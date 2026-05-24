from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
from typing import Iterable

from .classifier import ClassifiedItem, classify_item
from .contracts import JobContract, Playstyle, build_job_contract
from .gearexport import GearItem, load_character_snapshot, load_gearexport
from .itemstats import ItemStatsIndex, load_item_stats, load_item_stats_from_db
from .mobstats import TargetProfile, empty_target_manifest, load_target_profile_from_db
from .renderer import SLOT_ORDER, render_profile


COMBAT_SLOT_ORDER = tuple(
    slot for slot in SLOT_ORDER if slot not in {"Range", "Ammo"}
)

WEAPON_SLOTS = {"Main", "Sub", "Range", "Ammo"}
COMBAT_WEAPON_FAMILIES = {
    "ammo",
    "axe",
    "bow",
    "club",
    "dagger",
    "great_axe",
    "great_katana",
    "sword",
    "great_sword",
    "gun",
    "grip",
    "hand_to_hand",
    "instrument",
    "katana",
    "polearm",
    "scythe",
    "shield",
    "staff",
    "throwing",
}

DAMAGE_TYPE_BY_WEAPON_FAMILY = {
    "sword": "slash",
    "great_sword": "slash",
    "axe": "slash",
    "great_axe": "slash",
    "great_katana": "slash",
    "katana": "slash",
    "scythe": "slash",
    "polearm": "pierce",
    "dagger": "pierce",
    "bow": "pierce",
    "gun": "pierce",
    "throwing": "pierce",
    "club": "impact",
    "staff": "impact",
    "hand_to_hand": "h2h",
}

TWO_HANDED_WEAPON_FAMILIES = {"staff", "great_sword", "great_axe", "great_katana", "scythe", "polearm"}

