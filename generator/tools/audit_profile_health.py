from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import sys
import tempfile
from typing import Callable

from check_lua_syntax import _compile_with_luajit, _resolve_luajit


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DIST_ROOT = ODDLUA_ROOT / "dist" / "packs"
DEFAULT_INSTALL_ROOT = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\luashitacast"
)
DEFAULT_REPORT_ROOT = ODDLUA_ROOT / "reports" / "live-reconciliation"
WEAPON_SLOTS = ("Main", "Sub", "Range", "Ammo")
DESTRUCTIVE_ACTION_INTENTS = {"JobAbility", "Weaponskill"}

SyntaxCompiler = Callable[[Path, Path], tuple[int, str]]


def audit_profile_health(
    *,
    player_slug: str,
    job: str,
    dist_root: Path | str = DEFAULT_DIST_ROOT,
    install_root: Path | str = DEFAULT_INSTALL_ROOT,
    installed_profile: Path | str | None = None,
    report_root: Path | str = DEFAULT_REPORT_ROOT,
    luajit_path: Path | str | None = None,
    syntax_compiler: SyntaxCompiler | None = None,
) -> dict[str, object]:
    job = job.upper()
    generated_path = Path(dist_root) / player_slug / job / f"{job}.lua"
    installed_path = Path(installed_profile) if installed_profile else Path(install_root) / player_slug / f"{job}.lua"
    manifest_path = generated_path.with_name("manifest.json")

    generated_info = _file_info(generated_path)
    installed_info = _file_info(installed_path)
    manifest_info = _file_info(manifest_path)
    failures: list[str] = []
    warnings: list[str] = []

    if not generated_info["exists"]:
        failures.append("generated profile missing")
    if not installed_info["exists"]:
        failures.append("installed profile missing")
    if not manifest_info["exists"]:
        failures.append("manifest missing")

    hash_parity = None
    if generated_info["exists"] and installed_info["exists"]:
        hash_parity = generated_info["sha256"] == installed_info["sha256"]
        if not hash_parity:
            failures.append("generated and installed profile hashes differ")

    lua_syntax = _syntax_report(
        (generated_path, installed_path),
        luajit_path=luajit_path,
        compiler=syntax_compiler,
    )
    if lua_syntax["failed"]:
        failures.append("LuaJIT syntax check failed")

    selected_set_names = _manifest_selected_set_names(manifest_path)
    weapon_removal_findings: list[dict[str, object]] = []
    if generated_path.exists():
        weapon_removal_findings = destructive_weapon_removal_findings(
            generated_path.read_text(encoding="utf-8"),
            selected_set_names=selected_set_names,
        )
        if weapon_removal_findings:
            failures.append("destructive action set weapon removal found")

    live_reconciliation = _latest_reconciliation_summary(
        report_root=Path(report_root),
        player_slug=player_slug,
        job=job,
    )
    if not live_reconciliation["latestReport"]:
        warnings.append("no live reconciliation report found")

    return {
        "playerSlug": player_slug,
        "job": job,
        "generatedProfile": generated_info,
        "installedProfile": installed_info,
        "manifest": manifest_info,
        "hashParity": hash_parity,
        "luaSyntax": lua_syntax,
        "weaponRemovalFindings": weapon_removal_findings,
        "liveReconciliation": live_reconciliation,
        "failures": failures,
        "warnings": warnings,
        "exitCode": 1 if failures else 0,
    }


def destructive_weapon_removal_findings(
    lua_text: str,
    *,
    selected_set_names: set[str] | None = None,
) -> list[dict[str, object]]:
    sets = _parse_generated_sets(lua_text)
    intents = _parse_set_intents(lua_text)
    findings: list[dict[str, object]] = []
    for set_name, slots in sets.items():
        if selected_set_names is not None and set_name not in selected_set_names:
            continue
        removed_slots = sorted(
            slot for slot, value in slots.items() if slot in WEAPON_SLOTS and value.lower() == "remove"
        )
        if not removed_slots:
            continue
        intent = intents.get(set_name, "")
        if intent not in DESTRUCTIVE_ACTION_INTENTS:
            continue
        findings.append(
            {
                "setName": set_name,
                "intent": intent,
                "slots": removed_slots,
            }
        )
    return findings


def _manifest_selected_set_names(path: Path) -> set[str] | None:
    if not path.exists():
        return None
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return None
    selected_items = data.get("selectedItems")
    if not isinstance(selected_items, dict):
        return None
    return {str(name) for name in selected_items}


def _parse_generated_sets(lua_text: str) -> dict[str, dict[str, str]]:
    sets: dict[str, dict[str, str]] = {}
    for match in re.finditer(
        r"^    (?P<name>[A-Za-z0-9_]+)\s*=\s*\{\n(?P<body>.*?)(?=^    \},)",
        lua_text,
        re.MULTILINE | re.DOTALL,
    ):
        body = match.group("body")
        slots = {
            slot: value
            for slot, value in re.findall(
                r"^\s+([A-Za-z0-9_]+)\s*=\s*'((?:\\'|[^'])*)'",
                body,
                re.MULTILINE,
            )
        }
        sets[match.group("name")] = slots
    return sets


