from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_ROOT = ODDLUA_ROOT / "reports" / "catseye-subjob-capabilities"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.catseye_subjob_capability_audit import audit_catseye_subjob_capabilities  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit Catseye-specific subjob capability overrides used by OddLua."
    )
    parser.add_argument("--output-root", default=DEFAULT_OUTPUT_ROOT, type=Path)
    parser.add_argument("--no-write", action="store_true")
    parser.add_argument("--fail-on-issues", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = audit_catseye_subjob_capabilities(
        output_root=args.output_root,
        write_files=not args.no_write,
    )
    summary = result["summary"]
    print(
        "Catseye subjob capability audit: checkedPairs={checked}; issues={issues}".format(
            checked=summary["checkedPairs"],
            issues=summary["issues"],
        )
    )
    if "outputDir" in result:
        print(f"Wrote audit: {result['outputDir']}")
    if args.fail_on_issues and int(summary["issues"]) > 0:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
