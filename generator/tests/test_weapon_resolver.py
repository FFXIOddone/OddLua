from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.builder import _build_combat_style, _build_job_sets
from oddlua.classifier import classify_item
from oddlua.contracts import build_job_contract
from oddlua.gearexport import GearItem
from oddlua.itemstats import EquipmentStats, ItemLatent, ItemMod, ItemStatsIndex, WeaponStats
from oddlua.renderer import SEMANTIC_SET_PREFERENCES


def test_classifier_uses_server_weapon_skill_before_item_name_guessing() -> None:
    item = _weapon(20720, "Egeking")
    item_stats = _rdm_weapon_stats()

    classification = classify_item(item, item_stats=item_stats)

    assert classification.weapon_family == "sword"
    assert "sword_skill" in classification.roles
    assert "Server item_weapon skill 3 identifies sword family." in classification.reasons


def test_classifier_does_not_guess_weapon_family_from_item_name() -> None:
    item = _weapon(9000, "Justice Sword")
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9000: _equipment(9000, "justice_sword", level=75, jobs=16, slot_mask=3),
        },
    )

    classification = classify_item(item, item_stats=item_stats)

    assert classification.slot_family == "weapon"
    assert classification.weapon_family == "unknown"
    assert "sword_skill" not in classification.roles


def test_classifier_does_not_apply_exact_name_or_utility_hints() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9001: _equipment(9001, "spike_necklace", level=75, jobs=16, slot_mask=512),
            9002: _equipment(9002, "warp_ring", level=75, jobs=16, slot_mask=24576),
        },
    )
    spike = classify_item(_accessory(9001, "Spike Necklace", "Neck"), item_stats=item_stats)
    warp = classify_item(_accessory(9002, "Warp Ring", "Ring1/Ring2"), item_stats=item_stats)

    assert "str" not in spike.roles
    assert "dex" not in spike.roles
    assert not warp.excluded
    assert warp.exclusion_reason == ""