JOB_STYLE_WEAPON_FAMILIES = {
    "WAR": {
        "Damage": {"Main": ("great_axe", "axe", "sword"), "Sub": ("axe", "sword", "shield")},
        "Accuracy": {"Main": ("great_axe", "axe", "sword"), "Sub": ("axe", "sword", "shield")},
        "WeaponSkill": {"Main": ("great_axe", "axe", "sword"), "Sub": ("axe", "sword", "shield")},
        "Survival": {"Main": ("axe", "sword"), "Sub": ("shield",)},
    },
    "MNK": {
        "Damage": {"Main": ("hand_to_hand",), "Sub": tuple()},
        "Accuracy": {"Main": ("hand_to_hand",), "Sub": tuple()},
        "WeaponSkill": {"Main": ("hand_to_hand",), "Sub": tuple()},
        "Evasion": {"Main": ("hand_to_hand",), "Sub": tuple()},
    },
    "WHM": {
        "Cure": {"Main": ("club", "staff"), "Sub": ("shield", "grip")},
        "FastCast": {"Main": ("club", "staff"), "Sub": ("shield", "grip")},
        "IdleRefresh": {"Main": ("club", "staff"), "Sub": ("shield", "grip")},
        "Damage": {"Main": ("club", "staff"), "Sub": ("shield", "grip")},
    },
    "BLM": {
        "Nuke": {"Main": ("staff", "club"), "Sub": ("grip",)},
        "MagicAccuracy": {"Main": ("staff", "club"), "Sub": ("grip",)},
        "FastCast": {"Main": ("staff", "club"), "Sub": ("grip",)},
        "IdleRefresh": {"Main": ("staff", "club"), "Sub": ("grip",)},
    },
    "RDM": {
        "Enspell": {"Main": ("sword", "dagger", "club", "staff"), "Sub": ("sword", "dagger", "shield", "grip")},
        "MagicAccuracy": {"Main": ("sword", "dagger", "club", "staff"), "Sub": ("sword", "dagger", "shield", "grip")},
        "FastCast": {"Main": ("sword", "dagger", "club", "staff"), "Sub": ("sword", "dagger", "shield", "grip")},
        "Cure": {"Main": ("club", "staff", "sword"), "Sub": ("shield", "grip")},
    },
    "THF": {
        "Melt": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
        "Dagger": {"Main": ("dagger",), "Sub": ("dagger",)},
        "Safe": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
        "Treasure": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
    },
    "PLD": {
        "Tank": {"Main": ("sword", "club"), "Sub": ("shield",)},
        "Enmity": {"Main": ("sword", "club"), "Sub": ("shield",)},
        "Damage": {"Main": ("sword", "club"), "Sub": ("shield",)},
        "MagicDefense": {"Main": ("sword", "club"), "Sub": ("shield",)},
    },
    "DRK": {
        "Damage": {"Main": ("scythe", "great_sword", "sword", "axe"), "Sub": ("shield",)},
        "Accuracy": {"Main": ("scythe", "great_sword", "sword", "axe"), "Sub": ("shield",)},
        "WeaponSkill": {"Main": ("scythe", "great_sword", "sword", "axe"), "Sub": ("shield",)},
        "DrainAbsorb": {"Main": ("scythe", "great_sword", "staff"), "Sub": ("grip",)},
    },
    "BST": {
        "Damage": {"Main": ("axe", "club", "sword"), "Sub": ("axe", "club", "shield")},
        "Accuracy": {"Main": ("axe", "club", "sword"), "Sub": ("axe", "club", "shield")},
        "PetDamage": {"Main": ("axe", "club", "sword"), "Sub": ("axe", "club", "shield")},
        "PetTank": {"Main": ("axe", "club", "sword"), "Sub": ("shield", "axe", "club")},
    },
    "BRD": {
        "Song": {"Main": ("dagger", "sword", "staff", "club"), "Sub": ("shield", "grip"), "Range": ("instrument",)},
        "FastCast": {"Main": ("dagger", "sword", "staff", "club"), "Sub": ("shield", "grip"), "Range": ("instrument",)},
        "MagicAccuracy": {"Main": ("dagger", "sword", "staff", "club"), "Sub": ("shield", "grip"), "Range": ("instrument",)},
        "IdleRefresh": {"Main": ("dagger", "sword", "staff", "club"), "Sub": ("shield", "grip"), "Range": ("instrument",)},
    },
    "RNG": {
        "RangedDamage": {"Main": ("dagger", "axe", "sword"), "Sub": ("dagger", "axe", "shield"), "Range": ("bow", "gun"), "Ammo": ("ammo",)},
        "RangedAccuracy": {"Main": ("dagger", "axe", "sword"), "Sub": ("dagger", "axe", "shield"), "Range": ("bow", "gun"), "Ammo": ("ammo",)},
        "WeaponSkill": {"Main": ("dagger", "axe", "sword"), "Sub": ("dagger", "axe", "shield"), "Range": ("bow", "gun"), "Ammo": ("ammo",)},
        "Evasion": {"Main": ("dagger", "axe", "sword"), "Sub": ("dagger", "axe", "shield"), "Range": ("bow", "gun"), "Ammo": ("ammo",)},
    },
    "SAM": {
        "StoreTP": {"Main": ("great_katana", "polearm"), "Sub": tuple()},
        "Accuracy": {"Main": ("great_katana", "polearm"), "Sub": tuple()},
        "WeaponSkill": {"Main": ("great_katana", "polearm"), "Sub": tuple()},
        "Evasion": {"Main": ("great_katana", "polearm"), "Sub": tuple()},
    },
    "NIN": {
        "Damage": {"Main": ("katana", "dagger", "sword"), "Sub": ("katana", "dagger", "sword")},
        "Accuracy": {"Main": ("katana", "dagger", "sword"), "Sub": ("katana", "dagger", "sword")},
        "Evasion": {"Main": ("katana", "dagger", "sword"), "Sub": ("katana", "dagger", "sword")},
        "Ninjutsu": {"Main": ("katana", "dagger", "sword"), "Sub": ("katana", "dagger", "sword")},
    },
    "DRG": {
        "Damage": {"Main": ("polearm", "staff"), "Sub": tuple()},
        "Accuracy": {"Main": ("polearm", "staff"), "Sub": tuple()},
        "WeaponSkill": {"Main": ("polearm", "staff"), "Sub": tuple()},
        "Jump": {"Main": ("polearm",), "Sub": tuple()},
    },
    "SMN": {
        "AvatarPerp": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
        "BloodPact": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
        "SummoningMagic": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
        "IdleRefresh": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
    },
    "BLU": {
        "PhysicalBlue": {"Main": ("sword", "club"), "Sub": ("sword", "club", "shield")},
        "MagicalBlue": {"Main": ("sword", "club", "staff"), "Sub": ("sword", "club", "shield", "grip")},
        "FastCast": {"Main": ("sword", "club", "staff"), "Sub": ("sword", "club", "shield", "grip")},
        "Accuracy": {"Main": ("sword", "club"), "Sub": ("sword", "club", "shield")},
    },
    "COR": {
        "RangedDamage": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword"), "Range": ("gun",), "Ammo": ("ammo",)},
        "RangedAccuracy": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword"), "Range": ("gun",), "Ammo": ("ammo",)},
        "QuickDraw": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword"), "Range": ("gun",), "Ammo": ("ammo",)},
        "Roll": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword"), "Range": ("gun",), "Ammo": ("ammo",)},
    },
    "PUP": {
        "Damage": {"Main": ("hand_to_hand",), "Sub": tuple()},
        "Accuracy": {"Main": ("hand_to_hand",), "Sub": tuple()},
        "PetDamage": {"Main": ("hand_to_hand",), "Sub": tuple()},
        "PetTank": {"Main": ("hand_to_hand",), "Sub": tuple()},
    },
    "DNC": {
        "Damage": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
        "Accuracy": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
        "Waltz": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
        "Evasion": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword")},
    },
    "SCH": {
        "Nuke": {"Main": ("staff", "club"), "Sub": ("grip",)},
        "MagicAccuracy": {"Main": ("staff", "club"), "Sub": ("grip",)},
        "FastCast": {"Main": ("staff", "club"), "Sub": ("grip",)},
        "IdleRefresh": {"Main": ("staff", "club"), "Sub": ("grip",)},
    },
    "GEO": {
        "GeoMagic": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
        "Nuke": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
        "FastCast": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
        "IdleRefresh": {"Main": ("staff", "club"), "Sub": ("grip", "shield")},
    },
    "RUN": {
        "Tank": {"Main": ("great_sword", "sword"), "Sub": ("shield",)},
        "MagicDefense": {"Main": ("great_sword", "sword"), "Sub": ("shield",)},
        "Damage": {"Main": ("great_sword", "sword"), "Sub": ("shield",)},
        "Enmity": {"Main": ("great_sword", "sword"), "Sub": ("shield",)},
    },
}

