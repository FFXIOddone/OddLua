from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import shutil
import sys
from typing import Iterable


ODDLUA_ROOT = Path(__file__).resolve().parent
DEFAULT_GEAREXPORT_ROOT = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport"
)
DEFAULT_LUASHITACAST_ROOT = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\luashitacast"
)
DEFAULT_OUTPUT_ROOT = ODDLUA_ROOT / "dist"
DEFAULT_BACKUP_ROOT = ODDLUA_ROOT / "backups" / "luashitacast"
DEFAULT_REPORT_ROOT = ODDLUA_ROOT / "reports" / "apply"
DEFAULT_RUNTIME_ROOT = ODDLUA_ROOT / "runtime"
COMMON_RUNTIME_ASSETS = (
    Path("luashitacast/common/conditionals.lua"),
)

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.app.build_pack import build_pack  # noqa: E402
from oddlua.contracts import SUPPORTED_JOBS  # noqa: E402
from oddlua.gearexport import load_character_snapshot  # noqa: E402


@dataclass(frozen=True)
class CharacterSource:
    player: str
    player_id: str
    gear_path: Path
    character_path: Path

    @property
    def install_dir_name(self) -> str:
        return f"{self.player}_{self.player_id}"


def discover_character_sources(gearexport_root: Path | str = DEFAULT_GEAREXPORT_ROOT) -> tuple[CharacterSource, ...]:
    root = Path(gearexport_root)
    if not root.exists():
        raise FileNotFoundError(f"Catseye gearexport root not found: {root}")

    sources: list[CharacterSource] = []
    for character_path in sorted(root.glob("*_*/*_*_character.json")):
        stem = character_path.stem
        suffix = "_character"
        if not stem.endswith(suffix):
            continue
        player_token = stem[: -len(suffix)]
        player, player_id = _split_player_token(player_token)
        if not player or not player_id:
            continue
        gear_path = root / f"{player}_{player_id}_gear.lua"
        if gear_path.exists():
            sources.append(
                CharacterSource(
                    player=player,
                    player_id=player_id,
                    gear_path=gear_path,
                    character_path=character_path,
                )
            )
    return tuple(sources)


