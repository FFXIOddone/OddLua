from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
from typing import Iterable, Literal


PlannerProfileStatus = Literal["loaded", "missing", "malformed", "unloaded"]


@dataclass(frozen=True)
class MechanicsPlannerProfileAudit:
    manifest_path: str
    player: str
    player_id: str
    job: str
    status: PlannerProfileStatus
    planner_version: int
    baseline_set: str
    transition_count: int
    action_count: int
    warning_count: int
    pool_bridge_action_count: int
    negative_tick_action_count: int
    skipped_transition_count: int
    warning_types: dict[str, int]
    skipped_reasons: dict[str, int]
    top_warning_sets: tuple[str, ...]

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "manifestPath": self.manifest_path,
            "player": self.player,
            "playerId": self.player_id,
            "job": self.job,
            "status": self.status,
            "plannerVersion": self.planner_version,
            "baselineSet": self.baseline_set,
            "transitionCount": self.transition_count,
            "actionCount": self.action_count,
            "warningCount": self.warning_count,
            "poolBridgeActionCount": self.pool_bridge_action_count,
            "negativeTickActionCount": self.negative_tick_action_count,
            "skippedTransitionCount": self.skipped_transition_count,
            "warningTypes": dict(self.warning_types),
            "skippedReasons": dict(self.skipped_reasons),
            "topWarningSets": list(self.top_warning_sets),
        }


@dataclass(frozen=True)
class MechanicsPlannerAuditResult:
    generated_at: str
    manifest_root: str
    summary: dict[str, int]
    planner_versions: dict[str, int]
    warning_types: dict[str, int]
    skipped_reasons: dict[str, int]
    profiles: tuple[MechanicsPlannerProfileAudit, ...]
    output_dir: Path | None = None
    json_path: Path | None = None
    markdown_path: Path | None = None

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "generatedAt": self.generated_at,
            "manifestRoot": self.manifest_root,
            "summary": dict(self.summary),
            "plannerVersions": dict(self.planner_versions),
            "warningTypes": dict(self.warning_types),
            "skippedReasons": dict(self.skipped_reasons),
            "warningTypeTopProfiles": warning_type_top_profiles(self),
            "profiles": [
                profile.manifest_metadata()
                for profile in self.profiles
            ],
        }


def audit_mechanics_planner_manifests(
    *,
    manifest_root: Path | str,
    output_root: Path | str | None = None,
    write_files: bool = True,
) -> MechanicsPlannerAuditResult:
    root = Path(manifest_root)
    profiles = tuple(
        _audit_manifest(manifest_path)
        for manifest_path in sorted(root.glob("*/*/manifest.json"))
    )
    summary = _summary_for_profiles(profiles)
    planner_versions = _planner_versions_for_profiles(profiles)
    warning_types = _warning_types_for_profiles(profiles)
    skipped_reasons = _skipped_reasons_for_profiles(profiles)
    result = MechanicsPlannerAuditResult(
        generated_at=_timestamp(),
        manifest_root=str(root),
        summary=summary,
        planner_versions=planner_versions,
        warning_types=warning_types,
        skipped_reasons=skipped_reasons,
        profiles=profiles,
    )
    if not write_files:
        return result

    report_root = Path(output_root) if output_root is not None else Path("reports") / "mechanics-planner"
    output_dir = _create_unique_output_dir(report_root, _timestamp_for_path())
    json_path = output_dir / "audit.json"
    markdown_path = output_dir / "audit.md"
    json_path.write_text(json.dumps(result.manifest_metadata(), indent=2, sort_keys=True), encoding="utf-8")
    markdown_path.write_text(markdown_report(result), encoding="utf-8")
    return MechanicsPlannerAuditResult(
        generated_at=result.generated_at,
        manifest_root=result.manifest_root,
        summary=result.summary,
        planner_versions=result.planner_versions,
        warning_types=result.warning_types,
        skipped_reasons=result.skipped_reasons,
        profiles=result.profiles,
        output_dir=output_dir,
        json_path=json_path,
        markdown_path=markdown_path,
    )


