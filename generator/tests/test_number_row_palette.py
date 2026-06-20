from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.planning.command_registry import AAHTACOS_SAM_CONTROLS_FEATURE
from oddlua.planning.number_row_palette import (
    NUMBER_ROW_KEYS,
    plan_number_row_palette,
)


def test_number_row_palette_uses_raw_keyboard_row() -> None:
    palette = plan_number_row_palette(
        job="RDM",
        playstyles=("Cure", "Enspell", "FastCast"),
        available_sets={"Cure", "Enspell", "FastCast", "Craft", "Movement"},
    )

    assert NUMBER_ROW_KEYS == ("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=")
    assert [binding.key for binding in palette.bindings] == list(NUMBER_ROW_KEYS)
    assert [(binding.key, binding.action.label) for binding in palette.bindings[:8]] == [
        ("1", "Style-"),
        ("2", "Style+"),
        ("3", "Styles"),
        ("4", "Warp"),
        ("5", "Lockstyle"),
        ("6", "Status"),
        ("7", "Craft"),
        ("8", "Move"),
    ]
    assert palette.bindings[0].action.literal == "/lac fwd styleprev"
    assert palette.bindings[1].action.literal == "/lac fwd stylenext"
    assert palette.bindings[6].action.literal == "/lac fwd utility craft"
    assert palette.bindings[8].action.label == "Auto 1"


def test_sam_palette_uses_visible_toggles_and_job_actions() -> None:
    palette = plan_number_row_palette(
        job="SAM",
        playstyles=("StoreTP", "Accuracy", "WeaponSkill"),
        available_sets={"StoreTP", "Accuracy", "WeaponSkill", "Meditate", "ThirdEye", "Craft", "Movement"},
        profile_features=(AAHTACOS_SAM_CONTROLS_FEATURE,),
    )
    by_key = {binding.key: binding.action for binding in palette.bindings}

    assert by_key["9"].literal == "/lac fwd autoeye"
    assert by_key["9"].toggle_state == "AutoThirdEye"
    assert by_key["0"].literal == "/lac fwd autowar"
    assert by_key["0"].toggle_state == "AutoWarBuffs"
    assert by_key["-"].literal == '/ja "Meditate" <me>'
    assert by_key["="].literal == '/ja "Third Eye" <me>'


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
    assert manifest["bindings"][0] == {
        "key": "1",
        "id": "style.prev",
        "label": "Style-",
        "literal": "/lac fwd styleprev",
        "kind": "action",
        "toggleState": "",
        "fallbackSets": [],
    }
    assert manifest["unbound"] == []
