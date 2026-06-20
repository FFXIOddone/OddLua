from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from datetime import datetime
import json
from pathlib import Path
import re
import sqlite3
import sys
from typing import Any


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ODDLUA_ROOT.parent
DEFAULT_DB_PATH = ODDLUA_ROOT / "data" / "oddlua_stats.sqlite"
DEFAULT_CATSEYE_WIKI_ROOT = PROJECT_ROOT / "tools-data" / "catseye-wiki-cache"
DEFAULT_CLIENT_ITEMS_PATH = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport"
)

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua import statsdb  # noqa: E402


STATISH_RE = re.compile(
    r"\b("
    r"STR|DEX|VIT|AGI|INT|MND|CHR|Accuracy|Attack|Evasion|Haste|Store TP|"
    r"Double Attack|Triple Attack|Quadruple Attack|Dual Wield|Magic|MAB|MACC|"
    r"Refresh|Regen|Subtle Blow|Cure|Fast Cast|Snapshot|Ranged|Pet:|Avatar:|"
    r"Movement|Treasure Hunter|Skill|MP\+|HP\+"
    r")\b",
    re.IGNORECASE,
)

COVERED_BUCKETS = {
    "wiki_matched_current_db",
    "wiki_variant_base_item_current_db",
    "wiki_level_disambiguated_current_db_name",
    "wiki_equivalent_duplicate_current_db_name",
    "wiki_absent_from_current_client_and_db",
}