STYLE_INTENTS = {
    "Melt": "TP",
    "Dagger": "TP",
    "Safe": "PDT",
    "Treasure": "TP",
    "Craft": "Crafting",
    "Tank": "PDT",
    "Enmity": "Enmity",
    "Damage": "TP",
    "MagicDefense": "MDT",
    "Nuke": "Nuke",
    "MagicAccuracy": "MagicAccuracy",
    "FastCast": "FastCast",
    "IdleRefresh": "Refresh",
    "Accuracy": "Accuracy",
    "WeaponSkill": "WS",
    "Survival": "PDT",
    "Evasion": "Evasion",
    "Cure": "Cure",
    "Enspell": "TP",
    "DrainAbsorb": "MagicAccuracy",
    "PetDamage": "PetDamage",
    "PetTank": "PetTank",
    "Song": "Song",
    "RangedDamage": "Ranged",
    "RangedAccuracy": "RangedAccuracy",
    "StoreTP": "TP",
    "Ninjutsu": "Ninjutsu",
    "Jump": "WS",
    "AvatarPerp": "Refresh",
    "BloodPact": "PetDamage",
    "SummoningMagic": "MagicAccuracy",
    "PhysicalBlue": "TP",
    "MagicalBlue": "Nuke",
    "QuickDraw": "QuickDraw",
    "Roll": "Roll",
    "Waltz": "Cure",
    "GeoMagic": "MagicAccuracy",
}

LOW_VALUE_COMBAT_ITEM_REASONS = {
    "Gemini Subligar": "Rejected after live THF audit: it has no useful combat value versus Crow Hose or Noct Brais at this level band.",
}

STYLE_ROLE_WEIGHTS = {
    "Melt": {
        "melee_offense": 900,
        "weapon_skill": 450,
        "accuracy": 650,
        "str": 600,
        "dex": 550,
        "agi": 100,
        "combat": 100,
    },
    "Dagger": {
        "dagger_skill": 1100,
        "melee_offense": 850,
        "weapon_skill": 500,
        "accuracy": 700,
        "dex": 650,
        "str": 300,
        "combat": 100,
    },
    "Safe": {
        "evasion": 1000,
        "defense": 650,
        "agi": 350,
        "accuracy": 200,
        "melee_offense": 150,
        "combat": 100,
    },
    "Craft": {
        "crafting": 1000,
        "utility": 100,
    },
}

