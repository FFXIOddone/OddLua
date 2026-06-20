from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import re
import sqlite3
from typing import Iterable

from .catseye_wiki_stats import (
    DIRECT_STAT_MODS,
    STAT_MOD_IDS,
    comparable_wiki_stats_text,
    parse_wiki_conditional_stat_mods,
    parse_wiki_stat_mods,
    parse_wiki_weapon_stats,
)
from .itemstats import EQUIPMENT_SLOT_MASKS, JOB_ID_BY_ABBR, MOD_NAMES
from .manifests.provenance import CatseyeProvenance, metadata_entries_for_provenance
from .sources.catseye_git import inspect_git_checkout
from .sources.catseye_launcher import inspect_launcher


SQL_FILES = (
    "item_basic.sql",
    "item_equipment.sql",
    "item_weapon.sql",
    "item_mods.sql",
    "item_latents.sql",
    "augments.sql",
    "merits.sql",
    "traits.sql",
    "skill_caps.sql",
    "skill_ranks.sql",
    "weapon_skills.sql",
    "item_usable.sql",
)

REQUIRED_SQL_FILES = (
    "item_basic.sql",
    "item_equipment.sql",
    "item_weapon.sql",
)

CORE_MECHANICS_SQL_FILES = (
    "abilities.sql",
    "spell_list.sql",
    "status_effects.sql",
    "item_mods_pet.sql",
)

MOB_SQL_FILES = (
    "mob_resistances.sql",
    "mob_pools.sql",
    "mob_species_system.sql",
    "mob_groups.sql",
)

