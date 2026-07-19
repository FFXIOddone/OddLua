from pathlib import Path
import shutil
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.renderer import render_profile
from oddlua.planning.number_row_palette import plan_number_row_palette


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

    assert "keypad=/lac fwd keypad" in lua
    assert (
        "; keypad=' .. keypadText .. '; buffitems=' .. buffItemsText .. "
        "'; burst=' .. (state.MagicBurstMode and 'on' or 'off') .. "
        "'; override=' .. profile.OverrideStateText() .. '; safety=' .. "
        "profile.OddLuaRuntime.ActiveSafetyReason(getPlayer()) .. '; mpfloor=' .. profile.IdlePoolStateText() .. "
        "'; help=/lac fwd help; styles=/lac fwd styles; keypad=/lac fwd keypad"
    ) in lua
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


def test_generated_profile_help_keeps_developer_commands_out_of_normal_runtime_help() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    help_block = lua[lua.index("local function printOddLuaHelp()") : lua.index("local function oddLuaStatusField")]

    assert "/lac fwd help | styles | status | keypad | lockstyle | weaponsync | warp | subjob | buffitems | pdt | fireres." in help_block
    assert "Buff item overlays: /lac fwd buffitems on|off|status." in help_block
    assert "Defensive overrides: /lac fwd pdt|mdt|dt|evasion|safe|survival|tank|defenseoff." in help_block
    assert (
        "Resist overrides: /lac fwd fireres|iceres|earthres|windres|waterres|thunderres|lightningres|lightres|darkres|statusres|charmres|resoff."
        in help_block
    )
    assert "Idle pool floors: /lac fwd setmp <n>|addmp <n>|resetmp and sethp <n>|addhp <n>|resethp." in help_block
    assert "Update gear: /lac fwd updategear" in help_block
    assert "mechanics help" not in help_block
    assert "reconcile status" not in help_block
    assert "refreshgear" not in help_block
    assert "keybindings.txt" not in help_block


def test_generated_profile_exposes_rag_style_resist_overrides_without_keybind_churn() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={
            "Damage": {"Body": "Haubergeon"},
            "FireRes": {"Body": "Crimson Scale Mail"},
            "LightningRes": {"Body": "Coral Scale Mail"},
            "StatusResist": {"Head": "Elegant Ribbon"},
            "CharmResist": {"Head": "Walahra Turban"},
        },
        default_playstyle="Damage",
        playstyle_names=("Damage",),
    )

    assert "IdleOverrideSet = nil" in lua
    assert "profile.ResistAliases = {" in lua
    assert "fireres = 'FireRes'" in lua
    assert "thunderres = 'ThunderRes'" in lua
    assert "lightningres = 'LightningRes'" in lua
    assert "statusres = 'StatusResist'" in lua
    assert "charmres = 'CharmResist'" in lua
    assert "resoff = ''" in lua
    assert "profile.DefenseAliases = {" in lua
    assert "pdt = 'PDT'" in lua
    assert "mdt = 'MDT'" in lua
    assert "dt = 'Dt'" in lua
    assert "defenseoff = ''" in lua
    assert "function profile.HandleOverrideCommand(args)" in lua
    assert "function profile.HandleResistCommand(args)" in lua
    assert "if state.IdleOverrideSet == nil or state.IdleOverrideSet == '' then" in lua
    assert "if state.IdleOverrideSet == setName then" in lua
    assert "message(messageLabel .. '=off.');\n            return false;" in lua
    assert "message(messageLabel .. '=off.');\n        return true;" in lua
    assert (
        "elseif command == 'override' or command == 'defense' or command == 'def' "
        "or profile.DefenseAliases[command] ~= nil then"
    ) in lua
    assert "if profile.HandleOverrideCommand(args) then" in lua
    assert "elseif command == 'resist' or command == 'res' or profile.ResistAliases[command] ~= nil then" in lua
    assert "if profile.HandleResistCommand(args) then" in lua
    assert "elseif state.IdleOverrideSet ~= nil" in lua
    assert "if profile.OddLuaRuntime.EquipManualOverrideSet(state.IdleOverrideSet, force) then" in lua
    assert "override=' .. profile.OverrideStateText()" in lua
    defensive_start = lua.index("local function firstAvailableDefensiveSet()")
    defensive_end = lua.index("\nlocal function providedThreatEntities", defensive_start)
    default_start = lua.index("local function equipDefaultForPlayer(player, force)")
    default_end = lua.index("\nlocal oddLuaNumberRow", default_start)
    assert "StatusResist" not in lua[defensive_start:defensive_end]
    assert "CharmResist" not in lua[defensive_start:defensive_end]
    assert "'StatusResist'" not in lua[default_start:default_end]
    assert "'CharmResist'" not in lua[default_start:default_end]
    assert "Unknown resist command. Use fireres|iceres|earthres|windres|waterres|thunderres|lightningres|lightres|darkres|statusres|charmres|resoff." in lua
    assert "'/bind" not in lua[lua.index("profile.ResistAliases = {") : lua.index("local oddLuaRefresh = {")]


