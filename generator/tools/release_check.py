from __future__ import annotations

import argparse
from dataclasses import dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys
import time
from typing import Callable


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_REPORT_ROOT = ODDLUA_ROOT / "reports" / "release-check"
MECHANICS_WARNING_TYPE_BUDGETS = {
    "final_hp_pool_lower": 2980,
    "final_mp_pool_lower": 1891,
    "hp_percent_or_conversion_requires_runtime_probe": 615,
    "mp_percent_or_conversion_requires_runtime_probe": 366,
}
MECHANICS_SKIPPED_REASON_BUDGETS = {
    "utility_set": 183,
}
CATSEYE_INCONSISTENCY_FINDING_BUDGETS = {
    "client_name_collision_signatures": 72,
    "unexpected_client_name_collision_signatures": 0,
}
GEAR_AUDIT_FINDING_TAG_BUDGETS = {
    "manual_review_named_effect": 334,
    "manual_review_special_effect": 386,
}
WEAPONSKILL_MIN_CATALOG_COUNT = 190
WEAPONSKILL_MIN_TOTAL_SETS = 1000
MECHANICS_MIN_LOADED_PROFILE_COUNT = 20
MECHANICS_MAX_WARNING_COUNT = 5643
MECHANICS_MAX_SKIPPED_TRANSITIONS = 183


@dataclass(frozen=True)
class ReleaseCheckStep:
    name: str
    argv: list[str]
    cwd: Path


Runner = Callable[[ReleaseCheckStep], int]


