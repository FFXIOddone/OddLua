from pathlib import Path
import os
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.builder import (
    JOB_STYLE_WEAPON_FAMILIES,
    SelectedGear,
    _effective_default_playstyle,
    _automatic_semantic_styles_for_job,
    _build_combat_style,
    _build_job_sets,
    _conditional_equips_for_sets,
    _job_allowed_weapon_families,
    _load_default_item_stats,
    _weapon_family_policy_for_style,
    _weapon_score,
)
import oddlua.builder as builder_module
from oddlua.classifier import ClassifiedItem, classify_item
from oddlua.contracts import STANDARD_JOB_STYLES, SUPPORTED_JOBS, build_job_contract
from oddlua.gearexport import GearItem
from oddlua.itemstats import (
    EQUIPMENT_SLOT_MASKS,
    EquipmentStats,
    ItemConditionalMod,
    ItemLatent,
    ItemMod,
    ItemStatsIndex,
    WeaponStats,
)
from oddlua.renderer import SEMANTIC_SET_PREFERENCES
from oddlua.subjobs import SubjobProfile
from oddlua.weaponskills import CatseyeWeaponSkill, WeaponSkillEligibilityContext, eligible_weaponskills_for_job


def test_default_item_stats_loader_reuses_unchanged_stats_db(monkeypatch, tmp_path: Path) -> None:
    stats_db = tmp_path / "oddlua_stats.sqlite"
    stats_db.write_text("fixture", encoding="utf-8")
    calls: list[Path] = []

    def fake_load_item_stats_from_db(path: Path) -> ItemStatsIndex:
        calls.append(Path(path))
        return ItemStatsIndex(source_path=Path(path), mods_by_item_id={})

    monkeypatch.setattr(builder_module, "load_item_stats_from_db", fake_load_item_stats_from_db)

    first = _load_default_item_stats(None, stats_db_path=stats_db)
    second = _load_default_item_stats(None, stats_db_path=stats_db)

    assert first is second
    assert calls == [stats_db.resolve()]


def test_default_item_stats_loader_refreshes_changed_stats_db(monkeypatch, tmp_path: Path) -> None:
    stats_db = tmp_path / "oddlua_stats.sqlite"
    stats_db.write_text("fixture", encoding="utf-8")
    calls: list[Path] = []

    def fake_load_item_stats_from_db(path: Path) -> ItemStatsIndex:
        calls.append(Path(path))
        return ItemStatsIndex(source_path=Path(path), mods_by_item_id={})

    monkeypatch.setattr(builder_module, "load_item_stats_from_db", fake_load_item_stats_from_db)

    first = _load_default_item_stats(None, stats_db_path=stats_db)
    _bump_mtime(stats_db)
    second = _load_default_item_stats(None, stats_db_path=stats_db)

    assert first is not second
    assert calls == [stats_db.resolve(), stats_db.resolve()]


def test_current_subjob_wins_default_subjob_for_matching_current_job() -> None:
    contract = build_job_contract("RDM", character_level=75)

    assert builder_module._default_subjob_for_contract(contract, "RDM75/THF37") == "THF"


def test_catseye_thf_subjob_hint_allows_dual_wield_weapon_offhands(monkeypatch) -> None:
    monkeypatch.setitem(builder_module.JOB_STYLE_SUBJOB_HINTS, ("RDM", "Enspell"), "THF")

    assert builder_module._dual_wield_gated_sub_families(("club", "shield"), "RDM", "Enspell") == (
        "club",
        "shield",
    )


def test_build_loader_reuses_unchanged_gearexport(monkeypatch, tmp_path: Path) -> None:
    gear_path = tmp_path / "Oddone_29938_gear.lua"
    gear_path.write_text("fixture", encoding="utf-8")
    calls: list[Path] = []

    def fake_load_gearexport(path: Path) -> object:
        calls.append(Path(path))
        return object()

    monkeypatch.setattr(builder_module, "load_gearexport", fake_load_gearexport)

    first = builder_module._load_gearexport_for_build(gear_path)
    second = builder_module._load_gearexport_for_build(gear_path)

    assert first is second
    assert calls == [gear_path.resolve()]


def test_build_loader_refreshes_changed_gearexport(monkeypatch, tmp_path: Path) -> None:
    gear_path = tmp_path / "Oddone_29938_gear.lua"
    gear_path.write_text("fixture", encoding="utf-8")
    calls: list[Path] = []

    def fake_load_gearexport(path: Path) -> object:
        calls.append(Path(path))
        return object()

    monkeypatch.setattr(builder_module, "load_gearexport", fake_load_gearexport)

    first = builder_module._load_gearexport_for_build(gear_path)
    _bump_mtime(gear_path)
    second = builder_module._load_gearexport_for_build(gear_path)

    assert first is not second
    assert calls == [gear_path.resolve(), gear_path.resolve()]


def test_build_loader_reuses_unchanged_character_snapshot(monkeypatch, tmp_path: Path) -> None:
    character_path = tmp_path / "Oddone_29938_character.json"
    character_path.write_text("{}", encoding="utf-8")
    calls: list[Path] = []

    def fake_load_character_snapshot(path: Path) -> object:
        calls.append(Path(path))
        return object()

    monkeypatch.setattr(builder_module, "load_character_snapshot", fake_load_character_snapshot)

    first = builder_module._load_character_snapshot_for_build(character_path)
    second = builder_module._load_character_snapshot_for_build(character_path)

    assert first is second
    assert calls == [character_path.resolve()]


def test_build_loader_refreshes_changed_character_snapshot(monkeypatch, tmp_path: Path) -> None:
    character_path = tmp_path / "Oddone_29938_character.json"
    character_path.write_text("{}", encoding="utf-8")
    calls: list[Path] = []

    def fake_load_character_snapshot(path: Path) -> object:
        calls.append(Path(path))
        return object()

    monkeypatch.setattr(builder_module, "load_character_snapshot", fake_load_character_snapshot)

    first = builder_module._load_character_snapshot_for_build(character_path)
    _bump_mtime(character_path)
    second = builder_module._load_character_snapshot_for_build(character_path)

    assert first is not second
    assert calls == [character_path.resolve(), character_path.resolve()]


def test_classified_item_eligibility_uses_stored_server_masks(monkeypatch) -> None:
    item = _gear_item(9001, "Fixture Sword", "Main/Sub", "Weapon")
    classification = ClassifiedItem(
        item=item,
        slot_family="weapon",
        weapon_family="sword",
        roles=("combat",),
        tags=tuple(),
        excluded=False,
        exclusion_reason="",
        reasons=tuple(),
        confidence="high",
        confidence_score=1.0,
        server_mods=tuple(),
        pet_server_mods=tuple(),
        augment_mods=tuple(),
        pet_augment_mods=tuple(),
        server_level=75,
        server_jobs_mask=16,
        server_slot_mask=3,
        server_removal_slot_mask=0,
    )

    def fail_if_view_is_rebuilt(self):
        raise AssertionError("eligibility should use stored masks directly")

    monkeypatch.setattr(ClassifiedItem, "_server_equipment_view", fail_if_view_is_rebuilt)

    assert classification.job_eligible("RDM") is True
    assert classification.job_eligible("WAR") is False
    assert classification.slot_eligible("Main") is True
    assert classification.slot_eligible("Sub") is True
    assert classification.slot_eligible("Head") is False


def test_classifier_uses_server_weapon_skill_before_item_name_guessing() -> None:
    item = _weapon(20720, "Egeking")
    item_stats = _rdm_weapon_stats()

    classification = classify_item(item, item_stats=item_stats)

    assert classification.weapon_family == "sword"
    assert "sword_skill" in classification.roles
    assert "Server item_weapon skill 3 identifies sword family." in classification.reasons


def test_classifier_does_not_guess_weapon_family_from_item_name() -> None:
    item = _weapon(9000, "Justice Sword")
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9000: _equipment(9000, "justice_sword", level=75, jobs=16, slot_mask=3),
        },
    )

    classification = classify_item(item, item_stats=item_stats)

    assert classification.slot_family == "weapon"
    assert classification.weapon_family == "unknown"
    assert "sword_skill" not in classification.roles


def test_classifier_treats_ammo_slot_items_as_ammo_family() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9010: (ItemMod(24, "RATT", 10),),
            9011: (ItemMod(11, "AGI", 2),),
        },
        equipment_by_item_id={
            9010: _equipment(9010, "fixture_bullet", level=75, jobs=4194303, slot_mask=8),
            9011: _equipment(9011, "fixture_tathlum", level=75, jobs=4194303, slot_mask=8),
        },
        weapon_stats_by_item_id={
            9010: WeaponStats(item_id=9010, skill=26, delay=240, damage=80, hit=1),
            9011: WeaponStats(item_id=9011, skill=0, delay=999, damage=0, hit=1),
        },
    )

    bullet = classify_item(_gear_item(9010, "Fixture Bullet", "Ammo", "Weapon"), item_stats=item_stats)
    tathlum = classify_item(_gear_item(9011, "Fixture Tathlum", "Ammo", "Weapon"), item_stats=item_stats)

    assert bullet.weapon_family == "ammo"
    assert tathlum.weapon_family == "ammo"
    assert "ranged_offense" in bullet.roles
    assert "Server item_equipment slot identifies ammo family." in bullet.reasons


def test_classifier_distinguishes_generic_throwing_from_shuriken_subskill() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9012: _equipment(9012, "fixture_throwing", level=72, jobs=4194303, slot_mask=8, removal_slot_mask=4),
            9013: _equipment(9013, "fixture_shuriken", level=48, jobs=4096, slot_mask=8, removal_slot_mask=4),
        },
        weapon_stats_by_item_id={
            9012: WeaponStats(item_id=9012, skill=27, delay=276, damage=250, hit=1),
            9013: WeaponStats(item_id=9013, skill=27, delay=192, damage=63, hit=1, subskill=3),
        },
    )

    throwing = classify_item(_gear_item(9012, "Fixture Throwing", "Ammo", "Weapon"), item_stats=item_stats)
    shuriken = classify_item(_gear_item(9013, "Fixture Shuriken", "Ammo", "Weapon", jobs=("NIN",)), item_stats=item_stats)

    assert throwing.weapon_family == "throwing"
    assert throwing.slot_eligible("Ammo")
    assert not throwing.slot_eligible("Range")
    assert not throwing.is_shuriken
    assert throwing.server_weapon_subskill == 0
    assert "Server item_weapon skill 27 identifies throwing family." in throwing.reasons

    assert shuriken.weapon_family == "throwing"
    assert shuriken.slot_eligible("Ammo")
    assert not shuriken.slot_eligible("Range")
    assert shuriken.is_shuriken
    assert shuriken.server_weapon_subskill == 3


