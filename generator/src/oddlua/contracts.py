from __future__ import annotations

from dataclasses import dataclass

from .gearexport import CharacterSnapshot


SUPPORTED_JOBS = (
    "WAR", "MNK", "WHM", "BLM", "RDM", "THF", "PLD", "DRK", "BST",
    "BRD", "RNG", "SAM", "NIN", "DRG", "SMN", "BLU", "COR", "PUP",
    "DNC", "SCH", "GEO", "RUN",
)

HARD_EXCLUSIONS = (
    "Fishing",
    "Crafting",
    "Utility",
    "Cosmetic",
    "PolicyExcluded",
    "LevelIneligible",
    "WrongJob",
    "WrongWeaponFamily",
)

STANDARD_JOB_STYLES = {
    "WAR": ("Damage", "Accuracy", "WeaponSkill", "Survival"),
    "MNK": ("Damage", "Accuracy", "WeaponSkill", "Evasion"),
    "WHM": ("Cure", "FastCast", "IdleRefresh", "Damage"),
    "BLM": ("Nuke", "MagicAccuracy", "FastCast", "IdleRefresh"),
    "RDM": ("Enspell", "MagicAccuracy", "FastCast", "Cure"),
    "DRK": ("Damage", "Accuracy", "WeaponSkill", "DrainAbsorb"),
    "BST": ("Damage", "Accuracy", "PetDamage", "PetTank"),
    "BRD": ("Song", "FastCast", "MagicAccuracy", "IdleRefresh"),
    "RNG": ("RangedDamage", "RangedAccuracy", "WeaponSkill", "Evasion"),
    "SAM": ("StoreTP", "Accuracy", "WeaponSkill", "Evasion"),
    "NIN": ("Damage", "Accuracy", "Evasion", "Ninjutsu"),
    "DRG": ("Damage", "Accuracy", "WeaponSkill", "Jump"),
    "SMN": ("AvatarPerp", "BloodPact", "SummoningMagic", "IdleRefresh"),
    "BLU": ("PhysicalBlue", "MagicalBlue", "FastCast", "Accuracy"),
    "COR": ("RangedDamage", "RangedAccuracy", "QuickDraw", "Roll"),
    "PUP": ("Damage", "Accuracy", "PetDamage", "PetTank"),
    "DNC": ("Damage", "Accuracy", "Waltz", "Evasion"),
    "GEO": ("GeoMagic", "Nuke", "FastCast", "IdleRefresh"),
    "RUN": ("Tank", "MagicDefense", "Damage", "Enmity"),
}

