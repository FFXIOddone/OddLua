from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.planning.command_registry import (
    BLUE_LEARNING_MODE_FEATURE,
    CASTER_SUSTAIN_MODE_FEATURE,
    GUARD_MODE_FEATURE,
    OCCULT_ACUMEN_MODE_FEATURE,
    CommandRegistration,
    default_forward_commands,
)
from oddlua.planning.keybinding_planner import plan_keybindings
from oddlua.planning.number_row_palette import NUMBER_ROW_KEYS, plan_number_row_palette


def test_default_forward_commands_include_warp_and_style_accuracy() -> None:
    commands = default_forward_commands(playstyles=("Accuracy", "Treasure"))
    literal_by_id = {command.command_id: command.literal for command in commands}
    command_by_id = {command.command_id: command for command in commands}

    assert literal_by_id["help"] == "/lac fwd help"
    assert literal_by_id["warp"] == "/lac fwd warp"
    assert literal_by_id["weapon.sync"] == "/lac fwd weaponsync"
    assert command_by_id["weapon.sync"].exempt_from_binding is True
    assert literal_by_id["gear.update"] == "/lac fwd updategear"
    assert literal_by_id["gear.update.status"] == "/lac fwd updategear status"
    assert literal_by_id["conditional.status"] == "/lac fwd overlays"
    assert literal_by_id["mechanics.avoidtick"] == "/lac fwd mechanics avoidtick"
    assert command_by_id["mechanics.avoidtick"].exempt_from_binding is True
    assert command_by_id["gear.update"].exempt_from_binding is True
    assert command_by_id["gear.update.status"].exempt_from_binding is True
    assert command_by_id["conditional.status"].exempt_from_binding is True
    assert literal_by_id["resist.fireres"] == "/lac fwd fireres"
    assert literal_by_id["resist.thunderres"] == "/lac fwd thunderres"
    assert literal_by_id["resist.lightningres"] == "/lac fwd lightningres"
    assert literal_by_id["resist.statusres"] == "/lac fwd statusres"
    assert literal_by_id["resist.charmres"] == "/lac fwd charmres"
    assert literal_by_id["resist.resoff"] == "/lac fwd resoff"
    assert command_by_id["resist.fireres"].exempt_from_binding is True
    assert command_by_id["resist.thunderres"].exempt_from_binding is True
    assert command_by_id["resist.lightningres"].exempt_from_binding is True
    assert command_by_id["resist.statusres"].exempt_from_binding is True
    assert command_by_id["resist.charmres"].exempt_from_binding is True
    assert command_by_id["resist.resoff"].exempt_from_binding is True
    assert literal_by_id["override.pdt"] == "/lac fwd pdt"
    assert literal_by_id["override.mdt"] == "/lac fwd mdt"
    assert command_by_id["override.pdt"].exempt_from_binding is True
    assert command_by_id["override.mdt"].exempt_from_binding is True
    assert literal_by_id["idlepool.setmp"] == "/lac fwd setmp"
    assert literal_by_id["idlepool.addmp"] == "/lac fwd addmp"
    assert literal_by_id["idlepool.resetmp"] == "/lac fwd resetmp"
    assert literal_by_id["idlepool.sethp"] == "/lac fwd sethp"
    assert literal_by_id["idlepool.addhp"] == "/lac fwd addhp"
    assert literal_by_id["idlepool.resethp"] == "/lac fwd resethp"
    assert command_by_id["idlepool.setmp"].exempt_from_binding is True
    assert command_by_id["idlepool.sethp"].exempt_from_binding is True
    assert literal_by_id["styles"] == "/lac fwd styles"
    assert literal_by_id["style.accuracy"] == "/lac fwd style accuracy"
    assert literal_by_id["style.treasure"] == "/lac fwd style treasure"


def test_default_forward_commands_deduplicates_style_tokens() -> None:
    commands = default_forward_commands(playstyles=("Accuracy", "accuracy", "Accuracy "))

    style_accuracy = [command for command in commands if command.command_id == "style.accuracy"]

    assert len(style_accuracy) == 1
    assert style_accuracy[0].literal == "/lac fwd style accuracy"


