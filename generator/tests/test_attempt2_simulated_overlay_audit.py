from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import sys

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.builder import (
    _automatic_semantic_styles_for_job,
    _build_combat_style,
    _weapon_family_policy_for_style,
)
from oddlua.classifier import classify_item
from oddlua.contracts import build_job_contract
from oddlua.gearexport import GearItem
from oddlua.itemstats import EQUIPMENT_SLOT_MASKS, EquipmentStats, ItemMod, ItemStatsIndex
from oddlua.planning.command_registry import default_forward_commands
from oddlua.planning.keybinding_planner import plan_keybindings


ALL_JOB_MASK = (1 << 22) - 1


@dataclass(frozen=True)
class ContractBindingCase:
    job: str
    level: int
    expected_playstyles: tuple[str, ...]
    expected_default: str
    expected_first_bindings: tuple[tuple[str, str, str], ...]
    constraints: str


@dataclass(frozen=True)
class SemanticOverlayCase:
    job: str
    must_include: frozenset[str]
    must_exclude: frozenset[str]
    constraints: str


@dataclass(frozen=True)
class WeaponPolicyCase:
    job: str
    style: str
    expected_policy: dict[str, tuple[str, ...]]
    constraints: str


CONTRACT_BINDING_CASES = (
    ContractBindingCase(
        job="WAR",
        level=75,
        expected_playstyles=("Damage", "Accuracy", "WeaponSkill", "Survival"),
        expected_default="Damage",
        expected_first_bindings=(
            ("F1", "warp", "/lac fwd warp"),
            ("F2", "style.accuracy", "/lac fwd style accuracy"),
            ("F3", "style.damage", "/lac fwd style damage"),
            ("F4", "style.survival", "/lac fwd style survival"),
            ("F5", "style.weaponskill", "/lac fwd style weaponskill"),
            ("F6", "style.status", "/lac fwd style"),
        ),
        constraints=(
            "WAR75 contract lanes are fixed by STANDARD_JOB_STYLES; key plan sorts by "
            "priority then command id, so warp binds before all style commands."
        ),
    ),
    ContractBindingCase(
        job="SAM",
        level=31,
        expected_playstyles=("StoreTP", "Accuracy", "WeaponSkill", "Evasion"),
        expected_default="StoreTP",
        expected_first_bindings=(
            ("F1", "warp", "/lac fwd warp"),
            ("F2", "style.accuracy", "/lac fwd style accuracy"),
            ("F3", "style.evasion", "/lac fwd style evasion"),
            ("F4", "style.storetp", "/lac fwd style storetp"),
            ("F5", "style.weaponskill", "/lac fwd style weaponskill"),
            ("F6", "style.status", "/lac fwd style"),
        ),
        constraints=(
            "SAM31 uses the same four contract lanes as SAM75, but all later gear "
            "selection must still respect level 31 eligibility."
        ),
    ),
    ContractBindingCase(
        job="COR",
        level=75,
        expected_playstyles=("RangedDamage", "RangedAccuracy", "QuickDraw", "Roll"),
        expected_default="RangedDamage",
        expected_first_bindings=(
            ("F1", "warp", "/lac fwd warp"),
            ("F2", "style.quickdraw", "/lac fwd style quickdraw"),
            ("F3", "style.rangedaccuracy", "/lac fwd style rangedaccuracy"),
            ("F4", "style.rangeddamage", "/lac fwd style rangeddamage"),
            ("F5", "style.roll", "/lac fwd style roll"),
            ("F6", "style.status", "/lac fwd style"),
        ),
        constraints=(
            "COR75 command macros must expose ranged, Quick Draw, Roll, and Warp "
            "through deterministic F-key bindings."
        ),
    ),
)


SEMANTIC_OVERLAY_CASES = (
    SemanticOverlayCase(
        job="BLM",
        must_include=frozenset({"Nuke", "Weather_Fire", "Day_Ice"}),
        must_exclude=frozenset({"BlueMagic", "QuickDraw", "Roll"}),
        constraints="BLM receives elemental caster overlays, but BLU and COR-only overlays are gated out.",
    ),
    SemanticOverlayCase(
        job="BLU",
        must_include=frozenset({"BlueMagic", "PhysicalBlueMagic", "MagicalBlueMagic"}),
        must_exclude=frozenset({"QuickDraw", "Roll", "Song"}),
        constraints="BLU receives blue magic overlays, but COR and BRD overlays remain job-restricted.",
    ),
    SemanticOverlayCase(
        job="COR",
        must_include=frozenset({"Snapshot", "RangedPreshot", "QuickDraw", "Roll"}),
        must_exclude=frozenset({"BlueMagic", "Song", "BloodPactRage"}),
        constraints="COR receives ranged, Quick Draw, and Roll overlays without leaking BLU/BRD/SMN overlays.",
    ),
    SemanticOverlayCase(
        job="SAM",
        must_include=frozenset({"Meditate", "ThirdEye"}),
        must_exclude=frozenset({"QuickDraw", "Roll", "BlueMagic"}),
        constraints="SAM receives job-specific Meditate and Third Eye overlays only.",
    ),
)


