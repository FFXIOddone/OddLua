from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, Literal

from .itemstats import ItemConditionalMod, ItemLatent, ItemMod, ItemStatsIndex


ValuePolicy = Literal["positive", "negative", "nonzero"]


@dataclass(frozen=True)
class OpportunityDefinition:
    key: str
    title: str
    category: str
    action_window: str
    desired_outputs: tuple[str, ...]
    jobs: tuple[str, ...]
    trigger_mods: tuple[str, ...]
    notes: str
    value_policy: ValuePolicy = "positive"


@dataclass(frozen=True)
class OpportunityEvidence:
    item_id: int
    item_name: str
    source: str
    mods: tuple[str, ...]

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "itemId": self.item_id,
            "item": self.item_name,
            "source": self.source,
            "mods": list(self.mods),
        }


@dataclass(frozen=True)
class MechanicsOpportunity:
    key: str
    title: str
    category: str
    action_window: str
    desired_outputs: tuple[str, ...]
    jobs: tuple[str, ...]
    trigger_mods: tuple[str, ...]
    notes: str
    evidence: tuple[OpportunityEvidence, ...]

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "key": self.key,
            "title": self.title,
            "category": self.category,
            "actionWindow": self.action_window,
            "desiredOutputs": list(self.desired_outputs),
            "jobs": list(self.jobs),
            "triggerMods": list(self.trigger_mods),
            "notes": self.notes,
            "evidence": [
                evidence.manifest_metadata()
                for evidence in self.evidence
            ],
        }


ALL_JOBS = (
    "WAR",
    "MNK",
    "WHM",
    "BLM",
    "RDM",
    "THF",
    "PLD",
    "DRK",
    "BST",
    "BRD",
    "RNG",
    "SAM",
    "NIN",
    "DRG",
    "SMN",
    "BLU",
    "COR",
    "PUP",
    "DNC",
    "SCH",
    "GEO",
    "RUN",
)


