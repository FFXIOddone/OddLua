from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.rendering.keybinds import render_keybindings_script


def test_render_keybindings_script_outputs_auditable_ashita_binds() -> None:
    script = render_keybindings_script(
        {
            "bindings": [
                {"key": "F1", "commandId": "warp", "literal": "/lac fwd warp"},
                {"key": "Ctrl+F2", "commandId": "style.accuracy", "literal": "/lac fwd style accuracy"},
                {"key": "Alt+F3", "commandId": "status", "literal": "/lac fwd status"},
            ],
        }
    )

    assert "-- OddLua generated keybinding plan." in script
    assert "-- Quick start: /lac fwd help" in script
    assert "-- F1: Warp Ring" in script
    assert "-- Ctrl+F2: switch to accuracy style" in script
    assert "-- Alt+F3: show current style and subjob status" in script
    assert "/bind F1 /lac fwd warp" in script
    assert "/bind ^F2 /lac fwd style accuracy" in script
    assert "/bind !F3 /lac fwd status" in script


def test_render_keybindings_script_labels_common_commands() -> None:
    script = render_keybindings_script(
        {
            "bindings": [
                {"key": "F1", "commandId": "warp", "literal": "/lac fwd warp"},
                {"key": "F2", "commandId": "style.accuracy", "literal": "/lac fwd style accuracy"},
                {"key": "F3", "commandId": "style.status", "literal": "/lac fwd style"},
                {"key": "F4", "commandId": "mechanics.warnings", "literal": "/lac fwd mechanics warnings"},
            ],
        }
    )

    assert "-- F1: Warp Ring" in script
    assert "-- F2: switch to accuracy style" in script
    assert "-- F3: show available styles" in script
    assert "-- F4: show mechanics warning counts" in script


def test_render_keybindings_script_skips_invalid_keys_and_non_lac_literals() -> None:
    script = render_keybindings_script(
        {
            "bindings": [
                {"key": "F1", "commandId": "warp", "literal": "/lac fwd warp"},
                {"key": "F13", "commandId": "status", "literal": "/lac fwd status"},
                {"key": "F2", "commandId": "unsafe", "literal": "/echo unsafe"},
                {"key": "Ctrl+F3", "commandId": "style.accuracy", "literal": "/lac fwd style accuracy"},
            ],
        }
    )

    assert "/bind F1 /lac fwd warp" in script
    assert "/bind ^F3 /lac fwd style accuracy" in script
    assert "F13" not in script
    assert "/echo unsafe" not in script
