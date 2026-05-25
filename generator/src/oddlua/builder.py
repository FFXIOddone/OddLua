from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
from typing import Iterable

from .classifier import ClassifiedItem, classify_item
from .contracts import JobContract, Playstyle, build_job_contract
from .gearexport import GearItem, load_character_snapshot, load_gearexport
from .itemstats import EQUIPMENT_SLOT_MASKS, ItemStatsIndex, load_item_stats, load_item_stats_from_db
from .mechanics import mechanics_manifest_for_style, mechanics_source_manifest, score_mechanics_mods
from .mobstats import TargetProfile, empty_target_manifest, load_target_profile_from_db
from .renderer import SEMANTIC_SET_PREFERENCES, SLOT_ORDER, render_profile
from .subjobs import SubjobProfile, build_subjob_profiles, subjob_manifest


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
OFFHAND_WEAPON_FAMILIES = {"axe", "club", "dagger", "katana", "sword"}
NON_DUAL_WIELD_SUB_FAMILIES = {"shield", "grip"}
NATIVE_DUAL_WIELD_JOBS = {"NIN", "DNC"}
DUAL_WIELD_SUBJOBS = {"NIN", "DNC"}
MOVEMENT_SEMANTIC_STYLES = ("Movement", "Movement_City", "Movement_Night", "Movement_DuskToDawn")
AUTOMATIC_SEMANTIC_STYLES = tuple(SEMANTIC_SET_PREFERENCES)
DAMAGE_WEAPON_SCORE_STYLES = {
    "Accuracy",
    "Damage",
    "Dagger",
    "Enspell",
    "Jump",
    "Melt",
    "PhysicalBlue",
    "RangedAccuracy",
    "RangedDamage",
    "StoreTP",
    "Treasure",
    "WeaponSkill",
}
NON_DAMAGE_WEAPON_SCORE_STYLES = {
    "AvatarPerp",
    "BloodPact",
    "Cure",
    "DrainAbsorb",
    "FastCast",
    "GeoMagic",
    "IdleRefresh",
    "MagicAccuracy",
    "MagicDefense",
    "MagicalBlue",
    "Movement",
    "Movement_City",
    "Movement_DuskToDawn",
    "Movement_Night",
    "Ninjutsu",
    "Nuke",
    "PetDamage",
    "PetTank",
    "QuickDraw",
    "Resting",
    "Roll",
    "Song",
    "SummoningMagic",
    "Waltz",
}

SEMANTIC_SCORING_OVERRIDES = {
    "Aftercast": "IdleRefresh",
    "Barspell": "MagicDefense",
    "Crafting": "Craft",
    "Dia": "MagicAccuracy",
    "Divine": "MagicAccuracy",
    "Enhancing": "FastCast",
    "EnhancingDuration": "FastCast",
    "Haste": "FastCast",
    "Hybrid": "Survival",
    "Idle": "IdleRefresh",
    "JobAbility": "Enmity",
    "PDT": "Survival",
    "Phalanx": "MagicDefense",
    "Regen": "Cure",
    "Refresh": "IdleRefresh",
    "Samba": "Damage",
    "Snapshot": "RangedAccuracy",
    "TP": "Damage",
    "TPAccuracy": "Accuracy",
    "Waltz": "Waltz",
    "Weaponskill": "WeaponSkill",
}

MOVEMENT_LATENT_CONDITIONS: dict[str, tuple[tuple[int, int | None], ...]] = {
    "Movement_City": ((54, None),),  # ZONE_HOME_NATION: used by aketons.
    "Movement_Night": ((26, 1),),  # TIME_OF_DAY: nighttime.
    "Movement_DuskToDawn": ((26, 2),),  # TIME_OF_DAY: dusk through dawn.
}
STACKING_MOVEMENT_MODS = {"MOVE_SPEED_STACKABLE"}


@dataclass(frozen=True)
class WeaponSlotPolicy:
    fixed_item_ids: tuple[int, ...] = tuple()
    preferred_item_ids: tuple[int, ...] = tuple()

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
        "Enspell": {"Main": ("sword", "dagger", "club", "staff"), "Sub": ("sword", "dagger", "club", "shield", "grip")},
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

