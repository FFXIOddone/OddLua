from pathlib import Path
import sqlite3
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.contracts import SUPPORTED_JOBS
from oddlua.renderer import SLOT_ORDER, derive_semantic_sets, render_profile
from oddlua.subjobs import VIABLE_SUBJOBS_BY_MAIN_JOB, build_subjob_profiles


def test_every_supported_main_job_has_viable_subjobs_defined() -> None:
    missing = [job for job in SUPPORTED_JOBS if not VIABLE_SUBJOBS_BY_MAIN_JOB.get(job)]

    assert missing == []


def test_nin_subjob_profile_includes_dual_wield_and_shadows_from_level_37_db(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_subjob_fixture_db(db_path)

    profiles = build_subjob_profiles("THF", db_path=db_path)
    nin = profiles["NIN"]

    assert "dual_wield" in nin.capabilities
    assert "shadows" in nin.capabilities
    assert any(trait.name == "dual wield" and trait.level == 25 and trait.value == 15 for trait in nin.traits)
    assert [spell.name for spell in nin.spells] == ["utsusemi_ichi", "utsusemi_ni"]


def test_static_subjob_profiles_use_canonical_capability_names() -> None:
    sch = build_subjob_profiles("WHM")["SCH"]

    assert "stratagems" in sch.capabilities
    assert "strategems" not in sch.capabilities


def test_rendered_lua_exports_subjob_profiles_and_capability_helpers(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_subjob_fixture_db(db_path)
    subjobs = build_subjob_profiles("THF", db_path=db_path)

    lua = render_profile(
        player="Tester",
        player_id="1",
        job="THF",
        sets={"Melt": {"Main": "Dagger"}},
        default_playstyle="Melt",
        subjob_profiles=subjobs,
        default_subjob="NIN",
    )

    assert "profile.Subjobs = subjobs;" in lua
    assert "profile.HasSubjobCapability = hasSubjobCapability;" in lua
    assert "local jobIdToAbbr = {" in lua
    assert "[13] = 'NIN'" in lua
    assert "NIN = {" in lua
    assert "dual_wield" in lua
    assert "utsusemi_ni" in lua
    assert "Subjob=NIN" in lua
    assert "use subjob traits|spells|abilities" in lua


def test_rendered_lua_uses_dynamic_luashitacast_state_handlers() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="BLU",
        sets={
            "PhysicalBlue": {"Main": "Unbreakable", "Neck": "Peacock Charm"},
            "MagicalBlue": {"Main": "Stormblade", "Neck": "Aife's Medal"},
            "FastCast": {"Head": "Walahra Turban", "Ear1": "Loquac. Earring"},
            "Accuracy": {"Main": "Unbreakable", "Ear2": "Brutal Earring"},
        },
        default_playstyle="PhysicalBlue",
    )

    assert "    Playstyle_PhysicalBlue = {" in lua
    assert "    Idle = {" in lua
    assert "    TP = {" in lua
    assert "    FastCast = {" in lua
    assert "    BlueMagic = {" in lua
    assert "local function equipDefaultForPlayer(player, force)" in lua
    assert (
        "profile.HandleDefault = function()\n"
        "    local handledWarpTimer = processWarpRingTimers();\n"
        "    if handledWarpTimer and state.WarpRingLocked ~= true then\n"
        "        return;\n"
        "    end\n"
        "    equipDefaultForPlayer(getPlayer(), false);"
    ) in lua
    assert "equipCurrent(false);" not in lua
    assert "profile.HandlePrecast = function()\n    equipNamedSet('FastCast', false);" in lua
    assert "elseif skill == 'blue magic' then" in lua
    assert "equipNamedSet('BlueMagic', false);" in lua
    assert "local function equipWeaponskill()" in lua
    assert "equipNamedSet('Weaponskill', false);" in lua
    assert "profile.HandleWeaponskill = function()\n    equipWeaponskill();" in lua
    assert "equipDefaultForPlayer(getPlayer(), true);" in lua


def test_rendered_lua_accepts_raw_resting_status_values() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Resting": {"Body": "Errant Hpl."}},
        default_playstyle="Enspell",
    )

    assert "status == '33'" in lua
    assert "status == '34'" in lua


def test_explicit_semantic_sets_are_not_exposed_as_playstyles() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="THF",
        sets={
            "Melt": {"Main": "Dagger"},
            "Resting": {"Body": "Errant Hpl."},
        },
        default_playstyle="Melt",
        playstyle_names=("Melt",),
    )

    assert "    Resting = {" in lua
    assert "Playstyle_Resting" not in lua
    assert "resting = 'Resting'" not in lua
    assert "style melt." in lua