STYLE_MOD_WEIGHTS = {
    "Melt": {
        "ACC": 28,
        "WSACC": 18,
        "ATT": 12,
        "ATTP": 12,
        "STR": 20,
        "DEX": 18,
        "AGI": 6,
        "ENMITY": -2,
        "STORETP": 24,
        "HASTE_GEAR": 90,
        "SUBTLE_BLOW": 2,
        "ITEM_ADDEFFECT_DMG": 20,
        "ITEM_ADDEFFECT_CHANCE": 30,
        "ITEM_ADDEFFECT_POWER": 10,
        "ITEM_ADDEFFECT_DURATION": 1,
    },
    "Dagger": {
        "ACC": 30,
        "WSACC": 20,
        "ATT": 10,
        "ATTP": 10,
        "STR": 14,
        "DEX": 24,
        "AGI": 6,
        "ENMITY": -2,
        "STORETP": 24,
        "HASTE_GEAR": 90,
        "SUBTLE_BLOW": 2,
        "ITEM_ADDEFFECT_DMG": 20,
        "ITEM_ADDEFFECT_CHANCE": 30,
        "ITEM_ADDEFFECT_POWER": 10,
        "ITEM_ADDEFFECT_DURATION": 1,
    },
    "Safe": {
        "EVA": 35,
        "REVA": 20,
        "DEF": 5,
        "VIT": 8,
        "AGI": 10,
        "HP": 1,
        "ACC": 10,
        "ATT": 3,
        "ENMITY": -3,
    },
    "Treasure": {
        "ACC": 20,
        "ATT": 8,
        "STR": 12,
        "DEX": 12,
        "STORETP": 15,
        "HASTE_GEAR": 60,
    },
    "Tank": {
        "HP": 5,
        "HPP": 30,
        "DEF": 8,
        "VIT": 16,
        "ENMITY": 25,
        "SHIELD": 35,
        "SHIELDBLOCKRATE": 30,
        "MDEF": 8,
        "DMGPHYS": -45,
        "UDMGPHYS": -45,
        "DMGMAGIC": -20,
        "UDMGMAGIC": -20,
        "EVA": 3,
        "ACC": 4,
    },
    "Enmity": {
        "ENMITY": 60,
        "HP": 5,
        "HPP": 30,
        "DEF": 4,
        "VIT": 8,
        "SHIELD": 18,
        "FASTCAST": 18,
        "UFASTCAST": 18,
        "HASTE_GEAR": 30,
    },
    "Damage": {
        "ACC": 30,
        "WSACC": 18,
        "ATT": 16,
        "ATTP": 14,
        "STR": 20,
        "DEX": 16,
        "STORETP": 24,
        "HASTE_GEAR": 90,
        "ENMITY": 4,
    },
    "MagicDefense": {
        "HP": 5,
        "HPP": 30,
        "MDEF": 45,
        "BARSPELL_MDEF_BONUS": 30,
        "DMGMAGIC": -70,
        "UDMGMAGIC": -70,
        "DMGMAGIC_II": -70,
        "FIRE_MEVA": 12,
        "ICE_MEVA": 12,
        "WIND_MEVA": 12,
        "EARTH_MEVA": 12,
        "THUNDER_MEVA": 12,
        "WATER_MEVA": 12,
        "LIGHT_MEVA": 12,
        "DARK_MEVA": 12,
        "DEF": 4,
        "VIT": 8,
    },
    "Nuke": {
        "MATT": 60,
        "MAGIC_DAMAGE": 30,
        "INT": 35,
        "MACC": 20,
        "FIRE_MAB": 50,
        "ICE_MAB": 50,
        "WIND_MAB": 50,
        "EARTH_MAB": 50,
        "THUNDER_MAB": 50,
        "WATER_MAB": 50,
        "LIGHT_MAB": 50,
        "MP": 2,
        "MPP": 12,
        "CONSERVE_MP": 8,
    },
    "MagicAccuracy": {
        "MACC": 65,
        "FIRE_MACC": 50,
        "ICE_MACC": 50,
        "WIND_MACC": 50,
        "EARTH_MACC": 50,
        "THUNDER_MACC": 50,
        "WATER_MACC": 50,
        "LIGHT_MACC": 50,
        "DARK_MACC": 50,
        "INT": 20,
        "MND": 20,
        "MATT": 10,
        "MP": 1,
    },
    "FastCast": {
        "FASTCAST": 100,
        "UFASTCAST": 100,
        "QUICK_MAGIC": 70,
        "HASTE_GEAR": 45,
        "MP": 2,
        "MPP": 10,
        "ENMITY": -4,
    },
    "IdleRefresh": {
        "REFRESH": 250,
        "MPHEAL": 80,
        "CONSERVE_MP": 20,
        "MP": 4,
        "MPP": 25,
        "HP": 2,
        "MDEF": 15,
        "DMGPHYS": -25,
        "DMGMAGIC": -25,
        "UDMGPHYS": -25,
        "UDMGMAGIC": -25,
    },
    "Accuracy": {
        "ACC": 55,
        "WSACC": 35,
        "DEX": 18,
        "ATT": 8,
        "STORETP": 16,
        "HASTE_GEAR": 60,
    },
    "WeaponSkill": {
        "STR": 32,
        "DEX": 28,
        "VIT": 16,
        "AGI": 16,
        "INT": 12,
        "MND": 12,
        "ATT": 20,
        "ACC": 20,
        "WSACC": 30,
        "WSDMG": 70,
        "STORETP": 10,
    },
    "Survival": {
        "HP": 5,
        "HPP": 25,
        "DEF": 8,
        "VIT": 12,
        "EVA": 18,
        "MDEF": 12,
        "DMGPHYS": -45,
        "DMGMAGIC": -35,
        "UDMGPHYS": -45,
        "UDMGMAGIC": -35,
    },
    "Evasion": {
        "EVA": 45,
        "REVA": 25,
        "AGI": 16,
        "DEF": 4,
        "HP": 2,
        "ACC": 8,
        "HASTE_GEAR": 30,
    },
    "Cure": {
        "CURE_POTENCY": 90,
        "CURE_POTENCY_II": 90,
        "CURE_CAST_TIME": -30,
        "MND": 28,
        "MP": 4,
        "MPP": 20,
        "FASTCAST": 25,
        "UFASTCAST": 25,
        "ENMITY": -8,
        "MDEF": 8,
    },
    "Enspell": {
        "ACC": 28,
        "ATT": 12,
        "DEX": 18,
        "STR": 14,
        "HASTE_GEAR": 80,
        "MACC": 18,
        "MATT": 14,
        "INT": 16,
        "MND": 12,
        "ENH_MAGIC_DURATION": 20,
    },
    "DrainAbsorb": {
        "DARK_MACC": 70,
        "MACC": 45,
        "INT": 25,
        "MATT": 20,
        "MP": 3,
        "FASTCAST": 15,
        "ACC": 8,
        "ATT": 8,
    },
    "PetDamage": {
        "PET_ATK": 45,
        "PET_ACC": 45,
        "PET_MAB": 45,
        "PET_STORETP": 25,
        "PET_HASTE": 35,
        "ACC": 10,
        "ATT": 8,
    },
    "PetTank": {
        "PET_DEF": 45,
        "PET_EVA": 45,
        "PET_MDEF": 35,
        "PET_DMG_TAKEN": -60,
        "HP": 3,
        "DEF": 5,
    },
    "Song": {
        "CHR": 35,
        "MACC": 35,
        "SINGING": 50,
        "WIND_INSTRUMENT": 50,
        "STRING_INSTRUMENT": 50,
        "SONG_SPELLCASTING_TIME": -35,
        "FASTCAST": 20,
        "MP": 2,
    },
    "RangedDamage": {
        "RATT": 24,
        "RATTP": 18,
        "RACC": 28,
        "STR": 18,
        "AGI": 22,
        "STORETP": 18,
        "SNAP_SHOT": 60,
    },
    "RangedAccuracy": {
        "RACC": 55,
        "AGI": 24,
        "RATT": 10,
        "ACC": 8,
        "SNAP_SHOT": 35,
    },
    "StoreTP": {
        "STORETP": 60,
        "HASTE_GEAR": 90,
        "ACC": 28,
        "ATT": 14,
        "STR": 14,
        "DEX": 12,
    },
    "Ninjutsu": {
        "NINJUTSU": 70,
        "MACC": 45,
        "INT": 24,
        "MATT": 18,
        "FASTCAST": 25,
        "HASTE_GEAR": 30,
        "EVA": 12,
    },
    "Jump": {
        "STR": 26,
        "DEX": 22,
        "ATT": 18,
        "ACC": 25,
        "STORETP": 24,
        "HASTE_GEAR": 60,
    },
    "AvatarPerp": {
        "AVATAR_PERPETUATION": -90,
        "PERPETUATION_REDUCTION": 90,
        "REFRESH": 180,
        "MP": 5,
        "MPP": 25,
        "SUMMONING_MAGIC": 45,
        "CONSERVE_MP": 20,
    },
    "BloodPact": {
        "BLOOD_BOON": 30,
        "BP_DAMAGE": 75,
        "PET_MAB": 55,
        "PET_ATK": 55,
        "PET_ACC": 45,
        "SUMMONING_MAGIC": 35,
        "MP": 2,
    },
    "SummoningMagic": {
        "SUMMONING_MAGIC": 80,
        "MACC": 25,
        "MP": 4,
        "MPP": 20,
        "CONSERVE_MP": 15,
    },
    "PhysicalBlue": {
        "BLUE_MAGIC_SKILL": 60,
        "STR": 28,
        "DEX": 24,
        "VIT": 18,
        "ACC": 24,
        "ATT": 18,
        "HASTE_GEAR": 55,
    },
    "MagicalBlue": {
        "BLUE_MAGIC_SKILL": 55,
        "MATT": 55,
        "MACC": 35,
        "INT": 30,
        "MAGIC_DAMAGE": 25,
        "MP": 2,
    },
    "QuickDraw": {
        "QUICK_DRAW_MACC": 80,
        "MACC": 35,
        "MATT": 45,
        "AGI": 28,
        "MAGIC_DAMAGE": 18,
        "RACC": 12,
    },
    "Roll": {
        "PHANTOM_ROLL": 80,
        "CHR": 24,
        "RACC": 14,
        "MP": 2,
        "ENMITY": -4,
    },
    "Waltz": {
        "WALTZ_POTENTCY": 90,
        "WALTZ_POTENCY": 90,
        "CHR": 28,
        "VIT": 24,
        "HP": 3,
        "EVA": 18,
        "ENMITY": -4,
    },
    "GeoMagic": {
        "GEOMANCY_SKILL": 80,
        "HANDBELL_SKILL": 80,
        "MACC": 35,
        "MND": 22,
        "INT": 22,
        "MP": 4,
        "FASTCAST": 20,
    },
}