def test_classifier_excludes_fishing_and_pet_consumable_ammo_from_combat() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9022: (ItemMod(5, "MP", 30),),
        },
        equipment_by_item_id={
            9020: _equipment(9020, "fixture_lure", level=1, jobs=4194303, slot_mask=8),
            9021: _equipment(9021, "fixture_pet_food", level=72, jobs=4194303, slot_mask=8),
            9022: _equipment(9022, "fixture_tathlum", level=70, jobs=4194303, slot_mask=8),
            9023: _equipment(9023, "fixture_pet_poultice", level=1, jobs=4194303, slot_mask=8),
        },
        weapon_stats_by_item_id={
            9020: WeaponStats(item_id=9020, skill=48, delay=240, damage=0, hit=1),
            9021: WeaponStats(item_id=9021, skill=0, delay=85, damage=900, hit=1),
            9022: WeaponStats(item_id=9022, skill=0, delay=999, damage=0, hit=1),
            9023: WeaponStats(item_id=9023, skill=255, delay=84, damage=6, hit=1),
        },
    )

    lure = classify_item(_gear_item(9020, "Fixture Lure", "Ammo", "Weapon"), item_stats=item_stats)
    pet_food = classify_item(_gear_item(9021, "Fixture Pet Food", "Ammo", "Weapon"), item_stats=item_stats)
    tathlum = classify_item(_gear_item(9022, "Fixture Tathlum", "Ammo", "Weapon"), item_stats=item_stats)
    pet_poultice = classify_item(_gear_item(9023, "Fixture Pet Poultice", "Ammo", "Weapon"), item_stats=item_stats)

    assert lure.excluded
    assert lure.exclusion_reason == "Fishing"
    assert lure.weapon_family == "fishing_ammo"
    assert pet_food.excluded
    assert pet_food.exclusion_reason == "Utility"
    assert pet_food.weapon_family == "utility_ammo"
    assert pet_poultice.excluded
    assert pet_poultice.exclusion_reason == "Utility"
    assert tathlum.weapon_family == "ammo"
    assert not tathlum.excluded


def test_classifier_does_not_apply_exact_name_or_utility_hints() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9001: _equipment(9001, "spike_necklace", level=75, jobs=16, slot_mask=512),
            9002: _equipment(9002, "warp_ring", level=75, jobs=16, slot_mask=24576),
        },
    )
    spike = classify_item(_accessory(9001, "Spike Necklace", "Neck"), item_stats=item_stats)
    warp = classify_item(_accessory(9002, "Warp Ring", "Ring1/Ring2"), item_stats=item_stats)

    assert "str" not in spike.roles
    assert "dex" not in spike.roles
    assert not warp.excluded
    assert warp.exclusion_reason == ""


def test_sam31_storetp_prefers_great_katana_when_penta_thrust_is_not_unlocked() -> None:
    sam_jobs_hex = str(1 << ((22 - 12) * 8))
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9302: (ItemMod(8, "STR", 1),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "fixture_great_katana", level=4, jobs=2048, slot_mask=1),
            9302: _equipment(9302, "fixture_polearm", level=4, jobs=2048, slot_mask=1),
        },
        weapon_stats_by_item_id={
            9301: WeaponStats(item_id=9301, skill=10, delay=420, damage=12, hit=1),
            9302: WeaponStats(item_id=9302, skill=8, delay=396, damage=13, hit=1),
        },
        skill_caps_by_level_rank={
            (31, 1): 96,
            (31, 5): 92,
            (51, 5): 150,
        },
        skill_ranks_by_skill_job={
            (10, "SAM"): 1,
            (8, "SAM"): 5,
        },
        weapon_skills_by_key={
            "tachi_goten": CatseyeWeaponSkill(
                weapon_skill_id=100,
                name="Tachi: Goten",
                key="tachi_goten",
                display_name="Tachi: Goten",
                set_name="WS_Tachi_Goten",
                accuracy_set_name="WSAcc_Tachi_Goten",
                jobs_hex=sam_jobs_hex,
                weapon_type=10,
                weapon_family="great_katana",
                skill_level=70,
                element_id=0,
                element_name="None",
                main_only=False,
                unlock_id=0,
            ),
            "penta_thrust": CatseyeWeaponSkill(
                weapon_skill_id=116,
                name="Penta Thrust",
                key="penta_thrust",
                display_name="Penta Thrust",
                set_name="WS_Penta_Thrust",
                accuracy_set_name="WSAcc_Penta_Thrust",
                jobs_hex=sam_jobs_hex,
                weapon_type=8,
                weapon_family="polearm",
                skill_level=150,
                element_id=0,
                element_name="None",
                main_only=False,
                unlock_id=0,
            ),
        },
    )
    eligibility = WeaponSkillEligibilityContext(
        job="SAM",
        character_level=31,
        skill_caps_by_level_rank=item_stats.skill_caps_by_level_rank,
        skill_ranks_by_skill_job=item_stats.skill_ranks_by_skill_job,
    )
    eligible_keys = {
        ws.key for ws in eligible_weaponskills_for_job(item_stats.weapon_skills_by_key, eligibility)
    }
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _gear_item(9301, "Fixture Great Katana", "Main", "Weapon", level=4, jobs=("SAM",)),
            _gear_item(9302, "Fixture Polearm", "Main", "Weapon", level=4, jobs=("SAM",)),
        )
    )

    style = _build_combat_style("StoreTP", classified, "SAM", 31, item_stats)

    assert "tachi_goten" in eligible_keys
    assert "penta_thrust" not in eligible_keys
    assert style["Main"].item.name == "Fixture Great Katana"
    assert "job skill rank 1 cap 96" in style["Main"].reason


def test_generic_weaponskill_fallback_does_not_swap_weapon_slots() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9401: (ItemMod(8, "STR", 20),),
        },
        equipment_by_item_id={
            9401: _equipment(9401, "ws_body", level=75, jobs=2048, slot_mask=32),
            9402: _equipment(9402, "fixture_great_katana", level=75, jobs=2048, slot_mask=3),
            9403: _equipment(9403, "fixture_grip", level=75, jobs=2048, slot_mask=2),
            9404: _equipment(9404, "fixture_throwing", level=75, jobs=2048, slot_mask=4),
            9405: _equipment(9405, "fixture_ammo", level=75, jobs=2048, slot_mask=8),
        },
        weapon_stats_by_item_id={
            9402: WeaponStats(item_id=9402, skill=10, delay=450, damage=80, hit=1),
            9403: WeaponStats(item_id=9403, skill=0, delay=0, damage=0, hit=1),
            9404: WeaponStats(item_id=9404, skill=27, delay=240, damage=60, hit=1),
            9405: WeaponStats(item_id=9405, skill=0, delay=240, damage=50, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9401, "WS Body", "Body", jobs=("SAM",)),
            _gear_item(9402, "Fixture Great Katana", "Main/Sub", "Weapon", jobs=("SAM",)),
            _gear_item(9403, "Fixture Grip", "Sub", "Weapon", jobs=("SAM",)),
            _gear_item(9404, "Fixture Throwing", "Range", "Weapon", jobs=("SAM",)),
            _gear_item(9405, "Fixture Ammo", "Ammo", "Weapon", jobs=("SAM",)),
        )
    )

    style = _build_combat_style("Weaponskill", classified, "SAM", 75, item_stats)

    assert {"Main", "Sub", "Range", "Ammo"}.isdisjoint(style)
    assert style["Body"].item.name == "WS Body"


def test_cor_defaults_to_roll_when_ranged_default_has_no_range_weapon() -> None:
    contract = build_job_contract("COR", character_level=75)
    selected = {
        "RangedDamage": {"Main": object(), "Ammo": object()},
        "Roll": {"Main": object(), "Ammo": object()},
    }

    assert _effective_default_playstyle(contract, selected) == "Roll"


def test_rdm_enspell_resolver_keeps_data_backed_target_weapons() -> None:
    weapons = (
        _weapon(17754, "Sylphid Epee", level=72),
        _weapon(17710, "Justice Sword", level=73),
        _weapon(18904, "Somnia Melodiam"),
        _weapon(20720, "Egeking"),
        _weapon(18852, "Octave Club", level=63),
    )
    item_stats = _rdm_weapon_stats()
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in weapons
    )

    style = _build_combat_style(
        "Enspell",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Main"].item.id == 18904
    assert style["Main"].item.name == "Somnia Melodiam"
    assert style["Main"].classification.weapon_family == "sword"
    assert style["Sub"].item.id in {20720, 18852}
    assert style["Sub"].classification.weapon_family in {"sword", "club"}


def test_rdm_enspell_prefers_catseye_octave_club_offhand() -> None:
    weapons = (
        _weapon(18904, "Somnia Melodiam"),
        _weapon(20720, "Egeking"),
        _weapon(18852, "Octave Club", level=63),
    )
    item_stats = _rdm_weapon_stats()
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in weapons
    )

    style = _build_combat_style(
        "Enspell",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Sub"].item.id == 18852
    assert style["Sub"].item.name == "Octave Club"


def test_thf_melt_can_use_catseye_octave_club_offhand() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        equipment_by_item_id={
            18852: _equipment(18852, "octave_club", level=63, jobs=32767, slot_mask=3),
            9001: _equipment(9001, "thf_dagger", level=75, jobs=32, slot_mask=3),
        },
        mods_by_item_id={},
        weapon_stats_by_item_id={
            18852: WeaponStats(item_id=18852, skill=11, delay=264, damage=11, hit=1),
            9001: WeaponStats(item_id=9001, skill=2, delay=200, damage=40, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _weapon(18852, "Octave Club", level=63),
            _weapon(9001, "THF Dagger"),
        )
    )

    style = _build_combat_style(
        "Melt",
        classified,
        "THF",
        75,
        item_stats,
    )

    assert style["Main"].item.id == 9001
    assert style["Sub"].item.id == 18852


def test_weapon_score_uses_catseye_max_swings_mod_when_server_hit_is_one() -> None:
    item_stats = _weapon_policy_stats(
        {
            9001: (11, 200, 40),
            9002: (11, 264, 15),
        },
        mods_by_item_id={
            9002: (ItemMod(978, "MAX_SWINGS", 4),),
        },
    )
    normal_club = _weapon(9001, "Normal Club")
    catseye_oa_club = _weapon(9002, "Moblin Mallet")
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (normal_club, catseye_oa_club)
    )

    style = _build_combat_style(
        "Damage",
        classified,
        "RDM",
        75,
        item_stats,
    )
    evidence = builder_module._score_evidence(
        "Damage",
        "Main",
        catseye_oa_club,
        classify_item(catseye_oa_club, item_stats=item_stats),
        item_stats,
    )

    assert style["Main"].item.id == 9002
    assert "Catseye effective hits 4" in evidence


