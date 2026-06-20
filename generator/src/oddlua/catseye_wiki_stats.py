from __future__ import annotations

from dataclasses import dataclass
import re


HIDDEN_EFFECT_PREFIX_RE = re.compile(r"\bHidden Effect:\s*", re.IGNORECASE)
HIDDEN_CRAFTING_SKILL_RE = re.compile(
    r"\b(?:Alchemy|Cooking|Fishing)\s+Skill\s*[+-]\s*\d+(?!\s*~)",
    re.IGNORECASE,
)
WIKI_INCREASES_JIG_DURATION_RE = re.compile(r'\bIncreases\s+"?Jig"?\s+duration\b', re.IGNORECASE)
WIKI_INCREASES_SAMBA_DURATION_RE = re.compile(r'\bIncreases\s+"?Samba"?\s+duration\b', re.IGNORECASE)
CATSEYE_UNQUANTIFIED_JIG_DURATION_VALUE = 25
CATSEYE_UNQUANTIFIED_SAMBA_DURATION_VALUE = 30

STAT_MOD_IDS = {
    "DEF": 1,
    "HP": 2,
    "HPP": 3,
    "MP": 5,
    "MPP": 6,
    "STR": 8,
    "DEX": 9,
    "VIT": 10,
    "AGI": 11,
    "INT": 12,
    "MND": 13,
    "CHR": 14,
    "FIRE_MEVA": 15,
    "ICE_MEVA": 16,
    "WIND_MEVA": 17,
    "EARTH_MEVA": 18,
    "THUNDER_MEVA": 19,
    "WATER_MEVA": 20,
    "LIGHT_MEVA": 21,
    "DARK_MEVA": 22,
    "ATT": 23,
    "RATT": 24,
    "ACC": 25,
    "RACC": 26,
    "ENMITY": 27,
    "MATT": 28,
    "MDEF": 29,
    "MACC": 30,
    "MEVA": 31,
    "WSACC": 48,
    "EVA": 68,
    "MPHEAL": 71,
    "HPHEAL": 72,
    "STORETP": 73,
    "HTH": 80,
    "DAGGER": 81,
    "SWORD": 82,
    "GSWORD": 83,
    "AXE": 84,
    "GAXE": 85,
    "SCYTHE": 86,
    "POLEARM": 87,
    "KATANA": 88,
    "GKATANA": 89,
    "CLUB": 90,
    "STAFF": 91,
    "ARCHERY": 104,
    "MARKSMAN": 105,
    "THROW": 106,
    "GUARD": 107,
    "EVASION": 108,
    "SHIELD": 109,
    "PARRY": 110,
    "DIVINE": 111,
    "HEALING": 112,
    "ENHANCE": 113,
    "ENFEEBLE": 114,
    "ELEM": 115,
    "DARK": 116,
    "SUMMONING": 117,
    "NINJUTSU": 118,
    "SINGING": 119,
    "STRING": 120,
    "WIND": 121,
    "BLUE": 122,
    "GEOMANCY_SKILL": 123,
    "HANDBELL_SKILL": 124,
    "BP_DAMAGE": 126,
    "FISH": 127,
    "COOK": 135,
    "BARRAGE_COUNT": 138,
    "WALTZ_COST": 139,
    "DMG": 160,
    "DMGPHYS": 161,
    "DMGMAGIC": 163,
    "DMGPHYS_II": 190,
    "DEATHRES": 255,
    "CRITHITRATE": 165,
    "SPELLINTERRUPT": 168,
    "FASTCAST": 170,
    "MARTIAL_ARTS": 173,
    "SKILLCHAINBONUS": 174,
    "SKILLCHAINDMG": 175,
    "SLEEPRES": 240,
    "BLINDRES": 243,
    "SILENCERES": 244,
    "PETRIFYRES": 246,
    "BINDRES": 247,
    "CHARMRES": 252,
    "AMNESIARES": 253,
    "CURE_POTENCY_II": 260,
    "DUAL_WIELD": 259,
    "TANDEM_STRIKE_POWER": 271,
    "TANDEM_BLOW_POWER": 272,
    "DOUBLE_ATTACK": 288,
    "SUBTLE_BLOW": 289,
    "COUNTER": 291,
    "KICK_ATTACK_RATE": 292,
    "STEAL": 298,
    "TRIPLE_ATTACK": 302,
    "TREASURE_HUNTER": 303,
    "RECYCLE": 305,
    "ZANSHIN": 306,
    "UTSUSEMI_BONUS": 900,
    "NINJA_TOOL": 308,
    "MAGIC_DAMAGE": 311,
    "REGEN_DURATION": 339,
    "LIGHT_ARTS_EFFECT": 334,
    "DARK_ARTS_EFFECT": 335,
    "TP_BONUS": 345,
    "PERPETUATION_REDUCTION": 346,
    "FIRE_STAFF_BONUS": 347,
    "ICE_STAFF_BONUS": 348,
    "WIND_STAFF_BONUS": 349,
    "EARTH_STAFF_BONUS": 350,
    "THUNDER_STAFF_BONUS": 351,
    "WATER_STAFF_BONUS": 352,
    "LIGHT_STAFF_BONUS": 353,
    "DARK_STAFF_BONUS": 354,
    "BP_DELAY": 357,
    "RAPID_SHOT": 359,
    "SNAPSHOT": 365,
    "AVATAR_PERPETUATION": 371,
    "BLOOD_BOON": 913,
    "REFRESH": 369,
    "REGEN": 370,
    "CURE_POTENCY": 374,
    "CURE_POTENCY_RCVD": 375,
    "RANGED_DELAYP": 381,
    "HASTE_GEAR": 384,
    "RETALIATION": 414,
    "CONSERVE_MP": 296,
    "CRIT_DMG_INCREASE": 421,
    "ENMITY_LOSS_REDUCTION": 427,
    "MINUET_EFFECT": 434,
    "PAEON_EFFECT": 435,
    "REQUIEM_EFFECT": 436,
    "MADRIGAL_EFFECT": 438,
    "LULLABY_EFFECT": 440,
    "ETUDE_EFFECT": 441,
    "BALLAD_EFFECT": 442,
    "MARCH_EFFECT": 443,
    "CAROL_EFFECT": 445,
    "ELEGY_EFFECT": 447,
    "PRELUDE_EFFECT": 448,
    "ALL_SONGS_EFFECT": 452,
    "TACTICAL_PARRY": 486,
    "MAGIC_BURST_BONUS_CAPPED": 487,
    "IRIDESCENCE": 566,
    "ENSPELL_DMG_BONUS": 432,
    "SONG_DURATION_BONUS": 454,
    "SONG_SPELLCASTING_TIME": 455,
    "GRIMOIRE_SPELLCASTING": 489,
    "WALTZ_POTENCY": 491,
    "SAMBA_DURATION": 490,
    "JIG_DURATION": 492,
    "WALTZ_DELAY": 497,
    "CURE_CAST_TIME": 519,
    "ROLL_RANGE": 528,
    "STONESKIN_BONUS_HP": 539,
    "BP_DELAY_II": 541,
    "MAGIC_CRITHITRATE": 562,
    "MAGIC_CRIT_DMG_INCREASE": 563,
    "SONG_RECAST_DELAY": 833,
    "MYTHIC_OCC_ATT_TWICE": 865,
    "SYNTH_MATERIAL_LOSS": 861,
    "SYNTH_SUCCESS_RATE": 851,
    "DMGMAGIC_II": 831,
    "REPAIR_POTENCY": 854,
    "ENH_MAGIC_DURATION": 890,
    "ELEMENTAL_CELERITY": 901,
    "DAKEN": 911,
    "OCCULT_ACUMEN": 902,
    "CONSERVE_TP": 944,
    "BERSERK_DURATION": 954,
    "AGGRESSOR_DURATION": 955,
    "INDI_DURATION": 960,
    "GEOMANCY_BONUS": 961,
    "INQUARTATA": 963,
    "SUBTLE_BLOW_II": 973,
    "MAX_SWINGS": 978,
    "MAX_FINISHING_MOVE_BONUS": 988,
    "ONE_HOUR_RECAST": 996,
    "SWORDPLAY": 1008,
    "PFLUG": 1011,
    "VIVACIOUS_PULSE_POTENCY": 1012,
    "LIFE_CYCLE_EFFECT": 1029,
    "DOUBLE_ATTACK_DMG": 1038,
    "SIC_READY_RECAST": 1052,
    "DEAD_AIM_EFFECT": 1054,
    "BREATH_DMG_DEALT": 1075,
    "ELEMENTAL_DEBUFF_EFFECT": 1150,
    "PHALANX_RECEIVED": 1182,
}

