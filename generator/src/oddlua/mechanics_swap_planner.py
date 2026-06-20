from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Mapping

from .gearexport import GearItem
from .itemstats import ItemConditionalMod, ItemLatent, ItemMod, ItemStatsIndex


SLOT_ORDER = (
    "Main",
    "Sub",
    "Range",
    "Ammo",
    "Head",
    "Body",
    "Hands",
    "Legs",
    "Feet",
    "Neck",
    "Waist",
    "Ear1",
    "Ear2",
    "Ring1",
    "Ring2",
    "Back",
)

BASELINE_SET_CANDIDATES = (
    "Aftercast",
    "Idle",
    "PhysicalIdle",
    "IdleRefresh",
    "Damage",
    "Melt",
)

UTILITY_TRANSITION_SET_NAMES = {
    "Craft",
    "Crafting",
}

UTILITY_TRANSITION_SET_PREFIXES = (
    "Movement",
)

CONVERSION_POOL_MODS = {
    "CONVMPTOHP",
    "CONVHPTOMP",
}

NEGATIVE_TICK_MODS = {
    "REFRESH",
    "REGEN",
    "REFRESH_DOWN",
    "REGEN_DOWN",
}
PLANNER_VERSION = 2


@dataclass(frozen=True)
class PoolContribution:
    slot: str
    item_id: int
    item_name: str
    hp_flat: int = 0
    hp_percent: int = 0
    mp_flat: int = 0
    mp_percent: int = 0
    conversions: tuple[str, ...] = tuple()
    evidence: tuple[str, ...] = tuple()

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "slot": self.slot,
            "itemId": self.item_id,
            "item": self.item_name,
            "hpFlat": self.hp_flat,
            "hpPercent": self.hp_percent,
            "mpFlat": self.mp_flat,
            "mpPercent": self.mp_percent,
            "conversions": list(self.conversions),
            "evidence": list(self.evidence),
        }


@dataclass(frozen=True)
class MechanicsSwapAction:
    key: str
    phase: str
    slot: str
    item_id: int
    item_name: str
    reason: str

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "key": self.key,
            "phase": self.phase,
            "slot": self.slot,
            "itemId": self.item_id,
            "item": self.item_name,
            "reason": self.reason,
        }


@dataclass(frozen=True)
class MechanicsTransitionPlan:
    source_set_name: str
    target_set_name: str
    actions: tuple[MechanicsSwapAction, ...]
    warnings: tuple[str, ...]
    pool_summaries: dict[str, dict[str, int]]

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "sourceSet": self.source_set_name,
            "targetSet": self.target_set_name,
            "actions": [
                action.manifest_metadata()
                for action in self.actions
            ],
            "warnings": list(self.warnings),
            "poolSummaries": self.pool_summaries,
        }


def build_transition_swap_plan(
    *,
    source_set_name: str,
    target_set_name: str,
    source_slots: Mapping[str, GearItem],
    target_slots: Mapping[str, GearItem],
    item_stats: ItemStatsIndex,
) -> MechanicsTransitionPlan:
    source_contributions = {
        slot: _pool_contribution(slot, item, item_stats)
        for slot, item in source_slots.items()
    }
    target_contributions = {
        slot: _pool_contribution(slot, item, item_stats)
        for slot, item in target_slots.items()
    }
    pool_summaries = {
        "HP": _pool_summary(source_contributions, target_contributions, "HP"),
        "MP": _pool_summary(source_contributions, target_contributions, "MP"),
    }
    warnings = _transition_warnings(source_contributions, target_contributions, pool_summaries)

    ordered_actions: list[tuple[int, int, MechanicsSwapAction]] = []
    for slot in _ordered_slots(target_slots):
        source = source_contributions.get(slot)
        target = target_contributions[slot]
        phase, priority = _phase_for_contribution(source, target)
        ordered_actions.append(
            (
                priority,
                _slot_rank(slot),
                MechanicsSwapAction(
                    key=_action_key_for_phase(phase),
                    phase=phase,
                    slot=slot,
                    item_id=target.item_id,
                    item_name=target.item_name,
                    reason=_reason_for_contribution(source, target),
                ),
            )
        )

    actions = tuple(
        action
        for _, _, action in sorted(ordered_actions, key=lambda row: (row[0], row[1]))
    )
    return MechanicsTransitionPlan(
        source_set_name=source_set_name,
        target_set_name=target_set_name,
        actions=actions + plan_negative_tick_avoidance(
            set_name=target_set_name,
            slots=target_slots,
            item_stats=item_stats,
        ),
        warnings=warnings,
        pool_summaries=pool_summaries,
    )


def plan_negative_tick_avoidance(
    *,
    set_name: str,
    slots: Mapping[str, GearItem],
    item_stats: ItemStatsIndex,
) -> tuple[MechanicsSwapAction, ...]:
    actions: list[MechanicsSwapAction] = []
    for slot in _ordered_slots(slots):
        item = slots[slot]
        negative_mods = _negative_tick_mods(item.id, item_stats)
        if not negative_mods:
            continue
        actions.append(
            MechanicsSwapAction(
                key="negative_tick_avoidance",
                phase="remove_before_tick",
                slot=slot,
                item_id=item.id,
                item_name=item.name,
                reason=(
                    f"{set_name} equips {item.name} with negative tick mods "
                    + ", ".join(negative_mods)
                ),
            )
        )
    return tuple(actions)