def test_thf_dagger_style_keeps_dagger_offhand_over_octave_club() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        equipment_by_item_id={
            18852: _equipment(18852, "octave_club", level=63, jobs=32767, slot_mask=3),
            9001: _equipment(9001, "thf_dagger", level=75, jobs=32, slot_mask=3),
            9002: _equipment(9002, "thf_offhand_dagger", level=75, jobs=32, slot_mask=3),
        },
        mods_by_item_id={},
        weapon_stats_by_item_id={
            18852: WeaponStats(item_id=18852, skill=11, delay=264, damage=11, hit=1),
            9001: WeaponStats(item_id=9001, skill=2, delay=200, damage=40, hit=1),
            9002: WeaponStats(item_id=9002, skill=2, delay=190, damage=35, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _weapon(18852, "Octave Club", level=63),
            _weapon(9001, "THF Dagger"),
            _weapon(9002, "THF Offhand Dagger"),
        )
    )

    style = _build_combat_style(
        "Dagger",
        classified,
        "THF",
        75,
        item_stats,
    )

    assert style["Sub"].item.id == 9002
    assert style["Sub"].classification.weapon_family == "dagger"


def test_rdm_enspell_nin_resolver_does_not_treat_generic_throwing_as_shuriken() -> None:
    base_stats = _rdm_weapon_stats()
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            **base_stats.mods_by_item_id,
            18136: (ItemMod(5, "MP", 3), ItemMod(12, "INT", 1)),
        },
        equipment_by_item_id={
            **base_stats.equipment_by_item_id,
            18136: _equipment(18136, "morion_tathlum", level=25, jobs=4194303, slot_mask=8, removal_slot_mask=4),
            18164: _equipment(18164, "antarctic_wind", level=72, jobs=4194303, slot_mask=8, removal_slot_mask=4),
            18244: _equipment(18244, "virtue_stone", level=73, jobs=4194303, slot_mask=8, removal_slot_mask=4),
        },
        weapon_stats_by_item_id={
            **base_stats.weapon_stats_by_item_id,
            18136: WeaponStats(item_id=18136, skill=0, delay=999, damage=0, hit=1),
            18164: WeaponStats(item_id=18164, skill=27, delay=276, damage=250, hit=1),
            18244: WeaponStats(item_id=18244, skill=0, delay=4, damage=1, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _weapon(18904, "Somnia Melodiam"),
            _weapon(20720, "Egeking"),
            _gear_item(18136, "Morion Tathlum", "Ammo", "Weapon"),
            _gear_item(18164, "Antarctic Wind", "Ammo", "Weapon"),
            _gear_item(18244, "Virtue Stone", "Ammo", "Weapon"),
        )
    )

    style = _build_combat_style("Enspell", classified, "RDM", 75, item_stats)

    assert "Range" not in style
    assert style["Ammo"].item.name == "Morion Tathlum"
    assert style["Ammo"].classification.weapon_family == "ammo"


def test_nin_damage_resolver_uses_real_shuriken_for_daken_ammo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9001: _equipment(9001, "fixture_katana", level=75, jobs=4096, slot_mask=3),
            9012: _equipment(9012, "fixture_throwing", level=72, jobs=4194303, slot_mask=8, removal_slot_mask=4),
            9013: _equipment(9013, "fixture_shuriken", level=48, jobs=4096, slot_mask=8, removal_slot_mask=4),
        },
        weapon_stats_by_item_id={
            9001: WeaponStats(item_id=9001, skill=9, delay=227, damage=39, hit=1),
            9012: WeaponStats(item_id=9012, skill=27, delay=276, damage=250, hit=1),
            9013: WeaponStats(item_id=9013, skill=27, delay=192, damage=63, hit=1, subskill=3),
        },
        skill_caps_by_level_rank={(75, 4): 269},
        skill_ranks_by_skill_job={(9, "NIN"): 4, (27, "NIN"): 4},
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _gear_item(9001, "Fixture Katana", "Main/Sub", "Weapon", jobs=("NIN",)),
            _gear_item(9012, "Fixture Throwing", "Ammo", "Weapon", jobs=("NIN",)),
            _gear_item(9013, "Fixture Shuriken", "Ammo", "Weapon", jobs=("NIN",)),
        )
    )

    style = _build_combat_style("Damage", classified, "NIN", 75, item_stats)

    assert style["Ammo"].item.name == "Fixture Shuriken"
    assert style["Ammo"].classification.is_shuriken
    assert "Range" not in style


def test_rdm_magic_accuracy_keeps_stat_ammo_over_throwing_range_weapon() -> None:
    base_stats = _rdm_weapon_stats()
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            **base_stats.mods_by_item_id,
            18136: (ItemMod(5, "MP", 3), ItemMod(12, "INT", 1)),
        },
        equipment_by_item_id={
            **base_stats.equipment_by_item_id,
            18136: _equipment(18136, "morion_tathlum", level=25, jobs=4194303, slot_mask=8, removal_slot_mask=4),
            18164: _equipment(18164, "antarctic_wind", level=72, jobs=4194303, slot_mask=8, removal_slot_mask=4),
        },
        weapon_stats_by_item_id={
            **base_stats.weapon_stats_by_item_id,
            18136: WeaponStats(item_id=18136, skill=0, delay=999, damage=0, hit=1),
            18164: WeaponStats(item_id=18164, skill=27, delay=276, damage=250, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _weapon(20720, "Egeking"),
            _shield(12296, "Genbu's Shield", level=74),
            _gear_item(18136, "Morion Tathlum", "Ammo", "Weapon"),
            _gear_item(18164, "Antarctic Wind", "Ammo", "Weapon"),
        )
    )

    style = _build_combat_style("MagicAccuracy", classified, "RDM", 75, item_stats)

    assert "Range" not in style
    assert style["Ammo"].item.name == "Morion Tathlum"
    assert style["Ammo"].classification.weapon_family == "ammo"


def test_style_without_dual_wield_hint_does_not_pick_offhand_weapon() -> None:
    items = (
        _weapon(20720, "Egeking"),
        _weapon(20629, "Atoyac"),
        _shield(12296, "Genbu's Shield", level=74),
    )
    item_stats = _rdm_weapon_stats()
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in items
    )

    style = _build_combat_style(
        "MagicAccuracy",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Sub"].item.name == "Genbu's Shield"
    assert style["Sub"].classification.weapon_family == "shield"


def test_war_offensive_styles_do_not_pick_swords_over_viable_axes() -> None:
    item_stats = _weapon_policy_stats(
        {
            8101: (3, 224, 70),
            8102: (6, 504, 95),
            8103: (5, 288, 45),
            8104: (2, 200, 90),
        }
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8101, "High DPS Sword", "Main/Sub", "Weapon", jobs=("WAR",)),
            _gear_item(8102, "Byakko's Axe", "Main/Sub", "Weapon", jobs=("WAR",)),
            _gear_item(8103, "Martial Axe", "Main/Sub", "Weapon", jobs=("WAR",)),
            _gear_item(8104, "Fast Dagger", "Main/Sub", "Weapon", jobs=("WAR",)),
        ),
    )

    for style_name in ("Damage", "Accuracy", "WeaponSkill"):
        style = _build_combat_style(style_name, classified, "WAR", 75, item_stats)

        assert style["Main"].classification.weapon_family in {"great_axe", "axe"}
        assert style["Main"].item.name != "High DPS Sword"
        assert "Sub" not in style or style["Sub"].classification.weapon_family == "axe"


def test_standard_job_styles_define_weapon_preferences_for_each_weapon_slot() -> None:
    missing: list[str] = []
    for job in SUPPORTED_JOBS:
        for style_name in STANDARD_JOB_STYLES.get(job, tuple()):
            policy = _weapon_family_policy_for_style(job, style_name)
            if not policy:
                missing.append(f"{job}.{style_name}")
                continue
            for slot in ("Main", "Sub", "Range", "Ammo"):
                if slot not in policy:
                    missing.append(f"{job}.{style_name}.{slot}")
            if job == "BRD" and style_name in {"Song", "FastCast", "MagicAccuracy", "IdleRefresh"}:
                if policy.get("Range") != ("instrument",):
                    missing.append(f"{job}.{style_name}.Range")

    assert missing == []


def test_rejected_weapon_family_reason_uses_default_weapon_preferences() -> None:
    assert {"great_axe", "axe", "throwing", "ammo"} <= _job_allowed_weapon_families("WAR")
    assert {"dagger", "sword", "gun", "ammo"} <= _job_allowed_weapon_families("COR")


def test_two_handed_job_styles_allow_grips_in_sub_slot() -> None:
    expected_grip_styles = {
        "WAR": ("Damage", "Accuracy", "WeaponSkill"),
        "DRK": ("Damage", "Accuracy", "WeaponSkill", "DrainAbsorb"),
        "SAM": ("StoreTP", "Accuracy", "WeaponSkill", "Evasion"),
        "DRG": ("Damage", "Accuracy", "WeaponSkill", "Jump"),
        "RUN": ("Tank", "MagicDefense", "Damage", "Enmity"),
    }

    missing = [
        f"{job}.{style_name}"
        for job, style_names in expected_grip_styles.items()
        for style_name in style_names
        if "grip" not in JOB_STYLE_WEAPON_FAMILIES[job][style_name].get("Sub", tuple())
    ]

    assert missing == []


def test_war_great_axe_styles_select_grip_for_two_handed_main_weapon() -> None:
    item_stats = _weapon_policy_stats(
        {
            20872: (6, 504, 93),
            19000: (0, 240, 1),
        },
        grip_ids={19000},
        mods_by_item_id={
            20872: (ItemMod(8, "STR", 3),),
            19000: (ItemMod(25, "ACC", 3),),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(20872, "Ixtab", "Main", "Weapon", jobs=("WAR",)),
            _gear_item(19000, "War Grip", "Sub", "Weapon", jobs=("WAR",)),
        ),
    )

    style = _build_combat_style("Damage", classified, "WAR", 75, item_stats)

    assert style["Main"].item.name == "Ixtab"
    assert style["Sub"].item.name == "War Grip"
    assert style["Sub"].classification.weapon_family == "grip"


def test_cor_ranged_styles_select_gun_and_ammo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            8801: (ItemMod(11, "AGI", 3),),
            8802: (ItemMod(26, "RACC", 6),),
            8803: (ItemMod(24, "RATT", 12),),
        },
        equipment_by_item_id={
            8801: _equipment(8801, "fixture_dagger", level=75, jobs=4194303, slot_mask=3),
            8802: _equipment(8802, "fixture_gun", level=75, jobs=4194303, slot_mask=4),
            8803: _equipment(8803, "fixture_bullet", level=75, jobs=4194303, slot_mask=8),
        },
        weapon_stats_by_item_id={
            8801: WeaponStats(item_id=8801, skill=2, delay=200, damage=45, hit=1),
            8802: WeaponStats(item_id=8802, skill=26, delay=480, damage=60, hit=1),
            8803: WeaponStats(item_id=8803, skill=26, delay=240, damage=80, hit=1),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8801, "Fixture Dagger", "Main/Sub", "Weapon", jobs=("COR",)),
            _gear_item(8802, "Fixture Gun", "Range", "Weapon", jobs=("COR",)),
            _gear_item(8803, "Fixture Bullet", "Ammo", "Weapon", jobs=("COR",)),
        ),
    )

    style = _build_combat_style("RangedDamage", classified, "COR", 75, item_stats)

    assert style["Main"].item.name == "Fixture Dagger"
    assert style["Range"].item.name == "Fixture Gun"
    assert style["Range"].classification.weapon_family == "gun"
    assert style["Ammo"].item.name == "Fixture Bullet"
    assert style["Ammo"].classification.weapon_family == "ammo"