@dataclass(frozen=True)
class SelectedGear:
    slot: str
    item: GearItem
    classification: ClassifiedItem
    reason: str
    score: int


@dataclass(frozen=True)
class BuildResult:
    output_dir: Path
    profile_path: Path
    manifest_path: Path
    profile_text: str
    manifest: dict[str, object]


def build_pack(
    *,
    player: str,
    player_id: str,
    job: str,
    gear_path: Path | str,
    character_path: Path | str,
    output_root: Path | str,
    server_sql_root: Path | str | None = None,
    stats_db_path: Path | str | None = None,
    target_name: str | None = None,
) -> BuildResult:
    job = job.upper()

    export = load_gearexport(gear_path)
    character = load_character_snapshot(character_path)
    contract = build_job_contract(job, character)
    character_level = contract.character_level
    item_stats = _load_default_item_stats(server_sql_root, stats_db_path=stats_db_path)
    target_profile = _load_target_profile(item_stats, target_name)
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in export.items
    )

    selected = _build_job_sets(classified, contract, item_stats, target_profile)
    sets = {
        style: {
            slot: selected_item.item.name
            for slot, selected_item in slot_map.items()
        }
        for style, slot_map in selected.items()
    }
    selected_names = {
        selected_item.item.name
        for slot_map in selected.values()
        for selected_item in slot_map.values()
    }

    manifest = _build_manifest(
        player=player,
        player_id=player_id,
        job=job,
        contract=contract,
        gear_path=Path(gear_path),
        character_path=Path(character_path),
        export_current_job=export.current_job,
        character_current_job=character.current_job,
        export_metadata=export.raw_metadata,
        character_raw=character.raw,
        item_stats=item_stats,
        target_profile=target_profile,
        target_name=target_name,
        sets=sets,
        selected=selected,
        rejected_items=_rejected_manifest(
            classified,
            selected_names=selected_names,
            job=job,
            character_level=character_level,
        ),
    )

    output_dir = Path(output_root) / "packs" / f"{player}_{player_id}" / job
    output_dir.mkdir(parents=True, exist_ok=True)
    profile_text = render_profile(
        player=player,
        player_id=player_id,
        job=job,
        sets=sets,
        default_playstyle=contract.default_playstyle,
        style_intents={
            style.name: STYLE_INTENTS.get(style.name, "TP")
            for style in contract.playstyles
        },
    )
    profile_path = output_dir / f"{job}.lua"
    manifest_path = output_dir / "manifest.json"
    profile_path.write_text(profile_text, encoding="utf-8")
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True), encoding="utf-8")

    return BuildResult(
        output_dir=output_dir,
        profile_path=profile_path,
        manifest_path=manifest_path,
        profile_text=profile_text,
        manifest=manifest,
    )


def _load_default_item_stats(
    server_sql_root: Path | str | None,
    *,
    stats_db_path: Path | str | None = None,
) -> ItemStatsIndex | None:
    stats_db = Path(stats_db_path) if stats_db_path is not None else Path(__file__).resolve().parents[2] / "data" / "oddlua_stats.sqlite"
    if stats_db.exists():
        return load_item_stats_from_db(stats_db)

    root = Path(server_sql_root) if server_sql_root is not None else Path(__file__).resolve().parents[3] / "server" / "sql"
    item_mods = root / "item_mods.sql" if root.is_dir() else root
    if not item_mods.exists():
        return None
    return load_item_stats(root)


def _load_target_profile(item_stats: ItemStatsIndex | None, target_name: str | None) -> TargetProfile | None:
    if not target_name:
        return None
    if item_stats is None or item_stats.source_path.suffix.lower() not in {".sqlite", ".db"}:
        raise ValueError("target_name requires an OddLua SQLite stats database with mobdb tables")
    target = load_target_profile_from_db(item_stats.source_path, target_name=target_name)
    if target is None:
        raise ValueError(f"Target not found in OddLua mobdb stats: {target_name}")
    return target


