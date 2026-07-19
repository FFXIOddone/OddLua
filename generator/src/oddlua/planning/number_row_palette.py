from __future__ import annotations

from dataclasses import dataclass, replace
from typing import Iterable

from .command_registry import AAHTACOS_SAM_CONTROLS_FEATURE


NUMBER_ROW_KEYS: tuple[str, ...] = (
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
)
NUMBER_ROW_DISPLAY_KEYS: tuple[str, ...] = (".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
NUMBER_ROW_UNBOUND_SLOT = "slot12"
NUMBER_ROW_COMMAND_ONLY_KEYS: tuple[str, ...] = ("NUMPAD2", "NUMPAD4", "NUMPAD6", "NUMPAD8")

UTILITY_FALLBACKS: dict[str, tuple[str, ...]] = {
    "craft": ("Craft", "Fishing", "Gathering", "Clamming", "Movement", "Resting", "Treasure", "Survival"),
    "movement": ("Movement", "Movement_City", "Movement_Night", "Movement_DuskToDawn", "InCity", "Survival"),
}


@dataclass(frozen=True)
class NumberRowAction:
    action_id: str
    label: str
    literal: str
    kind: str = "action"
    toggle_state: str = ""
    fallback_sets: tuple[str, ...] = ()

    def to_manifest(self) -> dict[str, object]:
        return {
            "id": self.action_id,
            "label": self.label,
            "literal": self.literal,
            "kind": self.kind,
            "toggleState": self.toggle_state,
            "fallbackSets": list(self.fallback_sets),
        }


@dataclass(frozen=True)
class NumberRowBinding:
    key: str
    display_key: str
    action: NumberRowAction

    def to_manifest(self) -> dict[str, object]:
        row = {"key": self.key, "displayKey": self.display_key}
        row.update(self.action.to_manifest())
        return row


@dataclass(frozen=True)
class NumberRowPalette:
    bindings: tuple[NumberRowBinding, ...]
    unbound: tuple[str, ...] = ()

    def to_manifest(self) -> dict[str, object]:
        return {
            "keys": list(NUMBER_ROW_KEYS),
            "displayKeys": list(NUMBER_ROW_DISPLAY_KEYS) + [""],
            "bindings": [binding.to_manifest() for binding in self.bindings],
            "unbound": list(self.unbound),
        }


def plan_number_row_palette(
    *,
    job: str,
    playstyles: Iterable[str],
    available_sets: Iterable[str],
    profile_features: tuple[str, ...] = (),
) -> NumberRowPalette:
    tuple(playstyles)
    frozenset(available_sets)
    normalized_job = job.upper()
    actions = _base_actions()
    actions.extend(_utility_actions())
    auto_and_job_actions = _auto_and_job_actions(normalized_job, tuple(profile_features))
    if auto_and_job_actions:
        actions.append(auto_and_job_actions[0])
    actions.append(_warp_action())
    actions.extend(auto_and_job_actions[1:])

    while len(actions) < len(NUMBER_ROW_KEYS):
        slot_number = len(actions) - 8 + 1
        actions.append(
            NumberRowAction(f"slot.empty.{slot_number}", f"Auto {slot_number}", "/lac fwd palette missing", "toggle")
        )

    bindings = tuple(
        NumberRowBinding(
            key=key,
            display_key=display_key,
            action=(replace(action, kind="command-only") if key in NUMBER_ROW_COMMAND_ONLY_KEYS else action),
        )
        for key, display_key, action in zip(
            NUMBER_ROW_KEYS,
            NUMBER_ROW_DISPLAY_KEYS,
            actions[: len(NUMBER_ROW_KEYS)],
            strict=True,
        )
    )
    return NumberRowPalette(bindings=bindings, unbound=(NUMBER_ROW_UNBOUND_SLOT,))


def _base_actions() -> list[NumberRowAction]:
    return [
        NumberRowAction("style.prev", "Style-", "/lac fwd styleprev"),
        NumberRowAction("style.next", "Style+", "/lac fwd stylenext"),
        NumberRowAction("styles", "Styles", "/lac fwd styles"),
        NumberRowAction("status", "Status", "/lac fwd status"),
        NumberRowAction("lockstyle", "Lockstyle", "/lac fwd lockstyle"),
    ]


def _warp_action() -> NumberRowAction:
    return NumberRowAction("warp", "Warp", "/lac fwd warp")


def _utility_actions() -> list[NumberRowAction]:
    return [
        NumberRowAction(
            "utility.movement",
            "Move",
            "/lac fwd utility movement",
            "utility",
            fallback_sets=UTILITY_FALLBACKS["movement"],
        ),
        NumberRowAction(
            "utility.craft",
            "Craft",
            "/lac fwd utility craft",
            "utility",
            fallback_sets=UTILITY_FALLBACKS["craft"],
        ),
    ]


def _auto_and_job_actions(job: str, profile_features: tuple[str, ...]) -> list[NumberRowAction]:
    if job == "SAM" and AAHTACOS_SAM_CONTROLS_FEATURE in profile_features:
        return [
            NumberRowAction("sam.autoeye", "AutoEye", "/lac fwd autoeye", "toggle", toggle_state="AutoThirdEye"),
            NumberRowAction("sam.autowar", "AutoWAR", "/lac fwd autowar", "toggle", toggle_state="AutoWarBuffs"),
            NumberRowAction("sam.meditate", "Meditate", "/lac fwd meditate", "job"),
            NumberRowAction("sam.thirdeye", "ThirdEye", "/lac fwd thirdeye", "job"),
        ]
    return [
        NumberRowAction("palette.auto1", "Auto 1", "/lac fwd palette missing", "toggle"),
        NumberRowAction("palette.auto2", "Auto 2", "/lac fwd palette missing", "toggle"),
        NumberRowAction("palette.job1", "Job 1", "/lac fwd palette missing", "job"),
        NumberRowAction("palette.job2", "Job 2", "/lac fwd palette missing", "job"),
    ]
