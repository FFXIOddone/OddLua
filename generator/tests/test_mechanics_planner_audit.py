from pathlib import Path
import json
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from oddlua.mechanics_planner_audit import (
    audit_mechanics_planner_manifests,
    mechanics_planner_console_payload,
    parse_warning_type_limits,
    planner_audit_failures,
    planner_audit_exit_code,
)
from audit_mechanics_planner import main, parse_args


def test_mechanics_planner_audit_counts_loaded_profiles_actions_and_warnings(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
                "mechanicsSwapPlanner": {
                    "plannerVersion": 2,
                    "loaded": True,
                    "baselineSet": "Aftercast",
                    "skippedTransitions": {
                        "Crafting": "utility_set",
                    },
                    "transitions": {
                    "Nuke": {
                        "warnings": ["final_hp_pool_lower"],
                        "actions": [
                            {"key": "pool_bridge_transition", "phase": "equip_pool_gain", "slot": "Ring1"},
                            {"key": "pool_bridge_transition", "phase": "equip_pool_loss", "slot": "Body"},
                        ],
                    },
                    "Idle": {
                        "warnings": [],
                        "actions": [
                            {"key": "negative_tick_avoidance", "phase": "remove_before_tick", "slot": "Main"},
                        ],
                    },
                },
            },
        },
    )

    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert result.summary["profile_count"] == 1
    assert result.summary["loaded_profile_count"] == 1
    assert result.summary["transition_count"] == 2
    assert result.summary["warning_count"] == 1
    assert result.summary["action_count"] == 3
    assert result.summary["pool_bridge_action_count"] == 2
    assert result.summary["negative_tick_action_count"] == 1
    assert result.summary["skipped_transition_count"] == 1
    assert result.planner_versions == {"2": 1}
    assert result.skipped_reasons["utility_set"] == 1
    assert result.warning_types["final_hp_pool_lower"] == 1
    assert result.profiles[0].skipped_transition_count == 1
    assert result.profiles[0].planner_version == 2
    assert result.profiles[0].top_warning_sets == ("Nuke",)


def test_mechanics_planner_audit_tolerates_missing_and_malformed_planner_blocks(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Aahtacos_30102" / "THF" / "manifest.json",
        {"player": "Aahtacos", "playerId": "30102", "job": "THF"},
    )
    _write_manifest(
        manifest_root / "Aahtacos_30102" / "SAM" / "manifest.json",
        {
            "player": "Aahtacos",
            "playerId": "30102",
            "job": "SAM",
            "mechanicsSwapPlanner": ["not", "a", "dict"],
        },
    )

    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert result.summary["profile_count"] == 2
    assert result.summary["loaded_profile_count"] == 0
    assert result.summary["malformed_profile_count"] == 1
    assert result.summary["missing_profile_count"] == 1
    statuses = {profile.job: profile.status for profile in result.profiles}
    assert statuses == {"THF": "missing", "SAM": "malformed"}


def test_mechanics_planner_audit_writes_json_and_markdown(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
                "mechanicsSwapPlanner": {
                    "loaded": True,
                    "baselineSet": "Aftercast",
                    "skippedTransitions": {"Crafting": "utility_set"},
                    "transitions": {
                        "Nuke": {"warnings": ["final_hp_pool_lower"], "actions": []},
                    },
                },
        },
    )

    result = audit_mechanics_planner_manifests(
        manifest_root=manifest_root,
        output_root=tmp_path / "reports",
        write_files=True,
    )

    assert result.output_dir is not None
    assert result.json_path is not None
    assert result.markdown_path is not None
    assert result.json_path.exists()
    assert result.markdown_path.exists()
    data = json.loads(result.json_path.read_text(encoding="utf-8"))
    assert data["summary"]["profile_count"] == 1
    assert data["summary"]["skipped_transition_count"] == 1
    assert data["plannerVersions"] == {"0": 1}
    assert data["skippedReasons"] == {"utility_set": 1}
    assert data["warningTypes"] == {"final_hp_pool_lower": 1}
    markdown = result.markdown_path.read_text(encoding="utf-8")
    assert "Oddone" in markdown
    assert "## Warning Type Top Profiles" in markdown
    assert "`final_hp_pool_lower`: Oddone_29938 RDM=1" in markdown