def build_release_check_steps(
    root: Path | str = ODDLUA_ROOT,
    *,
    skip_generation: bool = False,
    include_gear_audit: bool = False,
    include_attempt2_foundation: bool = False,
) -> tuple[ReleaseCheckStep, ...]:
    root = Path(root)
    steps = [
        ReleaseCheckStep(
            name="pytest",
            argv=[sys.executable, "-m", "pytest", "-p", "no:cacheprovider", "-q"],
            cwd=root,
        ),
        ReleaseCheckStep(
            name="style-weight-name-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_style_weight_names.py"),
            ],
            cwd=root,
        ),
        ReleaseCheckStep(
            name="oddorg-namespace-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_oddorg_namespace.py"),
                "--root",
                str(root),
            ],
            cwd=root,
        ),
    ]
    if not skip_generation:
        steps.append(
            ReleaseCheckStep(
                name="apply-dry-run",
                argv=[
                    sys.executable,
                    str(root / "apply_all_jobs.py"),
                    "--dry-run",
                    "--output-root",
                    str(root / "dist"),
                    "--stats-db-path",
                    str(root / "data" / "oddlua_stats.sqlite"),
                ],
                cwd=root,
            )
        )
    if include_attempt2_foundation:
        steps.append(
            ReleaseCheckStep(
                name="attempt2-foundation-audit",
                argv=[
                    sys.executable,
                    str(root / "tools" / "audit_attempt2_foundation.py"),
                    "--manifest-root",
                    str(root / "dist" / "packs"),
                ],
                cwd=root,
            )
        )
    steps.extend(
        [
            ReleaseCheckStep(
                name="runtime-ux-audit",
                argv=[
                    sys.executable,
                    str(root / "tools" / "audit_runtime_ux.py"),
                    "--profile-root",
                    str(root / "dist" / "packs"),
                ],
                cwd=root,
            ),
            ReleaseCheckStep(
                name="keybinding-quickstart-audit",
                argv=[
                    sys.executable,
                    str(root / "tools" / "audit_keybinding_quickstart.py"),
                    "--sidecar-root",
                    str(root / "dist" / "packs"),
                ],
                cwd=root,
            ),
        ]
    )
    steps.append(
        ReleaseCheckStep(
            name="weaponskill-coverage-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_weaponskill_coverage.py"),
                "--stats-db",
                str(root / "data" / "oddlua_stats.sqlite"),
                "--dist-root",
                str(root / "dist" / "packs"),
                "--compact",
                "--min-catalog-count",
                str(WEAPONSKILL_MIN_CATALOG_COUNT),
                "--min-profile-count",
                "1",
                "--min-total-weaponskill-sets",
                str(WEAPONSKILL_MIN_TOTAL_SETS),
                "--max-profiles-without-weaponskill-sets",
                "0",
            ],
            cwd=root,
        )
    )
    steps.append(
        ReleaseCheckStep(
            name="catseye-equipment-catalog-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_catseye_equipment_catalog.py"),
                "--db-path",
                str(root / "data" / "oddlua_stats.sqlite"),
                "--output-root",
                str(root / "reports" / "catseye-equipment-catalog"),
                "--max-equipment-mismatches",
                "0",
                "--max-weapon-mismatches",
                "0",
            ],
            cwd=root,
        )
    )
    steps.append(
        ReleaseCheckStep(
            name="catseye-equipment-inconsistencies-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_catseye_equipment_inconsistencies.py"),
                "--db-path",
                str(root / "data" / "oddlua_stats.sqlite"),
                "--catseye-wiki-root",
                str(root.parent / "tools-data" / "catseye-wiki-cache"),
                "--fail-on-unbudgeted-findings",
                *_catseye_inconsistency_budget_args(),
            ],
            cwd=root,
        )
    )
    steps.append(
        ReleaseCheckStep(
            name="manifest-item-ambiguity-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_manifest_item_ambiguity.py"),
                "--manifest-root",
                str(root / "dist" / "packs"),
                "--stats-db-path",
                str(root / "data" / "oddlua_stats.sqlite"),
                "--output-root",
                str(root / "reports" / "manifest-item-ambiguity"),
                "--fail-on-findings",
            ],
            cwd=root,
        )
    )
    if include_gear_audit:
        steps.append(
            ReleaseCheckStep(
                name="gear-resolution-audit",
                argv=[
                    sys.executable,
                    str(root / "tools" / "audit_gear_resolution.py"),
                    "--manifest-root",
                    str(root / "dist" / "packs"),
                    "--stats-db-path",
                    str(root / "data" / "oddlua_stats.sqlite"),
                    "--output-root",
                    str(root / "reports" / "gear-audit"),
                    "--compact-json",
                    "--fail-on-status-findings",
                    *_gear_audit_finding_tag_budget_args(),
                ],
                cwd=root,
            )
        )
    steps.extend(
        [
        ReleaseCheckStep(
            name="mechanics-planner-audit",
            argv=[
                sys.executable,
                str(root / "tools" / "audit_mechanics_planner.py"),
                "--no-write",
                "--fail-on-missing",
                "--fail-on-malformed",
                "--fail-on-unloaded",
                "--min-profile-count",
                "1",
                "--min-loaded-profile-count",
                str(MECHANICS_MIN_LOADED_PROFILE_COUNT),
                "--min-planner-version",
                "2",
                "--max-warning-count",
                str(MECHANICS_MAX_WARNING_COUNT),
                "--max-skipped-transition-count",
                str(MECHANICS_MAX_SKIPPED_TRANSITIONS),
                "--compact",
                *_warning_type_budget_args(),
                *_skipped_reason_budget_args(),
            ],
            cwd=root,
        ),
        ReleaseCheckStep(
            name="lua-syntax",
            argv=[
                sys.executable,
                    str(root / "tools" / "check_lua_syntax.py"),
                    "--root",
                    str(root / "dist" / "packs"),
                    "--min-files",
                    "1",
                ],
                cwd=root,
            ),
        ]
    )
    return tuple(steps)


def _warning_type_budget_args() -> list[str]:
    args: list[str] = []
    for warning_type, max_count in MECHANICS_WARNING_TYPE_BUDGETS.items():
        args.extend(("--max-warning-type", f"{warning_type}={max_count}"))
    return args


def _skipped_reason_budget_args() -> list[str]:
    args: list[str] = []
    for skipped_reason, max_count in MECHANICS_SKIPPED_REASON_BUDGETS.items():
        args.extend(("--max-skipped-reason", f"{skipped_reason}={max_count}"))
    return args


def _catseye_inconsistency_budget_args() -> list[str]:
    args: list[str] = []
    for technique, max_count in CATSEYE_INCONSISTENCY_FINDING_BUDGETS.items():
        args.extend(("--max-technique", f"{technique}={max_count}"))
    return args


def _gear_audit_finding_tag_budget_args() -> list[str]:
    args: list[str] = []
    for tag, max_count in GEAR_AUDIT_FINDING_TAG_BUDGETS.items():
        args.extend(("--max-finding-tag", f"{tag}={max_count}"))
    return args


