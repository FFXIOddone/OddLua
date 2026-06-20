from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import re
import sqlite3
from typing import TYPE_CHECKING

from .gameconstants import JOB_ID_BY_ABBR, WEAPON_FAMILY_BY_SKILL

if TYPE_CHECKING:
    from .weaponskills import CatseyeWeaponSkill


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
    10: "VIT",
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
    31: "MEVA",
    32: "FIRE_MAB",
    33: "ICE_MAB",
    34: "WIND_MAB",
    35: "EARTH_MAB",
    36: "THUNDER_MAB",
    37: "WATER_MAB",
    38: "LIGHT_MAB",
    39: "DARK_MAB",
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
    80: "HTH",
    81: "DAGGER",
    82: "SWORD",
    83: "GSWORD",
    84: "AXE",
    85: "GAXE",
    86: "SCYTHE",
    87: "POLEARM",
    88: "KATANA",
    89: "GKATANA",
    90: "CLUB",
    91: "STAFF",
    104: "ARCHERY",
    105: "MARKSMAN",
    106: "THROW",
    107: "GUARD",
    108: "EVASION",
    75: "MOVE_SPEED_STACKABLE",
    76: "MOVE_SPEED_GEAR_BONUS",
    78: "MOVE_SPEED_QUICKENING",
    79: "MOVE_SPEED_MAZURKA",
    109: "SHIELD",
    110: "PARRY",
    111: "DIVINE",
    112: "HEALING",
    113: "ENHANCE",
    114: "ENFEEBLE",
    115: "ELEM",
    116: "DARK",
    117: "SUMMONING",
    118: "NINJUTSU",
    119: "SINGING",
    120: "STRING",
    121: "WIND",
    122: "BLUE",
    123: "GEOMANCY_SKILL",
    124: "HANDBELL_SKILL",
    127: "FISH",
    139: "WALTZ_COST",
    160: "DMG",
    161: "DMGPHYS",
    163: "DMGMAGIC",
    165: "CRITHITRATE",
    168: "SPELLINTERRUPT",
    169: "MOVE_SPEED_OVERRIDE",
    170: "FASTCAST",
    173: "MARTIAL_ARTS",
    174: "SKILLCHAINBONUS",
    175: "SKILLCHAINDMG",
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
    190: "DMGPHYS_II",
    224: "VERMIN_KILLER",
    225: "BIRD_KILLER",
    226: "AMORPH_KILLER",
    227: "LIZARD_KILLER",
    228: "AQUAN_KILLER",
    229: "PLANTOID_KILLER",
    230: "BEAST_KILLER",
    231: "UNDEAD_KILLER",
    232: "ARCANA_KILLER",
    233: "DRAGON_KILLER",
    234: "DEMON_KILLER",
    235: "EMPTY_KILLER",
    236: "HUMANOID_KILLER",
    237: "LUMINIAN_KILLER",
    238: "LUMINION_KILLER",
    240: "SLEEPRES",
    243: "BLINDRES",
    244: "SILENCERES",
    246: "PETRIFYRES",
    252: "CHARMRES",
    255: "DEATHRES",
    259: "DUAL_WIELD",
    260: "CURE_POTENCY_II",
    289: "SUBTLE_BLOW",
    291: "COUNTER",
    292: "KICK_ATTACK_RATE",
    298: "STEAL",
    288: "DOUBLE_ATTACK",
    296: "CONSERVE_MP",
    302: "TRIPLE_ATTACK",
    303: "TREASURE_HUNTER",
    305: "RECYCLE",
    306: "ZANSHIN",
    334: "LIGHT_ARTS_EFFECT",
    335: "DARK_ARTS_EFFECT",
    311: "MAGIC_DAMAGE",
    315: "ENH_DRAIN_ASPIR",
    345: "TP_BONUS",
    346: "PERPETUATION_REDUCTION",
    359: "RAPID_SHOT",
    365: "SNAPSHOT",
    369: "REFRESH",
    371: "AVATAR_PERPETUATION",
    357: "BP_DELAY",
    374: "CURE_POTENCY",
    375: "CURE_POTENCY_RCVD",
    381: "RANGED_DELAYP",
    384: "HASTE_GEAR",
    389: "UDMGMAGIC",
    407: "UFASTCAST",
    414: "RETALIATION",
    421: "CRIT_DMG_INCREASE",
    427: "ENMITY_LOSS_REDUCTION",
    434: "MINUET_EFFECT",
    435: "PAEON_EFFECT",
    440: "LULLABY_EFFECT",
    438: "MADRIGAL_EFFECT",
    441: "ETUDE_EFFECT",
    442: "BALLAD_EFFECT",
    443: "MARCH_EFFECT",
    445: "CAROL_EFFECT",
    447: "ELEGY_EFFECT",
    448: "PRELUDE_EFFECT",
    452: "ALL_SONGS_EFFECT",
    432: "ENSPELL_DMG_BONUS",
    454: "SONG_DURATION_BONUS",
    455: "SONG_SPELLCASTING_TIME",
    486: "TACTICAL_PARRY",
    487: "MAGIC_BURST_BONUS_CAPPED",
    489: "GRIMOIRE_SPELLCASTING",
    491: "WALTZ_POTENCY",
    492: "JIG_DURATION",
    497: "WALTZ_DELAY",
    518: "SHIELDBLOCKRATE",
    519: "CURE_CAST_TIME",
    523: "AMMO_SWING",
    528: "ROLL_RANGE",
    539: "STONESKIN_BONUS_HP",
    347: "FIRE_STAFF_BONUS",
    348: "ICE_STAFF_BONUS",
    349: "WIND_STAFF_BONUS",
    350: "EARTH_STAFF_BONUS",
    351: "THUNDER_STAFF_BONUS",
    352: "WATER_STAFF_BONUS",
    353: "LIGHT_STAFF_BONUS",
    354: "DARK_STAFF_BONUS",
    553: "FIRE_AFFINITY_PERP",
    554: "ICE_AFFINITY_PERP",
    555: "WIND_AFFINITY_PERP",
    556: "EARTH_AFFINITY_PERP",
    557: "THUNDER_AFFINITY_PERP",
    558: "WATER_AFFINITY_PERP",
    559: "LIGHT_AFFINITY_PERP",
    560: "DARK_AFFINITY_PERP",
    562: "MAGIC_CRITHITRATE",
    563: "MAGIC_CRIT_DMG_INCREASE",
    566: "IRIDESCENCE",
    827: "BARSPELL_MDEF_BONUS",
    831: "DMGMAGIC_II",
    854: "REPAIR_POTENCY",
    865: "MYTHIC_OCC_ATT_TWICE",
    833: "SONG_RECAST_DELAY",
    890: "ENH_MAGIC_DURATION",
    900: "UTSUSEMI_BONUS",
    901: "ELEMENTAL_CELERITY",
    898: "SMITE",
    902: "OCCULT_ACUMEN",
    911: "DAKEN",
    909: "QUICK_MAGIC",
    944: "CONSERVE_TP",
    961: "GEOMANCY_BONUS",
    963: "INQUARTATA",
    973: "SUBTLE_BLOW_II",
    996: "ONE_HOUR_RECAST",
    937: "FOOD_DURATION",
    972: "MOUNT_MOVE",
    978: "MAX_SWINGS",
    979: "ADDITIONAL_SWING_CHANCE",
    988: "MAX_FINISHING_MOVE_BONUS",
    1130: "FOOD_HP",
    1131: "FOOD_MP",
    1195: "ENSPELL_DMG_PCT",
    1038: "DOUBLE_ATTACK_DMG",
    1039: "TRIPLE_ATTACK_DMG",
    1029: "LIFE_CYCLE_EFFECT",
    1150: "ELEMENTAL_DEBUFF_EFFECT",
    1182: "PHALANX_RECEIVED",
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
    "melee_offense": {23, 62, 73, 288, 384, 865, 1038, 1039},
    "accuracy": {25, 48},
    "evasion": {68},
    "ranged_offense": {24},
    "ranged_accuracy": {26},
    "ranged_evasion": {70},
    "enmity": {27},
    "shield": {109},
    "magic_damage": {28, 32, 33, 34, 35, 36, 37, 38, 39, 311, 347, 348, 349, 350, 351, 352, 353, 354, 566},
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
class ItemConditionalMod:
    item_id: int
    mod_id: int
    name: str
    value: int
    condition_type: str
    condition_name: str
    source_text: str = ""