def test_combat_sets_do_not_select_pet_consumables_as_ammo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            8811: (ItemMod(12, "INT", 4),),
        },
        equipment_by_item_id={
            8810: _equipment(8810, "fixture_pet_food", level=72, jobs=4194303, slot_mask=8),
            8811: _equipment(8811, "fixture_stat_ammo", level=70, jobs=4194303, slot_mask=8),
        },
        weapon_stats_by_item_id={
            8810: WeaponStats(item_id=8810, skill=0, delay=85, damage=900, hit=1),
            8811: WeaponStats(item_id=8811, skill=0, delay=999, damage=0, hit=1),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8810, "Fixture Pet Food", "Ammo", "Weapon", jobs=("BLM",)),
            _gear_item(8811, "Fixture Stat Ammo", "Ammo", "Weapon", jobs=("BLM",)),
        ),
    )

    style = _build_combat_style("Nuke", classified, "BLM", 75, item_stats)

    assert style["Ammo"].item.name == "Fixture Stat Ammo"
    assert style["Ammo"].classification.weapon_family == "ammo"


def test_automatic_styles_fall_back_to_job_weapon_preferences() -> None:
    item_stats = _weapon_policy_stats(
        {
            8701: (12, 356, 40),
            8702: (6, 504, 93),
        },
        mods_by_item_id={
            8701: (ItemMod(5, "MP", 50),),
            8702: (ItemMod(8, "STR", 3),),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8701, "Caster Staff", "Main", "Weapon", jobs=("WAR",)),
            _gear_item(8702, "War Great Axe", "Main", "Weapon", jobs=("WAR",)),
        ),
    )

    style = _build_combat_style("Cure", classified, "WAR", 75, item_stats)

    assert "Main" not in style or style["Main"].classification.weapon_family in {"great_axe", "axe"}


def test_war_offensive_styles_prefer_ixtab_over_byakkos_axe() -> None:
    item_stats = _weapon_policy_stats(
        {
            18198: (6, 504, 94),
            20872: (6, 504, 93),
        }
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(18198, "Byakko's Axe", "Main", "Weapon", jobs=("WAR",)),
            _gear_item(20872, "Ixtab", "Main", "Weapon", jobs=("WAR",)),
        ),
    )

    for style_name in ("Damage", "Accuracy", "WeaponSkill"):
        style = _build_combat_style(style_name, classified, "WAR", 75, item_stats)

        assert style["Main"].item.id == 20872
        assert style["Main"].item.name == "Ixtab"


def test_tp_bonus_contributes_to_weaponskill_weapon_selection() -> None:
    item_stats = _weapon_policy_stats(
        {
            8601: (5, 276, 46),
            8602: (5, 276, 46),
        },
        mods_by_item_id={
            8601: (ItemMod(345, "TP_BONUS", 1000),),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8601, "Martial Axe", "Main/Sub", "Weapon", jobs=("WAR",)),
            _gear_item(8602, "Plain Axe", "Main/Sub", "Weapon", jobs=("WAR",)),
        ),
    )

    style = _build_combat_style("WeaponSkill", classified, "WAR", 75, item_stats)

    assert style["Main"].item.name == "Martial Axe"
    assert style["Main"].score > _weapon_score(style["Main"].item, style["Main"].classification, item_stats, None)


def test_blood_pact_style_prioritizes_blood_pact_delay_reduction() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            8901: (ItemMod(5, "MP", 60),),
            8902: (ItemMod(5, "MP", 20), ItemMod(357, "BP_DELAY", 4)),
        },
        equipment_by_item_id={
            8901: _equipment(8901, "mp_body", level=75, jobs=16384, slot_mask=32),
            8902: _equipment(8902, "bp_delay_body", level=75, jobs=16384, slot_mask=32),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8901, "MP Body", "Body", "Armor", jobs=("SMN",)),
            _gear_item(8902, "BP Delay Body", "Body", "Armor", jobs=("SMN",)),
        ),
    )

    style = _build_combat_style("BloodPact", classified, "SMN", 75, item_stats)

    assert style["Body"].item.name == "BP Delay Body"


def test_drk_offensive_styles_use_two_handed_weapon_families_without_shield() -> None:
    item_stats = _weapon_policy_stats(
        {
            8201: (3, 224, 70),
            8202: (7, 528, 95),
            8203: (4, 444, 88),
            8204: (0, 240, 1),
        },
        shield_ids={8204},
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8201, "High DPS Sword", "Main/Sub", "Weapon", jobs=("DRK",)),
            _gear_item(8202, "Suzaku's Scythe", "Main/Sub", "Weapon", jobs=("DRK",)),
            _gear_item(8203, "Dark Great Sword", "Main/Sub", "Weapon", jobs=("DRK",)),
            _gear_item(8204, "Tower Shield", "Sub", "Armor", jobs=("DRK",)),
        ),
    )

    for style_name in ("Damage", "Accuracy", "WeaponSkill"):
        style = _build_combat_style(style_name, classified, "DRK", 75, item_stats)

        assert style["Main"].classification.weapon_family in {"scythe", "great_sword"}
        assert style["Main"].item.name != "High DPS Sword"
        assert "Sub" not in style


def test_bst_offensive_styles_prefer_axe_or_club_over_sword() -> None:
    item_stats = _weapon_policy_stats(
        {
            8301: (3, 224, 70),
            8302: (5, 288, 50),
            8303: (11, 264, 45),
        }
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8301, "High DPS Sword", "Main/Sub", "Weapon", jobs=("BST",)),
            _gear_item(8302, "Hunahpu", "Main/Sub", "Weapon", jobs=("BST",)),
            _gear_item(8303, "Pet Club", "Main/Sub", "Weapon", jobs=("BST",)),
        ),
    )

    for style_name in ("Damage", "Accuracy"):
        style = _build_combat_style(style_name, classified, "BST", 75, item_stats)

        assert style["Main"].classification.weapon_family in {"axe", "club"}
        assert style["Main"].item.name != "High DPS Sword"


def test_bst_pet_damage_does_not_use_shield_as_offensive_sub_weapon() -> None:
    item_stats = _weapon_policy_stats(
        {
            8311: (5, 288, 50),
            8312: (11, 264, 45),
            8313: (0, 240, 1),
        },
        shield_ids={8313},
        pet_mods_by_item_id={
            8311: (ItemMod(100, "PET_ATK", 5),),
            8312: (ItemMod(101, "PET_ACC", 1),),
            8313: (ItemMod(102, "PET_ATK", 50),),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8311, "Pet Axe", "Main/Sub", "Weapon", jobs=("BST",)),
            _gear_item(8312, "Pet Club", "Main/Sub", "Weapon", jobs=("BST",)),
            _gear_item(8313, "Pet Shield", "Sub", "Armor", jobs=("BST",)),
        ),
    )

    style = _build_combat_style("PetDamage", classified, "BST", 75, item_stats)

    assert style["Main"].classification.weapon_family in {"axe", "club"}
    assert "Sub" not in style or style["Sub"].classification.weapon_family in {"axe", "club"}


def test_nin_offensive_styles_prefer_katana_or_dagger_over_sword() -> None:
    item_stats = _weapon_policy_stats(
        {
            8401: (3, 224, 70),
            8402: (3, 236, 65),
            8403: (9, 232, 40),
            8404: (2, 200, 35),
        }
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8401, "High DPS Sword", "Main/Sub", "Weapon", jobs=("NIN",)),
            _gear_item(8402, "Second Sword", "Main/Sub", "Weapon", jobs=("NIN",)),
            _gear_item(8403, "Yoto +1", "Main/Sub", "Weapon", jobs=("NIN",)),
            _gear_item(8404, "Garuda's Dagger", "Main/Sub", "Weapon", jobs=("NIN",)),
        ),
    )

    for style_name in ("Damage", "Accuracy"):
        style = _build_combat_style(style_name, classified, "NIN", 75, item_stats)

        assert style["Main"].classification.weapon_family in {"katana", "dagger"}
        assert style["Sub"].classification.weapon_family in {"katana", "dagger"}


def test_equal_score_tiebreak_uses_server_level_not_raw_export_level() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            8501: (ItemMod(25, "ACC", 10),),
            8502: (ItemMod(25, "ACC", 10),),
        },
        equipment_by_item_id={
            8501: _equipment(8501, "raw_high_server_low", level=50, jobs=4194303, slot_mask=16),
            8502: _equipment(8502, "raw_low_server_high", level=75, jobs=4194303, slot_mask=16),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _gear_item(8501, "Raw High Server Low", "Head", "Armor", level=75, jobs=("WAR",)),
            _gear_item(8502, "Raw Low Server High", "Head", "Armor", level=10, jobs=("WAR",)),
        ),
    )

    style = _build_combat_style("Damage", classified, "WAR", 75, item_stats)

    assert style["Head"].item.id == 8502


def test_weapon_score_fallback_uses_server_level_not_raw_export_level() -> None:
    item = _gear_item(8510, "Server Level Axe", "Main/Sub", "Weapon", level=10, jobs=("WAR",))
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            8510: _equipment(8510, "server_level_axe", level=75, jobs=4194303, slot_mask=3),
        },
    )
    classification = classify_item(item, item_stats=item_stats)

    assert _weapon_score(item, classification, None, None) == 7500
    assert _weapon_score(item, classification, item_stats, None) == 7500


