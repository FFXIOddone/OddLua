from pathlib import Path
import json
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.live_reconciliation import (
    format_reconciliation_markdown,
    main,
    summarize_reconciliation_log,
    write_reconciliation_report,
)


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
    assert summary.set_counts["Damage"].mismatch_count == 1
    assert summary.slot_mismatches["Body"][("Haubergeon", "Scale Mail")] == 1
    assert summary.slot_mismatches["Hands"][("Dusk Gloves", "")] == 1
    assert summary.unknown_reasons["gData.GetEquipment unavailable"] == 1

    markdown = format_reconciliation_markdown(summary)

    assert "# OddLua Live Reconciliation Report" in markdown
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

    markdown = format_reconciliation_markdown(summary)

    assert "queued repairs 1; repair verification failures 1; unrepaired mismatches 1" in markdown
    assert "Playstyle_Enspell: total 2, matches 1, mismatches 1, unknown 0, queued repairs 1" in markdown


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
