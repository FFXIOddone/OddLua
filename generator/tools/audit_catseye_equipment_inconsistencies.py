from __future__ import annotations

import argparse
from collections import defaultdict
from datetime import datetime
import json
from pathlib import Path
import re
import sqlite3
import sys
from typing import Any, Iterable


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ODDLUA_ROOT.parent
DEFAULT_DB_PATH = ODDLUA_ROOT / "data" / "oddlua_stats.sqlite"
DEFAULT_CATSEYE_WIKI_ROOT = PROJECT_ROOT / "tools-data" / "catseye-wiki-cache"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua import statsdb  # noqa: E402
from oddlua.catseye_client_names import client_collision_is_expected  # noqa: E402
from oddlua.catseye_equipment_audit import _race_duplicate_equipment_candidate_ids  # noqa: E402
from oddlua.catseye_skipped_effects_audit import skipped_effect_fragments_for_record  # noqa: E402


TECHNIQUES = (
    "stale_catseye_stat_override_application",
    "orphan_catseye_provenance_rows",
    "conflicting_duplicate_wiki_records",
    "client_name_collision_signatures",
    "uncovered_client_db_field_differences",
    "wiki_slot_name_lexical_mismatches",
    "wiki_armor_page_slot_mismatches",
    "wiki_utility_tokens_without_effect_tags",
    "wiki_weapon_stats_without_weapon_rows",
    "utility_effect_tags_without_matching_wiki_tokens",
    "semantic_duplicate_wiki_record_conflicts",
    "wiki_slot_name_db_slot_conflicts",
    "unexpected_client_name_collision_signatures",
    "high_signal_skipped_effect_fragments",
    "ambiguous_wiki_record_matches",
    "db_slot_name_lexical_mismatches",
    "client_slot_name_lexical_mismatches",
    "catseye_source_slot_guarded_overrides",
    "stat_overrides_from_slot_conflicting_sources",
    "identity_catseye_equipment_overrides",
)

ARMOR_PAGE_SLOT_MASKS = {
    slot: statsdb.EQUIPMENT_SLOT_MASKS[slot]
    for slot in ("Head", "Body", "Hands", "Legs", "Feet")
}

SLOT_NAME_TOKENS = {
    slot: tuple(sorted(tokens))
    for slot, tokens in statsdb.CATSEYE_ARMOR_SLOT_NAME_TOKENS.items()
}

WEAPON_SLOT_BITS = sum(
    statsdb.EQUIPMENT_SLOT_MASKS[slot]
    for slot in ("Main", "Sub", "Range", "Ammo")
)
CURRENT_BUILD_SLOT_NAME_LEXICAL_EXCEPTIONS = {
    # The current Catseye client resource dump and server DB both label this as
    # Legs even though the display name contains "Boots". OddLua must follow
    # the live equip slot for generated Lua to equip it correctly.
    11957: "Novennial Boots",
}
CURRENT_BUILD_SOURCE_SLOT_MISPLACEMENT_EXCEPTIONS = {
    # These current Catseye wiki records are listed on the wrong equipment page,
    # while the live DB/client slot and name-implied slot agree. Keep guarding
    # the slot during import, but do not report them as unresolved mismatches.
    (28201, "pages/CatsEyeXI_Content_Equipment_Head.txt", "Head", "Legs"): "Acrobat's Breeches",
    (27047, "pages/CatsEyeXI_Content_Equipment_Head.txt", "Head", "Hands"): "Taeon Gloves",
    (27406, "pages/CatsEyeXI_Content_Equipment_Legs.txt", "Legs", "Feet"): "Helios Boots",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run cross-cutting Catseye equipment inconsistency techniques."
    )
    parser.add_argument("--db-path", default=DEFAULT_DB_PATH, type=Path)
    parser.add_argument("--catseye-wiki-root", default=DEFAULT_CATSEYE_WIKI_ROOT, type=Path)
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--max-examples-per-technique", default=50, type=int)
    parser.add_argument(
        "--fail-on-unbudgeted-findings",
        action="store_true",
        help="Fail if any technique has findings above its explicit --max-technique budget.",
    )
    parser.add_argument(
        "--max-technique",
        action="append",
        default=[],
        metavar="NAME=COUNT",
        help="Allowed finding count for one technique when --fail-on-unbudgeted-findings is used.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_catseye_equipment_inconsistencies(
        db_path=args.db_path,
        catseye_wiki_root=args.catseye_wiki_root,
        max_examples_per_technique=args.max_examples_per_technique,
    )

    output_dir = args.output_dir
    if output_dir is None:
        output_dir = (
            ODDLUA_ROOT
            / "reports"
            / "catseye-equipment-inconsistencies"
            / datetime.now().strftime("%Y%m%d-%H%M%S")
        )
    output_dir.mkdir(parents=True, exist_ok=True)

    json_path = output_dir / "catseye_equipment_inconsistencies.json"
    md_path = output_dir / "catseye_equipment_inconsistencies.md"
    json_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    md_path.write_text(render_markdown(report), encoding="utf-8")
    print(f"Wrote {json_path}")
    print(f"Wrote {md_path}")
    print(json.dumps(report["summary"], indent=2, sort_keys=True))
    if args.fail_on_unbudgeted_findings:
        failures = inconsistency_audit_failures(
            report,
            max_findings_by_technique=parse_max_technique_budgets(args.max_technique),
        )
        for failure in failures:
            print(f"FAIL: {failure}")
        if failures:
            return 1
    return 0


