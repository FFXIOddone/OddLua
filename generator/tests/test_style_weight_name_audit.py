from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_style_weight_names import audit_style_weight_names


def test_style_weight_name_audit_accepts_server_and_documented_synthetic_names() -> None:
    report = audit_style_weight_names(
        style_weights={
            "Accuracy": {"ACC": 55},
            "QuickDraw": {"QUICK_DRAW_MACC": 80},
        },
        conditional_style_weights={"Accuracy": {"CRITHITRATE": 50}},
    )

    assert report["failureCount"] == 0
    assert report["unknownWeightNames"] == []


def test_style_weight_name_audit_flags_undocumented_unknown_names() -> None:
    report = audit_style_weight_names(
        style_weights={"Accuracy": {"ACC": 55, "SNAP_SHOT": 35}},
        conditional_style_weights={},
    )

    assert report["failureCount"] == 1
    assert report["unknownWeightNames"] == ["SNAP_SHOT"]
    assert report["failures"] == [
        {
            "weightName": "SNAP_SHOT",
            "styles": ["Accuracy"],
        }
    ]


def test_style_weight_name_audit_respects_explicit_empty_maps() -> None:
    report = audit_style_weight_names(
        style_weights={},
        conditional_style_weights={},
    )

    assert report["failureCount"] == 0
    assert report["unknownWeightNames"] == []


def test_current_style_weight_names_are_documented_or_server_backed() -> None:
    report = audit_style_weight_names()

    assert report["failureCount"] == 0
    assert report["unknownWeightNames"] == []
