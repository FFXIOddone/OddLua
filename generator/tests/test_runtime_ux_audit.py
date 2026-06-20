from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_runtime_ux import audit_runtime_ux_root


def test_runtime_ux_audit_fails_empty_profile_root(tmp_path: Path) -> None:
    report = audit_runtime_ux_root(tmp_path / "packs")

    assert report["profileCount"] == 0
    assert report["failureCount"] == 1
    assert report["failures"] == [
        {
            "path": str(tmp_path / "packs"),
            "missing": ["generatedProfiles"],
        }
    ]


def test_runtime_ux_audit_fails_profiles_missing_help_surface(tmp_path: Path) -> None:
    profile_path = tmp_path / "packs" / "Tester_1" / "WAR" / "WAR.lua"
    profile_path.parent.mkdir(parents=True)
    profile_path.write_text("local profile = {};\nreturn profile;\n", encoding="utf-8")

    report = audit_runtime_ux_root(tmp_path / "packs")

    assert report["profileCount"] == 1
    assert report["failureCount"] == 1
    assert report["failures"][0]["missing"] == [
        "printOddLuaHelp",
        "printStyleList",
        "loadHelpHint",
        "statusHelpHint",
        "unknownCommandRecovery",
    ]


def test_runtime_ux_audit_passes_profile_with_discoverable_commands(tmp_path: Path) -> None:
    profile_path = tmp_path / "packs" / "Tester_1" / "WAR" / "WAR.lua"
    profile_path.parent.mkdir(parents=True)
    profile_path.write_text(
        "\n".join(
            (
                "local function printOddLuaHelp() end",
                "local function printStyleList() end",
                "message('Use /lac fwd help for commands and one-button setup.')",
                "message('help=/lac fwd help; styles=/lac fwd styles')",
                "message('Unknown command: x. Use /lac fwd help.')",
            )
        ),
        encoding="utf-8",
    )

    report = audit_runtime_ux_root(tmp_path / "packs")

    assert report["profileCount"] == 1
    assert report["failureCount"] == 0
    assert report["failures"] == []
