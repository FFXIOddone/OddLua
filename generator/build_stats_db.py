from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parent
PROJECT_ROOT = ODDLUA_ROOT.parent
DEFAULT_SQL_ROOT = PROJECT_ROOT / "server" / "sql"
DEFAULT_SCRIPTS_ITEMS_ROOT = PROJECT_ROOT / "server" / "scripts" / "items"
DEFAULT_OUTPUT_PATH = ODDLUA_ROOT / "data" / "oddlua_stats.sqlite"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.statsdb import build_stats_db  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build the OddLua SQLite stats database from Catseye server sources."
    )
    parser.add_argument("--sql-root", default=DEFAULT_SQL_ROOT, type=Path)
    parser.add_argument("--scripts-items-root", default=DEFAULT_SCRIPTS_ITEMS_ROOT, type=Path)
    parser.add_argument("--output-path", default=DEFAULT_OUTPUT_PATH, type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = build_stats_db(
        sql_root=args.sql_root,
        scripts_items_root=args.scripts_items_root,
        output_path=args.output_path,
    )
    print(f"Wrote {result.path}")
    print(
        "Imported "
        f"{result.item_count} items, "
        f"{result.item_mod_count} item mods, "
        f"{result.food_count} foods, "
        f"{result.food_mod_count} food mods, "
        f"{result.mob_resistance_count} mob resist profiles, "
        f"{result.mob_pool_count} mob pools, "
        f"{result.mob_group_count} mob groups."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