def apply_all_jobs(
    *,
    characters: Iterable[CharacterSource],
    luashitacast_root: Path | str,
    output_root: Path | str,
    backup_root: Path | str,
    report_root: Path | str,
    stats_db_path: Path | str | None = None,
    target_name: str | None = None,
    dry_run: bool = False,
    timestamp: str | None = None,
) -> dict[str, object]:
    timestamp = timestamp or _timestamp()
    luashitacast_root = Path(luashitacast_root)
    output_root = Path(output_root)
    backup_root = Path(backup_root)
    report_root = Path(report_root)
    stats_db_path = Path(stats_db_path) if stats_db_path else None
    report_path = report_root / f"oddlua-apply-all-jobs-{timestamp}.json"
    backup_batch_root = backup_root / timestamp

    report: dict[str, object] = {
        "timestamp": timestamp,
        "dryRun": dry_run,
        "luashitacastRoot": str(luashitacast_root),
        "outputRoot": str(output_root),
        "backupRoot": str(backup_batch_root),
        "reportPath": str(report_path),
        "statsDbPath": str(stats_db_path) if stats_db_path else "",
        "targetName": target_name or "",
        "characters": [],
        "summary": {
            "characters": 0,
            "eligibleJobs": 0,
            "skippedJobs": 0,
            "builtJobs": 0,
            "installedTargets": 0,
            "wouldInstallTargets": 0,
            "backedUpTargets": 0,
            "installedCommonAssets": 0,
            "wouldInstallCommonAssets": 0,
            "backedUpCommonAssets": 0,
            "mechanicsPlannerLoadedJobs": 0,
            "mechanicsPlannerTransitions": 0,
            "mechanicsPlannerSkippedTransitions": 0,
            "mechanicsPlannerWarnings": 0,
            "mechanicsPlannerActions": 0,
            "mechanicsPlannerVersions": {},
            "mechanicsPlannerWarningTypes": {},
            "mechanicsPlannerSkippedReasons": {},
        },
        "commonRuntimeAssets": [],
    }
    summary = report["summary"]
    assert isinstance(summary, dict)

    for source in tuple(characters):
        character_report = _apply_character(
            source=source,
            luashitacast_root=luashitacast_root,
            output_root=output_root,
            backup_batch_root=backup_batch_root,
            stats_db_path=stats_db_path,
            target_name=target_name,
            dry_run=dry_run,
        )
        report["characters"].append(character_report)  # type: ignore[union-attr]
        summary["characters"] += 1
        summary["eligibleJobs"] += character_report["summary"]["eligibleJobs"]
        summary["skippedJobs"] += character_report["summary"]["skippedJobs"]
        summary["builtJobs"] += character_report["summary"]["builtJobs"]
        summary["installedTargets"] += character_report["summary"]["installedTargets"]
        summary["wouldInstallTargets"] += character_report["summary"]["wouldInstallTargets"]
        summary["backedUpTargets"] += character_report["summary"]["backedUpTargets"]
        summary["mechanicsPlannerLoadedJobs"] += character_report["summary"]["mechanicsPlannerLoadedJobs"]
        summary["mechanicsPlannerTransitions"] += character_report["summary"]["mechanicsPlannerTransitions"]
        summary["mechanicsPlannerSkippedTransitions"] += character_report["summary"]["mechanicsPlannerSkippedTransitions"]
        summary["mechanicsPlannerWarnings"] += character_report["summary"]["mechanicsPlannerWarnings"]
        summary["mechanicsPlannerActions"] += character_report["summary"]["mechanicsPlannerActions"]
        _merge_summary_count_map(
            summary,
            "mechanicsPlannerVersions",
            character_report["summary"].get("mechanicsPlannerVersions"),
        )
        _merge_summary_count_map(
            summary,
            "mechanicsPlannerWarningTypes",
            character_report["summary"].get("mechanicsPlannerWarningTypes"),
        )
        _merge_summary_count_map(
            summary,
            "mechanicsPlannerSkippedReasons",
            character_report["summary"].get("mechanicsPlannerSkippedReasons"),
        )

    common_reports = _apply_common_runtime_assets(
        luashitacast_root=luashitacast_root,
        backup_batch_root=backup_batch_root,
        dry_run=dry_run,
    )
    report["commonRuntimeAssets"] = common_reports
    if dry_run:
        summary["wouldInstallCommonAssets"] += len(common_reports)
    else:
        summary["installedCommonAssets"] += len(common_reports)
        summary["backedUpCommonAssets"] += sum(1 for item in common_reports if item.get("backupPath"))

    report_root.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True), encoding="utf-8")
    return report


def _apply_common_runtime_assets(
    *,
    luashitacast_root: Path | str,
    backup_batch_root: Path | str,
    runtime_root: Path | str = DEFAULT_RUNTIME_ROOT,
    dry_run: bool,
) -> list[dict[str, object]]:
    luashitacast_root = Path(luashitacast_root)
    backup_batch_root = Path(backup_batch_root)
    runtime_root = Path(runtime_root)

    reports: list[dict[str, object]] = []
    for source_relative_path in COMMON_RUNTIME_ASSETS:
        source_path = runtime_root / source_relative_path
        if not source_path.exists():
            raise FileNotFoundError(f"OddLua runtime asset not found: {source_path}")

        target_relative_path = source_relative_path.relative_to("luashitacast")
        reports.append(
            _apply_target(
                source_path=source_path,
                target_path=luashitacast_root / target_relative_path,
                luashitacast_root=luashitacast_root,
                backup_batch_root=backup_batch_root,
                dry_run=dry_run,
            )
        )
    return reports