def markdown_report(result: MechanicsPlannerAuditResult) -> str:
    lines = [
        "# Mechanics Planner Audit",
        "",
        f"- Generated: {result.generated_at}",
        f"- Manifest root: `{result.manifest_root}`",
        f"- Profiles: {result.summary.get('profile_count', 0)}",
        f"- Loaded profiles: {result.summary.get('loaded_profile_count', 0)}",
        f"- Transitions: {result.summary.get('transition_count', 0)}",
        f"- Actions: {result.summary.get('action_count', 0)}",
        f"- Warnings: {result.summary.get('warning_count', 0)}",
        f"- Skipped transitions: {result.summary.get('skipped_transition_count', 0)}",
        f"- Planner versions: {_format_count_map(result.planner_versions)}",
        "",
        "## Warning Types",
        "",
    ]
    if result.warning_types:
        for warning, count in sorted(result.warning_types.items(), key=lambda row: (-row[1], row[0])):
            lines.append(f"- `{warning}`: {count}")
    else:
        lines.append("- None")
    lines.extend([
        "",
        "## Warning Type Top Profiles",
        "",
    ])
    top_profiles = warning_type_top_profiles(result)
    if top_profiles:
        for warning, rows in sorted(top_profiles.items()):
            summary = ", ".join(
                f"{row['profile']}={row['count']}"
                for row in rows
            )
            lines.append(f"- `{warning}`: {summary}")
    else:
        lines.append("- None")
    lines.extend([
        "",
        "## Skipped Reasons",
        "",
    ])
    if result.skipped_reasons:
        for reason, count in sorted(result.skipped_reasons.items(), key=lambda row: (-row[1], row[0])):
            lines.append(f"- `{reason}`: {count}")
    else:
        lines.append("- None")
    lines.extend([
        "",
        "## Profiles",
        "",
    ])
    if not result.profiles:
        lines.append("- None")
    for profile in result.profiles:
        label = f"{profile.player}_{profile.player_id} {profile.job}".strip()
        lines.append(
            f"- **{label}**: {profile.status}; transitions={profile.transition_count}; "
            f"actions={profile.action_count}; warnings={profile.warning_count}; "
            f"skipped={profile.skipped_transition_count}"
        )
        if profile.top_warning_sets:
            lines.append(f"  Warning sets: {', '.join(profile.top_warning_sets)}")
    return "\n".join(lines).rstrip() + "\n"


def mechanics_planner_console_payload(
    result: MechanicsPlannerAuditResult,
    *,
    include_top_profiles: bool = True,
) -> dict[str, object]:
    payload: dict[str, object] = {
        "summary": dict(result.summary),
        "plannerVersions": dict(result.planner_versions),
        "warningTypes": dict(result.warning_types),
        "skippedReasons": dict(result.skipped_reasons),
    }
    if include_top_profiles:
        payload["warningTypeTopProfiles"] = warning_type_top_profiles(result)
    return payload


def warning_type_top_profiles(result: MechanicsPlannerAuditResult, *, limit: int = 10) -> dict[str, list[dict[str, object]]]:
    rows_by_warning: dict[str, list[tuple[int, str]]] = {}
    for profile in result.profiles:
        profile_label = f"{profile.player}_{profile.player_id} {profile.job}".strip()
        for warning_type, count in profile.warning_types.items():
            if count <= 0:
                continue
            rows_by_warning.setdefault(warning_type, []).append((count, profile_label))

    return {
        warning_type: [
            {"profile": profile_label, "count": count}
            for count, profile_label in sorted(rows, key=lambda row: (-row[0], row[1]))[:limit]
        ]
        for warning_type, rows in sorted(rows_by_warning.items())
    }


def planner_audit_exit_code(
    result: MechanicsPlannerAuditResult,
    *,
    fail_on_missing: bool = False,
    fail_on_malformed: bool = False,
    fail_on_unloaded: bool = False,
    min_profile_count: int | None = None,
    min_loaded_profile_count: int | None = None,
    min_planner_version: int | None = None,
    max_warning_count: int | None = None,
    max_warning_types: dict[str, int] | None = None,
    max_skipped_transition_count: int | None = None,
    max_skipped_reasons: dict[str, int] | None = None,
) -> int:
    return 1 if planner_audit_failures(
        result,
        fail_on_missing=fail_on_missing,
        fail_on_malformed=fail_on_malformed,
        fail_on_unloaded=fail_on_unloaded,
        min_profile_count=min_profile_count,
        min_loaded_profile_count=min_loaded_profile_count,
        min_planner_version=min_planner_version,
        max_warning_count=max_warning_count,
        max_warning_types=max_warning_types,
        max_skipped_transition_count=max_skipped_transition_count,
        max_skipped_reasons=max_skipped_reasons,
    ) else 0