MECHANICS_OPPORTUNITY_DEFINITIONS: tuple[OpportunityDefinition, ...] = (
    OpportunityDefinition(
        key="hp_bridge_swap",
        title="HP bridge swap",
        category="pool_bridge",
        action_window="before removing HP-positive or HP-conversion gear",
        desired_outputs=("avoid_current_hp_clamp_loss", "safe_aftercast"),
        jobs=ALL_JOBS,
        trigger_mods=("HP", "HPP", "CONVMPTOHP", "CONVHPTOMP"),
        notes="Equip alternate HP support before removing volatile HP gear so current HP never exceeds the intermediate max.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="mp_bridge_swap",
        title="MP bridge swap",
        category="pool_bridge",
        action_window="before removing MP-positive or MP-conversion gear",
        desired_outputs=("avoid_current_mp_clamp_loss", "safe_cast_cycle"),
        jobs=ALL_JOBS,
        trigger_mods=("MP", "MPP", "CONVMPTOHP", "CONVHPTOMP"),
        notes="Equip alternate MP support or spend MP before removing volatile MP gear.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="threshold_latent_toggle",
        title="HP/MP threshold latent toggle",
        category="threshold",
        action_window="when current HP or MP percent can be shaped before latent checks",
        desired_outputs=("latent_refresh", "latent_regen", "latent_stat_bonus"),
        jobs=ALL_JOBS,
        trigger_mods=("HP", "HPP", "MP", "MPP", "REFRESH", "REGEN"),
        notes="Use max-pool swaps to enter or leave latent threshold bands intentionally.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="stoneskin_snapshot",
        title="Stoneskin snapshot",
        category="spell_snapshot",
        action_window="Stoneskin midcast/resolution",
        desired_outputs=("larger_absorb_pool", "safer_idle_after_cast"),
        jobs=("RDM", "WHM", "SCH", "BLM", "GEO", "RUN"),
        trigger_mods=("STONESKIN_BONUS_HP", "ENHANCE", "MND"),
        notes="Wear Stoneskin bonus and enhancing stats for resolution, then drop unsafe pieces after the barrier is created.",
    ),
    OpportunityDefinition(
        key="mp_cost_avoidance",
        title="MP cost avoidance",
        category="spell_snapshot",
        action_window="spell cost calculation",
        desired_outputs=("free_spell_proc", "mp_sustain"),
        jobs=("WHM", "BLM", "RDM", "PLD", "DRK", "BRD", "NIN", "SMN", "BLU", "SCH", "GEO", "RUN"),
        trigger_mods=("NO_SPELL_MP_DEPLETION", "CONSERVE_MP", "BLACK_MAGIC_COST", "WHITE_MAGIC_COST", "DARK_MAGIC_COST"),
        notes="Wear cost-reduction or no-depletion gear only while the server calculates spell cost.",
    ),
    OpportunityDefinition(
        key="cure_to_mp_snapshot",
        title="Cure-to-MP snapshot",
        category="spell_snapshot",
        action_window="Cure final amount calculation",
        desired_outputs=("mp_return", "healing_sustain"),
        jobs=("WHM", "RDM", "SCH", "PLD"),
        trigger_mods=("CURE2MP_PERCENT", "CURE_POTENCY", "CURE_POTENCY_II"),
        notes="Equip Cure-to-MP gear when final cure amount is known; return to safer gear after resolution.",
    ),
    OpportunityDefinition(
        key="refresh_regen_tick_pulse",
        title="Refresh/Regen tick pulse",
        category="tick_pulse",
        action_window="server status-effect tick",
        desired_outputs=("mp_tick_gain", "hp_tick_gain"),
        jobs=ALL_JOBS,
        trigger_mods=("REFRESH", "REGEN", "HPHEAL", "MPHEAL"),
        notes="Pulse tick gear for server ticks instead of wearing unsafe sustain gear constantly.",
    ),
    OpportunityDefinition(
        key="negative_tick_avoidance",
        title="Negative tick avoidance",
        category="avoidance",
        action_window="before Refresh/Regen/down-tick processing",
        desired_outputs=("avoid_mp_drain", "avoid_hp_drain"),
        jobs=ALL_JOBS,
        trigger_mods=("REFRESH", "REGEN", "REFRESH_DOWN", "REGEN_DOWN"),
        notes="Remove weapon-drawn drains and harmful latent tick gear before the tick when the action window is over.",
        value_policy="negative",
    ),
    OpportunityDefinition(
        key="damage_to_mp_window",
        title="Damage-to-MP window",
        category="hit_window",
        action_window="expected incoming hit or Cover window",
        desired_outputs=("mp_return_from_damage", "tank_sustain"),
        jobs=("PLD", "RUN", "DRK", "WAR", "MNK"),
        trigger_mods=("ABSORB_DMG_TO_MP", "ABSORB_PHYSDMG_TO_MP", "COVER_TO_MP"),
        notes="Wear absorption gear only for expected damage events, then return to mitigation or output gear.",
    ),
    OpportunityDefinition(
        key="fast_cast_precast",
        title="Fast Cast precast split",
        category="precast_snapshot",
        action_window="spell start packet",
        desired_outputs=("shorter_cast", "interrupt_reliability", "recast_reduction"),
        jobs=("WHM", "BLM", "RDM", "PLD", "DRK", "BRD", "NIN", "SMN", "BLU", "SCH", "GEO", "RUN"),
        trigger_mods=("FASTCAST", "UFASTCAST", "QUICK_MAGIC", "SPELLINTERRUPT", "SPELL_INTERRUPT"),
        notes="Separate cast-start reliability from landing potency so one set does not water down the other.",
    ),
    OpportunityDefinition(
        key="enhancing_snapshot",
        title="Enhancing potency/duration snapshot",
        category="spell_snapshot",
        action_window="enhancing spell final power and duration",
        desired_outputs=("buff_potency", "buff_duration", "recast_efficiency"),
        jobs=("WHM", "RDM", "SCH", "PLD", "GEO", "RUN"),
        trigger_mods=("ENHANCE", "ENHANCING_MAGIC_DURATION", "ENHANCES_REFRESH", "REGEN_MULTIPLIER", "REGEN_BONUS", "PHALANX", "BARSPELL_AMOUNT", "AQUAVEIL_COUNT", "ENSPELL_DMG_PCT"),
        notes="Route Refresh, Regen, Phalanx, Barspells, Enspells, and Aquaveil independently.",
    ),
    OpportunityDefinition(
        key="enfeeble_snapshot",
        title="Enfeebling accuracy/duration split",
        category="spell_snapshot",
        action_window="enfeebling spell landing and duration",
        desired_outputs=("land_rate", "duration", "potency"),
        jobs=("RDM", "WHM", "BLM", "SCH", "GEO", "BRD"),
        trigger_mods=("ENFEEBLING", "MACC", "MND", "INT", "ENFEEBLE_DURATION", "ELEM_DEBUFF_DURATION"),
        notes="Pick magic accuracy against hard targets and duration/potency when landing is reliable.",
    ),
    OpportunityDefinition(
        key="elemental_nuke_snapshot",
        title="Elemental nuke and magic burst routing",
        category="spell_snapshot",
        action_window="spell damage calculation",
        desired_outputs=("magic_damage", "magic_accuracy", "elemental_affinity", "magic_burst_damage"),
        jobs=("BLM", "RDM", "SCH", "GEO", "NIN", "BLU", "DRK"),
        trigger_mods=("MATT", "MACC", "MAGIC_DAMAGE", "MAG_BURST_BONUS", "FIRE_STAFF_BONUS", "ICE_STAFF_BONUS", "WIND_STAFF_BONUS", "EARTH_STAFF_BONUS", "THUNDER_STAFF_BONUS", "WATER_STAFF_BONUS", "LIGHT_STAFF_BONUS", "DARK_STAFF_BONUS", "IRIDESCENCE"),
        notes="Score the exact element, day/weather, target resistance, and burst state.",
    ),
    OpportunityDefinition(
        key="weaponskill_snapshot",
        title="Weapon skill formula snapshot",
        category="action_snapshot",
        action_window="weapon skill execution",
        desired_outputs=("ws_damage", "ws_accuracy", "ftp_value"),
        jobs=("WAR", "MNK", "RDM", "THF", "PLD", "DRK", "BST", "RNG", "SAM", "NIN", "DRG", "BLU", "COR", "PUP", "DNC", "RUN"),
        trigger_mods=("WSDMG", "WSACC", "TP_BONUS", "STR", "DEX", "VIT", "AGI", "INT", "MND", "CHR", "CRITHITRATE", "CRIT_DMG_INCREASE"),
        notes="Use exact WS script WSC, hit count, crit flags, magical flags, and TP scaling.",
    ),
    OpportunityDefinition(
        key="ranged_split",
        title="Ranged preshot/midshot split",
        category="action_snapshot",
        action_window="ranged attack start and ranged damage resolution",
        desired_outputs=("snapshot_speed", "ranged_damage", "ranged_accuracy", "ammo_efficiency"),
        jobs=("RNG", "COR"),
        trigger_mods=("SNAPSHOT", "RAPID_SHOT", "RACC", "RATT", "STORETP", "RECYCLE", "TRUE_SHOT"),
        notes="Keep Snapshot/Rapid Shot in preshot and damage/accuracy/Store TP in midshot.",
    ),
    OpportunityDefinition(
        key="store_tp_breakpoint",
        title="Store TP breakpoint",
        category="breakpoint",
        action_window="TP phase set building",
        desired_outputs=("rounds_to_ws", "tp_cycle_damage"),
        jobs=("WAR", "MNK", "THF", "PLD", "DRK", "BST", "RNG", "SAM", "NIN", "DRG", "BLU", "COR", "PUP", "DNC", "RUN"),
        trigger_mods=("STORETP", "TP_BONUS", "REGAIN"),
        notes="Value Store TP by whether it changes hits or rounds to next WS.",
    ),
    OpportunityDefinition(
        key="haste_delay_breakpoint",
        title="Haste, Dual Wield, and Martial Arts breakpoint",
        category="breakpoint",
        action_window="TP phase set building",
        desired_outputs=("delay_reduction", "tp_return_efficiency", "avoid_dw_overcap"),
        jobs=("WAR", "MNK", "THF", "BST", "RNG", "NIN", "BLU", "COR", "PUP", "DNC"),
        trigger_mods=("HASTE_GEAR", "DUAL_WIELD", "MARTIAL_ARTS", "DELAY", "DELAYP"),
        notes="Too much delay reduction or Dual Wield can be wasted or reduce TP-cycle quality.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="tp_feed_reduction",
        title="TP feed reduction",
        category="defense",
        action_window="melee/ranged hit resolution",
        desired_outputs=("lower_enemy_tp_feed", "safer_tanking"),
        jobs=("MNK", "NIN", "DNC", "THF", "PUP", "RUN", "PLD"),
        trigger_mods=("SUBTLE_BLOW", "SUBTLE_BLOW_II", "INHIBIT_TP", "TANDEM_BLOW"),
        notes="When enemy TP moves are the danger, TP-feed reduction can beat raw DPS.",
    ),
    OpportunityDefinition(
        key="enmity_snapshot",
        title="Enmity spike snapshot",
        category="action_snapshot",
        action_window="JA/spell enmity event",
        desired_outputs=("ce_ve_gain", "tank_control"),
        jobs=("PLD", "RUN", "WAR", "NIN", "RDM", "WHM", "SCH", "BLU"),
        trigger_mods=("ENMITY", "ENMITY_LOSS_REDUCTION", "CURE_POTENCY"),
        notes="Use enmity gear for Provoke, Flash, cures, and tank JAs, then return to mitigation.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="shield_block_window",
        title="Shield block window",
        category="defense",
        action_window="expected incoming physical hit",
        desired_outputs=("block_rate", "block_damage_reduction", "survival"),
        jobs=("PLD", "RUN", "WAR", "RDM"),
        trigger_mods=("SHIELD", "SHIELDBLOCKRATE", "BLOCK_RATE", "REPRISAL_BLOCK_RATE", "SHIELD_DEF_BONUS"),
        notes="Shield skill and block modifiers need separate value from generic defense or PDT.",
    ),
    OpportunityDefinition(
        key="waltz_snapshot",
        title="Waltz snapshot",
        category="job_action_snapshot",
        action_window="Dancer Waltz execution",
        desired_outputs=("waltz_healing", "tp_efficiency", "recast_efficiency"),
        jobs=("DNC",),
        trigger_mods=("WALTZ_POTENCY", "WALTZ_POTENTCY", "WALTZ_COST", "WALTZ_DELAY", "CHR", "VIT"),
        notes="DNC healing should not reuse Cure spell scoring.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="step_flourish_snapshot",
        title="Step and Flourish snapshot",
        category="job_action_snapshot",
        action_window="Step or Flourish execution",
        desired_outputs=("step_land_rate", "finishing_moves", "flourish_damage"),
        jobs=("DNC",),
        trigger_mods=("STEP_ACCURACY", "WALTZ_DELAY", "CHR", "DEX", "ACC"),
        notes="DNC utility actions need accuracy and finishing-move context.",
    ),
    OpportunityDefinition(
        key="quick_draw_snapshot",
        title="Quick Draw snapshot",
        category="job_action_snapshot",
        action_window="Quick Draw execution",
        desired_outputs=("quick_draw_damage", "quick_draw_accuracy", "dot_amplification"),
        jobs=("COR",),
        trigger_mods=("QUICK_DRAW_DMG", "QUICK_DRAW_DMG_PERCENT", "QUICK_DRAW_MACC", "MATT", "MACC", "MAGIC_DAMAGE"),
        notes="Quick Draw is a magic action with card/ammo and element-specific concerns.",
    ),
    OpportunityDefinition(
        key="phantom_roll_snapshot",
        title="Phantom Roll snapshot",
        category="job_action_snapshot",
        action_window="Phantom Roll execution",
        desired_outputs=("roll_potency", "roll_duration", "recast_efficiency"),
        jobs=("COR",),
        trigger_mods=("PHANTOM_ROLL", "PHANTOM_DURATION", "PHANTOM_RECAST", "LUCKY_ROLL", "BUST_DURATION"),
        notes="Roll sets should optimize the support action, then drop back to combat or idle.",
    ),
    OpportunityDefinition(
        key="song_snapshot",
        title="Song instrument/duration/accuracy split",
        category="spell_snapshot",
        action_window="Bard song cast and landing",
        desired_outputs=("song_count", "song_duration", "song_accuracy", "song_potency"),
        jobs=("BRD",),
        trigger_mods=("SINGING", "WIND_INSTRUMENT", "STRING_INSTRUMENT", "ALL_SONGS_EFFECT", "SONG_DURATION", "SONG_SPELLCASTING_TIME", "MACC"),
        notes="Buff songs and debuff songs should not use the same scoring surface.",
    ),
    OpportunityDefinition(
        key="geomancy_snapshot",
        title="Geomancy and luopan split",
        category="spell_snapshot",
        action_window="Geomancy cast, luopan survival, and enfeebling landing",
        desired_outputs=("geomancy_potency", "luopan_survival", "magic_accuracy"),
        jobs=("GEO",),
        trigger_mods=("GEOMANCY_SKILL", "HANDBELL_SKILL", "GEOMANCY_BONUS", "LUOPAN_REGEN", "LUOPAN_DMG_TAKEN", "MACC"),
        notes="Separate handbell/geomancy skill, luopan durability, and caster magic accuracy.",
    ),
    OpportunityDefinition(
        key="avatar_perp_bloodpact_split",
        title="Avatar perpetuation and Blood Pact split",
        category="pet_action_snapshot",
        action_window="avatar idle or Blood Pact execution",
        desired_outputs=("avatar_sustain", "blood_pact_damage", "blood_pact_accuracy"),
        jobs=("SMN",),
        trigger_mods=("AVATAR_PERPETUATION", "PERPETUATION_REDUCTION", "BP_DAMAGE", "BLOOD_BOON", "SUMMONING_MAGIC", "PET_MAB", "PET_MACC", "PET_ACC", "PET_ATK"),
        notes="SMN idle and Blood Pact actions need different master and pet gear priorities.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="pet_action_snapshot",
        title="Pet action snapshot",
        category="pet_action_snapshot",
        action_window="pet physical, magical, or tank action",
        desired_outputs=("pet_damage", "pet_accuracy", "pet_survival"),
        jobs=("BST", "PUP", "SMN", "DRG"),
        trigger_mods=("PET_ACC", "PET_ATK", "PET_MAB", "PET_MACC", "PET_STORETP", "PET_HASTE", "PET_DEF", "PET_DMG_TAKEN", "PET_REGEN", "BP_DAMAGE"),
        notes="Master gear can be optimal only if it improves the pet action currently being executed.",
    ),
    OpportunityDefinition(
        key="blue_magic_split",
        title="Blue Magic physical/magical/healing split",
        category="spell_snapshot",
        action_window="Blue Magic spell resolution",
        desired_outputs=("blue_physical_damage", "blue_magical_damage", "blue_accuracy", "blue_healing"),
        jobs=("BLU",),
        trigger_mods=("BLUE", "BLUE_MAGIC_SKILL", "MATT", "MACC", "ATT", "ACC", "STR", "DEX", "VIT", "MND"),
        notes="BLU spells are not one style; each spell family needs separate formula routing.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="ninjutsu_split",
        title="Ninjutsu shadow and elemental split",
        category="spell_snapshot",
        action_window="Ninjutsu cast and resolution",
        desired_outputs=("shadow_recast", "ninjutsu_damage", "ninjutsu_accuracy"),
        jobs=("NIN",),
        trigger_mods=("NINJUTSU", "NINJUTSU_POWER", "NINJUTSU_RECAST", "MATT", "MACC", "FASTCAST"),
        notes="Utsusemi recast/interruption and elemental wheel damage/accuracy need separate sets.",
    ),
    OpportunityDefinition(
        key="elemental_defense_window",
        title="Elemental defense window",
        category="defense",
        action_window="expected incoming elemental damage or RUN ability window",
        desired_outputs=("elemental_sdt_reduction", "magic_survival"),
        jobs=("RUN", "PLD", "RDM", "WHM", "SCH", "GEO"),
        trigger_mods=("FIRE_MEVA", "ICE_MEVA", "WIND_MEVA", "EARTH_MEVA", "THUNDER_MEVA", "WATER_MEVA", "LIGHT_MEVA", "DARK_MEVA", "MDEF", "MEVA", "DMGMAGIC"),
        notes="Elemental defense should be selected against known incoming element and target profile.",
        value_policy="nonzero",
    ),
    OpportunityDefinition(
        key="treasure_hunter_tag",
        title="Treasure Hunter tag window",
        category="utility_snapshot",
        action_window="claim, first hit, or TH upgrade window",
        desired_outputs=("drop_rate_tag", "combat_recovery_after_tag"),
        jobs=("THF",),
        trigger_mods=("TREASURE_HUNTER",),
        notes="Wear TH only for the tag/upgrade window unless the item also wins combat scoring.",
    ),
    OpportunityDefinition(
        key="movement_latent_routing",
        title="Movement latent routing",
        category="utility",
        action_window="travel/non-combat movement",
        desired_outputs=("movement_speed", "avoid_combat_pollution"),
        jobs=ALL_JOBS,
        trigger_mods=("MOVE_SPEED_GEAR_BONUS", "MOVE_SPEED_STACKABLE", "MOVE_SPEED_QUICKENING", "MOVE_SPEED_OVERRIDE", "MOUNT_MOVE"),
        notes="Keep city/night/dusk/mount movement gear out of combat and idle scoring unless travel is selected.",
    ),
    OpportunityDefinition(
        key="food_cap_breakpoint",
        title="Food cap breakpoint",
        category="consumable",
        action_window="food selection before content",
        desired_outputs=("cap_aware_food_value", "long_session_value"),
        jobs=ALL_JOBS,
        trigger_mods=("FOOD_HPP", "FOOD_HP_CAP", "FOOD_MPP", "FOOD_MP_CAP", "FOOD_ATTP", "FOOD_ATT_CAP", "FOOD_ACCP", "FOOD_ACC_CAP", "FOOD_DURATION"),
        notes="Food percent and cap mods must be scored against current stats and expected content duration.",
        value_policy="nonzero",
    ),
)


