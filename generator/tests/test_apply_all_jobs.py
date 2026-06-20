from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from apply_all_jobs import (
    _add_mechanics_planner_summary,
    _apply_common_runtime_assets,
    _format_mechanics_summary,
    _mechanics_planner_report,
)


def test_apply_common_runtime_assets_copies_conditionals_helper(tmp_path: Path) -> None:
    runtime_root = tmp_path / "runtime"
    source = runtime_root / "luashitacast" / "common" / "conditionals.lua"
    source.parent.mkdir(parents=True)
    source.write_text("local conditionals = {}\nreturn conditionals;\n", encoding="utf-8")

    target_root = tmp_path / "luashitacast"
    reports = _apply_common_runtime_assets(
        luashitacast_root=target_root,
        backup_batch_root=tmp_path / "backups",
        runtime_root=runtime_root,
        dry_run=False,
    )

    target = target_root / "common" / "conditionals.lua"
    assert target.read_text(encoding="utf-8") == source.read_text(encoding="utf-8")
    assert reports == [
        {
            "path": str(target),
            "relativePath": "common\\conditionals.lua",
            "action": "created",
            "existed": False,
            "backupPath": "",
            "sha256Before": "",
            "sha256Source": reports[0]["sha256Source"],
            "sha256After": reports[0]["sha256Source"],
        }
    ]


def test_mechanics_planner_report_extracts_manifest_counts() -> None:
    report = _mechanics_planner_report(
        {
            "mechanicsSwapPlanner": {
                "loaded": True,
                "plannerVersion": 2,
                "baselineSet": "Aftercast",
                "transitions": {
                    "Nuke": {
                        "warnings": ["final_hp_pool_lower"],
                        "actions": [
                            {"key": "pool_bridge_transition"},
                            {"key": "negative_tick_avoidance"},
                        ],
                    },
                    "Cure": {
                        "warnings": [],
                        "actions": [{"key": "pool_bridge_transition"}],
                    },
                },
                "skippedTransitions": {
                    "Movement": "utility_set",
                },
            }
        }
    )

    assert report == {
        "loaded": True,
        "plannerVersion": 2,
        "baselineSet": "Aftercast",
        "transitionCount": 2,
        "skippedTransitionCount": 1,
        "actionCount": 3,
        "warningCount": 1,
        "poolBridgeActionCount": 2,
        "negativeTickActionCount": 1,
        "warningTypes": {"final_hp_pool_lower": 1},
        "skippedReasons": {"utility_set": 1},
    }


def test_add_mechanics_planner_summary_accumulates_counts() -> None:
    summary = {
        "mechanicsPlannerLoadedJobs": 0,
        "mechanicsPlannerTransitions": 0,
        "mechanicsPlannerSkippedTransitions": 0,
        "mechanicsPlannerWarnings": 0,
        "mechanicsPlannerActions": 0,
        "mechanicsPlannerVersions": {},
        "mechanicsPlannerWarningTypes": {},
        "mechanicsPlannerSkippedReasons": {},
    }

    _add_mechanics_planner_summary(
        summary,
        {
            "loaded": True,
            "transitionCount": 2,
            "skippedTransitionCount": 1,
            "warningCount": 3,
            "actionCount": 4,
            "plannerVersion": 2,
            "warningTypes": {"final_hp_pool_lower": 2, "final_mp_pool_lower": 1},
            "skippedReasons": {"utility_set": 1},
        },
    )
    _add_mechanics_planner_summary(
        summary,
        {
            "loaded": False,
            "transitionCount": 10,
            "skippedTransitionCount": 10,
            "warningCount": 10,
            "actionCount": 10,
            "warningTypes": {"ignored": 10},
            "skippedReasons": {"ignored": 10},
        },
    )

    assert summary == {
        "mechanicsPlannerLoadedJobs": 1,
        "mechanicsPlannerTransitions": 2,
        "mechanicsPlannerSkippedTransitions": 1,
        "mechanicsPlannerWarnings": 3,
        "mechanicsPlannerActions": 4,
        "mechanicsPlannerVersions": {"2": 1},
        "mechanicsPlannerWarningTypes": {"final_hp_pool_lower": 2, "final_mp_pool_lower": 1},
        "mechanicsPlannerSkippedReasons": {"utility_set": 1},
    }


def test_format_mechanics_summary_includes_counts_and_warning_types() -> None:
    assert _format_mechanics_summary(
        {
            "mechanicsPlannerLoadedJobs": 36,
            "mechanicsPlannerTransitions": 3300,
            "mechanicsPlannerSkippedTransitions": 183,
            "mechanicsPlannerWarnings": 5643,
            "mechanicsPlannerVersions": {
                "2": 36,
            },
            "mechanicsPlannerWarningTypes": {
                "final_hp_pool_lower": 2980,
                "mp_percent_or_conversion_requires_runtime_probe": 366,
            },
            "mechanicsPlannerSkippedReasons": {
                "utility_set": 183,
            },
        }
    ) == (
        "Mechanics planner: loaded jobs 36; transitions 3300; skipped 183; warnings 5643; "
        "versions 2=36; "
        "warning types final_hp_pool_lower=2980, mp_percent_or_conversion_requires_runtime_probe=366; "
        "skipped reasons utility_set=183"
    )