WEAPON_POLICY_CASES = (
    WeaponPolicyCase(
        job="WAR",
        style="Damage",
        expected_policy={
            "Main": ("great_axe", "axe"),
            "Sub": ("grip", "axe"),
            "Range": ("throwing",),
            "Ammo": ("ammo",),
        },
        constraints="WAR Damage overlays default ranged/ammo slots, then narrow Main/Sub to great axe or axe.",
    ),
    WeaponPolicyCase(
        job="WAR",
        style="Survival",
        expected_policy={
            "Main": ("axe", "sword"),
            "Sub": ("shield",),
            "Range": ("throwing",),
            "Ammo": ("ammo",),
        },
        constraints="WAR Survival deliberately trades two-handed DPS routing for one-handed weapon plus shield.",
    ),
    WeaponPolicyCase(
        job="SAM",
        style="StoreTP",
        expected_policy={
            "Main": ("great_katana", "polearm"),
            "Sub": ("grip",),
            "Range": ("throwing",),
            "Ammo": ("ammo",),
        },
        constraints="SAM StoreTP keeps two-handed main weapons and grip-only sub routing.",
    ),
    WeaponPolicyCase(
        job="COR",
        style="QuickDraw",
        expected_policy={
            "Main": ("dagger", "sword"),
            "Sub": ("dagger", "sword"),
            "Range": ("gun",),
            "Ammo": ("ammo",),
        },
        constraints="COR QuickDraw must require gun range routing while preserving dagger/sword hand slots.",
    ),
)


@pytest.mark.parametrize("case", CONTRACT_BINDING_CASES, ids=lambda case: f"{case.job}{case.level}")
def test_contracts_and_f_key_bindings_match_hand_calculated_order(case: ContractBindingCase) -> None:
    contract = build_job_contract(case.job, character_level=case.level)

    assert tuple(playstyle.name for playstyle in contract.playstyles) == case.expected_playstyles, case.constraints
    assert contract.default_playstyle == case.expected_default, case.constraints

    commands = default_forward_commands(playstyles=case.expected_playstyles)
    plan = plan_keybindings(commands)
    actual_first_bindings = tuple(
        (binding.key, binding.command.command_id, binding.command.literal)
        for binding in plan.bindings[: len(case.expected_first_bindings)]
    )

    assert actual_first_bindings == case.expected_first_bindings, case.constraints
    assert plan.conflicts == tuple(), case.constraints
    assert plan.unbound == tuple(), case.constraints


@pytest.mark.parametrize("case", SEMANTIC_OVERLAY_CASES, ids=lambda case: case.job)
def test_job_semantic_overlays_respect_calculated_job_gates(case: SemanticOverlayCase) -> None:
    overlays = set(_automatic_semantic_styles_for_job(case.job))

    assert case.must_include <= overlays, case.constraints
    assert overlays.isdisjoint(case.must_exclude), case.constraints


@pytest.mark.parametrize("case", WEAPON_POLICY_CASES, ids=lambda case: f"{case.job}_{case.style}")
def test_weapon_family_policies_match_calculated_style_constraints(case: WeaponPolicyCase) -> None:
    assert _weapon_family_policy_for_style(case.job, case.style) == case.expected_policy, case.constraints


def test_war_body_overlay_scoring_matches_manual_accuracy_and_damage_math() -> None:
    item_stats = _item_stats(
        equipment_by_item_id={
            1001: _equipment(1001, "accuracy_harness", level=75, slot="Body"),
            1002: _equipment(1002, "attack_harness", level=75, slot="Body"),
        },
        mods_by_item_id={
            1001: (ItemMod(25, "ACC", 10),),
            1002: (ItemMod(23, "ATT", 30),),
        },
    )
    classified = _classified_items(
        (
            _gear_item(1001, "Accuracy Harness", "Body", jobs=("WAR",)),
            _gear_item(1002, "Attack Harness", "Body", jobs=("WAR",)),
        ),
        item_stats,
    )

    accuracy = _build_combat_style("Accuracy", classified, "WAR", 75, item_stats)
    damage = _build_combat_style("Damage", classified, "WAR", 75, item_stats)

    assert accuracy["Body"].item.name == "Accuracy Harness"
    assert accuracy["Body"].score == 550  # ACC+10 * Accuracy weight 55 beats ATT+30 * 8 = 240.
    assert damage["Body"].item.name == "Attack Harness"
    assert damage["Body"].score == 480  # ATT+30 * Damage weight 16 beats ACC+10 * 30 = 300.


