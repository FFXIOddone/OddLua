from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.catseye_subjob_capability_audit import audit_catseye_subjob_capabilities
from oddlua.subjobs import SubjobProfile


def test_catseye_subjob_capability_audit_passes_current_thf_dual_wield_rule() -> None:
    result = audit_catseye_subjob_capabilities(write_files=False)

    assert result["summary"]["issues"] == 0
    assert result["summary"]["checkedPairs"] >= 1


def test_catseye_subjob_capability_audit_reports_missing_profiles_and_capabilities() -> None:
    def broken_profiles(main_job: str) -> dict[str, SubjobProfile]:
        if main_job == "RDM":
            return {}
        if main_job == "WAR":
            return {"THF": _subjob_profile("THF", ("sneak_attack",))}
        raise AssertionError(main_job)

    result = audit_catseye_subjob_capabilities(
        main_jobs=("RDM", "WAR"),
        required_subjobs_by_main_job={"RDM": ("THF",), "WAR": ("THF",)},
        profile_builder=broken_profiles,
        write_files=False,
    )

    assert result["summary"] == {"checkedPairs": 2, "issues": 2}
    assert result["issues"] == [
        {
            "mainJob": "RDM",
            "subjob": "THF",
            "issue": "missing_profile",
            "missingCapabilities": ["dual_wield"],
        },
        {
            "mainJob": "WAR",
            "subjob": "THF",
            "issue": "missing_capability",
            "missingCapabilities": ["dual_wield"],
        },
    ]


def _subjob_profile(abbr: str, capabilities: tuple[str, ...]) -> SubjobProfile:
    return SubjobProfile(
        abbr=abbr,
        level=37,
        capabilities=capabilities,
        abilities=tuple(),
        traits=tuple(),
        spells=tuple(),
    )
