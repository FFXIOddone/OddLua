from pathlib import Path
import hashlib
import json
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.live_reconciliation import (
    classify_reconciliation_lifecycle,
    derive_reconciliation_report_path,
    format_reconciliation_markdown,
    main,
    summarize_reconciliation_log,
    write_reconciliation_report,
)


def _lifecycle_signature() -> dict[str, object]:
    return {
        "player": "Oddone",
        "playerId": "29938",
        "job": "RDM",
        "set": "Cure",
        "playstyle": "Caster",
        "intent": "Cure",
        "expected": {"Main": "Chatoyant Staff", "Sub": "Omni Grip"},
    }


def test_lifecycle_classifier_resolves_current_direct_repair_chain() -> None:
    signature = _lifecycle_signature()
    rows = [
        {
            **signature,
            "sequence": 10,
            "repairAttempt": 0,
            "status": "mismatch",
            "repair": False,
            "repairQueued": True,
            "repairStrategy": "direct",
        },
        {
            **signature,
            "sequence": 11,
            "repairAttempt": 1,
            "status": "mismatch",
            "repair": True,
            "repairQueued": True,
            "repairStrategy": "direct",
        },
        {
            **signature,
            "sequence": 12,
            "repairAttempt": 2,
            "status": "match",
            "repair": True,
            "repairQueued": False,
        },
    ]

    lifecycle = classify_reconciliation_lifecycle(rows)

    assert lifecycle.raw_match_count == 1
    assert lifecycle.raw_mismatch_count == 2
    assert lifecycle.raw_repair_queued_count == 2
    assert lifecycle.resolved_queued_repair_count == 2
    assert lifecycle.terminal_repair_failure_count == 0
    assert [row.outcome for row in lifecycle.rows] == [
        "resolved_queued_repair",
        "resolved_queued_repair",
        "match",
    ]
    assert [row.resolved_by_row_index for row in lifecycle.rows[:2]] == [3, 3]
    assert [row.key.repair_cycle_sequence for row in lifecycle.rows] == [10, 10, 10]


def test_lifecycle_classifier_prefers_explicit_cycle_for_observation_only_settle() -> None:
    signature = _lifecycle_signature()
    rows = [
        {
            **signature,
            "sequence": 10,
            "repairAttempt": 0,
            "cycleSequence": 7,
            "buildToken": "build-alias",
            "status": "mismatch",
            "repair": False,
            "repairQueued": True,
            "repairStrategy": "direct",
        },
        {
            **signature,
            "sequence": 11,
            "repairAttempt": 1,
            "repairCycleSequence": "7",
            "buildToken": "build-alias",
            "status": "mismatch",
            "repair": True,
            "repairQueued": True,
            "repairStrategy": "direct",
        },
        {
            **signature,
            "sequence": 13,
            "repairAttempt": 2,
            "cycleSequence": 7,
            "buildToken": "build-alias",
            "observationOnly": True,
            "status": "match",
            "repair": True,
            "repairQueued": False,
        },
    ]

    lifecycle = classify_reconciliation_lifecycle(rows)

    assert lifecycle.resolved_queued_repair_count == 2
    assert lifecycle.unresolved_queued_repair_count == 0
    assert [row.key.repair_cycle_sequence for row in lifecycle.rows] == [7, 7, 7]
    assert [row.key.profile_build_token for row in lifecycle.rows] == [
        "BUILD-ALIAS",
        "BUILD-ALIAS",
        "BUILD-ALIAS",
    ]
    assert [row.resolved_by_row_index for row in lifecycle.rows[:2]] == [3, 3]


def test_lifecycle_classifier_does_not_cross_sequence_reset() -> None:
    signature = _lifecycle_signature()
    lifecycle = classify_reconciliation_lifecycle(
        [
            {
                **signature,
                "sequence": 10,
                "status": "mismatch",
                "repair": False,
                "repairQueued": True,
            },
            {
                **signature,
                "sequence": 1,
                "status": "match",
                "repair": False,
                "repairQueued": False,
            },
        ]
    )

    assert lifecycle.load_cycle_count == 2
    assert lifecycle.unresolved_queued_repair_count == 1
    assert lifecycle.rows[0].resolved_by_row_index is None


