from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import sqlite3
from typing import Iterable

from . import catseye_wiki_stats as wiki_stats
from .statsdb import (
    CATSEYE_MANUAL_REVIEW_EFFECT_PATTERNS,
    CATSEYE_SERVER_AUTHORITY_MODS,
    CatseyeEquipmentRecord,
    EQUIPMENT_SLOT_MASKS,
    _build_equipment_item_name_index,
    _iter_catseye_equipment_records,
    _match_catseye_equipment_item_id,
    _normalize_catseye_equipment_name,
    _prefer_catseye_stat_value,
    _resolve_catseye_pages_root,
    _select_catseye_equipment_record,
)


STAT_MOD_IDS = {
    "DEF": 1,
    "HP": 2,
    "MP": 5,
    "STR": 8,
    "DEX": 9,
    "VIT": 10,
    "AGI": 11,
    "INT": 12,
    "MND": 13,
    "CHR": 14,
    "ATT": 23,
    "RATT": 24,
    "ACC": 25,
    "RACC": 26,
    "ENMITY": 27,
    "MATT": 28,
    "MACC": 30,
    "STORETP": 73,
    "DMG": 160,
    "DMGPHYS": 161,
    "DMGMAGIC": 163,
    "SPELLINTERRUPT": 168,
    "FASTCAST": 170,
    "DOUBLE_ATTACK": 288,
    "TRIPLE_ATTACK": 302,
    "MAGIC_DAMAGE": 311,
    "FIRE_STAFF_BONUS": 347,
    "ICE_STAFF_BONUS": 348,
    "WIND_STAFF_BONUS": 349,
    "EARTH_STAFF_BONUS": 350,
    "THUNDER_STAFF_BONUS": 351,
    "WATER_STAFF_BONUS": 352,
    "LIGHT_STAFF_BONUS": 353,
    "DARK_STAFF_BONUS": 354,
    "REFRESH": 369,
    "REGEN": 370,
    "CURE_POTENCY": 374,
    "HASTE_GEAR": 384,
    "ENSPELL_DMG_BONUS": 432,
    "SONG_DURATION_BONUS": 454,
    "MYTHIC_OCC_ATT_TWICE": 865,
    "ENH_MAGIC_DURATION": 890,
    "DOUBLE_ATTACK_DMG": 1038,
    "PHALANX_RECEIVED": 1182,
}

ELEMENTAL_STAFF_BONUS_MODS = (
    "FIRE_STAFF_BONUS",
    "ICE_STAFF_BONUS",
    "WIND_STAFF_BONUS",
    "EARTH_STAFF_BONUS",
    "THUNDER_STAFF_BONUS",
    "WATER_STAFF_BONUS",
    "LIGHT_STAFF_BONUS",
    "DARK_STAFF_BONUS",
)

STAT_MOD_IDS = wiki_stats.STAT_MOD_IDS
DIRECT_STAT_MODS = wiki_stats.DIRECT_STAT_MODS
IGNORED_DIRECT_MOD_EXTRAS = {
    # Wiki pages often omit elemental resistance side stats on retail-derived
    # gear. Keep the audit focused on player-visible direct combat stats.
}
RACE_DUPLICATE_VARIANT_MODS = {"EQUIPMENT_ONLY_RACE"}
WEAPON_SLOT_MASK = 1 | 2 | 4 | 1024
ARMOR_SLOT_NAME_TOKENS = {
    "Head": ("cap", "crown", "hat", "headband", "helm", "helmet", "hairpin", "mask", "sallet", "tiara", "turban", "visor"),
    "Body": ("apron", "bliaut", "breastplate", "coat", "cuirass", "doublet", "harness", "jacket", "jerkin", "jubbah", "mail", "robe", "samue", "tunic", "vest"),
    "Hands": ("bangles", "cuffs", "dastanas", "finger", "gauntlets", "gloves", "handschuhs", "kote", "mittens", "mitts", "wristbands"),
    "Legs": ("breeches", "cuisses", "hakama", "hose", "kecks", "pants", "slacks", "subligar", "tights", "trousers"),
    "Feet": ("boots", "duckbills", "feet", "gaiters", "gamashes", "greaves", "leggings", "ledelsens", "pumps", "sabatons", "sandals", "shoes", "sune-ate"),
}
ARMOR_SLOT_MASKS = {
    slot: EQUIPMENT_SLOT_MASKS[slot]
    for slot in ARMOR_SLOT_NAME_TOKENS
}

