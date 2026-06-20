from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.manifests.schema import ManifestValidationError, validate_profile_manifest  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit Attempt 2 foundation manifest fields.")
    parser.add_argument("--manifest-root", default=ODDLUA_ROOT / "dist" / "packs", type=Path)
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def audit_manifest_root(manifest_root: Path | str) -> dict[str, object]:
    root = Path(manifest_root)
    manifest_paths = sorted(root.glob("*/*/manifest.json"))
    failures: list[dict[str, str]] = []
    missing_command_registry = 0
    missing_key_bindings = 0

    for manifest_path in manifest_paths:
        try:
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            validate_profile_manifest(manifest)
        except (json.JSONDecodeError, ManifestValidationError) as exc:
            failures.append({"path": str(manifest_path), "message": str(exc)})
            continue
        if "commandRegistry" not in manifest:
            missing_command_registry += 1
            failures.append({"path": str(manifest_path), "message": "missing commandRegistry"})
        if "keyBindings" not in manifest:
            missing_key_bindings += 1
            failures.append({"path": str(manifest_path), "message": "missing keyBindings"})

    return {
        "manifestRoot": str(root),
        "manifestCount": len(manifest_paths),
        "failureCount": len(failures),
        "failures": failures,
        "missingCommandRegistry": missing_command_registry,
        "missingKeyBindings": missing_key_bindings,
    }


def main() -> int:
    args = parse_args()
    report = audit_manifest_root(args.manifest_root)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(
            "Attempt 2 foundation audit: "
            f"manifests={report['manifestCount']} "
            f"failures={report['failureCount']} "
            f"missingCommandRegistry={report['missingCommandRegistry']} "
            f"missingKeyBindings={report['missingKeyBindings']}"
        )
    return 1 if int(report["failureCount"]) else 0


if __name__ == "__main__":
    raise SystemExit(main())