def test_generated_profile_composes_manual_overrides_from_one_deterministic_base() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={
            "Damage": {"Main": "Bravura", "Body": "Haubergeon"},
            "PlannerBase": {
                "Main": "Bravura",
                "Body": "Haubergeon",
                "Hands": "Dusk Gloves",
                "Feet": "Dusk Ledelsens",
            },
            "Aftercast": {"Main": "Bravura", "Body": "Haubergeon"},
            "Idle": {"Main": "Bravura", "Body": "Vermillion Cloak"},
            "FireRes": {"Body": "Crimson Scale Mail", "Hands": "remove"},
        },
        default_playstyle="Damage",
        playstyle_names=("Damage",),
        mechanics_swap_planner={
            "loaded": True,
            "baselineSet": "PlannerBase",
            "transitions": {
                "FireRes": {
                    "sourceSet": "PlannerBase",
                    "targetSet": "FireRes",
                    "actions": [],
                    "warnings": [],
                    "poolSummaries": {},
                }
            },
            "skippedTransitions": {},
        },
    )

    source_start = lua.index("function profile.OddLuaRuntime.ManualOverrideSourceSetName(setName)")
    source_end = lua.index("function profile.OddLuaRuntime.BuildManualOverrideSet(setName)", source_start)
    source = lua[source_start:source_end]
    assert "type(mechanicsSwapPlanner.transitions) == 'table'" in source
    assert "transition = mechanicsSwapPlanner.transitions[setName];" in source
    planner_source = source.index("transition.sourceSet")
    planner_baseline = source.index("mechanicsSwapPlanner.baselineSet", planner_source)
    aftercast_fallback = source.index("'Aftercast'", planner_baseline)
    idle_fallback = source.index("'Idle'", aftercast_fallback)
    assert planner_source < planner_baseline < aftercast_fallback < idle_fallback
    assert "type(sets[candidate]) == 'table' and not isClearSet(sets[candidate])" in source

    compose_start = source_end
    compose_end = lua.index("function profile.OddLuaRuntime.EquipManualOverrideSet(setName, force)", compose_start)
    compose = lua[compose_start:compose_end]
    assert "local targetSet = sets[setName];" in compose
    assert "local sourceSetName = profile.OddLuaRuntime.ManualOverrideSourceSetName(setName);" in compose
    assert "local composedSet = overlayEquipSet(sets[sourceSetName], targetSet);" in compose
    assert "for _, slot in ipairs(equipmentSlots) do" in compose
    assert "if composedSet[slot] == nil then" in compose
    assert "composedSet[slot] = 'remove';" in compose
    assert "return composedSet, sourceSetName;" in compose

    overlay_start = lua.index("local function overlayEquipSet(baseSet, overlay)")
    overlay_end = lua.index("local function equipProfileSlotsDroppedByScale", overlay_start)
    overlay = lua[overlay_start:overlay_end]
    assert "local result = copyEquipSet(baseSet);" in overlay
    assert "for slot, item in pairs(overlay) do" in overlay
    assert "result[slot] = item;" in overlay
    assert overlay.index("copyEquipSet(baseSet)") < overlay.index("result[slot] = item")
    assert "Hands = 'remove'" in lua

    guarded_start = lua.index("function profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, requestedSet)")
    guarded_end = lua.index("local function equipProfileSlotsDroppedByScale", guarded_start)
    guarded = lua[guarded_start:guarded_end]
    assert "local bypassSlots = scaleWeaponGuardBypassSlotsBySet[setName] or {};" in guarded
    assert "for slot, _ in pairs(reconciliationProtectedWeaponSlots) do" in guarded
    assert "if bypassSlots[slot] ~= true then" in guarded
    assert "guardedSet[slot] = nil;" in guarded

    named_start = lua.index("local function equipNamedSet(setName, force, requestedSet)")
    named_end = lua.index("local function equipNamedSetIfNotClear", named_start)
    named = lua[named_start:named_end]
    warp_start = named.index("if state.WarpRingLocked == true then")
    warp_end = named.index("local appliedSet = setToEquip;", warp_start)
    warp = named[warp_start:warp_end]
    assert "pcall(scale.ResolveSet, setName, setToEquip, setIntents[setName])" in warp
    assert "ScaleGuardedDirectEquipSet(setName, setToEquip)" in warp
    assert warp.index("pcall(scale.ResolveSet") < warp.index("applyWarpRingLock(appliedLockedSet)")
    assert "resolvedReconciliationExpectedSet(setName, requestedLockedSet, appliedLockedSet" in warp
    assert "if usedScaleResolver ~= true then" in named
    assert named.count("ScaleGuardedDirectEquipSet(setName, setToEquip)") >= 3

    equip_start = compose_end
    equip_end = lua.index("local function equipOvertDefensiveSet", equip_start)
    equip = lua[equip_start:equip_end]
    assert "local composedSet = profile.OddLuaRuntime.BuildManualOverrideSet(setName);" in equip
    assert "if type(composedSet) ~= 'table' then" in equip
    assert "return false;" in equip
    assert "return equipNamedSet(setName, force, composedSet);" in equip
    assert equip.count("equipNamedSet(setName, force, composedSet)") == 1
    assert "equipNamedSetIfNotClear(setName, force)" not in equip

    setter_start = lua.index("function profile.SetIdleOverrideSet(setName, label)")
    setter_end = lua.index("function profile.HandleOverrideCommand(args)", setter_start)
    setter = lua[setter_start:setter_end]
    assert "local composedSet = profile.OddLuaRuntime.BuildManualOverrideSet(setName);" in setter
    assert "message('Not Applicable / Missing Override Baseline');" in setter
    assert "return false;" in setter

    stable_start = lua.index("local function isStableEquipIntent(setName)")
    stable_end = lua.index("local function stableEquipForceForSet", stable_start)
    stable = lua[stable_start:stable_end]
    assert "if state.IdleOverrideSet == setName then" in stable
    assert "return true;" in stable

    default_start = lua.index("local function equipDefaultForPlayer(player, force)")
    default_end = lua.index("\nlocal oddLuaNumberRow", default_start)
    default = lua[default_start:default_end]
    assert "profile.OddLuaRuntime.EquipManualOverrideSet(state.IdleOverrideSet, force)" in default
    assert "state.IdleOverrideSet = nil;" in default
    assert "return equipDefaultForPlayer(player, force);" in default
    assert "equipNamedSetIfNotClear(state.IdleOverrideSet, force)" not in default


def test_generated_profile_routes_weakness_and_explains_active_safety_reason() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="MNK",
        sets={
            "Damage": {"Main": "Maochinoli", "Body": "Shura Togi"},
            "PDT": {"Body": "Arhat's Gi"},
            "Guard": {"Feet": "Melee Gaiters"},
        },
        default_playstyle="Damage",
        playstyle_names=("Damage",),
        profile_features=("guard_mode",),
    )

    assert "profile.OddLuaRuntime.WeaknessStatusBuffs = { 'weakness', 1 };" in lua
    default_start = lua.index("local function equipDefaultForPlayer(player, force)")
    default_end = lua.index("\nlocal oddLuaNumberRow", default_start)
    default = lua[default_start:default_end]
    dangerous_position = default.index("if hasDangerousStatus()")
    weakness_position = default.index(
        "elseif profile.OddLuaRuntime.HasWeakness() == true",
        dangerous_position,
    )
    resting_position = default.index("elseif player and isResting(player)", weakness_position)
    assert dangerous_position < weakness_position < resting_position
    assert "local defensiveSet = firstAvailableDefensiveSet();" in default

    reason_start = lua.index("function profile.OddLuaRuntime.ActiveSafetyReason(player)")
    reason_end = lua.index("\nlocal function applyWarpRingLock", reason_start)
    reason = lua[reason_start:reason_end]
    ordered = (
        "'dangerous-status'",
        "'weakness'",
        "'manual-override'",
        "'overt-threat'",
        "'emergency-hp'",
    )
    positions = [reason.index(token) for token in ordered]
    assert positions == sorted(positions)
    assert "shouldEquipOvertDefense(player) ~= nil" in reason
    assert "isEmergencyHp(player) and firstAvailableDefensiveSet() ~= nil" in reason
    assert "WeaknessUntil" not in lua
    assert "WeaknessMode" not in lua
    assert "; safety=' .. profile.OddLuaRuntime.ActiveSafetyReason(getPlayer())" in lua