WIKI_WEAPON_RE = re.compile(r"\bDMG:?\s*(?P<damage>\d+)\s+Delay:?\s*(?P<delay>\d+)", re.IGNORECASE)
WIKI_SIGNED_RE = re.compile(r"(?P<label>Enmity)\s*(?P<value>[+-]\d+)", re.IGNORECASE)
WIKI_ALL_ELEMENTS_AFFINITY_RE = re.compile(r"\ball\s+elements?\s+affinity\s*\+?\s*(\d+)", re.IGNORECASE)
WIKI_DOUBLE_ATTACK_DAMAGE_RE = re.compile(
    r"\b(?:increases\s+)?\"?double\s+attack\"?\s+damage(?:\s*\+?\s*(\d+)\s*%?)?",
    re.IGNORECASE,
)
WIKI_OCC_ATTACKS_TWICE_RE = re.compile(r"\boccasionally\s+attacks\s+twice\b", re.IGNORECASE)
WIKI_HIDDEN_KILLER_EFFECT_RE = re.compile(
    r'\bHidden Effect:\s*"?[A-Za-z]+\s+Killer"?\s*[+-]\s*\d+(?!\s*~)',
    re.IGNORECASE,
)
MANUAL_REVIEW_COVERAGE_RES = (
    WIKI_ALL_ELEMENTS_AFFINITY_RE,
    WIKI_OCC_ATTACKS_TWICE_RE,
    wiki_stats.WIKI_OCC_ATTACKS_RANGE_RE,
    WIKI_DOUBLE_ATTACK_DAMAGE_RE,
    WIKI_HIDDEN_KILLER_EFFECT_RE,
    *(pattern for _effect_tag, pattern, _target, _note in CATSEYE_MANUAL_REVIEW_EFFECT_PATTERNS),
)


@dataclass(frozen=True)
class CatalogFinding:
    severity: str
    kind: str
    item_name: str
    item_id: int | None
    source_path: str
    field: str
    wiki_value: object
    db_value: object
    message: str
    source_text: str


@dataclass(frozen=True)
class CatalogAuditResult:
    summary: dict[str, int]
    findings: tuple[CatalogFinding, ...]
    output_dir: Path | None = None
    json_path: Path | None = None
    markdown_path: Path | None = None