STYLE_SPECS = {
    "Tank": {
        "description": "Durable tank set for holding attention and reducing incoming damage.",
        "weapon_family": "job_tank",
        "priority_roles": ("defense", "hp", "enmity", "damage_taken", "magic_defense"),
    },
    "Enmity": {
        "description": "Hate spike set for job abilities and spells that need stronger enmity.",
        "weapon_family": "job_tank",
        "priority_roles": ("enmity", "hp", "fast_cast", "defense"),
    },
    "MagicDefense": {
        "description": "Magic-heavy target set for elemental pressure and spell damage.",
        "weapon_family": "job_tank",
        "priority_roles": ("magic_defense", "mdef", "magic_evasion", "hp"),
    },
    "Nuke": {
        "description": "Elemental magic damage set.",
        "weapon_family": "staff+grip",
        "priority_roles": ("magic_damage", "matt", "int", "magic_accuracy"),
    },
    "MagicAccuracy": {
        "description": "Spell landing set for resist-sensitive targets.",
        "weapon_family": "caster",
        "priority_roles": ("magic_accuracy", "int", "mnd", "mp"),
    },
    "FastCast": {
        "description": "Precast and recast set for faster spell starts.",
        "weapon_family": "caster",
        "priority_roles": ("fast_cast", "quick_magic", "haste", "mp"),
    },
    "IdleRefresh": {
        "description": "Idle sustain set for MP recovery and downtime safety.",
        "weapon_family": "caster",
        "priority_roles": ("refresh", "mp", "conserve_mp", "magic_defense"),
    },
    "Damage": {
        "description": "Default engaged damage set for practical kill speed.",
        "weapon_family": "job_default",
        "priority_roles": ("melee_offense", "accuracy", "str", "dex", "weapon_skill"),
    },
    "Accuracy": {
        "description": "Accuracy-biased engaged set for higher-evasion targets.",
        "weapon_family": "job_default",
        "priority_roles": ("accuracy", "dex", "melee_offense", "weapon_skill"),
    },
    "WeaponSkill": {
        "description": "Weapon skill set using the job's practical damage stats.",
        "weapon_family": "job_default",
        "priority_roles": ("weapon_skill", "str", "dex", "accuracy", "melee_offense"),
    },
    "Survival": {
        "description": "Safer engaged fallback for hard pulls.",
        "weapon_family": "job_default",
        "priority_roles": ("defense", "evasion", "hp", "vit", "magic_defense"),
    },
    "Evasion": {
        "description": "Avoidance set for jobs that can mitigate through evasion or shadows.",
        "weapon_family": "job_default",
        "priority_roles": ("evasion", "agi", "defense", "accuracy"),
    },
    "Cure": {
        "description": "Healing set for cure potency, MND, MP, and safe casting.",
        "weapon_family": "staff_or_club",
        "priority_roles": ("cure", "mnd", "mp", "fast_cast", "magic_defense"),
    },
    "Enspell": {
        "description": "RDM hybrid melee/casting set for enspell damage and accuracy.",
        "weapon_family": "sword_or_dagger",
        "priority_roles": ("melee_offense", "accuracy", "magic_accuracy", "int", "mnd"),
    },
    "DrainAbsorb": {
        "description": "DRK dark-magic utility set for drains, absorbs, and spell landing.",
        "weapon_family": "scythe_or_great_sword",
        "priority_roles": ("magic_accuracy", "dark_magic", "int", "mp", "melee_offense"),
    },
    "PetDamage": {
        "description": "Pet-focused damage set while preserving master gear legality.",
        "weapon_family": "job_default",
        "priority_roles": ("pet_damage", "pet_accuracy", "melee_offense", "accuracy"),
    },
    "PetTank": {
        "description": "Pet-focused durability set for pet tanking or safer automation.",
        "weapon_family": "job_default",
        "priority_roles": ("pet_defense", "pet_evasion", "hp", "defense"),
    },
    "Song": {
        "description": "BRD song set for landing and maintaining songs.",
        "weapon_family": "instrument",
        "priority_roles": ("song", "magic_accuracy", "chr", "fast_cast"),
    },
    "RangedDamage": {
        "description": "Ranged attack set for physical ranged damage.",
        "weapon_family": "ranged",
        "priority_roles": ("ranged_offense", "ranged_accuracy", "agi", "str"),
    },
    "RangedAccuracy": {
        "description": "Ranged accuracy set for evasive targets.",
        "weapon_family": "ranged",
        "priority_roles": ("ranged_accuracy", "agi", "accuracy"),
    },
    "StoreTP": {
        "description": "SAM TP flow set for faster weapon-skill cadence.",
        "weapon_family": "great_katana",
        "priority_roles": ("store_tp", "haste", "accuracy", "melee_offense"),
    },
    "Ninjutsu": {
        "description": "NIN casting set for ninjutsu landing and safe recasts.",
        "weapon_family": "katana",
        "priority_roles": ("magic_accuracy", "int", "fast_cast", "evasion"),
    },
    "Jump": {
        "description": "DRG jump and polearm burst set.",
        "weapon_family": "polearm",
        "priority_roles": ("weapon_skill", "str", "dex", "accuracy", "store_tp"),
    },
    "AvatarPerp": {
        "description": "SMN idle/perpetuation set for avatar upkeep and MP sustain.",
        "weapon_family": "staff+grip",
        "priority_roles": ("avatar_perp", "refresh", "mp", "summoning_magic"),
    },
    "BloodPact": {
        "description": "SMN blood pact set for avatar offensive actions.",
        "weapon_family": "staff+grip",
        "priority_roles": ("blood_pact", "pet_damage", "pet_accuracy", "summoning_magic"),
    },
    "SummoningMagic": {
        "description": "SMN skill and magic-accuracy set.",
        "weapon_family": "staff+grip",
        "priority_roles": ("summoning_magic", "magic_accuracy", "mp"),
    },
    "PhysicalBlue": {
        "description": "BLU physical spell and melee set.",
        "weapon_family": "sword",
        "priority_roles": ("blue_magic", "str", "dex", "accuracy", "melee_offense"),
    },
    "MagicalBlue": {
        "description": "BLU magical spell set.",
        "weapon_family": "sword",
        "priority_roles": ("blue_magic", "magic_damage", "magic_accuracy", "int"),
    },
    "QuickDraw": {
        "description": "COR magic-shot set for Quick Draw accuracy and damage.",
        "weapon_family": "gun",
        "priority_roles": ("quick_draw", "magic_accuracy", "magic_damage", "agi"),
    },
    "Roll": {
        "description": "COR roll utility set that still blocks non-combat utility filler.",
        "weapon_family": "gun",
        "priority_roles": ("roll", "ranged_accuracy", "chr", "mp"),
    },
    "Waltz": {
        "description": "DNC healing support set for Waltz potency and survivability.",
        "weapon_family": "dagger",
        "priority_roles": ("waltz", "chr", "vit", "hp", "evasion"),
    },
    "GeoMagic": {
        "description": "GEO geomancy and enfeebling support set.",
        "weapon_family": "staff+grip",
        "priority_roles": ("geomancy", "magic_accuracy", "mp", "fast_cast"),
    },
}