def test_rdm_elemental_styles_prefer_chatoyant_staff_bonus_mods() -> None:
    elemental_staff_mods = (
        ItemMod(347, "FIRE_STAFF_BONUS", 3),
        ItemMod(348, "ICE_STAFF_BONUS", 3),
        ItemMod(349, "WIND_STAFF_BONUS", 3),
        ItemMod(350, "EARTH_STAFF_BONUS", 3),
        ItemMod(351, "THUNDER_STAFF_BONUS", 3),
        ItemMod(352, "WATER_STAFF_BONUS", 3),
        ItemMod(353, "LIGHT_STAFF_BONUS", 3),
        ItemMod(354, "DARK_STAFF_BONUS", 3),
        ItemMod(553, "FIRE_AFFINITY_PERP", 3),
        ItemMod(554, "ICE_AFFINITY_PERP", 3),
        ItemMod(555, "WIND_AFFINITY_PERP", 3),
        ItemMod(556, "EARTH_AFFINITY_PERP", 3),
        ItemMod(557, "THUNDER_AFFINITY_PERP", 3),
        ItemMod(558, "WATER_AFFINITY_PERP", 3),
        ItemMod(559, "LIGHT_AFFINITY_PERP", 3),
        ItemMod(560, "DARK_AFFINITY_PERP", 3),
    )
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            18633: elemental_staff_mods,
            9104: (
                ItemMod(28, "MATT", 20),
                ItemMod(311, "MAGIC_DAMAGE", 40),
                ItemMod(12, "INT", 15),
            ),
        },
        equipment_by_item_id={
            18633: _equipment(18633, "chatoyant_staff", level=51, jobs=4194303, slot_mask=1),
            9104: _equipment(9104, "tamaxchi", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            18633: WeaponStats(item_id=18633, skill=12, delay=356, damage=35, hit=1),
            9104: WeaponStats(item_id=9104, skill=11, delay=216, damage=88, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _gear_item(18633, "Chatoyant Staff", "Main", "Weapon", level=51),
            _gear_item(9104, "Tamaxchi", "Main/Sub", "Weapon"),
        )
    )

    for style_name in (
        "Nuke",
        "Elemental",
        "Elemental_Fire",
        "Elemental_Ice",
        "Elemental_Wind",
        "Elemental_Earth",
        "Elemental_Thunder",
        "Elemental_Lightning",
        "Elemental_Water",
        "Elemental_Light",
        "Elemental_Dark",
        "Weather_Fire",
        "Day_Fire",
        "Weather_Lightning",
        "Day_Lightning",
    ):
        style = _build_combat_style(
            style_name,
            classified,
            "RDM",
            75,
            item_stats,
        )

        assert style["Main"].item.id == 18633
        assert style["Main"].item.name == "Chatoyant Staff"


def test_cure_style_prefers_chatoyant_light_staff_bonus_over_tamaxchi_potency() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            18633: (
                ItemMod(13, "MND", 5),
                ItemMod(353, "LIGHT_STAFF_BONUS", 3),
                ItemMod(374, "CURE_POTENCY", 10),
                ItemMod(566, "IRIDESCENCE", 2),
            ),
            21125: (
                ItemMod(13, "MND", 5),
                ItemMod(374, "CURE_POTENCY", 22),
            ),
        },
        equipment_by_item_id={
            18633: _equipment(18633, "chatoyant_staff", level=51, jobs=4194303, slot_mask=1),
            21125: _equipment(21125, "tamaxchi", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            18633: WeaponStats(item_id=18633, skill=12, delay=356, damage=35, hit=1),
            21125: WeaponStats(item_id=21125, skill=11, delay=216, damage=88, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _gear_item(18633, "Chatoyant Staff", "Main", "Weapon", level=51),
            _gear_item(21125, "Tamaxchi", "Main/Sub", "Weapon"),
        )
    )

    style = _build_combat_style(
        "Cure",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Main"].item.id == 18633
    assert style["Main"].item.name == "Chatoyant Staff"


def test_slot_with_no_weighted_server_data_is_left_empty() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9003: _equipment(9003, "empty_neck", level=75, jobs=16, slot_mask=512),
        },
    )
    classified = (
        (_accessory(9003, "Empty Necklace", "Neck"), classify_item(_accessory(9003, "Empty Necklace", "Neck"), item_stats=item_stats)),
    )

    style = _build_combat_style(
        "MagicAccuracy",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert "Neck" not in style


def test_idle_jewelry_does_not_use_mp_or_hmp_only_accessories() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9050: (ItemMod(5, "MP", 15),),
            9051: (ItemMod(71, "MPHEAL", 2),),
            9052: (ItemMod(369, "REFRESH", 1),),
            9053: (ItemMod(161, "DMGPHYS", -3),),
        },
        equipment_by_item_id={
            9050: _equipment(9050, "mana_ring", level=40, jobs=16, slot_mask=8192),
            9051: _equipment(9051, "relaxing_earring", level=40, jobs=16, slot_mask=2048),
            9052: _equipment(9052, "refresh_earring", level=40, jobs=16, slot_mask=4096),
            9053: _equipment(9053, "pdt_ring", level=40, jobs=16, slot_mask=16384),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _accessory(9050, "Mana Ring", "Ring1"),
            _accessory(9051, "Relaxing Earring", "Ear1"),
            _accessory(9052, "Refresh Earring", "Ear2"),
            _accessory(9053, "PDT Ring", "Ring2"),
        ),
    )

    style = _build_combat_style("Idle", classified, "RDM", 75, item_stats)

    selected_names = {selected.item.name for selected in style.values()}
    assert "Mana Ring" not in selected_names
    assert "Relaxing Earring" not in selected_names
    assert style["Ear2"].item.name == "Refresh Earring"
    assert style["Ring2"].item.name == "PDT Ring"


def test_casting_jewelry_does_not_use_mp_only_ring_as_filler() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9060: (ItemMod(5, "MP", 15),),
            9061: (ItemMod(170, "FASTCAST", 2),),
        },
        equipment_by_item_id={
            9060: _equipment(9060, "mana_ring", level=40, jobs=16, slot_mask=8192),
            9061: _equipment(9061, "fastcast_earring", level=40, jobs=16, slot_mask=2048),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _accessory(9060, "Mana Ring", "Ring1"),
            _accessory(9061, "Fastcast Earring", "Ear1"),
        ),
    )

    style = _build_combat_style("FastCast", classified, "RDM", 75, item_stats)

    selected_names = {selected.item.name for selected in style.values()}
    assert "Mana Ring" not in selected_names
    assert style["Ear1"].item.name == "Fastcast Earring"


def test_resting_jewelry_keeps_hmp_earring_but_not_mp_only_ring() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9070: (ItemMod(5, "MP", 15),),
            9071: (ItemMod(71, "MPHEAL", 2),),
        },
        equipment_by_item_id={
            9070: _equipment(9070, "mana_ring", level=40, jobs=16, slot_mask=8192),
            9071: _equipment(9071, "relaxing_earring", level=40, jobs=16, slot_mask=2048),
        },
    )
    classified = _classified_items(
        item_stats,
        (
            _accessory(9070, "Mana Ring", "Ring1"),
            _accessory(9071, "Relaxing Earring", "Ear1"),
        ),
    )

    style = _build_combat_style("Resting", classified, "RDM", 75, item_stats)

    selected_names = {selected.item.name for selected in style.values()}
    assert "Mana Ring" not in selected_names
    assert style["Ear1"].item.name == "Relaxing Earring"


