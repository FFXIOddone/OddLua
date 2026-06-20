from __future__ import annotations

import json
import sqlite3
import sys
from pathlib import Path


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_manifest_item_ambiguity import (  # noqa: E402
    audit_manifest_item_ambiguity,
    manifest_item_ambiguity_exit_code,
)


def test_manifest_item_ambiguity_audit_reports_selected_unexpected_client_collision(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_client_items(
        db_path,
        (
            (1001, "Odd Sword", 75, 0, 1, 1, 0, 0, 3, 10, 240, 0),
            (1002, "Odd Sword", 75, 0, 1, 1, 0, 0, 4, 20, 230, 0),
        ),
    )
    _write_manifest(
        tmp_path / "packs" / "Oddone_29938" / "WAR" / "manifest.json",
        item_name="Odd Sword",
        item_id=1001,
    )

    report = audit_manifest_item_ambiguity(
        manifest_root=tmp_path / "packs",
        stats_db_path=db_path,
        output_root=tmp_path / "reports",
    )

    assert report["summary"]["ambiguousClientNames"] == 1
    assert report["summary"]["selectedItemsScanned"] == 1
    assert report["summary"]["findings"] == 1
    assert manifest_item_ambiguity_exit_code(report, fail_on_findings=True) == 1
    assert report["findings"] == [
        {
            "issue": "Generated manifest selects a client display name with multiple unexpected Catseye item signatures",
            "player": "Oddone",
            "playerId": "29938",
            "job": "WAR",
            "style": "Damage",
            "slot": "Main",
            "name": "Odd Sword",
            "normalizedName": "oddsword",
            "selectedItemId": 1001,
            "ambiguousItemIds": [1001, 1002],
            "manifestPath": str(tmp_path / "packs" / "Oddone_29938" / "WAR" / "manifest.json"),
        }
    ]


def test_manifest_item_ambiguity_audit_ignores_expected_level_upgrade_collision(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_client_items(
        db_path,
        (
            (2001, "Expected Blade", 75, 0, 1, 1, 0, 0, 3, 50, 240, 0),
            (2002, "Expected Blade", 99, 0, 1, 1, 0, 0, 3, 90, 240, 0),
        ),
    )
    _write_manifest(
        tmp_path / "packs" / "Oddone_29938" / "WAR" / "manifest.json",
        item_name="Expected Blade",
        item_id=2002,
    )

    report = audit_manifest_item_ambiguity(
        manifest_root=tmp_path / "packs",
        stats_db_path=db_path,
        output_root=tmp_path / "reports",
    )

    assert report["summary"]["ambiguousClientNames"] == 0
    assert report["summary"]["selectedItemsScanned"] == 1
    assert report["summary"]["findings"] == 0
    assert report["findings"] == []
    assert manifest_item_ambiguity_exit_code(report, fail_on_findings=True) == 0


def test_manifest_item_ambiguity_audit_ignores_signed_suffixes_and_delay_upgrade_chains(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_client_items(
        db_path,
        (
            (3001, "Signed Blade +1", 75, 0, 1, 1, 0, 0, 3, 90, 240, 0),
            (3002, "Signed Blade -1", 75, 0, 1, 1, 0, 0, 3, 10, 260, 0),
            (3003, "Expected Delay Blade", 75, 0, 1, 1, 0, 0, 3, 50, 240, 0),
            (3004, "Expected Delay Blade", 80, 0, 2, 1, 0, 0, 3, 90, 230, 0),
        ),
    )
    _write_manifest(
        tmp_path / "packs" / "Oddone_29938" / "WAR" / "manifest.json",
        item_name="Signed Blade +1",
        item_id=3001,
    )
    _write_manifest(
        tmp_path / "packs" / "Oddone_29938" / "PLD" / "manifest.json",
        item_name="Expected Delay Blade",
        item_id=3004,
    )

    report = audit_manifest_item_ambiguity(
        manifest_root=tmp_path / "packs",
        stats_db_path=db_path,
        output_root=tmp_path / "reports",
    )

    assert report["summary"]["ambiguousClientNames"] == 0
    assert report["summary"]["selectedItemsScanned"] == 2
    assert report["summary"]["findings"] == 0
    assert report["findings"] == []


def _write_client_items(db_path: Path, rows: tuple[tuple[int, str, int, int, int, int, int, int, int, int, int, int], ...]) -> None:
    with sqlite3.connect(db_path) as db:
        db.executescript(
            """
            create table catseye_client_items (
                item_id integer primary key,
                name text not null,
                level integer not null,
                ilevel integer not null,
                jobs integer not null,
                slot integer not null,
                shield_size integer not null,
                su_level integer not null,
                skill integer not null,
                damage integer not null,
                delay integer not null,
                damage_type integer not null
            );
            """
        )
        db.executemany(
            """
            insert into catseye_client_items (
                item_id, name, level, ilevel, jobs, slot, shield_size,
                su_level, skill, damage, delay, damage_type
            ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            rows,
        )


def _write_manifest(path: Path, *, item_name: str, item_id: int) -> None:
    path.parent.mkdir(parents=True)
    path.write_text(
        json.dumps(
            {
                "player": "Oddone",
                "playerId": "29938",
                "job": "WAR",
                "selectedItems": {
                    "Damage": {
                        "Main": {
                            "id": item_id,
                            "item": item_name,
                        }
                    }
                },
            }
        ),
        encoding="utf-8",
    )