def test_rdm_enspell_resolver_keeps_data_backed_target_weapons() -> None:
    weapons = (
        _weapon(17754, "Sylphid Epee", level=72),
        _weapon(17710, "Justice Sword", level=73),
        _weapon(18904, "Somnia Melodiam"),
        _weapon(20720, "Egeking"),
        _weapon(18852, "Octave Club", level=63),
    )
    item_stats = _rdm_weapon_stats()
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in weapons
    )

    style = _build_combat_style(
        "Enspell",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Main"].item.id == 18904
    assert style["Main"].item.name == "Somnia Melodiam"
    assert style["Main"].classification.weapon_family == "sword"
    assert style["Sub"].item.id in {20720, 18852}
    assert style["Sub"].classification.weapon_family in {"sword", "club"}


def test_style_without_dual_wield_hint_does_not_pick_offhand_weapon() -> None:
    items = (
        _weapon(20720, "Egeking"),
        _weapon(20629, "Atoyac"),
        _shield(12296, "Genbu's Shield", level=74),
    )
    item_stats = _rdm_weapon_stats()
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in items
    )

    style = _build_combat_style(
        "MagicAccuracy",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Sub"].item.name == "Genbu's Shield"
    assert style["Sub"].classification.weapon_family == "shield"


def test_slot_with_no_weighted_server_data_is_left_empty() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9003: _equipment(9003, "empty_neck", level=75, jobs=16, slot_mask=512),
        },
    )
    classified = (
        (_accessory(9003, "Empty Necklace", "Neck"), classify_item(_accessory(9003, "Empty Necklace", "Neck"), item_stats=item_stats)),
    )

    style = _build_combat_style(
        "MagicAccuracy",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert "Neck" not in style


def test_resting_style_uses_real_hmp_mods() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9100: (ItemMod(71, "MPHEAL", 10),),
            9101: (ItemMod(28, "MATT", 30),),
        },
        equipment_by_item_id={
            9100: _equipment(9100, "resting_torque", level=75, jobs=16, slot_mask=512),
            9101: _equipment(9101, "nuke_torque", level=75, jobs=16, slot_mask=512),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _accessory(9100, "Resting Torque", "Neck"),
            _accessory(9101, "Nuke Torque", "Neck"),
        )
    )

    style = _build_combat_style(
        "Resting",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Neck"].item.id == 9100


def test_job_generation_includes_calculated_resting_semantic_set() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9100: (ItemMod(71, "MPHEAL", 10),),
        },
        equipment_by_item_id={
            9100: _equipment(9100, "resting_torque", level=75, jobs=16, slot_mask=512),
        },
    )
    classified = (
        (
            _accessory(9100, "Resting Torque", "Neck"),
            classify_item(_accessory(9100, "Resting Torque", "Neck"), item_stats=item_stats),
        ),
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Resting"]["Neck"].item.id == 9100


def test_job_generation_attempts_every_semantic_set_and_populates_common_ones() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9400: (ItemMod(369, "REFRESH", 1),),
            9401: (ItemMod(170, "FASTCAST", 5),),
            9402: (ItemMod(30, "MACC", 8),),
            9403: (ItemMod(28, "MATT", 10),),
            9404: (ItemMod(374, "CURE_POTENCY", 8),),
            9405: (ItemMod(384, "HASTE_GEAR", 80), ItemMod(25, "ACC", 10)),
            9406: (ItemMod(161, "DMGPHYS", -5),),
            9407: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9400: _equipment(9400, "refresh_body", level=75, jobs=16, slot_mask=32),
            9401: _equipment(9401, "fastcast_head", level=75, jobs=16, slot_mask=16),
            9402: _equipment(9402, "macc_neck", level=75, jobs=16, slot_mask=512),
            9403: _equipment(9403, "mab_waist", level=75, jobs=16, slot_mask=1024),
            9404: _equipment(9404, "cure_hands", level=75, jobs=16, slot_mask=64),
            9405: _equipment(9405, "haste_legs", level=75, jobs=16, slot_mask=128),
            9406: _equipment(9406, "pdt_ring", level=75, jobs=16, slot_mask=8192),
            9407: _equipment(9407, "strider_boots", level=20, jobs=16, slot_mask=256),
            9408: _equipment(9408, "training_sword", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9408: WeaponStats(item_id=9408, skill=3, delay=240, damage=50, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9400, "Refresh Body", "Body"),
            _armor(9401, "Fastcast Head", "Head"),
            _accessory(9402, "Macc Neck", "Neck"),
            _accessory(9403, "MAB Waist", "Waist"),
            _armor(9404, "Cure Hands", "Hands"),
            _armor(9405, "Haste Legs", "Legs"),
            _accessory(9406, "PDT Ring", "Ring1"),
            _armor(9407, "Strider Boots", "Feet"),
            _weapon(9408, "Training Sword"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    missing = [set_name for set_name in SEMANTIC_SET_PREFERENCES if set_name not in sets]
    assert missing == []
    assert sets["Idle"]["Body"].item.id == 9400
    assert sets["Aftercast"]["Body"].item.id == 9400
    assert sets["Precast"]["Head"].item.id == 9401
    assert sets["FastCast"]["Head"].item.id == 9401
    assert sets["Midcast"]["Neck"].item.id == 9402
    assert sets["Elemental_Fire"]["Waist"].item.id == 9403
    assert sets["Weather_Fire"]["Waist"].item.id == 9403
    assert sets["Day_Fire"]["Waist"].item.id == 9403
    assert sets["Cure"]["Hands"].item.id == 9404
    assert sets["TP"]["Legs"].item.id == 9405
    assert sets["PDT"]["Ring1"].item.id == 9406
    assert sets["Movement"]["Feet"].item.id == 9407


def test_movement_style_uses_real_move_speed_mods() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9200: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
            9201: (ItemMod(68, "EVA", 30),),
        },
        equipment_by_item_id={
            9200: _equipment(9200, "strider_boots", level=20, jobs=16, slot_mask=256),
            9201: _equipment(9201, "evasion_boots", level=75, jobs=16, slot_mask=256),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9200, "Strider Boots", "Feet"),
            _armor(9201, "Evasion Boots", "Feet"),
        )
    )

    style = _build_combat_style(
        "Movement",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Feet"].item.id == 9200


def test_movement_style_rejects_multi_slot_movement_overlay_from_automatic_sets() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9302: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9302: _equipment(9302, "blood_cuisses", level=73, jobs=16, slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9302, "Blood Cuisses", "Legs"),
        )
    )

    style = _build_combat_style("Movement", classified, "RDM", 75, item_stats)

    assert "Body" not in style
    assert style["Legs"].item.id == 9302


