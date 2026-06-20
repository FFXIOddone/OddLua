from __future__ import annotations

from collections.abc import Mapping, Sequence


class ManifestValidationError(ValueError):
    """Raised when a generated profile manifest violates the stable contract."""


_REQUIRED_FIELD_TYPES: dict[str, type | tuple[type, ...]] = {
    "player": str,
    "playerId": str,
    "job": str,
    "level": int,
    "defaultPlaystyle": str,
    "playstyles": list,
    "sets": dict,
    "selectedItems": dict,
    "serverItemStats": dict,
    "catseyeSnapshot": dict,
}


def validate_profile_manifest(manifest: dict[str, object]) -> dict[str, object]:
    """Validate the Attempt 1-compatible profile manifest shape.

    The validator is intentionally additive. It checks the fields current
    renderers and audits rely on, while allowing new Attempt 2 fields.
    """

    if not isinstance(manifest, dict):
        raise ManifestValidationError("manifest must be a dict")

    for field_name, expected_type in _REQUIRED_FIELD_TYPES.items():
        if field_name not in manifest:
            raise ManifestValidationError(f"manifest missing required field: {field_name}")
        value = manifest[field_name]
        if not isinstance(value, expected_type):
            raise ManifestValidationError(
                f"manifest field {field_name} must be {_type_name(expected_type)}"
            )

    _validate_non_empty_string(manifest, "player")
    _validate_non_empty_string(manifest, "playerId")
    _validate_job(manifest["job"])
    _validate_playstyles(manifest["playstyles"], manifest["defaultPlaystyle"])
    _validate_sets(manifest["sets"])
    return manifest


def _validate_non_empty_string(manifest: Mapping[str, object], field_name: str) -> None:
    value = manifest[field_name]
    if not str(value).strip():
        raise ManifestValidationError(f"manifest field {field_name} must not be empty")


def _validate_job(value: object) -> None:
    job = str(value)
    if len(job) != 3 or job.upper() != job:
        raise ManifestValidationError("manifest field job must be a 3-letter uppercase job abbreviation")


def _validate_playstyles(value: object, default_playstyle: object) -> None:
    if not isinstance(value, Sequence) or isinstance(value, (str, bytes)):
        raise ManifestValidationError("manifest field playstyles must be a list of strings")
    playstyles = [str(entry) for entry in value]
    if not playstyles:
        raise ManifestValidationError("manifest field playstyles must not be empty")
    if str(default_playstyle) not in playstyles:
        raise ManifestValidationError("defaultPlaystyle must be present in playstyles")


def _validate_sets(value: object) -> None:
    if not isinstance(value, Mapping):
        raise ManifestValidationError("manifest field sets must be a mapping")
    if not value:
        raise ManifestValidationError("manifest field sets must not be empty")
    for set_name, slots in value.items():
        if not isinstance(set_name, str) or not set_name:
            raise ManifestValidationError("manifest set names must be non-empty strings")
        if not isinstance(slots, Mapping):
            raise ManifestValidationError(f"manifest set {set_name} must be a slot mapping")


def _type_name(expected_type: type | tuple[type, ...]) -> str:
    if isinstance(expected_type, tuple):
        return " or ".join(t.__name__ for t in expected_type)
    return expected_type.__name__