def test_lifecycle_classifier_does_not_cross_profile_build() -> None:
    signature = _lifecycle_signature()
    lifecycle = classify_reconciliation_lifecycle(
        [
            {
                **signature,
                "sequence": 10,
                "profileBuildToken": "build-a",
                "status": "mismatch",
                "repair": False,
                "repairQueued": True,
            },
            {
                **signature,
                "sequence": 11,
                "profileBuildToken": "build-b",
                "status": "match",
                "repair": False,
                "repairQueued": False,
            },
        ]
    )

    assert lifecycle.load_cycle_count == 2
    assert lifecycle.unresolved_queued_repair_count == 1
    assert lifecycle.rows[0].key.profile_build_token == "BUILD-A"
    assert lifecycle.rows[1].key.profile_build_token == "BUILD-B"


def test_lifecycle_classifier_resolves_only_the_same_action() -> None:
    signature = _lifecycle_signature()
    lifecycle = classify_reconciliation_lifecycle(
        [
            {
                **signature,
                "sequence": 1,
                "status": "mismatch",
                "repair": False,
                "repairQueued": False,
                "actionProbeSequence": " cast-1 ",
            },
            {
                **signature,
                "sequence": 2,
                "status": "match",
                "repair": False,
                "repairQueued": False,
                "actionSequence": "cast-1",
            },
            {
                **signature,
                "sequence": 3,
                "status": "mismatch",
                "repair": False,
                "repairQueued": False,
                "actionProbeSequence": "cast-2",
            },
            {
                **signature,
                "sequence": 4,
                "status": "match",
                "repair": False,
                "repairQueued": False,
                "actionProbeSequence": "cast-3",
            },
        ]
    )

    assert lifecycle.resolved_transient_mismatch_count == 1
    assert lifecycle.unrepaired_mismatch_count == 1
    assert lifecycle.rows[0].outcome == "resolved_transient_mismatch"
    assert lifecycle.rows[0].resolved_by_row_index == 2
    assert lifecycle.rows[2].outcome == "unrepaired_mismatch"


def test_lifecycle_classifier_keeps_explicit_failure_terminal() -> None:
    signature = _lifecycle_signature()
    lifecycle = classify_reconciliation_lifecycle(
        [
            {
                **signature,
                "status": "mismatch",
                "repair": True,
                "repairQueued": True,
                "repairFailed": True,
                "actionProbeSequence": "cast-1",
            },
            {
                **signature,
                "status": "match",
                "repair": True,
                "repairQueued": False,
                "actionSequence": "cast-1",
            },
        ]
    )

    assert lifecycle.raw_repair_queued_count == 1
    assert lifecycle.resolved_queued_repair_count == 0
    assert lifecycle.terminal_repair_failure_count == 1
    assert lifecycle.rows[0].outcome == "terminal_repair_failure"
    assert lifecycle.rows[0].terminal_source == "explicit"