def mechanics_swap_plan_manifest(
    selected: Mapping[str, Mapping[str, object]],
    item_stats: ItemStatsIndex | None,
) -> dict[str, object]:
    if item_stats is None or not selected:
        return {
            "loaded": False,
            "plannerVersion": PLANNER_VERSION,
            "baselineSet": "",
            "supportedOpportunities": [
                "hp_bridge_swap",
                "mp_bridge_swap",
                "negative_tick_avoidance",
            ],
            "transitions": {},
            "skippedTransitions": {},
        }

    baseline_set_name = _baseline_set_name(selected)
    baseline_slots = _slot_items(selected[baseline_set_name])
    transitions: dict[str, object] = {}
    skipped_transitions: dict[str, str] = {}
    for set_name in selected:
        if set_name == baseline_set_name:
            continue
        skip_reason = _skip_reason_for_transition(set_name)
        if skip_reason:
            skipped_transitions[set_name] = skip_reason
            continue
        target_slots = _slot_items(selected[set_name])
        if not target_slots:
            continue
        transitions[set_name] = build_transition_swap_plan(
            source_set_name=baseline_set_name,
            target_set_name=set_name,
            source_slots=baseline_slots,
            target_slots=target_slots,
            item_stats=item_stats,
        ).manifest_metadata()

    return {
        "loaded": True,
        "plannerVersion": PLANNER_VERSION,
        "baselineSet": baseline_set_name,
        "supportedOpportunities": [
            "hp_bridge_swap",
            "mp_bridge_swap",
            "negative_tick_avoidance",
        ],
        "transitions": transitions,
        "skippedTransitions": skipped_transitions,
    }


def _pool_contribution(slot: str, item: GearItem, item_stats: ItemStatsIndex) -> PoolContribution:
    hp_flat = 0
    hp_percent = 0
    mp_flat = 0
    mp_percent = 0
    conversions: list[str] = []
    evidence: list[str] = []
    for name, value in _pool_mods(item.id, item_stats):
        if name == "HP":
            hp_flat += value
        elif name == "HPP":
            hp_percent += value
        elif name == "MP":
            mp_flat += value
        elif name == "MPP":
            mp_percent += value
        elif name in CONVERSION_POOL_MODS:
            conversions.append(f"{name}{value:+d}")
        else:
            continue
        evidence.append(f"{name}{value:+d}")
    return PoolContribution(
        slot=slot,
        item_id=item.id,
        item_name=item.name,
        hp_flat=hp_flat,
        hp_percent=hp_percent,
        mp_flat=mp_flat,
        mp_percent=mp_percent,
        conversions=tuple(conversions),
        evidence=tuple(evidence),
    )


def _pool_mods(item_id: int, item_stats: ItemStatsIndex) -> tuple[tuple[str, int], ...]:
    rows: list[tuple[str, int]] = []
    for mod in item_stats.mods_for_item_id(item_id):
        if _is_pool_mod(mod.name):
            rows.append((mod.name, mod.value))
    for latent in item_stats.latents_for_item_id(item_id):
        if _is_pool_mod(latent.name):
            rows.append((latent.name, latent.value))
    for conditional in item_stats.conditional_mods_for_item_id(item_id):
        if _is_pool_mod(conditional.name):
            rows.append((conditional.name, conditional.value))
    return tuple(rows)


def _is_pool_mod(name: str) -> bool:
    return name in {"HP", "HPP", "MP", "MPP"} or name in CONVERSION_POOL_MODS


def _negative_tick_mods(item_id: int, item_stats: ItemStatsIndex) -> tuple[str, ...]:
    rows: list[str] = []
    for mod in item_stats.mods_for_item_id(item_id):
        if _is_negative_tick_mod(mod):
            rows.append(f"{mod.name}{mod.value:+d}")
    for latent in item_stats.latents_for_item_id(item_id):
        if _is_negative_tick_mod(latent):
            rows.append(f"{latent.name}{latent.value:+d}")
    for conditional in item_stats.conditional_mods_for_item_id(item_id):
        if _is_negative_tick_mod(conditional):
            rows.append(f"{conditional.name}{conditional.value:+d}")
    return tuple(rows)


def _is_negative_tick_mod(row: ItemMod | ItemLatent | ItemConditionalMod) -> bool:
    if row.name not in NEGATIVE_TICK_MODS:
        return False
    return row.value < 0


def _pool_summary(
    source_contributions: Mapping[str, PoolContribution],
    target_contributions: Mapping[str, PoolContribution],
    pool: str,
) -> dict[str, int]:
    if pool == "HP":
        return {
            "sourceFlat": sum(row.hp_flat for row in source_contributions.values()),
            "targetFlat": sum(row.hp_flat for row in target_contributions.values()),
            "sourcePercent": sum(row.hp_percent for row in source_contributions.values()),
            "targetPercent": sum(row.hp_percent for row in target_contributions.values()),
        }
    return {
        "sourceFlat": sum(row.mp_flat for row in source_contributions.values()),
        "targetFlat": sum(row.mp_flat for row in target_contributions.values()),
        "sourcePercent": sum(row.mp_percent for row in source_contributions.values()),
        "targetPercent": sum(row.mp_percent for row in target_contributions.values()),
    }


