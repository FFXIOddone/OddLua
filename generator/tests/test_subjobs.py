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
    assert "daken" in nin.capabilities
    assert any(trait.name == "dual wield" and trait.level == 25 and trait.value == 15 for trait in nin.traits)
    assert any(trait.name == "daken" and trait.level == 25 and trait.value == 20 for trait in nin.traits)
    assert [spell.name for spell in nin.spells] == ["utsusemi_ichi", "utsusemi_ni"]


def test_catseye_thf_subjob_profile_includes_dual_wield_for_rdm() -> None:
    profiles = build_subjob_profiles("RDM")

    assert "THF" in profiles
    assert "dual_wield" in profiles["THF"].capabilities


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
        "    equipDefaultForPlayer(getPlayer(), false);"
    ) in lua
    assert "equipCurrent(false);" not in lua
    assert "profile.HandlePrecast = function()\n    equipNamedSet('FastCast', false);" in lua
    assert "elseif skill == 'blue magic' then" in lua
    assert "equipFirstAvailable({ 'BlueMagic', 'PhysicalBlueMagic', 'MagicalBlueMagic', 'Midcast' }, false);" in lua
    assert "local function equipWeaponskill()" in lua
    assert "equipNamedSet('Weaponskill', false);" in lua
    assert "profile.HandleWeaponskill = function()\n    equipWeaponskill();" in lua
    assert "equipDefaultForPlayer(getPlayer(), true);" in lua


def test_rendered_lua_integrates_overt_defense_pressure_with_weapon_lock_override() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="THF",
        sets={
            "Melt": {"Main": "Thief's Knife", "Body": "Scorpion Harness"},
            "PDT": {"Main": "Terra's Staff", "Sub": "Reign Grip", "Body": "Darksteel Harness"},
            "Hybrid": {"Body": "Scorpion Harness +1"},
            "MDT": {"Body": "Coral Scale Mail +1"},
        },
        default_playstyle="Melt",
    )

    assert "local OVERT_DEFENSE_TARGET_COUNT = 3;" in lua
    assert "local OVERT_DEFENSE_TP_UNLOCK = 700;" in lua
    assert "local OVERT_DEFENSE_HP_FORCE_HPP = 60;" in lua
    assert "profile.GetThreatEntities = nil;" in lua
    assert "local function playerTp(player)" in lua
    assert "local function countOvertDefenseThreats(player)" in lua
    assert "local function shouldEquipOvertDefense(player)" in lua
    assert "local function equipOvertDefensiveSet(setName)" in lua
    assert "scale.SetWeaponLockEnabled(false);" in lua
    assert "local previousWeaponLockEnabled = status.weaponLockEnabled == true;" in lua
    assert "if hpp ~= nil and hpp < OVERT_DEFENSE_HP_FORCE_HPP then" in lua
    assert "if tp < OVERT_DEFENSE_TP_UNLOCK then" in lua

    default_block = lua[lua.index("local function equipDefaultForPlayer") : lua.index("local function equipBlueMagic")]
    assert default_block.index("local defensiveSet = shouldEquipOvertDefense(player);") < default_block.index(
        "isEmergencyHp(player)"
    )
    assert "equipOvertDefensiveSet(defensiveSet);" in default_block


def test_rendered_lua_routes_exact_weaponskill_sets_before_generic_fallbacks() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="SAM",
        sets={
            "WS_Tachi_Gekko": {"Body": "Kirin's Osode"},
            "WSAcc_Tachi_Gekko": {"Neck": "Justice Torque"},
            "WSElemental": {"Neck": "Philomath Stole"},
            "Weaponskill": {"Body": "Haubergeon +1"},
        },
        default_playstyle="StoreTP",
    )

    assert "local weaponSkillRoutes = {\n    ['tachi_gekko'] = 'WS_Tachi_Gekko',\n};" in lua
    assert "local weaponSkillAccuracyRoutes = {\n    ['tachi_gekko'] = 'WSAcc_Tachi_Gekko',\n};" in lua
    assert 'local weaponSkillRoutes = {"' not in lua
    assert 'local weaponSkillAccuracyRoutes = {"' not in lua
    assert "local function weaponSkillRouteKey(name)" in lua
    assert "local exactRoute = weaponSkillRoutes[key];" in lua
    assert "local accuracyRoute = weaponSkillAccuracyRoutes[key];" in lua
    assert "if accuracyRoute and equipNamedSet(accuracyRoute, false) then" in lua


