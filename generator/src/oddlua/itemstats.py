from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import re
import sqlite3


ITEM_MOD_INSERT_RE = re.compile(
    r"INSERT\s+INTO\s+`item_mods`\s+VALUES\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(-?\d+)\s*\)",
    re.IGNORECASE,
)

ITEM_LATENT_INSERT_RE = re.compile(
    r"INSERT\s+INTO\s+`item_latents`\s+VALUES\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(-?\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)",
    re.IGNORECASE,
)

ITEM_EQUIPMENT_INSERT_RE = re.compile(
    r"INSERT\s+INTO\s+`item_equipment`\s+VALUES\s*\(\s*"
    r"(\d+)\s*,\s*'([^']*)'\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,"
    r"\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)",
    re.IGNORECASE,
)

MOD_NAMES = {
    1: "DEF",
    2: "HP",
    3: "HPP",
    5: "MP",
    6: "MPP",
    8: "STR",
    9: "DEX",
    11: "AGI",
    12: "INT",
    13: "MND",
    14: "CHR",
    15: "FIRE_MEVA",
    16: "ICE_MEVA",
    17: "WIND_MEVA",
    18: "EARTH_MEVA",
    19: "THUNDER_MEVA",
    20: "WATER_MEVA",
    21: "LIGHT_MEVA",
    22: "DARK_MEVA",
    23: "ATT",
    24: "RATT",
    25: "ACC",
    26: "RACC",
    27: "ENMITY",
    28: "MATT",
    29: "MDEF",
    30: "MACC",
    32: "FIRE_MAB",
    33: "ICE_MAB",
    34: "WIND_MAB",
    35: "EARTH_MAB",
    36: "THUNDER_MAB",
    37: "WATER_MAB",
    38: "LIGHT_MAB",
    40: "FIRE_MACC",
    41: "ICE_MACC",
    42: "WIND_MACC",
    43: "EARTH_MACC",
    44: "THUNDER_MACC",
    45: "WATER_MACC",
    46: "LIGHT_MACC",
    47: "DARK_MACC",
    48: "WSACC",
    62: "ATTP",
    68: "EVA",
    70: "REVA",
    71: "MPHEAL",
    72: "HPHEAL",
    73: "STORETP",
    75: "MOVE_SPEED_STACKABLE",
    76: "MOVE_SPEED_GEAR_BONUS",
    78: "MOVE_SPEED_QUICKENING",
    79: "MOVE_SPEED_MAZURKA",
    109: "SHIELD",
    161: "DMGPHYS",
    163: "DMGMAGIC",
    169: "MOVE_SPEED_OVERRIDE",
    170: "FASTCAST",
    176: "FOOD_HPP",
    177: "FOOD_HP_CAP",
    178: "FOOD_MPP",
    179: "FOOD_MP_CAP",
    180: "FOOD_ATTP",
    181: "FOOD_ATT_CAP",
    182: "FOOD_DEFP",
    183: "FOOD_DEF_CAP",
    184: "FOOD_ACCP",
    185: "FOOD_ACC_CAP",
    186: "FOOD_RATTP",
    187: "FOOD_RATT_CAP",
    188: "FOOD_RACCP",
    189: "FOOD_RACC_CAP",
    289: "SUBTLE_BLOW",
    296: "CONSERVE_MP",
    311: "MAGIC_DAMAGE",
    369: "REFRESH",
    374: "CURE_POTENCY",
    384: "HASTE_GEAR",
    389: "UDMGMAGIC",
    407: "UFASTCAST",
    523: "AMMO_SWING",
    827: "BARSPELL_MDEF_BONUS",
    831: "DMGMAGIC_II",
    909: "QUICK_MAGIC",
    937: "FOOD_DURATION",
    972: "MOUNT_MOVE",
    978: "MAX_SWINGS",
    979: "ADDITIONAL_SWING_CHANCE",
    1130: "FOOD_HP",
    1131: "FOOD_MP",
    1195: "ENSPELL_DMG_PCT",
}

