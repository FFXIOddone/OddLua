from pathlib import Path
from dataclasses import replace
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

import pytest

from oddlua.weaponskill_scoring import weights_for_weaponskill
from oddlua.weaponskill_scripts import WeaponSkillScript, parse_weaponskill_script
from oddlua.weaponskills import load_weaponskill_catalog


REPO_ROOT = Path(__file__).resolve().parents[1]
STATS_DB = REPO_ROOT / "data" / "oddlua_stats.sqlite"
SERVER_WS = REPO_ROOT.parent / "server" / "scripts" / "actions" / "weaponskills"


def test_physical_ws_weights_follow_wsc_and_physical_damage() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["tachi_gekko"]
    script = parse_weaponskill_script(SERVER_WS / "tachi_gekko.lua", use_adoulin_changes=True)

    weights = weights_for_weaponskill(ws, script, accuracy=False)

    assert weights["STR"] > weights.get("DEX", 0)
    assert weights["WSDMG"] > 0
    assert weights["ATT"] > 0
    assert weights["WSACC"] > 0


def test_accuracy_ws_weights_raise_accuracy_without_erasing_wsc() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["tachi_gekko"]
    script = parse_weaponskill_script(SERVER_WS / "tachi_gekko.lua", use_adoulin_changes=True)

    normal = weights_for_weaponskill(ws, script, accuracy=False)
    accuracy = weights_for_weaponskill(ws, script, accuracy=True)

    assert accuracy["STR"] == normal["STR"]
    assert accuracy["ACC"] > normal["ACC"]
    assert accuracy["WSACC"] > normal["WSACC"]


def test_magical_ws_weights_include_mab_macc_and_element_staff_bonus() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["sanguine_blade"]
    script = parse_weaponskill_script(SERVER_WS / "sanguine_blade.lua", use_adoulin_changes=True)

    weights = weights_for_weaponskill(ws, script, accuracy=False)

    assert weights["MATT"] > 0
    assert weights["MACC"] > 0
    assert weights["DARK_STAFF_BONUS"] > 0
    assert weights["MND"] > weights["STR"]


def test_multihit_crit_ws_weights_include_crit_and_multihit_value() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["hexa_strike"]
    script = parse_weaponskill_script(SERVER_WS / "hexa_strike.lua", use_adoulin_changes=True)

    weights = weights_for_weaponskill(ws, script, accuracy=False)

    assert weights["CRITHITRATE"] > 0
    assert weights["DOUBLE_ATTACK"] > 0
    assert weights["MND"] == weights["STR"]


def test_merit_weaponskill_weights_include_parsed_primary_stat() -> None:
    catalog = load_weaponskill_catalog(STATS_DB)
    script = parse_weaponskill_script(
        SERVER_WS / "stardiver.lua",
        use_adoulin_changes=True,
    )

    weights = weights_for_weaponskill(catalog["stardiver"], script, accuracy=False)

    assert weights["STR"] == 96
    assert weights["DOUBLE_ATTACK"] > 0


def test_no_script_uses_catalog_magic_defaults_and_staff_bonus() -> None:
    ws = replace(load_weaponskill_catalog(STATS_DB)["sanguine_blade"], element_name="Dark", element_id=255)

    normal = weights_for_weaponskill(ws, None, accuracy=False)
    assert normal["MATT"] > 0
    assert normal["MACC"] > 0
    assert normal["DARK_STAFF_BONUS"] > 0

    accuracy = weights_for_weaponskill(ws, None, accuracy=True)
    assert accuracy["MACC"] > normal["MACC"]
    assert accuracy["ACC"] > normal.get("ACC", 0)
    assert accuracy["WSACC"] > normal.get("WSACC", 0)


def test_no_script_uses_correct_light_staff_bonus_from_catalog_element() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["trueflight"]

    weights = weights_for_weaponskill(ws, None, accuracy=False)

    assert weights["LIGHT_STAFF_BONUS"] > 0
    assert "WATER_STAFF_BONUS" not in weights


def test_weaponskill_scoring_rejects_unknown_damage_kind() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["sanguine_blade"]

    bad_script = WeaponSkillScript(damage_kind="weird", num_hits=1)

    with pytest.raises(ValueError, match=r"Unsupported weapon skill damage kind: weird"):
        weights_for_weaponskill(ws, bad_script, accuracy=False)


def test_negative_wsc_weights_are_omitted() -> None:
    ws = load_weaponskill_catalog(STATS_DB)["tachi_gekko"]
    script = WeaponSkillScript(
        damage_kind="physical",
        num_hits=1,
        wsc={"STR": -1.0},
    )

    weights = weights_for_weaponskill(ws, script, accuracy=False)

    assert "STR" not in weights
    assert "DEX" not in weights
    assert weights["WSDMG"] > 0
