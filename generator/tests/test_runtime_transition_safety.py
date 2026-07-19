from __future__ import annotations

from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

from oddlua.renderer import render_profile


def _profile_lua() -> str:
    return render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "PDT": {"Body": "Darksteel Harness"},
            "IdleMaxMP": {"Ring1": "Ether Ring"},
            "IdleMaxHP": {"Ring1": "Bomb Queen Ring"},
            "Movement": {"Feet": "Herald's Gaiters"},
            "InCity": {"Body": "Kupo Suit"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )


def _lua_function_block(lua: str, name: str) -> str:
    for marker in (f"function {name}(", f"local function {name}(", f"{name} = function("):
        if marker in lua:
            start = lua.index(marker)
            break
    else:
        raise AssertionError(f"Lua function not found: {name}")
    next_local = lua.find("\nlocal function ", start + 1)
    next_public = lua.find("\nfunction ", start + 1)
    ends = [index for index in (next_local, next_public) if index >= 0]
    return lua[start : min(ends) if ends else len(lua)]


def test_reconciliation_pauses_repairs_but_keeps_observations_retryable() -> None:
    lua = _profile_lua()
    repair = _lua_function_block(lua, "repairReconciliationMismatch")
    record = _lua_function_block(lua, "recordPendingReconciliationSnapshot")
    force_expected = _lua_function_block(lua, "forceReconciliationExpected")
    reset_barrier = _lua_function_block(lua, "queueReconciliationResetBarrier")
    reset_safe_slots = lua.split("local reconciliationResetBarrierSafeSlots = {", 1)[1].split("};", 1)[0]

    assert "profile.OddLuaRuntime.EncumbranceStatusBuffs = { 'encumbrance', 177, 259 };" in lua
    assert "local encumbranceState = profile.OddLuaRuntime.HasEncumbrance();" in repair
    assert repair.index("PlayerContextReady") < repair.index("HasEncumbrance")
    assert repair.index("HasEncumbrance") < repair.index("queueReconciliationResetBarrier")
    assert repair.index("HasEncumbrance") < repair.index("forceReconciliationExpected")
    assert "gFunc.ForceEquipSet(resetSet);" in reset_barrier
    assert "gFunc.ForceEquipSet(movementSafeEquipSet(pending.expected));" in force_expected
    for unsafe_slot in ("Main", "Sub", "Range", "Ammo"):
        assert f"{unsafe_slot} = true" not in reset_safe_slots
    assert "repairResetExpected = resetExpected," in reset_barrier
    assert "expected = reservation.repairResetExpected," in reset_barrier
    assert "if forceReconciliationExpected(request) then" in reset_barrier
    assert "gFunc.ForceEquipSet(reservation.repairResetExpected);" in reset_barrier
    assert "scheduled.repairSupersedingSnapshot = {" in lua
    assert "supersedeResetBarrierIfNeeded()" in reset_barrier
    assert "PlayerContextReady" in reset_barrier
    assert "HasEncumbrance" in reset_barrier
    assert "return false, 'repair_paused_encumbrance';" in repair
    assert "return false, 'repair_paused_encumbrance_unknown';" in repair
    assert "snapshot.repairPaused = repairPauseReason ~= nil;" in record
    assert "state.ReconcileLastRecordedSignature = nil;" in record
    assert "writeReconciliationSnapshot(snapshot);" in record
    assert "snapshot.repairPaused ~= true" in record
    assert '"repairPaused":' in lua


def test_city_movement_requires_confident_on_foot_state() -> None:
    lua = _profile_lua()
    mounted = _lua_function_block(lua, "isMounted")
    movement = _lua_function_block(lua, "canEquipMovement")
    in_city = _lua_function_block(lua, "shouldEquipInCityMovement")

    assert "profile.OddLuaRuntime.MountedStatusBuffs = { 'chocobo', 'mount', 'mounted', 252 };" in lua
    assert "StatusListState(profile.OddLuaRuntime.MountedStatusBuffs)" in mounted
    assert "function profile.OddLuaRuntime.IsOnFoot(player)" in lua
    assert "return isMounted(player) == false;" in lua
    assert "if not profile.OddLuaRuntime.IsOnFoot(player) then" in movement
    assert "return profile.OddLuaRuntime.PlayerIsMoving(player) == true;" in movement
    assert "return isCity(environment) and profile.OddLuaRuntime.IsOnFoot(player);" in in_city


def test_reconciliation_encumbrance_contract_executes_pause_and_resume() -> None:
    with TemporaryDirectory(prefix="oddlua-reconcile-pause-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(
            render_profile(
                player="Tester",
                player_id="1",
                job="RDM",
                sets={
                    "Aftercast": {"Body": "Yigit Gomlek", "Back": "Intensifying Cape"},
                    "IdleNonCombat": {"Body": "Yigit Gomlek", "Back": "Intensifying Cape"},
                },
                default_playstyle="Idle",
                playstyle_names=("Idle",),
            ),
            encoding="utf-8",
        )
        driver_path.write_text(
            "\n".join(
                (
                    "local encumbered = true",
                    "local forceCount = 0",
                    "local equipment = { Body='Seers Tunic', Back='Oneiros Cape' }",
                    "local tasks = {}",
                    "ashita = { tasks = { once = function(_delay, callback) tasks[#tasks + 1] = callback end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MP=100 } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(probe)",
                    "    if encumbered and (probe == 'encumbrance' or probe == 177 or probe == 259) then return 1 end",
                    "    return 0",
                    "  end,",
                    "}",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = function(_set) end,",
                    "  ForceEquipSet = function(_set) forceCount = forceCount + 1 end,",
                    "}",
                    "local function runNextTask()",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local callback = table.remove(tasks, 1)",
                    "  callback()",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "io = nil",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'encumbered observation was not scheduled')",
                    "runNextTask()",
                    "assert(forceCount == 0, 'Encumbrance repair was not paused')",
                    "encumbered = false",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'retryable observation was not rescheduled')",
                    "runNextTask()",
                    "assert(forceCount == 1, 'repair did not resume exactly once')",
                    "assert(#tasks == 1, 'resumed repair confirmation was not scheduled')",
                    "print('PASS reconciliation pause and resume')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS reconciliation pause and resume" in completed.stdout


def test_reconciliation_empty_equipment_is_unknown_and_never_mutates() -> None:
    with TemporaryDirectory(prefix="oddlua-reconcile-empty-observation-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(
            render_profile(
                player="Tester",
                player_id="1",
                job="RDM",
                sets={
                    "Aftercast": {"Body": "Yigit Gomlek", "Back": "Intensifying Cape"},
                    "IdleNonCombat": {"Body": "Yigit Gomlek", "Back": "Intensifying Cape"},
                },
                default_playstyle="Idle",
                playstyle_names=("Idle",),
            ),
            encoding="utf-8",
        )
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local equipment = {}",
                    "local forceCount = 0",
                    "ashita = { tasks = { once = function(_delay, callback) tasks[#tasks + 1] = callback end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MainJob='RDM', MainJobLevel=75, SubJob='WHM', SubJobLevel=37, TP=0, IsMoving=false } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "}",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = function(_set) end,",
                    "  ForceEquipSet = function(_set) forceCount = forceCount + 1 end,",
                    "}",
                    "local function runNextTask()",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local callback = table.remove(tasks, 1)",
                    "  callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 10 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted and type(value) == 'table' then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "io = nil",
                    "profile.HandleDefault()",
                    "runNextTask()",
                    "assert(forceCount == 0, 'empty observation entered the repair path')",
                    "assert(state.ReconcileLast.status == 'unknown_observation', 'empty observation was not unknown')",
                    "assert(state.ReconcileLast.reason == 'gData.GetEquipment returned empty table', 'empty observation reason drifted')",
                    "assert(state.ReconcileLastRecordedSignature == nil, 'empty observation poisoned deduplication')",
                    "equipment = { Body='Yigit Gomlek', Back='Intensifying Cape' }",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'current equipment was not retryable after empty observation')",
                    "runNextTask()",
                    "assert(state.ReconcileLast.status == 'match', 'retry after empty observation did not match')",
                    "assert(forceCount == 0, 'retry after empty observation forced equipment')",
                    "print('PASS empty reconciliation observation is fail-closed and retryable')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS empty reconciliation observation is fail-closed" in completed.stdout