def test_resting_style_uses_real_hmp_mods() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9100: (ItemMod(71, "MPHEAL", 10),),
            9101: (ItemMod(28, "MATT", 30),),
        },
        equipment_by_item_id={
            9100: _equipment(9100, "resting_torque", level=75, jobs=16, slot_mask=512),
            9101: _equipment(9101, "nuke_torque", level=75, jobs=16, slot_mask=512),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _accessory(9100, "Resting Torque", "Neck"),
            _accessory(9101, "Nuke Torque", "Neck"),
        )
    )

    style = _build_combat_style(
        "Resting",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Neck"].item.id == 9100


def test_job_generation_includes_calculated_resting_semantic_set() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9100: (ItemMod(71, "MPHEAL", 10),),
        },
        equipment_by_item_id={
            9100: _equipment(9100, "resting_torque", level=75, jobs=16, slot_mask=512),
        },
    )
    classified = (
        (
            _accessory(9100, "Resting Torque", "Neck"),
            classify_item(_accessory(9100, "Resting Torque", "Neck"), item_stats=item_stats),
        ),
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Resting"]["Neck"].item.id == 9100


def test_sam_job_generation_includes_meditate_and_third_eye_sets() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            15113: (ItemMod(94, "MEDITATE_DURATION", 4),),
            15128: (ItemMod(508, "THIRD_EYE_COUNTER_RATE", 15),),
            9100: (ItemMod(25, "ACC", 20),),
            9101: (ItemMod(73, "STORETP", 10),),
            9102: (ItemMod(25, "ACC", 15),),
        },
        equipment_by_item_id={
            15113: _equipment(15113, "saotome_kote", level=73, jobs=2048, slot_mask=64),
            15128: _equipment(15128, "saotome_haidate", level=72, jobs=2048, slot_mask=128),
            9100: _equipment(9100, "accuracy_hands", level=75, jobs=2048, slot_mask=64),
            9101: _equipment(9101, "fixture_great_katana", level=75, jobs=2048, slot_mask=3),
            9102: _equipment(9102, "fixture_sword", level=75, jobs=2048, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9101: WeaponStats(item_id=9101, skill=10, delay=450, damage=80, hit=1),
            9102: WeaponStats(item_id=9102, skill=3, delay=240, damage=40, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(15113, "Saotome Kote", "Hands", level=73, jobs=("SAM",)),
            _armor(15128, "Saotome Haidate", "Legs", level=72, jobs=("SAM",)),
            _armor(9100, "Accuracy Hands", "Hands", jobs=("SAM",)),
            _gear_item(9101, "Fixture Great Katana", "Main/Sub", "Weapon", jobs=("SAM",)),
            _gear_item(9102, "Fixture Sword", "Main/Sub", "Weapon", jobs=("SAM",)),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("SAM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Meditate"]["Hands"].item.id == 15113
    assert sets["ThirdEye"]["Legs"].item.id == 15128
    assert "Sub" not in sets["Meditate"]
    assert "Sub" not in sets["ThirdEye"]


def test_sam_omits_empty_job_action_sets_to_preserve_jobability_fallback() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9101: (ItemMod(73, "STORETP", 5),),
            9102: (ItemMod(23, "ATT", 5),),
        },
        equipment_by_item_id={
            9101: _equipment(9101, "fixture_great_katana", level=75, jobs=2048, slot_mask=3),
            9102: _equipment(9102, "fixture_grip", level=75, jobs=2048, slot_mask=2),
        },
        weapon_stats_by_item_id={
            9101: WeaponStats(item_id=9101, skill=10, delay=450, damage=80, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _gear_item(9101, "Fixture Great Katana", "Main/Sub", "Weapon", jobs=("SAM",)),
            _gear_item(9102, "Fixture Grip", "Sub", "Weapon", jobs=("SAM",)),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("SAM", character_level=75),
        item_stats,
        None,
    )

    assert sets["JobAbility"]["Main"].item.id == 9101
    assert "Meditate" not in sets
    assert "ThirdEye" not in sets


def test_subjob_dnc_generation_includes_action_sets_for_non_dnc_main() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9300: (ItemMod(491, "WALTZ_POTENCY", 5),),
            9301: (ItemMod(25, "ACC", 20),),
            9302: (ItemMod(23, "ATT", 20),),
            9303: (ItemMod(11, "AGI", 20), ItemMod(25, "ACC", 25), ItemMod(23, "ATT", 25)),
            9304: (ItemMod(23, "ATT", 30),),
        },
        equipment_by_item_id={
            9300: _equipment(9300, "waltz_feet", level=75, jobs=16, slot_mask=256),
            9301: _equipment(9301, "step_hands", level=75, jobs=16, slot_mask=64),
            9302: _equipment(9302, "samba_waist", level=75, jobs=16, slot_mask=1024),
            9303: _equipment(9303, "action_sword", level=75, jobs=16, slot_mask=3),
            9304: _equipment(9304, "action_ammo", level=75, jobs=16, slot_mask=8),
        },
        weapon_stats_by_item_id={
            9303: WeaponStats(item_id=9303, skill=3, delay=224, damage=40, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9300, "Waltz Feet", "Feet"),
            _armor(9301, "Step Hands", "Hands"),
            _armor(9302, "Samba Waist", "Waist"),
            _gear_item(9303, "Action Sword", "Main/Sub", "Weapon"),
            _gear_item(9304, "Action Ammo", "Ammo", "Weapon"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
        subjob_profiles={"DNC": _subjob_profile("DNC", ("waltz", "steps", "samba"))},
    )

    assert sets["Waltz"]["Feet"].item.id == 9300
    assert sets["Steps"]["Hands"].item.id == 9301
    assert sets["Samba"]["Waist"].item.id == 9302
    for set_name in ("Waltz", "Steps", "Samba"):
        assert "Main" not in sets[set_name]
        assert "Sub" not in sets[set_name]
        assert "Ammo" not in sets[set_name]


def test_subjob_sam_generation_includes_action_sets_for_non_sam_main() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            15113: (ItemMod(94, "MEDITATE_DURATION", 4),),
            15128: (ItemMod(508, "THIRD_EYE_COUNTER_RATE", 15),),
            9300: (ItemMod(73, "STORETP", 15), ItemMod(68, "EVA", 20)),
            9301: (ItemMod(73, "STORETP", 20),),
        },
        equipment_by_item_id={
            15113: _equipment(15113, "saotome_kote", level=73, jobs=32, slot_mask=64),
            15128: _equipment(15128, "saotome_haidate", level=72, jobs=32, slot_mask=128),
            9300: _equipment(9300, "action_dagger", level=75, jobs=32, slot_mask=3),
            9301: _equipment(9301, "action_ammo", level=75, jobs=32, slot_mask=8),
        },
        weapon_stats_by_item_id={
            9300: WeaponStats(item_id=9300, skill=2, delay=190, damage=30, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(15113, "Saotome Kote", "Hands", level=73, jobs=("THF",)),
            _armor(15128, "Saotome Haidate", "Legs", level=72, jobs=("THF",)),
            _gear_item(9300, "Action Dagger", "Main/Sub", "Weapon", jobs=("THF",)),
            _gear_item(9301, "Action Ammo", "Ammo", "Weapon", jobs=("THF",)),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("THF", character_level=75),
        item_stats,
        None,
        subjob_profiles={"SAM": _subjob_profile("SAM", ("meditate", "third_eye"))},
    )

    assert sets["Meditate"]["Hands"].item.id == 15113
    assert sets["ThirdEye"]["Legs"].item.id == 15128
    for set_name in ("Meditate", "ThirdEye"):
        assert "Main" not in sets[set_name]
        assert "Sub" not in sets[set_name]
        assert "Ammo" not in sets[set_name]


def test_sam_idle_prefers_survival_body_over_mp_only_body() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            12562: (ItemMod(5, "MP", 30),),
            14511: (
                ItemMod(1, "DEF", 51),
                ItemMod(2, "HP", 34),
                ItemMod(10, "VIT", 7),
            ),
        },
        equipment_by_item_id={
            12562: _equipment(12562, "kirins_osode", level=75, jobs=2048, slot_mask=32),
            14511: _equipment(14511, "saotome_domaru_+1", level=75, jobs=2048, slot_mask=32),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(12562, "Kirin's Osode", "Body", jobs=("SAM",)),
            _armor(14511, "Sao. Domaru +1", "Body", jobs=("SAM",)),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("SAM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Idle"]["Body"].item.id == 14511
    assert sets["Aftercast"]["Body"].item.id == 14511


def test_job_generation_attempts_every_semantic_set_and_populates_common_ones() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9400: (ItemMod(369, "REFRESH", 1),),
            9401: (ItemMod(170, "FASTCAST", 5),),
            9402: (ItemMod(30, "MACC", 8),),
            9403: (ItemMod(28, "MATT", 10),),
            9404: (ItemMod(374, "CURE_POTENCY", 8),),
            9405: (ItemMod(384, "HASTE_GEAR", 80), ItemMod(25, "ACC", 10)),
            9406: (ItemMod(161, "DMGPHYS", -5),),
            9407: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9400: _equipment(9400, "refresh_body", level=75, jobs=16, slot_mask=32),
            9401: _equipment(9401, "fastcast_head", level=75, jobs=16, slot_mask=16),
            9402: _equipment(9402, "macc_neck", level=75, jobs=16, slot_mask=512),
            9403: _equipment(9403, "mab_waist", level=75, jobs=16, slot_mask=1024),
            9404: _equipment(9404, "cure_hands", level=75, jobs=16, slot_mask=64),
            9405: _equipment(9405, "haste_legs", level=75, jobs=16, slot_mask=128),
            9406: _equipment(9406, "pdt_ring", level=75, jobs=16, slot_mask=8192),
            9407: _equipment(9407, "strider_boots", level=20, jobs=16, slot_mask=256),
            9408: _equipment(9408, "training_sword", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9408: WeaponStats(item_id=9408, skill=3, delay=240, damage=50, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9400, "Refresh Body", "Body"),
            _armor(9401, "Fastcast Head", "Head"),
            _accessory(9402, "Macc Neck", "Neck"),
            _accessory(9403, "MAB Waist", "Waist"),
            _armor(9404, "Cure Hands", "Hands"),
            _armor(9405, "Haste Legs", "Legs"),
            _accessory(9406, "PDT Ring", "Ring1"),
            _armor(9407, "Strider Boots", "Feet"),
            _weapon(9408, "Training Sword"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    restricted_noise = {
        "BlueMagic",
        "PhysicalBlueMagic",
        "MagicalBlueMagic",
        "PetReady",
        "PetMagic",
        "QuickDraw",
        "Roll",
        "Snapshot",
        "Ranged",
        "RangedMidshot",
        "RangedPreshot",
    }
    missing = [set_name for set_name in _automatic_semantic_styles_for_job("RDM") if set_name not in sets]
    assert missing == []
    assert not (set(sets) & restricted_noise)
    assert sets["Idle"]["Body"].item.id == 9400
    assert sets["Aftercast"]["Body"].item.id == 9400
    assert sets["Precast"]["Head"].item.id == 9401
    assert sets["FastCast"]["Head"].item.id == 9401
    assert sets["Midcast"]["Neck"].item.id == 9402
    assert sets["Elemental_Fire"]["Waist"].item.id == 9403
    assert sets["Weather_Fire"]["Waist"].item.id == 9403
    assert sets["Day_Fire"]["Waist"].item.id == 9403
    assert sets["Cure"]["Hands"].item.id == 9404
    assert sets["TP"]["Legs"].item.id == 9405
    assert sets["PDT"]["Ring1"].item.id == 9406
    assert sets["Movement"]["Feet"].item.id == 9407


def test_automatic_semantic_styles_are_limited_to_job_relevant_surfaces() -> None:
    blm_styles = set(_automatic_semantic_styles_for_job("BLM"))
    blu_styles = set(_automatic_semantic_styles_for_job("BLU"))
    cor_styles = set(_automatic_semantic_styles_for_job("COR"))
    sam_styles = set(_automatic_semantic_styles_for_job("SAM"))

    assert "BlueMagic" not in blm_styles
    assert "PhysicalBlueMagic" not in blm_styles
    assert "MagicalBlueMagic" not in blm_styles
    assert "PetMagic" not in blm_styles
    assert "QuickDraw" not in blm_styles
    assert "Roll" not in blm_styles
    assert "Snapshot" not in blm_styles

    assert {"BlueMagic", "PhysicalBlueMagic", "MagicalBlueMagic"} <= blu_styles
    assert {"QuickDraw", "Roll", "Snapshot", "RangedMidshot"} <= cor_styles
    assert {"Meditate", "ThirdEye"} <= sam_styles
    assert "PetMagic" not in sam_styles


def test_movement_style_uses_real_move_speed_mods() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9200: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
            9201: (ItemMod(68, "EVA", 30),),
        },
        equipment_by_item_id={
            9200: _equipment(9200, "strider_boots", level=20, jobs=16, slot_mask=256),
            9201: _equipment(9201, "evasion_boots", level=75, jobs=16, slot_mask=256),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9200, "Strider Boots", "Feet"),
            _armor(9201, "Evasion Boots", "Feet"),
        )
    )

    style = _build_combat_style(
        "Movement",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Feet"].item.id == 9200


def test_movement_style_rejects_multi_slot_movement_overlay_from_automatic_sets() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9302: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9302: _equipment(9302, "blood_cuisses", level=73, jobs=16, slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9302, "Blood Cuisses", "Legs"),
        )
    )

    style = _build_combat_style("Movement", classified, "RDM", 75, item_stats)

    assert "Body" not in style
    assert style["Legs"].item.id == 9302


def test_combat_style_skips_slots_occupied_by_multi_slot_equipment() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9311: (ItemMod(161, "DMGPHYS", -5),),
            9312: (ItemMod(1, "DEF", 40),),
        },
        equipment_by_item_id={
            9311: _equipment(9311, "multi_slot_body", level=75, jobs=16, slot_mask=32, removal_slot_mask=128),
            9312: _equipment(9312, "strong_legs", level=75, jobs=16, slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9311, "Multi Slot Body", "Body"),
            _armor(9312, "Strong Legs", "Legs"),
        )
    )

    style = _build_combat_style("Survival", classified, "RDM", 75, item_stats)

    assert style["Body"].item.id == 9311
    assert "Legs" not in style


def test_secondary_slot_locks_ignore_ammo_range_removal_mask() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            9321: _equipment(
                9321,
                "range_removing_ammo",
                level=75,
                jobs=16,
                slot_mask=EQUIPMENT_SLOT_MASKS["Ammo"],
                removal_slot_mask=EQUIPMENT_SLOT_MASKS["Range"],
            ),
            9322: _equipment(
                9322,
                "multi_slot_body",
                level=75,
                jobs=16,
                slot_mask=EQUIPMENT_SLOT_MASKS["Body"],
                removal_slot_mask=EQUIPMENT_SLOT_MASKS["Legs"],
            ),
        },
    )
    ammo = _gear_item(9321, "Range Removing Ammo", "Ammo", "Weapon")
    body = _armor(9322, "Multi Slot Body", "Body")

    locks = builder_module._secondary_slot_locks_for_sets(
        {
            "Enspell": {
                "Ammo": SelectedGear(
                    slot="Ammo",
                    item=ammo,
                    classification=classify_item(ammo, item_stats=item_stats),
                    reason="fixture",
                    score=1,
                ),
                "Body": SelectedGear(
                    slot="Body",
                    item=body,
                    classification=classify_item(body, item_stats=item_stats),
                    reason="fixture",
                    score=1,
                ),
            },
        }
    )

    assert locks == {"Enspell": {"Body": ("Legs",)}}


def test_incity_style_allows_multi_slot_movement_overlay() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9302: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9302: _equipment(9302, "blood_cuisses", level=73, jobs=16, slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9302, "Blood Cuisses", "Legs"),
        )
    )

    normal = _build_combat_style("Movement", classified, "RDM", 75, item_stats)
    incity = _build_combat_style("InCity", classified, "RDM", 75, item_stats)

    assert "Body" not in normal
    assert normal["Legs"].item.id == 9302
    assert incity["Body"].item.id == 9301
    assert "Legs" not in incity


