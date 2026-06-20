from __future__ import annotations

from datetime import datetime, timezone
import json
from pathlib import Path
from typing import Callable, Mapping

from .contracts import SUPPORTED_JOBS
from .subjobs import SubjobProfile, VIABLE_SUBJOBS_BY_MAIN_JOB, build_subjob_profiles


CATSEYE_REQUIRED_SUBJOB_CAPABILITIES = {
    "THF": ("dual_wield",),
}

CATSEYE_REQUIRED_SUBJOBS_BY_MAIN_JOB = {
    "RDM": ("THF",),
}

ProfileBuilder = Callable[[str], Mapping[str, SubjobProfile]]


def audit_catseye_subjob_capabilities(
    *,
    main_jobs: tuple[str, ...] = tuple(SUPPORTED_JOBS),
    required_subjob_capabilities: Mapping[str, tuple[str, ...]] = CATSEYE_REQUIRED_SUBJOB_CAPABILITIES,
    required_subjobs_by_main_job: Mapping[str, tuple[str, ...]] = CATSEYE_REQUIRED_SUBJOBS_BY_MAIN_JOB,
    profile_builder: ProfileBuilder = build_subjob_profiles,
    output_root: Path | str | None = None,
    write_files: bool = True,
) -> dict[str, object]:
    pairs = _required_pairs(
        main_jobs=main_jobs,
        required_subjob_capabilities=required_subjob_capabilities,
        required_subjobs_by_main_job=required_subjobs_by_main_job,
    )
    issues: list[dict[str, object]] = []
    for main_job, subjob in pairs:
        profiles = profile_builder(main_job)
        missing_capabilities = list(required_subjob_capabilities.get(subjob, tuple()))
        profile = profiles.get(subjob)
        if profile is None:
            issues.append(
                {
                    "mainJob": main_job,
                    "subjob": subjob,
                    "issue": "missing_profile",
                    "missingCapabilities": missing_capabilities,
                }
            )
            continue

        capabilities = set(profile.capabilities)
        missing_capabilities = [
            capability
            for capability in required_subjob_capabilities.get(subjob, tuple())
            if capability not in capabilities
        ]
        if missing_capabilities:
            issues.append(
                {
                    "mainJob": main_job,
                    "subjob": subjob,
                    "issue": "missing_capability",
                    "missingCapabilities": missing_capabilities,
                }
            )

    result: dict[str, object] = {
        "summary": {
            "checkedPairs": len(pairs),
            "issues": len(issues),
        },
        "requiredSubjobCapabilities": {
            subjob: list(capabilities)
            for subjob, capabilities in sorted(required_subjob_capabilities.items())
        },
        "requiredSubjobsByMainJob": {
            main_job: list(subjobs)
            for main_job, subjobs in sorted(required_subjobs_by_main_job.items())
        },
        "checkedPairs": [
            {"mainJob": main_job, "subjob": subjob}
            for main_job, subjob in pairs
        ],
        "issues": issues,
    }
    if write_files:
        if output_root is None:
            output_root = Path(__file__).resolve().parents[2] / "reports" / "catseye-subjob-capabilities"
        output_dir = Path(output_root) / _timestamp()
        output_dir.mkdir(parents=True, exist_ok=True)
        json_path = output_dir / "catseye_subjob_capabilities.json"
        markdown_path = output_dir / "catseye_subjob_capabilities.md"
        json_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        markdown_path.write_text(_markdown(result), encoding="utf-8")
        result["outputDir"] = str(output_dir)
        result["jsonPath"] = str(json_path)
        result["markdownPath"] = str(markdown_path)
    return result


def _required_pairs(
    *,
    main_jobs: tuple[str, ...],
    required_subjob_capabilities: Mapping[str, tuple[str, ...]],
    required_subjobs_by_main_job: Mapping[str, tuple[str, ...]],
) -> tuple[tuple[str, str], ...]:
    pairs: set[tuple[str, str]] = set()
    required_subjobs = set(required_subjob_capabilities)
    for raw_main_job in main_jobs:
        main_job = raw_main_job.upper()
        for subjob in VIABLE_SUBJOBS_BY_MAIN_JOB.get(main_job, tuple()):
            if subjob in required_subjobs:
                pairs.add((main_job, subjob))
        for subjob in required_subjobs_by_main_job.get(main_job, tuple()):
            pairs.add((main_job, subjob.upper()))
    return tuple(sorted(pairs))


def _markdown(result: Mapping[str, object]) -> str:
    summary = result.get("summary", {})
    lines = [
        "# Catseye Subjob Capability Audit",
        "",
        f"- Checked pairs: {_summary_value(summary, 'checkedPairs')}",
        f"- Issues: {_summary_value(summary, 'issues')}",
        "",
    ]
    issues = result.get("issues")
    if isinstance(issues, list) and issues:
        lines.append("## Issues")
        lines.append("")
        for issue in issues:
            if not isinstance(issue, dict):
                continue
            missing = ", ".join(str(value) for value in issue.get("missingCapabilities", []))
            lines.append(
                "- {main}/{sub}: {kind}; missing {missing}".format(
                    main=issue.get("mainJob", ""),
                    sub=issue.get("subjob", ""),
                    kind=issue.get("issue", ""),
                    missing=missing or "none",
                )
            )
    else:
        lines.append("No Catseye subjob capability gaps found.")
    lines.append("")
    return "\n".join(lines)


def _summary_value(summary: object, key: str) -> object:
    if isinstance(summary, dict):
        return summary.get(key, 0)
    return 0


def _timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
