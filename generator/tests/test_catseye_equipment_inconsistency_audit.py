from pathlib import Path
import sqlite3
import sys

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from tools.audit_catseye_equipment_inconsistencies import (  # noqa: E402
    TECHNIQUES,
    audit_catseye_equipment_inconsistencies,
    inconsistency_audit_failures,
    parse_max_technique_budgets,
    parse_args,
)
from oddlua import statsdb  # noqa: E402


def test_inconsistency_audit_runs_expanded_equipment_gap_techniques(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_audit_fixture_db(db_path)
    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Taeon Gloves",
                "[Head]All Races",
                "DEF:23 Haste+1%",
                "Lv.75 All Jobs",
                "Obtained via Incursion.",
                "Fixture Gloves",
                "[Head]All Races",
                "DEF:23 Haste+1%",
                "Lv.75 All Jobs",
                "Non-exception slot conflict fixture.",
                "Dancer's Tiara +1",
                "[Head]All Races",
                "DEF:19 HP+15 DEX+4 CHR+4 Enmity-2",
                "Lv.74 DNC",
                "Race duplicate fixture.",
                "Mirror Mantle",
                "[Back]All Races",
                "DEF:5 DEX+2",
                "Lv.36 All Jobs",
                "Fixture duplicate one.",
                "Mirror Mantle",
                "[Back]All Races",
                "DEF:5 AGI+2",
                "Lv.36 All Jobs",
                "Fixture duplicate two.",
                "Path Mantle",
                "[Back]All Races",
                "DEF:5 DEX+2",
                "Lv.36 All Jobs",
                "Base path duplicate.",
                "Path Mantle",
                "[Back]All Races",
                "DEF:5 HP+0~25",
                "Lv.36 All Jobs",
                "Covered augment path duplicate.",
                "Plain Gloves",
                "[Hands]All Races",
                "DEF:7 Shield skill +10",
                "Lv.30 All Jobs",
                "Equivalent duplicate one.",
                "Plain Gloves",
                "[Hands]All Races",
                "DEF:7 Shield skill+10",
                "Lv.30 All Jobs",
                "Equivalent duplicate two.",
                "Mystery Blade",
                "[Sword]All Races",
                "DMG:5 Delay:200",
                "Lv.75 All Jobs",
                "Ambiguous fixture.",
                "Apex Togi",
                "[Body]All Races",
                "DEF:40 Set Bonus: Increases Rate of Critical Hits+5%",
                "Lv.75 MNK",
                "Parsed set bonus fixture.",
                "Order Mail",
                "[Body]All Races",
                'DEF:50 Accuracy+10 Haste+3% "Store TP"+3',
                "Lv.75 PLD",
                "Order-only duplicate one.",
                "Order Mail",
                "[Body]All Races",
                'DEF:50 "Store TP"+3 Haste+3% Accuracy+10',
                "Lv.75 PLD",
                "Order-only duplicate two.",
                "Mystic Togi",
                "[Body]All Races",
                'DEF:40 "Unmapped Example" rate-5',
                "Lv.75 MNK",
                "Skipped effect fixture.",
            )
        ),
        encoding="utf-8",
    )

    report = audit_catseye_equipment_inconsistencies(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        max_examples_per_technique=20,
    )

    assert {
        "semantic_duplicate_wiki_record_conflicts",
        "wiki_slot_name_db_slot_conflicts",
        "unexpected_client_name_collision_signatures",
        "high_signal_skipped_effect_fragments",
        "ambiguous_wiki_record_matches",
        "db_slot_name_lexical_mismatches",
        "client_slot_name_lexical_mismatches",
        "catseye_source_slot_guarded_overrides",
        "stat_overrides_from_slot_conflicting_sources",
        "identity_catseye_equipment_overrides",
    }.issubset(set(TECHNIQUES))
    assert report["summary"]["techniques"] == 20
    assert _finding_names(report, "wiki_slot_name_db_slot_conflicts") == {"Fixture Gloves"}
    assert "Mirror Mantle" in _finding_names(report, "semantic_duplicate_wiki_record_conflicts")
    assert "Path Mantle" not in _finding_names(report, "semantic_duplicate_wiki_record_conflicts")
    assert "Path Mantle" not in _finding_names(report, "conflicting_duplicate_wiki_records")
    assert "Plain Gloves" not in _finding_names(report, "semantic_duplicate_wiki_record_conflicts")
    assert "Plain Gloves" not in _finding_names(report, "conflicting_duplicate_wiki_records")
    assert "Order Mail" not in _finding_names(report, "semantic_duplicate_wiki_record_conflicts")
    assert "Order Mail" not in _finding_names(report, "conflicting_duplicate_wiki_records")
    assert "Mystery Blade" in _finding_names(report, "ambiguous_wiki_record_matches")
    assert "Dancer's Tiara +1" not in _finding_names(report, "ambiguous_wiki_record_matches")
    assert "Odd Collision" in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Expected Blade" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Expected Relic" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Expected Delay Blade" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Expected Same-Name Sword" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Judge's Sword" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Signed Blade +1" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Signed Blade -1" not in _finding_names(report, "unexpected_client_name_collision_signatures")
    assert "Apex Togi" not in _finding_names(report, "high_signal_skipped_effect_fragments")
    assert "Mystic Togi" in _finding_names(report, "high_signal_skipped_effect_fragments")
    assert _finding_names(report, "wiki_slot_name_lexical_mismatches") == {"Fixture Gloves"}
    assert "Wrong Boots" in _finding_names(report, "db_slot_name_lexical_mismatches")
    assert "Client Boots" in _finding_names(report, "client_slot_name_lexical_mismatches")
    assert "Novennial Boots" not in _finding_names(report, "db_slot_name_lexical_mismatches")
    assert "Novennial Boots" not in _finding_names(report, "client_slot_name_lexical_mismatches")
    assert "Fixture Gloves" in _finding_names(report, "catseye_source_slot_guarded_overrides")
    assert "Fixture Gloves" in _finding_names(report, "stat_overrides_from_slot_conflicting_sources")
    assert "Identity Cap" in _finding_names(report, "identity_catseye_equipment_overrides")