def test_movement_style_leaves_clear_debug_set_when_only_movement_option_is_overlay() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
        )
    )

    for style_name in ("Movement", "Movement_City", "Movement_Night", "Movement_DuskToDawn"):
        style = _build_combat_style(style_name, classified, "RDM", 75, item_stats)
        assert style == {}


def test_movement_style_prefers_equal_single_slot_speed_over_multi_slot_kupo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9303: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9303: _equipment(9303, "fast_feet", level=75, jobs=16, slot_mask=256),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9303, "Fast Feet", "Feet"),
        )
    )

    style = _build_combat_style("Movement", classified, "RDM", 75, item_stats)

    assert "Body" not in style
    assert style["Feet"].item.id == 9303


def test_movement_style_prefers_stackable_compatible_combo_over_multi_slot_kupo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9304: (ItemMod(75, "MOVE_SPEED_STACKABLE", 10),),
            9305: (ItemMod(75, "MOVE_SPEED_STACKABLE", 10),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9304: _equipment(9304, "stackable_body", level=75, jobs=16, slot_mask=32),
            9305: _equipment(9305, "stackable_legs", level=75, jobs=16, slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9304, "Stackable Body", "Body"),
            _armor(9305, "Stackable Legs", "Legs"),
        )
    )

    style = _build_combat_style("Movement", classified, "RDM", 75, item_stats)

    assert style["Body"].item.id == 9304
    assert style["Legs"].item.id == 9305


def test_movement_city_style_uses_server_latent_aketons() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            14428: _equipment(14428, "kingdom_aketon", level=1, jobs=4194303, slot_mask=32),
            9300: _equipment(9300, "combat_body", level=75, jobs=16, slot_mask=32),
        },
        latents_by_item_id={
            14428: (ItemLatent(14428, 76, "MOVE_SPEED_GEAR_BONUS", 12, 54, 19),),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(14428, "Kingdom Aketon", "Body"),
            _armor(9300, "Combat Body", "Body"),
        )
    )

    base = _build_combat_style("Movement", classified, "RDM", 75, item_stats)
    city = _build_combat_style("Movement_City", classified, "RDM", 75, item_stats)

    assert "Body" not in base
    assert city["Body"].item.id == 14428


def test_movement_night_styles_use_server_time_latents() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            12997: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            12997: _equipment(12997, "danzo_sune_ate", level=75, jobs=4096, slot_mask=256),
            14101: _equipment(14101, "ninja_kyahan", level=54, jobs=4096, slot_mask=256),
            15364: _equipment(15364, "nin_kyahan_+1", level=74, jobs=4096, slot_mask=256),
        },
        latents_by_item_id={
            14101: (ItemLatent(14101, 76, "MOVE_SPEED_GEAR_BONUS", 24, 26, 1),),
            15364: (ItemLatent(15364, 76, "MOVE_SPEED_GEAR_BONUS", 24, 26, 2),),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(12997, "Danzo Sune-Ate", "Feet", jobs=("NIN",)),
            _armor(14101, "Ninja Kyahan", "Feet", jobs=("NIN",)),
            _armor(15364, "Nin. Kyahan +1", "Feet", jobs=("NIN",)),
        )
    )

    night = _build_combat_style("Movement_Night", classified, "NIN", 75, item_stats)
    dusk_to_dawn = _build_combat_style("Movement_DuskToDawn", classified, "NIN", 75, item_stats)

    assert night["Feet"].item.id == 14101
    assert dusk_to_dawn["Feet"].item.id == 15364