WEAPON_FAMILY_BY_SKILL = {
    1: "hand_to_hand",
    2: "dagger",
    3: "sword",
    4: "great_sword",
    5: "axe",
    6: "great_axe",
    7: "scythe",
    8: "polearm",
    9: "katana",
    10: "great_katana",
    11: "club",
    12: "staff",
    25: "bow",
    26: "gun",
    27: "throwing",
    40: "instrument",
    41: "instrument",
    42: "instrument",
    45: "instrument",
}

JOB_ID_BY_ABBR = {
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

EQUIPMENT_SLOT_MASKS = {
    "Main": 1 << 0,
    "Sub": 1 << 1,
    "Range": 1 << 2,
    "Ammo": 1 << 3,
    "Head": 1 << 4,
    "Body": 1 << 5,
    "Hands": 1 << 6,
    "Legs": 1 << 7,
    "Feet": 1 << 8,
    "Neck": 1 << 9,
    "Waist": 1 << 10,
    "Ear1": 1 << 11,
    "Ear2": 1 << 12,
    "Ring1": 1 << 13,
    "Ring2": 1 << 14,
    "Back": 1 << 15,
}

WEAPON_SLOT_BITS = sum(EQUIPMENT_SLOT_MASKS[slot] for slot in ("Main", "Sub", "Range", "Ammo"))
ARMOR_SLOT_BITS = sum(EQUIPMENT_SLOT_MASKS[slot] for slot in ("Head", "Body", "Hands", "Legs", "Feet"))
ACCESSORY_SLOT_BITS = sum(
    EQUIPMENT_SLOT_MASKS[slot]
    for slot in ("Neck", "Waist", "Ear1", "Ear2", "Ring1", "Ring2", "Back")
)

ROLE_MODS = {
    "hp": {2, 3},
    "mp": {5, 6},
    "defense": {1},
    "str": {8},
    "dex": {9},
    "int": {12},
    "mnd": {13},
    "agi": {11},
    "melee_offense": {23, 62, 73, 384},
    "accuracy": {25, 48},
    "evasion": {68},
    "ranged_offense": {24},
    "ranged_accuracy": {26},
    "ranged_evasion": {70},
    "enmity": {27},
    "shield": {109},
    "magic_damage": {28, 32, 33, 34, 35, 36, 37, 38, 311},
    "magic_accuracy": {30, 40, 41, 42, 43, 44, 45, 46, 47},
    "magic_defense": {15, 16, 17, 18, 19, 20, 21, 22, 29, 163, 827, 831},
    "fast_cast": {170, 407, 909},
    "refresh": {369, 71, 296},
    "movement": {76, 78, 79, 169, 972},
}

ROLE_MOD_NAMES = {
    "cure": {"CURE_POTENCY", "CURE_POTENCY_II", "CURE_CAST_TIME"},
    "waltz": {"WALTZ_POTENCY", "WALTZ_POTENTCY", "WALTZ_COST", "WALTZ_DELAY"},
    "song": {"SINGING", "WIND_INSTRUMENT", "STRING_INSTRUMENT", "SONG_SPELLCASTING_TIME", "ALL_SONGS_EFFECT"},
    "geomancy": {"GEOMANCY_SKILL", "HANDBELL_SKILL", "GEOMANCY_BONUS"},
    "pet_damage": {"PET_ATK", "PET_ACC", "PET_MAB", "PET_MACC", "PET_STORETP", "PET_HASTE", "BP_DAMAGE"},
    "pet_accuracy": {"PET_ACC", "PET_MACC"},
    "pet_defense": {"PET_DEF", "PET_DMG_TAKEN", "PET_REGEN"},
    "pet_evasion": {"PET_EVA"},
    "quick_draw": {"QUICK_DRAW_MACC", "QUICK_DRAW_DMG", "QUICK_DRAW_DMG_PERCENT"},
    "roll": {"PHANTOM_ROLL", "PHANTOM_DURATION", "PHANTOM_RECAST"},
}


@dataclass(frozen=True)
class ItemMod:
    mod_id: int
    name: str
    value: int


@dataclass(frozen=True)
class ItemLatent:
    item_id: int
    mod_id: int
    name: str
    value: int
    condition_id: int
    condition_value: int


@dataclass(frozen=True)
class WeaponStats:
    item_id: int
    skill: int
    delay: int
    damage: int
    hit: int

    @property
    def dps_score(self) -> int:
        if self.delay <= 0:
            return 0
        return int(self.damage * max(self.hit, 1) * 100_000 / self.delay)


@dataclass(frozen=True)
class EquipmentStats:
    item_id: int
    name: str
    level: int
    ilevel: int
    jobs: int
    shield_size: int
    slot_mask: int
    removal_slot_mask: int = 0

    def level_eligible(self, character_level: int) -> bool:
        return character_level > 0 and (self.level <= 0 or self.level <= character_level)

    def job_eligible(self, job: str) -> bool:
        job_id = JOB_ID_BY_ABBR.get(job.upper())
        if job_id is None:
            return False
        return bool(self.jobs & (1 << (job_id - 1)))

    def has_slot(self, slot: str) -> bool:
        slot_mask = EQUIPMENT_SLOT_MASKS.get(slot)
        if slot_mask is None:
            return False
        return bool(self.slot_mask & slot_mask)

    def slot_family(self) -> str:
        if self.slot_mask & WEAPON_SLOT_BITS:
            return "weapon"
        if self.slot_mask & ARMOR_SLOT_BITS:
            return "armor"
        if self.slot_mask & ACCESSORY_SLOT_BITS:
            return "accessory"
        return "unknown"


@dataclass(frozen=True)
class ItemStatsIndex:
    source_path: Path
    mods_by_item_id: dict[int, tuple[ItemMod, ...]]
    equipment_by_item_id: dict[int, EquipmentStats] = field(default_factory=dict)
    food_mods_by_item_id: dict[int, tuple[ItemMod, ...]] = field(default_factory=dict)
    pet_mods_by_item_id: dict[int, tuple[ItemMod, ...]] = field(default_factory=dict)
    weapon_stats_by_item_id: dict[int, WeaponStats] = field(default_factory=dict)
    latents_by_item_id: dict[int, tuple[ItemLatent, ...]] = field(default_factory=dict)
    mechanics_counts: dict[str, int] = field(default_factory=dict)

    def mods_for_item_id(self, item_id: int) -> tuple[ItemMod, ...]:
        return self.mods_by_item_id.get(item_id, tuple())

    def equipment_for_item_id(self, item_id: int) -> EquipmentStats | None:
        return self.equipment_by_item_id.get(item_id)

    def food_mods_for_item_id(self, item_id: int) -> tuple[ItemMod, ...]:
        return self.food_mods_by_item_id.get(item_id, tuple())

    def pet_mods_for_item_id(self, item_id: int) -> tuple[ItemMod, ...]:
        return self.pet_mods_by_item_id.get(item_id, tuple())

    def latents_for_item_id(self, item_id: int) -> tuple[ItemLatent, ...]:
        return self.latents_by_item_id.get(item_id, tuple())

    def weapon_stats_for_item_id(self, item_id: int) -> WeaponStats | None:
        return self.weapon_stats_by_item_id.get(item_id)

    def weapon_family_for_item_id(self, item_id: int) -> str | None:
        weapon_stats = self.weapon_stats_for_item_id(item_id)
        if weapon_stats is None:
            return None
        return WEAPON_FAMILY_BY_SKILL.get(weapon_stats.skill)

    def role_names_for_mods(self, mods: tuple[ItemMod, ...]) -> tuple[str, ...]:
        roles: list[str] = []
        for mod in mods:
            if mod.value <= 0:
                continue
            for role, mod_ids in ROLE_MODS.items():
                if mod.mod_id in mod_ids:
                    roles.append(role)
            for role, names in ROLE_MOD_NAMES.items():
                if mod.name in names:
                    roles.append(role)
        return tuple(dict.fromkeys(roles))


def load_item_stats(sql_root: Path | str) -> ItemStatsIndex:
    root = Path(sql_root)
    path = root / "item_mods.sql" if root.is_dir() else root
    if not path.exists():
        raise FileNotFoundError(f"Server item_mods.sql not found: {path}")

    mods_by_item_id: dict[int, list[ItemMod]] = {}
    equipment_by_item_id: dict[int, EquipmentStats] = {}
    pet_mods_by_item_id: dict[int, list[ItemMod]] = {}
    latents_by_item_id: dict[int, list[ItemLatent]] = {}
    for match in ITEM_MOD_INSERT_RE.finditer(path.read_text(encoding="utf-8", errors="replace")):
        item_id = int(match.group(1))
        mod_id = int(match.group(2))
        value = int(match.group(3))
        mods_by_item_id.setdefault(item_id, []).append(
            ItemMod(
                mod_id=mod_id,
                name=MOD_NAMES.get(mod_id, f"MOD_{mod_id}"),
                value=value,
            )
        )
    if root.is_dir():
        equipment_path = root / "item_equipment.sql"
        if equipment_path.exists():
            for match in ITEM_EQUIPMENT_INSERT_RE.finditer(
                equipment_path.read_text(encoding="utf-8", errors="replace")
            ):
                item_id = int(match.group(1))
                equipment_by_item_id[item_id] = EquipmentStats(
                    item_id=item_id,
                    name=match.group(2),
                    level=int(match.group(3)),
                    ilevel=int(match.group(4)),
                    jobs=int(match.group(5)),
                    shield_size=int(match.group(7)),
                    slot_mask=int(match.group(9)),
                    removal_slot_mask=int(match.group(10)),
                )

        pet_path = root / "item_mods_pet.sql"
        if pet_path.exists():
            for match in re.finditer(
                r"INSERT\s+INTO\s+`item_mods_pet`\s+VALUES\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(-?\d+)\s*,\s*(\d+)\s*\)",
                pet_path.read_text(encoding="utf-8", errors="replace"),
                re.IGNORECASE,
            ):
                item_id = int(match.group(1))
                mod_id = int(match.group(2))
                value = int(match.group(3))
                pet_mods_by_item_id.setdefault(item_id, []).append(
                    ItemMod(
                        mod_id=mod_id,
                        name=_pet_mod_name(MOD_NAMES.get(mod_id, f"MOD_{mod_id}")),
                        value=value,
                    )
                )

        latent_path = root / "item_latents.sql"
        if latent_path.exists():
            for match in ITEM_LATENT_INSERT_RE.finditer(
                latent_path.read_text(encoding="utf-8", errors="replace")
            ):
                item_id = int(match.group(1))
                mod_id = int(match.group(2))
                latents_by_item_id.setdefault(item_id, []).append(
                    ItemLatent(
                        item_id=item_id,
                        mod_id=mod_id,
                        name=MOD_NAMES.get(mod_id, f"MOD_{mod_id}"),
                        value=int(match.group(3)),
                        condition_id=int(match.group(4)),
                        condition_value=int(match.group(5)),
                    )
                )

    return ItemStatsIndex(
        source_path=path,
        mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(mods_by_item_id.items())
        },
        equipment_by_item_id=dict(sorted(equipment_by_item_id.items())),
        pet_mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(pet_mods_by_item_id.items())
        },
        latents_by_item_id={
            item_id: tuple(latents)
            for item_id, latents in sorted(latents_by_item_id.items())
        },
    )