def planner_audit_failures(
    result: MechanicsPlannerAuditResult,
    *,
    fail_on_missing: bool = False,
    fail_on_malformed: bool = False,
    fail_on_unloaded: bool = False,
    min_profile_count: int | None = None,
    min_loaded_profile_count: int | None = None,
    min_planner_version: int | None = None,
    max_warning_count: int | None = None,
    max_warning_types: dict[str, int] | None = None,
    max_skipped_transition_count: int | None = None,
    max_skipped_reasons: dict[str, int] | None = None,
) -> tuple[str, ...]:
    summary = result.summary
    failures: list[str] = []
    if min_profile_count is not None and summary.get("profile_count", 0) < min_profile_count:
        failures.append(f"profile_count {summary.get('profile_count', 0)} below min {min_profile_count}")
    if (
        min_loaded_profile_count is not None
        and summary.get("loaded_profile_count", 0) < min_loaded_profile_count
    ):
        failures.append(
            f"loaded_profile_count {summary.get('loaded_profile_count', 0)} below min {min_loaded_profile_count}"
        )
    if min_planner_version is not None:
        below_min_count = sum(
            1
            for profile in result.profiles
            if profile.status == "loaded" and profile.planner_version < min_planner_version
        )
        if below_min_count:
            failures.append(f"plannerVersion below min {min_planner_version}: {below_min_count} profiles")
    if fail_on_missing and summary.get("missing_profile_count", 0) > 0:
        failures.append(f"missing_profile_count {summary.get('missing_profile_count', 0)} exceeds max 0")
    if fail_on_malformed and summary.get("malformed_profile_count", 0) > 0:
        failures.append(f"malformed_profile_count {summary.get('malformed_profile_count', 0)} exceeds max 0")
    if fail_on_unloaded and summary.get("unloaded_profile_count", 0) > 0:
        failures.append(f"unloaded_profile_count {summary.get('unloaded_profile_count', 0)} exceeds max 0")
    if max_warning_count is not None and summary.get("warning_count", 0) > max_warning_count:
        failures.append(f"warning_count {summary.get('warning_count', 0)} exceeds max {max_warning_count}")
    for warning_type, max_count in (max_warning_types or {}).items():
        actual_count = result.warning_types.get(warning_type, 0)
        if actual_count > max_count:
            failures.append(f"warning type {warning_type} count {actual_count} exceeds max {max_count}")
    if (
        max_skipped_transition_count is not None
        and summary.get("skipped_transition_count", 0) > max_skipped_transition_count
    ):
        failures.append(
            f"skipped_transition_count {summary.get('skipped_transition_count', 0)} exceeds max {max_skipped_transition_count}"
        )
    for skipped_reason, max_count in (max_skipped_reasons or {}).items():
        actual_count = result.skipped_reasons.get(skipped_reason, 0)
        if actual_count > max_count:
            failures.append(f"skipped reason {skipped_reason} count {actual_count} exceeds max {max_count}")
    return tuple(failures)


def parse_warning_type_limits(values: Iterable[str]) -> dict[str, int]:
    return parse_count_limits(values, budget_label="Warning type")


def parse_count_limits(values: Iterable[str], *, budget_label: str = "Count") -> dict[str, int]:
    limits: dict[str, int] = {}
    for value in values:
        name, separator, raw_count = value.partition("=")
        name = name.strip()
        raw_count = raw_count.strip()
        if separator != "=" or not name or not raw_count:
            raise ValueError(f"{budget_label} budget must use name=count: {value}")
        try:
            count = int(raw_count)
        except ValueError as exc:
            raise ValueError(f"{budget_label} budget count must be an integer: {value}") from exc
        if count < 0:
            raise ValueError(f"{budget_label} budget count must be non-negative: {value}")
        limits[name] = count
    return limits


def _audit_manifest(manifest_path: Path) -> MechanicsPlannerProfileAudit:
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        manifest = {}
    if not isinstance(manifest, dict):
        manifest = {}

    planner = manifest.get("mechanicsSwapPlanner")
    if planner is None:
        return _profile_row(manifest_path, manifest, status="missing")
    if not isinstance(planner, dict):
        return _profile_row(manifest_path, manifest, status="malformed")
    if planner.get("loaded") is not True:
        return _profile_row(manifest_path, manifest, status="unloaded", planner=planner)

    transitions = planner.get("transitions")
    if not isinstance(transitions, dict):
        return _profile_row(manifest_path, manifest, status="malformed", planner=planner)
    skipped_transitions = planner.get("skippedTransitions")
    if not isinstance(skipped_transitions, dict):
        skipped_transitions = {}
    skipped_reasons = Counter(str(reason) for reason in skipped_transitions.values())

    transition_count = 0
    action_count = 0
    warning_count = 0
    warning_types: Counter[str] = Counter()
    pool_bridge_action_count = 0
    negative_tick_action_count = 0
    warning_sets: list[tuple[int, str]] = []

    for set_name, transition in sorted(transitions.items()):
        if not isinstance(transition, dict):
            continue
        transition_count += 1
        warnings = transition.get("warnings")
        if not isinstance(warnings, list):
            warnings = []
        warning_count += len(warnings)
        for warning in warnings:
            warning_types[str(warning)] += 1
        if warnings:
            warning_sets.append((len(warnings), str(set_name)))

        actions = transition.get("actions")
        if not isinstance(actions, list):
            actions = []
        action_count += len(actions)
        for action in actions:
            if not isinstance(action, dict):
                continue
            key = str(action.get("key", ""))
            if key == "pool_bridge_transition":
                pool_bridge_action_count += 1
            elif key == "negative_tick_avoidance":
                negative_tick_action_count += 1

    top_warning_sets = tuple(
        set_name
        for _, set_name in sorted(warning_sets, key=lambda row: (-row[0], row[1]))[:10]
    )
    return MechanicsPlannerProfileAudit(
        manifest_path=str(manifest_path),
        player=str(manifest.get("player", "")),
        player_id=str(manifest.get("playerId", "")),
        job=str(manifest.get("job", "")),
        status="loaded",
        planner_version=_int_value(planner.get("plannerVersion")),
        baseline_set=str(planner.get("baselineSet", "")),
        transition_count=transition_count,
        action_count=action_count,
        warning_count=warning_count,
        pool_bridge_action_count=pool_bridge_action_count,
        negative_tick_action_count=negative_tick_action_count,
        skipped_transition_count=len(skipped_transitions),
        warning_types=dict(warning_types),
        skipped_reasons=dict(skipped_reasons),
        top_warning_sets=top_warning_sets,
    )


