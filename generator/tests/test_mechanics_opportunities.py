from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.itemstats import EquipmentStats, ItemLatent, ItemMod, ItemStatsIndex
from oddlua.mechanics_opportunities import (
    discover_mechanics_opportunities,
    mechanics_opportunity_manifest,
)


def test_discovers_opportunities_from_direct_latent_and_pet_mods() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "Shedir Seraweels"),
            1001: _equipment(1001, "Wizard's Rod"),
            1002: _equipment(1002, "Mindmeld Kris"),
            1003: _equipment(1003, "Pet Harness"),
        },
        mods_by_item_id={
            1000: (ItemMod(539, "STONESKIN_BONUS_HP", 35),),
            1001: (ItemMod(530, "NO_SPELL_MP_DEPLETION", 15),),
        },
        latents_by_item_id={
            1002: (ItemLatent(1002, 369, "REFRESH", -10, 56, 0),),
        },
        pet_mods_by_item_id={
            1003: (ItemMod(25, "PET_ACC", 12),),
        },
    )

    opportunities = {
        opportunity.key: opportunity
        for opportunity in discover_mechanics_opportunities(item_stats)
    }

    assert "stoneskin_snapshot" in opportunities
    assert "mp_cost_avoidance" in opportunities
    assert "negative_tick_avoidance" in opportunities
    assert "pet_action_snapshot" in opportunities

    negative = opportunities["negative_tick_avoidance"]
    assert negative.evidence[0].item_id == 1002
    assert negative.evidence[0].mods == ("REFRESH-10",)
    assert negative.evidence[0].source == "item_latents"


def test_manifest_is_json_safe_and_reports_detected_keys() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={2000: _equipment(2000, "Ratri Breastplate")},
        mods_by_item_id={2000: (ItemMod(2, "HP", 533),)},
    )

    manifest = mechanics_opportunity_manifest(item_stats)

    assert manifest["definitionCount"] >= 30
    assert manifest["detectedCount"] >= 1
    keys = {
        opportunity["key"]
        for opportunity in manifest["opportunities"]
    }
    assert "hp_bridge_swap" in keys


def test_manifest_handles_missing_item_stats() -> None:
    manifest = mechanics_opportunity_manifest(None)

    assert manifest["definitionCount"] >= 30
    assert manifest["detectedCount"] == 0
    assert manifest["opportunities"] == []


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