def load_item_stats_from_db(db_path: Path | str) -> ItemStatsIndex:
    path = Path(db_path)
    if not path.exists():
        raise FileNotFoundError(f"OddLua stats database not found: {path}")

    mods_by_item_id: dict[int, list[ItemMod]] = {}
    equipment_by_item_id: dict[int, EquipmentStats] = {}
    food_mods_by_item_id: dict[int, list[ItemMod]] = {}
    pet_mods_by_item_id: dict[int, list[ItemMod]] = {}
    weapon_stats_by_item_id: dict[int, WeaponStats] = {}
    latents_by_item_id: dict[int, list[ItemLatent]] = {}
    mechanics_counts: dict[str, int] = {}
    db = sqlite3.connect(path)
    try:
        db.row_factory = sqlite3.Row
        for row in db.execute(
            "select item_id, mod_id, mod_name, value from item_mods order by item_id, rowid"
        ):
            item_id = int(row["item_id"])
            mod_id = int(row["mod_id"])
            mods_by_item_id.setdefault(item_id, []).append(
                ItemMod(
                    mod_id=mod_id,
                    name=str(row["mod_name"]),
                    value=int(row["value"]),
                )
            )

        for row in db.execute(
            "select item_id, name, level, ilevel, jobs, shield_size, slot, rslot from item_equipment order by item_id"
        ):
            item_id = int(row["item_id"])
            equipment_by_item_id[item_id] = EquipmentStats(
                item_id=item_id,
                name=str(row["name"]),
                level=int(row["level"]),
                ilevel=int(row["ilevel"]),
                jobs=int(row["jobs"]),
                shield_size=int(row["shield_size"]),
                slot_mask=int(row["slot"]),
                removal_slot_mask=int(row["rslot"]),
            )

        if _has_table(db, "item_mods_pet"):
            for row in db.execute(
                "select item_id, mod_id, mod_name, value from item_mods_pet order by item_id, rowid"
            ):
                item_id = int(row["item_id"])
                mod_id = int(row["mod_id"])
                pet_mods_by_item_id.setdefault(item_id, []).append(
                    ItemMod(
                        mod_id=mod_id,
                        name=str(row["mod_name"]),
                        value=int(row["value"]),
                    )
                )

        if _has_table(db, "item_latents"):
            for row in db.execute(
                """
                select item_id, mod_id, mod_name, value, condition_id, condition_value
                from item_latents
                order by item_id, rowid
                """
            ):
                item_id = int(row["item_id"])
                latents_by_item_id.setdefault(item_id, []).append(
                    ItemLatent(
                        item_id=item_id,
                        mod_id=int(row["mod_id"]),
                        name=str(row["mod_name"]),
                        value=int(row["value"]),
                        condition_id=int(row["condition_id"]),
                        condition_value=int(row["condition_value"]),
                    )
                )

        for row in db.execute(
            """
            select item_id, mod_id, mod_name, value
            from food_effect_mods
            where target_type = 'player'
            order by item_id, rowid
            """
        ):
            item_id = int(row["item_id"])
            mod_id = int(row["mod_id"])
            food_mods_by_item_id.setdefault(item_id, []).append(
                ItemMod(
                    mod_id=mod_id,
                    name=str(row["mod_name"]),
                    value=int(row["value"]),
                )
            )

        for row in db.execute(
            "select item_id, skill, delay, damage, hit from item_weapon order by item_id"
        ):
            item_id = int(row["item_id"])
            weapon_stats_by_item_id[item_id] = WeaponStats(
                item_id=item_id,
                skill=int(row["skill"]),
                delay=int(row["delay"]),
                damage=int(row["damage"]),
                hit=int(row["hit"]),
            )

        for table in ("abilities", "spells", "status_effects", "item_mods_pet", "item_latents"):
            if _has_table(db, table):
                mechanics_counts[table] = int(db.execute(f"select count(*) from {table}").fetchone()[0])
    finally:
        db.close()

    return ItemStatsIndex(
        source_path=path,
        mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(mods_by_item_id.items())
        },
        equipment_by_item_id=dict(sorted(equipment_by_item_id.items())),
        food_mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(food_mods_by_item_id.items())
        },
        pet_mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(pet_mods_by_item_id.items())
        },
        weapon_stats_by_item_id=dict(sorted(weapon_stats_by_item_id.items())),
        latents_by_item_id={
            item_id: tuple(latents)
            for item_id, latents in sorted(latents_by_item_id.items())
        },
        mechanics_counts=mechanics_counts,
    )


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    return db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone() is not None


def _pet_mod_name(base_name: str) -> str:
    if base_name.startswith("PET_"):
        return base_name
    return {
        "ACC": "PET_ACC",
        "RACC": "PET_ACC",
        "ATT": "PET_ATK",
        "ATTP": "PET_ATK",
        "RATT": "PET_ATK",
        "RATTP": "PET_ATK",
        "MATT": "PET_MAB",
        "MAGIC_DAMAGE": "PET_MAB",
        "MACC": "PET_MACC",
        "STORETP": "PET_STORETP",
        "HASTE_GEAR": "PET_HASTE",
        "DEF": "PET_DEF",
        "EVA": "PET_EVA",
        "MDEF": "PET_MDEF",
        "DMGPHYS": "PET_DMG_TAKEN",
        "DMGMAGIC": "PET_DMG_TAKEN",
        "UDMGPHYS": "PET_DMG_TAKEN",
        "UDMGMAGIC": "PET_DMG_TAKEN",
        "REGEN": "PET_REGEN",
        "REFRESH": "PET_REFRESH",
    }.get(base_name, base_name)