def test_inconsistency_audit_failures_require_zero_unbudgeted_findings() -> None:
    report = {
        "technique_summaries": {
            technique: {"findings": 0}
            for technique in TECHNIQUES
        }
    }
    report["technique_summaries"]["client_name_collision_signatures"]["findings"] = 2
    report["technique_summaries"]["stale_catseye_stat_override_application"]["findings"] = 1

    assert inconsistency_audit_failures(
        report,
        max_findings_by_technique={"client_name_collision_signatures": 2},
    ) == (
        "stale_catseye_stat_override_application findings 1 exceeds max 0",
    )
    assert inconsistency_audit_failures(
        report,
        max_findings_by_technique={"client_name_collision_signatures": 1},
    ) == (
        "stale_catseye_stat_override_application findings 1 exceeds max 0",
        "client_name_collision_signatures findings 2 exceeds max 1",
    )


def test_catseye_equipment_name_normalization_preserves_signed_upgrade_suffixes() -> None:
    assert statsdb._normalize_catseye_equipment_name("Signed Blade +1") == "signedbladeplus1"
    assert statsdb._normalize_catseye_equipment_name("Signed Blade -1") == "signedblademinus1"
    assert (
        statsdb._normalize_catseye_equipment_name("Signed Blade +1")
        != statsdb._normalize_catseye_equipment_name("Signed Blade -1")
    )
    assert statsdb._normalize_catseye_equipment_name("San d'Orian Sword") == "sandoriansword"


def test_parse_max_technique_budgets_validates_names_and_counts() -> None:
    assert parse_max_technique_budgets(
        (
            "client_name_collision_signatures=72",
            "unexpected_client_name_collision_signatures=0",
        )
    ) == {
        "client_name_collision_signatures": 72,
        "unexpected_client_name_collision_signatures": 0,
    }

    with pytest.raises(ValueError, match="Unknown Catseye inconsistency technique"):
        parse_max_technique_budgets(("not_a_real_technique=1",))
    with pytest.raises(ValueError, match="non-negative integer"):
        parse_max_technique_budgets(("client_name_collision_signatures=-1",))
    with pytest.raises(ValueError, match="NAME=COUNT"):
        parse_max_technique_budgets(("client_name_collision_signatures",))