def _transition_warnings(
    source_contributions: Mapping[str, PoolContribution],
    target_contributions: Mapping[str, PoolContribution],
    pool_summaries: Mapping[str, Mapping[str, int]],
) -> tuple[str, ...]:
    warnings: list[str] = []
    for pool, summary in pool_summaries.items():
        prefix = pool.lower()
        if summary["targetFlat"] < summary["sourceFlat"] or summary["targetPercent"] < summary["sourcePercent"]:
            warnings.append(f"final_{prefix}_pool_lower")
        if _requires_runtime_pool_probe(source_contributions, target_contributions, summary):
            warnings.append(f"{prefix}_percent_or_conversion_requires_runtime_probe")
    return tuple(dict.fromkeys(warnings))


def _requires_runtime_pool_probe(
    source_contributions: Mapping[str, PoolContribution],
    target_contributions: Mapping[str, PoolContribution],
    summary: Mapping[str, int],
) -> bool:
    if _has_conversions(source_contributions, target_contributions):
        return True
    percent_changed = summary["sourcePercent"] != summary["targetPercent"]
    if not percent_changed:
        return False
    return summary["targetFlat"] < summary["sourceFlat"] or summary["targetPercent"] < summary["sourcePercent"]


def _has_conversions(
    source_contributions: Mapping[str, PoolContribution],
    target_contributions: Mapping[str, PoolContribution],
) -> bool:
    return any(
        row.conversions
        for row in tuple(source_contributions.values()) + tuple(target_contributions.values())
    )


def _phase_for_contribution(
    source: PoolContribution | None,
    target: PoolContribution,
) -> tuple[str, int]:
    source = source or PoolContribution(slot=target.slot, item_id=0, item_name="")
    gain = (
        target.hp_flat > source.hp_flat
        or target.hp_percent > source.hp_percent
        or target.mp_flat > source.mp_flat
        or target.mp_percent > source.mp_percent
    )
    loss = (
        target.hp_flat < source.hp_flat
        or target.hp_percent < source.hp_percent
        or target.mp_flat < source.mp_flat
        or target.mp_percent < source.mp_percent
    )
    if gain and not loss:
        return "equip_pool_gain", 0
    if gain and loss:
        return "equip_pool_mixed", 1
    if loss:
        return "equip_pool_loss", 3
    return "equip_target", 2


def _action_key_for_phase(phase: str) -> str:
    if phase in {"equip_pool_gain", "equip_pool_mixed", "equip_pool_loss"}:
        return "pool_bridge_transition"
    return "equip_target"


def _reason_for_contribution(
    source: PoolContribution | None,
    target: PoolContribution,
) -> str:
    source = source or PoolContribution(slot=target.slot, item_id=0, item_name="")
    deltas = {
        "HP": target.hp_flat - source.hp_flat,
        "HPP": target.hp_percent - source.hp_percent,
        "MP": target.mp_flat - source.mp_flat,
        "MPP": target.mp_percent - source.mp_percent,
    }
    formatted = [
        f"{name}{value:+d}"
        for name, value in deltas.items()
        if value
    ]
    if target.conversions:
        formatted.extend(target.conversions)
    if formatted:
        return "pool delta " + ", ".join(formatted)
    return "ordinary target equip"


def _ordered_slots(slots: Mapping[str, object]) -> tuple[str, ...]:
    known = [
        slot
        for slot in SLOT_ORDER
        if slot in slots
    ]
    extras = sorted(slot for slot in slots if slot not in SLOT_ORDER)
    return tuple(known + extras)


def _slot_rank(slot: str) -> int:
    try:
        return SLOT_ORDER.index(slot)
    except ValueError:
        return len(SLOT_ORDER)


def _baseline_set_name(selected: Mapping[str, Mapping[str, object]]) -> str:
    for set_name in BASELINE_SET_CANDIDATES:
        if set_name in selected:
            return set_name
    return next(iter(selected))


def _skip_reason_for_transition(set_name: str) -> str:
    if set_name in UTILITY_TRANSITION_SET_NAMES:
        return "utility_set"
    if any(set_name.startswith(prefix) for prefix in UTILITY_TRANSITION_SET_PREFIXES):
        return "utility_set"
    return ""


def _slot_items(slot_map: Mapping[str, object]) -> dict[str, GearItem]:
    items: dict[str, GearItem] = {}
    for slot, value in slot_map.items():
        item = _extract_item(value)
        if item is not None:
            items[slot] = item
    return items


def _extract_item(value: object) -> GearItem | None:
    if isinstance(value, GearItem):
        return value
    item = getattr(value, "item", None)
    if isinstance(item, GearItem):
        return item
    if isinstance(value, Mapping):
        candidate = value.get("item")
        if isinstance(candidate, GearItem):
            return candidate
    return None