def test_reconciliation_context_drift_yields_without_stale_repair() -> None:
    with TemporaryDirectory(prefix="oddlua-reconcile-context-drift-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(
            render_profile(
                player="Tester",
                player_id="1",
                job="PLD",
                sets={
                    "Playstyle_Damage": {
                        "Main": "Octave Club",
                        "Hands": "Dusk Gloves",
                        "Feet": "Dusk Ledelsens",
                    },
                    "IdleNonCombat": {"Body": "Brigandine"},
                },
                default_playstyle="Damage",
                playstyle_names=("Damage",),
            ),
            encoding="utf-8",
        )
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local moving = false",
                    "local equipment = { Main='Octave Club' }",
                    "local forceCount = 0",
                    "ashita = { tasks = { once = function(_delay, callback) tasks[#tasks + 1] = callback end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Engaged', MainJob='PLD', MainJobLevel=75, SubJob='WAR', SubJobLevel=37, TP=0, IsMoving=moving } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "}",
                    "local function apply(set)",
                    "  for slot, item in pairs(set or {}) do",
                    "    if item == 'remove' then equipment[slot] = nil else equipment[slot] = item end",
                    "  end",
                    "end",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = apply,",
                    "  ForceEquipSet = function(set) forceCount = forceCount + 1; apply(set) end,",
                    "}",
                    "local function runNextTask()",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local callback = table.remove(tasks, 1)",
                    "  callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 10 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted and type(value) == 'table' then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "io = nil",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'stationary context did not schedule')",
                    "moving = true",
                    "equipment.Hands = nil",
                    "equipment.Feet = nil",
                    "runNextTask()",
                    "assert(forceCount == 0, 'changed movement context repaired stale Dusk gear')",
                    "assert(state.ReconcileLast == nil, 'changed context emitted a stale reconciliation result')",
                    "assert(state.ReconcileLastRecordedSignature == nil, 'changed context poisoned deduplication')",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'moving context did not receive a fresh settle window')",
                    "runNextTask()",
                    "assert(state.ReconcileLast.status == 'match', 'movement-safe context did not reconcile')",
                    "assert(forceCount == 0, 'movement-safe context used a force repair')",
                    "print('PASS reconciliation context drift yields without stale repair')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS reconciliation context drift yields" in completed.stdout


def test_action_reconciliation_gets_one_observation_only_settle() -> None:
    with TemporaryDirectory(prefix="oddlua-reconcile-action-settle-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(
            render_profile(
                player="Tester",
                player_id="1",
                job="RDM",
                sets={
                    "Cure": {"Body": "Yigit Gomlek", "Back": "Grapevine Cape"},
                    "Healing": {"Body": "Yigit Gomlek", "Back": "Grapevine Cape"},
                    "IdleNonCombat": {"Body": "Vermillion Cloak", "Back": "Intensifying Cape"},
                },
                default_playstyle="Idle",
                playstyle_names=("Idle",),
            ),
            encoding="utf-8",
        )
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local equipment = { Body='Vermillion Cloak', Back='Intensifying Cape' }",
                    "local forceCount = 0",
                    "ashita = { tasks = { once = function(delay, callback) tasks[#tasks + 1] = { delay=delay, callback=callback } end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MainJob='RDM', MainJobLevel=75, SubJob='WHM', SubJobLevel=37, TP=0, IsMoving=false } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetAction = function() return { Name='Cure', Skill='Healing Magic' } end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "}",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = function(set)",
                    "    for slot, item in pairs(set or {}) do if slot ~= 'Back' then equipment[slot] = item end end",
                    "  end,",
                    "  ForceEquipSet = function(_set) forceCount = forceCount + 1 end,",
                    "}",
                    "local function runNextTask(minimumDelay)",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local task = table.remove(tasks, 1)",
                    "  if minimumDelay then assert(task.delay >= minimumDelay, 'observation-only settle was too short') end",
                    "  task.callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 10 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted and type(value) == 'table' then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "io = nil",
                    "profile.OddLuaRuntime.ActionProbeSequence = 'action-1'",
                    "profile.HandleMidcast()",
                    "runNextTask()",
                    "assert(state.ReconcileLast == nil, 'first action mismatch was emitted before bounded settle')",
                    "assert(state.ReconcilePendingSnapshot.observationOnly == true, 'action settle was not observation-only')",
                    "local cycle = state.ReconcilePendingSnapshot.cycleSequence",
                    "assert(cycle ~= nil, 'action settle lost its lifecycle identity')",
                    "assert(#tasks == 1, 'action mismatch did not schedule exactly one settle observation')",
                    "equipment.Back = 'Grapevine Cape'",
                    "runNextTask(0.2)",
                    "assert(state.ReconcileLast.status == 'match', 'settled action did not match')",
                    "assert(state.ReconcileLast.observationOnly == true, 'settled action row lost observation-only marker')",
                    "assert(state.ReconcileLast.cycleSequence == cycle, 'settled action changed lifecycle identity')",
                    "assert(forceCount == 0, 'action settle mutated equipment')",
                    "assert(#tasks == 0, 'action settle scheduled an extra follow-up')",
                    "print('PASS action reconciliation gets one observation-only settle')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS action reconciliation gets one observation-only settle" in completed.stdout


