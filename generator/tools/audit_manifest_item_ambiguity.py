from __future__ import annotations

import argparse
from collections import defaultdict
from datetime import datetime
import json
from pathlib import Path
import sqlite3
import sys
from typing import Any


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MANIFEST_ROOT = ODDLUA_ROOT / "dist" / "packs"
DEFAULT_STATS_DB_PATH = ODDLUA_ROOT / "data" / "oddlua_stats.sqlite"
DEFAULT_OUTPUT_ROOT = ODDLUA_ROOT / "reports" / "manifest-item-ambiguity"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua import statsdb  # noqa: E402
from oddlua.catseye_client_names import client_collision_is_expected  # noqa: E402


def audit_manifest_item_ambiguity(
    *,
    manifest_root: Path | str,
    stats_db_path: Path | str,
    output_root: Path | str | None = None,
) -> dict[str, Any]:
    manifest_root = Path(manifest_root)
    stats_db_path = Path(stats_db_path)
    ambiguous_by_norm = _unexpected_client_collision_map(stats_db_path)

    findings: list[dict[str, Any]] = []
    profiles_scanned = 0
    selected_items_scanned = 0

    for manifest_path in sorted(manifest_root.glob("*/*/manifest.json")):
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        profiles_scanned += 1
        selected_items = manifest.get("selectedItems")
        if not isinstance(selected_items, dict):
            continue
        for style_name, slots in sorted(selected_items.items()):
            if not isinstance(slots, dict):
                continue
            for slot_name, selected in sorted(slots.items()):
                if not isinstance(selected, dict) or not selected.get("item"):
                    continue
                selected_items_scanned += 1
                selected_name = str(selected["item"])
                normalized = statsdb._normalize_catseye_equipment_name(selected_name)
                collision = ambiguous_by_norm.get(normalized)
                if collision is None:
                    continue
                findings.append(
                    {
                        "issue": "Generated manifest selects a client display name with multiple unexpected Catseye item signatures",
                        "player": str(manifest.get("player") or ""),
                        "playerId": str(manifest.get("playerId") or ""),
                        "job": str(manifest.get("job") or ""),
                        "style": str(style_name),
                        "slot": str(slot_name),
                        "name": selected_name,
                        "normalizedName": normalized,
                        "selectedItemId": _int_or_none(selected.get("id")),
                        "ambiguousItemIds": collision["item_ids"],
                        "manifestPath": str(manifest_path),
                    }
                )

    report: dict[str, Any] = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "manifestRoot": str(manifest_root),
        "statsDbPath": str(stats_db_path),
        "summary": {
            "profilesScanned": profiles_scanned,
            "selectedItemsScanned": selected_items_scanned,
            "ambiguousClientNames": len(ambiguous_by_norm),
            "findings": len(findings),
        },
        "findings": findings,
    }

    if output_root is not None:
        run_dir = Path(output_root) / datetime.now().strftime("%Y%m%d-%H%M%S")
        run_dir.mkdir(parents=True, exist_ok=True)
        (run_dir / "manifest_item_ambiguity.json").write_text(
            json.dumps(report, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        (run_dir / "manifest_item_ambiguity.md").write_text(
            render_markdown(report),
            encoding="utf-8",
        )
        report["outputDir"] = str(run_dir)

    return report


def manifest_item_ambiguity_exit_code(
    report: dict[str, Any],
    *,
    fail_on_findings: bool = False,
) -> int:
    if not fail_on_findings:
        return 0
    summary = report.get("summary")
    if not isinstance(summary, dict):
        return 1
    return 1 if int(summary.get("findings") or 0) > 0 else 0


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Manifest Item Ambiguity Audit",
        "",
        "## Summary",
        "",
    ]
    for key, value in report["summary"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Findings", ""])
    findings = report.get("findings") or []
    if not findings:
        lines.append("- none")
    else:
        for finding in findings:
            lines.append(
                "- {player} {job} {style}.{slot}: {name} "
                "(selected id {selectedItemId}; ambiguous ids {ambiguousItemIds}; {manifestPath})".format(
                    **finding
                )
            )
    lines.append("")
    return "\n".join(lines)


def _unexpected_client_collision_map(stats_db_path: Path) -> dict[str, dict[str, Any]]:
    with sqlite3.connect(stats_db_path) as db:
        db.row_factory = sqlite3.Row
        if not _has_table(db, "catseye_client_items"):
            return {}
        rows = [
            (
                int(row["item_id"]),
                {
                    "name": str(row["name"]),
                    "level": int(row["level"]),
                    "ilevel": int(row["ilevel"]),
                    "jobs": int(row["jobs"]),
                    "slot": int(row["slot"]),
                    "shield_size": int(row["shield_size"]),
                    "su_level": int(row["su_level"]),
                    "skill": int(row["skill"]),
                    "damage": int(row["damage"]),
                    "delay": int(row["delay"]),
                    "damage_type": int(row["damage_type"]),
                },
            )
            for row in db.execute(
                """
                select item_id, name, level, ilevel, jobs, slot, shield_size,
                       su_level, skill, damage, delay, damage_type
                from catseye_client_items
                """
            )
        ]

    by_norm: dict[str, list[tuple[int, dict[str, Any]]]] = defaultdict(list)
    for item_id, row in rows:
        if not _client_item_has_equipment_shape(row):
            continue
        normalized = statsdb._normalize_catseye_equipment_name(str(row["name"]))
        if normalized:
            by_norm[normalized].append((item_id, row))

    collisions: dict[str, dict[str, Any]] = {}
    for normalized, collision_rows in sorted(by_norm.items()):
        if len(collision_rows) <= 1 or client_collision_is_expected(collision_rows):
            continue
        signatures = {
            (
                int(row["level"]),
                int(row["jobs"]),
                int(row["slot"]),
                int(row["skill"]),
                int(row["damage"]),
                int(row["delay"]),
                int(row["damage_type"]),
            )
            for _item_id, row in collision_rows
        }
        if len(signatures) <= 1:
            continue
        collisions[normalized] = {
            "name": str(collision_rows[0][1]["name"]),
            "item_ids": sorted(item_id for item_id, _row in collision_rows),
            "signature_count": len(signatures),
            "signatures": sorted(signatures),
        }
    return collisions


def _client_item_has_equipment_shape(row: dict[str, Any]) -> bool:
    if int(row.get("jobs") or 0) <= 0:
        return False
    return any(
        int(row.get(field) or 0) > 0
        for field in ("slot", "skill", "damage", "delay")
    )


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    return db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone() is not None


def _int_or_none(value: object) -> int | None:
    try:
        if value is None or value == "":
            return None
        return int(value)
    except (TypeError, ValueError):
        return None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit generated manifests for Catseye duplicate display-name equipment risks."
    )
    parser.add_argument("--manifest-root", default=DEFAULT_MANIFEST_ROOT, type=Path)
    parser.add_argument("--stats-db-path", default=DEFAULT_STATS_DB_PATH, type=Path)
    parser.add_argument("--output-root", default=DEFAULT_OUTPUT_ROOT, type=Path)
    parser.add_argument("--fail-on-findings", action="store_true")
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_manifest_item_ambiguity(
        manifest_root=args.manifest_root,
        stats_db_path=args.stats_db_path,
        output_root=args.output_root,
    )
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(render_markdown(report))
    return manifest_item_ambiguity_exit_code(
        report,
        fail_on_findings=args.fail_on_findings,
    )


if __name__ == "__main__":
    raise SystemExit(main())
