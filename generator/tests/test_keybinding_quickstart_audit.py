from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_keybinding_quickstart import audit_keybinding_quickstart_root


def test_keybinding_quickstart_audit_fails_empty_sidecar_root(tmp_path: Path) -> None:
    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["sidecarCount"] == 0
    assert report["failureCount"] == 1
    assert report["failures"] == [
        {
            "path": str(tmp_path / "packs"),
            "missing": ["generatedKeybindingSidecars"],
            "unsafeBinds": [],
        }
    ]


def test_keybinding_quickstart_audit_fails_unlabeled_sidecar(tmp_path: Path) -> None:
    sidecar = tmp_path / "packs" / "Tester_1" / "WAR" / "keybindings.txt"
    sidecar.parent.mkdir(parents=True)
    sidecar.write_text("/bind F1 /lac fwd warp\n", encoding="utf-8")

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["sidecarCount"] == 1
    assert report["failureCount"] == 1
    assert report["failures"][0]["missing"] == [
        "quickstartComment",
        "bindingLabel",
    ]


def test_keybinding_quickstart_audit_fails_non_lac_forward_binds(tmp_path: Path) -> None:
    sidecar = tmp_path / "packs" / "Tester_1" / "WAR" / "keybindings.txt"
    sidecar.parent.mkdir(parents=True)
    sidecar.write_text(
        "\n".join(
            (
                "-- Quick start: /lac fwd help",
                "-- F1: Warp Ring",
                "/bind F1 /echo unsafe",
            )
        ),
        encoding="utf-8",
    )

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["failureCount"] == 1
    assert report["failures"][0]["unsafeBinds"] == ["/bind F1 /echo unsafe"]


def test_keybinding_quickstart_audit_passes_labeled_lac_forward_binds(tmp_path: Path) -> None:
    sidecar = tmp_path / "packs" / "Tester_1" / "WAR" / "keybindings.txt"
    sidecar.parent.mkdir(parents=True)
    sidecar.write_text(
        "\n".join(
            (
                "-- OddLua generated keybinding plan.",
                "-- Quick start: /lac fwd help",
                "-- F1: Warp Ring",
                "/bind F1 /lac fwd warp",
            )
        ),
        encoding="utf-8",
    )

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["sidecarCount"] == 1
    assert report["failureCount"] == 0
    assert report["failures"] == []


def test_keybinding_quickstart_audit_fails_unbound_generated_command_branch(tmp_path: Path) -> None:
    profile_dir = tmp_path / "packs" / "Tester_1" / "SAM"
    profile_dir.mkdir(parents=True)
    (profile_dir / "keybindings.txt").write_text(
        "\n".join(
            (
                "-- OddLua generated keybinding plan.",
                "-- Quick start: /lac fwd help",
                "-- F1: Warp Ring",
                "/bind F1 /lac fwd warp",
            )
        ),
        encoding="utf-8",
    )
    (profile_dir / "SAM.lua").write_text(
        "\n".join(
            (
                "profile.HandleCommand = function(args)",
                "    local command = normalize(args[1]);",
                "    if command == 'warp' then",
                "        useWarpRing();",
                "    elseif command == 'sekkagekko' then",
                "        queueSamCommands('ok', {});",
                "    elseif command == 'style' or command == 'playstyle' then",
                "        printStyleList();",
                "    end",
                "end",
            )
        ),
        encoding="utf-8",
    )

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["failureCount"] == 1
    assert report["failures"][0]["missingBindings"] == ["/lac fwd sekkagekko"]


def test_keybinding_quickstart_audit_uses_manifest_bindings_when_available(tmp_path: Path) -> None:
    profile_dir = tmp_path / "packs" / "Tester_1" / "WAR"
    profile_dir.mkdir(parents=True)
    (profile_dir / "manifest.json").write_text(
        """
{
  "keyBindings": {
    "bindings": [
      {"key": "F1", "commandId": "warp", "literal": "/lac fwd warp"}
    ],
    "conflicts": [],
    "unbound": ["reconcile.status"]
  }
}
""".strip(),
        encoding="utf-8",
    )
    (profile_dir / "keybindings.txt").write_text(
        "\n".join(
            (
                "-- OddLua generated keybinding plan.",
                "-- Quick start: /lac fwd help",
                "-- F1: Warp Ring",
                "/bind F1 /lac fwd warp",
            )
        ),
        encoding="utf-8",
    )
    (profile_dir / "WAR.lua").write_text(
        "\n".join(
            (
                "profile.HandleCommand = function(args)",
                "    local command = normalize(args[1]);",
                "    if command == 'warp' then",
                "        useWarpRing();",
                "    elseif command == 'reconcile' then",
                "        handleReconcileCommand(args);",
                "    elseif command == 'on' or command == 'off' then",
                "        handleReconcileCommand(args);",
                "    end",
                "end",
            )
        ),
        encoding="utf-8",
    )

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["failureCount"] == 0
    assert report["failures"] == []


def test_keybinding_quickstart_audit_fails_missing_manifest_planned_binding(tmp_path: Path) -> None:
    profile_dir = tmp_path / "packs" / "Tester_1" / "WAR"
    profile_dir.mkdir(parents=True)
    (profile_dir / "manifest.json").write_text(
        """
{
  "keyBindings": {
    "bindings": [
      {"key": "F1", "commandId": "warp", "literal": "/lac fwd warp"},
      {"key": "F2", "commandId": "status", "literal": "/lac fwd status"}
    ],
    "conflicts": [],
    "unbound": []
  }
}
""".strip(),
        encoding="utf-8",
    )
    (profile_dir / "keybindings.txt").write_text(
        "\n".join(
            (
                "-- OddLua generated keybinding plan.",
                "-- Quick start: /lac fwd help",
                "-- F1: Warp Ring",
                "/bind F1 /lac fwd warp",
            )
        ),
        encoding="utf-8",
    )

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["failureCount"] == 1
    assert report["failures"][0]["missingBindings"] == ["/lac fwd status"]


def test_keybinding_quickstart_audit_passes_bound_generated_command_branches(tmp_path: Path) -> None:
    profile_dir = tmp_path / "packs" / "Tester_1" / "SAM"
    profile_dir.mkdir(parents=True)
    (profile_dir / "keybindings.txt").write_text(
        "\n".join(
            (
                "-- OddLua generated keybinding plan.",
                "-- Quick start: /lac fwd help",
                "-- F1: Warp Ring",
                "/bind F1 /lac fwd warp",
                "-- F2: SAM Sekkanoki + Gekko",
                "/bind F2 /lac fwd sekkagekko",
            )
        ),
        encoding="utf-8",
    )
    (profile_dir / "SAM.lua").write_text(
        "\n".join(
            (
                "profile.HandleCommand = function(args)",
                "    local command = normalize(args[1]);",
                "    if command == 'warp' then",
                "        useWarpRing();",
                "    elseif command == 'sekkagekko' then",
                "        queueSamCommands('ok', {});",
                "    elseif command == 'mechanics' then",
                "        handleMechanicsCommand(args);",
                "    end",
                "end",
            )
        ),
        encoding="utf-8",
    )

    report = audit_keybinding_quickstart_root(tmp_path / "packs")

    assert report["failureCount"] == 0
    assert report["failures"] == []