def test_movement_style_leaves_clear_debug_set_when_only_movement_option_is_overlay() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
        )
    )

    for style_name in ("Movement", "Movement_City", "Movement_Night", "Movement_DuskToDawn"):
        style = _build_combat_style(style_name, classified, "RDM", 75, item_stats)
        assert style == {}


def test_movement_style_prefers_equal_single_slot_speed_over_multi_slot_kupo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9303: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9303: _equipment(9303, "fast_feet", level=75, jobs=16, slot_mask=256),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9303, "Fast Feet", "Feet"),
        )
    )

    style = _build_combat_style("Movement", classified, "RDM", 75, item_stats)

    assert "Body" not in style
    assert style["Feet"].item.id == 9303


def test_movement_style_prefers_stackable_compatible_combo_over_multi_slot_kupo() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
            9304: (ItemMod(75, "MOVE_SPEED_STACKABLE", 10),),
            9305: (ItemMod(75, "MOVE_SPEED_STACKABLE", 10),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
            9304: _equipment(9304, "stackable_body", level=75, jobs=16, slot_mask=32),
            9305: _equipment(9305, "stackable_legs", level=75, jobs=16, slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
            _armor(9304, "Stackable Body", "Body"),
            _armor(9305, "Stackable Legs", "Legs"),
        )
    )

    style = _build_combat_style("Movement", classified, "RDM", 75, item_stats)

    assert style["Body"].item.id == 9304
    assert style["Legs"].item.id == 9305


def test_movement_city_style_uses_server_latent_aketons() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={},
        equipment_by_item_id={
            14428: _equipment(14428, "kingdom_aketon", level=1, jobs=4194303, slot_mask=32),
            9300: _equipment(9300, "combat_body", level=75, jobs=16, slot_mask=32),
        },
        latents_by_item_id={
            14428: (ItemLatent(14428, 76, "MOVE_SPEED_GEAR_BONUS", 12, 54, 19),),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(14428, "Kingdom Aketon", "Body"),
            _armor(9300, "Combat Body", "Body"),
        )
    )

    base = _build_combat_style("Movement", classified, "RDM", 75, item_stats)
    city = _build_combat_style("Movement_City", classified, "RDM", 75, item_stats)

    assert "Body" not in base
    assert city["Body"].item.id == 14428


def test_movement_night_styles_use_server_time_latents() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            12997: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            12997: _equipment(12997, "danzo_sune_ate", level=75, jobs=4096, slot_mask=256),
            14101: _equipment(14101, "ninja_kyahan", level=54, jobs=4096, slot_mask=256),
            15364: _equipment(15364, "nin_kyahan_+1", level=74, jobs=4096, slot_mask=256),
        },
        latents_by_item_id={
            14101: (ItemLatent(14101, 76, "MOVE_SPEED_GEAR_BONUS", 24, 26, 1),),
            15364: (ItemLatent(15364, 76, "MOVE_SPEED_GEAR_BONUS", 24, 26, 2),),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(12997, "Danzo Sune-Ate", "Feet", jobs=("NIN",)),
            _armor(14101, "Ninja Kyahan", "Feet", jobs=("NIN",)),
            _armor(15364, "Nin. Kyahan +1", "Feet", jobs=("NIN",)),
        )
    )

    night = _build_combat_style("Movement_Night", classified, "NIN", 75, item_stats)
    dusk_to_dawn = _build_combat_style("Movement_DuskToDawn", classified, "NIN", 75, item_stats)

    assert night["Feet"].item.id == 14101
    assert dusk_to_dawn["Feet"].item.id == 15364


def test_job_generation_includes_conditional_movement_semantic_sets() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9200: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 12),),
        },
        equipment_by_item_id={
            9200: _equipment(9200, "strider_boots", level=20, jobs=16, slot_mask=256),
            14428: _equipment(14428, "kingdom_aketon", level=1, jobs=4194303, slot_mask=32),
        },
        latents_by_item_id={
            14428: (ItemLatent(14428, 76, "MOVE_SPEED_GEAR_BONUS", 12, 54, 19),),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9200, "Strider Boots", "Feet"),
            _armor(14428, "Kingdom Aketon", "Body"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Movement"]["Feet"].item.id == 9200
    assert sets["Movement_City"]["Body"].item.id == 14428


def test_job_generation_includes_incity_multi_slot_movement_set() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9301: (ItemMod(76, "MOVE_SPEED_GEAR_BONUS", 18),),
        },
        equipment_by_item_id={
            9301: _equipment(9301, "kupo_suit", level=1, jobs=4194303, slot_mask=32, removal_slot_mask=128),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9301, "Kupo Suit", "Body"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    assert sets["Movement"] == {}
    assert sets["InCity"]["Body"].item.id == 9301


def test_status_conditional_accuracy_gear_is_not_base_set_but_generates_trigger() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            16306: (ItemMod(9, "DEX", 3),),
            9001: (ItemMod(25, "ACC", 10),),
        },
        equipment_by_item_id={
            16306: _equipment(16306, "halting_stole", level=75, jobs=4194303, slot_mask=512),
            9001: _equipment(9001, "peacock_charm", level=75, jobs=4194303, slot_mask=512),
        },
        conditional_mods_by_item_id={
            16306: (
                ItemConditionalMod(
                    item_id=16306,
                    mod_id=25,
                    name="ACC",
                    value=20,
                    condition_type="status",
                    condition_name="paralysis",
                    source_text="Halting Stole DEX+3 Paralysis: Accuracy+20",
                ),
            ),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(16306, "Halting Stole", "Neck", jobs=("SAM",)),
            _armor(9001, "Peacock Charm", "Neck", jobs=("SAM",)),
        )
    )

    accuracy = _build_combat_style("Accuracy", classified, "SAM", 75, item_stats)
    conditional_equips = _conditional_equips_for_sets(
        {"Accuracy": accuracy},
        classified,
        "SAM",
        75,
        item_stats,
    )

    assert accuracy["Neck"].item.id == 9001
    assert conditional_equips == {
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
    }


def test_poisoned_critical_hit_rate_gear_generates_damage_trigger() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9001: (ItemMod(23, "ATT", 2),),
            9002: (ItemMod(9, "DEX", 1),),
        },
        equipment_by_item_id={
            9001: _equipment(9001, "attack_gloves", level=75, jobs=4194303, slot_mask=64),
            9002: _equipment(9002, "venom_vambraces", level=75, jobs=4194303, slot_mask=64),
        },
        conditional_mods_by_item_id={
            9002: (
                ItemConditionalMod(
                    item_id=9002,
                    mod_id=165,
                    name="CRITHITRATE",
                    value=3,
                    condition_type="status",
                    condition_name="poison",
                    source_text="Latent Effect (Poisoned): Critical Hit Rate +3%",
                ),
            ),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9001, "Attack Gloves", "Hands", jobs=("RDM",)),
            _armor(9002, "Venom Vambraces", "Hands", jobs=("RDM",)),
        )
    )

    damage = _build_combat_style("Damage", classified, "RDM", 75, item_stats)
    conditional_equips = _conditional_equips_for_sets(
        {"Damage": damage},
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert damage["Hands"].item.id == 9001
    assert conditional_equips == {
        "Damage": (
            {
                "condition": {
                    "type": "status",
                    "name": "poison",
                    "buffs": ("poison",),
                },
                "slots": {"Hands": "Venom Vambraces"},
            },
        )
    }


def test_resting_style_does_not_pair_sub_weapon_with_two_handed_staff() -> None:
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9102: (ItemMod(71, "MPHEAL", 10),),
            9103: (ItemMod(2, "HP", 130),),
        },
        equipment_by_item_id={
            9102: _equipment(9102, "resting_staff", level=75, jobs=16, slot_mask=3),
            9103: _equipment(9103, "statted_sword", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9102: WeaponStats(item_id=9102, skill=12, delay=366, damage=50, hit=1),
            9103: WeaponStats(item_id=9103, skill=3, delay=240, damage=50, hit=1),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _weapon(9102, "Resting Staff"),
            _weapon(9103, "Statted Sword"),
        )
    )

    style = _build_combat_style(
        "Resting",
        classified,
        "RDM",
        75,
        item_stats,
    )

    assert style["Main"].item.id == 9102
    assert "Sub" not in style


def _rdm_weapon_stats() -> ItemStatsIndex:
    return ItemStatsIndex(
        source_path=Path("test.sqlite"),
        equipment_by_item_id={
            17754: _equipment(17754, "sylphid_epee", level=72, jobs=16, slot_mask=3),
            17710: _equipment(17710, "justice_sword", level=73, jobs=16, slot_mask=3),
            18904: _equipment(18904, "ephemeron", level=75, jobs=16, slot_mask=3),
            20720: _equipment(20720, "egeking", level=75, jobs=16, slot_mask=3),
            18852: _equipment(18852, "octave_club", level=63, jobs=16, slot_mask=3),
            20629: _equipment(20629, "atoyac", level=75, jobs=16, slot_mask=3),
            12296: _equipment(12296, "genbus_shield", level=74, jobs=16, slot_mask=2),
        },
        mods_by_item_id={
            17710: (ItemMod(8, "STR", 7),),
            18904: (
                ItemMod(11, "AGI", 15),
                ItemMod(384, "HASTE_GEAR", 300),
            ),
            20629: (ItemMod(30, "MACC", 10),),
            12296: (ItemMod(30, "MACC", 8),),
        },
        weapon_stats_by_item_id={
            17754: WeaponStats(item_id=17754, skill=3, delay=224, damage=39, hit=1),
            17710: WeaponStats(item_id=17710, skill=3, delay=236, damage=34, hit=1),
            18904: WeaponStats(item_id=18904, skill=3, delay=213, damage=58, hit=1),
            20720: WeaponStats(item_id=20720, skill=3, delay=236, damage=124, hit=1),
            18852: WeaponStats(item_id=18852, skill=11, delay=264, damage=11, hit=1),
            20629: WeaponStats(item_id=20629, skill=2, delay=200, damage=97, hit=1),
        },
    )


def _bump_mtime(path: Path) -> None:
    next_mtime = path.stat().st_mtime_ns + 1_000_000_000
    os.utime(path, ns=(next_mtime, next_mtime))


def _equipment(
    item_id: int,
    name: str,
    *,
    level: int,
    jobs: int,
    slot_mask: int,
    removal_slot_mask: int = 0,
) -> EquipmentStats:
    return EquipmentStats(
        item_id=item_id,
        name=name,
        level=level,
        ilevel=0,
        jobs=jobs,
        shield_size=1 if slot_mask == 2 else 0,
        slot_mask=slot_mask,
        removal_slot_mask=removal_slot_mask,
    )