def discover_mechanics_opportunities(
    item_stats: ItemStatsIndex,
    *,
    include_empty: bool = False,
    evidence_limit: int | None = 8,
) -> tuple[MechanicsOpportunity, ...]:
    opportunities: list[MechanicsOpportunity] = []
    for definition in MECHANICS_OPPORTUNITY_DEFINITIONS:
        evidence = _evidence_for_definition(
            item_stats,
            definition,
            evidence_limit=evidence_limit,
        )
        if evidence or include_empty:
            opportunities.append(
                MechanicsOpportunity(
                    key=definition.key,
                    title=definition.title,
                    category=definition.category,
                    action_window=definition.action_window,
                    desired_outputs=definition.desired_outputs,
                    jobs=definition.jobs,
                    trigger_mods=definition.trigger_mods,
                    notes=definition.notes,
                    evidence=evidence,
                )
            )
    return tuple(opportunities)


def mechanics_opportunity_manifest(item_stats: ItemStatsIndex | None) -> dict[str, object]:
    if item_stats is None:
        return {
            "definitionCount": len(MECHANICS_OPPORTUNITY_DEFINITIONS),
            "detectedCount": 0,
            "opportunities": [],
        }
    opportunities = discover_mechanics_opportunities(item_stats)
    return {
        "definitionCount": len(MECHANICS_OPPORTUNITY_DEFINITIONS),
        "detectedCount": len(opportunities),
        "opportunities": [
            opportunity.manifest_metadata()
            for opportunity in opportunities
        ],
    }