JOB_STYLE_WEAPON_POLICIES = {
    ("RDM", "Enspell"): {
        "Main": WeaponSlotPolicy(fixed_item_ids=(18904,)),  # Somnia Melodiam / Ephemeron
        "Sub": WeaponSlotPolicy(preferred_item_ids=(20720, 18852)),  # Egeking, Octave Club
    },
}

PREFERRED_ITEM_ID_BONUS = 10_000_000

JOB_STYLE_SUBJOB_HINTS = {
    ("WAR", "Damage"): "NIN",
    ("WAR", "Accuracy"): "NIN",
    ("WAR", "WeaponSkill"): "NIN",
    ("RDM", "Enspell"): "NIN",
    ("THF", "Melt"): "NIN",
    ("THF", "Dagger"): "NIN",
    ("THF", "Safe"): "NIN",
    ("THF", "Treasure"): "NIN",
    ("BST", "Damage"): "NIN",
    ("BST", "Accuracy"): "NIN",
    ("BST", "PetDamage"): "NIN",
    ("RNG", "RangedDamage"): "NIN",
    ("RNG", "RangedAccuracy"): "NIN",
    ("RNG", "WeaponSkill"): "NIN",
    ("RNG", "Evasion"): "NIN",
    ("BLU", "PhysicalBlue"): "NIN",
    ("BLU", "Accuracy"): "NIN",
    ("COR", "RangedDamage"): "NIN",
    ("COR", "RangedAccuracy"): "NIN",
    ("COR", "QuickDraw"): "NIN",
    ("COR", "Roll"): "NIN",
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
    "Movement": "Movement",
    "Movement_City": "Movement",
    "Movement_Night": "Movement",
    "Movement_DuskToDawn": "Movement",
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

LOW_VALUE_COMBAT_ITEM_ID_REASONS = {
    15377: "Rejected after live THF audit: it has no useful combat value versus Crow Hose or Noct Brais at this level band.",
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
    "Resting": {
        "MPHEAL": 220,
        "HPHEAL": 120,
        "MP": 5,
        "MPP": 30,
        "HP": 2,
        "HPP": 10,
        "MND": 3,
        "MDEF": 8,
        "REFRESH": 20,
    },
    "Movement": {
        "MOVE_SPEED_GEAR_BONUS": 1200,
        "MOVE_SPEED_OVERRIDE": 1200,
        "MOVE_SPEED_QUICKENING": 600,
        "MOVE_SPEED_MAZURKA": 600,
        "MOUNT_MOVE": 100,
        "MOVE_SPEED_STACKABLE": 1200,
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

for _movement_style in MOVEMENT_SEMANTIC_STYLES[1:]:
    STYLE_MOD_WEIGHTS[_movement_style] = STYLE_MOD_WEIGHTS["Movement"]


def _scoring_style_name(style_name: str) -> str:
    if style_name in STYLE_MOD_WEIGHTS:
        return style_name
    if _is_elemental_semantic(style_name):
        return "Nuke"

    override = SEMANTIC_SCORING_OVERRIDES.get(style_name)
    if override:
        return override

    for preferred_style in SEMANTIC_SET_PREFERENCES.get(style_name, tuple()):
        if preferred_style in STYLE_MOD_WEIGHTS:
            return preferred_style
        if _is_elemental_semantic(preferred_style):
            return "Nuke"
    return style_name


def _is_elemental_semantic(style_name: str) -> bool:
    return style_name.startswith(("Elemental_", "Weather_", "Day_"))


def _style_mod_weights(style_name: str) -> dict[str, int]:
    return STYLE_MOD_WEIGHTS.get(_scoring_style_name(style_name), {})


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
    subjob_profiles = _load_subjob_profiles(job, item_stats)
    default_subjob = _default_subjob_for_contract(contract, character.current_job)
    style_subjobs = _style_subjobs_for_contract(contract)
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
    selected_keys = {
        _item_key(selected_item.item)
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
        subjob_profiles=subjob_profiles,
        default_subjob=default_subjob,
        style_subjobs=style_subjobs,
        sets=sets,
        selected=selected,
        rejected_items=_rejected_manifest(
            classified,
            selected_keys=selected_keys,
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
        playstyle_names=tuple(style.name for style in contract.playstyles),
        style_intents={
            style.name: STYLE_INTENTS.get(style.name, "TP")
            for style in contract.playstyles
        },
        subjob_profiles=subjob_profiles,
        default_subjob=default_subjob,
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


def _load_subjob_profiles(job: str, item_stats: ItemStatsIndex | None) -> dict[str, SubjobProfile]:
    db_path: Path | None = None
    if item_stats is not None and item_stats.source_path.suffix.lower() in {".sqlite", ".db"}:
        db_path = item_stats.source_path
    return build_subjob_profiles(job, db_path=db_path)


def _current_subjob_abbr(current_job: str) -> str:
    if "/" not in current_job:
        return ""
    subjob_part = current_job.split("/", 1)[1].strip().upper()
    letters = []
    for char in subjob_part:
        if not char.isalpha():
            break
        letters.append(char)
    return "".join(letters)


def _current_main_job_abbr(current_job: str) -> str:
    main_job_part = current_job.split("/", 1)[0].strip().upper()
    letters = []
    for char in main_job_part:
        if not char.isalpha():
            break
        letters.append(char)
    return "".join(letters)


def _default_subjob_for_contract(contract: JobContract, current_job: str) -> str:
    style_hint = JOB_STYLE_SUBJOB_HINTS.get((contract.job, contract.default_playstyle))
    if style_hint:
        return style_hint
    if _current_main_job_abbr(current_job) == contract.job:
        return _current_subjob_abbr(current_job)
    return ""


def _style_subjobs_for_contract(contract: JobContract) -> dict[str, str]:
    return {
        style.name: subjob
        for style in contract.playstyles
        if (subjob := JOB_STYLE_SUBJOB_HINTS.get((contract.job, style.name)))
    }


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
    for style_name in AUTOMATIC_SEMANTIC_STYLES:
        if style_name not in sets:
            if _scoring_style_name(style_name) == "Craft":
                sets[style_name] = _build_craft_style(classified, contract.job, contract.character_level)
            else:
                sets[style_name] = _build_combat_style(
                    style_name,
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
    if style_name in MOVEMENT_SEMANTIC_STYLES:
        return _build_movement_style(
            style_name,
            classified,
            job,
            character_level,
            item_stats,
            target_profile=target_profile,
        )

    style: dict[str, SelectedGear] = {}
    blocked_keys: set[str] = set()
    scoring_style = _scoring_style_name(style_name)
    weapon_family_by_slot = (
        JOB_STYLE_WEAPON_FAMILIES.get(job, {}).get(style_name)
        or JOB_STYLE_WEAPON_FAMILIES.get(job, {}).get(scoring_style)
        or {}
    )
    weapon_policy_by_slot = (
        JOB_STYLE_WEAPON_POLICIES.get((job, style_name))
        or JOB_STYLE_WEAPON_POLICIES.get((job, scoring_style))
        or {}
    )

    for slot in _slot_order_for_style(weapon_family_by_slot):
        allowed_families = weapon_family_by_slot.get(slot)
        if slot == "Sub":
            main = style.get("Main")
            allowed_families = _sub_families_for_main(allowed_families, main)
            allowed_families = _non_damage_sub_families_for_main(style_name, job, main, allowed_families)
            allowed_families = _dual_wield_gated_sub_families(
                allowed_families,
                job,
                style_name,
            )
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
            slot_policy=weapon_policy_by_slot.get(slot),
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


def _non_damage_sub_families_for_main(
    style_name: str,
    job: str,
    main: SelectedGear | None,
    configured: tuple[str, ...] | None,
) -> tuple[str, ...] | None:
    if _uses_weapon_damage_score(style_name) or configured is not None:
        return configured
    if main is not None:
        main_family = main.classification.weapon_family
        if main_family in TWO_HANDED_WEAPON_FAMILIES:
            return ("grip",)
        if main_family == "hand_to_hand":
            return tuple()
    if _style_has_dual_wield(job, style_name):
        return configured
    return tuple(sorted(NON_DUAL_WIELD_SUB_FAMILIES))


def _dual_wield_gated_sub_families(
    configured: tuple[str, ...] | None,
    job: str,
    style_name: str,
) -> tuple[str, ...] | None:
    if configured is None or not any(family in OFFHAND_WEAPON_FAMILIES for family in configured):
        return configured
    if _style_has_dual_wield(job, style_name):
        return configured
    gated = tuple(family for family in configured if family in NON_DUAL_WIELD_SUB_FAMILIES)
    return gated


def _style_has_dual_wield(job: str, style_name: str) -> bool:
    if job in NATIVE_DUAL_WIELD_JOBS:
        return True
    scoring_style = _scoring_style_name(style_name)
    return (
        JOB_STYLE_SUBJOB_HINTS.get((job, style_name)) in DUAL_WIELD_SUBJOBS
        or JOB_STYLE_SUBJOB_HINTS.get((job, scoring_style)) in DUAL_WIELD_SUBJOBS
    )


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
            if _slot_eligible(item, classification, slot):
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


def _build_movement_style(
    style_name: str,
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex | None,
    *,
    target_profile: TargetProfile | None = None,
) -> dict[str, SelectedGear]:
    candidates_by_slot = {
        slot: _slot_candidates(
            style_name,
            slot,
            classified,
            job,
            character_level,
            tuple(),
            item_stats=item_stats,
            target_profile=target_profile,
        )
        for slot in COMBAT_SLOT_ORDER
    }
    selected_by_slot: dict[str, SelectedGear] = {}
    best_rank: tuple[int, int, int, int, int, int] | None = None

    def walk(
        index: int,
        selected: dict[str, SelectedGear],
        occupied_slots: set[str],
        blocked_keys: set[str],
    ) -> None:
        nonlocal selected_by_slot, best_rank
        if index >= len(COMBAT_SLOT_ORDER):
            rank = _movement_set_rank(style_name, selected, item_stats)
            if best_rank is None or rank > best_rank:
                best_rank = rank
                selected_by_slot = dict(selected)
            return

        slot = COMBAT_SLOT_ORDER[index]
        if slot in occupied_slots:
            walk(index + 1, selected, occupied_slots, blocked_keys)
            return

        walk(index + 1, selected, occupied_slots, blocked_keys)
        for candidate in candidates_by_slot.get(slot, ()):
            key = _item_key(candidate.item)
            if key in blocked_keys:
                continue
            candidate_slots = set(_occupied_slots_for_selected(candidate))
            if candidate_slots & occupied_slots:
                continue
            selected[slot] = candidate
            walk(index + 1, selected, occupied_slots | candidate_slots, blocked_keys | {key})
            selected.pop(slot, None)

    walk(0, {}, set(), set())
    return selected_by_slot


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
    slot_policy: WeaponSlotPolicy | None = None,
) -> SelectedGear | None:
    candidates = _slot_candidates(
        style_name,
        slot,
        classified,
        job,
        character_level,
        preferred_names,
        required_weapon_family=required_weapon_family,
        allowed_weapon_families=allowed_weapon_families,
        blocked_keys=blocked_keys,
        include_crafting=include_crafting,
        item_stats=item_stats,
        target_profile=target_profile,
        slot_policy=slot_policy,
    )
    fixed_item_ids = set(slot_policy.fixed_item_ids) if slot_policy else set()

    if not candidates:
        return None
    if fixed_item_ids:
        fixed_candidates = [selected for selected in candidates if selected.item.id in fixed_item_ids]
        if fixed_candidates:
            candidates = fixed_candidates
    return max(candidates, key=lambda selected: (selected.score, selected.item.level, selected.item.id))


def _slot_candidates(
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
    slot_policy: WeaponSlotPolicy | None = None,
) -> list[SelectedGear]:
    candidates: list[SelectedGear] = []
    blocked_keys = blocked_keys or set()
    for item, classification in classified:
        if _item_key(item) in blocked_keys:
            continue
        if not _slot_eligible(item, classification, slot):
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
        if _is_movement_style(style_name) and (classification.server_removal_slot_mask or 0):
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
            slot_policy=slot_policy,
        )
        if score <= 0:
            continue
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
                    slot_policy=slot_policy,
                ),
                score=score,
            )
        )

    return candidates


def _item_key(item: GearItem) -> str:
    index = item.raw_stats.get("index", "")
    container_id = item.raw_stats.get("container_id", "")
    return f"{item.id}|{item.storage}|{container_id}|{index}"


def _occupied_slots_for_selected(selected: SelectedGear) -> tuple[str, ...]:
    slot_mask = selected.classification.server_slot_mask or 0
    removal_slot_mask = selected.classification.server_removal_slot_mask or 0
    occupied_mask = slot_mask | removal_slot_mask
    occupied_slots = tuple(
        slot
        for slot in SLOT_ORDER
        if occupied_mask & EQUIPMENT_SLOT_MASKS.get(slot, 0)
    )
    return occupied_slots or (selected.slot,)


def _movement_set_rank(
    style_name: str,
    selected_by_slot: dict[str, SelectedGear],
    item_stats: ItemStatsIndex | None,
) -> tuple[int, int, int, int, int, int]:
    nonstacking_scores: dict[str, int] = {}
    stacking_score = 0
    conditional_latent_score = 0
    total_item_score = 0
    occupied_slots: set[str] = set()
    removal_slot_count = 0

    for selected in selected_by_slot.values():
        total_item_score += selected.score
        occupied_slots.update(_occupied_slots_for_selected(selected))
        removal_slot_count += (selected.classification.server_removal_slot_mask or 0).bit_count()
        for mod_name, weighted_value in _movement_weighted_mods(style_name, selected, item_stats):
            if mod_name in STACKING_MOVEMENT_MODS:
                stacking_score += weighted_value
            else:
                nonstacking_scores[mod_name] = max(nonstacking_scores.get(mod_name, 0), weighted_value)
        conditional_latent_score += _movement_conditional_latent_score(style_name, selected, item_stats)

    movement_score = stacking_score + sum(nonstacking_scores.values())
    return (
        movement_score,
        conditional_latent_score,
        -removal_slot_count,
        -len(occupied_slots),
        -len(selected_by_slot),
        total_item_score,
    )


def _movement_weighted_mods(
    style_name: str,
    selected: SelectedGear,
    item_stats: ItemStatsIndex | None,
) -> tuple[tuple[str, int], ...]:
    weights = _style_mod_weights(style_name)
    weighted: list[tuple[str, int]] = []
    for mod_name, value in selected.classification.server_mods:
        weight = weights.get(mod_name, 0)
        if weight and value:
            weighted.append((mod_name, value * weight))
    if item_stats is not None:
        for latent in item_stats.latents_for_item_id(selected.item.id):
            if not _latent_applies_to_style(style_name, latent.condition_id, latent.condition_value):
                continue
            weight = weights.get(latent.name, 0)
            if weight and latent.value:
                weighted.append((latent.name, latent.value * weight))
    return tuple(weighted)


def _movement_conditional_latent_score(
    style_name: str,
    selected: SelectedGear,
    item_stats: ItemStatsIndex | None,
) -> int:
    if item_stats is None:
        return 0
    weights = _style_mod_weights(style_name)
    score = 0
    for latent in item_stats.latents_for_item_id(selected.item.id):
        if not _latent_applies_to_style(style_name, latent.condition_id, latent.condition_value):
            continue
        score += latent.value * weights.get(latent.name, 0)
    return score


def _is_eligible_combat_item(
    item: GearItem,
    classification: ClassifiedItem,
    job: str,
    character_level: int,
) -> bool:
    if classification.excluded:
        return False
    if item.id in LOW_VALUE_COMBAT_ITEM_ID_REASONS:
        return False
    if not classification.level_eligible(character_level):
        return False
    if not classification.job_eligible(job):
        return False
    if classification.weapon_family in {"fishing_rod", "fishing_ammo"}:
        return False
    return True


def _slot_eligible(item: GearItem, classification: ClassifiedItem, slot: str) -> bool:
    if classification.server_slot_mask is not None:
        return classification.slot_eligible(slot)
    return False


def _score_item(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    preferred_names: tuple[str, ...],
    *,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
    slot_policy: WeaponSlotPolicy | None = None,
) -> int:
    if style_name == "Craft":
        score = item.level * 8
        for role in classification.roles:
            score += STYLE_ROLE_WEIGHTS.get(style_name, {}).get(role, 0)
        return score

    score = _mod_score(style_name, classification)
    score += _latent_mod_score(style_name, item, item_stats)

    if slot in WEAPON_SLOTS:
        if _uses_weapon_damage_score(style_name):
            score += _weapon_score(item, classification, item_stats, target_profile)
            score += _weapon_policy_bonus(item, slot_policy)
    return score


def _uses_weapon_damage_score(style_name: str) -> bool:
    if style_name in STYLE_MOD_WEIGHTS:
        return style_name not in NON_DAMAGE_WEAPON_SCORE_STYLES
    return _scoring_style_name(style_name) in DAMAGE_WEAPON_SCORE_STYLES


def _is_movement_style(style_name: str) -> bool:
    return style_name in MOVEMENT_SEMANTIC_STYLES or _scoring_style_name(style_name) == "Movement"


def _selection_reason(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    preferred_names: tuple[str, ...],
    *,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
    slot_policy: WeaponSlotPolicy | None = None,
) -> str:
    if style_name == "Safe":
        return f"Calculated for Safe from {_score_evidence(style_name, slot, item, classification, item_stats, target_profile, slot_policy)}."
    if style_name == "Craft":
        return "Selected only for non-engaged Craft mode; combat playstyles hard-exclude crafting utility gear."
    return f"Calculated for {style_name} from {_score_evidence(style_name, slot, item, classification, item_stats, target_profile, slot_policy)}."


def _mod_score(style_name: str, classification: ClassifiedItem) -> int:
    weights = _style_mod_weights(style_name)
    return score_mechanics_mods(
        _scoring_style_name(style_name),
        classification.server_mods,
        classification.pet_server_mods,
        weights,
    ).score


def _latent_mod_score(
    style_name: str,
    item: GearItem,
    item_stats: ItemStatsIndex | None,
) -> int:
    if item_stats is None:
        return 0
    weights = _style_mod_weights(style_name)
    if not weights:
        return 0

    score = 0
    for latent in item_stats.latents_for_item_id(item.id):
        if not _latent_applies_to_style(style_name, latent.condition_id, latent.condition_value):
            continue
        weight = weights.get(latent.name, 0)
        if weight:
            score += latent.value * weight
    return score


def _latent_applies_to_style(style_name: str, condition_id: int, condition_value: int) -> bool:
    for expected_condition_id, expected_condition_value in MOVEMENT_LATENT_CONDITIONS.get(style_name, tuple()):
        if condition_id != expected_condition_id:
            continue
        if expected_condition_value is None or condition_value == expected_condition_value:
            return True
    return False


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


def _weapon_policy_bonus(
    item: GearItem,
    slot_policy: WeaponSlotPolicy | None,
) -> int:
    if slot_policy is None or item.id not in slot_policy.preferred_item_ids:
        return 0
    rank = slot_policy.preferred_item_ids.index(item.id)
    return PREFERRED_ITEM_ID_BONUS - (rank * 1_000)


def _score_evidence(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None = None,
    slot_policy: WeaponSlotPolicy | None = None,
) -> str:
    weights = _style_mod_weights(style_name)
    mechanics_score = score_mechanics_mods(
        _scoring_style_name(style_name),
        classification.server_mods,
        classification.pet_server_mods,
        weights,
    )
    parts: list[str] = []
    if slot in WEAPON_SLOTS and _uses_weapon_damage_score(style_name):
        weapon_stats = item_stats.weapon_stats_for_item_id(item.id) if item_stats else None
        if weapon_stats is not None:
            parts.append(f"weapon damage {weapon_stats.damage}, delay {weapon_stats.delay}")
        if slot_policy is not None:
            if item.id in slot_policy.fixed_item_ids:
                parts.append(f"fixed weapon policy item_id {item.id}")
            elif item.id in slot_policy.preferred_item_ids:
                parts.append(f"preferred weapon policy item_id {item.id}")
        if target_profile is not None:
            damage_type = DAMAGE_TYPE_BY_WEAPON_FAMILY.get(classification.weapon_family)
            if damage_type:
                sdt = target_profile.physical_sdt.get(damage_type, 0)
                if sdt:
                    parts.append(f"target {target_profile.name} {damage_type} SDT {sdt:+d}")
    if mechanics_score.weighted_mods:
        parts.append("weighted mods " + ", ".join(mechanics_score.weighted_mods))
    if mechanics_score.pet_weighted_mods:
        parts.append("pet weighted mods " + ", ".join(mechanics_score.pet_weighted_mods))
    latent_parts = _latent_score_evidence(style_name, item, item_stats)
    if latent_parts:
        parts.append("conditional latents " + ", ".join(latent_parts))
    if mechanics_score.surfaces:
        parts.append("mechanics surfaces " + ", ".join(mechanics_score.surfaces))
    if not parts:
        parts.append("eligible gear tie-breakers; no weighted combat mods")
    return "; ".join(parts)


def _latent_score_evidence(
    style_name: str,
    item: GearItem,
    item_stats: ItemStatsIndex | None,
) -> list[str]:
    if item_stats is None:
        return []
    weights = _style_mod_weights(style_name)
    if not weights:
        return []

    evidence: list[str] = []
    for latent in item_stats.latents_for_item_id(item.id):
        if not _latent_applies_to_style(style_name, latent.condition_id, latent.condition_value):
            continue
        if latent.name not in weights:
            continue
        evidence.append(
            f"{latent.name}{latent.value:+d} condition {latent.condition_id}:{latent.condition_value}"
        )
    return evidence


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
    subjob_profiles: dict[str, SubjobProfile],
    default_subjob: str,
    style_subjobs: dict[str, str],
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
        "mechanicsDecisionModel": _mechanics_decision_manifest(contract, item_stats),
        "subjobModel": {
            "defaultSubjob": default_subjob,
            "styleSubjobs": style_subjobs,
            "subjobLevel": 37,
            "profiles": subjob_manifest(subjob_profiles),
        },
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
            "equipmentItemCount": 0,
            "itemCount": 0,
            "foodItemCount": 0,
            "foodModCount": 0,
            "petItemCount": 0,
            "petItemModCount": 0,
            "mechanicsSources": mechanics_source_manifest({}),
        }
    return {
        "loaded": True,
        "sourcePath": str(item_stats.source_path),
        "sourceKind": "sqlite" if item_stats.source_path.suffix.lower() in {".sqlite", ".db"} else "sql",
        "equipmentItemCount": len(item_stats.equipment_by_item_id),
        "itemCount": len(item_stats.mods_by_item_id),
        "foodItemCount": len(item_stats.food_mods_by_item_id),
        "foodModCount": sum(len(mods) for mods in item_stats.food_mods_by_item_id.values()),
        "petItemCount": len(item_stats.pet_mods_by_item_id),
        "petItemModCount": sum(len(mods) for mods in item_stats.pet_mods_by_item_id.values()),
        "mechanicsSources": mechanics_source_manifest(item_stats.mechanics_counts),
    }