@dataclass(frozen=True)
class Playstyle:
    name: str
    description: str
    command: str
    weapon_family: str
    allows_weapon_family_switch: bool
    priority_roles: tuple[str, ...]
    prohibited_roles: tuple[str, ...]
    combat_enabled: bool
    non_engaged_only: bool
    allows_level_ineligible_items: bool
    degrade_without_useful_gear: bool
    reasons: tuple[str, ...]
    confidence: str

    @property
    def manifest_metadata(self) -> dict[str, object]:
        return {
            "name": self.name,
            "command": self.command,
            "weaponFamily": self.weapon_family,
            "allowsWeaponFamilySwitch": self.allows_weapon_family_switch,
            "priorityRoles": list(self.priority_roles),
            "prohibitedRoles": list(self.prohibited_roles),
            "combatEnabled": self.combat_enabled,
            "nonEngagedOnly": self.non_engaged_only,
            "allowsLevelIneligibleItems": self.allows_level_ineligible_items,
            "degradeWithoutUsefulGear": self.degrade_without_useful_gear,
            "reasons": list(self.reasons),
            "confidence": self.confidence,
        }


@dataclass(frozen=True)
class JobContract:
    job: str
    character_level: int
    level_source: str
    default_playstyle: str
    playstyles: tuple[Playstyle, ...]
    hard_exclusions: tuple[str, ...]
    confidence: str
    reasons: tuple[str, ...]

    def playstyle(self, name: str) -> Playstyle:
        folded = name.lower()
        for style in self.playstyles:
            if style.name.lower() == folded or style.command.lower().endswith(folded):
                return style
        raise KeyError(name)

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "job": self.job,
            "characterLevel": self.character_level,
            "levelSource": self.level_source,
            "defaultPlaystyle": self.default_playstyle,
            "playstyles": [style.manifest_metadata for style in self.playstyles],
            "hardExclusions": list(self.hard_exclusions),
            "confidence": self.confidence,
            "reasons": list(self.reasons),
        }