def audit_catseye_equipment_catalog(
    *,
    db_path: Path | str,
    catseye_wiki_root: Path | str,
    output_root: Path | str,
    write_files: bool = True,
) -> CatalogAuditResult:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        raise FileNotFoundError(f"Catseye wiki equipment pages not found: {catseye_wiki_root}")

    findings: list[CatalogFinding] = []
    summary: dict[str, int] = {
        "records": 0,
        "matched": 0,
        "unmatched": 0,
        "ambiguous": 0,
        "equipment_mismatches": 0,
        "weapon_checks": 0,
        "weapon_mismatches": 0,
        "stat_checks": 0,
        "stat_mismatches": 0,
        "manual_coverage": 0,
        "manual_review": 0,
    }

    db = sqlite3.connect(db_path)
    try:
        item_ids_by_name = _build_equipment_item_name_index(db)
        manual_coverage_by_name = _augment_path_manual_coverage_by_name(db)
        matched_records_by_item_id: dict[int, list[CatseyeEquipmentRecord]] = {}
        for record in _iter_catseye_equipment_records(pages_root):
            summary["records"] += 1
            item_id = _match_catseye_equipment_item_id(record, item_ids_by_name, db)
            if item_id is None:
                normalized = _normalize_catseye_equipment_name(record.name)
                candidates = item_ids_by_name.get(normalized, set())
                manual_coverage = manual_coverage_by_name.get(normalized)
                if manual_coverage is not None:
                    summary["manual_coverage"] += 1
                    findings.append(
                        _finding(
                            "info",
                            "manual_coverage_augment_path",
                            record.name,
                            manual_coverage["item_id"],
                            record.source_path,
                            "item_id",
                            record.name,
                            {
                                "base_item_id": manual_coverage["item_id"],
                                "effect_tag": manual_coverage["effect_tag"],
                            },
                            "Wiki path variant is covered by a manual augment-path tag on the base item.",
                            record.stats_text,
                        )
                    )
                    continue
                if len(candidates) > 1:
                    duplicate_item_ids = _race_duplicate_equipment_candidate_ids(db, record, candidates)
                    if duplicate_item_ids:
                        summary["matched"] += 1
                        for duplicate_item_id in duplicate_item_ids:
                            matched_records_by_item_id.setdefault(duplicate_item_id, []).append(record)
                        continue
                    summary["ambiguous"] += 1
                    findings.append(
                        _finding(
                            "warning",
                            "ambiguous_name",
                            record.name,
                            None,
                            record.source_path,
                            "item_id",
                            record.name,
                            sorted(candidates),
                            "Wiki item name matches multiple DB item ids.",
                            record.stats_text,
                        )
                    )
                else:
                    summary["unmatched"] += 1
                    findings.append(
                        _finding(
                            "error",
                            "unmatched_name",
                            record.name,
                            None,
                            record.source_path,
                            "item_id",
                            record.name,
                            None,
                            "Wiki item name does not match an equipment item in the DB.",
                            record.stats_text,
                        )
                    )
                continue

            summary["matched"] += 1
            matched_records_by_item_id.setdefault(item_id, []).append(record)

        for item_id, records in sorted(matched_records_by_item_id.items()):
            record = _select_audit_record(db, item_id, records)
            _audit_equipment_row(db, record, item_id, findings, summary)
            _audit_weapon_stats(db, record, item_id, findings, summary)
            _audit_item_mods(db, record, item_id, findings, summary)
            _audit_manual_review(record, item_id, findings, summary)
    finally:
        db.close()

    result = CatalogAuditResult(summary=summary, findings=tuple(findings))
    if not write_files:
        return result

    output_dir = Path(output_root) / _timestamp()
    output_dir.mkdir(parents=True, exist_ok=True)
    json_path = output_dir / "catalog_audit.json"
    markdown_path = output_dir / "catalog_audit.md"
    json_path.write_text(_audit_json(result), encoding="utf-8")
    markdown_path.write_text(_audit_markdown(result), encoding="utf-8")
    return CatalogAuditResult(
        summary=summary,
        findings=tuple(findings),
        output_dir=output_dir,
        json_path=json_path,
        markdown_path=markdown_path,
    )


def _race_duplicate_equipment_candidate_ids(
    db: sqlite3.Connection,
    record: CatseyeEquipmentRecord,
    candidates: set[int],
) -> tuple[int, ...]:
    expected_mods = parse_wiki_stat_mods(record.stats_text)
    expected_weapon = parse_wiki_weapon_stats(record.stats_text)
    profiles: list[tuple[object, ...]] = []

    for item_id in sorted(candidates):
        row = db.execute(
            """
            select level, ilevel, jobs, slot, script_type
            from item_equipment
            where item_id = ?
            """,
            (item_id,),
        ).fetchone()
        if row is None:
            return tuple()

        level, ilevel, jobs, slot, script_type = (int(value) for value in row)
        if (level, jobs, slot) != (record.level, record.jobs_mask, record.slot_mask):
            return tuple()

        weapon_profile: tuple[int, int] | None = None
        if expected_weapon:
            weapon_row = db.execute(
                "select damage, delay from item_weapon where item_id = ?",
                (item_id,),
            ).fetchone()
            if weapon_row is None:
                return tuple()
            weapon_profile = (int(weapon_row[0]), int(weapon_row[1]))
            if weapon_profile != (expected_weapon["damage"], expected_weapon["delay"]):
                return tuple()

        mods = {
            mod_name: value
            for mod_name, value in _item_mods_by_name(db, item_id).items()
            if mod_name not in RACE_DUPLICATE_VARIANT_MODS
        }
        for mod_name, expected_value in expected_mods.items():
            if mods.get(mod_name) != expected_value:
                return tuple()

        profiles.append(
            (
                level,
                ilevel,
                jobs,
                slot,
                script_type,
                weapon_profile,
                tuple(sorted(mods.items())),
            )
        )

    if len(set(profiles)) != 1:
        return tuple()
    return tuple(sorted(candidates))


