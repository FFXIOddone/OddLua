from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ODDLUA_ROOT.parent
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.catseye_skipped_effects_audit import audit_catseye_skipped_effects  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Report Catseye wiki equipment effect fragments not parsed into OddLua stats."
    )
    parser.add_argument(
        "--catseye-wiki-root",
        default=PROJECT_ROOT / "tools-data" / "catseye-wiki-cache",
        type=Path,
    )
    parser.add_argument(
        "--output-root",
        default=ODDLUA_ROOT / "reports" / "catseye-skipped-effects",
        type=Path,
    )
    parser.add_argument("--max-examples-per-group", default=5, type=int)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = audit_catseye_skipped_effects(
        catseye_wiki_root=args.catseye_wiki_root,
        output_root=args.output_root,
        max_examples_per_group=args.max_examples_per_group,
    )
    print(f"Wrote audit: {result.output_dir}")
    print(result.summary)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