def _apply_character(
    *,
    source: CharacterSource,
    luashitacast_root: Path,
    output_root: Path,
    backup_batch_root: Path,
    stats_db_path: Path | None,
    target_name: str | None,
    dry_run: bool,
) -> dict[str, object]:
    snapshot = load_character_snapshot(source.character_path)
    character_report: dict[str, object] = {
        "player": source.player,
        "playerId": source.player_id,
        "gearPath": str(source.gear_path),
        "characterPath": str(source.character_path),
        "currentJob": snapshot.current_job,
        "jobs": [],
        "summary": {
            "eligibleJobs": 0,
            "skippedJobs": 0,
            "builtJobs": 0,
            "installedTargets": 0,
            "wouldInstallTargets": 0,
            "backedUpTargets": 0,
            "mechanicsPlannerLoadedJobs": 0,
            "mechanicsPlannerTransitions": 0,
            "mechanicsPlannerSkippedTransitions": 0,
            "mechanicsPlannerWarnings": 0,
            "mechanicsPlannerActions": 0,
            "mechanicsPlannerVersions": {},
            "mechanicsPlannerWarningTypes": {},
            "mechanicsPlannerSkippedReasons": {},
        },
    }
    summary = character_report["summary"]
    assert isinstance(summary, dict)

    for job in SUPPORTED_JOBS:
        level = snapshot.job_level(job)
        if level <= 0:
            character_report["jobs"].append(  # type: ignore[union-attr]
                {
                    "job": job,
                    "level": level,
                    "action": "skipped",
                    "reason": "level_zero",
                }
            )
            summary["skippedJobs"] += 1
            continue

        summary["eligibleJobs"] += 1
        result = build_pack(
            player=source.player,
            player_id=source.player_id,
            job=job,
            gear_path=source.gear_path,
            character_path=source.character_path,
            output_root=output_root,
            stats_db_path=stats_db_path,
            target_name=target_name,
        )
        summary["builtJobs"] += 1

        targets = tuple(_target_paths(luashitacast_root, source, job))
        target_reports = []
        for target in targets:
            target_report = _apply_target(
                source_path=result.profile_path,
                target_path=target,
                luashitacast_root=luashitacast_root,
                backup_batch_root=backup_batch_root,
                dry_run=dry_run,
            )
            target_reports.append(target_report)
            if dry_run:
                summary["wouldInstallTargets"] += 1
            else:
                summary["installedTargets"] += 1
                if target_report["backupPath"]:
                    summary["backedUpTargets"] += 1

        mechanics_planner = _mechanics_planner_report(result.manifest)
        _add_mechanics_planner_summary(summary, mechanics_planner)
        character_report["jobs"].append(  # type: ignore[union-attr]
            {
                "job": job,
                "level": level,
                "action": "would_install" if dry_run else "installed",
                "profilePath": str(result.profile_path),
                "manifestPath": str(result.manifest_path),
                "keybindingsPath": str(result.keybindings_path),
                "defaultPlaystyle": result.manifest["defaultPlaystyle"],
                "playstyles": result.manifest["playstyles"],
                "mechanicsPlanner": mechanics_planner,
                "targets": target_reports,
            }
        )

    return character_report


def _add_mechanics_planner_summary(summary: dict[str, object], planner_report: dict[str, object]) -> None:
    if planner_report.get("loaded") is not True:
        return
    summary["mechanicsPlannerLoadedJobs"] = int(summary.get("mechanicsPlannerLoadedJobs", 0)) + 1
    summary["mechanicsPlannerTransitions"] = int(summary.get("mechanicsPlannerTransitions", 0)) + int(
        planner_report.get("transitionCount", 0)
    )
    summary["mechanicsPlannerSkippedTransitions"] = int(
        summary.get("mechanicsPlannerSkippedTransitions", 0)
    ) + int(planner_report.get("skippedTransitionCount", 0))
    summary["mechanicsPlannerWarnings"] = int(summary.get("mechanicsPlannerWarnings", 0)) + int(
        planner_report.get("warningCount", 0)
    )
    summary["mechanicsPlannerActions"] = int(summary.get("mechanicsPlannerActions", 0)) + int(
        planner_report.get("actionCount", 0)
    )
    _merge_summary_count_map(
        summary,
        "mechanicsPlannerVersions",
        {str(_int_value(planner_report.get("plannerVersion"))): 1},
    )
    _merge_summary_count_map(summary, "mechanicsPlannerWarningTypes", planner_report.get("warningTypes"))
    _merge_summary_count_map(summary, "mechanicsPlannerSkippedReasons", planner_report.get("skippedReasons"))