def test_on_unload_invalidates_queued_reconciliation_reset_callback() -> None:
    with TemporaryDirectory(prefix="oddlua-reconcile-unload-barrier-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(
            render_profile(
                player="Tester",
                player_id="1",
                job="RDM",
                sets={
                    "Aftercast": {"Main": "Numen Staff", "Back": "Intensifying Cape"},
                    "IdleNonCombat": {"Main": "Numen Staff", "Back": "Intensifying Cape"},
                },
                default_playstyle="Idle",
                playstyle_names=("Idle",),
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
            ),
            encoding="utf-8",
        )
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local equipment = { Main='Numen Staff', Back='Swith Cape' }",
                    "local forceCount = 0",
                    "ashita = { tasks = { once = function(delay, callback) tasks[#tasks + 1] = { delay=delay, callback=callback } end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MainJob='RDM', MainJobLevel=75, SubJob='WHM', SubJobLevel=37, TP=0, IsMoving=false } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "  GetThreatEntities = function() return {} end,",
                    "}",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = function(_set) end,",
                    "  ForceEquipSet = function(set)",
                    "    forceCount = forceCount + 1",
                    "    if set and set.Back == 'remove' then equipment.Back = nil end",
                    "  end,",
                    "}",
                    "local function runNextTask()",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local task = table.remove(tasks, 1)",
                    "  task.callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 10 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted and type(value) == 'table' then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "io = nil",
                    "profile.HandleDefault()",
                    "runNextTask()",
                    "assert(forceCount == 1, 'stable mismatch did not enter direct repair')",
                    "assert(state.ReconcilePendingSnapshot.repairAttempt == 1, 'direct repair observation was not queued')",
                    "runNextTask()",
                    "assert(forceCount == 2, 'failed direct repair did not enter reset barrier')",
                    "assert(state.ReconcilePendingSnapshot.repairResetBarrier == true, 'reset-barrier reservation was not active')",
                    "assert(#tasks == 1, 'reset barrier did not queue exactly one callback')",
                    "local staleResetTask = table.remove(tasks, 1)",
                    "assert(staleResetTask.delay >= 0.2, 'captured task was not the reset-barrier callback')",
                    "assert(#tasks == 0, 'reconciliation callback was not isolated before unload')",
                    "local staleLast = state.ReconcileLast",
                    "local staleToken = state.ReconcileScanToken",
                    "profile.OnUnload()",
                    "local unloadToken = state.ReconcileScanToken",
                    "local forceAfterUnload = forceCount",
                    "local paletteTaskCount = #tasks",
                    "assert(paletteTaskCount > 0, 'palette-unbind fixture did not queue its own tasks')",
                    "assert(state.ReconcileEnabled == false, 'unload did not disable reconciliation')",
                    "assert(state.ReconcilePendingSnapshot == nil, 'unload retained pending reconciliation owner')",
                    "assert(state.ReconcileScanScheduled == false, 'unload retained scheduled reconciliation state')",
                    "assert(unloadToken ~= staleToken, 'unload did not invalidate reconciliation token')",
                    "assert(state.ReconcileLastRecordedSignature == nil, 'unload retained reconciliation dedupe signature')",
                    "staleResetTask.callback()",
                    "assert(forceCount == forceAfterUnload, 'stale reset callback forced equipment after unload')",
                    "assert(state.ReconcileLast == staleLast, 'stale reset callback updated reconciliation result after unload')",
                    "assert(state.ReconcilePendingSnapshot == nil, 'stale reset callback recreated pending owner')",
                    "assert(state.ReconcileScanScheduled == false, 'stale reset callback rearmed scheduler')",
                    "assert(state.ReconcileScanToken == unloadToken, 'stale reset callback changed invalidated token')",
                    "assert(#tasks == paletteTaskCount, 'stale reset callback queued work among palette unbind tasks')",
                    "print('PASS unload invalidates queued reconciliation reset callback')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS unload invalidates queued reconciliation reset callback" in completed.stdout


