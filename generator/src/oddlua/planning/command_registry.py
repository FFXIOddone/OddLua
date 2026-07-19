from __future__ import annotations

from dataclasses import dataclass


AAHTACOS_SAM_CONTROLS_FEATURE = "aahtacos_sam_controls"
BLUE_LEARNING_MODE_FEATURE = "blue_learning_mode"
CASTER_SUSTAIN_MODE_FEATURE = "caster_sustain_mode"
GUARD_MODE_FEATURE = "guard_mode"
OCCULT_ACUMEN_MODE_FEATURE = "occult_acumen_mode"
EXPLICIT_GEAR_MODES_FEATURE = "explicit_gear_modes"

RESIST_COMMANDS: tuple[tuple[str, str, str], ...] = (
    ("fireres", "FireRes", "fire"),
    ("iceres", "IceRes", "ice"),
    ("earthres", "EarthRes", "earth"),
    ("windres", "WindRes", "wind"),
    ("waterres", "WaterRes", "water"),
    ("thunderres", "ThunderRes", "thunder"),
    ("lightningres", "LightningRes", "lightning"),
    ("lightres", "LightRes", "light"),
    ("darkres", "DarkRes", "dark"),
    ("statusres", "StatusResist", "status"),
    ("charmres", "CharmResist", "charm"),
    ("resoff", "", "off"),
)

DEFENSIVE_OVERRIDE_COMMANDS: tuple[tuple[str, str], ...] = (
    ("dt", "Dt"),
    ("pdt", "PDT"),
    ("mdt", "MDT"),
    ("evasion", "Evasion"),
    ("safe", "Safe"),
    ("survival", "Survival"),
    ("tank", "Tank"),
    ("defenseoff", ""),
)

IDLE_POOL_COMMANDS: tuple[tuple[str, str], ...] = (
    ("idlepool.setmp", "setmp"),
    ("idlepool.addmp", "addmp"),
    ("idlepool.resetmp", "resetmp"),
    ("idlepool.sethp", "sethp"),
    ("idlepool.addhp", "addhp"),
    ("idlepool.resethp", "resethp"),
)


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
        CommandRegistration(
            "weapon.sync",
            "/lac fwd weaponsync",
            "runtime",
            priority=11,
            exempt_from_binding=True,
        ),
        CommandRegistration("style.status", "/lac fwd style", "style", priority=30),
        CommandRegistration("styles", "/lac fwd styles", "style", priority=31),
        CommandRegistration("status", "/lac fwd status", "runtime", priority=40),
        CommandRegistration(
            "conditional.status",
            "/lac fwd overlays",
            "diagnostics",
            priority=84,
            exempt_from_binding=True,
        ),
        CommandRegistration("subjob", "/lac fwd subjob", "subjob", priority=50),
        CommandRegistration("mechanics.status", "/lac fwd mechanics status", "mechanics", priority=60),
        CommandRegistration("subjob.traits", "/lac fwd subjob traits", "subjob", priority=70),
        CommandRegistration("subjob.spells", "/lac fwd subjob spells", "subjob", priority=70),
        CommandRegistration("subjob.abilities", "/lac fwd subjob abilities", "subjob", priority=70),
        CommandRegistration("mechanics.list", "/lac fwd mechanics list", "mechanics", priority=75),
        CommandRegistration("mechanics.warnings", "/lac fwd mechanics warnings", "mechanics", priority=75),
        CommandRegistration("mechanics.skipped", "/lac fwd mechanics skipped", "mechanics", priority=75),
        CommandRegistration(
            "mechanics.avoidtick",
            "/lac fwd mechanics avoidtick",
            "mechanics",
            priority=75,
            exempt_from_binding=True,
        ),
        CommandRegistration("warp.clear", "/lac fwd warpclear", "runtime", priority=80),
        CommandRegistration("gear.update", "/lac fwd updategear", "gear", priority=82, exempt_from_binding=True),
        CommandRegistration(
            "gear.update.status",
            "/lac fwd updategear status",
            "gear",
            priority=83,
            exempt_from_binding=True,
        ),
        CommandRegistration("help", "/lac fwd help", "runtime", priority=85),
    ]
    commands.extend(
        CommandRegistration(f"resist.{command}", f"/lac fwd {command}", "resist", priority=84, exempt_from_binding=True)
        for command, _set_name, _token in RESIST_COMMANDS
    )
    commands.extend(
        CommandRegistration(
            f"override.{command}",
            f"/lac fwd {command}",
            "override",
            priority=84,
            exempt_from_binding=True,
        )
        for command, _set_name in DEFENSIVE_OVERRIDE_COMMANDS
    )
    commands.extend(
        CommandRegistration(
            command_id,
            f"/lac fwd {command}",
            "idlepool",
            priority=84,
            exempt_from_binding=True,
        )
        for command_id, command in IDLE_POOL_COMMANDS
    )
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
    if BLUE_LEARNING_MODE_FEATURE in profile_features:
        commands.append(
            CommandRegistration(
                "mode.bluelearning",
                "/lac fwd learning",
                "mode",
                priority=84,
                exempt_from_binding=True,
            )
        )
    if CASTER_SUSTAIN_MODE_FEATURE in profile_features:
        commands.append(
            CommandRegistration(
                "mode.castersustain",
                "/lac fwd sustain",
                "mode",
                priority=84,
                exempt_from_binding=True,
            )
        )
    if GUARD_MODE_FEATURE in profile_features:
        commands.append(
            CommandRegistration(
                "mode.guard",
                "/lac fwd guard",
                "mode",
                priority=84,
                exempt_from_binding=True,
            )
        )
    if OCCULT_ACUMEN_MODE_FEATURE in profile_features:
        commands.append(
            CommandRegistration(
                "mode.occultacumen",
                "/lac fwd acumen",
                "mode",
                priority=84,
                exempt_from_binding=True,
            )
        )
    if EXPLICIT_GEAR_MODES_FEATURE in profile_features:
        commands.append(
            CommandRegistration(
                "mode.explicitgear",
                "/lac fwd mode",
                "mode",
                priority=84,
                exempt_from_binding=True,
            )
        )
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
        CommandRegistration("sam.meditate", "/lac fwd meditate", "sam", priority=76),
        CommandRegistration("sam.thirdeye", "/lac fwd thirdeye", "sam", priority=76),
    )