def build_thf_contract(
    character: CharacterSnapshot | int | None = None,
    *,
    character_level: int | None = None,
) -> JobContract:
    level, level_source = _resolve_thf_level(character, character_level)
    level_facts = _level_fact_reason(level)

    return JobContract(
        job="THF",
        character_level=level,
        level_source=level_source,
        default_playstyle="Melt",
        playstyles=(
            Playstyle(
                name="Melt",
                description="Default raw kill-speed mode for Aahtacos THF at the current level band.",
                command="style melt",
                weapon_family="any",
                allows_weapon_family_switch=True,
                priority_roles=("melee_offense", "accuracy", "str", "dex", "weapon_skill"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=(
                    "kill_speed is the default because longer-lived targets create worse outcomes.",
                    level_facts,
                ),
                confidence="catseye_job_rules_and_local_level",
            ),
            Playstyle(
                name="Dagger",
                description="Dagger skill and dagger weapon skill mode without under-level gear.",
                command="style dagger",
                weapon_family="dagger",
                allows_weapon_family_switch=False,
                priority_roles=("dagger_skill", "melee_offense", "accuracy", "dex", "weapon_skill"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=(
                    "Dagger mode biases dagger-family weapons and Viper Bite/Wasp Sting fit.",
                    "Level eligibility remains hard-gated by CharacterSnapshot THF level.",
                ),
                confidence="catseye_job_rules_and_local_level",
            ),
            Playstyle(
                name="Safe",
                description="Survival and evasion fallback for unsafe pulls.",
                command="style safe",
                weapon_family="any",
                allows_weapon_family_switch=True,
                priority_roles=("evasion", "defense", "agi", "accuracy", "melee_offense"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("Safe mode prefers evasion and defense without abandoning valid combat gear.",),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="Treasure",
                description="Treasure Hunter marker/proc mode that falls back to Melt when useful TH gear is absent.",
                command="style treasure",
                weapon_family="any",
                allows_weapon_family_switch=True,
                priority_roles=("treasure", "farming", "melee_offense", "accuracy"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=(
                    "CatsEyeXI has TH caps and proc behavior, but no useful TH item should mean no kill-speed downgrade.",
                ),
                confidence="catseye_job_rules_and_local_level",
            ),
            Playstyle(
                name="Craft",
                description="Non-engaged crafting and utility mode only.",
                command="style craft",
                weapon_family="none",
                allows_weapon_family_switch=False,
                priority_roles=("crafting", "utility"),
                prohibited_roles=("melee_offense", "weapon_skill", "dagger_skill", "sword_skill"),
                combat_enabled=False,
                non_engaged_only=True,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("Craft mode is intentionally blocked from combat and engaged set selection.",),
                confidence="catseye_aware_local_contract",
            ),
        ),
        hard_exclusions=(
            "Fishing",
            "Crafting",
            "Utility",
            "Cosmetic",
            "PolicyExcluded",
            "LevelIneligible",
            "WrongJob",
            "WrongWeaponFamily",
        ),
        confidence="catseye_aware_local_contract",
        reasons=(
            "THF level is sourced from CharacterSnapshot.job_level('THF'), not GearExport.current_job.",
            "Catseye THF rules include Dual Wield I/II, Assassin at 50, Bully at 60, early Viper Bite, and TH proc behavior.",
            "Live testing feedback can policy-exclude low-value named gear when the local classifier would otherwise overvalue it.",
        ),
    )


def build_job_contract(
    job: str,
    character: CharacterSnapshot | int | None = None,
    *,
    character_level: int | None = None,
) -> JobContract:
    normalized = job.upper()
    if normalized == "THF":
        return build_thf_contract(character, character_level=character_level)
    if normalized == "PLD":
        return build_pld_contract(character, character_level=character_level)
    if normalized == "SCH":
        return build_sch_contract(character, character_level=character_level)
    if normalized in STANDARD_JOB_STYLES:
        return build_standard_job_contract(normalized, character, character_level=character_level)
    raise ValueError(f"OddLua builder does not have a job contract for {normalized}")


def build_standard_job_contract(
    job: str,
    character: CharacterSnapshot | int | None = None,
    *,
    character_level: int | None = None,
) -> JobContract:
    level, level_source = _resolve_job_level(job, character, character_level)
    style_names = STANDARD_JOB_STYLES[job]
    playstyles = tuple(_build_standard_playstyle(job, level, style_name) for style_name in style_names)

    return JobContract(
        job=job,
        character_level=level,
        level_source=level_source,
        default_playstyle=style_names[0],
        playstyles=playstyles,
        hard_exclusions=HARD_EXCLUSIONS,
        confidence="catseye_aware_local_contract",
        reasons=(
            f"{job} level is sourced from CharacterSnapshot.job_level('{job}'), not GearExport.current_job.",
            f"The first {job} build lanes are {', '.join(style_names)}.",
            "Target physical SDT can bias weapon scoring when mobdb data is available.",
        ),
    )


def _build_standard_playstyle(job: str, level: int, style_name: str) -> Playstyle:
    spec = STYLE_SPECS[style_name]
    command = _style_command(style_name)
    return Playstyle(
        name=style_name,
        description=str(spec["description"]),
        command=f"style {command}",
        weapon_family=str(spec["weapon_family"]),
        allows_weapon_family_switch=True,
        priority_roles=tuple(spec["priority_roles"]),
        prohibited_roles=("crafting", "fishing", "utility"),
        combat_enabled=True,
        non_engaged_only=False,
        allows_level_ineligible_items=False,
        degrade_without_useful_gear=False,
        reasons=(
            f"At {job}{level}, {style_name} is one of the four generated job lanes.",
            "Owned gear remains hard-gated by job, level, slot, and explicit utility exclusions.",
        ),
        confidence="catseye_aware_local_contract",
    )


def _style_command(style_name: str) -> str:
    return style_name.lower()


def build_pld_contract(
    character: CharacterSnapshot | int | None = None,
    *,
    character_level: int | None = None,
) -> JobContract:
    level, level_source = _resolve_job_level("PLD", character, character_level)

    return JobContract(
        job="PLD",
        character_level=level,
        level_source=level_source,
        default_playstyle="Tank",
        playstyles=(
            Playstyle(
                name="Tank",
                description="Default shield tank set focused on surviving engaged combat while holding hate.",
                command="style tank",
                weapon_family="sword+shield",
                allows_weapon_family_switch=True,
                priority_roles=("shield", "defense", "hp", "vit", "enmity", "damage_taken"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=(
                    f"At PLD{level}, shield tanking is the safest default because PLD value comes from mitigation plus enmity.",
                    "Sub slot is constrained to shield for tank and hate styles.",
                ),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="Enmity",
                description="Hate spike set for Provoke, Flash, Sentinel, Cover, and other enmity actions.",
                command="style enmity",
                weapon_family="sword+shield",
                allows_weapon_family_switch=True,
                priority_roles=("enmity", "hp", "shield", "fast_cast", "defense"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("Enmity mode values direct ENMITY, HP cushion, and shield safety over raw DPS.",),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="Damage",
                description="Solo or low-risk melee damage set using the best practical one-handed PLD weapon.",
                command="style damage",
                weapon_family="sword_or_club+shield",
                allows_weapon_family_switch=True,
                priority_roles=("melee_offense", "accuracy", "str", "dex", "haste", "weapon_skill"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=(
                    "Damage mode may choose sword or club when target physical weaknesses make one clearly better.",
                ),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="MagicDefense",
                description="Magic-heavy target set focused on MDEF, magic damage taken, HP, and elemental evasion.",
                command="style magicdefense",
                weapon_family="sword+shield",
                allows_weapon_family_switch=True,
                priority_roles=("magic_defense", "mdef", "magic_evasion", "hp", "damage_taken"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("MagicDefense mode is for targets where spell damage or elemental pressure is the main risk.",),
                confidence="catseye_aware_local_contract",
            ),
        ),
        hard_exclusions=(
            "Fishing",
            "Crafting",
            "Utility",
            "Cosmetic",
            "PolicyExcluded",
            "LevelIneligible",
            "WrongJob",
            "WrongWeaponFamily",
        ),
        confidence="catseye_aware_local_contract",
        reasons=(
            "PLD level is sourced from CharacterSnapshot.job_level('PLD'), not GearExport.current_job.",
            "The first PLD build lanes are tank, hate spike, melee damage, and magic defense.",
            "Target physical SDT can bias Damage between sword and club when mobdb data is available.",
        ),
    )


def build_sch_contract(
    character: CharacterSnapshot | int | None = None,
    *,
    character_level: int | None = None,
) -> JobContract:
    level, level_source = _resolve_job_level("SCH", character, character_level)

    return JobContract(
        job="SCH",
        character_level=level,
        level_source=level_source,
        default_playstyle="Nuke",
        playstyles=(
            Playstyle(
                name="Nuke",
                description="Default elemental magic damage set for SCH nuking.",
                command="style nuke",
                weapon_family="staff+grip",
                allows_weapon_family_switch=True,
                priority_roles=("magic_damage", "matt", "int", "magic_accuracy", "elemental_magic"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=(
                    f"At SCH{level}, elemental output starts from INT, magic attack, and enough magic accuracy to land.",
                    "Main/Sub favors staff plus grip to avoid invalid staff-plus-shield combinations.",
                ),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="MagicAccuracy",
                description="Resist-sensitive SCH set for enfeebles, dark magic, and hard-to-land nukes.",
                command="style magicaccuracy",
                weapon_family="staff+grip",
                allows_weapon_family_switch=True,
                priority_roles=("magic_accuracy", "int", "mnd", "elemental_magic", "dark_magic"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("MagicAccuracy mode prioritizes landing spells when target resist ranks are a bigger risk than raw damage.",),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="FastCast",
                description="Precast and recast set for faster spell starts.",
                command="style fastcast",
                weapon_family="staff+grip",
                allows_weapon_family_switch=True,
                priority_roles=("fast_cast", "quick_magic", "haste", "mp"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("FastCast mode is a spell-start set and should not borrow melee filler when casting stats are absent.",),
                confidence="catseye_aware_local_contract",
            ),
            Playstyle(
                name="IdleRefresh",
                description="Idle sustain set for MP recovery and safer downtime.",
                command="style idlerefresh",
                weapon_family="staff+grip",
                allows_weapon_family_switch=True,
                priority_roles=("refresh", "mp", "conserve_mp", "damage_taken", "magic_defense"),
                prohibited_roles=("crafting", "fishing", "utility"),
                combat_enabled=True,
                non_engaged_only=False,
                allows_level_ineligible_items=False,
                degrade_without_useful_gear=False,
                reasons=("IdleRefresh mode values passive MP recovery and safety over action-specific spell stats.",),
                confidence="catseye_aware_local_contract",
            ),
        ),
        hard_exclusions=(
            "Fishing",
            "Crafting",
            "Utility",
            "Cosmetic",
            "PolicyExcluded",
            "LevelIneligible",
            "WrongJob",
            "WrongWeaponFamily",
        ),
        confidence="catseye_aware_local_contract",
        reasons=(
            "SCH level is sourced from CharacterSnapshot.job_level('SCH'), not GearExport.current_job.",
            "The first SCH build lanes are nuke, magic accuracy, fast cast, and idle refresh.",
            "Target elemental SDT/resist ranks are available to tune future spell-element choices.",
        ),
    )


def _resolve_thf_level(
    character: CharacterSnapshot | int | None,
    explicit_level: int | None,
) -> tuple[int, str]:
    return _resolve_job_level("THF", character, explicit_level)


def _resolve_job_level(
    job: str,
    character: CharacterSnapshot | int | None,
    explicit_level: int | None,
) -> tuple[int, str]:
    normalized = job.upper()
    if isinstance(character, CharacterSnapshot):
        level = character.job_level(normalized)
        source = f"CharacterSnapshot.job_level('{normalized}')"
    elif isinstance(character, int):
        level = character
        source = "explicit_character_level"
    elif explicit_level is not None:
        level = explicit_level
        source = "explicit_character_level"
    else:
        raise ValueError(f"build_{normalized.lower()}_contract requires CharacterSnapshot or character_level")

    if level <= 0:
        raise ValueError(f"{normalized} level must be greater than zero")
    return level, source


def _level_fact_reason(level: int) -> str:
    facts: list[str] = []
    if level >= 40:
        facts.append("Dual Wield II")
    elif level >= 20:
        facts.append("Dual Wield I")
    if level >= 50:
        facts.append("Assassin")
    if level >= 60:
        facts.append("Bully")
        return f"At THF{level}, Catseye THF has {', '.join(facts)}."
    known = ", ".join(facts) if facts else "starter THF rules"
    return f"At THF{level}, Catseye THF has {known}, but not Bully."