def audit_catseye_equipment_inconsistencies(
    *,
    db_path: Path,
    catseye_wiki_root: Path,
    max_examples_per_technique: int = 50,
) -> dict[str, Any]:
    pages_root = statsdb._resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        raise FileNotFoundError(f"Catseye equipment pages not found under {catseye_wiki_root}")

    db = sqlite3.connect(db_path)
    db.row_factory = sqlite3.Row
    try:
        catalog = _load_catalog(db)
        records = tuple(statsdb._iter_catseye_equipment_records(pages_root))
        item_ids_by_name = statsdb._build_equipment_item_name_index(db)

        results = {
            "stale_catseye_stat_override_application": _stale_stat_override_findings(db, catalog),
            "orphan_catseye_provenance_rows": _orphan_provenance_findings(db, catalog, pages_root),
            "conflicting_duplicate_wiki_records": _conflicting_duplicate_wiki_findings(
                records,
                item_ids_by_name,
                db,
                catalog,
            ),
            "client_name_collision_signatures": _client_name_collision_findings(catalog),
            "uncovered_client_db_field_differences": _uncovered_client_db_diff_findings(catalog),
            "wiki_slot_name_lexical_mismatches": _wiki_slot_name_lexical_findings(records),
            "wiki_armor_page_slot_mismatches": _wiki_armor_page_slot_findings(records),
            "wiki_utility_tokens_without_effect_tags": _wiki_utility_without_effect_tag_findings(
                records,
                item_ids_by_name,
                db,
                catalog,
            ),
            "wiki_weapon_stats_without_weapon_rows": _wiki_weapon_without_weapon_row_findings(
                records,
                item_ids_by_name,
                db,
                catalog,
            ),
            "utility_effect_tags_without_matching_wiki_tokens": _utility_effect_tag_source_findings(
                records,
                item_ids_by_name,
                db,
                catalog,
            ),
            "semantic_duplicate_wiki_record_conflicts": _semantic_duplicate_wiki_findings(
                records,
                item_ids_by_name,
                db,
                catalog,
            ),
            "wiki_slot_name_db_slot_conflicts": _wiki_slot_name_db_slot_findings(
                records,
                item_ids_by_name,
                db,
                catalog,
            ),
            "unexpected_client_name_collision_signatures": _unexpected_client_name_collision_findings(catalog),
            "high_signal_skipped_effect_fragments": _high_signal_skipped_effect_findings(records),
            "ambiguous_wiki_record_matches": _ambiguous_wiki_record_match_findings(
                records,
                item_ids_by_name,
                db,
            ),
            "db_slot_name_lexical_mismatches": _db_slot_name_lexical_findings(catalog),
            "client_slot_name_lexical_mismatches": _client_slot_name_lexical_findings(catalog),
            "catseye_source_slot_guarded_overrides": _source_slot_guarded_override_findings(catalog),
            "stat_overrides_from_slot_conflicting_sources": _stat_override_slot_conflicting_source_findings(catalog),
            "identity_catseye_equipment_overrides": _identity_equipment_override_findings(catalog),
        }
    finally:
        db.close()

    technique_summaries = {
        technique: {
            "findings": len(findings),
            "examples_returned": min(len(findings), max_examples_per_technique),
        }
        for technique, findings in results.items()
    }
    return {
        "sources": {
            "db_path": str(db_path),
            "catseye_wiki_root": str(catseye_wiki_root),
            "resolved_pages_root": str(pages_root),
        },
        "summary": {
            "techniques": len(results),
            "total_findings": sum(len(findings) for findings in results.values()),
            "technique_findings": {
                technique: len(findings)
                for technique, findings in results.items()
            },
        },
        "techniques": TECHNIQUES,
        "technique_summaries": technique_summaries,
        "findings": {
            technique: findings[:max_examples_per_technique]
            for technique, findings in results.items()
        },
    }


def inconsistency_audit_failures(
    report: dict[str, Any],
    *,
    max_findings_by_technique: dict[str, int] | None = None,
) -> tuple[str, ...]:
    max_findings_by_technique = max_findings_by_technique or {}
    technique_summaries = report.get("technique_summaries")
    if not isinstance(technique_summaries, dict):
        return ("missing technique_summaries",)

    failures: list[str] = []
    for technique in TECHNIQUES:
        summary = technique_summaries.get(technique)
        if not isinstance(summary, dict):
            failures.append(f"{technique} missing summary")
            continue
        findings = int(summary.get("findings") or 0)
        max_findings = int(max_findings_by_technique.get(technique, 0))
        if findings > max_findings:
            failures.append(f"{technique} findings {findings} exceeds max {max_findings}")
    return tuple(failures)


def parse_max_technique_budgets(entries: Iterable[str]) -> dict[str, int]:
    budgets: dict[str, int] = {}
    for entry in entries:
        if "=" not in entry:
            raise ValueError(f"Technique budget must use NAME=COUNT: {entry}")
        technique, raw_count = entry.split("=", 1)
        if technique not in TECHNIQUES:
            raise ValueError(f"Unknown Catseye inconsistency technique: {technique}")
        try:
            count = int(raw_count)
        except ValueError as exc:
            raise ValueError(f"Technique budget count must be a non-negative integer: {entry}") from exc
        if count < 0:
            raise ValueError(f"Technique budget count must be a non-negative integer: {entry}")
        budgets[technique] = count
    return budgets


def _load_catalog(db: sqlite3.Connection) -> dict[str, Any]:
    return {
        "items": _rows_by_item_id(db, "select item_id, name, sort_name, item_type from items"),
        "equipment": _rows_by_item_id(
            db,
            """
            select item_id, name, level, ilevel, jobs, slot, shield_size, su_level
            from item_equipment
            """,
        ),
        "weapons": _rows_by_item_id(
            db,
            "select item_id, name, skill, damage, delay, damage_type from item_weapon",
        ),
        "client_items": _rows_by_item_id(
            db,
            """
            select item_id, name, level, ilevel, jobs, slot, shield_size, su_level,
                   skill, damage, delay, damage_type
            from catseye_client_items
            """,
        )
        if _has_table(db, "catseye_client_items")
        else {},
        "item_mods": _item_mod_values(db),
        "stat_overrides": _stat_override_values(db),
        "effect_tags": _effect_tags(db),
        "equipment_overrides": _rows_by_item_id(
            db,
            """
            select item_id, server_name, catseye_name, original_level,
                   catseye_level, original_ilevel, catseye_ilevel,
                   original_jobs, catseye_jobs, original_slot, catseye_slot,
                   source_path, stats_text
            from catseye_equipment_overrides
            """,
        )
        if _has_table(db, "catseye_equipment_overrides")
        else {},
    }