def _parse_set_intents(lua_text: str) -> dict[str, str]:
    match = re.search(r"^local setIntents = \{\n(?P<body>.*?)^\}", lua_text, re.MULTILINE | re.DOTALL)
    if not match:
        return {}
    return {
        name: intent
        for name, intent in re.findall(
            r"^\s+([A-Za-z0-9_]+)\s*=\s*'([^']*)'",
            match.group("body"),
            re.MULTILINE,
        )
    }


def _file_info(path: Path) -> dict[str, object]:
    exists = path.exists()
    return {
        "path": str(path),
        "exists": exists,
        "sha256": _sha256(path) if exists and path.is_file() else None,
    }


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest().upper()


def _syntax_report(
    paths: tuple[Path, ...],
    *,
    luajit_path: Path | str | None,
    compiler: SyntaxCompiler | None,
) -> dict[str, object]:
    existing_paths = tuple(dict.fromkeys(path for path in paths if path.exists()))
    if compiler is None:
        try:
            compiler = _compile_with_luajit(_resolve_luajit(luajit_path))
        except FileNotFoundError as exc:
            return {
                "checked": 0,
                "passed": 0,
                "failed": len(existing_paths) or 1,
                "failures": [{"path": "", "error": str(exc)}],
            }
    failures: list[dict[str, str]] = []
    with tempfile.TemporaryDirectory(prefix="oddlua-profile-health-") as temp_dir:
        output_path = Path(temp_dir) / "check.luac"
        for path in existing_paths:
            exit_code, output = compiler(path, output_path)
            if exit_code != 0:
                failures.append({"path": str(path), "error": output})
    return {
        "checked": len(existing_paths),
        "passed": len(existing_paths) - len(failures),
        "failed": len(failures),
        "failures": failures,
    }


def _latest_reconciliation_summary(
    *,
    report_root: Path,
    player_slug: str,
    job: str,
) -> dict[str, object]:
    reports = sorted(
        report_root.glob(f"{player_slug}-{job}*.md"),
        key=lambda path: (path.stat().st_mtime_ns, _reconciliation_snapshot_count(path), path.name),
        reverse=True,
    )
    if not reports:
        return {"latestReport": None, "summary": None}
    latest = reports[0]
    summary = _reconciliation_summary(latest)
    return {
        "latestReport": str(latest),
        "summary": summary,
    }


def _reconciliation_summary(path: Path) -> dict[str, int] | None:
    text = "\n".join(path.read_text(encoding="utf-8", errors="replace").splitlines()[0:3])
    match = re.search(
        r"Total snapshots:\s*(?P<snapshots>\d+);\s*matches\s*(?P<matches>\d+);\s*"
        r"mismatches\s*(?P<mismatches>\d+);\s*unknown\s*(?P<unknown>\d+)",
        text,
    )
    if not match:
        return None
    return {key: int(value) for key, value in match.groupdict().items()}


def _reconciliation_snapshot_count(path: Path) -> int:
    summary = _reconciliation_summary(path)
    if not summary:
        return -1
    return summary["snapshots"]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit one OddLua generated/installed LuAshitacast profile pair."
    )
    parser.add_argument("--player", "--player-slug", dest="player_slug", required=True)
    parser.add_argument("--job", required=True)
    parser.add_argument("--dist-root", default=DEFAULT_DIST_ROOT, type=Path)
    parser.add_argument("--install-root", default=DEFAULT_INSTALL_ROOT, type=Path)
    parser.add_argument("--installed-profile", default=None, type=Path)
    parser.add_argument("--report-root", default=DEFAULT_REPORT_ROOT, type=Path)
    parser.add_argument("--luajit", default=None, type=Path)
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_profile_health(
        player_slug=args.player_slug,
        job=args.job,
        dist_root=args.dist_root,
        install_root=args.install_root,
        installed_profile=args.installed_profile,
        report_root=args.report_root,
        luajit_path=args.luajit,
    )
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        status = "PASS" if report["exitCode"] == 0 else "FAIL"
        print(f"Profile health: {status} {report['playerSlug']} {report['job']}")
        print(f"Hash parity: {report['hashParity']}")
        print(
            "Lua syntax: checked={checked}; passed={passed}; failed={failed}".format(
                **report["luaSyntax"]
            )
        )
        for finding in report["weaponRemovalFindings"]:
            print(
                "Weapon removal: {setName} intent={intent} slots={slots}".format(
                    **finding
                )
            )
        for failure in report["failures"]:
            print(f"Failure: {failure}", file=sys.stderr)
        for warning in report["warnings"]:
            print(f"Warning: {warning}", file=sys.stderr)
    return int(report["exitCode"])


if __name__ == "__main__":
    raise SystemExit(main())