def test_rendered_lua_routes_blue_magic_by_spell_name_not_active_style() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="BLU",
        sets={
            "PhysicalBlue": {"Main": "Unbreakable", "Neck": "Peacock Charm"},
            "MagicalBlue": {"Main": "Stormblade", "Neck": "Aife's Medal"},
            "FastCast": {"Head": "Walahra Turban", "Ear1": "Loquac. Earring"},
            "Cure": {"Main": "Tamaxchi", "Ring1": "Aqua Ring"},
        },
        default_playstyle="PhysicalBlue",
    )

    assert "local blueMagicRoutes = {" in lua
    assert "    ['frenetic rip'] = 'PhysicalBlueMagic'," in lua
    assert "    ['charged whisker'] = 'MagicalBlueMagic'," in lua
    assert "    ['wild carrot'] = 'Cure'," in lua
    assert "local function equipBlueMagic(name)" in lua
    assert "local route = blueMagicRoutes[normalize(name)];" in lua
    assert "if route and equipNamedSet(route, false) then" in lua
    assert "equipFirstAvailable({ 'BlueMagic', 'PhysicalBlueMagic', 'MagicalBlueMagic', 'Midcast' }, false);" in lua
    assert "equipBlueMagic(name);" in lua
    assert "local function equipBlueMagic()\n    local active = activeCombatStyle();" not in lua


def test_rendered_aahtacos_sam_keeps_auto_combat_controls() -> None:
    lua = render_profile(
        player="Aahtacos",
        player_id="30102",
        job="SAM",
        sets={
            "StoreTP": {"Main": "Amanomurakumo", "Hands": "Dusk Gloves"},
            "Accuracy": {"Main": "Amanomurakumo", "Hands": "Hachiryu Kote"},
            "WeaponSkill": {"Main": "Amanomurakumo", "Head": "Wyvern Helm"},
            "ThirdEye": {"Legs": "Saotome Haidate"},
            "Meditate": {"Hands": "Saotome Kote"},
        },
        default_playstyle="StoreTP",
        playstyle_names=("StoreTP", "Accuracy", "WeaponSkill"),
        profile_features=("aahtacos_sam_controls",),
    )

    assert "AutoThirdEye = false," in lua
    assert "AutoWarBuffs = false," in lua
    assert "AutoCombat = false," in lua
    assert "local THIRD_EYE_COMMAND = '/ja \"Third Eye\" <me>';" in lua
    assert "local function maybeAutoThirdEye(player)" in lua
    assert "if not hasBuff('Seigan') then" in lua
    assert "if hasBuff('Third Eye') then" in lua
    assert "isAbilityOnCooldown('Third Eye')" in lua
    assert "elseif command == 'seiganeye' then" in lua
    assert "{ delay = 1, text = '/ja \"Seigan\" <me>' }," in lua
    assert "{ delay = 3, text = '/ja \"Third Eye\" <me>' }," in lua
    assert "elseif command == 'autoeye' or command == 'autothirdeye' then" in lua
    assert "elseif command == 'autocombat' or command == 'autoincombat' then" in lua
    assert "maybeAutoThirdEye(player);" in lua
    assert "maybeAutoWarBuffs(player);" in lua
    assert "equipFirstAvailable({ 'ThirdEye', 'JobAbility' }, false);" in lua
    assert "equipFirstAvailable({ 'Meditate', 'JobAbility' }, false);" in lua