ELEMENTAL_STAFF_BONUS_MODS = (
    "FIRE_STAFF_BONUS",
    "ICE_STAFF_BONUS",
    "WIND_STAFF_BONUS",
    "EARTH_STAFF_BONUS",
    "THUNDER_STAFF_BONUS",
    "WATER_STAFF_BONUS",
    "LIGHT_STAFF_BONUS",
    "DARK_STAFF_BONUS",
)

ELEMENTAL_RESISTANCE_MODS = (
    "FIRE_MEVA",
    "ICE_MEVA",
    "WIND_MEVA",
    "EARTH_MEVA",
    "THUNDER_MEVA",
    "WATER_MEVA",
    "LIGHT_MEVA",
    "DARK_MEVA",
)
ELEMENTAL_RESIST_LABELS = (
    ("FIRE_MEVA", "Fire"),
    ("ICE_MEVA", "Ice"),
    ("WIND_MEVA", "Wind"),
    ("EARTH_MEVA", "Earth"),
    ("THUNDER_MEVA", "Thunder"),
    ("WATER_MEVA", "Water"),
    ("LIGHT_MEVA", "Light"),
    ("DARK_MEVA", "Dark"),
)
ELEMENTAL_RESIST_PATTERNS = tuple(
    (
        mod_name,
        rf"\b{label} Resist\s*([+-]\s*\d+)(?!\s*~)",
        1,
    )
    for mod_name, label in ELEMENTAL_RESIST_LABELS
)
DAMAGE_TAKEN_MODS = frozenset(
    {
        "DMG",
        "DMGPHYS",
        "DMGMAGIC",
        "DMGPHYS_II",
        "DMGMAGIC_II",
    }
)
NEGATIVE_DUPLICATE_DIRECT_MODS = frozenset({"HP", "MP", "STR", "DEX", "VIT", "AGI", "INT", "MND", "CHR"})

KILLER_STAT_LABELS = (
    ("VERMIN_KILLER", "Vermin"),
    ("BIRD_KILLER", "Bird"),
    ("AMORPH_KILLER", "Amorph"),
    ("LIZARD_KILLER", "Lizard"),
    ("AQUAN_KILLER", "Aquan"),
    ("PLANTOID_KILLER", "Plantoid"),
    ("BEAST_KILLER", "Beast"),
    ("UNDEAD_KILLER", "Undead"),
    ("ARCANA_KILLER", "Arcana"),
    ("DRAGON_KILLER", "Dragon"),
    ("DEMON_KILLER", "Demon"),
    ("EMPTY_KILLER", "Empty"),
    ("HUMANOID_KILLER", "Humanoid"),
    ("LUMINIAN_KILLER", "Luminian"),
    ("LUMINION_KILLER", "Luminion"),
)
KILLER_STAT_PATTERNS = tuple(
    (
        mod_name,
        rf'\b"?{label}\s+Killer"?\s*([+-]\s*\d+)(?!\s*~)',
        1,
    )
    for mod_name, label in KILLER_STAT_LABELS
)

