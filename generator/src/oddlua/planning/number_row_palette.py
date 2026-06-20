from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

from .command_registry import AAHTACOS_SAM_CONTROLS_FEATURE


NUMBER_ROW_KEYS: tuple[str, ...] = ("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=")

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
    action: NumberRowAction

    def to_manifest(self) -> dict[str, object]:
        row = {"key": self.key}
        row.update(self.action.to_manifest())
        return row


@dataclass(frozen=True)
class NumberRowPalette:
    bindings: tuple[NumberRowBinding, ...]
    unbound: tuple[str, ...] = ()

    def to_manifest(self) -> dict[str, object]:
        return {
            "keys": list(NUMBER_ROW_KEYS),
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
    actions.extend(_auto_and_job_actions(normalized_job, tuple(profile_features)))

    while len(actions) < len(NUMBER_ROW_KEYS):
        slot_number = len(actions) - 8 + 1
        actions.append(
            NumberRowAction(f"slot.empty.{slot_number}", f"Auto {slot_number}", "/lac fwd palette missing", "toggle")
        )

    bindings = tuple(
        NumberRowBinding(key=key, action=action)
        for key, action in zip(NUMBER_ROW_KEYS, actions[: len(NUMBER_ROW_KEYS)], strict=True)
    )
    return NumberRowPalette(bindings=bindings)


def _base_actions() -> list[NumberRowAction]:
    return [
        NumberRowAction("style.prev", "Style-", "/lac fwd styleprev"),
        NumberRowAction("style.next", "Style+", "/lac fwd stylenext"),
        NumberRowAction("styles", "Styles", "/lac fwd styles"),
        NumberRowAction("warp", "Warp", "/lac fwd warp"),
        NumberRowAction("lockstyle", "Lockstyle", "/lac fwd lockstyle"),
        NumberRowAction("status", "Status", "/lac fwd status"),
    ]


def _utility_actions() -> list[NumberRowAction]:
    return [
        NumberRowAction(
            "utility.craft",
            "Craft",
            "/lac fwd utility craft",
            "utility",
            fallback_sets=UTILITY_FALLBACKS["craft"],
        ),
        NumberRowAction(
            "utility.movement",
            "Move",
            "/lac fwd utility movement",
            "utility",
            fallback_sets=UTILITY_FALLBACKS["movement"],
        ),
    ]


def _auto_and_job_actions(job: str, profile_features: tuple[str, ...]) -> list[NumberRowAction]:
    if job == "SAM" and AAHTACOS_SAM_CONTROLS_FEATURE in profile_features:
        return [
            NumberRowAction("sam.autoeye", "AutoEye", "/lac fwd autoeye", "toggle", toggle_state="AutoThirdEye"),
            NumberRowAction("sam.autowar", "AutoWAR", "/lac fwd autowar", "toggle", toggle_state="AutoWarBuffs"),
            NumberRowAction("sam.meditate", "Meditate", '/ja "Meditate" <me>', "job"),
            NumberRowAction("sam.thirdeye", "ThirdEye", '/ja "Third Eye" <me>', "job"),
        ]
    return [
        NumberRowAction("palette.auto1", "Auto 1", "/lac fwd palette missing", "toggle"),
        NumberRowAction("palette.auto2", "Auto 2", "/lac fwd palette missing", "toggle"),
        NumberRowAction("palette.job1", "Job 1", "/lac fwd palette missing", "job"),
        NumberRowAction("palette.job2", "Job 2", "/lac fwd palette missing", "job"),
    ]
