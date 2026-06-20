from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.manifests.compatibility import diff_manifest_signatures, manifest_signature


def test_manifest_signature_ignores_source_paths_but_keeps_semantic_plan() -> None:
    manifest = {
        "player": "Tester",
        "playerId": "1",
        "job": "RDM",
        "level": 75,
        "defaultPlaystyle": "Accuracy",
        "playstyles": ["Accuracy"],
        "sets": {"Accuracy": {"Body": "Scorpion Harness"}},
        "selectedItems": {
            "Accuracy": {
                "Body": {
                    "item": {"name": "Scorpion Harness"},
                    "reason": "weighted mods ACC+10",
                }
            }
        },
        "serverItemStats": {"sourcePath": "C:/different/path/oddlua_stats.sqlite"},
        "mechanicsSwapPlanner": {
            "loaded": True,
            "plannerVersion": 2,
            "transitions": {"Accuracy": {"actions": [{"key": "pool_bridge_transition"}]}},
            "skippedTransitions": {"Movement": "utility_set"},
        },
    }

    signature = manifest_signature(manifest)

    assert signature["identity"] == {"player": "Tester", "playerId": "1", "job": "RDM", "level": 75}
    assert signature["setNames"] == ["Accuracy"]
    assert signature["selectedItems"]["Accuracy"]["Body"]["name"] == "Scorpion Harness"
    assert signature["mechanicsSwapPlanner"] == {
        "loaded": True,
        "plannerVersion": 2,
        "transitionCount": 1,
        "skippedTransitionCount": 1,
    }
    assert "serverItemStats" not in signature


def test_diff_manifest_signatures_reports_changed_values() -> None:
    left = {"identity": {"job": "RDM"}, "setNames": ["Accuracy"]}
    right = {"identity": {"job": "THF"}, "setNames": ["Accuracy", "Treasure"]}

    assert diff_manifest_signatures(left, right) == [
        "identity differs",
        "setNames differs",
    ]
