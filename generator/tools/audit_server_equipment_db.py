from __future__ import annotations

import argparse
from datetime import datetime
import json
from pathlib import Path
import re
import sqlite3
import subprocess
import sys
from typing import Any


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ODDLUA_ROOT.parent
DEFAULT_DB_PATH = ODDLUA_ROOT / "data" / "oddlua_stats.sqlite"
DEFAULT_SERVER_ROOT = PROJECT_ROOT / "server"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua import statsdb  # noqa: E402


COMPARE_FIELDS = (
    ("item.name", ("item", "name")),
    ("item.sort_name", ("item", "sort_name")),
    ("item.item_type", ("item", "item_type")),
    ("equipment.name", ("equipment", "name")),
    ("equipment.level", ("equipment", "level")),
    ("equipment.ilevel", ("equipment", "ilevel")),
    ("equipment.jobs", ("equipment", "jobs")),
    ("equipment.slot", ("equipment", "slot")),
    ("equipment.shield_size", ("equipment", "shield_size")),
    ("equipment.su_level", ("equipment", "su_level")),
    ("weapon.name", ("weapon", "name")),
    ("weapon.skill", ("weapon", "skill")),
    ("weapon.damage", ("weapon", "damage")),
    ("weapon.delay", ("weapon", "delay")),
    ("weapon.damage_type", ("weapon", "damage_type")),
)

NAME_FIELDS = {
    "item.name",
    "item.sort_name",
    "equipment.name",
    "weapon.name",
}

SERVER_ITEM_TYPE_LABELS = {
    "@GENERAL_TYPE": "Item",
    "@LINKSHELL_TYPE": "Item",
    "@FURNISHING_TYPE": "Item",
    "@PUPPET_TYPE": "Item",
    "@USABLE_TYPE": "Item",
    "@EQUIPMENT_TYPE": "Armor",
    "@WEAPON_TYPE": "Weapon",
    "@CURRENCY_TYPE": "Item",
    "1": "Item",
    "2": "Item",
    "3": "Item",
    "4": "Item",
    "5": "Item",
    "6": "Armor",
    "7": "Weapon",
    "8": "Item",
}

LABEL_NORMALIZE_RE = re.compile(r"[^a-z0-9]+")

CLIENT_FIELD_MAP = {
    "item.name": "name",
    "item.sort_name": "name",
    "equipment.name": "name",
    "equipment.level": "level",
    "equipment.ilevel": "ilevel",
    "equipment.jobs": "jobs",
    "equipment.slot": "slot",
    "equipment.shield_size": "shield_size",
    "equipment.su_level": "su_level",
    "weapon.name": "name",
    "weapon.skill": "skill",
    "weapon.damage": "damage",
    "weapon.delay": "delay",
    "weapon.damage_type": "damage_type",
}

EQUIPMENT_OVERRIDE_FIELD_MAP = {
    "equipment.level": "catseye_level",
    "equipment.ilevel": "catseye_ilevel",
    "equipment.jobs": "catseye_jobs",
    "equipment.slot": "catseye_slot",
}