def test_generated_profile_exposes_rag_style_idle_pool_threshold_commands_without_keybind_churn() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Joyeuse"},
            "IdleNonCombat": {"Body": "Vermillion Cloak"},
            "IdleMaxMP": {"Ring1": "Ether Ring"},
            "IdleMaxHP": {"Ring1": "Bomb Queen Ring"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "IdleMaxMPThreshold = 0" in lua
    assert "IdleMaxMPAdd = 0" in lua
    assert "IdleMaxHPThreshold = 0" in lua
    assert "IdleMaxHPAdd = 0" in lua
    assert "function profile.IdlePoolStateText()" in lua
    assert "function profile.HandleIdlePoolCommand(args)" in lua
    assert "profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player)" in lua
    assert "profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player)" in lua
    assert "profile.OddLuaRuntime.EquipIdleContextSet('IdleMaxMP', force)" in lua
    assert "profile.OddLuaRuntime.EquipIdleContextSet('IdleMaxHP', force)" in lua
    assert "elseif command == 'setmp' or command == 'addmp' or command == 'resetmp'" in lua
    assert "or command == 'sethp' or command == 'addhp' or command == 'resethp' then" in lua
    assert "mpfloor=' .. profile.IdlePoolStateText()" in lua
    assert "'/bind" not in lua[lua.index("function profile.HandleIdlePoolCommand(args)") : lua.index("local oddLuaRefresh = {")]


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
    assert "scheduleReconciliationSnapshot = function(setName, expectedSet, force, repair, repairAttempt, options)" in lua
    assert "local metadata = type(options) == 'table' and options or {};" in lua
    assert "local actionProbeSequence = metadata.actionProbeSequence;" in lua
    assert "snapshot.actionProbeSequence = pending.actionProbeSequence" in lua
    assert "'\"actionProbeSequence\":' .. reconciliationJsonEscape(snapshot.actionProbeSequence)" in lua
    assert "signature = signature .. '|actionProbeSequence=' .. actionProbeSequence" in lua
    assert "local delaySeconds = tonumber(metadata.delaySeconds) or reconciliationDelayForSet(setName);" in lua
    assert "ReconcileCycleSeq = 0" in lua
    assert "gData.GetEquipment returned empty table" in lua
    assert "function profile.OddLuaRuntime.GetEnvironment()" in lua
    assert "return profile.OddLuaRuntime.GetEnvironment();" in lua
    assert "function profile.OddLuaRuntime.ReconciliationContextSignature()" in lua
    for context_field in (
        "moving=",
        "mainJob=",
        "mainLevel=",
        "subJob=",
        "subLevel=",
        "tpPositive=",
        "status=",
        "zone=",
        "area=",
        "movementSafety=",
    ):
        assert context_field in lua
    assert "and contextSignature == scheduled.contextSignature" in lua
    assert lua.count("if profile.OddLuaRuntime.ReconciliationContextMatches(superseding) ~= true then") == 2
    assert "contextSignature = superseding.contextSignature," in lua
    assert "profileBuildToken = profileBuildToken," in lua
    assert "cycleSequence = cycleSequence," in lua
    assert "contextSignature = contextSignature," in lua
    assert "observationOnly = observationOnly," in lua
    assert "snapshot.observationOnly ~= true" in lua
    assert "profile.OddLuaRuntime.ReconciliationObservationSettleSeconds = 0.25;" in lua
    for json_field in (
        '"profileBuildToken":',
        '"cycleSequence":',
        '"contextSignature":',
        '"observationOnly":',
        '"repairFailed":',
    ):
        assert json_field in lua
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

    equip_block = lua[lua.index("local function equipNamedSet(setName, force, requestedSet)") : lua.index("local function equipNamedSetIfNotClear")]

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
    assert "buildConditionalOverlayForSet(setName, reconciliationEquipContext(force))" in lua
    assert "local function reconciliationExpectedSignature(setName, expected)" in lua
    assert "local function recordPendingReconciliationSnapshot(token)" in lua
    assert "state.ReconcilePendingSnapshot = {" in lua
    assert "and signature == state.ReconcileLastRecordedSignature" in lua
    assert "state.ReconcileLastRecordedSignature = pending.signature;" in lua
    assert "status = 'superseded'" not in lua


def test_generated_profile_applies_missing_buff_item_overlays() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="DRG",
        sets={"Idle": {"Head": "Wanderer's Chapeau"}},
        default_playstyle="Idle",
        playstyle_names=("Idle",),
        buff_item_overlays={
            "Idle": (
                {
                    "condition": {
                        "type": "missing_status",
                        "name": "reraise",
                        "buffs": ("reraise",),
                    },
                    "slots": {"Head": "Reraise Hairpin"},
                    "afterUse": {"Head": "Wanderer's Chapeau"},
                    "item": {
                        "id": 15211,
                        "name": "Reraise Hairpin",
                        "effect": "reraise",
                        "sourcePath": "scripts/items/reraise_hairpin.lua",
                    },
                },
            )
        },
    )

    assert "profile.BuffItemOverlays = {" in lua
    assert "type = 'missing_status'" in lua
    assert "name = 'reraise'" in lua
    assert "slots = { Head = 'Reraise Hairpin' }" in lua
    assert "afterUse = { Head = 'Wanderer\\'s Chapeau' }" in lua
    assert "profile.ApplyBuffItemOverlaysForSet(setName, effectiveForce);" in lua
    assert "local afterUseOverlay = profile.BuffItemAfterUseOverlayForSet(setName, force);" in lua
    assert "function profile.BuffItemAfterUseOverlayForSet(setName, force)" in lua
    assert "local function setOwnsSlot(slot)" in lua
    assert "if normalize(item) ~= 'remove' or setOwnsSlot(slot) then" in lua
    assert "profile.BuffItemOverlayForSet(setName, force)" in lua
    assert "expectedSet = overlayEquipSet(expectedSet, profile.BuffItemAfterUseOverlayForSet(setName, force));" in lua
    assert "expectedSet = overlayEquipSet(expectedSet, profile.BuffItemOverlayForSet(setName, force));" in lua
    assert "conditionals.BuildOverlay(profile.BuffItemOverlays[setName], reconciliationEquipContext(force))" in lua