def test_inconsistency_audit_cli_accepts_repeated_technique_budgets(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "audit_catseye_equipment_inconsistencies.py",
            "--fail-on-unbudgeted-findings",
            "--max-technique",
            "client_name_collision_signatures=72",
            "--max-technique",
            "unexpected_client_name_collision_signatures=0",
        ],
    )

    args = parse_args()

    assert args.fail_on_unbudgeted_findings is True
    assert args.max_technique == [
        "client_name_collision_signatures=72",
        "unexpected_client_name_collision_signatures=0",
    ]


def test_inconsistency_audit_accepts_hidden_crafting_utility_effect_sources(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_hidden_crafting_fixture_db(db_path, include_tags=True)
    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    _write_hidden_crafting_wiki_page(wiki_pages)

    report = audit_catseye_equipment_inconsistencies(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
    )

    assert _finding_names(report, "utility_effect_tags_without_matching_wiki_tokens") == set()
    assert _finding_names(report, "wiki_utility_tokens_without_effect_tags") == set()


def test_inconsistency_audit_flags_missing_hidden_crafting_utility_effect_tags(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_hidden_crafting_fixture_db(db_path, include_tags=False)
    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    _write_hidden_crafting_wiki_page(wiki_pages)

    report = audit_catseye_equipment_inconsistencies(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
    )

    missing_tags = {
        str(finding["details"]["effect_tag"])
        for finding in report["findings"]["wiki_utility_tokens_without_effect_tags"]  # type: ignore[index]
    }
    assert missing_tags == {"hidden_alchemy_skill", "hidden_cooking_skill"}


def _finding_names(report: dict[str, object], technique: str) -> set[str]:
    findings = report["findings"][technique]  # type: ignore[index]
    return {str(finding["name"]) for finding in findings}  # type: ignore[index]


def _write_audit_fixture_db(path: Path) -> None:
    db = sqlite3.connect(path)
    try:
        db.executescript(
            """
            create table items (
                item_id integer primary key,
                name text not null,
                sort_name text not null,
                item_type text not null
            );
            create table item_equipment (
                item_id integer primary key,
                name text not null,
                level integer not null,
                ilevel integer not null,
                jobs integer not null,
                script_type integer not null,
                slot integer not null,
                shield_size integer not null,
                su_level integer not null
            );
            create table item_weapon (
                item_id integer primary key,
                name text not null,
                skill integer not null,
                damage integer not null,
                delay integer not null,
                damage_type integer not null
            );
            create table item_mods (
                item_id integer not null,
                mod_name text not null,
                value integer not null
            );
            create table catseye_equipment_effect_tags (
                item_id integer not null,
                effect_tag text not null,
                status text not null,
                target text not null,
                source_path text not null,
                source_text text not null,
                note text,
                mod_name text,
                value integer
            );
            create table catseye_equipment_overrides (
                item_id integer not null,
                server_name text not null,
                catseye_name text not null,
                original_level integer not null,
                catseye_level integer not null,
                original_ilevel integer not null,
                catseye_ilevel integer not null,
                original_jobs integer not null,
                catseye_jobs integer not null,
                original_slot integer not null,
                catseye_slot integer not null,
                source_path text not null,
                source_text text not null,
                stats_text text not null
            );
            create table catseye_equipment_stat_overrides (
                item_id integer not null,
                mod_id integer not null,
                mod_name text not null,
                original_value integer,
                catseye_value integer not null,
                source_path text not null,
                source_text text not null
            );
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
        equipment_rows = [
            (27047, "Taeon Gloves", 75, 0, 4194303, 0, 64, 0, 0),
            (37047, "Fixture Gloves", 75, 0, 4194303, 0, 64, 0, 0),
            (11475, "Dancer's Tiara +1", 74, 0, 262144, 0, 16, 0, 0),
            (11476, "Dancer's Tiara +1", 74, 0, 262144, 0, 16, 0, 0),
            (30001, "Mirror Mantle", 36, 0, 4194303, 0, 32768, 0, 0),
            (30003, "Path Mantle", 36, 0, 4194303, 0, 32768, 0, 0),
            (30002, "Plain Gloves", 30, 0, 4194303, 0, 64, 0, 0),
            (31001, "Mystery Blade", 1, 0, 4194303, 0, 3, 0, 0),
            (31002, "Mystery Blade", 2, 0, 4194303, 0, 3, 0, 0),
            (32001, "Apex Togi", 75, 0, 2, 0, 32, 0, 0),
            (34001, "Order Mail", 75, 0, 1, 0, 32, 0, 0),
            (11957, "Novennial Boots", 75, 0, 4194303, 0, 128, 0, 0),
            (33001, "Wrong Boots", 75, 0, 4194303, 0, 16, 0, 0),
            (33002, "Identity Cap", 75, 0, 4194303, 0, 16, 0, 0),
        ]
        db.executemany(
            "insert into items values (?, ?, ?, ?)",
            [
                (item_id, name, name.lower().replace(" ", "_"), "Armor")
                for item_id, name, *_rest in equipment_rows
            ],
        )
        db.executemany(
            "insert into item_equipment values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            equipment_rows,
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?)",
            [
                (11475, "DEF", 19),
                (11475, "HP", 15),
                (11475, "DEX", 4),
                (11475, "CHR", 4),
                (11475, "ENMITY", -2),
                (11475, "EQUIPMENT_ONLY_RACE", 149),
                (11476, "DEF", 19),
                (11476, "HP", 15),
                (11476, "DEX", 4),
                (11476, "CHR", 4),
                (11476, "ENMITY", -2),
                (11476, "EQUIPMENT_ONLY_RACE", 106),
                (30003, "DEF", 5),
                (30003, "DEX", 2),
            ],
        )
        db.execute(
            """
            insert into catseye_equipment_effect_tags values (
                30003, 'random_hp_path', 'manual_review', 'augment_path',
                'pages/CatsEyeXI_Content_Equipment_Head.txt',
                'Path Mantle (Random Path): HP+0~25',
                'Fixture random augment path.', null, null
            )
            """
        )
        db.executemany(
            "insert into item_weapon values (?, ?, ?, ?, ?, ?)",
            [
                (31001, "Mystery Blade", 3, 10, 240, 1),
                (31002, "Mystery Blade", 3, 12, 240, 1),
            ],
        )
        db.executemany(
            "insert into catseye_client_items values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [
                (90001, "Odd Collision", 75, 0, 4194303, 64, 0, 0, 0, 0, 0, 0),
                (90002, "Odd Collision", 75, 0, 4194303, 128, 0, 0, 0, 0, 0, 0),
                (90003, "Expected Blade", 99, 0, 4194303, 3, 0, 0, 3, 100, 240, 1),
                (90004, "Expected Blade", 99, 0, 4194303, 3, 0, 0, 3, 110, 240, 1),
                (90006, "Expected Relic", 75, 0, 4194303, 3, 0, 0, 4, 80, 431, 0),
                (90007, "Expected Relic", 80, 0, 193, 3, 0, 0, 4, 99, 431, 0),
                (90008, "Expected Delay Blade", 75, 0, 4194303, 3, 0, 0, 3, 80, 431, 0),
                (90009, "Expected Delay Blade", 80, 0, 193, 3, 0, 0, 3, 99, 420, 0),
                (90010, "Expected Same-Name Sword", 99, 0, 4194303, 3, 0, 0, 3, 80, 431, 0),
                (90011, "Expected Same-Name Sword", 99, 0, 4194303, 3, 0, 0, 3, 99, 420, 0),
                (16622, "Judge's Sword", 1, 0, 4194303, 1, 0, 0, 4, 99, 999, 0),
                (17644, "Judge's Sword", 1, 0, 4194303, 3, 0, 0, 3, 0, 240, 0),
                (90012, "Signed Blade +1", 75, 0, 4194303, 3, 0, 0, 3, 99, 420, 0),
                (90013, "Signed Blade -1", 75, 0, 4194303, 3, 0, 0, 3, 80, 431, 0),
                (11957, "Novennial Boots", 75, 0, 4194303, 128, 0, 0, 0, 0, 0, 0),
                (90005, "Client Boots", 75, 0, 4194303, 16, 0, 0, 0, 0, 0, 0),
            ],
        )
        db.executemany(
            """
            insert into catseye_equipment_overrides values (
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
            )
            """,
            [
                (
                    27047,
                    "Taeon Gloves",
                    "Taeon Gloves",
                    75,
                    75,
                    256,
                    0,
                    4194303,
                    4194303,
                    64,
                    64,
                    "pages/CatsEyeXI_Content_Equipment_Head.txt",
                    "Obtained via Incursion.",
                    "DEF:23 Haste+1%",
                ),
                (
                    33002,
                    "Identity Cap",
                    "Identity Cap",
                    75,
                    75,
                    0,
                    0,
                    4194303,
                    4194303,
                    16,
                    16,
                    "pages/CatsEyeXI_Content_Equipment_Head.txt",
                    "No-op fixture.",
                    "DEF:1",
                ),
                (
                    37047,
                    "Fixture Gloves",
                    "Fixture Gloves",
                    75,
                    75,
                    256,
                    0,
                    4194303,
                    4194303,
                    64,
                    64,
                    "pages/CatsEyeXI_Content_Equipment_Head.txt",
                    "Non-exception slot conflict fixture.",
                    "DEF:23 Haste+1%",
                ),
            ],
        )
        db.executemany(
            """
            insert into catseye_equipment_stat_overrides values (
                ?, 1, 'DEF', 85, 23, 'pages/CatsEyeXI_Content_Equipment_Head.txt',
                ?
            )
            """,
            (
                (27047, "Taeon Gloves DEF:23 Haste+1%"),
                (37047, "Fixture Gloves DEF:23 Haste+1%"),
            ),
        )
        db.commit()
    finally:
        db.close()


def _write_hidden_crafting_fixture_db(path: Path, *, include_tags: bool) -> None:
    db = sqlite3.connect(path)
    try:
        db.executescript(
            """
            create table items (
                item_id integer primary key,
                name text not null,
                sort_name text not null,
                item_type text not null
            );
            create table item_equipment (
                item_id integer primary key,
                name text not null,
                level integer not null,
                ilevel integer not null,
                jobs integer not null,
                script_type integer not null,
                slot integer not null,
                shield_size integer not null,
                su_level integer not null
            );
            create table item_weapon (
                item_id integer primary key,
                name text not null,
                skill integer not null,
                damage integer not null,
                delay integer not null,
                damage_type integer not null
            );
            create table item_mods (
                item_id integer not null,
                mod_name text not null,
                value integer not null
            );
            create table catseye_equipment_stat_overrides (
                item_id integer not null,
                mod_id integer not null,
                mod_name text not null,
                original_value integer,
                catseye_value integer not null,
                source_path text not null,
                source_text text not null
            );
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
            create table catseye_equipment_effect_tags (
                item_id integer not null,
                effect_tag text not null,
                status text not null,
                target text not null,
                source_path text not null,
                source_text text not null,
                note text,
                mod_name text,
                value integer
            );
            """
        )
        db.execute(
            "insert into items values (?, ?, ?, ?)",
            (22198, "Neph. Grip", "neph_grip", "Armor"),
        )
        db.execute(
            "insert into item_equipment values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (22198, "Neph. Grip", 75, 0, 4194303, 0, 2, 0, 0),
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?)",
            ((22198, "MP", 6), (22198, "INT", 1)),
        )
        if include_tags:
            db.executemany(
                """
                insert into catseye_equipment_effect_tags values (
                    ?, ?, ?, ?, ?, ?, ?, ?, ?
                )
                """,
                (
                    (
                        22198,
                        "hidden_alchemy_skill",
                        "manual_review",
                        "utility",
                        "pages/CatsEyeXI_Content_Equipment_Sub.txt",
                        "Hidden Effect: Alchemy Skill+1",
                        "Craft utility effect is not a combat gear score.",
                        None,
                        1,
                    ),
                    (
                        22198,
                        "hidden_cooking_skill",
                        "manual_review",
                        "utility",
                        "pages/CatsEyeXI_Content_Equipment_Sub.txt",
                        "Hidden Effect: Alchemy Skill+1 Cooking Skill+1",
                        "Craft utility effect is not a combat gear score.",
                        None,
                        1,
                    ),
                ),
            )
        db.commit()
    finally:
        db.close()


def _write_hidden_crafting_wiki_page(wiki_pages: Path) -> None:
    (wiki_pages / "CatsEyeXI_Content_Equipment_Sub.txt").write_text(
        "\n".join(
            (
                "Neph. Grip",
                "[Sub]All Races",
                "MP+6 INT+1 Hidden Effect: Alchemy Skill+1 Cooking Skill+1",
                "Lv.75 All Jobs",
                "Hidden crafting fixture.",
            )
        ),
        encoding="utf-8",
    )
