from __future__ import annotations

import argparse
import json
from pathlib import Path
import re


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
BIND_LABEL_RE = re.compile(r"^--\s+(?:Ctrl\+|Alt\+|Shift\+)?F(?:[1-9]|1[0-2]):\s+")
COMMAND_BRANCH_RE = re.compile(r"(?:if|elseif)\s+command\s*==\s*'([^']+)'")
ARGUMENT_GROUP_COMMANDS = frozenset({"style", "mechanics", "subjob"})


def audit_keybinding_quickstart_root(root: Path | str) -> dict[str, object]:
    sidecar_root = Path(root)
    sidecar_paths = sorted(sidecar_root.glob("*/*/keybindings.txt"))
    failures: list[dict[str, object]] = []

    if not sidecar_paths:
        failures.append(
            {
                "path": str(sidecar_root),
                "missing": ["generatedKeybindingSidecars"],
                "unsafeBinds": [],
            }
        )

    for sidecar_path in sidecar_paths:
        lines = sidecar_path.read_text(encoding="utf-8").splitlines()
        missing: list[str] = []
        if "-- Quick start: /lac fwd help" not in lines:
            missing.append("quickstartComment")
        if not any(BIND_LABEL_RE.match(line) for line in lines):
            missing.append("bindingLabel")
        bind_lines = [line for line in lines if line.startswith("/bind ")]
        if not bind_lines:
            missing.append("bindCommand")
        unsafe_binds = [
            line
            for line in bind_lines
            if not _is_safe_lac_forward_bind(line)
        ]
        missing_bindings = _missing_generated_command_bindings(sidecar_path, bind_lines)
        if missing or unsafe_binds or missing_bindings:
            failures.append(
                {
                    "path": str(sidecar_path),
                    "missing": missing,
                    "unsafeBinds": unsafe_binds,
                    **({"missingBindings": missing_bindings} if missing_bindings else {}),
                }
            )

    return {
        "sidecarRoot": str(sidecar_root),
        "sidecarCount": len(sidecar_paths),
        "failureCount": len(failures),
        "failures": failures,
    }


def _is_safe_lac_forward_bind(line: str) -> bool:
    parts = line.split(maxsplit=2)
    return len(parts) == 3 and parts[0] == "/bind" and parts[2].lower().startswith("/lac fwd")


def _missing_generated_command_bindings(sidecar_path: Path, bind_lines: list[str]) -> list[str]:
    bound_literals = {
        line.split(maxsplit=2)[2].strip().lower()
        for line in bind_lines
        if _is_safe_lac_forward_bind(line)
    }
    manifest_literals = _manifest_binding_literals(sidecar_path.parent / "manifest.json")
    required_literals = manifest_literals if manifest_literals is not None else _lua_command_branch_literals(sidecar_path)
    return [
        literal
        for literal in required_literals
        if literal.lower() not in bound_literals
    ]


def _manifest_binding_literals(manifest_path: Path) -> list[str] | None:
    if not manifest_path.exists():
        return None
    data = json.loads(manifest_path.read_text(encoding="utf-8"))
    key_bindings = data.get("keyBindings")
    if not isinstance(key_bindings, dict):
        return None
    bindings = key_bindings.get("bindings")
    if not isinstance(bindings, list):
        return None
    literals: list[str] = []
    for binding in bindings:
        if not isinstance(binding, dict):
            continue
        literal = binding.get("literal")
        if isinstance(literal, str) and literal not in literals:
            literals.append(literal)
    return literals


def _lua_command_branch_literals(sidecar_path: Path) -> list[str]:
    required_literals: list[str] = []
    for lua_path in sorted(sidecar_path.parent.glob("*.lua")):
        text = lua_path.read_text(encoding="utf-8")
        for token in COMMAND_BRANCH_RE.findall(text):
            if token in ARGUMENT_GROUP_COMMANDS:
                continue
            literal = f"/lac fwd {token}"
            if literal not in required_literals:
                required_literals.append(literal)
    return required_literals


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit generated keybinding sidecar quickstart labels.")
    parser.add_argument("--sidecar-root", default=ODDLUA_ROOT / "dist" / "packs", type=Path)
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_keybinding_quickstart_root(args.sidecar_root)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(
            "Keybinding quickstart audit: "
            f"sidecars={report['sidecarCount']} "
            f"failures={report['failureCount']}"
        )
    return 1 if int(report["failureCount"]) else 0


if __name__ == "__main__":
    raise SystemExit(main())
