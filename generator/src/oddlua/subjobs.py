from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import sqlite3
from typing import Mapping


SUBJOB_LEVEL = 37

JOB_IDS = {
    "WAR": 1,
    "MNK": 2,
    "WHM": 3,
    "BLM": 4,
    "RDM": 5,
    "THF": 6,
    "PLD": 7,
    "DRK": 8,
    "BST": 9,
    "BRD": 10,
    "RNG": 11,
    "SAM": 12,
    "NIN": 13,
    "DRG": 14,
    "SMN": 15,
    "BLU": 16,
    "COR": 17,
    "PUP": 18,
    "DNC": 19,
    "SCH": 20,
    "GEO": 21,
    "RUN": 22,
}

VIABLE_SUBJOBS_BY_MAIN_JOB = {
    "WAR": ("NIN", "SAM", "DNC", "THF", "MNK"),
    "MNK": ("WAR", "NIN", "DNC", "THF", "SAM"),
    "WHM": ("SCH", "RDM", "BLM", "SMN", "NIN"),
    "BLM": ("RDM", "WHM", "SCH", "NIN", "SMN"),
    "RDM": ("NIN", "THF", "SCH", "WHM", "BLM", "DNC", "WAR"),
    "THF": ("NIN", "WAR", "DNC", "RNG", "SAM"),
    "PLD": ("WAR", "NIN", "RDM", "DNC", "WHM", "BLU"),
    "DRK": ("SAM", "WAR", "NIN", "THF", "DNC", "WHM"),
    "BST": ("DNC", "NIN", "WAR", "WHM", "THF"),
    "BRD": ("WHM", "NIN", "RDM", "DNC", "BLM"),
    "RNG": ("NIN", "WAR", "SAM", "THF", "DNC"),
    "SAM": ("WAR", "NIN", "DNC", "RNG", "THF"),
    "NIN": ("WAR", "DNC", "THF", "RNG", "SAM"),
    "DRG": ("SAM", "WAR", "NIN", "DNC", "WHM", "BLU"),
    "SMN": ("WHM", "RDM", "SCH", "BLM", "NIN"),
    "BLU": ("NIN", "WAR", "DNC", "THF", "RDM", "WHM"),
    "COR": ("NIN", "RNG", "DNC", "WHM", "WAR"),
    "PUP": ("WAR", "NIN", "DNC", "THF", "WHM"),
    "DNC": ("NIN", "WAR", "SAM", "THF", "WHM"),
    "SCH": ("RDM", "WHM", "BLM", "NIN", "SMN"),
    "GEO": ("RDM", "WHM", "BLM", "NIN", "SCH"),
    "RUN": ("WAR", "NIN", "SAM", "DNC", "WHM", "BLU"),
}

BASE_CAPABILITIES_BY_SUBJOB = {
    "WAR": ("provoke", "attack_boost", "defense_boost", "melee_burst"),
    "MNK": ("counter", "max_hp", "martial_arts", "boost"),
    "WHM": ("cure", "status_removal", "protect_shell", "sneak_invisible"),
    "BLM": ("elemental_magic", "warp", "sleep", "magic_burst"),
    "RDM": ("fast_cast", "cure", "enfeeble", "enhancing", "sneak_invisible"),
    "THF": ("sneak_attack", "treasure_hunter", "evasion", "flee", "dual_wield"),
    "PLD": ("sentinel", "shield", "cure", "defense_boost"),
    "DRK": ("last_resort", "souleater", "dark_magic", "attack_boost"),
    "BST": ("charm", "reward", "pet_utility"),
    "BRD": ("song", "support", "resist_status"),
    "RNG": ("ranged_accuracy", "sharpshot", "scavenge"),
    "SAM": ("store_tp", "meditate", "third_eye", "weapon_skill"),
    "NIN": ("dual_wield", "shadows", "ninjutsu", "subtle_blow", "daken"),
    "DRG": ("jump", "attack_bonus", "accuracy_bonus"),
    "SMN": ("auto_refresh", "avatar_support", "mp_sustain"),
    "BLU": ("cocoon", "blue_utility", "healing_breeze", "wild_carrot"),
    "COR": ("roll", "ranged_accuracy", "quick_draw"),
    "PUP": ("automaton", "pet_utility"),
    "DNC": ("waltz", "samba", "steps", "dual_wield"),
    "SCH": ("light_arts", "dark_arts", "sublimation", "stratagems"),
    "GEO": ("geomancy", "elemental_debuff"),
    "RUN": ("runes", "magic_defense", "foil"),
}