def _rows_by_item_id(db: sqlite3.Connection, query: str) -> dict[int, dict[str, Any]]:
    return {
        int(row["item_id"]): {
            key: _json_value(row[key])
            for key in row.keys()
            if key != "item_id"
        }
        for row in db.execute(query)
    }


def _json_value(value: object) -> object:
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return value


def _item_mod_values(db: sqlite3.Connection) -> dict[tuple[int, str], list[int]]:
    values: dict[tuple[int, str], list[int]] = defaultdict(list)
    for row in db.execute("select item_id, mod_name, value from item_mods"):
        values[(int(row["item_id"]), str(row["mod_name"]))].append(int(row["value"]))
    return values


def _stat_override_values(db: sqlite3.Connection) -> dict[tuple[int, str], list[dict[str, Any]]]:
    if not _has_table(db, "catseye_equipment_stat_overrides"):
        return {}

    values: dict[tuple[int, str], list[dict[str, Any]]] = defaultdict(list)
    for row in db.execute(
        """
        select item_id, mod_id, mod_name, original_value, catseye_value, source_path, source_text
        from catseye_equipment_stat_overrides
        """
    ):
        values[(int(row["item_id"]), str(row["mod_name"]))].append(
            {
                "item_id": int(row["item_id"]),
                "mod_id": int(row["mod_id"]),
                "mod_name": str(row["mod_name"]),
                "original_value": None if row["original_value"] is None else int(row["original_value"]),
                "catseye_value": int(row["catseye_value"]),
                "source_path": str(row["source_path"]),
                "source_text": str(row["source_text"]),
            }
        )
    return values


def _effect_tags(db: sqlite3.Connection) -> dict[int, list[dict[str, Any]]]:
    if not _has_table(db, "catseye_equipment_effect_tags"):
        return {}

    tags: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for row in db.execute(
        """
        select item_id, effect_tag, status, target, source_path, source_text, value
        from catseye_equipment_effect_tags
        """
    ):
        tags[int(row["item_id"])].append(
            {
                "effect_tag": str(row["effect_tag"]),
                "status": str(row["status"]),
                "target": str(row["target"]),
                "source_path": str(row["source_path"]),
                "source_text": str(row["source_text"]),
                "value": None if row["value"] is None else int(row["value"]),
            }
        )
    return tags