def test_summarize_reconciliation_log_groups_mismatches_by_set_and_slot(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    rows = [
        {
            "schema": "oddlua.reconcile.v1",
            "player": "Tester",
            "job": "WAR",
            "set": "Damage",
            "status": "match",
            "mismatches": [],
        },
        {
            "schema": "oddlua.reconcile.v1",
            "player": "Tester",
            "job": "WAR",
            "set": "Damage",
            "status": "mismatch",
            "mismatches": [
                {"slot": "Body", "expected": "Haubergeon", "observed": "Scale Mail"},
                {"slot": "Hands", "expected": "Dusk Gloves", "observed": ""},
            ],
        },
        {
            "schema": "oddlua.reconcile.v1",
            "player": "Tester",
            "job": "WAR",
            "set": "Idle",
            "status": "unknown_observation",
            "reason": "gData.GetEquipment unavailable",
            "mismatches": [],
        },
    ]
    log_path.write_text("\n".join(json.dumps(row) for row in rows), encoding="utf-8")

    summary = summarize_reconciliation_log(log_path)

    assert summary.total_count == 3
    assert summary.match_count == 1
    assert summary.mismatch_count == 1
    assert summary.unknown_count == 1
    assert summary.players == ("Tester",)
    assert summary.jobs == ("WAR",)
    assert summary.set_counts["Damage"].mismatch_count == 1
    assert summary.slot_mismatches["Body"][("Haubergeon", "Scale Mail")] == 1
    assert summary.slot_mismatches["Hands"][("Dusk Gloves", "")] == 1
    assert summary.unknown_reasons["gData.GetEquipment unavailable"] == 1

    markdown = format_reconciliation_markdown(summary)

    assert "# OddLua Live Reconciliation Report" in markdown
    assert "- players: Tester" in markdown
    assert "- jobs: WAR" in markdown
    assert "Damage: total 2, matches 1, mismatches 1, unknown 0" in markdown
    assert "Body: expected `Haubergeon`, observed `Scale Mail` - 1" in markdown
    assert "gData.GetEquipment unavailable - 1" in markdown


def test_write_reconciliation_report_creates_markdown_file(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    log_path.write_text(
        json.dumps(
            {
                "schema": "oddlua.reconcile.v1",
                "set": "Damage",
                "status": "mismatch",
                "mismatches": [{"slot": "Body", "expected": "Haubergeon", "observed": "Scale Mail"}],
            }
        ),
        encoding="utf-8",
    )
    report_path = tmp_path / "reconciliation.md"

    written = write_reconciliation_report(log_path, report_path)

    assert written == report_path
    assert report_path.read_text(encoding="utf-8").startswith("# OddLua Live Reconciliation Report")
    assert "Body: expected `Haubergeon`, observed `Scale Mail` - 1" in report_path.read_text(encoding="utf-8")


def test_write_reconciliation_report_can_record_profile_hash_metadata(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    generated = tmp_path / "dist" / "packs" / "Player_1" / "RDM" / "RDM.lua"
    installed = tmp_path / "install" / "Player_1" / "RDM.lua"
    report_path = tmp_path / "reconciliation.md"
    log_path.write_text(
        json.dumps(
            {
                "schema": "oddlua.reconcile.v1",
                "player": "Player",
                "playerId": "1",
                "job": "RDM",
                "set": "Idle",
                "status": "match",
            }
        ),
        encoding="utf-8",
    )
    generated.parent.mkdir(parents=True)
    installed.parent.mkdir(parents=True)
    generated.write_text("local sets = {}\n", encoding="utf-8")
    installed.write_text(generated.read_text(encoding="utf-8"), encoding="utf-8")

    write_reconciliation_report(
        log_path,
        report_path,
        generated_profile=generated,
        installed_profile=installed,
    )

    expected_sha = hashlib.sha256(generated.read_bytes()).hexdigest().upper()
    markdown = report_path.read_text(encoding="utf-8")
    assert f"- generatedProfilePath: {generated}" in markdown
    assert f"- generatedProfileSha256: {expected_sha}" in markdown
    assert f"- installedProfilePath: {installed}" in markdown
    assert f"- installedProfileSha256: {expected_sha}" in markdown
    assert "- generatedInstalledHashParity: true" in markdown


def test_write_reconciliation_report_rejects_empty_log_by_default(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    report_path = tmp_path / "reconciliation.md"
    log_path.write_text("", encoding="utf-8")

    try:
        write_reconciliation_report(log_path, report_path)
    except ValueError as exc:
        assert "no reconciliation snapshots found" in str(exc)
    else:
        raise AssertionError("Expected empty reconciliation log to fail")

    assert not report_path.exists()


def test_write_reconciliation_report_can_allow_empty_log(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    report_path = tmp_path / "reconciliation.md"
    log_path.write_text("", encoding="utf-8")

    written = write_reconciliation_report(log_path, report_path, allow_empty=True)

    assert written == report_path
    assert "Total snapshots: 0" in report_path.read_text(encoding="utf-8")


def test_write_reconciliation_report_rejects_mixed_profile_identity(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile-mixed.jsonl"
    report_path = tmp_path / "reconciliation.md"
    log_path.write_text(
        "\n".join(
            (
                json.dumps(
                    {
                        "schema": "oddlua.reconcile.v1",
                        "player": "Oddone",
                        "playerId": "29938",
                        "job": "BRD",
                        "set": "Idle",
                        "status": "match",
                    }
                ),
                json.dumps(
                    {
                        "schema": "oddlua.reconcile.v1",
                        "player": "Oddone",
                        "playerId": "29938",
                        "job": "SMN",
                        "set": "Idle",
                        "status": "match",
                    }
                ),
            )
        ),
        encoding="utf-8",
    )

    try:
        write_reconciliation_report(log_path, report_path)
    except ValueError as exc:
        assert "mixed reconciliation identities found" in str(exc)
    else:
        raise AssertionError("Expected mixed reconciliation identity to fail")

    assert not report_path.exists()


def test_derive_reconciliation_report_path_uses_profile_identity_and_log_mtime(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile-Oddone_29938-RDM.jsonl"
    output_root = tmp_path / "reports"
    log_path.write_text(
        "\n".join(
            (
                json.dumps(
                    {
                        "schema": "oddlua.reconcile.v1",
                        "player": "Oddone",
                        "playerId": "29938",
                        "job": "RDM",
                        "set": "Idle",
                        "status": "match",
                    }
                ),
                json.dumps(
                    {
                        "schema": "oddlua.reconcile.v1",
                        "player": "Oddone",
                        "playerId": "29938",
                        "job": "RDM",
                        "set": "TP",
                        "status": "match",
                    }
                ),
            )
        ),
        encoding="utf-8",
    )
    mtime = 1
    import os

    os.utime(log_path, (mtime, mtime))

    report_path = derive_reconciliation_report_path(log_path, output_root)

    assert report_path == output_root / "Oddone_29938-RDM-19700101-000001.md"


def test_derive_reconciliation_report_path_falls_back_to_log_name_identity(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile-Pleasebanme_48997-SAM.jsonl"
    output_root = tmp_path / "reports"
    log_path.write_text(
        json.dumps(
            {
                "schema": "oddlua.reconcile.v1",
                "set": "TP",
                "status": "match",
            }
        ),
        encoding="utf-8",
    )

    report_path = derive_reconciliation_report_path(log_path, output_root, timestamp="manual")

    assert report_path == output_root / "Pleasebanme_48997-SAM-manual.md"


def test_summarize_reconciliation_log_separates_repair_outcomes(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    rows = [
        {
            "schema": "oddlua.reconcile.v1",
            "set": "Playstyle_Enspell",
            "status": "mismatch",
            "repairQueued": True,
            "repair": False,
            "mismatches": [{"slot": "Back", "expected": "Grapevine Cape", "observed": "Oneiros Cape"}],
        },
        {
            "schema": "oddlua.reconcile.v1",
            "set": "Playstyle_Enspell",
            "status": "match",
            "repairQueued": False,
            "repair": True,
            "mismatches": [],
        },
        {
            "schema": "oddlua.reconcile.v1",
            "set": "Aftercast",
            "status": "mismatch",
            "repairQueued": False,
            "repair": True,
            "mismatches": [{"slot": "Body", "expected": "Ryl.Kgt. Chainmail", "observed": ""}],
        },
        {
            "schema": "oddlua.reconcile.v1",
            "set": "Cure",
            "status": "mismatch",
            "repairQueued": False,
            "repair": False,
            "mismatches": [{"slot": "Ring2", "expected": "Aqua Ring", "observed": "Leather Ring"}],
        },
    ]
    log_path.write_text("\n".join(json.dumps(row) for row in rows), encoding="utf-8")

    summary = summarize_reconciliation_log(log_path)

    assert summary.repair_queued_count == 1
    assert summary.repair_failed_count == 1
    assert summary.unrepaired_mismatch_count == 1
    assert summary.set_counts["Playstyle_Enspell"].repair_queued_count == 1
    assert summary.set_counts["Aftercast"].repair_failed_count == 1
    assert summary.set_counts["Cure"].unrepaired_mismatch_count == 1
    assert summary.lifecycle.resolved_queued_repair_count == 1
    assert summary.lifecycle.terminal_repair_failure_count == 1
    assert summary.lifecycle.unrepaired_mismatch_count == 1

    markdown = format_reconciliation_markdown(summary)

    assert "queued repairs 1; repair verification failures 1; unrepaired mismatches 1" in markdown
    assert "resolved queued repairs 1; resolved transient mismatches 0" in markdown
    assert "Playstyle_Enspell: total 2, matches 1, mismatches 1, unknown 0, queued repairs 1" in markdown


def test_summarize_reconciliation_log_surfaces_alias_backed_raw_differences(tmp_path: Path) -> None:
    log_path = tmp_path / "oddlua-reconcile-Oddone_29938-RDM.jsonl"
    log_path.write_text(
        json.dumps(
            {
                "schema": "oddlua.reconcile.v1",
                "player": "Oddone",
                "playerId": "29938",
                "job": "RDM",
                "set": "Cure",
                "status": "match",
                "expected": {"Main": "Chatoyant Staff", "Sub": "Omni Grip"},
                "observed": {"Main": "Chatoyant Staff", "Sub": "Thrace Strap"},
                "mismatches": [],
            }
        ),
        encoding="utf-8",
    )

    summary = summarize_reconciliation_log(log_path)

    assert summary.match_count == 1
    assert summary.mismatch_count == 0
    assert summary.unrepaired_mismatch_count == 0
    assert summary.set_counts["Cure"].mismatch_count == 0
    assert summary.raw_equipment_differences["Sub"][("Omni Grip", "Thrace Strap")] == 1

    markdown = format_reconciliation_markdown(summary)

    assert "## Alias-Matched Raw Equipment Differences" in markdown
    assert "Sub: expected `Omni Grip`, observed `Thrace Strap` - 1" in markdown


def test_live_reconciliation_cli_writes_report(tmp_path: Path, capsys) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    report_path = tmp_path / "reconciliation.md"
    log_path.write_text(
        json.dumps(
            {
                "schema": "oddlua.reconcile.v1",
                "set": "Idle",
                "status": "match",
                "mismatches": [],
            }
        ),
        encoding="utf-8",
    )

    exit_code = main([str(log_path), "--output", str(report_path)])

    assert exit_code == 0
    assert report_path.exists()
    assert str(report_path) in capsys.readouterr().out


def test_live_reconciliation_cli_rejects_empty_log_by_default(tmp_path: Path, capsys) -> None:
    log_path = tmp_path / "oddlua-reconcile.jsonl"
    report_path = tmp_path / "reconciliation.md"
    log_path.write_text("", encoding="utf-8")

    exit_code = main([str(log_path), "--output", str(report_path)])

    assert exit_code == 1
    assert not report_path.exists()
    assert "no reconciliation snapshots found" in capsys.readouterr().err


def test_live_reconciliation_cli_rejects_mixed_profile_identity(tmp_path: Path, capsys) -> None:
    log_path = tmp_path / "oddlua-reconcile-mixed.jsonl"
    log_path.write_text(
        "\n".join(
            (
                json.dumps({"player": "Oddone", "playerId": "29938", "job": "BRD", "status": "match"}),
                json.dumps({"player": "Oddone", "playerId": "29938", "job": "SMN", "status": "match"}),
            )
        ),
        encoding="utf-8",
    )

    exit_code = main([str(log_path)])

    assert exit_code == 1
    assert "mixed reconciliation identities found" in capsys.readouterr().err


def test_live_reconciliation_cli_writes_auto_named_report(tmp_path: Path, capsys) -> None:
    log_path = tmp_path / "oddlua-reconcile-Oddone_29938-BRD.jsonl"
    output_root = tmp_path / "reports"
    log_path.write_text(
        json.dumps(
            {
                "schema": "oddlua.reconcile.v1",
                "player": "Oddone",
                "playerId": "29938",
                "job": "BRD",
                "set": "Idle",
                "status": "match",
                "mismatches": [],
            }
        ),
        encoding="utf-8",
    )

    exit_code = main([str(log_path), "--output-root", str(output_root), "--timestamp", "nowish"])

    report_path = output_root / "Oddone_29938-BRD-nowish.md"
    assert exit_code == 0
    assert report_path.exists()
    assert str(report_path) in capsys.readouterr().out
