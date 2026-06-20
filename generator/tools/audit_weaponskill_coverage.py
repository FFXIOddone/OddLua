from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.weaponskills import load_weaponskill_catalog


def audit_weaponskill_coverage(*, stats_db_path: Path, dist_root: Path) -> dict[str, object]:
    catalog = load_weaponskill_catalog(stats_db_path)
    profiles = []
    for manifest_path in sorted(dist_root.glob("*/*/manifest.json")):
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        selected = manifest.get("selectedItems", {})
        if not isinstance(selected, dict):
            selected = {}
        ws_sets = sorted(name for name in selected if name.startswith("WS_") or name.startswith("WSAcc_"))
        profiles.append({
            "manifestPath": str(manifest_path),
            "player": manifest.get("player", ""),
            "job": manifest.get("job", ""),
            "weaponskillSetCount": len(ws_sets),
            "weaponskillSets": ws_sets,
        })
    total_weaponskill_sets = sum(int(profile["weaponskillSetCount"]) for profile in profiles)
    return {
        "summary": {
            "catalogCount": len(catalog),
            "profileCount": len(profiles),
            "profilesWithWeaponskillSets": sum(1 for profile in profiles if int(profile["weaponskillSetCount"]) > 0),
            "profilesWithoutWeaponskillSets": sum(1 for profile in profiles if int(profile["weaponskillSetCount"]) == 0),
            "totalWeaponskillSets": total_weaponskill_sets,
        },
        "catalogCount": len(catalog),
        "catalogKeys": sorted(catalog),
        "profiles": profiles,
    }


def weaponskill_console_payload(report: dict[str, object], *, compact: bool = False) -> dict[str, object]:
    if compact:
        return {"summary": report.get("summary", {})}
    return report


def weaponskill_audit_failures(
    report: dict[str, object],
    *,
    min_catalog_count: int | None = None,
    min_profile_count: int | None = None,
    min_total_weaponskill_sets: int | None = None,
    max_profiles_without_weaponskill_sets: int | None = None,
) -> tuple[str, ...]:
    summary = report.get("summary")
    if not isinstance(summary, dict):
        return ("missing summary",)
    checks = (
        ("catalogCount", min_catalog_count),
        ("profileCount", min_profile_count),
        ("totalWeaponskillSets", min_total_weaponskill_sets),
    )
    failures: list[str] = []
    for key, minimum in checks:
        if minimum is None:
            continue
        actual = int(summary.get(key, 0))
        if actual < minimum:
            failures.append(f"{key} {actual} below min {minimum}")
    if max_profiles_without_weaponskill_sets is not None:
        actual = int(summary.get("profilesWithoutWeaponskillSets", 0))
        if actual > max_profiles_without_weaponskill_sets:
            failures.append(
                "profilesWithoutWeaponskillSets "
                f"{actual} exceeds max {max_profiles_without_weaponskill_sets}"
            )
    return tuple(failures)


def weaponskill_audit_exit_code(
    report: dict[str, object],
    *,
    min_catalog_count: int | None = None,
    min_profile_count: int | None = None,
    min_total_weaponskill_sets: int | None = None,
    max_profiles_without_weaponskill_sets: int | None = None,
) -> int:
    return 1 if weaponskill_audit_failures(
        report,
        min_catalog_count=min_catalog_count,
        min_profile_count=min_profile_count,
        min_total_weaponskill_sets=min_total_weaponskill_sets,
        max_profiles_without_weaponskill_sets=max_profiles_without_weaponskill_sets,
    ) else 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--stats-db",
        type=Path,
        default=ODDLUA_ROOT / "data" / "oddlua_stats.sqlite",
    )
    parser.add_argument(
        "--dist-root",
        type=Path,
        default=ODDLUA_ROOT / "dist" / "packs",
    )
    parser.add_argument("--out", default="")
    parser.add_argument("--compact", action="store_true")
    parser.add_argument("--min-catalog-count", type=int, default=None)
    parser.add_argument("--min-profile-count", type=int, default=None)
    parser.add_argument("--min-total-weaponskill-sets", type=int, default=None)
    parser.add_argument("--max-profiles-without-weaponskill-sets", type=int, default=None)
    args = parser.parse_args()

    report = audit_weaponskill_coverage(
        stats_db_path=(
            args.stats_db
            if args.stats_db.is_absolute()
            else Path.cwd() / args.stats_db
        ),
        dist_root=(
            args.dist_root
            if args.dist_root.is_absolute()
            else Path.cwd() / args.dist_root
        ),
    )
    text = json.dumps(weaponskill_console_payload(report, compact=args.compact), indent=2, sort_keys=True)
    if args.out:
        out_path = Path(args.out)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(text + "\n", encoding="utf-8")
    else:
        print(text)
    failures = weaponskill_audit_failures(
        report,
        min_catalog_count=args.min_catalog_count,
        min_profile_count=args.min_profile_count,
        min_total_weaponskill_sets=args.min_total_weaponskill_sets,
        max_profiles_without_weaponskill_sets=args.max_profiles_without_weaponskill_sets,
    )
    for failure in failures:
        print(f"Gate failed: {failure}", file=sys.stderr)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