def test_rendered_aahtacos_sam_stays_under_luajit_top_level_local_limit() -> None:
    lua = render_profile(
        player="Aahtacos",
        player_id="30102",
        job="SAM",
        sets={"Aftercast": {"Body": "Hachiman Domaru"}},
        default_playstyle="Aftercast",
        profile_features=("aahtacos_sam_controls",),
    )

    top_level_local_count = sum(
        1
        for line in lua.splitlines()
        if line.startswith("local ")
    )

    assert top_level_local_count <= 200


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
    assert "Use /lac fwd help for commands and one-button setup." in lua


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
    assert semantic_sets["InCity"] == {}
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
    assert "if isClearSet(setToEquip) then" in lua
    assert "gFunc.EquipSet(setToEquip);" in lua
    assert "gFunc.ForceEquipSet(setToEquip);" in lua


def test_rendered_lua_locks_secondary_slots_for_multi_slot_equipment() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Survival": {"Body": "Kupo Suit"},
            "Enspell": {"Body": "Rapparee Harness", "Legs": "Byakko's Haidate"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        secondary_slot_locks={"Survival": {"Body": ("Legs",)}},
    )

    assert "local setSecondarySlotLocks = {" in lua
    assert "    Survival = {" in lua
    assert "        Body = { 'Legs' }," in lua
    assert "local function releaseSecondarySlotLocksNotInSet(setName)" in lua
    assert "local function applySecondarySlotLocksForSet(setName)" in lua
    assert "gFunc.Enable(slot);" in lua
    assert "gFunc.Disable(slot);" in lua
    assert "releaseSecondarySlotLocksNotInSet(setName);" in lua
    assert "applySecondarySlotLocksForSet(setName);" in lua
    assert "unlockSecondarySlotLocks();" in lua


def test_rendered_lua_updates_secondary_slot_lock_state_before_luashitacast_calls() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Survival": {"Body": "Kupo Suit"},
            "Enspell": {"Body": "Rapparee Harness", "Legs": "Byakko's Haidate"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        secondary_slot_locks={"Survival": {"Body": ("Legs",)}},
    )

    release_block = _lua_function_block(lua, "releaseSecondarySlotLocksNotInSetNames")
    apply_block = _lua_function_block(lua, "applySecondarySlotLocksForSet")
    unlock_block = _lua_function_block(lua, "unlockSecondarySlotLocks")

    assert release_block.index("active[slot] = nil;") < release_block.index("gFunc.Enable(slot);")
    assert apply_block.index("active[slot] = true;") < apply_block.index("gFunc.Disable(slot);")
    assert unlock_block.index("active[slot] = nil;") < unlock_block.index("gFunc.Enable(slot);")


def test_rendered_lua_resolves_idle_movement_secondary_locks_as_one_context() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "Aftercast": {"Body": "Refresh Body", "Legs": "Duelist's Tights"},
            "Movement": {"Feet": "Strider Boots"},
            "InCity": {"Body": "Kupo Suit"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
        secondary_slot_locks={"InCity": {"Body": ("Legs",)}},
    )

    release_block = _lua_function_block(lua, "releaseSecondarySlotLocksNotInSet")
    idle_block = _lua_function_block(lua, "equipIdleState")

    assert "local function releaseSecondarySlotLocksNotInSetNames(setNames)" in lua
    assert "local function idleSecondarySlotLockSetNames(player, environment)" in lua
    assert "local contextSetNames = state.SecondarySlotLockContextSetNames;" in release_block
    assert "releaseSecondarySlotLocksNotInSetNames(contextSetNames);" in release_block
    assert "state.SecondarySlotLockContextSetNames = idleSecondarySlotLockSetNames(player, getEnvironment());" in idle_block
    assert (
        idle_block.index("state.SecondarySlotLockContextSetNames = idleSecondarySlotLockSetNames(player, getEnvironment());")
        < idle_block.index("pcall(equipBaseIdleState, player, force);")
    )
    assert "state.SecondarySlotLockContextSetNames = previousSecondarySlotLockContext;" in idle_block


