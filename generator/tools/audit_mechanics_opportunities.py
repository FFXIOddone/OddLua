from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.gearexport import load_gearexport  # noqa: E402
from oddlua.itemstats import load_item_stats_from_db  # noqa: E402
from oddlua.mechanics_opportunity_audit import audit_mechanics_opportunities  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit mechanics opportunities against a character gearexport."
    )
    parser.add_argument("--stats-db", default=ODDLUA_ROOT / "data" / "oddlua_stats.sqlite", type=Path)
    parser.add_argument("--gear", required=True, type=Path)
    parser.add_argument("--output-root", default=ODDLUA_ROOT / "reports" / "mechanics-opportunities", type=Path)
    parser.add_argument(
        "--include-empty",
        action="store_true",
        help="Include opportunity definitions with no current server evidence.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    item_stats = load_item_stats_from_db(args.stats_db)
    gear = load_gearexport(args.gear)
    result = audit_mechanics_opportunities(
        item_stats=item_stats,
        owned_items=gear.items,
        output_root=args.output_root,
        include_no_server_evidence=args.include_empty,
        write_files=True,
    )
    print(f"Wrote audit: {result.output_dir}")
    print(json.dumps(result.summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