def test_reconciliation_preserves_and_bounds_async_repair_follow_up() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {
                "Main": "Numen Staff",
                "Sub": "Omni Grip",
                "Back": "Intensifying Cape",
            },
            "IdleNonCombat": {
                "Main": "Numen Staff",
                "Sub": "Omni Grip",
                "Back": "Intensifying Cape",
            },
        },
        default_playstyle="Idle",
        playstyle_names=("Idle",),
    )
    stale_intent_lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {
                "Main": "Numen Staff",
                "Sub": "Omni Grip",
                "Back": "Intensifying Cape",
            },
            "IdleNonCombat": {
                "Main": "Numen Staff",
                "Sub": "Omni Grip",
                "Back": "Intensifying Cape",
            },
            "IdleCombat": {
                "Main": "Numen Staff",
                "Sub": "Omni Grip",
                "Back": "Boxer's Mantle",
            },
        },
        default_playstyle="Idle",
        playstyle_names=("Idle",),
    )

    with TemporaryDirectory(prefix="oddlua-reconcile-async-repair-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        stale_profile_path = root / "stale_profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(lua, encoding="utf-8")
        stale_profile_path.write_text(stale_intent_lua, encoding="utf-8")
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local playerStatus = 'Idle'",
                    "local threatActive = false",
                    "local equipment = { Main='Numen Staff', Sub='Omni Grip', Back='Swith Cape' }",
                    "local forceCount = 0",
                    "local backWasReset = false",
                    "local lastForceSet = nil",
                    "ashita = { tasks = { once = function(delay, callback) tasks[#tasks + 1] = { delay=delay, callback=callback } end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status=playerStatus, MP=100 } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "  GetThreatEntities = function() if threatActive then return { { HasPlayerThreat=true } } end return {} end,",
                    "}",
                    "local function apply(set, includeBack)",
                    "  for slot, item in pairs(set or {}) do",
                    "    if slot ~= 'Back' or includeBack then",
                    "      if item == 'remove' then equipment[slot] = nil else equipment[slot] = item end",
                    "    end",
                    "  end",
                    "end",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = function(set) apply(set, false) end,",
                    "  ForceEquipSet = function(set)",
                    "    forceCount = forceCount + 1",
                    "    lastForceSet = set",
                    "    if set and set.Back == 'remove' then",
                    "      apply(set, true)",
                    "      backWasReset = true",
                    "    else",
                    "      apply(set, backWasReset)",
                    "      if set and set.Back == 'Intensifying Cape' and backWasReset then backWasReset = false end",
                    "    end",
                    "  end,",
                    "}",
                    "local function runNextTask(minimumDelay)",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local task = table.remove(tasks, 1)",
                    "  if minimumDelay then assert(task.delay >= minimumDelay, 'scheduled barrier was too short') end",
                    "  task.callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 10 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted and type(value) == 'table' then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "io = nil",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'initial reconciliation did not coalesce')",
                    "runNextTask()",
                    "assert(forceCount == 1, 'initial mismatch did not queue first repair')",
                    "assert(state.ReconcileLast.status == 'mismatch', 'initial mismatch was not recorded')",
                    "assert(state.ReconcileLast.repair == false, 'initial observation was mislabeled as repair')",
                    "assert(state.ReconcileLast.repairQueued == true, 'first repair was not recorded as queued')",
                    "assert(state.ReconcilePendingSnapshot.repairAttempt == 1, 'first repair attempt was not bound')",
                    "local repairCycle = state.ReconcilePendingSnapshot.cycleSequence",
                    "assert(repairCycle ~= nil, 'repair lifecycle identity was not allocated')",
                    "assert(type(state.ReconcilePendingSnapshot.contextSignature) == 'string', 'repair context fingerprint was not captured')",
                    "assert(#tasks == 1, 'first repair observation was not scheduled')",
                    "local firstRepair = state.ReconcilePendingSnapshot",
                    "local firstRepairToken = state.ReconcileScanToken",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'ordinary idle composition displaced first repair')",
                    "assert(state.ReconcilePendingSnapshot == firstRepair, 'first repair object was overwritten')",
                    "assert(state.ReconcileScanToken == firstRepairToken, 'first repair token was invalidated')",
                    "runNextTask()",
                    "assert(forceCount == 2, 'failed first repair did not reset exactly the mismatched slot')",
                    "assert(equipment.Back == nil, 'failed direct swap did not create an exact-slot reset barrier')",
                    "assert(state.ReconcileLast.status == 'mismatch', 'failed first repair was not observed')",
                    "assert(state.ReconcileLast.repair == true, 'failed first repair was mislabeled')",
                    "assert(state.ReconcileLast.repairQueued == true, 'bounded retry was not recorded as queued')",
                    "assert(state.ReconcileLast.repairStrategy == 'reset_barrier', 'reset barrier strategy was not recorded')",
                    "assert(state.ReconcilePendingSnapshot.repairAttempt == 2, 'bounded retry attempt was not bound')",
                    "assert(state.ReconcilePendingSnapshot.repairResetBarrier == true, 'reset barrier reservation was not bound')",
                    "assert(state.ReconcilePendingSnapshot.cycleSequence == repairCycle, 'reset barrier changed repair lifecycle identity')",
                    "assert(#tasks == 1, 'reset barrier follow-up was not scheduled')",
                    "local secondRepair = state.ReconcilePendingSnapshot",
                    "local secondRepairToken = state.ReconcileScanToken",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'ordinary idle composition displaced reset barrier; tasks=' .. tostring(#tasks) .. '; old=' .. tostring(secondRepair.signature) .. '; new=' .. tostring(state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.signature) .. '; oldSet=' .. tostring(secondRepair.set) .. '; newSet=' .. tostring(state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.set))",
                    "assert(state.ReconcilePendingSnapshot == secondRepair, 'reset barrier object was overwritten; old=' .. tostring(secondRepair.signature) .. '; new=' .. tostring(state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.signature) .. '; oldSet=' .. tostring(secondRepair.set) .. '; newSet=' .. tostring(state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.set))",
                    "assert(state.ReconcileScanToken == secondRepairToken, 'reset barrier token was invalidated')",
                    "runNextTask(0.2)",
                    "assert(forceCount == 3, 'reset barrier did not issue the bounded re-equip')",
                    "assert(lastForceSet.Back == 'Intensifying Cape', 'reset barrier did not target exact Back value')",
                    "assert(lastForceSet.Main == nil and lastForceSet.Sub == nil, 'reset barrier re-equipped unrelated slots')",
                    "assert(equipment.Back == 'Intensifying Cape', 'bounded retry did not restore Back')",
                    "assert(state.ReconcilePendingSnapshot == secondRepair, 'first safe re-equip released the reset reservation')",
                    "assert(state.ReconcileScanToken == secondRepairToken, 'first safe re-equip invalidated the reset token')",
                    "assert(state.ReconcilePendingSnapshot.repairResetBarrier == true, 'first safe re-equip lost the reset reservation marker')",
                    "assert(#tasks == 1, 'first safe re-equip did not schedule its bounded reassert')",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'ordinary idle composition displaced bounded reassert')",
                    "assert(state.ReconcilePendingSnapshot == secondRepair, 'bounded reassert reservation was overwritten')",
                    "assert(state.ReconcileScanToken == secondRepairToken, 'bounded reassert token was invalidated')",
                    "runNextTask(0.2)",
                    "assert(forceCount == 4, 'reset barrier did not issue exactly one bounded reassert')",
                    "assert(lastForceSet.Back == 'Intensifying Cape', 'bounded reassert did not target exact Back value')",
                    "assert(lastForceSet.Main == nil and lastForceSet.Sub == nil, 'bounded reassert equipped unrelated slots')",
                    "assert(state.ReconcilePendingSnapshot.repairAttempt == 2, 'post-reset observation attempt was not bound')",
                    "assert(state.ReconcilePendingSnapshot.repairResetBarrier ~= true, 'reset reservation survived bounded reassert')",
                    "assert(state.ReconcilePendingSnapshot.cycleSequence == repairCycle, 'post-reset observation changed repair lifecycle identity')",
                    "assert(#tasks == 1, 'post-reset repair observation was not scheduled')",
                    "local postResetRepair = state.ReconcilePendingSnapshot",
                    "local postResetToken = state.ReconcileScanToken",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'ordinary idle composition displaced post-reset observation')",
                    "assert(state.ReconcilePendingSnapshot == postResetRepair, 'post-reset observation was overwritten')",
                    "assert(state.ReconcileScanToken == postResetToken, 'post-reset observation token was invalidated')",
                    "runNextTask()",
                    "assert(forceCount == 4, 'repair exceeded the bounded reassert contract')",
                    "assert(state.ReconcileLast.status == 'match', 'successful retry was not confirmed')",
                    "assert(state.ReconcileLast.repair == true, 'successful retry was not labeled as repair')",
                    "assert(state.ReconcileLast.repairAttempt == 2, 'successful retry attempt was not recorded')",
                    "assert(state.ReconcileLast.cycleSequence == repairCycle, 'successful retry changed repair lifecycle identity')",
                    "assert(state.ReconcileLast.repairFailed == false, 'successful retry was mislabeled as failed')",
                    "assert(state.ReconcilePendingSnapshot == nil, 'successful retry left a pending snapshot')",
                    "assert(state.ReconcileScanScheduled == false, 'successful retry left the scheduler active')",
                    "assert(#tasks == 0, 'repair observation left an unexpected task queued')",
                    "tasks = {}",
                    "playerStatus = 'Idle'",
                    "threatActive = false",
                    "equipment = { Main='Numen Staff', Sub='Omni Grip', Back='Swith Cape' }",
                    "forceCount = 0",
                    "backWasReset = false",
                    "lastForceSet = nil",
                    f"local preBarrierProfile = dofile([[{stale_profile_path.as_posix()}]])",
                    "local preBarrierState = findUpvalue(preBarrierProfile.HandleDefault, 'state', {}, 0)",
                    "assert(preBarrierState, 'pre-barrier profile state was not discoverable')",
                    "preBarrierProfile.HandleDefault()",
                    "runNextTask()",
                    "assert(forceCount == 1, 'pre-barrier fixture did not queue direct repair')",
                    "local preBarrierRepair = preBarrierState.ReconcilePendingSnapshot",
                    "local preBarrierToken = preBarrierState.ReconcileScanToken",
                    "local preBarrierLast = preBarrierState.ReconcileLast",
                    "threatActive = true",
                    "preBarrierProfile.HandleDefault()",
                    "assert(preBarrierState.ReconcilePendingSnapshot == preBarrierRepair, 'pre-barrier superseder replaced scheduler owner early')",
                    "assert(preBarrierState.ReconcileScanToken == preBarrierToken, 'pre-barrier superseder invalidated owner token early')",
                    "assert(preBarrierState.ReconcilePendingSnapshot.repairSupersedingSnapshot.set == 'IdleCombat', 'pre-barrier current intent was dropped')",
                    "assert(#tasks == 1, 'pre-barrier superseder scheduled overlapping observation')",
                    "threatActive = false",
                    "preBarrierProfile.HandleDefault()",
                    "assert(preBarrierState.ReconcilePendingSnapshot == preBarrierRepair, 'A-B-A transition replaced scheduler owner early')",
                    "assert(preBarrierState.ReconcilePendingSnapshot.repairSupersedingSnapshot.set == 'IdleNonCombat', 'A-B-A transition cleared final A intent')",
                    "assert(preBarrierState.ReconcilePendingSnapshot.repairSupersedingSnapshot.equipmentSignature == preBarrierRepair.equipmentSignature, 'A-B-A final gear signature did not return to A')",
                    "assert(#tasks == 1, 'A-B-A transition scheduled overlapping observation')",
                    "local forceCountBeforeOldCallback = forceCount",
                    "runNextTask()",
                    "assert(forceCount == forceCountBeforeOldCallback, 'stale direct-repair observation forced or reset old gear')",
                    "assert(backWasReset == false, 'stale direct-repair observation created reset barrier')",
                    "assert(preBarrierState.ReconcileLast == preBarrierLast, 'stale repair callback observed current intent before its settle delay')",
                    "assert(preBarrierState.ReconcilePendingSnapshot.set == 'IdleNonCombat', 'fresh final-A observation was not scheduled')",
                    "assert(#tasks == 1, 'fresh current observation did not receive one settle task')",
                    "equipment.Back = 'Intensifying Cape'",
                    "runNextTask()",
                    "assert(preBarrierState.ReconcileLast.status == 'match', 'pre-barrier current intent did not match')",
                    "assert(preBarrierState.ReconcileLast.set == 'IdleNonCombat', 'pre-barrier observation did not record final A set')",
                    "assert(preBarrierState.ReconcilePendingSnapshot == nil, 'pre-barrier handoff left pending state')",
                    "assert(#tasks == 0, 'pre-barrier handoff left unexpected task')",
                    "tasks = {}",
                    "playerStatus = 'Idle'",
                    "threatActive = false",
                    "equipment = { Main='Numen Staff', Sub='Omni Grip', Back='Swith Cape' }",
                    "forceCount = 0",
                    "backWasReset = false",
                    "lastForceSet = nil",
                    f"local staleProfile = dofile([[{stale_profile_path.as_posix()}]])",
                    "local staleState = findUpvalue(staleProfile.HandleDefault, 'state', {}, 0)",
                    "assert(staleState, 'stale-intent profile state was not discoverable')",
                    "staleProfile.HandleDefault()",
                    "runNextTask()",
                    "runNextTask()",
                    "local staleReservation = staleState.ReconcilePendingSnapshot",
                    "local staleToken = staleState.ReconcileScanToken",
                    "runNextTask(0.2)",
                    "assert(forceCount == 3, 'stale-intent fixture did not reach its first safe re-equip')",
                    "assert(#tasks == 1, 'stale-intent fixture did not queue its delayed reassert')",
                    "threatActive = true",
                    "equipment.Back = \"Boxer's Mantle\"",
                    "staleProfile.HandleDefault()",
                    "assert(staleState.ReconcilePendingSnapshot == staleReservation, 'different signature replaced reservation before its guarded callback')",
                    "assert(staleState.ReconcileScanToken == staleToken, 'different signature invalidated token before its guarded callback')",
                    "assert(staleState.ReconcilePendingSnapshot.repairSupersedingSnapshot.set == 'IdleCombat', 'different signature was not retained as current intent')",
                    "assert(#tasks == 1, 'different signature scheduled an overlapping observation')",
                    "runNextTask(0.2)",
                    "assert(forceCount == 3, 'stale reset callback forced old equipment')",
                    "assert(equipment.Back == \"Boxer's Mantle\", 'stale reset callback overwrote current equipment')",
                    "assert(staleState.ReconcilePendingSnapshot ~= staleReservation, 'stale reservation survived superseding callback')",
                    "assert(staleState.ReconcileScanToken ~= staleToken, 'superseding callback retained stale token')",
                    "assert(staleState.ReconcilePendingSnapshot.set == 'IdleCombat', 'superseding callback did not schedule current set')",
                    "assert(#tasks == 1, 'superseding callback did not schedule one current observation')",
                    "runNextTask()",
                    "assert(staleState.ReconcileLast.status == 'match', 'current-set observation did not complete')",
                    "assert(staleState.ReconcileLast.set == 'IdleCombat', 'current-set observation recorded stale set')",
                    "assert(staleState.ReconcilePendingSnapshot == nil, 'current-set observation left pending state')",
                    "assert(#tasks == 0, 'stale-intent scenario left an unexpected task')",
                    "tasks = {}",
                    "playerStatus = 'Idle'",
                    "threatActive = false",
                    "equipment = { Main='Numen Staff', Sub='Omni Grip', Back='Swith Cape' }",
                    "forceCount = 0",
                    "gFunc.ForceEquipSet = function(set)",
                    "  forceCount = forceCount + 1",
                    "  if set and set.Back == 'remove' then equipment.Back = nil end",
                    "end",
                    f"local terminalProfile = dofile([[{profile_path.as_posix()}]])",
                    "local terminalState = findUpvalue(terminalProfile.HandleDefault, 'state', {}, 0)",
                    "assert(terminalState, 'terminal profile state was not discoverable')",
                    "terminalProfile.HandleDefault()",
                    "runNextTask()",
                    "assert(forceCount == 1, 'terminal case did not queue first repair')",
                    "local terminalCycle = terminalState.ReconcilePendingSnapshot.cycleSequence",
                    "assert(terminalCycle ~= nil, 'terminal repair lifecycle identity was not allocated')",
                    "terminalProfile.HandleDefault()",
                    "runNextTask()",
                    "assert(forceCount == 2, 'terminal case did not create its reset barrier')",
                    "terminalProfile.HandleDefault()",
                    "runNextTask(0.2)",
                    "assert(forceCount == 3, 'terminal case did not issue its post-reset re-equip')",
                    "terminalProfile.HandleDefault()",
                    "runNextTask(0.2)",
                    "assert(forceCount == 4, 'terminal case did not issue exactly one bounded reassert')",
                    "terminalProfile.HandleDefault()",
                    "local terminalPriorRow = terminalState.ReconcileLast",
                    "runNextTask()",
                    "assert(forceCount == 4, 'terminal case exceeded the bounded reassert contract')",
                    "assert(equipment.Back == nil, 'terminal case unexpectedly restored equipment')",
                    "assert(terminalState.ReconcileLast == terminalPriorRow, 'attempt-2 mismatch was emitted before final settle')",
                    "assert(terminalState.ReconcilePendingSnapshot.observationOnly == true, 'terminal settle was not observation-only')",
                    "assert(terminalState.ReconcilePendingSnapshot.repair == true, 'terminal settle lost repair identity')",
                    "assert(terminalState.ReconcilePendingSnapshot.repairAttempt == 2, 'terminal settle changed attempt count')",
                    "assert(terminalState.ReconcilePendingSnapshot.cycleSequence == terminalCycle, 'terminal settle changed lifecycle identity')",
                    "assert(#tasks == 1, 'terminal mismatch did not queue exactly one final settle')",
                    "runNextTask(0.2)",
                    "assert(forceCount == 4, 'terminal final settle mutated equipment')",
                    "assert(terminalState.ReconcileLast.status == 'mismatch', 'terminal mismatch was not recorded')",
                    "assert(terminalState.ReconcileLast.repair == true, 'terminal mismatch was not labeled as repair')",
                    "assert(terminalState.ReconcileLast.repairAttempt == 2, 'terminal attempt count was not recorded')",
                    "assert(terminalState.ReconcileLast.observationOnly == true, 'terminal row lost observation-only marker')",
                    "assert(terminalState.ReconcileLast.repairFailed == true, 'terminal mismatch was not labeled as failed repair')",
                    "assert(terminalState.ReconcileLast.cycleSequence == terminalCycle, 'terminal row changed lifecycle identity')",
                    "assert(terminalState.ReconcileLast.repairQueued == false, 'terminal mismatch queued an extra retry')",
                    "assert(terminalState.ReconcilePendingSnapshot == nil, 'terminal mismatch left a pending snapshot')",
                    "assert(terminalState.ReconcileScanScheduled == false, 'terminal mismatch left the scheduler active')",
                    "assert(#tasks == 0, 'terminal mismatch left an unexpected task queued')",
                    "print('PASS reconciliation async repair preservation and bound')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS reconciliation async repair preservation and bound" in completed.stdout