def test_generated_profile_buff_item_overlays_have_toggle_and_uses_left_guard() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Idle": {"Head": "Wanderer's Chapeau"}},
        default_playstyle="Idle",
        playstyle_names=("Idle",),
        buff_item_overlays={
            "Idle": (
                {
                    "condition": {
                        "type": "missing_status",
                        "name": "reraise",
                        "buffs": ("reraise",),
                    },
                    "slots": {"Head": "Reraise Hairpin"},
                    "afterUse": {"Head": "Wanderer's Chapeau"},
                    "item": {
                        "id": 15211,
                        "name": "Reraise Hairpin",
                        "effect": "reraise",
                    },
                },
            )
        },
    )

    assert "BuffItemOverlaysEnabled = true" in lua
    assert "profile.BuffItemContainers = { 0, 8, 10, 11, 12, 13, 14, 15, 16 };" in lua
    assert "function profile.BuffItemHasUsesLeft(entry)" in lua
    assert "local itemType = type(item);" in lua
    assert "if itemType ~= 'table' and itemType ~= 'userdata' then" in lua
    assert "itemHasUsesLeft = profile.BuffItemHasUsesLeft" in lua
    assert "if profile.BuffItemOverlaysEnabled() ~= true then" in lua
    assert "local hasUsesLeft = true;" in lua
    assert "hasUsesLeft = profile.BuffItemHasUsesLeft(entry) == true;" in lua
    assert "elseif command == 'buffitems' or command == 'buffitem' or command == 'buffoverlays' then" in lua
    assert "profile.HandleBuffItemOverlayCommand(args);" in lua
    assert "Buff item overlays: /lac fwd buffitems on|off|status." in lua


def test_runtime_conditionals_guard_item_overlays_by_uses_left() -> None:
    conditionals = (
        Path(__file__).resolve().parents[2] / "runtime" / "luashitacast" / "common" / "conditionals.lua"
    ).read_text()

    assert "local function itemHasUsesLeft(context, entry)" in conditionals
    assert "type(context.itemHasUsesLeft) == 'function'" in conditionals
    assert "if itemHasUsesLeft(context, entry) then" in conditionals


def test_runtime_conditionals_scope_slot_side_conditions_to_each_overlay_slot() -> None:
    conditionals = (
        Path(__file__).resolve().parents[2] / "runtime" / "luashitacast" / "common" / "conditionals.lua"
    ).read_text()
    condition_matcher = conditionals[
        conditionals.index("function conditionals.ConditionMatches") : conditionals.index(
            "function conditionals.ResolveOverlay"
        )
    ]

    assert "local function slotSideMatches(condition, slot)" in conditionals
    assert "slot_side" not in condition_matcher
    assert "conditionType ~= 'slot_side'" in conditionals
    assert "side == 'right_ear' and normalizedSlot == 'ear2'" in conditionals
    assert "side == 'left_ear' and normalizedSlot == 'ear1'" in conditionals
    assert "if entryMatches or slotSideMatches(entry.condition, slot) then" in conditionals


def test_runtime_conditionals_require_every_status_for_status_all() -> None:
    conditionals = (
        Path(__file__).resolve().parents[2] / "runtime" / "luashitacast" / "common" / "conditionals.lua"
    ).read_text()

    assert "elseif conditionType == 'status_all' then" in conditionals
    assert "if buffState(context, buff) ~= true then" in conditionals


def test_runtime_conditionals_resolve_winning_owner_without_changing_build_overlay_api() -> None:
    conditionals = (
        Path(__file__).resolve().parents[2] / "runtime" / "luashitacast" / "common" / "conditionals.lua"
    ).read_text()
    resolver = conditionals[
        conditionals.index("function conditionals.ResolveOverlay") : conditionals.index(
            "function conditionals.BuildOverlay"
        )
    ]
    build_overlay = conditionals[
        conditionals.index("function conditionals.BuildOverlay") : conditionals.index(
            "function conditionals.ApplyForSet"
        )
    ]

    assert "owners[slot] = {" in resolver
    assert "conditionType = conditionType" in resolver
    assert "index = index" in resolver
    assert "owners.Ring2 = nil" in resolver
    assert "local overlay = conditionals.ResolveOverlay(entries, context);" in build_overlay
    assert "return overlay;" in build_overlay


def test_generated_profile_reports_conditional_winners_without_equipping() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="SAM",
        sets={"Accuracy": {"Neck": "Peacock Charm", "Body": "Haubergeon"}},
        default_playstyle="Accuracy",
        playstyle_names=("Accuracy",),
        conditional_equips={
            "Accuracy": (
                {
                    "condition": {"type": "status", "name": "poison", "buffs": ("poison",)},
                    "slots": {"Neck": "Halting Stole"},
                },
            ),
            "__global__": (
                {
                    "condition": {"type": "status", "name": "cover", "buffs": ("cover",)},
                    "slots": {"Body": "Valor Surcoat"},
                },
            ),
        },
    )

    start = lua.index("function profile.PrintConditionalOverlayStatus()")
    end = lua.index("\nlocal function equipCombatStyle", start)
    diagnostic = lua[start:end]
    assert "state.LastEquippedSetName or setNameFor(activeCombatStyle())" in diagnostic
    assert "conditionals.ResolveOverlay(conditionalEquips[setName], context)" in diagnostic
    assert "conditionals.ResolveOverlay(conditionalEquips.Global, context)" in diagnostic
    assert diagnostic.index("recordOwners('set', setOwners)") < diagnostic.index(
        "recordOwners('global', globalOwners)"
    )
    assert "for _, slot in ipairs(equipmentSlots) do" in diagnostic
    assert "winners=none" in diagnostic
    assert "gFunc.EquipSet" not in diagnostic
    assert "gFunc.ForceEquipSet" not in diagnostic
    assert "elseif command == 'overlays' or command == 'overlay'" in lua
    assert "profile.PrintConditionalOverlayStatus();" in lua
    assert "Conditional overlays: /lac fwd overlays." in lua