def _augment_path_manual_coverage_by_name(db: sqlite3.Connection) -> dict[str, dict[str, object]]:
    try:
        rows = db.execute(
            """
            select item_id, effect_tag, source_text
            from catseye_equipment_effect_tags
            where status = 'manual_review'
              and target = 'augment_path'
            """
        )
    except sqlite3.OperationalError:
        return {}

    coverage: dict[str, dict[str, object]] = {}
    for item_id, effect_tag, source_text in rows:
        path_name = str(source_text).split(":", 1)[0].strip()
        normalized = _normalize_catseye_equipment_name(path_name)
        if not normalized:
            continue
        coverage[normalized] = {
            "item_id": int(item_id),
            "effect_tag": str(effect_tag),
        }
    return coverage


def parse_wiki_weapon_stats(stats_text: str) -> dict[str, int]:
    return wiki_stats.parse_wiki_weapon_stats(stats_text)


def parse_wiki_stat_mods(stats_text: str) -> dict[str, int]:
    return wiki_stats.parse_wiki_stat_mods(stats_text)


def _select_audit_record(
    db: sqlite3.Connection,
    item_id: int,
    records: list[CatseyeEquipmentRecord],
) -> CatseyeEquipmentRecord:
    if len(records) == 1:
        return records[0]

    existing = db.execute(
        "select name, level, ilevel, jobs, slot from item_equipment where item_id = ?",
        (item_id,),
    ).fetchone()
    if existing is None:
        return records[0]

    return _select_catseye_equipment_record(records, existing)


def _numeric_patterns() -> tuple[tuple[str, str, int], ...]:
    return (
        ("DEF", r"\bDEF[:+]\s*(-?\d+)(?!\s*~)", 1),
        ("HP", r"\bHP\+(-?\d+)(?!\s*~)", 1),
        ("MP", r"\bMP\+(-?\d+)(?!\s*~)", 1),
        ("STR", r"\bSTR\+(-?\d+)(?!\s*~)", 1),
        ("DEX", r"\bDEX\+(-?\d+)(?!\s*~)", 1),
        ("VIT", r"\bVIT\+(-?\d+)(?!\s*~)", 1),
        ("AGI", r"\bAGI\+(-?\d+)(?!\s*~)", 1),
        ("INT", r"\bINT\+(-?\d+)(?!\s*~)", 1),
        ("MND", r"\bMND\+(-?\d+)(?!\s*~)", 1),
        ("CHR", r"\bCHR\+(-?\d+)(?!\s*~)", 1),
        ("MACC", r"\bMagic Accuracy\+(-?\d+)(?!\s*~)", 1),
        ("MATT", r"\b\"?Magic Atk\.? Bonus\"?\+(-?\d+)(?!\s*~)", 1),
        ("MATT", r"\bMagic Attack Bonus\+(-?\d+)(?!\s*~)", 1),
        ("RACC", r"\bRanged Accuracy\+(-?\d+)(?!\s*~)", 1),
        ("RATT", r"\bRanged Attack\+(-?\d+)(?!\s*~)", 1),
        ("ACC", r"(?<!Magic )(?<!Ranged )\bAccuracy\+(-?\d+)(?!\s*~)", 1),
        ("ATT", r"(?<!Magic )(?<!Ranged )\bAttack\+(-?\d+)(?!\s*~)", 1),
        ("CURE_POTENCY", r"\bCure potency\s*\+(-?\d+)%(?!\s*~)", 1),
        ("FASTCAST", r"\bFast Cast\+(-?\d+)%(?!\s*~)", 1),
        ("HASTE_GEAR", r"\bHaste\+(-?\d+)%(?!\s*~)", 100),
        ("SPELLINTERRUPT", r"\bSpell interruption rate down\s*(-?\d+)%(?!\s*~)", 1),
        ("STORETP", r"\bStore TP\+(-?\d+)(?!\s*~)", 1),
        ("DOUBLE_ATTACK", r"\bDouble Attack\+(-?\d+)%(?!\s*~)", 1),
        ("TRIPLE_ATTACK", r"\bTriple Attack\+(-?\d+)%(?!\s*~)", 1),
        ("REFRESH", r"\bRefresh\+(-?\d+)(?!\s*~)", 1),
        ("REGEN", r"\bRegen\+(-?\d+)(?!\s*~)", 1),
        ("MAGIC_DAMAGE", r"\bMagic Damage\+(-?\d+)(?!\s*~)", 1),
        ("MAGIC_DAMAGE", r"\bMagic dmg\.?\s*\+(-?\d+)(?!\s*~)", 1),
        ("DMG", r"\bDamage taken\s*(-\d+)%(?!\s*~)", 100),
        ("DMGPHYS", r"\bPhysical damage taken\s*(-\d+)%(?!\s*~)", 100),
        ("DMGMAGIC", r"\bMagic dmg\. taken\s*(-\d+)%(?!\s*~)", 100),
        ("ENH_MAGIC_DURATION", r"\bEnhancing magic duration\s*\+(-?\d+)%(?!\s*~)", 1),
        ("SONG_DURATION_BONUS", r"\bSong effect duration\s*\+(-?\d+)%(?!\s*~)", 1),
        ("ENSPELL_DMG_BONUS", r"\bSword enhancement spell damage\+(-?\d+)(?!\s*~)", 1),
        ("PHALANX_RECEIVED", r"\bPhalanx\+(-?\d+)(?!\s*~)", 1),
    )


