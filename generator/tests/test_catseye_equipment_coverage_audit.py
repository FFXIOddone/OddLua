from pathlib import Path
import sqlite3
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from oddlua.statsdb import build_stats_db
from tools.audit_catseye_equipment_coverage import audit_coverage


def test_catseye_coverage_audit_accepts_manual_effect_tags(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (18812,0,'ossa_grip','ossa_grip',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (21169,0,'keraunos','keraunos',0,'Weapon',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (18812,'ossa_grip',75,0,4194303,0,0,0,2,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (21169,'keraunos',75,0,4194303,0,0,0,3,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_weapon` VALUES (18812,'ossa_grip',0,0,0,0,0,1,1,999,1,0);",
                "INSERT INTO `item_weapon` VALUES (21169,'keraunos',12,0,0,0,0,0,1,402,40,0);",
            )
        ),
        encoding="utf-8",
    )

    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Grip.txt").write_text(
        "\n".join(
            (
                "Ossa Grip",
                "[Grip]All Races",
                "Latent effect: Enhancing magic duration+5% (when having Ice Spikes active)",
                "Lv.75 All Jobs",
                "Dropped by a Catseye source.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Staff.txt").write_text(
        "\n".join(
            (
                "Keraunos",
                "[Staff]All Races",
                "DMG:40 Delay:402 Magic Potency+15% Magic Accuracy+30",
                "Lv.75 All Jobs",
                "Dropped by a Catseye source.",
            )
        ),
        encoding="utf-8",
    )

    db_path = tmp_path / "oddlua_stats.sqlite"
    build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=db_path,
        catseye_wiki_root=catseye_root,
    )

    db = sqlite3.connect(db_path)
    try:
        tag_rows = [
            (int(item_id), str(effect_tag), str(status), str(target), value)
            for item_id, effect_tag, status, target, value in db.execute(
                """
                select item_id, effect_tag, status, target, value
                from catseye_equipment_effect_tags
                where item_id in (18812, 21169)
                order by item_id, effect_tag
                """
            )
        ]
        tags = {
            item_id: (effect_tag, status, target, value)
            for item_id, effect_tag, status, target, value in tag_rows
        }
    finally:
        db.close()

    report = audit_coverage(
        db_path=db_path,
        catseye_wiki_root=catseye_root,
        client_items_path=tmp_path / "missing-client-items",
    )

    assert tags[18812] == ("conditional_enhancing_magic_duration", "manual_review", "conditional", None)
    assert [row for row in tag_rows if row[0] == 18812] == [
        (18812, "conditional_enhancing_magic_duration", "manual_review", "conditional", None)
    ]
    assert tags[21169] == ("magic_potency", "manual_review", "unsupported", 15)
    assert report["summary"]["statish_matched_records_without_effect_tags"] == 0
    assert report["statish_matched_records_without_effect_tags"] == []


def test_catseye_coverage_audit_cleans_reconcilable_unresolved_records(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "DEF = 1,",
                "EQUIPMENT_ONLY_RACE = 160,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (11302,0,'dancer\\'s_tiara_+1','dancer\\'s_tiara_+1',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (11303,0,'dancer\\'s_tiara_+1','dancer\\'s_tiara_+1',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (12560,0,'scale_mail','scale_mail',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (18976,0,'vajra','vajra',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (18996,0,'vajra','vajra',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (21070,0,'idris','idris',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (21080,0,'idris','idris',0,'Weapon',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (11302,'dancer\\'s_tiara_+1',74,0,262144,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (11303,'dancer\\'s_tiara_+1',74,0,262144,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (12560,'scale_mail',10,0,2141649,0,0,0,32,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (18976,'vajra',75,0,32,0,0,0,3,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (18996,'vajra',75,0,32,0,0,0,3,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (21070,'idris',75,0,1048576,0,0,0,3,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (21080,'idris',99,375,1048576,0,0,0,3,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_weapon` VALUES (18976,'vajra',2,0,0,0,0,0,1,200,31,0);",
                "INSERT INTO `item_weapon` VALUES (18996,'vajra',2,0,0,0,0,0,1,200,31,0);",
                "INSERT INTO `item_weapon` VALUES (21070,'idris',11,0,0,0,0,0,1,280,52,0);",
                "INSERT INTO `item_weapon` VALUES (21080,'idris',11,0,0,0,0,0,1,280,175,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (11302,1,19);",
                "INSERT INTO `item_mods` VALUES (11302,160,149);",
                "INSERT INTO `item_mods` VALUES (11303,1,19);",
                "INSERT INTO `item_mods` VALUES (11303,160,106);",
            )
        ),
        encoding="utf-8",
    )

    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "",
                "Scale Mail (Novice Trial Path)",
                "[Body]All Races",
                "DEF:11 DEF+3 HP+10",
                "Lv.10 WAR, RDM, PLD, DRK, BST, RNG, SAM, DRG, BLU, RUN",
                "Augmented through Novice Trials",
                "",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Club.txt").write_text(
        "\n".join(
            (
                "",
                "Idris",
                "[Club]All Races",
                'DMG:52 Delay:280 Magic Accuracy+10 "Magic Atk. Bonus"+10',
                "Lv.75 GEO",
                "Obtained via the custom Ergon Weapon quest.",
                "",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Dagger.txt").write_text(
        "\n".join(
            (
                "",
                "Vajra",
                "[Dagger]All Races",
                'DMG:31 Delay:200 Enhances "Sneak Attack" effect',
                "Lv.75 THF",
                "Obtained via Mythic weapon quest.",
                "",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "",
                "Dancer's Tiara +1",
                "[Head]All Races",
                "DEF:19 HP+15 DEX+4 CHR+4",
                "Lv.74 DNC",
                "Artifact armor.",
                "",
            )
        ),
        encoding="utf-8",
    )

    db_path = tmp_path / "oddlua_stats.sqlite"
    build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=db_path,
        catseye_wiki_root=catseye_root,
    )

    db = sqlite3.connect(db_path)
    try:
        scale_tags = list(
            db.execute(
                """
                select effect_tag, status, target
                from catseye_equipment_effect_tags
                where item_id = 12560
                """
            )
        )
    finally:
        db.close()

    report = audit_coverage(
        db_path=db_path,
        catseye_wiki_root=catseye_root,
        client_items_path=tmp_path / "missing-client-items",
    )

    assert ("novice_trial_path_def_hp_augments", "manual_review", "augment_path") in scale_tags
    assert report["summary"]["unresolved_records"] == 0
    assert report["summary"]["bucket_counts"].get("wiki_level_disambiguated_current_db_name", 0) == 0
    assert report["summary"]["bucket_counts"]["wiki_matched_current_db"] == 2
    assert report["summary"]["bucket_counts"]["wiki_equivalent_duplicate_current_db_name"] == 1


def test_catseye_coverage_audit_keeps_current_build_absent_wiki_records_out_of_unresolved(
    tmp_path: Path,
) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("", encoding="utf-8")

    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "",
                "Old Wiki-Only Hat",
                "[Head]All Races",
                "DEF:1",
                "Lv.1 All Jobs",
                "Legacy wiki listing.",
                "",
            )
        ),
        encoding="utf-8",
    )

    db_path = tmp_path / "oddlua_stats.sqlite"
    build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=db_path,
        catseye_wiki_root=catseye_root,
    )

    report = audit_coverage(
        db_path=db_path,
        catseye_wiki_root=catseye_root,
        client_items_path=tmp_path / "missing-client-items",
    )

    assert report["summary"]["unresolved_records"] == 0
    assert report["unresolved_records"] == []
    assert report["summary"]["current_build_absent_wiki_records"] == 1
    assert report["current_build_absent_wiki_records"][0]["name"] == "Old Wiki-Only Hat"
    assert report["summary"]["bucket_counts"]["wiki_absent_from_current_client_and_db"] == 1