STAT_OVERRIDE_FIELD_MAP = {
    "weapon.damage": "WEAPON_DAMAGE",
    "weapon.delay": "WEAPON_DELAY",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compare OddLua equipment DB rows against a CatseyeXI server source tree."
    )
    parser.add_argument("--db-path", default=DEFAULT_DB_PATH, type=Path)
    parser.add_argument("--server-root", default=DEFAULT_SERVER_ROOT, type=Path)
    parser.add_argument("--server-label", default=None)
    parser.add_argument("--output-dir", type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_server_equipment_db(
        db_path=args.db_path,
        server_root=args.server_root,
        server_label=args.server_label,
    )

    output_dir = args.output_dir
    if output_dir is None:
        output_dir = (
            ODDLUA_ROOT
            / "reports"
            / "verify"
            / f"server-equipment-db-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
        )
    output_dir.mkdir(parents=True, exist_ok=True)

    json_path = output_dir / "server_equipment_db_reconciliation.json"
    md_path = output_dir / "server_equipment_db_reconciliation.md"
    json_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    md_path.write_text(render_markdown(report), encoding="utf-8")

    print(f"Wrote {json_path}")
    print(f"Wrote {md_path}")
    return 0


def audit_server_equipment_db(
    *,
    db_path: Path,
    server_root: Path,
    server_label: str | None = None,
) -> dict[str, Any]:
    server_catalog = _load_server_catalog(server_root)
    db_catalog = _load_db_catalog(db_path)
    server_ids = set(server_catalog)
    db_ids = set(db_catalog["items"]) & set(db_catalog["equipment"])

    exact_matches: list[dict[str, Any]] = []
    covered_client_differences: list[dict[str, Any]] = []
    covered_equipment_override_differences: list[dict[str, Any]] = []
    unexpected_differences: list[dict[str, Any]] = []
    missing_server_equipment: list[dict[str, Any]] = []
    db_only_equipment: list[dict[str, Any]] = []

    for item_id in sorted(server_ids):
        server_row = server_catalog[item_id]
        db_row = _catalog_row(db_catalog, item_id)
        if db_row is None:
            missing_server_equipment.append(_server_summary(server_row))
            continue

        differences = _field_differences(server_row, db_row, db_catalog)
        if not differences:
            exact_matches.append(_server_summary(server_row) | {"db_name": db_row["item"]["name"]})
            continue

        covered_reasons = [
            _covered_reason(diff, db_catalog, item_id)
            for diff in differences
        ]
        row = _server_summary(server_row) | {
            "db_name": db_row["item"]["name"],
            "field_differences": differences,
        }
        if covered_reasons and all(reason == "catseye_client_items" for reason in covered_reasons):
            covered_client_differences.append(row | {"covered_by": "catseye_client_items"})
        elif covered_reasons and all(reason is not None for reason in covered_reasons):
            covered_equipment_override_differences.append(
                row | {"covered_by": sorted(set(str(reason) for reason in covered_reasons))}
            )
        else:
            unexpected_differences.append(row)

    for item_id in sorted(db_ids - server_ids):
        db_row = _catalog_row(db_catalog, item_id)
        if db_row is None:
            continue
        client_item = db_catalog["client_items"].get(item_id)
        db_only_equipment.append(
            {
                "item_id": item_id,
                "db_name": db_row["item"]["name"],
                "equipment_name": db_row["equipment"]["name"],
                "level": db_row["equipment"]["level"],
                "slot": db_row["equipment"]["slot"],
                "present_in_catseye_client_items": client_item is not None,
            }
        )

    summary = {
        "server_equipment_items": len(server_ids),
        "oddlua_equipment_items": len(db_ids),
        "exact_matches": len(exact_matches),
        "covered_client_resource_differences": len(covered_client_differences),
        "covered_equipment_override_differences": len(covered_equipment_override_differences),
        "unexpected_differences": len(unexpected_differences),
        "missing_server_equipment_in_db": len(missing_server_equipment),
        "db_only_equipment": len(db_only_equipment),
        "db_only_client_resource_equipment": sum(
            1 for row in db_only_equipment if row["present_in_catseye_client_items"]
        ),
        "db_only_uncovered_equipment": sum(
            1 for row in db_only_equipment if not row["present_in_catseye_client_items"]
        ),
    }

    return {
        "sources": {
            "db_path": str(db_path),
            "server_root": str(server_root),
            "server_label": server_label or _git_label(server_root),
            "server_sql_root": str(Path(server_root) / "sql"),
        },
        "summary": summary,
        "missing_server_equipment_in_db": missing_server_equipment,
        "unexpected_differences": unexpected_differences,
        "covered_client_resource_differences": covered_client_differences,
        "covered_equipment_override_differences": covered_equipment_override_differences,
        "db_only_equipment": db_only_equipment,
    }


def _load_server_catalog(server_root: Path) -> dict[int, dict[str, Any]]:
    sql_root = Path(server_root) / "sql"
    if not sql_root.exists():
        raise FileNotFoundError(f"Server SQL root not found: {sql_root}")

    items = _read_item_basic(sql_root / "item_basic.sql")
    equipment = _read_item_equipment(sql_root / "item_equipment.sql")
    weapons = _read_item_weapon(sql_root / "item_weapon.sql")
    catalog: dict[int, dict[str, Any]] = {}
    for item_id, equipment_row in equipment.items():
        catalog[item_id] = {
            "item_id": item_id,
            "item": items.get(item_id, {"name": "", "sort_name": "", "item_type": ""}),
            "equipment": equipment_row,
            "weapon": weapons.get(item_id),
        }
    return catalog


def _load_db_catalog(db_path: Path) -> dict[str, Any]:
    db = sqlite3.connect(db_path)
    db.row_factory = sqlite3.Row
    try:
        items = {
            int(row["item_id"]): {
                "name": str(row["name"]),
                "sort_name": str(row["sort_name"]),
                "item_type": str(row["item_type"]),
            }
            for row in db.execute("select item_id, name, sort_name, item_type from items")
        }
        equipment = {
            int(row["item_id"]): {
                "name": str(row["name"]),
                "level": int(row["level"]),
                "ilevel": int(row["ilevel"]),
                "jobs": int(row["jobs"]),
                "slot": int(row["slot"]),
                "shield_size": int(row["shield_size"]),
                "su_level": int(row["su_level"]),
            }
            for row in db.execute(
                """
                select item_id, name, level, ilevel, jobs, slot, shield_size, su_level
                from item_equipment
                """
            )
        }
        weapons = {
            int(row["item_id"]): {
                "name": str(row["name"]),
                "skill": int(row["skill"]),
                "damage": int(row["damage"]),
                "delay": int(row["delay"]),
                "damage_type": int(row["damage_type"]),
            }
            for row in db.execute("select item_id, name, skill, damage, delay, damage_type from item_weapon")
        }
        client_items = _optional_table_rows(
            db,
            "catseye_client_items",
            """
            select item_id, name, level, ilevel, jobs, slot, shield_size, su_level,
                   skill, damage, delay, damage_type
            from catseye_client_items
            """,
        )
        equipment_overrides = _optional_table_rows(
            db,
            "catseye_equipment_overrides",
            """
            select item_id, catseye_level, catseye_ilevel, catseye_jobs, catseye_slot
            from catseye_equipment_overrides
            """,
        )
        stat_overrides = _optional_stat_override_rows(db)
        aliases = _optional_alias_rows(db)
    finally:
        db.close()

    return {
        "items": items,
        "equipment": equipment,
        "weapons": weapons,
        "client_items": client_items,
        "equipment_overrides": equipment_overrides,
        "stat_overrides": stat_overrides,
        "aliases": aliases,
    }


def _optional_table_rows(db: sqlite3.Connection, table: str, query: str) -> dict[int, dict[str, Any]]:
    if not _has_table(db, table):
        return {}
    rows: dict[int, dict[str, Any]] = {}
    for row in db.execute(query):
        item_id = int(row["item_id"])
        rows[item_id] = {
            key: (int(row[key]) if isinstance(row[key], int) else None if row[key] is None else str(row[key]))
            for key in row.keys()
            if key != "item_id"
        }
    return rows


def _optional_stat_override_rows(db: sqlite3.Connection) -> dict[int, list[dict[str, Any]]]:
    if not _has_table(db, "catseye_equipment_stat_overrides"):
        return {}

    rows: dict[int, list[dict[str, Any]]] = {}
    for row in db.execute(
        """
        select item_id, mod_name, original_value, catseye_value
        from catseye_equipment_stat_overrides
        """
    ):
        rows.setdefault(int(row["item_id"]), []).append(
            {
                "mod_name": str(row["mod_name"]),
                "original_value": None if row["original_value"] is None else int(row["original_value"]),
                "catseye_value": int(row["catseye_value"]),
            }
        )
    return rows


def _optional_alias_rows(db: sqlite3.Connection) -> dict[int, set[str]]:
    if not _has_table(db, "item_name_aliases"):
        return {}

    aliases: dict[int, set[str]] = {}
    for row in db.execute("select item_id, name from item_name_aliases"):
        aliases.setdefault(int(row["item_id"]), set()).add(str(row["name"]))
    return aliases


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    return db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone() is not None


def _catalog_row(catalog: dict[str, Any], item_id: int) -> dict[str, Any] | None:
    item = catalog["items"].get(item_id)
    equipment = catalog["equipment"].get(item_id)
    if item is None or equipment is None:
        return None
    return {
        "item_id": item_id,
        "item": item,
        "equipment": equipment,
        "weapon": catalog["weapons"].get(item_id),
    }


def _field_differences(
    server_row: dict[str, Any],
    db_row: dict[str, Any],
    db_catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    differences: list[dict[str, Any]] = []
    for field, path in COMPARE_FIELDS:
        server_value = _nested_value(server_row, path)
        db_value = _nested_value(db_row, path)
        if not _field_values_equivalent(
            field=field,
            item_id=int(server_row["item_id"]),
            server_value=server_value,
            db_value=db_value,
            db_catalog=db_catalog,
        ):
            differences.append({"field": field, "server": server_value, "db": db_value})
    return differences


def _field_values_equivalent(
    *,
    field: str,
    item_id: int,
    server_value: object,
    db_value: object,
    db_catalog: dict[str, Any],
) -> bool:
    if field in NAME_FIELDS:
        return _label_values_equivalent(item_id, server_value, db_value, db_catalog)
    if field == "item.item_type":
        return _canonical_item_type(server_value) == _canonical_item_type(db_value)
    return server_value == db_value


def _label_values_equivalent(
    item_id: int,
    server_value: object,
    db_value: object,
    db_catalog: dict[str, Any],
) -> bool:
    if server_value == db_value:
        return True

    server_text = "" if server_value is None else str(server_value)
    db_text = "" if db_value is None else str(db_value)
    if _normalize_label(server_text) == _normalize_label(db_text):
        return True

    aliases = db_catalog["aliases"].get(item_id, set())
    return any(_normalize_label(server_text) == _normalize_label(alias) for alias in aliases)


def _normalize_label(value: str) -> str:
    return LABEL_NORMALIZE_RE.sub("", value.lower())


def _canonical_item_type(value: object) -> str:
    text = "" if value is None else str(value)
    return SERVER_ITEM_TYPE_LABELS.get(text, text)


def _nested_value(row: dict[str, Any], path: tuple[str, str]) -> object:
    group, key = path
    group_value = row.get(group)
    if group_value is None:
        return None
    return group_value.get(key)


def _covered_reason(diff: dict[str, Any], db_catalog: dict[str, Any], item_id: int) -> str | None:
    field = str(diff["field"])
    db_value = diff["db"]
    client_item = db_catalog["client_items"].get(item_id)
    if (
        field == "item.item_type"
        and client_item is not None
        and _client_item_type_label(client_item) == _canonical_item_type(db_value)
    ):
        return "catseye_client_items"

    client_key = CLIENT_FIELD_MAP.get(field)
    if client_key is not None and client_item is not None and client_item.get(client_key) == db_value:
        return "catseye_client_items"

    override_key = EQUIPMENT_OVERRIDE_FIELD_MAP.get(field)
    equipment_override = db_catalog["equipment_overrides"].get(item_id)
    if (
        override_key is not None
        and equipment_override is not None
        and equipment_override.get(override_key) == db_value
    ):
        return "catseye_equipment_overrides"

    stat_override_name = STAT_OVERRIDE_FIELD_MAP.get(field)
    if stat_override_name is not None:
        for override in db_catalog["stat_overrides"].get(item_id, ()):
            if override["mod_name"] == stat_override_name and override["catseye_value"] == db_value:
                return "catseye_equipment_stat_overrides"

    return None


def _client_item_type_label(client_item: dict[str, Any]) -> str:
    if (
        int(client_item.get("skill") or 0) > 0
        or int(client_item.get("damage") or 0) > 0
        or int(client_item.get("delay") or 0) > 0
    ):
        return "Weapon"
    if int(client_item.get("slot") or 0) > 0:
        return "Armor"
    return "Item"


def _server_summary(row: dict[str, Any]) -> dict[str, Any]:
    equipment = row["equipment"]
    weapon = row.get("weapon")
    return {
        "item_id": row["item_id"],
        "server_name": row["item"]["name"],
        "server_sort_name": row["item"]["sort_name"],
        "equipment_name": equipment["name"],
        "level": equipment["level"],
        "jobs": equipment["jobs"],
        "slot": equipment["slot"],
        "weapon_skill": None if weapon is None else weapon["skill"],
        "weapon_damage": None if weapon is None else weapon["damage"],
        "weapon_delay": None if weapon is None else weapon["delay"],
    }


def _read_item_basic(path: Path) -> dict[int, dict[str, Any]]:
    rows = statsdb._read_insert_rows(path, "item_basic")
    items: dict[int, dict[str, Any]] = {}
    for row in rows:
        if len(row) < 9:
            continue
        item_type_index = 4 if _looks_like_item_type(row[4]) else 5
        if len(row) <= item_type_index:
            continue
        item_id = statsdb._as_int(row[0])
        items[item_id] = {
            "name": statsdb._as_text(row[2]),
            "sort_name": statsdb._as_text(row[3]),
            "item_type": statsdb._as_text(row[item_type_index]),
        }
    return items


def _looks_like_item_type(value: object) -> bool:
    text = statsdb._as_text(value)
    return text in SERVER_ITEM_TYPE_LABELS or text.endswith("_TYPE")


def _read_item_equipment(path: Path) -> dict[int, dict[str, Any]]:
    rows = statsdb._read_insert_rows(path, "item_equipment")
    equipment: dict[int, dict[str, Any]] = {}
    for row in rows:
        if len(row) < 12:
            continue
        item_id = statsdb._as_int(row[0])
        equipment[item_id] = {
            "name": statsdb._as_text(row[1]),
            "level": statsdb._as_int(row[2]),
            "ilevel": statsdb._as_int(row[3]),
            "jobs": statsdb._as_int(row[4]),
            "shield_size": statsdb._as_int(row[6]),
            "slot": statsdb._as_int(row[8]),
            "su_level": statsdb._as_int(row[11]),
        }
    return equipment


def _read_item_weapon(path: Path) -> dict[int, dict[str, Any]]:
    rows = statsdb._read_insert_rows(path, "item_weapon")
    weapons: dict[int, dict[str, Any]] = {}
    for row in rows:
        if len(row) < 12:
            continue
        item_id = statsdb._as_int(row[0])
        weapons[item_id] = {
            "name": statsdb._as_text(row[1]),
            "skill": statsdb._as_int(row[2]),
            "damage_type": statsdb._as_int(row[7]),
            "delay": statsdb._as_int(row[9]),
            "damage": statsdb._as_int(row[10]),
        }
    return weapons


def _git_label(server_root: Path) -> str:
    root = Path(server_root)
    if not (root / ".git").exists():
        return root.name
    try:
        ref = subprocess.check_output(
            ["git", "-C", str(root), "rev-parse", "--short", "HEAD"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
        branch = subprocess.check_output(
            ["git", "-C", str(root), "branch", "--show-current"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return root.name
    return f"{branch or 'detached'}@{ref}"


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Server Equipment DB Reconciliation",
        "",
        "## Summary",
        "",
    ]
    for key, value in report["summary"].items():
        lines.append(f"- {key}: {value}")

    _append_rows(lines, "Missing Server Equipment In DB", report["missing_server_equipment_in_db"])
    _append_rows(lines, "Unexpected Differences", report["unexpected_differences"], include_differences=True)
    _append_rows(
        lines,
        "Covered Client Resource Differences",
        report["covered_client_resource_differences"],
        include_differences=True,
    )
    _append_rows(
        lines,
        "Covered Equipment Override Differences",
        report["covered_equipment_override_differences"],
        include_differences=True,
    )
    _append_rows(lines, "DB Only Equipment", report["db_only_equipment"])

    lines.extend(["", "## Sources", ""])
    for key, value in report["sources"].items():
        lines.append(f"- {key}: `{value}`")
    return "\n".join(lines) + "\n"


def _append_rows(
    lines: list[str],
    title: str,
    rows: list[dict[str, Any]],
    *,
    include_differences: bool = False,
    limit: int = 100,
) -> None:
    lines.extend(["", f"## {title}", ""])
    if not rows:
        lines.append("- none")
        return
    for row in rows[:limit]:
        label = row.get("server_name") or row.get("db_name") or row.get("equipment_name")
        lines.append(f"- item_id={row['item_id']} {label}")
        if include_differences:
            for diff in row.get("field_differences", ()):
                lines.append(f"  - {diff['field']}: server=`{diff['server']}` db=`{diff['db']}`")
    if len(rows) > limit:
        lines.append(f"- ... {len(rows) - limit} more rows in JSON")


if __name__ == "__main__":
    raise SystemExit(main())
