from __future__ import annotations

import re
from typing import Iterable, Mapping

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

ODDLUA_REFRESH_LAUNCHER = r"C:\Users\jakeb\Projects\FFXI Personal Server\OddLua\Run-OddLuaGameRefresh.cmd"
ODDLUA_REFRESH_STATUS_PATH = r"C:\Users\jakeb\Projects\FFXI Personal Server\OddLua\reports\game-refresh\latest-status.json"

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
    "InCity": "Movement",
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
    "Idle": "Idle",
    "Resting": "Idle",
    "InCity": "Movement",
    "Movement": "Movement",
    "Movement_City": "Movement",
    "Movement_Night": "Movement",
    "Movement_DuskToDawn": "Movement",
    "Aftercast": "Idle",
    "PDT": "PDT",
    "MDT": "MDT",
    "Crafting": "Crafting",
    "TP": "TP",
    "Hybrid": "TP",
    "TPAccuracy": "Accuracy",
    "Precast": "FastCast",
    "FastCast": "FastCast",
    "Midcast": "MagicAccuracy",
    "Cure": "Cure",
    "Healing": "Healing",
    "Enhancing": "Enhancing",
    "EnhancingDuration": "Enhancing",
    "Stoneskin": "Enhancing",
    "Refresh": "Enhancing",
    "Regen": "Healing",
    "SneakInvisible": "Enhancing",
    "Barspell": "Enhancing",
    "Phalanx": "Enhancing",
    "Aquaveil": "Enhancing",
    "Haste": "Enhancing",
    "Enfeebling": "Enfeebling",
    "Sleep": "Enfeebling",
    "Bind": "Enfeebling",
    "Gravity": "Enfeebling",
    "Silence": "Enfeebling",
    "Slow": "Enfeebling",
    "Paralyze": "Enfeebling",
    "Blind": "Enfeebling",
    "Dispel": "Enfeebling",
    "Dia": "Enfeebling",
    "Bio": "DarkMagic",
    "Divine": "Cure",
    "Elemental": "Nuke",
    "Nuke": "Nuke",
    "DarkMagic": "DarkMagic",
    "DrainAspir": "DarkMagic",
    "Absorb": "DarkMagic",
    "Stun": "DarkMagic",
    "BlueMagic": "BlueMagic",
    "PhysicalBlueMagic": "BlueMagic",
    "MagicalBlueMagic": "Nuke",
    "Song": "Song",
    "SongDebuff": "Song",
    "SongBuff": "Song",
    "Geomancy": "MagicAccuracy",
    "Summoning": "MagicAccuracy",
    "BloodPactRage": "PetDamage",
    "BloodPactWard": "PetTank",
    "AvatarPerp": "Refresh",
    "Ninjutsu": "Ninjutsu",
    "Utsusemi": "FastCast",
    "NinjutsuEnfeeble": "Ninjutsu",
    "Snapshot": "RangedPreshot",
    "RangedPreshot": "RangedPreshot",
    "Ranged": "RangedAccuracy",
    "RangedMidshot": "RangedAccuracy",
    "RangedAccuracy": "RangedAccuracy",
    "RangedAttack": "RangedAttack",
    "QuickDraw": "QuickDraw",
    "Weaponskill": "Weaponskill",
    "WeaponSkillAccuracy": "Weaponskill",
    "WSElemental": "Weaponskill",
    "JobAbility": "TP",
    "Enmity": "Enmity",
    "Waltz": "Cure",
    "Steps": "Accuracy",
    "Samba": "TP",
    "Jump": "Weaponskill",
    "Meditate": "JobAbility",
    "ThirdEye": "JobAbility",
    "PetReady": "PetDamage",
    "PetMagic": "PetDamage",
    "PetTank": "PetTank",
    "Roll": "Roll",
}

