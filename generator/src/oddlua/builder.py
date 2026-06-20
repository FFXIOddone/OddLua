from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache
import json
from pathlib import Path
from typing import Iterable

from .classifier import ClassifiedItem, classify_item
from .contracts import JobContract, Playstyle, build_job_contract
from .gameconstants import WEAPON_FAMILY_BY_SKILL
from .gearexport import CharacterSnapshot, GearExport, GearItem, load_character_snapshot, load_gearexport
from .itemstats import (
    EQUIPMENT_SLOT_MASKS,
    ItemConditionalMod,
    ItemStatsIndex,
    WeaponStats,
    load_item_stats,
    load_item_stats_from_db,
)
from .manifests.schema import validate_profile_manifest
from .mechanics import mechanics_manifest_for_style, mechanics_source_manifest, score_mechanics_mods
from .mechanics_opportunities import mechanics_opportunity_manifest
from .mechanics_swap_planner import mechanics_swap_plan_manifest
from .mobstats import TargetProfile, empty_target_manifest, load_target_profile_from_db
from .planning.command_registry import default_forward_commands
from .planning.keybinding_planner import plan_keybindings
from .planning.number_row_palette import plan_number_row_palette
from .renderer import SEMANTIC_SET_PREFERENCES, SLOT_ORDER, render_profile
from .rendering.keybinds import render_keybindings_script
from .subjobs import SubjobProfile, build_subjob_profiles, subjob_manifest
from .weaponskill_scoring import weights_for_weaponskill
from .weaponskill_scripts import parse_weaponskill_script
from .weaponskills import CatseyeWeaponSkill, WeaponSkillEligibilityContext, eligible_weaponskills_for_job


COMBAT_SLOT_ORDER = tuple(
    slot for slot in SLOT_ORDER if slot not in {"Range", "Ammo"}
)

WEAPON_SLOTS = {"Main", "Sub", "Range", "Ammo"}
JEWELRY_SLOTS = {"Ear1", "Ear2", "Ring1", "Ring2"}
JEWELRY_SECONDARY_ONLY_MODS = {"MP", "MPP", "MPHEAL", "HPHEAL", "CONSERVE_MP"}
RESTING_JEWELRY_SECONDARY_ONLY_MODS = {"MP", "MPP", "CONSERVE_MP"}
WS_ACTION_BLOCKED_SLOTS = {"Main", "Sub", "Range"}
GENERIC_WEAPONSKILL_ACTION_BLOCKED_SLOTS = {"Main", "Sub", "Range", "Ammo"}
GENERIC_WEAPONSKILL_FALLBACK_STYLES = {"Weaponskill", "WeaponSkillAccuracy", "WSElemental"}
SUBJOB_ACTION_SNAPSHOT_STYLES = {"Meditate", "Samba", "Steps", "ThirdEye", "Waltz"}
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
DUAL_WIELD_SUBJOBS = {"NIN", "DNC", "THF"}
MOVEMENT_SEMANTIC_STYLES = ("Movement", "InCity", "Movement_City", "Movement_Night", "Movement_DuskToDawn")
AUTOMATIC_SEMANTIC_STYLES = tuple(SEMANTIC_SET_PREFERENCES)
# Catseye wiki documents Octave Club as Kraken-equivalent OA2-8x; the
# server item_weapon row keeps hit=1, so score it by its live behavior.
CATSEYE_EFFECTIVE_WEAPON_HITS = {
    18852: 8,  # Octave Club
}
NATIVE_DAKEN_JOBS = {"NIN"}
DAKEN_SUBJOBS = {"NIN"}
JOB_SPECIFIC_AUTOMATIC_STYLES = {
    "SAM": ("Meditate", "ThirdEye"),
}
SUBJOB_CAPABILITY_AUTOMATIC_STYLES = {
    "jump": ("Jump",),
    "meditate": ("Meditate",),
    "provoke": ("Enmity",),
    "quick_draw": ("QuickDraw",),
    "roll": ("Roll",),
    "samba": ("Samba",),
    "sentinel": ("Enmity",),
    "steps": ("Steps",),
    "third_eye": ("ThirdEye",),
    "waltz": ("Waltz",),
}
JOB_RESTRICTED_AUTOMATIC_STYLES = {
    "BlueMagic": {"BLU"},
    "PhysicalBlueMagic": {"BLU"},
    "MagicalBlueMagic": {"BLU"},
    "Song": {"BRD"},
    "SongDebuff": {"BRD"},
    "SongBuff": {"BRD"},
    "Geomancy": {"GEO"},
    "Summoning": {"SMN"},
    "BloodPactRage": {"SMN"},
    "BloodPactWard": {"SMN"},
    "AvatarPerp": {"SMN"},
    "Snapshot": {"RNG", "COR"},
    "RangedPreshot": {"RNG", "COR"},
    "Ranged": {"RNG", "COR"},
    "RangedMidshot": {"RNG", "COR"},
    "RangedAccuracy": {"RNG", "COR"},
    "RangedAttack": {"RNG", "COR"},
    "QuickDraw": {"COR"},
    "Roll": {"COR"},
    "Waltz": {"DNC"},
    "Steps": {"DNC"},
    "Samba": {"DNC"},
    "Jump": {"DRG"},
    "PetReady": {"BST", "PUP"},
    "PetMagic": {"BST", "PUP", "SMN"},
    "PetTank": {"BST", "PUP", "SMN"},
}
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
    "InCity",
    "MagicAccuracy",
    "MagicDefense",
    "MagicalBlue",
    "Meditate",
    "Movement",
    "Movement_City",
    "Movement_DuskToDawn",
    "Movement_Night",
    "Ninjutsu",
    "Nuke",
    "PhysicalIdle",
    "PetDamage",
    "PetTank",
    "QuickDraw",
    "Resting",
    "Roll",
    "Song",
    "SummoningMagic",
    "ThirdEye",
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
JOB_SEMANTIC_SCORING_OVERRIDES = {
    ("SAM", "Aftercast"): "PhysicalIdle",
    ("SAM", "Idle"): "PhysicalIdle",
}

MOVEMENT_LATENT_CONDITIONS: dict[str, tuple[tuple[int, int | None], ...]] = {
    "Movement_City": ((54, None),),  # ZONE_HOME_NATION: used by aketons.
    "Movement_Night": ((26, 1),),  # TIME_OF_DAY: nighttime.
    "Movement_DuskToDawn": ((26, 2),),  # TIME_OF_DAY: dusk through dawn.
}
STACKING_MOVEMENT_MODS = {"MOVE_SPEED_STACKABLE"}

ELEMENTAL_STAFF_BONUS_MODS = {
    "Fire": "FIRE_STAFF_BONUS",
    "Ice": "ICE_STAFF_BONUS",
    "Wind": "WIND_STAFF_BONUS",
    "Earth": "EARTH_STAFF_BONUS",
    "Thunder": "THUNDER_STAFF_BONUS",
    "Lightning": "THUNDER_STAFF_BONUS",
    "Water": "WATER_STAFF_BONUS",
    "Light": "LIGHT_STAFF_BONUS",
    "Dark": "DARK_STAFF_BONUS",
}
ELEMENTAL_STAFF_BONUS_WEIGHT = 2_000
WEAPON_FAMILY_PREFERENCE_BONUS = 100
JOB_WEAPON_SKILL_CAP_BONUS = 8
JOB_WEAPON_SKILL_RANK_BONUS = 250
WEAPON_SKILL_ID_BY_FAMILY = {
    family: skill_id
    for skill_id, family in WEAPON_FAMILY_BY_SKILL.items()
    if family != "instrument"
}
RANGE_REQUIRED_DEFAULT_PLAYSTYLES = {"RangedDamage", "RangedAccuracy", "QuickDraw"}


