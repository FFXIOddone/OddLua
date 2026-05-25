from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.builder import _score_evidence, _score_item
from oddlua.classifier import classify_item
from oddlua.gearexport import GearItem
from oddlua.itemstats import ItemMod, ItemStatsIndex


def test_pet_damage_style_scores_pet_item_mods() -> None:
    pet_item = _item(1000, "Pet Harness")
    master_item = _item(1001, "Attack Harness")
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            master_item.id: (ItemMod(23, "ATT", 20),),
        },
        pet_mods_by_item_id={
            pet_item.id: (ItemMod(25, "PET_ACC", 12),),
        },
    )

    pet_classification = classify_item(pet_item, item_stats=item_stats)
    master_classification = classify_item(master_item, item_stats=item_stats)

    pet_score = _score_item(
        "PetDamage",
        "Body",
        pet_item,
        pet_classification,
        tuple(),
        item_stats=item_stats,
    )
    master_score = _score_item(
        "PetDamage",
        "Body",
        master_item,
        master_classification,
        tuple(),
        item_stats=item_stats,
    )

    assert pet_score > master_score
    assert pet_classification.pet_server_mods == (("PET_ACC", 12),)
    assert "pet weighted mods PET_ACC+12" in _score_evidence(
        "PetDamage",
        "Body",
        pet_item,
        pet_classification,
        item_stats,
    )


def test_non_pet_damage_style_does_not_score_pet_only_mods() -> None:
    pet_item = _item(1000, "Pet Harness")
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        pet_mods_by_item_id={
            pet_item.id: (ItemMod(25, "PET_ACC", 12),),
        },
    )

    classification = classify_item(pet_item, item_stats=item_stats)

    assert _score_item(
        "Damage",
        "Body",
        pet_item,
        classification,
        tuple(),
        item_stats=item_stats,
    ) == 0


def _item(item_id: int, name: str) -> GearItem:
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
        source_path=Path("fixture.lua"),
    )
