from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.renderer import render_profile


def test_generated_profile_has_help_styles_and_no_arg_help() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={
            "Damage": {"Body": "Haubergeon"},
            "Accuracy": {"Body": "Scorpion Harness"},
        },
        default_playstyle="Damage",
        playstyle_names=("Damage", "Accuracy"),
    )

    assert "local function printOddLuaHelp()" in lua
    assert "local function printStyleList()" in lua
    assert "if not args or not args[1] then\n        printOddLuaHelp();" in lua
    assert "if command == 'help' or command == '?' then" in lua
    assert "elseif command == 'styles' or command == 'stylelist' then" in lua


def test_generated_profile_status_and_unknown_style_point_to_help() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={
            "Damage": {"Body": "Haubergeon"},
            "Accuracy": {"Body": "Scorpion Harness"},
        },
        default_playstyle="Damage",
        playstyle_names=("Damage", "Accuracy"),
    )

    assert "help=/lac fwd help; styles=/lac fwd styles" in lua
    assert "message('Unknown style: ' .. tostring(args[2]) .. '.');" in lua
    assert "printStyleList();" in lua
    assert "message('Styles: ' .. styleListText() .. '. Use /lac fwd style <name>.');" in lua


def test_generated_profile_load_message_points_to_help_not_memorized_commands() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="THF",
        sets={"Melt": {"Main": "Thief's Knife"}},
        default_playstyle="Melt",
        playstyle_names=("Melt",),
    )

    assert "Use /lac fwd help for commands and one-button setup." in lua
    assert "Use /lac fwd style melt." not in lua


def test_generated_profile_exposes_live_reconciliation_controls() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={
            "Damage": {"Body": "Haubergeon", "Hands": "Dusk Gloves"},
            "Idle": {"Body": "Vermillion Cloak"},
        },
        default_playstyle="Damage",
        playstyle_names=("Damage",),
    )

    assert "ReconcileEnabled = true" in lua
    assert "local function observeReconciliationEquipment()" in lua
    assert "gData.GetEquipment" in lua
    assert "local function compareReconciliationSnapshot(setName, expected, observed)" in lua
    assert "local function writeReconciliationSnapshot(snapshot)" in lua
    assert "io.open(reconciliationConfig.logPath, 'ab')" in lua
    assert "local function scheduleReconciliationSnapshot(setName, expectedSet, force, repair)" in lua
    assert "scheduleTask(reconciliationDelayForSet(setName), function()" in lua
    assert "handleReconcileCommand(args)" in lua
    assert "elseif command == 'reconcile' then" in lua
    assert "reconcile on|off|status|last" in lua


def test_generated_profile_lockstyle_snapshots_tp_set() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "TP": {"Main": "Joytoy", "Sub": "Enhancing Sword"},
            "Melee": {"Main": "Joytoy", "Sub": "Enhancing Sword"},
            "Idle": {"Main": "Terra's Staff"},
        },
        default_playstyle="Melee",
        playstyle_names=("Melee",),
    )

    assert "lockstyle equips the TP set first" in lua
    assert "local function lockstyleCombatSet()" in lua
    assert "if not equipNamedSet('TP', true) then" in lua
    assert "if not equipNamedSet(setNameFor('Melee'), true) then" in lua
    assert "local function applyTpLockstyle()" in lua
    assert "queueTypedCommand('/lockstyle on', 1)" in lua
    assert "Lockstyle captured TP set." in lua
    assert "scheduleTask(0.3, applyTpLockstyle)" in lua
    assert "elseif command == 'lockstyle' or command == 'stylelock' then" in lua

    helper_index = lua.index("local function lockstyleCombatSet()")
    equip_index = lua.index("if not equipNamedSet('TP', true) then", helper_index)
    lockstyle_index = lua.index("queueTypedCommand('/lockstyle on', 1)", helper_index)
    assert equip_index < lockstyle_index


def test_generated_profile_schedules_reconciliation_after_each_named_set_equip() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={"Damage": {"Body": "Haubergeon"}},
        default_playstyle="Damage",
        playstyle_names=("Damage",),
    )

    equip_block = lua[lua.index("local function equipNamedSet(setName, force)") : lua.index("local function equipNamedSetIfNotClear")]

    assert "local equippedSet = resolvedReconciliationExpectedSet(setName, setToEquip, appliedSet, effectiveForce);" in equip_block
    assert "scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);" in equip_block
    assert "scheduleReconciliationSnapshot(setName, setToEquip, force);" not in equip_block


