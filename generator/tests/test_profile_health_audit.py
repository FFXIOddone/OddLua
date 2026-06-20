from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_profile_health import audit_profile_health


def test_profile_health_passes_for_synced_profile_without_destructive_jobability(tmp_path: Path) -> None:
    generated = tmp_path / "dist" / "packs" / "Player_1" / "SAM" / "SAM.lua"
    installed = tmp_path / "install" / "Player_1" / "SAM.lua"
    manifest = generated.with_name("manifest.json")
    generated.parent.mkdir(parents=True)
    installed.parent.mkdir(parents=True)
    generated.write_text(
        "\n".join(
            (
                "local sets = {",
                "    JobAbility = {",
                "        Main = 'Koryukagemitsu',",
                "        Sub = 'Tenax Strap',",
                "    },",
                "}",
                "local setIntents = {",
                "    JobAbility = 'TP',",
                "}",
            )
        ),
        encoding="utf-8",
    )
    installed.write_text(generated.read_text(encoding="utf-8"), encoding="utf-8")
    manifest.write_text("{}", encoding="utf-8")

    report = audit_profile_health(
        player_slug="Player_1",
        job="SAM",
        dist_root=tmp_path / "dist" / "packs",
        install_root=tmp_path / "install",
        syntax_compiler=lambda _path, _output: (0, ""),
    )

    assert report["exitCode"] == 0
    assert report["hashParity"] is True
    assert report["generatedProfile"]["exists"] is True
    assert report["installedProfile"]["exists"] is True
    assert report["manifest"]["exists"] is True
    assert report["luaSyntax"]["failed"] == 0
    assert report["weaponRemovalFindings"] == []
    assert report["failures"] == []


def test_profile_health_fails_hash_mismatch_and_destructive_jobability_weapon_removal(tmp_path: Path) -> None:
    generated = tmp_path / "dist" / "packs" / "Player_1" / "SAM" / "SAM.lua"
    installed = tmp_path / "install" / "Player_1" / "SAM.lua"
    generated.parent.mkdir(parents=True)
    installed.parent.mkdir(parents=True)
    generated.write_text(
        "\n".join(
            (
                "local sets = {",
                "    Meditate = {",
                "        Main = 'remove',",
                "        Sub = 'remove',",
                "        Range = 'remove',",
                "        Ammo = 'remove',",
                "    },",
                "}",
                "local setIntents = {",
                "    Meditate = 'JobAbility',",
                "}",
            )
        ),
        encoding="utf-8",
    )
    installed.write_text("-- stale installed copy\n", encoding="utf-8")

    report = audit_profile_health(
        player_slug="Player_1",
        job="SAM",
        dist_root=tmp_path / "dist" / "packs",
        install_root=tmp_path / "install",
        syntax_compiler=lambda _path, _output: (0, ""),
    )

    assert report["exitCode"] == 1
    assert report["hashParity"] is False
    assert "generated and installed profile hashes differ" in report["failures"]
    assert "manifest missing" in report["failures"]
    assert report["weaponRemovalFindings"] == [
        {
            "setName": "Meditate",
            "intent": "JobAbility",
            "slots": ["Ammo", "Main", "Range", "Sub"],
        }
    ]
    assert "destructive action set weapon removal found" in report["failures"]


def test_profile_health_discovers_latest_reconciliation_report(tmp_path: Path) -> None:
    generated = tmp_path / "dist" / "packs" / "Player_1" / "RDM" / "RDM.lua"
    installed = tmp_path / "install" / "Player_1" / "RDM.lua"
    manifest = generated.with_name("manifest.json")
    reports = tmp_path / "reports" / "live-reconciliation"
    generated.parent.mkdir(parents=True)
    installed.parent.mkdir(parents=True)
    reports.mkdir(parents=True)
    generated.write_text("local sets = {}\nlocal setIntents = {}\n", encoding="utf-8")
    installed.write_text(generated.read_text(encoding="utf-8"), encoding="utf-8")
    manifest.write_text("{}", encoding="utf-8")
    old_report = reports / "Player_1-RDM-old.md"
    latest_report = reports / "Player_1-RDM-active.md"
    old_report.write_text("Total snapshots: 1; matches 1; mismatches 0; unknown 0.\n", encoding="utf-8")
    latest_report.write_text("Total snapshots: 5; matches 4; mismatches 1; unknown 0.\n", encoding="utf-8")

    report = audit_profile_health(
        player_slug="Player_1",
        job="RDM",
        dist_root=tmp_path / "dist" / "packs",
        install_root=tmp_path / "install",
        report_root=reports,
        syntax_compiler=lambda _path, _output: (0, ""),
    )

    assert report["exitCode"] == 0
    assert report["liveReconciliation"]["latestReport"] == str(latest_report)
    assert report["liveReconciliation"]["summary"] == {
        "matches": 4,
        "mismatches": 1,
        "snapshots": 5,
        "unknown": 0,
    }


def test_profile_health_ignores_renderer_only_semantic_placeholders_when_manifest_is_available(
    tmp_path: Path,
) -> None:
    generated = tmp_path / "dist" / "packs" / "Player_1" / "SAM" / "SAM.lua"
    installed = tmp_path / "install" / "Player_1" / "SAM.lua"
    manifest = generated.with_name("manifest.json")
    generated.parent.mkdir(parents=True)
    installed.parent.mkdir(parents=True)
    generated.write_text(
        "\n".join(
            (
                "local sets = {",
                "    Jump = {",
                "        Main = 'remove',",
                "        Sub = 'remove',",
                "        Range = 'remove',",
                "        Ammo = 'remove',",
                "    },",
                "}",
                "local setIntents = {",
                "    Jump = 'Weaponskill',",
                "}",
            )
        ),
        encoding="utf-8",
    )
    installed.write_text(generated.read_text(encoding="utf-8"), encoding="utf-8")
    manifest.write_text('{"selectedItems": {"JobAbility": {}}}', encoding="utf-8")

    report = audit_profile_health(
        player_slug="Player_1",
        job="SAM",
        dist_root=tmp_path / "dist" / "packs",
        install_root=tmp_path / "install",
        syntax_compiler=lambda _path, _output: (0, ""),
    )

    assert report["exitCode"] == 0
    assert report["weaponRemovalFindings"] == []