def _stale_stat_override_findings(
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for (item_id, mod_name), rows in sorted(catalog["stat_overrides"].items()):
        expected = _preferred_value(row["catseye_value"] for row in rows)
        weapon = catalog["weapons"].get(item_id)
        if mod_name == "WEAPON_DAMAGE":
            actual = None if weapon is None else int(weapon["damage"])
        elif mod_name == "WEAPON_DELAY":
            actual = None if weapon is None else int(weapon["delay"])
        else:
            actual_values = catalog["item_mods"].get((item_id, mod_name), ())
            actual = sum(actual_values) if actual_values else None

        if actual == expected:
            continue

        findings.append(
            _finding(
                item_id=item_id,
                name=_display_name(catalog, item_id),
                issue=f"{mod_name} override expects {expected}, current DB has {actual}",
                details={
                    "mod_name": mod_name,
                    "expected": expected,
                    "actual": actual,
                    "sources": sorted({row["source_path"] for row in rows}),
                },
            )
        )
    return findings


def _preferred_value(values: Any) -> int:
    iterator = iter(values)
    preferred = int(next(iterator))
    for value in iterator:
        value = int(value)
        if value < 0 and preferred <= 0:
            if value < preferred:
                preferred = value
        elif value > preferred:
            preferred = value
    return preferred


def _orphan_provenance_findings(
    db: sqlite3.Connection,
    catalog: dict[str, Any],
    pages_root: Path,
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    provenance_queries = (
        (
            "catseye_equipment_overrides",
            "select item_id, catseye_name as name, source_path from catseye_equipment_overrides",
        ),
        (
            "catseye_equipment_stat_overrides",
            "select item_id, mod_name as name, source_path from catseye_equipment_stat_overrides",
        ),
        (
            "catseye_equipment_effect_tags",
            "select item_id, effect_tag as name, source_path from catseye_equipment_effect_tags",
        ),
    )
    for table, query in provenance_queries:
        if not _has_table(db, table):
            continue
        for row in db.execute(query):
            item_id = int(row["item_id"])
            source_path = str(row["source_path"])
            source_exists = _source_path_exists(pages_root, source_path)
            if item_id not in catalog["equipment"] or not source_exists:
                findings.append(
                    _finding(
                        item_id=item_id,
                        name=_display_name(catalog, item_id) or str(row["name"]),
                        issue=f"{table} provenance is not anchored to current equipment/wiki source",
                        details={
                            "table": table,
                            "source_path": source_path,
                            "item_equipment_present": item_id in catalog["equipment"],
                            "source_path_exists": source_exists,
                        },
                    )
                )
    return findings


def _source_path_exists(pages_root: Path, source_path: str) -> bool:
    path = Path(source_path)
    if path.is_absolute():
        return path.exists()
    return (pages_root.parent / source_path).exists() or (pages_root / source_path).exists()


def _conflicting_duplicate_wiki_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    by_norm: dict[str, list[statsdb.CatseyeEquipmentRecord]] = defaultdict(list)
    for record in records:
        if _record_is_current_build_source_slot_misplacement(record):
            continue
        by_norm[statsdb._normalize_catseye_equipment_name(record.name)].append(record)

    findings: list[dict[str, Any]] = []
    for normalized, group in sorted(by_norm.items()):
        signatures = {_semantic_wiki_record_signature(record) for record in group}
        if len(signatures) <= 1:
            continue

        matched_ids = {
            item_id
            for record in group
            for item_id in (statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db),)
            if item_id is not None
        }
        if len(matched_ids) > 1:
            continue
        if _duplicate_group_has_augment_path_coverage(catalog, group, matched_ids):
            continue

        findings.append(
            {
                "name": group[0].name,
                "issue": "duplicate Catseye wiki records have conflicting signatures but collapse to one or zero DB ids",
                "details": {
                    "normalized_name": normalized,
                    "record_count": len(group),
                    "signature_count": len(signatures),
                    "matched_item_ids": sorted(matched_ids),
                    "sources": sorted({record.source_path for record in group}),
                    "examples": [
                        {
                            "level": record.level,
                            "jobs": record.jobs_mask,
                            "slot": record.slot_mask,
                            "stats_text": record.stats_text,
                            "source_path": record.source_path,
                        }
                        for record in group[:5]
                    ],
                },
            }
        )
    return findings


def _client_name_collision_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    by_norm: dict[str, list[tuple[int, dict[str, Any]]]] = defaultdict(list)
    for item_id, row in catalog["client_items"].items():
        if not _client_item_has_equipment_shape(row):
            continue
        normalized = statsdb._normalize_catseye_equipment_name(str(row["name"]))
        if normalized:
            by_norm[normalized].append((item_id, row))

    findings: list[dict[str, Any]] = []
    for normalized, rows in sorted(by_norm.items()):
        item_ids = sorted(item_id for item_id, _row in rows)
        if len(item_ids) <= 1:
            continue
        signatures = {
            (
                int(row["level"]),
                int(row["jobs"]),
                int(row["slot"]),
                int(row["skill"]),
                int(row["damage"]),
                int(row["delay"]),
            )
            for _item_id, row in rows
        }
        if len(signatures) <= 1:
            continue
        findings.append(
            {
                "name": str(rows[0][1]["name"]),
                "issue": "Catseye client resources reuse one normalized name across different equipment signatures",
                "details": {
                    "normalized_name": normalized,
                    "item_ids": item_ids,
                    "signature_count": len(signatures),
                    "signatures": sorted(signatures),
                },
            }
        )
    return findings


def _uncovered_client_db_diff_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    equipment_fields = ("name", "level", "ilevel", "jobs", "slot", "shield_size", "su_level")
    weapon_fields = ("name", "skill", "damage", "delay", "damage_type")
    for item_id, client in sorted(catalog["client_items"].items()):
        if not _client_item_has_equipment_shape(client):
            continue
        equipment = catalog["equipment"].get(item_id)
        weapon = catalog["weapons"].get(item_id)
        diffs: list[dict[str, Any]] = []
        if equipment is None and int(client.get("slot") or 0) > 0:
            diffs.append({"field": "item_equipment", "client": "present", "db": None})
        elif equipment is not None:
            for field in equipment_fields:
                if str(field) == "name":
                    if statsdb._normalize_catseye_equipment_name(str(equipment[field])) != statsdb._normalize_catseye_equipment_name(str(client[field])):
                        diffs.append({"field": f"equipment.{field}", "client": client[field], "db": equipment[field]})
                elif int(equipment[field]) != int(client[field]) and not _client_equipment_diff_covered_by_override(
                    item_id,
                    field,
                    int(equipment[field]),
                    catalog,
                ):
                    diffs.append({"field": f"equipment.{field}", "client": client[field], "db": equipment[field]})

        client_is_weapon = any(int(client.get(field) or 0) > 0 for field in ("skill", "damage", "delay"))
        if weapon is None and client_is_weapon:
            diffs.append({"field": "item_weapon", "client": "present", "db": None})
        elif weapon is not None and client_is_weapon:
            for field in weapon_fields:
                if field == "name":
                    if statsdb._normalize_catseye_equipment_name(str(weapon[field])) != statsdb._normalize_catseye_equipment_name(str(client[field])):
                        diffs.append({"field": f"weapon.{field}", "client": client[field], "db": weapon[field]})
                elif int(weapon[field]) != int(client[field]) and not _client_diff_covered_by_stat_override(
                    item_id,
                    field,
                    int(weapon[field]),
                    catalog,
                ):
                    diffs.append({"field": f"weapon.{field}", "client": client[field], "db": weapon[field]})

        if diffs:
            findings.append(
                _finding(
                    item_id=item_id,
                    name=_display_name(catalog, item_id) or str(client["name"]),
                    issue="Catseye client resource differs from current DB without recognized coverage",
                    details={"differences": diffs},
                )
            )
    return findings


def _client_item_has_equipment_shape(row: dict[str, Any]) -> bool:
    if int(row.get("jobs") or 0) <= 0:
        return False
    return any(
        int(row.get(field) or 0) > 0
        for field in ("slot", "skill", "damage", "delay")
    )


def _client_equipment_diff_covered_by_override(
    item_id: int,
    field: str,
    db_value: int,
    catalog: dict[str, Any],
) -> bool:
    override_field = {
        "level": "catseye_level",
        "ilevel": "catseye_ilevel",
        "jobs": "catseye_jobs",
        "slot": "catseye_slot",
    }.get(field)
    if override_field is None:
        return False
    override = catalog["equipment_overrides"].get(item_id)
    return override is not None and int(override[override_field]) == db_value


def _client_diff_covered_by_stat_override(
    item_id: int,
    field: str,
    db_value: int,
    catalog: dict[str, Any],
) -> bool:
    mod_name = {
        "damage": "WEAPON_DAMAGE",
        "delay": "WEAPON_DELAY",
    }.get(field)
    if mod_name is None:
        return False
    return any(
        int(row["catseye_value"]) == db_value
        for row in catalog["stat_overrides"].get((item_id, mod_name), ())
    )


def _wiki_slot_name_lexical_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        expected_slots = _slots_implied_by_name(record.name)
        if not expected_slots:
            continue
        actual_slots = {
            slot
            for slot, mask in ARMOR_PAGE_SLOT_MASKS.items()
            if record.slot_mask & mask
        }
        if len(actual_slots) != 1 or actual_slots & expected_slots:
            continue
        actual_slot = next(iter(actual_slots))
        expected_slot = next(iter(expected_slots)) if len(expected_slots) == 1 else None
        if expected_slot is not None and _is_current_build_source_slot_misplacement_by_name(
            record.name,
            record.source_path,
            actual_slot,
            expected_slot,
        ):
            continue
        findings.append(
            {
                "name": record.name,
                "issue": "wiki item name implies a different armor slot than the parsed record slot",
                "details": {
                    "expected_slots_from_name": sorted(expected_slots),
                    "parsed_slots": sorted(actual_slots),
                    "source_path": record.source_path,
                    "stats_text": record.stats_text,
                },
            }
        )
    return findings


def _slots_implied_by_name(name: str) -> set[str]:
    name_tokens = set(re.findall(r"[a-z0-9]+", name.lower()))
    slots = set()
    for slot, slot_tokens in SLOT_NAME_TOKENS.items():
        if any(token in name_tokens for token in slot_tokens):
            slots.add(slot)
    return slots


def _wiki_armor_page_slot_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        page_slot = _armor_slot_from_source_path(record.source_path)
        if page_slot is None:
            continue
        expected_mask = ARMOR_PAGE_SLOT_MASKS[page_slot]
        if record.slot_mask == expected_mask:
            continue
        findings.append(
            {
                "name": record.name,
                "issue": "wiki equipment page family disagrees with parsed slot header",
                "details": {
                    "page_slot": page_slot,
                    "parsed_slot_mask": record.slot_mask,
                    "source_path": record.source_path,
                    "stats_text": record.stats_text,
                },
            }
        )
    return findings


def _armor_slot_from_source_path(source_path: str) -> str | None:
    name = Path(source_path).stem
    prefix = "CatsEyeXI_Content_Equipment_"
    if not name.startswith(prefix):
        return None
    suffix = name[len(prefix):]
    return suffix if suffix in ARMOR_PAGE_SLOT_MASKS else None


def _iter_expected_utility_effect_tags(
    record: statsdb.CatseyeEquipmentRecord,
    item_id: int,
) -> Iterable[statsdb.CatseyeEquipmentEffectTag]:
    yield from statsdb._iter_catseye_utility_effect_tags(record, item_id)
    for effect in statsdb._iter_catseye_unsupported_effect_tags(record, item_id):
        if effect.target == "utility":
            yield effect


def _wiki_utility_without_effect_tag_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        item_id = statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None:
            continue
        actual_tags = {
            tag["effect_tag"]
            for tag in catalog["effect_tags"].get(item_id, ())
            if tag["target"] == "utility"
        }
        for expected in _iter_expected_utility_effect_tags(record, item_id):
            if expected.effect_tag in actual_tags:
                continue
            findings.append(
                _finding(
                    item_id=item_id,
                    name=_display_name(catalog, item_id) or record.name,
                    issue="wiki utility passive token is not represented by an effect tag",
                    details={
                        "effect_tag": expected.effect_tag,
                        "value": expected.value,
                        "source_path": record.source_path,
                        "source_text": expected.source_text,
                    },
                )
            )
    return findings


def _wiki_weapon_without_weapon_row_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        weapon_stats = statsdb.parse_wiki_weapon_stats(record.stats_text)
        if not weapon_stats:
            continue
        if record.slot_mask & WEAPON_SLOT_BITS == 0:
            continue
        item_id = statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None or item_id in catalog["weapons"]:
            continue
        findings.append(
            _finding(
                item_id=item_id,
                name=_display_name(catalog, item_id) or record.name,
                issue="matched wiki weapon stats have no item_weapon row",
                details={
                    "source_path": record.source_path,
                    "weapon_stats": weapon_stats,
                    "stats_text": record.stats_text,
                },
            )
        )
    return findings


def _utility_effect_tag_source_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    expected_by_item: dict[int, set[tuple[str, int | None]]] = defaultdict(set)
    for record in records:
        item_id = statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None:
            continue
        for effect in _iter_expected_utility_effect_tags(record, item_id):
            expected_by_item[item_id].add((effect.effect_tag, effect.value))

    findings: list[dict[str, Any]] = []
    for item_id, tags in sorted(catalog["effect_tags"].items()):
        for tag in tags:
            if tag["target"] != "utility":
                continue
            key = (str(tag["effect_tag"]), tag["value"])
            if key in expected_by_item.get(item_id, set()):
                continue
            findings.append(
                _finding(
                    item_id=item_id,
                    name=_display_name(catalog, item_id),
                    issue="utility effect tag no longer matches any parsed wiki utility token",
                    details={
                        "effect_tag": tag["effect_tag"],
                        "value": tag["value"],
                        "source_path": tag["source_path"],
                        "source_text": tag["source_text"],
                    },
                )
            )
    return findings


def _semantic_duplicate_wiki_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    by_norm: dict[str, list[statsdb.CatseyeEquipmentRecord]] = defaultdict(list)
    for record in records:
        if _record_is_current_build_source_slot_misplacement(record):
            continue
        by_norm[statsdb._normalize_catseye_equipment_name(record.name)].append(record)

    findings: list[dict[str, Any]] = []
    for normalized, group in sorted(by_norm.items()):
        if len(group) <= 1:
            continue

        signatures = {_semantic_wiki_record_signature(record) for record in group}
        if len(signatures) <= 1:
            continue

        matched_ids = {
            item_id
            for record in group
            for item_id in (statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db),)
            if item_id is not None
        }
        if _duplicate_group_has_augment_path_coverage(catalog, group, matched_ids):
            continue
        findings.append(
            {
                "name": group[0].name,
                "issue": "duplicate Catseye wiki records differ after semantic stat normalization",
                "details": {
                    "normalized_name": normalized,
                    "record_count": len(group),
                    "semantic_signature_count": len(signatures),
                    "matched_item_ids": sorted(matched_ids),
                    "sources": sorted({record.source_path for record in group}),
                    "examples": [
                        {
                            "level": record.level,
                            "jobs": record.jobs_mask,
                            "slot": record.slot_mask,
                            "stats_text": record.stats_text,
                            "semantic_signature": list(_semantic_wiki_record_signature(record)),
                            "source_path": record.source_path,
                        }
                        for record in group[:5]
                    ],
                },
            }
        )
    return findings


