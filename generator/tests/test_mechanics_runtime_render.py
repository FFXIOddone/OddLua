from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.renderer import render_profile


def test_rendered_lua_exports_default_off_mechanics_probe_commands() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Nuke": {"Body": "Nuke Robe", "Ring1": "Bridge Ring"},
        },
        default_playstyle="Nuke",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": ("hp_bridge_swap", "mp_bridge_swap"),
            "transitions": {
                "Nuke": {
                    "sourceSet": "Aftercast",
                    "targetSet": "Nuke",
                    "warnings": ("final_hp_pool_lower",),
                    "actions": (
                        {
                            "key": "pool_bridge_transition",
                            "phase": "equip_pool_gain",
                            "slot": "Ring1",
                            "item": "Bridge Ring",
                            "reason": "pool delta HP+120",
                        },
                    ),
                },
            },
        },
    )

    assert "MechanicsProbes = false," in lua
    assert "MechanicsExecution = false," in lua
    assert "local mechanicsSwapPlanner = {" in lua
    assert "['baselineSet'] = 'Aftercast'," in lua
    assert "['Nuke'] = {" in lua
    assert "local function handleMechanicsCommand(args)" in lua
    assert "elseif command == 'mechanics' then\n        handleMechanicsCommand(args);" in lua
    assert "mechanics probes on|off" in lua
    assert "mechanics plan <set>" in lua
    assert "mechanics probe <set>" in lua


def test_rendered_lua_chunks_mechanics_planner_transitions_for_luajit() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Nuke": {"Body": "Nuke Robe"},
            "Cure": {"Body": "Cure Robe"},
        },
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": ("hp_bridge_swap",),
            "transitions": {
                "Nuke": {"actions": [], "warnings": ["final_hp_pool_lower"]},
                "Cure": {"actions": [], "warnings": []},
            },
            "skippedTransitions": {"Movement": "utility_set"},
        },
    )

    mechanics_block = lua[lua.index("local mechanicsSwapPlanner") : lua.index("local OVERT_DEFENSE_TARGET_COUNT")]

    assert "['transitions'] = {}," in mechanics_block
    assert "['skippedTransitions'] = {}," in mechanics_block
    assert "mechanicsSwapPlanner.transitions['Nuke'] =" in mechanics_block
    assert "mechanicsSwapPlanner.transitions['Cure'] =" in mechanics_block
    assert "mechanicsSwapPlanner.skippedTransitions['Movement'] = 'utility_set';" in mechanics_block
    assert "['transitions'] = {\n        ['Nuke']" not in mechanics_block


def test_rendered_lua_mechanics_probe_surface_does_not_auto_execute_actions() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Aftercast": {"Body": "HP Vest"}},
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {},
        },
    )

    mechanics_block = lua[lua.index("local mechanicsSwapPlanner") : lua.index("local OVERT_DEFENSE_TARGET_COUNT")]
    assert "gFunc.Equip" not in mechanics_block
    assert "ForceEquip" not in mechanics_block
    assert "scale.EquipSet" not in mechanics_block
    assert "Mechanics execution is disabled" in lua


def test_rendered_lua_mechanics_plan_reports_intentionally_skipped_transitions() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Movement_Night": {"Feet": "Strider Boots"},
        },
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {},
            "skippedTransitions": {"Movement_Night": "utility_set"},
        },
    )

    assert "local function mechanicsSkipReasonForSet(setName)" in lua
    assert "Mechanics transition skipped for " in lua
    assert "mechanicsSwapPlanner.skippedTransitions" in lua


def test_rendered_lua_mechanics_target_lookup_uses_playstyle_aliases() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Nuke": {"Body": "Nuke Robe"},
        },
        default_playstyle="Nuke",
        playstyle_names=("Nuke",),
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {"Playstyle_Nuke": {"actions": [], "warnings": []}},
            "skippedTransitions": {},
        },
    )

    target_lookup = lua[lua.index("local function mechanicsTargetSet") : lua.index("local function printMechanicsPlan")]
    assert "local alias = styleAliases[normalize(setName)];" in target_lookup
    assert "if alias and sets['Playstyle_' .. alias] then" in target_lookup
    assert "return 'Playstyle_' .. alias;" in target_lookup


