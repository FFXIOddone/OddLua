from __future__ import annotations

import re
from typing import Iterable, Mapping

from .planning.command_registry import (
    BLUE_LEARNING_MODE_FEATURE,
    CASTER_SUSTAIN_MODE_FEATURE,
    EXPLICIT_GEAR_MODES_FEATURE,
    GUARD_MODE_FEATURE,
    OCCULT_ACUMEN_MODE_FEATURE,
)
from .planning.number_row_palette import NUMBER_ROW_COMMAND_ONLY_KEYS
from .subjobs import JOB_IDS, SubjobProfile


SLOT_ORDER = (
    "Main",
    "Sub",
    "Range",
    "Ammo",
    "Head",
    "Neck",
    "Ear1",
    "Ear2",
    "Body",
    "Hands",
    "Ring1",
    "Ring2",
    "Back",
    "Waist",
    "Legs",
    "Feet",
)
GLOBAL_CONDITIONAL_EQUIP_KEY = "__global__"

ODDLUA_REFRESH_LAUNCHER = r"C:\Users\jakeb\Projects\FFXI Personal Server\OddLua\Run-OddLuaGameRefresh.cmd"
ODDLUA_REFRESH_STATUS_PATH = r"C:\Users\jakeb\Projects\FFXI Personal Server\OddLua\reports\game-refresh\latest-status.json"

KEYPAD_MOVEMENT_CLUSTER_UNBIND_KEYS = NUMBER_ROW_COMMAND_ONLY_KEYS
ARROW_MOVEMENT_CLUSTER_UNBIND_KEYS = ("UP", "DOWN", "LEFT", "RIGHT")
RESERVED_MOVEMENT_CLUSTER_UNBIND_KEYS = (
    *KEYPAD_MOVEMENT_CLUSTER_UNBIND_KEYS,
    *ARROW_MOVEMENT_CLUSTER_UNBIND_KEYS,
)
RESERVED_MOVEMENT_CLUSTER_KEYS = frozenset(RESERVED_MOVEMENT_CLUSTER_UNBIND_KEYS)
LEGACY_KEYPAD_UNBIND_KEYS = (
    "NUMPAD.",
    "NUMPAD0",
    "NUMPAD1",
    "NUMPAD2",
    "NUMPAD3",
    "NUMPAD4",
    "NUMPAD5",
    "NUMPAD6",
    "NUMPAD7",
    "NUMPAD8",
    "NUMPAD9",
)

STYLE_INTENTS = {
    "AncientCircle": "AncientCircle",
    "ArcaneCircle": "ArcaneCircle",
    "HolyCircle": "HolyCircle",
    "Flee": "Flee",
    "Hide": "Hide",
    "Camouflage": "Camouflage",
    "AlacrityCelerity": "FastCast",
    "Melt": "TP",
    "Dagger": "TP",
    "Safe": "PDT",
    "Treasure": "TP",
    "Craft": "Crafting",
    "Tank": "PDT",
    "Dt": "PDT",
    "Enmity": "Enmity",
    "Damage": "TP",
    "MagicDefense": "MDT",
    "FireRes": "MDT",
    "IceRes": "MDT",
    "WindRes": "MDT",
    "EarthRes": "MDT",
    "ThunderRes": "MDT",
    "LightningRes": "MDT",
    "WaterRes": "MDT",
    "LightRes": "MDT",
    "DarkRes": "MDT",
    "StatusResist": "MDT",
    "CharmResist": "MDT",
    "Nuke": "Nuke",
    "DivineDamage": "Nuke",
    "MagicAccuracy": "MagicAccuracy",
    "BlueLearning": "Idle",
    "Chakra": "JobAbility",
    "CombatSkillup": "TP",
    "ElementalPrecast": "FastCast",
    "FastCast": "FastCast",
    "Guard": "PDT",
    "MagicBurst": "Nuke",
    "MagicSkillup": "MagicAccuracy",
    "OccultAcumen": "Nuke",
    "SIRD": "SIRD",
    "SIRD_NIN": "SIRD",
    "ConserveMP": "FastCast",
    "IdleRefresh": "Refresh",
    "IdleNonCombat": "Refresh",
    "IdleCombat": "PDT",
    "IdleMaxMP": "Refresh",
    "IdleMaxHP": "Idle",
    "IdleCity": "Movement",
    "InCity": "Movement",
    "Movement": "Movement",
    "Movement_City": "Movement",
    "Movement_Night": "Movement",
    "Movement_DuskToDawn": "Movement",
    "Accuracy": "Accuracy",
    "WeaponSkill": "Weaponskill",
    "Survival": "PDT",
    "Evasion": "Evasion",
    "Cure": "Cure",
    "CurePrecast": "CurePrecast",
    "Enspell": "TP",
    "DrainAbsorb": "MagicAccuracy",
    "PetDamage": "PetDamage",
    "PetTank": "PetTank",
    "Song": "Song",
    "RangedDamage": "RangedAttack",
    "RangedAccuracy": "RangedAccuracy",
    "StoreTP": "TP",
    "Ninjutsu": "Ninjutsu",
    "Jump": "Weaponskill",
    "JumpAccuracy": "Weaponskill",
    "HighJump": "Weaponskill",
    "HighJumpAccuracy": "Weaponskill",
    "Aggressor": "JobAbility",
    "Barrage": "Barrage",
    "Berserk": "JobAbility",
    "Retaliation": "Retaliation",
    "Warcry": "JobAbility",
    "CoverActive": "CoverActive",
    "Rampart": "JobAbility",
    "ShieldBash": "JobAbility",
    "WardingCircle": "WardingCircle",
    "AvatarPerp": "Refresh",
    "BloodPact": "PetDamage",
    "SummoningMagic": "Summoning",
    "PhysicalBlue": "TP",
    "Proc": "TP",
    "MagicalBlue": "Nuke",
    "QuickDraw": "QuickDraw",
    "QuickDrawAccuracy": "MagicAccuracy",
    "Roll": "Roll",
    "Waltz": "Cure",
    "HealingWaltz": "JobAbility",
    "Flourish": "Flourish",
    "GeoMagic": "MagicAccuracy",
    "IndiDuration": "MagicAccuracy",
    "Jig": "JobAbility",
    "Maneuver": "JobAbility",
    "Mug": "JobAbility",
    "Reward": "JobAbility",
    "Sentinel": "JobAbility",
    "SATA": "JobAbility",
    "SneakAttack": "JobAbility",
    "SpiritLink": "JobAbility",
    "SuperJump": "JobAbility",
    "TrickAttack": "JobAbility",
    "Charm": "JobAbility",
    "Counterstance": "Counterstance",
    "DualWield": "TP",
    "WyvernBreath": "PetDamage",
}

ELEMENT_SUFFIXES = (
    "Fire",
    "Ice",
    "Wind",
    "Earth",
    "Thunder",
    "Lightning",
    "Water",
    "Light",
    "Dark",
)

RESIST_SEMANTIC_SETS = {
    "Fire": "FireRes",
    "Ice": "IceRes",
    "Wind": "WindRes",
    "Earth": "EarthRes",
    "Thunder": "ThunderRes",
    "Lightning": "LightningRes",
    "Water": "WaterRes",
    "Light": "LightRes",
    "Dark": "DarkRes",
}

BLUE_MAGIC_ROUTES = {
    "1000 needles": "MagicalBlueMagic",
    "actinic burst": "Enfeebling",
    "amorphic spikes": "PhysicalBlueMagic",
    "amplification": "Enhancing",
    "animating wail": "Enhancing",
    "asuran claws": "PhysicalBlueMagic",
    "auroral drape": "Enfeebling",
    "awful eye": "Enfeebling",
    "bad breath": "MagicalBlueMagic",
    "battery charge": "Enhancing",
    "battle dance": "PhysicalBlueMagic",
    "blank gaze": "Enfeebling",
    "blastbomb": "MagicalBlueMagic",
    "blitzstrahl": "MagicalBlueMagic",
    "blood drain": "MagicalBlueMagic",
    "blood saber": "MagicalBlueMagic",
    "bludgeon": "PhysicalBlueMagic",
    "body slam": "PhysicalBlueMagic",
    "bomb toss": "MagicalBlueMagic",
    "cannonball": "PhysicalBlueMagic",
    "chaotic eye": "Enfeebling",
    "charged whisker": "MagicalBlueMagic",
    "cimicine discharge": "Enfeebling",
    "claw cyclone": "PhysicalBlueMagic",
    "cocoon": "Enhancing",
    "cold wave": "Enfeebling",
    "corrosive ooze": "MagicalBlueMagic",
    "cursed sphere": "MagicalBlueMagic",
    "death ray": "MagicalBlueMagic",
    "death scissors": "PhysicalBlueMagic",
    "delta thrust": "PhysicalBlueMagic",
    "diamondhide": "Enhancing",
    "digest": "MagicalBlueMagic",
    "dimensional death": "PhysicalBlueMagic",
    "disseverment": "PhysicalBlueMagic",
    "dream flower": "Enfeebling",
    "empty thrash": "PhysicalBlueMagic",
    "enervation": "Enfeebling",
    "exuviation": "Cure",
    "eyes on me": "MagicalBlueMagic",
    "feather barrier": "Enhancing",
    "feather storm": "PhysicalBlueMagic",
    "feather tickle": "Enfeebling",
    "filamented hold": "Enfeebling",
    "firespit": "MagicalBlueMagic",
    "flying hip press": "MagicalBlueMagic",
    "foot kick": "PhysicalBlueMagic",
    "frenetic rip": "PhysicalBlueMagic",
    "frightful roar": "Enfeebling",
    "frost breath": "MagicalBlueMagic",
    "frypan": "PhysicalBlueMagic",
    "geist wall": "Enfeebling",
    "goblin rush": "PhysicalBlueMagic",
    "grand slam": "PhysicalBlueMagic",
    "head butt": "PhysicalBlueMagic",
    "healing breeze": "Cure",
    "heat breath": "MagicalBlueMagic",
    "heavy strike": "PhysicalBlueMagic",
    "hecatomb wave": "MagicalBlueMagic",
    "helldive": "PhysicalBlueMagic",
    "hydro shot": "PhysicalBlueMagic",
    "hysteric barrage": "PhysicalBlueMagic",
    "ice break": "MagicalBlueMagic",
    "infrasonics": "Enfeebling",
    "jet stream": "PhysicalBlueMagic",
    "jettatura": "Enfeebling",
    "light of penance": "Enfeebling",
    "lowing": "Enfeebling",
    "maelstrom": "MagicalBlueMagic",
    "magic fruit": "Cure",
    "magic hammer": "MagicalBlueMagic",
    "magnetite cloud": "MagicalBlueMagic",
    "mandibular bite": "PhysicalBlueMagic",
    "memento mori": "Enhancing",
    "metallic body": "Enhancing",
    "mind blast": "MagicalBlueMagic",
    "mp drainkiss": "MagicalBlueMagic",
    "mysterious light": "MagicalBlueMagic",
    "occultation": "Enhancing",
    "pinecone bomb": "PhysicalBlueMagic",
    "plasma charge": "Enhancing",
    "plenilune embrace": "Cure",
    "poison breath": "MagicalBlueMagic",
    "pollen": "Cure",
    "power attack": "PhysicalBlueMagic",
    "quad continuum": "PhysicalBlueMagic",
    "quadrastrike": "PhysicalBlueMagic",
    "queasyshroom": "PhysicalBlueMagic",
    "radiant breath": "MagicalBlueMagic",
    "ram charge": "PhysicalBlueMagic",
    "reactor cool": "Enhancing",
    "refueling": "Enhancing",
    "regeneration": "Enhancing",
    "regurgitation": "MagicalBlueMagic",
    "rending deluge": "MagicalBlueMagic",
    "saline coat": "Enhancing",
    "sandspin": "MagicalBlueMagic",
    "sandspray": "Enfeebling",
    "screwdriver": "PhysicalBlueMagic",
    "seedspray": "PhysicalBlueMagic",
    "self-destruct": "MagicalBlueMagic",
    "sheep song": "Enfeebling",
    "sickle slash": "PhysicalBlueMagic",
    "smite of rage": "PhysicalBlueMagic",
    "soporific": "Enfeebling",
    "sound blast": "Enfeebling",
    "spinal cleave": "PhysicalBlueMagic",
    "spiral spin": "PhysicalBlueMagic",
    "sprout smack": "PhysicalBlueMagic",
    "stinking gas": "Enfeebling",
    "sub-zero smash": "PhysicalBlueMagic",
    "sudden lunge": "PhysicalBlueMagic",
    "tail slap": "PhysicalBlueMagic",
    "temporal shift": "Enfeebling",
    "terror touch": "PhysicalBlueMagic",
    "thermal pulse": "MagicalBlueMagic",
    "triumphant roar": "Enhancing",
    "uppercut": "PhysicalBlueMagic",
    "venom shell": "Enfeebling",
    "vertical cleave": "PhysicalBlueMagic",
    "voracious trunk": "Enfeebling",
    "warm-up": "Enhancing",
    "whirl of rage": "PhysicalBlueMagic",
    "white wind": "Cure",
    "wild carrot": "Cure",
    "wild oats": "PhysicalBlueMagic",
    "wind breath": "MagicalBlueMagic",
    "yawn": "Enfeebling",
    "zephyr mantle": "Enhancing",
}

AAHTACOS_SAM_CONTROLS_FEATURE = "aahtacos_sam_controls"

SEMANTIC_INTENTS = {
    "AncientCircle": "AncientCircle",
    "ArcaneCircle": "ArcaneCircle",
    "HolyCircle": "HolyCircle",
    "Flee": "Flee",
    "Hide": "Hide",
    "Camouflage": "Camouflage",
    "Idle": "Idle",
    "IdleCity": "Idle",
    "IdleCombat": "PDT",
    "IdleMaxMP": "Idle",
    "IdleMaxHP": "Idle",
    "IdleNonCombat": "Idle",
    "Resting": "Idle",
    "InCity": "Movement",
    "Movement": "Movement",
    "Movement_City": "Movement",
    "Movement_Night": "Movement",
    "Movement_DuskToDawn": "Movement",
    "Aftercast": "Idle",
    "Dt": "PDT",
    "PDT": "PDT",
    "MDT": "MDT",
    "FireRes": "MDT",
    "IceRes": "MDT",
    "WindRes": "MDT",
    "EarthRes": "MDT",
    "ThunderRes": "MDT",
    "LightningRes": "MDT",
    "WaterRes": "MDT",
    "LightRes": "MDT",
    "DarkRes": "MDT",
    "StatusResist": "MDT",
    "CharmResist": "MDT",
    "Crafting": "Crafting",
    "TP": "TP",
    "Hybrid": "TP",
    "TPAccuracy": "Accuracy",
    "Precast": "FastCast",
    "AlacrityCelerity": "FastCast",
    "BlueLearning": "Idle",
    "Chakra": "JobAbility",
    "CombatSkillup": "TP",
    "ElementalPrecast": "FastCast",
    "FastCast": "FastCast",
    "Guard": "PDT",
    "MagicBurst": "Nuke",
    "MagicSkillup": "MagicAccuracy",
    "OccultAcumen": "Nuke",
    "Proc": "TP",
    "SIRD": "SIRD",
    "SIRD_NIN": "SIRD",
    "ConserveMP": "FastCast",
    "Midcast": "MagicAccuracy",
    "Cure": "Cure",
    "CurePrecast": "CurePrecast",
    "Healing": "Healing",
    "Cursna": "Healing",
    "StatusRemoval": "Healing",
    "Enhancing": "Enhancing",
    "EnhancingDuration": "Enhancing",
    "Spikes": "Enhancing",
    "Stoneskin": "Enhancing",
    "Refresh": "Refresh",
    "Regen": "Regen",
    "SneakInvisible": "Enhancing",
    "Barspell": "Enhancing",
    "Phalanx": "Enhancing",
    "Aquaveil": "Enhancing",
    "Haste": "Enhancing",
    "Enfeebling": "Enfeebling",
    "Sleep": "Enfeebling",
    "Bind": "Enfeebling",
    "Burn": "Enfeebling",
    "Choke": "Enfeebling",
    "Drown": "Enfeebling",
    "Frost": "Enfeebling",
    "Gravity": "Enfeebling",
    "Silence": "Enfeebling",
    "Slow": "Enfeebling",
    "Paralyze": "Enfeebling",
    "Poison": "Enfeebling",
    "Rasp": "Enfeebling",
    "Shock": "Enfeebling",
    "Blind": "Enfeebling",
    "Dispel": "Enfeebling",
    "Dia": "Dia",
    "Bio": "DarkMagic",
    "Divine": "Enfeebling",
    "Flash": "Enmity",
    "Elemental": "Nuke",
    "Nuke": "Nuke",
    "DarkMagic": "DarkMagic",
    "DrainAspir": "DarkMagic",
    "Absorb": "DarkMagic",
    "Stun": "DarkMagic",
    "BlueMagic": "BlueMagic",
    "PhysicalBlueMagic": "PhysicalBlueMagic",
    "MagicalBlueMagic": "Nuke",
    "Song": "Song",
    "SongPrecast": "SongPrecast",
    "SongDebuff": "SongDebuff",
    "SongBuff": "SongBuff",
    "Geomancy": "MagicAccuracy",
    "IndiDuration": "MagicAccuracy",
    "Summoning": "Summoning",
    "BloodPactRage": "PetDamage",
    "BloodPactWard": "PetTank",
    "AvatarPerp": "Refresh",
    "Ninjutsu": "Ninjutsu",
    "Utsusemi": "FastCast",
    "NinjutsuEnfeeble": "NinjutsuEnfeeble",
    "Snapshot": "RangedPreshot",
    "RangedPreshot": "RangedPreshot",
    "Ranged": "RangedAccuracy",
    "RangedMidshot": "RangedAccuracy",
    "RangedAccuracy": "RangedAccuracy",
    "RangedAttack": "RangedAttack",
    "QuickDraw": "QuickDraw",
    "QuickDrawAccuracy": "MagicAccuracy",
    "Weaponskill": "Weaponskill",
    "WeaponSkillAccuracy": "WeaponSkillAccuracy",
    "WSElemental": "WSElemental",
    "JobAbility": "JobAbility",
    "Enmity": "Enmity",
    "Waltz": "Cure",
    "HealingWaltz": "JobAbility",
    "Flourish": "Flourish",
    "Steps": "Accuracy",
    "Samba": "TP",
    "Jig": "JobAbility",
    "Maneuver": "JobAbility",
    "Mug": "JobAbility",
    "Reward": "JobAbility",
    "Sentinel": "JobAbility",
    "SATA": "JobAbility",
    "SneakAttack": "JobAbility",
    "SpiritLink": "JobAbility",
    "SuperJump": "JobAbility",
    "TrickAttack": "JobAbility",
    "Jump": "Weaponskill",
    "JumpAccuracy": "Weaponskill",
    "HighJump": "Weaponskill",
    "HighJumpAccuracy": "Weaponskill",
    "Aggressor": "JobAbility",
    "Barrage": "Barrage",
    "Berserk": "JobAbility",
    "Retaliation": "Retaliation",
    "Warcry": "JobAbility",
    "CoverActive": "CoverActive",
    "Rampart": "JobAbility",
    "ShieldBash": "JobAbility",
    "WardingCircle": "WardingCircle",
    "Meditate": "Meditate",
    "ThirdEye": "ThirdEye",
    "PetReady": "PetDamage",
    "PetMagic": "PetMagic",
    "PetTank": "PetTank",
    "Roll": "Roll",
    "Charm": "JobAbility",
    "Counterstance": "Counterstance",
    "DualWield": "TP",
    "WyvernBreath": "PetDamage",
}

SEMANTIC_SET_PREFERENCES = {
    "Idle": (
        "IdleNonCombat",
        "IdleRefresh",
        "AvatarPerp",
        "Safe",
        "Survival",
        "Evasion",
        "PetTank",
        "Tank",
        "MagicDefense",
        "FastCast",
        "Cure",
    ),
    "IdleCity": ("IdleCity", "InCity", "Movement_City", "Movement", "IdleNonCombat", "IdleRefresh"),
    "IdleCombat": ("IdleCombat", "Dt", "PDT", "MDT", "MagicDefense", "Safe", "Survival", "Tank", "Evasion"),
    "IdleMaxMP": ("IdleMaxMP", "IdleNonCombat", "IdleRefresh", "AvatarPerp", "Refresh"),
    "IdleMaxHP": ("IdleMaxHP", "PhysicalIdle", "Survival", "Safe", "IdleCombat"),
    "IdleNonCombat": ("IdleNonCombat", "IdleRefresh", "AvatarPerp", "Refresh"),
    "Resting": ("IdleRefresh", "AvatarPerp", "Cure", "FastCast", "MagicAccuracy"),
    "InCity": ("InCity", "Movement_City", "Movement"),
    "Movement": ("Movement",),
    "Movement_City": ("Movement_City", "Movement"),
    "Movement_Night": ("Movement_Night", "Movement"),
    "Movement_DuskToDawn": ("Movement_DuskToDawn", "Movement"),
    "Aftercast": ("IdleNonCombat", "IdleRefresh", "Safe", "Survival", "Evasion", "MagicDefense", "FastCast", "Cure"),
    "Dt": ("Safe", "Survival", "Tank", "MagicDefense", "Evasion", "PetTank"),
    "PDT": ("Dt", "Safe", "Survival", "Tank", "MagicDefense", "Evasion", "PetTank"),
    "MDT": ("MagicDefense", "Safe", "Survival", "Tank", "IdleRefresh", "AvatarPerp"),
    "FireRes": ("FireRes", "MagicDefense", "MDT"),
    "IceRes": ("IceRes", "MagicDefense", "MDT"),
    "WindRes": ("WindRes", "MagicDefense", "MDT"),
    "EarthRes": ("EarthRes", "MagicDefense", "MDT"),
    "ThunderRes": ("ThunderRes", "MagicDefense", "MDT"),
    "LightningRes": ("LightningRes", "ThunderRes", "MagicDefense", "MDT"),
    "WaterRes": ("WaterRes", "MagicDefense", "MDT"),
    "LightRes": ("LightRes", "MagicDefense", "MDT"),
    "DarkRes": ("DarkRes", "MagicDefense", "MDT"),
    "StatusResist": ("StatusResist",),
    "CharmResist": ("CharmResist",),
    "Crafting": ("Craft",),
    "TP": (
        "Melt",
        "Damage",
        "Enspell",
        "PhysicalBlue",
        "Accuracy",
        "StoreTP",
        "RangedDamage",
        "Tank",
    ),
    "Hybrid": ("Damage", "Accuracy", "Survival", "Evasion", "Safe", "Tank"),
    "TPAccuracy": ("Accuracy", "Dagger", "RangedAccuracy", "MagicAccuracy", "Damage"),
    "BlueLearning": ("BlueLearning",),
    "Chakra": ("Chakra",),
    "CombatSkillup": ("CombatSkillup",),
    "MagicSkillup": ("MagicSkillup",),
    "Proc": ("Proc",),
    "AlacrityCelerity": ("AlacrityCelerity",),
    "Precast": ("FastCast", "Ninjutsu", "Song", "GeoMagic", "MagicAccuracy"),
    "ElementalPrecast": ("FastCast", "Precast", "MagicAccuracy"),
    "DivineDamage": ("Nuke", "MagicAccuracy", "Divine", "FastCast"),
    "FastCast": ("FastCast", "Ninjutsu", "Song", "GeoMagic", "MagicAccuracy"),
    "Guard": ("Guard",),
    "MagicBurst": ("Nuke", "Elemental", "MagicAccuracy", "FastCast"),
    "OccultAcumen": ("OccultAcumen",),
    "SIRD": ("SIRD", "FastCast", "MagicDefense", "IdleCombat"),
    "SIRD_NIN": ("SIRD_NIN", "SIRD", "FastCast", "MagicDefense", "IdleCombat"),
    "ConserveMP": ("ConserveMP", "FastCast", "MagicAccuracy", "Midcast"),
    "Midcast": ("MagicAccuracy", "Nuke", "MagicalBlue", "GeoMagic", "SIRD", "FastCast"),
    "CurePrecast": ("CurePrecast", "FastCast"),
    "Cure": ("Cure", "Waltz", "FastCast", "IdleRefresh"),
    "Healing": ("Cure", "Waltz", "FastCast", "IdleRefresh"),
    "Cursna": ("StatusRemoval", "Cure", "FastCast"),
    "StatusRemoval": ("Cure", "FastCast", "MagicAccuracy"),
    "Enhancing": ("FastCast", "Cure", "MagicAccuracy", "GeoMagic"),
    "EnhancingDuration": ("FastCast", "Cure", "MagicAccuracy", "GeoMagic"),
    "Spikes": ("Enhancing", "Nuke", "MagicAccuracy"),
    "Stoneskin": ("Cure", "MagicAccuracy", "FastCast", "IdleRefresh"),
    "Refresh": ("IdleRefresh", "FastCast", "MagicAccuracy", "Cure"),
    "Regen": ("Cure", "IdleRefresh", "FastCast"),
    "SneakInvisible": ("FastCast", "IdleRefresh", "MagicAccuracy"),
    "Barspell": ("MagicDefense", "Cure", "FastCast"),
    "Phalanx": ("MagicDefense", "Cure", "FastCast"),
    "Aquaveil": ("FastCast", "Cure", "MagicAccuracy"),
    "Haste": ("FastCast", "Cure", "MagicAccuracy"),
    "Enfeebling": ("MagicAccuracy", "GeoMagic", "Ninjutsu", "Song", "FastCast"),
    "Sleep": ("MagicAccuracy", "DrainAbsorb", "Ninjutsu", "FastCast"),
    "Bind": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Burn": ("MagicAccuracy", "Nuke", "FastCast"),
    "Choke": ("MagicAccuracy", "Nuke", "FastCast"),
    "Drown": ("MagicAccuracy", "Nuke", "FastCast"),
    "Frost": ("MagicAccuracy", "Nuke", "FastCast"),
    "Gravity": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Silence": ("MagicAccuracy", "Song", "FastCast"),
    "Slow": ("MagicAccuracy", "FastCast"),
    "Paralyze": ("MagicAccuracy", "FastCast"),
    "Poison": ("MagicAccuracy", "Nuke", "FastCast"),
    "Rasp": ("MagicAccuracy", "Nuke", "FastCast"),
    "Shock": ("MagicAccuracy", "Nuke", "FastCast"),
    "Blind": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Dispel": ("MagicAccuracy", "FastCast"),
    "Dia": ("MagicAccuracy", "Cure", "FastCast"),
    "Bio": ("DrainAbsorb", "MagicAccuracy", "FastCast"),
    "Divine": ("MagicAccuracy", "Nuke", "Cure", "FastCast"),
    "Elemental": ("Nuke", "MagicalBlue", "GeoMagic", "QuickDraw", "MagicAccuracy", "FastCast"),
    "Nuke": ("Nuke", "MagicalBlue", "GeoMagic", "QuickDraw", "MagicAccuracy", "FastCast"),
    "DarkMagic": ("DrainAbsorb", "MagicAccuracy", "Nuke", "FastCast"),
    "DrainAspir": ("DrainAbsorb", "MagicAccuracy", "Nuke", "FastCast"),
    "Absorb": ("DrainAbsorb", "MagicAccuracy", "FastCast"),
    "Stun": ("MagicAccuracy", "DrainAbsorb", "FastCast"),
    "BlueMagic": ("PhysicalBlue", "MagicalBlue", "Accuracy", "FastCast"),
    "PhysicalBlueMagic": ("PhysicalBlue", "Accuracy", "FastCast"),
    "MagicalBlueMagic": ("MagicalBlue", "Nuke", "MagicAccuracy", "FastCast"),
    "Song": ("Song", "MagicAccuracy", "FastCast"),
    "SongPrecast": ("FastCast", "Song"),
    "SongDebuff": ("Song", "MagicAccuracy", "FastCast"),
    "SongBuff": ("Song", "FastCast", "IdleRefresh"),
    "Geomancy": ("GeoMagic", "MagicAccuracy", "FastCast"),
    "IndiDuration": ("GeoMagic", "MagicAccuracy", "FastCast"),
    "Summoning": ("SummoningMagic", "BloodPact", "AvatarPerp", "FastCast"),
    "BloodPactRage": ("BloodPact", "PetDamage", "SummoningMagic", "FastCast"),
    "BloodPactWard": ("SummoningMagic", "PetTank", "AvatarPerp", "FastCast"),
    "AvatarPerp": ("AvatarPerp", "IdleRefresh", "SummoningMagic"),
    "Ninjutsu": ("Ninjutsu", "MagicAccuracy", "FastCast", "Evasion"),
    "Utsusemi": ("FastCast", "Ninjutsu", "Evasion"),
    "NinjutsuEnfeeble": ("Ninjutsu", "MagicAccuracy", "FastCast"),
    "Snapshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "RangedPreshot": ("Snapshot", "RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "Ranged": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "RangedMidshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Accuracy"),
    "RangedAccuracy": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Accuracy"),
    "RangedAttack": ("RangedDamage", "RangedAccuracy", "QuickDraw"),
    "QuickDraw": ("QuickDraw", "MagicAccuracy", "Nuke", "RangedAccuracy"),
    "QuickDrawAccuracy": ("QuickDrawAccuracy",),
    "Weaponskill": (
        "WeaponSkill",
        "Jump",
        "HighJump",
        "StoreTP",
        "Damage",
        "Melt",
        "Enspell",
        "RangedDamage",
        "Accuracy",
        "PhysicalBlue",
    ),
    "WeaponSkillAccuracy": ("WeaponSkill", "Accuracy", "StoreTP", "RangedAccuracy", "Damage"),
    "WSElemental": ("WSElemental", "WeaponSkill", "MagicAccuracy"),
    "JobAbility": ("Enmity", "HighJump", "Jump", "Roll", "Waltz", "Flourish", "PetDamage", "Tank"),
    "HighJump": ("HighJump", "Jump", "WeaponSkill", "Accuracy", "Damage"),
    "SuperJump": ("SuperJump",),
    "Enmity": ("Enmity", "Tank", "MagicDefense", "FastCast"),
    "Waltz": ("Waltz", "Cure", "Evasion"),
    "HealingWaltz": ("HealingWaltz", "StatusRemoval", "JobAbility"),
    "Flourish": ("Flourish", "Steps", "Accuracy", "JobAbility"),
    "Steps": ("Accuracy", "Damage", "Evasion"),
    "Samba": ("Damage", "Accuracy", "StoreTP"),
    "Jig": ("Jig", "JobAbility"),
    "Maneuver": ("Maneuver", "JobAbility"),
    "SneakAttack": ("SneakAttack", "SATA", "JobAbility"),
    "TrickAttack": ("TrickAttack", "SATA", "JobAbility"),
    "SATA": ("SATA", "JobAbility"),
    "SpiritLink": ("SpiritLink", "WyvernHealing", "JobAbility"),
    "Mug": ("Mug",),
    "Reward": ("Reward", "JobAbility"),
    "Sentinel": ("Sentinel", "Enmity", "JobAbility"),
    "CoverActive": ("CoverActive",),
    "Rampart": ("Rampart", "JobAbility"),
    "ShieldBash": ("ShieldBash", "JobAbility"),
    "WardingCircle": ("WardingCircle", "JobAbility"),
    "AncientCircle": ("AncientCircle",),
    "ArcaneCircle": ("ArcaneCircle",),
    "HolyCircle": ("HolyCircle",),
    "Flee": ("Flee",),
    "Hide": ("Hide",),
    "Camouflage": ("Camouflage",),
    "Jump": ("Jump", "WeaponSkill", "Accuracy", "Damage"),
    "PetReady": ("PetDamage", "PetTank", "Damage"),
    "PetMagic": ("PetMagic", "PetDamage", "MagicAccuracy"),
    "PetTank": ("PetTank", "Survival", "Tank"),
    "Roll": ("Roll", "RangedAccuracy", "QuickDraw", "FastCast"),
}

EXACT_ONLY_SEMANTIC_SETS = {
    "AlacrityCelerity",
    "BlueLearning",
    "Chakra",
    "CombatSkillup",
    "SIRD_NIN",
    "ConserveMP",
    "Cursna",
    "CurePrecast",
    "ElementalPrecast",
    "HighJump",
    "SuperJump",
    "Jig",
    "HealingWaltz",
    "Maneuver",
    "Mug",
    "SATA",
    "SneakAttack",
    "SpiritLink",
    "TrickAttack",
    "CoverActive",
    "Reward",
    "Rampart",
    "ShieldBash",
    "Sentinel",
    "WardingCircle",
    "AncientCircle",
    "ArcaneCircle",
    "HolyCircle",
    "Flee",
    "Hide",
    "Camouflage",
    "Guard",
    "StatusResist",
    "CharmResist",
    "IndiDuration",
    "MagicBurst",
    "MagicSkillup",
    "QuickDrawAccuracy",
    "OccultAcumen",
    "Proc",
    "StatusRemoval",
    "Stoneskin",
}

for _element in ELEMENT_SUFFIXES:
    SEMANTIC_INTENTS[f"Elemental_{_element}"] = "Nuke"
    SEMANTIC_INTENTS[f"Weather_{_element}"] = "Nuke"
    SEMANTIC_INTENTS[f"Day_{_element}"] = "Nuke"
    SEMANTIC_SET_PREFERENCES[f"Elemental_{_element}"] = (
        f"Elemental_{_element}",
        "Nuke",
        "MagicalBlue",
        "GeoMagic",
        "QuickDraw",
        "MagicAccuracy",
    )
    SEMANTIC_SET_PREFERENCES[f"Weather_{_element}"] = (
        f"Weather_{_element}",
        f"Elemental_{_element}",
        "Nuke",
        "MagicalBlue",
        "GeoMagic",
        "QuickDraw",
        "MagicAccuracy",
        "FastCast",
    )
    SEMANTIC_SET_PREFERENCES[f"Day_{_element}"] = (
        f"Day_{_element}",
        f"Elemental_{_element}",
        "Nuke",
        "MagicalBlue",
        "GeoMagic",
        "QuickDraw",
        "MagicAccuracy",
        "FastCast",
    )