def test_generated_profile_reconciliation_models_final_expected_gear() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Main": "Terra's Staff", "Sub": "Omni Grip", "Legs": "Darksteel Subligar"},
            "Movement": {"Legs": "Blood Cuisses"},
            "Playstyle_Enspell": {"Main": "Somnia Melodiam", "Sub": "Egeking"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "ReconcilePendingSnapshot = nil" in lua
    assert "ReconcileScanScheduled = false" in lua
    assert "ReconcileLastRecordedSignature = nil" in lua
    assert "local function resolvedReconciliationExpectedSet(setName, requestedSet, appliedSet, force)" in lua
    assert "expectedSetWithProtectedWeapons(expectedSet, requestedSet, setIntents[setName])" in lua
    assert "conditionals.BuildOverlay(conditionalEquips[setName], reconciliationEquipContext(force))" in lua
    assert "local function reconciliationExpectedSignature(setName, expected)" in lua
    assert "local function recordPendingReconciliationSnapshot(token)" in lua
    assert "state.ReconcilePendingSnapshot = {" in lua
    assert "if repair ~= true and signature == state.ReconcileLastRecordedSignature then" in lua
    assert "state.ReconcileLastRecordedSignature = pending.signature;" in lua
    assert "status = 'superseded'" not in lua


def test_generated_profile_repairs_stable_reconciliation_mismatches_once() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Playstyle_Enspell": {
                "Main": "Somnia Melodiam",
                "Sub": "Egeking",
                "Ring2": "Sniper's Ring",
                "Back": "Grapevine Cape",
            },
            "Enfeebling": {
                "Ring2": "Insect Ring",
                "Back": "Oneiros Cape",
            },
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "local function reconciliationCanRepairIntent(intent)" in lua
    assert "return intentText == 'tp' or intentText == 'idle' or intentText == 'movement';" in lua
    assert "local repairReconciliationMismatch;" in lua
    assert "repairReconciliationMismatch = function(pending)" in lua
    assert "if pending.repair == true or not reconciliationCanRepairIntent(pending.intent) then" in lua
    assert "scale.ForceEquipSet(pending.set, pending.expected, pending.intent);" in lua
    assert "scheduleReconciliationSnapshot(pending.set, pending.expected, true, true);" in lua
    assert "if repair ~= true and signature == state.ReconcileLastRecordedSignature then" in lua
    assert (
        "if state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.repair == true "
        "and state.ReconcilePendingSnapshot.signature == signature then"
    ) in lua
    assert "repair = repair == true," in lua
    assert "snapshot.repair = pending.repair == true;" in lua
    assert '"repair":' in lua


def test_generated_profile_suppresses_chat_for_queued_reconciliation_repairs() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Playstyle_Enspell": {
                "Main": "Somnia Melodiam",
                "Sub": "Octave Club",
                "Ring2": "Sniper's Ring",
                "Back": "Grapevine Cape",
            },
            "Cure": {
                "Ring2": "Aqua Ring",
                "Back": "Hierarch's Mantle",
            },
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "if snapshot.status == 'mismatch' and snapshot.repairQueued ~= true then" in lua
    assert "if snapshot.status == 'mismatch' then\n        local repairText = '';" not in lua


def test_generated_profile_forces_next_stable_equip_after_action_gear() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Playstyle_Enspell": {
                "Main": "Somnia Melodiam",
                "Sub": "Octave Club",
                "Ring2": "Sniper's Ring",
                "Back": "Grapevine Cape",
            },
            "Cure": {
                "Ring2": "Aqua Ring",
                "Back": "Hierarch's Mantle",
            },
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    equip_block = lua[lua.index("local function equipNamedSet(setName, force)") : lua.index("local function equipNamedSetIfNotClear")]

    assert "StableEquipForcePending = false" in lua
    assert "local function isStableEquipIntent(setName)" in lua
    assert "local function stableEquipForceForSet(setName, setToEquip, force)" in lua
    assert "not isClearSet(setToEquip)" in lua
    assert "state.StableEquipForcePending = false;" in lua
    assert "local effectiveForce = stableEquipForceForSet(setName, setToEquip, force);" in equip_block
    assert "elseif effectiveForce == true and scale and scale.ForceEquipSet then" in equip_block
    assert "markStableEquipForceNeeded(setName, effectiveForce);" in equip_block


def test_generated_profile_skips_clear_placeholders_in_fallback_routes() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="SAM",
        sets={
            "Meditate": {},
            "JobAbility": {
                "Main": "Koryukagemitsu",
                "Sub": "Tenax Strap",
            },
        },
        default_playstyle="JobAbility",
        playstyle_names=("JobAbility",),
    )

    meditate_block = lua[lua.index("    Meditate = {") : lua.index("    },", lua.index("    Meditate = {"))]
    fallback_block = lua[lua.index("local function equipFirstAvailable") : lua.index("local function canonicalElement")]

    assert "Main = 'remove'," in meditate_block
    assert "equipNamedSetIfNotClear(setName, force)" in fallback_block
    assert "equipNamedSet(setName, force)" not in fallback_block


def test_generated_profile_can_launch_fixed_gear_refresh_workflow() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Playstyle_Enspell": {"Main": "Somnia Melodiam"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "refreshgear" in lua
    assert "local oddLuaRefresh = {" in lua
    assert "launcher =" in lua
    assert "Run-OddLuaGameRefresh.cmd" in lua
    assert "statusPath =" in lua
    assert "latest-status.json" in lua
    assert "local function startOddLuaGearRefresh(args)" in lua
    assert "queueTypedCommand('/gearexport full', 1)" in lua
    assert "queueTypedCommand('/gearexport resources', 1)" in lua
    assert "ashita.misc.execute(oddLuaRefresh.launcher, '')" in lua
    assert "local function pollOddLuaRefreshStatus(attempt)" in lua
    assert "queueTypedCommand('/lac reload', 1)" in lua
    assert "elseif command == 'refreshgear' or command == 'reprocessgear' or command == 'rebuildgear' then" in lua
    assert "startOddLuaGearRefresh(args);" in lua
    assert "os.execute" not in lua