@dataclass(frozen=True)
class WeaponStats:
    item_id: int
    skill: int
    delay: int
    damage: int
    hit: int
    subskill: int = 0

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
    conditional_mods_by_item_id: dict[int, tuple[ItemConditionalMod, ...]] = field(default_factory=dict)
    weapon_skills_by_key: dict[str, "CatseyeWeaponSkill"] = field(default_factory=dict)
    skill_caps_by_level_rank: dict[tuple[int, int], int] = field(default_factory=dict)
    skill_ranks_by_skill_job: dict[tuple[int, str], int] = field(default_factory=dict)
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

    def conditional_mods_for_item_id(self, item_id: int) -> tuple[ItemConditionalMod, ...]:
        return self.conditional_mods_by_item_id.get(item_id, tuple())

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
    conditional_mods_by_item_id: dict[int, list[ItemConditionalMod]] = {}
    mechanics_counts: dict[str, int] = {}
    weapon_skills_by_key: dict[str, "CatseyeWeaponSkill"] = {}
    skill_caps_by_level_rank: dict[tuple[int, int], int] = {}
    skill_ranks_by_skill_job: dict[tuple[int, str], int] = {}
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

        if _has_table(db, "item_conditional_mods"):
            for row in db.execute(
                """
                select item_id, mod_id, mod_name, value, condition_type, condition_name, source_text
                from item_conditional_mods
                order by item_id, condition_type, condition_name, rowid
                """
            ):
                item_id = int(row["item_id"])
                conditional_mods_by_item_id.setdefault(item_id, []).append(
                    ItemConditionalMod(
                        item_id=item_id,
                        mod_id=int(row["mod_id"]),
                        name=str(row["mod_name"]),
                        value=int(row["value"]),
                        condition_type=str(row["condition_type"]),
                        condition_name=str(row["condition_name"]),
                        source_text=str(row["source_text"]),
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
            "select item_id, skill, subskill, delay, damage, hit from item_weapon order by item_id"
        ):
            item_id = int(row["item_id"])
            weapon_stats_by_item_id[item_id] = WeaponStats(
                item_id=item_id,
                skill=int(row["skill"]),
                delay=int(row["delay"]),
                damage=int(row["damage"]),
                hit=int(row["hit"]),
                subskill=int(row["subskill"]),
            )

        for table in ("abilities", "spells", "status_effects", "item_mods_pet", "item_latents", "item_conditional_mods"):
            if _has_table(db, table):
                mechanics_counts[table] = int(db.execute(f"select count(*) from {table}").fetchone()[0])

        if _has_table(db, "weapon_skills"):
            from .weaponskills import load_weaponskill_catalog_from_connection

            weapon_skills_by_key = load_weaponskill_catalog_from_connection(db)
            mechanics_counts["weapon_skills"] = int(db.execute("select count(*) from weapon_skills").fetchone()[0])

        if _has_table(db, "skill_caps"):
            for row in db.execute("select level, rank, cap from skill_caps"):
                skill_caps_by_level_rank[(int(row["level"]), int(row["rank"]))] = int(row["cap"])
            mechanics_counts["skill_caps"] = int(db.execute("select count(*) from skill_caps").fetchone()[0])

        if _has_table(db, "skill_ranks"):
            for row in db.execute("select skill_id, job, rank from skill_ranks"):
                skill_ranks_by_skill_job[(int(row["skill_id"]), str(row["job"]).upper())] = int(row["rank"])
            mechanics_counts["skill_ranks"] = int(db.execute("select count(*) from skill_ranks").fetchone()[0])
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
        conditional_mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(conditional_mods_by_item_id.items())
        },
        weapon_skills_by_key=weapon_skills_by_key or {},
        skill_caps_by_level_rank=dict(sorted(skill_caps_by_level_rank.items())),
        skill_ranks_by_skill_job=dict(sorted(skill_ranks_by_skill_job.items())),
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
