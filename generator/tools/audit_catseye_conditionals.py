from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ODDLUA_ROOT.parent
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.catseye_conditionals_audit import audit_catseye_conditionals  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit Catseye equipment conditionals parsed into OddLua runtime helpers."
    )
    parser.add_argument(
        "--catseye-wiki-root",
        default=PROJECT_ROOT / "tools-data" / "catseye-wiki-cache",
        type=Path,
    )
    parser.add_argument(
        "--output-root",
        default=ODDLUA_ROOT / "reports" / "catseye-conditionals",
        type=Path,
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = audit_catseye_conditionals(
        catseye_wiki_root=args.catseye_wiki_root,
        output_root=args.output_root,
    )
    print(f"Wrote audit: {result.output_dir}")
    print(result.summary)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