MOD_ENUM_RE = re.compile(r"^\s*([A-Z][A-Z0-9_]*)\s*=\s*(-?\d+)\s*,?", re.MULTILINE)
ITEM_ID_RE = re.compile(r"--\s*ID:\s*(\d+)")
ITEM_NAME_RE = re.compile(r"--\s*Item:\s*([^\r\n]+)")
FOOD_TYPE_RE = re.compile(r"xi\.foodType\.([A-Z0-9_]+)")
DURATION_RE = re.compile(r"duration\s*=\s*(\d+)")
ON_EFFECT_GAIN_RE = re.compile(
    r"itemObject\.onEffectGain\s*=\s*function\s*\([^)]*\)(.*?)(?:itemObject\.onEffectLose\s*=|return\s+itemObject|$)",
    re.DOTALL,
)
ADD_MOD_RE = re.compile(r"effect:addMod\s*\(\s*xi\.mod\.([A-Z0-9_]+)\s*,\s*(-?\d+)\s*\)")
ADD_PET_MOD_RE = re.compile(r"target:addPetMod\s*\(\s*xi\.mod\.([A-Z0-9_]+)\s*,\s*(-?\d+)\s*\)")
CATSEYE_EQUIPMENT_HEADER_RE = re.compile(r"^\[([^\]]+)\]All Races$")
CATSEYE_LEVEL_RE = re.compile(r"^Lv\.(\d+)\s*(.*)$")
CATSEYE_NAME_NORMALIZE_RE = re.compile(r"[^a-z0-9]+")
CATSEYE_SIGNED_SUFFIX_RE = re.compile(r"([+-])\s*(\d+)")
CATSEYE_RECIPE_MARKER_RE = re.compile(r"(^|\s)\*+(\s|$)")
CATSEYE_MOVEMENT_SPEED_RE = re.compile(r"\bmovement\s+speed\s*\+?\s*(\d+)\s*%", re.IGNORECASE)
CATSEYE_MOUNT_MOVEMENT_RE = re.compile(r"\bmount\s+movement\s+speed\b", re.IGNORECASE)
CATSEYE_ALL_ELEMENTS_AFFINITY_RE = re.compile(r"\ball\s+elements?\s+affinity\s*\+?\s*(\d+)", re.IGNORECASE)
CATSEYE_DOUBLE_ATTACK_DAMAGE_RE = re.compile(
    r"\b(?:increases\s+)?\"?double\s+attack\"?\s+damage(?:\s*\+?\s*(\d+)\s*%?)?",
    re.IGNORECASE,
)
CATSEYE_OCC_ATTACKS_TWICE_RE = re.compile(r"\boccasionally\s+attacks\s+twice\b", re.IGNORECASE)
CATSEYE_SURVEYOR_RE = re.compile(r'"?\bSurveyor\b"?\s*\+(\d+)', re.IGNORECASE)
CATSEYE_EXPERT_ANGLER_RE = re.compile(r'"?\bExpert Angler\b"?\s*\+(\d+)', re.IGNORECASE)
CATSEYE_FATIGUE_LIMIT_RE = re.compile(r"\bFatigue limit\s*\+(\d+)%", re.IGNORECASE)
CATSEYE_GOLDEN_ARROW_RATE_RE = re.compile(r"\bGolden Arrow Rate\s*\+(\d+)%", re.IGNORECASE)
CATSEYE_MAGIC_POTENCY_RE = re.compile(r"\bMagic\s+Potency\s*\+?\s*(\d+)\s*%", re.IGNORECASE)
CATSEYE_SLOT_SIDE_MAGIC_SKILLS_RE = re.compile(
    r"\b(?P<side>right|left)\s+ear\s*:\s*Magic\s+skills\s*\+?\s*(?P<value>\d+)",
    re.IGNORECASE,
)
CATSEYE_GENERIC_MAGIC_SKILL_RE = re.compile(
    r"(?<![A-Za-z]\s)\bMagic\s+skill\s*\+?\s*(\d+)",
    re.IGNORECASE,
)
CATSEYE_SYNTHESIS_SKILL_RE = re.compile(r"\bSynthesis\s+skill\s*\+?\s*(\d+)", re.IGNORECASE)
CATSEYE_FENCER_RE = re.compile(r"\bFencer\s*\+?\s*(\d+)", re.IGNORECASE)
CATSEYE_MANUAL_REVIEW_EFFECT_PATTERNS = (
    (
        "unlabeled_signed_source_fragment",
        re.compile(r"\b(?:DEF|DMG|Delay):\s*\d+\s+([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "source_anomaly",
        "Catseye source has an unlabeled signed value; retained for manual source cleanup.",
    ),
    (
        "latent_weapon_damage",
        re.compile(r"\bLatent effect:\s*DMG\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Latent weapon damage needs latent-condition modeling before scoring.",
    ),
    (
        "latent_weapon_damage_absolute",
        re.compile(r"\bLatent effect:\s*DMG\s*:\s*(\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Absolute latent weapon damage needs latent-condition modeling before scoring.",
    ),
    (
        "latent_range_stat",
        re.compile(r"\bLatent effect:\s*[^.]*[+-]\s*\d+\s*~\s*\d+", re.IGNORECASE),
        "unsupported",
        "Latent ranged stat values need condition and roll-range modeling before scoring.",
    ),
    (
        "latent_critical_hit_damage",
        re.compile(r"\bLatent effect:\s*Increases critical hit damage\b", re.IGNORECASE),
        "unsupported",
        "Unquantified latent critical-hit damage needs condition and value validation before scoring.",
    ),
    (
        "latent_condition_marker",
        re.compile(r"\((?:Latent|TP\s*[<>]=?|when)\b[^)]*\)", re.IGNORECASE),
        "conditional",
        "Source declares a latent condition marker that is not itself a scored stat.",
    ),
    (
        "weapon_damage_delta",
        re.compile(r"(?<!Latent effect:\s)\bDMG\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "source_anomaly",
        "Weapon damage delta text is not an item_mod and is tracked as a source anomaly.",
    ),
    (
        "overload_rate",
        re.compile(r'"?\bOverload\b"?\s+rate\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Puppetmaster overload-rate wording has no direct scored item_mod mapping.",
    ),
    (
        "resist_death_damage",
        re.compile(r"\bResist\s+DEATH/DMG\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Slash-combined death resistance and damage text needs manual source review before scoring.",
    ),
    (
        "healing_magic_casting_time",
        re.compile(r"\bHealing magic casting time\s*(-\s*\d+)%(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Current server enum has Cure casting time but no exact healing-magic casting stat.",
    ),
    (
        "latent_weapon_skill_damage",
        re.compile(r"\bLatent effect:\s*Weapon skill damage\s*([+-]\s*\d+)%?(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Latent weapon-skill damage requires condition modeling before scoring.",
    ),
    (
        "weapon_skill_damage",
        re.compile(r"(?<!Latent effect:\s)\bWeapon skill damage\s*([+-]\s*\d+)%?(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Generic weapon-skill damage must be resolved to first-hit/all-hit/per-WS semantics before scoring.",
    ),
    (
        "reward_charm_bonus",
        re.compile(r'\bAugments\s+"Reward"\s+Charm\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Beastmaster Reward/Charm interaction needs mechanic-specific validation.",
    ),
    (
        "reward_effect_charm_bonus",
        re.compile(r'\bEnhances\s+"Reward"\s+effect\s+Charm\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Beastmaster Reward/Charm interaction needs mechanic-specific validation.",
    ),
    (
        "call_beast_charm_bonus",
        re.compile(r'\bAugments\s+"Call Beast"\s+Charm\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Call Beast/Charm wording has no direct scored item_mod mapping.",
    ),
    (
        "tame_charm_bonus",
        re.compile(r'\bImproves\s+"Tame"\s+success\s+rate(?:\s+Vs\.\s+\w+:)?\s+"?Charm"?\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Tame success and Charm bonus text needs Beastmaster-specific mechanic validation.",
    ),
    (
        "reward_recast_family_charm_bonus",
        re.compile(r'\bReduces\s+"Reward"\s+recast\s+time\s+Vs\.\s+\w+:\s+"?Charm"?\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Reward recast and family-scoped Charm text should not be scored as a direct stat.",
    ),
    (
        "family_charm_bonus",
        re.compile(r'\bVs\.\s+\w+:\s+"?Charm"?\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Family-scoped Charm bonus needs target-family modeling before scoring.",
    ),
    (
        "charm_bonus",
        re.compile(
            r'(?<!")(?<!Resist )(?<!Reward" )(?<!Beast" )(?<!effect )(?<!rate )(?<!Birds: )(?<!Lizards: )(?<!Plantoids: )(?<!Vermin: )"?Charm"?\s*([+-]\s*\d+)(?!\s*~)',
            re.IGNORECASE,
        ),
        "unsupported",
        "Standalone Charm bonus is tracked separately from Resist Charm until mechanics are verified.",
    ),
    (
        "automaton_magic_skills",
        re.compile(r"\bAutomaton:\s+Magic Skills\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Automaton skill text is pet-scoped and not a player gear score.",
    ),
    (
        "automaton_skills",
        re.compile(r"\bAutomaton:\s+Skills\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Automaton skill text is pet-scoped and not a player gear score.",
    ),
    (
        "avatar_elemental_resistance",
        re.compile(r"\bAvatar elemental resistance\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Avatar elemental resistance is pet-scoped and needs pet stat modeling before scoring.",
    ),
    (
        "combat_skills",
        re.compile(r"\bCombat skills\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Generic combat skill spans multiple weapon and defensive skill mods.",
    ),
    (
        "magic_skills",
        re.compile(r"(?<!Automaton:\s)\bMagic skills\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Generic magic skills span multiple magic skill mods.",
    ),
    (
        "hidden_alchemy_skill",
        re.compile(r"\bHidden Effect:.*?\bAlchemy Skill\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "utility",
        "Craft utility effect is not a combat gear score.",
    ),
    (
        "hidden_cooking_skill",
        re.compile(r"\bHidden Effect:.*?\bCooking Skill\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "utility",
        "Craft utility effect is not a combat gear score.",
    ),
    (
        "shield_bash",
        re.compile(r"\bShield Bash\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Ability-specific Shield Bash text needs mechanic validation before scoring.",
    ),
    (
        "weapon_bash",
        re.compile(r"\bWeapon Bash\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Ability-specific Weapon Bash text needs mechanic validation before scoring.",
    ),
    (
        "third_eye",
        re.compile(r"\bThird Eye\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Third Eye wording does not identify which server Third Eye mod should be scored.",
    ),
    (
        "reward",
        re.compile(r'(?<!")\bReward\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Reward potency/recast semantics need Beastmaster-specific validation.",
    ),
    (
        "angon_effect",
        re.compile(r'"Angon":\s*Drains movement speed\s+"Angon":\s*Duration\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Angon side effects need ability-specific handling before scoring.",
    ),
    (
        "tomahawk_effect",
        re.compile(r'Tomahawk:\s*Grants\s+"Potency"\s+Tomahawk:\s*Duration\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Tomahawk side effects need ability-specific handling before scoring.",
    ),
    (
        "lunge",
        re.compile(r'"?\bLunge\b"?\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Rune Fencer Lunge bonus needs mechanic-specific validation.",
    ),
    (
        "accomplice_collaborator_effect",
        re.compile(r"\bAccomplice/Collaborator Effect\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Thief enmity-transfer effect is not a generic gear score.",
    ),
    (
        "furnace_blessing_regen_potency",
        re.compile(r"\bFurnace blessing\s*\(Regen Potency\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Furnace blessing wording is a named effect without direct score semantics.",
    ),
    (
        "handbell_mp_not_depleted",
        re.compile(r"\bHandbell\)\s*MP not depleted when magic used\s*([+-]\s*\d+)%?(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Chance-based MP preservation is tracked separately from scored combat stats.",
    ),
    (
        "banish_vs_undead_potency",
        re.compile(r'\bPotency of\s+"Banish"\s+vs\.\s+undead\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Target-family Banish potency needs spell/family condition modeling before scoring.",
    ),
    (
        "item_add_effect_type",
        re.compile(r"\bItem Add Effect Type\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Raw add-effect type marker is source metadata, not a scored stat.",
    ),
    (
        "feral_heart_killer_effects",
        re.compile(r'"Feral Heart"\s*\(Killer Effects\s*([+-]\s*\d+)%?(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Named Feral Heart effect needs Beastmaster-specific validation.",
    ),
    (
        "killer_effects",
        re.compile(r'(?<!"Feral Heart" \()\bKiller Effects\s*([+-]\s*\d+)%?(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Generic Killer Effects text does not identify a specific killer-family mod.",
    ),
    (
        "nt",
        re.compile(r"\bNT\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "NT abbreviation is source-specific and needs manual interpretation.",
    ),
    (
        "oggbis_wisdom_guard",
        re.compile(r'"?Oggbi\'s Wisdom"?\s*\(Guard\s*([+-]\s*\d+)%?(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Named Oggbi's Wisdom effect should not be reduced to a generic Guard stat without validation.",
    ),
    (
        "wings_era_recollection_treasure_hunter",
        re.compile(r'"Wings-Era Warriors:\s*":\s*Enchantment:\s*"Recollection"\s+"Treasure Hunter"\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Named enchantment-side Treasure Hunter effect is tracked separately from passive TH scoring.",
    ),
    (
        "elemental_resistance_spells",
        re.compile(r"\bElemental Resistance spells\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Barspell-style elemental resistance text needs spell-effect modeling before scoring.",
    ),
    (
        "latent_cursed_conserve_mp",
        re.compile(r'\bLatent Effect \(Cursed\):\s*"Conserve MP"\s*([+-]\s*\d+)(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Cursed latent Conserve MP requires latent-condition handling before scoring.",
    ),
    (
        "poison_effect",
        re.compile(r"\bPoison effect\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Named poison proc/effect text is not a generic combat stat.",
    ),
    (
        "step_tp_consumed",
        re.compile(r"\bStep TP consumed\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Dancer Step TP consumption needs job-ability-specific handling.",
    ),
    (
        "hidden_tactical_parry",
        re.compile(r'\bHidden effect:\s*"Tactical Parry"\s*([+-]\s*\d+)%?(?!\s*~)', re.IGNORECASE),
        "unsupported",
        "Hidden Tactical Parry is tracked for manual review until hidden-effect scoring is modeled.",
    ),
    (
        "absorb_damage_to_mp",
        re.compile(r"\bAbsorb\s+(?:Dmg|Damage)\s+to\s+MP\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
        "unsupported",
        "Damage-to-MP conversion has no current direct server-backed gear score.",
    ),
    (
        "additional_effect_recover_mp",
        re.compile(r"\bAdditional effect:\s*Recover MP\b", re.IGNORECASE),
        "unsupported",
        "Weapon additional-effect MP recovery needs proc and action-specific modeling before scoring.",
    ),
    (
        "additional_effect_flash",
        re.compile(r"\bAdditional effect:\s*Flash\b", re.IGNORECASE),
        "unsupported",
        "Weapon additional-effect Flash needs proc and action-specific modeling before scoring.",
    ),
    (
        "additional_effect_water",
        re.compile(r"\bAdditional effect:\s*Water\b", re.IGNORECASE),
        "unsupported",
        "Weapon additional-effect Water needs proc and action-specific modeling before scoring.",
    ),
    (
        "additional_effect_tp_drain",
        re.compile(r"\bAdditional effect:\s*TP Drain\b", re.IGNORECASE),
        "unsupported",
        "Weapon additional-effect TP Drain needs proc and action-specific modeling before scoring.",
    ),
    (
        "additional_effect_generic",
        re.compile(
            r"\bAdditional effect(?:\s+with\s+[^:]+)?\s*:\s*[A-Za-z][A-Za-z ,.'%+-]*",
            re.IGNORECASE,
        ),
        "unsupported",
        "Weapon additional effects need proc and action-specific modeling before scoring.",
    ),
    (
        "snapshot_effect",
        re.compile(r'\bEnhances\s+"?Snapshot"?\s+effect\b', re.IGNORECASE),
        "unsupported",
        "Unquantified Snapshot enhancement needs job-action validation before scoring.",
    ),
    (
        "rapid_shot_trait_tier",
        re.compile(r'\bGrants\s+"?Rapid Shot"?\s+(?:[IVX]+|\d+)\b', re.IGNORECASE),
        "unsupported",
        "Trait-tier Rapid Shot grant is tracked separately from numeric RAPID_SHOT gear mods.",
    ),
    (
        "royal_knights_pledge",
        re.compile(r"\bRoyal Knight'?s Pledge\s*\([^)]*", re.IGNORECASE),
        "unsupported",
        "Named Royal Knight's Pledge bundle needs effect-specific modeling before scoring.",
    ),
    (
        "luzafs_curse",
        re.compile(r"\bLuzaf'?s Curse\s*\([^)]*", re.IGNORECASE),
        "unsupported",
        "Named Luzaf's Curse bundle needs effect-specific modeling before scoring.",
    ),
    (
        "domain_incursion_marker",
        re.compile(r'"?Domain Incursion"?', re.IGNORECASE),
        "source_marker",
        "Domain Incursion text is a source/acquisition marker, not a scored equipment stat.",
    ),
    (
        "hidden_piercing_damage",
        re.compile(r"\bHidden effect:\s*Deals piercing damage\b", re.IGNORECASE),
        "unsupported",
        "Hidden damage-type conversion needs weapon damage-type modeling before scoring.",
    ),
    (
        "hidden_blunt_damage",
        re.compile(r"\bHidden effect:\s*Blunt damage\b", re.IGNORECASE),
        "unsupported",
        "Hidden damage-type conversion needs weapon damage-type modeling before scoring.",
    ),
    (
        "hidden_slashing_damage",
        re.compile(r"\bHidden Effect:\s*Slashing damage\b", re.IGNORECASE),
        "unsupported",
        "Hidden damage-type conversion needs weapon damage-type modeling before scoring.",
    ),
    (
        "hidden_pet_ranged_accuracy",
        re.compile(r"\bHidden Effect:\s*Pet:\s*Ranged Acc+uracy\s*\+?(\d+)", re.IGNORECASE),
        "unsupported",
        "Hidden pet ranged accuracy needs hidden-effect and pet-stat modeling before scoring.",
    ),
    (
        "hidden_all_elements_magic_potency",
        re.compile(r"\bHidden Effect:\s*All elements:\s*Magic Potency", re.IGNORECASE),
        "unsupported",
        "Hidden all-elements magic potency bundle needs hidden-effect validation before scoring.",
    ),
    (
        "physical_damage_spikes",
        re.compile(r'\bPhysical damage:\s*"?Shock Spikes"?\s+effect\b', re.IGNORECASE),
        "unsupported",
        "Retaliatory physical-damage spike effects need proc modeling before scoring.",
    ),
    (
        "generic_enhances_effect",
        re.compile(
            r"\bEnhances(?:\s+(?:the\s+)?effects?\s+of|\s+effect\s+of|\s+potency\s+of)?\s+"
            r'(?:"[^"]+"|[A-Za-z][A-Za-z\s.]+?)'
            r"(?:\s+(?:effect|effects|spells|received|potency|attack|accuracy|evasion|damage|duration))?"
            r"(?:\s*\([^)]*\))?",
            re.IGNORECASE,
        ),
        "unsupported",
        "Generic enhancement wording needs ability- or trait-specific validation before scoring.",
    ),
    (
        "adds_refresh_effect",
        re.compile(r'\bAdds\s+"?Refresh"?\s+effect\b', re.IGNORECASE),
        "unsupported",
        "Unquantified Refresh-granting effect needs runtime tick/value validation before scoring.",
    ),
    (
        "adds_regen_effect",
        re.compile(r'\bAdds\s+"?Regen"?\s+effect\b', re.IGNORECASE),
        "unsupported",
        "Unquantified Regen-granting effect needs runtime tick/value validation before scoring.",
    ),
    (
        "converts_hp_to_mp",
        re.compile(r"\bConverts\s+(\d+)\s+HP\s+to\s+MP\b", re.IGNORECASE),
        "unsupported",
        "HP-to-MP conversion is tracked as a mechanic-specific effect, not a direct stat replacement.",
    ),
    (
        "occ_quickens_spellcasting",
        re.compile(r"\bOcc\.\s+Quickens Spellcasting\s*\+?(\d+)%?", re.IGNORECASE),
        "unsupported",
        "Occasionally quickens spellcasting is chance-based and not a direct Fast Cast score.",
    ),
    (
        "grants_tactical_parry",
        re.compile(r'\bGrants\s+"?Tactical Parry"?\b', re.IGNORECASE),
        "unsupported",
        "Trait grant is tracked separately from numeric Tactical Parry gear mods.",
    ),
    (
        "grants_magic_burst_bonus",
        re.compile(r'\bGrants\s+"?Magic Burst Bonus"?\b', re.IGNORECASE),
        "unsupported",
        "Trait grant is tracked separately from numeric magic burst gear mods.",
    ),
    (
        "augments_third_eye",
        re.compile(r'\bAugments\s+"?Third Eye"?\b', re.IGNORECASE),
        "unsupported",
        "Third Eye augmentation needs job-ability-specific validation before scoring.",
    ),
    (
        "wyvern_breaths",
        re.compile(r"\bWyvern uses breaths more effectively\b", re.IGNORECASE),
        "unsupported",
        "Wyvern breath effectiveness needs pet ability modeling before scoring.",
    ),
    *(
        (
            f"{element.lower()}_defense",
            re.compile(rf"\b{element}\s+Def\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE),
            "unsupported",
            "Elemental defense text has no current direct server-backed gear score.",
        )
        for element in ("Fire", "Ice", "Wind", "Earth", "Lightning", "Water", "Light", "Dark")
    ),
)
CATSEYE_PHYSICAL_ACCURACY_RE = re.compile(r"(?<!magic )(?<!ranged )\baccuracy\s*\+(\d+)", re.IGNORECASE)
CATSEYE_STAT_LOOKAHEAD_LINES = 16
CATSEYE_DAMAGE_TAKEN_RE = re.compile(
    r"\b(?P<label>physical\s+damage\s+taken|phys\.\s*dmg\.\s*taken|magic\s+damage\s+taken|mag\.\s*damage\s+taken|damage\s+taken)"
    r"\s*(?!II\b)(?P<sign>[+-])?\s*(?P<value>\d+)(?:\s*~\s*(?P<range>\d+))?\s*%",
    re.IGNORECASE,
)
CATSEYE_DIRECT_STAT_LABEL_MODS = {
    "accuracy": "ACC",
    "acc": "ACC",
    "agi": "AGI",
    "attack": "ATT",
    "atk": "ATT",
    "chr": "CHR",
    "critical hit damage": "CRIT_DMG_INCREASE",
    "critical hit rate": "CRITHITRATE",
    "cure potency": "CURE_POTENCY",
    "def": "DEF",
    "dex": "DEX",
    "double attack": "DOUBLE_ATTACK",
    "dbl. atk": "DOUBLE_ATTACK",
    "dual wield": "DUAL_WIELD",
    "enmity": "ENMITY",
    "enhancing magic skill": "ENHANCE",
    "evasion": "EVA",
    "fast cast": "FASTCAST",
    "geomancy": "GEOMANCY_BONUS",
    "haste": "HASTE_GEAR",
    "healing magic skill": "HEALING",
    "hp": "HP",
    "int": "INT",
    "magic accuracy": "MACC",
    "magic atk. bonus": "MATT",
    "magic attack bonus": "MATT",
    "magic def. bonus": "MDEF",
    "magic defense bonus": "MDEF",
    "magic evasion": "MEVA",
    "magic damage": "MAGIC_DAMAGE",
    "mnd": "MND",
    "mp": "MP",
    "mp recovered while healing": "MPHEAL",
    "parrying skill": "PARRY",
    "ranged accuracy": "RACC",
    "ranged attack": "RATT",
    "rapid shot": "RAPID_SHOT",
    "snapshot": "SNAPSHOT",
    "store tp": "STORETP",
    "str": "STR",
    "subtle blow": "SUBTLE_BLOW",
    "triple attack": "TRIPLE_ATTACK",
    "triple atk.": "TRIPLE_ATTACK",
    "vit": "VIT",
}
CATSEYE_DIRECT_STAT_RE = re.compile(
    r"(?<![A-Za-z])['\"]?(?P<label>"
    + "|".join(
        re.escape(label)
        for label in sorted(CATSEYE_DIRECT_STAT_LABEL_MODS, key=len, reverse=True)
    )
    + r")['\"]?\s*(?P<colon>:)?\s*(?P<sign>[+-])?\s*(?P<value>\d+)(?:\s*~\s*(?P<range>\d+))?\s*(?P<percent>%?)",
    re.IGNORECASE,
)
CATSEYE_HUNDREDTH_PERCENT_MODS = {
    "DMG",
    "DMGPHYS",
    "DMGMAGIC",
    "HASTE_GEAR",
}
CATSEYE_SERVER_AUTHORITY_MODS = {
    # Current Catseye server SQL carries stronger Elemental Celerity values than
    # the wiki text on some items; keep the live build value when it is better.
    "ELEMENTAL_CELERITY",
}
CATSEYE_STAT_MOD_FALLBACK_IDS = {
    "ACC": 25,
    "AGI": 11,
    "ATT": 23,
    "AGGRESSOR_DURATION": 955,
    "AMNESIARES": 253,
    "BARRAGE_COUNT": 138,
    "BINDRES": 247,
    "BLINDRES": 243,
    "BLOOD_BOON": 913,
    "BP_DAMAGE": 126,
    "BP_DELAY": 357,
    "BP_DELAY_II": 541,
    "BERSERK_DURATION": 954,
    "BREATH_DMG_DEALT": 1075,
    "CHARMRES": 252,
    "CHR": 14,
    "COOK": 135,
    "CRITHITRATE": 165,
    "CRIT_DMG_INCREASE": 421,
    "CURE_POTENCY": 374,
    "CURE_POTENCY_RCVD": 375,
    "DEF": 1,
    "DEAD_AIM_EFFECT": 1054,
    "DEX": 9,
    "DMG": 160,
    "DMGPHYS": 161,
    "DMGPHYS_II": 190,
    "DMGMAGIC": 162,
    "DMGMAGIC_II": 831,
    "DOUBLE_ATTACK": 288,
    "DUAL_WIELD": 259,
    "DARK_ARTS_EFFECT": 335,
    "ELEMENTAL_DEBUFF_EFFECT": 1150,
    "ELEMENTAL_CELERITY": 901,
    "ENMITY": 27,
    "ENMITY_LOSS_REDUCTION": 427,
    "ENHANCE": 113,
    "ENSPELL_DMG_BONUS": 432,
    "ELEM": 115,
    "EVA": 68,
    "FASTCAST": 170,
    "GEOMANCY_BONUS": 961,
    "GRIMOIRE_SPELLCASTING": 489,
    "GUARD": 107,
    "HASTE_GEAR": 384,
    "HEALING": 112,
    "HP": 2,
    "HPP": 3,
    "INDI_DURATION": 960,
    "INT": 12,
    "LIGHT_ARTS_EFFECT": 334,
    "LIFE_CYCLE_EFFECT": 1029,
    "MACC": 30,
    "MAGIC_DAMAGE": 311,
    "MAGIC_CRITHITRATE": 562,
    "MAGIC_CRIT_DMG_INCREASE": 563,
    "MATT": 28,
    "MDEF": 29,
    "MEVA": 31,
    "MND": 13,
    "MP": 5,
    "MPP": 6,
    "MPHEAL": 71,
    "MAX_FINISHING_MOVE_BONUS": 988,
    "MAX_SWINGS": 978,
    "NINJA_TOOL": 308,
    "NINJUTSU": 118,
    "OCCULT_ACUMEN": 902,
    "PAEON_EFFECT": 435,
    "PARRY": 110,
    "PETRIFYRES": 246,
    "PFLUG": 1011,
    "RACC": 26,
    "RANGED_DELAYP": 381,
    "RAPID_SHOT": 359,
    "RATT": 24,
    "RECYCLE": 305,
    "REGEN_DURATION": 339,
    "REPAIR_POTENCY": 854,
    "REQUIEM_EFFECT": 436,
    "ROLL_RANGE": 528,
    "LULLABY_EFFECT": 440,
    "JIG_DURATION": 492,
    "SAMBA_DURATION": 490,
    "SNAPSHOT": 365,
    "STORETP": 73,
    "STR": 8,
    "SUBTLE_BLOW": 289,
    "SYNTH_SUCCESS_RATE": 851,
    "SYNTH_MATERIAL_LOSS": 861,
    "SIC_READY_RECAST": 1052,
    "SILENCERES": 244,
    "SWORDPLAY": 1008,
    "TANDEM_BLOW_POWER": 272,
    "TANDEM_STRIKE_POWER": 271,
    "SLEEPRES": 240,
    "TRIPLE_ATTACK": 302,
    "UTSUSEMI_BONUS": 900,
    "STONESKIN_BONUS_HP": 539,
    "SUBTLE_BLOW_II": 973,
    "VIVACIOUS_PULSE_POTENCY": 1012,
    "VIT": 10,
}
CATSEYE_PET_STAT_PREFIX_RE = re.compile(r"\b(?:pet|avatar|wyvern|luopan)\s*:\s*", re.IGNORECASE)
CATSEYE_CONTEXTUAL_HP_MP_PREFIX_RE = re.compile(
    r"(?:conserve|to|into|converted to|damage to|dmg to)\s+$",
    re.IGNORECASE,
)
CATSEYE_UNQUANTIFIED_DOUBLE_ATTACK_DMG_VALUE = 3
CATSEYE_UNQUANTIFIED_OCC_ATTACKS_TWICE_VALUE = 1
CATSEYE_DIRECT_ACCURACY_OVERRIDE_ITEM_IDS = {
    # Somnia Melodiam's Catseye page carries this in plain text, but broad
    # Accuracy+ parsing also catches conditional ranges like Accuracy+0~8.
    18904,
}
ELEMENTAL_STAFF_BONUS_MODS = (
    ("FIRE_STAFF_BONUS", 347),
    ("ICE_STAFF_BONUS", 348),
    ("WIND_STAFF_BONUS", 349),
    ("EARTH_STAFF_BONUS", 350),
    ("THUNDER_STAFF_BONUS", 351),
    ("WATER_STAFF_BONUS", 352),
    ("LIGHT_STAFF_BONUS", 353),
    ("DARK_STAFF_BONUS", 354),
)

ALL_JOB_MASK = sum(1 << (job_id - 1) for job_id in JOB_ID_BY_ABBR.values())
CATSEYE_EQUIPMENT_NAME_ALIASES = {
    # Catseye renamed the retail Ephemeron item in-game/wiki-side but keeps the
    # server item row under its retail name/id.
    "somniamelodiam": 18904,
    "idris": 21070,
    "epeolatry": 20753,
    "sakpatasbreastplate": 23764,
    # Level 75 Catseye Mythic entries use the finished level 75 rows where the
    # duplicate retail base rows and upgraded rows share the same display name.
    "vajra": 18996,
    "nagi": 19003,
    "laevateinn": 18994,
    "tupsimati": 18990,
    # Full wiki names that reconcile to abbreviated Catseye client resource
    # names. Keep these explicit so augmented path variants do not collapse onto
    # their base item rows.
    "clericspantalnplus1": 15582,
    "craftmastersringplus1": 26171,
    "harbingersgaitersplus1": 27401,
    "tempestgamashesplus1": 25943,
    "axemastersgauntlets": 10515,
    "nephilimgrip": 22198,
    "harvesterssunhat": 25557,
    "brigandseyepatch": 28443,
}
CATSEYE_SLOT_FAMILIES = {
    "Ammo": ("Ammo",),
    "Trinket": ("Ammo",),
    "Item": ("Ammo",),
    "Jug": ("Ammo",),
    "Throwing": ("Ammo",),
    "Head": ("Head",),
    "Body": ("Body",),
    "Hands": ("Hands",),
    "Legs": ("Legs",),
    "Feet": ("Feet",),
    "Neck": ("Neck",),
    "Waist": ("Waist",),
    "Back": ("Back",),
    "Earring": ("Ear1", "Ear2"),
    "Ring": ("Ring1", "Ring2"),
    "Shield": ("Sub",),
    "Grip": ("Sub",),
    "Bell": ("Range",),
    "Bow": ("Range",),
    "Crossbow": ("Range",),
    "Gun": ("Range",),
    "Instrument": ("Range",),
    "Sword": ("Main", "Sub"),
    "Dagger": ("Main", "Sub"),
    "Axe": ("Main", "Sub"),
    "Katana": ("Main", "Sub"),
    "Club": ("Main", "Sub"),
    "Hand-to-Hand": ("Main",),
    "Great Axe": ("Main",),
    "Great Katana": ("Main",),
    "Great Sword": ("Main",),
    "Polearm": ("Main",),
    "Scythe": ("Main",),
    "Staff": ("Main",),
}
CATSEYE_ARMOR_SLOT_NAME_TOKENS = {
    "Head": {
        "bandana", "beret", "bonnet", "cap", "crown", "eyepatch",
        "hairpin", "hat", "helm", "khud", "mask", "sallet", "shades",
        "somen", "tiara", "turban",
    },
    "Body": {
        "bliaut", "breastplate", "coat", "cuirie", "cuirass", "doublet",
        "frac", "garb", "gi", "harness", "jackcoat", "jerkin", "mail",
        "manteel", "robe", "togi", "tunic", "vest",
    },
    "Hands": {
        "armlets", "bangles", "cuffs", "gages", "gants", "gauntlets",
        "gloves", "hentzes", "kote", "manopolas", "mitts", "tekko",
    },
    "Legs": {
        "breeches", "brais", "cannions", "cosciales", "cuishes",
        "flanchard", "hakama", "hose", "kecks", "pants",
        "pantaln", "sawabaki", "seraweels", "sitabaki", "slacks",
        "subligar", "tights", "trews", "trousers",
    },
    "Feet": {
        "boots", "bottes", "crackows", "duckbills", "gaiters",
        "gambieras", "gamashes", "jambeaux", "ledelsens", "leggings",
        "loafers", "poulaines", "pumps", "sabatons", "shoes", "slippers",
        "sollerets",
    },
}


@dataclass(frozen=True)
class StatsDbBuildResult:
    path: Path
    item_count: int
    item_mod_count: int
    food_count: int
    food_mod_count: int
    mob_resistance_count: int = 0
    mob_pool_count: int = 0
    mob_group_count: int = 0
    ability_count: int = 0
    spell_count: int = 0
    status_effect_count: int = 0
    pet_item_mod_count: int = 0
    item_latent_count: int = 0
    catseye_equipment_override_count: int = 0
    catseye_equipment_stat_override_count: int = 0
    catseye_equipment_effect_tag_count: int = 0
    client_item_count: int = 0
    client_equipment_update_count: int = 0
    client_weapon_update_count: int = 0
    skill_cap_count: int = 0
    skill_rank_count: int = 0


@dataclass(frozen=True)
class FoodMod:
    target_type: str
    mod_id: int
    mod_name: str
    value: int


@dataclass(frozen=True)
class FoodEffect:
    item_id: int
    name: str
    food_type: str
    duration_seconds: int
    script_path: Path
    mods: tuple[FoodMod, ...]


@dataclass(frozen=True)
class CatseyeEquipmentRecord:
    name: str
    level: int
    jobs_mask: int
    slot_mask: int
    stats_text: str
    source_text: str
    source_path: str


@dataclass(frozen=True)
class CatseyeEquipmentStatOverride:
    item_id: int
    mod_id: int
    mod_name: str
    value: int
    source_path: str
    source_text: str


@dataclass(frozen=True)
class CatseyeEquipmentEffectTag:
    item_id: int
    effect_tag: str
    status: str
    target: str
    source_path: str
    source_text: str
    note: str
    mod_name: str | None = None
    value: int | None = None


@dataclass(frozen=True)
class ClientItemResource:
    item_id: int
    name: str
    level: int
    ilevel: int
    client_jobs_mask: int
    jobs_mask: int
    slot_mask: int
    flags: int
    stack_size: int
    item_type: int
    sub_type: int
    skill: int
    damage: int
    delay: int
    damage_type: int
    shield_size: int
    su_level: int
    valid_targets: int


@dataclass(frozen=True)
class ClientItemResourceImport:
    source_path: Path | None
    item_count: int = 0
    equipment_update_count: int = 0
    weapon_update_count: int = 0


CATSEYE_MANUAL_EQUIPMENT_EFFECTS: tuple[CatseyeEquipmentEffectTag, ...] = (
    CatseyeEquipmentEffectTag(
        item_id=20810,
        effect_tag="attack",
        status="scored",
        target="player",
        mod_name="ATT",
        value=15,
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Attack+15",
        note="Direct Catseye wiki stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=20810,
        effect_tag="physical_damage_taken",
        status="scored",
        target="player",
        mod_name="DMGPHYS",
        value=-1000,
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Physical damage taken -10%",
        note="DMGPHYS uses hundredths of a percent in server item_mods.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=20810,
        effect_tag="pet_attack",
        status="scored",
        target="pet",
        mod_name="ATT",
        value=15,
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Pet: Attack+15",
        note="Pet-side direct stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=20810,
        effect_tag="pet_accuracy",
        status="scored",
        target="pet",
        mod_name="ACC",
        value=10,
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Pet: Accuracy+10",
        note="Pet-side direct stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=20810,
        effect_tag="latent_level_60_plus_occasionally_attacks_twice",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Occasionally attacks twice (Latent Activation: Level 60+)",
        note="Conditional multi-attack is not modeled as always-on weapon hits.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18541,
        effect_tag="accuracy",
        status="scored",
        target="player",
        mod_name="ACC",
        value=5,
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Accuracy+5",
        note="Direct Catseye wiki stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18541,
        effect_tag="sic_ready_delay",
        status="manual_review",
        target="unsupported",
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text='"Sic" and "Ready" ability delay -2',
        note="Ability delay reduction is not a scored equipment mod in OddLua yet.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18541,
        effect_tag="latent_master_pet_haste",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Axe.txt",
        source_text="Latent effect: Haste+2%; Latent effect: Pet: Haste+2%",
        note="Requires BST pet proximity condition and is not always-on.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11531,
        effect_tag="pet_store_tp",
        status="scored",
        target="pet",
        mod_name="STORETP",
        value=3,
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text='Pet: "Store TP"+3',
        note="Pet-side direct stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11531,
        effect_tag="pet_def",
        status="scored",
        target="pet",
        mod_name="DEF",
        value=3,
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Pet: DEF+3",
        note="Pet-side direct stat from the same Pet line.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11531,
        effect_tag="pet_hp",
        status="scored",
        target="pet",
        mod_name="HP",
        value=6,
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Pet: HP+6",
        note="Pet-side direct stat from the same Pet line.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11531,
        effect_tag="pet_mp",
        status="scored",
        target="pet",
        mod_name="MP",
        value=6,
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Pet: MP+6",
        note="Pet-side direct stat from the same Pet line.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11531,
        effect_tag="pet_attack",
        status="scored",
        target="pet",
        mod_name="ATT",
        value=3,
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Pet: Attack+3",
        note="Pet-side direct stat from the same Pet line.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=20597,
        effect_tag="latent_under_level_50_occasionally_attacks_twice",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Dagger.txt",
        source_text="Latent effect: Occasionally attacks twice (Latent Activation: Under Lv50)",
        note="Under-level-50 latent should not be treated as always-on at level 75.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=20597,
        effect_tag="random_attack_damage_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Dagger.txt",
        source_text="Attack+0~3 DMG+0~1",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=19118,
        effect_tag="random_attack_accuracy_agi_dex_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Dagger.txt",
        source_text="Attack+0~5 Accuracy+0~5 AGI+0~5 DEX+0~5",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=23990,
        effect_tag="empty_killer",
        status="scored",
        target="player",
        mod_name="EMPTY_KILLER",
        value=2,
        source_path="pages/CatsEyeXI_Content_Equipment_Earring.txt",
        source_text="Empty Killer+2",
        note="Direct Catseye wiki stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=23990,
        effect_tag="right_ear_magic_skills",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Earring.txt",
        source_text="Right ear: Magic skills +1 (incl. Blue, Geomancy, Handbell)",
        note="Slot-side condition is not currently modeled for earring scoring.",
        value=1,
    ),
    CatseyeEquipmentEffectTag(
        item_id=23991,
        effect_tag="empty_killer",
        status="scored",
        target="player",
        mod_name="EMPTY_KILLER",
        value=3,
        source_path="pages/CatsEyeXI_Content_Equipment_Earring.txt",
        source_text="Empty Killer+3",
        note="Direct Catseye wiki stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=23991,
        effect_tag="right_ear_magic_skills",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Earring.txt",
        source_text="Right ear: Magic skills +2 (incl. Blue, Geomancy, Handbell)",
        note="Slot-side condition is not currently modeled for earring scoring.",
        value=2,
    ),
    CatseyeEquipmentEffectTag(
        item_id=18368,
        effect_tag="wind_fan_conditional_additional_effect",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Great_Sword.txt",
        source_text="Additional effect with wind fan equipped: Wind damage",
        note="Requires a paired fan condition outside current equipment scoring.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18368,
        effect_tag="random_attack_pdt_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Great_Sword.txt",
        source_text="Attack+0~8 Physical Damage Taken-0~4",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18369,
        effect_tag="wind_fan_conditional_additional_effect",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Great_Sword.txt",
        source_text="Additional effect with wind fan equipped: Wind damage",
        note="Requires a paired fan condition outside current equipment scoring.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18369,
        effect_tag="random_attack_pdt_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Great_Sword.txt",
        source_text="Attack+0~8 Physical Damage Taken-0~4",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=19159,
        effect_tag="random_attack_accuracy_str_dex_charm_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Great_Sword.txt",
        source_text="Attack+0~10 Accuracy+0~5 STR+0~5 DEX+0~5 Resist Charm+0~5",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18812,
        effect_tag="conditional_enhancing_magic_duration",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Grip.txt",
        source_text="Latent effect: Enhancing magic duration+5% (when having Ice Spikes active)",
        note="Requires Ice Spikes condition and is not always-on.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=10394,
        effect_tag="synth_material_loss",
        status="scored",
        target="player",
        mod_name="SYNTH_MATERIAL_LOSS",
        value=2,
        source_path="pages/CatsEyeXI_Content_Equipment_Neck.txt",
        source_text="Decreases likelihood of synthesis material loss +2%",
        note="Direct crafting utility mod.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=10394,
        effect_tag="synthesis_skill",
        status="manual_review",
        target="unsupported",
        source_path="pages/CatsEyeXI_Content_Equipment_Neck.txt",
        source_text="Synthesis skill +2",
        note="Generic synthesis skill does not map to a single server craft mod.",
        value=2,
    ),
    CatseyeEquipmentEffectTag(
        item_id=10395,
        effect_tag="synth_material_loss",
        status="scored",
        target="player",
        mod_name="SYNTH_MATERIAL_LOSS",
        value=5,
        source_path="pages/CatsEyeXI_Content_Equipment_Neck.txt",
        source_text="Decreases likelihood of synthesis material loss 5%",
        note="Direct crafting utility mod.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=10395,
        effect_tag="synthesis_skill",
        status="manual_review",
        target="unsupported",
        source_path="pages/CatsEyeXI_Content_Equipment_Neck.txt",
        source_text="Synthesis skill +2",
        note="Generic synthesis skill does not map to a single server craft mod.",
        value=2,
    ),
    CatseyeEquipmentEffectTag(
        item_id=19304,
        effect_tag="random_attack_accuracy_str_charm_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Polearm.txt",
        source_text="Attack+0~10 Accuracy+0~5 STR+0~5 Resist Charm+0~5",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11674,
        effect_tag="occasional_magic_damage_annul",
        status="manual_review",
        target="unsupported",
        source_path="pages/CatsEyeXI_Content_Equipment_Ring.txt",
        source_text="Occasionally annuls magic damage taken",
        note="Proc-based annul effect is not a standard scored stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=11674,
        effect_tag="dark_weather_magic_stats",
        status="manual_review",
        target="conditional",
        source_path="pages/CatsEyeXI_Content_Equipment_Ring.txt",
        source_text='Dark weather: MP+30 Magic Accuracy+5 Dark weather: "Magic Atk. Bonus"+5',
        note="Weather condition is not always-on.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=18603,
        effect_tag="random_magic_accuracy_attack_mp_int_conserve_mp_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Staff.txt",
        source_text="Magic Accuracy+0~12 Magic Attack Bonus+0~5 MP+1~5 INT+0~5 Conserve MP+0~5",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=17765,
        effect_tag="random_attack_accuracy_blue_magic_str_skillchain_range",
        status="manual_review",
        target="random_range",
        source_path="pages/CatsEyeXI_Content_Equipment_Sword.txt",
        source_text="Attack+0~5 Accuracy+0~5 Blue Magic Skill+0~5 STR+0~5 Skillchain Damage+0~5%",
        note="Random range is not a deterministic passive stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12560,
        effect_tag="novice_trial_path_def_hp_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Scale Mail (Novice Trial Path): DEF+3 HP+10",
        note="Catseye augment path on the base Scale Mail item; not an always-on base item stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12560,
        effect_tag="ventures_path_random_hp_mp_str_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Scale Mail (Ventures Path): HP+0~9 MP+0~9 STR+0~2",
        note="Catseye random augment path on the base Scale Mail item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12661,
        effect_tag="novice_trial_path_def_hp_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Solid Mail (Novice Trial Path): DEF+3 HP+10",
        note="Catseye augment path on the base Solid Mail item; not an always-on base item stat.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12661,
        effect_tag="ventures_path_random_hp_mp_str_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Solid Mail (Ventures Path): HP+0~9 MP+0~9 STR+0~2",
        note="Catseye random augment path on the base Solid Mail item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=13570,
        effect_tag="ventures_path_random_hp_enmity_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Ram Mantle (EXP Ventures Rewards): HP+0~25 Enmity+0~2",
        note="Catseye random augment path on the base Ram Mantle item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=13575,
        effect_tag="populox_path_random_hp_enmity_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Ram Mantle +1 (Populox Path): HP+0~25 Enmity+0~2",
        note="Catseye transferred random augment path on the Ram Mantle +1 item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=13575,
        effect_tag="ametrine_path_dex_agi_hpheal_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Back.txt",
        source_text="Ram Mantle +1 (Ametrine Path): DEX+2 AGI+2 HP recovered while healing+2",
        note="Catseye transferred fixed augment path on the Ram Mantle +1 item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12562,
        effect_tag="byakko_path_random_dual_wield_critical_attack_accuracy_evasion_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Kirin's Osode (Byakko Path): Dual Wield +0~3 Critical Hit Rate +0~3% Attack +0~5 Accuracy +0~5 Evasion +0~5",
        note="Catseye random augment path on the base Kirin's Osode item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12562,
        effect_tag="genbu_path_random_regen_pdt_attack_accuracy_evasion_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Kirin's Osode (Genbu Path): Regen +0~3 Physical Damage Taken -0~5% Attack +0~5 Accuracy +0~5 Evasion +0~5",
        note="Catseye random augment path on the base Kirin's Osode item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12562,
        effect_tag="seiryu_path_random_snapshot_ranged_attack_evasion_accuracy_attack_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Kirin's Osode (Seiryu Path): Snapshot +0~3 Ranged Attack +0~5 Evasion +0~5 Accuracy +0~5 Attack +0~5",
        note="Catseye random augment path on the base Kirin's Osode item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=12562,
        effect_tag="suzaku_path_random_double_attack_critical_damage_attack_accuracy_evasion_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Body.txt",
        source_text="Kirin's Osode (Suzaku Path): Double Attack +0~3 Critical Hit Damage +0~3% Attack +0~5 Accuracy +0~5 Evasion +0~5",
        note="Catseye random augment path on the base Kirin's Osode item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=17567,
        effect_tag="byakko_path_random_summoning_attack_accuracy_dex_hp_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Staff.txt",
        source_text="Kirin's Pole (Byakko Path): Summoning Magic Skill +0~5 Attack +0~5 Accuracy +0~5 DEX +0~5 HP +0~18",
        note="Catseye random augment path on the base Kirin's Pole item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=17567,
        effect_tag="genbu_path_random_enhancing_attack_accuracy_vit_hp_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Staff.txt",
        source_text="Kirin's Pole (Genbu Path): Enhancing Magic Skill +0~5 Attack +0~5 Accuracy +0~5 VIT +0~5 HP +0~18",
        note="Catseye random augment path on the base Kirin's Pole item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=17567,
        effect_tag="seiryu_path_random_enfeebling_attack_accuracy_agi_mp_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Staff.txt",
        source_text="Kirin's Pole (Seiryu Path): Enfeebling Magic Skill +0~5 Attack +0~5 Accuracy +0~5 AGI +0~5 MP +0~18",
        note="Catseye random augment path on the base Kirin's Pole item.",
    ),
    CatseyeEquipmentEffectTag(
        item_id=17567,
        effect_tag="suzaku_path_random_elemental_attack_accuracy_str_mp_augments",
        status="manual_review",
        target="augment_path",
        source_path="pages/CatsEyeXI_Content_Equipment_Staff.txt",
        source_text="Kirin's Pole (Suzaku Path): Elemental Magic Skill +0~5 Attack +0~5 Accuracy +0~5 STR +0~5 MP +0~18",
        note="Catseye random augment path on the base Kirin's Pole item.",
    ),
)

CATSEYE_MANUAL_MOD_IDS = {
    "ATT": 23,
    "ACC": 25,
    "DEF": 1,
    "HP": 2,
    "MP": 5,
    "STORETP": 73,
    "DMGPHYS": 161,
    "EMPTY_KILLER": 235,
    "SYNTH_MATERIAL_LOSS": 861,
}


def build_stats_db(
    *,
    sql_root: Path | str,
    scripts_items_root: Path | str,
    output_path: Path | str,
    catseye_wiki_root: Path | str | None = None,
    client_items_path: Path | str | None = None,
) -> StatsDbBuildResult:
    sql_path = Path(sql_root)
    scripts_path = Path(scripts_items_root)
    destination = Path(output_path)

    if not sql_path.exists():
        raise FileNotFoundError(f"Server SQL root not found: {sql_path}")
    if not scripts_path.exists():
        raise FileNotFoundError(f"Server item scripts root not found: {scripts_path}")
    for filename in REQUIRED_SQL_FILES:
        path = sql_path / filename
        if not path.exists():
            raise FileNotFoundError(f"Required server SQL source not found: {path}")

    destination.parent.mkdir(parents=True, exist_ok=True)
    temp_path = destination.with_suffix(".tmp.sqlite")
    if temp_path.exists():
        temp_path.unlink()

    mod_names = _load_mod_names(sql_path.parent / "scripts" / "enum" / "mod.lua")

    db = sqlite3.connect(temp_path)
    try:
        db.execute("pragma journal_mode = off")
        db.execute("pragma synchronous = off")
        _create_schema(db)

        item_name_by_id = _insert_item_basic(db, sql_path / "item_basic.sql")
        _insert_item_equipment(db, sql_path / "item_equipment.sql")
        _insert_item_weapon(db, sql_path / "item_weapon.sql")
        client_item_import = _apply_client_item_resources(db, client_items_path)
        catseye_equipment_override_count = _apply_catseye_equipment_overrides(db, catseye_wiki_root)
        item_mod_count = (
            _insert_item_mods(db, sql_path / "item_mods.sql", mod_names)
            if (sql_path / "item_mods.sql").exists()
            else 0
        )
        catseye_equipment_stat_override_count = _apply_catseye_equipment_stat_overrides(
            db,
            catseye_wiki_root,
            mod_names,
        )
        item_latent_count = (
            _insert_item_latents(db, sql_path / "item_latents.sql", mod_names)
            if (sql_path / "item_latents.sql").exists()
            else 0
        )
        if (sql_path / "augments.sql").exists():
            _insert_augments(db, sql_path / "augments.sql", mod_names)
        if (sql_path / "merits.sql").exists():
            _insert_merits(db, sql_path / "merits.sql")
        if (sql_path / "traits.sql").exists():
            _insert_traits(db, sql_path / "traits.sql", mod_names)
        skill_cap_count = (
            _insert_skill_caps(db, sql_path / "skill_caps.sql")
            if (sql_path / "skill_caps.sql").exists()
            else 0
        )
        skill_rank_count = (
            _insert_skill_ranks(db, sql_path / "skill_ranks.sql")
            if (sql_path / "skill_ranks.sql").exists()
            else 0
        )
        if (sql_path / "weapon_skills.sql").exists():
            _insert_weapon_skills(db, sql_path / "weapon_skills.sql")
        if (sql_path / "item_usable.sql").exists():
            _insert_item_usable(db, sql_path / "item_usable.sql")
        ability_count = (
            _insert_abilities(db, sql_path / "abilities.sql")
            if (sql_path / "abilities.sql").exists()
            else 0
        )
        spell_count = (
            _insert_spells(db, sql_path / "spell_list.sql")
            if (sql_path / "spell_list.sql").exists()
            else 0
        )
        status_effect_count = (
            _insert_status_effects(db, sql_path / "status_effects.sql")
            if (sql_path / "status_effects.sql").exists()
            else 0
        )
        pet_item_mod_count = (
            _insert_item_mods_pet(db, sql_path / "item_mods_pet.sql", mod_names)
            if (sql_path / "item_mods_pet.sql").exists()
            else 0
        )
        catseye_equipment_effect_tag_count = _apply_catseye_manual_equipment_effects(
            db,
            catseye_wiki_root,
            mod_names,
        )
        catseye_equipment_stat_override_count = int(
            db.execute("select count(*) from catseye_equipment_stat_overrides").fetchone()[0]
        )
        mob_resistance_count, mob_pool_count, mob_group_count = _insert_mob_sources(db, sql_path)
        food_count, food_mod_count = _insert_food_effects(db, scripts_path, item_name_by_id, mod_names)

        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("schema_version", "8"),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("item_latent_count", str(item_latent_count)),
        )
        db.executemany(
            "insert into metadata(key, value) values (?, ?)",
            (
                ("skill_cap_count", str(skill_cap_count)),
                ("skill_rank_count", str(skill_rank_count)),
            ),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("source_sql_root", str(sql_path)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("source_scripts_items_root", str(scripts_path)),
        )
        if catseye_wiki_root is not None:
            db.execute(
                "insert into metadata(key, value) values (?, ?)",
                ("source_catseye_wiki_root", str(Path(catseye_wiki_root))),
            )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("catseye_equipment_override_count", str(catseye_equipment_override_count)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("catseye_equipment_stat_override_count", str(catseye_equipment_stat_override_count)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("catseye_equipment_effect_tag_count", str(catseye_equipment_effect_tag_count)),
        )
        if client_item_import.source_path is not None:
            db.executemany(
                "insert into metadata(key, value) values (?, ?)",
                (
                    ("source_client_items_path", str(client_item_import.source_path)),
                    ("client_item_count", str(client_item_import.item_count)),
                    ("client_equipment_update_count", str(client_item_import.equipment_update_count)),
                    ("client_weapon_update_count", str(client_item_import.weapon_update_count)),
                ),
            )
        db.executemany(
            "insert into metadata(key, value) values (?, ?)",
            metadata_entries_for_provenance(_detect_catseye_provenance(sql_path)),
        )
        db.commit()
    finally:
        db.close()

    destination.unlink(missing_ok=True)
    temp_path.replace(destination)

    return StatsDbBuildResult(
        path=destination,
        item_count=len(item_name_by_id),
        item_mod_count=item_mod_count,
        food_count=food_count,
        food_mod_count=food_mod_count,
        mob_resistance_count=mob_resistance_count,
        mob_pool_count=mob_pool_count,
        mob_group_count=mob_group_count,
        ability_count=ability_count,
        spell_count=spell_count,
        status_effect_count=status_effect_count,
        pet_item_mod_count=pet_item_mod_count,
        item_latent_count=item_latent_count,
        catseye_equipment_override_count=catseye_equipment_override_count,
        catseye_equipment_stat_override_count=catseye_equipment_stat_override_count,
        catseye_equipment_effect_tag_count=catseye_equipment_effect_tag_count,
        client_item_count=client_item_import.item_count,
        client_equipment_update_count=client_item_import.equipment_update_count,
        client_weapon_update_count=client_item_import.weapon_update_count,
        skill_cap_count=skill_cap_count,
        skill_rank_count=skill_rank_count,
    )


def _detect_catseye_provenance(sql_path: Path) -> CatseyeProvenance:
    git = None
    try:
        git = inspect_git_checkout(sql_path.parent, remote_name="catseye")
    except (RuntimeError, FileNotFoundError, OSError):
        git = None

    launcher = None
    launcher_root = Path(r"C:\Games\CatsEyeXI")
    if launcher_root.exists():
        launcher = inspect_launcher(launcher_root)

    return CatseyeProvenance(
        git=git,
        launcher=launcher,
        verified=False,
        verification_note="fast local inspection; Catseye production source ref not verified",
    )


def _create_schema(db: sqlite3.Connection) -> None:
    db.executescript(
        """
        create table items (
            item_id integer primary key,
            sub_id integer not null,
            name text not null,
            sort_name text not null,
            item_type text not null,
            stack_size integer not null,
            flags text not null,
            auction_house text not null,
            base_sell integer not null
        );

        create table item_name_aliases (
            item_id integer not null,
            name text not null,
            source text not null,
            primary key(item_id, name, source)
        );
        create index item_name_aliases_item_id_idx on item_name_aliases(item_id);

        create table item_equipment (
            item_id integer primary key,
            name text not null,
            level integer not null,
            ilevel integer not null,
            jobs integer not null,
            model_id integer not null,
            shield_size integer not null,
            script_type integer not null,
            slot integer not null,
            rslot integer not null,
            rslot_look integer not null,
            su_level integer not null
        );

        create table catseye_equipment_overrides (
            item_id integer primary key,
            server_name text not null,
            catseye_name text not null,
            original_level integer not null,
            catseye_level integer not null,
            original_ilevel integer not null,
            catseye_ilevel integer not null,
            original_jobs integer not null,
            catseye_jobs integer not null,
            original_slot integer not null,
            catseye_slot integer not null,
            source_path text not null,
            source_text text not null,
            stats_text text not null
        );

        create table catseye_equipment_stat_overrides (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            original_value integer,
            catseye_value integer not null,
            source_path text not null,
            source_text text not null
        );
        create index catseye_equipment_stat_overrides_item_idx
            on catseye_equipment_stat_overrides(item_id);

        create table catseye_equipment_effect_tags (
            item_id integer not null,
            effect_tag text not null,
            status text not null,
            target text not null,
            source_path text not null,
            source_text text not null,
            note text not null,
            mod_name text,
            value integer
        );
        create index catseye_equipment_effect_tags_item_idx
            on catseye_equipment_effect_tags(item_id);

        create table catseye_client_items (
            item_id integer primary key,
            name text not null,
            level integer not null,
            ilevel integer not null,
            client_jobs integer not null,
            jobs integer not null,
            slot integer not null,
            flags integer not null,
            stack_size integer not null,
            item_type integer not null,
            sub_type integer not null,
            skill integer not null,
            damage integer not null,
            delay integer not null,
            damage_type integer not null,
            shield_size integer not null,
            su_level integer not null,
            valid_targets integer not null,
            source_path text not null
        );

        create table item_weapon (
            item_id integer primary key,
            name text not null,
            skill integer not null,
            subskill integer not null,
            ilvl_skill integer not null,
            ilvl_parry integer not null,
            ilvl_magic_accuracy integer not null,
            damage_type integer not null,
            hit integer not null,
            delay integer not null,
            damage integer not null,
            unlock_points integer not null
        );

        create table item_mods (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null
        );
        create index item_mods_item_id_idx on item_mods(item_id);

        create table item_latents (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            condition_id integer not null,
            condition_value integer not null
        );
        create index item_latents_item_id_idx on item_latents(item_id);
        create index item_latents_condition_idx on item_latents(condition_id, condition_value);

        create table item_conditional_mods (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            condition_type text not null,
            condition_name text not null,
            source_path text not null,
            source_text text not null
        );
        create index item_conditional_mods_item_id_idx on item_conditional_mods(item_id);
        create index item_conditional_mods_condition_idx
            on item_conditional_mods(condition_type, condition_name);

        create table item_mods_pet (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            pet_type integer not null
        );
        create index item_mods_pet_item_id_idx on item_mods_pet(item_id);

        create table abilities (
            ability_id integer primary key,
            name text not null,
            job integer not null,
            level integer not null,
            valid_target integer not null,
            recast_time integer not null,
            recast_id integer not null,
            message1 integer not null,
            message2 integer not null,
            animation integer not null,
            animation_time integer not null,
            cast_time integer not null,
            action_type integer not null,
            range integer not null,
            is_aoe integer not null,
            radius integer not null,
            ce integer not null,
            ve integer not null,
            merit_mod_id integer not null,
            add_type integer not null,
            content_tag text
        );
        create index abilities_job_level_idx on abilities(job, level);
        create index abilities_recast_id_idx on abilities(recast_id);

        create table spells (
            spell_id integer primary key,
            name text not null,
            jobs_hex text not null,
            spell_group integer not null,
            family integer not null,
            element integer not null,
            zone_misc integer not null,
            valid_targets integer not null,
            skill integer not null,
            mp_cost integer not null,
            cast_time integer not null,
            recast_time integer not null,
            message integer not null,
            magic_burst_message integer not null,
            animation integer not null,
            animation_time integer not null,
            aoe integer not null,
            base integer not null,
            multiplier real not null,
            ce integer not null,
            ve integer not null,
            requirements integer not null,
            spell_range integer not null,
            radius integer not null,
            content_tag text
        );
        create index spells_skill_idx on spells(skill);
        create index spells_element_idx on spells(element);

        create table status_effects (
            status_id integer primary key,
            name text not null,
            flags integer not null,
            status_type integer not null,
            negative_id integer not null,
            overwrite integer not null,
            block_id integer not null,
            remove_id integer not null,
            element integer not null,
            min_duration integer not null,
            sort_key integer not null
        );
        create index status_effects_name_idx on status_effects(name);

        create table augments (
            augment_id integer not null,
            multiplier integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            is_pet integer not null,
            pet_type integer not null
        );

        create table merits (
            merit_id integer not null,
            name text not null,
            upgrade integer not null,
            value integer not null,
            jobs integer not null,
            upgrade_id integer not null,
            category_id integer not null
        );

        create table traits (
            trait_id integer not null,
            name text not null,
            job integer not null,
            level integer not null,
            rank integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            content_tag text,
            merit_id integer not null
        );

        create table weapon_skills (
            weapon_skill_id integer not null,
            name text not null,
            jobs_hex text not null,
            weapon_type integer not null,
            skill_level integer not null,
            element integer not null,
            animation integer not null,
            animation_time integer not null,
            range integer not null,
            aoe integer not null,
            radius integer not null,
            primary_sc integer not null,
            secondary_sc integer not null,
            tertiary_sc integer not null,
            main_only integer not null,
            unlock_id integer not null
        );

        create table skill_caps (
            level integer not null,
            rank integer not null,
            cap integer not null,
            primary key (level, rank)
        );

        create table skill_ranks (
            skill_id integer not null,
            skill_name text not null,
            job text not null,
            rank integer not null,
            primary key (skill_id, job)
        );

        create table item_usable (
            item_id integer primary key,
            name text not null,
            valid_targets integer not null,
            activation integer not null,
            animation integer not null,
            animation_time integer not null,
            max_charges integer not null,
            use_delay integer not null,
            reuse_delay integer not null,
            aoe integer not null
        );

        create table food_effects (
            item_id integer primary key,
            name text not null,
            food_type text not null,
            duration_seconds integer not null,
            script_path text not null
        );

        create table food_effect_mods (
            item_id integer not null,
            target_type text not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null
        );
        create index food_effect_mods_item_id_idx on food_effect_mods(item_id);

        create table mob_resistances (
            resist_id integer primary key,
            name text not null,
            slash_sdt integer not null,
            pierce_sdt integer not null,
            h2h_sdt integer not null,
            impact_sdt integer not null,
            magical_sdt integer not null,
            fire_sdt integer not null,
            ice_sdt integer not null,
            wind_sdt integer not null,
            earth_sdt integer not null,
            lightning_sdt integer not null,
            water_sdt integer not null,
            light_sdt integer not null,
            dark_sdt integer not null,
            fire_res_rank integer not null,
            ice_res_rank integer not null,
            wind_res_rank integer not null,
            earth_res_rank integer not null,
            lightning_res_rank integer not null,
            water_res_rank integer not null,
            light_res_rank integer not null,
            dark_res_rank integer not null,
            paralyze_res_rank integer not null,
            bind_res_rank integer not null,
            silence_res_rank integer not null,
            slow_res_rank integer not null,
            poison_res_rank integer not null,
            light_sleep_res_rank integer not null,
            dark_sleep_res_rank integer not null,
            blind_res_rank integer not null
        );

        create table mob_pools (
            poolid integer primary key,
            name text not null,
            packet_name text not null,
            speciesid integer not null,
            mjob integer not null,
            sjob integer not null,
            cmb_skill integer not null,
            cmb_delay integer not null,
            cmb_dmg_mult integer not null,
            aggro integer not null,
            links integer not null,
            mob_type integer not null,
            immunity integer not null,
            spell_list integer not null,
            skill_list_id integer not null,
            resist_id integer not null
        );
        create index mob_pools_name_idx on mob_pools(name);
        create index mob_pools_resist_id_idx on mob_pools(resist_id);

        create table mob_family_system (
            speciesID integer primary key,
            family text not null,
            superFamilyID integer not null,
            superFamily text not null,
            ecosystemID integer not null,
            ecosystem text not null,
            HP integer not null,
            MP integer not null,
            STR integer not null,
            DEX integer not null,
            VIT integer not null,
            AGI integer not null,
            INT integer not null,
            MND integer not null,
            CHR integer not null,
            ATT integer not null,
            DEF integer not null,
            ACC integer not null,
            EVA integer not null,
            Element real not null,
            detects integer not null,
            charmable integer not null
        );

        create table mob_groups (
            groupid integer not null,
            poolid integer not null,
            zoneid integer not null,
            name text not null,
            respawntime integer not null,
            spawntype integer not null,
            dropid integer not null,
            HP integer not null,
            MP integer not null,
            allegiance integer not null,
            content_tag text
        );
        create index mob_groups_poolid_idx on mob_groups(poolid);
        create index mob_groups_name_idx on mob_groups(name);

        create table metadata (
            key text primary key,
            value text not null
        );
        """
    )


def _insert_item_basic(db: sqlite3.Connection, path: Path) -> dict[int, str]:
    rows = _read_insert_rows(path, "item_basic")
    mapped: list[tuple[object, ...]] = []
    alias_rows: list[tuple[int, str, str]] = []
    item_name_by_id: dict[int, str] = {}
    for row in rows:
        _expect_minimum(path, "item_basic", row, 9)
        item_type_index = _item_basic_item_type_index(row)
        _expect_minimum(path, "item_basic", row, item_type_index + 5)
        item_id = _as_int(row[0])
        name = _as_text(row[2])
        sort_name = _as_text(row[3])
        item_name_by_id[item_id] = name
        alias_rows.append((item_id, name, "server_item_basic_name"))
        alias_rows.append((item_id, sort_name, "server_item_basic_sort_name"))
        mapped.append(
            (
                item_id,
                _as_int(row[1]),
                name,
                sort_name,
                _as_text(row[item_type_index]),
                _as_int(row[item_type_index + 1]),
                _as_text(row[item_type_index + 2]),
                _as_text(row[item_type_index + 3]),
                _as_int(row[item_type_index + 4]),
            )
        )
    db.executemany(
        """
        insert into items(
            item_id, sub_id, name, sort_name, item_type, stack_size, flags, auction_house, base_sell
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    _insert_item_name_aliases(db, alias_rows)
    return item_name_by_id


def _item_basic_item_type_index(row: tuple[object | None, ...]) -> int:
    return 4 if _looks_like_item_basic_type(row[4]) else 5


def _looks_like_item_basic_type(value: object | None) -> bool:
    text = _as_text(value)
    return text.endswith("_TYPE") or text in {"Armor", "Weapon", "Item"}


def _insert_item_equipment(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "item_equipment")
    mapped: list[tuple[object, ...]] = []
    alias_rows: list[tuple[int, str, str]] = []
    for row in rows:
        _expect_minimum(path, "item_equipment", row, 12)
        item_id = _as_int(row[0])
        name = _as_text(row[1])
        alias_rows.append((item_id, name, "server_item_equipment_name"))
        mapped.append(
            (
                item_id,
                name,
                _as_int(row[2]),
                _as_int(row[3]),
                _as_int(row[4]),
                _as_int(row[5]),
                _as_int(row[6]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                _as_int(row[10]),
                _as_int(row[11]),
            )
        )
    db.executemany(
        """
        insert into item_equipment(
            item_id, name, level, ilevel, jobs, model_id, shield_size, script_type,
            slot, rslot, rslot_look, su_level
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    _insert_item_name_aliases(db, alias_rows)


def _insert_item_name_aliases(
    db: sqlite3.Connection,
    rows: Iterable[tuple[int, str, str]],
) -> None:
    alias_rows = [(item_id, name, source) for item_id, name, source in rows if name]
    if not alias_rows:
        return

    db.executemany(
        """
        insert or ignore into item_name_aliases(item_id, name, source)
        values (?, ?, ?)
        """,
        alias_rows,
    )


def _apply_catseye_equipment_overrides(
    db: sqlite3.Connection,
    catseye_wiki_root: Path | str | None,
) -> int:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        return 0

    equipment_records = tuple(_iter_catseye_equipment_records(pages_root))
    if not equipment_records:
        return 0

    item_ids_by_name = _build_equipment_item_name_index(db)
    records_by_item_id: dict[int, list[CatseyeEquipmentRecord]] = {}
    override_rows: list[tuple[object, ...]] = []
    update_rows: list[tuple[object, ...]] = []

    for record in equipment_records:
        if record.level > 75 or record.jobs_mask <= 0 or record.slot_mask <= 0:
            continue

        item_id = _match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None:
            continue
        records_by_item_id.setdefault(item_id, []).append(record)

    for item_id, records in sorted(records_by_item_id.items()):
        existing = db.execute(
            """
            select name, level, ilevel, jobs, slot
            from item_equipment
            where item_id = ?
            """,
            (item_id,),
        ).fetchone()
        if existing is None:
            continue

        server_name, original_level, original_ilevel, original_jobs, original_slot = existing
        record = _select_catseye_equipment_record(records, existing)
        catseye_slot = _catseye_equipment_slot_for_update(record, int(original_slot))
        if (
            int(original_level),
            int(original_ilevel),
            int(original_jobs),
            int(original_slot),
        ) == (
            record.level,
            0,
            record.jobs_mask,
            catseye_slot,
        ):
            continue

        override_rows.append(
            (
                item_id,
                str(server_name),
                record.name,
                int(original_level),
                record.level,
                int(original_ilevel),
                0,
                int(original_jobs),
                record.jobs_mask,
                int(original_slot),
                catseye_slot,
                record.source_path,
                record.source_text,
                record.stats_text,
            )
        )
        update_rows.append((record.level, 0, record.jobs_mask, catseye_slot, item_id))

    if not override_rows:
        return 0

    db.executemany(
        """
        insert into catseye_equipment_overrides(
            item_id, server_name, catseye_name, original_level, catseye_level,
            original_ilevel, catseye_ilevel, original_jobs, catseye_jobs,
            original_slot, catseye_slot, source_path, source_text, stats_text
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        override_rows,
    )
    db.executemany(
        """
        update item_equipment
        set level = ?, ilevel = ?, jobs = ?, slot = ?
        where item_id = ?
        """,
        update_rows,
    )
    return len(override_rows)


def _apply_catseye_equipment_stat_overrides(
    db: sqlite3.Connection,
    catseye_wiki_root: Path | str | None,
    mod_names: dict[int, str],
) -> int:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        return 0

    item_ids_by_name = _build_equipment_item_name_index(db)
    if not item_ids_by_name:
        return 0

    movement_mod_id = _mod_id_by_name(mod_names, "MOVE_SPEED_GEAR_BONUS", fallback=76)
    movement_mod_name = _mod_name(mod_names, movement_mod_id)
    candidates: dict[tuple[int, int], CatseyeEquipmentStatOverride] = {}
    wiki_direct_mods_by_item_id: dict[int, set[str]] = {}
    override_rows: list[tuple[object, ...]] = []
    conditional_rows_by_key: dict[tuple[object, ...], tuple[object, ...]] = {}
    for path in sorted(pages_root.glob("*.txt")):
        for candidate in _iter_catseye_movement_speed_overrides(
            path,
            pages_root,
            item_ids_by_name,
            movement_mod_id,
            movement_mod_name,
        ):
            key = (candidate.item_id, candidate.mod_id)
            existing = candidates.get(key)
            if existing is None or _prefer_catseye_stat_value(candidate.value, existing.value):
                candidates[key] = candidate

    records_by_item_id: dict[int, list[CatseyeEquipmentRecord]] = {}
    for record in _iter_catseye_equipment_records(pages_root):
        item_id = _match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None:
            continue
        records_by_item_id.setdefault(item_id, []).append(record)

    for item_id, records in sorted(records_by_item_id.items()):
        existing = db.execute(
            """
            select name, level, ilevel, jobs, slot
            from item_equipment
            where item_id = ?
            """,
            (item_id,),
        ).fetchone()
        if existing is None:
            continue
        record = _select_catseye_equipment_record(records, existing)
        override_rows.extend(_apply_catseye_weapon_stat_overrides(db, record, item_id))
        for candidate in _iter_catseye_direct_stat_overrides(record, item_id, mod_names):
            key = (candidate.item_id, candidate.mod_id)
            existing_candidate = candidates.get(key)
            if existing_candidate is None or _prefer_catseye_stat_value(candidate.value, existing_candidate.value):
                candidates[key] = candidate
        wiki_mods = parse_wiki_stat_mods(record.stats_text)
        wiki_direct_mods_by_item_id[item_id] = set(wiki_mods)
        for row in _catseye_conditional_mod_rows(record, item_id, mod_names):
            key = row[:6]
            conditional_rows_by_key[key] = row
        for mod_name, value in wiki_mods.items():
            mod_id = _mod_id_by_name(mod_names, mod_name, fallback=STAT_MOD_IDS.get(mod_name, 0))
            if mod_id == 0:
                continue
            candidate = CatseyeEquipmentStatOverride(
                item_id=item_id,
                mod_id=mod_id,
                mod_name=_catseye_resolved_stat_mod_name(mod_names, mod_name, mod_id),
                value=value,
                source_path=record.source_path,
                source_text=" ".join((record.name, record.stats_text)).strip(),
            )
            key = (candidate.item_id, candidate.mod_id)
            existing = candidates.get(key)
            if existing is None or candidate.value > existing.value:
                candidates[key] = candidate

    _remove_stale_catseye_direct_mods(db, wiki_direct_mods_by_item_id)

    for candidate in sorted(candidates.values(), key=lambda value: (value.item_id, value.mod_id)):
        existing_values = [
            int(row[0])
            for row in db.execute(
                "select value from item_mods where item_id = ? and mod_id = ?",
                (candidate.item_id, candidate.mod_id),
            )
        ]
        original_value = sum(existing_values) if existing_values else None
        if original_value == candidate.value:
            continue
        if (
            original_value is not None
            and candidate.mod_name in CATSEYE_SERVER_AUTHORITY_MODS
            and not _prefer_catseye_stat_value(candidate.value, original_value)
        ):
            continue

        db.execute(
            "delete from item_mods where item_id = ? and mod_id = ?",
            (candidate.item_id, candidate.mod_id),
        )
        db.execute(
            "insert into item_mods(item_id, mod_id, mod_name, value) values (?, ?, ?, ?)",
            (candidate.item_id, candidate.mod_id, candidate.mod_name, candidate.value),
        )
        override_rows.append(
            (
                candidate.item_id,
                candidate.mod_id,
                candidate.mod_name,
                original_value,
                candidate.value,
                candidate.source_path,
                candidate.source_text,
            )
        )

    conditional_rows = [
        row
        for _key, row in sorted(
            conditional_rows_by_key.items(),
            key=lambda value: (
                int(value[1][0]),
                str(value[1][4]),
                str(value[1][5]),
                int(value[1][1]),
            ),
        )
    ]
    if conditional_rows:
        db.executemany(
            """
            insert into item_conditional_mods(
                item_id, mod_id, mod_name, value, condition_type, condition_name,
                source_path, source_text
            ) values (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            conditional_rows,
        )

    if not override_rows:
        return len(conditional_rows)

    db.executemany(
        """
        insert into catseye_equipment_stat_overrides(
            item_id, mod_id, mod_name, original_value, catseye_value,
            source_path, source_text
        ) values (?, ?, ?, ?, ?, ?, ?)
        """,
        override_rows,
    )
    return len(override_rows) + len(conditional_rows)


def _select_catseye_equipment_record(
    records: list[CatseyeEquipmentRecord],
    existing: tuple[object, ...],
) -> CatseyeEquipmentRecord:
    _server_name, original_level, _original_ilevel, original_jobs, original_slot = existing

    def score(record: CatseyeEquipmentRecord) -> tuple[int, int, int, int]:
        return (
            _catseye_record_name_slot_score(record),
            1 if record.slot_mask == int(original_slot) else 0,
            1 if record.level == int(original_level) else 0,
            1 if record.jobs_mask == int(original_jobs) else 0,
        )

    return max(records, key=score)


def _catseye_record_name_slot_score(record: CatseyeEquipmentRecord) -> int:
    implied_slot = _catseye_name_implied_armor_slot_mask(record.name)
    if implied_slot == 0:
        return 1
    return 1 if record.slot_mask & implied_slot else 0


def _catseye_equipment_slot_for_update(
    record: CatseyeEquipmentRecord,
    original_slot: int,
) -> int:
    implied_slot = _catseye_name_implied_armor_slot_mask(record.name)
    if implied_slot != 0 and original_slot & implied_slot and not record.slot_mask & implied_slot:
        return original_slot
    return record.slot_mask


def _catseye_name_implied_armor_slot_mask(name: str) -> int:
    name_tokens = set(re.findall(r"[a-z0-9]+", name.lower()))
    slot_masks = {
        EQUIPMENT_SLOT_MASKS[slot]
        for slot, tokens in CATSEYE_ARMOR_SLOT_NAME_TOKENS.items()
        if any(token in name_tokens for token in tokens)
    }
    if len(slot_masks) != 1:
        return 0
    return next(iter(slot_masks))


def _apply_catseye_weapon_stat_overrides(
    db: sqlite3.Connection,
    record: CatseyeEquipmentRecord,
    item_id: int,
) -> list[tuple[object, ...]]:
    expected = parse_wiki_weapon_stats(record.stats_text)
    if not expected:
        return []

    existing = db.execute(
        "select damage, delay from item_weapon where item_id = ?",
        (item_id,),
    ).fetchone()
    if existing is None:
        return []

    current = {"damage": int(existing[0]), "delay": int(existing[1])}
    override_rows: list[tuple[object, ...]] = []
    updates: dict[str, int] = {}
    for field, value in expected.items():
        if current[field] == value:
            continue
        updates[field] = value
        override_rows.append(
            (
                item_id,
                -1 if field == "damage" else -2,
                "WEAPON_DAMAGE" if field == "damage" else "WEAPON_DELAY",
                current[field],
                value,
                record.source_path,
                " ".join((record.name, record.stats_text)).strip(),
            )
        )

    if updates:
        db.execute(
            """
            update item_weapon
            set damage = ?, delay = ?
            where item_id = ?
            """,
            (
                updates.get("damage", current["damage"]),
                updates.get("delay", current["delay"]),
                item_id,
            ),
        )
    return override_rows


def _catseye_conditional_mod_rows(
    record: CatseyeEquipmentRecord,
    item_id: int,
    mod_names: dict[int, str],
) -> Iterable[tuple[object, ...]]:
    source_text = " ".join((record.name, record.stats_text)).strip()
    for conditional_mod in parse_wiki_conditional_stat_mods(record.stats_text):
        mod_id = _mod_id_by_name(
            mod_names,
            conditional_mod.mod_name,
            fallback=STAT_MOD_IDS.get(conditional_mod.mod_name, 0),
        )
        if mod_id == 0:
            continue
        yield (
            item_id,
            mod_id,
            _mod_name(mod_names, mod_id),
            conditional_mod.value,
            conditional_mod.condition_type,
            conditional_mod.condition_name,
            record.source_path,
            source_text,
        )


def _remove_stale_catseye_direct_mods(
    db: sqlite3.Connection,
    wiki_direct_mods_by_item_id: dict[int, set[str]],
) -> None:
    if not wiki_direct_mods_by_item_id:
        return

    comparable_mods = set(DIRECT_STAT_MODS)
    for item_id, wiki_mod_names in wiki_direct_mods_by_item_id.items():
        existing_mods = {
            str(row[0])
            for row in db.execute(
                "select distinct mod_name from item_mods where item_id = ?",
                (item_id,),
            )
        }
        stale_mods = sorted((existing_mods & comparable_mods) - wiki_mod_names)
        for mod_name in stale_mods:
            db.execute(
                "delete from item_mods where item_id = ? and mod_name = ?",
                (item_id, mod_name),
            )


def _iter_catseye_special_effect_stat_overrides(
    record: CatseyeEquipmentRecord,
    item_id: int,
    mod_names: dict[int, str],
) -> Iterable[CatseyeEquipmentStatOverride]:
    source_text = " ".join((record.name, record.stats_text)).strip()

    accuracy_match = CATSEYE_PHYSICAL_ACCURACY_RE.search(record.stats_text)
    if item_id in CATSEYE_DIRECT_ACCURACY_OVERRIDE_ITEM_IDS and accuracy_match is not None:
        yield _catseye_stat_override(
            item_id,
            "ACC",
            int(accuracy_match.group(1)),
            record,
            source_text,
            mod_names,
            fallback=25,
        )

    affinity_match = CATSEYE_ALL_ELEMENTS_AFFINITY_RE.search(record.stats_text)
    if affinity_match is not None:
        value = int(affinity_match.group(1))
        for mod_name, fallback in ELEMENTAL_STAFF_BONUS_MODS:
            yield _catseye_stat_override(
                item_id,
                mod_name,
                value,
                record,
                source_text,
                mod_names,
                fallback=fallback,
            )

    double_attack_damage_match = CATSEYE_DOUBLE_ATTACK_DAMAGE_RE.search(record.stats_text)
    if double_attack_damage_match is not None:
        value = (
            int(double_attack_damage_match.group(1))
            if double_attack_damage_match.group(1)
            else CATSEYE_UNQUANTIFIED_DOUBLE_ATTACK_DMG_VALUE
        )
        yield _catseye_stat_override(
            item_id,
            "DOUBLE_ATTACK_DMG",
            value,
            record,
            source_text,
            mod_names,
            fallback=1038,
        )

    if CATSEYE_OCC_ATTACKS_TWICE_RE.search(record.stats_text):
        yield _catseye_stat_override(
            item_id,
            "MYTHIC_OCC_ATT_TWICE",
            CATSEYE_UNQUANTIFIED_OCC_ATTACKS_TWICE_VALUE,
            record,
            source_text,
            mod_names,
            fallback=865,
        )


def _catseye_stat_override(
    item_id: int,
    mod_name: str,
    value: int,
    record: CatseyeEquipmentRecord,
    source_text: str,
    mod_names: dict[int, str],
    *,
    fallback: int,
) -> CatseyeEquipmentStatOverride:
    mod_id = _mod_id_by_name(mod_names, mod_name, fallback=fallback)
    resolved_mod_name = _mod_name(mod_names, mod_id) if mod_id else mod_name
    if fallback and mod_id == fallback and resolved_mod_name == f"MOD_{mod_id}":
        resolved_mod_name = mod_name
    return CatseyeEquipmentStatOverride(
        item_id=item_id,
        mod_id=mod_id,
        mod_name=resolved_mod_name,
        value=value,
        source_path=record.source_path,
        source_text=source_text,
    )


def _prefer_catseye_stat_value(candidate: int, existing: int) -> bool:
    if candidate < 0 and existing <= 0:
        return candidate < existing
    return candidate > existing


def _apply_catseye_manual_equipment_effects(
    db: sqlite3.Connection,
    catseye_wiki_root: Path | str | None,
    mod_names: dict[int, str],
) -> int:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        return 0

    effects_by_key: dict[tuple[int, str, str], CatseyeEquipmentEffectTag] = {
        (effect.item_id, effect.effect_tag, effect.target): effect
        for effect in CATSEYE_MANUAL_EQUIPMENT_EFFECTS
    }
    item_ids_by_name = _build_equipment_item_name_index(db)
    for record in _iter_catseye_equipment_records(pages_root):
        item_id = _match_catseye_equipment_item_id(record, item_ids_by_name, db)
        if item_id is None:
            continue
        for effect in _iter_catseye_utility_effect_tags(record, item_id):
            key = (effect.item_id, effect.effect_tag, effect.target)
            effects_by_key.setdefault(key, effect)
        for effect in _iter_catseye_unsupported_effect_tags(record, item_id):
            key = (effect.item_id, effect.effect_tag, effect.target)
            effects_by_key.setdefault(key, effect)
        for effect in _iter_catseye_slot_side_effect_tags(record, item_id):
            key = (effect.item_id, effect.effect_tag, effect.target)
            effects_by_key.setdefault(key, effect)

    effects = tuple(effects_by_key.values())
    if not effects:
        return 0

    equipment_item_ids = {
        int(row[0])
        for row in db.execute(
            """
            select item_id
            from item_equipment
            where item_id in ({})
            """.format(",".join("?" for _ in effects)),
            tuple(effect.item_id for effect in effects),
        )
    }
    if not equipment_item_ids:
        return 0

    inserted_tag_count = 0
    for effect in effects:
        if effect.item_id not in equipment_item_ids:
            continue

        db.execute(
            """
            delete from catseye_equipment_effect_tags
            where item_id = ? and effect_tag = ? and target = ?
            """,
            (effect.item_id, effect.effect_tag, effect.target),
        )
        db.execute(
            """
            insert into catseye_equipment_effect_tags(
                item_id, effect_tag, status, target, source_path, source_text,
                note, mod_name, value
            ) values (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                effect.item_id,
                effect.effect_tag,
                effect.status,
                effect.target,
                effect.source_path,
                effect.source_text,
                effect.note,
                effect.mod_name,
                effect.value,
            ),
        )
        inserted_tag_count += 1

        if effect.status != "scored" or effect.mod_name is None or effect.value is None:
            continue

        mod_id = _mod_id_by_name(
            mod_names,
            effect.mod_name,
            fallback=CATSEYE_MANUAL_MOD_IDS.get(effect.mod_name, 0),
        )
        if effect.target == "player":
            _replace_catseye_player_item_mod(db, effect, mod_id)
        elif effect.target == "pet":
            _replace_catseye_pet_item_mod(db, effect, mod_id)

    return inserted_tag_count


def _iter_catseye_utility_effect_tags(
    record: CatseyeEquipmentRecord,
    item_id: int,
) -> Iterable[CatseyeEquipmentEffectTag]:
    for effect_tag, pattern, note in (
        (
            "surveyor",
            CATSEYE_SURVEYOR_RE,
            "Catseye HELM utility passive; not a combat scoring mod.",
        ),
        (
            "expert_angler",
            CATSEYE_EXPERT_ANGLER_RE,
            "Catseye fishing utility passive; not a combat scoring mod.",
        ),
        (
            "fatigue_limit",
            CATSEYE_FATIGUE_LIMIT_RE,
            "Catseye fishing fatigue limit utility passive; percentage value.",
        ),
        (
            "golden_arrow_rate",
            CATSEYE_GOLDEN_ARROW_RATE_RE,
            "Catseye fishing golden arrow rate utility passive; percentage value.",
        ),
    ):
        match = pattern.search(record.stats_text)
        if match is None:
            continue
        yield CatseyeEquipmentEffectTag(
            item_id=item_id,
            effect_tag=effect_tag,
            status="manual_review",
            target="utility",
            source_path=record.source_path,
            source_text=match.group(0).strip(),
            note=note,
            value=int(match.group(1)),
        )


def _iter_catseye_unsupported_effect_tags(
    record: CatseyeEquipmentRecord,
    item_id: int,
) -> Iterable[CatseyeEquipmentEffectTag]:
    for match in CATSEYE_MAGIC_POTENCY_RE.finditer(record.stats_text):
        yield CatseyeEquipmentEffectTag(
            item_id=item_id,
            effect_tag="magic_potency",
            status="manual_review",
            target="unsupported",
            source_path=record.source_path,
            source_text=match.group(0).strip(),
            note=(
                "Catseye named effect has no current server item_mod equivalent; "
                "tracked for manual review."
            ),
            value=int(match.group(1)),
        )
    for effect_tag, pattern, note in (
        (
            "magic_skill",
            CATSEYE_GENERIC_MAGIC_SKILL_RE,
            "Generic magic skill spans multiple server skill mods; tracked for manual review.",
        ),
        (
            "synthesis_skill",
            CATSEYE_SYNTHESIS_SKILL_RE,
            "Generic synthesis skill does not map to a single server craft mod.",
        ),
        (
            "fencer_trait_tier",
            CATSEYE_FENCER_RE,
            "Fencer tier maps to multiple trait-derived effects and is not scored directly.",
        ),
    ):
        match = pattern.search(record.stats_text)
        if match is None:
            continue
        yield CatseyeEquipmentEffectTag(
            item_id=item_id,
            effect_tag=effect_tag,
            status="manual_review",
            target="unsupported",
            source_path=record.source_path,
            source_text=match.group(0).strip(),
            note=note,
            value=int(match.group(1)),
        )
    for effect_tag, pattern, target, note in CATSEYE_MANUAL_REVIEW_EFFECT_PATTERNS:
        for match in pattern.finditer(record.stats_text):
            if effect_tag == "latent_condition_marker" and _has_parsed_conditional_stat_for_match(
                record.stats_text,
                match,
            ):
                continue
            yield CatseyeEquipmentEffectTag(
                item_id=item_id,
                effect_tag=effect_tag,
                status="manual_review",
                target=target,
                source_path=record.source_path,
                source_text=match.group(0).strip(),
                note=note,
                value=_catseye_manual_review_effect_value(match),
            )


def _has_parsed_conditional_stat_for_match(text: str, match: re.Match[str]) -> bool:
    line_start = text.rfind("\n", 0, match.start()) + 1
    line_end = text.find("\n", match.end())
    if line_end == -1:
        line_end = len(text)
    marker_text = re.sub(r"\s+", " ", match.group(0).strip("()").lower())
    if not marker_text.startswith("when"):
        return False
    for mod in parse_wiki_conditional_stat_mods(text[line_start:line_end].strip()):
        if _marker_text_matches_conditional_mod(marker_text, mod.condition_type, mod.condition_name):
            return True
    return False


def _marker_text_matches_conditional_mod(marker_text: str, condition_type: str, condition_name: str) -> bool:
    readable_name = condition_name.replace("_", " ")
    if condition_type == "status":
        return readable_name in marker_text
    if condition_type in {"level_lt", "level_gte"}:
        return condition_name in marker_text and ("level" in marker_text or "lv" in marker_text)
    if condition_type in {"mpp_lt", "mp_gt"}:
        return condition_name in marker_text and "mp" in marker_text
    return False


def _iter_catseye_slot_side_effect_tags(
    record: CatseyeEquipmentRecord,
    item_id: int,
) -> Iterable[CatseyeEquipmentEffectTag]:
    for match in CATSEYE_SLOT_SIDE_MAGIC_SKILLS_RE.finditer(record.stats_text):
        side = match.group("side").lower()
        yield CatseyeEquipmentEffectTag(
            item_id=item_id,
            effect_tag=f"{side}_ear_magic_skills",
            status="manual_review",
            target="conditional",
            source_path=record.source_path,
            source_text=match.group(0).strip(),
            note="Slot-side condition is not currently modeled for earring scoring.",
            value=int(match.group("value")),
        )


def _replace_catseye_player_item_mod(
    db: sqlite3.Connection,
    effect: CatseyeEquipmentEffectTag,
    mod_id: int,
) -> None:
    if effect.mod_name is None or effect.value is None:
        return

    existing_values = [
        int(row[0])
        for row in db.execute(
            """
            select value
            from item_mods
            where item_id = ? and (mod_name = ? or mod_id = ?)
            """,
            (effect.item_id, effect.mod_name, mod_id),
        )
    ]
    original_value = max(existing_values) if existing_values else None
    if original_value == effect.value:
        return

    db.execute(
        """
        delete from item_mods
        where item_id = ? and (mod_name = ? or mod_id = ?)
        """,
        (effect.item_id, effect.mod_name, mod_id),
    )
    db.execute(
        "insert into item_mods(item_id, mod_id, mod_name, value) values (?, ?, ?, ?)",
        (effect.item_id, mod_id, effect.mod_name, effect.value),
    )

    db.execute(
        """
        delete from catseye_equipment_stat_overrides
        where item_id = ? and mod_name = ? and source_path = ? and source_text = ?
        """,
        (effect.item_id, effect.mod_name, effect.source_path, effect.source_text),
    )
    db.execute(
        """
        insert into catseye_equipment_stat_overrides(
            item_id, mod_id, mod_name, original_value, catseye_value,
            source_path, source_text
        ) values (?, ?, ?, ?, ?, ?, ?)
        """,
        (
            effect.item_id,
            mod_id,
            effect.mod_name,
            original_value,
            effect.value,
            effect.source_path,
            effect.source_text,
        ),
    )


def _replace_catseye_pet_item_mod(
    db: sqlite3.Connection,
    effect: CatseyeEquipmentEffectTag,
    mod_id: int,
) -> None:
    if effect.mod_name is None or effect.value is None:
        return

    pet_mod_name = _pet_mod_name(effect.mod_name)
    existing_value = db.execute(
        """
        select value
        from item_mods_pet
        where item_id = ? and mod_name = ? and pet_type = 0
        """,
        (effect.item_id, pet_mod_name),
    ).fetchone()
    if existing_value is not None and int(existing_value[0]) == effect.value:
        return

    db.execute(
        """
        delete from item_mods_pet
        where item_id = ? and mod_name = ? and pet_type = 0
        """,
        (effect.item_id, pet_mod_name),
    )
    db.execute(
        """
        insert into item_mods_pet(item_id, mod_id, mod_name, value, pet_type)
        values (?, ?, ?, ?, 0)
        """,
        (effect.item_id, mod_id, pet_mod_name, effect.value),
    )


def _iter_catseye_direct_stat_overrides(
    record: CatseyeEquipmentRecord,
    item_id: int,
    mod_names: dict[int, str],
) -> Iterable[CatseyeEquipmentStatOverride]:
    text = _expand_catseye_compound_stats(comparable_wiki_stats_text(record.stats_text))
    source_text = f"{record.name} {record.stats_text}".strip()

    for match in CATSEYE_DAMAGE_TAKEN_RE.finditer(text):
        if _catseye_match_is_pet_scoped(text, match.start()):
            continue
        raw_label = match.group("label").lower()
        if "magic" in raw_label or "mag." in raw_label:
            mod_name = "DMGMAGIC"
        elif "physical" in raw_label or "phys." in raw_label:
            mod_name = "DMGPHYS"
        else:
            mod_name = "DMG"
        value = _catseye_direct_stat_value(match, default_sign="-")
        if value is None:
            continue
        mod_id = _catseye_stat_mod_id(mod_names, mod_name)
        if mod_id <= 0:
            continue
        yield CatseyeEquipmentStatOverride(
            item_id=item_id,
            mod_id=mod_id,
            mod_name=_catseye_resolved_stat_mod_name(mod_names, mod_name, mod_id),
            value=_scale_catseye_direct_stat(mod_name, value),
            source_path=record.source_path,
            source_text=source_text,
        )

    for match in CATSEYE_DIRECT_STAT_RE.finditer(text):
        if _catseye_match_is_pet_scoped(text, match.start()):
            continue
        sign = match.group("sign")
        if sign is None and match.group("colon") is None:
            continue

        label = " ".join(match.group("label").lower().split())
        if label in {"hp", "mp"} and _catseye_match_is_contextual_hp_mp(text, match.start()):
            continue
        mod_name = CATSEYE_DIRECT_STAT_LABEL_MODS[label]
        if match.group("percent") == "%" and mod_name == "HP":
            mod_name = "HPP"
        elif match.group("percent") == "%" and mod_name == "MP":
            mod_name = "MPP"
        value = _catseye_direct_stat_value(match)
        if value is None:
            continue
        mod_id = _catseye_stat_mod_id(mod_names, mod_name)
        if mod_id <= 0:
            continue
        yield CatseyeEquipmentStatOverride(
            item_id=item_id,
            mod_id=mod_id,
            mod_name=_catseye_resolved_stat_mod_name(mod_names, mod_name, mod_id),
            value=_scale_catseye_direct_stat(mod_name, value),
            source_path=record.source_path,
            source_text=source_text,
        )


def _expand_catseye_compound_stats(text: str) -> str:
    expanded = re.sub(
        r"\bHP/MP\s*(?P<value>[+-]\s*\d+(?:\s*~\s*\d+)?)",
        lambda match: f"HP{match.group('value')} MP{match.group('value')}",
        text,
        flags=re.IGNORECASE,
    )
    expanded = re.sub(
        r"\b(?:Acc|Accuracy)/Atk\s*(?P<value>[+-]\s*\d+(?:\s*~\s*\d+)?)",
        lambda match: f"Accuracy{match.group('value')} Attack{match.group('value')}",
        expanded,
        flags=re.IGNORECASE,
    )
    return expanded


def _catseye_match_is_pet_scoped(text: str, start: int) -> bool:
    pet_prefixes = [match.start() for match in CATSEYE_PET_STAT_PREFIX_RE.finditer(text, 0, start)]
    if not pet_prefixes:
        return False
    last_pet = max(pet_prefixes)
    hard_boundaries = (
        text.rfind(";", 0, start),
        text.rfind(".", 0, start),
        text.rfind(" Latent", 0, start),
        text.rfind(" Hidden", 0, start),
        text.rfind(" Grants", 0, start),
        text.rfind(" Adds", 0, start),
        text.rfind(" Dispense", 0, start),
    )
    return last_pet > max(hard_boundaries)


def _catseye_match_is_contextual_hp_mp(text: str, start: int) -> bool:
    prefix = text[max(0, start - 24):start]
    return CATSEYE_CONTEXTUAL_HP_MP_PREFIX_RE.search(prefix) is not None


def _catseye_direct_stat_value(
    match: re.Match[str],
    *,
    default_sign: str | None = None,
) -> int | None:
    if match.group("range") is not None:
        return None
    sign = match.group("sign") or default_sign
    value_text = match.group("value")
    if value_text is None:
        return None
    value = int(value_text)
    if sign == "-":
        value = -value
    return value


def _catseye_manual_review_effect_value(match: re.Match[str]) -> int | None:
    if not match.groups():
        return None
    value_text = match.group(1)
    if value_text is None:
        return None
    return int(value_text.replace(" ", "").replace("+", "").replace("%", ""))


def _scale_catseye_direct_stat(mod_name: str, value: int) -> int:
    if mod_name in CATSEYE_HUNDREDTH_PERCENT_MODS:
        return value * 100
    return value


def _catseye_stat_mod_id(mod_names: dict[int, str], mod_name: str) -> int:
    return _mod_id_by_name(
        mod_names,
        mod_name,
        fallback=CATSEYE_STAT_MOD_FALLBACK_IDS.get(mod_name, 0),
    )


def _catseye_resolved_stat_mod_name(
    mod_names: dict[int, str],
    mod_name: str,
    mod_id: int,
) -> str:
    resolved_mod_name = _mod_name(mod_names, mod_id)
    fallback = CATSEYE_STAT_MOD_FALLBACK_IDS.get(mod_name, 0)
    if fallback and mod_id == fallback and resolved_mod_name == f"MOD_{mod_id}":
        return mod_name
    return resolved_mod_name


def _iter_catseye_movement_speed_overrides(
    path: Path,
    pages_root: Path,
    item_ids_by_name: dict[str, set[int]],
    mod_id: int,
    mod_name: str,
) -> Iterable[CatseyeEquipmentStatOverride]:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = [line.strip() for line in text.replace("\u00a0", " ").splitlines()]
    lines = [line for line in lines if line]
    try:
        source_path = path.relative_to(pages_root.parent).as_posix()
    except ValueError:
        source_path = path.as_posix()

    for index, line in enumerate(lines):
        item_id = _match_catseye_equipment_name(line, item_ids_by_name)
        if item_id is None:
            continue

        source_lines = _catseye_stat_source_lines(lines, index, item_ids_by_name)
        value = _first_catseye_movement_speed_value(source_lines)
        if value is None:
            continue

        yield CatseyeEquipmentStatOverride(
            item_id=item_id,
            mod_id=mod_id,
            mod_name=mod_name,
            value=value,
            source_path=source_path,
            source_text=" ".join(source_lines),
        )


def _catseye_stat_source_lines(
    lines: list[str],
    item_index: int,
    item_ids_by_name: dict[str, set[int]],
) -> list[str]:
    source_lines = [lines[item_index]]

    for offset, line in enumerate(lines[item_index + 1:item_index + 1 + CATSEYE_STAT_LOOKAHEAD_LINES], start=1):
        if "used in synthesis for" in line.lower():
            break
        if _line_starts_catseye_equipment_record(lines, item_index + offset, item_ids_by_name):
            break

        source_lines.append(line)
        if _first_catseye_movement_speed_value((line,)) is not None:
            break
        if CATSEYE_LEVEL_RE.match(line) is not None:
            break

    return source_lines


def _line_starts_catseye_equipment_record(
    lines: list[str],
    index: int,
    item_ids_by_name: dict[str, set[int]],
) -> bool:
    if index + 1 >= len(lines):
        return False
    if CATSEYE_EQUIPMENT_HEADER_RE.match(lines[index + 1]) is None:
        return False
    return _match_catseye_equipment_name(lines[index], item_ids_by_name) is not None


def _first_catseye_movement_speed_value(lines: Iterable[str]) -> int | None:
    for line in lines:
        if CATSEYE_MOUNT_MOVEMENT_RE.search(line):
            continue
        match = CATSEYE_MOVEMENT_SPEED_RE.search(line)
        if match is not None:
            return int(match.group(1))
    return None


def _resolve_catseye_pages_root(catseye_wiki_root: Path | str | None) -> Path | None:
    if catseye_wiki_root is None:
        return None

    root = Path(catseye_wiki_root)
    candidates = (
        root,
        root / "pages",
        root / "tools-data" / "catseye-wiki-cache" / "pages",
    )
    for candidate in candidates:
        if candidate.exists() and any(candidate.glob("CatsEyeXI_Content_Equipment_*.txt")):
            return candidate
    return None


def _build_equipment_item_name_index(db: sqlite3.Connection) -> dict[str, set[int]]:
    item_ids_by_name: dict[str, set[int]] = {}
    rows = db.execute(
        """
        select e.item_id, i.name, i.sort_name, e.name
        from item_equipment e
        left join items i on i.item_id = e.item_id
        """
    )
    for item_id, item_name, sort_name, equipment_name in rows:
        for value in (item_name, sort_name, equipment_name):
            if value is None:
                continue
            normalized = _normalize_catseye_equipment_name(str(value))
            if normalized:
                item_ids_by_name.setdefault(normalized, set()).add(int(item_id))

    try:
        alias_rows = db.execute(
            """
            select a.item_id, a.name
            from item_name_aliases a
            join item_equipment e on e.item_id = a.item_id
            """
        )
    except sqlite3.OperationalError:
        alias_rows = ()

    for item_id, name in alias_rows:
        normalized = _normalize_catseye_equipment_name(str(name))
        if normalized:
            item_ids_by_name.setdefault(normalized, set()).add(int(item_id))

    return item_ids_by_name


def _match_catseye_equipment_item_id(
    record: CatseyeEquipmentRecord,
    item_ids_by_name: dict[str, set[int]],
    db: sqlite3.Connection | None = None,
) -> int | None:
    item_id = _match_catseye_equipment_name(record.name, item_ids_by_name)
    if item_id is not None or db is None:
        return item_id

    normalized_name = _normalize_catseye_equipment_name(record.name)
    candidates = item_ids_by_name.get(normalized_name)
    if candidates is None or len(candidates) <= 1:
        return None
    return _select_catseye_item_id_candidate(db, record, candidates)


def _select_catseye_item_id_candidate(
    db: sqlite3.Connection,
    record: CatseyeEquipmentRecord,
    candidates: set[int],
) -> int | None:
    placeholders = ",".join("?" for _ in candidates)
    rows = list(
        db.execute(
            f"""
            select e.item_id, e.level, e.jobs, e.slot, e.script_type, w.damage, w.delay
            from item_equipment e
            left join item_weapon w on w.item_id = e.item_id
            where e.item_id in ({placeholders})
            """,
            tuple(sorted(candidates)),
        )
    )
    if not rows:
        return None

    weapon_stats = parse_wiki_weapon_stats(record.stats_text)

    def score(row: tuple[object, ...]) -> tuple[int, int, int, int, int, int]:
        _item_id, level, jobs, slot, script_type, damage, delay = row
        return (
            1 if int(slot) == record.slot_mask else 0,
            1 if int(level) == record.level else 0,
            1 if int(jobs) == record.jobs_mask else 0,
            1 if int(script_type) != 0 else 0,
            1 if weapon_stats.get("damage") is not None and damage is not None and int(damage) == weapon_stats["damage"] else 0,
            1 if weapon_stats.get("delay") is not None and delay is not None and int(delay) == weapon_stats["delay"] else 0,
        )

    scored = [(score(row), int(row[0])) for row in rows]
    best_score = max(value[0] for value in scored)
    if not any(best_score):
        return None
    best_item_ids = [item_id for row_score, item_id in scored if row_score == best_score]
    if len(best_item_ids) != 1:
        return None
    return best_item_ids[0]


def _match_catseye_equipment_name(
    name: str,
    item_ids_by_name: dict[str, set[int]],
) -> int | None:
    if CATSEYE_RECIPE_MARKER_RE.search(name):
        return None

    normalized_name = _normalize_catseye_equipment_name(name)
    alias_item_id = CATSEYE_EQUIPMENT_NAME_ALIASES.get(normalized_name)
    if alias_item_id is not None:
        return alias_item_id

    item_ids = item_ids_by_name.get(normalized_name)
    if item_ids is None or len(item_ids) != 1:
        return None
    return next(iter(item_ids))


def _iter_catseye_equipment_records(pages_root: Path) -> Iterable[CatseyeEquipmentRecord]:
    for path in sorted(pages_root.glob("CatsEyeXI_Content_Equipment_*.txt")):
        yield from _parse_catseye_equipment_page(path, pages_root)


def _parse_catseye_equipment_page(path: Path, pages_root: Path) -> Iterable[CatseyeEquipmentRecord]:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = [line.strip() for line in text.replace("\u00a0", " ").splitlines()]
    lines = [line for line in lines if line]
    header_indexes = [
        index for index, line in enumerate(lines)
        if CATSEYE_EQUIPMENT_HEADER_RE.match(line) is not None
    ]

    for header_position, header_index in enumerate(header_indexes):
        if header_index <= 0:
            continue

        header_match = CATSEYE_EQUIPMENT_HEADER_RE.match(lines[header_index])
        if header_match is None:
            continue

        next_header_index = header_indexes[header_position + 1] if header_position + 1 < len(header_indexes) else len(lines)
        record_end = max(header_index + 1, next_header_index - 1)
        level_index = next(
            (
                index for index in range(header_index + 1, record_end)
                if CATSEYE_LEVEL_RE.match(lines[index]) is not None
            ),
            -1,
        )
        if level_index < 0:
            continue

        level_match = CATSEYE_LEVEL_RE.match(lines[level_index])
        if level_match is None:
            continue

        try:
            source_path = path.relative_to(pages_root.parent).as_posix()
        except ValueError:
            source_path = path.as_posix()

        source_lines = [
            line for line in lines[level_index + 1:record_end]
            if not re.fullmatch(r"\d+", line)
        ]
        source_text = " ".join(source_lines) or f"Listed on {path.name}."
        yield CatseyeEquipmentRecord(
            name=lines[header_index - 1],
            level=int(level_match.group(1)),
            jobs_mask=_catseye_jobs_mask(level_match.group(2)),
            slot_mask=_catseye_slot_mask(header_match.group(1)),
            stats_text=" ".join(lines[header_index + 1:level_index]),
            source_text=source_text,
            source_path=source_path,
        )


def _catseye_jobs_mask(job_text: str) -> int:
    text = " ".join((job_text or "").replace(",", " ").replace("/", " ").split())
    if not text or text == "All Jobs":
        return ALL_JOB_MASK

    mask = 0
    for token in text.split(" "):
        job_id = JOB_ID_BY_ABBR.get(token.upper())
        if job_id is not None:
            mask |= 1 << (job_id - 1)
    return mask


def _catseye_slot_mask(slot_family: str) -> int:
    mask = 0
    for slot in CATSEYE_SLOT_FAMILIES.get(slot_family, (slot_family,)):
        mask |= EQUIPMENT_SLOT_MASKS.get(slot, 0)
    return mask


def _normalize_catseye_equipment_name(name: str) -> str:
    signed = CATSEYE_SIGNED_SUFFIX_RE.sub(
        lambda match: f" {'plus' if match.group(1) == '+' else 'minus'}{match.group(2)} ",
        name.lower(),
    )
    return CATSEYE_NAME_NORMALIZE_RE.sub("", signed)


def _normalize_skill_rank_name(name: str) -> str:
    normalized = re.sub(r"[^a-z0-9]+", "_", name.strip().lower()).strip("_")
    return {
        "hand2hand": "hand_to_hand",
    }.get(normalized, normalized)


def _insert_item_weapon(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "item_weapon")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "item_weapon", row, 12)
        mapped.append(tuple(_as_int(row[index]) if index != 1 else _as_text(row[index]) for index in range(12)))
    db.executemany(
        """
        insert into item_weapon(
            item_id, name, skill, subskill, ilvl_skill, ilvl_parry, ilvl_magic_accuracy,
            damage_type, hit, delay, damage, unlock_points
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _apply_client_item_resources(
    db: sqlite3.Connection,
    client_items_path: Path | str | None,
) -> ClientItemResourceImport:
    if client_items_path is None:
        return ClientItemResourceImport(source_path=None)

    dump_path = _resolve_client_items_dump_path(client_items_path)
    resources = tuple(_iter_client_item_resources(dump_path))
    if not resources:
        return ClientItemResourceImport(source_path=dump_path)

    db.executemany(
        """
        insert into catseye_client_items(
            item_id, name, level, ilevel, client_jobs, jobs, slot, flags,
            stack_size, item_type, sub_type, skill, damage, delay, damage_type,
            shield_size, su_level, valid_targets, source_path
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            (
                item.item_id,
                item.name,
                item.level,
                item.ilevel,
                item.client_jobs_mask,
                item.jobs_mask,
                item.slot_mask,
                item.flags,
                item.stack_size,
                item.item_type,
                item.sub_type,
                item.skill,
                item.damage,
                item.delay,
                item.damage_type,
                item.shield_size,
                item.su_level,
                item.valid_targets,
                str(dump_path),
            )
            for item in resources
        ),
    )

    equipment_update_count = 0
    weapon_update_count = 0
    for item in resources:
        if item.slot_mask > 0 or item.skill > 0 or item.damage > 0 or item.delay > 0:
            _upsert_client_basic_resource(db, item)

        if item.slot_mask > 0 and item.jobs_mask > 0:
            _upsert_client_equipment_resource(db, item)
            equipment_update_count += 1

        if item.skill > 0 or item.damage > 0 or item.delay > 0:
            _upsert_client_weapon_resource(db, item)
            weapon_update_count += 1

    return ClientItemResourceImport(
        source_path=dump_path,
        item_count=len(resources),
        equipment_update_count=equipment_update_count,
        weapon_update_count=weapon_update_count,
    )


def _upsert_client_basic_resource(db: sqlite3.Connection, item: ClientItemResource) -> None:
    _insert_item_name_aliases(db, ((item.item_id, item.name, "catseye_client_item_name"),))
    item_type = _client_basic_item_type(item)
    cursor = db.execute(
        """
        update items
        set name = ?, sort_name = ?, item_type = ?, stack_size = ?, flags = ?
        where item_id = ?
        """,
        (
            item.name,
            item.name,
            item_type,
            max(item.stack_size, 1),
            str(item.flags),
            item.item_id,
        ),
    )
    if cursor.rowcount:
        return

    db.execute(
        """
        insert into items(
            item_id, sub_id, name, sort_name, item_type, stack_size, flags, auction_house, base_sell
        ) values (?, 0, ?, ?, ?, ?, ?, '', 0)
        """,
        (
            item.item_id,
            item.name,
            item.name,
            item_type,
            max(item.stack_size, 1),
            str(item.flags),
        ),
    )


def _client_basic_item_type(item: ClientItemResource) -> str:
    if item.skill > 0 or item.damage > 0 or item.delay > 0:
        return "Weapon"
    if item.slot_mask > 0:
        return "Armor"
    return "Item"


def _resolve_client_items_dump_path(client_items_path: Path | str) -> Path:
    path = Path(client_items_path)
    if path.is_file():
        return path
    if path.is_dir():
        matches = sorted(
            path.rglob("*_client_items.json"),
            key=lambda candidate: candidate.stat().st_mtime,
            reverse=True,
        )
        if matches:
            return matches[0]
    raise FileNotFoundError(f"Catseye client item resource dump not found: {path}")


def _iter_client_item_resources(path: Path) -> Iterable[ClientItemResource]:
    payload = json.loads(path.read_text(encoding="utf-8", errors="replace"))
    raw_items = payload if isinstance(payload, list) else payload.get("items", ())
    for raw in raw_items:
        if not isinstance(raw, dict):
            continue
        item_id = _json_int(raw, "id")
        name = _json_text(raw, "name")
        if item_id <= 0 or not name:
            continue

        client_jobs_mask = _json_int(raw, "jobMask")
        yield ClientItemResource(
            item_id=item_id,
            name=name,
            level=_json_int(raw, "level"),
            ilevel=_json_int(raw, "itemLevel"),
            client_jobs_mask=client_jobs_mask,
            jobs_mask=_server_jobs_mask_from_client(client_jobs_mask),
            slot_mask=_json_int(raw, "slotMask"),
            flags=_json_int(raw, "flags"),
            stack_size=_json_int(raw, "stack", default=1),
            item_type=_json_int(raw, "type"),
            sub_type=_json_int(raw, "subType"),
            skill=_json_int(raw, "skill"),
            damage=_json_int(raw, "damage"),
            delay=_json_int(raw, "delay"),
            damage_type=_json_int(raw, "damageType"),
            shield_size=_json_int(raw, "shieldSize"),
            su_level=_json_int(raw, "superiorLevel"),
            valid_targets=_json_int(raw, "validTargets"),
        )


def _server_jobs_mask_from_client(client_jobs_mask: int) -> int:
    return client_jobs_mask >> 1


def _upsert_client_equipment_resource(db: sqlite3.Connection, item: ClientItemResource) -> None:
    cursor = db.execute(
        """
        update item_equipment
        set name = ?, level = ?, ilevel = ?, jobs = ?, shield_size = ?, slot = ?, su_level = ?
        where item_id = ?
        """,
        (
            item.name,
            item.level,
            item.ilevel,
            item.jobs_mask,
            item.shield_size,
            item.slot_mask,
            item.su_level,
            item.item_id,
        ),
    )
    if cursor.rowcount:
        return

    db.execute(
        """
        insert into item_equipment(
            item_id, name, level, ilevel, jobs, model_id, shield_size, script_type,
            slot, rslot, rslot_look, su_level
        ) values (?, ?, ?, ?, ?, 0, ?, 0, ?, 0, 0, ?)
        """,
        (
            item.item_id,
            item.name,
            item.level,
            item.ilevel,
            item.jobs_mask,
            item.shield_size,
            item.slot_mask,
            item.su_level,
        ),
    )


def _upsert_client_weapon_resource(db: sqlite3.Connection, item: ClientItemResource) -> None:
    cursor = db.execute(
        """
        update item_weapon
        set name = ?, skill = ?, damage_type = ?, delay = ?, damage = ?
        where item_id = ?
        """,
        (
            item.name,
            item.skill,
            item.damage_type,
            item.delay,
            item.damage,
            item.item_id,
        ),
    )
    if cursor.rowcount:
        return

    db.execute(
        """
        insert into item_weapon(
            item_id, name, skill, subskill, ilvl_skill, ilvl_parry,
            ilvl_magic_accuracy, damage_type, hit, delay, damage, unlock_points
        ) values (?, ?, ?, 0, 0, 0, 0, ?, 0, ?, ?, 0)
        """,
        (
            item.item_id,
            item.name,
            item.skill,
            item.damage_type,
            item.delay,
            item.damage,
        ),
    )


def _insert_item_mods(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> int:
    rows = _read_insert_rows(path, "item_mods")
    mapped = [
        (_as_int(row[0]), _as_int(row[1]), _mod_name(mod_names, _as_int(row[1])), _as_int(row[2]))
        for row in rows
        if len(row) >= 3
    ]
    db.executemany(
        "insert into item_mods(item_id, mod_id, mod_name, value) values (?, ?, ?, ?)",
        mapped,
    )
    return len(mapped)


def _insert_item_latents(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> int:
    rows = _read_insert_rows(path, "item_latents")
    mapped = [
        (
            _as_int(row[0]),
            _as_int(row[1]),
            _mod_name(mod_names, _as_int(row[1])),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
        )
        for row in rows
        if len(row) >= 5
    ]
    db.executemany(
        """
        insert into item_latents(item_id, mod_id, mod_name, value, condition_id, condition_value)
        values (?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_item_mods_pet(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> int:
    rows = _read_insert_rows(path, "item_mods_pet")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        if len(row) < 4:
            continue
        mod_id = _as_int(row[1])
        base_name = _mod_name(mod_names, mod_id)
        mapped.append(
            (
                _as_int(row[0]),
                mod_id,
                _pet_mod_name(base_name),
                _as_int(row[2]),
                _as_int(row[3]),
            )
        )
    db.executemany(
        "insert into item_mods_pet(item_id, mod_id, mod_name, value, pet_type) values (?, ?, ?, ?, ?)",
        mapped,
    )
    return len(mapped)


def _insert_abilities(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "abilities")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "abilities", row, 20)
        values = [
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
            _as_int(row[10]),
            _as_int(row[11]),
            _as_int(row[12]),
            _as_int(row[13]),
            _as_int(row[14]),
            _as_int(row[15]),
            _as_int(row[16]),
            _as_int(row[17]),
            _as_int(row[18]),
            _as_int(row[19]),
            None if len(row) < 21 or row[20] is None else _as_text(row[20]),
        ]
        mapped.append(tuple(values))
    db.executemany(
        """
        insert into abilities(
            ability_id, name, job, level, valid_target, recast_time, recast_id,
            message1, message2, animation, animation_time, cast_time, action_type,
            range, is_aoe, radius, ce, ve, merit_mod_id, add_type, content_tag
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_spells(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "spell_list")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "spell_list", row, 24)
        values = [
            _as_int(row[0]),
            _as_text(row[1]),
            _as_text(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
            _as_int(row[10]),
            _as_int(row[11]),
            _as_int(row[12]),
            _as_int(row[13]),
            _as_int(row[14]),
            _as_int(row[15]),
            _as_int(row[16]),
            _as_int(row[17]),
            _as_float(row[18]),
            _as_int(row[19]),
            _as_int(row[20]),
            _as_int(row[21]),
            _as_int(row[22]),
            _as_int(row[23]),
            None if len(row) < 25 or row[24] is None else _as_text(row[24]),
        ]
        mapped.append(tuple(values))
    db.executemany(
        """
        insert into spells(
            spell_id, name, jobs_hex, spell_group, family, element, zone_misc,
            valid_targets, skill, mp_cost, cast_time, recast_time, message,
            magic_burst_message, animation, animation_time, aoe, base, multiplier,
            ce, ve, requirements, spell_range, radius, content_tag
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_status_effects(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "status_effects")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "status_effects", row, 10)
        values = [
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
            _as_int(row[10]) if len(row) > 10 else 0,
        ]
        mapped.append(tuple(values))
    db.executemany(
        """
        insert into status_effects(
            status_id, name, flags, status_type, negative_id, overwrite, block_id,
            remove_id, element, min_duration, sort_key
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_augments(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> None:
    rows = _read_insert_rows(path, "augments")
    mapped = [
        (
            _as_int(row[0]),
            _as_int(row[1]),
            _as_int(row[2]),
            _mod_name(mod_names, _as_int(row[2])),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
        )
        for row in rows
        if len(row) >= 6
    ]
    db.executemany(
        """
        insert into augments(augment_id, multiplier, mod_id, mod_name, value, is_pet, pet_type)
        values (?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_merits(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "merits")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
        )
        for row in rows
        if len(row) >= 7
    ]
    db.executemany(
        """
        insert into merits(merit_id, name, upgrade, value, jobs, upgrade_id, category_id)
        values (?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_traits(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> None:
    rows = _read_insert_rows(path, "traits")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _mod_name(mod_names, _as_int(row[5])),
            _as_int(row[6]),
            None if row[7] is None else _as_text(row[7]),
            _as_int(row[8]),
        )
        for row in rows
        if len(row) >= 9
    ]
    db.executemany(
        """
        insert into traits(trait_id, name, job, level, rank, mod_id, mod_name, value, content_tag, merit_id)
        values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_skill_caps(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "skill_caps")
    mapped: list[tuple[int, int, int]] = []
    for row in rows:
        if len(row) < 15:
            continue
        level = _as_int(row[0])
        for rank in range(14):
            mapped.append((level, rank, _as_int(row[rank + 1])))
    db.executemany(
        "insert into skill_caps(level, rank, cap) values (?, ?, ?)",
        mapped,
    )
    return len(mapped)


def _insert_skill_ranks(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "skill_ranks")
    mapped: list[tuple[int, str, str, int]] = []
    jobs = tuple(JOB_ID_BY_ABBR.keys())
    for row in rows:
        if len(row) < 2 + len(jobs):
            continue
        skill_id = _as_int(row[0])
        skill_name = _normalize_skill_rank_name(_as_text(row[1]))
        for index, job in enumerate(jobs, start=2):
            mapped.append((skill_id, skill_name, job, _as_int(row[index])))
    db.executemany(
        "insert into skill_ranks(skill_id, skill_name, job, rank) values (?, ?, ?, ?)",
        mapped,
    )
    return len(mapped)


def _insert_weapon_skills(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "weapon_skills")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_text(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
            _as_int(row[10]),
            _as_int(row[11]),
            _as_int(row[12]),
            _as_int(row[13]),
            _as_int(row[14]),
            _as_int(row[15]),
        )
        for row in rows
        if len(row) >= 16
    ]
    db.executemany(
        """
        insert into weapon_skills(
            weapon_skill_id, name, jobs_hex, weapon_type, skill_level, element, animation,
            animation_time, range, aoe, radius, primary_sc, secondary_sc, tertiary_sc,
            main_only, unlock_id
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_item_usable(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "item_usable")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
        )
        for row in rows
        if len(row) >= 10
    ]
    db.executemany(
        """
        insert into item_usable(
            item_id, name, valid_targets, activation, animation, animation_time,
            max_charges, use_delay, reuse_delay, aoe
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_mob_sources(db: sqlite3.Connection, sql_path: Path) -> tuple[int, int, int]:
    paths = {filename: sql_path / filename for filename in MOB_SQL_FILES}
    if not all(path.exists() for path in paths.values()):
        return 0, 0, 0

    resistance_count = _insert_mob_resistances(db, paths["mob_resistances.sql"])
    pool_count = _insert_mob_pools(db, paths["mob_pools.sql"])
    _insert_mob_family_system(db, paths["mob_species_system.sql"])
    group_count = _insert_mob_groups(db, paths["mob_groups.sql"])
    return resistance_count, pool_count, group_count


def _insert_mob_resistances(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_resistances")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_resistances", row, 23)
        values = [_as_int(row[index]) if index != 1 else _as_text(row[index]) for index in range(min(len(row), 31))]
        while len(values) < 31:
            values.append(0)
        mapped.append(tuple(values[:31]))
    db.executemany(
        """
        insert into mob_resistances(
            resist_id, name, slash_sdt, pierce_sdt, h2h_sdt, impact_sdt, magical_sdt,
            fire_sdt, ice_sdt, wind_sdt, earth_sdt, lightning_sdt, water_sdt, light_sdt, dark_sdt,
            fire_res_rank, ice_res_rank, wind_res_rank, earth_res_rank, lightning_res_rank,
            water_res_rank, light_res_rank, dark_res_rank, paralyze_res_rank, bind_res_rank,
            silence_res_rank, slow_res_rank, poison_res_rank, light_sleep_res_rank,
            dark_sleep_res_rank, blind_res_rank
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_mob_pools(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_pools")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_pools", row, 26)
        mapped.append(
            (
                _as_int(row[0]),
                _as_text(row[1]),
                _as_text(row[2]),
                _as_int(row[3]),
                _as_int(row[5]),
                _as_int(row[6]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                _as_int(row[11]),
                _as_int(row[13]),
                _as_int(row[14]),
                _as_int(row[15]),
                _as_int(row[21]),
                _as_int(row[24]),
                _as_int(row[25]),
            )
        )
    db.executemany(
        """
        insert into mob_pools(
            poolid, name, packet_name, speciesid, mjob, sjob, cmb_skill, cmb_delay,
            cmb_dmg_mult, aggro, links, mob_type, immunity, spell_list, skill_list_id, resist_id
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_mob_family_system(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_family_system")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_family_system", row, 23)
        mapped.append(
            (
                _as_int(row[0]),
                _as_text(row[1]),
                _as_int(row[2]),
                _as_text(row[3]),
                _as_int(row[4]),
                _as_text(row[5]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                _as_int(row[10]),
                _as_int(row[11]),
                _as_int(row[12]),
                _as_int(row[13]),
                _as_int(row[14]),
                _as_int(row[15]),
                _as_int(row[16]),
                _as_int(row[17]),
                _as_int(row[18]),
                _as_int(row[19]),
                _as_float(row[20]),
                _as_int(row[21]),
                _as_int(row[22]),
            )
        )
    db.executemany(
        """
        insert into mob_family_system(
            speciesID, family, superFamilyID, superFamily, ecosystemID, ecosystem,
            HP, MP, STR, DEX, VIT, AGI, INT, MND, CHR, ATT, DEF, ACC, EVA,
            Element, detects, charmable
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_mob_groups(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_groups")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_groups", row, 11)
        mapped.append(
            (
                _as_int(row[0]),
                _as_int(row[1]),
                _as_int(row[2]),
                _as_text(row[3]),
                _as_int(row[4]),
                _as_int(row[5]),
                _as_int(row[6]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                None if row[10] is None else _as_text(row[10]),
            )
        )
    db.executemany(
        """
        insert into mob_groups(
            groupid, poolid, zoneid, name, respawntime, spawntype, dropid,
            HP, MP, allegiance, content_tag
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_food_effects(
    db: sqlite3.Connection,
    scripts_path: Path,
    item_name_by_id: dict[int, str],
    mod_names: dict[int, str],
) -> tuple[int, int]:
    item_id_by_name = {name.lower(): item_id for item_id, name in item_name_by_id.items()}
    effects = tuple(_iter_food_effects(scripts_path, item_id_by_name, mod_names))

    db.executemany(
        """
        insert into food_effects(item_id, name, food_type, duration_seconds, script_path)
        values (?, ?, ?, ?, ?)
        """,
        (
            (
                effect.item_id,
                effect.name,
                effect.food_type,
                effect.duration_seconds,
                str(effect.script_path),
            )
            for effect in effects
        ),
    )

    food_mod_rows = [
        (effect.item_id, mod.target_type, mod.mod_id, mod.mod_name, mod.value)
        for effect in effects
        for mod in effect.mods
    ]
    db.executemany(
        """
        insert into food_effect_mods(item_id, target_type, mod_id, mod_name, value)
        values (?, ?, ?, ?, ?)
        """,
        food_mod_rows,
    )
    return len(effects), len(food_mod_rows)


def _iter_food_effects(
    scripts_path: Path,
    item_id_by_name: dict[str, int],
    mod_names: dict[int, str],
) -> Iterable[FoodEffect]:
    mod_ids_by_name = {name: mod_id for mod_id, name in mod_names.items()}
    for path in sorted(scripts_path.glob("*.lua")):
        text = path.read_text(encoding="utf-8", errors="replace")
        if "foodOnItemCheck" not in text and "xi.foodType" not in text:
            continue

        item_id_match = ITEM_ID_RE.search(text)
        item_id = int(item_id_match.group(1)) if item_id_match else item_id_by_name.get(path.stem.lower())
        if item_id is None:
            continue

        item_name_match = ITEM_NAME_RE.search(text)
        item_name = item_name_match.group(1).strip() if item_name_match else path.stem
        food_type_match = FOOD_TYPE_RE.search(text)
        duration_match = DURATION_RE.search(text)
        gain_match = ON_EFFECT_GAIN_RE.search(text)
        gain_text = gain_match.group(1) if gain_match else ""

        mods: list[FoodMod] = []
        for mod_name, value in ADD_MOD_RE.findall(gain_text):
            mods.append(
                FoodMod(
                    target_type="player",
                    mod_id=mod_ids_by_name.get(mod_name, 0),
                    mod_name=mod_name,
                    value=int(value),
                )
            )
        for mod_name, value in ADD_PET_MOD_RE.findall(gain_text):
            mods.append(
                FoodMod(
                    target_type="pet",
                    mod_id=mod_ids_by_name.get(mod_name, 0),
                    mod_name=mod_name,
                    value=int(value),
                )
            )

        yield FoodEffect(
            item_id=item_id,
            name=item_name,
            food_type=food_type_match.group(1) if food_type_match else "UNKNOWN",
            duration_seconds=int(duration_match.group(1)) if duration_match else 0,
            script_path=path,
            mods=tuple(mods),
        )


def _load_mod_names(enum_path: Path) -> dict[int, str]:
    mod_names = dict(MOD_NAMES)
    if not enum_path.exists():
        return mod_names

    text = enum_path.read_text(encoding="utf-8", errors="replace")
    for name, value in MOD_ENUM_RE.findall(text):
        mod_names[int(value)] = name
    return mod_names


def _mod_name(mod_names: dict[int, str], mod_id: int) -> str:
    return mod_names.get(mod_id, f"MOD_{mod_id}")


def _mod_id_by_name(mod_names: dict[int, str], mod_name: str, *, fallback: int) -> int:
    for mod_id, candidate_name in mod_names.items():
        if candidate_name == mod_name:
            return mod_id
    return fallback


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


def _read_insert_rows(path: Path, table: str) -> tuple[tuple[object | None, ...], ...]:
    text = path.read_text(encoding="utf-8", errors="replace")
    rows: list[tuple[object | None, ...]] = []
    insert_re = re.compile(
        rf"INSERT\s+INTO\s+`?{re.escape(table)}`?\s+VALUES\s*(.*?);",
        re.IGNORECASE | re.DOTALL,
    )
    for match in insert_re.finditer(text):
        for tuple_text in _split_tuples(match.group(1)):
            rows.append(tuple(_parse_sql_atom(value) for value in _split_sql_tuple(tuple_text)))
    return tuple(rows)


def _split_tuples(values_text: str) -> Iterable[str]:
    in_quote = False
    depth = 0
    start = 0
    index = 0
    while index < len(values_text):
        char = values_text[index]
        if char == "'" and (index == 0 or values_text[index - 1] != "\\"):
            if in_quote and index + 1 < len(values_text) and values_text[index + 1] == "'":
                index += 2
                continue
            in_quote = not in_quote
        elif not in_quote:
            if char == "(":
                if depth == 0:
                    start = index + 1
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    yield values_text[start:index]
        index += 1


def _split_sql_tuple(tuple_text: str) -> tuple[str, ...]:
    values: list[str] = []
    in_quote = False
    start = 0
    index = 0
    while index < len(tuple_text):
        char = tuple_text[index]
        if char == "'" and (index == 0 or tuple_text[index - 1] != "\\"):
            if in_quote and index + 1 < len(tuple_text) and tuple_text[index + 1] == "'":
                index += 2
                continue
            in_quote = not in_quote
        elif char == "," and not in_quote:
            values.append(tuple_text[start:index].strip())
            start = index + 1
        index += 1
    values.append(tuple_text[start:].strip())
    return tuple(values)


def _parse_sql_atom(value: str) -> object | None:
    value = value.strip()
    if value.upper() == "NULL":
        return None
    if len(value) >= 2 and value[0] == "'" and value[-1] == "'":
        return value[1:-1].replace("''", "'").replace("\\'", "'")
    try:
        return int(value, 0)
    except ValueError:
        return value


def _json_int(row: dict[str, object], key: str, default: int = 0) -> int:
    value = row.get(key)
    if value is None:
        return default
    if isinstance(value, bool):
        return int(value)
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value)
    text = str(value).strip()
    try:
        return int(text, 0)
    except ValueError:
        return default


def _json_text(row: dict[str, object], key: str) -> str:
    value = row.get(key)
    return "" if value is None else str(value)


def _as_int(value: object | None, default: int = 0) -> int:
    if value is None:
        return default
    if isinstance(value, int):
        return value
    text = str(value).strip()
    try:
        return int(text, 0)
    except ValueError:
        return default


def _as_text(value: object | None) -> str:
    return "" if value is None else str(value)


def _as_float(value: object | None, default: float = 0.0) -> float:
    if value is None:
        return default
    if isinstance(value, float):
        return value
    if isinstance(value, int):
        return float(value)
    text = str(value).strip()
    try:
        return float(text)
    except ValueError:
        return default


def _expect_minimum(path: Path, table: str, row: tuple[object | None, ...], minimum: int) -> None:
    if len(row) < minimum:
        raise ValueError(f"{path} {table} row has {len(row)} values, expected at least {minimum}: {row!r}")
