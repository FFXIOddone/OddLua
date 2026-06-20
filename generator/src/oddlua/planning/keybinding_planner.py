from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping

from .command_registry import CommandRegistration


DEFAULT_KEY_ORDER: tuple[str, ...] = (
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10",
    "F11",
    "F12",
    "Ctrl+F1",
    "Ctrl+F2",
    "Ctrl+F3",
    "Ctrl+F4",
    "Ctrl+F5",
    "Ctrl+F6",
    "Ctrl+F7",
    "Ctrl+F8",
    "Ctrl+F9",
    "Ctrl+F10",
    "Ctrl+F11",
    "Ctrl+F12",
    "Alt+F1",
    "Alt+F2",
    "Alt+F3",
    "Alt+F4",
    "Alt+F5",
    "Alt+F6",
    "Alt+F7",
    "Alt+F8",
    "Alt+F9",
    "Alt+F10",
    "Alt+F11",
    "Alt+F12",
)


@dataclass(frozen=True)
class KeyBinding:
    key: str
    command: CommandRegistration

    def to_manifest(self) -> dict[str, object]:
        return {
            "key": self.key,
            "commandId": self.command.command_id,
            "literal": self.command.literal,
        }


@dataclass(frozen=True)
class KeyBindingPlan:
    bindings: tuple[KeyBinding, ...]
    conflicts: tuple[str, ...]
    unbound: tuple[str, ...]

    def to_manifest(self) -> dict[str, object]:
        return {
            "bindings": [binding.to_manifest() for binding in self.bindings],
            "conflicts": list(self.conflicts),
            "unbound": list(self.unbound),
        }


def plan_keybindings(
    commands: tuple[CommandRegistration, ...],
    *,
    overrides: Mapping[str, str] | None = None,
    key_order: tuple[str, ...] = DEFAULT_KEY_ORDER,
) -> KeyBindingPlan:
    overrides = overrides or {}
    active = [
        command
        for command in commands
        if command.available and not command.exempt_from_binding
    ]
    active.sort(key=lambda command: (command.priority, command.command_id))

    used_by_key: dict[str, str] = {}
    bindings: list[KeyBinding] = []
    conflicts: list[str] = []
    unbound: list[str] = []

    for command in active:
        requested = overrides.get(command.command_id)
        if requested:
            requested = requested.strip()
            if requested not in key_order:
                conflicts.append(f"{command.command_id} requested invalid key {requested}")
                unbound.append(command.command_id)
                continue
        key = requested or _first_free_key(key_order, used_by_key)
        if not key:
            unbound.append(command.command_id)
            continue
        existing_command_id = used_by_key.get(key)
        if existing_command_id is not None:
            conflicts.append(f"{command.command_id} requested {key} already assigned to {existing_command_id}")
            unbound.append(command.command_id)
            continue
        used_by_key[key] = command.command_id
        bindings.append(KeyBinding(key=key, command=command))

    return KeyBindingPlan(
        bindings=tuple(bindings),
        conflicts=tuple(conflicts),
        unbound=tuple(unbound),
    )


def _first_free_key(key_order: tuple[str, ...], used_by_key: Mapping[str, str]) -> str:
    for key in key_order:
        if key not in used_by_key:
            return key
    return ""