def test_normal_reconciliation_superseders_receive_fresh_settle_windows() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Aftercast": {"Back": "Swith Cape"},
            "Cure": {"Back": "Tempered Cape"},
            "IdleNonCombat": {"Back": "Intensifying Cape"},
            "Movement": {"Back": "Nexus Cape"},
        },
        default_playstyle="Idle",
        playstyle_names=("Idle",),
    )

    with TemporaryDirectory(prefix="oddlua-reconcile-normal-superseder-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(lua, encoding="utf-8")
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local equipment = { Back='Intensifying Cape' }",
                    "local forceCount = 0",
                    "local zoneId = 100",
                    "ashita = { tasks = { once = function(delay, callback) tasks[#tasks + 1] = { delay=delay, callback=callback } end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MP=100 } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=zoneId } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "  GetThreatEntities = function() return {} end,",
                    "}",
                    "gFunc = {",
                    "  LoadFile = function(_path) return nil end,",
                    "  EquipSet = function(_set) end,",
                    "  ForceEquipSet = function(_set) forceCount = forceCount + 1 end,",
                    "}",
                    "local function runNextTask(minimumDelay)",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local task = table.remove(tasks, 1)",
                    "  if minimumDelay then assert(task.delay >= minimumDelay, 'fresh settle window was too short: ' .. tostring(task.delay)) end",
                    "  task.callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 20 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found ~= nil then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "local schedule = findUpvalue(profile.HandleDefault, 'scheduleReconciliationSnapshot', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "assert(type(schedule) == 'function', 'reconciliation scheduler was not discoverable')",
                    "io = nil",
                    "local idle = { Back='Intensifying Cape' }",
                    "local cure = { Back='Tempered Cape' }",
                    "local movement = { Back='Nexus Cape' }",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'default baseline and overlay did not collect into one task')",
                    "local composedOwner = state.ReconcilePendingSnapshot",
                    "local composedToken = state.ReconcileScanToken",
                    "assert(composedOwner.set == 'IdleNonCombat', 'default composition did not retain its final overlay')",
                    "assert(composedOwner.repairSupersedingSnapshot == nil, 'default composition created an internal superseder')",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'repeated identical default scheduled an overlapping task')",
                    "assert(state.ReconcilePendingSnapshot == composedOwner, 'repeated identical default replaced scheduler owner')",
                    "assert(state.ReconcileScanToken == composedToken, 'repeated identical default invalidated scheduler token')",
                    "assert(composedOwner.repairSupersedingSnapshot == nil, 'repeated identical default created a starvation superseder')",
                    "runNextTask(0.35)",
                    "assert(state.ReconcileLast.status == 'match' and state.ReconcileLast.set == 'IdleNonCombat', 'initial idle observation failed')",
                    "local initialLast = state.ReconcileLast",
                    "equipment.Back = 'Context Drift Cape'",
                    "schedule('Cure', cure, false, false, nil)",
                    "local driftOwner = state.ReconcilePendingSnapshot",
                    "schedule('Movement', movement, false, false, nil)",
                    "assert(driftOwner.repairSupersedingSnapshot.set == 'Movement', 'context-drift fixture did not bind superseding intent')",
                    "zoneId = 101",
                    "runNextTask()",
                    "assert(state.ReconcileLast == initialLast, 'A-B-C handoff emitted stale B observation')",
                    "assert(forceCount == 0, 'A-B-C handoff repaired stale B intent')",
                    "assert(state.ReconcilePendingSnapshot == nil and state.ReconcileScanScheduled == false, 'A-B-C handoff retained stale scheduler state')",
                    "assert(state.ReconcileLastRecordedSignature == nil, 'A-B-C handoff poisoned deduplication')",
                    "assert(#tasks == 0, 'A-B-C handoff scheduled stale B under context C')",
                    "schedule('Movement', movement, false, false, nil)",
                    "assert(string.find(state.ReconcilePendingSnapshot.contextSignature, 'zone=101', 1, true), 'fresh C observation did not capture current context')",
                    "equipment.Back = 'Nexus Cape'",
                    "runNextTask(0.35)",
                    "assert(state.ReconcileLast.status == 'match' and state.ReconcileLast.set == 'Movement', 'fresh C observation did not reconcile')",
                    "initialLast = state.ReconcileLast",
                    "equipment.Back = 'Unsettled Cape'",
                    "schedule('Cure', cure, false, false, nil)",
                    "assert(#tasks == 1 and tasks[1].delay < 0.35, 'short action delay was not scheduled')",
                    "local actionOwner = state.ReconcilePendingSnapshot",
                    "schedule('Movement', movement, false, false, nil)",
                    "assert(state.ReconcilePendingSnapshot == actionOwner, 'normal superseder replaced scheduler owner early')",
                    "assert(actionOwner.repairSupersedingSnapshot.set == 'Movement', 'normal superseder did not retain final movement intent')",
                    "assert(#tasks == 1, 'normal superseder scheduled an overlapping task')",
                    "runNextTask()",
                    "assert(state.ReconcileLast == initialLast, 'stale action callback observed final movement before its settle window')",
                    "assert(forceCount == 0, 'stale action callback repaired final movement before its settle window')",
                    "assert(state.ReconcilePendingSnapshot.set == 'Movement', 'fresh movement observation was not scheduled')",
                    "assert(#tasks == 1, 'fresh movement observation did not receive exactly one task')",
                    "equipment.Back = 'Nexus Cape'",
                    "runNextTask(0.35)",
                    "assert(state.ReconcileLast.status == 'match' and state.ReconcileLast.set == 'Movement', 'normal A-B handoff did not observe final movement')",
                    "local movementLast = state.ReconcileLast",
                    "equipment.Back = 'Unsettled Again Cape'",
                    "schedule('Cure', cure, false, false, nil)",
                    "local returnOwner = state.ReconcilePendingSnapshot",
                    "schedule('Movement', movement, false, false, nil)",
                    "assert(state.ReconcilePendingSnapshot == returnOwner, 'normal A-B-A transition replaced scheduler owner early')",
                    "assert(returnOwner.repairSupersedingSnapshot.set == 'Movement', 'normal A-B-A transition dropped final A intent')",
                    "runNextTask()",
                    "assert(state.ReconcileLast == movementLast, 'normal A-B-A stale callback observed unsettled final A')",
                    "assert(forceCount == 0, 'normal A-B-A stale callback repaired unsettled final A')",
                    "assert(state.ReconcilePendingSnapshot.set == 'Movement', 'normal A-B-A did not schedule fresh final A observation')",
                    "equipment.Back = 'Nexus Cape'",
                    "runNextTask(0.35)",
                    "assert(state.ReconcileLast.status == 'match' and state.ReconcileLast.set == 'Movement', 'normal A-B-A final observation did not match')",
                    "assert(state.ReconcilePendingSnapshot == nil, 'normal handoff left pending scheduler state')",
                    "assert(state.ReconcileScanScheduled == false, 'normal handoff left scheduler active')",
                    "assert(#tasks == 0, 'normal handoff left an unexpected task')",
                    "gFunc.EquipSet = function(set)",
                    "  for slot, item in pairs(set or {}) do equipment[slot] = item end",
                    "end",
                    "equipment.Back = 'Tempered Cape'",
                    "schedule('Cure', cure, false, false, nil)",
                    "local failedOwner = state.ReconcilePendingSnapshot",
                    "local failedToken = state.ReconcileScanToken",
                    "local lastBeforeFailure = state.ReconcileLast",
                    "local ok, failure = pcall(function()",
                    "  profile.OddLuaRuntime.RunReconciliationComposition(function()",
                    "    profile.HandleDefault()",
                    "    error('simulated post-equip composition failure')",
                    "  end)",
                    "end)",
                    "assert(ok == false and string.find(tostring(failure), 'simulated post-equip composition failure', 1, true), 'composition failure did not propagate')",
                    "assert(state.ReconcileCompositionActive == false, 'failed composition left batching active')",
                    "assert(state.ReconcileCompositionPending == nil, 'failed composition left a collected request')",
                    "assert(state.ReconcilePendingSnapshot == nil, 'failed composition left the old scheduler owner armed')",
                    "assert(state.ReconcileScanScheduled == false, 'failed composition left scheduler active')",
                    "assert(state.ReconcileScanToken ~= failedToken, 'failed composition did not invalidate the old token')",
                    "assert(state.ReconcileLastRecordedSignature == nil, 'failed composition retained stale deduplication state')",
                    "assert(failedOwner ~= nil, 'failed-composition fixture had no prior owner')",
                    "runNextTask()",
                    "assert(forceCount == 0, 'invalidated stale callback forced gear after composition failure')",
                    "assert(state.ReconcileLast == lastBeforeFailure, 'invalidated stale callback observed gear after composition failure')",
                    "assert(#tasks == 0, 'invalidated stale callback left an unexpected task')",
                    "profile.HandleDefault()",
                    "assert(#tasks == 1, 'healthy default did not recover after composition failure')",
                    "assert(state.ReconcilePendingSnapshot.set == 'IdleNonCombat', 'recovered default did not retain its final set')",
                    "runNextTask(0.35)",
                    "assert(state.ReconcileLast.status == 'match' and state.ReconcileLast.set == 'IdleNonCombat', 'recovered default did not reconcile')",
                    "assert(state.ReconcilePendingSnapshot == nil and state.ReconcileScanScheduled == false, 'recovered default left scheduler state')",
                    "print('PASS normal reconciliation superseders receive fresh settle windows')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS normal reconciliation superseders receive fresh settle windows" in completed.stdout