DIRECT_STAT_MODS = frozenset(STAT_MOD_IDS)
WIKI_WEAPON_RE = re.compile(r"\bDMG:?\s*(?P<damage>\d+)\s+Delay:?\s*(?P<delay>\d+)", re.IGNORECASE)
WIKI_SIGNED_RE = re.compile(r"(?P<label>Enmity)\s*(?P<value>[+-]\s*\d+)(?!\s*~)", re.IGNORECASE)
WIKI_ALL_ELEMENTS_AFFINITY_RE = re.compile(r"\ball\s+elements?\s+affinity\s*\+?\s*(\d+)", re.IGNORECASE)
WIKI_ALL_ELEMENTAL_RESISTANCES_RE = re.compile(
    r"\b(?:all\s+elemental\s+resist(?:ance)?s?|resist\s+all\s+elements)\s*\+?\s*(\d+)",
    re.IGNORECASE,
)
WIKI_ALL_STATS_RE = re.compile(r"\ball\s+stats\s*([+-]\s*\d+)(?!\s*~)", re.IGNORECASE)
WIKI_ALL_ELEMENTS_MAGIC_POTENCY_RE = re.compile(
    r"\ball\s+elements:\s+magic\s+potency\s*\+?\s*(\d+)\s*%",
    re.IGNORECASE,
)
WIKI_IRIDESCENCE_RE = re.compile(r"\biridescence\b\"?(?:\s*\((\d+)\s*%\))?", re.IGNORECASE)
WIKI_DOUBLE_ATTACK_DAMAGE_RE = re.compile(
    r"\b(?:increases\s+)?\"?double\s+attack\"?\s+damage(?:\s*\+?\s*(\d+)\s*%?)?",
    re.IGNORECASE,
)
WIKI_OCC_ATTACKS_RANGE_RE = re.compile(
    r"\boccasionally\s+attacks\s+(?P<minimum>\d+)\s*-\s*(?P<maximum>\d+)\b",
    re.IGNORECASE,
)
WIKI_OCC_ATTACKS_TWICE_RE = re.compile(r"\boccasionally\s+attacks\s+twice\b", re.IGNORECASE)
WIKI_CONDITIONAL_PREFIX_RE = re.compile(
    r"(?i)\b(?P<label>"
    r"set\s+bonus|"
    r"set|"
    r"right\s+ear|left\s+ear|"
    r"(?:fire|ice|wind|earth|thunder|water|light|dark)\s+weather|"
    r"on\s+(?:fires|ices|winds|earths|lightnings|waters|lights|darks)days?|"
    r"paralysis|poison|blindness|blind|silence|sleep|stun|petrification|bind|slow|"
    r"curse|disease|plague|terror|amnesia|charm|weakness|doom|"
    r"ice\s+spikes|blaze\s+spikes|shock\s+spikes|dread\s+spikes|"
    r"arcane\s+circle|holy\s+circle|ancient\s+circle|warding\s+circle|"
    r"haste|protect|shell|sneak|invisible|aquaveil|stoneskin|phalanx|refresh|regen"
    r")\s*:\s*"
)
WIKI_LATENT_EFFECT_RE = re.compile(
    r"(?i)\blatent\s+effect\s*(?:\((?P<inline_condition>[^)]*)\))?\s*:\s*(?P<body>.*?)(?=\s*\(?\s*latent\b|$)"
)
WIKI_LATENT_ACTIVATION_RE = re.compile(r"(?i)\(\s*latent(?:\s+activation)?\s*:\s*(?P<condition>[^)]*)\)")
WIKI_TRAILING_LATENT_CONDITION_RE = re.compile(r"(?i)\s*\((?P<condition>[^)]*\bactive[^)]*)\)\s*$")
LATENT_UNKNOWN_CONDITION = ("latent_unknown", "unspecified")
LATENT_STATUS_CONDITIONS = {
    "arcane circle": "arcane_circle",
    "blaze spikes": "blaze_spikes",
    "dread spikes": "dread_spikes",
    "ice spikes": "ice_spikes",
    "poison": "poison",
    "poisoned": "poison",
    "shock spikes": "shock_spikes",
}


@dataclass(frozen=True)
class WikiConditionalStatMod:
    mod_name: str
    value: int
    condition_type: str
    condition_name: str
    source_text: str


def parse_wiki_weapon_stats(stats_text: str) -> dict[str, int]:
    match = WIKI_WEAPON_RE.search(_comparable_stats_text(stats_text))
    if match is None:
        return {}
    return {
        "damage": int(match.group("damage")),
        "delay": int(match.group("delay")),
    }


def parse_wiki_stat_mods(stats_text: str) -> dict[str, int]:
    text = _comparable_stats_text(stats_text)
    return _parse_stat_mods_from_text(text)


def comparable_wiki_stats_text(stats_text: str) -> str:
    return _comparable_stats_text(stats_text)


def parse_wiki_conditional_stat_mods(stats_text: str) -> tuple[WikiConditionalStatMod, ...]:
    mods: list[WikiConditionalStatMod] = []
    for line in _raw_stat_lines(stats_text):
        clauses = _conditional_clauses(line)
        for label, body in clauses:
            condition = _condition_from_label(label)
            if condition is None:
                continue
            for mod_name, value in sorted(_parse_conditional_stat_mods_from_body(body).items()):
                mods.append(
                    WikiConditionalStatMod(
                        mod_name=mod_name,
                        value=value,
                        condition_type=condition[0],
                        condition_name=condition[1],
                        source_text=f"{label}: {body}".strip(),
                    )
                )
        for condition, body in _latent_conditional_clauses(line):
            for mod_name, value in sorted(_parse_conditional_stat_mods_from_body(body).items()):
                mods.append(
                    WikiConditionalStatMod(
                        mod_name=mod_name,
                        value=value,
                        condition_type=condition[0],
                        condition_name=condition[1],
                        source_text=f"Latent: {body}".strip(),
                    )
                )
    return tuple(mods)