@dataclass(frozen=True)
class SubjobAbility:
    name: str
    level: int
    recast_time: int
    recast_id: int
    ce: int
    ve: int

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "name": self.name,
            "level": self.level,
            "recastTime": self.recast_time,
            "recastId": self.recast_id,
            "ce": self.ce,
            "ve": self.ve,
        }


@dataclass(frozen=True)
class SubjobTrait:
    name: str
    level: int
    rank: int
    mod_name: str
    value: int

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "name": self.name,
            "level": self.level,
            "rank": self.rank,
            "modName": self.mod_name,
            "value": self.value,
        }


@dataclass(frozen=True)
class SubjobSpell:
    name: str
    level: int
    mp_cost: int
    cast_time: int
    recast_time: int

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "name": self.name,
            "level": self.level,
            "mpCost": self.mp_cost,
            "castTime": self.cast_time,
            "recastTime": self.recast_time,
        }


@dataclass(frozen=True)
class SubjobProfile:
    abbr: str
    level: int
    capabilities: tuple[str, ...]
    abilities: tuple[SubjobAbility, ...]
    traits: tuple[SubjobTrait, ...]
    spells: tuple[SubjobSpell, ...]

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "abbr": self.abbr,
            "level": self.level,
            "capabilities": list(self.capabilities),
            "abilities": [ability.manifest_metadata() for ability in self.abilities],
            "traits": [trait.manifest_metadata() for trait in self.traits],
            "spells": [spell.manifest_metadata() for spell in self.spells],
        }


def build_subjob_profiles(
    main_job: str,
    *,
    db_path: Path | str | None = None,
    subjob_level: int = SUBJOB_LEVEL,
) -> dict[str, SubjobProfile]:
    normalized_main = main_job.upper()
    viable_subjobs = VIABLE_SUBJOBS_BY_MAIN_JOB.get(normalized_main, tuple())
    if db_path is None:
        return {
            subjob: _empty_profile(subjob, subjob_level)
            for subjob in viable_subjobs
        }

    path = Path(db_path)
    if not path.exists():
        return {
            subjob: _empty_profile(subjob, subjob_level)
            for subjob in viable_subjobs
        }

    db = sqlite3.connect(path)
    try:
        db.row_factory = sqlite3.Row
        has_abilities = _has_table(db, "abilities")
        has_traits = _has_table(db, "traits")
        has_spells = _has_table(db, "spells")

        profiles: dict[str, SubjobProfile] = {}
        for subjob in viable_subjobs:
            job_id = JOB_IDS[subjob]
            abilities = _load_subjob_abilities(db, job_id, subjob_level) if has_abilities else tuple()
            traits = _load_subjob_traits(db, job_id, subjob_level) if has_traits else tuple()
            spells = _load_subjob_spells(db, job_id, subjob_level) if has_spells else tuple()
            profiles[subjob] = SubjobProfile(
                abbr=subjob,
                level=subjob_level,
                capabilities=_derive_capabilities(subjob, abilities, traits, spells),
                abilities=abilities,
                traits=traits,
                spells=spells,
            )
        return profiles
    finally:
        db.close()


def subjob_manifest(profiles: Mapping[str, SubjobProfile]) -> dict[str, object]:
    return {
        subjob: profile.manifest_metadata()
        for subjob, profile in profiles.items()
    }


