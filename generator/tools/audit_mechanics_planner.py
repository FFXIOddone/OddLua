from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.mechanics_planner_audit import (  # noqa: E402
    audit_mechanics_planner_manifests,
    mechanics_planner_console_payload,
    parse_count_limits,
    parse_warning_type_limits,
    planner_audit_failures,
    planner_audit_exit_code,
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit generated OddLua mechanics swap planner coverage."
    )
    parser.add_argument("--manifest-root", default=ODDLUA_ROOT / "dist" / "packs", type=Path)
    parser.add_argument("--output-root", default=ODDLUA_ROOT / "reports" / "mechanics-planner", type=Path)
    parser.add_argument("--no-write", action="store_true")
    parser.add_argument("--fail-on-missing", action="store_true")
    parser.add_argument("--fail-on-malformed", action="store_true")
    parser.add_argument("--fail-on-unloaded", action="store_true")
    parser.add_argument("--min-profile-count", type=int, default=None)
    parser.add_argument("--min-loaded-profile-count", type=int, default=None)
    parser.add_argument("--min-planner-version", type=int, default=None)
    parser.add_argument("--max-warning-count", type=int, default=None)
    parser.add_argument("--max-skipped-transition-count", type=int, default=None)
    parser.add_argument("--compact", action="store_true")
    parser.add_argument(
        "--max-warning-type",
        action="append",
        default=None,
        metavar="NAME=COUNT",
        help="Fail when one warning type exceeds its budget. May be passed more than once.",
    )
    parser.add_argument(
        "--max-skipped-reason",
        action="append",
        default=None,
        metavar="NAME=COUNT",
        help="Fail when one skipped-transition reason exceeds its budget. May be passed more than once.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        max_warning_types = parse_warning_type_limits(args.max_warning_type or ())
        max_skipped_reasons = parse_count_limits(
            args.max_skipped_reason or (),
            budget_label="Skipped reason",
        )
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    result = audit_mechanics_planner_manifests(
        manifest_root=args.manifest_root,
        output_root=args.output_root,
        write_files=not args.no_write,
    )
    if result.output_dir is not None:
        print(f"Wrote audit: {result.output_dir}")
    print(
        json.dumps(
            mechanics_planner_console_payload(result, include_top_profiles=not args.compact),
            indent=2,
            sort_keys=True,
        )
    )
    failures = planner_audit_failures(
        result,
        fail_on_missing=args.fail_on_missing,
        fail_on_malformed=args.fail_on_malformed,
        fail_on_unloaded=args.fail_on_unloaded,
        min_profile_count=args.min_profile_count,
        min_loaded_profile_count=args.min_loaded_profile_count,
        min_planner_version=args.min_planner_version,
        max_warning_count=args.max_warning_count,
        max_warning_types=max_warning_types,
        max_skipped_transition_count=args.max_skipped_transition_count,
        max_skipped_reasons=max_skipped_reasons,
    )
    for failure in failures:
        print(f"Gate failed: {failure}", file=sys.stderr)
    return planner_audit_exit_code(
        result,
        fail_on_missing=args.fail_on_missing,
        fail_on_malformed=args.fail_on_malformed,
        fail_on_unloaded=args.fail_on_unloaded,
        min_profile_count=args.min_profile_count,
        min_loaded_profile_count=args.min_loaded_profile_count,
        min_planner_version=args.min_planner_version,
        max_warning_count=args.max_warning_count,
        max_warning_types=max_warning_types,
        max_skipped_transition_count=args.max_skipped_transition_count,
        max_skipped_reasons=max_skipped_reasons,
    )


if __name__ == "__main__":
    raise SystemExit(main())