def _semantic_wiki_record_signature(record: statsdb.CatseyeEquipmentRecord) -> tuple[Any, ...]:
    conditional_mods = tuple(
        sorted(
            (
                mod.mod_name,
                mod.value,
                mod.condition_type,
                mod.condition_name,
            )
            for mod in statsdb.parse_wiki_conditional_stat_mods(record.stats_text)
        )
    )
    utility_effects = tuple(
        sorted(
            (effect.effect_tag, effect.value)
            for effect in statsdb._iter_catseye_utility_effect_tags(record, item_id=0)
        )
    )
    return (
        record.level,
        record.jobs_mask,
        record.slot_mask,
        tuple(sorted(statsdb.parse_wiki_stat_mods(record.stats_text).items())),
        tuple(sorted(statsdb.parse_wiki_weapon_stats(record.stats_text).items())),
        conditional_mods,
        utility_effects,
    )


def _duplicate_group_has_augment_path_coverage(
    catalog: dict[str, Any],
    group: list[statsdb.CatseyeEquipmentRecord],
    matched_ids: set[int],
) -> bool:
    if len(matched_ids) != 1:
        return False
    item_id = next(iter(matched_ids))
    normalized_name = statsdb._normalize_catseye_equipment_name(group[0].name)
    if not normalized_name:
        return False
    for tag in catalog["effect_tags"].get(item_id, ()):
        if tag["target"] != "augment_path":
            continue
        source_name = str(tag["source_text"]).split(":", 1)[0]
        if statsdb._normalize_catseye_equipment_name(source_name).startswith(normalized_name):
            return True
    return False