def _empty_profile(subjob: str, level: int) -> SubjobProfile:
    return SubjobProfile(
        abbr=subjob,
        level=level,
        capabilities=BASE_CAPABILITIES_BY_SUBJOB.get(subjob, tuple()),
        abilities=tuple(),
        traits=tuple(),
        spells=tuple(),
    )


def _load_subjob_abilities(db: sqlite3.Connection, job_id: int, level: int) -> tuple[SubjobAbility, ...]:
    rows = db.execute(
        """
        select name, level, recast_time, recast_id, ce, ve
        from abilities
        where job = ? and level > 0 and level <= ?
        order by level, ability_id
        """,
        (job_id, level),
    ).fetchall()
    return tuple(
        SubjobAbility(
            name=str(row["name"]),
            level=int(row["level"]),
            recast_time=int(row["recast_time"]),
            recast_id=int(row["recast_id"]),
            ce=int(row["ce"]),
            ve=int(row["ve"]),
        )
        for row in rows
    )


def _load_subjob_traits(db: sqlite3.Connection, job_id: int, level: int) -> tuple[SubjobTrait, ...]:
    rows = db.execute(
        """
        select name, level, rank, mod_name, value
        from traits
        where job = ? and level > 0 and level <= ?
        order by level, trait_id, rank
        """,
        (job_id, level),
    ).fetchall()
    return tuple(
        SubjobTrait(
            name=str(row["name"]),
            level=int(row["level"]),
            rank=int(row["rank"]),
            mod_name=str(row["mod_name"]),
            value=int(row["value"]),
        )
        for row in rows
    )


def _load_subjob_spells(db: sqlite3.Connection, job_id: int, level: int) -> tuple[SubjobSpell, ...]:
    rows = db.execute(
        """
        select name, jobs_hex, spell_group, mp_cost, cast_time, recast_time
        from spells
        order by spell_id
        """
    ).fetchall()
    spells: list[SubjobSpell] = []
    for row in rows:
        if int(row["spell_group"]) == 8:
            continue
        spell_level = _spell_level_for_job(row["jobs_hex"], job_id)
        if spell_level <= 0 or spell_level > level:
            continue
        spells.append(
            SubjobSpell(
                name=str(row["name"]),
                level=spell_level,
                mp_cost=int(row["mp_cost"]),
                cast_time=int(row["cast_time"]),
                recast_time=int(row["recast_time"]),
            )
        )
    return tuple(sorted(spells, key=lambda spell: (spell.level, spell.name)))


def _derive_capabilities(
    subjob: str,
    abilities: tuple[SubjobAbility, ...],
    traits: tuple[SubjobTrait, ...],
    spells: tuple[SubjobSpell, ...],
) -> tuple[str, ...]:
    capabilities = list(BASE_CAPABILITIES_BY_SUBJOB.get(subjob, tuple()))
    trait_names = {trait.mod_name for trait in traits}
    spell_names = {spell.name for spell in spells}
    ability_names = {ability.name for ability in abilities}

    if "DUAL_WIELD" in trait_names:
        capabilities.append("dual_wield")
    if "DAKEN" in trait_names:
        capabilities.append("daken")
    if any(name.startswith("utsusemi_") for name in spell_names):
        capabilities.append("shadows")
    if any(name.startswith("cure") for name in spell_names):
        capabilities.append("cure")
    if {"sneak", "invisible"} & spell_names:
        capabilities.append("sneak_invisible")
    if "provoke" in ability_names:
        capabilities.append("provoke")
    if "meditate" in ability_names:
        capabilities.append("meditate")
    if "sublimation" in ability_names:
        capabilities.append("sublimation")
    return tuple(dict.fromkeys(capabilities))


def _spell_level_for_job(value: object, job_id: int) -> int:
    text = str(value).strip()
    if not text:
        return 0
    try:
        number = int(text, 0)
    except ValueError:
        return 0
    data = number.to_bytes(22, "big", signed=False)
    index = job_id - 1
    if index < 0 or index >= len(data):
        return 0
    return int(data[index])


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    return db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone() is not None