def _build_job_sets(
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    contract: JobContract,
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None,
) -> dict[str, dict[str, SelectedGear]]:
    sets: dict[str, dict[str, SelectedGear]] = {}
    for style in contract.playstyles:
        if style.name == "Craft":
            sets[style.name] = _build_craft_style(classified, contract.job, contract.character_level)
        elif style.name == "Treasure":
            melt = sets.get("Melt")
            if melt is None:
                melt = _build_combat_style(
                    "Melt",
                    classified,
                    contract.job,
                    contract.character_level,
                    item_stats,
                    target_profile=target_profile,
                )
                sets["Melt"] = melt
            sets[style.name] = _build_treasure_style(
                classified,
                contract.job,
                contract.character_level,
                melt,
                item_stats,
                target_profile=target_profile,
            )
        else:
            sets[style.name] = _build_combat_style(
                style.name,
                classified,
                contract.job,
                contract.character_level,
                item_stats,
                target_profile=target_profile,
            )
    return sets


def _build_combat_style(
    style_name: str,
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex | None,
    *,
    target_profile: TargetProfile | None = None,
) -> dict[str, SelectedGear]:
    style: dict[str, SelectedGear] = {}
    blocked_keys: set[str] = set()
    weapon_family_by_slot = JOB_STYLE_WEAPON_FAMILIES.get(job, {}).get(style_name, {})

    for slot in _slot_order_for_style(weapon_family_by_slot):
        allowed_families = weapon_family_by_slot.get(slot)
        if slot == "Sub":
            main = style.get("Main")
            allowed_families = _sub_families_for_main(allowed_families, main)
        selected = _select_slot(
            style_name,
            slot,
            classified,
            job,
            character_level,
            tuple(),
            allowed_weapon_families=allowed_families,
            blocked_keys=blocked_keys,
            item_stats=item_stats,
            target_profile=target_profile,
        )
        if selected:
            style[slot] = selected
            blocked_keys.add(_item_key(selected.item))
    return style


def _slot_order_for_style(weapon_family_by_slot: dict[str, tuple[str, ...]]) -> tuple[str, ...]:
    if "Range" in weapon_family_by_slot or "Ammo" in weapon_family_by_slot:
        return SLOT_ORDER
    return COMBAT_SLOT_ORDER


def _sub_families_for_main(
    configured: tuple[str, ...] | None,
    main: SelectedGear | None,
) -> tuple[str, ...] | None:
    if main is None or configured is None:
        return configured
    main_family = main.classification.weapon_family
    if main_family in TWO_HANDED_WEAPON_FAMILIES:
        return tuple(family for family in configured if family == "grip")
    if main_family == "hand_to_hand":
        return tuple()
    return configured


def _build_treasure_style(
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    melt: dict[str, SelectedGear],
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None = None,
) -> dict[str, SelectedGear]:
    treasure_items = [
        (item, classification)
        for item, classification in classified
        if _is_eligible_combat_item(item, classification, job, character_level)
        and "treasure" in classification.roles
    ]
    if not treasure_items:
        return {
            slot: _copy_selected(
                selected,
                "Treasure has no useful eligible TH gear at this level; falling back to Melt to preserve kill speed.",
            )
            for slot, selected in melt.items()
        }

    treasure = {
        slot: _copy_selected(
            selected,
            "Treasure starts from Melt so TH gear cannot degrade the baseline kill-speed set.",
        )
        for slot, selected in melt.items()
    }
    for item, classification in treasure_items:
        for slot in COMBAT_SLOT_ORDER:
            if item.has_slot(slot):
                score = _score_item(
                    "Treasure",
                    slot,
                    item,
                    classification,
                    tuple(),
                    item_stats=item_stats,
                    target_profile=target_profile,
                )
                current = treasure.get(slot)
                if current is None or score > current.score:
                    treasure[slot] = SelectedGear(
                        slot=slot,
                        item=item,
                        classification=classification,
                        reason="Eligible Treasure Hunter or farming item improves Treasure style without using utility gear.",
                        score=score,
                    )
    return treasure


def _build_craft_style(
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
) -> dict[str, SelectedGear]:
    craft: dict[str, SelectedGear] = {}
    for slot in COMBAT_SLOT_ORDER:
        selected = _select_slot(
            "Craft",
            slot,
            classified,
            job,
            character_level,
            tuple(),
            include_crafting=True,
        )
        if selected:
            craft[slot] = selected
    return craft


def _copy_selected(selected: SelectedGear, reason: str) -> SelectedGear:
    return SelectedGear(
        slot=selected.slot,
        item=selected.item,
        classification=selected.classification,
        reason=reason,
        score=selected.score,
    )