def _canonical_stats_text(stats_text: str) -> str:
    text = stats_text.replace('"', "").replace("\u00a0", " ")
    text = re.sub(r"([a-z])([A-Z])", r"\1 \2", text)
    text = text.lower()
    text = re.sub(r"\s*([+:/%()-])\s*", r"\1", text)
    return " ".join(text.split())


def _wiki_slot_name_db_slot_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
    catalog: dict[str, Any],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        expected_slots = _slots_implied_by_name(record.name)
        if len(expected_slots) != 1:
            continue
        expected_slot = next(iter(expected_slots))
        expected_mask = ARMOR_PAGE_SLOT_MASKS[expected_slot]
        if record.slot_mask & expected_mask:
            continue

        item_id = statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None:
            continue

        trusted_slot = _trusted_db_slot_for_name(catalog, item_id, expected_mask)
        if trusted_slot & expected_mask == 0:
            continue
        source_slot = _armor_slot_from_source_path(record.source_path)
        if _is_current_build_source_slot_misplacement(
            item_id,
            record.source_path,
            source_slot,
            expected_slot,
        ):
            continue

        findings.append(
            _finding(
                item_id=item_id,
                name=_display_name(catalog, item_id) or record.name,
                issue="wiki slot contradicts item name and the DB/original slot agrees with the name",
                details={
                    "expected_slot_from_name": expected_slot,
                    "wiki_record_slots": _slot_names_for_mask(record.slot_mask),
                    "trusted_db_slots": _slot_names_for_mask(trusted_slot),
                    "source_path": record.source_path,
                    "stats_text": record.stats_text,
                },
            )
        )
    return findings


def _trusted_db_slot_for_name(
    catalog: dict[str, Any],
    item_id: int,
    expected_mask: int,
) -> int:
    equipment = catalog["equipment"].get(item_id)
    trusted_slot = 0 if equipment is None else int(equipment["slot"])
    override = catalog["equipment_overrides"].get(item_id)
    if override is not None:
        original_slot = int(override.get("original_slot") or 0)
        if original_slot & expected_mask:
            return original_slot
    return trusted_slot


def _record_is_current_build_source_slot_misplacement(
    record: statsdb.CatseyeEquipmentRecord,
) -> bool:
    expected_slots = _slots_implied_by_name(record.name)
    actual_slots = {
        slot
        for slot, mask in ARMOR_PAGE_SLOT_MASKS.items()
        if record.slot_mask & mask
    }
    if len(expected_slots) != 1 or len(actual_slots) != 1:
        return False
    return _is_current_build_source_slot_misplacement_by_name(
        record.name,
        record.source_path,
        next(iter(actual_slots)),
        next(iter(expected_slots)),
    )


