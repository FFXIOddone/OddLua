from pathlib import Path
import sqlite3
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.statsdb import build_stats_db


def test_build_stats_db_imports_core_mechanics_sources(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "ACC = 25,\nMACC = 30,\nPET_ACC = 25,\n",
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
    )

    assert result.ability_count == 1
    assert result.spell_count == 1
    assert result.status_effect_count == 1
    assert result.pet_item_mod_count == 1

    db = sqlite3.connect(result.path)
    try:
        pet_mod = db.execute(
            "select mod_name, value, pet_type from item_mods_pet where item_id = 1000"
        ).fetchone()
        ability = db.execute(
            "select name, recast_time, ce, ve from abilities where ability_id = 1"
        ).fetchone()
        spell = db.execute(
            "select name, mp_cost, cast_time, recast_time from spells where spell_id = 1"
        ).fetchone()
        status = db.execute(
            "select name, overwrite, block_id, min_duration from status_effects where status_id = 1"
        ).fetchone()
    finally:
        db.close()

    assert pet_mod == ("PET_ACC", 12, 0)
    assert ability == ("mighty_strikes", 3600, 1, 300)
    assert spell == ("cure", 8, 2000, 5000)
    assert status == ("poison", 0, 0, 0)


def test_build_stats_db_imports_item_latents(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "MOVE_SPEED_GEAR_BONUS = 76,\n",
        encoding="utf-8",
    )
    (sql_root / "item_latents.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_latents` VALUES (14101,76,24,26,1);",
                "INSERT INTO `item_latents` VALUES (14428,76,12,54,19);",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
    )

    assert result.item_latent_count == 2

    db = sqlite3.connect(result.path)
    try:
        rows = list(
            db.execute(
                """
                select item_id, mod_name, value, condition_id, condition_value
                from item_latents
                order by item_id
                """
            )
        )
        metadata = dict(db.execute("select key, value from metadata"))
    finally:
        db.close()

    assert rows == [
        (14101, "MOVE_SPEED_GEAR_BONUS", 24, 26, 1),
        (14428, "MOVE_SPEED_GEAR_BONUS", 12, 54, 19),
    ]
    assert metadata["item_latent_count"] == "2"


