from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_gear_resolution import (
    audit_manifest_slot,
    gear_audit_json_payload,
    gear_audit_failures,
    gear_audit_exit_code,
    parse_args,
    parse_finding_tag_budgets,
    _occupied_slots_for_manifest_style,
    _should_audit_slot_for_style,
)
from oddlua.classifier import classify_item
from oddlua.gearexport import GearItem
from oddlua.itemstats import EquipmentStats, ItemMod, ItemStatsIndex, WeaponStats
from oddlua.weaponskills import CatseyeWeaponSkill


def test_gear_audit_exit_code_fails_on_non_best_status_when_enabled() -> None:
    report = {
        "summary": {
            "statuses": {
                "selected_is_best": 10,
                "candidate_beats_selected": 1,
            },
            "findingTags": {
                "manual_review_special_effect": 3,
            },
        },
    }

    assert gear_audit_exit_code(report) == 0
    assert gear_audit_exit_code(report, fail_on_status_findings=True) == 1
    assert gear_audit_failures(report, fail_on_status_findings=True) == (
        "candidate_beats_selected count 1 exceeds max 0",
    )


def test_gear_audit_exit_code_allows_manual_review_tags_without_status_findings() -> None:
    report = {
        "summary": {
            "statuses": {
                "selected_is_best": 10,
            },
            "findingTags": {
                "manual_review_special_effect": 3,
            },
        },
    }

    assert gear_audit_exit_code(report, fail_on_status_findings=True) == 0


def test_gear_audit_can_gate_finding_tag_budgets() -> None:
    report = {
        "summary": {
            "statuses": {
                "selected_is_best": 10,
            },
            "findingTags": {
                "manual_review_named_effect": 2,
                "manual_review_special_effect": 4,
            },
        },
    }

    assert gear_audit_failures(
        report,
        fail_on_status_findings=True,
        max_finding_tags={
            "manual_review_named_effect": 2,
            "manual_review_special_effect": 3,
        },
    ) == (
        "manual_review_special_effect tag count 4 exceeds max 3",
    )
    assert gear_audit_exit_code(
        report,
        fail_on_status_findings=True,
        max_finding_tags={
            "manual_review_named_effect": 2,
            "manual_review_special_effect": 4,
        },
    ) == 0


def test_parse_finding_tag_budgets_validates_counts() -> None:
    assert parse_finding_tag_budgets(
        (
            "manual_review_named_effect=334",
            "manual_review_special_effect=386",
        )
    ) == {
        "manual_review_named_effect": 334,
        "manual_review_special_effect": 386,
    }

    try:
        parse_finding_tag_budgets(("manual_review_special_effect=-1",))
    except ValueError as exc:
        assert "non-negative integer" in str(exc)
    else:
        raise AssertionError("negative finding tag budget should fail")

    try:
        parse_finding_tag_budgets(("manual_review_special_effect",))
    except ValueError as exc:
        assert "TAG=COUNT" in str(exc)
    else:
        raise AssertionError("malformed finding tag budget should fail")


def test_gear_audit_cli_accepts_repeated_finding_tag_budgets() -> None:
    args = parse_args(
        (
            "--max-finding-tag",
            "manual_review_named_effect=334",
            "--max-finding-tag",
            "manual_review_special_effect=386",
        )
    )

    assert args.max_finding_tag == [
        "manual_review_named_effect=334",
        "manual_review_special_effect=386",
    ]


def test_gear_audit_json_payload_can_omit_heavy_rows() -> None:
    report = {
        "generatedAt": "2026-06-18T19:00:00",
        "summary": {"slotRows": 1},
        "profiles": [{"player": "Pleasebanme", "job": "SAM"}],
        "rows": [{"topCandidates": [{"serverMods": {"STR": 1}}]}],
    }

    payload = gear_audit_json_payload(report, compact=True)

    assert payload == {
        "generatedAt": "2026-06-18T19:00:00",
        "summary": {"slotRows": 1},
        "profiles": [{"player": "Pleasebanme", "job": "SAM"}],
        "rows": [],
        "rowsOmitted": 1,
    }
    assert report["rows"] == [{"topCandidates": [{"serverMods": {"STR": 1}}]}]