def _parse_stat_mods_from_text(text: str) -> dict[str, int]:
    mods: dict[str, int] = {}
    seen_damage_taken_values: set[tuple[str, int, str]] = set()
    seen_negative_direct_values: set[tuple[str, int, str]] = set()

    for mod_name, pattern, scale in _numeric_patterns():
        for match in re.finditer(pattern, text, re.IGNORECASE):
            if _has_numeric_suffix_continuation(text, match.end()):
                continue
            value = int(match.group(1).replace(" ", "")) * scale
            if mod_name in DAMAGE_TAKEN_MODS:
                damage_key = (mod_name, value, _normalized_duplicate_stat_text(match.group(0)))
                if damage_key in seen_damage_taken_values:
                    continue
                seen_damage_taken_values.add(damage_key)
            if value < 0 and mod_name in NEGATIVE_DUPLICATE_DIRECT_MODS:
                negative_key = (mod_name, value, _normalized_duplicate_stat_text(match.group(0)))
                if negative_key in seen_negative_direct_values:
                    continue
                seen_negative_direct_values.add(negative_key)
            _add_mod(mods, mod_name, value)

    for match in WIKI_SIGNED_RE.finditer(text):
        _add_mod(mods, "ENMITY", int(match.group("value")))

    for match in WIKI_ALL_STATS_RE.finditer(text):
        value = int(match.group(1).replace(" ", ""))
        for mod_name in ("STR", "DEX", "VIT", "AGI", "INT", "MND", "CHR"):
            _add_mod(mods, mod_name, value)

    affinity_match = WIKI_ALL_ELEMENTS_AFFINITY_RE.search(text)
    if affinity_match is not None:
        value = int(affinity_match.group(1))
        for mod_name in ELEMENTAL_STAFF_BONUS_MODS:
            mods[mod_name] = value

    elemental_resistances_match = WIKI_ALL_ELEMENTAL_RESISTANCES_RE.search(text)
    if elemental_resistances_match is not None:
        value = int(elemental_resistances_match.group(1))
        for mod_name in ELEMENTAL_RESISTANCE_MODS:
            _add_mod(mods, mod_name, value)

    all_elements_potency_match = WIKI_ALL_ELEMENTS_MAGIC_POTENCY_RE.search(text)
    if all_elements_potency_match is not None:
        value = int(all_elements_potency_match.group(1)) // 5
        for mod_name in ELEMENTAL_STAFF_BONUS_MODS:
            mods[mod_name] = value

    iridescence_match = WIKI_IRIDESCENCE_RE.search(text)
    if iridescence_match is not None:
        mods["IRIDESCENCE"] = int(iridescence_match.group(1)) // 5 if iridescence_match.group(1) else 2

    double_attack_damage_match = WIKI_DOUBLE_ATTACK_DAMAGE_RE.search(text)
    if double_attack_damage_match is not None:
        mods["DOUBLE_ATTACK_DMG"] = (
            int(double_attack_damage_match.group(1))
            if double_attack_damage_match.group(1)
            else 3
        )

    for match in WIKI_OCC_ATTACKS_RANGE_RE.finditer(text):
        minimum = int(match.group("minimum"))
        maximum = int(match.group("maximum"))
        if minimum >= 2 and maximum >= minimum:
            _add_mod(mods, "MAX_SWINGS", maximum)

    if WIKI_OCC_ATTACKS_TWICE_RE.search(text):
        mods["MYTHIC_OCC_ATT_TWICE"] = 1

    if "JIG_DURATION" not in mods and WIKI_INCREASES_JIG_DURATION_RE.search(text):
        mods["JIG_DURATION"] = CATSEYE_UNQUANTIFIED_JIG_DURATION_VALUE
    if "SAMBA_DURATION" not in mods and WIKI_INCREASES_SAMBA_DURATION_RE.search(text):
        mods["SAMBA_DURATION"] = CATSEYE_UNQUANTIFIED_SAMBA_DURATION_VALUE

    return mods