def _audit_equipment_row(
    db: sqlite3.Connection,
    record,
    item_id: int,
    findings: list[CatalogFinding],
    summary: dict[str, int],
) -> None:
    row = db.execute(
        "select level, ilevel, jobs, slot from item_equipment where item_id = ?",
        (item_id,),
    ).fetchone()
    if row is None:
        findings.append(
            _finding(
                "error",
                "missing_equipment_row",
                record.name,
                item_id,
                record.source_path,
                "item_equipment",
                "present",
                None,
                "Matched item has no item_equipment row.",
                record.stats_text,
            )
        )
        summary["equipment_mismatches"] += 1
        return

    level, _ilevel, jobs, slot = (int(value) for value in row)
    expected = {
        "level": record.level,
        "jobs": record.jobs_mask,
        "slot": record.slot_mask,
    }
    actual = {
        "level": level,
        "jobs": jobs,
        "slot": slot,
    }
    for field, wiki_value in expected.items():
        db_value = actual[field]
        if _should_trust_name_consistent_slot(record, field, wiki_value, db_value):
            continue
        if wiki_value != db_value:
            summary["equipment_mismatches"] += 1
            findings.append(
                _finding(
                    "error",
                    "equipment_mismatch",
                    record.name,
                    item_id,
                    record.source_path,
                    field,
                    wiki_value,
                    db_value,
                    "Wiki equipment field differs from item_equipment.",
                    record.stats_text,
                )
            )


def _should_trust_name_consistent_slot(
    record: CatseyeEquipmentRecord,
    field: str,
    wiki_value: int,
    db_value: int,
) -> bool:
    if field != "slot":
        return False
    expected_slots = _slots_implied_by_item_name(record.name)
    if len(expected_slots) != 1:
        return False
    expected_slot = next(iter(expected_slots))
    expected_mask = ARMOR_SLOT_MASKS[expected_slot]
    if db_value & expected_mask == 0 or wiki_value & expected_mask:
        return False
    source_slot = _armor_slot_from_source_path(record.source_path)
    return source_slot is not None and source_slot != expected_slot


def _slots_implied_by_item_name(name: str) -> set[str]:
    name_tokens = set(re.findall(r"[a-z0-9]+", name.lower()))
    slots = set()
    for slot, slot_tokens in ARMOR_SLOT_NAME_TOKENS.items():
        if any(token in name_tokens for token in slot_tokens):
            slots.add(slot)
    return slots


def _armor_slot_from_source_path(source_path: str) -> str | None:
    stem = Path(source_path).stem
    if "_Equipment_" not in stem:
        return None
    suffix = stem.rsplit("_Equipment_", 1)[-1].replace("_", " ")
    return suffix if suffix in ARMOR_SLOT_MASKS else None