@dataclass(frozen=True)
class WeaponSlotPolicy:
    fixed_item_ids: tuple[int, ...] = tuple()
    preferred_item_ids: tuple[int, ...] = tuple()


JOB_DEFAULT_WEAPON_FAMILIES = {
    "WAR": {"Main": ("great_axe", "axe"), "Sub": ("grip", "axe", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "MNK": {"Main": ("hand_to_hand",), "Sub": tuple(), "Range": ("throwing",), "Ammo": ("ammo",)},
    "WHM": {"Main": ("staff", "club"), "Sub": ("grip", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "BLM": {"Main": ("staff", "club"), "Sub": ("grip", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "RDM": {"Main": ("sword", "dagger", "club", "staff"), "Sub": ("sword", "dagger", "club", "shield", "grip"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "THF": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "PLD": {"Main": ("sword", "club"), "Sub": ("shield",), "Range": ("throwing",), "Ammo": ("ammo",)},
    "DRK": {"Main": ("scythe", "great_sword", "staff"), "Sub": ("grip",), "Range": ("throwing",), "Ammo": ("ammo",)},
    "BST": {"Main": ("axe", "club"), "Sub": ("axe", "club", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "BRD": {"Main": ("staff", "club", "dagger", "sword"), "Sub": ("grip", "shield"), "Range": ("instrument",), "Ammo": ("ammo",)},
    "RNG": {"Main": ("dagger", "axe", "sword"), "Sub": ("dagger", "axe", "shield"), "Range": ("bow", "gun"), "Ammo": ("ammo",)},
    "SAM": {"Main": ("great_katana", "polearm"), "Sub": ("grip",), "Range": ("throwing",), "Ammo": ("ammo",)},
    "NIN": {"Main": ("katana", "dagger"), "Sub": ("katana", "dagger"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "DRG": {"Main": ("polearm", "staff"), "Sub": ("grip",), "Range": ("throwing",), "Ammo": ("ammo",)},
    "SMN": {"Main": ("staff", "club"), "Sub": ("grip", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "BLU": {"Main": ("sword", "club", "staff"), "Sub": ("sword", "club", "shield", "grip"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "COR": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword"), "Range": ("gun",), "Ammo": ("ammo",)},
    "PUP": {"Main": ("hand_to_hand",), "Sub": tuple(), "Range": ("throwing",), "Ammo": ("ammo",)},
    "DNC": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "SCH": {"Main": ("staff", "club"), "Sub": ("grip", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "GEO": {"Main": ("staff", "club"), "Sub": ("grip", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
    "RUN": {"Main": ("great_sword", "sword"), "Sub": ("grip", "shield"), "Range": ("throwing",), "Ammo": ("ammo",)},
}


JOB_STYLE_WEAPON_FAMILIES = {
    "WAR": {
        "Damage": {"Main": ("great_axe", "axe"), "Sub": ("grip", "axe")},
        "Accuracy": {"Main": ("great_axe", "axe"), "Sub": ("grip", "axe")},
        "WeaponSkill": {"Main": ("great_axe", "axe"), "Sub": ("grip", "axe")},
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
        "Melt": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword", "club")},
        "Dagger": {"Main": ("dagger",), "Sub": ("dagger",)},
        "Safe": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword", "club")},
        "Treasure": {"Main": ("dagger", "sword"), "Sub": ("dagger", "sword", "club")},
    },
    "PLD": {
        "Tank": {"Main": ("sword", "club"), "Sub": ("shield",)},
        "Enmity": {"Main": ("sword", "club"), "Sub": ("shield",)},
        "Damage": {"Main": ("sword", "club"), "Sub": ("shield",)},
        "MagicDefense": {"Main": ("sword", "club"), "Sub": ("shield",)},
    },
    "DRK": {
        "Damage": {"Main": ("scythe", "great_sword"), "Sub": ("grip",)},
        "Accuracy": {"Main": ("scythe", "great_sword"), "Sub": ("grip",)},
        "WeaponSkill": {"Main": ("scythe", "great_sword"), "Sub": ("grip",)},
        "DrainAbsorb": {"Main": ("scythe", "great_sword", "staff"), "Sub": ("grip",)},
    },
    "BST": {
        "Damage": {"Main": ("axe", "club"), "Sub": ("axe", "club")},
        "Accuracy": {"Main": ("axe", "club"), "Sub": ("axe", "club")},
        "PetDamage": {"Main": ("axe", "club"), "Sub": ("axe", "club")},
        "PetTank": {"Main": ("axe", "club"), "Sub": ("shield", "axe", "club")},
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
        "StoreTP": {"Main": ("great_katana", "polearm"), "Sub": ("grip",)},
        "Accuracy": {"Main": ("great_katana", "polearm"), "Sub": ("grip",)},
        "WeaponSkill": {"Main": ("great_katana", "polearm"), "Sub": ("grip",)},
        "Evasion": {"Main": ("great_katana", "polearm"), "Sub": ("grip",)},
        "Meditate": {"Main": tuple(), "Sub": tuple()},
        "ThirdEye": {"Main": tuple(), "Sub": tuple()},
    },
    "NIN": {
        "Damage": {"Main": ("katana", "dagger"), "Sub": ("katana", "dagger")},
        "Accuracy": {"Main": ("katana", "dagger"), "Sub": ("katana", "dagger")},
        "Evasion": {"Main": ("katana", "dagger"), "Sub": ("katana", "dagger")},
        "Ninjutsu": {"Main": ("katana", "dagger"), "Sub": ("katana", "dagger")},
    },
    "DRG": {
        "Damage": {"Main": ("polearm", "staff"), "Sub": ("grip",)},
        "Accuracy": {"Main": ("polearm", "staff"), "Sub": ("grip",)},
        "WeaponSkill": {"Main": ("polearm", "staff"), "Sub": ("grip",)},
        "Jump": {"Main": ("polearm",), "Sub": ("grip",)},
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
        "Tank": {"Main": ("great_sword", "sword"), "Sub": ("grip", "shield")},
        "MagicDefense": {"Main": ("great_sword", "sword"), "Sub": ("grip", "shield")},
        "Damage": {"Main": ("great_sword", "sword"), "Sub": ("grip", "shield")},
        "Enmity": {"Main": ("great_sword", "sword"), "Sub": ("grip", "shield")},
    },
}

JOB_STYLE_WEAPON_POLICIES = {
    ("WAR", "Damage"): {
        "Main": WeaponSlotPolicy(preferred_item_ids=(20872,)),  # Ixtab
    },
    ("WAR", "Accuracy"): {
        "Main": WeaponSlotPolicy(preferred_item_ids=(20872,)),  # Ixtab
    },
    ("WAR", "WeaponSkill"): {
        "Main": WeaponSlotPolicy(preferred_item_ids=(20872,)),  # Ixtab
    },
    ("RDM", "Enspell"): {
        "Main": WeaponSlotPolicy(fixed_item_ids=(18904,)),  # Somnia Melodiam / Ephemeron
        # Prefer Octave Club when owned; Egeking remains the fallback target.
        "Sub": WeaponSlotPolicy(fixed_item_ids=(18852,), preferred_item_ids=(20720,)),
    },
}

PREFERRED_ITEM_ID_BONUS = 10_000_000


def _weapon_family_policy_for_style(job: str, style_name: str) -> dict[str, tuple[str, ...]]:
    normalized_job = job.upper()
    selection_style_name = _selection_style_name_for_job(style_name, normalized_job)
    scoring_style = _scoring_style_name(selection_style_name)
    policies: list[dict[str, tuple[str, ...]]] = []
    default_policy = JOB_DEFAULT_WEAPON_FAMILIES.get(normalized_job)
    if default_policy:
        policies.append(default_policy)
    job_policies = JOB_STYLE_WEAPON_FAMILIES.get(normalized_job, {})
    for candidate_style in (scoring_style, selection_style_name, style_name):
        policy = job_policies.get(candidate_style)
        if policy:
            policies.append(policy)
    return _merge_weapon_family_policies(*policies)


def _weapon_slot_policy_for_style(job: str, style_name: str) -> dict[str, WeaponSlotPolicy]:
    normalized_job = job.upper()
    selection_style_name = _selection_style_name_for_job(style_name, normalized_job)
    scoring_style = _scoring_style_name(selection_style_name)
    for candidate_style in (style_name, selection_style_name, scoring_style):
        policy = JOB_STYLE_WEAPON_POLICIES.get((normalized_job, candidate_style))
        if policy:
            return policy
    return {}


def _merge_weapon_family_policies(*policies: dict[str, tuple[str, ...]]) -> dict[str, tuple[str, ...]]:
    merged: dict[str, tuple[str, ...]] = {}
    for policy in policies:
        merged.update(policy)
    return merged

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
    "InCity": "Movement",
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
    "Meditate": "TP",
    "ThirdEye": "TP",
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
        "DOUBLE_ATTACK": 70,
        "DOUBLE_ATTACK_DMG": 40,
        "MYTHIC_OCC_ATT_TWICE": 1200,
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
        "DOUBLE_ATTACK": 70,
        "DOUBLE_ATTACK_DMG": 40,
        "MYTHIC_OCC_ATT_TWICE": 1200,
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
        "DOUBLE_ATTACK": 55,
        "DOUBLE_ATTACK_DMG": 30,
        "MYTHIC_OCC_ATT_TWICE": 900,
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
        "DOUBLE_ATTACK": 70,
        "DOUBLE_ATTACK_DMG": 40,
        "MYTHIC_OCC_ATT_TWICE": 1200,
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
        "DARK_MAB": 50,
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
    "PhysicalIdle": {
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
        "DOUBLE_ATTACK": 50,
        "DOUBLE_ATTACK_DMG": 25,
        "MYTHIC_OCC_ATT_TWICE": 800,
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
        "TP_BONUS": 2,
        "STORETP": 10,
        "DOUBLE_ATTACK": 45,
        "DOUBLE_ATTACK_DMG": 25,
        "MYTHIC_OCC_ATT_TWICE": 700,
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
        "LIGHT_STAFF_BONUS": 500,
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
        "DOUBLE_ATTACK": 55,
        "DOUBLE_ATTACK_DMG": 35,
        "MYTHIC_OCC_ATT_TWICE": 900,
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
        "SNAPSHOT": 60,
    },
    "RangedAccuracy": {
        "RACC": 55,
        "AGI": 24,
        "RATT": 10,
        "ACC": 8,
        "SNAPSHOT": 35,
    },
    "StoreTP": {
        "STORETP": 60,
        "HASTE_GEAR": 90,
        "ACC": 28,
        "ATT": 14,
        "STR": 14,
        "DEX": 12,
        "DOUBLE_ATTACK": 60,
        "DOUBLE_ATTACK_DMG": 35,
        "MYTHIC_OCC_ATT_TWICE": 1000,
    },
    "Meditate": {
        "MEDITATE_DURATION": 10000,
        "STORETP": 10,
        "HASTE_GEAR": 10,
    },
    "ThirdEye": {
        "THIRD_EYE_COUNTER_RATE": 10000,
        "EVA": 10,
        "HP": 1,
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
        "BP_DELAY": 75,
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

CONDITIONAL_STYLE_MOD_WEIGHTS = {
    "Melt": {"CRITHITRATE": 55},
    "Dagger": {"CRITHITRATE": 55},
    "Treasure": {"CRITHITRATE": 45},
    "Damage": {"CRITHITRATE": 55},
    "WeaponSkill": {"CRITHITRATE": 45},
    "Enspell": {"CRITHITRATE": 45},
    "RangedDamage": {"CRITHITRATE": 45},
    "StoreTP": {"CRITHITRATE": 50},
    "PhysicalBlue": {"CRITHITRATE": 45},
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
    weights = STYLE_MOD_WEIGHTS.get(_scoring_style_name(style_name), {})
    if _scoring_style_name(style_name) != "Nuke":
        return weights

    staff_bonus_weights = _elemental_staff_bonus_weights(style_name)
    if not staff_bonus_weights:
        return weights
    return {**weights, **staff_bonus_weights}


def _conditional_style_mod_weights(style_name: str) -> dict[str, int]:
    weights = dict(_style_mod_weights(style_name))
    conditional_weights = CONDITIONAL_STYLE_MOD_WEIGHTS.get(_scoring_style_name(style_name), {})
    if conditional_weights:
        weights.update(conditional_weights)
    return weights


def _elemental_staff_bonus_weights(style_name: str) -> dict[str, int]:
    element = _element_from_semantic_style(style_name)
    if element:
        staff_bonus_mod = ELEMENTAL_STAFF_BONUS_MODS.get(element)
        return {staff_bonus_mod: ELEMENTAL_STAFF_BONUS_WEIGHT} if staff_bonus_mod else {}
    return {mod_name: ELEMENTAL_STAFF_BONUS_WEIGHT for mod_name in ELEMENTAL_STAFF_BONUS_MODS.values()}


def _element_from_semantic_style(style_name: str) -> str | None:
    for prefix in ("Elemental_", "Weather_", "Day_"):
        if style_name.startswith(prefix):
            return style_name[len(prefix):]
    return None


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
    keybindings_path: Path
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

    export = _load_gearexport_for_build(gear_path)
    character = _load_character_snapshot_for_build(character_path)
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

    selected = _build_job_sets(
        classified,
        contract,
        item_stats,
        target_profile,
        subjob_profiles=subjob_profiles,
    )
    default_playstyle = _effective_default_playstyle(contract, selected)
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

    conditional_equips = _conditional_equips_for_sets(
        selected,
        classified,
        job,
        character_level,
        item_stats,
    )
    mechanics_swap_planner = mechanics_swap_plan_manifest(selected, item_stats)
    profile_features = _profile_features(player=player, player_id=player_id, job=job)
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
        default_playstyle=default_playstyle,
        subjob_profiles=subjob_profiles,
        default_subjob=default_subjob,
        style_subjobs=style_subjobs,
        sets=sets,
        selected=selected,
        conditional_equips=conditional_equips,
        mechanics_swap_planner=mechanics_swap_planner,
        rejected_items=_rejected_manifest(
            classified,
            selected_keys=selected_keys,
            job=job,
            character_level=character_level,
        ),
        profile_features=profile_features,
    )

    output_dir = Path(output_root) / "packs" / f"{player}_{player_id}" / job
    output_dir.mkdir(parents=True, exist_ok=True)
    profile_text = render_profile(
        player=player,
        player_id=player_id,
        job=job,
        sets=sets,
        default_playstyle=default_playstyle,
        playstyle_names=tuple(style.name for style in contract.playstyles),
        style_intents={
            style.name: STYLE_INTENTS.get(style.name, "TP")
            for style in contract.playstyles
        },
        subjob_profiles=subjob_profiles,
        default_subjob=default_subjob,
        profile_features=profile_features,
        secondary_slot_locks=_secondary_slot_locks_for_sets(selected),
        dual_wield_sub_sets=_dual_wield_sub_sets_for_sets(selected),
        conditional_equips=conditional_equips,
        mechanics_swap_planner=mechanics_swap_planner,
        number_row_palette=manifest["numberRowPalette"],
    )
    profile_path = output_dir / f"{job}.lua"
    manifest_path = output_dir / "manifest.json"
    keybindings_path = output_dir / "keybindings.txt"
    profile_path.write_text(profile_text, encoding="utf-8")
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True), encoding="utf-8")
    keybindings_path.write_text(render_keybindings_script(manifest["keyBindings"]), encoding="utf-8")

    return BuildResult(
        output_dir=output_dir,
        profile_path=profile_path,
        manifest_path=manifest_path,
        keybindings_path=keybindings_path,
        profile_text=profile_text,
        manifest=manifest,
    )


def _profile_features(*, player: str, player_id: str, job: str) -> tuple[str, ...]:
    if job == "SAM" and player.lower() == "aahtacos" and str(player_id) == "30102":
        return ("aahtacos_sam_controls",)
    return tuple()


def _load_default_item_stats(
    server_sql_root: Path | str | None,
    *,
    stats_db_path: Path | str | None = None,
) -> ItemStatsIndex | None:
    stats_db = Path(stats_db_path) if stats_db_path is not None else Path(__file__).resolve().parents[2] / "data" / "oddlua_stats.sqlite"
    if stats_db.exists():
        stats_db = stats_db.resolve()
        return _load_item_stats_from_db_cached(str(stats_db), stats_db.stat().st_mtime_ns)

    root = Path(server_sql_root) if server_sql_root is not None else Path(__file__).resolve().parents[3] / "server" / "sql"
    item_mods = root / "item_mods.sql" if root.is_dir() else root
    if not item_mods.exists():
        return None
    return load_item_stats(root)


@lru_cache(maxsize=4)
def _load_item_stats_from_db_cached(path: str, mtime_ns: int) -> ItemStatsIndex:
    return load_item_stats_from_db(Path(path))


def _load_gearexport_for_build(path: Path | str) -> GearExport:
    source_path = Path(path).resolve()
    return _load_gearexport_cached(str(source_path), source_path.stat().st_mtime_ns)


@lru_cache(maxsize=8)
def _load_gearexport_cached(path: str, mtime_ns: int) -> GearExport:
    return load_gearexport(Path(path))


def _load_character_snapshot_for_build(path: Path | str) -> CharacterSnapshot:
    source_path = Path(path).resolve()
    return _load_character_snapshot_cached(str(source_path), source_path.stat().st_mtime_ns)


@lru_cache(maxsize=8)
def _load_character_snapshot_cached(path: str, mtime_ns: int) -> CharacterSnapshot:
    return load_character_snapshot(Path(path))


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


def _effective_default_playstyle(
    contract: JobContract,
    selected: dict[str, dict[str, object]],
) -> str:
    default = contract.default_playstyle
    if not _requires_range_weapon(default):
        return default
    if selected.get(default, {}).get("Range") is not None:
        return default

    playstyle_names = {style.name for style in contract.playstyles}
    for fallback in ("Roll", "Accuracy", "Damage", "StoreTP", "Melt"):
        if fallback == default or fallback not in playstyle_names:
            continue
        if selected.get(fallback):
            return fallback
    return default


def _requires_range_weapon(style_name: str) -> bool:
    return style_name in RANGE_REQUIRED_DEFAULT_PLAYSTYLES


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
    if _current_main_job_abbr(current_job) == contract.job:
        return _current_subjob_abbr(current_job)
    style_hint = JOB_STYLE_SUBJOB_HINTS.get((contract.job, contract.default_playstyle))
    if style_hint:
        return style_hint
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
    *,
    subjob_profiles: dict[str, SubjobProfile] | None = None,
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
    automatic_styles = _automatic_semantic_styles_for_job(contract.job)
    subjob_styles = _automatic_semantic_styles_for_subjobs(subjob_profiles or {})
    automatic_styles = tuple(dict.fromkeys((*automatic_styles, *subjob_styles)))
    for style_name in automatic_styles:
        if style_name not in sets:
            if _scoring_style_name(style_name) == "Craft":
                sets[style_name] = _build_craft_style(classified, contract.job, contract.character_level)
            else:
                style_set = _build_combat_style(
                    style_name,
                    classified,
                    contract.job,
                    contract.character_level,
                    item_stats,
                    target_profile=target_profile,
                )
                if style_set or style_name not in SUBJOB_ACTION_SNAPSHOT_STYLES:
                    sets[style_name] = style_set
    for ws in _eligible_weaponskills_for_contract(contract, item_stats):
        script = _script_for_weaponskill(ws, item_stats)
        for set_name, accuracy in ((ws.set_name, False), (ws.accuracy_set_name, True)):
            if set_name not in sets:
                sets[set_name] = _build_weaponskill_style(
                    ws,
                    script,
                    classified,
                    contract,
                    item_stats,
                    accuracy=accuracy,
                    target_profile=target_profile,
                )
    return sets


def _eligible_weaponskills_for_contract(
    contract: JobContract,
    item_stats: ItemStatsIndex | None,
) -> tuple[CatseyeWeaponSkill, ...]:
    if item_stats is None:
        return tuple()
    context = WeaponSkillEligibilityContext(
        job=contract.job,
        character_level=contract.character_level,
        skill_caps_by_level_rank=item_stats.skill_caps_by_level_rank,
        skill_ranks_by_skill_job=item_stats.skill_ranks_by_skill_job,
        learned_unlock_ids=frozenset(),
    )
    return eligible_weaponskills_for_job(
        item_stats.weapon_skills_by_key,
        context,
    )


def _script_for_weaponskill(
    ws: CatseyeWeaponSkill,
    item_stats: ItemStatsIndex | None,
):
    if item_stats is None:
        return None
    candidate_roots: list[Path] = []
    if len(item_stats.source_path.parents) >= 3:
        candidate_roots.append(item_stats.source_path.parents[2] / "server")
    candidate_roots.append(Path(__file__).resolve().parents[3] / "server")
    for root in candidate_roots:
        candidate = root / "scripts" / "actions" / "weaponskills" / f"{ws.key}.lua"
        if candidate.exists():
            return parse_weaponskill_script(candidate, use_adoulin_changes=True)
    return None


def _build_weaponskill_style(
    ws: CatseyeWeaponSkill,
    script,
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    contract: JobContract,
    item_stats: ItemStatsIndex | None,
    *,
    accuracy: bool,
    target_profile: TargetProfile | None,
) -> dict[str, SelectedGear]:
    weights = weights_for_weaponskill(ws, script, accuracy=accuracy)
    style: dict[str, SelectedGear] = {}
    blocked_keys: set[str] = set()
    occupied_slots: set[str] = set()
    reason_prefix = f"Calculated for {'WSAcc' if accuracy else 'WS'} {ws.display_name}"

    for slot in COMBAT_SLOT_ORDER:
        if slot in WS_ACTION_BLOCKED_SLOTS or slot in occupied_slots:
            continue
        selected = _select_slot_with_weights(
            "WeaponSkill",
            slot,
            weights,
            classified,
            contract.job,
            contract.character_level,
            tuple(),
            allowed_weapon_families=tuple(),
            blocked_keys=blocked_keys,
            item_stats=item_stats,
            target_profile=target_profile,
            reason_prefix=reason_prefix,
        )
        if selected:
            style[slot] = selected
            blocked_keys.add(_item_key(selected.item))
            occupied_slots.update(_occupied_slots_for_selected(selected))
    return style


def _automatic_semantic_styles_for_job(job: str) -> tuple[str, ...]:
    normalized = job.upper()
    styles = [
        style_name
        for style_name in AUTOMATIC_SEMANTIC_STYLES
        if normalized in JOB_RESTRICTED_AUTOMATIC_STYLES.get(style_name, {normalized})
    ]
    for style_name in JOB_SPECIFIC_AUTOMATIC_STYLES.get(normalized, tuple()):
        if style_name not in styles:
            styles.append(style_name)
    return tuple(styles)


def _automatic_semantic_styles_for_subjobs(
    subjob_profiles: dict[str, SubjobProfile],
) -> tuple[str, ...]:
    styles: list[str] = []
    for profile in subjob_profiles.values():
        for capability in profile.capabilities:
            for style_name in SUBJOB_CAPABILITY_AUTOMATIC_STYLES.get(capability, tuple()):
                if style_name not in styles:
                    styles.append(style_name)
    return tuple(styles)


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
    occupied_slots: set[str] = set()
    selection_style_name = _selection_style_name_for_job(style_name, job)
    weapon_family_by_slot = _weapon_family_policy_for_style(job, style_name)
    weapon_policy_by_slot = _weapon_slot_policy_for_style(job, style_name)
    blocked_action_slots = _action_time_blocked_slots_for_style(style_name)

    for slot in _slot_order_for_style(weapon_family_by_slot):
        if slot in blocked_action_slots or slot in occupied_slots:
            continue
        allowed_families = weapon_family_by_slot.get(slot)
        if slot == "Sub":
            main = style.get("Main")
            allowed_families = _sub_families_for_main(allowed_families, main)
            allowed_families = _non_damage_sub_families_for_main(selection_style_name, job, main, allowed_families)
            allowed_families = _dual_wield_gated_sub_families(
                allowed_families,
                job,
                selection_style_name,
            )
        selected = _select_slot(
            selection_style_name,
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
            occupied_slots.update(_occupied_slots_for_selected(selected))
    return style


def _selection_style_name_for_job(style_name: str, job: str) -> str:
    return JOB_SEMANTIC_SCORING_OVERRIDES.get((job, style_name), style_name)


def _slot_order_for_style(weapon_family_by_slot: dict[str, tuple[str, ...]]) -> tuple[str, ...]:
    if "Range" in weapon_family_by_slot or "Ammo" in weapon_family_by_slot:
        return SLOT_ORDER
    return COMBAT_SLOT_ORDER


def _action_time_blocked_slots_for_style(style_name: str) -> set[str]:
    if style_name in SUBJOB_ACTION_SNAPSHOT_STYLES:
        return WEAPON_SLOTS
    if style_name in GENERIC_WEAPONSKILL_FALLBACK_STYLES:
        return GENERIC_WEAPONSKILL_ACTION_BLOCKED_SLOTS
    if style_name.startswith("WS_") or style_name.startswith("WSAcc_"):
        return WS_ACTION_BLOCKED_SLOTS | {"Ammo"}
    return set()


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
    return tuple(family for family in configured if family != "grip")


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


def _style_has_daken(job: str, style_name: str) -> bool:
    if job in NATIVE_DAKEN_JOBS:
        return True
    scoring_style = _scoring_style_name(style_name)
    return (
        JOB_STYLE_SUBJOB_HINTS.get((job, style_name)) in DAKEN_SUBJOBS
        or JOB_STYLE_SUBJOB_HINTS.get((job, scoring_style)) in DAKEN_SUBJOBS
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
    return max(candidates, key=_selected_rank)


def _select_slot_with_weights(
    style_name: str,
    slot: str,
    weights: dict[str, int],
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    preferred_names: tuple[str, ...],
    *,
    allowed_weapon_families: tuple[str, ...] | None = None,
    blocked_keys: set[str] | None = None,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
    reason_prefix: str | None = None,
) -> SelectedGear | None:
    candidates = _slot_candidates_with_weights(
        style_name,
        slot,
        weights,
        classified,
        job,
        character_level,
        preferred_names,
        allowed_weapon_families=allowed_weapon_families,
        blocked_keys=blocked_keys,
        item_stats=item_stats,
        target_profile=target_profile,
        reason_prefix=reason_prefix,
    )
    if not candidates:
        return None
    return max(candidates, key=_selected_rank)


def _slot_candidates_with_weights(
    style_name: str,
    slot: str,
    weights: dict[str, int],
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    preferred_names: tuple[str, ...],
    *,
    allowed_weapon_families: tuple[str, ...] | None = None,
    blocked_keys: set[str] | None = None,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
    reason_prefix: str | None = None,
) -> list[SelectedGear]:
    candidates: list[SelectedGear] = []
    blocked_keys = blocked_keys or set()
    for item, classification in classified:
        if _item_key(item) in blocked_keys:
            continue
        if not _slot_eligible(item, classification, slot):
            continue
        if not _is_eligible_combat_item(item, classification, job, character_level):
            continue
        if slot in WEAPON_SLOTS:
            allowed_families = _allowed_weapon_families_for_slot(
                style_name,
                slot,
                allowed_weapon_families,
                job,
            )
            if allowed_families is None:
                allowed_families = tuple(sorted(COMBAT_WEAPON_FAMILIES))
            if classification.weapon_family not in allowed_families:
                continue
            if _blocks_throwing_for_slot(style_name, slot, classification, job):
                continue

        score = _score_item_with_weights(
            style_name,
            slot,
            item,
            classification,
            preferred_names,
            weights,
            item_stats=item_stats,
            target_profile=target_profile,
        )
        if score <= 0:
            continue
        if slot in JEWELRY_SLOTS and not _jewelry_has_primary_score(
            style_name,
            item,
            classification,
            weights,
            item_stats,
        ):
            continue
        candidates.append(
            SelectedGear(
                slot=slot,
                item=item,
                classification=classification,
                reason=_selection_reason_with_weights(
                    style_name,
                    slot,
                    item,
                    classification,
                    preferred_names,
                    weights,
                    item_stats=item_stats,
                    target_profile=target_profile,
                    reason_prefix=reason_prefix,
                ),
                score=score,
            )
        )
    return candidates


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
        if (
            _is_movement_style(style_name)
            and not _allows_multi_slot_movement_overlay(style_name)
            and (classification.server_removal_slot_mask or 0)
        ):
            continue
        if required_weapon_family and classification.weapon_family != required_weapon_family:
            continue
        allowed_families = _allowed_weapon_families_for_slot(
            style_name,
            slot,
            allowed_weapon_families,
            job,
        )
        if allowed_families is None and required_weapon_family:
            allowed_families = (required_weapon_family,)
        if allowed_families is None and slot in WEAPON_SLOTS:
            allowed_families = tuple(sorted(COMBAT_WEAPON_FAMILIES))
        if slot in WEAPON_SLOTS and classification.weapon_family not in allowed_families:
            continue
        if _blocks_throwing_for_slot(style_name, slot, classification, job):
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
            allowed_weapon_families=allowed_families,
            job=job,
            character_level=character_level,
        )
        if score <= 0:
            continue
        if slot in JEWELRY_SLOTS and not _jewelry_has_primary_score(
            style_name,
            item,
            classification,
            _style_mod_weights(style_name),
            item_stats,
        ):
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
                    allowed_weapon_families=allowed_families,
                    job=job,
                    character_level=character_level,
                ),
                score=score,
            )
        )

    return candidates


def _item_key(item: GearItem) -> str:
    index = item.raw_stats.get("index", "")
    container_id = item.raw_stats.get("container_id", "")
    return f"{item.id}|{item.storage}|{container_id}|{index}"


def _allowed_weapon_families_for_slot(
    style_name: str,
    slot: str,
    configured: tuple[str, ...] | None,
    job: str,
) -> tuple[str, ...] | None:
    if (
        slot == "Ammo"
        and configured is not None
        and "ammo" in configured
        and _style_has_daken(job, style_name)
        and "throwing" not in configured
    ):
        return (*configured, "throwing")
    return configured


def _blocks_throwing_for_slot(
    style_name: str,
    slot: str,
    classification: ClassifiedItem,
    job: str,
) -> bool:
    if classification.weapon_family != "throwing":
        return False
    if slot != "Ammo":
        return True
    return not (_style_has_daken(job, style_name) and classification.is_shuriken)


def _occupied_slots_for_selected(selected: SelectedGear) -> tuple[str, ...]:
    slot_mask = EQUIPMENT_SLOT_MASKS.get(selected.slot, 0)
    removal_slot_mask = selected.classification.server_removal_slot_mask or 0
    occupied_mask = slot_mask | removal_slot_mask
    server_slot_mask = selected.classification.server_slot_mask or 0
    if slot_mask and not (server_slot_mask & slot_mask):
        occupied_mask |= server_slot_mask
    occupied_slots = tuple(
        slot
        for slot in SLOT_ORDER
        if occupied_mask & EQUIPMENT_SLOT_MASKS.get(slot, 0)
    )
    return occupied_slots or (selected.slot,)


def _should_generate_secondary_slot_lock(slot: str, locked_slot: str) -> bool:
    """Skip lock pairs where the server mask describes an equip relationship."""
    if slot == "Ammo" and locked_slot == "Range":
        return False
    return True


def _secondary_slot_locks_for_sets(
    selected: dict[str, dict[str, SelectedGear]],
) -> dict[str, dict[str, tuple[str, ...]]]:
    locks: dict[str, dict[str, tuple[str, ...]]] = {}
    for set_name, slot_map in selected.items():
        set_locks: dict[str, tuple[str, ...]] = {}
        for slot, selected_item in slot_map.items():
            removal_slot_mask = selected_item.classification.server_removal_slot_mask or 0
            if removal_slot_mask == 0:
                continue
            locked_slots = tuple(
                locked_slot
                for locked_slot in SLOT_ORDER
                if locked_slot != slot
                and removal_slot_mask & EQUIPMENT_SLOT_MASKS.get(locked_slot, 0)
                and _should_generate_secondary_slot_lock(slot, locked_slot)
            )
            if locked_slots:
                set_locks[slot] = locked_slots
        if set_locks:
            locks[set_name] = set_locks
    return locks


def _dual_wield_sub_sets_for_sets(
    selected: dict[str, dict[str, SelectedGear]],
) -> set[str]:
    return {
        set_name
        for set_name, slot_map in selected.items()
        if (
            (sub := slot_map.get("Sub")) is not None
            and sub.classification.weapon_family in OFFHAND_WEAPON_FAMILIES
        )
    }


def _conditional_equips_for_sets(
    selected: dict[str, dict[str, SelectedGear]],
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex | None,
) -> dict[str, tuple[dict[str, object], ...]]:
    if item_stats is None or not classified:
        return {}

    conditional_equips: dict[str, tuple[dict[str, object], ...]] = {}
    for set_name, slot_map in selected.items():
        entries_by_condition: dict[
            tuple[str, str],
            dict[str, tuple[int, str]],
        ] = {}
        for slot in SLOT_ORDER:
            base_score = slot_map[slot].score if slot in slot_map else 0
            candidate = _best_conditional_candidate_for_slot(
                set_name,
                slot,
                classified,
                job,
                character_level,
                base_score,
                item_stats,
            )
            if candidate is None:
                continue

            condition_type, condition_name, score, item_name = candidate
            slots = entries_by_condition.setdefault((condition_type, condition_name), {})
            existing = slots.get(slot)
            if existing is None or score > existing[0]:
                slots[slot] = (score, item_name)

        entries: list[dict[str, object]] = []
        for (condition_type, condition_name), slots in sorted(entries_by_condition.items()):
            entries.append(
                {
                    "condition": _conditional_condition_manifest(condition_type, condition_name),
                    "slots": {
                        slot: item_name
                        for slot, (_score, item_name) in sorted(
                            slots.items(),
                            key=lambda value: SLOT_ORDER.index(value[0]),
                        )
                    },
                }
            )
        if entries:
            conditional_equips[set_name] = tuple(entries)
    return conditional_equips


def _best_conditional_candidate_for_slot(
    style_name: str,
    slot: str,
    classified: tuple[tuple[GearItem, ClassifiedItem], ...],
    job: str,
    character_level: int,
    base_score: int,
    item_stats: ItemStatsIndex,
) -> tuple[str, str, int, str] | None:
    best: tuple[str, str, int, str] | None = None
    best_rank: tuple[int, int, int] | None = None
    for item, classification in classified:
        if not _slot_eligible(item, classification, slot):
            continue
        if not _is_eligible_combat_item(item, classification, job, character_level):
            continue
        conditional_scores = _conditional_mod_scores_by_condition(style_name, item, item_stats)
        if not conditional_scores:
            continue
        unconditional_score = _score_item(
            style_name,
            slot,
            item,
            classification,
            tuple(),
            item_stats=item_stats,
        )
        for (condition_type, condition_name), conditional_score in conditional_scores.items():
            score = unconditional_score + conditional_score
            if score <= base_score:
                continue
            candidate = (condition_type, condition_name, score, item.name)
            rank = (score, _authoritative_item_level(item, classification), item.id)
            if best_rank is None or rank > best_rank:
                best = candidate
                best_rank = rank
    return best


def _conditional_mod_scores_by_condition(
    style_name: str,
    item: GearItem,
    item_stats: ItemStatsIndex,
) -> dict[tuple[str, str], int]:
    weights = _conditional_style_mod_weights(style_name)
    if not weights:
        return {}
    scores: dict[tuple[str, str], int] = {}
    for conditional_mod in item_stats.conditional_mods_for_item_id(item.id):
        score = _conditional_mod_score(conditional_mod, weights)
        if score <= 0:
            continue
        condition = (
            conditional_mod.condition_type,
            conditional_mod.condition_name,
        )
        scores[condition] = scores.get(condition, 0) + score
    return scores


def _conditional_mod_score(
    conditional_mod: ItemConditionalMod,
    weights: dict[str, int],
) -> int:
    weight = weights.get(conditional_mod.name, 0)
    if weight == 0 or conditional_mod.value == 0:
        return 0
    return conditional_mod.value * weight


def _conditional_condition_manifest(condition_type: str, condition_name: str) -> dict[str, object]:
    condition: dict[str, object] = {
        "type": condition_type,
        "name": condition_name,
    }
    if condition_type == "status":
        condition["buffs"] = (condition_name,)
    elif condition_type in {"level_lt", "level_gte", "mpp_lt", "mp_gt"}:
        try:
            condition["threshold"] = int(condition_name)
        except ValueError:
            pass
    elif condition_type == "zone_region" and condition_name == "tu_lia":
        condition["areas"] = (
            "Hall of the Gods",
            "La'Loff Amphitheater",
            "Ru'Aun Gardens",
            "The Celestial Nexus",
            "The Shrine of Ru'Avitau",
            "Ve'Lugannon Palace",
        )
    return condition


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
    for mod_name, value in _player_mods_for(selected.classification):
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


def _authoritative_item_level(item: GearItem, classification: ClassifiedItem) -> int:
    if classification.server_level is not None:
        return classification.server_level
    return item.level


def _selected_rank(selected: SelectedGear) -> tuple[int, int, int]:
    return (
        selected.score,
        _authoritative_item_level(selected.item, selected.classification),
        selected.item.id,
    )


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
    allowed_weapon_families: tuple[str, ...] | None = None,
    job: str | None = None,
    character_level: int | None = None,
) -> int:
    if style_name == "Craft":
        score = _authoritative_item_level(item, classification) * 8
        for role in classification.roles:
            score += STYLE_ROLE_WEIGHTS.get(style_name, {}).get(role, 0)
        return score

    mod_score = _mod_score(style_name, classification)
    latent_score = _latent_mod_score(style_name, item, item_stats)
    score = mod_score + latent_score

    if slot in WEAPON_SLOTS:
        uses_slot_weapon_damage = _uses_weapon_damage_score_for_slot(style_name, slot, classification, job)
        if slot == "Ammo" and not uses_slot_weapon_damage and score <= 0:
            return 0
        score += _weapon_family_preference_bonus(classification, allowed_weapon_families)
        if uses_slot_weapon_damage:
            score += _weapon_score(item, classification, item_stats, target_profile)
            score += _job_weapon_skill_bonus(classification, item_stats, job, character_level)
            score += _weapon_policy_bonus(item, slot_policy)
    return score


def _score_item_with_weights(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    preferred_names: tuple[str, ...],
    weights: dict[str, int],
    *,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
) -> int:
    del preferred_names
    score = score_mechanics_mods(
        _scoring_style_name(style_name),
        classification.server_mods,
        classification.pet_server_mods,
        weights,
    ).score
    score += _latent_mod_score_with_weights(style_name, item, item_stats, weights)
    if slot in WEAPON_SLOTS and _uses_weapon_damage_score_for_slot(style_name, slot, classification, None):
        score += _weapon_score(item, classification, item_stats, target_profile)
    return score


def _uses_weapon_damage_score(style_name: str) -> bool:
    if style_name in STYLE_MOD_WEIGHTS:
        return style_name not in NON_DAMAGE_WEAPON_SCORE_STYLES
    return _scoring_style_name(style_name) in DAMAGE_WEAPON_SCORE_STYLES


def _uses_weapon_damage_score_for_slot(
    style_name: str,
    slot: str,
    classification: ClassifiedItem,
    job: str | None,
) -> bool:
    if not _uses_weapon_damage_score(style_name):
        return False
    if slot != "Ammo":
        return True
    scoring_style = _scoring_style_name(style_name)
    if scoring_style in {"RangedDamage", "RangedAccuracy"}:
        return True
    return job is not None and _style_has_daken(job, style_name) and classification.is_shuriken


def _is_movement_style(style_name: str) -> bool:
    return style_name in MOVEMENT_SEMANTIC_STYLES or _scoring_style_name(style_name) == "Movement"


def _allows_multi_slot_movement_overlay(style_name: str) -> bool:
    return style_name == "InCity"


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
    allowed_weapon_families: tuple[str, ...] | None = None,
    job: str | None = None,
    character_level: int | None = None,
) -> str:
    if style_name == "Safe":
        return f"Calculated for Safe from {_score_evidence(style_name, slot, item, classification, item_stats, target_profile, slot_policy, allowed_weapon_families, job=job, character_level=character_level)}."
    if style_name == "Craft":
        return "Selected only for non-engaged Craft mode; combat playstyles hard-exclude crafting utility gear."
    return f"Calculated for {style_name} from {_score_evidence(style_name, slot, item, classification, item_stats, target_profile, slot_policy, allowed_weapon_families, job=job, character_level=character_level)}."


def _selection_reason_with_weights(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    preferred_names: tuple[str, ...],
    weights: dict[str, int],
    *,
    item_stats: ItemStatsIndex | None = None,
    target_profile: TargetProfile | None = None,
    reason_prefix: str | None = None,
) -> str:
    del preferred_names
    prefix = reason_prefix or f"Calculated for {style_name}"
    evidence = _score_evidence_with_weights(
        style_name,
        slot,
        item,
        classification,
        weights,
        item_stats=item_stats,
        target_profile=target_profile,
    )
    return f"{prefix} from {evidence}."


def _mod_score(style_name: str, classification: ClassifiedItem) -> int:
    weights = _style_mod_weights(style_name)
    return score_mechanics_mods(
        _scoring_style_name(style_name),
        _player_mods_for(classification),
        _pet_mods_for(classification),
        weights,
    ).score


def _player_mods_for(classification: ClassifiedItem) -> tuple[tuple[str, int], ...]:
    return classification.server_mods + classification.augment_mods


def _pet_mods_for(classification: ClassifiedItem) -> tuple[tuple[str, int], ...]:
    return classification.pet_server_mods + classification.pet_augment_mods


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


def _latent_mod_score_with_weights(
    style_name: str,
    item: GearItem,
    item_stats: ItemStatsIndex | None,
    weights: dict[str, int],
) -> int:
    if item_stats is None or not weights:
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


def _jewelry_has_primary_score(
    style_name: str,
    item: GearItem,
    classification: ClassifiedItem,
    weights: dict[str, int],
    item_stats: ItemStatsIndex | None,
) -> bool:
    positive_mod_names = _positive_weighted_mod_names(classification.server_mods, weights)
    positive_mod_names.update(_positive_weighted_mod_names(classification.pet_server_mods, weights))
    positive_mod_names.update(_positive_weighted_latent_mod_names(style_name, item, item_stats, weights))
    if _scoring_style_name(style_name) == "Resting":
        secondary_only_mods = RESTING_JEWELRY_SECONDARY_ONLY_MODS
    else:
        secondary_only_mods = JEWELRY_SECONDARY_ONLY_MODS
    return bool(positive_mod_names - secondary_only_mods)


def _positive_weighted_mod_names(
    mods: tuple[tuple[str, int], ...],
    weights: dict[str, int],
) -> set[str]:
    positive_mod_names: set[str] = set()
    for name, value in mods:
        weight = weights.get(name, 0)
        if weight and value * weight > 0:
            positive_mod_names.add(name)
    return positive_mod_names


def _positive_weighted_latent_mod_names(
    style_name: str,
    item: GearItem,
    item_stats: ItemStatsIndex | None,
    weights: dict[str, int],
) -> set[str]:
    if item_stats is None or not weights:
        return set()
    positive_mod_names: set[str] = set()
    for latent in item_stats.latents_for_item_id(item.id):
        if not _latent_applies_to_style(style_name, latent.condition_id, latent.condition_value):
            continue
        weight = weights.get(latent.name, 0)
        if weight and latent.value * weight > 0:
            positive_mod_names.add(latent.name)
    return positive_mod_names


def _weapon_score(
    item: GearItem,
    classification: ClassifiedItem,
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None,
) -> int:
    if item_stats is None:
        base_score = _authoritative_item_level(item, classification) * 100
        return base_score + _target_weapon_bonus(classification, base_score, target_profile)
    weapon_stats = item_stats.weapon_stats_for_item_id(item.id)
    if weapon_stats is None:
        base_score = _authoritative_item_level(item, classification) * 100
        return base_score + _target_weapon_bonus(classification, base_score, target_profile)
    effective_hits = _effective_weapon_hits(item, weapon_stats, item_stats)
    base_score = (
        int(weapon_stats.damage * effective_hits * 100_000 / weapon_stats.delay)
        if weapon_stats.delay > 0
        else 0
    )
    return base_score + _target_weapon_bonus(classification, base_score, target_profile)


def _effective_weapon_hits(
    item: GearItem,
    weapon_stats: WeaponStats,
    item_stats: ItemStatsIndex | None = None,
) -> int:
    effective_hits = max(weapon_stats.hit, CATSEYE_EFFECTIVE_WEAPON_HITS.get(item.id, 1), 1)
    if item_stats is None:
        return effective_hits

    for mod in item_stats.mods_for_item_id(item.id):
        if mod.name == "MAX_SWINGS" and mod.value > effective_hits:
            effective_hits = mod.value
        elif mod.name == "MYTHIC_OCC_ATT_TWICE" and mod.value > 0:
            effective_hits = max(effective_hits, 2)
    return effective_hits


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


def _weapon_family_preference_bonus(
    classification: ClassifiedItem,
    allowed_weapon_families: tuple[str, ...] | None,
) -> int:
    if not allowed_weapon_families:
        return 0
    try:
        rank = allowed_weapon_families.index(classification.weapon_family)
    except ValueError:
        return 0
    return (len(allowed_weapon_families) - rank) * WEAPON_FAMILY_PREFERENCE_BONUS


def _job_weapon_skill_bonus(
    classification: ClassifiedItem,
    item_stats: ItemStatsIndex | None,
    job: str | None,
    character_level: int | None,
) -> int:
    rank, cap = _job_weapon_skill_rank_cap(classification, item_stats, job, character_level)
    if rank is None or cap is None:
        return 0
    return (cap * JOB_WEAPON_SKILL_CAP_BONUS) + (max(0, 16 - rank) * JOB_WEAPON_SKILL_RANK_BONUS)


def _job_weapon_skill_rank_cap(
    classification: ClassifiedItem,
    item_stats: ItemStatsIndex | None,
    job: str | None,
    character_level: int | None,
) -> tuple[int | None, int | None]:
    if item_stats is None or job is None or character_level is None:
        return None, None
    skill_id = WEAPON_SKILL_ID_BY_FAMILY.get(classification.weapon_family)
    if skill_id is None:
        return None, None
    rank = item_stats.skill_ranks_by_skill_job.get((skill_id, job.upper()))
    if rank is None:
        return None, None
    cap = _skill_cap_for_rank(item_stats, character_level, rank)
    if cap <= 0:
        return rank, None
    return rank, cap


def _skill_cap_for_rank(item_stats: ItemStatsIndex, character_level: int, rank: int) -> int:
    direct = item_stats.skill_caps_by_level_rank.get((character_level, rank))
    if direct is not None:
        return direct
    eligible_levels = [
        level
        for level, candidate_rank in item_stats.skill_caps_by_level_rank
        if candidate_rank == rank and level <= character_level
    ]
    if not eligible_levels:
        return 0
    return item_stats.skill_caps_by_level_rank[(max(eligible_levels), rank)]


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
    allowed_weapon_families: tuple[str, ...] | None = None,
    *,
    job: str | None = None,
    character_level: int | None = None,
) -> str:
    weights = _style_mod_weights(style_name)
    mechanics_score = score_mechanics_mods(
        _scoring_style_name(style_name),
        classification.server_mods,
        classification.pet_server_mods,
        weights,
    )
    augment_score = score_mechanics_mods(
        _scoring_style_name(style_name),
        classification.augment_mods,
        classification.pet_augment_mods,
        weights,
    )
    parts: list[str] = []
    if slot in WEAPON_SLOTS and _uses_weapon_damage_score_for_slot(style_name, slot, classification, job):
        weapon_stats = item_stats.weapon_stats_for_item_id(item.id) if item_stats else None
        if weapon_stats is not None:
            effective_hits = _effective_weapon_hits(item, weapon_stats, item_stats)
            evidence = f"weapon damage {weapon_stats.damage}, delay {weapon_stats.delay}"
            if effective_hits > max(weapon_stats.hit, 1):
                evidence += f", Catseye effective hits {effective_hits}"
            parts.append(evidence)
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
        if allowed_weapon_families is not None and classification.weapon_family in allowed_weapon_families:
            parts.append(f"weapon family preference {classification.weapon_family}")
        rank, cap = _job_weapon_skill_rank_cap(classification, item_stats, job, character_level)
        if rank is not None and cap is not None:
            parts.append(f"job skill rank {rank} cap {cap}")
    if mechanics_score.weighted_mods:
        parts.append("weighted mods " + ", ".join(mechanics_score.weighted_mods))
    if mechanics_score.pet_weighted_mods:
        parts.append("pet weighted mods " + ", ".join(mechanics_score.pet_weighted_mods))
    if augment_score.weighted_mods:
        parts.append("augment weighted mods " + ", ".join(augment_score.weighted_mods))
    if augment_score.pet_weighted_mods:
        parts.append("pet augment weighted mods " + ", ".join(augment_score.pet_weighted_mods))
    latent_parts = _latent_score_evidence(style_name, item, item_stats)
    if latent_parts:
        parts.append("conditional latents " + ", ".join(latent_parts))
    surfaces = mechanics_score.surfaces or augment_score.surfaces
    if surfaces:
        parts.append("mechanics surfaces " + ", ".join(surfaces))
    if not parts:
        parts.append("eligible gear tie-breakers; no weighted combat mods")
    return "; ".join(parts)


def _score_evidence_with_weights(
    style_name: str,
    slot: str,
    item: GearItem,
    classification: ClassifiedItem,
    weights: dict[str, int],
    *,
    item_stats: ItemStatsIndex | None,
    target_profile: TargetProfile | None = None,
) -> str:
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
            effective_hits = _effective_weapon_hits(item, weapon_stats, item_stats)
            evidence = f"weapon damage {weapon_stats.damage}, delay {weapon_stats.delay}"
            if effective_hits > max(weapon_stats.hit, 1):
                evidence += f", Catseye effective hits {effective_hits}"
            parts.append(evidence)
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
    latent_parts = _latent_score_evidence_with_weights(style_name, item, item_stats, weights)
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


def _latent_score_evidence_with_weights(
    style_name: str,
    item: GearItem,
    item_stats: ItemStatsIndex | None,
    weights: dict[str, int],
) -> list[str]:
    if item_stats is None or not weights:
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
    default_playstyle: str,
    subjob_profiles: dict[str, SubjobProfile],
    default_subjob: str,
    style_subjobs: dict[str, str],
    sets: dict[str, dict[str, str]],
    selected: dict[str, dict[str, SelectedGear]],
    conditional_equips: dict[str, tuple[dict[str, object], ...]],
    mechanics_swap_planner: dict[str, object],
    rejected_items: dict[str, object],
    profile_features: tuple[str, ...] = tuple(),
) -> dict[str, object]:
    commands = default_forward_commands(
        playstyles=tuple(style.name for style in contract.playstyles),
        profile_features=profile_features,
    )
    keybinding_plan = plan_keybindings(commands)
    number_row_palette = plan_number_row_palette(
        job=job,
        playstyles=tuple(style.name for style in contract.playstyles),
        available_sets=tuple(sets),
        profile_features=profile_features,
    )
    manifest = {
        "player": player,
        "playerId": player_id,
        "job": job,
        "level": contract.character_level,
        "levelSource": contract.level_source,
        "defaultPlaystyle": default_playstyle,
        "contractDefaultPlaystyle": contract.default_playstyle,
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
        "conditionalEquips": conditional_equips,
        "rejectedItems": rejected_items,
        "serverItemStats": _server_item_stats_manifest(item_stats),
        "mechanicsDecisionModel": _mechanics_decision_manifest(contract, item_stats),
        "mechanicsSwapPlanner": mechanics_swap_planner,
        "commandRegistry": {
            "commands": [command.to_manifest() for command in commands],
        },
        "keyBindings": keybinding_plan.to_manifest(),
        "numberRowPalette": number_row_palette.to_manifest(),
        "subjobModel": {
            "defaultSubjob": default_subjob,
            "styleSubjobs": style_subjobs,
            "subjobLevel": 37,
            "profiles": subjob_manifest(subjob_profiles),
            "dualWieldSubSets": sorted(_dual_wield_sub_sets_for_sets(selected)),
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
    validate_profile_manifest(manifest)
    return manifest


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
        "mechanicsOpportunities": mechanics_opportunity_manifest(item_stats),
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
    normalized_job = job.upper()
    families: set[str] = set()
    default_rules = JOB_DEFAULT_WEAPON_FAMILIES.get(normalized_job, {})
    for slot_families in default_rules.values():
        families.update(slot_families)
    for style_rules in JOB_STYLE_WEAPON_FAMILIES.get(normalized_job, {}).values():
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