def test_generated_profile_binds_raw_number_row_from_loaded_profile_palette() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Cure": {"Main": "Chatoyant Staff"},
            "Enspell": {"Main": "Joyeuse"},
            "Craft": {"Body": "Protective Spectacles"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Cure", "Enspell"),
        number_row_palette={
            "keys": ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="],
            "bindings": [
                {
                    "key": "1",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "2",
                    "id": "style.next",
                    "label": "Style+",
                    "literal": "/lac fwd stylenext",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "3",
                    "id": "styles",
                    "label": "Styles",
                    "literal": "/lac fwd styles",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "4",
                    "id": "warp",
                    "label": "Warp",
                    "literal": "/lac fwd warp",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
            ],
            "unbound": [],
        },
    )

    assert "local numberRowBindings = {" in lua
    assert "{ key = '1', label = 'Style-', literal = '/lac fwd styleprev'" in lua
    assert "queueTypedCommand('/bind 1 /lac fwd styleprev', -1)" in lua
    assert "queueTypedCommand('/unbind 1', -1)" in lua
    assert "function oddLuaNumberRow.bindPalette()" in lua
    assert "function oddLuaNumberRow.unbindPalette()" in lua
    assert "oddLuaNumberRow.bindPalette();" in lua
    assert "oddLuaNumberRow.unbindPalette();" in lua


def test_generated_profile_handles_style_cycle_and_palette_toggle_commands() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Cure": {"Main": "Chatoyant Staff"}, "Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Cure", "Enspell"),
    )

    assert "NumberRowPaletteEnabled = true" in lua
    assert "function oddLuaNumberRow.cyclePlaystyle(delta)" in lua
    assert "elseif command == 'styleprev' or command == 'styleback' then" in lua
    assert "oddLuaNumberRow.cyclePlaystyle(-1);" in lua
    assert "elseif command == 'stylenext' or command == 'stylefwd' then" in lua
    assert "oddLuaNumberRow.cyclePlaystyle(1);" in lua
    assert "elseif command == 'palette' or command == 'numberrow' then" in lua
    assert "oddLuaNumberRow.setPaletteEnabled(value);" in lua


def test_generated_profile_utility_fallback_prints_missing_equipment_message() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={"Damage": {"Body": "Haubergeon"}},
        default_playstyle="Damage",
        playstyle_names=("Damage",),
    )

    assert "utilityFallbacks = {" in lua
    assert "craft = { 'Craft', 'Fishing', 'Gathering', 'Clamming', 'Movement', 'Resting', 'Treasure', 'Survival' }" in lua
    assert "movement = { 'Movement', 'Movement_City', 'Movement_Night', 'Movement_DuskToDawn', 'InCity', 'Survival' }" in lua
    assert "function oddLuaNumberRow.equipUtilityIntent(intent)" in lua
    assert "message('Not Applicable / Missing Equipment');" in lua
    assert "elseif command == 'utility' then" in lua
    assert "oddLuaNumberRow.equipUtilityIntent(value);" in lua


def test_generated_profile_renders_loaded_profile_overlay_without_telemetry() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "local oddLuaNumberRow = {" in lua
    assert "renderEvent =" in lua
    assert "pcall(require, 'imgui')" in lua
    assert "function oddLuaNumberRow.renderOverlay()" in lua
    assert "OddLua Tester_1 RDM" in lua
    assert "imgui.TextColored(onColor, binding.key .. ' ' .. binding.label);" in lua
    assert "imgui.TextColored(offColor, binding.key .. ' ' .. binding.label);" in lua
    assert "ashita.events.register('d3d_present', oddLuaNumberRow.renderEvent, oddLuaNumberRow.renderOverlay)" in lua
    assert "ashita.events.unregister('d3d_present', oddLuaNumberRow.renderEvent)" in lua
    assert "SAM / DRG / RDM" not in lua
    assert "DPS" not in lua
    assert "HPS" not in lua
    assert "damage taken" not in lua.lower()
    assert "+MP" not in lua
    assert "+HP" not in lua


def test_warp_ring_flow_is_single_press_and_unlocks_ring2_after_use() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    use_block = lua[lua.index("local function useWarpRing()") : lua.index("local function equipFirstAvailable")]

    assert "forceEquipInlineSet({ Ring2 = 'Warp Ring' }, true)" in use_block
    assert "oddLuaWarpRing.lockRing2();" in use_block
    assert "scheduleTask(10, oddLuaWarpRing.finishUse)" in use_block
    assert "Press the bound warp key again" not in use_block
    assert "Warp Ring flow already running." in use_block