def test_rendered_lua_mechanics_status_reports_transition_and_skip_counts() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Aftercast": {"Body": "HP Vest"}},
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {"Nuke": {"actions": [], "warnings": []}},
            "skippedTransitions": {"Movement": "utility_set"},
        },
    )

    status_block = lua[lua.index("local function mechanicsStatus") : lua.index("local function handleMechanicsCommand")]
    assert "local transitionCount = tableCount(mechanicsSwapPlanner and mechanicsSwapPlanner.transitions);" in status_block
    assert "local skippedCount = tableCount(mechanicsSwapPlanner and mechanicsSwapPlanner.skippedTransitions);" in status_block
    assert "local actionCount, warningCount = mechanicsPlanActionWarningCounts();" in status_block
    assert "local plannerVersion = mechanicsSwapPlanner and mechanicsSwapPlanner.plannerVersion or 0;" in status_block
    assert "'; version=' .. tostring(plannerVersion)" in status_block
    assert "'; transitions=' .. tostring(transitionCount)" in status_block
    assert "'; skipped=' .. tostring(skippedCount)" in status_block
    assert "'; actions=' .. tostring(actionCount)" in status_block
    assert "'; warnings=' .. tostring(warningCount)" in status_block


def test_rendered_lua_mechanics_list_reports_available_transition_names() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Nuke": {"Body": "Nuke Robe"},
            "Movement": {"Feet": "Strider Boots"},
        },
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {"Nuke": {"actions": [], "warnings": []}},
            "skippedTransitions": {"Movement": "utility_set"},
        },
    )

    list_block = lua[lua.index("local function sortedMechanicsKeys") : lua.index("local function mechanicsStatus")]
    command_block = lua[lua.index("local function handleMechanicsCommand") : lua.index("local function setNameFor")]
    assert "local function printMechanicsList()" in list_block
    assert "table.sort(names);" in list_block
    assert "Mechanics planned sets (" in list_block
    assert "Mechanics skipped sets (" in list_block
    assert "mechanics list" in command_block
    assert "elseif subcommand == 'list' then" in command_block
    assert "printMechanicsList();" in command_block


def test_rendered_lua_mechanics_warnings_reports_warning_type_counts() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Nuke": {"Body": "Nuke Robe"},
        },
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {
                "Nuke": {"actions": [], "warnings": ["final_hp_pool_lower"]},
            },
            "skippedTransitions": {},
        },
    )

    warnings_block = lua[lua.index("local function mechanicsWarningTypeCounts") : lua.index("local function mechanicsStatus")]
    command_block = lua[lua.index("local function handleMechanicsCommand") : lua.index("local function setNameFor")]
    assert "local function printMechanicsWarnings()" in warnings_block
    assert "Mechanics warning types: none." in warnings_block
    assert "Mechanics warning type " in warnings_block
    assert "mechanics warnings" in command_block
    assert "elseif subcommand == 'warnings' then" in command_block
    assert "printMechanicsWarnings();" in command_block


def test_rendered_lua_mechanics_skipped_reports_skip_reason_counts() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Body": "HP Vest"},
            "Movement": {"Feet": "Strider Boots"},
        },
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": (),
            "transitions": {},
            "skippedTransitions": {"Movement": "utility_set"},
        },
    )

    skipped_block = lua[lua.index("local function mechanicsSkippedReasonCounts") : lua.index("local function mechanicsStatus")]
    command_block = lua[lua.index("local function handleMechanicsCommand") : lua.index("local function setNameFor")]
    assert "local function printMechanicsSkipped()" in skipped_block
    assert "Mechanics skipped reasons: none." in skipped_block
    assert "Mechanics skipped reason " in skipped_block
    assert "mechanics skipped" in command_block
    assert "elseif subcommand == 'skipped' then" in command_block
    assert "printMechanicsSkipped();" in command_block