def _numeric_patterns() -> tuple[tuple[str, str, int], ...]:
    return (
        (
            "DEF",
            r"(?<!Fire )(?<!Ice )(?<!Wind )(?<!Earth )(?<!Thunder )(?<!Water )(?<!Light )(?<!Dark )"
            r"\bDEF\s*(?::|(?=[+-]))\s*([+-]?\s*\d+)(?!\s*[~%])",
            1,
        ),
        ("HPP", r"\bHP\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("MPP", r"\bMP\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("HP", r"\bHP\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("MP", r"(?<!Conserve )(?<!to )\bMP\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("STR", r"\bSTR\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("DEX", r"\bDEX\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("VIT", r"\bVIT\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("AGI", r"\bAGI\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("INT", r"\bINT\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("MND", r"\bMND\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("CHR", r"\bCHR\s*([+-]\s*\d+)(?!\s*[~%])", 1),
        ("MEVA", r"\bMagic Evasion\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MEVA", r"\bM\.?\s*Evasion\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("EVA", r"(?<!Magic )(?<!M\.)\bEvasion\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MDEF", r"\b\"?Magic Def(?:ense)?\.? Bonus\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("MDEF", r"\bM\.?\s*Def\.? Bonus\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MACC", r"\bMagic Accuracy\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MACC", r"\bMagic Acc\.\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MACC", r"\bM\.?\s*Acc\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MATT", r"\b\"?Magic Atk\.? Bonus\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MATT", r"\b\"?Magic Attack Bonus\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MATT", r"\bMAB\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RACC", r"\bRanged Accuracy\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RACC", r"\bRanged Acc\.\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RATT", r"\bRanged Attack\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RATT", r"\bRanged Atttack\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RATT", r"\bRanged Atk\.\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ACC", r"\bAcc/M\.?Acc\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ACC", r"(?<!Magic )(?<!Ranged )\bAccuracy\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ACC", r"(?<!Magic )(?<!Ranged )\bAcc\.\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ATT", r"(?<!Magic )(?<!Ranged )\bAttack\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ATT", r"\bAtack\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("CURE_POTENCY", r"\b\"?Cure\"? potency\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CURE_POTENCY_II", r"\b\"?Cure\"? potency II\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CURE_POTENCY_RCVD", r"\bCure (?:potency )?(?:received|rec[e.]?ived)\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CURE_POTENCY_RCVD", r"\bCure P\. Received\s*([+-]\s*\d+)%(?!\s*~)", 1),
        (
            "CURE_POTENCY_RCVD",
            r'\bPotency of "?Cure"? (?:effect )?received\s*([+-]\s*\d+)%(?!\s*~)',
            1,
        ),
        ("CURE_CAST_TIME", r"\b\"?Cure\"? spellcasting time\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CURE_CAST_TIME", r"\bCure cast\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("ELEMENTAL_CELERITY", r"\bElemental(?: magic)? casting time\s*(-\s*\d+)%(?!\s*~)", -1),
        ("BP_DAMAGE", r"\bBlood Pact damage\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("BREATH_DMG_DEALT", r"\bBreath damage dealt\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("FASTCAST", r"\b\"?Fast Cast\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        (
            "FASTCAST",
            r"\bEnhances\s+\"?Fast Cast\"?\s+effect\s*(?:\(\s*(?:Fast Cast\s*:)?\s*)?([+-]\s*\d+)\s*%?\s*\)?(?!\s*~)",
            1,
        ),
        ("HASTE_GEAR", r"\bHaste\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("HASTE_GEAR", r"\b\"?Slow\"?\s*\+(\s*\d+)%(?!\s*~)", -100),
        ("ONE_HOUR_RECAST", r"\bSP Ability delay\s*(-\s*\d+)(?!\s*~)", -1),
        ("BP_DELAY", r'\b"?Blood Pact"?\s+ability delay\s*(-\s*\d+)(?!\s*~)', -1),
        ("BP_DELAY_II", r'\b"?Blood Pact"?\s+recast time II\s*(-\s*\d+)(?!\s*~)', -1),
        (
            "SIC_READY_RECAST",
            r'\b"?\s*Sic\s*"?\s+and\s+"?\s*Ready\s*"?\s+ability delay\s*(-\s*\d+)(?!\s*~)',
            -1,
        ),
        ("BARRAGE_COUNT", r'\b"?Barrage"?\s*([+-]\s*\d+)(?!\s*~)', 1),
        ("DEAD_AIM_EFFECT", r'\b"?Dead Aim"?\s*([+-]\s*\d+)%?(?!\s*~)', 1),
        (
            "BERSERK_DURATION",
            r'\b"?Berserk(?:/Aggressor)?"?\s+effect duration\s*([+-]\s*\d+)(?!\s*~)',
            1,
        ),
        (
            "AGGRESSOR_DURATION",
            r'\b"?Berserk/Aggressor"?\s+effect duration\s*([+-]\s*\d+)(?!\s*~)',
            1,
        ),
        (
            "SPELLINTERRUPT",
            r"\bSpell Interrupt(?:ion)?(?: Rate)?(?: Down)?\s*([+-]\s*\d+)%?(?!\s*~)",
            1,
        ),
        ("STORETP", r"\b\"?Store TP\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SUBTLE_BLOW", r"\b\"?Subtle Blow\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SUBTLE_BLOW_II", r"\b\"?Subtle Blow II\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("COUNTER", r"\b\"?Counter\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("RETALIATION", r"(?<!\w)\"?Retaliation\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("DUAL_WIELD", r"\b\"?Dual Wield\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "DUAL_WIELD",
            r"\bEnhances\s+\"?Dual Wield\"?\s+effect\s*(?:\(\s*)?([+-]\s*\d+)\s*%?\s*\)?(?!\s*~)",
            1,
        ),
        ("MARTIAL_ARTS", r"\bMartial Arts\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("KICK_ATTACK_RATE", r"\b\"?Kick Attacks?\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("ZANSHIN", r"\b\"?Zanshin\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("TP_BONUS", r"\bTP Bonus\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("CONSERVE_TP", r"\bConserve TP\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("STEAL", r"\b\"?Steal\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("TREASURE_HUNTER", r"\bTreasure Hunter\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("FISH", r"\bFishing skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SYNTH_SUCCESS_RATE", r"\bSynthesis Success Rate\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("DEATHRES", r"\bResist\s+\"?Death\"?(?!\s*/)\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("CHARMRES", r"\bResist\s+Charm\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RECYCLE", r"\b\"?Recycle\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("INQUARTATA", r"\b(?:Parrying rate|Parry rate|Inquartata)\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("TACTICAL_PARRY", r"\bTactical Parry\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("ENMITY_LOSS_REDUCTION", r"\bReduces enmity loss\s*(-\s*\d+)%(?!\s*~)", -1),
        ("ENMITY_LOSS_REDUCTION", r"\bEnmity Loss Reduction\s*\+(\s*\d+)%?(?!\s*~)", 1),
        ("ENMITY_LOSS_REDUCTION", r"\bEnmity Loss Reduction\s*(-\s*\d+)%?(?!\s*~)", -1),
        ("ENH_DRAIN_ASPIR", r"\bDrain/Aspir\s*([+-]?\s*\d+)(?!\s*~)", 1),
        (
            "ENH_DRAIN_ASPIR",
            r'\b"?Drain"?\s+and\s+"?Aspir"?\s+potency\s*([+-]?\s*\d+)(?!\s*~)',
            1,
        ),
        (
            "ENH_DRAIN_ASPIR",
            r'\bEnhances\s+"?Drain"?\s+and\s+"?Aspir"?\s*\(\s*([+-]?\s*\d+)\s*\)',
            1,
        ),
        ("SNAPSHOT", r"\b\"?Snapshot\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("RAPID_SHOT", r"\b\"?Rapid Shot\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("RAPID_SHOT", r"\bRapidshot\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("RANGED_DELAYP", r"\bRanged delay\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("NINJA_TOOL", r"\b\"?Ninja Tool Expertise\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("BLOOD_BOON", r'\b"?\s*Blood Boon\s*"?\s*([+-]\s*\d+)(?!\s*~)', 1),
        ("DOUBLE_ATTACK", r"\b\"?Double Attack\"?\s*([+-]\s*\d+)%(?!\s*~)", 1),
        (
            "DOUBLE_ATTACK",
            r"\bEnhances\s+\"?Double Attack\"?\s+effect\s*(?:\(\s*)?([+-]\s*\d+)\s*%?\s*\)?(?!\s*~)",
            1,
        ),
        ("TRIPLE_ATTACK", r"\b\"?Triple Attack\"?\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("TRIPLE_ATTACK", r"\b\"?Triple Atk\.\"?\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("DOUBLE_ATTACK", r"\bDbl\. Atk\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("CRITHITRATE", r"(?<!Magical )\bCritical Hit Rate\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CRITHITRATE", r"(?<!Magic )\bCrit\.?\s*hit rate\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CRITHITRATE", r"\bCrit\.?\s*Rate\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CRITHITRATE", r"\bIncreases Rate of Critical Hits\s*\+?\s*(\d+)%(?!\s*~)", 1),
        ("CRIT_DMG_INCREASE", r"\bCritical Hit Damage\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("CRIT_DMG_INCREASE", r"\bCrit\.?(?:ical)? hit damage\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("MAGIC_CRITHITRATE", r"\bMagic crit\. hit rate\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        (
            "MAGIC_CRIT_DMG_INCREASE",
            r"\bMagical Critical Hit Dmg\s*([+-]\s*\d+)%?(?!\s*~)",
            1,
        ),
        ("REFRESH", r"\b\"?Refresh\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("REGEN_DURATION", r"\b\"?Regen\"?\s+Duration\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("REGEN", r"\b\"?Regen\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "LIFE_CYCLE_EFFECT",
            r'\bAdds\s+"?Regen"?\s+effect\s+Life Cycle\s*([+-]\s*\d+)(?!\s*~)',
            1,
        ),
        (
            "UTSUSEMI_BONUS",
            r'\bAdds\s+"?Regen"?\s+effect\s+Utsusemi\s*([+-]\s*\d+)(?!\s*~)',
            1,
        ),
        ("HPHEAL", r"\bHP recovered while healing\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MPHEAL", r"\bMP recovered while healing\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("CONSERVE_MP", r"\b\"?Conserve MP\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("COOK", r"\bCooking Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("DARK", r"\bDark Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MAGIC_DAMAGE", r"\bMagic Damage\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MAGIC_DAMAGE", r"\bMagic dmg\.?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("DAKEN", r"(?<!\w)\"?Daken\"?\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("OCCULT_ACUMEN", r"\b\"?Occult Acumen\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "PERPETUATION_REDUCTION",
            r"\bAvatar'?s?\s+perpetuation(?:\s+cost)?\s*(-\s*\d+)(?!\s*~)",
            -1,
        ),
        (
            "DMG",
            r"(?<!Magic )(?<!Physical )(?<!Phys\. )\b\"?Damage taken\"?\s*([+-]\s*\d+)%(?!\s*~)",
            100,
        ),
        ("DMG", r"\bDT\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("DMGPHYS_II", r"\bPhysical Damage taken II\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("DMGPHYS_II", r"\bPhys\. dmg\. taken II\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("DMGPHYS", r"\bPhysical (?:damage|dmg\.) taken\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("DMGMAGIC_II", r"\bMagic Damage Taken II\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("DMGMAGIC", r"\bMagic (?:damage|dmg\.) taken\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("ENH_MAGIC_DURATION", r"\bEnhancing magic duration\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("SONG_DURATION_BONUS", r"\bSong effect duration\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("SONG_DURATION_BONUS", r"\bSong duration\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("SONG_DURATION_BONUS", r"\bSong Duration Bonus\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("SONG_SPELLCASTING_TIME", r"\bSong Spellcasting Time\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("SONG_RECAST_DELAY", r"\bSong Recast Delay\s*(-\s*\d+)(?!\s*~)", -1),
        (
            "GRIMOIRE_SPELLCASTING",
            r"\bGrimoire:\s*Spellcasting time\s*([+-]\s*\d+)%(?!\s*~)",
            1,
        ),
        ("ALL_SONGS_EFFECT", r"\bAll songs\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MINUET_EFFECT", r"\bMinuet\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("PAEON_EFFECT", r"\b\"?Paeon\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("REQUIEM_EFFECT", r"\b\"?Requiem\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("LULLABY_EFFECT", r"\bLullaby\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MADRIGAL_EFFECT", r"\bMadrigal\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ETUDE_EFFECT", r"\bEtude\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("BALLAD_EFFECT", r"\bBallad\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MARCH_EFFECT", r"\bMarch\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("CAROL_EFFECT", r"\bCarol\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ELEGY_EFFECT", r"\bElegy\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("PRELUDE_EFFECT", r"\bPrelude\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ENSPELL_DMG_BONUS", r"\bSword enhancement spell damage\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ENSPELL_DMG_BONUS", r"\bEnspell Damage Bonus\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("PHALANX_RECEIVED", r"\bPhalanx\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("GEOMANCY_BONUS", r"\bGeomancy\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("INDI_DURATION", r"\bIndicolure spell duration\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("JIG_DURATION", r"\bJig Duration\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("AMNESIARES", r"\bAmnesia Resistance\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("BINDRES", r"\b\"?Resist Bind\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("BLINDRES", r"\b(?:\"?Resist Blind\"?|Blind Resistance)\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "PETRIFYRES",
            r"\b(?:\"?Resist Petrify\"?|Petrify Resistance)\s*([+-]\s*\d+)(?!\s*~)",
            1,
        ),
        (
            "SILENCERES",
            r"\b(?:\"?Resist Silence\"?|Silence Resistance)\s*([+-]\s*\d+)(?!\s*~)",
            1,
        ),
        ("SLEEPRES", r"\b(?:\"?Resist Sleep\"?|Sleep Resistance)\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SAMBA_DURATION", r"\b\"?Samba\"?\s+Duration\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("TANDEM_BLOW_POWER", r"\b\"?Tandem Blow\"?\s+effect\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "TANDEM_STRIKE_POWER",
            r"\b\"?Tandem Strike\"?\s+effect\s*([+-]\s*\d+)(?!\s*~)",
            1,
        ),
        (
            "VIVACIOUS_PULSE_POTENCY",
            r"\b\"?Vivacious Pulse\"?\s+potency\s*([+-]\s*\d+)%?(?!\s*~)",
            1,
        ),
        ("PFLUG", r"\b\"?Pflug\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("REPAIR_POTENCY", r"\bRepair Potency\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("MAX_FINISHING_MOVE_BONUS", r"\bMaximum Finishing Moves\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "ROLL_RANGE",
            r'\bIncreases\s+"?Phantom Roll"?\s+area of effect\s*([+-]\s*\d+)(?!\s*~)',
            1,
        ),
        ("DARK_ARTS_EFFECT", r'\b"?Dark Arts"?\s*([+-]\s*\d+)(?!\s*~)', 1),
        ("LIGHT_ARTS_EFFECT", r'\b"?Light Arts"?\s*([+-]\s*\d+)(?!\s*~)', 1),
        ("STONESKIN_BONUS_HP", r"\bIronskin\s*\(\s*Stoneskin\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ELEMENTAL_DEBUFF_EFFECT", r"\bElemental Debuff Potency\s*([+-]\s*\d+)(?!\s*~)", 1),
        (
            "SYNTH_MATERIAL_LOSS",
            r"\bDecreases likelihood of synthesis material loss\s*\+?\s*(\d+)%?(?!\s*~)",
            1,
        ),
        ("SKILLCHAINBONUS", r"\b\"?Skillchain Bonus\"?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SKILLCHAINDMG", r"\bSkillchain Damage\s*([+-]\s*\d+)%(?!\s*~)", 100),
        ("MAGIC_BURST_BONUS_CAPPED", r"\bMagic burst damage\s*([+-]\s*\d+)%?(?!\s*~)", 1),
        ("WALTZ_POTENCY", r"\bWaltz Potency\s*([+-]\s*\d+)%(?!\s*~)", 1),
        ("WALTZ_DELAY", r"\bWaltz delay\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("WALTZ_COST", r"\bWaltz TP cost\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SWORDPLAY", r"\bSwordplay\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SHIELDBLOCKRATE", r"\bChance of successful block\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("HTH", r"\bHand-to-[Hh]and skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("DAGGER", r"\bDagger skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SWORD", r"\bSword skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("GSWORD", r"\bGreat Sword skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("AXE", r"\bAxe skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("GAXE", r"\bGreat Axe skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SCYTHE", r"\bScythe skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("POLEARM", r"\bPolearm skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("KATANA", r"\bKatana skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("GKATANA", r"\bGreat Katana skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("CLUB", r"\bClub skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("STAFF", r"\bStaff skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ARCHERY", r"\bArchery skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MARKSMAN", r"\bMarksmanship skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("MARKSMAN", r"\bMarks\. skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("THROW", r"\bThrow(?:ing)? skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("GUARD", r"\bGuard(?:ing)? skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("EVASION", r"\bEvasion skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SHIELD", r"\bShield skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("PARRY", r"\bParrying skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("PARRY", r"\bParry Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("DIVINE", r"\bDivine Magic(?: Skill)?\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("HEALING", r"\bHealing magic skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("HEALING", r"\bHealing skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ENHANCE", r"\bEnhancing Magic Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ENFEEBLE", r"\bEnfeebling Magic Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ELEM", r"\bElemental Magic Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ELEM", r"\bElemental Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("ELEM", r"\bElem\. magic skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("DARK", r"\bDark Magic Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SUMMONING", r"\bSummoning magic skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SUMMONING", r"\bSummoning skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("NINJUTSU", r"\bNinjutsu skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("NINJUTSU", r"\bNinjutsuSkill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("OCCULT_ACUMEN", r"\bOccult (?:Acument|Occument)\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("SINGING", r"\bSinging skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("STRING", r"\bString instrument skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("STRING", r"\bString Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("WIND", r"\bWind instrument skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("BLUE", r"\bBlue Magic skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("GEOMANCY_SKILL", r"\bGeomancy skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        ("HANDBELL_SKILL", r"\bHandbell Skill\s*([+-]\s*\d+)(?!\s*~)", 1),
        *ELEMENTAL_RESIST_PATTERNS,
        *KILLER_STAT_PATTERNS,
    )


def _comparable_stats_text(stats_text: str) -> str:
    return " ".join(_comparable_stat_lines(stats_text))


def _comparable_stat_lines(stats_text: str) -> list[str]:
    return _player_stat_lines(stats_text, strip_conditionals=True)


def _player_stat_lines(stats_text: str, *, strip_conditionals: bool) -> list[str]:
    lines = []
    for line in stats_text.replace("\u00a0", " ").splitlines():
        line = line.strip()
        if not line:
            continue
        lower = line.lower()
        if "latent effect" in lower:
            line = re.split(r"(?i)\blatent effect\b", line, maxsplit=1)[0].strip()
            if not line:
                continue
            lower = line.lower()
        if "latent activation" in lower:
            line = WIKI_LATENT_ACTIVATION_RE.sub("", line).strip()
            if not line:
                continue
            lower = line.lower()
        line = re.split(r"(?i)\b(?:pet|avatar|wyvern|luopan):", line, maxsplit=1)[0].strip()
        if not line:
            continue
        line = _strip_hidden_crafting_skill_phrases(line).strip()
        if not line:
            continue
        if strip_conditionals:
            line = _strip_conditional_clauses(line).strip()
            if not line:
                continue
        lines.append(line)
    return lines


def _raw_stat_lines(stats_text: str) -> list[str]:
    return [
        line.strip()
        for line in stats_text.replace("\u00a0", " ").splitlines()
        if line.strip()
    ]


def _strip_hidden_crafting_skill_phrases(line: str) -> str:
    match = HIDDEN_EFFECT_PREFIX_RE.search(line)
    if match is None:
        return line

    prefix = line[:match.start()]
    hidden_body = line[match.end():]
    cleaned_body = HIDDEN_CRAFTING_SKILL_RE.sub("", hidden_body)
    cleaned_body = " ".join(cleaned_body.split())
    if not cleaned_body:
        return prefix
    return f"{prefix}{line[match.start():match.end()]}{cleaned_body}"


def _strip_conditional_clauses(line: str) -> str:
    spans = _conditional_clause_spans(line)
    if not spans:
        return line

    result: list[str] = []
    cursor = 0
    for start, _prefix_end, end, _label in spans:
        result.append(line[cursor:start])
        cursor = end
    result.append(line[cursor:])
    return " ".join(part.strip() for part in result if part.strip())


def _conditional_clauses(line: str) -> tuple[tuple[str, str], ...]:
    clauses = []
    for _start, prefix_end, end, label in _conditional_clause_spans(line):
        body = line[prefix_end:end].strip()
        if body:
            clauses.append((label, body))
    return tuple(clauses)


def _conditional_clause_spans(line: str) -> tuple[tuple[int, int, int, str], ...]:
    matches = list(WIKI_CONDITIONAL_PREFIX_RE.finditer(line))
    if not matches:
        return tuple()

    spans: list[tuple[int, int, int, str]] = []
    for index, match in enumerate(matches):
        clause_end = matches[index + 1].start() if index + 1 < len(matches) else len(line)
        spans.append((match.start(), match.end(), clause_end, match.group("label")))
    return tuple(spans)


def _latent_conditional_clauses(line: str) -> tuple[tuple[tuple[str, str], str], ...]:
    activation_condition_text = _latent_activation_condition_text(line)
    activation_condition = (
        _condition_from_latent_text(activation_condition_text)
        if activation_condition_text
        else None
    )
    clauses = []
    for match in WIKI_LATENT_EFFECT_RE.finditer(line):
        body = _strip_latent_activation(match.group("body")).strip()
        trailing_condition_text = _trailing_latent_condition_text(body)
        condition_text = match.group("inline_condition") or trailing_condition_text or ""
        condition = (
            _condition_from_latent_text(condition_text)
            if condition_text
            else activation_condition
        )
        if condition is None:
            if condition_text or activation_condition_text:
                continue
            condition = LATENT_UNKNOWN_CONDITION

        body = _strip_trailing_latent_condition(body).strip()
        if body:
            clauses.append((condition, body))
    return tuple(clauses)


def _latent_activation_condition(line: str) -> tuple[str, str] | None:
    condition_text = _latent_activation_condition_text(line)
    if not condition_text:
        return None
    return _condition_from_latent_text(condition_text)


def _latent_activation_condition_text(line: str) -> str:
    match = WIKI_LATENT_ACTIVATION_RE.search(line)
    if match is None:
        return ""
    return match.group("condition")


def _strip_latent_activation(text: str) -> str:
    return WIKI_LATENT_ACTIVATION_RE.sub("", text)


def _trailing_latent_condition_text(text: str) -> str:
    match = WIKI_TRAILING_LATENT_CONDITION_RE.search(text)
    return match.group("condition").strip() if match else ""


def _strip_trailing_latent_condition(text: str) -> str:
    return WIKI_TRAILING_LATENT_CONDITION_RE.sub("", text)


def _condition_from_label(label: str) -> tuple[str, str] | None:
    value = re.sub(r"\s+", " ", label.strip().lower())
    if value in {"set", "set bonus"}:
        return "set_bonus", "set"
    if value in {"right ear", "left ear"}:
        return "slot_side", value.replace(" ", "_")
    if value.endswith(" weather"):
        return "weather", value[: -len(" weather")]
    day_match = re.fullmatch(r"on\s+([a-z]+)days?", value)
    if day_match:
        day_name = day_match.group(1)
        if day_name.endswith("s"):
            day_name = day_name[:-1]
        if day_name == "lightning":
            day_name = "thunder"
        return "day", day_name
    return "status", value.replace(" ", "_")


def _condition_from_latent_text(text: str) -> tuple[str, str] | None:
    value = re.sub(r"\s+", " ", text.strip().lower())
    if not value:
        return None

    for token, condition_name in LATENT_STATUS_CONDITIONS.items():
        if token in value and ("active" in value or value == token):
            return "status", condition_name

    level_match = re.search(r"\b(?:under|below)\s+(?:lv\.?|level)?\s*\.?\s*(\d+)\b", value)
    if level_match:
        return "level_lt", level_match.group(1)

    level_plus_match = re.search(r"\blevel\s*(\d+)\s*\+", value)
    if level_plus_match:
        return "level_gte", level_plus_match.group(1)

    mp_percent_match = re.search(r"\bmp\s*(?:is)?\s*<\s*(\d+)\s*%", value)
    if mp_percent_match:
        return "mpp_lt", mp_percent_match.group(1)

    mp_gt_match = re.search(r"\bmp\s*>\s*(\d+)\b", value)
    if mp_gt_match:
        return "mp_gt", mp_gt_match.group(1)

    if "arcane circle" in value:
        return "status", "arcane_circle"

    if value in {"poisoned", "poison"}:
        return "status", "poison"

    if "under lv50" in value or "under lv.50" in value:
        return "level_lt", "50"

    if "while in tu'lia" in value or "while in tulia" in value:
        return "zone_region", "tu_lia"

    return None


def _parse_conditional_stat_mods_from_body(body: str) -> dict[str, int]:
    player_body = re.split(
        r"(?i)\b(?:pet|avatar|automaton|wyvern|luopan):",
        body,
        maxsplit=1,
    )[0].strip()
    if not player_body:
        return {}
    return _parse_stat_mods_from_text(player_body)


def _has_numeric_suffix_continuation(text: str, match_end: int) -> bool:
    suffix = text[match_end:]
    if suffix and suffix[0].isdigit():
        return True

    stripped = suffix.lstrip()
    return bool(stripped and stripped[0] in {"~", "%"})


def _normalized_duplicate_stat_text(text: str) -> str:
    normalized = text.replace('"', "").lower()
    normalized = re.sub(r"\s+", " ", normalized)
    normalized = re.sub(r"\s*([+-])\s*", r"\1", normalized)
    return normalized.strip()


def _add_mod(mods: dict[str, int], mod_name: str, value: int) -> None:
    mods[mod_name] = mods.get(mod_name, 0) + value
