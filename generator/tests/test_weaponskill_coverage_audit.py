from pathlib import Path
import json
import sys

REPO_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO_ROOT / "src"))
sys.path.insert(0, str(REPO_ROOT / "tools"))

STATS_DB = REPO_ROOT / "data" / "oddlua_stats.sqlite"
from audit_weaponskill_coverage import (
    audit_weaponskill_coverage,
    weaponskill_audit_failures,
    weaponskill_audit_exit_code,
    weaponskill_console_payload,
)


def test_audit_reports_catalog_and_generated_profile_coverage() -> None:
    report = audit_weaponskill_coverage(
        stats_db_path=STATS_DB,
        dist_root=REPO_ROOT / "dist" / "packs",
    )

    assert report["catalogCount"] >= 190
    assert report["summary"]["catalogCount"] >= 190
    assert report["summary"]["profileCount"] > 0
    assert report["summary"]["totalWeaponskillSets"] > 0
    assert "tachi_gekko" in report["catalogKeys"]
    assert "sanguine_blade" in report["catalogKeys"]
    assert report["profiles"]
    assert weaponskill_audit_exit_code(
        report,
        min_catalog_count=190,
        min_profile_count=1,
        min_total_weaponskill_sets=1,
        max_profiles_without_weaponskill_sets=0,
    ) == 0


def test_audit_tolerates_missing_or_non_dict_selected_items(tmp_path: Path) -> None:
    dist_root = tmp_path / "packs"
    manifest_missing = dist_root / "Player_1" / "WAR" / "manifest.json"
    manifest_missing.parent.mkdir(parents=True)
    manifest_missing.write_text(
        json.dumps({"player": "Player_1", "job": "WAR"}),
        encoding="utf-8",
    )

    manifest_list = dist_root / "Player_1" / "THF" / "manifest.json"
    manifest_list.parent.mkdir(parents=True)
    manifest_list.write_text(
        json.dumps(
            {
                "player": "Player_1",
                "job": "THF",
                "selectedItems": ["WS_Tachi_Gekko", "WSAcc_Tachi_Gekko"],
            }
        ),
        encoding="utf-8",
    )

    report = audit_weaponskill_coverage(
        stats_db_path=STATS_DB,
        dist_root=dist_root,
    )

    assert len(report["profiles"]) == 2
    profile_by_path = {entry["manifestPath"]: entry for entry in report["profiles"]}

    assert str(manifest_missing) in profile_by_path
    assert profile_by_path[str(manifest_missing)]["weaponskillSetCount"] == 0
    assert profile_by_path[str(manifest_missing)]["weaponskillSets"] == []

    assert str(manifest_list) in profile_by_path
    assert profile_by_path[str(manifest_list)]["weaponskillSetCount"] == 0
    assert profile_by_path[str(manifest_list)]["weaponskillSets"] == []


def test_weaponskill_audit_failures_report_minimum_gate_failures() -> None:
    report = {
        "summary": {
            "catalogCount": 0,
            "profileCount": 0,
            "totalWeaponskillSets": 0,
        },
    }

    assert weaponskill_audit_failures(
        report,
        min_catalog_count=1,
        min_profile_count=1,
        min_total_weaponskill_sets=1,
        max_profiles_without_weaponskill_sets=0,
    ) == (
        "catalogCount 0 below min 1",
        "profileCount 0 below min 1",
        "totalWeaponskillSets 0 below min 1",
    )
    assert weaponskill_audit_exit_code(report, min_catalog_count=1) == 1


def test_weaponskill_audit_failures_report_profiles_without_sets() -> None:
    report = {
        "summary": {
            "catalogCount": 199,
            "profileCount": 27,
            "totalWeaponskillSets": 1000,
            "profilesWithoutWeaponskillSets": 2,
        },
    }

    assert weaponskill_audit_failures(report, max_profiles_without_weaponskill_sets=0) == (
        "profilesWithoutWeaponskillSets 2 exceeds max 0",
    )


def test_weaponskill_console_payload_can_be_compact() -> None:
    report = {
        "summary": {
            "catalogCount": 199,
            "profileCount": 27,
            "totalWeaponskillSets": 1000,
        },
        "profiles": [{"job": "WAR"}],
    }

    assert weaponskill_console_payload(report, compact=True) == {
        "summary": {
            "catalogCount": 199,
            "profileCount": 27,
            "totalWeaponskillSets": 1000,
        },
    }