def _merge_summary_count_map(summary: dict[str, object], key: str, values: object) -> None:
    target = summary.get(key)
    if not isinstance(target, dict):
        target = {}
        summary[key] = target
    if not isinstance(values, dict):
        return
    for name, count in values.items():
        target[str(name)] = int(target.get(str(name), 0)) + int(count)


def _mechanics_planner_report(manifest: dict[str, object]) -> dict[str, object]:
    planner = manifest.get("mechanicsSwapPlanner")
    if not isinstance(planner, dict):
        return {
            "loaded": False,
            "plannerVersion": 0,
            "baselineSet": "",
            "transitionCount": 0,
            "skippedTransitionCount": 0,
            "actionCount": 0,
            "warningCount": 0,
            "poolBridgeActionCount": 0,
            "negativeTickActionCount": 0,
            "warningTypes": {},
            "skippedReasons": {},
        }

    transitions = planner.get("transitions")
    if not isinstance(transitions, dict):
        transitions = {}
    skipped_transitions = planner.get("skippedTransitions")
    if not isinstance(skipped_transitions, dict):
        skipped_transitions = {}

    action_count = 0
    warning_count = 0
    warning_types: Counter[str] = Counter()
    pool_bridge_action_count = 0
    negative_tick_action_count = 0
    skipped_reasons = Counter(str(reason) for reason in skipped_transitions.values())
    for transition in transitions.values():
        if not isinstance(transition, dict):
            continue
        warnings = transition.get("warnings")
        if isinstance(warnings, list):
            warning_count += len(warnings)
            for warning in warnings:
                warning_types[str(warning)] += 1
        actions = transition.get("actions")
        if not isinstance(actions, list):
            continue
        action_count += len(actions)
        for action in actions:
            if not isinstance(action, dict):
                continue
            key = str(action.get("key", ""))
            if key == "pool_bridge_transition":
                pool_bridge_action_count += 1
            elif key == "negative_tick_avoidance":
                negative_tick_action_count += 1

    return {
        "loaded": planner.get("loaded") is True,
        "plannerVersion": _int_value(planner.get("plannerVersion")),
        "baselineSet": str(planner.get("baselineSet", "")),
        "transitionCount": len(transitions),
        "skippedTransitionCount": len(skipped_transitions),
        "actionCount": action_count,
        "warningCount": warning_count,
        "poolBridgeActionCount": pool_bridge_action_count,
        "negativeTickActionCount": negative_tick_action_count,
        "warningTypes": dict(warning_types),
        "skippedReasons": dict(skipped_reasons),
    }


def _int_value(value: object) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return 0


def _apply_target(
    *,
    source_path: Path,
    target_path: Path,
    luashitacast_root: Path,
    backup_batch_root: Path,
    dry_run: bool,
) -> dict[str, object]:
    _assert_inside_root(luashitacast_root, target_path)
    relative_path = _relative_to_root(luashitacast_root, target_path)
    existed = target_path.exists()
    before_sha = _sha256(target_path) if existed else ""
    source_sha = _sha256(source_path)
    backup_path: Path | None = None

    if not dry_run:
        target_path.parent.mkdir(parents=True, exist_ok=True)
        if existed:
            backup_path = backup_batch_root / relative_path
            backup_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(target_path, backup_path)
        shutil.copy2(source_path, target_path)

    return {
        "path": str(target_path),
        "relativePath": str(relative_path),
        "action": "would_update" if dry_run and existed else "would_create" if dry_run else "updated" if existed else "created",
        "existed": existed,
        "backupPath": str(backup_path) if backup_path else "",
        "sha256Before": before_sha,
        "sha256Source": source_sha,
        "sha256After": source_sha if dry_run else _sha256(target_path),
    }


