from pathlib import Path
from types import SimpleNamespace
import json
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from release_check import (
    ReleaseCheckStep,
    _capturing_runner,
    _format_duration_summary,
    _run_subprocess,
    _write_release_report,
    build_release_check_steps,
    parse_args,
    run_release_checks,
)


def test_build_release_check_steps_runs_generation_before_generated_artifact_gates(tmp_path: Path) -> None:
    steps = build_release_check_steps(tmp_path)

    assert [step.name for step in steps] == [
        "pytest",
        "style-weight-name-audit",
        "oddorg-namespace-audit",
        "apply-dry-run",
        "runtime-ux-audit",
        "keybinding-quickstart-audit",
        "weaponskill-coverage-audit",
        "catseye-equipment-catalog-audit",
        "catseye-equipment-inconsistencies-audit",
        "manifest-item-ambiguity-audit",
        "mechanics-planner-audit",
        "lua-syntax",
    ]
    assert steps[0].argv[:3] == [sys.executable, "-m", "pytest"]
    assert "-p" in steps[0].argv
    assert "no:cacheprovider" in steps[0].argv
    assert steps[1].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_style_weight_names.py")]
    assert steps[2].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_oddorg_namespace.py")]
    assert steps[3].argv[:2] == [sys.executable, str(tmp_path / "apply_all_jobs.py")]
    assert "--dry-run" in steps[3].argv
    assert steps[4].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_runtime_ux.py")]
    assert str(tmp_path / "dist" / "packs") in steps[4].argv
    assert steps[5].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_keybinding_quickstart.py")]
    assert str(tmp_path / "dist" / "packs") in steps[5].argv
    assert steps[6].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_weaponskill_coverage.py")]
    assert "--compact" in steps[6].argv
    assert _option_values(steps[6].argv, "--min-catalog-count") == ["190"]
    assert _option_values(steps[6].argv, "--min-profile-count") == ["1"]
    assert _option_values(steps[6].argv, "--min-total-weaponskill-sets") == ["1000"]
    assert _option_values(steps[6].argv, "--max-profiles-without-weaponskill-sets") == ["0"]
    assert steps[7].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_catseye_equipment_catalog.py")]
    assert _option_values(steps[7].argv, "--max-equipment-mismatches") == ["0"]
    assert _option_values(steps[7].argv, "--max-weapon-mismatches") == ["0"]
    assert steps[8].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_catseye_equipment_inconsistencies.py")]
    assert _option_values(steps[8].argv, "--db-path") == [str(tmp_path / "data" / "oddlua_stats.sqlite")]
    assert _option_values(steps[8].argv, "--catseye-wiki-root") == [
        str(tmp_path.parent / "tools-data" / "catseye-wiki-cache")
    ]
    assert "--fail-on-unbudgeted-findings" in steps[8].argv
    assert _option_values(steps[8].argv, "--max-technique") == [
        "client_name_collision_signatures=72",
        "unexpected_client_name_collision_signatures=0",
    ]
    assert steps[9].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_manifest_item_ambiguity.py")]
    assert _option_values(steps[9].argv, "--manifest-root") == [str(tmp_path / "dist" / "packs")]
    assert _option_values(steps[9].argv, "--stats-db-path") == [str(tmp_path / "data" / "oddlua_stats.sqlite")]
    assert _option_values(steps[9].argv, "--output-root") == [str(tmp_path / "reports" / "manifest-item-ambiguity")]
    assert "--fail-on-findings" in steps[9].argv
    assert steps[10].argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_mechanics_planner.py")]
    assert "--compact" in steps[10].argv
    assert "--min-profile-count" in steps[10].argv
    assert _option_values(steps[10].argv, "--min-profile-count") == ["1"]
    assert _option_values(steps[10].argv, "--min-loaded-profile-count") == ["20"]
    assert _option_values(steps[10].argv, "--min-planner-version") == ["2"]
    assert _option_values(steps[10].argv, "--max-warning-count") == ["5643"]
    assert _option_values(steps[10].argv, "--max-warning-type") == [
        "final_hp_pool_lower=2980",
        "final_mp_pool_lower=1891",
        "hp_percent_or_conversion_requires_runtime_probe=615",
        "mp_percent_or_conversion_requires_runtime_probe=366",
    ]
    assert _option_values(steps[10].argv, "--max-skipped-transition-count") == ["183"]
    assert _option_values(steps[10].argv, "--max-skipped-reason") == [
        "utility_set=183",
    ]
    assert steps[11].argv[:2] == [sys.executable, str(tmp_path / "tools" / "check_lua_syntax.py")]
    assert _option_values(steps[11].argv, "--min-files") == ["1"]