def _select_slot(
    style_name: str,
    slot: str,
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    preferred_names: tuple[str, ...],
    *,
    required_weapon_family: str | None = None,
    allowed_weapon_families: tuple[str, ...] | None = None,
    blocked_keys: set[str] | None = None,
    include_crafting: bool = False,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
) -> SelectedGear | None:
    candidates: list[SelectedGear] = []
    blocked_keys = blocked_keys or set()

    for item, classification in classified:
        if _item_key(item) in blocked_keys:
            continue
        if not item.has_slot(slot):
            continue
        if include_crafting:
            if classification.exclusion_reason != "Crafting":
                continue
        elif not _is_eligible_combat_item(item, classification, job, character_level):
            continue
        if include_crafting and (
            not classification.level_eligible(character_level)
            or not classification.job_eligible(job)
        ):
            continue
        if required_weapon_family and classification.weapon_family != required_weapon_family:
            continue
        allowed_families = allowed_weapon_families
        if allowed_families is None and required_weapon_family:
            allowed_families = (required_weapon_family,)
        if allowed_families is None and slot in WEAPON_SLOTS:
            allowed_families = tuple(sorted(COMBAT_WEAPON_FAMILIES))
        if slot in WEAPON_SLOTS and classification.weapon_family not in allowed_families:
            continue

        score = _score_item(
            style_name,
            slot,
            item,
            classification,
            preferred_names,
            item_stats=item_stats,
            target_profile=target_profile,
        )
        candidates.append(
            SelectedGear(
                slot=slot,
                item=item,
                classification=classification,
                reason=_selection_reason(
                    style_name,
                    slot,
                    item,
                    classification,
                    preferred_names,
                    item_stats=item_stats,
                    target_profile=target_profile,
                ),
                score=score,
            )
        )

    if not candidates:
        return None
    return max(candidates, key=lambda selected: (selected.score, selected.item.level, selected.item.name))


def _item_key(item: GearItem) -> str:
    index = item.raw_stats.get("index", "")
    container_id = item.raw_stats.get("container_id", "")
    return f"{item.id}|{item.name}|{item.storage}|{container_id}|{index}"


def _is_eligible_combat_item(
    item: GearItem,
    classification: ClassifiedItem,
    job: str,
    character_level: int,
) -> bool:
    if classification.excluded:
        return False
    if item.name in LOW_VALUE_COMBAT_ITEM_REASONS:
        return False
    if not classification.level_eligible(character_level):
        return False
    if not classification.job_eligible(job):
        return False
    if classification.weapon_family in {"fishing_rod", "fishing_ammo"}:
        return False
    return True


def _score_item(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    preferred_names: tuple[str, ...],
    *,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
) -> int:
    if style_name == "Craft":
        score = item.level * 8
        for role in classification.roles:
            score += STYLE_ROLE_WEIGHTS.get(style_name, {}).get(role, 0)
        return score

    score = _mod_score(style_name, classification)

    if slot in WEAPON_SLOTS:
        score += _weapon_score(item, classification, item_stats, target_profile)
    return score


def _selection_reason(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    preferred_names: tuple[str, ...],
    *,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
) -> str:
    if style_name == "Safe":
        return f"Calculated for Safe from {_score_evidence(style_name, slot, item, classification, item_stats, target_profile)}."
    if style_name == "Craft":
        return "Selected only for non-engaged Craft mode; combat playstyles hard-exclude crafting utility gear."
    return f"Calculated for {style_name} from {_score_evidence(style_name, slot, item, classification, item_stats, target_profile)}."


def _mod_score(style_name: str, classification: ClassifiedItem) -> int:
    weights = STYLE_MOD_WEIGHTS.get(style_name, {})
    return sum(
        value * weights.get(name, 0)
        for name, value in classification.server_mods
    )


def _weapon_score(
    item: GearItem,
    classification: ClassifiedItem,
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None,
) -> int:
    if item_stats is None:
        base_score = item.level * 100
        return base_score + _target_weapon_bonus(classification, base_score, target_profile)
    weapon_stats = item_stats.weapon_stats_for_item_id(item.id)
    if weapon_stats is None:
        base_score = item.level * 100
        return base_score + _target_weapon_bonus(classification, base_score, target_profile)
    base_score = weapon_stats.dps_score
    return base_score + _target_weapon_bonus(classification, base_score, target_profile)


def _target_weapon_bonus(
    classification: ClassifiedItem,
    base_score: int,
    target_profile: TargetProfile | None,
) -> int:
    if target_profile is None or base_score <= 0:
        return 0
    damage_type = DAMAGE_TYPE_BY_WEAPON_FAMILY.get(classification.weapon_family)
    if damage_type is None:
        return 0
    sdt = target_profile.physical_sdt.get(damage_type, 0)
    return int(base_score * sdt / 10_000)


def _score_evidence(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None = None,
) -> str:
    weights = STYLE_MOD_WEIGHTS.get(style_name, {})
    weighted_mods = [
        f"{name}{value:+d}"
        for name, value in classification.server_mods
        if weights.get(name, 0) != 0 and value != 0
    ]
    parts: list[str] = []
    if slot in WEAPON_SLOTS:
        weapon_stats = item_stats.weapon_stats_for_item_id(item.id) if item_stats else None
        if weapon_stats is not None:
            parts.append(f"weapon damage {weapon_stats.damage}, delay {weapon_stats.delay}")
        if target_profile is not None:
            damage_type = DAMAGE_TYPE_BY_WEAPON_FAMILY.get(classification.weapon_family)
            if damage_type:
                sdt = target_profile.physical_sdt.get(damage_type, 0)
                if sdt:
                    parts.append(f"target {target_profile.name} {damage_type} SDT {sdt:+d}")
    if weighted_mods:
        parts.append("weighted mods " + ", ".join(weighted_mods))
    if not parts:
        parts.append("eligible gear tie-breakers; no weighted combat mods")
    return "; ".join(parts)


