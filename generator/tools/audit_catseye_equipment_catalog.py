from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ODDLUA_ROOT.parent
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.catseye_equipment_audit import audit_catseye_equipment_catalog  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compare OddLua equipment facts against the Catseye wiki equipment catalog."
    )
    parser.add_argument(
        "--db-path",
        default=ODDLUA_ROOT / "data" / "oddlua_stats.sqlite",
        type=Path,
    )
    parser.add_argument(
        "--catseye-wiki-root",
        default=PROJECT_ROOT / "tools-data" / "catseye-wiki-cache",
        type=Path,
    )
    parser.add_argument(
        "--output-root",
        default=ODDLUA_ROOT / "reports" / "catseye-equipment-catalog",
        type=Path,
    )
    parser.add_argument("--max-equipment-mismatches", type=int)
    parser.add_argument("--max-weapon-mismatches", type=int)
    return parser.parse_args()


def catalog_budget_failures(
    summary: dict[str, int],
    *,
    max_equipment_mismatches: int | None = None,
    max_weapon_mismatches: int | None = None,
) -> tuple[str, ...]:
    failures: list[str] = []
    if (
        max_equipment_mismatches is not None
        and int(summary.get("equipment_mismatches", 0)) > max_equipment_mismatches
    ):
        failures.append(
            f"equipment_mismatches {summary.get('equipment_mismatches', 0)} exceeds max {max_equipment_mismatches}"
        )
    if (
        max_weapon_mismatches is not None
        and int(summary.get("weapon_mismatches", 0)) > max_weapon_mismatches
    ):
        failures.append(
            f"weapon_mismatches {summary.get('weapon_mismatches', 0)} exceeds max {max_weapon_mismatches}"
        )
    return tuple(failures)


def main() -> int:
    args = parse_args()
    result = audit_catseye_equipment_catalog(
        db_path=args.db_path,
        catseye_wiki_root=args.catseye_wiki_root,
        output_root=args.output_root,
    )
    print(f"Wrote audit: {result.output_dir}")
    print(result.summary)
    failures = catalog_budget_failures(
        result.summary,
        max_equipment_mismatches=args.max_equipment_mismatches,
        max_weapon_mismatches=args.max_weapon_mismatches,
    )
    for failure in failures:
        print(f"Gate failed: {failure}", file=sys.stderr)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