def _is_current_build_source_slot_misplacement(
    item_id: int,
    source_path: str,
    source_slot: str | None,
    expected_slot: str,
) -> bool:
    if source_slot is None:
        return False
    normalized_source_path = source_path.replace("\\", "/")
    return (
        item_id,
        normalized_source_path,
        source_slot,
        expected_slot,
    ) in CURRENT_BUILD_SOURCE_SLOT_MISPLACEMENT_EXCEPTIONS


def _is_current_build_source_slot_misplacement_by_name(
    name: str,
    source_path: str,
    source_slot: str | None,
    expected_slot: str,
) -> bool:
    if source_slot is None:
        return False
    normalized_source_path = source_path.replace("\\", "/")
    return any(
        stored_source_path == normalized_source_path
        and stored_source_slot == source_slot
        and stored_expected_slot == expected_slot
        and stored_name == name
        for (
            _item_id,
            stored_source_path,
            stored_source_slot,
            stored_expected_slot,
        ), stored_name in CURRENT_BUILD_SOURCE_SLOT_MISPLACEMENT_EXCEPTIONS.items()
    )


def _unexpected_client_name_collision_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    by_norm: dict[str, list[tuple[int, dict[str, Any]]]] = defaultdict(list)
    for item_id, row in catalog["client_items"].items():
        if not _client_item_has_equipment_shape(row):
            continue
        normalized = statsdb._normalize_catseye_equipment_name(str(row["name"]))
        if normalized:
            by_norm[normalized].append((item_id, row))

    findings: list[dict[str, Any]] = []
    for normalized, rows in sorted(by_norm.items()):
        if len(rows) <= 1 or client_collision_is_expected(rows, allow_special_cases=True):
            continue
        signatures = {
            (
                int(row["level"]),
                int(row["jobs"]),
                int(row["slot"]),
                int(row["skill"]),
                int(row["damage"]),
                int(row["delay"]),
                int(row["damage_type"]),
            )
            for _item_id, row in rows
        }
        if len(signatures) <= 1:
            continue
        findings.append(
            {
                "name": str(rows[0][1]["name"]),
                "issue": "Catseye client name collision is not shaped like an expected level-upgrade chain",
                "details": {
                    "normalized_name": normalized,
                    "item_ids": sorted(item_id for item_id, _row in rows),
                    "signature_count": len(signatures),
                    "signatures": sorted(signatures),
                },
            }
        )
    return findings


def _high_signal_skipped_effect_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        for fragment in skipped_effect_fragments_for_record(record):
            if fragment.label == "Unlabeled signed value":
                continue
            findings.append(
                {
                    "name": record.name,
                    "issue": "wiki stat text contains an unparsed high-signal effect fragment",
                    "details": {
                        "label": fragment.label,
                        "fragment": fragment.fragment,
                        "source_path": record.source_path,
                        "stats_text": record.stats_text,
                    },
                }
            )
    return findings


def _ambiguous_wiki_record_match_findings(
    records: tuple[statsdb.CatseyeEquipmentRecord, ...],
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection,
) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for record in records:
        normalized = statsdb._normalize_catseye_equipment_name(record.name)
        candidates = item_ids_by_name.get(normalized, set())
        if len(candidates) <= 1:
            continue
        item_id = statsdb._match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is not None:
            continue
        if _race_duplicate_equipment_candidate_ids(db, record, candidates):
            continue
        findings.append(
            {
                "name": record.name,
                "issue": "wiki record name maps to multiple DB items and scoring cannot choose one",
                "details": {
                    "normalized_name": normalized,
                    "candidate_item_ids": sorted(candidates),
                    "level": record.level,
                    "jobs": record.jobs_mask,
                    "slot": record.slot_mask,
                    "weapon_stats": statsdb.parse_wiki_weapon_stats(record.stats_text),
                    "source_path": record.source_path,
                    "stats_text": record.stats_text,
                },
            }
        )
    return findings


def _slot_names_for_mask(mask: int) -> list[str]:
    return [
        slot
        for slot, slot_mask in statsdb.EQUIPMENT_SLOT_MASKS.items()
        if mask & slot_mask
    ]


def _db_slot_name_lexical_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for item_id, equipment in sorted(catalog["equipment"].items()):
        if int(item_id) in CURRENT_BUILD_SLOT_NAME_LEXICAL_EXCEPTIONS:
            continue
        expected_slots = _slots_implied_by_name(str(equipment["name"]))
        if len(expected_slots) != 1:
            continue
        expected_slot = next(iter(expected_slots))
        expected_mask = ARMOR_PAGE_SLOT_MASKS[expected_slot]
        actual_slot = int(equipment["slot"])
        if actual_slot & expected_mask:
            continue
        actual_armor_slots = [
            slot
            for slot, mask in ARMOR_PAGE_SLOT_MASKS.items()
            if actual_slot & mask
        ]
        if not actual_armor_slots:
            continue
        findings.append(
            _finding(
                item_id=item_id,
                name=str(equipment["name"]),
                issue="DB equipment slot contradicts the armor slot implied by the item name",
                details={
                    "expected_slot_from_name": expected_slot,
                    "db_slots": actual_armor_slots,
                    "slot_mask": actual_slot,
                },
            )
        )
    return findings


def _client_slot_name_lexical_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for item_id, client in sorted(catalog["client_items"].items()):
        if int(item_id) in CURRENT_BUILD_SLOT_NAME_LEXICAL_EXCEPTIONS:
            continue
        if not _client_item_has_equipment_shape(client):
            continue
        expected_slots = _slots_implied_by_name(str(client["name"]))
        if len(expected_slots) != 1:
            continue
        expected_slot = next(iter(expected_slots))
        expected_mask = ARMOR_PAGE_SLOT_MASKS[expected_slot]
        actual_slot = int(client["slot"])
        if actual_slot & expected_mask:
            continue
        actual_armor_slots = [
            slot
            for slot, mask in ARMOR_PAGE_SLOT_MASKS.items()
            if actual_slot & mask
        ]
        if not actual_armor_slots:
            continue
        findings.append(
            _finding(
                item_id=item_id,
                name=str(client["name"]),
                issue="Catseye client resource slot contradicts the armor slot implied by the item name",
                details={
                    "expected_slot_from_name": expected_slot,
                    "client_slots": actual_armor_slots,
                    "slot_mask": actual_slot,
                },
            )
        )
    return findings