def _profile_row(
    manifest_path: Path,
    manifest: dict[str, object],
    *,
    status: PlannerProfileStatus,
    planner: dict[str, object] | None = None,
) -> MechanicsPlannerProfileAudit:
    return MechanicsPlannerProfileAudit(
        manifest_path=str(manifest_path),
        player=str(manifest.get("player", "")),
        player_id=str(manifest.get("playerId", "")),
        job=str(manifest.get("job", "")),
        status=status,
        planner_version=_int_value((planner or {}).get("plannerVersion")),
        baseline_set=str((planner or {}).get("baselineSet", "")),
        transition_count=0,
        action_count=0,
        warning_count=0,
        pool_bridge_action_count=0,
        negative_tick_action_count=0,
        skipped_transition_count=0,
        warning_types={},
        skipped_reasons={},
        top_warning_sets=tuple(),
    )


def _int_value(value: object) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return 0


def _summary_for_profiles(profiles: tuple[MechanicsPlannerProfileAudit, ...]) -> dict[str, int]:
    summary: Counter[str] = Counter()
    summary["profile_count"] = len(profiles)
    for profile in profiles:
        summary[f"{profile.status}_profile_count"] += 1
        summary["transition_count"] += profile.transition_count
        summary["warning_count"] += profile.warning_count
        summary["action_count"] += profile.action_count
        summary["pool_bridge_action_count"] += profile.pool_bridge_action_count
        summary["negative_tick_action_count"] += profile.negative_tick_action_count
        summary["skipped_transition_count"] += profile.skipped_transition_count
        if profile.warning_count:
            summary["profile_with_warning_count"] += 1
    for key in (
        "loaded_profile_count",
        "missing_profile_count",
        "malformed_profile_count",
        "unloaded_profile_count",
        "profile_with_warning_count",
    ):
        summary[key] += 0
    return dict(summary)


def _planner_versions_for_profiles(profiles: tuple[MechanicsPlannerProfileAudit, ...]) -> dict[str, int]:
    versions: Counter[str] = Counter()
    for profile in profiles:
        if profile.status != "loaded":
            continue
        versions[str(profile.planner_version)] += 1
    return dict(sorted(versions.items()))


def _warning_types_for_profiles(profiles: tuple[MechanicsPlannerProfileAudit, ...]) -> dict[str, int]:
    warning_types: Counter[str] = Counter()
    for profile in profiles:
        warning_types.update(profile.warning_types)
    return dict(sorted(warning_types.items()))


def _skipped_reasons_for_profiles(profiles: tuple[MechanicsPlannerProfileAudit, ...]) -> dict[str, int]:
    skipped_reasons: Counter[str] = Counter()
    for profile in profiles:
        skipped_reasons.update(profile.skipped_reasons)
    return dict(sorted(skipped_reasons.items()))


def _format_count_map(value: dict[str, int]) -> str:
    if not value:
        return "none"
    return ", ".join(
        f"{name}={value[name]}"
        for name in sorted(value)
    )


def _timestamp() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def _timestamp_for_path() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def _create_unique_output_dir(root: Path, timestamp_slug: str) -> Path:
    for index in range(1000):
        suffix = "" if index == 0 else f"-{index + 1:02d}"
        output_dir = root / f"{timestamp_slug}{suffix}"
        try:
            output_dir.mkdir(parents=True, exist_ok=False)
        except FileExistsError:
            continue
        return output_dir
    raise RuntimeError(f"Could not create unique mechanics planner audit directory under {root}")