def test_level_gate_blocks_high_score_future_gear_before_overlay_scoring_wins() -> None:
    item_stats = _item_stats(
        equipment_by_item_id={
            1101: _equipment(1101, "future_harness", level=75, slot="Body"),
            1102: _equipment(1102, "training_harness", level=30, slot="Body"),
        },
        mods_by_item_id={
            1101: (ItemMod(25, "ACC", 99),),
            1102: (ItemMod(23, "ATT", 5),),
        },
    )
    classified = _classified_items(
        (
            _gear_item(1101, "Future Harness", "Body", level=75, jobs=("WAR",)),
            _gear_item(1102, "Training Harness", "Body", level=30, jobs=("WAR",)),
        ),
        item_stats,
    )

    level_30_accuracy = _build_combat_style("Accuracy", classified, "WAR", 30, item_stats)
    level_75_accuracy = _build_combat_style("Accuracy", classified, "WAR", 75, item_stats)

    assert level_30_accuracy["Body"].item.name == "Training Harness"
    assert level_30_accuracy["Body"].score == 40  # ATT+5 * Accuracy weight 8; level 75 ACC+99 is ineligible.
    assert level_75_accuracy["Body"].item.name == "Future Harness"
    assert level_75_accuracy["Body"].score == 5445  # ACC+99 * Accuracy weight 55 once level gate allows it.


def test_cor_snapshot_semantic_scores_catseye_server_snapshot_mod_name() -> None:
    item_stats = _item_stats(
        equipment_by_item_id={
            1201: _equipment(1201, "snapshot_belt", level=75, slot="Waist"),
            1202: _equipment(1202, "racc_belt", level=75, slot="Waist"),
        },
        mods_by_item_id={
            1201: (ItemMod(365, "SNAPSHOT", 10),),
            1202: (ItemMod(26, "RACC", 5),),
        },
    )
    classified = _classified_items(
        (
            _gear_item(1201, "Snapshot Belt", "Waist", category="Accessory", jobs=("COR",)),
            _gear_item(1202, "RACC Belt", "Waist", category="Accessory", jobs=("COR",)),
        ),
        item_stats,
    )

    snapshot = _build_combat_style("Snapshot", classified, "COR", 75, item_stats)

    assert snapshot["Waist"].item.name == "Snapshot Belt"
    assert snapshot["Waist"].score == 350  # SNAPSHOT+10 * RangedAccuracy snapshot weight 35 beats RACC+5 * 55 = 275.


def test_empty_overlay_build_returns_empty_style_without_crashing() -> None:
    assert _build_combat_style("Accuracy", tuple(), "WAR", 75, None) == {}


def test_wrong_job_server_mask_blocks_otherwise_useful_overlay_item() -> None:
    rdm_only_mask = 1 << (5 - 1)
    item_stats = _item_stats(
        equipment_by_item_id={
            1301: _equipment(1301, "rdm_only_harness", level=75, slot="Body", jobs=rdm_only_mask),
        },
        mods_by_item_id={
            1301: (ItemMod(25, "ACC", 99),),
        },
    )
    classified = _classified_items(
        (
            _gear_item(1301, "RDM Only Harness", "Body", jobs=("WAR",)),
        ),
        item_stats,
    )

    assert _build_combat_style("Accuracy", classified, "WAR", 75, item_stats) == {}


def _classified_items(
    items: tuple[GearItem, ...],
    item_stats: ItemStatsIndex,
) -> tuple[tuple[GearItem, object], ...]:
    return tuple((item, classify_item(item, item_stats=item_stats)) for item in items)


def _item_stats(
    *,
    equipment_by_item_id: dict[int, EquipmentStats],
    mods_by_item_id: dict[int, tuple[ItemMod, ...]],
) -> ItemStatsIndex:
    return ItemStatsIndex(
        source_path=Path("attempt2-simulated-audit.sqlite"),
        equipment_by_item_id=equipment_by_item_id,
        mods_by_item_id=mods_by_item_id,
    )


def _equipment(
    item_id: int,
    name: str,
    *,
    level: int,
    slot: str,
    jobs: int = ALL_JOB_MASK,
) -> EquipmentStats:
    return EquipmentStats(
        item_id=item_id,
        name=name,
        level=level,
        ilevel=0,
        jobs=jobs,
        shield_size=0,
        slot_mask=EQUIPMENT_SLOT_MASKS[slot],
        removal_slot_mask=0,
    )


def _gear_item(
    item_id: int,
    name: str,
    slot: str,
    *,
    category: str = "Armor",
    level: int = 75,
    jobs: tuple[str, ...],
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
        source_path=Path("attempt2-simulated-audit.lua"),
    )