def test_run_release_checks_stops_on_first_failure(tmp_path: Path) -> None:
    calls: list[str] = []

    def runner(step) -> int:
        calls.append(step.name)
        return 7 if step.name == "apply-dry-run" else 0

    report = run_release_checks(tmp_path, runner=runner)

    assert report["exitCode"] == 7
    assert [step["name"] for step in report["steps"]] == [
        "pytest",
        "style-weight-name-audit",
        "oddorg-namespace-audit",
        "apply-dry-run",
    ]
    assert [step["exitCode"] for step in report["steps"]] == [0, 0, 0, 7]
    assert calls == ["pytest", "style-weight-name-audit", "oddorg-namespace-audit", "apply-dry-run"]


def test_run_release_checks_records_step_durations(tmp_path: Path) -> None:
    calls: list[str] = []
    clock_values = iter([10.0, 10.25, 20.0, 20.5, 30.0, 30.75, 40.0, 41.5])

    def runner(step) -> int:
        calls.append(step.name)
        return 7 if step.name == "apply-dry-run" else 0

    report = run_release_checks(tmp_path, runner=runner, clock=lambda: next(clock_values))

    assert report["exitCode"] == 7
    assert report["durationSeconds"] == 3.0
    assert [step["name"] for step in report["steps"]] == [
        "pytest",
        "style-weight-name-audit",
        "oddorg-namespace-audit",
        "apply-dry-run",
    ]
    assert [step["durationSeconds"] for step in report["steps"]] == [0.25, 0.5, 0.75, 1.5]
    assert calls == ["pytest", "style-weight-name-audit", "oddorg-namespace-audit", "apply-dry-run"]


def test_format_duration_summary_lists_total_and_step_times() -> None:
    assert _format_duration_summary(
        {
            "durationSeconds": 1.75,
            "steps": [
                {"name": "pytest", "durationSeconds": 0.25},
                {"name": "apply-dry-run", "durationSeconds": 1.5},
            ],
        }
    ) == "Durations: total=1.75s; pytest=0.25s; apply-dry-run=1.50s"


def test_build_release_check_steps_can_skip_generation(tmp_path: Path) -> None:
    steps = build_release_check_steps(tmp_path, skip_generation=True)

    assert [step.name for step in steps] == [
        "pytest",
        "style-weight-name-audit",
        "oddorg-namespace-audit",
        "runtime-ux-audit",
        "keybinding-quickstart-audit",
        "weaponskill-coverage-audit",
        "catseye-equipment-catalog-audit",
        "catseye-equipment-inconsistencies-audit",
        "manifest-item-ambiguity-audit",
        "mechanics-planner-audit",
        "lua-syntax",
    ]


def test_build_release_check_steps_can_include_gear_audit(tmp_path: Path) -> None:
    steps = build_release_check_steps(tmp_path, include_gear_audit=True)

    assert [step.name for step in steps] == [
        "pytest",
        "style-weight-name-audit",
        "oddorg-namespace-audit",
        "apply-dry-run",
        "runtime-ux-audit",
        "keybinding-quickstart-audit",
        "weaponskill-coverage-audit",
        "catseye-equipment-catalog-audit",
        "catseye-equipment-inconsistencies-audit",
        "manifest-item-ambiguity-audit",
        "gear-resolution-audit",
        "mechanics-planner-audit",
        "lua-syntax",
    ]
    gear_step = steps[10]
    assert gear_step.argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_gear_resolution.py")]
    assert str(tmp_path / "reports" / "gear-audit") in gear_step.argv
    assert "--fail-on-status-findings" in gear_step.argv
    assert "--compact-json" in gear_step.argv
    assert _option_values(gear_step.argv, "--max-finding-tag") == [
        "manual_review_named_effect=334",
        "manual_review_special_effect=386",
    ]