def test_rendered_lua_removes_dual_wield_offhand_when_active_subjob_lacks_capability() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="WAR",
        sets={"Damage": {"Main": "Hunahpu", "Sub": "Martial Axe"}},
        default_playstyle="Damage",
        playstyle_names=("Damage",),
        subjob_profiles=build_subjob_profiles("WAR"),
        default_subjob="NIN",
        dual_wield_sub_sets={"Damage"},
    )

    assert "local nativeDualWieldMainJobs = {" in lua
    assert "local setRequiresDualWieldSub = {" in lua
    assert "    Damage = true," in lua
    assert "    Playstyle_Damage = true," in lua
    assert "local function setWithSubjobLegalOffhand(setName, set)" in lua
    assert "if setRequiresDualWieldSub[setName] ~= true then" in lua
    assert "if mainJobHasNativeDualWield() or hasSubjobCapability('dual_wield') then" in lua
    assert "adjusted.Sub = 'remove';" in lua
    assert "local setToEquip = setWithSubjobLegalOffhand(setName, set);" in lua


def test_rendered_lua_applies_status_conditional_equips_after_matching_set() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="SAM",
        sets={"Accuracy": {"Neck": "Peacock Charm"}},
        default_playstyle="Accuracy",
        playstyle_names=("Accuracy",),
        conditional_equips={
            "Accuracy": (
                {
                    "condition": {
                        "type": "status",
                        "name": "paralysis",
                        "buffs": ("paralysis",),
                    },
                    "slots": {"Neck": "Halting Stole"},
                },
            )
        },
    )

    assert "local conditionalEquips = {" in lua
    assert "Playstyle_Accuracy = {" in lua
    assert "condition = { type = 'status', name = 'paralysis', buffs = { 'paralysis' } }" in lua
    assert "slots = { Neck = 'Halting Stole' }" in lua
    assert "gFunc.LoadFile('common/conditionals.lua')" in lua
    assert "conditionals.ApplyForSet(conditionalEquips, setName, {" in lua
    assert "applyConditionalEquipsForSet(setName, effectiveForce);" in lua


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
        "InCity",
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
            "InCity": {"Body": "Kupo Suit"},
            "Movement": {"Feet": "Strider Boots"},
            "Movement_City": {"Body": "Kingdom Aketon"},
            "Movement_Night": {"Feet": "Ninja Kyahan"},
            "Movement_DuskToDawn": {"Feet": "Nin. Kyahan +1"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "    InCity = {" in lua
    assert "    Movement = {" in lua
    assert "    Movement_City = {" in lua
    assert "    Movement_Night = {" in lua
    assert "    Movement_DuskToDawn = {" in lua
    assert "local cityAreas = {" in lua
    assert "local function isCity(environment)" in lua
    assert "local function isNight(environment)" in lua
    assert "local function isDuskToDawn(environment)" in lua
    assert "local function equipNamedSetIfNotClear(setName, force)" in lua
    assert "local function equipMovement(player, environment, force)" in lua
    assert "local function equipIdleState(player, force)" in lua
    assert "if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('InCity', force) then" in lua
    assert lua.index("equipNamedSetIfNotClear('Movement_City', force)") < lua.index("equipNamedSetIfNotClear('InCity', force)")
    assert "equipMovement(player, getEnvironment(), force);" in lua
    assert "if equipMovement(getEnvironment(), force) then\n            return;" not in lua


def test_rendered_lua_applies_movement_in_city_or_out_of_combat_on_foot() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "InCity": {"Body": "Kupo Suit"},
            "Movement_City": {"Body": "Kingdom Aketon"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    movement_gate = _lua_function_block(lua, "canEquipMovement")
    incity_gate = _lua_function_block(lua, "shouldEquipInCityMovement")
    movement_block = _lua_function_block(lua, "equipMovement")
    movement_context_block = _lua_function_block(lua, "addMovementSecondarySlotLockSetNames")

    assert "local function isMounted(player)" in lua
    assert "local function isOnFoot(player)" in lua
    assert "local mountedStatusIds = { 252 };" in lua
    assert "local function canEquipMovement(player, environment)" in lua
    assert "if isCity(environment) then" in movement_gate
    assert "not isEngaged(player)" in movement_gate
    assert "isOnFoot(player)" in movement_gate
    assert "not isResting(player)" not in movement_gate
    assert "return isCity(environment);" in incity_gate
    assert "if not canEquipMovement(player, environment) then" in movement_block
    assert "if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('Movement_City', force) then" in movement_block
    assert "if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('InCity', force) then" in movement_block
    assert "if not canEquipMovement(player, environment) then" in movement_context_block
    assert "if shouldEquipInCityMovement(player, environment) then" in movement_context_block


def test_rendered_lua_exports_bound_warp_ring_equip_then_use_command() -> None:
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
    assert "local function processWarpRingTimers()" not in lua
    assert "local function useWarpRing()" in lua
    assert "local oddLuaWarpRing = {};" in lua
    assert "function oddLuaWarpRing.lockRing2()" in lua
    assert "function oddLuaWarpRing.unlockRing2()" in lua
    assert "gFunc.Disable('Ring2')" in lua
    assert "gFunc.Enable('Ring2')" in lua
    assert "function oddLuaWarpRing.finishUse()" in lua
    assert "forceEquipInlineSet({ Ring2 = 'Warp Ring' }, true)" in lua
    assert "state.WarpRingLocked = true" in lua
    assert "state.WarpUseAt = now + 9" not in lua
    assert "state.WarpClearAt = now + 30" not in lua
    assert "scheduleTask(9, processWarpRingTimers)" not in lua
    assert "scheduleTask(30, processWarpRingTimers)" not in lua
    assert "scheduleTask(10, oddLuaWarpRing.finishUse)" in lua
    assert "scheduleTask(10, clearWarpRing)" in lua
    assert "queueTypedCommand('/item \"Warp Ring\" <me>', 1)" in lua
    assert "queueTypedCommand('/item \"Warp Ring\" <me>', 9)" not in lua
    assert "queueTypedCommand('/item \"Warp Ring\" <me>', 8.2)" not in lua
    assert "queueTypedCommand('/lac fwd warpclear', 30)" not in lua
    assert "local function clearWarpRing()" in lua
    assert "forceEquipInlineSet({ Ring2 = 'remove' }, true)" in lua
    assert "local handledWarpTimer = processWarpRingTimers();" not in lua
    assert "Press the bound warp key again" not in lua
    assert "state.WarpRingUsable = true" not in lua
    assert "if state.WarpRingLocked == true and state.WarpRingUsable == true then" not in lua
    assert "elseif command == 'warp' then" in lua
    assert "elseif command == 'warpclear' then" in lua


def test_rendered_lua_lockstyle_captures_default_tp_set() -> None:
    lua = render_profile(
        player="Tester",
        player_id="1",
        job="RDM",
        sets={
            "Enspell": {"Main": "Somnia Melodiam"},
            "TP": {"Body": "Scorpion Harness"},
            "InCity": {"Body": "Kupo Suit"},
        },
        default_playstyle="Enspell",
        playstyle_names=("Enspell",),
    )

    assert "local function lockstyleCombatSet()" in lua
    assert "if not equipNamedSet('TP', true) then" in lua
    assert "queueTypedCommand('/lockstyle on', 1)" in lua
    assert "elseif command == 'lockstyle' or command == 'stylelock' then" in lua
    assert "Lockstyle captured TP set." in lua
    lockstyle_block = lua[lua.index("local function lockstyleCombatSet()"):lua.index("local function equipMovement")]
    assert "equipMovement" not in lockstyle_block
    assert "InCity" not in lockstyle_block


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
    assert "equipMovement(player, getEnvironment(), force);" in lua
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
    assert _lua_set_block(lua, "InCity") == _remove_set_block("InCity")
    assert "equipNamedSetIfNotClear('InCity', force)" in lua
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
                (123, "daken", 13, 25, 1, "DAKEN", 20),
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


def _lua_function_block(lua: str, function_name: str) -> str:
    marker = f"local function {function_name}("
    start = lua.index(marker)
    end = lua.find("\nlocal function ", start + len(marker))
    if end == -1:
        end = len(lua)
    return lua[start:end]


def _remove_set_block(set_name: str) -> str:
    lines = [f"    {set_name} = {{"]
    for slot in SLOT_ORDER:
        lines.append(f"        {slot} = 'remove',")
    lines.append("    },")
    return "\n".join(lines)
