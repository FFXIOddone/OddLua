from pathlib import Path
import json
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.gearexport import GearItem
from oddlua.itemstats import EquipmentStats, ItemLatent, ItemMod, ItemStatsIndex
import oddlua.mechanics_opportunity_audit as audit_module
from oddlua.mechanics_opportunity_audit import audit_mechanics_opportunities


def test_audit_separates_owned_supported_and_missing_owned_opportunities() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={
            1000: _equipment(1000, "Shedir Seraweels"),
            1001: _equipment(1001, "Wizard's Rod"),
        },
        mods_by_item_id={
            1000: (ItemMod(539, "STONESKIN_BONUS_HP", 35),),
            1001: (ItemMod(530, "NO_SPELL_MP_DEPLETION", 15),),
        },
    )
    owned_items = (_gear_item(1000, "Shedir Seraweels"),)

    result = audit_mechanics_opportunities(
        item_stats=item_stats,
        owned_items=owned_items,
        include_no_server_evidence=False,
    )
    entries = {
        entry.key: entry
        for entry in result.entries
    }

    assert entries["stoneskin_snapshot"].status == "owned_supported"
    assert entries["stoneskin_snapshot"].owned_evidence[0].item_id == 1000
    assert entries["mp_cost_avoidance"].status == "server_supported_missing_owned"
    assert entries["mp_cost_avoidance"].server_evidence_count == 1
    assert result.summary["owned_supported"] == 1
    assert result.summary["server_supported_missing_owned"] >= 1


def test_audit_includes_latent_owned_evidence_and_writes_files(tmp_path: Path) -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={2000: _equipment(2000, "Mindmeld Kris")},
        mods_by_item_id={},
        latents_by_item_id={
            2000: (ItemLatent(2000, 369, "REFRESH", -10, 56, 0),),
        },
    )

    result = audit_mechanics_opportunities(
        item_stats=item_stats,
        owned_items=(_gear_item(2000, "Mindmeld Kris"),),
        output_root=tmp_path / "reports",
        include_no_server_evidence=False,
        write_files=True,
    )

    assert result.output_dir is not None
    assert result.json_path is not None
    assert result.markdown_path is not None
    assert result.json_path.exists()
    assert result.markdown_path.exists()

    data = json.loads(result.json_path.read_text(encoding="utf-8"))
    entries = {
        entry["key"]: entry
        for entry in data["entries"]
    }
    assert entries["negative_tick_avoidance"]["status"] == "owned_supported"
    assert "Mindmeld Kris" in result.markdown_path.read_text(encoding="utf-8")


def test_audit_file_output_uses_unique_directory_when_timestamps_collide(tmp_path: Path, monkeypatch) -> None:
    monkeypatch.setattr(audit_module, "_timestamp_for_path", lambda: "20260531T120000Z")
    item_stats = ItemStatsIndex(
        source_path=Path("fixture.sqlite"),
        equipment_by_item_id={1000: _equipment(1000, "Shedir Seraweels")},
        mods_by_item_id={
            1000: (ItemMod(539, "STONESKIN_BONUS_HP", 35),),
        },
    )

    first = audit_mechanics_opportunities(
        item_stats=item_stats,
        owned_items=(_gear_item(1000, "Shedir Seraweels"),),
        output_root=tmp_path / "reports",
        include_no_server_evidence=False,
        write_files=True,
    )
    second = audit_mechanics_opportunities(
        item_stats=item_stats,
        owned_items=(_gear_item(1000, "Shedir Seraweels"),),
        output_root=tmp_path / "reports",
        include_no_server_evidence=False,
        write_files=True,
    )

    assert first.output_dir != second.output_dir
    assert first.json_path is not None
    assert second.json_path is not None
    assert first.json_path.exists()
    assert second.json_path.exists()


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


def _gear_item(item_id: int, name: str) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=1,
        slot="Body",
        category="Armor",
        jobs=("ALL",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("gear.lua"),
    )