def _audit_weapon_stats(
    db: sqlite3.Connection,
    record,
    item_id: int,
    findings: list[CatalogFinding],
    summary: dict[str, int],
) -> None:
    expected = parse_wiki_weapon_stats(record.stats_text)
    if not expected:
        return

    row = db.execute(
        "select damage, delay from item_weapon where item_id = ?",
        (item_id,),
    ).fetchone()
    if row is None and not _is_weapon_slot(record.slot_mask):
        return
    actual = None if row is None else {"damage": int(row[0]), "delay": int(row[1])}
    for field, wiki_value in expected.items():
        summary["weapon_checks"] += 1
        db_value = None if actual is None else actual[field]
        if wiki_value != db_value:
            summary["weapon_mismatches"] += 1
            summary["stat_mismatches"] += 1
            findings.append(
                _finding(
                    "error",
                    "weapon_stat_mismatch",
                    record.name,
                    item_id,
                    record.source_path,
                    field,
                    wiki_value,
                    db_value,
                    "Wiki weapon stat differs from item_weapon.",
                    record.stats_text,
                )
            )


def _audit_item_mods(
    db: sqlite3.Connection,
    record,
    item_id: int,
    findings: list[CatalogFinding],
    summary: dict[str, int],
) -> None:
    expected = parse_wiki_stat_mods(record.stats_text)
    actual = _item_mods_by_name(db, item_id)
    scored_effect_mods = _scored_effect_mods_by_name(db, item_id)

    for mod_name, wiki_value in sorted(expected.items()):
        summary["stat_checks"] += 1
        db_value = actual.get(mod_name)
        if db_value != wiki_value:
            if _server_authority_mod_covers_mismatch(mod_name, wiki_value, db_value):
                summary["manual_coverage"] += 1
                findings.append(
                    _finding(
                        "info",
                        "manual_coverage_server_authority_mod",
                        record.name,
                        item_id,
                        record.source_path,
                        mod_name,
                        wiki_value,
                        db_value,
                        "Current Catseye server DB has a stronger value than the wiki; accepted as server-authoritative.",
                        record.stats_text,
                    )
                )
                continue
            summary["stat_mismatches"] += 1
            findings.append(
                _finding(
                    "error",
                    "item_mod_mismatch",
                    record.name,
                    item_id,
                    record.source_path,
                    mod_name,
                    wiki_value,
                    db_value,
                    "Wiki stat is missing from item_mods." if db_value is None else "Wiki stat differs from item_mods.",
                    record.stats_text,
                )
            )

    for mod_name, db_value in sorted(actual.items()):
        if mod_name not in DIRECT_STAT_MODS or mod_name in IGNORED_DIRECT_MOD_EXTRAS:
            continue
        if mod_name in expected:
            continue
        if scored_effect_mods.get(mod_name) == db_value:
            summary["manual_coverage"] += 1
            findings.append(
                _finding(
                    "info",
                    "manual_coverage_scored_effect_mod",
                    record.name,
                    item_id,
                    record.source_path,
                    mod_name,
                    None,
                    db_value,
                    "Scored Catseye effect tag covers this server-backed direct stat.",
                    record.stats_text,
                )
            )
            continue
        summary["stat_mismatches"] += 1
        findings.append(
            _finding(
                "warning",
                "db_extra_direct_mod",
                record.name,
                item_id,
                record.source_path,
                mod_name,
                None,
                db_value,
                "item_mods contains a comparable direct stat not present in the wiki record.",
                record.stats_text,
            )
        )


def _audit_manual_review(record, item_id: int, findings: list[CatalogFinding], summary: dict[str, int]) -> None:
    review_lines = []
    for line in _stats_lines(record.stats_text):
        lower = line.lower()
        if any(token in lower for token in ("latent", "hidden", "additional effect", "enhances", "domain incursion")):
            parsed = _manual_review_line_has_coverage(line)
            if not parsed:
                review_lines.append(line)
    if not review_lines:
        return

    summary["manual_review"] += 1
    findings.append(
        _finding(
            "info",
            "manual_review_effect",
            record.name,
            item_id,
            record.source_path,
            "stats_text",
            review_lines,
            None,
            "Wiki record contains special/conditional effect text that was not parsed as a direct stat.",
            record.stats_text,
        )
    )