def lua_quote(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


def _blue_magic_route_key(value: str) -> str:
    text = re.sub(r"[^a-z0-9]+", " ", str(value).strip().lower())
    return re.sub(r"\s+", " ", text).strip()


def render_blue_magic_routes() -> str:
    lines = ["local blueMagicRoutes = {"]
    for spell_name, set_name in sorted(BLUE_MAGIC_ROUTES.items()):
        lines.append(f"    [{lua_quote(_blue_magic_route_key(spell_name))}] = {lua_quote(set_name)},")
    lines.append("};")
    return "\n".join(lines)


def _route_key_from_ws_set(suffix: str) -> str:
    text = str(suffix).strip().lower().replace("-", "_").replace(" ", "_")
    text = re.sub(r"[^a-z0-9_]+", "", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text


def _weapon_skill_route_entries(sets: Mapping[str, Mapping[str, str]]) -> tuple[tuple[str, str, bool], ...]:
    entries: list[tuple[str, str, bool]] = []
    for set_name in sorted(sets):
        if set_name.startswith("WSAcc_"):
            entries.append((_route_key_from_ws_set(set_name[6:]), set_name, True))
        elif set_name.startswith("WS_"):
            entries.append((_route_key_from_ws_set(set_name[3:]), set_name, False))
    return tuple(entries)


def render_resist_aliases() -> str:
    aliases: dict[str, str] = {
        "resoff": "",
        "resistoff": "",
        "nores": "",
        "clearres": "",
    }
    for element, set_name in RESIST_SEMANTIC_SETS.items():
        token = element.lower()
        aliases[f"{token}res"] = set_name
        aliases[f"{token}resist"] = set_name
        aliases[f"{token}resistance"] = set_name
    aliases.update(
        {
            "fres": "FireRes",
            "ires": "IceRes",
            "eres": "EarthRes",
            "ares": "WindRes",
            "wires": "WindRes",
            "wres": "WaterRes",
            "wares": "WaterRes",
            "lres": "LightningRes",
            "tres": "LightningRes",
            "bres": "IceRes",
            "sres": "EarthRes",
            "dres": "DarkRes",
            "statusres": "StatusResist",
            "statusresist": "StatusResist",
            "allstatusres": "StatusResist",
            "charmres": "CharmResist",
            "charmresist": "CharmResist",
        }
    )
    lines = ["profile.ResistAliases = {"]
    for alias, set_name in sorted(aliases.items()):
        lines.append(f"    {alias} = {lua_quote(set_name)},")
    lines.append("};")
    return "\n".join(lines)


def render_defense_aliases() -> str:
    aliases: dict[str, str] = {
        "clearoverride": "",
        "defenseoff": "",
        "defoff": "",
        "nooverride": "",
        "overrideoff": "",
        "dt": "Dt",
        "pdt": "PDT",
        "mdt": "MDT",
        "evasion": "Evasion",
        "eva": "Evasion",
        "safe": "Safe",
        "survival": "Survival",
        "tank": "Tank",
        "magicdefense": "MagicDefense",
        "mdef": "MagicDefense",
        "idlecombat": "IdleCombat",
        "idlenoncombat": "IdleNonCombat",
        "idlecity": "IdleCity",
    }
    lines = ["profile.DefenseAliases = {"]
    for alias, set_name in sorted(aliases.items()):
        lines.append(f"    {alias} = {lua_quote(set_name)},")
    lines.append("};")
    return "\n".join(lines)


def render_aahtacos_sam_state_fields(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    AutoThirdEye = false,
    AutoWarBuffs = false,
    AutoCombat = false,"""


def render_blue_learning_state_fields(enabled: bool) -> str:
    if not enabled:
        return ""
    return "    BlueLearningMode = false,"


def render_blue_learning_runtime_helpers(enabled: bool) -> str:
    if not enabled:
        return ""
    return """local function blueLearningModeOverlay()
    if state.BlueLearningMode ~= true then
        return {};
    end
    local source = sets.BlueLearning;
    if type(source) ~= 'table' or isClearSet(source) then
        return {};
    end
    local overlay = copyEquipSet(source);
    overlay.Main = nil;
    overlay.Sub = nil;
    overlay.Range = nil;
    overlay.Ammo = nil;
    return overlay;
end

local function applyBlueLearningModeOverlay(force)
    local overlay = blueLearningModeOverlay();
    if next(overlay) == nil then
        return false;
    end
    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(movementSafeEquipSet(overlay));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(movementSafeEquipSet(overlay));
        return true;
    end
    return false;
end"""


def render_blue_learning_command_branches(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    elseif command == 'learning' or command == 'learn' or command == 'bluelearn' or command == 'bluelearning' then
        if value == '' or value == 'status' then
            local available = type(sets.BlueLearning) == 'table' and not isClearSet(sets.BlueLearning);
            message('Blue Learning mode=' .. (state.BlueLearningMode and 'on' or 'off') .. '; available=' .. (available and 'yes' or 'no') .. '; use /lac fwd learning on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets.BlueLearning) ~= 'table' or isClearSet(sets.BlueLearning) then
                state.BlueLearningMode = false;
                message('Blue Learning mode unavailable: no resolved BlueLearning equipment set.');
                return;
            end
            state.BlueLearningMode = true;
            equipDefaultForPlayer(getPlayer(), true);
            message('Blue Learning mode=on. Learning gear will remain active through mob-death resolution.');
        elseif value == 'off' then
            state.BlueLearningMode = false;
            equipDefaultForPlayer(getPlayer(), true);
            message('Blue Learning mode=off. Normal gear restored.');
        else
            message('Unknown learning option. Use /lac fwd learning on|off|status.');
        end"""


def render_guard_runtime_helpers(enabled: bool) -> str:
    if not enabled:
        return ""
    return """local guardSkillJobs = {
    ['MNK'] = true,
    ['PUP'] = true,
};

local function guardJobAbbr(value)
    local numeric = tonumber(value);
    if numeric and jobIdToAbbr[numeric] then
        return jobIdToAbbr[numeric];
    end
    return string.upper(tostring(value or ''));
end

function profile.OddLuaRuntime.GuardSkillState(player)
    player = player or getPlayer();
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player context unavailable';
    end

    local mainJob = guardJobAbbr(player.MainJob or player.mainJob);
    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
        or player.MainLevel
        or player.mainLevel
    ) or 0;
    if mainLevel < 1 or mainLevel > 75 then
        return false, 'main level outside CatsEye 1-75';
    end
    if guardSkillJobs[mainJob] == true then
        return true, 'native ' .. mainJob;
    end

    local subJob = guardJobAbbr(player.SubJob or player.subJob or player.Subjob or player.subjob);
    local subLevel = tonumber(
        player.SubJobSync
        or player.subJobSync
        or player.SubJobLevel
        or player.subJobLevel
        or player.SubLevel
        or player.subLevel
    ) or 0;
    local effectiveSubCap = math.min(37, math.floor(mainLevel / 2));
    if guardSkillJobs[subJob] == true and subLevel >= 1 and subLevel <= effectiveSubCap then
        return true, 'subjob ' .. subJob .. tostring(subLevel);
    end
    return false, 'current main/subjob has no Guard skill';
end

function profile.OddLuaRuntime.GuardEligibility(player)
    player = player or getPlayer();
    if type(sets.Guard) ~= 'table' or isClearSet(sets.Guard) then
        return false, 'no resolved Guard equipment set';
    end
    local hasSkill, skillReason = profile.OddLuaRuntime.GuardSkillState(player);
    if hasSkill ~= true then
        return false, skillReason;
    end
    if not isEngaged(player) then
        return false, 'not engaged';
    end
    if profile.OddLuaRuntime.HasIncapacitatingStatus() ~= false then
        return false, 'incapacitating status active or unknown';
    end
    if not gData or not gData.GetEquipment then
        return false, 'equipment state unavailable';
    end
    local ok, equipment = pcall(gData.GetEquipment);
    if not ok or type(equipment) ~= 'table' then
        return false, 'equipment state unavailable';
    end
    local main = equipment.Main or equipment.main;
    if main == nil then
        return true, 'eligible while unarmed';
    end
    if type(main) ~= 'table' then
        return false, 'main weapon state unavailable';
    end
    local resource = main.Resource or main.resource;
    if type(resource) ~= 'table' then
        return false, 'main weapon resource unavailable';
    end
    local skill = tonumber(resource.Skill or resource.skill);
    if skill ~= 1 then
        return false, 'main weapon is not Hand-to-Hand';
    end
    return true, 'eligible with Hand-to-Hand';
end

function profile.OddLuaRuntime.ShouldEquipGuard(player)
    local eligible = profile.OddLuaRuntime.GuardEligibility(player);
    return eligible == true;
end"""


def render_guard_command_branches(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    elseif command == 'guard' then
        if value == '' or value == 'status' then
            local eligible, reason = profile.OddLuaRuntime.GuardEligibility(getPlayer());
            local armed = state.IdleOverrideSet == 'Guard';
            message('Guard mode=' .. (armed and 'armed' or 'off') .. '; eligible=' .. (eligible and 'yes' or 'no') .. '; reason=' .. tostring(reason) .. '; use /lac fwd guard on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets.Guard) ~= 'table' or isClearSet(sets.Guard) then
                message('Guard mode unavailable: no resolved Guard equipment set.');
                return;
            end
            local hasSkill, skillReason = profile.OddLuaRuntime.GuardSkillState(getPlayer());
            if hasSkill ~= true then
                message('Guard mode unavailable: ' .. tostring(skillReason) .. '.');
                return;
            end
            state.IdleOverrideSet = 'Guard';
            local eligible, reason = profile.OddLuaRuntime.GuardEligibility(getPlayer());
            equipDefaultForPlayer(getPlayer(), true);
            message('Guard mode=armed; active=' .. (eligible and 'yes' or 'no') .. '; reason=' .. tostring(reason) .. '.');
            return;
        elseif value == 'off' then
            if state.IdleOverrideSet ~= 'Guard' then
                message('Guard mode=off; override=' .. profile.OverrideStateText() .. ' unchanged.');
                return;
            end
            state.IdleOverrideSet = nil;
            equipDefaultForPlayer(getPlayer(), true);
            message('Guard mode=off. Normal combat/idle gear restored.');
            return;
        else
            message('Unknown guard option. Use /lac fwd guard on|off|status.');
            return;
        end"""


def render_caster_sustain_state_fields(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    CasterSustainMode = false,
    CasterSustainActive = false,
    CasterSustainDefaultRouting = false,"""


def render_caster_sustain_runtime_helpers(enabled: bool) -> str:
    if not enabled:
        return ""
    return """profile.OddLuaRuntime.CasterSustainJobs = {
    BLM = true,
    BRD = true,
    GEO = true,
    RDM = true,
    SCH = true,
    SMN = true,
    WHM = true,
};

function profile.OddLuaRuntime.CasterSustainJobState(player)
    player = player or getPlayer();
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player context unavailable';
    end

    local mainJobValue = player.MainJob or player.mainJob;
    local mainJobId = tonumber(mainJobValue);
    local mainJob = string.upper(tostring(mainJobValue or ''));
    if mainJobId and jobIdToAbbr[mainJobId] then
        mainJob = jobIdToAbbr[mainJobId];
    end
    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
        or player.MainLevel
        or player.mainLevel
    );
    if mainLevel ~= 75 then
        return false, 'Numen Staff sustain requires CatsEye main level 75';
    end
    if profile.OddLuaRuntime.CasterSustainJobs[mainJob] ~= true then
        return false, 'main job is not an eligible Numen Staff caster';
    end
    return true, mainJob .. tostring(mainLevel);
end

function profile.OddLuaRuntime.CasterSustainEligibility(player)
    if state.CasterSustainMode ~= true then
        return false, 'mode off';
    end
    if type(sets.CasterSustain) ~= 'table' or isClearSet(sets.CasterSustain) then
        return false, 'no resolved CasterSustain equipment set';
    end

    player = player or getPlayer();
    local eligibleJob, jobReason = profile.OddLuaRuntime.CasterSustainJobState(player);
    if eligibleJob ~= true then
        return false, jobReason;
    end
    if state.WarpRingLocked == true then
        return false, 'warp ring flow active';
    end
    if state.IdleOverrideSet ~= nil and state.IdleOverrideSet ~= '' then
        return false, 'defensive override active';
    end
    if state.Playstyle == 'Craft' then
        return false, 'craft active';
    end
    if not isEngaged(player) then
        return false, 'weapon not drawn';
    end
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    if mp == nil or mp <= 0 then
        return false, 'MP unavailable or empty';
    end
    if profile.OddLuaRuntime.DangerousStatusState() ~= false
        or profile.OddLuaRuntime.HasWeakness() ~= false
        or profile.OddLuaRuntime.HasIncapacitatingStatus() ~= false
    then
        return false, 'status unsafe or unavailable';
    end
    if shouldEquipOvertDefense(player) ~= nil then
        return false, 'overt defense active';
    end
    if isEmergencyHp(player) and firstAvailableDefensiveSet() ~= nil then
        return false, 'emergency HP defense active';
    end
    return true, jobReason .. '; engaged; MP=' .. tostring(mp);
end

function profile.OddLuaRuntime.ShouldEquipCasterSustain(player)
    local eligible = profile.OddLuaRuntime.CasterSustainEligibility(player);
    return eligible == true;
end

function profile.OddLuaRuntime.CasterSustainModeOverlay(player)
    if state.CasterSustainDefaultRouting ~= true
        or profile.OddLuaRuntime.ShouldEquipCasterSustain(player) ~= true
    then
        return {};
    end
    local overlay = copyEquipSet(sets.CasterSustain);
    overlay.Sub = 'remove';
    return overlay;
end

function profile.OddLuaRuntime.RunWithCasterSustainWeaponUnlock(callback)
    if type(callback) ~= 'function' then
        return false, false;
    end

    local previousWeaponLockEnabled = nil;
    local weaponLockChanged = false;
    if scale and scale.Status and scale.SetWeaponLockEnabled then
        local statusOk, status = pcall(scale.Status);
        if statusOk == true and type(status) == 'table'
            and type(status.weaponLockEnabled) == 'boolean'
        then
            previousWeaponLockEnabled = status.weaponLockEnabled;
            weaponLockChanged = pcall(scale.SetWeaponLockEnabled, false);
        end
    end

    local ok, result = pcall(callback);
    if weaponLockChanged == true then
        pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    end
    return ok, result;
end

function profile.OddLuaRuntime.ApplyCasterSustainOverlay()
    local overlay = profile.OddLuaRuntime.CasterSustainModeOverlay(getPlayer());
    if next(overlay) == nil then
        state.CasterSustainActive = false;
        return false;
    end

    local ok, equipped = profile.OddLuaRuntime.RunWithCasterSustainWeaponUnlock(function()
        if gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(movementSafeEquipSet(overlay));
            return true;
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(movementSafeEquipSet(overlay));
            return true;
        end
        return false;
    end);
    state.CasterSustainActive = ok == true and equipped == true;
    return state.CasterSustainActive;
end"""


def render_caster_sustain_command_branches(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    elseif command == 'sustain' or command == 'castersustain' or command == 'numen' then
        if value == '' or value == 'status' then
            local eligible, reason = profile.OddLuaRuntime.CasterSustainEligibility(getPlayer());
            local available = type(sets.CasterSustain) == 'table' and not isClearSet(sets.CasterSustain);
            message('Caster Sustain mode=' .. (state.CasterSustainMode and 'armed' or 'off') .. '; active=' .. (state.CasterSustainActive and 'yes' or 'no') .. '; eligible=' .. (eligible and 'yes' or 'no') .. '; available=' .. (available and 'yes' or 'no') .. '; reason=' .. tostring(reason) .. '; use /lac fwd sustain on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets.CasterSustain) ~= 'table' or isClearSet(sets.CasterSustain) then
                state.CasterSustainMode = false;
                equipDefaultForPlayer(getPlayer(), true);
                message('Caster Sustain mode unavailable: no resolved CasterSustain equipment set.');
                return;
            end
            local player = getPlayer();
            local eligibleJob, jobReason = profile.OddLuaRuntime.CasterSustainJobState(player);
            if eligibleJob ~= true then
                state.CasterSustainMode = false;
                equipDefaultForPlayer(player, true);
                message('Caster Sustain mode unavailable: ' .. tostring(jobReason) .. '.');
                return;
            end
            state.CasterSustainMode = true;
            local eligible, reason = profile.OddLuaRuntime.CasterSustainEligibility(player);
            equipDefaultForPlayer(player, true);
            message('Caster Sustain mode=armed; active=' .. (state.CasterSustainActive and 'yes' or 'no') .. '; eligible=' .. (eligible and 'yes' or 'no') .. '; reason=' .. tostring(reason) .. '. This explicit mode deliberately swaps Main to Numen Staff and may reset TP.');
            return;
        elseif value == 'off' then
            state.CasterSustainMode = false;
            equipDefaultForPlayer(getPlayer(), true);
            message('Caster Sustain mode=off. Normal combat/idle gear restored.');
            return;
        else
            message('Unknown sustain option. Use /lac fwd sustain on|off|status.');
            return;
        end"""


def render_occult_acumen_state_fields(enabled: bool) -> str:
    if not enabled:
        return ""
    return "    OccultAcumenMode = false,"


def render_occult_acumen_runtime_helpers(enabled: bool) -> str:
    if not enabled:
        return ""
    return """local occultAcumenMainTraitLevels = {
    ['BLM'] = 60,
    ['DRK'] = 37,
    ['SCH'] = 60,
};
local occultAcumenElementalNoDamage = {
    ['burn'] = true,
    ['choke'] = true,
    ['drown'] = true,
    ['frost'] = true,
    ['rasp'] = true,
    ['shock'] = true,
};
local occultAcumenDarkDamageSpells = {
    ['bio'] = true,
    ['bio ii'] = true,
    ['bio iii'] = true,
    ['bio_ii'] = true,
    ['bio_iii'] = true,
    ['drain'] = true,
    ['drain ii'] = true,
    ['drain_ii'] = true,
    ['kaustra'] = true,
};

local function occultAcumenJobAbbr(value)
    local numeric = tonumber(value);
    if numeric and jobIdToAbbr[numeric] then
        return jobIdToAbbr[numeric];
    end
    return string.upper(tostring(value or ''));
end

function profile.OddLuaRuntime.HasOccultAcumenTrait()
    local player = getPlayer();
    if type(player) ~= 'table' then
        return false;
    end

    local mainJob = occultAcumenJobAbbr(player.MainJob or player.mainJob);
    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
        or player.MainLevel
        or player.mainLevel
    ) or 0;
    if mainLevel < 1 or mainLevel > 75 then
        return false;
    end
    local mainRequired = occultAcumenMainTraitLevels[mainJob];
    if mainRequired and mainLevel >= mainRequired then
        return true;
    end

    local subJob = occultAcumenJobAbbr(player.SubJob or player.subJob or player.Subjob or player.subjob);
    local subLevel = tonumber(
        player.SubJobSync
        or player.subJobSync
        or player.SubJobLevel
        or player.subJobLevel
        or player.SubLevel
        or player.subLevel
    ) or 0;
    return subJob == 'DRK' and subLevel == 37;
end

function profile.OddLuaRuntime.ShouldEquipOccultAcumen(action)
    if state.OccultAcumenMode ~= true then
        return false;
    end
    if type(sets.OccultAcumen) ~= 'table' or isClearSet(sets.OccultAcumen) then
        return false;
    end
    if not profile.OddLuaRuntime.HasOccultAcumenTrait() or not action then
        return false;
    end
    if hasBuff('Meikyo Shisui') then
        return false;
    end

    local skill = normalize(action.Skill or action.skill or action.SkillName or action.skillName);
    local name = normalize(action.Name or action.name);
    if skill == 'elemental magic' then
        return occultAcumenElementalNoDamage[name] ~= true;
    elseif skill == 'dark magic' then
        return occultAcumenDarkDamageSpells[name] == true;
    end
    return false;
end"""


def render_occult_acumen_command_branches(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    elseif command == 'acumen' or command == 'occult' or command == 'occultacumen' then
        if value == '' or value == 'status' then
            local available = type(sets.OccultAcumen) == 'table' and not isClearSet(sets.OccultAcumen);
            local traitAvailable = profile.OddLuaRuntime.HasOccultAcumenTrait();
            message('Occult Acumen mode=' .. (state.OccultAcumenMode and 'on' or 'off') .. '; available=' .. (available and 'yes' or 'no') .. '; trait=' .. (traitAvailable and 'yes' or 'no') .. '; use /lac fwd acumen on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets.OccultAcumen) ~= 'table' or isClearSet(sets.OccultAcumen) then
                state.OccultAcumenMode = false;
                message('Occult Acumen mode unavailable: no resolved OccultAcumen equipment set.');
                return;
            end
            if not profile.OddLuaRuntime.HasOccultAcumenTrait() then
                state.OccultAcumenMode = false;
                message('Occult Acumen mode unavailable: current main/subjob lacks the CatsEye Occult Acumen trait.');
                return;
            end
            state.OccultAcumenMode = true;
            message('Occult Acumen mode=on. Eligible damaging Elemental and Dark Magic will use TP-return gear at resolution.');
        elseif value == 'off' then
            state.OccultAcumenMode = false;
            message('Occult Acumen mode=off. Normal spell-resolution gear remains active.');
        else
            message('Unknown acumen option. Use /lac fwd acumen on|off|status.');
        end"""


def render_explicit_gear_mode_state_fields(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    ExplicitGearMode = 'off',
    ExplicitGearModeDefaultRouting = false,"""


def render_explicit_gear_mode_runtime_helpers(enabled: bool) -> str:
    if not enabled:
        return ""
    return """local explicitGearModeSetNames = {
    combat = 'CombatSkillup',
    magic = 'MagicSkillup',
    proc = 'Proc',
};

local function explicitGearModeSetAvailable(mode)
    local setName = explicitGearModeSetNames[normalize(mode)];
    return setName ~= nil
        and type(sets[setName]) == 'table'
        and not isClearSet(sets[setName]);
end

function profile.OddLuaRuntime.ExplicitGearModeAvailabilityText()
    local parts = {};
    for _, mode in ipairs({ 'combat', 'magic', 'proc' }) do
        parts[#parts + 1] = mode .. '=' .. (explicitGearModeSetAvailable(mode) and 'yes' or 'no');
    end
    return table.concat(parts, ',');
end

function profile.OddLuaRuntime.ExplicitGearModeOverlay(surface)
    local mode = normalize(state.ExplicitGearMode);
    if surface == 'default'
        and (mode == 'combat' or mode == 'proc')
        and not isEngaged(getPlayer())
    then
        return {};
    end
    local active = (surface == 'default' and (mode == 'combat' or mode == 'proc'))
        or (surface == 'midcast' and mode == 'magic');
    if active ~= true or explicitGearModeSetAvailable(mode) ~= true then
        return {};
    end

    local overlay = copyEquipSet(sets[explicitGearModeSetNames[mode]]);
    if mode == 'proc' then
        -- Proc is intentionally a Main-only weapon decision. Fail closed if a
        -- malformed generated set ever grows armor or secondary weapon slots.
        for _, slot in ipairs(equipmentSlots) do
            if slot ~= 'Main' then
                overlay[slot] = nil;
            end
        end
    else
        overlay.Main = nil;
        overlay.Sub = nil;
        overlay.Range = nil;
        overlay.Ammo = nil;
    end
    return overlay;
end

function profile.OddLuaRuntime.ApplyExplicitGearMode(surface, force)
    local overlay = profile.OddLuaRuntime.ExplicitGearModeOverlay(surface);
    if next(overlay) == nil then
        return false;
    end
    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(movementSafeEquipSet(overlay));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(movementSafeEquipSet(overlay));
        return true;
    end
    return false;
end"""


def render_explicit_gear_mode_command_branches(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    elseif command == 'mode' or command == 'gearmode' or command == 'skillup' or command == 'proc' then
        local selectedMode = value;
        if command == 'proc' and selectedMode == '' then
            selectedMode = 'proc';
        elseif command == 'skillup' and selectedMode ~= 'magic' then
            selectedMode = 'combat';
        end
        if selectedMode == '' or selectedMode == 'status' then
            message('Gear mode=' .. tostring(state.ExplicitGearMode)
                .. '; available=' .. profile.OddLuaRuntime.ExplicitGearModeAvailabilityText()
                .. '; use /lac fwd mode combat|magic|proc|off|status.');
            return;
        end
        if selectedMode == 'combatskillup' or selectedMode == 'combat_skillup' then
            selectedMode = 'combat';
        elseif selectedMode == 'magicskillup' or selectedMode == 'magic_skillup' then
            selectedMode = 'magic';
        end
        if selectedMode == 'off' then
            state.ExplicitGearMode = 'off';
            equipDefaultForPlayer(getPlayer(), true);
            message('Gear mode=off. Normal combat and spell gear restored.');
            return;
        end
        if explicitGearModeSetNames[selectedMode] == nil then
            message('Unknown gear mode. Use /lac fwd mode combat|magic|proc|off|status.');
            return;
        end
        if explicitGearModeSetAvailable(selectedMode) ~= true then
            state.ExplicitGearMode = 'off';
            equipDefaultForPlayer(getPlayer(), true);
            message('Gear mode unavailable: no resolved ' .. tostring(explicitGearModeSetNames[selectedMode]) .. ' equipment set. Mode remains off.');
            return;
        end
        state.ExplicitGearMode = selectedMode;
        equipDefaultForPlayer(getPlayer(), true);
        if selectedMode == 'proc' then
            message('Gear mode=proc. This explicit choice deliberately swaps Main and may reset TP; no action is automated.');
        elseif selectedMode == 'combat' then
            message('Gear mode=combat. Owned combat skill-gain gear overlays only while engaged.');
        else
            message('Gear mode=magic. Owned magic skill-gain gear overlays only at spell resolution.');
        end"""


def render_aahtacos_sam_locals(enabled: bool) -> str:
    if not enabled:
        return ""
    return """profile.OddLuaSamRuntime = {
    ThirdEyeCommand = '/ja "Third Eye" <me>',
    AutoThirdEyeUnknownRetrySeconds = 30,
    AutoThirdEyeReadyRetrySeconds = 3,
    AutoThirdEyeRecastPollSeconds = 1,
    AutoWarBuffUnknownRetrySeconds = 30,
    AutoWarBuffReadyRetrySeconds = 3,
    LastAutoThirdEyeAt = -9999,
    LastAutoWarBuffAt = {
        Berserk = -9999,
        Warcry = -9999,
    },
    LastThirdEyeRecastCheckAt = -9999,
    LastThirdEyeOnCooldown = nil,
};

profile.OddLuaSamManualAbilities = {
    meditate = { label = 'Meditate', level = 30, buff = 'Meditate', command = '/ja "Meditate" <me>' },
    thirdeye = { label = 'Third Eye', level = 15, buff = 'Third Eye', command = '/ja "Third Eye" <me>' },
};

profile.OddLuaSamBinds = {
    { key = '^1', binding = '/bind ^1 /ws "Tachi: Gekko" <t>', unbind = '/unbind ^1' },
    { key = '^2', binding = '/bind ^2 /ws "Tachi: Yukikaze" <t>', unbind = '/unbind ^2' },
    { key = '^3', binding = '/bind ^3 /ws "Tachi: Shoha" <t>', unbind = '/unbind ^3' },
    { key = '^4', binding = '/bind ^4 /ws "Tachi: Kaiten" <t>', unbind = '/unbind ^4' },
    { key = '^5', binding = '/bind ^5 /lac fwd sekkagekko', unbind = '/unbind ^5' },
    { key = '^6', binding = '/bind ^6 /lac fwd konzenshoha', unbind = '/unbind ^6' },
    { key = '!1', binding = '/bind !1 /ja "Hasso" <me>', unbind = '/unbind !1' },
    { key = '!2', binding = '/bind !2 /lac fwd seiganeye', unbind = '/unbind !2' },
    { key = '!3', binding = '/bind !3 /lac fwd meditate', unbind = '/unbind !3' },
    { key = '!4', binding = '/bind !4 /lac fwd warbuffs', unbind = '/unbind !4' },
    { key = '!5', binding = '/bind !5 /ja "Provoke" <t>', unbind = '/unbind !5' },
    { key = '!6', binding = '/bind !6 /lac fwd thirdeye', unbind = '/unbind !6' },
    { key = '!7', binding = '/bind !7 /lac fwd autoeye', unbind = '/unbind !7' },
    { key = '!8', binding = '/bind !8 /lac fwd autowar', unbind = '/unbind !8' },
    { key = '!9', binding = '/bind !9 /lac fwd autocombat', unbind = '/unbind !9' },
};

profile.OddLuaSamWarBuffCommands = {
    { ability = 'Berserk', buff = 'Berserk', command = '/ja "Berserk" <me>', delay = 1 },
    { ability = 'Warcry', buff = 'Warcry', command = '/ja "Warcry" <me>', delay = 3 },
};"""


def render_aahtacos_sam_helpers(enabled: bool) -> str:
    if not enabled:
        return ""
    return """local function samPrintHelp()
    message('Ctrl+1 Gekko, Ctrl+2 Yukikaze, Ctrl+3 Shoha, Ctrl+4 Kaiten, Ctrl+5 Sekkanoki+Gekko, Ctrl+6 Konzen+Shoha.');
    message('Alt+1 Hasso, Alt+2 Seigan+Third Eye, Alt+3 Meditate, Alt+4 Berserk+Warcry, Alt+5 Provoke, Alt+6 Third Eye.');
    message('Alt+7 Auto Third Eye, Alt+8 Auto WAR buffs, Alt+9 Auto combat master.');
    message('Commands: style/status/subjob/warp/help/meditate/thirdeye/sekkagekko/konzenshoha/seiganeye/warbuffs/autoeye/autowar/autocombat/scale status.');
end

local function setBooleanMode(key, value)
    local valueText = normalize(value);
    if valueText == 'on' or valueText == 'enable' or valueText == 'enabled' then
        state[key] = true;
    elseif valueText == 'off' or valueText == 'disable' or valueText == 'disabled' then
        state[key] = false;
    else
        state[key] = not state[key];
    end
    return state[key];
end

local function hasBuff(name)
    return getBuffCount(name) > 0;
end

local function abilityNameMatches(resource, abilityName)
    if type(resource) ~= 'table' then
        return false;
    end

    local expected = normalize(abilityName);
    local names = resource.Name;
    if type(names) == 'table' then
        for _, name in pairs(names) do
            if normalize(name) == expected then
                return true;
            end
        end
    elseif normalize(names) == expected then
        return true;
    end

    return false;
end

local function isAbilityOnCooldown(abilityName)
    if not AshitaCore or not AshitaCore.GetMemoryManager or not AshitaCore.GetResourceManager then
        return nil;
    end

    local okRecast, recast = pcall(function()
        return AshitaCore:GetMemoryManager():GetRecast();
    end);
    local okResources, resources = pcall(function()
        return AshitaCore:GetResourceManager();
    end);
    if not okRecast or not recast or not okResources or not resources or not resources.GetAbilityByTimerId then
        return nil;
    end

    for index = 0, 31 do
        local okId, id = pcall(function()
            return recast:GetAbilityTimerId(index);
        end);
        local okTimer, timer = pcall(function()
            return recast:GetAbilityTimer(index);
        end);
        if okId and okTimer and type(id) == 'number' and type(timer) == 'number' and timer > 0 then
            local okAbility, ability = pcall(function()
                return resources:GetAbilityByTimerId(id);
            end);
            if okAbility and abilityNameMatches(ability, abilityName) then
                return true;
            end
        end
    end

    return false;
end

local function isThirdEyeOnCooldown()
    local now = os.clock();
    if now - profile.OddLuaSamRuntime.LastThirdEyeRecastCheckAt < profile.OddLuaSamRuntime.AutoThirdEyeRecastPollSeconds then
        return profile.OddLuaSamRuntime.LastThirdEyeOnCooldown;
    end

    profile.OddLuaSamRuntime.LastThirdEyeRecastCheckAt = now;
    profile.OddLuaSamRuntime.LastThirdEyeOnCooldown = isAbilityOnCooldown('Third Eye');
    return profile.OddLuaSamRuntime.LastThirdEyeOnCooldown;
end

function profile.OddLuaRuntime.SamMainJobLevel(player)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return nil, 'player context unavailable';
    end

    local mainJobValue = player.MainJob or player.mainJob;
    local mainJobId = tonumber(mainJobValue);
    local mainJob = string.upper(tostring(mainJobValue or ''));
    if mainJobId and jobIdToAbbr[mainJobId] then
        mainJob = jobIdToAbbr[mainJobId];
    end
    if mainJob ~= 'SAM' then
        return nil, 'current main job is not SAM';
    end

    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
        or player.MainLevel
        or player.mainLevel
    );
    if mainLevel == nil then
        return nil, 'main-job level unavailable';
    end
    if mainLevel > 75 then
        return nil, 'main-job level exceeds the CatsEye level-75 cap';
    end
    return mainLevel, 'ready';
end

function profile.OddLuaRuntime.TrySamManualAbility(key)
    local spec = profile.OddLuaSamManualAbilities[key];
    if type(spec) ~= 'table' then
        message('Unknown guarded SAM ability.');
        return false;
    end

    local player = getPlayer();
    local mainLevel, reason = profile.OddLuaRuntime.SamMainJobLevel(player);
    if mainLevel == nil or mainLevel < spec.level then
        if mainLevel ~= nil then
            reason = 'requires SAM' .. tostring(spec.level);
        end
        message('SAM ' .. spec.label .. ' unavailable: ' .. tostring(reason) .. '.');
        return false;
    end
    if profile.OddLuaRuntime.HasIncapacitatingStatus() ~= false
        or profile.OddLuaRuntime.HasAmnesia() ~= false then
        message('SAM ' .. spec.label .. ' blocked: incapacitation or Amnesia is active or unknown.');
        return false;
    end

    local count, known = getBuffCount(spec.buff);
    if known ~= true then
        message('SAM ' .. spec.label .. ' blocked: buff state unavailable.');
        return false;
    end
    if count > 0 then
        message('SAM ' .. spec.label .. ' skipped: ' .. spec.buff .. ' is already active.');
        return false;
    end

    local onCooldown = isAbilityOnCooldown(spec.label);
    if onCooldown == nil then
        message('SAM ' .. spec.label .. ' blocked: recast state unavailable.');
        return false;
    end
    if onCooldown == true then
        message('SAM ' .. spec.label .. ' not ready: ability is on recast.');
        return false;
    end

    if queueTypedCommand(spec.command, 1) ~= true then
        message('SAM ' .. spec.label .. ' command unavailable.');
        return false;
    end
    if key == 'thirdeye' then
        profile.OddLuaSamRuntime.LastAutoThirdEyeAt = os.clock();
    end
    message('SAM ' .. spec.label .. ' queued.');
    return true;
end

local function queueSamCommands(label, commands, automatic)
    for _, command in ipairs(commands or {}) do
        local function dispatch(delay)
            if automatic == true
                and profile.OddLuaRuntime.CanIssueAutomaticJobAbility(getPlayer()) ~= true then
                if command.ability and profile.OddLuaSamRuntime.LastAutoWarBuffAt[command.ability] ~= nil then
                    profile.OddLuaSamRuntime.LastAutoWarBuffAt[command.ability] = -9999;
                end
                return false;
            end
            local queued = queueTypedCommand(command.text, delay);
            if queued ~= true and automatic == true
                and command.ability and profile.OddLuaSamRuntime.LastAutoWarBuffAt[command.ability] ~= nil then
                profile.OddLuaSamRuntime.LastAutoWarBuffAt[command.ability] = -9999;
            end
            return queued == true;
        end
        if command.delay and command.delay > 1 and scheduleTask(command.delay, function()
            dispatch(1);
        end) then
            -- Scheduled through ashita.tasks.once.
        else
            dispatch(command.delay or 1);
        end
        if command.text == profile.OddLuaSamRuntime.ThirdEyeCommand then
            profile.OddLuaSamRuntime.LastAutoThirdEyeAt = os.clock();
        end
    end
    message(label);
end

local function maybeAutoThirdEye(player)
    if state.AutoCombat ~= true or state.AutoThirdEye ~= true then
        return;
    end
    if profile.OddLuaRuntime.CanIssueAutomaticJobAbility(player) ~= true then
        return;
    end
    if not hasBuff('Seigan') then
        return;
    end
    if hasBuff('Third Eye') then
        return;
    end

    local onCooldown = isThirdEyeOnCooldown();
    if onCooldown == true then
        return;
    end

    local now = os.clock();
    local retrySeconds = profile.OddLuaSamRuntime.AutoThirdEyeUnknownRetrySeconds;
    if onCooldown == false then
        retrySeconds = profile.OddLuaSamRuntime.AutoThirdEyeReadyRetrySeconds;
    end
    if now - profile.OddLuaSamRuntime.LastAutoThirdEyeAt < retrySeconds then
        return;
    end

    queueSamCommands('Seigan active; Third Eye queued.', {
        { delay = 1, text = profile.OddLuaSamRuntime.ThirdEyeCommand },
    }, true);
end

local function maybeAutoWarBuffs(player)
    if state.AutoCombat ~= true or state.AutoWarBuffs ~= true then
        return;
    end
    if profile.OddLuaRuntime.CanIssueAutomaticJobAbility(player) ~= true then
        return;
    end

    local now = os.clock();
    local commands = {};
    for _, buff in ipairs(profile.OddLuaSamWarBuffCommands) do
        if not hasBuff(buff.buff) then
            local onCooldown = isAbilityOnCooldown(buff.ability);
            if onCooldown ~= true then
                local retrySeconds = profile.OddLuaSamRuntime.AutoWarBuffUnknownRetrySeconds;
                if onCooldown == false then
                    retrySeconds = profile.OddLuaSamRuntime.AutoWarBuffReadyRetrySeconds;
                end
                if now - profile.OddLuaSamRuntime.LastAutoWarBuffAt[buff.ability] >= retrySeconds then
                    commands[#commands + 1] = {
                        ability = buff.ability,
                        delay = buff.delay,
                        text = buff.command,
                    };
                    profile.OddLuaSamRuntime.LastAutoWarBuffAt[buff.ability] = now;
                end
            end
        end
    end

    if #commands > 0 then
        queueSamCommands('Auto WAR buffs queued.', commands, true);
    end
end"""


def render_aahtacos_sam_onload(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    for _, bind in ipairs(profile.OddLuaSamBinds) do
        queueTypedCommand(bind.binding, -1);
    end
    samPrintHelp();"""


def render_aahtacos_sam_onunload(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    for _, bind in ipairs(profile.OddLuaSamBinds) do
        queueTypedCommand(bind.unbind, -1);
    end"""


def render_aahtacos_sam_command_branches(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    elseif command == 'samhelp' then
        samPrintHelp();
    elseif command == 'sekkagekko' then
        queueSamCommands('Sekkanoki + Tachi: Gekko queued.', {
            { delay = 1, text = '/ja "Sekkanoki" <me>' },
            { delay = 3, text = '/ws "Tachi: Gekko" <t>' },
        });
    elseif command == 'konzenshoha' then
        queueSamCommands('Konzen-ittai + Tachi: Shoha queued.', {
            { delay = 1, text = '/ja "Konzen-ittai" <me>' },
            { delay = 3, text = '/ws "Tachi: Shoha" <t>' },
        });
    elseif command == 'seiganeye' then
        queueSamCommands('Seigan + Third Eye queued.', {
            { delay = 1, text = '/ja "Seigan" <me>' },
            { delay = 3, text = '/lac fwd thirdeye' },
        });
    elseif command == 'warbuffs' then
        queueSamCommands('Berserk + Warcry queued.', {
            { delay = 1, text = '/ja "Berserk" <me>' },
            { delay = 3, text = '/ja "Warcry" <me>' },
        });
    elseif command == 'meditate' then
        profile.OddLuaRuntime.TrySamManualAbility('meditate');
    elseif command == 'thirdeye' or command == 'third_eye' then
        profile.OddLuaRuntime.TrySamManualAbility('thirdeye');
    elseif command == 'autoeye' or command == 'autothirdeye' then
        setBooleanMode('AutoThirdEye', value);
        message('SAM auto Third Eye: ' .. (state.AutoThirdEye and 'on' or 'off'));
    elseif command == 'autowar' or command == 'autowarbuffs' or command == 'autobuffs' then
        setBooleanMode('AutoWarBuffs', value);
        message('SAM auto WAR buffs: ' .. (state.AutoWarBuffs and 'on' or 'off'));
    elseif command == 'autocombat' or command == 'autoincombat' then
        setBooleanMode('AutoCombat', value);
        message('SAM auto combat master: ' .. (state.AutoCombat and 'on' or 'off'));"""


def render_handle_default_body(sam_controls_enabled: bool) -> str:
    if not sam_controls_enabled:
        return """    equipDefaultForPlayer(getPlayer(), false);"""
    return """    local player = getPlayer();
    maybeAutoThirdEye(player);
    maybeAutoWarBuffs(player);
    equipDefaultForPlayer(player, false);"""


def render_lua_table(name: str, values: dict[str, str], remove_slots: Iterable[str] = tuple()) -> str:
    forced_removes = set(remove_slots)
    lines = [f"    {name} = {{"]
    if not values and not forced_removes:
        if name != "Resting":
            for slot in SLOT_ORDER:
                lines.append(f"        {slot} = 'remove',")
    else:
        for slot in SLOT_ORDER:
            if slot in forced_removes:
                lines.append(f"        {slot} = 'remove',")
                continue
            item = values.get(slot)
            if item:
                lines.append(f"        {slot} = {lua_quote(item)},")
    lines.append("    },")
    return "\n".join(lines)


def _number_row_slots(number_row_palette: Mapping[str, object]) -> tuple[dict[str, str], ...]:
    bindings = number_row_palette.get("bindings")
    rows: list[dict[str, str]] = []
    if isinstance(bindings, list):
        for binding in bindings:
            if not isinstance(binding, dict):
                continue
            key = str(binding.get("key", "")).strip()
            display_key = str(binding.get("displayKey", key)).strip()
            label = str(binding.get("label", "")).strip()
            literal = str(binding.get("literal", "")).strip()
            kind = str(binding.get("kind", "")).strip()
            toggle = str(binding.get("toggleState", "")).strip()
            if not key or not display_key or not label:
                continue
            rows.append(
                {
                    "key": key,
                    "display_key": display_key,
                    "label": label,
                    "literal": literal,
                    "kind": kind,
                    "toggle": toggle,
                }
            )
    unbound = number_row_palette.get("unbound")
    if isinstance(unbound, list):
        for _slot in unbound:
            rows.append(
                {
                    "key": "",
                    "display_key": "",
                    "label": "Unbound",
                    "literal": "",
                    "kind": "unbound",
                    "toggle": "",
                }
            )
    return tuple(rows)


def _number_row_bindings(
    number_row_palette: Mapping[str, object],
    *,
    include_movement_cluster: bool = False,
) -> tuple[dict[str, str], ...]:
    rows = [
        row
        for row in _number_row_slots(number_row_palette)
        if row["key"] and row["literal"] and row["kind"] != "unbound"
    ]
    if include_movement_cluster:
        return tuple(rows)
    return tuple(
        row
        for row in rows
        if row["kind"] != "command-only" and row["key"].upper() not in RESERVED_MOVEMENT_CLUSTER_KEYS
    )


def render_number_row_bindings(number_row_palette: Mapping[str, object]) -> str:
    lines = ["local numberRowBindings = {"]
    for binding in _number_row_slots(number_row_palette):
        lines.append(
            "    { key = "
            + lua_quote(binding["key"])
            + ", displayKey = "
            + lua_quote(binding["display_key"])
            + ", label = "
            + lua_quote(binding["label"])
            + ", literal = "
            + lua_quote(binding["literal"])
            + ", kind = "
            + lua_quote(binding["kind"])
            + ", toggle = "
            + lua_quote(binding["toggle"])
            + " },"
        )
    lines.append("};")
    return "\n".join(lines)


def render_number_row_bind_commands(number_row_palette: Mapping[str, object]) -> str:
    lines = ["    local bindingGeneration = state.BindingGeneration;", "    local commands = {"]
    for binding in _number_row_bindings(number_row_palette):
        bind_literal = f"/bind {binding['key']} {binding['literal']}"
        lines.append(f"        {lua_quote(bind_literal)},")
    lines.extend(
        [
            "    };",
            "    -- Queueing every bind during OnLoad can wedge Ashita; stagger them.",
            "    for index, command in ipairs(commands) do",
            "        local bindCommand = command;",
            "        local delay = (index - 1) * 0.20;",
            "        if not scheduleTask(delay, function()",
            "            if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then",
            "                return;",
            "            end",
            "            queueTypedCommand(bindCommand, -1);",
            "        end) then",
            "            message('Keypad bind scheduling unavailable; use /lac fwd keypad on after load.');",
            "            return;",
            "        end",
            "    end",
        ]
    )
    return "\n".join(lines)


def render_number_row_unbind_commands(number_row_palette: Mapping[str, object]) -> str:
    commands = [f"/unbind {binding['key']}" for binding in _number_row_bindings(number_row_palette)]
    return render_number_row_command_queue(
        commands,
        comment="Queueing every unbind during OnUnload can heap-corrupt Ashita; stagger them.",
        command_variable="unbindCommand",
        error_message="Keypad unbind scheduling unavailable; binds will be cleared on next profile unload.",
    )


def render_number_row_legacy_clear_commands(number_row_palette: Mapping[str, object]) -> str:
    commands: list[str] = []
    for key in LEGACY_KEYPAD_UNBIND_KEYS:
        commands.append(f"/unbind {key}")
    for key in ARROW_MOVEMENT_CLUSTER_UNBIND_KEYS:
        commands.append(f"/unbind {key}")
    for binding in _number_row_bindings(number_row_palette, include_movement_cluster=True):
        commands.append(f"/unbind {binding['key']}")
    commands.extend(render_legacy_number_row_unbind_commands())
    commands = list(dict.fromkeys(commands))
    return render_number_row_command_queue(
        commands,
        comment="Clear legacy keypad and number-row captures only on explicit cleanup.",
        command_variable="unbindCommand",
        error_message="Keypad legacy cleanup scheduling unavailable; retry /lac fwd keypad clear after load.",
    )


def render_number_row_command_queue(
    commands: Iterable[str],
    *,
    comment: str,
    command_variable: str,
    error_message: str,
) -> str:
    lines = ["    local bindingGeneration = state.BindingGeneration;", "    local commands = {"]
    for command in commands:
        lines.append(f"        {lua_quote(command)},")
    lines.extend(
        [
            "    };",
            f"    -- {comment}",
            "    for index, command in ipairs(commands) do",
            f"        local {command_variable} = command;",
            "        local delay = (index - 1) * 0.20;",
            "        if not scheduleTask(delay, function()",
            "            if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then",
            "                return;",
            "            end",
            f"            queueTypedCommand({command_variable}, -1);",
            "        end) then",
            f"            message({lua_quote(error_message)});",
            "            return;",
            "        end",
            "    end",
        ]
    )
    return "\n".join(lines)


def render_legacy_number_row_unbind_commands() -> list[str]:
    legacy_keys = ("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=")
    return [f"/unbind {key}" for key in legacy_keys]


def render_secondary_slot_locks(locks: Mapping[str, Mapping[str, tuple[str, ...]]]) -> str:
    if not locks:
        return "local setSecondarySlotLocks = {};"

    lines = ["local setSecondarySlotLocks = {"]
    for set_name, set_locks in locks.items():
        if not set_locks:
            continue
        lines.append(f"    {set_name} = {{")
        for slot, locked_slots in set_locks.items():
            slot_list = ", ".join(lua_quote(locked_slot) for locked_slot in locked_slots)
            lines.append(f"        {slot} = {{ {slot_list} }},")
        lines.append("    },")
    lines.append("};")
    return "\n".join(lines)


def secondary_lock_remove_slots(locks: Mapping[str, tuple[str, ...]]) -> tuple[str, ...]:
    slots: list[str] = []
    for locked_slots in locks.values():
        for slot in locked_slots:
            if slot not in slots:
                slots.append(slot)
    return tuple(slots)


def render_dual_wield_sub_sets(set_names: Iterable[str]) -> str:
    unique_names = tuple(dict.fromkeys(set_names))
    if not unique_names:
        return "local setRequiresDualWieldSub = {};"

    lines = ["local setRequiresDualWieldSub = {"]
    for set_name in unique_names:
        lines.append(f"    {set_name} = true,")
    lines.append("};")
    return "\n".join(lines)


def render_conditional_equips(conditional_equips: Mapping[str, tuple[dict[str, object], ...]]) -> str:
    if not conditional_equips:
        return "local conditionalEquips = {};"

    lines = ["local conditionalEquips = {"]
    for set_name, entries in conditional_equips.items():
        if not entries:
            continue
        lines.append(f"    {set_name} = {{")
        for entry in entries:
            condition = entry.get("condition") if isinstance(entry, dict) else None
            slots = entry.get("slots") if isinstance(entry, dict) else None
            if not isinstance(condition, Mapping) or not isinstance(slots, Mapping):
                continue
            lines.append("        {")
            lines.append(f"            condition = {render_condition_table(condition)},")
            lines.append(f"            slots = {render_inline_slot_table(slots)},")
            lines.append("        },")
        lines.append("    },")
    lines.append("};")
    return "\n".join(lines)


def render_buff_item_overlays(buff_item_overlays: Mapping[str, tuple[dict[str, object], ...]]) -> str:
    if not buff_item_overlays:
        return "profile.BuffItemOverlays = {};"

    lines = ["profile.BuffItemOverlays = {"]
    for set_name, entries in buff_item_overlays.items():
        if not entries:
            continue
        lines.append(f"    {set_name} = {{")
        for entry in entries:
            condition = entry.get("condition") if isinstance(entry, dict) else None
            slots = entry.get("slots") if isinstance(entry, dict) else None
            after_use = entry.get("afterUse") if isinstance(entry, dict) else None
            item = entry.get("item") if isinstance(entry, dict) else None
            if not isinstance(condition, Mapping) or not isinstance(slots, Mapping):
                continue
            lines.append("        {")
            lines.append(f"            condition = {render_condition_table(condition)},")
            lines.append(f"            slots = {render_inline_slot_table(slots)},")
            if isinstance(after_use, Mapping):
                lines.append(f"            afterUse = {render_inline_slot_table(after_use)},")
            if isinstance(item, Mapping):
                lines.append(f"            item = {render_lua_value(item, 12)},")
            lines.append("        },")
        lines.append("    },")
    lines.append("};")
    return "\n".join(lines)


def render_mechanics_swap_planner(planner: Mapping[str, object] | None) -> str:
    planner = planner or {
        "loaded": False,
        "plannerVersion": 1,
        "baselineSet": "",
        "supportedOpportunities": tuple(),
        "transitions": {},
        "skippedTransitions": {},
    }
    transitions = planner.get("transitions")
    skipped_transitions = planner.get("skippedTransitions")
    header = {
        key: value
        for key, value in planner.items()
        if key not in {"transitions", "skippedTransitions"}
    }
    header["transitions"] = {}
    header["skippedTransitions"] = {}

    lines = ["local mechanicsSwapPlanner = " + render_lua_value(header) + ";"]
    if isinstance(transitions, Mapping):
        for set_name, transition in transitions.items():
            lines.append(
                "mechanicsSwapPlanner.transitions["
                + lua_quote(str(set_name))
                + "] = "
                + render_lua_value(transition)
                + ";"
            )
    if isinstance(skipped_transitions, Mapping):
        for set_name, reason in skipped_transitions.items():
            lines.append(
                "mechanicsSwapPlanner.skippedTransitions["
                + lua_quote(str(set_name))
                + "] = "
                + render_lua_value(reason)
                + ";"
            )
    return "\n".join(lines)


def render_lua_value(value: object, indent: int = 0) -> str:
    if value is None:
        return "nil"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int | float):
        return str(value)
    if isinstance(value, str):
        return lua_quote(value)
    if isinstance(value, Mapping):
        if not value:
            return "{}"
        spaces = " " * indent
        inner_spaces = " " * (indent + 4)
        lines = ["{"]
        for key, item in value.items():
            lines.append(f"{inner_spaces}[{lua_quote(str(key))}] = {render_lua_value(item, indent + 4)},")
        lines.append(f"{spaces}}}")
        return "\n".join(lines)
    if isinstance(value, (tuple, list)):
        if not value:
            return "{}"
        if all(not isinstance(item, Mapping | list | tuple) for item in value):
            return "{ " + ", ".join(render_lua_value(item, indent) for item in value) + " }"
        spaces = " " * indent
        inner_spaces = " " * (indent + 4)
        lines = ["{"]
        for item in value:
            lines.append(f"{inner_spaces}{render_lua_value(item, indent + 4)},")
        lines.append(f"{spaces}}}")
        return "\n".join(lines)
    return lua_quote(str(value))


def render_mechanics_runtime_helpers() -> str:
    return """do
local function mechanicsPlanForSet(setName)
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        return nil;
    end
    local transitions = mechanicsSwapPlanner.transitions;
    if type(transitions) ~= 'table' then
        return nil;
    end
    return transitions[setName];
end

local function mechanicsSkipReasonForSet(setName)
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        return nil;
    end
    local skippedTransitions = mechanicsSwapPlanner.skippedTransitions;
    if type(skippedTransitions) ~= 'table' then
        return nil;
    end
    return skippedTransitions[setName];
end

local function mechanicsWarningText(plan)
    local warnings = plan and plan.warnings;
    if type(warnings) ~= 'table' or #warnings == 0 then
        return 'none';
    end
    return table.concat(warnings, ',');
end

local function mechanicsActionText(action)
    if type(action) ~= 'table' then
        return 'unknown action';
    end
    return tostring(action.phase or 'phase') .. ' ' .. tostring(action.slot or '?') .. '=' .. tostring(action.item or '?') .. ' (' .. tostring(action.reason or '') .. ')';
end

local function tableCount(value)
    if type(value) ~= 'table' then
        return 0;
    end
    local count = 0;
    for _, _ in pairs(value) do
        count = count + 1;
    end
    return count;
end

local function sortedMechanicsKeys(value)
    local names = {};
    if type(value) ~= 'table' then
        return names;
    end
    for name, _ in pairs(value) do
        table.insert(names, tostring(name));
    end
    table.sort(names);
    return names;
end

local function mechanicsPlanActionWarningCounts()
    local transitions = mechanicsSwapPlanner and mechanicsSwapPlanner.transitions;
    if type(transitions) ~= 'table' then
        return 0, 0;
    end
    local actionCount = 0;
    local warningCount = 0;
    for _, plan in pairs(transitions) do
        if type(plan) == 'table' then
            if type(plan.actions) == 'table' then
                actionCount = actionCount + #plan.actions;
            end
            if type(plan.warnings) == 'table' then
                warningCount = warningCount + #plan.warnings;
            end
        end
    end
    local explicitTransitions = mechanicsSwapPlanner and mechanicsSwapPlanner.explicitTransitions;
    if type(explicitTransitions) == 'table' then
        for _, plan in pairs(explicitTransitions) do
            if type(plan) == 'table' and type(plan.actions) == 'table' then
                actionCount = actionCount + #plan.actions;
            end
        end
    end
    return actionCount, warningCount;
end

local function mechanicsListText(names)
    if type(names) ~= 'table' or #names == 0 then
        return 'none';
    end
    if #names <= 12 then
        return table.concat(names, ',');
    end
    local visible = {};
    for index = 1, 12 do
        table.insert(visible, names[index]);
    end
    return table.concat(visible, ',') .. ' +' .. tostring(#names - 12) .. ' more';
end

local function printMechanicsList()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        message('Mechanics planner is not loaded.');
        return false;
    end
    local plannedNames = sortedMechanicsKeys(mechanicsSwapPlanner.transitions);
    local skippedNames = sortedMechanicsKeys(mechanicsSwapPlanner.skippedTransitions);
    message('Mechanics planned sets (' .. tostring(#plannedNames) .. '): ' .. mechanicsListText(plannedNames));
    message('Mechanics skipped sets (' .. tostring(#skippedNames) .. '): ' .. mechanicsListText(skippedNames));
    return true;
end

local function mechanicsWarningTypeCounts()
    local counts = {};
    local transitions = mechanicsSwapPlanner and mechanicsSwapPlanner.transitions;
    if type(transitions) ~= 'table' then
        return counts;
    end
    for _, plan in pairs(transitions) do
        local warnings = type(plan) == 'table' and plan.warnings or nil;
        if type(warnings) == 'table' then
            for _, warning in ipairs(warnings) do
                local key = tostring(warning);
                counts[key] = (counts[key] or 0) + 1;
            end
        end
    end
    return counts;
end

local function printMechanicsWarnings()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        message('Mechanics planner is not loaded.');
        return false;
    end
    local counts = mechanicsWarningTypeCounts();
    local names = sortedMechanicsKeys(counts);
    if #names == 0 then
        message('Mechanics warning types: none.');
        return true;
    end
    for _, warning in ipairs(names) do
        message('Mechanics warning type ' .. tostring(warning) .. ': ' .. tostring(counts[warning]));
    end
    return true;
end

local function mechanicsSkippedReasonCounts()
    local counts = {};
    local skippedTransitions = mechanicsSwapPlanner and mechanicsSwapPlanner.skippedTransitions;
    if type(skippedTransitions) ~= 'table' then
        return counts;
    end
    for _, reason in pairs(skippedTransitions) do
        local key = tostring(reason);
        counts[key] = (counts[key] or 0) + 1;
    end
    return counts;
end

local function printMechanicsSkipped()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        message('Mechanics planner is not loaded.');
        return false;
    end
    local counts = mechanicsSkippedReasonCounts();
    local names = sortedMechanicsKeys(counts);
    if #names == 0 then
        message('Mechanics skipped reasons: none.');
        return true;
    end
    for _, reason in ipairs(names) do
        message('Mechanics skipped reason ' .. tostring(reason) .. ': ' .. tostring(counts[reason]));
    end
    return true;
end

local function mechanicsTargetSet(args)
    local setName = args and args[3];
    if setName and sets[setName] then
        return setName;
    end
    local alias = styleAliases[normalize(setName)];
    if alias and sets['Playstyle_' .. alias] then
        return 'Playstyle_' .. alias;
    end
    if alias and sets[alias] then
        return alias;
    end
    if setName and sets['Playstyle_' .. tostring(setName)] then
        return 'Playstyle_' .. tostring(setName);
    end
    return setName or '';
end

local function printMechanicsPlan(setName)
    local plan = mechanicsPlanForSet(setName);
    if not plan then
        local skipReason = mechanicsSkipReasonForSet(setName);
        if skipReason then
            message('Mechanics transition skipped for ' .. tostring(setName) .. ': ' .. tostring(skipReason) .. '.');
            return false;
        end
        message('No mechanics transition plan for ' .. tostring(setName) .. '.');
        return false;
    end
    local actions = plan.actions or {};
    message('Mechanics plan ' .. tostring(setName) .. ': actions=' .. tostring(#actions) .. '; warnings=' .. mechanicsWarningText(plan));
    for index, action in ipairs(actions) do
        message('Mechanics action ' .. tostring(index) .. ': ' .. mechanicsActionText(action));
    end
    return true;
end

local function playerMechanicsText(player)
    if type(player) ~= 'table' then
        return 'player unavailable';
    end
    local hp = player.HP or player.hp or player.CurrentHP or player.currentHP or '?';
    local maxHp = player.MaxHP or player.maxHP or player.HPMax or player.hpmax or '?';
    local mp = player.MP or player.mp or player.CurrentMP or player.currentMP or '?';
    local maxMp = player.MaxMP or player.maxMP or player.MPMax or player.mpmax or '?';
    return 'HP=' .. tostring(hp) .. '/' .. tostring(maxHp) .. '; MP=' .. tostring(mp) .. '/' .. tostring(maxMp);
end

local function probeMechanicsPlan(setName)
    if state.MechanicsProbes ~= true then
        message('Mechanics probes disabled. Use mechanics probes on.');
        return false;
    end
    message('Mechanics probe ' .. tostring(setName) .. ': ' .. playerMechanicsText(getPlayer()));
    return printMechanicsPlan(setName);
end

local function mechanicsStatus()
    local loaded = mechanicsSwapPlanner and mechanicsSwapPlanner.loaded == true;
    local baseline = mechanicsSwapPlanner and mechanicsSwapPlanner.baselineSet or '';
    local plannerVersion = mechanicsSwapPlanner and mechanicsSwapPlanner.plannerVersion or 0;
    local transitionCount = tableCount(mechanicsSwapPlanner and mechanicsSwapPlanner.transitions);
    local skippedCount = tableCount(mechanicsSwapPlanner and mechanicsSwapPlanner.skippedTransitions);
    local actionCount, warningCount = mechanicsPlanActionWarningCounts();
    message('Mechanics planner loaded=' .. tostring(loaded) .. '; baseline=' .. tostring(baseline) .. '; version=' .. tostring(plannerVersion) .. '; transitions=' .. tostring(transitionCount) .. '; skipped=' .. tostring(skippedCount) .. '; actions=' .. tostring(actionCount) .. '; warnings=' .. tostring(warningCount) .. '; probes=' .. tostring(state.MechanicsProbes == true) .. '; execution=' .. tostring(state.MechanicsExecution == true));
    message('Automatic mechanics execution is disabled; explicit avoidtick acts only on receive-only observed harmful gear.');
end

local function handleMechanicsCommand(args)
    local subcommand = normalize(args and args[2]);
    if subcommand == '' or subcommand == 'status' then
        mechanicsStatus();
        return;
    elseif subcommand == 'help' then
        message('mechanics status | mechanics list | mechanics warnings | mechanics skipped | mechanics probes on|off | mechanics plan <set> | mechanics probe <set> | mechanics avoidtick');
        return;
    elseif subcommand == 'list' then
        printMechanicsList();
        return;
    elseif subcommand == 'warnings' then
        printMechanicsWarnings();
        return;
    elseif subcommand == 'skipped' then
        printMechanicsSkipped();
        return;
    elseif subcommand == 'probes' then
        local value = normalize(args and args[3]);
        if value == 'on' then
            state.MechanicsProbes = true;
        elseif value == 'off' then
            state.MechanicsProbes = false;
        end
        message('Mechanics probes: ' .. (state.MechanicsProbes and 'on' or 'off') .. '.');
        return;
    elseif subcommand == 'plan' then
        printMechanicsPlan(mechanicsTargetSet(args));
        return;
    elseif subcommand == 'probe' then
        probeMechanicsPlan(mechanicsTargetSet(args));
        return;
    elseif subcommand == 'avoidtick' then
        local avoided, detail = profile.OddLuaRuntime.AvoidNegativeTickGear();
        if avoided == true then
            message('Negative-tick avoidance requested: ' .. tostring(detail) .. '; verify observed equipment before treating it as proof.');
        else
            message('Negative-tick avoidance skipped: ' .. tostring(detail or 'unavailable') .. '.');
        end
        return;
    end
    message('Unknown mechanics command. Use mechanics help.');
end

profile.OddLuaRuntime.HandleMechanicsCommand = handleMechanicsCommand;
end"""


def render_condition_table(condition: Mapping[str, object]) -> str:
    condition_type = str(condition.get("type", ""))
    condition_name = str(condition.get("name", ""))
    parts = [
        f"type = {lua_quote(condition_type)}",
        f"name = {lua_quote(condition_name)}",
    ]
    for key in ("threshold",):
        value = condition.get(key)
        if isinstance(value, int | float):
            parts.append(f"{key} = {value}")
    for key in ("buffs", "areas"):
        values = condition.get(key)
        if isinstance(values, (tuple, list)) and values:
            parts.append(f"{key} = {render_lua_value(values)}")
    return "{ " + ", ".join(parts) + " }"


def render_inline_slot_table(slots: Mapping[str, object]) -> str:
    parts = []
    for slot in SLOT_ORDER:
        if slot in slots:
            parts.append(f"{slot} = {lua_quote(str(slots[slot]))}")
    return "{ " + ", ".join(parts) + " }"


def derive_semantic_sets(
    sets: Mapping[str, dict[str, str]],
    default_playstyle: str,
) -> dict[str, dict[str, str]]:
    semantic_sets: dict[str, dict[str, str]] = {}
    for semantic_name in SEMANTIC_SET_PREFERENCES:
        if semantic_name in EXACT_ONLY_SEMANTIC_SETS and semantic_name not in sets:
            continue
        semantic_sets[semantic_name] = dict(sets.get(semantic_name) or {})
    return semantic_sets


def render_subjob_profiles(profiles: Mapping[str, SubjobProfile]) -> str:
    if not profiles:
        return "local subjobs = {};"

    lines = ["local subjobs = {"]
    for abbr, profile in profiles.items():
        lines.append(f"    {abbr} = {{")
        lines.append(f"        level = {profile.level},")
        lines.append("        capabilities = {")
        for capability in profile.capabilities:
            lines.append(f"            {lua_quote(capability)},")
        lines.append("        },")
        lines.append("        abilities = {")
        for ability in profile.abilities:
            lines.append(
                "            "
                f"{{ name = {lua_quote(ability.name)}, level = {ability.level}, "
                f"recast = {ability.recast_time}, recastId = {ability.recast_id}, "
                f"ce = {ability.ce}, ve = {ability.ve} }},"
            )
        lines.append("        },")
        lines.append("        traits = {")
        for trait in profile.traits:
            lines.append(
                "            "
                f"{{ name = {lua_quote(trait.name)}, level = {trait.level}, rank = {trait.rank}, "
                f"mod = {lua_quote(trait.mod_name)}, value = {trait.value} }},"
            )
        lines.append("        },")
        lines.append("        spells = {")
        for spell in profile.spells:
            lines.append(
                "            "
                f"{{ name = {lua_quote(spell.name)}, level = {spell.level}, mp = {spell.mp_cost}, "
                f"cast = {spell.cast_time}, recast = {spell.recast_time} }},"
            )
        lines.append("        },")
        lines.append("    },")
    lines.append("};")
    return "\n".join(lines)


def render_job_id_table() -> str:
    lines = ["local jobIdToAbbr = {"]
    for abbr, job_id in JOB_IDS.items():
        lines.append(f"    [{job_id}] = {lua_quote(abbr)},")
    lines.append("};")
    return "\n".join(lines)


def render_reconciliation_name_alias_groups(
    aliases: Mapping[str, Iterable[str]] | None = None,
) -> str:
    rows: list[tuple[str, ...]] = []
    for canonical, names in sorted((aliases or {}).items()):
        values = [str(canonical), *(str(name) for name in names)]
        clean = tuple(dict.fromkeys(value.strip() for value in values if value.strip()))
        if len(clean) < 2:
            continue
        rows.append(clean)

    if not rows:
        return "profile.ReconciliationNameAliases = { groups = {}, aliases = {} };"

    lines = [
        "profile.ReconciliationNameAliases = {",
        "    groups = {",
    ]
    for row in rows:
        values = ", ".join(lua_quote(value) for value in row)
        lines.append(f"        {{ {values} }},")
    lines.extend([
        "    },",
        "    aliases = {},",
        "};",
    ])
    return "\n".join(lines)


def render_reconciliation_helpers(
    *,
    player: str,
    player_id: str,
    job: str,
    reconciliation_item_aliases: Mapping[str, Iterable[str]] | None = None,
) -> str:
    slot_lines = "\n".join(f"    {lua_quote(slot)}," for slot in SLOT_ORDER)
    safe_name = re.sub(r"[^A-Za-z0-9_.-]+", "_", f"{player}_{player_id}-{job}")
    log_path = f"logs/oddlua-reconcile-{safe_name}.jsonl"
    alias_groups = render_reconciliation_name_alias_groups(reconciliation_item_aliases)
    block = r"""
local reconciliationConfig = {
    schema = 'oddlua.reconcile.v1',
    player = @PLAYER@,
    playerId = @PLAYER_ID@,
    job = @JOB@,
    logPath = @LOG_PATH@,
    slotOrder = {
@SLOT_LINES@
    },
};

@ALIAS_GROUPS@

function profile.ReconciliationNameAliases.Base(value)
    if type(value) == 'table' then
        value = value.Name or value.name or '';
    end
    local text = normalize(value);
    text = string.gsub(text, '_', ' ');
    text = string.gsub(text, '[%p%c]+', ' ');
    text = string.gsub(text, '%s+', ' ');
    text = string.gsub(text, '^%s+', '');
    text = string.gsub(text, '%s+$', '');
    return text;
end

function profile.ReconciliationNameAliases.Register(names)
    local canonical = nil;
    for _, name in ipairs(names or {}) do
        local text = profile.ReconciliationNameAliases.Base(name);
        if text ~= '' and canonical == nil then
            canonical = text;
        end
    end
    if canonical == nil then
        return;
    end
    for _, name in ipairs(names or {}) do
        local text = profile.ReconciliationNameAliases.Base(name);
        if text ~= '' then
            profile.ReconciliationNameAliases.aliases[text] = canonical;
        end
    end
end

for _, names in ipairs(profile.ReconciliationNameAliases.groups) do
    profile.ReconciliationNameAliases.Register(names);
end

function profile.ReconciliationNameAliases.Canonical(value)
    local text = profile.ReconciliationNameAliases.Base(value);
    return profile.ReconciliationNameAliases.aliases[text] or text;
end

local function reconciliationJsonEscape(value)
    value = tostring(value or '');
    value = string.gsub(value, '\\', '\\\\');
    value = string.gsub(value, '"', '\\"');
    value = string.gsub(value, '\r', '\\r');
    value = string.gsub(value, '\n', '\\n');
    value = string.gsub(value, '\t', '\\t');
    return '"' .. value .. '"';
end

local function reconciliationJsonBool(value)
    if value == true then
        return 'true';
    end
    return 'false';
end

local function ensureReconciliationLogDirectory()
    if state.ReconcileLogDirectoryReady == true then
        return true;
    end

    if ashita and ashita.fs and ashita.fs.exists and ashita.fs.exists('logs') then
        state.ReconcileLogDirectoryReady = true;
        return true;
    end

    if ashita and ashita.fs then
        if ashita.fs.create_directory then
            pcall(ashita.fs.create_directory, 'logs');
        elseif ashita.fs.create_dir then
            pcall(ashita.fs.create_dir, 'logs');
        end
    end

    state.ReconcileLogDirectoryReady = true;
    return true;
end

local function reconciliationExpectedName(value)
    if type(value) == 'string' then
        return value;
    elseif type(value) == 'table' then
        return value.Name or value.name or value[1];
    end
    return nil;
end

local function reconciliationExpectedMap(set)
    local expected = {};
    if type(set) ~= 'table' then
        return expected;
    end

    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local name = reconciliationExpectedName(set[slot]);
        if name ~= nil then
            expected[slot] = tostring(name);
        end
    end
    return expected;
end

local function reconciliationObservedField(value, key)
    if value == nil then
        return nil;
    end
    local ok, result = pcall(function()
        return value[key];
    end);
    if ok == true then
        return result;
    end
    return nil;
end

local function reconciliationObservedResource(entry)
    return reconciliationObservedField(entry, 'Resource')
        or reconciliationObservedField(entry, 'resource')
        or reconciliationObservedField(entry, 'Item')
        or reconciliationObservedField(entry, 'item')
        or entry;
end

local function reconciliationObservedLocalizedName(value)
    if type(value) == 'string' then
        return value;
    end
    return reconciliationObservedField(value, 1) or reconciliationObservedField(value, 0);
end

local function reconciliationObservedName(entry)
    if type(entry) == 'string' then
        return entry;
    end
    local directName = reconciliationObservedLocalizedName(
        reconciliationObservedField(entry, 'Name')
        or reconciliationObservedField(entry, 'name')
    );
    if directName ~= nil then
        return directName;
    end
    local resource = reconciliationObservedResource(entry);
    local name = reconciliationObservedField(resource, 'Name')
        or reconciliationObservedField(resource, 'name');
    return reconciliationObservedLocalizedName(name);
end

local function reconciliationObservedId(entry)
    local item = reconciliationObservedField(entry, 'Item')
        or reconciliationObservedField(entry, 'item');
    local resource = reconciliationObservedResource(entry);
    return tonumber(
        reconciliationObservedField(item, 'Id')
        or reconciliationObservedField(item, 'ID')
        or reconciliationObservedField(item, 'id')
        or reconciliationObservedField(entry, 'Id')
        or reconciliationObservedField(entry, 'ID')
        or reconciliationObservedField(entry, 'id')
        or reconciliationObservedField(resource, 'Id')
        or reconciliationObservedField(resource, 'ID')
        or reconciliationObservedField(resource, 'id')
    );
end

local function observeReconciliationEquipment()
    if not gData or not gData.GetEquipment then
        return nil, 'gData.GetEquipment unavailable';
    end

    local ok, equipment = pcall(gData.GetEquipment);
    if not ok then
        return nil, 'gData.GetEquipment failed';
    end
    if type(equipment) ~= 'table' then
        return nil, 'gData.GetEquipment returned non-table';
    end
    if next(equipment) == nil then
        return nil, 'gData.GetEquipment returned empty table';
    end

    local observed = {};
    local observedIds = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local name = reconciliationObservedName(equipment[slot]);
        if name ~= nil and tostring(name) ~= '' then
            observed[slot] = tostring(name);
        end
        local itemId = reconciliationObservedId(equipment[slot]);
        if itemId ~= nil and itemId > 0 then
            observedIds[slot] = itemId;
        end
    end
    return observed, nil, observedIds;
end

local function reconciliationNamesMatch(expected, observed)
    local expectedText = profile.ReconciliationNameAliases.Canonical(expected);
    local observedText = profile.ReconciliationNameAliases.Canonical(observed);
    if expectedText == 'remove' then
        return observedText == '';
    end
    return expectedText == observedText;
end

local function compareReconciliationSnapshot(setName, expected, observed)
    local mismatches = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local expectedName = expected[slot];
        if expectedName ~= nil then
            local observedName = observed[slot] or '';
            if not reconciliationNamesMatch(expectedName, observedName) then
                mismatches[#mismatches + 1] = {
                    slot = slot,
                    expected = tostring(expectedName),
                    observed = tostring(observedName),
                };
            end
        end
    end

    local status = 'match';
    if #mismatches > 0 then
        status = 'mismatch';
    end
    return {
        set = setName,
        status = status,
        mismatches = mismatches,
    };
end

local function encodeReconciliationMap(map)
    local parts = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        if map and map[slot] ~= nil then
            parts[#parts + 1] = reconciliationJsonEscape(slot) .. ':' .. reconciliationJsonEscape(map[slot]);
        end
    end
    return '{' .. table.concat(parts, ',') .. '}';
end

local function encodeReconciliationMismatches(mismatches)
    local parts = {};
    for _, mismatch in ipairs(mismatches or {}) do
        parts[#parts + 1] = '{'
            .. '"slot":' .. reconciliationJsonEscape(mismatch.slot)
            .. ',"expected":' .. reconciliationJsonEscape(mismatch.expected)
            .. ',"observed":' .. reconciliationJsonEscape(mismatch.observed)
            .. '}';
    end
    return '[' .. table.concat(parts, ',') .. ']';
end

local function encodeReconciliationSnapshot(snapshot)
    local parts = {};
    parts[#parts + 1] = '"schema":' .. reconciliationJsonEscape(reconciliationConfig.schema);
    parts[#parts + 1] = '"player":' .. reconciliationJsonEscape(reconciliationConfig.player);
    parts[#parts + 1] = '"playerId":' .. reconciliationJsonEscape(reconciliationConfig.playerId);
    parts[#parts + 1] = '"job":' .. reconciliationJsonEscape(reconciliationConfig.job);
    parts[#parts + 1] = '"profileBuildToken":' .. reconciliationJsonEscape(snapshot.profileBuildToken);
    parts[#parts + 1] = '"sequence":' .. tostring(snapshot.sequence or 0);
    parts[#parts + 1] = '"cycleSequence":' .. tostring(snapshot.cycleSequence or 0);
    parts[#parts + 1] = '"timestamp":' .. tostring(snapshot.timestamp or 0);
    parts[#parts + 1] = '"set":' .. reconciliationJsonEscape(snapshot.set);
    parts[#parts + 1] = '"status":' .. reconciliationJsonEscape(snapshot.status);
    parts[#parts + 1] = '"force":' .. reconciliationJsonBool(snapshot.force == true);
    parts[#parts + 1] = '"repair":' .. reconciliationJsonBool(snapshot.repair == true);
    parts[#parts + 1] = '"repairAttempt":' .. tostring(tonumber(snapshot.repairAttempt) or 0);
    parts[#parts + 1] = '"repairQueued":' .. reconciliationJsonBool(snapshot.repairQueued == true);
    parts[#parts + 1] = '"repairPaused":' .. reconciliationJsonBool(snapshot.repairPaused == true);
    parts[#parts + 1] = '"repairFailed":' .. reconciliationJsonBool(snapshot.repairFailed == true);
    parts[#parts + 1] = '"observationOnly":' .. reconciliationJsonBool(snapshot.observationOnly == true);
    parts[#parts + 1] = '"contextSignature":' .. reconciliationJsonEscape(snapshot.contextSignature);
    if snapshot.repairStrategy ~= nil and snapshot.repairStrategy ~= '' then
        parts[#parts + 1] = '"repairStrategy":' .. reconciliationJsonEscape(snapshot.repairStrategy);
    end
    parts[#parts + 1] = '"playstyle":' .. reconciliationJsonEscape(snapshot.playstyle);
    parts[#parts + 1] = '"intent":' .. reconciliationJsonEscape(snapshot.intent);
    if snapshot.actionProbeSequence ~= nil and snapshot.actionProbeSequence ~= '' then
        parts[#parts + 1] = '"actionProbeSequence":' .. reconciliationJsonEscape(snapshot.actionProbeSequence);
    end
    parts[#parts + 1] = '"expected":' .. encodeReconciliationMap(snapshot.expected);
    parts[#parts + 1] = '"observed":' .. encodeReconciliationMap(snapshot.observed);
    parts[#parts + 1] = '"mismatches":' .. encodeReconciliationMismatches(snapshot.mismatches);
    if snapshot.reason ~= nil then
        parts[#parts + 1] = '"reason":' .. reconciliationJsonEscape(snapshot.reason);
    end
    return '{' .. table.concat(parts, ',') .. '}';
end

local function writeReconciliationSnapshot(snapshot)
    if not io or not io.open then
        return false, 'io.open unavailable';
    end

    ensureReconciliationLogDirectory();
    local file, err = io.open(reconciliationConfig.logPath, 'ab');
    if not file then
        state.ReconcileLastWriteError = tostring(err or 'unknown write error');
        return false, state.ReconcileLastWriteError;
    end

    file:write(encodeReconciliationSnapshot(snapshot), '\n');
    file:close();
    state.ReconcileLastWriteError = nil;
    return true, nil;
end

local function reconciliationMismatchSlots(mismatches)
    local parts = {};
    for _, mismatch in ipairs(mismatches or {}) do
        parts[#parts + 1] = tostring(mismatch.slot);
    end
    if #parts == 0 then
        return 'none';
    end
    return table.concat(parts, ',');
end

local function reconciliationExpectedSignature(setName, expected)
    local parts = { tostring(setName or '') };
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        if expected and expected[slot] ~= nil then
            parts[#parts + 1] = tostring(slot) .. '=' .. tostring(expected[slot]);
        end
    end
    return table.concat(parts, '|');
end

profile.OddLuaRuntime.ReconciliationObservationSettleSeconds = 0.25;

function profile.OddLuaRuntime.ReconciliationContextSignature()
    local player = profile.OddLuaRuntime.GetPlayer();
    local environment = profile.OddLuaRuntime.GetEnvironment();
    local function jobText(value)
        local numeric = tonumber(value);
        if numeric ~= nil and jobIdToAbbr[numeric] ~= nil then
            return normalize(jobIdToAbbr[numeric]);
        end
        return normalize(value);
    end
    local function effectiveLevel(...)
        for index = 1, select('#', ...) do
            local candidate = select(index, ...);
            local value = tonumber(candidate);
            if value ~= nil then
                return value;
            end
        end
        return '';
    end
    local mainJob = '';
    local subJob = '';
    local mainLevel = '';
    local subLevel = '';
    local status = '';
    local moving = false;
    local tpPositive = false;
    if type(player) == 'table' then
        mainJob = jobText(player.MainJob or player.mainJob or player.MainJobName or player.mainJobName);
        subJob = jobText(player.SubJob or player.subJob or player.Subjob or player.subjob or player.SubJobName or player.subJobName);
        mainLevel = effectiveLevel(
            player.MainJobSync,
            player.mainJobSync,
            player.MainJobLevel,
            player.mainJobLevel,
            player.MainLevel,
            player.mainLevel
        );
        subLevel = effectiveLevel(
            player.SubJobSync,
            player.subJobSync,
            player.SubJobLevel,
            player.subJobLevel,
            player.SubLevel,
            player.subLevel
        );
        status = normalize(player.Status or player.status or player.StatusName or player.statusName);
        moving = profile.OddLuaRuntime.PlayerIsMoving(player) == true;
        local tp = tonumber(player.TP or player.tp or player.TacticalPoints or player.tacticalPoints);
        tpPositive = tp ~= nil and tp > 0;
    end
    local zone = '';
    local area = '';
    if type(environment) == 'table' then
        zone = tostring(environment.ZoneId or environment.zoneId or environment.Zone or environment.zone or '');
        area = normalize(environment.Area or environment.area or environment.ZoneName or environment.zoneName);
    end
    return table.concat({
        'moving=' .. tostring(moving),
        'mainJob=' .. tostring(mainJob),
        'mainLevel=' .. tostring(mainLevel),
        'subJob=' .. tostring(subJob),
        'subLevel=' .. tostring(subLevel),
        'tpPositive=' .. tostring(tpPositive),
        'status=' .. tostring(status),
        'zone=' .. tostring(zone),
        'area=' .. tostring(area),
        'movementSafety=' .. tostring(movementSafetyActive() == true),
    }, '|');
end

function profile.OddLuaRuntime.ReconciliationContextMatches(pending)
    return type(pending) == 'table'
        and type(pending.contextSignature) == 'string'
        and pending.contextSignature == profile.OddLuaRuntime.ReconciliationContextSignature();
end

local function reconciliationDelayForSet(setName)
    if state.IdleOverrideSet == setName then
        return 0.35;
    end
    local intent = normalize(setIntents[setName] or '');
    if intent == 'idle' or intent == 'movement' or intent == 'tp' then
        return 0.35;
    end
    return 0.08;
end

local function reconciliationCanRepairSet(setName, intent)
    if state.IdleOverrideSet == setName then
        return true;
    end
    local intentText = normalize(intent or '');
    return intentText == 'tp' or intentText == 'idle' or intentText == 'movement';
end

local reconciliationMaxRepairAttempts = 2;
local reconciliationResetBarrierDelaySeconds = 0.35;
local reconciliationResetBarrierSafeSlots = {
    Head = true,
    Neck = true,
    Ear1 = true,
    Ear2 = true,
    Body = true,
    Hands = true,
    Ring1 = true,
    Ring2 = true,
    Back = true,
    Waist = true,
    Legs = true,
    Feet = true,
};
local repairReconciliationMismatch;
local forceReconciliationExpected;
local scheduleReconciliationSnapshot;

local function cancelPendingReconciliationSnapshot()
    state.ReconcilePendingSnapshot = nil;
    state.ReconcileScanScheduled = false;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
end

function profile.OddLuaRuntime.QueueReconciliationObservationSettle(pending)
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    scheduleReconciliationSnapshot(
        pending.set,
        pending.expected,
        pending.force,
        pending.repair,
        pending.repairAttempt,
        {
            actionProbeSequence = pending.actionProbeSequence,
            profileBuildToken = pending.profileBuildToken,
            contextSignature = pending.contextSignature,
            cycleSequence = pending.cycleSequence,
            delaySeconds = profile.OddLuaRuntime.ReconciliationObservationSettleSeconds,
            observationOnly = true,
        }
    );
    return true;
end

local function recordPendingReconciliationSnapshot(token)
    if token ~= nil and token ~= state.ReconcileScanToken then
        return;
    end
    if state.ReconcileEnabled ~= true then
        state.ReconcileScanScheduled = false;
        state.ReconcilePendingSnapshot = nil;
        return;
    end

    local pending = state.ReconcilePendingSnapshot;
    state.ReconcileScanScheduled = false;
    state.ReconcilePendingSnapshot = nil;
    if type(pending) ~= 'table' then
        return;
    end
    local superseding = pending.repairSupersedingSnapshot;
    if type(superseding) == 'table' then
        -- The old intent's delay says nothing about how long the new set has
        -- been equipped. Yield without observing and grant the current intent
        -- its complete normal settle window.
        state.ReconcileLastRecordedSignature = nil;
        if profile.OddLuaRuntime.ReconciliationContextMatches(superseding) ~= true then
            return;
        end
        scheduleReconciliationSnapshot(
            superseding.set,
            superseding.expected,
            superseding.force,
            false,
            nil,
            {
                actionProbeSequence = superseding.actionProbeSequence,
                profileBuildToken = superseding.profileBuildToken,
                contextSignature = superseding.contextSignature,
            }
        );
        return;
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return;
    end

    local observed, reason = observeReconciliationEquipment();
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return;
    end
    local snapshot;
    if observed == nil then
        snapshot = {
            set = pending.set,
            status = 'unknown_observation',
            reason = reason or 'unknown observation failure',
            mismatches = {},
            expected = pending.expected,
            observed = {},
        };
    else
        snapshot = compareReconciliationSnapshot(pending.set, pending.expected, observed);
        snapshot.expected = pending.expected;
        snapshot.observed = observed;
    end

    snapshot.profileBuildToken = pending.profileBuildToken;
    snapshot.sequence = pending.sequence;
    snapshot.cycleSequence = pending.cycleSequence;
    snapshot.contextSignature = pending.contextSignature;
    snapshot.timestamp = nowSeconds();
    snapshot.force = pending.force == true;
    snapshot.repair = pending.repair == true;
    snapshot.repairAttempt = tonumber(pending.repairAttempt) or 0;
    snapshot.repairQueued = false;
    snapshot.repairFailed = false;
    snapshot.repairPaused = false;
    snapshot.observationOnly = pending.observationOnly == true;
    snapshot.playstyle = pending.playstyle;
    snapshot.intent = pending.intent;
    snapshot.actionProbeSequence = pending.actionProbeSequence;

    if snapshot.status == 'mismatch' and snapshot.observationOnly ~= true then
        local terminalRepairAttempt = snapshot.repair == true
            and snapshot.repairAttempt >= reconciliationMaxRepairAttempts;
        local actionNeedsSettle = snapshot.repair ~= true
            and tostring(snapshot.actionProbeSequence or '') ~= ''
            and reconciliationCanRepairSet(pending.set, pending.intent) ~= true;
        if terminalRepairAttempt or actionNeedsSettle then
            state.ReconcileLastRecordedSignature = nil;
            profile.OddLuaRuntime.QueueReconciliationObservationSettle(pending);
            return;
        end
    end

    local repairPauseReason = nil;
    local repairStrategy = nil;
    if snapshot.status == 'mismatch'
        and snapshot.observationOnly ~= true
        and repairReconciliationMismatch
    then
        snapshot.repairQueued, repairPauseReason, repairStrategy = repairReconciliationMismatch(pending, snapshot.mismatches);
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return;
    end
    snapshot.repairStrategy = repairStrategy;
    snapshot.repairPaused = repairPauseReason ~= nil;
    snapshot.repairFailed = snapshot.status == 'mismatch'
        and snapshot.observationOnly == true
        and snapshot.repair == true
        and snapshot.repairAttempt >= reconciliationMaxRepairAttempts;
    if repairPauseReason ~= nil then
        snapshot.reason = repairPauseReason;
    end
    state.ReconcileLast = snapshot;
    if snapshot.status == 'unknown_observation' or snapshot.repairPaused == true then
        state.ReconcileLastRecordedSignature = nil;
    else
        state.ReconcileLastRecordedSignature = pending.signature;
    end
    writeReconciliationSnapshot(snapshot);

    if snapshot.status == 'mismatch' and snapshot.repairQueued ~= true and snapshot.repairPaused ~= true then
        local repairText = '';
        if snapshot.repairFailed == true then
            repairText = '; repair=failed';
        end
        message('Reconcile mismatch set=' .. tostring(pending.set) .. '; slots=' .. reconciliationMismatchSlots(snapshot.mismatches) .. repairText .. '.');
    end
end

scheduleReconciliationSnapshot = function(setName, expectedSet, force, repair, repairAttempt, options)
    if state.ReconcileEnabled ~= true then
        return;
    end

    local expected = reconciliationExpectedMap(expectedSet);
    if repair ~= true and state.ReconcileCompositionActive == true then
        -- Default handling composes a complete baseline and one or more sparse
        -- overlays synchronously. Only its final request is an observable
        -- intent; intermediate layers must not become scheduler superseders.
        state.ReconcileCompositionPending = {
            set = setName,
            expected = expected,
            force = force == true,
        };
        return;
    end
    local metadata = type(options) == 'table' and options or {};
    local observationOnly = metadata.observationOnly == true;
    local profileBuildToken = tostring(metadata.profileBuildToken or profile.OddLuaBuildToken or '');
    local contextSignature = tostring(
        metadata.contextSignature or profile.OddLuaRuntime.ReconciliationContextSignature()
    );
    local actionProbeSequence = metadata.actionProbeSequence;
    if actionProbeSequence == nil then
        actionProbeSequence = profile.OddLuaRuntime.ActionProbeSequence;
    end
    actionProbeSequence = tostring(actionProbeSequence or '');
    local signature = reconciliationExpectedSignature(setName, expected)
        .. '|contextSignature=' .. contextSignature;
    local equipmentSignature = reconciliationExpectedSignature('', expected)
        .. '|contextSignature=' .. contextSignature;
    if actionProbeSequence ~= '' then
        signature = signature .. '|actionProbeSequence=' .. actionProbeSequence;
        equipmentSignature = equipmentSignature .. '|actionProbeSequence=' .. actionProbeSequence;
    end
    local scheduled = state.ReconcilePendingSnapshot;
    if repair ~= true
        and observationOnly ~= true
        and state.ReconcileScanScheduled == true
        and type(scheduled) == 'table'
    then
        -- Preserve one scheduler owner. Identical equipment can coalesce on
        -- its existing timer only in the same runtime context; a different
        -- final intent/context gets a complete fresh settle window.
        local hasSupersedingIntent = type(scheduled.repairSupersedingSnapshot) == 'table';
        if hasSupersedingIntent ~= true
            and contextSignature == scheduled.contextSignature
            and equipmentSignature == scheduled.equipmentSignature
        then
            if scheduled.repair ~= true then
                scheduled.set = setName;
                scheduled.expected = expected;
                scheduled.force = force == true;
                scheduled.playstyle = state.Playstyle;
                scheduled.intent = setIntents[setName] or '';
                scheduled.actionProbeSequence = actionProbeSequence;
                scheduled.signature = signature;
                scheduled.equipmentSignature = equipmentSignature;
            end
            return;
        end
        scheduled.repairSupersedingSnapshot = {
            profileBuildToken = profileBuildToken,
            set = setName,
            expected = expected,
            force = force == true,
            playstyle = state.Playstyle,
            intent = setIntents[setName] or '',
            actionProbeSequence = actionProbeSequence,
            contextSignature = contextSignature,
            signature = signature,
            equipmentSignature = equipmentSignature,
        };
        return;
    end
    if repair ~= true
        and observationOnly ~= true
        and signature == state.ReconcileLastRecordedSignature
    then
        cancelPendingReconciliationSnapshot();
        return;
    end

    local cycleSequence = tonumber(metadata.cycleSequence);
    if cycleSequence == nil then
        state.ReconcileCycleSeq = (state.ReconcileCycleSeq or 0) + 1;
        cycleSequence = state.ReconcileCycleSeq;
    end
    state.ReconcileSnapshotSeq = (state.ReconcileSnapshotSeq or 0) + 1;
    state.ReconcilePendingSnapshot = {
        profileBuildToken = profileBuildToken,
        sequence = state.ReconcileSnapshotSeq,
        cycleSequence = cycleSequence,
        contextSignature = contextSignature,
        set = setName,
        expected = expected,
        force = force == true,
        repair = repair == true,
        repairAttempt = repair == true and (tonumber(repairAttempt) or 1) or 0,
        observationOnly = observationOnly,
        playstyle = state.Playstyle,
        intent = setIntents[setName] or '',
        actionProbeSequence = actionProbeSequence,
        signature = signature,
        equipmentSignature = equipmentSignature,
    };

    if state.ReconcileScanScheduled == true then
        return;
    end

    state.ReconcileScanScheduled = true;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
    local token = state.ReconcileScanToken;
    local delaySeconds = tonumber(metadata.delaySeconds) or reconciliationDelayForSet(setName);
    if not scheduleTask(delaySeconds, function()
        recordPendingReconciliationSnapshot(token);
    end) then
        recordPendingReconciliationSnapshot(token);
    end
end

function profile.OddLuaRuntime.RunReconciliationComposition(callback)
    if state.ReconcileCompositionActive == true then
        return callback();
    end
    state.ReconcileCompositionActive = true;
    state.ReconcileCompositionPending = nil;
    local ok, result = pcall(callback);
    local pending = state.ReconcileCompositionPending;
    state.ReconcileCompositionPending = nil;
    state.ReconcileCompositionActive = false;
    if ok ~= true then
        -- The failed composition may already have changed gear. Invalidate any
        -- older observation, repair, or reset owner before propagating the
        -- error so its queued callback cannot act on stale intent.
        cancelPendingReconciliationSnapshot();
        state.ReconcileLastRecordedSignature = nil;
        error(result, 0);
    end
    if type(pending) == 'table' then
        scheduleReconciliationSnapshot(pending.set, pending.expected, pending.force, false, nil);
    end
    return result;
end

forceReconciliationExpected = function(pending)
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    if movementSafetyActive() == true and gFunc and gFunc.ForceEquipSet then
        local ok = pcall(function()
            gFunc.ForceEquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    elseif movementSafetyActive() == true and gFunc and gFunc.EquipSet then
        local ok = pcall(function()
            gFunc.EquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    elseif scale and scale.ForceEquipSet then
        local ok = pcall(function()
            scale.ForceEquipSet(pending.set, pending.expected, pending.intent);
        end);
        return ok == true;
    elseif gFunc and gFunc.ForceEquipSet then
        local ok = pcall(function()
            gFunc.ForceEquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    elseif gFunc and gFunc.EquipSet then
        local ok = pcall(function()
            gFunc.EquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    end
    return false;
end

local function reconciliationResetSetForMismatches(pending, mismatches)
    local resetSet = {};
    for _, mismatch in ipairs(mismatches or {}) do
        local slot = tostring(mismatch.slot or '');
        local expected = type(pending.expected) == 'table' and pending.expected[slot] or nil;
        local expectedText = profile.ReconciliationNameAliases.Canonical(expected);
        if reconciliationResetBarrierSafeSlots[slot] == true
            and expectedText ~= ''
            and expectedText ~= 'remove'
        then
            resetSet[slot] = 'remove';
        end
    end
    return resetSet;
end

local function queueReconciliationResetBarrier(pending, mismatches, repairAttempt)
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    if movementSafetyActive() == true or not gFunc or not gFunc.ForceEquipSet then
        return false;
    end
    local resetSet = reconciliationResetSetForMismatches(pending, mismatches);
    if next(resetSet) == nil then
        return false;
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    local resetOk = pcall(function()
        gFunc.ForceEquipSet(resetSet);
    end);
    if resetOk ~= true then
        return false;
    end

    local nextAttempt = repairAttempt + 1;
    local resetExpected = {};
    for slot, _ in pairs(resetSet) do
        resetExpected[slot] = pending.expected[slot];
    end
    local reservation = {
        profileBuildToken = pending.profileBuildToken,
        cycleSequence = pending.cycleSequence,
        contextSignature = pending.contextSignature,
        set = pending.set,
        expected = pending.expected,
        force = true,
        repair = true,
        repairAttempt = nextAttempt,
        repairResetBarrier = true,
        repairResetExpected = resetExpected,
        playstyle = pending.playstyle,
        intent = pending.intent,
        actionProbeSequence = pending.actionProbeSequence,
        signature = pending.signature,
        equipmentSignature = pending.equipmentSignature,
    };
    state.ReconcilePendingSnapshot = reservation;
    state.ReconcileScanScheduled = true;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
    local token = state.ReconcileScanToken;
    local function releaseResetBarrier()
        state.ReconcileScanScheduled = false;
        state.ReconcilePendingSnapshot = nil;
    end
    local function supersedeResetBarrierIfNeeded()
        local superseding = reservation.repairSupersedingSnapshot;
        if type(superseding) ~= 'table' then
            return false;
        end
        releaseResetBarrier();
        state.ReconcileLastRecordedSignature = nil;
        if profile.OddLuaRuntime.ReconciliationContextMatches(superseding) ~= true then
            return true;
        end
        scheduleReconciliationSnapshot(
            superseding.set,
            superseding.expected,
            superseding.force,
            false,
            nil,
            {
                actionProbeSequence = superseding.actionProbeSequence,
                profileBuildToken = superseding.profileBuildToken,
                contextSignature = superseding.contextSignature,
            }
        );
        return true;
    end
    local function resetBarrierContextDrifted()
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) == true then
            return false;
        end
        releaseResetBarrier();
        state.ReconcileLastRecordedSignature = nil;
        return true;
    end
    local function resetBarrierCanContinue()
        if state.ReconcileEnabled ~= true then
            return false;
        end
        local contextReady = profile.OddLuaRuntime.PlayerContextReady(profile.OddLuaRuntime.GetPlayer()) == true;
        local encumbranceState = profile.OddLuaRuntime.HasEncumbrance();
        return contextReady == true
            and encumbranceState == false
            and movementSafetyActive() ~= true
            and profile.OddLuaRuntime.ReconciliationContextMatches(reservation) == true;
    end
    local function deferResetBarrier()
        releaseResetBarrier();
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) ~= true then
            state.ReconcileLastRecordedSignature = nil;
            return;
        end
        if state.ReconcileEnabled == true then
            scheduleReconciliationSnapshot(
                pending.set,
                pending.expected,
                true,
                true,
                repairAttempt,
                {
                    actionProbeSequence = pending.actionProbeSequence,
                    profileBuildToken = pending.profileBuildToken,
                    contextSignature = pending.contextSignature,
                    cycleSequence = pending.cycleSequence,
                }
            );
        end
    end
    local function forceResetBarrierExpected()
        local request = {
            profileBuildToken = reservation.profileBuildToken,
            cycleSequence = reservation.cycleSequence,
            contextSignature = reservation.contextSignature,
            set = reservation.set,
            expected = reservation.repairResetExpected,
            intent = reservation.intent,
        };
        if forceReconciliationExpected(request) then
            return true;
        end
        -- Scale can fail while raw ForceEquipSet remains available (the reset
        -- removal above already proved that path). Keep the fallback scoped to
        -- the same safe-slot subset so weapon slots can never be widened in.
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) ~= true then
            state.ReconcileLastRecordedSignature = nil;
            return false;
        end
        local ok = pcall(function()
            gFunc.ForceEquipSet(reservation.repairResetExpected);
        end);
        return ok == true;
    end
    local function completeResetBarrierReassert()
        if token ~= state.ReconcileScanToken or state.ReconcilePendingSnapshot ~= reservation then
            return;
        end
        if supersedeResetBarrierIfNeeded() then
            return;
        end
        if resetBarrierContextDrifted() then
            return;
        end
        if resetBarrierCanContinue() ~= true then
            deferResetBarrier();
            return;
        end
        releaseResetBarrier();
        -- One fixed, delayed reassert handles a partially accepted first send
        -- without widening the reset to weapon slots or creating a retry loop.
        forceResetBarrierExpected();
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) ~= true then
            state.ReconcileLastRecordedSignature = nil;
            return;
        end
        scheduleReconciliationSnapshot(
            pending.set,
            pending.expected,
            true,
            true,
            nextAttempt,
            {
                actionProbeSequence = pending.actionProbeSequence,
                profileBuildToken = pending.profileBuildToken,
                contextSignature = pending.contextSignature,
                cycleSequence = pending.cycleSequence,
            }
        );
    end
    local function completeResetBarrier()
        if token ~= state.ReconcileScanToken or state.ReconcilePendingSnapshot ~= reservation then
            return;
        end
        if supersedeResetBarrierIfNeeded() then
            return;
        end
        if resetBarrierContextDrifted() then
            return;
        end
        if resetBarrierCanContinue() ~= true then
            deferResetBarrier();
            return;
        end
        -- Keep Scale's cache aligned with the partial post-barrier request. If
        -- LuAshitacast accepts only part of this send, the guarded reassert
        -- below gets one bounded chance to finish the same safe-slot request.
        forceResetBarrierExpected();
        if resetBarrierContextDrifted() then
            return;
        end
        if not scheduleTask(reconciliationResetBarrierDelaySeconds, completeResetBarrierReassert) then
            completeResetBarrierReassert();
        end
    end
    if not scheduleTask(reconciliationResetBarrierDelaySeconds, completeResetBarrier) then
        completeResetBarrier();
    end
    return true;
end

repairReconciliationMismatch = function(pending, mismatches)
    if type(pending) ~= 'table' then
        return false;
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    if profile.OddLuaRuntime.PlayerContextReady(profile.OddLuaRuntime.GetPlayer()) ~= true then
        return false;
    end
    if not reconciliationCanRepairSet(pending.set, pending.intent) then
        return false;
    end
    local repairAttempt = tonumber(pending.repairAttempt) or 0;
    if repairAttempt >= reconciliationMaxRepairAttempts then
        return false;
    end
    local encumbranceState = profile.OddLuaRuntime.HasEncumbrance();
    if encumbranceState == true then
        return false, 'repair_paused_encumbrance';
    elseif encumbranceState ~= false then
        return false, 'repair_paused_encumbrance_unknown';
    end
    if type(pending.expected) ~= 'table' or next(pending.expected) == nil then
        return false;
    end

    if repairAttempt == 1 and queueReconciliationResetBarrier(pending, mismatches, repairAttempt) then
        return true, nil, 'reset_barrier';
    end

    local repaired = forceReconciliationExpected(pending);
    if repaired == true then
        scheduleReconciliationSnapshot(
            pending.set,
            pending.expected,
            true,
            true,
            repairAttempt + 1,
            {
                actionProbeSequence = pending.actionProbeSequence,
                profileBuildToken = pending.profileBuildToken,
                contextSignature = pending.contextSignature,
                cycleSequence = pending.cycleSequence,
            }
        );
    end
    if repaired == true then
        return true, nil, 'direct';
    end
    return false;
end

local function handleReconcileCommand(args)
    local command = normalize(args and args[2]);
    if command == 'on' then
        state.ReconcileEnabled = true;
        message('Reconciliation snapshots enabled.');
    elseif command == 'off' then
        state.ReconcileEnabled = false;
        message('Reconciliation snapshots disabled.');
    elseif command == 'status' or command == '' then
        local lastStatus = 'none';
        if state.ReconcileLast and state.ReconcileLast.status then
            lastStatus = tostring(state.ReconcileLast.status);
        end
        message('Reconcile enabled=' .. tostring(state.ReconcileEnabled == true) .. '; last=' .. lastStatus .. '; use /lac fwd reconcile on|off|status|last.');
    elseif command == 'last' then
        if not state.ReconcileLast then
            message('Reconcile last: none yet.');
            return;
        end
        message('Reconcile last set=' .. tostring(state.ReconcileLast.set) .. '; status=' .. tostring(state.ReconcileLast.status) .. '; mismatches=' .. reconciliationMismatchSlots(state.ReconcileLast.mismatches) .. '.');
    else
        message('Unknown reconcile command. Use reconcile on|off|status|last.');
    end
end
"""
    return (
        block.replace("@PLAYER@", lua_quote(player))
        .replace("@PLAYER_ID@", lua_quote(player_id))
        .replace("@JOB@", lua_quote(job))
        .replace("@LOG_PATH@", lua_quote(log_path))
        .replace("@SLOT_LINES@", slot_lines)
        .replace("@ALIAS_GROUPS@", alias_groups)
    )


def _intent_for_set_name(set_name: str, style_intents: Mapping[str, str]) -> str:
    if set_name.startswith("WSAcc_"):
        return "WeaponSkillAccuracy"
    if set_name.startswith("WS_"):
        return "Weaponskill"
    if set_name.startswith("Roll_"):
        return "Roll"
    if set_name.startswith("Song_"):
        if set_name in {"Song_Lullaby", "Song_Elegy", "Song_Requiem"}:
            return "SongDebuff"
        return "SongBuff"
    if set_name.startswith(("CureWeather_", "CureDay_")):
        return "Cure"
    if set_name.startswith(("DrainWeather_", "DrainDay_")):
        return "MagicAccuracy"
    if set_name.startswith(("MagicalBlueWeather_", "MagicalBlueDay_")):
        return "Nuke"
    if set_name.startswith(("NinjutsuWeather_", "NinjutsuDay_")):
        return "Ninjutsu"
    if set_name.startswith("QuickDrawAccuracy_"):
        return "MagicAccuracy"
    if set_name.startswith(("QuickDrawWeather_", "QuickDrawDay_")):
        if set_name.endswith(("_Light", "_Dark")):
            return "MagicAccuracy"
        return "QuickDraw"
    if set_name.startswith(("WSElementalWeather_", "WSElementalDay_")):
        return "WSElemental"
    return style_intents.get(set_name, STYLE_INTENTS.get(set_name, SEMANTIC_INTENTS.get(set_name, "TP")))


def render_profile(
    *,
    player: str,
    player_id: str,
    job: str,
    sets: dict[str, dict[str, str]],
    default_playstyle: str,
    playstyle_names: tuple[str, ...] | None = None,
    style_intents: dict[str, str] | None = None,
    subjob_profiles: Mapping[str, SubjobProfile] | None = None,
    default_subjob: str = "",
    profile_features: tuple[str, ...] | None = None,
    secondary_slot_locks: Mapping[str, Mapping[str, tuple[str, ...]]] | None = None,
    dual_wield_sub_sets: Iterable[str] | None = None,
    conditional_equips: Mapping[str, tuple[dict[str, object], ...]] | None = None,
    buff_item_overlays: Mapping[str, tuple[dict[str, object], ...]] | None = None,
    mechanics_swap_planner: Mapping[str, object] | None = None,
    number_row_palette: Mapping[str, object] | None = None,
    reconciliation_item_aliases: Mapping[str, Iterable[str]] | None = None,
    movement_penalty_items: Mapping[str, Iterable[str]] | None = None,
    forced_remove_slots: Mapping[str, Iterable[str]] | None = None,
    profile_build_token: str | None = None,
) -> str:
    style_intents = style_intents or STYLE_INTENTS
    subjob_profiles = subjob_profiles or {}
    profile_features = profile_features or tuple()
    number_row_palette = number_row_palette or {"keys": [], "bindings": [], "unbound": []}
    movement_penalty_items = movement_penalty_items or {}
    movement_penalty_lines: list[str] = []
    for slot in SLOT_ORDER:
        names = tuple(sorted({str(name).lower() for name in movement_penalty_items.get(slot, ())}))
        if not names:
            continue
        movement_penalty_lines.append(f"    {slot} = {{")
        movement_penalty_lines.extend(
            f"        [{lua_quote(name)}] = true," for name in names
        )
        movement_penalty_lines.append("    },")
    movement_penalty_block = "\n".join(movement_penalty_lines)
    aahtacos_sam_controls_enabled = AAHTACOS_SAM_CONTROLS_FEATURE in profile_features
    blue_learning_mode_enabled = (
        job.upper() == "BLU" and BLUE_LEARNING_MODE_FEATURE in profile_features
    )
    caster_sustain_mode_enabled = CASTER_SUSTAIN_MODE_FEATURE in profile_features
    guard_mode_enabled = GUARD_MODE_FEATURE in profile_features
    occult_acumen_mode_enabled = OCCULT_ACUMEN_MODE_FEATURE in profile_features
    explicit_gear_modes_enabled = EXPLICIT_GEAR_MODES_FEATURE in profile_features
    default_subjob = default_subjob.upper()
    playstyle_names = playstyle_names or tuple(sets)
    default_set_name = f"Playstyle_{default_playstyle}"
    semantic_sets = derive_semantic_sets(sets, default_playstyle)
    playstyle_sets = {
        name: sets[name]
        for name in playstyle_names
        if name in sets
    }
    exact_sets = dict(sets)
    rendered_sets = {
        **{f"Playstyle_{name}": gear for name, gear in playstyle_sets.items()},
        **exact_sets,
        **semantic_sets,
    }
    has_alacrity_celerity_surface = bool(rendered_sets.get("AlacrityCelerity"))
    rendered_intents = {
        **{
            name: _intent_for_set_name(name, style_intents)
            for name in exact_sets
        },
        **{
            f"Playstyle_{name}": _intent_for_set_name(name, style_intents)
            for name in playstyle_sets
        },
        **SEMANTIC_INTENTS,
    }
    secondary_slot_locks = secondary_slot_locks or {}
    rendered_secondary_slot_locks = {
        rendered_name: dict(locks)
        for rendered_name in rendered_sets
        if (
            locks := secondary_slot_locks.get(
                rendered_name[len("Playstyle_") :] if rendered_name.startswith("Playstyle_") else rendered_name
            )
        )
    }
    dual_wield_sub_sets = set(dual_wield_sub_sets or ())
    rendered_dual_wield_sub_sets = tuple(
        rendered_name
        for rendered_name in rendered_sets
        if (
            rendered_name in dual_wield_sub_sets
            or (
                rendered_name.startswith("Playstyle_")
                and rendered_name[len("Playstyle_") :] in dual_wield_sub_sets
            )
        )
    )
    conditional_equips = conditional_equips or {}
    rendered_conditional_equips: dict[str, tuple[dict[str, object], ...]] = {}
    global_conditional_entries = conditional_equips.get(GLOBAL_CONDITIONAL_EQUIP_KEY, tuple())
    if global_conditional_entries:
        rendered_conditional_equips["Global"] = tuple(global_conditional_entries)
    rendered_conditional_equips.update({
        rendered_name: tuple(entries)
        for rendered_name in rendered_sets
        if (
            entries := conditional_equips.get(
                rendered_name[len("Playstyle_") :] if rendered_name.startswith("Playstyle_") else rendered_name
            )
        )
    })
    forced_remove_slots = forced_remove_slots or {}
    rendered_forced_remove_slots = {
        rendered_name: tuple(slots)
        for rendered_name in rendered_sets
        if (
            slots := forced_remove_slots.get(
                rendered_name[len("Playstyle_") :] if rendered_name.startswith("Playstyle_") else rendered_name
            )
        )
    }
    buff_item_overlays = buff_item_overlays or {}
    rendered_buff_item_overlays = {
        rendered_name: tuple(entries)
        for rendered_name in rendered_sets
        if (
            entries := buff_item_overlays.get(
                rendered_name[len("Playstyle_") :] if rendered_name.startswith("Playstyle_") else rendered_name
            )
        )
    }
    set_blocks = "\n\n".join(
        render_lua_table(
            name,
            gear,
            remove_slots=(
                *secondary_lock_remove_slots(rendered_secondary_slot_locks.get(name, {})),
                *rendered_forced_remove_slots.get(name, tuple()),
            ),
        )
        for name, gear in rendered_sets.items()
    )
    secondary_slot_lock_block = render_secondary_slot_locks(rendered_secondary_slot_locks)
    dual_wield_sub_set_block = render_dual_wield_sub_sets(rendered_dual_wield_sub_sets)
    conditional_equip_block = render_conditional_equips(rendered_conditional_equips)
    buff_item_overlay_block = render_buff_item_overlays(rendered_buff_item_overlays)
    mechanics_swap_planner_block = render_mechanics_swap_planner(mechanics_swap_planner)
    mechanics_runtime_helpers = render_mechanics_runtime_helpers()
    intent_lines = "\n".join(
        f"    {name} = {lua_quote(rendered_intents.get(name, 'Idle'))},"
        for name in rendered_sets
    )
    style_alias_lines = "\n".join(
        f"    {name.lower()} = {lua_quote(name)},"
        for name in playstyle_sets
    )
    playstyle_name_lines = "\n".join(
        f"    {lua_quote(name)},"
        for name in playstyle_sets
    )
    style_names = "|".join(name.lower() for name in playstyle_sets)
    resist_aliases = render_resist_aliases()
    defense_aliases = render_defense_aliases()
    subjob_block = render_subjob_profiles(subjob_profiles)
    job_id_block = render_job_id_table()
    blue_magic_route_block = render_blue_magic_routes()
    reconciliation_helpers = render_reconciliation_helpers(
        player=player,
        player_id=player_id,
        job=job,
        reconciliation_item_aliases=reconciliation_item_aliases,
    )
    blue_learning_state_fields = render_blue_learning_state_fields(blue_learning_mode_enabled)
    blue_learning_runtime_helpers = render_blue_learning_runtime_helpers(blue_learning_mode_enabled)
    blue_learning_command_branches = render_blue_learning_command_branches(blue_learning_mode_enabled)
    blue_learning_quick_help_suffix = " | learning" if blue_learning_mode_enabled else ""
    blue_learning_help_line = (
        "    message('Blue Learning mode: /lac fwd learning on|off|status (default off).');"
        if blue_learning_mode_enabled
        else ""
    )
    blue_learning_status_fragment = (
        " .. '; learning=' .. (state.BlueLearningMode and 'on' or 'off')"
        if blue_learning_mode_enabled
        else ""
    )
    blue_learning_reconciliation_overlay = (
        "    expectedSet = overlayEquipSet(expectedSet, blueLearningModeOverlay());"
        if blue_learning_mode_enabled
        else ""
    )
    blue_learning_apply_locked = (
        "        applyBlueLearningModeOverlay(effectiveForce);"
        if blue_learning_mode_enabled
        else ""
    )
    blue_learning_apply_normal = (
        "    applyBlueLearningModeOverlay(effectiveForce);"
        if blue_learning_mode_enabled
        else ""
    )
    caster_sustain_state_fields = render_caster_sustain_state_fields(
        caster_sustain_mode_enabled
    )
    caster_sustain_runtime_helpers = render_caster_sustain_runtime_helpers(
        caster_sustain_mode_enabled
    )
    caster_sustain_command_branches = render_caster_sustain_command_branches(
        caster_sustain_mode_enabled
    )
    caster_sustain_quick_help_suffix = " | sustain" if caster_sustain_mode_enabled else ""
    caster_sustain_help_line = (
        "    message('Caster Sustain mode: /lac fwd sustain on|off|status (default off; deliberately swaps Main to Numen Staff and may reset TP; level-75 caster, engaged, and MP above zero only).');"
        if caster_sustain_mode_enabled
        else ""
    )
    caster_sustain_status_fragment = (
        " .. '; sustain=' .. (state.CasterSustainMode and 'armed' or 'off')"
        if caster_sustain_mode_enabled
        else ""
    )
    caster_sustain_reconciliation_overlay = (
        "    expectedSet = overlayEquipSet(expectedSet, profile.OddLuaRuntime.CasterSustainModeOverlay(getPlayer()));"
        if caster_sustain_mode_enabled
        else ""
    )
    caster_sustain_restore_helper = (
        """function profile.OddLuaRuntime.RestoreCasterSustainWeapon()
    state.CasterSustainActive = false;
    local ok, equipped = profile.OddLuaRuntime.RunWithCasterSustainWeaponUnlock(function()
        return equipCombatStyle(true);
    end);
    return ok == true and equipped == true;
end
"""
        if caster_sustain_mode_enabled
        else ""
    )
    caster_sustain_default_prelude = (
        """    local casterSustainEligible = profile.OddLuaRuntime.ShouldEquipCasterSustain(player);
    if state.CasterSustainActive == true and casterSustainEligible ~= true then
        profile.OddLuaRuntime.RestoreCasterSustainWeapon();
    end
"""
        if caster_sustain_mode_enabled
        else ""
    )
    caster_sustain_default_equip = (
        """            state.CasterSustainDefaultRouting = casterSustainEligible == true;
            local routeOk, equippedCombatStyle = pcall(function()
                local equipped = equipCombatStyle(force);
                if casterSustainEligible == true and equipped == true then
                    profile.OddLuaRuntime.ApplyCasterSustainOverlay();
                end
                return equipped;
            end);
            state.CasterSustainDefaultRouting = false;
            if routeOk ~= true then
                error(equippedCombatStyle);
            end"""
        if caster_sustain_mode_enabled
        else "            equipCombatStyle(force);"
    )
    guard_runtime_helpers = render_guard_runtime_helpers(guard_mode_enabled)
    guard_command_branches = render_guard_command_branches(guard_mode_enabled)
    guard_quick_help_suffix = " | guard" if guard_mode_enabled else ""
    guard_help_line = (
        "    message('Guard mode: /lac fwd guard on|off|status (default off; active only while engaged with Guard skill and Hand-to-Hand/unarmed).');"
        if guard_mode_enabled
        else ""
    )
    guard_survival_overlay_gate = (
        """        if state.IdleOverrideSet == 'Guard'
            and not profile.OddLuaRuntime.ShouldEquipGuard(getPlayer())
        then
            return false;
        end
"""
        if guard_mode_enabled
        else ""
    )
    manual_override_guard_gate = (
        " and state.IdleOverrideSet ~= 'Guard'" if guard_mode_enabled else ""
    )
    guard_safety_reason = (
        """        if state.IdleOverrideSet == 'Guard'
            and profile.OddLuaRuntime.ShouldEquipGuard(player)
            and type(sets['Guard']) == 'table'
            and not isClearSet(sets['Guard'])
        then
            return 'manual-override';
        end"""
        if guard_mode_enabled
        else ""
    )
    guard_default_equip = (
        """            if state.IdleOverrideSet == 'Guard'
                and profile.OddLuaRuntime.ShouldEquipGuard(player)
                and equipNamedSetIfNotClear('Guard', force)
            then
                return;
            end
"""
        if guard_mode_enabled
        else ""
    )
    occult_acumen_state_fields = render_occult_acumen_state_fields(occult_acumen_mode_enabled)
    occult_acumen_runtime_helpers = render_occult_acumen_runtime_helpers(occult_acumen_mode_enabled)
    occult_acumen_command_branches = render_occult_acumen_command_branches(
        occult_acumen_mode_enabled
    )
    occult_acumen_quick_help_suffix = " | acumen" if occult_acumen_mode_enabled else ""
    occult_acumen_help_line = (
        "    message('Occult Acumen mode: /lac fwd acumen on|off|status (default off; damaging Elemental/Dark Magic only).');"
        if occult_acumen_mode_enabled
        else ""
    )
    occult_acumen_status_fragment = (
        " .. '; acumen=' .. (state.OccultAcumenMode and 'on' or 'off')"
        if occult_acumen_mode_enabled
        else ""
    )
    explicit_gear_mode_state_fields = render_explicit_gear_mode_state_fields(
        explicit_gear_modes_enabled
    )
    explicit_gear_mode_runtime_helpers = render_explicit_gear_mode_runtime_helpers(
        explicit_gear_modes_enabled
    )
    explicit_gear_mode_command_branches = render_explicit_gear_mode_command_branches(
        explicit_gear_modes_enabled
    )
    explicit_gear_mode_quick_help_suffix = " | mode" if explicit_gear_modes_enabled else ""
    explicit_gear_mode_help_line = (
        "    message('Gear modes: /lac fwd mode combat|magic|proc|off|status (default off; Proc deliberately swaps Main and may reset TP).');"
        if explicit_gear_modes_enabled
        else ""
    )
    explicit_gear_mode_status_fragment = (
        " .. '; gearmode=' .. tostring(state.ExplicitGearMode)"
        if explicit_gear_modes_enabled
        else ""
    )
    explicit_gear_mode_reconciliation_overlay = (
        "    expectedSet = overlayEquipSet(expectedSet, profile.OddLuaRuntime.ExplicitGearModeOverlay('default'));"
        if explicit_gear_modes_enabled
        else ""
    )
    explicit_gear_mode_base_weapon_filter = (
        """    if state.ExplicitGearModeDefaultRouting == true
        and normalize(state.ExplicitGearMode) == 'proc'
    then
        local protectedSet = copyEquipSet(setToEquip);
        protectedSet.Main = nil;
        setToEquip = protectedSet;
    end
"""
        if explicit_gear_modes_enabled
        else ""
    )
    explicit_gear_mode_combat_wrapper = (
        """local function equipCombatStyleWithExplicitGearMode(force)
    state.ExplicitGearModeDefaultRouting = true;
    local ok, equipped = pcall(equipCombatStyle, force);
    if ok == true and equipped == true then
        profile.OddLuaRuntime.ApplyExplicitGearMode('default', force);
    end
    state.ExplicitGearModeDefaultRouting = false;
    if ok ~= true then
        error(equipped);
    end
    return equipped;
end
"""
        if explicit_gear_modes_enabled
        else ""
    )
    combat_style_equip_call = (
        "equipCombatStyleWithExplicitGearMode(force)"
        if explicit_gear_modes_enabled
        else "equipCombatStyle(force)"
    )
    caster_sustain_default_equip = caster_sustain_default_equip.replace(
        "equipCombatStyle(force)",
        combat_style_equip_call,
    )
    explicit_gear_mode_midcast_overlay = (
        """
    profile.OddLuaRuntime.ApplyExplicitGearMode('midcast', false);"""
        if explicit_gear_modes_enabled
        else ""
    )
    aahtacos_sam_status_fragment = (
        " .. '; autoCombat=' .. (state.AutoCombat and 'on' or 'off')"
        " .. '; autoThirdEye=' .. (state.AutoThirdEye and 'on' or 'off')"
        " .. '; autoWAR=' .. (state.AutoWarBuffs and 'on' or 'off')"
        if aahtacos_sam_controls_enabled
        else ""
    )
    aahtacos_sam_state_fields = render_aahtacos_sam_state_fields(aahtacos_sam_controls_enabled)
    aahtacos_sam_locals = render_aahtacos_sam_locals(aahtacos_sam_controls_enabled)
    aahtacos_sam_helpers = render_aahtacos_sam_helpers(aahtacos_sam_controls_enabled)
    aahtacos_sam_onload = render_aahtacos_sam_onload(aahtacos_sam_controls_enabled)
    aahtacos_sam_onunload = render_aahtacos_sam_onunload(aahtacos_sam_controls_enabled)
    aahtacos_sam_command_branches = render_aahtacos_sam_command_branches(aahtacos_sam_controls_enabled)
    aahtacos_sam_help_line = "        samPrintHelp();\n" if aahtacos_sam_controls_enabled else ""
    handle_default_body = render_handle_default_body(aahtacos_sam_controls_enabled)
    if has_alacrity_celerity_surface:
        handle_default_body = "    state.AlacrityCelerityPending = nil;\n" + handle_default_body
    pup_maneuver_enabled = job.upper() == "PUP"
    pup_maneuver_names_block = (
        """local elementalManeuverNames = {
    ['fire maneuver'] = true,
    ['ice maneuver'] = true,
    ['wind maneuver'] = true,
    ['earth maneuver'] = true,
    ['thunder maneuver'] = true,
    ['water maneuver'] = true,
    ['light maneuver'] = true,
    ['dark maneuver'] = true,
};"""
        if pup_maneuver_enabled
        else ""
    )
    pup_maneuver_scale_bypass = (
        """local scaleWeaponGuardBypassSlotsBySet = {
    Maneuver = { Range = true },
};"""
        if pup_maneuver_enabled
        else "local scaleWeaponGuardBypassSlotsBySet = {};"
    )
    pup_maneuver_ability_branch = (
        """    elseif name == 'activate' or elementalManeuverNames[name] == true then
        -- The Range controller is functionally required for Maneuvers and is
        -- pre-equipped for Activate. Main/Sub/Ammo stay untouched, and
        -- HandleDefault restores the current master combat or idle state.
        equipNamedSetIfNotClear('Maneuver', false);
"""
        if pup_maneuver_enabled
        else ""
    )
    number_row_bindings = render_number_row_bindings(number_row_palette)
    number_row_bind_commands = render_number_row_bind_commands(number_row_palette)
    number_row_unbind_commands = render_number_row_unbind_commands(number_row_palette)
    number_row_legacy_clear_commands = render_number_row_legacy_clear_commands(number_row_palette)
    weapon_skill_entries = _weapon_skill_route_entries(exact_sets)
    weapon_skill_route_block = "\n".join(
        f"    [{lua_quote(key)}] = {lua_quote(set_name)},"
        for key, set_name, is_accuracy in weapon_skill_entries
        if not is_accuracy
    )
    weapon_skill_accuracy_route_block = "\n".join(
        f"    [{lua_quote(key)}] = {lua_quote(set_name)},"
        for key, set_name, is_accuracy in weapon_skill_entries
        if is_accuracy
    )
    subjob_load_message = (
        f"Configured default Subjob={default_subjob}. Use /lac fwd subjob for level-37 capabilities."
        if default_subjob
        else "Use /lac fwd subjob for level-37 subjob capabilities."
    )
    has_sird_nin_surface = "SIRD_NIN" in rendered_sets
    has_conserve_mp_surface = "ConserveMP" in rendered_sets
    alacrity_celerity_state_field = (
        "    AlacrityCelerityPending = nil,"
        if has_alacrity_celerity_surface
        else ""
    )
    alacrity_celerity_runtime_helper = (
        """function profile.OddLuaRuntime.MatchingAlacrityCelerityStatus(action)
    if type(sets['AlacrityCelerity']) ~= 'table' then
        return nil;
    end
    if type(conditionals) ~= 'table'
        or type(conditionals.StatusSpellTypeMatches) ~= 'function'
    then
        return nil;
    end

    local context = {
        action = action,
        getBuffCount = getBuffCount,
    };
    if conditionals.StatusSpellTypeMatches('Alacrity', 'Black Magic', context) then
        return 'alacrity';
    end
    if conditionals.StatusSpellTypeMatches('Celerity', 'White Magic', context) then
        return 'celerity';
    end
    return nil;
end
"""
        if has_alacrity_celerity_surface
        else ""
    )
    alacrity_celerity_midcast_clear = (
        "    state.AlacrityCelerityPending = nil;\n"
        if has_alacrity_celerity_surface
        else ""
    )
    if has_alacrity_celerity_surface:
        precast_body = """    state.AlacrityCelerityPending = nil;
    local action = getAction();
    local name = normalize(action and action.Name);
    local skill = normalize(action and action.Skill);
    local baseEquipped = false;
    if skill == 'healing magic'
        and (string.find(name, 'cure', 1, true) == 1 or string.find(name, 'cura', 1, true) == 1) then
        baseEquipped = equipFirstAvailable({ 'CurePrecast', 'FastCast' }, false);
    elseif skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        baseEquipped = equipFirstAvailable({ 'SongPrecast', 'FastCast' }, false);
    end
    if baseEquipped ~= true and skill == 'elemental magic' then
        baseEquipped = equipNamedSetIfNotClear('ElementalPrecast', false);
    end
    if baseEquipped ~= true then
        equipNamedSet('FastCast', false);
        equipNamedSet('Precast', false);
    end

    local matchingStatus = profile.OddLuaRuntime.MatchingAlacrityCelerityStatus(action);
    if matchingStatus ~= nil and equipNamedSetIfNotClear('AlacrityCelerity', false) then
        state.AlacrityCelerityPending = matchingStatus;
    end"""
    else:
        precast_body = """    local action = getAction();
    local name = normalize(action and action.Name);
    local skill = normalize(action and action.Skill);
    if skill == 'healing magic'
        and (string.find(name, 'cure', 1, true) == 1 or string.find(name, 'cura', 1, true) == 1) then
        if equipFirstAvailable({ 'CurePrecast', 'FastCast' }, false) then
            return;
        end
    end
    if skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        if equipFirstAvailable({ 'SongPrecast', 'FastCast' }, false) then
            return;
        end
    end
    if skill == 'elemental magic' and equipNamedSetIfNotClear('ElementalPrecast', false) then
        return;
    end
    equipNamedSet('FastCast', false);
    equipNamedSet('Precast', false);"""
    sird_nin_runtime_helper = (
        """function profile.OddLuaRuntime.ShouldEquipSirdNin(action)
    if type(sets['SIRD_NIN']) ~= 'table' then
        return false;
    end
    if activeSubjob() ~= 'NIN' then
        return false;
    end

    local name = normalize(action and (action.Name or action.name));
    return string.find(name, 'aquaveil', 1, true) ~= nil
        or string.find(name, 'utsusemi', 1, true) ~= nil;
end
"""
        if has_sird_nin_surface
        else ""
    )
    conserve_mp_runtime_helper = (
        """function profile.OddLuaRuntime.PlayerMpp(player)
    if not player then
        return nil;
    end

    local mpp = player.MPP or player.mpp or player.MPPercent or player.mpPercent or player.MPPercentage or player.mpPercentage;
    if mpp then
        return tonumber(mpp);
    end

    local mp = profile.OddLuaRuntime.PlayerMp(player);
    local maxMp = tonumber(player.MaxMP or player.maxMP);
    if mp and maxMp and maxMp > 0 then
        return (mp / maxMp) * 100;
    end
    return nil;
end

function profile.OddLuaRuntime.ShouldEquipConserveMP(player, action)
    if type(sets['ConserveMP']) ~= 'table' then
        return false;
    end
    if not action then
        return false;
    end
    local mpp = profile.OddLuaRuntime.PlayerMpp(player);
    if mpp == nil or mpp > 50 then
        return false;
    end

    local skill = normalize(action.Skill or action.skill or action.SkillName or action.skillName);
    if skill == 'ninjutsu' then
        return false;
    end
    if skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        return false;
    end
    return true;
end
"""
        if has_conserve_mp_surface
        else ""
    )
    aquaveil_sird_nin_overlay = (
        """
        if profile.OddLuaRuntime.ShouldEquipSirdNin({ Name = name }) then
            equipNamedSetIfNotClear('SIRD_NIN', false);
        end"""
        if has_sird_nin_surface
        else ""
    )
    utsusemi_sird_nin_overlay = (
        """
        if profile.OddLuaRuntime.ShouldEquipSirdNin(action) then
            equipNamedSetIfNotClear('SIRD_NIN', false);
        end"""
        if has_sird_nin_surface
        else ""
    )
    conserve_mp_unknown_return = (
        """
    else
        return;"""
        if has_conserve_mp_surface
        else ""
    )
    conserve_mp_midcast_overlay = (
        """
    if profile.OddLuaRuntime.ShouldEquipConserveMP(getPlayer(), action) then
        equipNamedSetIfNotClear('ConserveMP', false);
    end"""
        if has_conserve_mp_surface
        else ""
    )
    occult_acumen_midcast_overlay = (
        """
    if profile.OddLuaRuntime.ShouldEquipOccultAcumen(action) then
        equipNamedSetIfNotClear('OccultAcumen', false);
    end"""
        if occult_acumen_mode_enabled
        else ""
    )
    profile_build_token_assignment = (
        f"profile.OddLuaBuildToken = {lua_quote(profile_build_token)};\n"
        if profile_build_token is not None
        else ""
    )

    return f"""local profile = {{}};
{profile_build_token_assignment}

local state = {{
    Playstyle = {lua_quote(default_playstyle)},
    IdleOverrideSet = nil,
    IdleMaxMPThreshold = 0,
    IdleMaxMPAdd = 0,
    IdleMaxHPThreshold = 0,
    IdleMaxHPAdd = 0,
    EmergencyHpActive = false,
    IdleMaxMPActive = false,
    IdleMaxHPActive = false,
    NumberRowPaletteEnabled = true,
    WarpRingLocked = false,
    PetActionPin = nil,
    LastEquippedSetName = nil,
    ActiveConditionalOverlaySlots = {{}},
    SecondarySlotLocks = {{}},
    SecondarySlotLockContextSetNames = nil,
    MechanicsProbes = false,
    MechanicsExecution = false,
    HpToMpBridgeInFlight = false,
    ReconcileEnabled = true,
    BuffItemOverlaysEnabled = true,
    ReconcileSnapshotSeq = 0,
    ReconcileCycleSeq = 0,
    ReconcilePendingSnapshot = nil,
    ReconcileScanScheduled = false,
    ReconcileScanToken = 0,
    ReconcileLastRecordedSignature = nil,
    ReconcileLast = nil,
    ReconcileCompositionActive = false,
    ReconcileCompositionPending = nil,
    ReconcileLogDirectoryReady = false,
    ReconcileLastWriteError = nil,
    StableEquipForcePending = false,
    OddLuaRefreshPending = false,
    OddLuaRefreshLastStatus = 'none',
    MagicBurstMode = false,
{alacrity_celerity_state_field}
{blue_learning_state_fields}
{caster_sustain_state_fields}
{occult_acumen_state_fields}
{explicit_gear_mode_state_fields}
{aahtacos_sam_state_fields}
}};

local sets = {{
{set_blocks}
}};

profile.Sets = sets;
local movementPenaltyItems = {{
{movement_penalty_block}
}};
profile.Packer = {{}};
profile.GetThreatEntities = nil;

{subjob_block}

profile.Subjobs = subjobs;

{job_id_block}

local setIntents = {{
{intent_lines}
}};

local styleAliases = {{
{style_alias_lines}
}};

local playstyleNames = {{
{playstyle_name_lines}
}};

{number_row_bindings}

local DEFAULT_PLAYSTYLE = {lua_quote(default_playstyle)};
local STYLE_COMMANDS_TEXT = {lua_quote(style_names)};
{resist_aliases}
{defense_aliases}
local oddLuaRefresh = {{
    launcher = {lua_quote(ODDLUA_REFRESH_LAUNCHER)},
    statusPath = {lua_quote(ODDLUA_REFRESH_STATUS_PATH)},
    delaySeconds = 12,
    resourceDelaySeconds = 18,
    pollSeconds = 5,
    maxPolls = 48,
}};

{secondary_slot_lock_block}

local nativeDualWieldMainJobs = {{
    DNC = 20,
    NIN = 10,
    THF = 20,
}};

{dual_wield_sub_set_block}

{conditional_equip_block}

{buff_item_overlay_block}

{mechanics_swap_planner_block}

{blue_magic_route_block}

local weaponSkillRoutes = {{
{weapon_skill_route_block}
}};

local weaponSkillAccuracyRoutes = {{
{weapon_skill_accuracy_route_block}
}};

{pup_maneuver_names_block}

{aahtacos_sam_locals}

local OVERT_DEFENSE_TARGET_COUNT = 3;
local OVERT_DEFENSE_TP_UNLOCK = 700;
local OVERT_DEFENSE_HP_FORCE_HPP = 60;

local dangerousStatusBuffs = {{
    bind = true,
    doom = true,
    ['gradual petrification'] = true,
    petrification = true,
    sleep = true,
    stun = true,
    terror = true,
}};

local dangerousStatusIds = {{ 2, 7, 10, 11, 15, 18, 19, 28 }};

local cityZoneIds = {{
    [26] = true,  -- Tavnazian Safehold
    [48] = true,  -- Al Zahbi
    [50] = true,  -- Aht Urhgan Whitegate
    [53] = true,  -- Nashmau
    [80] = true,  -- Southern San d'Oria [S]
    [87] = true,  -- Bastok Markets [S]
    [94] = true,  -- Windurst Waters [S]
    [230] = true, -- Southern San d'Oria
    [231] = true, -- Northern San d'Oria
    [232] = true, -- Port San d'Oria
    [233] = true, -- Chateau d'Oraguille
    [234] = true, -- Bastok Mines
    [235] = true, -- Bastok Markets
    [236] = true, -- Port Bastok
    [237] = true, -- Metalworks
    [238] = true, -- Windurst Waters
    [239] = true, -- Windurst Walls
    [240] = true, -- Port Windurst
    [241] = true, -- Windurst Woods
    [242] = true, -- Heavens Tower
    [243] = true, -- Ru'Lude Gardens
    [244] = true, -- Upper Jeuno
    [245] = true, -- Lower Jeuno
    [246] = true, -- Port Jeuno
    [247] = true, -- Rabao
    [248] = true, -- Selbina
    [249] = true, -- Mhaura
    [250] = true, -- Kazham
    [252] = true, -- Norg
    [256] = true, -- Western Adoulin
    [257] = true, -- Eastern Adoulin
}};

local cityAreas = {{
    ["southern san d'oria"] = true,
    ["northern san d'oria"] = true,
    ["port san d'oria"] = true,
    ["chateau d'oraguille"] = true,
    ["bastok mines"] = true,
    ["bastok markets"] = true,
    ["port bastok"] = true,
    ["metalworks"] = true,
    ["windurst waters"] = true,
    ["windurst walls"] = true,
    ["port windurst"] = true,
    ["windurst woods"] = true,
    ["heavens tower"] = true,
    ["ru'lude gardens"] = true,
    ["upper jeuno"] = true,
    ["lower jeuno"] = true,
    ["port jeuno"] = true,
    ["aht urhgan whitegate"] = true,
    ["al zahbi"] = true,
    ["nashmau"] = true,
    ["tavnazian safehold"] = true,
    ["rabao"] = true,
    ["selbina"] = true,
    ["mhaura"] = true,
    ["norg"] = true,
    ["kazham"] = true,
    ["western adoulin"] = true,
    ["eastern adoulin"] = true,
    ["residential area"] = true,
    ["southern san d'oria [s]"] = true,
    ["bastok markets [s]"] = true,
    ["windurst waters [s]"] = true,
}};

local equipmentSlots = {{
    'Main',
    'Sub',
    'Range',
    'Ammo',
    'Head',
    'Neck',
    'Ear1',
    'Ear2',
    'Body',
    'Hands',
    'Ring1',
    'Ring2',
    'Back',
    'Waist',
    'Legs',
    'Feet',
}};

local scale = nil;
if gFunc and gFunc.LoadFile then
    local ok, loaded = pcall(function()
        return gFunc.LoadFile('common/scale.lua');
    end);
    if ok then
        scale = loaded;
    end
end

local conditionals = nil;
if gFunc and gFunc.LoadFile then
    local ok, loaded = pcall(function()
        return gFunc.LoadFile('common/conditionals.lua');
    end);
    if ok then
        conditionals = loaded;
    end
end

local function message(text)
    text = '[{player} {job}] ' .. tostring(text or '');
    if gFunc and gFunc.Message then
        gFunc.Message(text);
    else
        print(text);
    end
end

local function queueTypedCommand(command, mode)
    if not AshitaCore or not AshitaCore.GetChatManager then
        return false;
    end

    local chatManager = AshitaCore:GetChatManager();
    if not chatManager or not chatManager.QueueCommand then
        return false;
    end

    local ok = pcall(function()
        chatManager:QueueCommand(mode or 1, command);
    end);
    return ok == true;
end

local function nowSeconds()
    if os and os.time then
        return os.time();
    elseif os and os.clock then
        return os.clock();
    end
    return 0;
end

local function scheduleTask(delay, callback)
    if ashita and ashita.tasks and ashita.tasks.once then
        local ok = pcall(function()
            ashita.tasks.once(delay, callback);
        end);
        return ok == true;
    end
    return false;
end

local function normalize(value)
    return string.lower(tostring(value or ''));
end

profile.BuffItemContainers = {{ 0, 8, 10, 11, 12, 13, 14, 15, 16 }};

function profile.BuffItemOverlaysEnabled()
    return state.BuffItemOverlaysEnabled == true;
end

function profile.BuffItemOverlayStateText()
    if profile.BuffItemOverlaysEnabled() then
        return 'on';
    end
    return 'off';
end

function profile.HandleBuffItemOverlayCommand(args)
    local value = normalize(args and args[2]);
    if value == 'on' or value == 'enable' or value == 'enabled' or value == 'true' or value == '1' then
        state.BuffItemOverlaysEnabled = true;
        message('Buff item overlays=on.');
    elseif value == 'off' or value == 'disable' or value == 'disabled' or value == 'false' or value == '0' then
        state.BuffItemOverlaysEnabled = false;
        message('Buff item overlays=off.');
    elseif value == '' or value == 'status' or value == 'help' then
        message('Buff item overlays=' .. profile.BuffItemOverlayStateText() .. '; use /lac fwd buffitems on|off|status.');
    else
        message('Unknown buffitems command. Use /lac fwd buffitems on|off|status.');
    end
end

function profile.BuffItemInventory()
    if not AshitaCore then
        return nil;
    end

    if AshitaCore.GetMemoryManager then
        local okManager, manager = pcall(function()
            return AshitaCore:GetMemoryManager();
        end);
        if okManager and manager and manager.GetInventory then
            local okInventory, inventory = pcall(function()
                return manager:GetInventory();
            end);
            if okInventory and inventory then
                return inventory;
            end
        end
    end

    if AshitaCore.GetDataManager then
        local okManager, manager = pcall(function()
            return AshitaCore:GetDataManager();
        end);
        if okManager and manager and manager.GetInventory then
            local okInventory, inventory = pcall(function()
                return manager:GetInventory();
            end);
            if okInventory and inventory then
                return inventory;
            end
        end
    end

    return nil;
end

function profile.BuffItemContainerMax(inventory, container)
    if not inventory then
        return 80;
    end

    local maxValue = nil;
    if inventory.GetContainerMax then
        pcall(function()
            maxValue = inventory:GetContainerMax(container);
        end);
    end
    if maxValue == nil and inventory.GetContainerCountMax then
        pcall(function()
            maxValue = inventory:GetContainerCountMax(container);
        end);
    end
    if maxValue == nil and inventory.GetContainerItemCount then
        pcall(function()
            maxValue = inventory:GetContainerItemCount(container);
        end);
    end

    maxValue = tonumber(maxValue);
    if maxValue ~= nil and maxValue >= 0 and maxValue <= 200 then
        return maxValue;
    end
    return 80;
end

function profile.BuffItemContainerItem(inventory, container, index)
    if not inventory then
        return nil;
    end

    if inventory.GetContainerItem then
        local ok, item = pcall(function()
            return inventory:GetContainerItem(container, index);
        end);
        if ok and item then
            return item;
        end
    end
    if inventory.GetItem then
        local ok, item = pcall(function()
            return inventory:GetItem(container, index);
        end);
        if ok and item then
            return item;
        end
    end
    return nil;
end

function profile.BuffItemEntryId(entry)
    if type(entry) ~= 'table' or type(entry.item) ~= 'table' then
        return nil;
    end
    return tonumber(entry.item.id or entry.item.Id or entry.item.itemId or entry.item.ItemId);
end

function profile.BuffItemRuntimeItemId(item)
    local itemType = type(item);
    if itemType ~= 'table' and itemType ~= 'userdata' then
        return nil;
    end
    return tonumber(item.Id or item.id or item.ItemId or item.itemId or item.Item or item.item);
end

function profile.BuffItemRuntimeItemCount(item)
    local itemType = type(item);
    if itemType ~= 'table' and itemType ~= 'userdata' then
        return nil;
    end
    return tonumber(item.Count or item.count or item.Quantity or item.quantity or item.Charges or item.charges or item.Uses or item.uses);
end

function profile.BuffItemHasUsesLeft(entry)
    local wantedId = profile.BuffItemEntryId(entry);
    if wantedId == nil then
        return false;
    end

    local inventory = profile.BuffItemInventory();
    if not inventory then
        return false;
    end

    for _, container in ipairs(profile.BuffItemContainers or {{}}) do
        local maxIndex = profile.BuffItemContainerMax(inventory, container);
        for index = 0, maxIndex do
            local item = profile.BuffItemContainerItem(inventory, container, index);
            if profile.BuffItemRuntimeItemId(item) == wantedId then
                local count = profile.BuffItemRuntimeItemCount(item);
                if count ~= nil and count > 0 then
                    return true;
                end
            end
        end
    end
    return false;
end

local function styleListText()
    local parts = {{}};
    for _, styleName in ipairs(playstyleNames) do
        local token = normalize(styleName);
        local label = token;
        if styleName == state.Playstyle and styleName == DEFAULT_PLAYSTYLE then
            label = label .. ' (current, default)';
        elseif styleName == state.Playstyle then
            label = label .. ' (current)';
        elseif styleName == DEFAULT_PLAYSTYLE then
            label = label .. ' (default)';
        end
        parts[#parts + 1] = label;
    end
    if #parts == 0 then
        return STYLE_COMMANDS_TEXT;
    end
    return table.concat(parts, ' | ');
end

local function printStyleList()
    message('Styles: ' .. styleListText() .. '. Use /lac fwd style <name>.');
end

local function printOddLuaHelp()
    message('Quick start: /lac fwd help | styles | status | keypad | lockstyle | weaponsync | warp | subjob | buffitems | pdt | fireres{blue_learning_quick_help_suffix}{caster_sustain_quick_help_suffix}{guard_quick_help_suffix}{occult_acumen_quick_help_suffix}{explicit_gear_mode_quick_help_suffix}.');
    message('Current style=' .. tostring(state.Playstyle) .. '; default=' .. tostring(DEFAULT_PLAYSTYLE) .. '.');
    printStyleList();
    message('Lockstyle: /lac fwd lockstyle equips the TP set first, then /lockstyle on.');
    message('Weapon sync: /lac fwd weaponsync deliberately equips only the active style Main/Sub/Range through Scale and may reset TP; the weapon lock is restored immediately.');
    message('Keypad macros: /lac fwd keypad shows keypad map; /lac fwd keypad off disables; /lac fwd keypad clear unbinds keypad and old number-row keys.');
    message('Buff item overlays: /lac fwd buffitems on|off|status.');
    message('Conditional overlays: /lac fwd overlays.');
    message('Magic Burst mode: /lac fwd burst on|off|status (default off).');
{blue_learning_help_line}
{caster_sustain_help_line}
{guard_help_line}
{occult_acumen_help_line}
{explicit_gear_mode_help_line}
    message('Defensive overrides: /lac fwd pdt|mdt|dt|evasion|safe|survival|tank|defenseoff.');
    message('Resist overrides: /lac fwd fireres|iceres|earthres|windres|waterres|thunderres|lightningres|lightres|darkres|statusres|charmres|resoff.');
    message('Idle pool floors: /lac fwd setmp <n>|addmp <n>|resetmp and sethp <n>|addhp <n>|resethp.');
    message('Update gear: /lac fwd updategear; status: /lac fwd updategear status.');
end

local function oddLuaStatusField(text, field)
    if type(text) ~= 'string' then
        return nil;
    end
    local pattern = '"' .. field .. '"%s*:%s*"([^"]*)"';
    return string.match(text, pattern);
end

local function readOddLuaRefreshStatus()
    if not io or not io.open then
        return nil, 'io.open unavailable';
    end

    local file = io.open(oddLuaRefresh.statusPath, 'rb');
    if not file then
        return nil, 'status not ready';
    end

    local text = file:read('*a') or '';
    file:close();
    local status = normalize(oddLuaStatusField(text, 'state') or oddLuaStatusField(text, 'status') or '');
    local detail = oddLuaStatusField(text, 'message') or '';
    if status == '' then
        return nil, 'status missing';
    end
    return status, detail;
end

local function pollOddLuaRefreshStatus(attempt)
    attempt = tonumber(attempt or 1) or 1;
    local status, detail = readOddLuaRefreshStatus();
    if status == 'success' then
        state.OddLuaRefreshPending = false;
        state.OddLuaRefreshLastStatus = 'success';
        message('OddLua gear refresh complete. Reloading LuAshitacast profile.');
        queueTypedCommand('/lac reload', 1);
        return;
    elseif status == 'failed' or status == 'error' then
        state.OddLuaRefreshPending = false;
        state.OddLuaRefreshLastStatus = 'failed';
        message('OddLua gear refresh failed: ' .. tostring(detail or '') .. '. Use /lac fwd refreshgear status.');
        return;
    end

    state.OddLuaRefreshLastStatus = status or 'running';
    if attempt >= oddLuaRefresh.maxPolls then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh still running or status unavailable after polling. Use /lac fwd refreshgear status.');
        return;
    end

    if not scheduleTask(oddLuaRefresh.pollSeconds, function()
        pollOddLuaRefreshStatus(attempt + 1);
    end) then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh poll scheduling failed. Use /lac fwd refreshgear status.');
    end
end

local function launchOddLuaGearRefresh()
    if not ashita or not ashita.misc or not ashita.misc.execute then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed: command launcher unavailable in this runtime.');
        return false;
    end

    local ok, err = pcall(function()
        ashita.misc.execute(oddLuaRefresh.launcher, '');
    end);
    if not ok then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed to launch.');
        return false;
    end

    message('OddLua refresh launched. Polling status.');
    pollOddLuaRefreshStatus(1);
    return true;
end

local function startOddLuaGearRefresh(args)
    local option = normalize(args and args[2]);
    if option == 'status' then
        local status, detail = readOddLuaRefreshStatus();
        message('OddLua refresh status=' .. tostring(status or state.OddLuaRefreshLastStatus or 'unknown') .. '; detail=' .. tostring(detail or '') .. '; pending=' .. tostring(state.OddLuaRefreshPending == true));
        return;
    end

    if state.OddLuaRefreshPending == true then
        message('OddLua gear refresh is already pending; use /lac fwd refreshgear status.');
        return;
    end

    local includeResources = option == 'resources' or option == 'full';
    if not queueTypedCommand('/gearexport full', 1) then
        message('OddLua gear refresh failed: could not queue /gearexport full.');
        return;
    end

    state.OddLuaRefreshPending = true;
    state.OddLuaRefreshLastStatus = 'queued';
    if includeResources then
        if not scheduleTask(2, function()
            queueTypedCommand('/gearexport resources', 1);
        end) then
            queueTypedCommand('/gearexport resources', 1);
        end
    end

    local delay = oddLuaRefresh.delaySeconds;
    if includeResources then
        delay = oddLuaRefresh.resourceDelaySeconds;
    end
    message('Queued /gearexport full. OddLua rebuild/apply will launch in ' .. tostring(delay) .. ' seconds.');
    if not scheduleTask(delay, launchOddLuaGearRefresh) then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed: scheduler unavailable after gearexport.');
    end
end

profile.OddLuaRuntime = profile.OddLuaRuntime or {{}};
profile.OddLuaRuntime.Hysteresis = {{
    EmergencyHpEnterHpp = 35,
    EmergencyHpExitHpp = 40,
    IdlePoolBand = 10,
}};
profile.OddLuaRuntime.MountedStatusBuffs = {{ 'chocobo', 'mount', 'mounted', 252 }};
profile.OddLuaRuntime.EncumbranceStatusBuffs = {{ 'encumbrance', 177, 259 }};

profile.OddLuaRuntime.StatusRemovalSpells = {{
    blindna = true,
    cursna = true,
    erase = true,
    esuna = true,
    paralyna = true,
    poisona = true,
    sacrifice = true,
    silena = true,
    stona = true,
    viruna = true,
}};

function profile.OddLuaRuntime.GetPlayer()
    if not gData or not gData.GetPlayer then
        return nil;
    end
    local ok, player = pcall(gData.GetPlayer);
    if ok == true and type(player) == 'table' then
        return player;
    end
    return nil;
end

function profile.OddLuaRuntime.GetEnvironment()
    if not gData or not gData.GetEnvironment then
        return nil;
    end
    local ok, environment = pcall(gData.GetEnvironment);
    if ok ~= true or type(environment) ~= 'table' then
        return nil;
    end
    if AshitaCore and AshitaCore.GetMemoryManager then
        local okZone, zoneId = pcall(function()
            return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
        end);
        if okZone then
            environment.ZoneId = zoneId;
        end
    end
    return environment;
end

local function movementEquipItemName(item)
    if type(item) == 'string' then
        return item;
    elseif type(item) == 'table' then
        if item.Name ~= nil then
            return item.Name;
        elseif item.name ~= nil then
            return item.name;
        elseif type(item.Resource) == 'table' and type(item.Resource.Name) == 'table' then
            return item.Resource.Name[1];
        elseif type(item.Item) == 'table' and item.Item.Name ~= nil then
            return item.Item.Name;
        end
    end
    return nil;
end

function profile.OddLuaRuntime.PlayerIsMoving(player)
    if type(player) ~= 'table' then
        return false;
    end
    local value = player.IsMoving;
    if value == nil then value = player.isMoving; end
    if value == nil then value = player.Moving; end
    if value == nil then value = player.moving; end
    local text = normalize(value);
    return value == true or text == 'true' or text == '1' or text == 'yes';
end

local function movementSafetyActive()
    if next(movementPenaltyItems) == nil then
        return false;
    end
    local player = profile.OddLuaRuntime.GetPlayer();
    if profile.OddLuaRuntime.PlayerIsMoving(player) ~= true then
        return false;
    end
    if type(profile.OddLuaRuntime.IsOnFoot) == 'function' then
        local ok, onFoot = pcall(profile.OddLuaRuntime.IsOnFoot, player);
        if ok == true and onFoot ~= true then
            return false;
        end
    end
    return true;
end

local function movementSafeEquipSet(set)
    local safe = {{}};
    if type(set) ~= 'table' then
        return safe;
    end
    for slot, item in pairs(set) do
        safe[slot] = item;
    end
    if movementSafetyActive() ~= true then
        return safe;
    end

    local observed = nil;
    if gData and gData.GetEquipment then
        local ok, equipment = pcall(gData.GetEquipment);
        if ok == true and type(equipment) == 'table' then
            observed = equipment;
        end
    end

    for slot, names in pairs(movementPenaltyItems) do
        local requestedName = normalize(movementEquipItemName(safe[slot]));
        if requestedName ~= '' and names[requestedName] == true then
            safe[slot] = 'remove';
        elseif safe[slot] == nil then
            local observedName = '';
            if observed ~= nil then
                observedName = normalize(movementEquipItemName(observed[slot]));
            end
            if observed == nil or (observedName ~= '' and names[observedName] == true) then
                safe[slot] = 'remove';
            end
        end
    end
    return safe;
end

profile.OddLuaRuntime.MovementSafeEquipSet = movementSafeEquipSet;

function profile.OddLuaRuntime.PlayerContextReady(player)
    if type(player) ~= 'table' then
        return false;
    end
    local name = tostring(player.Name or player.name or '');
    local hp = tonumber(player.HP or player.hp or player.CurrentHP or player.currentHP);
    local hpp = tonumber(
        player.HPP or player.hpp or player.HPPercent or player.hpPercent
        or player.HPPercentage or player.hpPercentage
    );
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    if name == '' or hp == nil or hp <= 0 then
        return false;
    end
    if hpp == nil or hpp <= 0 then
        return false;
    end
    if status == '' or status == 'unknown' or status == 'dead' or status == 'zoning'
        or status == '2' or status == '3' or status == '4' then
        return false;
    end
    return true;
end

{reconciliation_helpers}

local function weaponSkillRouteKey(name)
    local text = normalize(name);
    text = string.gsub(text, ':', '_');
    text = string.gsub(text, '-', '_');
    text = string.gsub(text, '%s+', '_');
    text = string.gsub(text, '[^%w_]', '');
    text = string.gsub(text, '_+', '_');
    return text;
end

local function getPlayer()
    return profile.OddLuaRuntime.GetPlayer();
end

profile.OddLuaPet = {{}};

function profile.OddLuaPet.getPet()
    if gData and gData.GetPet then
        local ok, pet = pcall(gData.GetPet);
        if ok then
            return pet;
        end
    end

    local player = getPlayer();
    if type(player) == 'table' then
        return player.Pet or player.pet or player.PetName or player.petName;
    end
    return nil;
end

{mechanics_runtime_helpers}

local function getAction()
    if gData and gData.GetAction then
        return gData.GetAction();
    end
    return nil;
end

local function getEnvironment()
    return profile.OddLuaRuntime.GetEnvironment();
end

local function truthy(value)
    if value == true then
        return true;
    end
    local text = normalize(value);
    return text == 'true' or text == '1' or text == 'yes';
end

local function environmentHour(environment)
    if not environment then
        return nil;
    end

    local timestamp = environment.Timestamp or environment.timestamp;
    if type(timestamp) == 'table' then
        local hour = tonumber(timestamp.hour or timestamp.Hour);
        if hour then
            return hour;
        end
    end

    local hour = tonumber(environment.Hour or environment.hour or environment.VanaHour or environment.vanaHour);
    if hour then
        return hour;
    end

    local time = tonumber(environment.Time or environment.time or environment.VanaTime or environment.vanaTime);
    if time then
        return math.floor(time);
    end
    return nil;
end

local function isCity(environment)
    if not environment then
        return false;
    end

    if truthy(environment.inCity or environment.InCity or environment.city or environment.City) then
        return true;
    end

    local zoneId = tonumber(environment.ZoneId or environment.zoneId or environment.Zone or environment.zone);
    if zoneId and cityZoneIds[zoneId] then
        return true;
    end

    local area = normalize(environment.Area or environment.area or environment.ZoneName or environment.zoneName);
    return cityAreas[area] == true;
end

local function isNight(environment)
    local hour = environmentHour(environment);
    if hour == nil then
        return false;
    end
    return hour >= 20 or hour < 4;
end

local function isDuskToDawn(environment)
    local hour = environmentHour(environment);
    if hour == nil then
        return false;
    end
    return hour >= 18 or hour < 6;
end

local function getBuffCount(name)
    if name == nil or tostring(name) == '' or not gData or not gData.GetBuffCount then
        return 0, false;
    end

    local ok, count = pcall(gData.GetBuffCount, name);
    if ok and type(count) == 'number' then
        return count, true;
    end
    return 0, false;
end

local function hasBuff(name)
    local count, known = getBuffCount(name);
    return known == true and count > 0;
end

{alacrity_celerity_runtime_helper}

profile.OddLuaRuntime.IncapacitatingStatusBuffs = {{
    'sleep', 'sleep ii', 'stun', 'lullaby', 'petrification', 'terror', 'impairment',
    2, 7, 10, 19, 28, 193, 261,
}};

profile.OddLuaRuntime.AmnesiaStatusBuffs = {{ 'amnesia', 16 }};
profile.OddLuaRuntime.WeaknessStatusBuffs = {{ 'weakness', 1 }};
profile.OddLuaRuntime.CurseStatusBuffs = {{ 'curse', 9, 20 }};

function profile.OddLuaRuntime.StatusListState(statuses)
    local unknown = false;
    for _, status in ipairs(statuses or {{}}) do
        local count, known = getBuffCount(status);
        if known ~= true then
            unknown = true;
        elseif count > 0 then
            return true;
        end
    end
    if unknown then
        return nil;
    end
    return false;
end

function profile.OddLuaRuntime.HasIncapacitatingStatus()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.IncapacitatingStatusBuffs);
end

function profile.OddLuaRuntime.HasAmnesia()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.AmnesiaStatusBuffs);
end

function profile.OddLuaRuntime.HasWeakness()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.WeaknessStatusBuffs);
end

function profile.OddLuaRuntime.HasEncumbrance()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.EncumbranceStatusBuffs);
end

function profile.OddLuaRuntime.DangerousStatusState()
    local unknown = false;
    for name in pairs(dangerousStatusBuffs) do
        local count, known = getBuffCount(name);
        if known ~= true then
            unknown = true;
        elseif count > 0 then
            return true;
        end
    end
    for _, id in ipairs(dangerousStatusIds) do
        local count, known = getBuffCount(id);
        if known ~= true then
            unknown = true;
        elseif count > 0 then
            return true;
        end
    end
    if unknown then
        return nil;
    end
    return false;
end

local function hasDangerousStatus()
    return profile.OddLuaRuntime.DangerousStatusState() == true;
end

local function activeSubjob()
    local player = getPlayer();
    if player then
        local subjob = player.SubJob or player.subJob or player.Subjob or player.subjob or player.SubJobName or player.subJobName;
        if subjob and tostring(subjob) ~= '' then
            local numeric = tonumber(subjob);
            if numeric and jobIdToAbbr[numeric] then
                return jobIdToAbbr[numeric];
            end
            return string.upper(tostring(subjob));
        end
    end
    return {lua_quote(default_subjob)};
end

local function currentSubjobProfile()
    local subjob = activeSubjob();
    return subjobs[subjob], subjob;
end
{sird_nin_runtime_helper}
local function hasSubjobCapability(capability)
    local subjob = currentSubjobProfile();
    if not subjob or not capability then
        return false;
    end
    local wanted = normalize(capability);
    for _, value in ipairs(subjob.capabilities or {{}}) do
        if normalize(value) == wanted then
            return true;
        end
    end
    return false;
end

profile.HasSubjobCapability = hasSubjobCapability;

local function mainJobHasNativeDualWield()
    local minimumLevel = nativeDualWieldMainJobs[{lua_quote(job.upper())}];
    if type(minimumLevel) ~= 'number' then
        return false;
    end
    local player = gData.GetPlayer();
    if type(player) ~= 'table' then
        return false;
    end
    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
    );
    return mainLevel ~= nil and mainLevel >= minimumLevel;
end

local function setWithSubjobLegalOffhand(setName, set)
    if type(set) ~= 'table' then
        return set;
    end
    if setRequiresDualWieldSub[setName] ~= true then
        return set;
    end
    if mainJobHasNativeDualWield() or hasSubjobCapability('dual_wield') then
        return set;
    end

    local adjusted = {{}};
    for slot, item in pairs(set) do
        adjusted[slot] = item;
    end
    adjusted.Sub = 'remove';
    return adjusted;
end

local function summarizeSubjobEntries(entries, label)
    local parts = {{}};
    for _, entry in ipairs(entries or {{}}) do
        local text = tostring(entry.name or '');
        if entry.level then
            text = text .. '@' .. tostring(entry.level);
        end
        if entry.mod and entry.value then
            text = text .. '(' .. tostring(entry.mod) .. tostring(entry.value) .. ')';
        end
        table.insert(parts, text);
    end
    if #parts == 0 then
        return label .. '=none';
    end
    return label .. '=' .. table.concat(parts, ',');
end

local function isEngaged(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'engaged' or status == 'attack' or status == 'attacking' or status == '1';
end

function profile.OddLuaRuntime.CanIssueAutomaticJobAbility(player)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true or not isEngaged(player) then
        return false;
    end
    if profile.OddLuaRuntime.HasIncapacitatingStatus() ~= false then
        return false;
    end
    if profile.OddLuaRuntime.HasAmnesia() ~= false then
        return false;
    end
    return true;
end

local function isResting(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'resting' or status == 'healing' or status == '33' or status == '34';
end

local function isMounted(player)
    if player then
        if truthy(player.Mounted or player.mounted or player.IsMounted or player.isMounted or player.OnMount or player.onMount) then
            return true;
        end

        local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
        if status == 'mounted' or status == 'mount' or status == 'chocobo' or status == '252' then
            return true;
        end
    end

    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.MountedStatusBuffs);
end

function profile.OddLuaRuntime.IsOnFoot(player)
    return isMounted(player) == false;
end

local function canEquipMovement(player, environment)
    if not profile.OddLuaRuntime.IsOnFoot(player) then
        return false;
    end
    return profile.OddLuaRuntime.PlayerIsMoving(player) == true;
end

local function shouldEquipInCityMovement(player, environment)
    return isCity(environment) and profile.OddLuaRuntime.IsOnFoot(player);
end

local function playerHpp(player)
    if not player then
        return nil;
    end

    local hpp = player.HPP or player.hpp or player.HPPercent or player.hpPercent or player.HPPercentage or player.hpPercentage;
    if hpp then
        return tonumber(hpp);
    end

    local hp = tonumber(player.HP or player.hp);
    local maxHp = tonumber(player.MaxHP or player.maxHP);
    if hp and maxHp and maxHp > 0 then
        return (hp / maxHp) * 100;
    end
    return nil;
end

function profile.OddLuaRuntime.PlayerHp(player)
    if not player then
        return nil;
    end
    return tonumber(player.HP or player.hp or player.CurrentHP or player.currentHP);
end

function profile.OddLuaRuntime.PlayerMp(player)
    if not player then
        return nil;
    end
    return tonumber(player.MP or player.mp or player.CurrentMP or player.currentMP);
end
{conserve_mp_runtime_helper}
local function playerTp(player)
    if not player then
        return 0;
    end
    return tonumber(player.TP or player.tp or player.TacticalPoints or player.tacticalPoints or 0) or 0;
end

local function isEmergencyHp(player)
    if player == nil then
        state.EmergencyHpActive = false;
        return false;
    end
    local hpp = playerHpp(player);
    local thresholds = profile.OddLuaRuntime.Hysteresis;
    return profile.OddLuaRuntime.UpdateHysteresisState(
        'EmergencyHpActive',
        hpp ~= nil,
        hpp ~= nil and hpp <= thresholds.EmergencyHpEnterHpp,
        hpp ~= nil and hpp >= thresholds.EmergencyHpExitHpp
    );
end

function profile.OddLuaRuntime.IsEmergencyHp(player)
    return isEmergencyHp(player);
end

{aahtacos_sam_helpers}

local function setNameFor(styleName)
    return 'Playstyle_' .. tostring(styleName or state.Playstyle);
end

local function isClearSet(set)
    if type(set) ~= 'table' then
        return false;
    end

    for _, slot in ipairs(equipmentSlots) do
        local item = set[slot];
        if item == nil then
            return false;
        end

        if type(item) == 'string' then
            if normalize(item) ~= 'remove' then
                return false;
            end
        elseif type(item) == 'table' then
            if normalize(item.Name or item.name) ~= 'remove' then
                return false;
            end
        else
            return false;
        end
    end

    return true;
end

local function firstAvailableDefensiveSet()
    local candidates = {{ 'IdleCombat', 'Dt', 'PDT', 'Playstyle_Safe', 'Safe', 'Survival', 'Tank', 'Evasion', 'MDT', 'MagicDefense' }};
    for _, setName in ipairs(candidates) do
        local set = sets[setName];
        if type(set) == 'table' and not isClearSet(set) then
            return setName;
        end
    end
    return nil;
end

local function providedThreatEntities(player)
    if type(profile.GetThreatEntities) == 'function' then
        local ok, entities = pcall(profile.GetThreatEntities, player);
        if ok and type(entities) == 'table' then
            return entities;
        end
    end
    if gData and type(gData.GetThreatEntities) == 'function' then
        local ok, entities = pcall(gData.GetThreatEntities, player);
        if ok and type(entities) == 'table' then
            return entities;
        end
    end
    return nil;
end

local function isIncrediblyToughEntity(entity)
    if type(entity) ~= 'table' then
        return false;
    end
    if entity.IsIncrediblyTough == true or entity.isIncrediblyTough == true then
        return true;
    end
    local difficulty = normalize(
        entity.Difficulty
        or entity.difficulty
        or entity.Check
        or entity.check
        or entity.CheckMessage
        or entity.checkMessage
        or entity.DifficultyText
        or entity.difficultyText
    );
    return difficulty == 'it'
        or difficulty == 'incredibly tough'
        or difficulty == 'incredibly_tough'
        or difficulty == 'incrediblytough';
end

local function addThreatIdentifier(identifiers, value)
    if value ~= nil and tostring(value) ~= '' then
        identifiers[tostring(value)] = true;
    end
end

local function playerThreatIdentifiers(player)
    local identifiers = {{}};
    if type(player) ~= 'table' then
        return identifiers;
    end
    addThreatIdentifier(identifiers, player.Id or player.ID or player.id);
    addThreatIdentifier(identifiers, player.ServerId or player.ServerID or player.serverId or player.serverID);
    addThreatIdentifier(identifiers, player.TargetIndex or player.targetIndex or player.Index or player.index);
    addThreatIdentifier(identifiers, player.Name or player.name);
    return identifiers;
end

local function threatValueIsActive(value)
    if value == true then
        return true;
    end
    if type(value) == 'number' then
        return value > 0;
    end
    if type(value) == 'string' then
        local normalized = normalize(value);
        return normalized == 'true' or normalized == 'yes' or normalized == 'active' or tonumber(value) ~= nil and tonumber(value) > 0;
    end
    return type(value) == 'table';
end

local function threatEntryMatchesPlayer(entry, identifiers)
    if type(entry) ~= 'table' then
        return false;
    end
    local id = entry.Id or entry.ID or entry.id or entry.ServerId or entry.ServerID or entry.serverId or entry.serverID;
    local index = entry.Index or entry.index or entry.TargetIndex or entry.targetIndex;
    local name = entry.Name or entry.name;
    if (id ~= nil and identifiers[tostring(id)] == true)
        or (index ~= nil and identifiers[tostring(index)] == true)
        or (name ~= nil and identifiers[tostring(name)] == true) then
        return threatValueIsActive(entry.Threat or entry.threat or entry.Enmity or entry.enmity or true);
    end
    return false;
end

local function entityHasPlayerThreat(entity, player)
    if type(entity) ~= 'table' then
        return false;
    end
    for _, field in ipairs({{ 'HasPlayerThreat', 'hasPlayerThreat', 'OnPlayerThreatTable', 'onPlayerThreatTable', 'PlayerThreat', 'playerThreat', 'ClaimedByPlayer', 'claimedByPlayer' }}) do
        if threatValueIsActive(entity[field]) then
            return true;
        end
    end

    local identifiers = playerThreatIdentifiers(player);
    for _, field in ipairs({{ 'TargetId', 'targetId', 'TargetID', 'targetID', 'TargetServerId', 'targetServerId', 'TargetIndex', 'targetIndex' }}) do
        local value = entity[field];
        if value ~= nil and identifiers[tostring(value)] == true then
            return true;
        end
    end

    local threatTable = entity.ThreatTable or entity.threatTable or entity.Threat or entity.threat or entity.Enmity or entity.enmity;
    if type(threatTable) ~= 'table' then
        return false;
    end
    for key, value in pairs(threatTable) do
        if identifiers[tostring(key)] == true and threatValueIsActive(value) then
            return true;
        end
        if threatEntryMatchesPlayer(value, identifiers) then
            return true;
        end
    end
    return false;
end

local function countOvertDefenseThreats(player)
    local entities = providedThreatEntities(player);
    if type(entities) ~= 'table' then
        return 0;
    end

    local count = 0;
    for _, entity in pairs(entities) do
        if isIncrediblyToughEntity(entity) and entityHasPlayerThreat(entity, player) then
            count = count + 1;
        end
    end
    return count;
end

function profile.OddLuaRuntime.CountPlayerThreats(player)
    local entities = providedThreatEntities(player);
    if type(entities) ~= 'table' then
        return 0;
    end

    local count = 0;
    for _, entity in pairs(entities) do
        if entityHasPlayerThreat(entity, player) then
            count = count + 1;
        end
    end
    return count;
end

function profile.OddLuaRuntime.ShouldEquipIdleCombat(player)
    if not player or isEngaged(player) or isResting(player) then
        return false;
    end
    return profile.OddLuaRuntime.CountPlayerThreats(player) > 0;
end

function profile.OddLuaRuntime.IdlePoolFloor(threshold, extra)
    local floor = (tonumber(threshold or 0) or 0) + (tonumber(extra or 0) or 0);
    if floor < 0 then
        return 0;
    end
    return floor;
end

function profile.OddLuaRuntime.UpdateHysteresisState(fieldName, observed, shouldEnter, shouldExit)
    if fieldName ~= 'EmergencyHpActive'
        and fieldName ~= 'IdleMaxMPActive'
        and fieldName ~= 'IdleMaxHPActive' then
        return false;
    end
    if observed ~= true then
        return state[fieldName] == true;
    end
    if state[fieldName] == true then
        if shouldExit == true then
            state[fieldName] = false;
        end
    elseif shouldEnter == true then
        state[fieldName] = true;
    end
    return state[fieldName] == true;
end

function profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player)
    if not player or isEngaged(player) or isResting(player) then
        state.IdleMaxMPActive = false;
        return false;
    end
    local floor = profile.OddLuaRuntime.IdlePoolFloor(state.IdleMaxMPThreshold, state.IdleMaxMPAdd);
    if floor <= 0 then
        state.IdleMaxMPActive = false;
        return false;
    end
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    local exitFloor = math.max(0, floor - profile.OddLuaRuntime.Hysteresis.IdlePoolBand);
    return profile.OddLuaRuntime.UpdateHysteresisState(
        'IdleMaxMPActive',
        mp ~= nil,
        mp ~= nil and mp >= floor,
        mp ~= nil and mp <= exitFloor
    );
end

function profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player)
    if not player or isEngaged(player) or isResting(player) then
        state.IdleMaxHPActive = false;
        return false;
    end
    local floor = profile.OddLuaRuntime.IdlePoolFloor(state.IdleMaxHPThreshold, state.IdleMaxHPAdd);
    if floor <= 0 then
        state.IdleMaxHPActive = false;
        return false;
    end
    local hp = profile.OddLuaRuntime.PlayerHp(player);
    return profile.OddLuaRuntime.UpdateHysteresisState(
        'IdleMaxHPActive',
        hp ~= nil,
        hp ~= nil and hp < floor,
        hp ~= nil and hp >= floor + profile.OddLuaRuntime.Hysteresis.IdlePoolBand
    );
end

local function shouldEquipOvertDefense(player)
    if not player or not isEngaged(player) then
        return nil;
    end
    if countOvertDefenseThreats(player) < OVERT_DEFENSE_TARGET_COUNT then
        return nil;
    end

    local defensiveSet = firstAvailableDefensiveSet();
    if not defensiveSet then
        return nil;
    end
    local hpp = playerHpp(player);
    if hpp ~= nil and hpp < OVERT_DEFENSE_HP_FORCE_HPP then
        return defensiveSet, true;
    end
    local tp = playerTp(player);
    if tp < OVERT_DEFENSE_TP_UNLOCK then
        return defensiveSet, tp == 0;
    end
    return nil;
end

function profile.OddLuaRuntime.ActiveSafetyReason(player)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return 'none';
    end
    if hasDangerousStatus() then
        return 'dangerous-status';
    end
    if profile.OddLuaRuntime.HasWeakness() == true then
        return 'weakness';
    end
    if (player and isResting(player)) or state.Playstyle == 'Craft' then
        return 'none';
    end
    if state.IdleOverrideSet ~= nil{manual_override_guard_gate}
        and type(sets[state.IdleOverrideSet]) == 'table'
        and not isClearSet(sets[state.IdleOverrideSet])
    then
        return 'manual-override';
    end
    if player and isEngaged(player) then
        if shouldEquipOvertDefense(player) ~= nil then
            return 'overt-threat';
        end
        if isEmergencyHp(player) and firstAvailableDefensiveSet() ~= nil then
            return 'emergency-hp';
        end
{guard_safety_reason}
    end
    return 'none';
end

local function applyWarpRingLock(set)
    if state.WarpRingLocked ~= true or type(set) ~= 'table' then
        return set;
    end

    local lockedSet = {{}};
    for slot, item in pairs(set) do
        lockedSet[slot] = item;
    end
    lockedSet.Ring2 = 'Warp Ring';
    return lockedSet;
end

local function desiredSecondarySlotLocks(setName)
    local desired = {{}};
    local setLocks = setSecondarySlotLocks[setName];
    if type(setLocks) ~= 'table' then
        return desired;
    end

    for _, lockedSlots in pairs(setLocks) do
        if type(lockedSlots) == 'table' then
            for _, slot in ipairs(lockedSlots) do
                desired[slot] = true;
            end
        end
    end
    return desired;
end

local function desiredSecondarySlotLocksForSetNames(setNames)
    local desired = {{}};
    if type(setNames) ~= 'table' then
        return desired;
    end

    for _, setName in ipairs(setNames) do
        local setDesired = desiredSecondarySlotLocks(setName);
        for slot, _ in pairs(setDesired) do
            desired[slot] = true;
        end
    end
    return desired;
end

local function contextSecondarySlotSafeSet(set)
    local contextSetNames = state.SecondarySlotLockContextSetNames;
    if type(set) ~= 'table' or type(contextSetNames) ~= 'table' then
        return set;
    end

    local lockedSlots = desiredSecondarySlotLocksForSetNames(contextSetNames);
    if next(lockedSlots) == nil then
        return set;
    end

    local safe = {{}};
    for slot, item in pairs(set) do
        if lockedSlots[slot] ~= true then
            safe[slot] = item;
        end
    end
    return safe;
end

local function contextSafeEquipSet(set)
    return movementSafeEquipSet(contextSecondarySlotSafeSet(set));
end

local contextSafeGFunc = {{}};
contextSafeGFunc.EquipSet = function(set)
    if gFunc and gFunc.EquipSet then
        return gFunc.EquipSet(contextSafeEquipSet(set));
    end
    return nil;
end;
contextSafeGFunc.ForceEquipSet = function(set)
    if gFunc and gFunc.ForceEquipSet then
        return gFunc.ForceEquipSet(contextSafeEquipSet(set));
    elseif gFunc and gFunc.EquipSet then
        return gFunc.EquipSet(contextSafeEquipSet(set));
    end
    return nil;
end;

local function releaseSecondarySlotLocksNotInSetNames(setNames)
    local active = state.SecondarySlotLocks;
    if type(active) ~= 'table' then
        state.SecondarySlotLocks = {{}};
        return;
    end

    local desired = desiredSecondarySlotLocksForSetNames(setNames);
    local slotsToEnable = {{}};
    for slot, _ in pairs(active) do
        if desired[slot] ~= true then
            slotsToEnable[#slotsToEnable + 1] = slot;
        end
    end

    for _, slot in ipairs(slotsToEnable) do
        active[slot] = nil;
    end

    for _, slot in ipairs(slotsToEnable) do
        if gFunc and gFunc.Enable then
            gFunc.Enable(slot);
        end
    end
end

local function releaseSecondarySlotLocksNotInSet(setName)
    local contextSetNames = state.SecondarySlotLockContextSetNames;
    if type(contextSetNames) == 'table' then
        releaseSecondarySlotLocksNotInSetNames(contextSetNames);
        return;
    end

    releaseSecondarySlotLocksNotInSetNames({{ setName }});
end

local function applySecondarySlotLocksForSet(setName)
    local active = state.SecondarySlotLocks;
    if type(active) ~= 'table' then
        active = {{}};
        state.SecondarySlotLocks = active;
    end

    local desired = desiredSecondarySlotLocks(setName);
    local slotsToDisable = {{}};
    for slot, _ in pairs(desired) do
        if active[slot] ~= true then
            slotsToDisable[#slotsToDisable + 1] = slot;
        end
    end

    for _, slot in ipairs(slotsToDisable) do
        active[slot] = true;
    end

    for _, slot in ipairs(slotsToDisable) do
        if gFunc and gFunc.Disable then
            gFunc.Disable(slot);
        end
    end
end

local function unlockSecondarySlotLocks()
    local active = state.SecondarySlotLocks;
    if type(active) ~= 'table' then
        state.SecondarySlotLocks = {{}};
        return;
    end

    local slotsToEnable = {{}};
    for slot, _ in pairs(active) do
        slotsToEnable[#slotsToEnable + 1] = slot;
    end

    for _, slot in ipairs(slotsToEnable) do
        active[slot] = nil;
    end

    for _, slot in ipairs(slotsToEnable) do
        if gFunc and gFunc.Enable then
            gFunc.Enable(slot);
        end
    end
end

local function buildConditionalOverlayForSet(setName, context)
    return conditionals.BuildOverlay(conditionalEquips[setName], context);
end

local function applyConditionalEquipsForSet(setName, baseSet, force)
    if not conditionals or not conditionals.BuildOverlay then
        return false;
    end

    local ok, overlay = pcall(function()
        return buildConditionalOverlayForSet(setName, {{
            force = force,
            gFunc = contextSafeGFunc,
            getBuffCount = getBuffCount,
            getEnvironment = getEnvironment,
            getPlayer = getPlayer,
            hasBuff = hasBuff,
            itemHasUsesLeft = profile.BuffItemHasUsesLeft,
            state = state,
        }});
    end);
    if ok ~= true or type(overlay) ~= 'table' then
        overlay = {{}};
    end

    local previousSlots = state.ActiveConditionalOverlaySlots;
    if type(previousSlots) ~= 'table' then
        previousSlots = {{}};
    end
    local restoration = {{}};
    local activeSlots = {{}};
    for slot, _ in pairs(previousSlots) do
        if overlay[slot] == nil then
            if state.WarpRingLocked == true and slot == 'Ring2' then
                activeSlots[slot] = true;
            else
                local baseItem = type(baseSet) == 'table' and baseSet[slot] or nil;
                restoration[slot] = baseItem or 'remove';
            end
        end
    end
    for slot, _ in pairs(overlay) do
        activeSlots[slot] = true;
    end
    state.ActiveConditionalOverlaySlots = activeSlots;

    local equipped = false;
    for _, candidate in ipairs({{ restoration, overlay }}) do
        if next(candidate) ~= nil then
            if force == true and gFunc and gFunc.ForceEquipSet then
                gFunc.ForceEquipSet(contextSafeEquipSet(candidate));
                equipped = true;
            elseif gFunc and gFunc.EquipSet then
                gFunc.EquipSet(contextSafeEquipSet(candidate));
                equipped = true;
            end
        end
    end
    return equipped;
end

function profile.ApplyBuffItemOverlaysForSet(setName, force)
    if not conditionals or not conditionals.ApplyForSet then
        return false;
    end

    local equipped = false;
    if profile.BuffItemAfterUseOverlayForSet then
        local afterUseOverlay = profile.BuffItemAfterUseOverlayForSet(setName, force);
        if next(afterUseOverlay) ~= nil then
            if force == true and gFunc and gFunc.ForceEquipSet then
                gFunc.ForceEquipSet(contextSafeEquipSet(afterUseOverlay));
                equipped = true;
            elseif gFunc and gFunc.EquipSet then
                gFunc.EquipSet(contextSafeEquipSet(afterUseOverlay));
                equipped = true;
            end
        end
    end

    if profile.BuffItemOverlaysEnabled() ~= true then
        return equipped;
    end

    local overlayEquipped = conditionals.ApplyForSet(profile.BuffItemOverlays, setName, {{
        force = force,
        gFunc = contextSafeGFunc,
        getBuffCount = getBuffCount,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        itemHasUsesLeft = profile.BuffItemHasUsesLeft,
        state = state,
    }});
    return equipped or overlayEquipped;
end

local reconciliationProtectedWeaponSlots = {{
    Main = true,
    Sub = true,
    Range = true,
}};

{pup_maneuver_scale_bypass}

local function profileSlotsDroppedByScale(setName, requestedSet, appliedSet)
    local dropped = {{}};
    if type(requestedSet) ~= 'table' then
        return dropped;
    end
    if type(appliedSet) ~= 'table' then
        appliedSet = {{}};
    end

    local bypassSlots = scaleWeaponGuardBypassSlotsBySet[setName] or {{}};
    for _, slot in ipairs(equipmentSlots) do
        local requestedRemove = normalize(requestedSet[slot]) == 'remove';
        local scaleChangedRemove = requestedRemove and normalize(appliedSet[slot]) ~= 'remove';
        if requestedSet[slot] ~= nil
            and (appliedSet[slot] == nil or scaleChangedRemove)
            and (reconciliationProtectedWeaponSlots[slot] ~= true
                or bypassSlots[slot] == true) then
            dropped[slot] = requestedSet[slot];
        end
    end
    return dropped;
end

local function copyEquipSet(set)
    local copy = {{}};
    if type(set) ~= 'table' then
        return copy;
    end
    for slot, item in pairs(set) do
        copy[slot] = item;
    end
    return copy;
end

local function overlayEquipSet(baseSet, overlay)
    local result = copyEquipSet(baseSet);
    if type(overlay) ~= 'table' then
        return result;
    end
    for slot, item in pairs(overlay) do
        result[slot] = item;
    end
    return result;
end

function profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, requestedSet)
    local guardedSet = copyEquipSet(requestedSet);
    local bypassSlots = scaleWeaponGuardBypassSlotsBySet[setName] or {{}};
    for slot, _ in pairs(reconciliationProtectedWeaponSlots) do
        if bypassSlots[slot] ~= true then
            guardedSet[slot] = nil;
        end
    end
    return guardedSet;
end

local function equipProfileSlotsDroppedByScale(setName, requestedSet, appliedSet, force)
    local dropped = profileSlotsDroppedByScale(setName, requestedSet, appliedSet);
    if next(dropped) == nil then
        return appliedSet;
    end
    dropped = movementSafeEquipSet(dropped);

    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(dropped);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(dropped);
    end
    return overlayEquipSet(appliedSet, dropped);
end

local function reconciliationEquipContext(force)
    return {{
        force = force,
        gFunc = contextSafeGFunc,
        getBuffCount = getBuffCount,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        itemHasUsesLeft = profile.BuffItemHasUsesLeft,
        state = state,
    }};
end

local function conditionalOverlayForSet(setName, force)
    if not conditionals or not conditionals.BuildOverlay then
        return {{}};
    end

    local ok, overlay = pcall(function()
        return buildConditionalOverlayForSet(setName, reconciliationEquipContext(force));
    end);
    if ok and type(overlay) == 'table' then
        return overlay;
    end
    return {{}};
end

local function globalConditionalOverlay(force)
    if not conditionals or not conditionals.BuildOverlay then
        return {{}};
    end

    local ok, overlay = pcall(function()
        return conditionals.BuildOverlay(conditionalEquips.Global, reconciliationEquipContext(force));
    end);
    if ok and type(overlay) == 'table' then
        return overlay;
    end
    return {{}};
end

local function applyGlobalConditionalEquips(force)
    local overlay = globalConditionalOverlay(force);
    if next(overlay) == nil then
        return false;
    end
    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(contextSafeEquipSet(overlay));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(contextSafeEquipSet(overlay));
        return true;
    end
    return false;
end

{blue_learning_runtime_helpers}

{caster_sustain_runtime_helpers}

{guard_runtime_helpers}

{occult_acumen_runtime_helpers}

{explicit_gear_mode_runtime_helpers}

function profile.BuffItemAfterUseOverlayForSet(setName, force)
    if not conditionals or not conditionals.ConditionMatches then
        return {{}};
    end

    local entries = profile.BuffItemOverlays[setName];
    if type(entries) ~= 'table' then
        return {{}};
    end

    local context = reconciliationEquipContext(force);
    local overlay = {{}};
    local function setOwnsSlot(slot)
        local set = sets[setName];
        return type(set) == 'table' and set[slot] ~= nil;
    end
    for _, entry in ipairs(entries) do
        if type(entry) == 'table' then
            local hasUsesLeft = true;
            if type(entry.item) == 'table' then
                hasUsesLeft = profile.BuffItemHasUsesLeft(entry) == true;
            end
            if profile.BuffItemOverlaysEnabled() ~= true
                or conditionals.ConditionMatches(entry.condition, context) ~= true
                or hasUsesLeft ~= true then
                for slot, item in pairs(entry.afterUse or {{}}) do
                    if normalize(item) ~= 'remove' or setOwnsSlot(slot) then
                        overlay[slot] = item;
                    end
                end
            end
        end
    end
    if state.WarpRingLocked == true then
        overlay.Ring2 = nil;
    end
    return overlay;
end

function profile.BuffItemOverlayForSet(setName, force)
    if not conditionals or not conditionals.BuildOverlay then
        return {{}};
    end
    if profile.BuffItemOverlaysEnabled() ~= true then
        return {{}};
    end

    local ok, overlay = pcall(function()
        return conditionals.BuildOverlay(profile.BuffItemOverlays[setName], reconciliationEquipContext(force));
    end);
    if ok and type(overlay) == 'table' then
        return overlay;
    end
    return {{}};
end

local function shouldExpectProtectedWeapons(intent)
    local status = nil;
    if scale and scale.Status then
        local ok, result = pcall(scale.Status);
        if ok and type(result) == 'table' then
            status = result;
        end
    end

    if status and status.weaponLockEnabled == false then
        return false;
    end
    if status and tonumber(status.tp or 0) and tonumber(status.tp or 0) > 0 then
        return true;
    end
    if status and isEngaged(status) then
        return intent ~= 'TP';
    end

    local player = getPlayer();
    if playerTp(player) > 0 then
        return true;
    end
    if isEngaged(player) then
        return intent ~= 'TP';
    end
    return false;
end

local function expectedSetWithProtectedWeapons(expectedSet, requestedSet, intent)
    local expected = copyEquipSet(expectedSet);
    if not shouldExpectProtectedWeapons(intent) then
        return expected;
    end

    local observed = observeReconciliationEquipment();
    if type(observed) ~= 'table' then
        return expected;
    end

    for slot, _ in pairs(reconciliationProtectedWeaponSlots) do
        if requestedSet and requestedSet[slot] ~= nil and expected[slot] == nil and observed[slot] ~= nil then
            expected[slot] = observed[slot];
        end
    end
    return expected;
end

local function resolvedReconciliationExpectedSet(setName, requestedSet, appliedSet, force)
    local expectedSet = copyEquipSet(appliedSet);
    if next(expectedSet) == nil then
        expectedSet = copyEquipSet(requestedSet);
    end
    expectedSet = expectedSetWithProtectedWeapons(expectedSet, requestedSet, setIntents[setName]);
    expectedSet = overlayEquipSet(expectedSet, conditionalOverlayForSet(setName, force));
    expectedSet = overlayEquipSet(expectedSet, profile.BuffItemAfterUseOverlayForSet(setName, force));
    expectedSet = overlayEquipSet(expectedSet, profile.BuffItemOverlayForSet(setName, force));
    expectedSet = overlayEquipSet(expectedSet, globalConditionalOverlay(force));
{caster_sustain_reconciliation_overlay}
{blue_learning_reconciliation_overlay}
{explicit_gear_mode_reconciliation_overlay}
    return contextSafeEquipSet(expectedSet);
end

local function isStableEquipIntent(setName)
    if state.IdleOverrideSet == setName then
        return true;
    end
    local intent = normalize(setIntents[setName] or '');
    return intent == 'tp' or intent == 'idle' or intent == 'movement';
end

local function stableEquipForceForSet(setName, setToEquip, force)
    if force == true then
        if isStableEquipIntent(setName) then
            state.StableEquipForcePending = false;
        end
        return true;
    end
    if state.StableEquipForcePending == true and isStableEquipIntent(setName) and not isClearSet(setToEquip) then
        state.StableEquipForcePending = false;
        return true;
    end
    return false;
end

local function markStableEquipForceNeeded(setName, force)
    if force == true then
        return;
    end
    if not isStableEquipIntent(setName) then
        state.StableEquipForcePending = true;
    end
end

local function equipNamedSet(setName, force, requestedSet)
    local set = requestedSet or sets[setName];
    if not set then
        return false;
    end

    local setToEquip = setWithSubjobLegalOffhand(setName, set);
    setToEquip = contextSecondarySlotSafeSet(setToEquip);
{explicit_gear_mode_base_weapon_filter}
    local effectiveForce = stableEquipForceForSet(setName, setToEquip, force);
    if isClearSet(setToEquip) then
        markStableEquipForceNeeded(setName, effectiveForce);
        return false;
    end

    releaseSecondarySlotLocksNotInSet(setName);

    if state.WarpRingLocked == true then
        local appliedLockedSet = nil;
        if scale and scale.ResolveSet then
            local ok, resolved = pcall(scale.ResolveSet, setName, setToEquip, setIntents[setName]);
            if ok == true and type(resolved) == 'table' then
                appliedLockedSet = resolved;
            end
        end
        if type(appliedLockedSet) ~= 'table' then
            appliedLockedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, setToEquip);
        end
        appliedLockedSet = movementSafeEquipSet(applyWarpRingLock(appliedLockedSet));
        local requestedLockedSet = applyWarpRingLock(setToEquip);
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(appliedLockedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(appliedLockedSet);
        end
        applyConditionalEquipsForSet(setName, appliedLockedSet, effectiveForce);
        profile.ApplyBuffItemOverlaysForSet(setName, effectiveForce);
        applyGlobalConditionalEquips(effectiveForce);
{blue_learning_apply_locked}
        applySecondarySlotLocksForSet(setName);
        local equippedSet = resolvedReconciliationExpectedSet(setName, requestedLockedSet, appliedLockedSet, effectiveForce);
        scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
        markStableEquipForceNeeded(setName, effectiveForce);
        state.LastEquippedSetName = setName;
        return true;
    end

    local appliedSet = setToEquip;
    local usedScaleResolver = false;
    if movementSafetyActive() == true then
        -- Resolve first, then apply movement safety and dispatch directly so a
        -- movement-penalty item cannot be restored by a stale Scale copy.
        if scale and scale.ResolveSet then
            local ok, resolved = pcall(scale.ResolveSet, setName, setToEquip, setIntents[setName]);
            if ok == true and type(resolved) == 'table' then
                appliedSet = resolved;
                usedScaleResolver = true;
            end
        end
        if usedScaleResolver ~= true then
            appliedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, appliedSet);
        end
        appliedSet = movementSafeEquipSet(appliedSet);
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(appliedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(appliedSet);
        end
    elseif effectiveForce == true and scale and scale.ForceEquipSet then
        appliedSet = scale.ForceEquipSet(setName, setToEquip, setIntents[setName]);
        usedScaleResolver = true;
    elseif scale and scale.EquipSet then
        appliedSet = scale.EquipSet(setName, setToEquip, setIntents[setName]);
        usedScaleResolver = true;
    elseif effectiveForce == true and gFunc and gFunc.ForceEquipSet then
        appliedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, setToEquip);
        gFunc.ForceEquipSet(movementSafeEquipSet(appliedSet));
    elseif gFunc and gFunc.EquipSet then
        appliedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, setToEquip);
        gFunc.EquipSet(movementSafeEquipSet(appliedSet));
    end
    if usedScaleResolver == true then
        local recoverySet = setToEquip;
        if movementSafetyActive() == true then
            recoverySet = movementSafeEquipSet(recoverySet);
        end
        appliedSet = equipProfileSlotsDroppedByScale(setName, recoverySet, appliedSet, effectiveForce);
    end
    applyConditionalEquipsForSet(setName, appliedSet, effectiveForce);
    profile.ApplyBuffItemOverlaysForSet(setName, effectiveForce);
    applyGlobalConditionalEquips(effectiveForce);
{blue_learning_apply_normal}
    applySecondarySlotLocksForSet(setName);
    local equippedSet = resolvedReconciliationExpectedSet(setName, setToEquip, appliedSet, effectiveForce);
    scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
    markStableEquipForceNeeded(setName, effectiveForce);
    state.LastEquippedSetName = setName;
    return true;
end

local function equipNamedSetIfNotClear(setName, force)
    local set = sets[setName];
    if not set or isClearSet(set) then
        return false;
    end
    return equipNamedSet(setName, force);
end

function profile.OddLuaRuntime.ManualOverrideSourceSetName(setName)
    local candidates = {{}};
    local transition = nil;
    if type(mechanicsSwapPlanner) == 'table' and type(mechanicsSwapPlanner.transitions) == 'table' then
        transition = mechanicsSwapPlanner.transitions[setName];
    end
    if type(transition) == 'table' then
        table.insert(candidates, transition.sourceSet);
    end
    if type(mechanicsSwapPlanner) == 'table' then
        table.insert(candidates, mechanicsSwapPlanner.baselineSet);
    end
    table.insert(candidates, 'Aftercast');
    table.insert(candidates, 'Idle');

    local seen = {{}};
    for _, candidate in ipairs(candidates) do
        if type(candidate) == 'string' and candidate ~= '' and candidate ~= setName
            and seen[candidate] ~= true
        then
            seen[candidate] = true;
            if type(sets[candidate]) == 'table' and not isClearSet(sets[candidate]) then
                return candidate;
            end
        end
    end
    return nil;
end

function profile.OddLuaRuntime.BuildManualOverrideSet(setName)
    local targetSet = sets[setName];
    if type(targetSet) ~= 'table' or isClearSet(targetSet) then
        return nil, nil;
    end
    local sourceSetName = profile.OddLuaRuntime.ManualOverrideSourceSetName(setName);
    if sourceSetName == nil then
        return nil, nil;
    end
    local composedSet = overlayEquipSet(sets[sourceSetName], targetSet);
    for _, slot in ipairs(equipmentSlots) do
        if composedSet[slot] == nil then
            composedSet[slot] = 'remove';
        end
    end
    return composedSet, sourceSetName;
end

function profile.OddLuaRuntime.EquipManualOverrideSet(setName, force)
    local composedSet = profile.OddLuaRuntime.BuildManualOverrideSet(setName);
    if type(composedSet) ~= 'table' then
        return false;
    end
    return equipNamedSet(setName, force, composedSet);
end

local function equipOvertDefensiveSet(setName, unlockWeapons)
    if not setName then
        return false;
    end

    -- Ordinary three-target pressure still needs defensive armor, but it must
    -- keep Scale's weapon guard.  Only zero TP or the already-qualified
    -- sub-60% HP emergency is allowed to unlock weapons.
    if unlockWeapons ~= true then
        return equipNamedSet(setName, true);
    end

    local status = {{}};
    if scale and scale.Status then
        local ok, result = pcall(scale.Status);
        if ok and type(result) == 'table' then
            status = result;
        end
    end
    local previousWeaponLockEnabled = status.weaponLockEnabled == true;

    if scale and scale.SetWeaponLockEnabled then
        local unlockOk = pcall(scale.SetWeaponLockEnabled, false);
        if unlockOk ~= true then
            return equipNamedSet(setName, true);
        end
    else
        return equipNamedSet(setName, true);
    end
    local ok, equipped = pcall(equipNamedSet, setName, true);
    local restoreOk = pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    if restoreOk ~= true then
        return false;
    end
    return ok == true and equipped == true;
end

local function forceEquipInlineSet(set, ignoreWarpRingLock)
    if type(set) ~= 'table' then
        return false;
    end

    local setToEquip = set;
    if ignoreWarpRingLock ~= true then
        setToEquip = applyWarpRingLock(set);
    end

    if gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(movementSafeEquipSet(setToEquip));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(movementSafeEquipSet(setToEquip));
        return true;
    end
    return false;
end

function profile.OddLuaRuntime.ExplicitSetMpBridgePlan()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        return nil;
    end
    local explicitTransitions = mechanicsSwapPlanner.explicitTransitions;
    if type(explicitTransitions) ~= 'table' then
        return nil;
    end
    local plan = explicitTransitions.setmp;
    if type(plan) ~= 'table' or plan.available ~= true then
        return nil;
    end
    if plan.targetSet ~= 'IdleMaxMP' or type(sets[plan.targetSet]) ~= 'table'
        or isClearSet(sets[plan.targetSet]) then
        return nil;
    end
    if type(plan.sourceSet) ~= 'string' or plan.sourceSet == ''
        or type(plan.sourceEquipment) ~= 'table'
        or type(plan.sourceVariants) ~= 'table'
        or type(plan.targetEquipment) ~= 'table'
        or type(plan.slot) ~= 'string' or plan.slot == ''
        or type(plan.sourceItem) ~= 'string' or plan.sourceItem == ''
        or type(plan.bridgeItem) ~= 'string' or plan.bridgeItem == ''
        or type(plan.finalItem) ~= 'string' or plan.finalItem == ''
    then
        return nil;
    end

    local knownSlot = false;
    for _, slot in ipairs(equipmentSlots) do
        if slot == plan.slot then
            knownSlot = true;
            break;
        end
    end
    if knownSlot ~= true
        or not reconciliationNamesMatch(plan.sourceItem, plan.sourceEquipment[plan.slot] or '')
        or reconciliationNamesMatch(plan.sourceItem, plan.bridgeItem)
        or reconciliationNamesMatch(plan.bridgeItem, plan.finalItem)
    then
        return nil;
    end

    local targetItem = reconciliationExpectedName(plan.targetEquipment[plan.slot]);
    if targetItem == nil or not reconciliationNamesMatch(plan.finalItem, targetItem) then
        return nil;
    end
    for slot, expected in pairs(plan.targetEquipment) do
        local namedTarget = reconciliationExpectedName(sets[plan.targetSet][slot]);
        if namedTarget == nil or not reconciliationNamesMatch(expected, namedTarget) then
            return nil;
        end
    end
    if (tonumber(plan.conversionAmount) or 0) <= 0
        or (tonumber(plan.bridgeHpCost) or -1) < 0
        or (tonumber(plan.hpCost) or -1) < 0
        or (tonumber(plan.mpGain) or 0) <= 0
        or tonumber(plan.sourceKnownHp) == nil
        or tonumber(plan.sourceKnownMp) == nil
        or tonumber(plan.targetHp) == nil
        or tonumber(plan.targetMp) == nil
    then
        return nil;
    end
    return plan;
end

function profile.OddLuaRuntime.ExplicitSetMpBridgeGate(player, plan)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player unavailable';
    end
    if isEngaged(player) or isResting(player) then
        return false, 'not idle';
    end
    if state.Playstyle == 'Craft' then
        return false, 'craft active';
    end
    if state.WarpRingLocked == true then
        return false, 'warp ring locked';
    end
    if state.IdleOverrideSet ~= nil then
        return false, 'override active';
    end
    if profile.OddLuaRuntime.DangerousStatusState() ~= false
        or profile.OddLuaRuntime.HasWeakness() ~= false
        or profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.CurseStatusBuffs) ~= false
    then
        return false, 'status unsafe';
    end
    if profile.OddLuaRuntime.ActiveSafetyReason(player) ~= 'none'
        or profile.OddLuaRuntime.ShouldEquipIdleCombat(player)
        or isEmergencyHp(player)
    then
        return false, 'safety active';
    end
    if profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) ~= true then
        return false, 'MP floor inactive';
    end

    local hp = profile.OddLuaRuntime.PlayerHp(player);
    local maxHp = tonumber(player.MaxHP or player.maxHP or player.HPMax or player.hpmax);
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    local maxMp = tonumber(player.MaxMP or player.maxMP or player.MPMax or player.mpmax);
    if hp == nil or maxHp == nil or mp == nil or maxMp == nil
        or hp <= 0 or maxHp < hp or mp < 0 or maxMp < mp
    then
        return false, 'pools unavailable';
    end
    local observed = observeReconciliationEquipment();
    if type(observed) ~= 'table' then
        return false, 'source mismatch';
    end
    for slot, expected in pairs(plan.sourceEquipment) do
        if not reconciliationNamesMatch(expected, observed[slot] or '') then
            return false, 'source mismatch';
        end
    end

    local sourceHp = tonumber(plan.sourceKnownHp);
    local sourceMp = tonumber(plan.sourceKnownMp);
    for slot, variants in pairs(plan.sourceVariants) do
        if type(variants) ~= 'table' then
            return false, 'source variants invalid';
        end
        local matched = false;
        local variantHp = nil;
        local variantMp = nil;
        for _, variant in ipairs(variants) do
            if type(variant) == 'table'
                and reconciliationNamesMatch(variant.item or '', observed[slot] or '')
            then
                matched = true;
                variantHp = math.max(variantHp or tonumber(variant.hp) or 0, tonumber(variant.hp) or 0);
                variantMp = math.max(variantMp or tonumber(variant.mp) or 0, tonumber(variant.mp) or 0);
            end
        end
        if matched ~= true then
            return false, 'source variant mismatch';
        end
        sourceHp = sourceHp + (variantHp or 0);
        sourceMp = sourceMp + (variantMp or 0);
    end

    local targetHp = tonumber(plan.targetHp);
    local targetMp = tonumber(plan.targetMp);
    if targetMp < sourceMp then
        return false, 'final MP pool unsafe';
    end
    local requiredHpCost = math.max(tonumber(plan.bridgeHpCost), sourceHp - targetHp, 0);
    if maxHp - hp < requiredHpCost then
        return false, 'HP headroom low';
    end
    return true, nil, observed;
end

function profile.OddLuaRuntime.TryExplicitSetMpBridge(player)
    local plan = profile.OddLuaRuntime.ExplicitSetMpBridgePlan();
    if plan == nil then
        return false;
    end
    if state.HpToMpBridgeInFlight == true then
        return true;
    end

    local allowed, reason, observed = profile.OddLuaRuntime.ExplicitSetMpBridgeGate(player, plan);
    if allowed ~= true then
        message('HP-to-MP bridge skipped: ' .. tostring(reason) .. '.');
        return true;
    end

    local bridgeSet = {{}};
    bridgeSet[plan.slot] = plan.bridgeItem;
    local finalSet = {{}};
    finalSet[plan.slot] = plan.finalItem;
    local sourceSet = {{}};
    for slot in pairs(plan.targetEquipment) do
        local observedName = observed[slot];
        sourceSet[slot] = observedName ~= nil and observedName ~= '' and observedName or 'remove';
    end

    state.HpToMpBridgeInFlight = true;
    local ok, result = pcall(function()
        if forceEquipInlineSet(bridgeSet, true) ~= true then
            error('bridge equip unavailable');
        end
        if forceEquipInlineSet(plan.targetEquipment, true) ~= true then
            error('target set unavailable');
        end
        if forceEquipInlineSet(finalSet, true) ~= true then
            error('final equip unavailable');
        end
        return true;
    end);
    if ok ~= true or result ~= true then
        local restoreOk, restored = pcall(forceEquipInlineSet, sourceSet, true);
        state.HpToMpBridgeInFlight = false;
        if restoreOk == true and restored == true then
            message('HP-to-MP bridge failed; source restored.');
        else
            message('HP-to-MP bridge failed; restore unavailable.');
        end
        return true;
    end

    state.HpToMpBridgeInFlight = false;
    message('HP-to-MP bridge queued.');
    return true;
end

local oddLuaWarpRing = {{}};

function oddLuaWarpRing.lockRing2()
    if gFunc and gFunc.Disable then
        gFunc.Disable('Ring2');
    end
end

function oddLuaWarpRing.unlockRing2()
    if gFunc and gFunc.Enable then
        gFunc.Enable('Ring2');
    end
end

local function clearWarpRing()
    state.WarpRingLocked = false;
    oddLuaWarpRing.unlockRing2();
    if forceEquipInlineSet({{ Ring2 = 'remove' }}, true) then
        message('Warp Ring removed from Ring2.');
    else
        message('Warp Ring cleanup failed: unable to force Ring2 remove.');
    end
end

function oddLuaWarpRing.finishUse()
    local useQueued = queueTypedCommand('/item "Warp Ring" <me>', 1);
    if not useQueued then
        message('Warp Ring use failed: unable to queue item command.');
        clearWarpRing();
        return;
    end
    message('Warp Ring use queued. Ring2 unlocks in 10 seconds.');
    if not scheduleTask(10, clearWarpRing) then
        message('Warp Ring cleanup scheduling failed; use /lac fwd warpclear.');
    end
end

local function useWarpRing()
    if state.WarpRingLocked == true then
        message('Warp Ring flow already running.');
        return;
    end

    state.WarpRingLocked = true;
    if not forceEquipInlineSet({{ Ring2 = 'Warp Ring' }}, true) then
        state.WarpRingLocked = false;
        message('Warp Ring equip failed: unable to force Ring2.');
        return;
    end
    oddLuaWarpRing.lockRing2();
    message('Warp Ring equipped and locked in Ring2. Use fires in 10 seconds.');
    if not scheduleTask(10, oddLuaWarpRing.finishUse) then
        message('Warp Ring use scheduling failed.');
        clearWarpRing();
    end
end

local function equipFirstAvailable(setNames, force)
    local triedSird = false;
    for _, setName in ipairs(setNames or {{}}) do
        if setName == 'SIRD' then
            triedSird = true;
        elseif setName == 'Midcast' and not triedSird then
            triedSird = true;
            if equipNamedSetIfNotClear('SIRD', force) then
                return true;
            end
        end
        if setName and equipNamedSetIfNotClear(setName, force) then
            return true;
        end
    end
    return false;
end

function profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay()
    if state.IdleOverrideSet ~= nil and state.IdleOverrideSet ~= '' then
{guard_survival_overlay_gate}
        return equipNamedSetIfNotClear(state.IdleOverrideSet, false);
    end
    return false;
end

function profile.OverrideStateText()
    if state.IdleOverrideSet and state.IdleOverrideSet ~= '' then
        return tostring(state.IdleOverrideSet);
    end
    return 'off';
end

function profile.ResistStateText()
    return profile.OverrideStateText();
end

function profile.SetIdleOverrideSet(setName, label)
    local messageLabel = label or 'Override';
    if setName == nil or setName == '' then
        if state.IdleOverrideSet == nil or state.IdleOverrideSet == '' then
            message(messageLabel .. '=off.');
            return false;
        end
        state.IdleOverrideSet = nil;
        message(messageLabel .. '=off.');
        return true;
    end
    if state.IdleOverrideSet == setName then
        state.IdleOverrideSet = nil;
        message(messageLabel .. '=off.');
        return true;
    end
    if not sets[setName] or isClearSet(sets[setName]) then
        message('Not Applicable / Missing Equipment');
        return false;
    end
    local composedSet = profile.OddLuaRuntime.BuildManualOverrideSet(setName);
    if type(composedSet) ~= 'table' then
        message('Not Applicable / Missing Override Baseline');
        return false;
    end
    state.IdleOverrideSet = setName;
    message(messageLabel .. '=' .. tostring(setName) .. '.');
    return true;
end

function profile.HandleOverrideCommand(args)
    local command = normalize(args and args[1]);
    local value = normalize(args and args[2]);
    if command == 'override' or command == 'defense' or command == 'def' then
        if value == '' or value == 'status' then
            message('Override=' .. profile.OverrideStateText() .. '.');
            return false;
        elseif value == 'off' or value == 'clear' then
            command = 'defenseoff';
        else
            command = value;
        end
    end
    local setName = profile.DefenseAliases[command];
    if setName == nil then
        setName = profile.ResistAliases[command];
    end
    if setName == nil then
        message('Unknown override command. Use pdt|mdt|dt|evasion|safe|survival|tank|defenseoff.');
        return false;
    end
    return profile.SetIdleOverrideSet(setName, 'Override');
end

function profile.HandleResistCommand(args)
    local command = normalize(args and args[1]);
    local value = normalize(args and args[2]);
    if command == 'resist' or command == 'res' then
        if value == '' or value == 'status' then
            message('Resist override=' .. profile.ResistStateText() .. '.');
            return false;
        elseif value == 'off' or value == 'clear' then
            command = 'resoff';
        elseif value:sub(-3) == 'res' then
            command = value;
        elseif value:sub(-6) == 'resist' then
            command = value;
        end
        if command == 'resist' or command == 'res' then
            command = value .. 'res';
        end
    end
    local setName = profile.ResistAliases[command];
    if setName == nil then
        message('Unknown resist command. Use fireres|iceres|earthres|windres|waterres|thunderres|lightningres|lightres|darkres|statusres|charmres|resoff.');
        return false;
    end
    return profile.SetIdleOverrideSet(setName, 'Resist override');
end

function profile.OddLuaRuntime.IdlePoolText(label, threshold, extra)
    if (tonumber(threshold or 0) or 0) <= 0 and (tonumber(extra or 0) or 0) <= 0 then
        return label .. '=off';
    end
    return label .. '=' .. tostring(tonumber(threshold or 0) or 0) .. '+' .. tostring(tonumber(extra or 0) or 0);
end

function profile.IdlePoolStateText()
    return profile.OddLuaRuntime.IdlePoolText('mp', state.IdleMaxMPThreshold, state.IdleMaxMPAdd)
        .. '; ' .. profile.OddLuaRuntime.IdlePoolText('hp', state.IdleMaxHPThreshold, state.IdleMaxHPAdd);
end

function profile.OddLuaRuntime.ParseIdlePoolNumber(value)
    if tonumber(value) == nil then
        return nil;
    end
    return math.max(0, math.floor(tonumber(value)));
end

function profile.OddLuaRuntime.UpdateIdlePoolField(fieldName, value, label)
    if value == nil then
        message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
        return false;
    end
    if state[fieldName] == value then
        message(label .. '=' .. tostring(value) .. '.');
        return false;
    end
    state[fieldName] = value;
    if fieldName == 'IdleMaxMPThreshold' or fieldName == 'IdleMaxMPAdd' then
        state.IdleMaxMPActive = false;
    elseif fieldName == 'IdleMaxHPThreshold' or fieldName == 'IdleMaxHPAdd' then
        state.IdleMaxHPActive = false;
    end
    message(label .. '=' .. tostring(value) .. '.');
    return true;
end

function profile.HandleIdlePoolCommand(args)
    local command = normalize(args and args[1]);
    local value = profile.OddLuaRuntime.ParseIdlePoolNumber(args and args[2]);
    if command == 'setmp' then
        local changed = profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxMPThreshold', value, 'Set MP');
        if changed ~= true then
            return false, false;
        end
        return true, profile.OddLuaRuntime.TryExplicitSetMpBridge(getPlayer());
    elseif command == 'addmp' then
        return profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxMPAdd', value, 'Add MP');
    elseif command == 'resetmp' then
        if state.IdleMaxMPThreshold == 0 and state.IdleMaxMPAdd == 0 then
            message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
            return false;
        end
        state.IdleMaxMPThreshold = 0;
        state.IdleMaxMPAdd = 0;
        state.IdleMaxMPActive = false;
        message('Reset MP.');
        return true;
    elseif command == 'sethp' then
        return profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxHPThreshold', value, 'Set HP');
    elseif command == 'addhp' then
        return profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxHPAdd', value, 'Add HP');
    elseif command == 'resethp' then
        if state.IdleMaxHPThreshold == 0 and state.IdleMaxHPAdd == 0 then
            message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
            return false;
        end
        state.IdleMaxHPThreshold = 0;
        state.IdleMaxHPAdd = 0;
        state.IdleMaxHPActive = false;
        message('Reset HP.');
        return true;
    end
    message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
    return false;
end

function profile.OddLuaPet.currentPetName()
    local pet = profile.OddLuaPet.getPet();
    if type(pet) == 'string' then
        return pet;
    end
    if type(pet) ~= 'table' then
        return '';
    end
    if pet.Name ~= nil then
        return tostring(pet.Name);
    elseif pet.name ~= nil then
        return tostring(pet.name);
    elseif pet.PetName ~= nil then
        return tostring(pet.PetName);
    elseif pet.petName ~= nil then
        return tostring(pet.petName);
    elseif type(pet.Resource) == 'table' and pet.Resource.Name ~= nil then
        return tostring(pet.Resource.Name);
    elseif type(pet.Item) == 'table' and pet.Item.Name ~= nil then
        return tostring(pet.Item.Name);
    end
    return '';
end

function profile.OddLuaPet.petSetToken(petName)
    local token = tostring(petName or '');
    token = string.gsub(token, '^%s+', '');
    token = string.gsub(token, '%s+$', '');
    token = string.gsub(token, '[^%w]+', '_');
    token = string.gsub(token, '_+', '_');
    token = string.gsub(token, '^_+', '');
    token = string.gsub(token, '_+$', '');
    return token;
end

function profile.OddLuaPet.titlePetSetToken(token)
    local parts = {{}};
    for part in string.gmatch(string.lower(tostring(token or '')), '[^_]+') do
        local first = string.sub(part, 1, 1);
        local rest = string.sub(part, 2);
        if first ~= '' then
            parts[#parts + 1] = string.upper(first) .. rest;
        end
    end
    return table.concat(parts, '_');
end

function profile.OddLuaPet.addPetOverlayCandidate(candidates, seen, setName)
    if setName and setName ~= '' and not seen[setName] then
        seen[setName] = true;
        candidates[#candidates + 1] = setName;
    end
end

function profile.OddLuaPet.petOverlaySetNames(petName)
    local token = profile.OddLuaPet.petSetToken(petName);
    if token == '' then
        return {{}};
    end

    local titleToken = profile.OddLuaPet.titlePetSetToken(token);
    local lowerToken = string.lower(token);
    local candidates = {{}};
    local seen = {{}};
    for _, prefix in ipairs({{ 'Pet_', 'Avatar_', 'Jug_', 'SMNPet_', 'BSTPet_', 'Wyvern_' }}) do
        profile.OddLuaPet.addPetOverlayCandidate(candidates, seen, prefix .. titleToken);
        profile.OddLuaPet.addPetOverlayCandidate(candidates, seen, prefix .. lowerToken);
    end
    return candidates;
end

function profile.OddLuaPet.equipPetOverlayForCurrentPet(force)
    return equipFirstAvailable(profile.OddLuaPet.petOverlaySetNames(profile.OddLuaPet.currentPetName()), force);
end

function profile.OddLuaPet.equipPetActionSet(setNames, force)
    local equipped = equipFirstAvailable(setNames, force);
    local overlayEquipped = profile.OddLuaPet.equipPetOverlayForCurrentPet(force);
    return equipped or overlayEquipped;
end

profile.OddLuaPet.PinPolicies = {{
    rage = {{
        SetNames = {{ 'BloodPactRage', 'BloodPact', 'PetDamage', 'SummoningMagic', 'JobAbility' }},
        StartSlackSeconds = 1.0,
        FinishSlackSeconds = 1.0,
    }},
    ward = {{
        SetNames = {{ 'BloodPactWard', 'SummoningMagic', 'PetTank', 'AvatarPerp', 'JobAbility' }},
        StartSlackSeconds = 1.0,
        FinishSlackSeconds = 1.0,
    }},
    ready_sic = {{
        SetNames = {{ 'PetReady', 'PetDamage', 'PetTank', 'JobAbility' }},
        StartSlackSeconds = 1.0,
        FinishSlackSeconds = 1.0,
    }},
}};

-- Exact cap-75 actions whose server formulas consume the PetMagic objective.
-- Hybrids, breath/fixed-damage moves, heals, post-cap actions, and unknowns
-- deliberately stay on their existing fail-closed policy chains.
profile.OddLuaPet.MagicalActionNames = {{}};
for _, actionName in ipairs({{
    'Searing Light', 'Level ? Holy', 'Howling Moon',
    'Fire II', 'Fire IV', 'Meteor Strike', 'Inferno',
    'Stone II', 'Stone IV', 'Geocrush', 'Earthen Fury',
    'Water II', 'Water IV', 'Grand Fall', 'Tidal Wave',
    'Aero II', 'Aero IV', 'Wind Blade', 'Aerial Blast',
    'Blizzard II', 'Blizzard IV', 'Heavenly Strike', 'Diamond Dust',
    'Thunder II', 'Thunderspark', 'Thunder IV', 'Thunderstorm', 'Judgment Bolt',
    'Somnolence', 'Mewing Lullaby', 'Eerie Eye', 'Sleepga', 'Nightmare',
    'Clarsach Call', 'Sonic Buffet', 'Tornado II',
    'Dust Cloud', 'Fireball', 'Cursed Sphere', 'Venom', 'Dream Flower',
    'Scream', 'Roar', 'Infrasonics', 'Sheep Song', 'Spore', 'Hi-Freq Field',
    'Spoil', 'Sandblast', 'Sandpit', 'Venom Spray', 'Soporific',
    'Gloeosuccus', 'Palsy Pollen', 'Numbing Noise', 'Toxic Spit',
    'Filamented Hold', 'Intimidate',
    'Dia', 'Dia II', 'Slow', 'Paralyze', 'Silence',
    'Fire', 'Fire III', 'Blizzard', 'Blizzard III', 'Aero', 'Aero III',
    'Stone', 'Stone III', 'Thunder', 'Thunder III', 'Water', 'Water III',
    'Poison', 'Poison II', 'Bio', 'Bio II', 'Drain', 'Aspir', 'Blind',
    'Dispel', 'Absorb-INT',
}}) do
    profile.OddLuaPet.MagicalActionNames[normalize(actionName)] = true;
end

function profile.OddLuaPet.isMagicalAction(action)
    if type(action) ~= 'table' then
        return false;
    end
    return profile.OddLuaPet.MagicalActionNames[normalize(action.Name or action.name)] == true;
end

function profile.OddLuaPet.setNamesForObservedAction(policy, action)
    local setNames = {{}};
    local seen = {{}};
    local function add(setName)
        if type(setName) == 'string' and setName ~= '' and seen[setName] ~= true then
            seen[setName] = true;
            setNames[#setNames + 1] = setName;
        end
    end
    if profile.OddLuaPet.isMagicalAction(action) then
        add('PetMagic');
    end
    for _, setName in ipairs(type(policy) == 'table' and policy.SetNames or {{}}) do
        add(setName);
    end
    return setNames;
end

function profile.OddLuaPet.getPetAction()
    if not gData or type(gData.GetPetAction) ~= 'function' then
        return nil, false;
    end
    local ok, action = pcall(gData.GetPetAction);
    if ok ~= true then
        return nil, false;
    end
    return action, true;
end

function profile.OddLuaPet.canPinAction(kind)
    if type(profile.OddLuaPet.PinPolicies[kind]) ~= 'table' then
        return false;
    end
    if type(gSettings) == 'table' and gSettings.HorizonMode == true then
        return false;
    end
    return gData ~= nil and type(gData.GetPetAction) == 'function';
end

function profile.OddLuaPet.clearActionPin()
    state.PetActionPin = nil;
end

function profile.OddLuaPet.clampDelay(value, minimum, maximum)
    local number = tonumber(value) or minimum;
    if number < minimum then
        return minimum;
    elseif number > maximum then
        return maximum;
    end
    return number;
end

function profile.OddLuaPet.beginActionPin(kind)
    local policy = profile.OddLuaPet.PinPolicies[kind];
    if type(policy) ~= 'table' then
        profile.OddLuaPet.clearActionPin();
        return false;
    end
    if profile.OddLuaPet.canPinAction(kind) ~= true then
        profile.OddLuaPet.clearActionPin();
        return profile.OddLuaPet.equipPetActionSet(policy.SetNames, false);
    end

    local settings = type(gSettings) == 'table' and gSettings or {{}};
    local AbilityDelay = profile.OddLuaPet.clampDelay(settings.AbilityDelay, 0, 5);
    local PetskillDelay = profile.OddLuaPet.clampDelay(settings.PetskillDelay, 0, 8);
    local startedAt = os.clock();
    state.PetActionPin = {{
        Kind = kind,
        Policy = policy,
        Observed = false,
        StartDeadline = startedAt + AbilityDelay + policy.StartSlackSeconds,
        FailSafeDeadline = startedAt + AbilityDelay + PetskillDelay + policy.FinishSlackSeconds,
    }};
    profile.OddLuaPet.equipPetActionSet(policy.SetNames, false);
    return true;
end

function profile.OddLuaPet.maintainActionPin(player, force, allowEquip)
    local pin = state.PetActionPin;
    if type(pin) ~= 'table' or type(pin.Policy) ~= 'table' then
        if allowEquip ~= true
            or profile.OddLuaRuntime.PlayerContextReady(player) ~= true
            or (type(gSettings) == 'table' and gSettings.HorizonMode == true) then
            return false;
        end
        local autonomousAction, known = profile.OddLuaPet.getPetAction();
        if known == true and profile.OddLuaPet.isMagicalAction(autonomousAction) then
            return profile.OddLuaPet.equipPetActionSet({{ 'PetMagic' }}, force);
        end
        return false;
    end
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true
        or profile.OddLuaPet.canPinAction(pin.Kind) ~= true then
        profile.OddLuaPet.clearActionPin();
        return false;
    end

    local now = os.clock();
    if now > pin.FailSafeDeadline then
        profile.OddLuaPet.clearActionPin();
        return false;
    end

    local action, known = profile.OddLuaPet.getPetAction();
    if known ~= true then
        profile.OddLuaPet.clearActionPin();
        return false;
    end
    if type(action) == 'table' then
        pin.Observed = true;
        if allowEquip == false then
            return false;
        end
        return profile.OddLuaPet.equipPetActionSet(
            profile.OddLuaPet.setNamesForObservedAction(pin.Policy, action),
            force
        );
    end
    if pin.Observed == true or now > pin.StartDeadline then
        profile.OddLuaPet.clearActionPin();
        return false;
    end
    if allowEquip == false then
        return false;
    end
    return profile.OddLuaPet.equipPetActionSet(pin.Policy.SetNames, force);
end

function profile.OddLuaPet.isPetOrientedSetName(setName)
    local intent = normalize(setIntents[setName] or '');
    local name = normalize(setName);
    return intent == 'petdamage' or intent == 'pettank'
        or name == 'avatarperp' or name == 'playstyle_avatarperp';
end

local function canonicalElement(element)
    local value = normalize(element);
    if value == 'fire' then
        return 'Fire';
    elseif value == 'ice' then
        return 'Ice';
    elseif value == 'wind' then
        return 'Wind';
    elseif value == 'earth' then
        return 'Earth';
    elseif value == 'thunder' or value == 'lightning' then
        return 'Thunder';
    elseif value == 'water' then
        return 'Water';
    elseif value == 'light' then
        return 'Light';
    elseif value == 'dark' then
        return 'Dark';
    end
    return nil;
end

local function elementMatches(left, right)
    local leftElement = canonicalElement(left);
    local rightElement = canonicalElement(right);
    return leftElement ~= nil and rightElement ~= nil and leftElement == rightElement;
end

local function setNameForElement(prefix, element)
    local canonical = canonicalElement(element);
    if not canonical then
        return nil;
    end

    local setName = tostring(prefix or '') .. '_' .. canonical;
    if sets[setName] then
        return setName;
    end

    if canonical == 'Thunder' then
        local lightningName = tostring(prefix or '') .. '_Lightning';
        if sets[lightningName] then
            return lightningName;
        end
    end

    return nil;
end

local function activeCombatStyle()
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        return {lua_quote(default_playstyle)};
    end
    return state.Playstyle;
end

function profile.OddLuaRuntime.SyncActiveStyleWeapons()
    if not scale or not scale.Status or not scale.SetWeaponLockEnabled or not scale.ForceEquipSet then
        return false, 'Scale legal weapon resolver is unavailable';
    end

    local activeSetName = setNameFor(activeCombatStyle());
    local activeSet = sets[activeSetName];
    if type(activeSet) ~= 'table' then
        return false, 'active style has no resolved equipment set';
    end
    activeSet = setWithSubjobLegalOffhand(activeSetName, activeSet);

    local requested = {{}};
    for _, slot in ipairs({{ 'Main', 'Sub', 'Range' }}) do
        if activeSet[slot] ~= nil then
            requested[slot] = activeSet[slot];
        end
    end
    if next(requested) == nil then
        return false, 'active style has no Main, Sub, or Range selection';
    end

    local statusOk, status = pcall(scale.Status);
    if statusOk ~= true or type(status) ~= 'table' then
        return false, 'Scale weapon-lock status is unavailable';
    end
    local previousWeaponLockEnabled = status.weaponLockEnabled == true;
    local unlockOk = pcall(scale.SetWeaponLockEnabled, false);
    if unlockOk ~= true then
        return false, 'Scale weapon lock could not be disabled';
    end

    -- ForceEquipSet resolves owned/legal replacements, including the generated
    -- offhand relationship, before dispatching this deliberate one-shot swap.
    local equipOk, resolved = pcall(
        scale.ForceEquipSet,
        activeSetName .. '_WeaponSync',
        requested,
        setIntents[activeSetName]
    );
    local restoreOk = pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    if restoreOk ~= true then
        return false, 'Scale weapon lock could not be restored';
    end
    if equipOk ~= true then
        return false, 'legal weapon resolution failed: ' .. tostring(resolved or 'unknown error');
    end
    if type(resolved) ~= 'table' or next(resolved) == nil then
        return false, 'Scale found no owned legal active-style weapons';
    end
    return true, activeSetName;
end

function profile.OddLuaRuntime.AvoidNegativeTickGear()
    local explicitTransitions = mechanicsSwapPlanner and mechanicsSwapPlanner.explicitTransitions;
    local plan = type(explicitTransitions) == 'table' and explicitTransitions.avoidtick or nil;
    if type(plan) ~= 'table' or plan.available ~= true or type(plan.actions) ~= 'table' then
        return false, 'no owned negative-tick avoidance plan';
    end
    local player = getPlayer();
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player context is not ready';
    end
    if not isEngaged(player) then
        return false, 'player is not engaged';
    end
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    if mp == nil or mp <= 0 then
        return false, 'player MP is not positive';
    end
    local observed, observeError, observedIds = observeReconciliationEquipment();
    if type(observed) ~= 'table' then
        return false, observeError or 'equipment observation unavailable';
    end
    if type(observedIds) ~= 'table' then
        return false, 'equipment item IDs are unavailable';
    end

    local activeSetName = setNameFor(activeCombatStyle());
    local activeSet = sets[activeSetName];
    if type(activeSet) ~= 'table' then
        activeSet = {{}};
    end
    local legalSet = setWithSubjobLegalOffhand(activeSetName, activeSet);
    local replacements = {{}};
    local details = {{}};
    for _, action in ipairs(plan.actions) do
        if type(action) == 'table' then
            local slot = tostring(action.slot or '');
            local harmfulItem = tostring(action.item or '');
            local harmfulItemId = tonumber(action.itemId);
            if slot ~= '' and harmfulItem ~= ''
                and harmfulItemId ~= nil and harmfulItemId > 0
                and observedIds[slot] == harmfulItemId
                and reconciliationNamesMatch(harmfulItem, observed[slot] or '')
            then
                local safeItem = legalSet[slot];
                local safeName = movementEquipItemName(safeItem);
                if safeName == nil or reconciliationNamesMatch(harmfulItem, safeName) then
                    replacements[slot] = 'remove';
                    safeName = 'remove';
                else
                    replacements[slot] = safeItem;
                end
                details[#details + 1] = slot .. ' ' .. harmfulItem .. '->' .. tostring(safeName);
            end
        end
    end
    if next(replacements) == nil then
        return false, 'no observed owned negative-tick item is equipped';
    end
    if forceEquipInlineSet(replacements, false) ~= true then
        return false, 'safe replacement equip is unavailable';
    end
    return true, table.concat(details, ', ');
end

function profile.PrintConditionalOverlayStatus()
    local setName = state.LastEquippedSetName or setNameFor(activeCombatStyle());
    if not conditionals or not conditionals.ResolveOverlay then
        message('Conditional overlays: set=' .. tostring(setName or 'unknown') .. '; unavailable.');
        return;
    end

    local context = reconciliationEquipContext(false);
    local okSet, _, setOwners = pcall(function()
        return conditionals.ResolveOverlay(conditionalEquips[setName], context);
    end);
    local okGlobal, _, globalOwners = pcall(function()
        return conditionals.ResolveOverlay(conditionalEquips.Global, context);
    end);
    if okSet ~= true or okGlobal ~= true
        or type(setOwners) ~= 'table' or type(globalOwners) ~= 'table' then
        message('Conditional overlays: set=' .. tostring(setName or 'unknown') .. '; unavailable.');
        return;
    end

    local winners = {{}};
    local function recordOwners(scope, owners)
        for slot, owner in pairs(owners) do
            if type(owner) == 'table' then
                winners[slot] = {{
                    scope = scope,
                    conditionType = tostring(owner.conditionType or 'conditional'),
                    conditionName = tostring(owner.conditionName or ''),
                    item = tostring(owner.item or ''),
                }};
            end
        end
    end
    recordOwners('set', setOwners);
    -- Global conditionals are applied after set-local conditionals at runtime.
    recordOwners('global', globalOwners);

    local groups = {{}};
    local orderedGroups = {{}};
    for _, slot in ipairs(equipmentSlots) do
        local owner = winners[slot];
        if owner then
            local conditionName = owner.conditionName;
            if conditionName == '' then
                conditionName = '?';
            end
            local key = owner.scope .. ':' .. owner.conditionType .. '=' .. conditionName;
            local group = groups[key];
            if not group then
                group = {{ label = key, slots = {{}} }};
                groups[key] = group;
                orderedGroups[#orderedGroups + 1] = group;
            end
            group.slots[#group.slots + 1] = slot .. '=' .. owner.item;
        end
    end

    if #orderedGroups == 0 then
        message('Conditional overlays: set=' .. tostring(setName or 'unknown') .. '; winners=none.');
        return;
    end
    local parts = {{}};
    for _, group in ipairs(orderedGroups) do
        parts[#parts + 1] = group.label .. '[' .. table.concat(group.slots, ',') .. ']';
    end
    message('Conditional overlays: set=' .. tostring(setName or 'unknown')
        .. '; winners=' .. table.concat(parts, ' | ') .. '.');
end

profile.OddLuaRuntime.StableWeaponPlaystyles = {{
    Tank = true,
    Enmity = true,
    MagicDefense = true,
    PetDamage = true,
    PetTank = true,
}};

local persistentCombatOverlayPlaystyles = {{
    Enmity = true,
    PetDamage = true,
    PetTank = true,
}};

function profile.OddLuaRuntime.ShouldEstablishStablePlaystyleWeapons(player)
    return profile.OddLuaRuntime.StableWeaponPlaystyles[state.Playstyle] == true
        and isEngaged(player)
        and playerTp(player) == 0;
end

function profile.OddLuaRuntime.EquipStablePlaystyle(setName, force)
    if not scale or not scale.Status or not scale.SetWeaponLockEnabled then
        return false;
    end
    local statusOk, status = pcall(scale.Status);
    if statusOk ~= true or type(status) ~= 'table' then
        return false;
    end
    local previousWeaponLockEnabled = status.weaponLockEnabled == true;
    local unlockOk = pcall(scale.SetWeaponLockEnabled, false);
    if unlockOk ~= true then
        return false;
    end
    local equipOk, equipped = pcall(equipNamedSet, setName, force);
    local restoreOk = pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    return restoreOk == true and equipOk == true and equipped == true;
end

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor({lua_quote(default_playstyle)}), force) then
            return true;
        end
        return equipNamedSet('TP', force);
    end

    local activeStyle = activeCombatStyle();
    local activeSet = setNameFor(activeStyle);
    if persistentCombatOverlayPlaystyles[activeStyle] == true
        and activeStyle ~= DEFAULT_PLAYSTYLE
        and state.LastEquippedSetName ~= activeSet
    then
        -- These labeled sets contain only positive, style-specific rows. Restore
        -- the complete default combat base first so sparse slots cannot retain
        -- a prior action snapshot or named-pet overlay.
        equipNamedSet(setNameFor(DEFAULT_PLAYSTYLE), force);
    end
    if profile.OddLuaRuntime.ShouldEstablishStablePlaystyleWeapons(getPlayer())
        and profile.OddLuaRuntime.EquipStablePlaystyle(activeSet, force)
    then
        return true;
    end
    if equipNamedSet(activeSet, force) then
        if profile.OddLuaPet.isPetOrientedSetName(activeSet) then
            profile.OddLuaPet.equipPetOverlayForCurrentPet(force);
        end
        return true;
    end
    if equipNamedSet('TP', force) then
        return true;
    end
    return equipNamedSet({lua_quote(default_set_name)}, force);
end

{explicit_gear_mode_combat_wrapper}

{caster_sustain_restore_helper}

local function lockstyleCombatSet()
    if not equipNamedSet('TP', true) then
        if not equipNamedSet(setNameFor({lua_quote(default_playstyle)}), true) then
            message('Unable to equip TP set for lockstyle.');
            return;
        end
    end

    local function applyTpLockstyle()
        if queueTypedCommand('/lockstyle on', 1) then
            message('Lockstyle captured TP set.');
        else
            message('Lockstyle command unavailable; equip TP set manually, then use /lockstyle on.');
        end
    end

    if not scheduleTask(0.3, applyTpLockstyle) then
        applyTpLockstyle();
    end
end

local function equipMovement(player, environment, force)
    if not canEquipMovement(player, environment) then
        return false;
    end

    local equipped = false;

    if equipNamedSetIfNotClear('Movement', force) then
        equipped = true;
    end
    if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('Movement_City', force) then
        equipped = true;
    end
    if isNight(environment) and equipNamedSetIfNotClear('Movement_Night', force) then
        equipped = true;
    end
    if isDuskToDawn(environment) and equipNamedSetIfNotClear('Movement_DuskToDawn', force) then
        equipped = true;
    end
    if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('InCity', force) then
        equipped = true;
    end

    return equipped;
end

local function addSecondarySlotLockSetNameIfNotClear(setNames, setName)
    local set = sets[setName];
    if set and not isClearSet(set) then
        setNames[#setNames + 1] = setName;
    end
end

local function addMovementSecondarySlotLockSetNames(setNames, player, environment)
    if not canEquipMovement(player, environment) then
        return;
    end

    addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement');
    if shouldEquipInCityMovement(player, environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement_City');
    end
    if isNight(environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement_Night');
    end
    if isDuskToDawn(environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement_DuskToDawn');
    end
    if shouldEquipInCityMovement(player, environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'InCity');
    end
end

local function idleSecondarySlotLockSetNames(player, environment)
    local setNames = {{}};
    if shouldEquipInCityMovement(player, environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleCity');
    elseif profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleCombat');
    else
        addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleNonCombat');
    end
    if not profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        if profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) then
            addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleMaxMP');
        end
        if profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player) then
            addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleMaxHP');
        end
    end
    addSecondarySlotLockSetNameIfNotClear(setNames, 'Aftercast');
    addSecondarySlotLockSetNameIfNotClear(setNames, 'Idle');
    if not profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        addMovementSecondarySlotLockSetNames(setNames, player, environment);
    end
    return setNames;
end

function profile.OddLuaRuntime.EquipIdleContextSet(setName, force)
    return equipNamedSetIfNotClear(setName, force);
end

local function equipBaseIdleState(player, force)
    local environment = getEnvironment();
    local equipped = false;

    -- Idle context sets are overlays and may contain only one or two slots.
    -- Establish a complete baseline before applying them so a sparse overlay
    -- cannot leave stale gear or empty slots from the previous job/action.
    if isClearSet(sets['Aftercast']) then
        equipNamedSet('Aftercast', force);
        equipped = true;
    else
        equipped = equipNamedSetIfNotClear('Aftercast', force);
    end

    if not equipped then
        if isClearSet(sets['Idle']) then
            equipNamedSet('Idle', force);
            equipped = true;
        else
            equipped = equipNamedSetIfNotClear('Idle', force);
        end
    end

    if shouldEquipInCityMovement(player, environment) and profile.OddLuaRuntime.EquipIdleContextSet('IdleCity', force) then
        equipped = true;
    elseif profile.OddLuaRuntime.ShouldEquipIdleCombat(player) and profile.OddLuaRuntime.EquipIdleContextSet('IdleCombat', force) then
        equipped = true;
    elseif profile.OddLuaRuntime.EquipIdleContextSet('IdleNonCombat', force) then
        equipped = true;
    end

    if not profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        if profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) then
            profile.OddLuaRuntime.EquipIdleContextSet('IdleMaxMP', force);
        end
        if profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player) then
            profile.OddLuaRuntime.EquipIdleContextSet('IdleMaxHP', force);
        end
        equipMovement(player, environment, force);
    end

    if equipped then
        return true;
    end
    return equipNamedSet('Idle', force);
end

local function equipIdleState(player, force)
    local previousSecondarySlotLockContext = state.SecondarySlotLockContextSetNames;
    state.SecondarySlotLockContextSetNames = idleSecondarySlotLockSetNames(player, getEnvironment());
    local ok, equipped = pcall(equipBaseIdleState, player, force);
    state.SecondarySlotLockContextSetNames = previousSecondarySlotLockContext;
    if not ok then
        error(equipped);
    end
    return equipped;
end

local function equipDefaultForPlayer(player, force)
    return profile.OddLuaRuntime.RunReconciliationComposition(function()
        if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
            profile.OddLuaPet.clearActionPin();
            return false;
        end
{caster_sustain_default_prelude}
        local petPinMayEquip = state.WarpRingLocked ~= true
            and not isResting(player)
            and state.Playstyle ~= 'Craft'
            and profile.OddLuaRuntime.ActiveSafetyReason(player) == 'none';
        if profile.OddLuaPet.maintainActionPin(player, force, petPinMayEquip) then
            return true;
        end
        if hasDangerousStatus() then
            local defensiveSet = firstAvailableDefensiveSet();
            if defensiveSet ~= nil then
                equipNamedSet(defensiveSet, force);
            end
        elseif profile.OddLuaRuntime.HasWeakness() == true then
            local defensiveSet = firstAvailableDefensiveSet();
            if defensiveSet ~= nil then
                equipNamedSet(defensiveSet, force);
            end
        elseif player and isResting(player) then
            equipNamedSet('Resting', force);
        elseif state.Playstyle == 'Craft' then
            if not equipNamedSet('Crafting', force) then
                equipNamedSet('Idle', force);
            end
        elseif state.IdleOverrideSet ~= nil{manual_override_guard_gate} then
            if profile.OddLuaRuntime.EquipManualOverrideSet(state.IdleOverrideSet, force) then
                return true;
            end
            state.IdleOverrideSet = nil;
            return equipDefaultForPlayer(player, force);
        elseif player and isEngaged(player) then
            local defensiveSet, unlockDefensiveWeapons = shouldEquipOvertDefense(player);
            if defensiveSet then
                local equippedDefensive = equipOvertDefensiveSet(defensiveSet, unlockDefensiveWeapons);
                if equippedDefensive then
                    return;
                end
            end
            if isEmergencyHp(player) then
                local emergencyDefensiveSet = firstAvailableDefensiveSet();
                if emergencyDefensiveSet ~= nil then
                    equipNamedSet(emergencyDefensiveSet, force);
                end
            else
{guard_default_equip}
{caster_sustain_default_equip}
            end
        else
            equipIdleState(player, force);
        end
    end);
end

local oddLuaNumberRow = {{
    utilityFallbacks = {{
        craft = {{ 'Craft', 'Fishing', 'Gathering', 'Clamming', 'Movement', 'Resting', 'Treasure', 'Survival' }},
        movement = {{ 'Movement', 'Movement_City', 'Movement_Night', 'Movement_DuskToDawn', 'InCity', 'Survival' }},
    }},
}};

function oddLuaNumberRow.setBooleanValue(current, value)
    local valueText = normalize(value);
    if valueText == 'on' or valueText == 'enable' or valueText == 'enabled' then
        return true;
    elseif valueText == 'off' or valueText == 'disable' or valueText == 'disabled' then
        return false;
    end
    return not current;
end

function oddLuaNumberRow.bindPalette()
    if state.NumberRowPaletteEnabled ~= true then
        return;
    end
{number_row_bind_commands}
end

function oddLuaNumberRow.unbindPalette()
{number_row_unbind_commands}
end

function oddLuaNumberRow.clearLegacyPaletteBinds()
{number_row_legacy_clear_commands}
end

function oddLuaNumberRow.paletteEntryText(binding)
    if not binding then
        return '';
    end
    if binding.kind == 'unbound' or binding.key == nil or binding.key == '' then
        return 'Unbound';
    end
    local displayKey = binding.displayKey;
    if displayKey == nil or displayKey == '' then
        displayKey = binding.key;
    end
    if binding.kind == 'command-only' then
        return tostring(displayKey) .. ' ' .. tostring(binding.label)
            .. ' [unbound; command ' .. tostring(binding.literal) .. ']';
    end
    return tostring(displayKey) .. ' ' .. tostring(binding.label);
end

function oddLuaNumberRow.paletteEntriesText(firstIndex, lastIndex)
    local parts = {{}};
    for index = firstIndex, lastIndex do
        local text = oddLuaNumberRow.paletteEntryText(numberRowBindings[index]);
        if text ~= '' then
            parts[#parts + 1] = text;
        end
    end
    return table.concat(parts, ' | ');
end

function oddLuaNumberRow.printPalette()
    local enabledText = 'off';
    if state.NumberRowPaletteEnabled == true then
        enabledText = 'on';
    end
    message('Keypad palette=' .. enabledText .. '; /lac fwd keypad on|off|clear.');
    message('Keypad 1: ' .. oddLuaNumberRow.paletteEntriesText(1, 6));
    message('Keypad 2: ' .. oddLuaNumberRow.paletteEntriesText(7, 12));
end

function oddLuaNumberRow.clearPaletteBinds()
    state.NumberRowPaletteEnabled = false;
    oddLuaNumberRow.unbindPalette();
    oddLuaNumberRow.clearLegacyPaletteBinds();
    message('OddLua keypad palette: cleared');
end

function oddLuaNumberRow.setPaletteEnabled(value)
    local enabled = oddLuaNumberRow.setBooleanValue(state.NumberRowPaletteEnabled, value);
    if state.NumberRowPaletteEnabled == enabled then
        if enabled then
            message('OddLua keypad palette: already on');
        else
            message('OddLua keypad palette: already off');
        end
        return;
    end
    state.NumberRowPaletteEnabled = enabled;
    if enabled then
        oddLuaNumberRow.bindPalette();
        message('OddLua keypad palette: on');
    else
        oddLuaNumberRow.unbindPalette();
        message('OddLua keypad palette: off');
    end
end

function oddLuaNumberRow.currentPlaystyleIndex()
    for index, styleName in ipairs(playstyleNames) do
        if styleName == state.Playstyle then
            return index;
        end
    end
    return 1;
end

function oddLuaNumberRow.cyclePlaystyle(delta)
    if #playstyleNames == 0 then
        message('No playstyles available.');
        return false;
    end
    local index = oddLuaNumberRow.currentPlaystyleIndex();
    local selectedIndex = ((index - 1 + delta) % #playstyleNames) + 1;
    state.Playstyle = playstyleNames[selectedIndex];
    message('Style=' .. state.Playstyle);
    equipDefaultForPlayer(getPlayer(), true);
    return true;
end

function oddLuaNumberRow.equipUtilityIntent(intent)
    local fallback = oddLuaNumberRow.utilityFallbacks[normalize(intent)];
    if type(fallback) ~= 'table' then
        message('Not Applicable / Missing Equipment');
        return false;
    end
    for _, setName in ipairs(fallback) do
        if equipNamedSetIfNotClear(setName, true) then
            message('Utility=' .. tostring(intent) .. '; set=' .. setName);
            return true;
        end
    end
    message('Not Applicable / Missing Equipment');
    return false;
end

local function blueMagicRouteKey(action)
    local value = action;
    if type(action) == 'table' then
        value = action.Name or action.name;
        if value == nil or tostring(value) == '' then
            value = action.DisplayName or action.displayName;
        end
    end
    local key = normalize(value);
    key = string.gsub(key, '[^%w]+', ' ');
    key = string.gsub(key, '%s+', ' ');
    key = string.gsub(key, '^%s+', '');
    return string.gsub(key, '%s+$', '');
end

local function equipBlueMagic(action)
    local route = blueMagicRoutes[blueMagicRouteKey(action)];
    if route == 'MagicalBlueMagic' then
        local environment = getEnvironment();
        local element = action and action.Element;
        local candidates = {{}};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
            table.insert(candidates, setNameForElement('MagicalBlueWeather', element));
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
            table.insert(candidates, setNameForElement('MagicalBlueDay', element));
        end
        table.insert(candidates, 'MagicalBlueMagic');
        table.insert(candidates, 'MagicalBlue');
        table.insert(candidates, 'BlueMagic');
        table.insert(candidates, 'Midcast');
        equipFirstAvailable(candidates, false);
        return;
    end
    if route and equipNamedSet(route, false) then
        return;
    end
    equipFirstAvailable({{ 'BlueMagic', 'PhysicalBlueMagic', 'MagicalBlueMagic', 'Midcast' }}, false);
end

local elementalDebuffStyleByName = {{
    burn = 'Burn',
    choke = 'Choke',
    drown = 'Drown',
    frost = 'Frost',
    rasp = 'Rasp',
    shock = 'Shock',
}};

function oddLuaNumberRow.advanceBindingGeneration()
    local lifecycle = package.loaded['oddlua.binding_lifecycle'];
    if type(lifecycle) ~= 'table' then
        lifecycle = {{ generation = 0 }};
        package.loaded['oddlua.binding_lifecycle'] = lifecycle;
    end
    lifecycle.generation = (tonumber(lifecycle.generation) or 0) + 1;
    return lifecycle.generation;
end

function oddLuaNumberRow.isBindingGenerationCurrent(generation)
    local lifecycle = package.loaded['oddlua.binding_lifecycle'];
    return type(lifecycle) == 'table'
        and tonumber(lifecycle.generation) == tonumber(generation);
end

local function equipElementalMagic(action)
    action = action or {{}};
    local actionName = normalize(action.Name);
    local debuffStyle = elementalDebuffStyleByName[actionName];
    if debuffStyle ~= nil then
        equipFirstAvailable({{ debuffStyle, 'MagicAccuracy', 'Elemental', 'Midcast' }}, false);
        return;
    end
    local environment = getEnvironment();
    local element = action.Element;
    local candidates = {{}};

    if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
        table.insert(candidates, setNameForElement('Weather', element));
    end
    if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
        table.insert(candidates, setNameForElement('Day', element));
    end
    table.insert(candidates, setNameForElement('Elemental', element));
    table.insert(candidates, 'Elemental');
    table.insert(candidates, 'Nuke');
    table.insert(candidates, 'Midcast');
    equipFirstAvailable(candidates, false);
    if state.MagicBurstMode == true then
        equipNamedSetIfNotClear('MagicBurst', false);
    end
end

local elementalBarspellNames = {{
    baraero = true,
    baraera = true,
    barblizzard = true,
    barblizzara = true,
    barfire = true,
    barfira = true,
    barstone = true,
    barstonra = true,
    barthunder = true,
    barthundra = true,
    barwater = true,
    barwatera = true,
}};

local function equipEnhancingMagic(name)
    local value = normalize(name);
    if string.find(value, 'stoneskin', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({{ 'Stoneskin', 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'spikes', 1, true) then
        equipFirstAvailable({{ 'Spikes', 'Enhancing' }}, false);
    elseif string.find(value, 'blink', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({{ 'SIRD', 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'refresh', 1, true) then
        equipFirstAvailable({{ 'Refresh', 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'regen', 1, true) then
        equipFirstAvailable({{ 'Regen', 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'en', 1, true) == 1 then
        -- Enspell is the post-cast melee playstyle. At spell resolution, use
        -- enhancing skill and duration rather than TP/haste/attack equipment.
        equipFirstAvailable({{ 'Enhancing', 'EnhancingDuration' }}, false);
    elseif string.find(value, 'sneak', 1, true) or string.find(value, 'invisible', 1, true) or string.find(value, 'deodorize', 1, true) then
        equipFirstAvailable({{ 'SneakInvisible', 'Enhancing' }}, false);
    elseif elementalBarspellNames[value] == true then
        equipFirstAvailable({{ 'Barspell', 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'bar', 1, true) == 1 then
        -- Status-resistance Barspells have duration but no elemental Barspell
        -- potency/MDEF term. Never fall through to unrelated generic Midcast
        -- (usually magic accuracy); keep the current gear if neither sparse
        -- duration nor enhancing-skill gear is available.
        equipFirstAvailable({{ 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'phalanx', 1, true) then
        equipFirstAvailable({{ 'Phalanx', 'EnhancingDuration', 'Enhancing' }}, false);
    elseif string.find(value, 'aquaveil', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({{ 'Aquaveil', 'SIRD', 'EnhancingDuration', 'Enhancing' }}, false);{aquaveil_sird_nin_overlay}
    elseif string.find(value, 'haste', 1, true) then
        equipFirstAvailable({{ 'Haste', 'EnhancingDuration', 'Enhancing' }}, false);
    else
        equipFirstAvailable({{ 'Enhancing', 'EnhancingDuration' }}, false);
    end
end

local function equipEnfeeblingMagic(name)
    local value = normalize(name);
    if string.find(value, 'sleep', 1, true) or string.find(value, 'lullaby', 1, true) then
        equipFirstAvailable({{ 'Sleep', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'bind', 1, true) then
        equipFirstAvailable({{ 'Bind', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'gravity', 1, true) then
        equipFirstAvailable({{ 'Gravity', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'silence', 1, true) then
        equipFirstAvailable({{ 'Silence', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'slow', 1, true) then
        equipFirstAvailable({{ 'Slow', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'paraly', 1, true) then
        equipFirstAvailable({{ 'Paralyze', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'poison', 1, true) then
        equipFirstAvailable({{ 'Poison', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'blind', 1, true) then
        equipFirstAvailable({{ 'Blind', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'dispel', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({{ 'Dispel', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'dia', 1, true) then
        equipFirstAvailable({{ 'Dia', 'Enfeebling', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'Enfeebling', 'Midcast' }}, false);
    end
end

local function equipDarkMagic(name)
    local value = normalize(name);
    if value == 'dread spikes' then
        equipFirstAvailable({{ 'DreadSpikes', 'DarkDuration', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'drain', 1, true) or string.find(value, 'aspir', 1, true) then
        local environment = getEnvironment();
        local candidates = {{}};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, 'Dark') then
            table.insert(candidates, 'DrainWeather_Dark');
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, 'Dark') then
            table.insert(candidates, 'DrainDay_Dark');
        end
        table.insert(candidates, 'DrainAspir');
        table.insert(candidates, 'DarkMagic');
        table.insert(candidates, 'Midcast');
        equipFirstAvailable(candidates, false);
    elseif string.find(value, 'absorb', 1, true) then
        equipFirstAvailable({{ 'Absorb', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'stun', 1, true) then
        equipFirstAvailable({{ 'Stun', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'bio', 1, true) then
        equipFirstAvailable({{ 'Bio', 'DarkMagic', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'DarkMagic', 'Midcast' }}, false);
    end
end

local function equipSong(name)
    local value = normalize(name);
    if string.find(value, 'minuet', 1, true) then
        equipFirstAvailable({{ 'Song_Minuet', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'paeon', 1, true) then
        equipFirstAvailable({{ 'Song_Paeon', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'lullaby', 1, true) then
        equipFirstAvailable({{ 'Song_Lullaby', 'SongDebuff', 'Song', 'Midcast' }}, false);
    elseif string.find(value, 'madrigal', 1, true) then
        equipFirstAvailable({{ 'Song_Madrigal', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'etude', 1, true) then
        equipFirstAvailable({{ 'Song_Etude', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'ballad', 1, true) then
        equipFirstAvailable({{ 'Song_Ballad', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'march', 1, true) then
        equipFirstAvailable({{ 'Song_March', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'carol', 1, true) then
        equipFirstAvailable({{ 'Song_Carol', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'elegy', 1, true) then
        equipFirstAvailable({{ 'Song_Elegy', 'SongDebuff', 'Song', 'Midcast' }}, false);
    elseif string.find(value, 'prelude', 1, true) then
        equipFirstAvailable({{ 'Song_Prelude', 'SongBuff', 'Song' }}, false);
    elseif string.find(value, 'requiem', 1, true) then
        equipFirstAvailable({{ 'Song_Requiem', 'SongDebuff', 'Song', 'Midcast' }}, false);
    elseif string.find(value, 'threnody', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({{ 'SongDebuff', 'Song', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'SongBuff', 'Song' }}, false);
    end
end

local function equipNinjutsu(action)
    local function isElementalNinjutsu(name)
        return string.find(name, 'katon', 1, true) == 1
            or string.find(name, 'hyoton', 1, true) == 1
            or string.find(name, 'huton', 1, true) == 1
            or string.find(name, 'doton', 1, true) == 1
            or string.find(name, 'raiton', 1, true) == 1
            or string.find(name, 'suiton', 1, true) == 1;
    end

    local name = normalize(action and action.Name);
    if string.find(name, 'utsusemi', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({{ 'Utsusemi', 'SIRD', 'Precast', 'FastCast' }}, false);{utsusemi_sird_nin_overlay}
    elseif string.find(name, 'kurayami', 1, true) or string.find(name, 'hojo', 1, true)
        or string.find(name, 'jubaku', 1, true) or string.find(name, 'dokumori', 1, true) then
        equipFirstAvailable({{ 'NinjutsuEnfeeble', 'Ninjutsu', 'Midcast' }}, false);
    elseif isElementalNinjutsu(name) then
        local environment = getEnvironment();
        local element = action and action.Element;
        local candidates = {{}};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
            table.insert(candidates, setNameForElement('NinjutsuWeather', element));
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
            table.insert(candidates, setNameForElement('NinjutsuDay', element));
        end
        table.insert(candidates, 'Ninjutsu');
        table.insert(candidates, 'Midcast');
        equipFirstAvailable(candidates, false);
    else
        equipFirstAvailable({{ 'Ninjutsu', 'Midcast' }}, false);
    end
end

local function equipSummoning(name)
    local value = normalize(name);
    if string.find(value, 'siphon', 1, true) then
        equipFirstAvailable({{ 'Summoning', 'AvatarPerp', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'Summoning', 'Midcast' }}, false);
    end
end

function profile.OddLuaRuntime.RollSetName(actionName)
    local value = normalize(actionName);
    value = string.gsub(value, '%s+roll$', '');
    value = string.gsub(value, '[^%w%s]', '');
    local suffix = '';
    for token in string.gmatch(value, '%w+') do
        suffix = suffix .. string.upper(string.sub(token, 1, 1)) .. string.sub(token, 2);
    end
    if suffix == '' then
        return 'Roll';
    end
    return 'Roll_' .. suffix;
end

local function equipAbility()
    local action = getAction();
    local name = normalize(action and action.Name);
    local actionType = normalize(action and action.Type);
    if actionType == 'quick draw' then
        local quickDrawElements = {{
            ['dark shot'] = 'Dark',
            ['earth shot'] = 'Earth',
            ['fire shot'] = 'Fire',
            ['ice shot'] = 'Ice',
            ['light shot'] = 'Light',
            ['thunder shot'] = 'Thunder',
            ['water shot'] = 'Water',
            ['wind shot'] = 'Wind',
        }};
        local function equipQuickDraw(action)
            local name = normalize(action and action.Name);
            local element = quickDrawElements[name] or (action and action.Element);
            local accuracyShot = name == 'dark shot' or name == 'light shot';
            local environment = getEnvironment();
            equipFirstAvailable({{ 'QuickDraw', 'MagicAccuracy', 'Midcast' }}, false);
            if accuracyShot then
                -- Preserve a valid marksmanship gun/bullet, then layer the
                -- sparse Dark/Light Shot accuracy objective over it.
                equipNamedSetIfNotClear('QuickDrawAccuracy', false);
                equipNamedSetIfNotClear(setNameForElement('QuickDrawAccuracy', element), false);
            end
            -- Weather and day bonuses stack on the server, so apply both
            -- matching overlays instead of stopping at the first one found.
            if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
                equipNamedSetIfNotClear(setNameForElement('QuickDrawWeather', element), false);
            end
            if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
                equipNamedSetIfNotClear(setNameForElement('QuickDrawDay', element), false);
            end
        end
        equipQuickDraw(action);
    elseif actionType == 'corsair roll' then
        equipFirstAvailable({{ profile.OddLuaRuntime.RollSetName(name), 'Roll', 'JobAbility' }}, false);
{pup_maneuver_ability_branch}    elseif string.find(name, 'barrage', 1, true) then
        -- BARRAGE_COUNT is read on the consuming ranged attack. Preload the
        -- exact sparse set here; HandleMidshot reapplies it while active.
        equipNamedSetIfNotClear('Barrage', false);
    elseif string.find(name, 'berserk', 1, true) then
        equipFirstAvailable({{ 'Berserk', 'JobAbility' }}, false);
    elseif string.find(name, 'aggressor', 1, true) then
        equipFirstAvailable({{ 'Aggressor', 'JobAbility' }}, false);
    elseif string.find(name, 'retaliation', 1, true) then
        -- The global status overlay keeps RETALIATION equipped for live hits.
        equipNamedSetIfNotClear('Retaliation', false);
    elseif name == 'warcry' then
        -- LuAshitacast holds this snapshot through ability resolution, then HandleDefault restores normal gear.
        equipFirstAvailable({{ 'Warcry', 'JobAbility' }}, false);
    elseif name == 'sentinel' then
        -- Snapshot the exact Sentinel effect plus Enmity only for Sentinel.
        -- HandleDefault restores the current combat or idle state.
        equipFirstAvailable({{ 'Sentinel', 'Enmity', 'JobAbility' }}, false);
    elseif actionType == 'blood pact: rage' then
        profile.OddLuaPet.beginActionPin('rage');
    elseif actionType == 'blood pact: ward' then
        profile.OddLuaPet.beginActionPin('ward');
    elseif name == 'super jump' then
        -- Super Jump deals no damage and has no cap-75 snapshot modifier.
        -- Preserve current gear when its exact set is intentionally clear.
        equipNamedSetIfNotClear('SuperJump', false);
    elseif name == 'spirit link' then
        equipFirstAvailable({{ 'SpiritLink', 'WyvernHealing', 'JobAbility' }}, false);
    elseif name == 'sneak attack' then
        equipFirstAvailable({{ 'SneakAttack', 'SATA', 'JobAbility' }}, false);
    elseif name == 'trick attack' then
        equipFirstAvailable({{ 'TrickAttack', 'SATA', 'JobAbility' }}, false);
    elseif string.find(name, 'third eye', 1, true) then
        -- The global status overlay keeps THIRD_EYE_COUNTER_RATE equipped
        -- while Third Eye is present; never substitute generic JA gear.
        equipNamedSetIfNotClear('ThirdEye', false);
    elseif string.find(name, 'meditate', 1, true) then
        equipNamedSetIfNotClear('Meditate', false);
    elseif name == 'warding circle' then
        -- Hold the exact circle snapshot through activation; HandleDefault restores normal gear.
        equipNamedSetIfNotClear('WardingCircle', false);
    elseif name == 'ancient circle' then
        equipNamedSetIfNotClear('AncientCircle', false);
    elseif name == 'arcane circle' then
        equipNamedSetIfNotClear('ArcaneCircle', false);
    elseif name == 'holy circle' then
        equipNamedSetIfNotClear('HolyCircle', false);
    elseif name == 'flee' then
        equipNamedSetIfNotClear('Flee', false);
    elseif name == 'hide' then
        equipNamedSetIfNotClear('Hide', false);
    elseif name == 'camouflage' then
        equipNamedSetIfNotClear('Camouflage', false);
    elseif name == 'mug' then
        -- Apply only direct non-weapon Mug modifiers through resolution.
        -- HandleDefault restores the current combat or idle state.
        equipNamedSetIfNotClear('Mug', false);
    elseif name == 'charm' then
        equipFirstAvailable({{ 'Charm', 'JobAbility' }}, false);
    elseif name == 'chakra' then
        -- Chakra has no generic cure-potency lane. Missing exact gear is a
        -- no-op so unrelated JobAbility equipment cannot replace live gear.
        equipNamedSetIfNotClear('Chakra', false);
    elseif name == 'counterstance' then
        -- COUNTERSTANCE_EFFECT snapshots now; counter-rate/damage rows are
        -- held later by the global Counterstance-status overlay.
        equipNamedSetIfNotClear('Counterstance', false);
    elseif name == 'rampart' then
        -- Hold the duration snapshot through activation; HandleDefault restores normal gear.
        equipNamedSetIfNotClear('Rampart', false);
    elseif name == 'shield bash' then
        -- Apply only direct non-weapon modifiers. Preserve the live legal
        -- Main/shield pair and TP; HandleDefault restores the current state.
        equipNamedSetIfNotClear('ShieldBash', false);
    elseif name == 'cover' then
        -- Keep the normal activation enmity gear, then preload the sparse Body
        -- overlay. The global Cover-status condition holds it for live hits.
        equipFirstAvailable({{ 'Enmity', 'JobAbility' }}, false);
        equipNamedSetIfNotClear('CoverActive', false);
    elseif string.find(name, 'provoke', 1, true)
        or string.find(name, 'palisade', 1, true) or string.find(name, 'flash', 1, true) then
        equipFirstAvailable({{ 'Enmity', 'JobAbility' }}, false);
    elseif name == 'healing waltz' then
        equipFirstAvailable({{ 'HealingWaltz', 'StatusRemoval', 'JobAbility' }}, false);
    elseif string.find(name, 'waltz', 1, true) then
        equipFirstAvailable({{ 'Waltz', 'Cure', 'JobAbility' }}, false);
    elseif string.find(name, 'flourish', 1, true) then
        equipFirstAvailable({{ 'Flourish', 'Steps', 'Accuracy', 'JobAbility' }}, false);
    elseif string.find(name, 'step', 1, true) then
        equipFirstAvailable({{ 'Steps', 'Accuracy', 'JobAbility' }}, false);
    elseif string.find(name, 'samba', 1, true) then
        equipNamedSetIfNotClear('Samba', false);
    elseif actionType == 'jig' or actionType == 'jigs'
        or name == 'spectral jig' or name == 'chocobo jig' or name == 'chocobo jig ii' then
        -- Hold the duration snapshot through ability resolution; HandleDefault restores normal gear.
        equipFirstAvailable({{ 'Jig', 'JobAbility' }}, false);
    elseif string.find(name, 'high jump', 1, true) then
        if state.Playstyle == 'Accuracy' then
            if equipFirstAvailable({{ 'HighJumpAccuracy', 'HighJump', 'JumpAccuracy', 'Jump', 'Weaponskill', 'JobAbility' }}, false) then
                return;
            end
        end
        equipFirstAvailable({{ 'HighJump', 'Jump', 'Weaponskill', 'JobAbility' }}, false);
    elseif string.find(name, 'jump', 1, true) then
        if state.Playstyle == 'Accuracy' then
            if equipFirstAvailable({{ 'JumpAccuracy', 'Jump', 'Weaponskill', 'JobAbility' }}, false) then
                return;
            end
        end
        equipFirstAvailable({{ 'Jump', 'Weaponskill', 'JobAbility' }}, false);
    elseif name == 'reward' then
        -- Reward snapshots master gear while preserving weapons and the equipped pet-food Ammo.
        equipNamedSetIfNotClear('Reward', false);
    elseif actionType == 'ready' or name == 'ready' or name == 'sic' then
        profile.OddLuaPet.beginActionPin('ready_sic');
    else
        equipNamedSet('JobAbility', false);
    end
end

local function equipWeaponskill()
    local function isMagicalWeaponSkillName(name)
        return string.find(name, 'aeolian', 1, true) or string.find(name, 'cyclone', 1, true)
            or string.find(name, 'energy', 1, true) or string.find(name, 'red lotus', 1, true)
            or string.find(name, 'seraph', 1, true) or string.find(name, 'sanguine', 1, true)
            or string.find(name, 'wildfire', 1, true) or string.find(name, 'leaden', 1, true)
            or string.find(name, 'jinpu', 1, true) or string.find(name, 'koki', 1, true)
            or string.find(name, 'goten', 1, true) or string.find(name, 'kagero', 1, true);
    end

    local action = getAction();
    local name = action and action.Name;
    local key = weaponSkillRouteKey(name);
    local exactRoute = weaponSkillRoutes[key];
    local accuracyRoute = weaponSkillAccuracyRoutes[key];
    local normalizedName = normalize(name);
    local magicalWeaponSkill = isMagicalWeaponSkillName(normalizedName);
    if state.Playstyle == 'Accuracy' then
        if accuracyRoute and equipNamedSet(accuracyRoute, false) then
            return;
        end
    end
    if magicalWeaponSkill then
        local environment = getEnvironment();
        local element = action and action.Element;
        local candidates = {{}};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
            table.insert(candidates, setNameForElement('WSElementalWeather', element));
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
            table.insert(candidates, setNameForElement('WSElementalDay', element));
        end
        if exactRoute then
            table.insert(candidates, exactRoute);
        end
        table.insert(candidates, 'WSElemental');
        table.insert(candidates, 'Elemental');
        table.insert(candidates, 'Weaponskill');
        equipFirstAvailable(candidates, false);
        return;
    end
    if exactRoute and equipNamedSet(exactRoute, false) then
        return;
    end
    if state.Playstyle == 'Accuracy' then
        equipFirstAvailable({{ 'WeaponSkillAccuracy', 'Weaponskill' }}, false);
    else
        equipNamedSet('Weaponskill', false);
    end
end

profile.OnLoad = function()
    if gSettings then
        gSettings.AllowAddSet = true;
        gSettings.AllowSyncEquip = true;
    end

    if scale and scale.Configure then
        scale.Configure({{
            sets = sets,
            intents = setIntents,
            enabled = true,
            weaponLockEnabled = true,
            preferProfileItems = true,
            debug = false
        }});
    end

    equipDefaultForPlayer(getPlayer(), true);
    message('OddLua dynamic profile loaded for {player}_{player_id}. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd help for commands and one-button setup.');
    message({lua_quote(subjob_load_message)});
    state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();
    oddLuaNumberRow.bindPalette();
{aahtacos_sam_onload}
end

profile.OnUnload = function()
    state.ReconcileEnabled = false;
    cancelPendingReconciliationSnapshot();
    state.ReconcileLastRecordedSignature = nil;
    state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();
    oddLuaNumberRow.unbindPalette();
    unlockSecondarySlotLocks();
{aahtacos_sam_onunload}
end

profile.HandleCommand = function(args)
    if scale and scale.HandleCommand and scale.HandleCommand(args) then
        return;
    end

    if not args or not args[1] then
        printOddLuaHelp();
        return;
    end

    local command = normalize(args[1]);
    local value = normalize(args[2]);

    if command == 'help' or command == '?' then
        printOddLuaHelp();
{aahtacos_sam_help_line}        return;
    elseif command == 'styles' or command == 'stylelist' then
        printStyleList();
        return;
    elseif command == 'styleprev' or command == 'styleback' then
        oddLuaNumberRow.cyclePlaystyle(-1);
    elseif command == 'stylenext' or command == 'stylefwd' then
        oddLuaNumberRow.cyclePlaystyle(1);
    elseif command == 'style' or command == 'playstyle' then
        if value == '' or value == 'status' then
            printStyleList();
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '.');
            printStyleList();
            return;
        end

        state.Playstyle = selected;
        if selected == 'Craft' and isEngaged(getPlayer()) then
            message('Style=Craft. Craft cannot equip while engaged.');
            equipDefaultForPlayer(getPlayer(), true);
            return;
        end

        message('Style=' .. state.Playstyle);
        equipDefaultForPlayer(getPlayer(), true);
    elseif command == 'lockstyle' or command == 'stylelock' then
        lockstyleCombatSet();
    elseif command == 'weaponsync' or command == 'syncweapons' then
        local synced, detail = profile.OddLuaRuntime.SyncActiveStyleWeapons();
        if synced == true then
            message('Weapon sync complete: style=' .. tostring(detail) .. '; Scale weapon lock restored.');
        else
            message('Weapon sync failed: ' .. tostring(detail or 'unknown error') .. '.');
        end
    elseif command == 'warp' then
        useWarpRing();
    elseif command == 'warpclear' then
        clearWarpRing();
    elseif command == 'buffitems' or command == 'buffitem' or command == 'buffoverlays' then
        profile.HandleBuffItemOverlayCommand(args);
    elseif command == 'burst' or command == 'magicburst' or command == 'mburst' then
        if value == '' or value == 'status' then
            message('Magic Burst mode=' .. (state.MagicBurstMode and 'on' or 'off') .. '; use /lac fwd burst on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets['MagicBurst']) ~= 'table' or isClearSet(sets['MagicBurst']) then
                state.MagicBurstMode = false;
                message('Magic Burst mode unavailable: no resolved MagicBurst equipment set.');
                return;
            end
            state.MagicBurstMode = true;
            message('Magic Burst mode=on.');
        elseif value == 'off' then
            state.MagicBurstMode = false;
            message('Magic Burst mode=off.');
        else
            message('Unknown burst option. Use /lac fwd burst on|off|status.');
        end
{blue_learning_command_branches}
{caster_sustain_command_branches}
{guard_command_branches}
{occult_acumen_command_branches}
{explicit_gear_mode_command_branches}
    elseif command == 'override' or command == 'defense' or command == 'def' or profile.DefenseAliases[command] ~= nil then
        if profile.HandleOverrideCommand(args) then
            equipDefaultForPlayer(getPlayer(), true);
        end
    elseif command == 'resist' or command == 'res' or profile.ResistAliases[command] ~= nil then
        if profile.HandleResistCommand(args) then
            equipDefaultForPlayer(getPlayer(), true);
        end
    elseif command == 'setmp' or command == 'addmp' or command == 'resetmp'
        or command == 'sethp' or command == 'addhp' or command == 'resethp' then
        local changed, handled = profile.HandleIdlePoolCommand(args);
        if changed and handled ~= true then
            equipDefaultForPlayer(getPlayer(), true);
        end
    elseif command == 'utility' then
        oddLuaNumberRow.equipUtilityIntent(value);
    elseif command == 'keypad' then
        if value == '' or value == 'status' or value == 'help' or value == 'list' or value == 'map' then
            oddLuaNumberRow.printPalette();
            return;
        elseif value == 'clear' or value == 'cleanup' or value == 'unbind' then
            oddLuaNumberRow.clearPaletteBinds();
            return;
        end
        oddLuaNumberRow.setPaletteEnabled(value);
    elseif command == 'palette' or command == 'numberrow' then
        if value == 'missing' then
            message('Not Applicable / Missing Equipment');
            return;
        end
        if value == 'clear' or value == 'cleanup' or value == 'unbind' then
            oddLuaNumberRow.clearPaletteBinds();
            return;
        end
        oddLuaNumberRow.setPaletteEnabled(value);
    elseif command == 'overlays' or command == 'overlay'
        or command == 'conditionals' or command == 'conditional' then
        profile.PrintConditionalOverlayStatus();
    elseif command == 'mechanics' then
        profile.OddLuaRuntime.HandleMechanicsCommand(args);
    elseif command == 'reconcile' then
        handleReconcileCommand(args);
    elseif command == 'updategear' or command == 'gearupdate' or command == 'refreshgear' or command == 'reprocessgear' or command == 'rebuildgear' then
        startOddLuaGearRefresh(args);
    elseif command == 'status' then
        local subjob, subjobName = currentSubjobProfile();
        local capabilityText = 'none';
        if subjob and subjob.capabilities then
            capabilityText = table.concat(subjob.capabilities, ',');
        end
        local keypadText = 'off';
        if state.NumberRowPaletteEnabled == true then
            keypadText = 'on';
        end
        local buffItemsText = profile.BuffItemOverlayStateText();
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle() .. '; Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. capabilityText .. '; keypad=' .. keypadText .. '; buffitems=' .. buffItemsText .. '; burst=' .. (state.MagicBurstMode and 'on' or 'off'){blue_learning_status_fragment}{caster_sustain_status_fragment}{occult_acumen_status_fragment}{explicit_gear_mode_status_fragment}{aahtacos_sam_status_fragment} .. '; override=' .. profile.OverrideStateText() .. '; safety=' .. profile.OddLuaRuntime.ActiveSafetyReason(getPlayer()) .. '; mpfloor=' .. profile.IdlePoolStateText() .. '; help=/lac fwd help; styles=/lac fwd styles; keypad=/lac fwd keypad');
    elseif command == 'subjob' or command == 'sj' then
        local subjob, subjobName = currentSubjobProfile();
        if not subjob then
            message('Subjob=' .. tostring(subjobName or '') .. '; no configured level-37 subjob profile.');
            return;
        end
        local detail = normalize(args[2]);
        if detail == 'traits' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.traits, 'traits'));
        elseif detail == 'spells' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.spells, 'spells'));
        elseif detail == 'abilities' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.abilities, 'abilities'));
        else
            message('Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. table.concat(subjob.capabilities or {{}}, ',') .. '; use subjob traits|spells|abilities');
        end
{aahtacos_sam_command_branches}
    else
        message('Unknown command: ' .. tostring(args[1]) .. '. Use /lac fwd help.');
    end
end

profile.HandleDefault = function()
{handle_default_body}
end

profile.HandleAbility = function()
    equipAbility();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
{precast_body}
end

profile.HandleMidcast = function()
{alacrity_celerity_midcast_clear}    local action = getAction();
    if not action then
        return;
    end

    local name = normalize(action.Name);
    local skill = normalize(action.Skill);
    if name == 'flash' then
        equipFirstAvailable({{ 'Flash', 'Enmity', 'Divine' }}, false);
    elseif skill == 'divine magic'
        and (string.find(name, 'banish', 1, true) == 1 or string.find(name, 'holy', 1, true) == 1) then
        equipFirstAvailable({{ 'DivineDamage', 'Divine', 'Midcast' }}, false);
    elseif skill == 'divine magic' and name == 'repose' then
        equipFirstAvailable({{ 'Divine', 'MagicAccuracy', 'Midcast' }}, false);
    elseif name == 'cursna' then
        equipFirstAvailable({{ 'Cursna', 'StatusRemoval' }}, false);
    elseif profile.OddLuaRuntime.StatusRemovalSpells[name] == true then
        equipNamedSetIfNotClear('StatusRemoval', false);
    elseif skill == 'healing magic' then
        if string.find(name, 'cure', 1, true) == 1 or string.find(name, 'cura', 1, true) == 1 then
            local environment = getEnvironment();
            local candidates = {{}};
            if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, 'Light') then
                table.insert(candidates, 'CureWeather_Light');
            end
            if environment and environment.DayElement and elementMatches(environment.DayElement, 'Light') then
                table.insert(candidates, 'CureDay_Light');
            end
            table.insert(candidates, 'Cure');
            table.insert(candidates, 'Healing');
            equipFirstAvailable(candidates, false);
        else
            equipNamedSet('Healing', false);
        end
    elseif skill == 'enhancing magic' then
        equipEnhancingMagic(name);
    elseif skill == 'enfeebling magic' then
        equipEnfeeblingMagic(name);
    elseif skill == 'divine magic' then
        equipFirstAvailable({{ 'Divine', 'Midcast' }}, false);
    elseif skill == 'elemental magic' then
        equipElementalMagic(action);
    elseif skill == 'dark magic' then
        equipDarkMagic(name);
    elseif skill == 'blue magic' then
        equipBlueMagic(action);
    elseif skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        equipSong(name);
    elseif skill == 'geomancy' then
        if string.sub(name, 1, 5) == 'indi-' then
            equipFirstAvailable({{ 'IndiDuration', 'Geomancy', 'GeoMagic', 'Midcast' }}, false);
        else
            equipFirstAvailable({{ 'Geomancy', 'GeoMagic', 'Midcast' }}, false);
        end
    elseif skill == 'summoning magic' or skill == 'summoning' then
        equipSummoning(name);
    elseif skill == 'ninjutsu' then
        equipNinjutsu(action);{conserve_mp_unknown_return}
    end{conserve_mp_midcast_overlay}{occult_acumen_midcast_overlay}{explicit_gear_mode_midcast_overlay}
end

profile.HandlePreshot = function()
    if not equipNamedSet('Snapshot', false) then
        equipNamedSet('RangedPreshot', false);
    end
end

profile.HandleMidshot = function()
    -- Preshot is deliberately sparse Snapshot/Rapid Shot gear. Restore a
    -- complete ranged-combat base before applying the sparse midshot overlay,
    -- so unscored slots never retain preshot gear or arbitrary filler.
    if not equipNamedSetIfNotClear('RangedAccuracy', false) then
        equipNamedSetIfNotClear('Ranged', false);
    end
    equipNamedSetIfNotClear('RangedMidshot', false);
    if hasBuff('Barrage') then
        -- BARRAGE_COUNT is evaluated on this ranged attack, not when the
        -- ability applies its status.
        equipNamedSetIfNotClear('Barrage', false);
    end
end

profile.HandleWeaponskill = function()
    equipWeaponskill();
end

return profile;
"""