def _weapon_policy_stats(
    weapons: dict[int, tuple[int, int, int]],
    *,
    shield_ids: set[int] | None = None,
    grip_ids: set[int] | None = None,
    mods_by_item_id: dict[int, tuple[ItemMod, ...]] | None = None,
    pet_mods_by_item_id: dict[int, tuple[ItemMod, ...]] | None = None,
) -> ItemStatsIndex:
    shield_ids = shield_ids or set()
    grip_ids = grip_ids or set()
    equipment_by_item_id = {}
    weapon_stats_by_item_id = {}
    for item_id, (skill, delay, damage) in weapons.items():
        if item_id in shield_ids or item_id in grip_ids:
            if item_id in grip_ids:
                equipment_by_item_id[item_id] = EquipmentStats(
                    item_id=item_id,
                    name=f"item_{item_id}",
                    level=75,
                    ilevel=0,
                    jobs=4194303,
                    shield_size=0,
                    slot_mask=2,
                    removal_slot_mask=0,
                )
                weapon_stats_by_item_id[item_id] = WeaponStats(
                    item_id=item_id,
                    skill=skill,
                    delay=delay,
                    damage=damage,
                    hit=1,
                )
            else:
                equipment_by_item_id[item_id] = _equipment(
                    item_id,
                    f"item_{item_id}",
                    level=75,
                    jobs=4194303,
                    slot_mask=2,
                )
            continue
        equipment_by_item_id[item_id] = _equipment(
            item_id,
            f"item_{item_id}",
            level=75,
            jobs=4194303,
            slot_mask=3,
        )
        weapon_stats_by_item_id[item_id] = WeaponStats(
            item_id=item_id,
            skill=skill,
            delay=delay,
            damage=damage,
            hit=1,
        )
    return ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id=mods_by_item_id or {},
        equipment_by_item_id=equipment_by_item_id,
        pet_mods_by_item_id=pet_mods_by_item_id or {},
        weapon_stats_by_item_id=weapon_stats_by_item_id,
    )


def _classified_items(
    item_stats: ItemStatsIndex,
    items: tuple[GearItem, ...],
) -> tuple[tuple[GearItem, object], ...]:
    return tuple((item, classify_item(item, item_stats=item_stats)) for item in items)


def _subjob_profile(abbr: str, capabilities: tuple[str, ...]) -> SubjobProfile:
    return SubjobProfile(
        abbr=abbr,
        level=37,
        capabilities=capabilities,
        abilities=tuple(),
        traits=tuple(),
        spells=tuple(),
    )


def _weapon(item_id: int, name: str, *, level: int = 75) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot="Main/Sub",
        category="Weapon",
        jobs=("RDM",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def _shield(item_id: int, name: str, *, level: int = 75) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot="Sub",
        category="Armor",
        jobs=("RDM",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def _accessory(item_id: int, name: str, slot: str, *, level: int = 75) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot=slot,
        category="Accessory",
        jobs=("RDM",),
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def _armor(item_id: int, name: str, slot: str, *, level: int = 75, jobs: tuple[str, ...] = ("RDM",)) -> GearItem:
    return _gear_item(item_id, name, slot, "Armor", level=level, jobs=jobs)


def _gear_item(
    item_id: int,
    name: str,
    slot: str,
    category: str,
    *,
    level: int = 75,
    jobs: tuple[str, ...] = ("RDM",),
) -> GearItem:
    return GearItem(
        id=item_id,
        name=name,
        count=1,
        level=level,
        slot=slot,
        category=category,
        jobs=jobs,
        storage="Inventory",
        augments=tuple(),
        raw_stats={},
        source_path=Path("fixture.lua"),
    )


def test_sam_generates_exact_ws_sets_without_action_time_weapon_swaps() -> None:
    sam_jobs_hex = str(1 << ((22 - 12) * 8))
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9001: (ItemMod(8, "STR", 20),),
            9002: (ItemMod(25, "ACC", 25),),
            9003: (ItemMod(23, "ATT", 18),),
        },
        equipment_by_item_id={
            9001: _equipment(9001, "ws_body", level=75, jobs=2048, slot_mask=32),
            9002: _equipment(9002, "ws_neck", level=75, jobs=2048, slot_mask=512),
            9003: _equipment(9003, "ws_waist", level=75, jobs=2048, slot_mask=1024),
            9100: _equipment(9100, "fixture_great_katana", level=75, jobs=2048, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9100: WeaponStats(item_id=9100, skill=10, delay=450, damage=80, hit=1),
        },
        skill_caps_by_level_rank={(75, 1): 300},
        skill_ranks_by_skill_job={(10, "SAM"): 1},
        weapon_skills_by_key={
            "tachi_gekko": CatseyeWeaponSkill(
                weapon_skill_id=110,
                name="Tachi: Gekko",
                key="tachi_gekko",
                display_name="Tachi: Gekko",
                set_name="WS_Tachi_Gekko",
                accuracy_set_name="WSAcc_Tachi_Gekko",
                jobs_hex=sam_jobs_hex,
                weapon_type=10,
                weapon_family="great_katana",
                skill_level=1,
                element_id=0,
                element_name="None",
                main_only=False,
                unlock_id=0,
            ),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _armor(9001, "WS Body", "Body", jobs=("SAM",)),
            _accessory(9002, "ACC Neck", "Neck"),
            _accessory(9003, "ATT Waist", "Waist"),
            _gear_item(9100, "Fixture Great Katana", "Main/Sub", "Weapon", jobs=("SAM",)),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("SAM", character_level=75),
        item_stats,
        None,
    )

    assert "WS_Tachi_Gekko" in sets
    assert "WSAcc_Tachi_Gekko" in sets
    assert "Main" not in sets["WS_Tachi_Gekko"]
    assert "Sub" not in sets["WS_Tachi_Gekko"]
    assert "Range" not in sets["WS_Tachi_Gekko"]
    assert "Ammo" not in sets["WS_Tachi_Gekko"]
    assert sets["WS_Tachi_Gekko"]["Body"].item.name == "WS Body"


def test_rdm_generates_sanguine_blade_as_magical_ws_set() -> None:
    rdm_jobs_hex = str(1 << ((22 - 5) * 8))
    item_stats = ItemStatsIndex(
        source_path=Path("test.sqlite"),
        mods_by_item_id={
            9201: (ItemMod(28, "MATT", 10),),
            9202: (ItemMod(13, "MND", 15),),
            9203: (ItemMod(39, "DARK_MAB", 8),),
        },
        equipment_by_item_id={
            9201: _equipment(9201, "mab_earring", level=75, jobs=16, slot_mask=2048),
            9202: _equipment(9202, "mnd_body", level=75, jobs=16, slot_mask=32),
            9203: _equipment(9203, "dark_mab_cape", level=75, jobs=16, slot_mask=32768),
            9300: _equipment(9300, "fixture_sword", level=75, jobs=16, slot_mask=3),
        },
        weapon_stats_by_item_id={
            9300: WeaponStats(item_id=9300, skill=3, delay=240, damage=50, hit=1),
        },
        skill_caps_by_level_rank={(75, 4): 300},
        skill_ranks_by_skill_job={(3, "RDM"): 4},
        weapon_skills_by_key={
            "sanguine_blade": CatseyeWeaponSkill(
                weapon_skill_id=111,
                name="Sanguine Blade",
                key="sanguine_blade",
                display_name="Sanguine Blade",
                set_name="WS_Sanguine_Blade",
                accuracy_set_name="WSAcc_Sanguine_Blade",
                jobs_hex=rdm_jobs_hex,
                weapon_type=3,
                weapon_family="sword",
                skill_level=1,
                element_id=255,
                element_name="Dark",
                main_only=False,
                unlock_id=0,
            ),
        },
    )
    classified = tuple(
        (item, classify_item(item, item_stats=item_stats))
        for item in (
            _accessory(9201, "MAB Earring", "Ear1"),
            _armor(9202, "MND Body", "Body"),
            _accessory(9203, "Dark MAB Cape", "Back"),
            _gear_item(9300, "Fixture Sword", "Main/Sub", "Weapon"),
        )
    )

    sets = _build_job_sets(
        classified,
        build_job_contract("RDM", character_level=75),
        item_stats,
        None,
    )

    assert "WS_Sanguine_Blade" in sets
    assert "Main" not in sets["WS_Sanguine_Blade"]
    assert "Sub" not in sets["WS_Sanguine_Blade"]
    assert "Ammo" not in sets["WS_Sanguine_Blade"]
    assert sets["WS_Sanguine_Blade"]["Ear1"].item.name == "MAB Earring"


def test_job_generation_manifest_includes_command_registry_and_bindings() -> None:
    contract = build_job_contract("WAR", character_level=75)
    item_stats = ItemStatsIndex(source_path=Path("test.sqlite"), mods_by_item_id={})
    armor = _armor(1001, "Scorpion Harness", "Body", jobs=("WAR",))
    selected = {
        "Accuracy": {
            "Body": SelectedGear(
                slot="Body",
                item=armor,
                classification=classify_item(armor, item_stats=item_stats),
                reason="fixture",
                score=10,
            )
        }
    }

    manifest = builder_module._build_manifest(
        player="Tester",
        player_id="1",
        job="WAR",
        contract=contract,
        gear_path=Path("gear.lua"),
        character_path=Path("character.json"),
        export_current_job="WAR",
        character_current_job="WAR",
        export_metadata={},
        character_raw={"jobs": {"WAR": 75}},
        item_stats=item_stats,
        target_profile=None,
        target_name=None,
        default_playstyle="Accuracy",
        subjob_profiles={},
        default_subjob="NIN",
        style_subjobs={},
        sets={"Accuracy": {"Body": "Scorpion Harness"}},
        selected=selected,
        conditional_equips={},
        mechanics_swap_planner={"loaded": False, "transitions": {}, "skippedTransitions": {}},
        rejected_items={"items": []},
    )

    command_literals = [entry["literal"] for entry in manifest["commandRegistry"]["commands"]]
    binding_literals = [entry["literal"] for entry in manifest["keyBindings"]["bindings"]]
    number_row = manifest["numberRowPalette"]

    assert "/lac fwd warp" in command_literals
    assert "/lac fwd style accuracy" in command_literals
    assert "/lac fwd warp" in binding_literals
    assert "/lac fwd style accuracy" in binding_literals
    assert manifest["keyBindings"]["conflicts"] == []
    assert manifest["keyBindings"]["unbound"] == []
    assert number_row["keys"] == [
        "NUMPAD.",
        "NUMPAD0",
        "NUMPAD1",
        "NUMPAD2",
        "NUMPAD3",
        "NUMPAD4",
        "NUMPAD5",
        "NUMPAD6",
        "NUMPAD7",
        "NUMPAD8",
        "NUMPAD9",
    ]
    assert number_row["displayKeys"] == [".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ""]
    assert number_row["bindings"][0]["literal"] == "/lac fwd styleprev"
    assert number_row["bindings"][8]["key"] == "NUMPAD7"
    assert number_row["bindings"][8]["literal"] == "/lac fwd warp"
    assert number_row["unbound"] == ["slot12"]
