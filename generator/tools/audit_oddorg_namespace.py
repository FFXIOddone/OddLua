from __future__ import annotations

import argparse
import json
from pathlib import Path


ODDLUA_ROOT = Path(__file__).resolve().parents[1]


def audit_oddorg_namespace(root: Path | str = ODDLUA_ROOT) -> dict[str, object]:
    root_path = Path(root)
    oddlua_source_root = root_path / "src" / "oddlua"
    failures: list[dict[str, object]] = []
    forbidden_module_path = oddlua_source_root / "oddorg.py"

    if forbidden_module_path.exists():
        failures.append(
            {
                "path": str(forbidden_module_path),
                "reason": "forbiddenOddLuaModulePath",
            }
        )

    for source_path in sorted(oddlua_source_root.rglob("*.py")):
        if "__pycache__" in source_path.parts:
            continue
        text = source_path.read_text(encoding="utf-8")
        for line_number, line in enumerate(text.splitlines(), start=1):
            if "oddorg" in line.lower():
                failures.append(
                    {
                        "path": str(source_path),
                        "reason": "forbiddenOddOrgReference",
                        "line": line_number,
                        "text": line.strip(),
                    }
                )

    return {
        "root": str(root_path),
        "auditedSourceRoot": str(oddlua_source_root),
        "failureCount": len(failures),
        "failures": failures,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit that OddOrg is not carried inside OddLua internals.")
    parser.add_argument("--root", default=ODDLUA_ROOT, type=Path)
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_oddorg_namespace(args.root)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(f"OddOrg namespace audit: failures={report['failureCount']}")
        for failure in report["failures"]:
            path = failure["path"]
            reason = failure["reason"]
            line = failure.get("line")
            suffix = f":{line}" if line is not None else ""
            print(f"  {path}{suffix}: {reason}")
    return 1 if int(report["failureCount"]) else 0


if __name__ == "__main__":
    raise SystemExit(main())