def test_generated_profile_marks_reserved_keypad_entries_as_unbound_commands() -> None:
    palette = plan_number_row_palette(
        job="SAM",
        playstyles=("StoreTP", "Accuracy", "WeaponSkill"),
        available_sets={"StoreTP", "Accuracy", "WeaponSkill"},
        profile_features=("aahtacos_sam_controls",),
    ).to_manifest()
    lua = render_profile(
        player="Aahtacos",
        player_id="30102",
        job="SAM",
        sets={"StoreTP": {"Main": "Amanomurakumo"}},
        default_playstyle="StoreTP",
        number_row_palette=palette,
        profile_features=("aahtacos_sam_controls",),
    )

    for key in ("NUMPAD2", "NUMPAD4", "NUMPAD6", "NUMPAD8"):
        assert f"key = '{key}'" in lua
        assert f"'/bind {key} " not in lua
    palette_text = lua[
        lua.index("function oddLuaNumberRow.paletteEntryText(binding)") : lua.index(
            "function oddLuaNumberRow.paletteEntriesText"
        )
    ]
    assert "binding.kind == 'command-only'" in palette_text
    assert "[unbound; command " in palette_text
    assert "'/bind NUMPAD9 /lac fwd meditate'," in lua
    sam_unload_block = lua[
        lua.index("profile.OnUnload = function()")
        : lua.index("profile.HandleCommand = function(args)")
    ]
    assert "queueTypedCommand(bind.unbind, -1);" in sam_unload_block


def test_runtime_conditionals_fail_closed_when_buff_state_is_unreadable() -> None:
    conditionals = (
        Path(__file__).resolve().parents[2] / "runtime" / "luashitacast" / "common" / "conditionals.lua"
    ).read_text()
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="SAM",
        sets={"Accuracy": {"Neck": "Peacock Charm"}},
        default_playstyle="Accuracy",
        playstyle_names=("Accuracy",),
    )

    assert "local function buffState(context, buff)" in conditionals
    assert "type(context.getBuffCount) == 'function'" in conditionals
    assert "if buffState(context, buff) ~= false then" in conditionals
    assert "return buffState(context, condition.name) == false;" in conditionals
    assert "return 0, false;" in lua
    assert "return count, true;" in lua
    assert lua.count("getBuffCount = getBuffCount,") >= 3


def test_generated_profile_reconciliation_uses_selected_item_aliases() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="THF",
        sets={"Melt": {"Sub": "Thorin's Shield"}},
        default_playstyle="Melt",
        playstyle_names=("Melt",),
        reconciliation_item_aliases={"Thorin's Shield": ("thorfinn_shield",)},
    )

    assert "profile.ReconciliationNameAliases = {" in lua
    assert "{ 'Thorin\\'s Shield', 'thorfinn_shield' }" in lua
    assert "function profile.ReconciliationNameAliases.Base(value)" in lua
    assert "text = string.gsub(text, '_', ' ');" in lua
    assert "function profile.ReconciliationNameAliases.Canonical(value)" in lua
    assert "local expectedText = profile.ReconciliationNameAliases.Canonical(expected);" in lua
    assert "local observedText = profile.ReconciliationNameAliases.Canonical(observed);" in lua


def test_generated_profile_fills_profile_slots_dropped_by_scale() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Playstyle_Enspell": {
                "Main": "Somnia Melodiam",
                "Sub": "Egeking",
                "Ear1": "Brutal Earring",
                "Ear2": "Novio Earring",
                "Ring1": "Portus Annulet",
                "Ring2": "Sniper's Ring",
                "Legs": "Dls. Tights +1",
            },
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    equip_block = lua[
        lua.index("local function equipNamedSet(setName, force, requestedSet)")
        : lua.index("local function equipNamedSetIfNotClear")
    ]
    fallback_block = lua[
        lua.index("local function profileSlotsDroppedByScale")
        : lua.index("local function resolvedReconciliationExpectedSet")
    ]

    assert "local scaleWeaponGuardBypassSlotsBySet = {};" in lua
    assert "local function profileSlotsDroppedByScale(setName, requestedSet, appliedSet)" in lua
    assert "local bypassSlots = scaleWeaponGuardBypassSlotsBySet[setName] or {};" in fallback_block
    assert "local requestedRemove = normalize(requestedSet[slot]) == 'remove';" in fallback_block
    assert "local scaleChangedRemove = requestedRemove and normalize(appliedSet[slot]) ~= 'remove';" in fallback_block
    assert "and (appliedSet[slot] == nil or scaleChangedRemove)" in fallback_block
    assert "and (reconciliationProtectedWeaponSlots[slot] ~= true" in fallback_block
    assert "or bypassSlots[slot] == true" in fallback_block
    assert "dropped[slot] = requestedSet[slot];" in fallback_block
    assert "value = value.Name or value.name or '';" in lua
    assert "local usedScaleResolver = false;" in equip_block
    assert "usedScaleResolver = true;" in equip_block
    assert (
        "appliedSet = equipProfileSlotsDroppedByScale("
        "setName, recoverySet, appliedSet, effectiveForce);"
    ) in equip_block
    assert "resolvedReconciliationExpectedSet(setName, setToEquip, appliedSet, effectiveForce)" in equip_block