def _source_slot_guarded_override_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for item_id, override in sorted(catalog["equipment_overrides"].items()):
        expected_slots = _slots_implied_by_name(str(override.get("catseye_name") or _display_name(catalog, item_id) or ""))
        if len(expected_slots) != 1:
            continue
        source_slot = _armor_slot_from_source_path(str(override.get("source_path") or ""))
        if source_slot is None or source_slot in expected_slots:
            continue
        expected_slot = next(iter(expected_slots))
        if _is_current_build_source_slot_misplacement(
            item_id,
            str(override.get("source_path") or ""),
            source_slot,
            expected_slot,
        ):
            continue
        expected_mask = ARMOR_PAGE_SLOT_MASKS[expected_slot]
        original_slot = int(override.get("original_slot") or 0)
        catseye_slot = int(override.get("catseye_slot") or 0)
        if original_slot & expected_mask == 0 or catseye_slot & expected_mask == 0:
            continue
        findings.append(
            _finding(
                item_id=item_id,
                name=_display_name(catalog, item_id),
                issue="Catseye override preserved a name-consistent slot while its wiki source path names another slot",
                details={
                    "expected_slot_from_name": expected_slot,
                    "source_path_slot": source_slot,
                    "original_slots": _slot_names_for_mask(original_slot),
                    "catseye_slots": _slot_names_for_mask(catseye_slot),
                    "source_path": override.get("source_path"),
                },
            )
        )
    return findings


def _stat_override_slot_conflicting_source_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    seen: set[tuple[int, str]] = set()
    findings: list[dict[str, Any]] = []
    for (item_id, _mod_name), rows in sorted(catalog["stat_overrides"].items()):
        name = _display_name(catalog, item_id)
        expected_slots = _slots_implied_by_name(name or "")
        if len(expected_slots) != 1:
            continue
        expected_slot = next(iter(expected_slots))
        expected_mask = ARMOR_PAGE_SLOT_MASKS[expected_slot]
        trusted_slot = _trusted_db_slot_for_name(catalog, item_id, expected_mask)
        if trusted_slot & expected_mask == 0:
            continue
        for row in rows:
            source_path = str(row["source_path"])
            source_slot = _armor_slot_from_source_path(source_path)
            if source_slot is None or source_slot in expected_slots:
                continue
            if _is_current_build_source_slot_misplacement(
                item_id,
                source_path,
                source_slot,
                expected_slot,
            ):
                continue
            key = (item_id, source_path)
            if key in seen:
                continue
            seen.add(key)
            findings.append(
                _finding(
                    item_id=item_id,
                    name=name,
                    issue="Catseye stat overrides are sourced from a wiki page whose slot conflicts with the item name",
                    details={
                        "expected_slot_from_name": expected_slot,
                        "source_path_slot": source_slot,
                        "trusted_db_slots": _slot_names_for_mask(trusted_slot),
                        "source_path": source_path,
                        "source_text": row["source_text"],
                    },
                )
            )
    return findings


def _identity_equipment_override_findings(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    compared_fields = (
        ("level", "original_level", "catseye_level"),
        ("ilevel", "original_ilevel", "catseye_ilevel"),
        ("jobs", "original_jobs", "catseye_jobs"),
        ("slot", "original_slot", "catseye_slot"),
    )
    for item_id, override in sorted(catalog["equipment_overrides"].items()):
        if not all(
            int(override.get(original) or 0) == int(override.get(catseye) or 0)
            for _label, original, catseye in compared_fields
        ):
            continue
        findings.append(
            _finding(
                item_id=item_id,
                name=_display_name(catalog, item_id),
                issue="Catseye equipment override records no effective equipment field change",
                details={
                    label: int(override.get(original) or 0)
                    for label, original, _catseye in compared_fields
                }
                | {"source_path": override.get("source_path")},
            )
        )
    return findings


def _display_name(catalog: dict[str, Any], item_id: int) -> str | None:
    equipment = catalog["equipment"].get(item_id)
    if equipment is not None:
        return str(equipment["name"])
    item = catalog["items"].get(item_id)
    if item is not None:
        return str(item["name"])
    return None


def _finding(
    *,
    item_id: int,
    name: str | None,
    issue: str,
    details: dict[str, Any],
) -> dict[str, Any]:
    return {
        "item_id": item_id,
        "name": name,
        "issue": issue,
        "details": details,
    }


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    return db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone() is not None


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Catseye Equipment Inconsistency Sweep",
        "",
        "## Summary",
        "",
    ]
    for key, value in report["summary"].items():
        lines.append(f"- {key}: {value}")

    lines.extend(["", "## Techniques", ""])
    for technique in report["techniques"]:
        lines.append(f"- {technique}: {report['technique_summaries'][technique]['findings']}")

    lines.extend(["", "## Findings", ""])
    for technique in report["techniques"]:
        findings = report["findings"][technique]
        lines.extend(["", f"### {technique}", ""])
        if not findings:
            lines.append("- none")
            continue
        for finding in findings:
            item_id = finding.get("item_id")
            prefix = f"item_id={item_id} " if item_id is not None else ""
            lines.append(f"- {prefix}{finding.get('name') or '(unnamed)'}: {finding['issue']}")

    lines.extend(["", "## Sources", ""])
    for key, value in report["sources"].items():
        lines.append(f"- {key}: `{value}`")
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    raise SystemExit(main())