def test_audit_manifest_slot_reports_selected_and_candidate_gap() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(5, "MP", 30),),
            2: (ItemMod(1, "DEF", 51), ItemMod(2, "HP", 34), ItemMod(10, "VIT", 7)),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="mp_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
            2: EquipmentStats(item_id=2, name="safe_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
        },
    )
    gear = (
        GearItem(1, "MP Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(2, "Safe Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Idle",
        slot="Body",
        selected_item_name="MP Body",
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["selected"]["item"] == "MP Body"
    assert result["bestCandidate"]["item"] == "Safe Body"
    assert result["status"] == "candidate_beats_selected"


def test_audit_manifest_slot_marks_selected_best() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(5, "MP", 30),),
            2: (ItemMod(1, "DEF", 51), ItemMod(2, "HP", 34), ItemMod(10, "VIT", 7)),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="mp_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
            2: EquipmentStats(item_id=2, name="safe_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
        },
    )
    gear = (
        GearItem(1, "MP Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(2, "Safe Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Idle",
        slot="Body",
        selected_item_name="Safe Body",
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["selected"]["item"] == "Safe Body"
    assert result["bestCandidate"]["item"] == "Safe Body"
    assert result["status"] == "selected_is_best"


def test_audit_manifest_slot_reports_raw_and_server_levels() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(25, "ACC", 10),),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="scaled_head", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=16),
        },
    )
    gear = (
        GearItem(1, "Scaled Head", 1, 10, "Head", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Accuracy",
        slot="Head",
        selected_item_name="Scaled Head",
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["selected"]["level"] == 10
    assert result["selected"]["serverLevel"] == 75
    assert result["bestCandidate"]["level"] == 10
    assert result["bestCandidate"]["serverLevel"] == 75


def test_audit_manifest_slot_reports_missing_slot_with_candidates() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={2: (ItemMod(2, "ACC", 12),)},
        equipment_by_item_id={
            2: EquipmentStats(item_id=2, name="safe_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
        },
    )
    gear = (
        GearItem(2, "Safe Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Accuracy",
        slot="Body",
        selected_item_name=None,
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["selected"] == {}
    assert result["status"] == "missing_slot_has_candidate"
    assert result["bestCandidate"]["item"] == "Safe Body"
    assert result["topCandidates"][0]["item"] == "Safe Body"


def test_audit_manifest_slot_blocks_paired_slot_candidates_on_missing_rows() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            3: (ItemMod(2, "ACC", 40),),
            4: (ItemMod(2, "ACC", 35),),
        },
        equipment_by_item_id={
            3: EquipmentStats(item_id=3, name="earl", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=12288),
            4: EquipmentStats(item_id=4, name="eary", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=12288),
        },
    )
    gear = (
        GearItem(3, "Ear A", 1, 75, "Ear1/Ear2", "Accessory", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(4, "Ear B", 1, 75, "Ear1/Ear2", "Accessory", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Accuracy",
        slot="Ear2",
        selected_item_name=None,
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
        blocked_selected_item_names=("Ear A",),
    )

    assert result["status"] == "missing_slot_has_candidate"
    assert result["bestCandidate"]["item"] == "Ear B"


def test_missing_slot_audit_respects_slots_occupied_by_selected_gear() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            10: (ItemMod(1, "DEF", 20),),
            11: (ItemMod(1, "DEF", 8),),
            12: (ItemMod(1, "DEF", 8),),
        },
        equipment_by_item_id={
            10: EquipmentStats(
                item_id=10,
                name="long_coat",
                level=75,
                ilevel=0,
                jobs=2048,
                shield_size=0,
                slot_mask=32,
                removal_slot_mask=64,
            ),
            11: EquipmentStats(item_id=11, name="mittens", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=64),
            12: EquipmentStats(item_id=12, name="ammo", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=8),
        },
        weapon_stats_by_item_id={
            12: WeaponStats(item_id=12, skill=0, delay=240, damage=20, hit=1),
        },
    )
    gear = (
        GearItem(10, "Long Coat", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(11, "Mittens", 1, 75, "Hands", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(12, "Ammo", 1, 75, "Ammo", "Weapon", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)
    slots = {"Body": {"item": "Long Coat"}}

    occupied = _occupied_slots_for_manifest_style(
        style_name="PDT",
        slots=slots,
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )
    hands = audit_manifest_slot(
        style_name="PDT",
        slot="Hands",
        selected_item_name=None,
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert "Hands" in occupied
    assert hands["status"] == "missing_slot_has_candidate"


def test_audit_manifest_slot_does_not_recommend_item_already_used_by_paired_slot() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(25, "ACC", 10),),
            2: (ItemMod(25, "ACC", 5),),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="best_ring", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=24576),
            2: EquipmentStats(item_id=2, name="second_ring", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=24576),
        },
    )
    gear = (
        GearItem(1, "Best Ring", 1, 75, "Ring1/Ring2", "Accessory", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(2, "Second Ring", 1, 75, "Ring1/Ring2", "Accessory", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Accuracy",
        slot="Ring2",
        selected_item_name="Second Ring",
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
        blocked_selected_item_names=("Best Ring",),
    )

    assert result["selected"]["item"] == "Second Ring"
    assert result["bestCandidate"]["item"] == "Second Ring"
    assert result["status"] == "selected_is_best"


def test_should_audit_slot_filters_weaponskill_action_styles() -> None:
    assert _should_audit_slot_for_style(style_name="Weaponskill", slot="Main") is False
    assert _should_audit_slot_for_style(style_name="Weaponskill", slot="Ammo") is False
    assert _should_audit_slot_for_style(style_name="Weaponskill", slot="Body") is True
    assert _should_audit_slot_for_style(style_name="WeaponSkillAccuracy", slot="Range") is False
    assert _should_audit_slot_for_style(style_name="WSElemental", slot="Sub") is False
    assert _should_audit_slot_for_style(style_name="WSAcc_Tachi_Gekko", slot="Range") is False
    assert _should_audit_slot_for_style(style_name="WSAcc_Tachi_Gekko", slot="Ammo") is False
    assert _should_audit_slot_for_style(style_name="WSAcc_Tachi_Gekko", slot="Body") is True
    assert _should_audit_slot_for_style(style_name="Crafting", slot="Main") is False
    assert _should_audit_slot_for_style(style_name="Movement_DuskToDawn", slot="Feet") is False
    assert _should_audit_slot_for_style(style_name="InCity", slot="Main") is False


def test_audit_manifest_slot_scores_treasure_fallback_as_melt_when_no_th_gear() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(9, "AGI", 2),),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="wing_earring", level=35, ilevel=0, jobs=4194303, shield_size=0, slot_mask=6144),
        },
    )
    gear = (
        GearItem(1, "Wing Earring", 1, 35, "Ear1/Ear2", "Accessory", ("ALL",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Treasure",
        slot="Ear1",
        selected_item_name="Wing Earring",
        classified=classified,
        job="THF",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["selectionStyle"] == "Melt"
    assert result["selected"]["item"] == "Wing Earring"
    assert result["bestCandidate"]["item"] == "Wing Earring"
    assert result["status"] == "selected_is_best"


def test_audit_manifest_slot_applies_weapon_policy_to_selected_candidate() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            18198: (ItemMod(23, "ATT", 5),),
            20872: (ItemMod(8, "STR", 3), ItemMod(10, "VIT", 3)),
        },
        equipment_by_item_id={
            18198: EquipmentStats(item_id=18198, name="byakkos_axe", level=74, ilevel=0, jobs=129, shield_size=0, slot_mask=1),
            20872: EquipmentStats(item_id=20872, name="ixtab", level=75, ilevel=0, jobs=2097281, shield_size=0, slot_mask=1),
        },
        weapon_stats_by_item_id={
            18198: WeaponStats(item_id=18198, skill=6, delay=504, damage=94, hit=1),
            20872: WeaponStats(item_id=20872, skill=6, delay=504, damage=93, hit=1),
        },
    )
    gear = (
        GearItem(18198, "Byakko's Axe", 1, 74, "Main", "Weapon", ("WAR",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(20872, "Ixtab", 1, 75, "Main", "Weapon", ("WAR",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="Damage",
        slot="Main",
        selected_item_name="Ixtab",
        classified=classified,
        job="WAR",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["status"] == "selected_is_best"
    assert result["selected"]["item"] == "Ixtab"
    assert result["bestCandidate"]["item"] == "Ixtab"
    assert result["selected"]["score"] == result["bestCandidate"]["score"]
    assert "preferred weapon policy item_id 20872" in result["selected"]["reason"]


def test_audit_manifest_slot_honors_fixed_rdm_enspell_weapon_policy() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            18904: (ItemMod(384, "HASTE_GEAR", 300),),
        },
        equipment_by_item_id={
            18904: EquipmentStats(item_id=18904, name="somnia_melodiam", level=75, ilevel=0, jobs=16, shield_size=0, slot_mask=3),
            20720: EquipmentStats(item_id=20720, name="egeking", level=75, ilevel=0, jobs=16, shield_size=0, slot_mask=3),
            18852: EquipmentStats(item_id=18852, name="octave_club", level=63, ilevel=0, jobs=16, shield_size=0, slot_mask=3),
        },
        weapon_stats_by_item_id={
            18904: WeaponStats(item_id=18904, skill=3, delay=213, damage=58, hit=1),
            20720: WeaponStats(item_id=20720, skill=3, delay=236, damage=43, hit=1),
            18852: WeaponStats(item_id=18852, skill=11, delay=264, damage=11, hit=1),
        },
    )
    gear = (
        GearItem(18904, "Somnia Melodiam", 1, 75, "Main/Sub", "Weapon", ("RDM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(20720, "Egeking", 1, 75, "Main/Sub", "Weapon", ("RDM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(18852, "Octave Club", 1, 63, "Main/Sub", "Weapon", ("RDM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    main = audit_manifest_slot(
        style_name="Enspell",
        slot="Main",
        selected_item_name="Somnia Melodiam",
        classified=classified,
        job="RDM",
        character_level=75,
        item_stats=item_stats,
    )
    sub = audit_manifest_slot(
        style_name="Enspell",
        slot="Sub",
        selected_item_name="Octave Club",
        classified=classified,
        job="RDM",
        character_level=75,
        item_stats=item_stats,
        blocked_selected_item_names=("Somnia Melodiam",),
    )

    assert main["status"] == "selected_is_best"
    assert main["bestCandidate"]["item"] == "Somnia Melodiam"
    assert sub["status"] == "selected_is_best"
    assert sub["bestCandidate"]["item"] == "Octave Club"


def test_audit_manifest_slot_scores_exact_weaponskill_rows_with_ws_weights() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(8, "STR", 12), ItemMod(23, "ATT", 8)),
            2: (ItemMod(1, "DEF", 50),),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="gekko_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
            2: EquipmentStats(item_id=2, name="safe_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
        },
        weapon_skills_by_key={
            "tachi_gekko": _weaponskill(),
        },
    )
    gear = (
        GearItem(1, "Gekko Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(2, "Safe Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="WS_Tachi_Gekko",
        slot="Body",
        selected_item_name="Gekko Body",
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["status"] == "selected_is_best"
    assert result["bestCandidate"]["item"] == "Gekko Body"
    assert result["topCandidates"]


def test_audit_manifest_slot_scores_exact_weaponskill_accuracy_rows_with_wsacc_weights() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            1: (ItemMod(8, "STR", 20), ItemMod(23, "ATT", 12)),
            2: (ItemMod(25, "ACC", 30), ItemMod(365, "WSACC", 10)),
        },
        equipment_by_item_id={
            1: EquipmentStats(item_id=1, name="damage_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
            2: EquipmentStats(item_id=2, name="accuracy_body", level=75, ilevel=0, jobs=2048, shield_size=0, slot_mask=32),
        },
        weapon_skills_by_key={
            "tachi_gekko": _weaponskill(),
        },
    )
    gear = (
        GearItem(1, "Damage Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
        GearItem(2, "Accuracy Body", 1, 75, "Body", "Armor", ("SAM",), "Inventory", tuple(), {}, Path("fixture.lua")),
    )
    classified = tuple((item, classify_item(item, item_stats=item_stats)) for item in gear)

    result = audit_manifest_slot(
        style_name="WSAcc_Tachi_Gekko",
        slot="Body",
        selected_item_name="Accuracy Body",
        classified=classified,
        job="SAM",
        character_level=75,
        item_stats=item_stats,
    )

    assert result["status"] == "selected_is_best"
    assert result["bestCandidate"]["item"] == "Accuracy Body"
    assert result["topCandidates"]


def _weaponskill() -> CatseyeWeaponSkill:
    return CatseyeWeaponSkill(
        weapon_skill_id=110,
        name="Tachi: Gekko",
        key="tachi_gekko",
        display_name="Tachi: Gekko",
        set_name="WS_Tachi_Gekko",
        accuracy_set_name="WSAcc_Tachi_Gekko",
        jobs_hex="0",
        weapon_type=10,
        weapon_family="great_katana",
        skill_level=1,
        element_id=0,
        element_name="None",
        main_only=False,
        unlock_id=0,
    )
