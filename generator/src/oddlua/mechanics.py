from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping


ModTuple = tuple[str, int]


STYLE_SURFACES = {
    "Melt": ("dps", "tp_cycle", "accuracy", "haste", "weapon_skill"),
    "Dagger": ("dps", "tp_cycle", "accuracy", "weapon_skill"),
    "Safe": ("survival", "evasion", "accuracy"),
    "Treasure": ("dps", "treasure", "accuracy"),
    "Tank": ("survival", "enmity", "shield", "mitigation"),
    "Enmity": ("enmity", "fast_cast", "survival"),
    "Damage": ("dps", "tp_cycle", "accuracy", "weapon_skill"),
    "MagicDefense": ("survival", "magic_defense", "elemental_resistance"),
    "Nuke": ("magic_dps", "magic_accuracy", "target_element"),
    "MagicAccuracy": ("enfeeble", "magic_accuracy", "duration", "target_resistance"),
    "FastCast": ("cast_cycle", "recast", "interrupt_reliability"),
    "IdleRefresh": ("sustain", "refresh", "survival"),
    "PhysicalIdle": ("survival", "mitigation", "downtime"),
    "Resting": ("sustain", "hmp", "recovery"),
    "Movement": ("movement_speed", "idle_utility", "travel"),
    "Movement_City": ("movement_speed", "city_latent", "travel"),
    "Movement_Night": ("movement_speed", "night_latent", "travel"),
    "Movement_DuskToDawn": ("movement_speed", "dusk_to_dawn_latent", "travel"),
    "Accuracy": ("dps", "accuracy", "target_evasion"),
    "WeaponSkill": ("weapon_skill", "accuracy", "target_sdt"),
    "Survival": ("survival", "mitigation", "evasion"),
    "Evasion": ("survival", "evasion", "shadows"),
    "Cure": ("hps", "cure_potency", "cast_cycle", "enmity"),
    "Enspell": ("dps", "enspell", "magic_accuracy", "enhancing_duration"),
    "DrainAbsorb": ("dark_magic", "enfeeble", "magic_accuracy", "sustain"),
    "PetDamage": ("pet_dps", "pet_accuracy", "master_pet_tradeoff"),
    "PetTank": ("pet_survival", "pet_mitigation", "master_pet_tradeoff"),
    "Song": ("song", "enfeeble", "duration", "magic_accuracy"),
    "RangedDamage": ("ranged_dps", "ranged_accuracy", "snapshot"),
    "RangedAccuracy": ("ranged_accuracy", "target_evasion"),
    "StoreTP": ("tp_cycle", "store_tp", "haste"),
    "Ninjutsu": ("ninjutsu", "magic_accuracy", "cast_cycle"),
    "Jump": ("weapon_skill", "jump", "accuracy"),
    "AvatarPerp": ("pet_sustain", "refresh", "avatar_perpetuation"),
    "BloodPact": ("pet_dps", "blood_pact", "pet_accuracy"),
    "SummoningMagic": ("pet_magic", "summoning_skill", "magic_accuracy"),
    "PhysicalBlue": ("blue_physical", "dps", "accuracy"),
    "MagicalBlue": ("blue_magical", "magic_dps", "magic_accuracy"),
    "QuickDraw": ("quick_draw", "magic_dps", "magic_accuracy", "dot_amplification"),
    "Roll": ("phantom_roll", "duration", "support"),
    "Waltz": ("hps", "waltz", "tp_sustain", "enmity"),
    "GeoMagic": ("geomancy", "enfeeble", "duration", "magic_accuracy"),
}

PET_WEIGHT_ALIASES = {
    "ACC": "PET_ACC",
    "RACC": "PET_ACC",
    "PET_RACC": "PET_ACC",
    "ATT": "PET_ATK",
    "ATTP": "PET_ATK",
    "RATT": "PET_ATK",
    "RATTP": "PET_ATK",
    "PET_ATT": "PET_ATK",
    "PET_RATT": "PET_ATK",
    "MATT": "PET_MAB",
    "MAGIC_DAMAGE": "PET_MAB",
    "PET_MATT": "PET_MAB",
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
}


@dataclass(frozen=True)
class MechanicsScore:
    score: int
    weighted_mods: tuple[str, ...]
    pet_weighted_mods: tuple[str, ...]
    surfaces: tuple[str, ...]


def score_mechanics_mods(
    style_name: str,
    player_mods: tuple[ModTuple, ...],
    pet_mods: tuple[ModTuple, ...],
    weights: Mapping[str, int],
) -> MechanicsScore:
    score = 0
    weighted_mods: list[str] = []
    pet_weighted_mods: list[str] = []

    for name, value in player_mods:
        weight = weights.get(name, 0)
        if weight == 0 or value == 0:
            continue
        score += value * weight
        weighted_mods.append(f"{name}{value:+d}")

    for name, value in pet_mods:
        weight_name = PET_WEIGHT_ALIASES.get(name, name)
        weight = weights.get(weight_name, weights.get(name, 0))
        if weight == 0 or value == 0:
            continue
        score += value * weight
        pet_weighted_mods.append(f"{name}{value:+d}")

    return MechanicsScore(
        score=score,
        weighted_mods=tuple(weighted_mods),
        pet_weighted_mods=tuple(pet_weighted_mods),
        surfaces=STYLE_SURFACES.get(style_name, tuple()),
    )


def mechanics_manifest_for_style(style_name: str) -> dict[str, object]:
    return {
        "style": style_name,
        "surfaces": list(STYLE_SURFACES.get(style_name, tuple())),
    }


def mechanics_source_manifest(mechanics_counts: Mapping[str, int]) -> dict[str, object]:
    return {
        "abilities": int(mechanics_counts.get("abilities", 0)),
        "spells": int(mechanics_counts.get("spells", 0)),
        "statusEffects": int(mechanics_counts.get("status_effects", 0)),
        "petItemMods": int(mechanics_counts.get("item_mods_pet", 0)),
    }
