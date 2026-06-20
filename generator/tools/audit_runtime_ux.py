from __future__ import annotations

import argparse
import json
from pathlib import Path


ODDLUA_ROOT = Path(__file__).resolve().parents[1]

REQUIRED_PROFILE_MARKERS: tuple[tuple[str, str], ...] = (
    ("printOddLuaHelp", "local function printOddLuaHelp()"),
    ("printStyleList", "local function printStyleList()"),
    ("loadHelpHint", "Use /lac fwd help for commands and one-button setup."),
    ("statusHelpHint", "help=/lac fwd help; styles=/lac fwd styles"),
    ("unknownCommandRecovery", "Unknown command:"),
)


def audit_runtime_ux_root(root: Path | str) -> dict[str, object]:
    profile_root = Path(root)
    profile_paths = sorted(profile_root.glob("*/*/*.lua"))
    failures: list[dict[str, object]] = []

    if not profile_paths:
        failures.append({"path": str(profile_root), "missing": ["generatedProfiles"]})

    for profile_path in profile_paths:
        text = profile_path.read_text(encoding="utf-8")
        missing = [
            marker_name
            for marker_name, marker_text in REQUIRED_PROFILE_MARKERS
            if marker_text not in text
        ]
        if missing:
            failures.append({"path": str(profile_path), "missing": missing})

    return {
        "profileRoot": str(profile_root),
        "profileCount": len(profile_paths),
        "failureCount": len(failures),
        "failures": failures,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit generated profile runtime UX affordances.")
    parser.add_argument("--profile-root", default=ODDLUA_ROOT / "dist" / "packs", type=Path)
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_runtime_ux_root(args.profile_root)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(
            "Runtime UX audit: "
            f"profiles={report['profileCount']} "
            f"failures={report['failureCount']}"
        )
    return 1 if int(report["failureCount"]) else 0


if __name__ == "__main__":
    raise SystemExit(main())