def test_generated_profile_repairs_stable_reconciliation_mismatches_with_bounded_retry() -> None:
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

    assert "if state.IdleOverrideSet == setName then\n        return 0.35;" in lua
    assert "local function reconciliationCanRepairSet(setName, intent)" in lua
    assert "if state.IdleOverrideSet == setName then\n        return true;" in lua
    assert "return intentText == 'tp' or intentText == 'idle' or intentText == 'movement';" in lua
    assert "local repairReconciliationMismatch;" in lua
    assert "repairReconciliationMismatch = function(pending, mismatches)" in lua
    assert "local reconciliationMaxRepairAttempts = 2;" in lua
    assert "local reconciliationResetBarrierDelaySeconds = 0.35;" in lua
    assert "if not reconciliationCanRepairSet(pending.set, pending.intent) then" in lua
    assert "if repairAttempt >= reconciliationMaxRepairAttempts then" in lua
    assert "scale.ForceEquipSet(pending.set, pending.expected, pending.intent);" in lua
    assert "gFunc.ForceEquipSet(resetSet);" in lua
    assert "repairResetBarrier = true," in lua
    assert "return true, nil, 'reset_barrier';" in lua
    assert "repairAttempt + 1," in lua
    assert "cycleSequence = pending.cycleSequence," in lua
    assert "contextSignature = pending.contextSignature," in lua
    assert "and signature == state.ReconcileLastRecordedSignature" in lua
    assert "and state.ReconcileScanScheduled == true" in lua
    assert "and type(scheduled) == 'table'" in lua
    assert "local hasSupersedingIntent = type(scheduled.repairSupersedingSnapshot) == 'table';" in lua
    assert "if repair ~= true and state.ReconcileCompositionActive == true then" in lua
    assert "function profile.OddLuaRuntime.RunReconciliationComposition(callback)" in lua
    assert "return profile.OddLuaRuntime.RunReconciliationComposition(function()" in lua
    assert "repair = repair == true," in lua
    assert "repairAttempt = repair == true and (tonumber(repairAttempt) or 1) or 0," in lua
    assert "snapshot.repair = pending.repair == true;" in lua
    assert "snapshot.repairAttempt = tonumber(pending.repairAttempt) or 0;" in lua
    assert '"repair":' in lua
    assert '"repairAttempt":' in lua
    assert '"repairStrategy":' in lua


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

    assert (
        "if snapshot.status == 'mismatch' and snapshot.repairQueued ~= true "
        "and snapshot.repairPaused ~= true then"
    ) in lua
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

    equip_block = lua[lua.index("local function equipNamedSet(setName, force, requestedSet)") : lua.index("local function equipNamedSetIfNotClear")]

    assert "StableEquipForcePending = false" in lua
    assert "local function isStableEquipIntent(setName)" in lua
    assert "local function stableEquipForceForSet(setName, setToEquip, force)" in lua
    assert "not isClearSet(setToEquip)" in lua
    assert "state.StableEquipForcePending = false;" in lua
    assert "local effectiveForce = stableEquipForceForSet(setName, setToEquip, force);" in equip_block
    assert "if effectiveForce == true and scale and scale.ForceEquipSet then" in equip_block
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
    assert "updategear" in lua
    assert "gearupdate" in lua
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
    assert (
        "elseif command == 'updategear' or command == 'gearupdate' or command == 'refreshgear'"
        in lua
    )
    assert "startOddLuaGearRefresh(args);" in lua
    assert "os.execute" not in lua


def test_game_refresh_launcher_verifies_runtime_ux_and_install_parity() -> None:
    script = (Path(__file__).resolve().parents[1] / "Run-OddLuaGameRefresh.ps1").read_text(encoding="utf-8")

    assert "audit_runtime_ux.py" in script
    assert "--profile-root" in script
    assert "--min-profile-count" in script
    assert "audit_profile_health.py" in script
    assert "--install-root" in script
    assert "--dist-root" in script
    assert "..\\client\\Ashita\\config\\addons\\luashitacast" in script
    assert "-LuashitacastRoot $LuashitacastRoot" in script
    assert "--install-root $LuashitacastRoot" in script
    assert "client\\Game\\FINAL FANTASY XI\\config\\addons\\luashitacast" not in script
    assert "C:\\Games\\CatsEyeXI\\catseyexi-client" not in script
    assert "Write-RefreshStatus -State 'success'" in script


def test_generated_profile_runtime_chat_does_not_expose_developer_paths() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "log=' .. reconciliationConfig.logPath" not in lua
    assert "; log=' .. reconciliationConfig.logPath" not in lua
    assert "'; status=' .. oddLuaRefresh.statusPath" not in lua
    assert "check ' .. oddLuaRefresh.statusPath" not in lua
    assert "Run ' .. oddLuaRefresh.launcher" not in lua


def test_generated_profile_does_not_unbind_keypad_keys_during_normal_load() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        number_row_palette={
            "keys": ["NUMPAD.", "NUMPAD0", "NUMPAD1"],
            "displayKeys": [".", "0", "1"],
            "bindings": [
                {
                    "key": "NUMPAD.",
                    "displayKey": ".",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "NUMPAD0",
                    "displayKey": "0",
                    "id": "style.next",
                    "label": "Style+",
                    "literal": "/lac fwd stylenext",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
            ],
            "unbound": [],
        },
    )

    on_load_block = lua[lua.index("profile.OnLoad = function()") : lua.index("profile.OnUnload = function()")]
    palette_toggle_block = lua[
        lua.index("function oddLuaNumberRow.setPaletteEnabled(value)")
        : lua.index("function oddLuaNumberRow.cyclePlaystyle")
    ]

    assert "oddLuaNumberRow.bindPalette();" in on_load_block
    assert "clearMovementClusterBinds" not in on_load_block
    assert "oddLuaNumberRow.bindPalette();" in palette_toggle_block
    assert "clearMovementClusterBinds" not in palette_toggle_block


def test_generated_profile_keypad_on_off_commands_are_idempotent() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        number_row_palette={
            "keys": ["NUMPAD."],
            "displayKeys": ["."],
            "bindings": [
                {
                    "key": "NUMPAD.",
                    "displayKey": ".",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
            ],
            "unbound": [],
        },
    )

    palette_toggle_block = lua[
        lua.index("function oddLuaNumberRow.setPaletteEnabled(value)")
        : lua.index("function oddLuaNumberRow.currentPlaystyleIndex")
    ]

    guard_index = palette_toggle_block.index("if state.NumberRowPaletteEnabled == enabled then")
    assign_index = palette_toggle_block.index("state.NumberRowPaletteEnabled = enabled;")
    assert guard_index < assign_index
    assert "message('OddLua keypad palette: already on');" in palette_toggle_block
    assert "message('OddLua keypad palette: already off');" in palette_toggle_block
    assert palette_toggle_block.count("oddLuaNumberRow.bindPalette();") == 1
    assert palette_toggle_block.count("oddLuaNumberRow.unbindPalette();") == 1


