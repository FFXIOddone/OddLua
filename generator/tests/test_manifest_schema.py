from pathlib import Path
import sys

import pytest


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.manifests.schema import ManifestValidationError, validate_profile_manifest


def _minimal_manifest() -> dict[str, object]:
    return {
        "player": "Tester",
        "playerId": "1",
        "job": "RDM",
        "level": 75,
        "defaultPlaystyle": "Accuracy",
        "playstyles": ["Accuracy", "Idle"],
        "sets": {"Accuracy": {"Body": "Scorpion Harness"}},
        "selectedItems": {"Accuracy": {"Body": {"name": "Scorpion Harness"}}},
        "serverItemStats": {"loaded": True, "sourcePath": "data/oddlua_stats.sqlite"},
        "catseyeSnapshot": {"gearPath": "gear.lua", "characterPath": "character.json"},
    }


def test_validate_profile_manifest_accepts_attempt1_shape() -> None:
    manifest = _minimal_manifest()

    validated = validate_profile_manifest(manifest)

    assert validated is manifest


def test_validate_profile_manifest_rejects_missing_required_field() -> None:
    manifest = _minimal_manifest()
    manifest.pop("sets")

    with pytest.raises(ManifestValidationError, match="sets"):
        validate_profile_manifest(manifest)


def test_validate_profile_manifest_rejects_wrong_field_type() -> None:
    manifest = _minimal_manifest()
    manifest["playstyles"] = "Accuracy"

    with pytest.raises(ManifestValidationError, match="playstyles"):
        validate_profile_manifest(manifest)
