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
    assert (
        "elseif command == 'mechanics' then\n"
        "        profile.OddLuaRuntime.HandleMechanicsCommand(args);"
    ) in lua
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
    assert "Automatic mechanics execution is disabled" in lua


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


def test_rendered_lua_setmp_bridge_is_synchronous_and_fail_closed() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WHM",
        sets={
            "Aftercast": {"Body": "Oracle's Robe"},
            "IdleMaxMP": {"Body": "Cleric's Briault"},
        },
        default_playstyle="Aftercast",
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "Aftercast",
            "supportedOpportunities": ("hp_to_mp_pool_bridge",),
            "transitions": {},
            "skippedTransitions": {},
            "explicitTransitions": {
                "setmp": {
                    "available": True,
                    "sourceSet": "Aftercast",
                    "targetSet": "IdleMaxMP",
                    "sourceEquipment": {"Body": "Oracle's Robe"},
                    "sourceVariants": {},
                    "targetEquipment": {"Body": "Cleric's Briault"},
                    "slot": "Body",
                    "sourceItem": "Oracle's Robe",
                    "bridgeItem": "Dalmatica",
                    "finalItem": "Cleric's Briault",
                    "conversionAmount": 50,
                    "bridgeHpCost": 70,
                    "hpCost": 70,
                    "mpGain": 30,
                    "sourceKnownHp": 20,
                    "sourceKnownMp": 20,
                    "targetHp": 0,
                    "targetMp": 35,
                    "targetMpGain": 15,
                    "sourcePath": "cats-eye-equipment/Dalmatica.md",
                    "sourceText": "Converts 50 HP to MP",
                },
            },
        },
    )

    assert "MechanicsExecution = false," in lua
    assert "HpToMpBridgeInFlight = false," in lua
    assert "['explicitTransitions'] = {" in lua
    assert "['bridgeItem'] = 'Dalmatica'," in lua

    bridge = lua[
        lua.index("function profile.OddLuaRuntime.ExplicitSetMpBridgePlan()")
        : lua.index("\nlocal oddLuaWarpRing")
    ]
    for contract in (
        "plan.targetSet ~= 'IdleMaxMP'",
        "profile.OddLuaRuntime.PlayerContextReady(player) ~= true",
        "isEngaged(player) or isResting(player)",
        "state.Playstyle == 'Craft'",
        "state.WarpRingLocked == true",
        "state.IdleOverrideSet ~= nil",
        "profile.OddLuaRuntime.DangerousStatusState() ~= false",
        "profile.OddLuaRuntime.HasWeakness() ~= false",
        "StatusListState(profile.OddLuaRuntime.CurseStatusBuffs) ~= false",
        "profile.OddLuaRuntime.ActiveSafetyReason(player) ~= 'none'",
        "profile.OddLuaRuntime.ShouldEquipIdleCombat(player)",
        "isEmergencyHp(player)",
        "profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) ~= true",
        "hp == nil or maxHp == nil or mp == nil or maxMp == nil",
        "local observed = observeReconciliationEquipment();",
        "for slot, expected in pairs(plan.sourceEquipment) do",
        "not reconciliationNamesMatch(expected, observed[slot] or '')",
        "for slot, variants in pairs(plan.sourceVariants) do",
        "if targetMp < sourceMp then",
        "local requiredHpCost = math.max(tonumber(plan.bridgeHpCost), sourceHp - targetHp, 0);",
        "maxHp - hp < requiredHpCost",
    ):
        assert contract in bridge

    sequence = (
        "forceEquipInlineSet(bridgeSet, true)",
        "forceEquipInlineSet(plan.targetEquipment, true)",
        "forceEquipInlineSet(finalSet, true)",
    )
    positions = [bridge.index(contract) for contract in sequence]
    assert positions == sorted(positions)
    assert "local ok, result = pcall(function()" in bridge
    assert "pcall(forceEquipInlineSet, sourceSet, true)" in bridge
    assert "state.HpToMpBridgeInFlight = false;" in bridge
    assert "HP-to-MP bridge queued." in bridge
    assert "equipNamedSetIfNotClear(plan.targetSet" not in bridge
    assert "scheduleTask" not in bridge
    skipped = bridge[
        bridge.index("if allowed ~= true then")
        : bridge.index("    local bridgeSet = {};")
    ]
    assert "HP-to-MP bridge skipped:" in skipped
    assert "return true;" in skipped


def test_rendered_lua_invokes_pool_bridge_only_after_changed_setmp() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WHM",
        sets={
            "Aftercast": {"Body": "Oracle's Robe"},
            "IdleMaxMP": {"Body": "Cleric's Briault"},
        },
        default_playstyle="Aftercast",
    )

    handler = lua[
        lua.index("function profile.HandleIdlePoolCommand(args)")
        : lua.index("\nfunction profile.OddLuaPet.currentPetName()")
    ]
    setmp = handler[: handler.index("    elseif command == 'addmp' then")]
    remaining_commands = handler[handler.index("    elseif command == 'addmp' then") :]
    assert setmp.index("local changed = profile.OddLuaRuntime.UpdateIdlePoolField") < setmp.index(
        "if changed ~= true then"
    )
    assert setmp.index("if changed ~= true then") < setmp.index(
        "profile.OddLuaRuntime.TryExplicitSetMpBridge(getPlayer())"
    )
    assert "TryExplicitSetMpBridge" not in remaining_commands

    command = lua[
        lua.index("    elseif command == 'setmp' or command == 'addmp'")
        : lua.index("    elseif command == 'utility' then")
    ]
    assert "local changed, handled = profile.HandleIdlePoolCommand(args);" in command
    assert "if changed and handled ~= true then" in command
    assert "equipDefaultForPlayer(getPlayer(), true);" in command