def test_missing_semantic_sets_do_not_fallback_to_playstyles() -> None:
    semantic_sets = derive_semantic_sets(
        {
            "Enspell": {"Main": "Somnia Melodiam"},
            "FastCast": {"Ear1": "Loquac. Earring"},
            "MagicAccuracy": {"Neck": "Enfeebling Torque"},
        },
        "Enspell",
    )

    assert semantic_sets["TP"] == {}
    assert semantic_sets["Precast"] == {}
    assert semantic_sets["Midcast"] == {}
    assert semantic_sets["Aftercast"] == {}
    assert semantic_sets["Elemental_Fire"] == {}
    assert semantic_sets["FastCast"] == {"Ear1": "Loquac. Earring"}


def test_rendered_missing_semantic_sets_are_blank_debug_sets() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "FastCast": {"Ear1": "Loquac. Earring"},
        },
        default_playstyle="Enspell",
    )

    assert _lua_set_block(lua, "TP") == _remove_set_block("TP")
    assert _lua_set_block(lua, "Precast") == _remove_set_block("Precast")
    assert _lua_set_block(lua, "Midcast") == _remove_set_block("Midcast")
    assert _lua_set_block(lua, "Aftercast") == _remove_set_block("Aftercast")
    assert "Ear1 = 'Loquac. Earring'," in _lua_set_block(lua, "FastCast")


def test_generated_clear_sets_bypass_scale_resolution() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Somnia Melodiam"}},
        default_playstyle="Enspell",
    )

    assert "local function isClearSet(set)" in lua
    assert "if isClearSet(set) then" in lua
    assert "gFunc.EquipSet(set);" in lua
    assert "gFunc.ForceEquipSet(set);" in lua


def test_resolver_sets_render_under_exact_names_without_fallback() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "MagicAccuracy": {"Neck": "Enfeebling Torque"},
            "GeoMagic": {"Range": "Dunna"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "Neck = 'Enfeebling Torque'," in _lua_set_block(lua, "MagicAccuracy")
    assert "Range = 'Dunna'," in _lua_set_block(lua, "GeoMagic")
    assert _lua_set_block(lua, "Midcast") == _remove_set_block("Midcast")
    assert "magicaccuracy = 'MagicAccuracy'" not in lua
    assert "geomagic = 'GeoMagic'" not in lua


def test_rendered_lua_exports_expanded_semantic_set_contract() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "MagicAccuracy": {"Neck": "Enfeebling Torque"},
            "FastCast": {"Ear1": "Loquac. Earring"},
            "Cure": {"Neck": "Colossus's Torque"},
        },
        default_playstyle="Enspell",
    )

    for set_name in (
        "Precast",
        "Midcast",
        "Elemental",
        "Elemental_Fire",
        "Elemental_Ice",
        "Elemental_Wind",
        "Elemental_Earth",
        "Elemental_Lightning",
        "Elemental_Water",
        "Elemental_Light",
        "Elemental_Dark",
        "Weather_Fire",
        "Weather_Ice",
        "Day_Fire",
        "Day_Ice",
        "EnhancingDuration",
        "Stoneskin",
        "Refresh",
        "Regen",
        "SneakInvisible",
        "Sleep",
        "Bind",
        "Stun",
        "DrainAspir",
        "WeaponSkillAccuracy",
        "Aftercast",
    ):
        assert f"    {set_name} = {{" in lua


def test_rendered_lua_routes_magic_by_action_and_environment() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="BLM",
        sets={
            "Nuke": {"Main": "Aquilo's Staff"},
            "MagicAccuracy": {"Neck": "Elemental Torque"},
            "FastCast": {"Ear1": "Loquac. Earring"},
            "IdleRefresh": {"Body": "Yigit Gomlek"},
        },
        default_playstyle="Nuke",
    )

    assert "local function getEnvironment()" in lua
    assert "local function setNameForElement(prefix, element)" in lua
    assert "local function equipElementalMagic(action)" in lua
    assert "local function equipEnhancingMagic(name)" in lua
    assert "local function equipEnfeeblingMagic(name)" in lua
    assert "action.Element" in lua
    assert "environment.DayElement" in lua
    assert "environment.WeatherElement" in lua
    assert "equipNamedSet('Aftercast', force)" in lua
    assert "equipElementalMagic(action);" in lua