def test_mechanics_planner_console_payload_includes_warning_and_skip_totals(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "skippedTransitions": {"Movement": "utility_set"},
                "transitions": {
                    "Nuke": {"warnings": ["final_hp_pool_lower"], "actions": []},
                },
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert mechanics_planner_console_payload(result) == {
        "summary": result.summary,
        "plannerVersions": {"0": 1},
        "warningTypes": {"final_hp_pool_lower": 1},
        "skippedReasons": {"utility_set": 1},
        "warningTypeTopProfiles": {
            "final_hp_pool_lower": [
                {"profile": "Oddone_29938 RDM", "count": 1},
            ],
        },
    }


def test_mechanics_planner_console_payload_ranks_warning_profiles_by_type(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {"warnings": ["final_hp_pool_lower"], "actions": []},
                },
            },
        },
    )
    _write_manifest(
        manifest_root / "Aahtacos_30102" / "MNK" / "manifest.json",
        {
            "player": "Aahtacos",
            "playerId": "30102",
            "job": "MNK",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Damage": {"warnings": ["final_hp_pool_lower"], "actions": []},
                    "Accuracy": {"warnings": ["final_hp_pool_lower", "final_mp_pool_lower"], "actions": []},
                },
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    payload = mechanics_planner_console_payload(result)

    assert payload["warningTypeTopProfiles"]["final_hp_pool_lower"] == [
        {"profile": "Aahtacos_30102 MNK", "count": 2},
        {"profile": "Oddone_29938 RDM", "count": 1},
    ]
    assert payload["warningTypeTopProfiles"]["final_mp_pool_lower"] == [
        {"profile": "Aahtacos_30102 MNK", "count": 1},
    ]


def test_mechanics_planner_console_payload_can_omit_top_profiles(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {"warnings": ["final_hp_pool_lower"], "actions": []},
                },
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    payload = mechanics_planner_console_payload(result, include_top_profiles=False)

    assert "warningTypeTopProfiles" not in payload


def test_planner_audit_gate_fails_on_missing_or_malformed_when_enabled(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Aahtacos_30102" / "THF" / "manifest.json",
        {"player": "Aahtacos", "playerId": "30102", "job": "THF"},
    )
    _write_manifest(
        manifest_root / "Aahtacos_30102" / "SAM" / "manifest.json",
        {
            "player": "Aahtacos",
            "playerId": "30102",
            "job": "SAM",
            "mechanicsSwapPlanner": ["bad"],
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result) == 0
    assert planner_audit_exit_code(result, fail_on_missing=True) == 1
    assert planner_audit_exit_code(result, fail_on_malformed=True) == 1


def test_planner_audit_gate_fails_when_warning_count_exceeds_limit(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {"warnings": ["final_hp_pool_lower"], "actions": []},
                },
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result, max_warning_count=1) == 0
    assert planner_audit_exit_code(result, max_warning_count=0) == 1


def test_planner_audit_gate_fails_when_profile_count_below_minimum(tmp_path: Path) -> None:
    result = audit_mechanics_planner_manifests(manifest_root=tmp_path / "packs", write_files=False)

    assert planner_audit_exit_code(result) == 0
    assert planner_audit_exit_code(result, min_profile_count=1) == 1
    assert planner_audit_failures(result, min_profile_count=1) == (
        "profile_count 0 below min 1",
    )


def test_planner_audit_gate_fails_when_loaded_profile_count_below_minimum(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {},
            },
        },
    )
    _write_manifest(
        manifest_root / "Oddone_29938" / "THF" / "manifest.json",
        {"player": "Oddone", "playerId": "29938", "job": "THF"},
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result, min_loaded_profile_count=1) == 0
    assert planner_audit_exit_code(result, min_loaded_profile_count=2) == 1
    assert planner_audit_failures(result, min_loaded_profile_count=2) == (
        "loaded_profile_count 1 below min 2",
    )


def test_planner_audit_gate_fails_when_planner_version_below_minimum(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "plannerVersion": 1,
                "baselineSet": "Aftercast",
                "transitions": {},
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result, min_planner_version=2) == 1
    assert planner_audit_failures(result, min_planner_version=2) == (
        "plannerVersion below min 2: 1 profiles",
    )