def _evidence_for_definition(
    item_stats: ItemStatsIndex,
    definition: OpportunityDefinition,
    *,
    evidence_limit: int | None,
) -> tuple[OpportunityEvidence, ...]:
    evidence: list[OpportunityEvidence] = []
    direct_mods = _mods_by_item_matching(
        item_stats.mods_by_item_id,
        definition.trigger_mods,
        definition.value_policy,
    )
    evidence.extend(
        _make_evidence(item_stats, "item_mods", direct_mods)
    )

    latent_mods = _latents_by_item_matching(
        item_stats.latents_by_item_id,
        definition.trigger_mods,
        definition.value_policy,
    )
    evidence.extend(
        _make_evidence(item_stats, "item_latents", latent_mods)
    )

    conditional_mods = _conditionals_by_item_matching(
        item_stats.conditional_mods_by_item_id,
        definition.trigger_mods,
        definition.value_policy,
    )
    evidence.extend(
        _make_evidence(item_stats, "item_conditional_mods", conditional_mods)
    )

    pet_mods = _mods_by_item_matching(
        item_stats.pet_mods_by_item_id,
        definition.trigger_mods,
        definition.value_policy,
    )
    evidence.extend(
        _make_evidence(item_stats, "item_mods_pet", pet_mods)
    )

    food_mods = _mods_by_item_matching(
        item_stats.food_mods_by_item_id,
        definition.trigger_mods,
        definition.value_policy,
    )
    evidence.extend(
        _make_evidence(item_stats, "food_effect_mods", food_mods)
    )

    unique: dict[tuple[int, str], OpportunityEvidence] = {}
    for item_evidence in evidence:
        key = (item_evidence.item_id, item_evidence.source)
        if key not in unique:
            unique[key] = item_evidence
    values = tuple(unique.values())
    if evidence_limit is None:
        return values
    return values[:evidence_limit]


