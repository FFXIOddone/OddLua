from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import re
import sqlite3


ITEM_MOD_INSERT_RE = re.compile(
    r"INSERT\s+INTO\s+`item_mods`\s+VALUES\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(-?\d+)\s*\)",
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
    109: "SHIELD",
    161: "DMGPHYS",
    163: "DMGMAGIC",
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
    827: "BARSPELL_MDEF_BONUS",
    831: "DMGMAGIC_II",
    909: "QUICK_MAGIC",
    937: "FOOD_DURATION",
    1130: "FOOD_HP",
    1131: "FOOD_MP",
}

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
}


@dataclass(frozen=True)
class ItemMod:
    mod_id: int
    name: str
    value: int


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
class ItemStatsIndex:
    source_path: Path
    mods_by_item_id: dict[int, tuple[ItemMod, ...]]
    food_mods_by_item_id: dict[int, tuple[ItemMod, ...]] = field(default_factory=dict)
    weapon_stats_by_item_id: dict[int, WeaponStats] = field(default_factory=dict)

    def mods_for_item_id(self, item_id: int) -> tuple[ItemMod, ...]:
        return self.mods_by_item_id.get(item_id, tuple())

    def food_mods_for_item_id(self, item_id: int) -> tuple[ItemMod, ...]:
        return self.food_mods_by_item_id.get(item_id, tuple())

    def weapon_stats_for_item_id(self, item_id: int) -> WeaponStats | None:
        return self.weapon_stats_by_item_id.get(item_id)

    def role_names_for_mods(self, mods: tuple[ItemMod, ...]) -> tuple[str, ...]:
        roles: list[str] = []
        for mod in mods:
            if mod.value <= 0:
                continue
            for role, mod_ids in ROLE_MODS.items():
                if mod.mod_id in mod_ids:
                    roles.append(role)
        return tuple(dict.fromkeys(roles))


def load_item_stats(sql_root: Path | str) -> ItemStatsIndex:
    root = Path(sql_root)
    path = root / "item_mods.sql" if root.is_dir() else root
    if not path.exists():
        raise FileNotFoundError(f"Server item_mods.sql not found: {path}")

    mods_by_item_id: dict[int, list[ItemMod]] = {}
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

    return ItemStatsIndex(
        source_path=path,
        mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(mods_by_item_id.items())
        },
    )


def load_item_stats_from_db(db_path: Path | str) -> ItemStatsIndex:
    path = Path(db_path)
    if not path.exists():
        raise FileNotFoundError(f"OddLua stats database not found: {path}")

    mods_by_item_id: dict[int, list[ItemMod]] = {}
    food_mods_by_item_id: dict[int, list[ItemMod]] = {}
    weapon_stats_by_item_id: dict[int, WeaponStats] = {}
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
    finally:
        db.close()

    return ItemStatsIndex(
        source_path=path,
        mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(mods_by_item_id.items())
        },
        food_mods_by_item_id={
            item_id: tuple(mods)
            for item_id, mods in sorted(food_mods_by_item_id.items())
        },
        weapon_stats_by_item_id=dict(sorted(weapon_stats_by_item_id.items())),
    )