def test_planner_audit_gate_fails_when_warning_type_exceeds_limit(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {
                        "warnings": ["final_hp_pool_lower", "final_hp_pool_lower", "final_mp_pool_lower"],
                        "actions": [],
                    },
                },
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result, max_warning_types={"final_hp_pool_lower": 2}) == 0
    assert planner_audit_exit_code(result, max_warning_types={"final_hp_pool_lower": 1}) == 1
    assert planner_audit_exit_code(result, max_warning_types={"runtime_probe_required": 0}) == 0


def test_planner_audit_gate_fails_when_skipped_transition_count_exceeds_limit(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "skippedTransitions": {
                    "Movement": "utility_set",
                    "Crafting": "utility_set",
                },
                "transitions": {},
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result, max_skipped_transition_count=2) == 0
    assert planner_audit_exit_code(result, max_skipped_transition_count=1) == 1
    assert planner_audit_failures(result, max_skipped_transition_count=1) == (
        "skipped_transition_count 2 exceeds max 1",
    )


def test_planner_audit_gate_fails_when_skipped_reason_exceeds_limit(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "skippedTransitions": {
                    "Movement": "utility_set",
                    "Empty": "empty_set",
                },
                "transitions": {},
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_exit_code(result, max_skipped_reasons={"utility_set": 1}) == 0
    assert planner_audit_exit_code(result, max_skipped_reasons={"utility_set": 0}) == 1
    assert planner_audit_exit_code(result, max_skipped_reasons={"manual_skip": 0}) == 0


def test_planner_audit_failures_report_specific_failed_gate(tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {"warnings": ["final_hp_pool_lower", "final_hp_pool_lower"], "actions": []},
                },
            },
        },
    )
    result = audit_mechanics_planner_manifests(manifest_root=manifest_root, write_files=False)

    assert planner_audit_failures(
        result,
        max_warning_count=1,
        max_warning_types={"final_hp_pool_lower": 1},
    ) == (
        "warning_count 2 exceeds max 1",
        "warning type final_hp_pool_lower count 2 exceeds max 1",
    )


def test_parse_warning_type_limits_requires_name_equals_count() -> None:
    assert parse_warning_type_limits(("final_hp_pool_lower=12", "runtime_probe_required=0")) == {
        "final_hp_pool_lower": 12,
        "runtime_probe_required": 0,
    }

    try:
        parse_warning_type_limits(("final_hp_pool_lower",))
    except ValueError as exc:
        assert "name=count" in str(exc)
    else:
        raise AssertionError("Expected invalid warning type budget to fail")


def test_audit_cli_accepts_repeated_warning_type_budgets(monkeypatch) -> None:
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "audit_mechanics_planner.py",
            "--max-warning-type",
            "final_hp_pool_lower=2127",
            "--max-warning-type",
            "final_mp_pool_lower=1811",
        ],
    )

    args = parse_args()

    assert args.max_warning_type == ["final_hp_pool_lower=2127", "final_mp_pool_lower=1811"]


def test_audit_cli_accepts_repeated_skipped_reason_budgets(monkeypatch) -> None:
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "audit_mechanics_planner.py",
            "--max-skipped-reason",
            "utility_set=137",
            "--max-skipped-reason",
            "empty_set=2",
        ],
    )

    args = parse_args()

    assert args.max_skipped_reason == ["utility_set=137", "empty_set=2"]


def test_audit_cli_accepts_min_loaded_profile_count(monkeypatch) -> None:
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "audit_mechanics_planner.py",
            "--min-loaded-profile-count",
            "20",
        ],
    )

    args = parse_args()

    assert args.min_loaded_profile_count == 20


def test_audit_cli_prints_gate_failure_details(monkeypatch, capsys, tmp_path: Path) -> None:
    manifest_root = tmp_path / "packs"
    _write_manifest(
        manifest_root / "Oddone_29938" / "RDM" / "manifest.json",
        {
            "player": "Oddone",
            "playerId": "29938",
            "job": "RDM",
            "mechanicsSwapPlanner": {
                "loaded": True,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {"warnings": ["final_hp_pool_lower"], "actions": []},
                },
            },
        },
    )
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "audit_mechanics_planner.py",
            "--manifest-root",
            str(manifest_root),
            "--no-write",
            "--max-warning-type",
            "final_hp_pool_lower=0",
        ],
    )

    exit_code = main()
    captured = capsys.readouterr()

    assert exit_code == 1
    assert "Gate failed: warning type final_hp_pool_lower count 1 exceeds max 0" in captured.err


def _write_manifest(path: Path, data: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data), encoding="utf-8")