def _build_manifest(
    *,
    player: str,
    player_id: str,
    job: str,
    contract: JobContract,
    gear_path: Path,
    character_path: Path,
    export_current_job: str,
    character_current_job: str,
    export_metadata: dict[str, object],
    character_raw: dict[str, object],
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None,
    target_name: str | None,
    sets: dict[str, dict[str, str]],
    selected: dict[str, dict[str, SelectedGear]],
    rejected_items: dict[str, object],
) -> dict[str, object]:
    return {
        "player": player,
        "playerId": player_id,
        "job": job,
        "level": contract.character_level,
        "levelSource": contract.level_source,
        "defaultPlaystyle": contract.default_playstyle,
        "playstyles": [style.name for style in contract.playstyles],
        "contract": contract.manifest_metadata(),
        "sets": sets,
        "selectedItems": {
            style_name: {
                slot: _selected_manifest(selected_item)
                for slot, selected_item in slot_map.items()
            }
            for style_name, slot_map in selected.items()
        },
        "rejectedItems": rejected_items,
        "serverItemStats": _server_item_stats_manifest(item_stats),
        "targetProfile": target_profile.manifest_metadata() if target_profile else empty_target_manifest(target_name),
        "catseyeSnapshot": _snapshot_manifest(
            gear_path=gear_path,
            character_path=character_path,
            export_current_job=export_current_job,
            character_current_job=character_current_job,
            export_metadata=export_metadata,
            character_raw=character_raw,
        ),
    }


def _server_item_stats_manifest(item_stats: ItemStatsIndex | None) -> dict[str, object]:
    if item_stats is None:
        return {
            "loaded": False,
            "sourcePath": "",
            "sourceKind": "",
            "itemCount": 0,
            "foodItemCount": 0,
            "foodModCount": 0,
        }
    return {
        "loaded": True,
        "sourcePath": str(item_stats.source_path),
        "sourceKind": "sqlite" if item_stats.source_path.suffix.lower() in {".sqlite", ".db"} else "sql",
        "itemCount": len(item_stats.mods_by_item_id),
        "foodItemCount": len(item_stats.food_mods_by_item_id),
        "foodModCount": sum(len(mods) for mods in item_stats.food_mods_by_item_id.values()),
    }


def _selected_manifest(selected: SelectedGear) -> dict[str, object]:
    item = selected.item
    return {
        "item": item.name,
        "slot": selected.slot,
        "reason": selected.reason,
        "score": selected.score,
        "level": item.level,
        "slots": item.slot,
        "jobs": list(item.jobs),
        "storage": item.storage,
        "classification": selected.classification.manifest_metadata(),
    }


def _rejected_manifest(
    classified: Iterable[tuple[GearItem, ClassifiedItem]],
    *,
    selected_names: set[str],
    job: str,
    character_level: int,
) -> dict[str, object]:
    rejected: dict[str, object] = {}
    for item, classification in classified:
        if item.name in selected_names:
            continue
        reason, detail = _rejection_reason(item, classification, job, character_level)
        if not reason:
            continue

        existing = rejected.get(item.name)
        entry = {
            "reason": reason,
            "detail": detail,
            "level": item.level,
            "slots": item.slot,
            "jobs": list(item.jobs),
            "storage": item.storage,
            "classification": classification.manifest_metadata(),
        }
        if existing is None or _reason_priority(reason) > _reason_priority(str(existing.get("reason"))):
            rejected[item.name] = entry
    return dict(sorted(rejected.items()))


def _rejection_reason(
    item: GearItem,
    classification: ClassifiedItem,
    job: str,
    character_level: int,
) -> tuple[str, str]:
    if classification.excluded:
        return classification.exclusion_reason, "Hard exclusion from combat sets."
    if item.name in LOW_VALUE_COMBAT_ITEM_REASONS:
        return "PolicyExcluded", LOW_VALUE_COMBAT_ITEM_REASONS[item.name]
    if not classification.level_eligible(character_level):
        return "LevelIneligible", f"Requires level {item.level}; CharacterSnapshot {job} level is {character_level}."
    if not classification.job_eligible(job):
        return "WrongJob", f"Item jobs do not include {job}."
    if classification.slot_family == "weapon" and classification.weapon_family not in _job_allowed_weapon_families(job):
        return "WrongWeaponFamily", f"Weapon family {classification.weapon_family} is not used by this {job} playstyle builder."
    if classification.slot_family in {"weapon", "armor", "accessory"}:
        return "LowerScore", "Eligible owned item, but another item scored higher for the generated playstyle sets."
    return "", ""


def _job_allowed_weapon_families(job: str) -> set[str]:
    families: set[str] = set()
    for style_rules in JOB_STYLE_WEAPON_FAMILIES.get(job, {}).values():
        for slot_families in style_rules.values():
            families.update(slot_families)
    return families or set(COMBAT_WEAPON_FAMILIES)


def _reason_priority(reason: str) -> int:
    return {
        "Fishing": 90,
        "Crafting": 90,
        "Utility": 90,
        "PolicyExcluded": 85,
        "LevelIneligible": 80,
        "WrongJob": 70,
        "WrongWeaponFamily": 60,
        "LowerScore": 10,
    }.get(reason, 0)


def _snapshot_manifest(
    *,
    gear_path: Path,
    character_path: Path,
    export_current_job: str,
    character_current_job: str,
    export_metadata: dict[str, object],
    character_raw: dict[str, object],
) -> dict[str, object]:
    player = character_raw.get("player")
    if not isinstance(player, dict):
        player = {}
    settings = character_raw.get("settings")
    if not isinstance(settings, dict):
        settings = {}

    return {
        "gearPath": str(gear_path),
        "characterPath": str(character_path),
        "currentJob": export_current_job,
        "characterCurrentJob": character_current_job,
        "playerName": player.get("name", ""),
        "serverId": player.get("serverId", ""),
        "zoneName": player.get("zoneName", ""),
        "clientRoot": settings.get("clientRoot", ""),
        "exportMetadata": export_metadata,
        "characterVersion": character_raw.get("version", ""),
    }
