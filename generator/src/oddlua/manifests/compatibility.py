from __future__ import annotations

from collections.abc import Mapping


def manifest_signature(manifest: Mapping[str, object]) -> dict[str, object]:
    sets = _mapping(manifest.get("sets"))
    selected_items = _mapping(manifest.get("selectedItems"))
    mechanics = _mapping(manifest.get("mechanicsSwapPlanner"))
    return {
        "identity": {
            "player": manifest.get("player", ""),
            "playerId": manifest.get("playerId", ""),
            "job": manifest.get("job", ""),
            "level": manifest.get("level", 0),
        },
        "defaultPlaystyle": manifest.get("defaultPlaystyle", ""),
        "playstyles": list(manifest.get("playstyles", [])) if isinstance(manifest.get("playstyles"), list) else [],
        "setNames": sorted(str(name) for name in sets),
        "selectedItems": _selected_item_signature(selected_items),
        "mechanicsSwapPlanner": _mechanics_signature(mechanics),
    }


def diff_manifest_signatures(left: Mapping[str, object], right: Mapping[str, object]) -> list[str]:
    keys = sorted(set(left) | set(right))
    return [f"{key} differs" for key in keys if left.get(key) != right.get(key)]


def _selected_item_signature(selected_items: Mapping[str, object]) -> dict[str, dict[str, dict[str, str]]]:
    result: dict[str, dict[str, dict[str, str]]] = {}
    for style_name, slots in selected_items.items():
        slot_map = _mapping(slots)
        result[str(style_name)] = {}
        for slot_name, value in slot_map.items():
            selected = _mapping(value)
            item = _mapping(selected.get("item"))
            result[str(style_name)][str(slot_name)] = {
                "name": str(item.get("name", selected.get("name", ""))),
                "reason": str(selected.get("reason", "")),
            }
    return result


def _mechanics_signature(mechanics: Mapping[str, object]) -> dict[str, object]:
    transitions = _mapping(mechanics.get("transitions"))
    skipped = _mapping(mechanics.get("skippedTransitions"))
    return {
        "loaded": mechanics.get("loaded", False),
        "plannerVersion": mechanics.get("plannerVersion", 0),
        "transitionCount": len(transitions),
        "skippedTransitionCount": len(skipped),
    }


def _mapping(value: object) -> Mapping[str, object]:
    return value if isinstance(value, Mapping) else {}