def test_build_stats_db_applies_catseye_equipment_level_overrides(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("ACC = 25,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (18904,0,'ephemeron','ephemeron',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (10942,0,'aifes_medal','aifes_medal',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (10761,0,'portus_annulet','portus_annulet',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (18904,'ephemeron',95,0,2130128,538,0,0,3,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (10942,'aifes_medal',94,0,4194303,0,0,0,512,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (10761,'portus_annulet',94,0,4194303,0,0,0,24576,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Sword.txt").write_text(
        "\n".join(
            (
                "Somnia Melodiam",
                "[Sword]All Races",
                "DMG:42 Delay:201 Accuracy+15",
                'Increases "Double Attack" damage',
                "Lv.75 RDM, BRD",
                "Dropped by Absolute Virtue",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Neck.txt").write_text(
        "\n".join(
            (
                "Aife's Medal",
                "[Neck]All Races",
                "INT+6 MND+6",
                "Lv.75 All Jobs",
                "Dropped in Dynamis 2.0 - Qufim",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Ring.txt").write_text(
        "\n".join(
            (
                "Portus Annulet",
                "[Ring]All Races",
                "Accuracy+6 Guarding skill +3",
                "Lv.74 All Jobs",
                "Dropped in Dynamis 2.0 - Tavnazia",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
    )

    assert result.catseye_equipment_override_count == 3

    db = sqlite3.connect(result.path)
    try:
        equipment = {
            item_id: (level, ilevel, jobs, slot)
            for item_id, level, ilevel, jobs, slot in db.execute(
                "select item_id, level, ilevel, jobs, slot from item_equipment"
            )
        }
        overrides = {
            item_id: catseye_name
            for item_id, catseye_name in db.execute(
                "select item_id, catseye_name from catseye_equipment_overrides"
            )
        }
    finally:
        db.close()

    assert equipment[18904] == (75, 0, 528, 3)
    assert equipment[10942] == (75, 0, 4194303, 512)
    assert equipment[10761] == (74, 0, 4194303, 24576)
    assert overrides[18904] == "Somnia Melodiam"
    assert overrides[10942] == "Aife's Medal"
    assert overrides[10761] == "Portus Annulet"


def test_build_stats_db_applies_client_item_resource_dump(tmp_path: Path) -> None:
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
        "INSERT INTO `item_basic` VALUES (18904,0,'ephemeron','ephemeron',0,'Weapon',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (18904,'ephemeron',95,0,2130128,538,0,0,3,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (18904,'ephemeron',3,0,0,0,0,0,0,224,39,0);\n",
        encoding="utf-8",
    )
    client_items_path = tmp_path / "Oddone_29938_client_items.json"
    client_items_path.write_text(
        """
        {
          "source": "AshitaCore:GetResourceManager():GetItemById",
          "items": [
            {
              "id": 18904,
              "name": "Somnia Melodiam",
              "level": 75,
              "itemLevel": 0,
              "jobMask": 1056,
              "slotMask": 3,
              "flags": 63572,
              "stack": 1,
              "type": 4,
              "subType": 0,
              "skill": 3,
              "damage": 58,
              "delay": 213,
              "damageType": 0,
              "shieldSize": 0,
              "superiorLevel": 0,
              "validTargets": 0
            },
            {
              "id": 20720,
              "name": "Egeking",
              "level": 75,
              "itemLevel": 0,
              "jobMask": 32,
              "slotMask": 3,
              "flags": 63552,
              "stack": 1,
              "type": 4,
              "subType": 0,
              "skill": 3,
              "damage": 43,
              "delay": 236,
              "damageType": 0,
              "shieldSize": 0,
              "superiorLevel": 0,
              "validTargets": 0
            }
          ]
        }
        """,
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        client_items_path=client_items_path,
    )

    assert result.client_item_count == 2
    assert result.client_equipment_update_count == 2
    assert result.client_weapon_update_count == 2

    db = sqlite3.connect(result.path)
    try:
        equipment = {
            item_id: (name, level, ilevel, jobs, slot)
            for item_id, name, level, ilevel, jobs, slot in db.execute(
                "select item_id, name, level, ilevel, jobs, slot from item_equipment order by item_id"
            )
        }
        weapons = {
            item_id: (name, skill, damage, delay)
            for item_id, name, skill, damage, delay in db.execute(
                "select item_id, name, skill, damage, delay from item_weapon order by item_id"
            )
        }
        client_rows = db.execute("select count(*) from catseye_client_items").fetchone()[0]
        metadata = dict(db.execute("select key, value from metadata"))
    finally:
        db.close()

    assert equipment[18904] == ("Somnia Melodiam", 75, 0, 528, 3)
    assert equipment[20720] == ("Egeking", 75, 0, 16, 3)
    assert weapons[18904] == ("Somnia Melodiam", 3, 58, 213)
    assert weapons[20720] == ("Egeking", 3, 43, 236)
    assert client_rows == 2
    assert metadata["source_client_items_path"] == str(client_items_path)
    assert metadata["client_item_count"] == "2"


def test_build_stats_db_applies_catseye_stat_overrides_from_broad_pages(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("MOVE_SPEED_GEAR_BONUS = 76,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (14281,0,'blood_cuisses','Blood Cuisses',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (14281,'blood_cuisses',73,0,2204880,62,0,0,128,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "INSERT INTO `item_mods` VALUES (14281,76,12);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Legs.txt").write_text(
        "\n".join(
            (
                "Blood Cuisses",
                "[Legs]All Races",
                "DEF:44 HP+27 MP+27",
                "Movement speed +12%",
                "Lv.73 RDM, PLD, DRK, RNG, DRG, BLU, COR, RUN",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Systems_Custom_Equipment.txt").write_text(
        "\n".join(
            (
                "Movement Speed",
                "Blood Cuisses",
                "RDM PLD DRK RNG DRG BLU COR RUN",
                "73",
                "DEF: 44 HP+27 MP+27",
                "Movement speed +18%",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
    )

    db = sqlite3.connect(result.path)
    try:
        movement_mod = db.execute(
            "select value from item_mods where item_id = 14281 and mod_id = 76"
        ).fetchone()[0]
        stat_overrides = {
            item_id: (mod_name, original_value, catseye_value)
            for item_id, mod_name, original_value, catseye_value in db.execute(
                """
                select item_id, mod_name, original_value, catseye_value
                from catseye_equipment_stat_overrides
                """
            )
        }
        metadata = dict(db.execute("select key, value from metadata"))
    finally:
        db.close()

    assert result.catseye_equipment_stat_override_count == 1
    assert movement_mod == 18
    assert stat_overrides[14281] == ("MOVE_SPEED_GEAR_BONUS", 12, 18)
    assert metadata["catseye_equipment_stat_override_count"] == "1"


def test_build_stats_db_ignores_catseye_recipe_ingredient_lines_for_stat_overrides(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("MOVE_SPEED_GEAR_BONUS = 76,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (14080,0,'strider_boots','strider_boots',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (19999,0,'harbingers_gaiters','Harbinger''s Gaiters',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (14080,'strider_boots',20,0,160,0,0,0,256,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (19999,'harbingers_gaiters',70,0,160,0,0,0,256,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (14080,76,12);",
                "INSERT INTO `item_mods` VALUES (19999,76,12);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Feet.txt").write_text(
        "Filler Boots\n[Feet]All Races\nDEF:1\nLv.1 All Jobs\n",
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Systems_Custom_Equipment.txt").write_text(
        "\n".join(
            (
                "Earth Crystal",
                "Strider Boots *",
                "Serica Cloth **",
                "Elementium Thread x3",
                "Harbinger's Gaiters",
                "[Feet]All Races",
                "DEF:17 MP+15 Evasion+9",
                "Movement speed +19%",
                "Lv.70 THF/RNG",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
    )

    db = sqlite3.connect(result.path)
    try:
        strider_value = db.execute(
            "select value from item_mods where item_id = 14080 and mod_id = 76"
        ).fetchone()[0]
        strider_override = db.execute(
            "select count(*) from catseye_equipment_stat_overrides where item_id = 14080"
        ).fetchone()[0]
    finally:
        db.close()

    assert strider_value == 12
    assert strider_override == 0


def test_build_stats_db_skips_ambiguous_catseye_equipment_names(tmp_path: Path) -> None:
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
                "INSERT INTO `item_basic` VALUES (10001,0,'laevateinn','laevateinn',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (10002,0,'laevateinn','laevateinn',0,'Weapon',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (10001,'laevateinn',99,0,8,0,0,0,1,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (10002,'laevateinn',99,0,8,0,0,0,1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Staff.txt").write_text(
        "\n".join(
            (
                "Laevateinn",
                "[Staff]All Races",
                "DMG:80 Delay:402",
                "Lv.75 BLM",
                "Listed on Catseye equipment page",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
    )

    db = sqlite3.connect(result.path)
    try:
        levels = [
            row[0]
            for row in db.execute(
                "select level from item_equipment where item_id in (10001, 10002) order by item_id"
            )
        ]
        override_count = db.execute("select count(*) from catseye_equipment_overrides").fetchone()[0]
    finally:
        db.close()

    assert result.catseye_equipment_override_count == 0
    assert levels == [99, 99]
    assert override_count == 0


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
    ):
        (sql_root / name).write_text("", encoding="utf-8")

    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (1000,0,'pet_harness','Pet Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "abilities.sql").write_text(
        "INSERT INTO `abilities` VALUES "
        "(1,'mighty_strikes',1,1,1,3600,0,0,0,0,0,0,0,0,0,0,1,300,0,0,'');\n",
        encoding="utf-8",
    )
    (sql_root / "spell_list.sql").write_text(
        "INSERT INTO `spell_list` VALUES "
        "(1,'cure',0x000000000000000000000000,0,1,6,0,1,1,8,2000,5000,0,0,0,0,0,10,1.0,1,0,0,0,21,0,'');\n",
        encoding="utf-8",
    )
    (sql_root / "status_effects.sql").write_text(
        "INSERT INTO `status_effects` VALUES (1,'poison',0,1,0,0,0,0,4,0,1);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods_pet.sql").write_text(
        "INSERT INTO `item_mods_pet` VALUES (1000,25,12,0);\n",
        encoding="utf-8",
    )