def _manual_review_line_has_coverage(line: str) -> bool:
    return bool(
        wiki_stats.parse_wiki_conditional_stat_mods(line)
        or any(pattern.search(line) for pattern in MANUAL_REVIEW_COVERAGE_RES)
    )


def _item_mods_by_name(db: sqlite3.Connection, item_id: int) -> dict[str, int]:
    mods: dict[str, int] = {}
    for mod_name, value in db.execute(
        "select mod_name, value from item_mods where item_id = ?",
        (item_id,),
    ):
        mods[str(mod_name)] = mods.get(str(mod_name), 0) + int(value)
    return mods


def _server_authority_mod_covers_mismatch(mod_name: str, wiki_value: int, db_value: int | None) -> bool:
    return (
        db_value is not None
        and mod_name in CATSEYE_SERVER_AUTHORITY_MODS
        and not _prefer_catseye_stat_value(wiki_value, db_value)
    )


def _scored_effect_mods_by_name(db: sqlite3.Connection, item_id: int) -> dict[str, int]:
    try:
        rows = db.execute(
            """
            select mod_name, value
            from catseye_equipment_effect_tags
            where item_id = ?
              and status = 'scored'
              and mod_name is not null
              and value is not null
            """,
            (item_id,),
        )
    except sqlite3.OperationalError:
        return {}

    mods: dict[str, int] = {}
    for mod_name, value in rows:
        mods[str(mod_name)] = mods.get(str(mod_name), 0) + int(value)
    return mods


def _is_weapon_slot(slot_mask: int) -> bool:
    return bool(int(slot_mask) & WEAPON_SLOT_MASK)


def _comparable_stats_text(stats_text: str) -> str:
    return " ".join(_comparable_stat_lines(stats_text))


def _comparable_stat_lines(stats_text: str) -> list[str]:
    lines = []
    for line in _stats_lines(stats_text):
        lower = line.lower()
        if "augrank" in lower or re.search(r"[+-]?\d+\s*~\s*[+-]?\d+", line):
            continue
        if "latent effect" in lower or "latent activation" in lower:
            continue
        lines.append(line)
    return lines


def _stats_lines(stats_text: str) -> list[str]:
    return [line.strip() for line in stats_text.replace("\u00a0", " ").splitlines() if line.strip()]


def _add_mod(mods: dict[str, int], mod_name: str, value: int) -> None:
    mods[mod_name] = mods.get(mod_name, 0) + value


def _finding(
    severity: str,
    kind: str,
    item_name: str,
    item_id: int | None,
    source_path: str,
    field: str,
    wiki_value: object,
    db_value: object,
    message: str,
    source_text: str,
) -> CatalogFinding:
    return CatalogFinding(
        severity=severity,
        kind=kind,
        item_name=item_name,
        item_id=item_id,
        source_path=source_path,
        field=field,
        wiki_value=wiki_value,
        db_value=db_value,
        message=message,
        source_text=source_text,
    )


def _audit_json(result: CatalogAuditResult) -> str:
    return json.dumps(
        {
            "summary": result.summary,
            "findings": [asdict(finding) for finding in result.findings],
        },
        indent=2,
        sort_keys=True,
    )


def _audit_markdown(result: CatalogAuditResult) -> str:
    lines = [
        "# Catseye Equipment Catalog Audit",
        "",
        "## Summary",
        "",
    ]
    for key, value in result.summary.items():
        lines.append(f"- {key}: {value}")

    lines.extend(["", "## Findings", ""])
    for finding in result.findings[:500]:
        item_id = "" if finding.item_id is None else f" #{finding.item_id}"
        lines.append(
            f"- [{finding.severity}] {finding.kind}: {finding.item_name}{item_id} "
            f"`{finding.field}` wiki=`{finding.wiki_value}` db=`{finding.db_value}` "
            f"({finding.source_path}) - {finding.message}"
        )
    if len(result.findings) > 500:
        lines.append(f"- Omitted {len(result.findings) - 500} additional findings from Markdown; see JSON.")
    lines.append("")
    return "\n".join(lines)


def _timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