def test_statsdb_tags_catseye_gathering_and_fishing_utility_passives(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("FISH = 127,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (26533,0,'plain_tunica','Plain Tunica',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (26535,0,'mariner\\'s_tunica','Mariner\\'s Tunica',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (26533,'Plain Tunica',30,0,4194303,0,0,0,32,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (26535,'Mariner\\'s Tunica',30,0,4194303,0,0,0,32,0,0,0);",
            )
        ),
        encoding="utf-8",
    )

    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "",
                "Plain Tunica",
                "[Body]All Races",
                "DEF:18 +4",
                "Improves Mining, Logging and Harvesting results",
                "Surveyor+1",
                "Lv.30 All Jobs",
                "Obtained via HELM Ventures.",
                "",
                "Mariner's Tunica",
                "[Body]All Races",
                "DEF:18 +4",
                "Fishing skill +1",
                "Expert Angler+1",
                "(Fatigue limit +10%, Golden Arrow Rate+1%)",
                "Lv.30 All Jobs",
                "Obtained via HELM Ventures.",
                "",
            )
        ),
        encoding="utf-8",
    )

    db_path = tmp_path / "oddlua_stats.sqlite"
    build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=db_path,
        catseye_wiki_root=catseye_root,
    )

    db = sqlite3.connect(db_path)
    try:
        tags = {
            (int(item_id), str(effect_tag)): (str(status), str(target), value)
            for item_id, effect_tag, status, target, value in db.execute(
                """
                select item_id, effect_tag, status, target, value
                from catseye_equipment_effect_tags
                order by item_id, effect_tag
                """
            )
        }
    finally:
        db.close()

    assert tags[(26533, "surveyor")] == ("manual_review", "utility", 1)
    assert tags[(26535, "expert_angler")] == ("manual_review", "utility", 1)
    assert tags[(26535, "fatigue_limit")] == ("manual_review", "utility", 10)
    assert tags[(26535, "golden_arrow_rate")] == ("manual_review", "utility", 1)


def _write_core_sql(sql_root: Path) -> None:
    for name in (
        "item_equipment.sql",
        "item_weapon.sql",
        "item_mods.sql",
        "item_latents.sql",
        "augments.sql",
        "merits.sql",
        "traits.sql",
        "weapon_skills.sql",
        "item_usable.sql",
        "item_mods_pet.sql",
    ):
        (sql_root / name).write_text("", encoding="utf-8")

    (sql_root / "item_basic.sql").write_text("", encoding="utf-8")
    (sql_root / "abilities.sql").write_text("", encoding="utf-8")
    (sql_root / "spell_list.sql").write_text("", encoding="utf-8")
    (sql_root / "status_effects.sql").write_text("", encoding="utf-8")