def test_rendered_lua_exports_and_routes_movement_sets() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "Movement": {"Feet": "Strider Boots"},
            "Movement_City": {"Body": "Kingdom Aketon"},
            "Movement_Night": {"Feet": "Ninja Kyahan"},
            "Movement_DuskToDawn": {"Feet": "Nin. Kyahan +1"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "    Movement = {" in lua
    assert "    Movement_City = {" in lua
    assert "    Movement_Night = {" in lua
    assert "    Movement_DuskToDawn = {" in lua
    assert "local cityAreas = {" in lua
    assert "local function isCity(environment)" in lua
    assert "local function isNight(environment)" in lua
    assert "local function isDuskToDawn(environment)" in lua
    assert "local function equipNamedSetIfNotClear(setName, force)" in lua
    assert "local function equipMovement(environment, force)" in lua
    assert "local function equipIdleState(player, force)" in lua
    assert "equipMovement(getEnvironment(), force);" in lua
    assert "if equipMovement(getEnvironment(), force) then\n            return;" not in lua


def test_rendered_lua_exports_timed_warp_ring_command() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Somnia Melodiam"}},
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "local function queueTypedCommand(command, mode)" in lua
    assert "local function forceEquipInlineSet(set, ignoreWarpRingLock)" in lua
    assert "WarpRingLocked = false" in lua
    assert "local function applyWarpRingLock(set)" in lua
    assert "local function scheduleTask(delay, callback)" in lua
    assert "local function processWarpRingTimers()" in lua
    assert "local function useWarpRing()" in lua
    assert "forceEquipInlineSet({ Ring2 = 'Warp Ring' })" in lua
    assert "state.WarpRingLocked = true" in lua
    assert "state.WarpUseAt = now + 9" in lua
    assert "state.WarpClearAt = now + 30" in lua
    assert "scheduleTask(9, processWarpRingTimers)" in lua
    assert "scheduleTask(30, processWarpRingTimers)" in lua
    assert "queueTypedCommand('/item \"Warp Ring\" <me>', 1)" in lua
    assert "queueTypedCommand('/item \"Warp Ring\" <me>', 9)" not in lua
    assert "queueTypedCommand('/item \"Warp Ring\" <me>', 8.2)" not in lua
    assert "queueTypedCommand('/lac fwd warpclear', 30)" not in lua
    assert "local function clearWarpRing()" in lua
    assert "forceEquipInlineSet({ Ring2 = 'remove' }, true)" in lua
    assert "local handledWarpTimer = processWarpRingTimers();" in lua
    assert "elseif command == 'warp' then" in lua
    assert "elseif command == 'warpclear' then" in lua


def test_default_idle_routes_to_idle_state_before_movement_overlay() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "Aftercast": {"Body": "Refresh Body"},
            "Movement": {"Feet": "Strider Boots"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "local function equipIdleState(player, force)" in lua
    assert "if isClearSet(sets['Aftercast']) then" in lua
    assert "equipNamedSet('Aftercast', force);" in lua
    assert "equipMovement(getEnvironment(), force);" in lua
    assert "equipIdleState(player, force);" in lua


def test_missing_movement_set_remains_clear_debug_set() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={"Enspell": {"Main": "Somnia Melodiam"}},
        default_playstyle="Enspell",
    )

    assert _lua_set_block(lua, "Movement") == _remove_set_block("Movement")
    assert "equipNamedSetIfNotClear('Movement_City', force)" in lua
    assert "equipNamedSet('Movement', force)" not in lua


def _write_subjob_fixture_db(path: Path) -> None:
    db = sqlite3.connect(path)
    try:
        db.executescript(
            """
            create table abilities (
                ability_id integer primary key,
                name text not null,
                job integer not null,
                level integer not null,
                recast_time integer not null,
                recast_id integer not null,
                ce integer not null,
                ve integer not null
            );
            create table traits (
                trait_id integer not null,
                name text not null,
                job integer not null,
                level integer not null,
                rank integer not null,
                mod_name text not null,
                value integer not null
            );
            create table spells (
                spell_id integer primary key,
                name text not null,
                jobs_hex text not null,
                spell_group integer not null,
                mp_cost integer not null,
                cast_time integer not null,
                recast_time integer not null
            );
            """
        )
        db.executemany(
            "insert into traits(trait_id, name, job, level, rank, mod_name, value) values (?, ?, ?, ?, ?, ?, ?)",
            [
                (18, "dual wield", 13, 10, 1, "DUAL_WIELD", 10),
                (18, "dual wield", 13, 25, 2, "DUAL_WIELD", 15),
            ],
        )
        db.executemany(
            "insert into spells(spell_id, name, jobs_hex, spell_group, mp_cost, cast_time, recast_time) values (?, ?, ?, ?, ?, ?, ?)",
            [
                (338, "utsusemi_ichi", _jobs_blob({13: 12}), 4, 1179, 4000, 30000),
                (339, "utsusemi_ni", _jobs_blob({13: 37}), 4, 1179, 1500, 45000),
                (896, "shantotto", _jobs_blob({13: 1}), 8, 0, 2000, 240000),
            ],
        )
        db.commit()
    finally:
        db.close()


def _jobs_blob(levels_by_job_id: dict[int, int]) -> str:
    levels = bytearray(22)
    for job_id, level in levels_by_job_id.items():
        levels[job_id - 1] = level
    return "0x" + levels.hex()


def _lua_set_block(lua: str, set_name: str) -> str:
    marker = f"    {set_name} = {{"
    start = lua.index(marker)
    end = lua.index("    },", start) + len("    },")
    return lua[start:end]


def _remove_set_block(set_name: str) -> str:
    lines = [f"    {set_name} = {{"]
    for slot in SLOT_ORDER:
        lines.append(f"        {slot} = 'remove',")
    lines.append("    },")
    return "\n".join(lines)
