from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parent
PROJECT_ROOT = ODDLUA_ROOT.parent
DEFAULT_SQL_ROOT = PROJECT_ROOT / "server" / "sql"
DEFAULT_SCRIPTS_ITEMS_ROOT = PROJECT_ROOT / "server" / "scripts" / "items"
DEFAULT_CATSEYE_WIKI_ROOT = PROJECT_ROOT / "tools-data" / "catseye-wiki-cache"
DEFAULT_CLIENT_ITEMS_PATH = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport"
)
DEFAULT_OUTPUT_PATH = ODDLUA_ROOT / "data" / "oddlua_stats.sqlite"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.statsdb import build_stats_db  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build the OddLua SQLite stats database from Catseye server sources."
    )
    parser.add_argument("--sql-root", default=DEFAULT_SQL_ROOT, type=Path)
    parser.add_argument("--scripts-items-root", default=DEFAULT_SCRIPTS_ITEMS_ROOT, type=Path)
    parser.add_argument("--catseye-wiki-root", default=DEFAULT_CATSEYE_WIKI_ROOT, type=Path)
    parser.add_argument("--client-items-path", default=DEFAULT_CLIENT_ITEMS_PATH, type=Path)
    parser.add_argument("--output-path", default=DEFAULT_OUTPUT_PATH, type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    client_items_path = args.client_items_path if args.client_items_path.exists() else None
    result = build_stats_db(
        sql_root=args.sql_root,
        scripts_items_root=args.scripts_items_root,
        catseye_wiki_root=args.catseye_wiki_root,
        client_items_path=client_items_path,
        output_path=args.output_path,
    )
    print(f"Wrote {result.path}")
    print(
        "Imported "
        f"{result.item_count} items, "
        f"{result.item_mod_count} item mods, "
        f"{result.food_count} foods, "
        f"{result.food_mod_count} food mods, "
        f"{result.ability_count} abilities, "
        f"{result.spell_count} spells, "
        f"{result.status_effect_count} status effects, "
        f"{result.pet_item_mod_count} pet item mods, "
        f"{result.item_latent_count} item latents, "
        f"{result.catseye_equipment_override_count} Catseye equipment overrides, "
        f"{result.catseye_equipment_stat_override_count} Catseye equipment stat overrides, "
        f"{result.client_item_count} client item resources, "
        f"{result.client_equipment_update_count} client equipment updates, "
        f"{result.client_weapon_update_count} client weapon updates, "
        f"{result.mob_resistance_count} mob resist profiles, "
        f"{result.mob_pool_count} mob pools, "
        f"{result.mob_group_count} mob groups."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
