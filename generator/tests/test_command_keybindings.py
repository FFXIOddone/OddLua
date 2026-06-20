from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.planning.command_registry import CommandRegistration, default_forward_commands
from oddlua.planning.keybinding_planner import plan_keybindings
from oddlua.planning.number_row_palette import NUMBER_ROW_KEYS, plan_number_row_palette


def test_default_forward_commands_include_warp_and_style_accuracy() -> None:
    commands = default_forward_commands(playstyles=("Accuracy", "Treasure"))
    literal_by_id = {command.command_id: command.literal for command in commands}

    assert literal_by_id["help"] == "/lac fwd help"
    assert literal_by_id["warp"] == "/lac fwd warp"
    assert literal_by_id["styles"] == "/lac fwd styles"
    assert literal_by_id["style.accuracy"] == "/lac fwd style accuracy"
    assert literal_by_id["style.treasure"] == "/lac fwd style treasure"


def test_default_forward_commands_deduplicates_style_tokens() -> None:
    commands = default_forward_commands(playstyles=("Accuracy", "accuracy", "Accuracy "))

    style_accuracy = [command for command in commands if command.command_id == "style.accuracy"]

    assert len(style_accuracy) == 1
    assert style_accuracy[0].literal == "/lac fwd style accuracy"


def test_keybinding_planner_assigns_plain_function_keys_by_priority() -> None:
    commands = (
        CommandRegistration("warp", "/lac fwd warp", "runtime", priority=10),
        CommandRegistration("style.accuracy", "/lac fwd style accuracy", "style", priority=20),
        CommandRegistration("status", "/lac fwd status", "runtime", priority=90),
    )

    plan = plan_keybindings(commands)

    assert [(binding.key, binding.command.literal) for binding in plan.bindings] == [
        ("F1", "/lac fwd warp"),
        ("F2", "/lac fwd style accuracy"),
        ("F3", "/lac fwd status"),
    ]
    assert plan.conflicts == ()
    assert plan.unbound == ()


def test_keybinding_planner_reports_override_conflicts() -> None:
    commands = (
        CommandRegistration("warp", "/lac fwd warp", "runtime", priority=10),
        CommandRegistration("style.accuracy", "/lac fwd style accuracy", "style", priority=20),
    )

    plan = plan_keybindings(commands, overrides={"warp": "F1", "style.accuracy": "F1"})

    assert [(binding.key, binding.command.command_id) for binding in plan.bindings] == [("F1", "warp")]
    assert plan.conflicts == ("style.accuracy requested F1 already assigned to warp",)
    assert plan.unbound == ("style.accuracy",)


def test_keybinding_planner_rejects_override_keys_outside_key_order() -> None:
    commands = (
        CommandRegistration("warp", "/lac fwd warp", "runtime", priority=10),
    )

    plan = plan_keybindings(commands, overrides={"warp": "F13"})

    assert plan.bindings == ()
    assert plan.conflicts == ("warp requested invalid key F13",)
    assert plan.unbound == ("warp",)


def test_keybinding_planner_reports_unbound_when_key_order_is_exhausted() -> None:
    commands = (
        CommandRegistration("warp", "/lac fwd warp", "runtime", priority=10),
        CommandRegistration("status", "/lac fwd status", "runtime", priority=20),
    )

    plan = plan_keybindings(commands, key_order=("F1",))

    assert [(binding.key, binding.command.command_id) for binding in plan.bindings] == [("F1", "warp")]
    assert plan.conflicts == ()
    assert plan.unbound == ("status",)


def test_default_forward_commands_include_aahtacos_sam_feature_commands() -> None:
    commands = default_forward_commands(
        playstyles=("StoreTP", "Accuracy", "WeaponSkill"),
        profile_features=("aahtacos_sam_controls",),
    )
    literal_by_id = {command.command_id: command.literal for command in commands}

    assert literal_by_id["sam.help"] == "/lac fwd samhelp"
    assert literal_by_id["sam.sekkagekko"] == "/lac fwd sekkagekko"
    assert literal_by_id["sam.konzenshoha"] == "/lac fwd konzenshoha"
    assert literal_by_id["sam.seiganeye"] == "/lac fwd seiganeye"
    assert literal_by_id["sam.warbuffs"] == "/lac fwd warbuffs"
    assert literal_by_id["sam.autoeye"] == "/lac fwd autoeye"
    assert literal_by_id["sam.autowar"] == "/lac fwd autowar"
    assert literal_by_id["sam.autocombat"] == "/lac fwd autocombat"


def test_number_row_palette_manifest_records_raw_profile_keys() -> None:
    palette = plan_number_row_palette(
        job="RDM",
        playstyles=("Cure", "Enspell"),
        available_sets={"Cure", "Enspell", "Craft", "Movement"},
    ).to_manifest()

    assert palette["keys"] == list(NUMBER_ROW_KEYS)
    assert palette["bindings"][0]["literal"] == "/lac fwd styleprev"
    assert palette["bindings"][3]["literal"] == "/lac fwd warp"
    assert palette["bindings"][6]["fallbackSets"][0] == "Craft"