def test_job_generation_includes_conditional_movement_semantic_sets() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9200: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9200: _equipment(9200, "strider_boots", level=20, jobs=16, slot_mask=256),
            14428: _equipment(14428, "kingdom_aketon", level=1, jobs=4194303, slot_mask=32),
        },
        latents_by_item_id={
            14428: (ItemLatent(14428, 76, "MOVE_SPEED_GEAR_BONUS", 12, 54, 19),),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9200, "Strider Boots", "Feet"),
            _armor(14428, "Kingdom Aketon", "Body"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Movement"]["Feet"].item.id == 9200
    assert sets["Movement_City"]["Body"].item.id == 14428


def test_resting_style_does_not_pair_sub_weapon_with_two_handed_staff() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9102: (ItemMod(71, "MPHEAL", 10),),
            9103: (ItemMod(2, "HP", 130),),
        },
        equipment_by_item_id={
            9102: _equipment(9102, "resting_staff", level=75, jobs=16, slot_mask=3),
            9103: _equipment(9103, "statted_sword", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9102: WeaponStats(item_id=9102, skill=12, delay=366, damage=50, hit=1),
            9103: WeaponStats(item_id=9103, skill=3, delay=240, damage=50, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _weapon(9102, "Resting Staff"),
            _weapon(9103, "Statted Sword"),
        )
    )

    style = _build_combat_style(
        "Resting",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Main"].item.id == 9102
    assert "Sub" not in style


def _rdm_weapon_stats() -> ItemStatsIndex:
    return ItemStatsIndex(
        source_path=Path("test.sqlite"),
        equipment_by_item_id={
            17754: _equipment(17754, "sylphid_epee", level=72, jobs=16, slot_mask=3),
            17710: _equipment(17710, "justice_sword", level=73, jobs=16, slot_mask=3),
            18904: _equipment(18904, "ephemeron", level=75, jobs=16, slot_mask=3),
            20720: _equipment(20720, "egeking", level=75, jobs=16, slot_mask=3),
            18852: _equipment(18852, "octave_club", level=63, jobs=16, slot_mask=3),
            20629: _equipment(20629, "atoyac", level=75, jobs=16, slot_mask=3),
            12296: _equipment(12296, "genbus_shield", level=74, jobs=16, slot_mask=2),
        },
        mods_by_item_id={
            17710: (ItemMod(8, "STR", 7),),
            18904: (
                ItemMod(11, "AGI", 15),
                ItemMod(384, "HASTE_GEAR", 300),
            ),
            20629: (ItemMod(30, "MACC", 10),),
            12296: (ItemMod(30, "MACC", 8),),
        },
        weapon_stats_by_item_id={
            17754: WeaponStats(item_id=17754, skill=3, delay=224, damage=39, hit=1),
            17710: WeaponStats(item_id=17710, skill=3, delay=236, damage=34, hit=1),
            18904: WeaponStats(item_id=18904, skill=3, delay=213, damage=58, hit=1),
            20720: WeaponStats(item_id=20720, skill=3, delay=236, damage=124, hit=1),
            18852: WeaponStats(item_id=18852, skill=11, delay=264, damage=11, hit=1),
            20629: WeaponStats(item_id=20629, skill=2, delay=200, damage=97, hit=1),
        },
    )


def _equipment(
    item_id: int,
    name: str,
    *,
    level: int,
    jobs: int,
    slot_mask: int,
    removal_slot_mask: int = 0,
) -> EquipmentStats:
    return EquipmentStats(
        item_id=item_id,
        name=name,
        level=level,
        ilevel=0,
        jobs=jobs,
        shield_size=1 if slot_mask == 2 else 0,
        slot_mask=slot_mask,
        removal_slot_mask=removal_slot_mask,
    )


def _weapon(item_id: int, name: str, *, level: int = 75) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot="Main/Sub",
        category="Weapon",
        jobs=("RDM",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def _shield(item_id: int, name: str, *, level: int = 75) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot="Sub",
        category="Armor",
        jobs=("RDM",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def _accessory(item_id: int, name: str, slot: str, *, level: int = 75) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot=slot,
        category="Accessory",
        jobs=("RDM",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def _armor(item_id: int, name: str, slot: str, *, level: int = 75, jobs: tuple[str, ...] = ("RDM",)) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot=slot,
        category="Armor",
        jobs=jobs,
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )
