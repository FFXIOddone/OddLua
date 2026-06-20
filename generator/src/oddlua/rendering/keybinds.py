from __future__ import annotations

from collections.abc import Mapping

VALID_FUNCTION_KEYS = frozenset(f"F{number}" for number in range(1, 13))


def render_keybindings_script(key_bindings: Mapping[str, object]) -> str:
    """Render an auditable Ashita bind sidecar from manifest key bindings."""

    lines = [
        "-- OddLua generated keybinding plan.",
        "-- Review before pasting or loading; profile Lua does not auto-bind these keys.",
        "-- Quick start: /lac fwd help",
    ]
    bindings = key_bindings.get("bindings")
    if not isinstance(bindings, list):
        return "\n".join(lines) + "\n"

    for binding in bindings:
        if not isinstance(binding, Mapping):
            continue
        key = _ashita_key(str(binding.get("key", "")))
        literal = str(binding.get("literal", "")).strip()
        if not key or not _is_lac_forward_literal(literal):
            continue
        display_key = str(binding.get("key", "")).strip()
        command_id = str(binding.get("commandId", "")).strip()
        lines.append(f"-- {display_key}: {_binding_label(command_id, literal)}")
        lines.append(f"/bind {key} {literal}")
    return "\n".join(lines) + "\n"


def _ashita_key(key: str) -> str:
    normalized = key.strip()
    for prefix, token in (
        ("Ctrl+", "^"),
        ("Alt+", "!"),
        ("Shift+", "@"),
    ):
        if normalized.startswith(prefix):
            base_key = normalized[len(prefix):]
            return token + base_key if base_key in VALID_FUNCTION_KEYS else ""
    return normalized if normalized in VALID_FUNCTION_KEYS else ""


def _is_lac_forward_literal(literal: str) -> bool:
    folded = literal.lower()
    return folded == "/lac fwd" or folded.startswith("/lac fwd ")


def _binding_label(command_id: str, literal: str) -> str:
    if command_id == "warp":
        return "Warp Ring"
    if command_id == "warp.clear":
        return "clear Warp Ring lock"
    if command_id == "help":
        return "show OddLua help"
    if command_id == "status":
        return "show current style and subjob status"
    if command_id == "style.status":
        return "show available styles"
    if command_id == "styles":
        return "show available styles"
    if command_id == "subjob":
        return "show subjob capabilities"
    if command_id == "subjob.traits":
        return "show subjob traits"
    if command_id == "subjob.spells":
        return "show subjob spells"
    if command_id == "subjob.abilities":
        return "show subjob abilities"
    if command_id == "mechanics.status":
        return "show mechanics status"
    if command_id == "mechanics.list":
        return "list mechanics plans"
    if command_id == "mechanics.skipped":
        return "show skipped mechanics plans"
    if command_id == "mechanics.warnings":
        return "show mechanics warning counts"
    if command_id == "sam.help":
        return "show SAM control help"
    if command_id == "sam.sekkagekko":
        return "SAM Sekkanoki + Gekko"
    if command_id == "sam.konzenshoha":
        return "SAM Konzen-ittai + Shoha"
    if command_id == "sam.seiganeye":
        return "SAM Seigan + Third Eye"
    if command_id == "sam.warbuffs":
        return "SAM Berserk + Warcry"
    if command_id == "sam.autoeye":
        return "toggle SAM auto Third Eye"
    if command_id == "sam.autowar":
        return "toggle SAM auto WAR buffs"
    if command_id == "sam.autocombat":
        return "toggle SAM auto combat"
    if command_id.startswith("style."):
        return f"switch to {command_id.removeprefix('style.')} style"
    return literal