def _mechanics_decision_manifest(contract: JobContract, item_stats: ItemStatsIndex | None) -> dict[str, object]:
    return {
        "source": "docs/CATSEYE_COMBAT_MAGIC_MECHANICS.md",
        "mechanicsSources": mechanics_source_manifest(item_stats.mechanics_counts if item_stats else {}),
        "playstyles": {
            style.name: mechanics_manifest_for_style(style.name)
            for style in contract.playstyles
        },
    }


def _selected_manifest(selected: SelectedGear) -> dict[str, object]:
    item = selected.item
    return {
        "id": item.id,
        "item": item.name,
        "slot": selected.slot,
        "reason": selected.reason,
        "score": selected.score,
        "level": item.level,
        "serverLevel": selected.classification.server_level,
        "serverJobsMask": selected.classification.server_jobs_mask,
        "serverSlotMask": selected.classification.server_slot_mask,
        "serverRemovalSlotMask": selected.classification.server_removal_slot_mask,
        "slots": item.slot,
        "jobs": list(item.jobs),
        "storage": item.storage,
        "classification": selected.classification.manifest_metadata(),
    }


def _rejected_manifest(
    classified: Iterable[tuple[GearItem, ClassifiedItem]],
    *,
    selected_keys: set[str],
    job: str,
    character_level: int,
) -> dict[str, object]:
    rejected: dict[str, object] = {}
    for item, classification in classified:
        if _item_key(item) in selected_keys:
            continue
        reason, detail = _rejection_reason(item, classification, job, character_level)
        if not reason:
            continue

        existing = rejected.get(item.name)
        entry = {
            "id": item.id,
            "reason": reason,
            "detail": detail,
            "level": item.level,
            "serverLevel": classification.server_level,
            "serverJobsMask": classification.server_jobs_mask,
            "serverSlotMask": classification.server_slot_mask,
            "serverRemovalSlotMask": classification.server_removal_slot_mask,
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
    if item.id in LOW_VALUE_COMBAT_ITEM_ID_REASONS:
        return "PolicyExcluded", LOW_VALUE_COMBAT_ITEM_ID_REASONS[item.id]
    if not classification.level_eligible(character_level):
        required_level = classification.server_level if classification.server_level is not None else item.level
        return "LevelIneligible", f"Requires level {required_level}; CharacterSnapshot {job} level is {character_level}."
    if not classification.job_eligible(job):
        return "WrongJob", f"Server item_equipment jobs mask does not include {job}."
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