def test_blue_learning_command_is_feature_gated_and_exempt_from_binding() -> None:
    without_feature = default_forward_commands(playstyles=("Damage",))
    with_feature = default_forward_commands(
        playstyles=("Damage",),
        profile_features=(BLUE_LEARNING_MODE_FEATURE,),
    )
    without_ids = {command.command_id for command in without_feature}
    with_by_id = {command.command_id: command for command in with_feature}

    assert "mode.bluelearning" not in without_ids
    assert with_by_id["mode.bluelearning"].literal == "/lac fwd learning"
    assert with_by_id["mode.bluelearning"].owner == "mode"
    assert with_by_id["mode.bluelearning"].exempt_from_binding is True


def test_caster_sustain_command_is_feature_gated_and_exempt_from_binding() -> None:
    without_feature = default_forward_commands(playstyles=("IdleRefresh",))
    with_feature = default_forward_commands(
        playstyles=("IdleRefresh",),
        profile_features=(CASTER_SUSTAIN_MODE_FEATURE,),
    )
    without_ids = {command.command_id for command in without_feature}
    with_by_id = {command.command_id: command for command in with_feature}

    assert "mode.castersustain" not in without_ids
    assert with_by_id["mode.castersustain"].literal == "/lac fwd sustain"
    assert with_by_id["mode.castersustain"].owner == "mode"
    assert with_by_id["mode.castersustain"].exempt_from_binding is True


def test_occult_acumen_command_is_feature_gated_and_exempt_from_binding() -> None:
    without_feature = default_forward_commands(playstyles=("Nuke",))
    with_feature = default_forward_commands(
        playstyles=("Nuke",),
        profile_features=(OCCULT_ACUMEN_MODE_FEATURE,),
    )
    without_ids = {command.command_id for command in without_feature}
    with_by_id = {command.command_id: command for command in with_feature}

    assert "mode.occultacumen" not in without_ids
    assert with_by_id["mode.occultacumen"].literal == "/lac fwd acumen"
    assert with_by_id["mode.occultacumen"].owner == "mode"
    assert with_by_id["mode.occultacumen"].exempt_from_binding is True


def test_guard_command_is_feature_gated_and_exempt_from_binding() -> None:
    without_feature = default_forward_commands(playstyles=("Damage",))
    with_feature = default_forward_commands(
        playstyles=("Damage",),
        profile_features=(GUARD_MODE_FEATURE,),
    )
    without_ids = {command.command_id for command in without_feature}
    with_by_id = {command.command_id: command for command in with_feature}

    assert "mode.guard" not in without_ids
    assert with_by_id["mode.guard"].literal == "/lac fwd guard"
    assert with_by_id["mode.guard"].owner == "mode"
    assert with_by_id["mode.guard"].exempt_from_binding is True


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
    assert literal_by_id["sam.meditate"] == "/lac fwd meditate"
    assert literal_by_id["sam.thirdeye"] == "/lac fwd thirdeye"


def test_number_row_palette_manifest_records_raw_profile_keys() -> None:
    palette = plan_number_row_palette(
        job="RDM",
        playstyles=("Cure", "Enspell"),
        available_sets={"Cure", "Enspell", "Craft", "Movement"},
    ).to_manifest()

    assert palette["keys"] == list(NUMBER_ROW_KEYS)
    assert palette["displayKeys"] == [".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ""]
    assert palette["bindings"][0]["key"] == "NUMPAD."
    assert palette["bindings"][0]["displayKey"] == "."
    assert palette["bindings"][0]["literal"] == "/lac fwd styleprev"
    assert palette["bindings"][8]["key"] == "NUMPAD7"
    assert palette["bindings"][8]["literal"] == "/lac fwd warp"
    assert palette["bindings"][6]["fallbackSets"][0] == "Craft"
    assert palette["unbound"] == ["slot12"]