def test_generated_profile_unload_unbinds_only_current_safe_keypad_binds() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        number_row_palette={
            "keys": ["NUMPAD.", "NUMPAD2", "UP"],
            "displayKeys": [".", "2", "Up"],
            "bindings": [
                {
                    "key": "NUMPAD.",
                    "displayKey": ".",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "NUMPAD2",
                    "displayKey": "2",
                    "id": "warp",
                    "label": "Warp",
                    "literal": "/lac fwd warp",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "UP",
                    "displayKey": "Up",
                    "id": "arrow.reserved",
                    "label": "Reserved",
                    "literal": "/lac fwd status",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
            ],
            "unbound": [],
        },
    )

    unbind_block = lua[
        lua.index("function oddLuaNumberRow.unbindPalette()")
        : lua.index("function oddLuaNumberRow.clearLegacyPaletteBinds()")
    ]
    legacy_clear_block = lua[
        lua.index("function oddLuaNumberRow.clearLegacyPaletteBinds()")
        : lua.index("function oddLuaNumberRow.paletteEntryText")
    ]

    assert "'/unbind NUMPAD.'," in unbind_block
    assert "'/unbind NUMPAD2'," not in unbind_block
    assert "'/unbind UP'," not in unbind_block
    assert "'/unbind 1'," not in unbind_block
    assert "oddLuaNumberRow.clearLegacyPaletteBinds();" in lua
    assert "'/unbind NUMPAD2'," in legacy_clear_block
    assert "'/unbind UP'," in legacy_clear_block
    assert "'/unbind DOWN'," in legacy_clear_block
    assert "'/unbind 1'," in legacy_clear_block


def test_generated_profile_binds_keypad_palette_from_loaded_profile_palette() -> None:
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
            "keys": ["NUMPAD.", "NUMPAD0", "NUMPAD1", "NUMPAD2", "NUMPAD3", "UP"],
            "displayKeys": [".", "0", "1", "2", "", "Up"],
            "bindings": [
                {
                    "key": "NUMPAD.",
                    "displayKey": ".",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "NUMPAD0",
                    "displayKey": "0",
                    "id": "style.next",
                    "label": "Style+",
                    "literal": "/lac fwd stylenext",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "NUMPAD1",
                    "displayKey": "1",
                    "id": "styles",
                    "label": "Styles",
                    "literal": "/lac fwd styles",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "NUMPAD2",
                    "displayKey": "2",
                    "id": "warp",
                    "label": "Warp",
                    "literal": "/lac fwd warp",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
                {
                    "key": "UP",
                    "displayKey": "Up",
                    "id": "arrow.reserved",
                    "label": "Reserved",
                    "literal": "/lac fwd status",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
            ],
            "unbound": ["slot12"],
        },
    )

    assert "local numberRowBindings = {" in lua
    assert "{ key = 'NUMPAD.', displayKey = '.', label = 'Style-', literal = '/lac fwd styleprev'" in lua
    assert "{ key = '', displayKey = '', label = 'Unbound', literal = '', kind = 'unbound'" in lua
    assert "'/bind NUMPAD. /lac fwd styleprev'," in lua
    assert "'/bind NUMPAD2 " not in lua
    assert "'/bind NUMPAD4 " not in lua
    assert "'/bind NUMPAD6 " not in lua
    assert "'/bind NUMPAD8 " not in lua
    assert "'/bind UP " not in lua
    assert "scheduleTask(delay, function()" in lua
    assert "package.loaded['oddlua.binding_lifecycle']" in lua
    assert "function oddLuaNumberRow.advanceBindingGeneration()" in lua
    assert "function oddLuaNumberRow.isBindingGenerationCurrent(generation)" in lua
    assert "if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then" in lua
    assert "queueTypedCommand(bindCommand, -1);" in lua
    assert "'/unbind NUMPAD.'," in lua
    assert "'/unbind NUMPAD2'," in lua
    assert "'/unbind NUMPAD4'," in lua
    assert "'/unbind NUMPAD6'," in lua
    assert "'/unbind NUMPAD8'," in lua
    assert "'/unbind UP'," in lua
    assert "'/unbind DOWN'," in lua
    assert "'/unbind LEFT'," in lua
    assert "'/unbind RIGHT'," in lua
    assert "'/unbind 1'," in lua
    assert "'/unbind ='," in lua
    assert "queueTypedCommand(unbindCommand, -1);" in lua
    assert "Queueing every unbind during OnUnload can heap-corrupt Ashita; stagger them." in lua
    assert "queueTypedCommand('/bind 1 /lac fwd styleprev', -1)" not in lua
    assert "queueTypedCommand('/bind  /lac fwd" not in lua
    assert "function oddLuaNumberRow.bindPalette()" in lua
    assert "function oddLuaNumberRow.unbindPalette()" in lua
    assert "oddLuaNumberRow.bindPalette();" in lua
    assert "oddLuaNumberRow.unbindPalette();" in lua
    bind_block = lua[
        lua.index("function oddLuaNumberRow.bindPalette()")
        : lua.index("function oddLuaNumberRow.unbindPalette()")
    ]
    assert "'/unbind 1'," not in bind_block
    assert "'/unbind ='," not in bind_block
    assert "queueTypedCommand('/bind NUMPAD. /lac fwd styleprev', -1)" not in bind_block
    assert "NUMPAD2" not in bind_block
    assert "UP" not in bind_block
    on_load_block = lua[
        lua.index("profile.OnLoad = function()")
        : lua.index("profile.OnUnload = function()")
    ]
    assert on_load_block.index("equipDefaultForPlayer(getPlayer(), true);") < on_load_block.index(
        "state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();"
    )
    assert on_load_block.index("state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();") < on_load_block.index("oddLuaNumberRow.bindPalette();")
    assert "oddLuaNumberRow.clearMovementClusterBinds();" not in on_load_block
    assert "oddLuaNumberRow.bindPalette();" in on_load_block
    on_unload_block = lua[
        lua.index("profile.OnUnload = function()")
        : lua.index("profile.HandleCommand = function(args)")
    ]
    assert "state.ReconcileEnabled = false;" in on_unload_block
    assert "cancelPendingReconciliationSnapshot();" in on_unload_block
    assert "state.ReconcileLastRecordedSignature = nil;" in on_unload_block
    assert on_unload_block.index("state.ReconcileEnabled = false;") < on_unload_block.index("cancelPendingReconciliationSnapshot();")
    assert on_unload_block.index("cancelPendingReconciliationSnapshot();") < on_unload_block.index("state.ReconcileLastRecordedSignature = nil;")
    assert on_unload_block.index("state.ReconcileLastRecordedSignature = nil;") < on_unload_block.index("state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();")
    assert on_unload_block.index("state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();") < on_unload_block.index("oddLuaNumberRow.unbindPalette();")
    unbind_block = lua[
        lua.index("function oddLuaNumberRow.unbindPalette()")
        : lua.index("function oddLuaNumberRow.clearLegacyPaletteBinds()")
    ]
    assert unbind_block.index("if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then") < unbind_block.index("queueTypedCommand(unbindCommand, -1);")
    palette_on_block = lua[lua.index("if enabled then") : lua.index("message('OddLua keypad palette: on')")]
    assert "oddLuaNumberRow.clearMovementClusterBinds();" not in palette_on_block
    assert "oddLuaNumberRow.bindPalette();" in palette_on_block