def run_release_checks(
    root: Path | str = ODDLUA_ROOT,
    *,
    runner: Runner | None = None,
    clock: Callable[[], float] | None = None,
    skip_generation: bool = False,
    include_gear_audit: bool = False,
    include_attempt2_foundation: bool = False,
) -> dict[str, object]:
    runner = runner or _run_subprocess
    clock = clock or time.monotonic
    step_reports: list[dict[str, object]] = []
    exit_code = 0
    total_duration = 0.0

    for step in build_release_check_steps(
        root,
        skip_generation=skip_generation,
        include_gear_audit=include_gear_audit,
        include_attempt2_foundation=include_attempt2_foundation,
    ):
        started_at = clock()
        step_exit_code = runner(step)
        duration_seconds = round(clock() - started_at, 3)
        total_duration += duration_seconds
        step_reports.append(
            {
                "name": step.name,
                "argv": step.argv,
                "cwd": str(step.cwd),
                "exitCode": step_exit_code,
                "durationSeconds": duration_seconds,
            }
        )
        if step_exit_code != 0:
            exit_code = step_exit_code
            break

    return {
        "root": str(Path(root)),
        "skipGeneration": skip_generation,
        "includeGearAudit": include_gear_audit,
        "includeAttempt2Foundation": include_attempt2_foundation,
        "exitCode": exit_code,
        "durationSeconds": round(total_duration, 3),
        "steps": step_reports,
    }


def _run_subprocess(step: ReleaseCheckStep) -> int:
    print(f"==> {step.name}", flush=True)
    completed = subprocess.run(step.argv, cwd=step.cwd, check=False)
    return completed.returncode


def _capturing_runner(outputs: dict[str, dict[str, str]]) -> Runner:
    def run(step: ReleaseCheckStep) -> int:
        completed = subprocess.run(
            step.argv,
            cwd=step.cwd,
            capture_output=True,
            text=True,
            check=False,
        )
        outputs[step.name] = {
            "stdout": completed.stdout,
            "stderr": completed.stderr,
        }
        return completed.returncode

    return run


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run OddLua's local release gates in the required order."
    )
    parser.add_argument("--root", default=ODDLUA_ROOT, type=Path)
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--skip-generation", action="store_true")
    parser.add_argument("--include-gear-audit", action="store_true")
    parser.add_argument("--include-attempt2-foundation", action="store_true")
    parser.add_argument("--write-report", action="store_true")
    parser.add_argument("--report-root", default=DEFAULT_REPORT_ROOT, type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    captured_outputs: dict[str, dict[str, str]] = {}
    report = run_release_checks(
        args.root,
        runner=_capturing_runner(captured_outputs) if args.json else None,
        skip_generation=args.skip_generation,
        include_gear_audit=args.include_gear_audit,
        include_attempt2_foundation=args.include_attempt2_foundation,
    )
    if args.json:
        for step in report["steps"]:
            assert isinstance(step, dict)
            step.update(captured_outputs.get(str(step["name"]), {}))
    report_path: Path | None = None
    if args.write_report:
        report_path = _write_release_report(report, report_root=args.report_root)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(
            "Release check: {passed}/{total} steps passed".format(
                passed=sum(1 for step in report["steps"] if step["exitCode"] == 0),  # type: ignore[index]
                total=len(report["steps"]),  # type: ignore[arg-type]
            )
        )
        print(_format_duration_summary(report))
        if report_path is not None:
            print(f"Wrote release report: {report_path}")
    return int(report["exitCode"])


def _write_release_report(
    report: dict[str, object],
    *,
    report_root: Path | str = DEFAULT_REPORT_ROOT,
    timestamp: str | None = None,
) -> Path:
    report_root = Path(report_root)
    report_root.mkdir(parents=True, exist_ok=True)
    timestamp = timestamp or _timestamp()
    report_path = report_root / f"release-check-{timestamp}.json"
    report["reportPath"] = str(report_path)
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True), encoding="utf-8")
    return report_path


def _format_duration_summary(report: dict[str, object]) -> str:
    step_parts: list[str] = []
    steps = report.get("steps")
    if isinstance(steps, list):
        for step in steps:
            if not isinstance(step, dict):
                continue
            step_parts.append(
                "{name}={duration:.2f}s".format(
                    name=step.get("name", ""),
                    duration=float(step.get("durationSeconds", 0.0)),
                )
            )
    return "Durations: total={total:.2f}s; {steps}".format(
        total=float(report.get("durationSeconds", 0.0)),
        steps="; ".join(step_parts) if step_parts else "none",
    )


def _timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")


if __name__ == "__main__":
    raise SystemExit(main())
