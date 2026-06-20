from __future__ import annotations

from dataclasses import dataclass


AAHTACOS_SAM_CONTROLS_FEATURE = "aahtacos_sam_controls"


@dataclass(frozen=True)
class CommandRegistration:
    command_id: str
    literal: str
    owner: str
    priority: int = 100
    available: bool = True
    exempt_from_binding: bool = False

    def to_manifest(self) -> dict[str, object]:
        return {
            "id": self.command_id,
            "literal": self.literal,
            "owner": self.owner,
            "priority": self.priority,
            "available": self.available,
            "exemptFromBinding": self.exempt_from_binding,
        }


def default_forward_commands(
    *,
    playstyles: tuple[str, ...],
    profile_features: tuple[str, ...] = tuple(),
) -> tuple[CommandRegistration, ...]:
    commands: list[CommandRegistration] = [
        CommandRegistration("warp", "/lac fwd warp", "runtime", priority=10),
        CommandRegistration("style.status", "/lac fwd style", "style", priority=30),
        CommandRegistration("styles", "/lac fwd styles", "style", priority=31),
        CommandRegistration("status", "/lac fwd status", "runtime", priority=40),
        CommandRegistration("subjob", "/lac fwd subjob", "subjob", priority=50),
        CommandRegistration("mechanics.status", "/lac fwd mechanics status", "mechanics", priority=60),
        CommandRegistration("subjob.traits", "/lac fwd subjob traits", "subjob", priority=70),
        CommandRegistration("subjob.spells", "/lac fwd subjob spells", "subjob", priority=70),
        CommandRegistration("subjob.abilities", "/lac fwd subjob abilities", "subjob", priority=70),
        CommandRegistration("mechanics.list", "/lac fwd mechanics list", "mechanics", priority=75),
        CommandRegistration("mechanics.warnings", "/lac fwd mechanics warnings", "mechanics", priority=75),
        CommandRegistration("mechanics.skipped", "/lac fwd mechanics skipped", "mechanics", priority=75),
        CommandRegistration("warp.clear", "/lac fwd warpclear", "runtime", priority=80),
        CommandRegistration("help", "/lac fwd help", "runtime", priority=85),
    ]
    seen_command_ids = {command.command_id for command in commands}
    for style_name in playstyles:
        normalized = _command_token(style_name)
        command_id = f"style.{normalized}"
        if command_id in seen_command_ids:
            continue
        seen_command_ids.add(command_id)
        commands.append(
            CommandRegistration(
                command_id=command_id,
                literal=f"/lac fwd style {normalized}",
                owner="style",
                priority=20,
            )
        )
    if AAHTACOS_SAM_CONTROLS_FEATURE in profile_features:
        commands.extend(_aahtacos_sam_control_commands())
    return tuple(commands)


def _command_token(value: str) -> str:
    return value.strip().lower().replace(" ", "_").replace("-", "_")


def _aahtacos_sam_control_commands() -> tuple[CommandRegistration, ...]:
    return (
        CommandRegistration("sam.help", "/lac fwd samhelp", "sam", priority=76),
        CommandRegistration("sam.sekkagekko", "/lac fwd sekkagekko", "sam", priority=76),
        CommandRegistration("sam.konzenshoha", "/lac fwd konzenshoha", "sam", priority=76),
        CommandRegistration("sam.seiganeye", "/lac fwd seiganeye", "sam", priority=76),
        CommandRegistration("sam.warbuffs", "/lac fwd warbuffs", "sam", priority=76),
        CommandRegistration("sam.autoeye", "/lac fwd autoeye", "sam", priority=76),
        CommandRegistration("sam.autowar", "/lac fwd autowar", "sam", priority=76),
        CommandRegistration("sam.autocombat", "/lac fwd autocombat", "sam", priority=76),
    )