def test_build_release_check_steps_can_include_attempt2_foundation_gate(tmp_path: Path) -> None:
    steps = build_release_check_steps(tmp_path, skip_generation=True, include_attempt2_foundation=True)

    assert [step.name for step in steps] == [
        "pytest",
        "style-weight-name-audit",
        "oddorg-namespace-audit",
        "attempt2-foundation-audit",
        "runtime-ux-audit",
        "keybinding-quickstart-audit",
        "weaponskill-coverage-audit",
        "catseye-equipment-catalog-audit",
        "catseye-equipment-inconsistencies-audit",
        "manifest-item-ambiguity-audit",
        "mechanics-planner-audit",
        "lua-syntax",
    ]
    foundation_step = steps[3]
    assert foundation_step.argv[:2] == [sys.executable, str(tmp_path / "tools" / "audit_attempt2_foundation.py")]
    assert "--manifest-root" in foundation_step.argv
    assert str(tmp_path / "dist" / "packs") in foundation_step.argv


def test_release_check_cli_accepts_skip_generation(monkeypatch) -> None:
    monkeypatch.setattr(sys, "argv", ["release_check.py", "--skip-generation"])

    args = parse_args()

    assert args.skip_generation is True


def test_release_check_cli_accepts_include_gear_audit(monkeypatch) -> None:
    monkeypatch.setattr(sys, "argv", ["release_check.py", "--include-gear-audit"])

    args = parse_args()

    assert args.include_gear_audit is True


def test_release_check_cli_accepts_include_attempt2_foundation(monkeypatch) -> None:
    monkeypatch.setattr(sys, "argv", ["release_check.py", "--include-attempt2-foundation"])

    args = parse_args()

    assert args.include_attempt2_foundation is True


def test_release_check_cli_accepts_write_report(monkeypatch, tmp_path: Path) -> None:
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "release_check.py",
            "--write-report",
            "--report-root",
            str(tmp_path),
        ],
    )

    args = parse_args()

    assert args.write_report is True
    assert args.report_root == tmp_path


def test_write_release_report_records_report_path(tmp_path: Path) -> None:
    report = {
        "root": "OddLua",
        "exitCode": 0,
        "steps": [
            {"name": "pytest", "exitCode": 0, "durationSeconds": 0.25},
        ],
    }

    path = _write_release_report(report, report_root=tmp_path, timestamp="20260602-000000")

    assert path == tmp_path / "release-check-20260602-000000.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    assert data["reportPath"] == str(path)


def test_subprocess_runner_flushes_step_label_before_running(monkeypatch, tmp_path: Path) -> None:
    events: list[tuple[str, object]] = []

    def fake_print(value: str, *, flush: bool = False) -> None:
        events.append(("print", (value, flush)))

    def fake_run(argv, *, cwd, check):
        events.append(("run", argv))
        return SimpleNamespace(returncode=0)

    monkeypatch.setattr("builtins.print", fake_print)
    monkeypatch.setattr("release_check.subprocess.run", fake_run)

    exit_code = _run_subprocess(ReleaseCheckStep("pytest", ["python", "-m", "pytest"], tmp_path))

    assert exit_code == 0
    assert events == [
        ("print", ("==> pytest", True)),
        ("run", ["python", "-m", "pytest"]),
    ]


def test_capturing_runner_records_step_output(monkeypatch, tmp_path: Path) -> None:
    outputs: dict[str, dict[str, str]] = {}

    def fake_run(argv, *, cwd, capture_output, text, check):
        assert capture_output is True
        assert text is True
        assert check is False
        return SimpleNamespace(returncode=3, stdout="out", stderr="err")

    monkeypatch.setattr("release_check.subprocess.run", fake_run)
    runner = _capturing_runner(outputs)

    exit_code = runner(ReleaseCheckStep("pytest", ["python", "-m", "pytest"], tmp_path))

    assert exit_code == 3
    assert outputs == {
        "pytest": {
            "stdout": "out",
            "stderr": "err",
        },
    }


def _option_values(argv: list[str], option: str) -> list[str]:
    return [
        argv[index + 1]
        for index, value in enumerate(argv[:-1])
        if value == option
    ]
