from __future__ import annotations

from .weaponskill_scripts import WeaponSkillScript
from .weaponskills import CatseyeWeaponSkill

ELEMENT_STAFF_BONUS = {
    "Fire": "FIRE_STAFF_BONUS",
    "Ice": "ICE_STAFF_BONUS",
    "Wind": "WIND_STAFF_BONUS",
    "Earth": "EARTH_STAFF_BONUS",
    "Lightning": "THUNDER_STAFF_BONUS",
    "Thunder": "THUNDER_STAFF_BONUS",
    "Water": "WATER_STAFF_BONUS",
    "Light": "LIGHT_STAFF_BONUS",
    "Dark": "DARK_STAFF_BONUS",
}

SUPPORTED_DAMAGE_KINDS = frozenset({"physical", "magical", "ranged"})


def _resolve_damage_kind(
    ws: CatseyeWeaponSkill,
    script: WeaponSkillScript | None,
) -> str:
    damage_kind = (
        script.damage_kind if script else ("magical" if ws.element_name != "None" else "physical")
    )
    if damage_kind not in SUPPORTED_DAMAGE_KINDS:
        raise ValueError(f"Unsupported weapon skill damage kind: {damage_kind}")
    return damage_kind


def weights_for_weaponskill(
    ws: CatseyeWeaponSkill,
    script: WeaponSkillScript | None,
    *,
    accuracy: bool,
) -> dict[str, int]:
    damage_kind = _resolve_damage_kind(ws, script)
    weights: dict[str, int] = {}

    if script:
        for stat, coefficient in script.wsc.items():
            weight = int(28 + coefficient * 80)
            if weight > 0:
                weights[stat] = max(weights.get(stat, 0), weight)
    else:
        weights.update({"STR": 32, "DEX": 24})

    if damage_kind == "magical":
        weights.update({"MATT": 65, "MACC": 38, "WSDMG": 55})
        element_name = script.element_name if script else ws.element_name
        staff_bonus = ELEMENT_STAFF_BONUS.get(element_name)
        if staff_bonus:
            weights[staff_bonus] = 1800
    elif damage_kind == "ranged":
        weights.update({"RATT": 42, "RACC": 38, "AGI": max(weights.get("AGI", 0), 34), "WSDMG": 65})
    else:
        weights.update({"ATT": 28, "ACC": 18, "WSACC": 34, "WSDMG": 70})

    if script and script.crit_varies:
        weights["CRITHITRATE"] = 48
    if script and script.num_hits > 1:
        weights["DOUBLE_ATTACK"] = 20
    if script and script.attack_multiplier:
        weights["ATT"] = max(weights.get("ATT", 0), 36)

    if accuracy:
        weights["ACC"] = max(weights.get("ACC", 0) + 35, 55)
        weights["WSACC"] = max(weights.get("WSACC", 0) + 45, 75)
        weights["MACC"] = max(weights.get("MACC", 0) + 25, 45)

    return weights