def _target_paths(
    luashitacast_root: Path,
    source: CharacterSource,
    job: str,
) -> tuple[Path, Path]:
    return (
        luashitacast_root / source.install_dir_name / f"{job}.lua",
        luashitacast_root / f"{source.player}_{job}.lua",
    )


def _split_player_token(value: str) -> tuple[str, str]:
    parts = value.rsplit("_", 1)
    if len(parts) != 2:
        return "", ""
    return parts[0], parts[1]


def _assert_inside_root(root: Path, path: Path) -> None:
    _relative_to_root(root, path)


def _relative_to_root(root: Path, path: Path) -> Path:
    root_resolved = root.resolve(strict=False)
    path_resolved = path.resolve(strict=False)
    try:
        return path_resolved.relative_to(root_resolved)
    except ValueError as exc:
        raise ValueError(f"Target path is outside LuAshitacast root: {path}") from exc


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build and apply OddLua profiles for every positive-level job in Catseye snapshots."
    )
    parser.add_argument("--gearexport-root", default=DEFAULT_GEAREXPORT_ROOT, type=Path)
    parser.add_argument("--luashitacast-root", default=DEFAULT_LUASHITACAST_ROOT, type=Path)
    parser.add_argument("--output-root", default=DEFAULT_OUTPUT_ROOT, type=Path)
    parser.add_argument("--backup-root", default=DEFAULT_BACKUP_ROOT, type=Path)
    parser.add_argument("--report-root", default=DEFAULT_REPORT_ROOT, type=Path)
    parser.add_argument("--stats-db-path", default=ODDLUA_ROOT / "data" / "oddlua_stats.sqlite", type=Path)
    parser.add_argument("--target-name", default=None)
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    characters = discover_character_sources(args.gearexport_root)
    if not characters:
        raise FileNotFoundError(f"No Catseye character snapshots with matching gear exports found under {args.gearexport_root}")

    report = apply_all_jobs(
        characters=characters,
        luashitacast_root=args.luashitacast_root,
        output_root=args.output_root,
        backup_root=args.backup_root,
        report_root=args.report_root,
        stats_db_path=args.stats_db_path if args.stats_db_path.exists() else None,
        target_name=args.target_name,
        dry_run=args.dry_run,
    )
    summary = report["summary"]
    assert isinstance(summary, dict)
    print(f"Wrote report: {report['reportPath']}")
    print(
        "Characters: {characters}; built jobs: {built}; installed targets: {installed}; "
        "would install: {would}; backups: {backups}".format(
            characters=summary["characters"],
            built=summary["builtJobs"],
            installed=summary["installedTargets"],
            would=summary["wouldInstallTargets"],
            backups=summary["backedUpTargets"],
        )
    )
    print(_format_mechanics_summary(summary))
    return 0


def _format_mechanics_summary(summary: dict[str, object]) -> str:
    version_text = _format_count_map(summary.get("mechanicsPlannerVersions"))
    warning_text = _format_count_map(summary.get("mechanicsPlannerWarningTypes"))
    skipped_text = _format_count_map(summary.get("mechanicsPlannerSkippedReasons"))
    return (
        "Mechanics planner: loaded jobs {loaded}; transitions {transitions}; skipped {skipped}; "
        "warnings {warnings}; versions {versions}; warning types {warning_types}; skipped reasons {skipped_reasons}"
    ).format(
        loaded=summary.get("mechanicsPlannerLoadedJobs", 0),
        transitions=summary.get("mechanicsPlannerTransitions", 0),
        skipped=summary.get("mechanicsPlannerSkippedTransitions", 0),
        warnings=summary.get("mechanicsPlannerWarnings", 0),
        versions=version_text,
        warning_types=warning_text,
        skipped_reasons=skipped_text,
    )


def _format_count_map(value: object) -> str:
    if not isinstance(value, dict) or not value:
        return "none"
    return ", ".join(
        f"{name}={value[name]}"
        for name in sorted(value)
    )


if __name__ == "__main__":
    raise SystemExit(main())
