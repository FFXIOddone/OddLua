from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.planning.command_registry import AAHTACOS_SAM_CONTROLS_FEATURE
from oddlua.planning.number_row_palette import (
    NUMBER_ROW_COMMAND_ONLY_KEYS,
    NUMBER_ROW_DISPLAY_KEYS,
    NUMBER_ROW_KEYS,
    plan_number_row_palette,
)


def test_number_row_palette_uses_keypad_keys_with_one_unbound_slot() -> None:
    palette = plan_number_row_palette(
        job="RDM",
        playstyles=("Cure", "Enspell", "FastCast"),
        available_sets={"Cure", "Enspell", "FastCast", "Craft", "Movement"},
    )

    assert NUMBER_ROW_KEYS == (
        "NUMPAD.",
        "NUMPAD0",
        "NUMPAD1",
        "NUMPAD2",
        "NUMPAD3",
        "NUMPAD4",
        "NUMPAD5",
        "NUMPAD6",
        "NUMPAD7",
        "NUMPAD8",
        "NUMPAD9",
    )
    assert NUMBER_ROW_DISPLAY_KEYS == (".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
    assert [binding.key for binding in palette.bindings] == list(NUMBER_ROW_KEYS)
    assert [binding.display_key for binding in palette.bindings] == list(NUMBER_ROW_DISPLAY_KEYS)
    assert [(binding.display_key, binding.action.label) for binding in palette.bindings[:8]] == [
        (".", "Style-"),
        ("0", "Style+"),
        ("1", "Styles"),
        ("2", "Status"),
        ("3", "Lockstyle"),
        ("4", "Move"),
        ("5", "Craft"),
        ("6", "Auto 1"),
    ]
    assert palette.bindings[0].action.literal == "/lac fwd styleprev"
    assert palette.bindings[1].action.literal == "/lac fwd stylenext"
    assert palette.bindings[6].action.literal == "/lac fwd utility craft"
    assert palette.bindings[8].key == "NUMPAD7"
    assert palette.bindings[8].action.label == "Warp"
    assert palette.bindings[8].action.literal == "/lac fwd warp"
    assert palette.unbound == ("slot12",)


def test_sam_palette_uses_visible_toggles_and_job_actions() -> None:
    palette = plan_number_row_palette(
        job="SAM",
        playstyles=("StoreTP", "Accuracy", "WeaponSkill"),
        available_sets={"StoreTP", "Accuracy", "WeaponSkill", "Meditate", "ThirdEye", "Craft", "Movement"},
        profile_features=(AAHTACOS_SAM_CONTROLS_FEATURE,),
    )
    by_key = {binding.key: binding.action for binding in palette.bindings}

    assert by_key["NUMPAD6"].literal == "/lac fwd autoeye"
    assert by_key["NUMPAD6"].toggle_state == "AutoThirdEye"
    assert by_key["NUMPAD7"].literal == "/lac fwd warp"
    assert by_key["NUMPAD8"].literal == "/lac fwd autowar"
    assert by_key["NUMPAD8"].toggle_state == "AutoWarBuffs"
    assert by_key["NUMPAD9"].literal == "/lac fwd meditate"
    assert all(binding.action.literal != '/ja "Third Eye" <me>' for binding in palette.bindings)
    assert all(not binding.action.literal.startswith("/ja ") for binding in palette.bindings)
    assert palette.unbound == ("slot12",)


def test_reserved_movement_cluster_entries_are_command_only_shortcuts() -> None:
    palette = plan_number_row_palette(
        job="SAM",
        playstyles=("StoreTP", "Accuracy", "WeaponSkill"),
        available_sets={"StoreTP", "Accuracy", "WeaponSkill", "Meditate", "ThirdEye"},
        profile_features=(AAHTACOS_SAM_CONTROLS_FEATURE,),
    )
    by_key = {binding.key: binding.action for binding in palette.bindings}

    assert NUMBER_ROW_COMMAND_ONLY_KEYS == ("NUMPAD2", "NUMPAD4", "NUMPAD6", "NUMPAD8")
    assert {key for key, action in by_key.items() if action.kind == "command-only"} == set(
        NUMBER_ROW_COMMAND_ONLY_KEYS
    )
    assert by_key["NUMPAD2"].literal == "/lac fwd status"
    assert by_key["NUMPAD4"].literal == "/lac fwd utility movement"
    assert by_key["NUMPAD6"].literal == "/lac fwd autoeye"
    assert by_key["NUMPAD8"].literal == "/lac fwd autowar"


def test_utility_actions_are_universal_and_include_fallbacks() -> None:
    palette = plan_number_row_palette(
        job="WAR",
        playstyles=("Damage", "Accuracy"),
        available_sets={"Damage", "Accuracy", "Survival"},
    )
    by_label = {binding.action.label: binding.action for binding in palette.bindings}

    assert by_label["Craft"].literal == "/lac fwd utility craft"
    assert by_label["Craft"].fallback_sets == (
        "Craft",
        "Fishing",
        "Gathering",
        "Clamming",
        "Movement",
        "Resting",
        "Treasure",
        "Survival",
    )
    assert by_label["Move"].fallback_sets == (
        "Movement",
        "Movement_City",
        "Movement_Night",
        "Movement_DuskToDawn",
        "InCity",
        "Survival",
    )


def test_palette_manifest_is_json_safe() -> None:
    palette = plan_number_row_palette(
        job="SAM",
        playstyles=("StoreTP", "Accuracy", "WeaponSkill"),
        available_sets={"StoreTP", "Accuracy", "WeaponSkill", "Craft", "Movement"},
    )

    manifest = palette.to_manifest()

    assert manifest["keys"] == list(NUMBER_ROW_KEYS)
    assert manifest["displayKeys"] == list(NUMBER_ROW_DISPLAY_KEYS) + [""]
    assert manifest["bindings"][0] == {
        "key": "NUMPAD.",
        "displayKey": ".",
        "id": "style.prev",
        "label": "Style-",
        "literal": "/lac fwd styleprev",
        "kind": "action",
        "toggleState": "",
        "fallbackSets": [],
    }
    assert manifest["unbound"] == ["slot12"]