def _mods_by_item_matching(
    mods_by_item_id: dict[int, tuple[ItemMod, ...]],
    trigger_mods: tuple[str, ...],
    value_policy: ValuePolicy,
) -> dict[int, tuple[str, ...]]:
    trigger_set = set(trigger_mods)
    matches: dict[int, tuple[str, ...]] = {}
    for item_id, mods in mods_by_item_id.items():
        mod_text = tuple(
            _mod_text(mod.name, mod.value)
            for mod in mods
            if mod.name in trigger_set and _value_matches(mod.value, value_policy)
        )
        if mod_text:
            matches[item_id] = mod_text
    return matches


def _latents_by_item_matching(
    latents_by_item_id: dict[int, tuple[ItemLatent, ...]],
    trigger_mods: tuple[str, ...],
    value_policy: ValuePolicy,
) -> dict[int, tuple[str, ...]]:
    trigger_set = set(trigger_mods)
    matches: dict[int, tuple[str, ...]] = {}
    for item_id, latents in latents_by_item_id.items():
        mod_text = tuple(
            _mod_text(latent.name, latent.value)
            for latent in latents
            if latent.name in trigger_set and _value_matches(latent.value, value_policy)
        )
        if mod_text:
            matches[item_id] = mod_text
    return matches


def _conditionals_by_item_matching(
    conditional_mods_by_item_id: dict[int, tuple[ItemConditionalMod, ...]],
    trigger_mods: tuple[str, ...],
    value_policy: ValuePolicy,
) -> dict[int, tuple[str, ...]]:
    trigger_set = set(trigger_mods)
    matches: dict[int, tuple[str, ...]] = {}
    for item_id, conditional_mods in conditional_mods_by_item_id.items():
        mod_text = tuple(
            _mod_text(mod.name, mod.value)
            for mod in conditional_mods
            if mod.name in trigger_set and _value_matches(mod.value, value_policy)
        )
        if mod_text:
            matches[item_id] = mod_text
    return matches


def _make_evidence(
    item_stats: ItemStatsIndex,
    source: str,
    mods_by_item_id: dict[int, tuple[str, ...]],
) -> list[OpportunityEvidence]:
    evidence: list[OpportunityEvidence] = []
    for item_id, mods in sorted(mods_by_item_id.items()):
        evidence.append(
            OpportunityEvidence(
                item_id=item_id,
                item_name=_item_name(item_stats, item_id),
                source=source,
                mods=mods,
            )
        )
    return evidence


def _item_name(item_stats: ItemStatsIndex, item_id: int) -> str:
    equipment = item_stats.equipment_for_item_id(item_id)
    if equipment is not None:
        return equipment.name
    return f"item_{item_id}"


def _value_matches(value: int, value_policy: ValuePolicy) -> bool:
    if value_policy == "positive":
        return value > 0
    if value_policy == "negative":
        return value < 0
    return value != 0


def _mod_text(name: str, value: int) -> str:
    return f"{name}{value:+d}"