AUDIT_BASE_VARIANT_NAME_ALIASES = {
    "scalemailnovicetrialpath": 12560,
    "scalemailventurespath": 12560,
    "solidmailnovicetrialpath": 12661,
    "solidmailventurespath": 12661,
    "kirinsosodebyakkopath": 12562,
    "kirinsosodegenbupath": 12562,
    "kirinsosodeseiryupath": 12562,
    "kirinsosodesuzakupath": 12562,
    "kirinspolebyakkopath": 17567,
    "kirinspolegenbupath": 17567,
    "kirinspoleseiryupath": 17567,
    "kirinspolesuzakupath": 17567,
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit Catseye wiki/client equipment coverage in the OddLua stats DB."
    )
    parser.add_argument("--db-path", default=DEFAULT_DB_PATH, type=Path)
    parser.add_argument("--catseye-wiki-root", default=DEFAULT_CATSEYE_WIKI_ROOT, type=Path)
    parser.add_argument("--client-items-path", default=DEFAULT_CLIENT_ITEMS_PATH, type=Path)
    parser.add_argument("--output-dir", type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_coverage(
        db_path=args.db_path,
        catseye_wiki_root=args.catseye_wiki_root,
        client_items_path=args.client_items_path,
    )

    output_dir = args.output_dir
    if output_dir is None:
        output_dir = (
            ODDLUA_ROOT
            / "reports"
            / "verify"
            / f"catseye-coverage-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
        )
    output_dir.mkdir(parents=True, exist_ok=True)

    json_path = output_dir / "catseye_equipment_reconciliation.json"
    md_path = output_dir / "catseye_equipment_reconciliation.md"
    json_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    md_path.write_text(render_markdown(report), encoding="utf-8")

    print(f"Wrote {json_path}")
    print(f"Wrote {md_path}")
    return 0


def audit_coverage(
    *,
    db_path: Path,
    catseye_wiki_root: Path,
    client_items_path: Path,
) -> dict[str, Any]:
    pages_root = statsdb._resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        raise FileNotFoundError(f"Catseye equipment pages not found under {catseye_wiki_root}")

    client_by_norm = _client_equipment_by_normalized_name(client_items_path)

    db = sqlite3.connect(db_path)
    try:
        item_ids_by_name = statsdb._build_equipment_item_name_index(db)
        db_ids_by_norm = _db_alias_ids_by_normalized_name(db)
        db_metadata = dict(db.execute("select key, value from metadata"))
        item_mod_counts = {
            int(item_id): int(count)
            for item_id, count in db.execute("select item_id, count(*) from item_mods group by item_id")
        }
        pet_mod_counts = (
            {
                int(item_id): int(count)
                for item_id, count in db.execute("select item_id, count(*) from item_mods_pet group by item_id")
            }
            if _has_table(db, "item_mods_pet")
            else {}
        )
        effect_tag_counts = (
            {
                int(item_id): int(count)
                for item_id, count in db.execute(
                    "select item_id, count(*) from catseye_equipment_effect_tags group by item_id"
                )
            }
            if _has_table(db, "catseye_equipment_effect_tags")
            else {}
        )
        effect_tags_by_item_id = (
            {
                int(item_id): tags.split("\n") if tags else []
                for item_id, tags in db.execute(
                    """
                    select item_id, group_concat(effect_tag || ':' || status || ':' || target, char(10))
                    from catseye_equipment_effect_tags
                    group by item_id
                    """
                )
            }
            if _has_table(db, "catseye_equipment_effect_tags")
            else {}
        )
        equipment_by_id = {
            int(item_id): {
                "name": str(name),
                "level": int(level),
                "ilevel": int(ilevel),
                "jobs": int(jobs),
                "slot": int(slot),
            }
            for item_id, name, level, ilevel, jobs, slot in db.execute(
                "select item_id, name, level, ilevel, jobs, slot from item_equipment"
            )
        }
        weapon_by_id = {
            int(item_id): {
                "skill": int(skill),
                "damage": int(damage),
                "delay": int(delay),
                "damage_type": int(damage_type),
            }
            for item_id, skill, damage, delay, damage_type in db.execute(
                "select item_id, skill, damage, delay, damage_type from item_weapon"
            )
        }
        mods_by_id: dict[int, list[tuple[str, int]]] = defaultdict(list)
        for item_id, mod_name, value in db.execute(
            "select item_id, mod_name, value from item_mods order by item_id, mod_name, value"
        ):
            mods_by_id[int(item_id)].append((str(mod_name), int(value)))
        latents_by_id: dict[int, list[tuple[str, int, int, int]]] = defaultdict(list)
        for item_id, mod_name, value, condition_id, condition_value in db.execute(
            """
            select item_id, mod_name, value, condition_id, condition_value
            from item_latents
            order by item_id, mod_name, value, condition_id, condition_value
            """
        ):
            latents_by_id[int(item_id)].append(
                (str(mod_name), int(value), int(condition_id), int(condition_value))
            )
        client_coverage = _client_db_coverage(db)
    finally:
        db.close()

    raw_records = [
        record
        for record in statsdb._iter_catseye_equipment_records(pages_root)
        if record.level <= 75 and record.jobs_mask > 0 and record.slot_mask > 0
    ]
    records, duplicate_records = _dedupe_equipment_records(raw_records)

    bucket_counts: Counter[str] = Counter()
    bucket_examples: dict[str, list[dict[str, Any]]] = defaultdict(list)
    unresolved_records: list[dict[str, Any]] = []
    current_build_absent_wiki_records: list[dict[str, Any]] = []
    statish_without_effect_tags: list[dict[str, Any]] = []

    for record in records:
        normalized = statsdb._normalize_catseye_equipment_name(record.name)
        match_item_id = statsdb._match_catseye_equipment_item_id(record, item_ids_by_name)
        db_item_ids = sorted(db_ids_by_norm.get(normalized, ()))
        client_item_ids = sorted({item.item_id for _, item in client_by_norm.get(normalized, ())})
        ambiguous_ids = sorted(item_ids_by_name.get(normalized, ()))
        equivalent_item_ids: list[int] = []
        match_reason: str | None = None

        if match_item_id is None:
            variant_item_id = AUDIT_BASE_VARIANT_NAME_ALIASES.get(normalized)
            if variant_item_id in equipment_by_id:
                match_item_id = variant_item_id
                match_reason = "wiki_variant_base_item_current_db"

        if match_item_id is None and ambiguous_ids:
            match_item_id, match_reason, equivalent_item_ids = _audit_disambiguated_match(
                record,
                ambiguous_ids,
                equipment_by_id,
                weapon_by_id,
                mods_by_id,
                latents_by_id,
            )

        if match_reason is not None:
            bucket = match_reason
        elif match_item_id is not None:
            bucket = "wiki_matched_current_db"
        elif len(ambiguous_ids) > 1:
            bucket = "wiki_ambiguous_current_db_name"
        elif client_item_ids:
            bucket = "wiki_client_present_but_not_uniquely_matched"
        elif db_item_ids:
            bucket = "wiki_db_present_but_not_uniquely_matched"
        elif "(" in record.name and ")" in record.name:
            bucket = "wiki_path_variant_no_item_id"
        else:
            bucket = "wiki_absent_from_current_client_and_db"

        row = {
            "name": record.name,
            "level": record.level,
            "source_path": record.source_path,
            "matched_item_id": match_item_id,
            "db_item_ids": db_item_ids,
            "client_item_ids": client_item_ids,
        }
        if equivalent_item_ids:
            row["equivalent_item_ids"] = equivalent_item_ids
        bucket_counts[bucket] += 1
        if len(bucket_examples[bucket]) < 25:
            bucket_examples[bucket].append(row)
        if bucket == "wiki_absent_from_current_client_and_db":
            current_build_absent_wiki_records.append(row)
        if bucket not in COVERED_BUCKETS:
            unresolved_records.append(row | {"bucket": bucket})

        if (
            match_item_id is not None
            and item_mod_counts.get(match_item_id, 0) == 0
            and pet_mod_counts.get(match_item_id, 0) == 0
            and effect_tag_counts.get(match_item_id, 0) == 0
            and STATISH_RE.search(record.stats_text) is not None
        ):
            equipment = equipment_by_id.get(match_item_id, {})
            statish_without_effect_tags.append(
                {
                    "name": record.name,
                    "item_id": match_item_id,
                    "db_name": equipment.get("name"),
                    "slot": equipment.get("slot"),
                    "level": record.level,
                    "source_path": record.source_path,
                    "stats_text": record.stats_text,
                    "player_mod_count": item_mod_counts.get(match_item_id, 0),
                    "pet_mod_count": pet_mod_counts.get(match_item_id, 0),
                    "effect_tag_count": effect_tag_counts.get(match_item_id, 0),
                }
            )
        if match_item_id is not None and effect_tags_by_item_id.get(match_item_id):
            row["catseye_effect_tags"] = effect_tags_by_item_id[match_item_id]

    return {
        "sources": {
            "db_path": str(db_path),
            "catseye_wiki_root": str(catseye_wiki_root),
            "client_items_path": str(client_items_path),
            "resolved_pages_root": str(pages_root),
        },
        "db_metadata": {
            key: db_metadata[key]
            for key in sorted(db_metadata)
            if key
            in {
                "schema_version",
                "source_sql_root",
                "source_catseye_wiki_root",
                "source_client_items_path",
                "catseye_equipment_override_count",
                "catseye_equipment_stat_override_count",
                "catseye_equipment_effect_tag_count",
                "client_item_count",
                "client_equipment_update_count",
                "client_weapon_update_count",
            }
        },
        "summary": {
            "wiki_equipment_eligible_records": len(records),
            "duplicate_wiki_equipment_records": len(duplicate_records),
            "bucket_counts": dict(sorted(bucket_counts.items())),
            "unresolved_records": len(unresolved_records),
            "current_build_absent_wiki_records": len(current_build_absent_wiki_records),
            "statish_matched_records_without_effect_tags": len(statish_without_effect_tags),
            "statish_matched_records_with_zero_item_mods": len(statish_without_effect_tags),
            **client_coverage["counts"],
        },
        "bucket_examples": dict(sorted(bucket_examples.items())),
        "unresolved_records": unresolved_records,
        "current_build_absent_wiki_records": current_build_absent_wiki_records,
        "statish_matched_records_without_effect_tags": statish_without_effect_tags,
        "statish_matched_records_with_zero_item_mods": statish_without_effect_tags,
        "client_coverage": client_coverage,
    }


def _client_equipment_by_normalized_name(
    client_items_path: Path,
) -> dict[str, list[tuple[str, statsdb.ClientItemResource]]]:
    by_norm: dict[str, list[tuple[str, statsdb.ClientItemResource]]] = defaultdict(list)
    for path in _client_item_dump_paths(client_items_path):
        for item in statsdb._iter_client_item_resources(path):
            if item.slot_mask > 0 or item.skill > 0 or item.damage > 0 or item.delay > 0:
                normalized = statsdb._normalize_catseye_equipment_name(item.name)
                if normalized:
                    by_norm[normalized].append((path.name, item))
    return by_norm


def _client_item_dump_paths(client_items_path: Path) -> tuple[Path, ...]:
    if client_items_path.is_file():
        return (client_items_path,)
    if not client_items_path.exists():
        return ()
    return tuple(sorted(client_items_path.rglob("*_client_items.json")))


def _db_alias_ids_by_normalized_name(db: sqlite3.Connection) -> dict[str, set[int]]:
    by_norm: dict[str, set[int]] = defaultdict(set)
    rows: list[tuple[int, str]] = []
    rows.extend(
        (int(item_id), str(name))
        for item_id, name in db.execute(
            """
            select i.item_id, i.name
            from items i
            join item_equipment e on e.item_id = i.item_id
            """
        )
    )
    rows.extend(
        (int(item_id), str(name))
        for item_id, name in db.execute("select item_id, name from item_equipment")
    )
    if _has_table(db, "item_name_aliases"):
        rows.extend(
            (int(item_id), str(name))
            for item_id, name in db.execute(
                """
                select a.item_id, a.name
                from item_name_aliases a
                join item_equipment e on e.item_id = a.item_id
                """
            )
        )

    for item_id, name in rows:
        normalized = statsdb._normalize_catseye_equipment_name(name)
        if normalized:
            by_norm[normalized].add(item_id)
    return by_norm


def _dedupe_equipment_records(
    records: list[statsdb.CatseyeEquipmentRecord],
) -> tuple[list[statsdb.CatseyeEquipmentRecord], list[statsdb.CatseyeEquipmentRecord]]:
    seen: set[tuple[object, ...]] = set()
    unique_records: list[statsdb.CatseyeEquipmentRecord] = []
    duplicate_records: list[statsdb.CatseyeEquipmentRecord] = []
    for record in records:
        key = (
            statsdb._normalize_catseye_equipment_name(record.name),
            record.level,
            record.jobs_mask,
            record.slot_mask,
            " ".join(record.stats_text.split()),
        )
        if key in seen:
            duplicate_records.append(record)
            continue
        seen.add(key)
        unique_records.append(record)
    return unique_records, duplicate_records


def _audit_disambiguated_match(
    record: statsdb.CatseyeEquipmentRecord,
    item_ids: list[int],
    equipment_by_id: dict[int, dict[str, int | str]],
    weapon_by_id: dict[int, dict[str, int]],
    mods_by_id: dict[int, list[tuple[str, int]]],
    latents_by_id: dict[int, list[tuple[str, int, int, int]]],
) -> tuple[int | None, str | None, list[int]]:
    candidates = [
        item_id
        for item_id in item_ids
        if _equipment_matches_record(record, equipment_by_id.get(item_id))
    ]
    if len(candidates) == 1:
        return candidates[0], "wiki_level_disambiguated_current_db_name", []
    if len(candidates) > 1 and _candidate_signatures_equivalent(
        candidates,
        equipment_by_id,
        weapon_by_id,
        mods_by_id,
        latents_by_id,
    ):
        return candidates[0], "wiki_equivalent_duplicate_current_db_name", candidates
    return None, None, []


def _equipment_matches_record(
    record: statsdb.CatseyeEquipmentRecord,
    equipment: dict[str, int | str] | None,
) -> bool:
    if equipment is None:
        return False
    return (
        int(equipment["level"]) == record.level
        and int(equipment["jobs"]) == record.jobs_mask
        and int(equipment["slot"]) == record.slot_mask
    )


def _candidate_signatures_equivalent(
    item_ids: list[int],
    equipment_by_id: dict[int, dict[str, int | str]],
    weapon_by_id: dict[int, dict[str, int]],
    mods_by_id: dict[int, list[tuple[str, int]]],
    latents_by_id: dict[int, list[tuple[str, int, int, int]]],
) -> bool:
    signatures = {
        _candidate_signature(item_id, equipment_by_id, weapon_by_id, mods_by_id, latents_by_id)
        for item_id in item_ids
    }
    return len(signatures) == 1


def _candidate_signature(
    item_id: int,
    equipment_by_id: dict[int, dict[str, int | str]],
    weapon_by_id: dict[int, dict[str, int]],
    mods_by_id: dict[int, list[tuple[str, int]]],
    latents_by_id: dict[int, list[tuple[str, int, int, int]]],
) -> tuple[object, ...]:
    equipment = equipment_by_id.get(item_id, {})
    weapon = weapon_by_id.get(item_id, {})
    comparable_mods = tuple(
        (mod_name, value)
        for mod_name, value in mods_by_id.get(item_id, [])
        if mod_name != "EQUIPMENT_ONLY_RACE"
    )
    return (
        equipment.get("level"),
        equipment.get("ilevel"),
        equipment.get("jobs"),
        equipment.get("slot"),
        tuple(sorted(weapon.items())),
        comparable_mods,
        tuple(latents_by_id.get(item_id, [])),
    )


def _client_db_coverage(db: sqlite3.Connection) -> dict[str, Any]:
    missing_items: list[dict[str, Any]] = []
    missing_equipment: list[dict[str, Any]] = []
    missing_weapons: list[dict[str, Any]] = []

    rows = db.execute(
        """
        select item_id, name, jobs, slot, skill, damage, delay
        from catseye_client_items
        """
    )
    for item_id, name, jobs, slot, skill, damage, delay in rows:
        item_id = int(item_id)
        if int(slot) > 0 and int(jobs) > 0:
            row = {"item_id": item_id, "name": str(name)}
            if db.execute("select 1 from items where item_id = ?", (item_id,)).fetchone() is None:
                missing_items.append(row)
            if db.execute("select 1 from item_equipment where item_id = ?", (item_id,)).fetchone() is None:
                missing_equipment.append(row)
        if int(skill) > 0 or int(damage) > 0 or int(delay) > 0:
            if db.execute("select 1 from item_weapon where item_id = ?", (item_id,)).fetchone() is None:
                missing_weapons.append({"item_id": item_id, "name": str(name)})

    return {
        "counts": {
            "client_equipment_missing_items": len(missing_items),
            "client_equipment_missing_item_equipment": len(missing_equipment),
            "client_weapons_missing_item_weapon": len(missing_weapons),
        },
        "client_equipment_missing_items": missing_items,
        "client_equipment_missing_item_equipment": missing_equipment,
        "client_weapons_missing_item_weapon": missing_weapons,
    }


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    return db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone() is not None


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Catseye Equipment Reconciliation",
        "",
        "## Summary",
        "",
    ]
    for key, value in report["summary"].items():
        lines.append(f"- {key}: {value}")

    lines.extend(["", "## Bucket Counts", ""])
    for key, value in report["summary"]["bucket_counts"].items():
        lines.append(f"- {key}: {value}")

    lines.extend(["", "## Unresolved Records", ""])
    if report["unresolved_records"]:
        for row in report["unresolved_records"]:
            lines.append(
                "- "
                f"{row['bucket']}: {row['name']} "
                f"(level {row['level']}, {row['source_path']}, "
                f"db_ids={row['db_item_ids']}, client_ids={row['client_item_ids']})"
            )
    else:
        lines.append("- none")

    lines.extend(["", "## Wiki Records Absent From Current Build", ""])
    if report["current_build_absent_wiki_records"]:
        for row in report["current_build_absent_wiki_records"]:
            lines.append(
                "- "
                f"{row['name']} "
                f"(level {row['level']}, {row['source_path']}, "
                f"db_ids={row['db_item_ids']}, client_ids={row['client_item_ids']})"
            )
    else:
        lines.append("- none")

    lines.extend(["", "## Matched Records With Stat-Like Text But No Mods Or Effect Tags", ""])
    if report["statish_matched_records_without_effect_tags"]:
        for row in report["statish_matched_records_without_effect_tags"]:
            lines.append(
                "- "
                f"{row['name']} item_id={row['item_id']} db_name={row['db_name']} "
                f"slot={row['slot']} ({row['source_path']}): `{row['stats_text']}`"
            )
    else:
        lines.append("- none")

    lines.extend(["", "## Sources", ""])
    for key, value in report["sources"].items():
        lines.append(f"- {key}: `{value}`")
    for key, value in report["db_metadata"].items():
        lines.append(f"- metadata.{key}: `{value}`")

    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    raise SystemExit(main())
