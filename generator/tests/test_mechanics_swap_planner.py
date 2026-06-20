from pathlib import Path
from types import SimpleNamespace
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.gearexport import GearItem
from oddlua.itemstats import EquipmentStats, ItemLatent, ItemMod, ItemStatsIndex
from oddlua.mechanics_swap_planner import (
    build_transition_swap_plan,
    mechanics_swap_plan_manifest,
    plan_negative_tick_avoidance,
)


def test_pool_bridge_transition_equips_target_pool_gain_before_pool_loss() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "HP Vest"),
            1001: _equipment(1001, "Nuke Robe"),
            1002: _equipment(1002, "Bridge Ring"),
        },
        mods_by_item_id={
            1000: (ItemMod(2, "HP", 100),),
            1002: (ItemMod(2, "HP", 120),),
        },
    )

    plan = build_transition_swap_plan(
        source_set_name="Aftercast",
        target_set_name="Nuke",
        source_slots={
            "Body": _gear_item(1000, "HP Vest", "Body"),
        },
        target_slots={
            "Body": _gear_item(1001, "Nuke Robe", "Body"),
            "Ring1": _gear_item(1002, "Bridge Ring", "Ring"),
        },
        item_stats=item_stats,
    )

    action_slots = [action.slot for action in plan.actions]
    assert action_slots.index("Ring1") < action_slots.index("Body")
    assert plan.actions[0].phase == "equip_pool_gain"
    assert plan.actions[-1].phase == "equip_pool_loss"
    assert plan.pool_summaries["HP"]["sourceFlat"] == 100
    assert plan.pool_summaries["HP"]["targetFlat"] == 120
    assert "final_hp_pool_lower" not in plan.warnings


def test_pool_bridge_transition_flags_final_drop_and_percent_probe() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "Percent Vest"),
            1001: _equipment(1001, "Plain Robe"),
        },
        mods_by_item_id={
            1000: (ItemMod(3, "HPP", 10),),
        },
    )

    plan = build_transition_swap_plan(
        source_set_name="Aftercast",
        target_set_name="Nuke",
        source_slots={"Body": _gear_item(1000, "Percent Vest", "Body")},
        target_slots={"Body": _gear_item(1001, "Plain Robe", "Body")},
        item_stats=item_stats,
    )

    assert "final_hp_pool_lower" in plan.warnings
    assert "hp_percent_or_conversion_requires_runtime_probe" in plan.warnings


def test_pool_bridge_transition_does_not_warn_for_harmless_percent_pool_gain() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "Penalty Ring"),
            1001: _equipment(1001, "HP Ring"),
        },
        mods_by_item_id={
            1000: (ItemMod(3, "HPP", -10),),
            1001: (ItemMod(2, "HP", 50),),
        },
    )

    plan = build_transition_swap_plan(
        source_set_name="Aftercast",
        target_set_name="Safe",
        source_slots={"Ring1": _gear_item(1000, "Penalty Ring", "Ring")},
        target_slots={"Ring1": _gear_item(1001, "HP Ring", "Ring")},
        item_stats=item_stats,
    )

    assert plan.pool_summaries["HP"]["targetFlat"] > plan.pool_summaries["HP"]["sourceFlat"]
    assert plan.pool_summaries["HP"]["targetPercent"] > plan.pool_summaries["HP"]["sourcePercent"]
    assert "final_hp_pool_lower" not in plan.warnings
    assert "hp_percent_or_conversion_requires_runtime_probe" not in plan.warnings


def test_negative_tick_avoidance_marks_harmful_refresh_items() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={2000: _equipment(2000, "Mindmeld Kris")},
        mods_by_item_id={},
        latents_by_item_id={
            2000: (ItemLatent(2000, 369, "REFRESH", -10, 56, 0),),
        },
    )

    actions = plan_negative_tick_avoidance(
        set_name="Idle",
        slots={"Main": _gear_item(2000, "Mindmeld Kris", "Main")},
        item_stats=item_stats,
    )

    assert len(actions) == 1
    assert actions[0].key == "negative_tick_avoidance"
    assert actions[0].slot == "Main"
    assert "REFRESH-10" in actions[0].reason


def test_mechanics_swap_plan_manifest_uses_aftercast_baseline() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "HP Vest"),
            1001: _equipment(1001, "Nuke Robe"),
            1002: _equipment(1002, "Bridge Ring"),
        },
        mods_by_item_id={
            1000: (ItemMod(2, "HP", 100),),
            1002: (ItemMod(2, "HP", 120),),
        },
    )
    selected = {
        "Aftercast": {
            "Body": SimpleNamespace(item=_gear_item(1000, "HP Vest", "Body")),
        },
        "Nuke": {
            "Body": SimpleNamespace(item=_gear_item(1001, "Nuke Robe", "Body")),
            "Ring1": SimpleNamespace(item=_gear_item(1002, "Bridge Ring", "Ring")),
        },
    }

    manifest = mechanics_swap_plan_manifest(selected, item_stats)
    transition = manifest["transitions"]["Nuke"]

    assert manifest["loaded"] is True
    assert manifest["plannerVersion"] == 2
    assert manifest["baselineSet"] == "Aftercast"
    assert transition["actions"][0]["slot"] == "Ring1"
    assert transition["actions"][0]["phase"] == "equip_pool_gain"


def test_mechanics_swap_plan_manifest_skips_utility_transitions() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "HP Vest"),
            1001: _equipment(1001, "Crafting Apron"),
            1002: _equipment(1002, "Strider Boots"),
        },
        mods_by_item_id={
            1000: (ItemMod(2, "HP", 100),),
        },
    )
    selected = {
        "Aftercast": {
            "Body": SimpleNamespace(item=_gear_item(1000, "HP Vest", "Body")),
        },
        "Crafting": {
            "Body": SimpleNamespace(item=_gear_item(1001, "Crafting Apron", "Body")),
        },
        "Movement_Night": {
            "Feet": SimpleNamespace(item=_gear_item(1002, "Strider Boots", "Feet")),
        },
    }

    manifest = mechanics_swap_plan_manifest(selected, item_stats)

    assert manifest["transitions"] == {}
    assert manifest["skippedTransitions"] == {
        "Crafting": "utility_set",
        "Movement_Night": "utility_set",
    }


def test_mechanics_swap_plan_manifest_omits_empty_target_sets() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "HP Vest"),
        },
        mods_by_item_id={
            1000: (ItemMod(2, "HP", 100),),
        },
    )
    selected = {
        "Aftercast": {
            "Body": SimpleNamespace(item=_gear_item(1000, "HP Vest", "Body")),
        },
        "WSElemental": {},
    }

    manifest = mechanics_swap_plan_manifest(selected, item_stats)

    assert manifest["transitions"] == {}
    assert manifest["skippedTransitions"] == {}


def _equipment(item_id: int, name: str) -> EquipmentStats:
    return EquipmentStats(
        item_id=item_id,
        name=name,
        level=1,
        ilevel=0,
        jobs=0,
        shield_size=0,
        slot_mask=1,
    )


def _gear_item(item_id: int, name: str, slot: str) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=1,
        slot=slot,
        category="Armor",
        jobs=("ALL",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("gear.lua"),
    )
