from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.builder import _score_evidence, _score_item
from oddlua.classifier import classify_item
from oddlua.gearexport import GearItem
from oddlua.itemstats import EquipmentStats, ItemMod, ItemStatsIndex


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


def test_gearexport_augments_contribute_to_item_score() -> None:
    plain_item = _item(1000, "Augmented Gloves")
    augmented_item = _item(
        1000,
        "Augmented Gloves",
        augments=("Accuracy+5", "'Fast Cast'+3", "Pet: Attack+2"),
    )
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            plain_item.id: EquipmentStats(
                item_id=plain_item.id,
                name=plain_item.name,
                level=1,
                ilevel=0,
                jobs=(1 << 22) - 1,
                shield_size=0,
                slot_mask=64,
                removal_slot_mask=0,
            )
        },
    )

    plain_classification = classify_item(plain_item, item_stats=item_stats)
    augmented_classification = classify_item(augmented_item, item_stats=item_stats)

    plain_score = _score_item(
        "Accuracy",
        "Hands",
        plain_item,
        plain_classification,
        tuple(),
        item_stats=item_stats,
    )
    augmented_score = _score_item(
        "Accuracy",
        "Hands",
        augmented_item,
        augmented_classification,
        tuple(),
        item_stats=item_stats,
    )

    assert augmented_score > plain_score
    assert augmented_classification.augment_mods == (("ACC", 5), ("FASTCAST", 3))
    assert augmented_classification.pet_augment_mods == (("PET_ATK", 2),)
    assert "augment weighted mods ACC+5" in _score_evidence(
        "Accuracy",
        "Hands",
        augmented_item,
        augmented_classification,
        item_stats,
    )


def _item(item_id: int, name: str, augments: tuple[str, ...] = tuple()) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=1,
        slot="Body",
        category="Armor",
        jobs=("ALL",),
        storage="Inventory",
        augments=augments,
        raw_stats={},
        source_path=Path("fixture.lua"),
    )