def test_binding_generation_invalidates_stale_scheduled_callbacks(tmp_path: Path) -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        number_row_palette={
            "keys": ["NUMPAD."],
            "displayKeys": ["."],
            "bindings": [
                {
                    "key": "NUMPAD.",
                    "displayKey": ".",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                }
            ],
            "unbound": [],
        },
    )
    palette_start = lua.index("local oddLuaNumberRow = {")
    palette_end = lua.index("function oddLuaNumberRow.clearLegacyPaletteBinds()", palette_start)
    lifecycle_start = lua.index("function oddLuaNumberRow.advanceBindingGeneration()")
    lifecycle_end = lua.index("local function equipElementalMagic", lifecycle_start)
    palette_runtime = lua[palette_start:palette_end]
    lifecycle_runtime = lua[lifecycle_start:lifecycle_end]
    driver = f"""
local state = {{ NumberRowPaletteEnabled = true, BindingGeneration = 0 }}
local pendingTasks = {{}}
local queuedCommands = {{}}
local function scheduleTask(delay, callback)
    pendingTasks[#pendingTasks + 1] = {{ delay = delay, callback = callback }}
    return true
end
local function queueTypedCommand(command, mode)
    queuedCommands[#queuedCommands + 1] = {{ command = command, mode = mode }}
    return true
end
local function message(_text)
end
{palette_runtime}
{lifecycle_runtime}
local function takeTasks()
    local tasks = pendingTasks
    pendingTasks = {{}}
    return tasks
end
local function runTasks(tasks)
    table.sort(tasks, function(left, right) return left.delay < right.delay end)
    for _, task in ipairs(tasks) do
        task.callback()
    end
end

state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration()
oddLuaNumberRow.bindPalette()
local staleLoadTasks = takeTasks()

state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration()
oddLuaNumberRow.unbindPalette()
local staleUnloadTasks = takeTasks()

state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration()
oddLuaNumberRow.bindPalette()
local currentLoadTasks = takeTasks()

runTasks(staleLoadTasks)
runTasks(staleUnloadTasks)
assert(#queuedCommands == 0, 'stale binding callbacks queued commands')
assert(#currentLoadTasks > 0, 'current profile scheduled no binds')
runTasks(currentLoadTasks)
assert(#queuedCommands == #currentLoadTasks, 'current binding callbacks were dropped')
for _, queued in ipairs(queuedCommands) do
    assert(queued.mode == -1, 'binding used the wrong queue mode')
    assert(string.sub(queued.command, 1, 6) == '/bind ', 'non-bind command escaped current load')
end
print('binding lifecycle contract passed')
"""
    driver_path = tmp_path / "binding_lifecycle_contract.lua"
    driver_path.write_text(driver, encoding="utf-8")
    luajit = shutil.which("luajit")
    assert luajit is not None
    completed = subprocess.run(
        [luajit, str(driver_path)],
        check=False,
        capture_output=True,
        text=True,
        timeout=10,
    )
    assert completed.returncode == 0, completed.stdout + completed.stderr
    assert "binding lifecycle contract passed" in completed.stdout


def test_generated_profile_handles_style_cycle_and_keypad_commands() -> None:
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
    assert "elseif command == 'keypad' then" in lua
    assert "oddLuaNumberRow.printPalette();" in lua
    assert "oddLuaNumberRow.clearPaletteBinds();" in lua
    assert "elseif command == 'palette' or command == 'numberrow' then" in lua
    assert "oddLuaNumberRow.setPaletteEnabled(value);" in lua
    assert "OddLua keypad palette: on" in lua
    assert "OddLua keypad palette: cleared" in lua
    assert "OddLua number row palette: on" not in lua


def test_generated_profile_prints_chat_keypad_map_without_overlay() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Cure": {"Main": "Chatoyant Staff"}, "Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Cure", "Enspell"),
    )

    assert "function oddLuaNumberRow.paletteEntryText(binding)" in lua
    assert "function oddLuaNumberRow.printPalette()" in lua
    assert "Keypad palette=' .. enabledText .. '; /lac fwd keypad on|off|clear." in lua
    assert "Keypad 1: ' .. oddLuaNumberRow.paletteEntriesText(1, 6)" in lua
    assert "Keypad 2: ' .. oddLuaNumberRow.paletteEntriesText(7, 12)" in lua
    assert "Keypad macros: /lac fwd keypad shows keypad map" in lua
    assert "One-button macros: review/load keybindings.txt" not in lua


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


def test_generated_profile_removes_keypad_overlay_but_keeps_key_binds() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Joyeuse"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        number_row_palette={
            "keys": ["NUMPAD."],
            "displayKeys": [".", ""],
            "bindings": [
                {
                    "key": "NUMPAD.",
                    "displayKey": ".",
                    "id": "style.prev",
                    "label": "Style-",
                    "literal": "/lac fwd styleprev",
                    "kind": "action",
                    "toggleState": "",
                    "fallbackSets": [],
                },
            ],
            "unbound": ["slot12"],
        },
    )

    assert "local oddLuaNumberRow = {" in lua
    assert "function oddLuaNumberRow.bindPalette()" in lua
    assert "function oddLuaNumberRow.unbindPalette()" in lua
    assert "'/bind NUMPAD. /lac fwd styleprev'," in lua
    assert "'/bind NUMPAD2 " not in lua
    assert "'/bind NUMPAD4 " not in lua
    assert "'/bind NUMPAD6 " not in lua
    assert "'/bind NUMPAD8 " not in lua
    assert "scheduleTask(delay, function()" in lua
    assert "'/unbind 1'," in lua
    assert "queueTypedCommand(unbindCommand, -1);" in lua
    assert "renderEvent =" not in lua
    assert "pcall(require, 'imgui')" not in lua
    assert "function oddLuaNumberRow.renderOverlay()" not in lua
    assert "local numberRowGridColumns = 6;" not in lua
    assert "imgui." not in lua
    assert "binding.key .. ' ' .. binding.label" not in lua
    assert "ashita.events.register('d3d_present'" not in lua
    assert "ashita.events.unregister('d3d_present'" not in lua
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