SEMANTIC_SET_PREFERENCES = {
    "Idle": (
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
    "Resting": ("IdleRefresh", "AvatarPerp", "Cure", "FastCast", "MagicAccuracy"),
    "InCity": ("InCity", "Movement_City", "Movement"),
    "Movement": ("Movement",),
    "Movement_City": ("Movement_City", "Movement"),
    "Movement_Night": ("Movement_Night", "Movement"),
    "Movement_DuskToDawn": ("Movement_DuskToDawn", "Movement"),
    "Aftercast": ("IdleRefresh", "Safe", "Survival", "Evasion", "MagicDefense", "FastCast", "Cure"),
    "PDT": ("Safe", "Survival", "Evasion", "PetTank", "Tank", "MagicDefense"),
    "MDT": ("MagicDefense", "Safe", "Survival", "Tank", "IdleRefresh", "AvatarPerp"),
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
    "Hybrid": ("Survival", "Evasion", "Safe", "Tank", "Damage", "Accuracy"),
    "TPAccuracy": ("Accuracy", "Dagger", "RangedAccuracy", "MagicAccuracy", "Damage"),
    "Precast": ("FastCast", "Ninjutsu", "Song", "GeoMagic", "MagicAccuracy"),
    "FastCast": ("FastCast", "Ninjutsu", "Song", "GeoMagic", "MagicAccuracy"),
    "Midcast": ("MagicAccuracy", "Nuke", "MagicalBlue", "GeoMagic", "FastCast"),
    "Cure": ("Cure", "Waltz", "FastCast", "IdleRefresh"),
    "Healing": ("Cure", "Waltz", "FastCast", "IdleRefresh"),
    "Enhancing": ("FastCast", "Cure", "MagicAccuracy", "GeoMagic"),
    "EnhancingDuration": ("FastCast", "Cure", "MagicAccuracy", "GeoMagic"),
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
    "Gravity": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Silence": ("MagicAccuracy", "Song", "FastCast"),
    "Slow": ("MagicAccuracy", "FastCast"),
    "Paralyze": ("MagicAccuracy", "FastCast"),
    "Blind": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Dispel": ("MagicAccuracy", "FastCast"),
    "Dia": ("MagicAccuracy", "Cure", "FastCast"),
    "Bio": ("DrainAbsorb", "MagicAccuracy", "FastCast"),
    "Divine": ("Nuke", "Cure", "MagicAccuracy", "FastCast"),
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
    "SongDebuff": ("Song", "MagicAccuracy", "FastCast"),
    "SongBuff": ("Song", "FastCast", "IdleRefresh"),
    "Geomancy": ("GeoMagic", "MagicAccuracy", "FastCast"),
    "Summoning": ("SummoningMagic", "BloodPact", "AvatarPerp", "FastCast"),
    "BloodPactRage": ("BloodPact", "PetDamage", "SummoningMagic", "FastCast"),
    "BloodPactWard": ("SummoningMagic", "PetTank", "AvatarPerp", "FastCast"),
    "AvatarPerp": ("AvatarPerp", "IdleRefresh", "SummoningMagic"),
    "Ninjutsu": ("Ninjutsu", "MagicAccuracy", "FastCast", "Evasion"),
    "Utsusemi": ("FastCast", "Ninjutsu", "Evasion"),
    "NinjutsuEnfeeble": ("Ninjutsu", "MagicAccuracy", "FastCast"),
    "Snapshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "RangedPreshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "Ranged": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "RangedMidshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Accuracy"),
    "RangedAccuracy": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Accuracy"),
    "RangedAttack": ("RangedDamage", "RangedAccuracy", "QuickDraw"),
    "QuickDraw": ("QuickDraw", "MagicAccuracy", "Nuke", "RangedAccuracy"),
    "Weaponskill": (
        "WeaponSkill",
        "Jump",
        "StoreTP",
        "Damage",
        "Melt",
        "Enspell",
        "RangedDamage",
        "Accuracy",
        "PhysicalBlue",
    ),
    "WeaponSkillAccuracy": ("WeaponSkill", "Accuracy", "StoreTP", "RangedAccuracy", "Damage"),
    "WSElemental": ("Nuke", "MagicalBlue", "QuickDraw", "WeaponSkill", "MagicAccuracy"),
    "JobAbility": ("Enmity", "Jump", "Roll", "Waltz", "PetDamage", "Tank"),
    "Enmity": ("Enmity", "Tank", "MagicDefense", "FastCast"),
    "Waltz": ("Waltz", "Cure", "Evasion"),
    "Steps": ("Accuracy", "Damage", "Evasion"),
    "Samba": ("Damage", "Accuracy", "StoreTP"),
    "Jump": ("Jump", "WeaponSkill", "Accuracy", "Damage"),
    "PetReady": ("PetDamage", "PetTank", "Damage"),
    "PetMagic": ("PetDamage", "MagicAccuracy", "Nuke"),
    "PetTank": ("PetTank", "Survival", "Tank"),
    "Roll": ("Roll", "RangedAccuracy", "QuickDraw", "FastCast"),
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


def render_blue_magic_routes() -> str:
    lines = ["local blueMagicRoutes = {"]
    for spell_name, set_name in sorted(BLUE_MAGIC_ROUTES.items()):
        lines.append(f"    [{lua_quote(spell_name)}] = {lua_quote(set_name)},")
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


def render_aahtacos_sam_state_fields(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    AutoThirdEye = false,
    AutoWarBuffs = false,
    AutoCombat = false,"""


def render_aahtacos_sam_locals(enabled: bool) -> str:
    if not enabled:
        return ""
    return """local THIRD_EYE_COMMAND = '/ja "Third Eye" <me>';
local AUTO_THIRD_EYE_UNKNOWN_RETRY_SECONDS = 30;
local AUTO_THIRD_EYE_READY_RETRY_SECONDS = 3;
local AUTO_THIRD_EYE_RECAST_POLL_SECONDS = 1;
local AUTO_WAR_BUFF_UNKNOWN_RETRY_SECONDS = 30;
local AUTO_WAR_BUFF_READY_RETRY_SECONDS = 3;
local lastAutoThirdEyeAt = -9999;
local lastAutoWarBuffAt = {
    Berserk = -9999,
    Warcry = -9999,
};
local lastThirdEyeRecastCheckAt = -9999;
local lastThirdEyeOnCooldown = nil;

local samBinds = {
    { key = '^1', binding = '/bind ^1 /ws "Tachi: Gekko" <t>', unbind = '/unbind ^1' },
    { key = '^2', binding = '/bind ^2 /ws "Tachi: Yukikaze" <t>', unbind = '/unbind ^2' },
    { key = '^3', binding = '/bind ^3 /ws "Tachi: Shoha" <t>', unbind = '/unbind ^3' },
    { key = '^4', binding = '/bind ^4 /ws "Tachi: Kaiten" <t>', unbind = '/unbind ^4' },
    { key = '^5', binding = '/bind ^5 /lac fwd sekkagekko', unbind = '/unbind ^5' },
    { key = '^6', binding = '/bind ^6 /lac fwd konzenshoha', unbind = '/unbind ^6' },
    { key = '!1', binding = '/bind !1 /ja "Hasso" <me>', unbind = '/unbind !1' },
    { key = '!2', binding = '/bind !2 /lac fwd seiganeye', unbind = '/unbind !2' },
    { key = '!3', binding = '/bind !3 /ja "Meditate" <me>', unbind = '/unbind !3' },
    { key = '!4', binding = '/bind !4 /lac fwd warbuffs', unbind = '/unbind !4' },
    { key = '!5', binding = '/bind !5 /ja "Provoke" <t>', unbind = '/unbind !5' },
    { key = '!6', binding = '/bind !6 /ja "Third Eye" <me>', unbind = '/unbind !6' },
    { key = '!7', binding = '/bind !7 /lac fwd autoeye', unbind = '/unbind !7' },
    { key = '!8', binding = '/bind !8 /lac fwd autowar', unbind = '/unbind !8' },
    { key = '!9', binding = '/bind !9 /lac fwd autocombat', unbind = '/unbind !9' },
};

local warBuffCommands = {
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
    message('Commands: style/status/subjob/warp/help/sekkagekko/konzenshoha/seiganeye/warbuffs/autoeye/autowar/autocombat/scale status.');
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
    if now - lastThirdEyeRecastCheckAt < AUTO_THIRD_EYE_RECAST_POLL_SECONDS then
        return lastThirdEyeOnCooldown;
    end

    lastThirdEyeRecastCheckAt = now;
    lastThirdEyeOnCooldown = isAbilityOnCooldown('Third Eye');
    return lastThirdEyeOnCooldown;
end

local function queueSamCommands(label, commands)
    for _, command in ipairs(commands or {}) do
        if command.delay and command.delay > 1 and scheduleTask(command.delay, function()
            queueTypedCommand(command.text, 1);
        end) then
            -- Scheduled through ashita.tasks.once.
        else
            queueTypedCommand(command.text, command.delay or 1);
        end
        if command.text == THIRD_EYE_COMMAND then
            lastAutoThirdEyeAt = os.clock();
        end
    end
    message(label);
end

local function maybeAutoThirdEye(player)
    if state.AutoCombat ~= true or state.AutoThirdEye ~= true then
        return;
    end
    if not player or not isEngaged(player) then
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
    local retrySeconds = AUTO_THIRD_EYE_UNKNOWN_RETRY_SECONDS;
    if onCooldown == false then
        retrySeconds = AUTO_THIRD_EYE_READY_RETRY_SECONDS;
    end
    if now - lastAutoThirdEyeAt < retrySeconds then
        return;
    end

    queueSamCommands('Seigan active; Third Eye queued.', {
        { delay = 1, text = THIRD_EYE_COMMAND },
    });
end

local function maybeAutoWarBuffs(player)
    if state.AutoCombat ~= true or state.AutoWarBuffs ~= true then
        return;
    end
    if not player or not isEngaged(player) then
        return;
    end

    local now = os.clock();
    local commands = {};
    for _, buff in ipairs(warBuffCommands) do
        if not hasBuff(buff.buff) then
            local onCooldown = isAbilityOnCooldown(buff.ability);
            if onCooldown ~= true then
                local retrySeconds = AUTO_WAR_BUFF_UNKNOWN_RETRY_SECONDS;
                if onCooldown == false then
                    retrySeconds = AUTO_WAR_BUFF_READY_RETRY_SECONDS;
                end
                if now - lastAutoWarBuffAt[buff.ability] >= retrySeconds then
                    commands[#commands + 1] = { delay = buff.delay, text = buff.command };
                    lastAutoWarBuffAt[buff.ability] = now;
                end
            end
        end
    end

    if #commands > 0 then
        queueSamCommands('Auto WAR buffs queued.', commands);
    end
end"""


def render_aahtacos_sam_onload(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    for _, bind in ipairs(samBinds) do
        queueTypedCommand(bind.binding, -1);
    end
    samPrintHelp();"""


def render_aahtacos_sam_onunload(enabled: bool) -> str:
    if not enabled:
        return ""
    return """    for _, bind in ipairs(samBinds) do
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
            { delay = 3, text = '/ja "Third Eye" <me>' },
        });
    elseif command == 'warbuffs' then
        queueSamCommands('Berserk + Warcry queued.', {
            { delay = 1, text = '/ja "Berserk" <me>' },
            { delay = 3, text = '/ja "Warcry" <me>' },
        });
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


def render_lua_table(name: str, values: dict[str, str]) -> str:
    lines = [f"    {name} = {{"]
    if not values:
        for slot in SLOT_ORDER:
            lines.append(f"        {slot} = 'remove',")
    else:
        for slot in SLOT_ORDER:
            item = values.get(slot)
            if item:
                lines.append(f"        {slot} = {lua_quote(item)},")
    lines.append("    },")
    return "\n".join(lines)


def _number_row_bindings(number_row_palette: Mapping[str, object]) -> tuple[dict[str, str], ...]:
    bindings = number_row_palette.get("bindings")
    if not isinstance(bindings, list):
        return tuple()
    rows: list[dict[str, str]] = []
    for binding in bindings:
        if not isinstance(binding, dict):
            continue
        key = str(binding.get("key", "")).strip()
        label = str(binding.get("label", "")).strip()
        literal = str(binding.get("literal", "")).strip()
        kind = str(binding.get("kind", "")).strip()
        toggle = str(binding.get("toggleState", "")).strip()
        if not key or not label or not literal:
            continue
        rows.append(
            {
                "key": key,
                "label": label,
                "literal": literal,
                "kind": kind,
                "toggle": toggle,
            }
        )
    return tuple(rows)


def render_number_row_bindings(number_row_palette: Mapping[str, object]) -> str:
    lines = ["local numberRowBindings = {"]
    for binding in _number_row_bindings(number_row_palette):
        lines.append(
            "    { key = "
            + lua_quote(binding["key"])
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
    lines = []
    for binding in _number_row_bindings(number_row_palette):
        bind_literal = f"/bind {binding['key']} {binding['literal']}"
        lines.append(f"    queueTypedCommand({lua_quote(bind_literal)}, -1);")
    return "\n".join(lines)


def render_number_row_unbind_commands(number_row_palette: Mapping[str, object]) -> str:
    lines = []
    for binding in _number_row_bindings(number_row_palette):
        unbind_literal = f"/unbind {binding['key']}"
        lines.append(f"    queueTypedCommand({lua_quote(unbind_literal)}, -1);")
    return "\n".join(lines)


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
    return """local function mechanicsPlanForSet(setName)
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
    message('Mechanics execution is disabled for this profile slice; use probes to validate timing before promotion.');
end

local function handleMechanicsCommand(args)
    local subcommand = normalize(args and args[2]);
    if subcommand == '' or subcommand == 'status' then
        mechanicsStatus();
        return;
    elseif subcommand == 'help' then
        message('mechanics status | mechanics list | mechanics warnings | mechanics skipped | mechanics probes on|off | mechanics plan <set> | mechanics probe <set>');
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
    end
    message('Unknown mechanics command. Use mechanics help.');
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
            parts.append(f"{key} = {{ " + ", ".join(lua_quote(str(value)) for value in values) + " }")
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


def render_reconciliation_helpers(*, player: str, player_id: str, job: str) -> str:
    slot_lines = "\n".join(f"    {lua_quote(slot)}," for slot in SLOT_ORDER)
    safe_name = re.sub(r"[^A-Za-z0-9_.-]+", "_", f"{player}_{player_id}-{job}")
    log_path = f"logs/oddlua-reconcile-{safe_name}.jsonl"
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

local function reconciliationObservedName(entry)
    if type(entry) == 'string' then
        return entry;
    elseif type(entry) == 'table' then
        if entry.Name ~= nil then
            return entry.Name;
        end
        if type(entry.Resource) == 'table' and type(entry.Resource.Name) == 'table' then
            return entry.Resource.Name[1];
        end
        if type(entry.Item) == 'table' and entry.Item.Name ~= nil then
            return entry.Item.Name;
        end
    end
    return nil;
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

    local observed = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local name = reconciliationObservedName(equipment[slot]);
        if name ~= nil and tostring(name) ~= '' then
            observed[slot] = tostring(name);
        end
    end
    return observed, nil;
end

local function reconciliationNamesMatch(expected, observed)
    local expectedText = normalize(expected);
    local observedText = normalize(observed);
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
    parts[#parts + 1] = '"sequence":' .. tostring(snapshot.sequence or 0);
    parts[#parts + 1] = '"timestamp":' .. tostring(snapshot.timestamp or 0);
    parts[#parts + 1] = '"set":' .. reconciliationJsonEscape(snapshot.set);
    parts[#parts + 1] = '"status":' .. reconciliationJsonEscape(snapshot.status);
    parts[#parts + 1] = '"force":' .. reconciliationJsonBool(snapshot.force == true);
    parts[#parts + 1] = '"repair":' .. reconciliationJsonBool(snapshot.repair == true);
    parts[#parts + 1] = '"repairQueued":' .. reconciliationJsonBool(snapshot.repairQueued == true);
    parts[#parts + 1] = '"playstyle":' .. reconciliationJsonEscape(snapshot.playstyle);
    parts[#parts + 1] = '"intent":' .. reconciliationJsonEscape(snapshot.intent);
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

local function reconciliationDelayForSet(setName)
    local intent = normalize(setIntents[setName] or '');
    if intent == 'idle' or intent == 'movement' or intent == 'tp' then
        return 0.35;
    end
    return 0.08;
end

local function reconciliationCanRepairIntent(intent)
    local intentText = normalize(intent or '');
    return intentText == 'tp' or intentText == 'idle' or intentText == 'movement';
end

local repairReconciliationMismatch;

local function cancelPendingReconciliationSnapshot()
    state.ReconcilePendingSnapshot = nil;
    state.ReconcileScanScheduled = false;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
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

    local observed, reason = observeReconciliationEquipment();
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

    snapshot.sequence = pending.sequence;
    snapshot.timestamp = nowSeconds();
    snapshot.force = pending.force == true;
    snapshot.repair = pending.repair == true;
    snapshot.repairQueued = false;
    snapshot.playstyle = pending.playstyle;
    snapshot.intent = pending.intent;
    if snapshot.status == 'mismatch' and repairReconciliationMismatch then
        snapshot.repairQueued = repairReconciliationMismatch(pending);
    end
    state.ReconcileLast = snapshot;
    state.ReconcileLastRecordedSignature = pending.signature;
    writeReconciliationSnapshot(snapshot);

    if snapshot.status == 'mismatch' and snapshot.repairQueued ~= true then
        local repairText = '';
        if snapshot.repair == true then
            repairText = '; repair=failed';
        end
        message('Reconcile mismatch set=' .. tostring(pending.set) .. '; slots=' .. reconciliationMismatchSlots(snapshot.mismatches) .. repairText .. '; log=' .. reconciliationConfig.logPath);
    end
end

local function scheduleReconciliationSnapshot(setName, expectedSet, force, repair)
    if state.ReconcileEnabled ~= true then
        return;
    end

    local expected = reconciliationExpectedMap(expectedSet);
    local signature = reconciliationExpectedSignature(setName, expected);
    if repair ~= true and signature == state.ReconcileLastRecordedSignature then
        if state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.repair == true and state.ReconcilePendingSnapshot.signature == signature then
            return;
        end
        cancelPendingReconciliationSnapshot();
        return;
    end

    state.ReconcileSnapshotSeq = (state.ReconcileSnapshotSeq or 0) + 1;
    state.ReconcilePendingSnapshot = {
        sequence = state.ReconcileSnapshotSeq,
        set = setName,
        expected = expected,
        force = force == true,
        repair = repair == true,
        playstyle = state.Playstyle,
        intent = setIntents[setName] or '',
        signature = signature,
    };

    if state.ReconcileScanScheduled == true then
        return;
    end

    state.ReconcileScanScheduled = true;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
    local token = state.ReconcileScanToken;
    if not scheduleTask(reconciliationDelayForSet(setName), function()
        recordPendingReconciliationSnapshot(token);
    end) then
        recordPendingReconciliationSnapshot(token);
    end
end

repairReconciliationMismatch = function(pending)
    if type(pending) ~= 'table' then
        return false;
    end
    if pending.repair == true or not reconciliationCanRepairIntent(pending.intent) then
        return false;
    end
    if type(pending.expected) ~= 'table' or next(pending.expected) == nil then
        return false;
    end

    local repaired = false;
    if scale and scale.ForceEquipSet then
        local ok = pcall(function()
            scale.ForceEquipSet(pending.set, pending.expected, pending.intent);
        end);
        repaired = ok == true;
    elseif gFunc and gFunc.ForceEquipSet then
        local ok = pcall(function()
            gFunc.ForceEquipSet(pending.expected);
        end);
        repaired = ok == true;
    elseif gFunc and gFunc.EquipSet then
        local ok = pcall(function()
            gFunc.EquipSet(pending.expected);
        end);
        repaired = ok == true;
    end

    if repaired == true then
        scheduleReconciliationSnapshot(pending.set, pending.expected, true, true);
    end
    return repaired;
end

local function handleReconcileCommand(args)
    local command = normalize(args and args[2]);
    if command == 'on' then
        state.ReconcileEnabled = true;
        message('Reconciliation snapshots enabled; log=' .. reconciliationConfig.logPath);
    elseif command == 'off' then
        state.ReconcileEnabled = false;
        message('Reconciliation snapshots disabled.');
    elseif command == 'status' or command == '' then
        local lastStatus = 'none';
        if state.ReconcileLast and state.ReconcileLast.status then
            lastStatus = tostring(state.ReconcileLast.status);
        end
        message('Reconcile enabled=' .. tostring(state.ReconcileEnabled == true) .. '; last=' .. lastStatus .. '; log=' .. reconciliationConfig.logPath .. '; use reconcile on|off|status|last.');
    elseif command == 'last' then
        if not state.ReconcileLast then
            message('Reconcile last: none yet; log=' .. reconciliationConfig.logPath);
            return;
        end
        message('Reconcile last set=' .. tostring(state.ReconcileLast.set) .. '; status=' .. tostring(state.ReconcileLast.status) .. '; mismatches=' .. reconciliationMismatchSlots(state.ReconcileLast.mismatches) .. '; log=' .. reconciliationConfig.logPath);
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
    )


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
    mechanics_swap_planner: Mapping[str, object] | None = None,
    number_row_palette: Mapping[str, object] | None = None,
) -> str:
    style_intents = style_intents or STYLE_INTENTS
    subjob_profiles = subjob_profiles or {}
    profile_features = profile_features or tuple()
    number_row_palette = number_row_palette or {"keys": [], "bindings": [], "unbound": []}
    aahtacos_sam_controls_enabled = AAHTACOS_SAM_CONTROLS_FEATURE in profile_features
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
    rendered_intents = {
        **{
            name: style_intents.get(name, STYLE_INTENTS.get(name, SEMANTIC_INTENTS.get(name, "TP")))
            for name in exact_sets
        },
        **{
            f"Playstyle_{name}": style_intents.get(name, STYLE_INTENTS.get(name, "TP"))
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
    rendered_conditional_equips = {
        rendered_name: tuple(entries)
        for rendered_name in rendered_sets
        if (
            entries := conditional_equips.get(
                rendered_name[len("Playstyle_") :] if rendered_name.startswith("Playstyle_") else rendered_name
            )
        )
    }
    set_blocks = "\n\n".join(
        render_lua_table(name, gear)
        for name, gear in rendered_sets.items()
    )
    secondary_slot_lock_block = render_secondary_slot_locks(rendered_secondary_slot_locks)
    dual_wield_sub_set_block = render_dual_wield_sub_sets(rendered_dual_wield_sub_sets)
    conditional_equip_block = render_conditional_equips(rendered_conditional_equips)
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
    subjob_block = render_subjob_profiles(subjob_profiles)
    job_id_block = render_job_id_table()
    blue_magic_route_block = render_blue_magic_routes()
    reconciliation_helpers = render_reconciliation_helpers(player=player, player_id=player_id, job=job)
    aahtacos_sam_state_fields = render_aahtacos_sam_state_fields(aahtacos_sam_controls_enabled)
    aahtacos_sam_locals = render_aahtacos_sam_locals(aahtacos_sam_controls_enabled)
    aahtacos_sam_helpers = render_aahtacos_sam_helpers(aahtacos_sam_controls_enabled)
    aahtacos_sam_onload = render_aahtacos_sam_onload(aahtacos_sam_controls_enabled)
    aahtacos_sam_onunload = render_aahtacos_sam_onunload(aahtacos_sam_controls_enabled)
    aahtacos_sam_command_branches = render_aahtacos_sam_command_branches(aahtacos_sam_controls_enabled)
    aahtacos_sam_help_line = "        samPrintHelp();\n" if aahtacos_sam_controls_enabled else ""
    handle_default_body = render_handle_default_body(aahtacos_sam_controls_enabled)
    number_row_bindings = render_number_row_bindings(number_row_palette)
    number_row_bind_commands = render_number_row_bind_commands(number_row_palette)
    number_row_unbind_commands = render_number_row_unbind_commands(number_row_palette)
    number_row_render_event = lua_quote(f"oddlua_number_row_{player}_{player_id}_{job}")
    number_row_overlay_title = lua_quote(f"OddLua {player}_{player_id} {job}")
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

    return f"""local profile = {{}};

local state = {{
    Playstyle = {lua_quote(default_playstyle)},
    NumberRowPaletteEnabled = true,
    WarpRingLocked = false,
    SecondarySlotLocks = {{}},
    SecondarySlotLockContextSetNames = nil,
    MechanicsProbes = false,
    MechanicsExecution = false,
    ReconcileEnabled = true,
    ReconcileSnapshotSeq = 0,
    ReconcilePendingSnapshot = nil,
    ReconcileScanScheduled = false,
    ReconcileScanToken = 0,
    ReconcileLastRecordedSignature = nil,
    ReconcileLast = nil,
    ReconcileLogDirectoryReady = false,
    ReconcileLastWriteError = nil,
    StableEquipForcePending = false,
    OddLuaRefreshPending = false,
    OddLuaRefreshLastStatus = 'none',
{aahtacos_sam_state_fields}
}};

local sets = {{
{set_blocks}
}};

profile.Sets = sets;
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
    DNC = true,
    NIN = true,
}};

{dual_wield_sub_set_block}

{conditional_equip_block}

{mechanics_swap_planner_block}

{blue_magic_route_block}

local weaponSkillRoutes = {{
{weapon_skill_route_block}
}};

local weaponSkillAccuracyRoutes = {{
{weapon_skill_accuracy_route_block}
}};

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

local mountedStatusBuffs = {{
    chocobo = true,
    mount = true,
    mounted = true,
}};

local mountedStatusIds = {{ 252 }};

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
    message('Quick start: /lac fwd help | styles | status | lockstyle | warp | subjob | mechanics help | reconcile status | refreshgear.');
    message('Current style=' .. tostring(state.Playstyle) .. '; default=' .. tostring(DEFAULT_PLAYSTYLE) .. '.');
    printStyleList();
    message('Lockstyle: /lac fwd lockstyle equips the TP set first, then /lockstyle on.');
    message('Reconciliation: /lac fwd reconcile on|off|status|last.');
    message('Gear refresh: /lac fwd refreshgear queues /gearexport full, rebuilds OddLua, applies profiles, then reloads on success.');
    message('One-button macros: review/load keybindings.txt; F-keys run /lac fwd commands.');
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
        message('OddLua gear refresh failed: ' .. tostring(detail or '') .. '; status=' .. oddLuaRefresh.statusPath);
        return;
    end

    state.OddLuaRefreshLastStatus = status or 'running';
    if attempt >= oddLuaRefresh.maxPolls then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh still running or status unavailable after polling; check ' .. oddLuaRefresh.statusPath);
        return;
    end

    if not scheduleTask(oddLuaRefresh.pollSeconds, function()
        pollOddLuaRefreshStatus(attempt + 1);
    end) then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh poll scheduling failed; check ' .. oddLuaRefresh.statusPath);
    end
end

local function launchOddLuaGearRefresh()
    if not ashita or not ashita.misc or not ashita.misc.execute then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed: ashita.misc.execute unavailable. Run the refresh script manually.');
        return false;
    end

    local ok, err = pcall(function()
        ashita.misc.execute(oddLuaRefresh.launcher, '');
    end);
    if not ok then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed to launch: ' .. tostring(err));
        return false;
    end

    message('OddLua refresh launched. Polling status; log root is reports/game-refresh.');
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
        message('OddLua gear refresh failed: scheduler unavailable after gearexport. Run ' .. oddLuaRefresh.launcher .. ' manually.');
    end
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
    if gData and gData.GetPlayer then
        return gData.GetPlayer();
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
    if gData and gData.GetEnvironment then
        local ok, environment = pcall(gData.GetEnvironment);
        if ok then
            if environment and AshitaCore and AshitaCore.GetMemoryManager then
                local okZone, zoneId = pcall(function()
                    return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
                end);
                if okZone then
                    environment.ZoneId = zoneId;
                end
            end
            return environment;
        end
    end
    return nil;
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
    if not gData or not gData.GetBuffCount then
        return 0;
    end

    local ok, count = pcall(gData.GetBuffCount, name);
    if ok and type(count) == 'number' then
        return count;
    end
    return 0;
end

local function hasBuff(name)
    if name == nil or tostring(name) == '' then
        return false;
    end
    return getBuffCount(name) > 0;
end

local function hasDangerousStatus()
    for name in pairs(dangerousStatusBuffs) do
        if hasBuff(name) then
            return true;
        end
    end
    for _, id in ipairs(dangerousStatusIds) do
        if hasBuff(id) then
            return true;
        end
    end
    return false;
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
    return nativeDualWieldMainJobs[{lua_quote(job.upper())}] == true;
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

    for name, _ in pairs(mountedStatusBuffs) do
        if hasBuff(name) then
            return true;
        end
    end
    for _, id in ipairs(mountedStatusIds) do
        if hasBuff(id) then
            return true;
        end
    end
    return false;
end

local function isOnFoot(player)
    return not isMounted(player);
end

local function canEquipMovement(player, environment)
    if isCity(environment) then
        return true;
    end
    return not isEngaged(player) and isOnFoot(player);
end

local function shouldEquipInCityMovement(player, environment)
    return isCity(environment);
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

local function playerTp(player)
    if not player then
        return 0;
    end
    return tonumber(player.TP or player.tp or player.TacticalPoints or player.tacticalPoints or 0) or 0;
end

local function isEmergencyHp(player)
    local hpp = playerHpp(player);
    return hpp ~= nil and hpp <= 35;
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
    local candidates = {{ 'PDT', 'Playstyle_Safe', 'Safe', 'Survival', 'Tank', 'Evasion', 'Hybrid', 'MDT' }};
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
        return defensiveSet;
    end
    local tp = playerTp(player);
    if tp < OVERT_DEFENSE_TP_UNLOCK then
        return defensiveSet;
    end
    return nil;
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

local function applyConditionalEquipsForSet(setName, force)
    if not conditionals or not conditionals.ApplyForSet then
        return false;
    end

    return conditionals.ApplyForSet(conditionalEquips, setName, {{
        force = force,
        gFunc = gFunc,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        state = state,
    }});
end

local reconciliationProtectedWeaponSlots = {{
    Main = true,
    Sub = true,
    Range = true,
}};

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

local function reconciliationEquipContext(force)
    return {{
        force = force,
        gFunc = gFunc,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        state = state,
    }};
end

local function conditionalOverlayForSet(setName, force)
    if not conditionals or not conditionals.BuildOverlay then
        return {{}};
    end

    local ok, overlay = pcall(function()
        return conditionals.BuildOverlay(conditionalEquips[setName], reconciliationEquipContext(force));
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
    return expectedSet;
end

local function isStableEquipIntent(setName)
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

local function equipNamedSet(setName, force)
    local set = sets[setName];
    if not set then
        return false;
    end

    releaseSecondarySlotLocksNotInSet(setName);
    local setToEquip = setWithSubjobLegalOffhand(setName, set);
    local effectiveForce = stableEquipForceForSet(setName, setToEquip, force);

    if state.WarpRingLocked == true then
        local lockedSet = applyWarpRingLock(setToEquip);
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(lockedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(lockedSet);
        end
        applyConditionalEquipsForSet(setName, effectiveForce);
        applySecondarySlotLocksForSet(setName);
        local equippedSet = resolvedReconciliationExpectedSet(setName, lockedSet, lockedSet, effectiveForce);
        scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
        markStableEquipForceNeeded(setName, effectiveForce);
        return true;
    end

    local appliedSet = setToEquip;
    if isClearSet(setToEquip) then
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(setToEquip);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(setToEquip);
        end
    elseif effectiveForce == true and scale and scale.ForceEquipSet then
        appliedSet = scale.ForceEquipSet(setName, setToEquip, setIntents[setName]);
    elseif effectiveForce == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(setToEquip);
    elseif scale and scale.EquipSet then
        appliedSet = scale.EquipSet(setName, setToEquip, setIntents[setName]);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(setToEquip);
    end
    applyConditionalEquipsForSet(setName, effectiveForce);
    applySecondarySlotLocksForSet(setName);
    local equippedSet = resolvedReconciliationExpectedSet(setName, setToEquip, appliedSet, effectiveForce);
    scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
    markStableEquipForceNeeded(setName, effectiveForce);
    return true;
end

local function equipNamedSetIfNotClear(setName, force)
    local set = sets[setName];
    if not set or isClearSet(set) then
        return false;
    end
    return equipNamedSet(setName, force);
end

local function equipOvertDefensiveSet(setName)
    if not setName then
        return false;
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
        scale.SetWeaponLockEnabled(false);
    end
    local ok, equipped = pcall(equipNamedSet, setName, true);
    if scale and scale.SetWeaponLockEnabled then
        scale.SetWeaponLockEnabled(previousWeaponLockEnabled);
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
        gFunc.ForceEquipSet(setToEquip);
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(setToEquip);
        return true;
    end
    return false;
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
    for _, setName in ipairs(setNames or {{}}) do
        if setName and equipNamedSetIfNotClear(setName, force) then
            return true;
        end
    end
    return false;
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

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor({lua_quote(default_playstyle)}), force) then
            return true;
        end
        return equipNamedSet('TP', force);
    end

    local activeSet = setNameFor(activeCombatStyle());
    if equipNamedSet(activeSet, force) then
        return true;
    end
    if equipNamedSet('TP', force) then
        return true;
    end
    return equipNamedSet({lua_quote(default_set_name)}, force);
end

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
    if isClearSet(sets['Aftercast']) then
        return setNames;
    end

    addSecondarySlotLockSetNameIfNotClear(setNames, 'Aftercast');
    if #setNames == 0 then
        if isClearSet(sets['Idle']) then
            return setNames;
        end
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Idle');
    end
    addMovementSecondarySlotLockSetNames(setNames, player, environment);
    return setNames;
end

local function equipBaseIdleState(player, force)
    if isClearSet(sets['Aftercast']) then
        equipNamedSet('Aftercast', force);
        return true;
    end

    local equipped = equipNamedSetIfNotClear('Aftercast', force);
    if not equipped then
        if isClearSet(sets['Idle']) then
            equipNamedSet('Idle', force);
            return true;
        end
        equipped = equipNamedSetIfNotClear('Idle', force);
    end

    equipMovement(player, getEnvironment(), force);
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
    if hasDangerousStatus() then
        equipNamedSet('PDT', force);
    elseif player and isEngaged(player) then
        local defensiveSet = shouldEquipOvertDefense(player);
        if defensiveSet then
            local equippedDefensive = equipOvertDefensiveSet(defensiveSet);
            if equippedDefensive then
                return;
            end
        end
        if isEmergencyHp(player) then
            equipNamedSet('PDT', force);
        else
            equipCombatStyle(force);
        end
    elseif state.Playstyle == 'Craft' then
        if not equipNamedSet('Crafting', force) then
            equipNamedSet('Idle', force);
        end
    elseif player and isResting(player) then
        equipNamedSet('Resting', force);
    else
        equipIdleState(player, force);
    end
end

local oddLuaNumberRow = {{
    renderEvent = {number_row_render_event},
    imgui = nil,
    overlayRegistered = false,
    utilityFallbacks = {{
        craft = {{ 'Craft', 'Fishing', 'Gathering', 'Clamming', 'Movement', 'Resting', 'Treasure', 'Survival' }},
        movement = {{ 'Movement', 'Movement_City', 'Movement_Night', 'Movement_DuskToDawn', 'InCity', 'Survival' }},
    }},
}};

if type(require) == 'function' then
    local ok, loaded = pcall(require, 'imgui');
    if ok and loaded then
        oddLuaNumberRow.imgui = loaded;
    end
end

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

function oddLuaNumberRow.setPaletteEnabled(value)
    local enabled = oddLuaNumberRow.setBooleanValue(state.NumberRowPaletteEnabled, value);
    state.NumberRowPaletteEnabled = enabled;
    if enabled then
        oddLuaNumberRow.bindPalette();
        message('OddLua number row palette: on');
    else
        oddLuaNumberRow.unbindPalette();
        message('OddLua number row palette: off');
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

function oddLuaNumberRow.toggleIsOn(binding)
    if not binding or binding.toggle == nil or binding.toggle == '' then
        return false;
    end
    return state[binding.toggle] == true;
end

function oddLuaNumberRow.renderOverlay()
    if state.NumberRowPaletteEnabled ~= true or oddLuaNumberRow.imgui == nil then
        return;
    end
    local imgui = oddLuaNumberRow.imgui;
    local flags = 0;
    if bit and bit.bor then
        flags = bit.bor(
            ImGuiWindowFlags_NoDecoration or 0,
            ImGuiWindowFlags_AlwaysAutoResize or 0,
            ImGuiWindowFlags_NoMove or 0,
            ImGuiWindowFlags_NoSavedSettings or 0,
            ImGuiWindowFlags_NoFocusOnAppearing or 0,
            ImGuiWindowFlags_NoNav or 0
        );
    end
    local onColor = {{ 0.78, 1.0, 0.72, 1.0 }};
    local offColor = {{ 0.35, 0.40, 0.36, 1.0 }};
    local neutralColor = {{ 0.90, 0.94, 0.90, 1.0 }};
    local title = {number_row_overlay_title};
    if imgui.SetNextWindowPos then
        imgui.SetNextWindowPos({{ 16, 8 }}, ImGuiCond_Always or 0);
    end
    if imgui.SetNextWindowBgAlpha then
        imgui.SetNextWindowBgAlpha(0.42);
    end
    if imgui.Begin and imgui.Begin(title .. '##numberrow', true, flags) then
        imgui.TextColored(neutralColor, title);
        for index, binding in ipairs(numberRowBindings) do
            if index > 1 and imgui.SameLine then
                imgui.SameLine();
            end
            if binding.kind == 'toggle' and binding.toggle ~= '' then
                if oddLuaNumberRow.toggleIsOn(binding) then
                    imgui.TextColored(onColor, binding.key .. ' ' .. binding.label);
                else
                    imgui.TextColored(offColor, binding.key .. ' ' .. binding.label);
                end
            else
                imgui.TextColored(neutralColor, binding.key .. ' ' .. binding.label);
            end
        end
    end
    if imgui.End then
        imgui.End();
    end
end

function oddLuaNumberRow.registerOverlay()
    if oddLuaNumberRow.overlayRegistered == true or oddLuaNumberRow.imgui == nil or not ashita or not ashita.events then
        return;
    end
    ashita.events.register('d3d_present', oddLuaNumberRow.renderEvent, oddLuaNumberRow.renderOverlay);
    oddLuaNumberRow.overlayRegistered = true;
end

function oddLuaNumberRow.unregisterOverlay()
    if oddLuaNumberRow.overlayRegistered ~= true or not ashita or not ashita.events then
        return;
    end
    ashita.events.unregister('d3d_present', oddLuaNumberRow.renderEvent);
    oddLuaNumberRow.overlayRegistered = false;
end

local function equipBlueMagic(name)
    local route = blueMagicRoutes[normalize(name)];
    if route and equipNamedSet(route, false) then
        return;
    end
    equipFirstAvailable({{ 'BlueMagic', 'PhysicalBlueMagic', 'MagicalBlueMagic', 'Midcast' }}, false);
end

local function equipElementalMagic(action)
    action = action or {{}};
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
end

local function equipEnhancingMagic(name)
    local value = normalize(name);
    if string.find(value, 'stoneskin', 1, true) then
        equipFirstAvailable({{ 'Stoneskin', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'refresh', 1, true) then
        equipFirstAvailable({{ 'Refresh', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'regen', 1, true) then
        equipFirstAvailable({{ 'Regen', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'sneak', 1, true) or string.find(value, 'invisible', 1, true) or string.find(value, 'deodorize', 1, true) then
        equipFirstAvailable({{ 'SneakInvisible', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'bar', 1, true) == 1 then
        equipFirstAvailable({{ 'Barspell', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'phalanx', 1, true) then
        equipFirstAvailable({{ 'Phalanx', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'aquaveil', 1, true) then
        equipFirstAvailable({{ 'Aquaveil', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'haste', 1, true) then
        equipFirstAvailable({{ 'Haste', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
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
    elseif string.find(value, 'blind', 1, true) then
        equipFirstAvailable({{ 'Blind', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'dispel', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({{ 'Dispel', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'dia', 1, true) then
        equipFirstAvailable({{ 'Dia', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'bio', 1, true) then
        equipFirstAvailable({{ 'Bio', 'DarkMagic', 'Enfeebling', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'Enfeebling', 'Midcast' }}, false);
    end
end

local function equipDarkMagic(name)
    local value = normalize(name);
    if string.find(value, 'drain', 1, true) or string.find(value, 'aspir', 1, true) then
        equipFirstAvailable({{ 'DrainAspir', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'absorb', 1, true) then
        equipFirstAvailable({{ 'Absorb', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'stun', 1, true) then
        equipFirstAvailable({{ 'Stun', 'DarkMagic', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'DarkMagic', 'Midcast' }}, false);
    end
end

local function equipSong(name)
    local value = normalize(name);
    if string.find(value, 'elegy', 1, true) or string.find(value, 'requiem', 1, true)
        or string.find(value, 'threnody', 1, true) or string.find(value, 'lullaby', 1, true)
        or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({{ 'SongDebuff', 'Song', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'SongBuff', 'Song', 'Midcast' }}, false);
    end
end

local function equipNinjutsu(name)
    local value = normalize(name);
    if string.find(value, 'utsusemi', 1, true) then
        equipFirstAvailable({{ 'Utsusemi', 'Precast', 'FastCast' }}, false);
    elseif string.find(value, 'kurayami', 1, true) or string.find(value, 'hojo', 1, true)
        or string.find(value, 'jubaku', 1, true) or string.find(value, 'dokumori', 1, true) then
        equipFirstAvailable({{ 'NinjutsuEnfeeble', 'Ninjutsu', 'Midcast' }}, false);
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

local function equipAbility()
    local action = getAction();
    local name = normalize(action and action.Name);
    local actionType = normalize(action and action.Type);
    if actionType == 'quick draw' then
        equipFirstAvailable({{ 'QuickDraw', 'MagicAccuracy', 'Midcast' }}, false);
    elseif actionType == 'corsair roll' then
        equipFirstAvailable({{ 'Roll', 'JobAbility' }}, false);
    elseif actionType == 'blood pact: rage' then
        equipFirstAvailable({{ 'BloodPactRage', 'PetReady', 'JobAbility' }}, false);
    elseif actionType == 'blood pact: ward' then
        equipFirstAvailable({{ 'BloodPactWard', 'PetTank', 'JobAbility' }}, false);
    elseif string.find(name, 'third eye', 1, true) then
        equipFirstAvailable({{ 'ThirdEye', 'JobAbility' }}, false);
    elseif string.find(name, 'meditate', 1, true) then
        equipFirstAvailable({{ 'Meditate', 'JobAbility' }}, false);
    elseif string.find(name, 'provoke', 1, true) or string.find(name, 'sentinel', 1, true)
        or string.find(name, 'warcry', 1, true) or string.find(name, 'cover', 1, true)
        or string.find(name, 'palisade', 1, true) or string.find(name, 'flash', 1, true) then
        equipFirstAvailable({{ 'Enmity', 'JobAbility' }}, false);
    elseif string.find(name, 'waltz', 1, true) then
        equipFirstAvailable({{ 'Waltz', 'Cure', 'JobAbility' }}, false);
    elseif string.find(name, 'step', 1, true) then
        equipFirstAvailable({{ 'Steps', 'Accuracy', 'JobAbility' }}, false);
    elseif string.find(name, 'samba', 1, true) then
        equipFirstAvailable({{ 'Samba', 'TP', 'JobAbility' }}, false);
    elseif string.find(name, 'jump', 1, true) then
        equipFirstAvailable({{ 'Jump', 'Weaponskill', 'JobAbility' }}, false);
    elseif string.find(name, 'ready', 1, true) or string.find(name, 'sic', 1, true) then
        equipFirstAvailable({{ 'PetReady', 'PetDamage', 'JobAbility' }}, false);
    else
        equipNamedSet('JobAbility', false);
    end
end

local function equipWeaponskill()
    local action = getAction();
    local name = action and action.Name;
    local key = weaponSkillRouteKey(name);
    local exactRoute = weaponSkillRoutes[key];
    local accuracyRoute = weaponSkillAccuracyRoutes[key];
    if state.Playstyle == 'Accuracy' then
        if accuracyRoute and equipNamedSet(accuracyRoute, false) then
            return;
        end
    end
    if exactRoute and equipNamedSet(exactRoute, false) then
        return;
    end
    local normalizedName = normalize(name);
    if state.Playstyle == 'Accuracy' then
        equipFirstAvailable({{ 'WeaponSkillAccuracy', 'Weaponskill' }}, false);
    elseif string.find(normalizedName, 'aeolian', 1, true) or string.find(normalizedName, 'cyclone', 1, true)
        or string.find(normalizedName, 'energy', 1, true) or string.find(normalizedName, 'red lotus', 1, true)
        or string.find(normalizedName, 'seraph', 1, true) or string.find(normalizedName, 'sanguine', 1, true)
        or string.find(normalizedName, 'wildfire', 1, true) or string.find(normalizedName, 'leaden', 1, true)
        or string.find(normalizedName, 'jinpu', 1, true) or string.find(normalizedName, 'koki', 1, true)
        or string.find(normalizedName, 'goten', 1, true) or string.find(normalizedName, 'kagero', 1, true) then
        equipFirstAvailable({{ 'WSElemental', 'Elemental', 'Weaponskill' }}, false);
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

    message('OddLua dynamic profile loaded for {player}_{player_id}. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd help for commands and one-button setup.');
    message({lua_quote(subjob_load_message)});
    oddLuaNumberRow.bindPalette();
    oddLuaNumberRow.registerOverlay();
{aahtacos_sam_onload}
end

profile.OnUnload = function()
    oddLuaNumberRow.unregisterOverlay();
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
    elseif command == 'warp' then
        useWarpRing();
    elseif command == 'warpclear' then
        clearWarpRing();
    elseif command == 'utility' then
        oddLuaNumberRow.equipUtilityIntent(value);
    elseif command == 'palette' or command == 'numberrow' then
        if value == 'missing' then
            message('Not Applicable / Missing Equipment');
            return;
        end
        oddLuaNumberRow.setPaletteEnabled(value);
    elseif command == 'mechanics' then
        handleMechanicsCommand(args);
    elseif command == 'reconcile' then
        handleReconcileCommand(args);
    elseif command == 'refreshgear' or command == 'reprocessgear' or command == 'rebuildgear' then
        startOddLuaGearRefresh(args);
    elseif command == 'status' then
        local subjob, subjobName = currentSubjobProfile();
        local capabilityText = 'none';
        if subjob and subjob.capabilities then
            capabilityText = table.concat(subjob.capabilities, ',');
        end
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle() .. '; Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. capabilityText .. '; help=/lac fwd help; styles=/lac fwd styles');
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
    equipNamedSet('FastCast', false);
    equipNamedSet('Precast', false);
end

profile.HandleMidcast = function()
    local action = getAction();
    if not action then
        return;
    end

    local name = normalize(action.Name);
    local skill = normalize(action.Skill);
    if skill == 'healing magic' then
        if string.find(name, 'cure', 1, true) or string.find(name, 'curaga', 1, true) then
            equipNamedSet('Cure', false);
        else
            equipNamedSet('Healing', false);
        end
    elseif skill == 'enhancing magic' then
        equipEnhancingMagic(name);
    elseif skill == 'enfeebling magic' then
        equipEnfeeblingMagic(name);
    elseif skill == 'divine magic' then
        equipNamedSet('Divine', false);
    elseif skill == 'elemental magic' then
        equipElementalMagic(action);
    elseif skill == 'dark magic' then
        equipDarkMagic(name);
    elseif skill == 'blue magic' then
        equipBlueMagic(name);
    elseif skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        equipSong(name);
    elseif skill == 'geomancy' then
        equipNamedSet('Geomancy', false);
    elseif skill == 'summoning magic' or skill == 'summoning' then
        equipSummoning(name);
    elseif skill == 'ninjutsu' then
        equipNinjutsu(name);
    end
end

profile.HandlePreshot = function()
    if not equipNamedSet('Snapshot', false) then
        equipNamedSet('RangedPreshot', false);
    end
end

profile.HandleMidshot = function()
    equipFirstAvailable({{ 'RangedMidshot', 'RangedAccuracy', 'Ranged' }}, false);
end

profile.HandleWeaponskill = function()
    equipWeaponskill();
end

return profile;
"""