def test_reset_barrier_self_schedules_bounded_safe_reassert_after_partial_drop() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="SMN",
        sets={
            "Aftercast": {
                "Main": "Numen Staff",
                "Ear1": "Loquac. Earring",
                "Ear2": "Pagondas Earring",
                "Ring1": "Succor Ring",
                "Ring2": "Corneus Ring",
                "Back": "Colossus's Mantle",
            },
            "IdleNonCombat": {
                "Main": "Numen Staff",
                "Ear1": "Loquac. Earring",
                "Ear2": "Pagondas Earring",
                "Ring1": "Succor Ring",
                "Ring2": "Corneus Ring",
                "Back": "Colossus's Mantle",
            },
        },
        default_playstyle="Idle",
        playstyle_names=("Idle",),
    )

    with TemporaryDirectory(prefix="oddlua-reconcile-scale-reset-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(lua, encoding="utf-8")
        driver_path.write_text(
            "\n".join(
                (
                    "local tasks = {}",
                    "local equipment = { Main='Numen Staff', Ear1='Suppanomimi', Ear2='Relaxing Earring', Ring1='Shadow Ring', Ring2='Alert Ring', Back=\"Summoner's Cape\" }",
                    "local barrierRemoved = false",
                    "local partialReequipCount = 0",
                    "local scaleSignature = nil",
                    "local scaleForceThrowsOnce = true",
                    "local orderedSlots = { 'Main', 'Ear1', 'Ear2', 'Ring1', 'Ring2', 'Back' }",
                    "local function signature(set)",
                    "  local parts = {}",
                    "  for _, slot in ipairs(orderedSlots) do",
                    "    if set and set[slot] ~= nil then parts[#parts + 1] = slot .. '=' .. tostring(set[slot]) end",
                    "  end",
                    "  return table.concat(parts, '|')",
                    "end",
                    "local function apply(set, includeSafeSlots)",
                    "  for slot, item in pairs(set or {}) do",
                    "    if item == 'remove' then",
                    "      equipment[slot] = nil",
                    "    elseif slot == 'Main' or includeSafeSlots then",
                    "      equipment[slot] = item",
                    "    end",
                    "  end",
                    "end",
                    "local fakeScale = {}",
                    "fakeScale.Configure = function(_config) end",
                    "fakeScale.ResolveSet = function(_setName, set, _intent) return set end",
                    "fakeScale.Status = function() return { weaponLockEnabled=true, debounceEnabled=true } end",
                    "fakeScale.EquipSet = function(_setName, set, _intent)",
                    "  local nextSignature = signature(set)",
                    "  if nextSignature ~= scaleSignature then",
                    "    scaleSignature = nextSignature",
                    "    gFunc.EquipSet(set)",
                    "  end",
                    "  return set",
                    "end",
                    "fakeScale.ForceEquipSet = function(_setName, set, _intent)",
                    "  scaleSignature = signature(set)",
                    "  if set and set.Main == nil and scaleForceThrowsOnce then",
                    "    scaleForceThrowsOnce = false",
                    "    error('simulated Scale partial-set failure')",
                    "  end",
                    "  gFunc.ForceEquipSet(set)",
                    "  return set",
                    "end",
                    "ashita = { tasks = { once = function(delay, callback) tasks[#tasks + 1] = { delay=delay, callback=callback } end } }",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MP=100 } end,",
                    "  GetEnvironment = function() return { Area='West Ronfaure', ZoneId=100 } end,",
                    "  GetEquipment = function() return equipment end,",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "}",
                    "gFunc = {",
                    "  LoadFile = function(path) if path == 'common/scale.lua' then return fakeScale end return nil end,",
                    "  EquipSet = function(set) apply(set, false) end,",
                    "  ForceEquipSet = function(set)",
                    "    local removesSlot = false",
                    "    for _, item in pairs(set or {}) do if item == 'remove' then removesSlot = true end end",
                    "    if removesSlot then",
                    "      apply(set, true)",
                    "      barrierRemoved = true",
                    "    elseif barrierRemoved and set and set.Main == nil then",
                    "      partialReequipCount = partialReequipCount + 1",
                    "      if partialReequipCount == 1 then",
                    "        apply({ Ring2=set.Ring2, Back=set.Back }, true)",
                    "      else",
                    "        apply(set, true)",
                    "      end",
                    "    else",
                    "      apply(set, false)",
                    "    end",
                    "  end,",
                    "}",
                    "local function runNextTask(minimumDelay)",
                    "  assert(#tasks > 0, 'expected a scheduled reconciliation task')",
                    "  local task = table.remove(tasks, 1)",
                    "  if minimumDelay then assert(task.delay >= minimumDelay, 'scheduled barrier was too short') end",
                    "  task.callback()",
                    "end",
                    "local function findUpvalue(fn, wanted, visited, depth)",
                    "  if type(fn) ~= 'function' or visited[fn] or depth > 10 then return nil end",
                    "  visited[fn] = true",
                    "  for index = 1, 192 do",
                    "    local name, value = debug.getupvalue(fn, index)",
                    "    if not name then break end",
                    "    if name == wanted and type(value) == 'table' then return value end",
                    "    if type(value) == 'function' then",
                    "      local found = findUpvalue(value, wanted, visited, depth + 1)",
                    "      if found then return found end",
                    "    end",
                    "  end",
                    "  return nil",
                    "end",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "local state = findUpvalue(profile.HandleDefault, 'state', {}, 0)",
                    "assert(state, 'profile state was not discoverable')",
                    "io = nil",
                    "profile.HandleDefault()",
                    "runNextTask()",
                    "assert(state.ReconcileLast.repairQueued == true, 'initial repair was not queued')",
                    "runNextTask()",
                    "assert(state.ReconcileLast.repairStrategy == 'reset_barrier', 'reset barrier was not queued')",
                    "assert(barrierRemoved == true, 'reset barrier did not clear the stubborn slots')",
                    "local resetReservation = state.ReconcilePendingSnapshot",
                    "local resetToken = state.ReconcileScanToken",
                    "runNextTask(0.2)",
                    "assert(partialReequipCount == 1, 'fixture did not partially drop the first safe re-equip')",
                    "assert(scaleForceThrowsOnce == false, 'fixture did not exercise raw fallback after Scale failure')",
                    "assert(equipment.Ear1 == nil, 'first safe re-equip unexpectedly restored Ear1')",
                    "assert(equipment.Ear2 == nil, 'first safe re-equip unexpectedly restored Ear2')",
                    "assert(equipment.Ring1 == nil, 'first safe re-equip unexpectedly restored Ring1')",
                    "assert(equipment.Ring2 == 'Corneus Ring', 'fixture did not restore Ring2 on the partial send')",
                    "assert(equipment.Back == \"Colossus's Mantle\", 'fixture did not restore Back on the partial send')",
                    "local partialSignature = 'Ear1=Loquac. Earring|Ear2=Pagondas Earring|Ring1=Succor Ring|Ring2=Corneus Ring|Back=Colossus\\'s Mantle'",
                    "local fullSignature = 'Main=Numen Staff|' .. partialSignature",
                    "assert(scaleSignature == partialSignature, 'Scale signature did not track the dropped partial re-equip')",
                    "assert(scaleSignature ~= fullSignature, 'Scale signature incorrectly retained the full set')",
                    "assert(state.ReconcilePendingSnapshot == resetReservation, 'first safe re-equip released its repair reservation')",
                    "assert(state.ReconcileScanToken == resetToken, 'first safe re-equip invalidated its repair token')",
                    "assert(#tasks == 1, 'first safe re-equip did not schedule its bounded reassert')",
                    "runNextTask(0.2)",
                    "assert(partialReequipCount == 2, 'reset barrier did not issue its bounded safe reassert')",
                    "assert(scaleSignature == partialSignature, 'bounded safe reassert changed the request scope')",
                    "assert(equipment.Ear1 == 'Loquac. Earring', 'bounded safe reassert did not restore Ear1')",
                    "assert(equipment.Ear2 == 'Pagondas Earring', 'bounded safe reassert did not restore Ear2')",
                    "assert(equipment.Ring1 == 'Succor Ring', 'bounded safe reassert did not restore Ring1')",
                    "assert(state.ReconcilePendingSnapshot.repairAttempt == 2, 'bounded safe reassert changed the repair attempt')",
                    "assert(state.ReconcilePendingSnapshot.repairResetBarrier ~= true, 'bounded safe reassert left the barrier reservation active')",
                    "assert(#tasks == 1, 'bounded safe reassert did not schedule confirmation')",
                    "runNextTask()",
                    "assert(state.ReconcileLast.status == 'match', 'bounded safe reassert left reset slots empty')",
                    "assert(state.ReconcileLast.repairAttempt == 2, 'successful reset confirmation used the wrong attempt')",
                    "assert(equipment.Ear1 == 'Loquac. Earring', 'Ear1 was not restored')",
                    "assert(equipment.Ear2 == 'Pagondas Earring', 'Ear2 was not restored')",
                    "assert(equipment.Ring1 == 'Succor Ring', 'Ring1 was not restored')",
                    "assert(equipment.Ring2 == 'Corneus Ring', 'Ring2 was not restored')",
                    "assert(equipment.Back == \"Colossus's Mantle\", 'Back was not restored')",
                    "assert(state.ReconcilePendingSnapshot == nil, 'successful reset left a pending snapshot')",
                    "assert(state.ReconcileScanScheduled == false, 'successful reset left the scheduler active')",
                    "assert(#tasks == 0, 'successful reset left an unexpected task queued')",
                    "print('PASS reset barrier self-schedules bounded safe reassert after partial drop')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS reset barrier self-schedules bounded safe reassert" in completed.stdout


def test_city_movement_contract_blocks_mounted_and_unknown_then_restores() -> None:
    with TemporaryDirectory(prefix="oddlua-mounted-city-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(_profile_lua(), encoding="utf-8")
        driver_path.write_text(
            "\n".join(
                (
                    "local buffMode = 'mounted'",
                    "local movementEquips = 0",
                    "local function recordSet(set)",
                    "  if type(set) == 'table' and (set.Body == 'Kupo Suit' or set.Feet == \"Herald's Gaiters\") then",
                    "    movementEquips = movementEquips + 1",
                    "  end",
                    "end",
                    "gData = {",
                    "  GetPlayer = function() return { Name='Tester', HP=1000, HPP=100, Status='Idle', MP=100, IsMoving=true } end,",
                    "  GetEnvironment = function() return { Area='Bastok Markets', ZoneId=235 } end,",
                    "  GetEquipment = function() return {} end,",
                    "  GetBuffCount = function(probe)",
                    "    if buffMode == 'unknown' then error('buff state unavailable') end",
                    "    if buffMode == 'mounted' and probe == 252 then return 1 end",
                    "    return 0",
                    "  end,",
                    "}",
                    "gFunc = { LoadFile=function(_path) return nil end, EquipSet=recordSet, ForceEquipSet=recordSet }",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "io = nil",
                    "profile.HandleDefault()",
                    "assert(movementEquips == 0, 'mounted city movement equipped')",
                    "buffMode = 'unknown'; profile.HandleDefault()",
                    "assert(movementEquips == 0, 'unknown mount state equipped movement')",
                    "buffMode = 'clear'; profile.HandleDefault()",
                    "assert(movementEquips > 0, 'on-foot city movement did not restore')",
                    "print('PASS mounted city movement gate')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS mounted city movement gate" in completed.stdout


def test_runtime_hysteresis_contract_executes_exact_transition_bands() -> None:
    lua = _profile_lua()
    assert "EmergencyHpEnterHpp = 35" in lua
    assert "EmergencyHpExitHpp = 40" in lua
    assert "IdlePoolBand = 10" in lua
    assert "fieldName ~= 'EmergencyHpActive'" in lua
    assert "state.IdleMaxMPActive = false;" in lua
    assert "state.IdleMaxHPActive = false;" in lua

    with TemporaryDirectory(prefix="oddlua-hysteresis-") as temporary_directory:
        root = Path(temporary_directory)
        profile_path = root / "profile.lua"
        driver_path = root / "contract.lua"
        profile_path.write_text(lua, encoding="utf-8")
        driver_path.write_text(
            "\n".join(
                (
                    "gData = {",
                    "  GetBuffCount = function(_probe) return 0 end,",
                    "  GetPlayer = function() return nil end,",
                    "  GetEquipment = function() return {} end,",
                    "}",
                    "gFunc = { LoadFile = function(_path) return nil end }",
                    f"local profile = dofile([[{profile_path.as_posix()}]])",
                    "assert(profile.HandleIdlePoolCommand({ 'setmp', '100' }) == true)",
                    "local p = { Status = 'Idle', MP = 99, HP = 100, HPP = 36 }",
                    "assert(profile.OddLuaRuntime.ShouldEquipIdleMaxMP(p) == false)",
                    "p.MP = 100; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxMP(p) == true)",
                    "p.MP = 99; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxMP(p) == true)",
                    "p.MP = 91; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxMP(p) == true)",
                    "p.MP = 90; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxMP(p) == false)",
                    "p.MP = 99; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxMP(p) == false)",
                    "assert(profile.HandleIdlePoolCommand({ 'sethp', '100' }) == true)",
                    "p.HP = 100; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxHP(p) == false)",
                    "p.HP = 99; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxHP(p) == true)",
                    "p.HP = 100; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxHP(p) == true)",
                    "p.HP = 109; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxHP(p) == true)",
                    "p.HP = 110; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxHP(p) == false)",
                    "p.HP = 100; assert(profile.OddLuaRuntime.ShouldEquipIdleMaxHP(p) == false)",
                    "assert(profile.OddLuaRuntime.IsEmergencyHp(p) == false)",
                    "p.HPP = 35; assert(profile.OddLuaRuntime.IsEmergencyHp(p) == true)",
                    "p.HPP = 36; assert(profile.OddLuaRuntime.IsEmergencyHp(p) == true)",
                    "p.HPP = 39; assert(profile.OddLuaRuntime.IsEmergencyHp(p) == true)",
                    "p.HPP = nil; assert(profile.OddLuaRuntime.IsEmergencyHp(p) == true)",
                    "p.HPP = 40; assert(profile.OddLuaRuntime.IsEmergencyHp(p) == false)",
                    "p.HPP = 39; assert(profile.OddLuaRuntime.IsEmergencyHp(p) == false)",
                    "assert(profile.OddLuaRuntime.IsEmergencyHp(nil) == false)",
                    "assert(profile.OddLuaRuntime.UpdateHysteresisState('UnknownField', true, true, false) == false)",
                    "print('PASS runtime hysteresis bands')",
                )
            ),
            encoding="utf-8",
        )
        completed = subprocess.run(
            ["luajit", str(driver_path)],
            check=False,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert completed.returncode == 0, completed.stdout + completed.stderr
        assert "PASS runtime hysteresis bands" in completed.stdout
