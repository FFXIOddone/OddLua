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
    assert metadata["catseye_provenance_verified"] == "0"
    assert "production source ref not verified" in metadata["catseye_provenance_verification_note"]


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


def test_build_stats_db_applies_catseye_equipment_overrides_after_client_resources(tmp_path: Path) -> None:
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
        "INSERT INTO `item_basic` VALUES (10993,0,'bruisers_cloak','Bruiser''s Cloak',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (10993,'bruisers_cloak',30,0,32,0,0,0,512,0,0,0);\n",
        encoding="utf-8",
    )
    client_items_path = tmp_path / "Oddone_29938_client_items.json"
    client_items_path.write_text(
        """
        {
          "items": [
            {
              "id": 10993,
              "name": "Bruiser's Cloak",
              "level": 30,
              "itemLevel": 0,
              "jobMask": 32,
              "slotMask": 512,
              "flags": 0,
              "stack": 1,
              "type": 4,
              "subType": 0,
              "skill": 0,
              "damage": 0,
              "delay": 0,
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
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Back.txt").write_text(
        "\n".join(
            (
                "Bruiser's Cloak",
                "[Back]All Races",
                "DEF:3 STR+2 Haste+2%",
                "Lv.20 WAR, MNK",
                "Novice Trials.",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
        client_items_path=client_items_path,
    )

    db = sqlite3.connect(result.path)
    try:
        equipment = db.execute(
            "select level, ilevel, jobs, slot from item_equipment where item_id = 10993"
        ).fetchone()
        override_count = db.execute("select count(*) from catseye_equipment_overrides").fetchone()[0]
    finally:
        db.close()

    assert equipment == (20, 0, 3, 32768)
    assert override_count == 1
    assert result.catseye_equipment_override_count == 1


def test_build_stats_db_imports_catseye_nine_column_item_basic(tmp_path: Path) -> None:
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
        "INSERT INTO `item_basic` VALUES (18801,0,'danger_grip','danger_grip',@WEAPON_TYPE,1,6148,@GRIP,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (18801,'danger_grip',81,0,4194303,0,0,0,2,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (18801,'danger_grip',0,0,0,0,0,1,1,999,1,0);\n",
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
    )

    db = sqlite3.connect(result.path)
    try:
        item = db.execute(
            "select name, sort_name, item_type, stack_size from items where item_id = 18801"
        ).fetchone()
        aliases = list(
            db.execute(
                """
                select name, source
                from item_name_aliases
                where item_id = 18801
                order by source
                """
            )
        )
    finally:
        db.close()

    assert item == ("danger_grip", "danger_grip", "@WEAPON_TYPE", 1)
    assert aliases == [
        ("danger_grip", "server_item_basic_name"),
        ("danger_grip", "server_item_basic_sort_name"),
        ("danger_grip", "server_item_equipment_name"),
    ]


def test_build_stats_db_prefers_duplicate_wiki_record_that_matches_client_slot(tmp_path: Path) -> None:
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
        "INSERT INTO `item_basic` VALUES (28201,0,'xux_trousers','xux_trousers',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (28201,'xux_trousers',99,0,1,0,0,0,16,0,0,0);\n",
        encoding="utf-8",
    )
    client_items_path = tmp_path / "Oddone_29938_client_items.json"
    client_items_path.write_text(
        """
        {
          "items": [
            {
              "id": 28201,
              "name": "Acrobat's Breeches",
              "level": 70,
              "itemLevel": 0,
              "jobMask": 2593826,
              "slotMask": 128,
              "flags": 0,
              "stack": 1,
              "type": 4,
              "subType": 0,
              "skill": 0,
              "damage": 0,
              "delay": 0,
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
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Acrobat's Breeches",
                "[Head]All Races",
                "DEF:28 Accuracy-10 Haste+6%",
                "Lv.75 MNK, THF, BST, RNG, NIN, BLU, COR, PUP, DNC, RUN",
                "Dropped in Dynamis 2.0.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Legs.txt").write_text(
        "\n".join(
            (
                "Acrobat's Breeches",
                "[Legs]All Races",
                "DEF:35 DEX+2 AGI+9 Evasion+11 Haste+2%",
                "Lv.70 MNK, THF, RNG, NIN, BLU, COR, PUP, DNC, RUN",
                "Dropped by Midgardsormr.",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
        client_items_path=client_items_path,
    )

    db = sqlite3.connect(result.path)
    try:
        equipment = db.execute(
            "select level, ilevel, jobs, slot from item_equipment where item_id = 28201"
        ).fetchone()
        mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 28201"
            )
        )
        override = db.execute(
            "select catseye_level, catseye_jobs, catseye_slot from catseye_equipment_overrides where item_id = 28201"
        ).fetchone()
    finally:
        db.close()

    assert equipment == (70, 0, 2593826, 128)
    assert mods["DEF"] == 35
    assert mods["DEX"] == 2
    assert mods["AGI"] == 9
    assert mods["HASTE_GEAR"] == 200
    assert "ACC" not in mods
    assert override == (70, 2593826, 128)
    assert result.catseye_equipment_override_count == 1


def test_build_stats_db_preserves_slot_when_catseye_wiki_slot_contradicts_item_name(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "DEF = 1,\nHASTE_GEAR = 384,\n",
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (27047,0,'taeon_gloves','Taeon Gloves',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (27047,'Taeon Gloves',75,0,4194303,0,0,0,64,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "INSERT INTO `item_mods` VALUES (27047,1,85,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Taeon Gloves",
                "[Head]All Races",
                "DEF:23 Haste+1%",
                "Lv.75 All Jobs",
                "Obtained via Incursion.",
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
        equipment = db.execute(
            "select level, ilevel, jobs, slot from item_equipment where item_id = 27047"
        ).fetchone()
        mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 27047"
            )
        )
        equipment_override = db.execute(
            "select catseye_slot from catseye_equipment_overrides where item_id = 27047"
        ).fetchone()
    finally:
        db.close()

    assert equipment == (75, 0, 4194303, 64)
    assert mods["DEF"] == 23
    assert mods["HASTE_GEAR"] == 100
    assert equipment_override is None


def test_build_stats_db_keeps_source_names_for_catseye_stat_matching_after_client_import(tmp_path: Path) -> None:
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
                "HP = 2,",
                "MP = 5,",
                "HASTE_GEAR = 384,",
                "MOVE_SPEED_GEAR_BONUS = 76,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (12545,0,'mythril_breastplate','mtl._breastplate',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (12545,'mtl._breastplate',49,0,193,29,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "INSERT INTO `item_mods` VALUES (12545,76,0);\n",
        encoding="utf-8",
    )
    client_items_path = tmp_path / "Pleasebanme_48997_client_items.json"
    client_items_path.write_text(
        """
        {
          "source": "AshitaCore:GetResourceManager():GetItemById",
          "items": [
            {
              "id": 12545,
              "name": "Mtl. Breastplate",
              "level": 49,
              "itemLevel": 0,
              "jobMask": 386,
              "slotMask": 32,
              "flags": 2084,
              "stack": 1,
              "type": 5,
              "subType": 0,
              "skill": 0,
              "damage": 0,
              "delay": 0,
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
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Mythril Breastplate",
                "[Body]All Races",
                "DEF:41 Movement speed +18%",
                "Lv.49 WAR, PLD, DRK",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
        client_items_path=client_items_path,
    )

    db = sqlite3.connect(result.path)
    try:
        movement_mod = db.execute(
            "select value from item_mods where item_id = 12545 and mod_id = 76"
        ).fetchone()[0]
        stat_overrides = list(
            db.execute(
                """
                select item_id, mod_name, original_value, catseye_value
                from catseye_equipment_stat_overrides
                """
            )
        )
    finally:
        db.close()

    assert result.catseye_equipment_stat_override_count == 1
    assert movement_mod == 18
    assert stat_overrides == [(12545, "MOVE_SPEED_GEAR_BONUS", 0, 18)]


def test_build_stats_db_maps_somnia_hidden_effects_without_smite(tmp_path: Path) -> None:
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
                "ACC = 25,",
                "FIRE_STAFF_BONUS = 347,",
                "ICE_STAFF_BONUS = 348,",
                "WIND_STAFF_BONUS = 349,",
                "EARTH_STAFF_BONUS = 350,",
                "THUNDER_STAFF_BONUS = 351,",
                "WATER_STAFF_BONUS = 352,",
                "LIGHT_STAFF_BONUS = 353,",
                "DARK_STAFF_BONUS = 354,",
                "MYTHIC_OCC_ATT_TWICE = 865,",
                "SMITE = 898,",
                "DOUBLE_ATTACK_DMG = 1038,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (18904,0,'ephemeron','ephemeron',0,'Weapon',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (18904,'ephemeron',95,0,2130128,538,0,0,3,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (18904,'ephemeron',3,0,0,0,0,0,0,213,58,0);\n",
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
                "Occasionally attacks twice",
                'Increases "Double Attack" damage',
                "Hidden Effect: All elements affinity +2",
                "Lv.75 RDM, BRD",
                "Dropped by Absolute Virtue",
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
        mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 18904"
            )
        )
        stat_override_count = db.execute(
            "select count(*) from catseye_equipment_stat_overrides where item_id = 18904"
        ).fetchone()[0]
    finally:
        db.close()

    assert mods["ACC"] == 15
    assert mods["DOUBLE_ATTACK_DMG"] == 3
    assert mods["MYTHIC_OCC_ATT_TWICE"] == 1
    assert mods["FIRE_STAFF_BONUS"] == 2
    assert mods["DARK_STAFF_BONUS"] == 2
    assert "SMITE" not in mods
    assert stat_override_count == 13


def test_build_stats_db_applies_catseye_occ_attacks_range_as_max_swings(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("MAX_SWINGS = 978,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (17057,0,'moblin_mallet','moblin_mallet',0,'Weapon',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (17057,'moblin_mallet',75,0,4194303,538,0,0,3,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (17057,'moblin_mallet',11,0,0,0,0,0,0,264,11,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Club.txt").write_text(
        "\n".join(
            (
                "Moblin Mallet",
                "[Club]All Races",
                "DMG:11 Delay:264 Occasionally attacks 2-4",
                "Lv.75 WAR, WHM, BLM, RDM, PLD, DRK, BST, BRD, RNG, SAM, NIN, DRG, SMN, BLU, COR, PUP, DNC, SCH",
                "Dropped by a Catseye source.",
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
        mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 17057"
            )
        )
        stat_override_count = db.execute(
            "select count(*) from catseye_equipment_stat_overrides where item_id = 17057"
        ).fetchone()[0]
    finally:
        db.close()

    assert mods["MAX_SWINGS"] == 4
    assert stat_override_count == 1


def test_build_stats_db_replaces_direct_catseye_wiki_stats_and_weapon_values(tmp_path: Path) -> None:
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
                "HP = 2,",
                "MP = 5,",
                "STR = 8,",
                "MND = 13,",
                "ACC = 25,",
                "ENMITY = 27,",
                "MATT = 28,",
                "MACC = 30,",
                "FASTCAST = 170,",
                "ENSPELL_DMG_BONUS = 432,",
                "PHALANX_RECEIVED = 1182,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (20720,0,'egeking','Egeking',0,'Weapon',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (20720,'egeking',99,0,2130128,0,0,0,3,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (20720,'egeking',3,0,0,0,0,0,1,240,51,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (20720,8,10);",
                "INSERT INTO `item_mods` VALUES (20720,27,4);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Sword.txt").write_text(
        "\n".join(
            (
                "Egeking",
                "[Sword]All Races",
                "DMG:43 Delay:236",
                "HP+15 MP+15 STR+4 MND+4",
                "Accuracy+8 Magic Accuracy+4 Magic Attack Bonus+4 Enmity-4",
                "Phalanx+3 Sword enhancement spell damage+6",
                "Fast Cast+5%",
                "Lv.75 RDM",
                "Obtained via Oboro",
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
        weapon = db.execute(
            "select damage, delay from item_weapon where item_id = 20720"
        ).fetchone()
        mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 20720"
            )
        )
        override_count = db.execute(
            "select count(*) from catseye_equipment_stat_overrides where item_id = 20720"
        ).fetchone()[0]
    finally:
        db.close()

    assert weapon == (43, 236)
    assert mods == {
        "HP": 15,
        "MP": 15,
        "STR": 4,
        "MND": 4,
        "ACC": 8,
        "MACC": 4,
        "MATT": 4,
        "ENMITY": -4,
        "PHALANX_RECEIVED": 3,
        "ENSPELL_DMG_BONUS": 6,
        "FASTCAST": 5,
    }
    assert override_count == 13
    assert result.catseye_equipment_stat_override_count == 13


def test_build_stats_db_moves_status_prefixed_catseye_stats_to_conditional_mods(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("DEX = 9,\nACC = 25,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (16306,0,'halting_stole','Halting Stole',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (16306,'halting_stole',75,0,4194303,0,0,0,512,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "INSERT INTO `item_mods` VALUES (16306,25,20);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Neck.txt").write_text(
        "\n".join(
            (
                "Halting Stole",
                "[Neck]All Races",
                "DEX+3 Paralysis: Accuracy+20",
                "Lv.75 All Jobs",
                "Dropped in Dynamis 2.0 - Bastok",
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
        direct_mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 16306"
            )
        )
        conditional_mods = list(
            db.execute(
                """
                select mod_name, value, condition_type, condition_name
                from item_conditional_mods
                where item_id = 16306
                """
            )
        )
    finally:
        db.close()

    assert direct_mods == {"DEX": 3}
    assert conditional_mods == [("ACC", 20, "status", "paralysis")]


def test_build_stats_db_moves_set_bonus_catseye_stats_to_conditional_mods(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("CRITHITRATE = 165,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (14592,0,'skadis_cuirie','Skadi''s Cuirie',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (14592,'skadis_cuirie',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Skadi's Cuirie",
                "[Body]All Races",
                "DEF:40 Set Bonus: Increases Rate of Critical Hits+5%",
                "Lv.75 All Jobs",
                "Dropped by a Catseye source.",
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
        direct_mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 14592"
            )
        )
        conditional_mods = list(
            db.execute(
                """
                select mod_name, value, condition_type, condition_name
                from item_conditional_mods
                where item_id = 14592
                """
            )
        )
    finally:
        db.close()

    assert "CRITHITRATE" not in direct_mods
    assert conditional_mods == [("CRITHITRATE", 5, "set_bonus", "set")]


def test_build_stats_db_matches_catseye_conditionals_to_client_only_equipment(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "DEX = 9,\nHASTE_GEAR = 384,\nCRITHITRATE = 165,\n",
        encoding="utf-8",
    )
    client_items_path = tmp_path / "Oddone_29938_client_items.json"
    client_items_path.write_text(
        """
        {
          "items": [
            {
              "id": 39100,
              "name": "Venom Vambraces",
              "level": 60,
              "itemLevel": 0,
              "jobMask": 795206,
              "slotMask": 64,
              "flags": 63552,
              "stack": 1,
              "type": 5,
              "subType": 0,
              "skill": 0,
              "damage": 0,
              "delay": 0,
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
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Hands.txt").write_text(
        "\n".join(
            (
                "Venom Vambraces",
                "[Hands]All Races",
                "DEF:14 DEX+3 Haste+2% Latent Effect (Poisoned): Critical Hit Rate +3%",
                "Lv.60 WAR, MNK, THF, BST, NIN, PUP, DNC",
                "Dropped by Venomous Drake.",
            )
        ),
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
        catseye_wiki_root=catseye_root,
        client_items_path=client_items_path,
    )

    db = sqlite3.connect(result.path)
    try:
        direct_mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 39100"
            )
        )
        conditional_mods = list(
            db.execute(
                """
                select mod_name, value, condition_type, condition_name
                from item_conditional_mods
                where item_id = 39100
                """
            )
        )
    finally:
        db.close()

    assert direct_mods["DEX"] == 3
    assert direct_mods["HASTE_GEAR"] == 200
    assert conditional_mods == [("CRITHITRATE", 3, "status", "poison")]


def test_build_stats_db_moves_latent_level_catseye_stats_to_conditional_mods(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("HP = 2,\nDEX = 9,\nACC = 25,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (14590,0,'eminence_doublet','Eminence Doublet',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (14590,'eminence_doublet',1,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (14590,2,10);",
                "INSERT INTO `item_mods` VALUES (14590,25,50);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Eminence Doublet",
                "[Body]All Races",
                "DEF:15 HP+10 Latent Effect (under Lv.31): DEX+1 Accuracy+50",
                "Lv.1 All Jobs",
                "Obtained from Records of Eminence.",
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
        direct_mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 14590"
            )
        )
        conditional_mods = list(
            db.execute(
                """
                select mod_name, value, condition_type, condition_name
                from item_conditional_mods
                where item_id = 14590
                order by mod_name
                """
            )
        )
    finally:
        db.close()

    assert direct_mods == {"DEF": 15, "HP": 10}
    assert conditional_mods == [
        ("ACC", 50, "level_lt", "31"),
        ("DEX", 1, "level_lt", "31"),
    ]


def test_build_stats_db_removes_stale_direct_mods_absent_from_catseye_wiki_record(tmp_path: Path) -> None:
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
                "ACC = 25,",
                "AGI = 11,",
                "HASTE_GEAR = 384,",
                "FIRE_STAFF_BONUS = 347,",
                "ICE_STAFF_BONUS = 348,",
                "WIND_STAFF_BONUS = 349,",
                "EARTH_STAFF_BONUS = 350,",
                "THUNDER_STAFF_BONUS = 351,",
                "WATER_STAFF_BONUS = 352,",
                "LIGHT_STAFF_BONUS = 353,",
                "DARK_STAFF_BONUS = 354,",
                "MYTHIC_OCC_ATT_TWICE = 865,",
                "DOUBLE_ATTACK_DMG = 1038,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (18904,0,'ephemeron','ephemeron',0,'Weapon',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (18904,'ephemeron',95,0,2130128,538,0,0,3,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (18904,'ephemeron',3,0,0,0,0,0,0,213,58,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (18904,11,15);",
                "INSERT INTO `item_mods` VALUES (18904,25,15);",
                "INSERT INTO `item_mods` VALUES (18904,384,300);",
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
                "DMG:42 Delay:201",
                "Accuracy+15",
                "Occasionally attacks twice",
                'Increases "Double Attack" damage',
                "Hidden Effect: All elements affinity +2",
                "Lv.75 RDM, BRD",
                "Dropped by Absolute Virtue",
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
        mods = dict(
            db.execute(
                "select mod_name, value from item_mods where item_id = 18904"
            )
        )
        weapon = db.execute(
            "select damage, delay from item_weapon where item_id = 18904"
        ).fetchone()
    finally:
        db.close()

    assert weapon == (42, 201)
    assert mods["ACC"] == 15
    assert mods["FIRE_STAFF_BONUS"] == 2
    assert mods["DARK_STAFF_BONUS"] == 2
    assert mods["DOUBLE_ATTACK_DMG"] == 3
    assert mods["MYTHIC_OCC_ATT_TWICE"] == 1
    assert "AGI" not in mods
    assert "HASTE_GEAR" not in mods
    assert result.catseye_equipment_stat_override_count == 12


def test_build_stats_db_removes_stale_direct_mods_when_catseye_wiki_has_no_direct_stats(tmp_path: Path) -> None:
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
                "MP = 5,",
                "MACC = 30,",
                "FASTCAST = 170,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (10394,0,'artisans_torque','artisans_torque',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (10394,'Artisan''s Torque',1,0,4194303,0,0,0,512,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (10394,5,30);",
                "INSERT INTO `item_mods` VALUES (10394,30,1);",
                "INSERT INTO `item_mods` VALUES (10394,170,5);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Neck.txt").write_text(
        "\n".join(
            (
                "Artisan's Torque",
                "[Neck]All Races",
                "Synthesis skill +2 Decreases likelihood of synthesis material loss +2%",
                "Lv.1 WAR, MNK, WHM, BLM, RDM, THF, PLD, DRK, BST, BRD, RNG, SAM, NIN, DRG, SMN, BLU, COR, PUP, DNC, SCH, GEO, RUN",
                "Obtained from crafting.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 10394"))
    finally:
        db.close()

    assert mods == {"SYNTH_MATERIAL_LOSS": 2}


def test_build_stats_db_applies_known_catseye_passive_effect_tags(tmp_path: Path) -> None:
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
                "ATT = 23,",
                "ACC = 25,",
                "DEF = 1,",
                "HP = 2,",
                "MP = 5,",
                "STORETP = 73,",
                "DMGPHYS = 161,",
                "EMPTY_KILLER = 235,",
                "SYNTH_MATERIAL_LOSS = 861,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (20810,0,'woodlander_+1','woodlander_+1',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (11531,0,'fidelity_mantle','fidelity_mantle',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (23990,0,'anima_earring','anima_earring',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (10395,0,'artisans_torque_+1','artisan\\'s_torque_+1',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (20810,'woodlander_+1',50,0,257,0,0,0,3,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (11531,'fidelity_mantle',30,0,4194303,0,0,0,32768,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (23990,'anima_earring',35,0,4194303,0,0,0,6144,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (10395,'artisan\\'s_torque_+1',1,0,4194303,0,0,0,512,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (20810,'woodlander_+1',5,0,0,0,0,0,1,276,40,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Axe.txt").write_text(
        "Woodlander +1\n[Axe]All Races\nAttack+15 Physical damage taken -10% Pet: Attack+15 Accuracy+10\nLv.50 WAR, BST\n",
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
        player_mods = {
            (item_id, mod_name): value
            for item_id, mod_name, value in db.execute(
                "select item_id, mod_name, value from item_mods where item_id in (20810, 23990, 10395)"
            )
        }
        pet_mods = {
            (item_id, mod_name): value
            for item_id, mod_name, value in db.execute(
                "select item_id, mod_name, value from item_mods_pet where item_id in (20810, 11531)"
            )
        }
        tags = {
            (item_id, effect_tag): status
            for item_id, effect_tag, status in db.execute(
                "select item_id, effect_tag, status from catseye_equipment_effect_tags"
            )
        }
        metadata = dict(db.execute("select key, value from metadata"))
    finally:
        db.close()

    assert player_mods[(20810, "ATT")] == 15
    assert player_mods[(20810, "DMGPHYS")] == -1000
    assert player_mods[(23990, "EMPTY_KILLER")] == 2
    assert player_mods[(10395, "SYNTH_MATERIAL_LOSS")] == 5
    assert pet_mods[(20810, "PET_ATK")] == 15
    assert pet_mods[(20810, "PET_ACC")] == 10
    assert pet_mods[(11531, "PET_STORETP")] == 3
    assert pet_mods[(11531, "PET_ATK")] == 3
    assert tags[(20810, "latent_level_60_plus_occasionally_attacks_twice")] == "manual_review"
    assert tags[(23990, "right_ear_magic_skills")] == "manual_review"
    assert tags[(10395, "synthesis_skill")] == "manual_review"
    assert metadata["catseye_equipment_effect_tag_count"] == str(len(tags))


def test_build_stats_db_tags_catseye_magic_potency_as_unsupported_effect(
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
    (enum_root / "mod.lua").write_text("MACC = 30,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (21169,0,'keraunos','keraunos',0,'Weapon',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (21169,'keraunos',75,0,4194303,0,0,0,3,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (21169,'keraunos',12,0,0,0,0,0,1,402,40,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Staff.txt").write_text(
        "\n".join(
            (
                "Keraunos",
                "[Staff]All Races",
                "DMG:40 Delay:402 Magic Potency+15% Magic Accuracy+30",
                "Lv.75 BLM, RDM, BRD, SMN, SCH, GEO",
                "Dropped by a Catseye source.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 21169"))
        tag = db.execute(
            """
            select effect_tag, status, target, value, mod_name
            from catseye_equipment_effect_tags
            where item_id = 21169
            """
        ).fetchone()
    finally:
        db.close()

    assert mods == {"MACC": 30}
    assert tag == ("magic_potency", "manual_review", "unsupported", 15, None)


def test_build_stats_db_moves_right_ear_skill_stats_to_conditionals(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "MP = 5,",
                "EVASION = 31,",
                "EMPTY_KILLER = 235,",
                "SHIELD = 276,",
                "PARRY = 277,",
                "GUARD = 278,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (23992,0,'spire_earring','Spire Earring',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (23992,'Spire Earring',75,0,4194303,0,0,0,6144,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (23992,31,3);",
                "INSERT INTO `item_mods` VALUES (23992,276,3);",
                "INSERT INTO `item_mods` VALUES (23992,277,3);",
                "INSERT INTO `item_mods` VALUES (23992,278,3);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Earring.txt").write_text(
        "\n".join(
            (
                "Spire Earring",
                "[Earring]All Races",
                'MP+10 "Empty Killer"+5 Right ear: Magic skills +3 '
                "(incl. Blue, Geomancy, Handbell) Right ear: Evasion skill +3 Shield skill +3 "
                "Right ear: Parrying skill +3 Guarding skill +3",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        direct_mods = dict(
            db.execute("select mod_name, value from item_mods where item_id = 23992")
        )
        conditional_mods = {
            (mod_name, value, condition_type, condition_name)
            for mod_name, value, condition_type, condition_name in db.execute(
                """
                select mod_name, value, condition_type, condition_name
                from item_conditional_mods
                where item_id = 23992
                """
            )
        }
        tag = db.execute(
            """
            select effect_tag, status, target, value
            from catseye_equipment_effect_tags
            where item_id = 23992 and effect_tag = 'right_ear_magic_skills'
            """
        ).fetchone()
    finally:
        db.close()

    assert direct_mods == {"EMPTY_KILLER": 5, "MP": 10}
    assert conditional_mods == {
        ("EVASION", 3, "slot_side", "right_ear"),
        ("GUARD", 3, "slot_side", "right_ear"),
        ("PARRY", 3, "slot_side", "right_ear"),
        ("SHIELD", 3, "slot_side", "right_ear"),
    }
    assert tag == ("right_ear_magic_skills", "manual_review", "conditional", 3)


def test_build_stats_db_moves_unknown_latent_stats_to_conditionals(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "ATT = 23,",
                "HASTE_GEAR = 384,",
                "DOUBLE_ATTACK = 288,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (15000,0,'latent_kote','Latent Kote',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (15000,'Latent Kote',75,0,4194303,0,0,0,64,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (15000,23,10);",
                "INSERT INTO `item_mods` VALUES (15000,384,200);",
                "INSERT INTO `item_mods` VALUES (15000,288,3);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Hands.txt").write_text(
        "\n".join(
            (
                "Latent Kote",
                "[Hands]All Races",
                'DEF:18 Latent effect: Attack+10 Haste+2% "Double Attack"+3%',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        direct_mods = dict(
            db.execute("select mod_name, value from item_mods where item_id = 15000")
        )
        conditional_mods = {
            (mod_name, value, condition_type, condition_name)
            for mod_name, value, condition_type, condition_name in db.execute(
                """
                select mod_name, value, condition_type, condition_name
                from item_conditional_mods
                where item_id = 15000
                """
            )
        }
    finally:
        db.close()

    assert direct_mods == {"DEF": 18}
    assert conditional_mods == {
        ("ATT", 10, "latent_unknown", "unspecified"),
        ("DOUBLE_ATTACK", 3, "latent_unknown", "unspecified"),
        ("HASTE_GEAR", 200, "latent_unknown", "unspecified"),
    }


def test_build_stats_db_scores_swordplay_and_tags_named_manual_review_effects(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "MP = 5,",
                "DARK = 116,",
                "SWORDPLAY = 1008,",
                "SYNTH_MATERIAL_LOSS = 861,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (27018,0,'futhark_mitons','Futhark Mitons',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (18543,0,'breidox','Breidox',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (10916,0,'elementium_torque','Elementium Torque',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (10394,0,'artisans_torque','Artisan\\'s Torque',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (11821,0,'khthonios_helm','Khthonios Helm',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (27018,'Futhark Mitons',75,0,4194303,0,0,0,64,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (18543,'Breidox',73,0,4194303,0,0,0,3,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (10916,'Elementium Torque',40,0,4194303,0,0,0,512,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (10394,'Artisan\\'s Torque',1,0,4194303,0,0,0,512,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (11821,'Khthonios Helm',75,0,4194303,0,0,0,16,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_weapon.sql").write_text(
        "INSERT INTO `item_weapon` VALUES (18543,'Breidox',5,0,0,0,0,0,1,288,47,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Hands.txt").write_text(
        "\n".join(
            (
                "Futhark Mitons",
                "[Hands]All Races",
                "DEF:20 HP+17 DEX+7 Swordplay +3 Enhances Sleight of Sword effect",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Khthonios Helm",
                "[Head]All Races",
                "DEF:29 HP+14 STR+7 INT+7 Dark magic skill+9",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Axe.txt").write_text(
        "\n".join(
            (
                "Breidox",
                "[Axe]All Races",
                "DMG:47 Delay:288 HP+5 STR+3 Enmity+3 Fencer+1 Pet: STR+3",
                "Lv.73 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Neck.txt").write_text(
        "\n".join(
            (
                "Elementium Torque",
                "[Neck]All Races",
                "MP+15 Magic skill+3 (incl. Blue, Geomancy, Handbell)",
                "Lv.40 All Jobs",
                "Dropped by test fixture.",
                "Artisan's Torque",
                "[Neck]All Races",
                "Synthesis skill +2 Decreases likelihood of synthesis material loss +2%",
                "Lv.1 All Jobs",
                "Dropped by test fixture.",
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
        futhark_mods = dict(
            db.execute("select mod_name, value from item_mods where item_id = 27018")
        )
        khthonios_mods = dict(
            db.execute("select mod_name, value from item_mods where item_id = 11821")
        )
        tags = {
            (item_id, effect_tag): (status, target, value)
            for item_id, effect_tag, status, target, value in db.execute(
                """
                select item_id, effect_tag, status, target, value
                from catseye_equipment_effect_tags
                where item_id in (18543, 10916, 10394, 11821)
                order by item_id, effect_tag
                """
            )
        }
    finally:
        db.close()

    assert futhark_mods["SWORDPLAY"] == 3
    assert khthonios_mods["DARK"] == 9
    assert tags[(18543, "fencer_trait_tier")] == ("manual_review", "unsupported", 1)
    assert tags[(10916, "magic_skill")] == ("manual_review", "unsupported", 3)
    assert tags[(10394, "synthesis_skill")] == ("manual_review", "unsupported", 2)
    assert (11821, "magic_skill") not in tags
    assert result.catseye_equipment_effect_tag_count >= 3


def test_build_stats_db_scores_crafting_success_and_blood_boon(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "BLOOD_BOON = 913,",
                "SYNTH_SUCCESS_RATE = 851,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (28565,0,'artisans_ring','Artisan\\'s Ring',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (11700,0,'covenant_belt','Covenant Belt',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (28565,'Artisan\\'s Ring',1,0,4194303,0,0,0,24576,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (11700,'Covenant Belt',75,0,4194303,0,0,0,1024,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Ring.txt").write_text(
        "\n".join(
            (
                "Artisan's Ring",
                "[Ring]All Races",
                "Synthesis Success Rate +2% Cannot synthesize high quality items",
                "Lv.1 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Waist.txt").write_text(
        "\n".join(
            (
                "Covenant Belt",
                "[Waist]All Races",
                '"Blood Boon"+3',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        artisan_mods = dict(
            db.execute("select mod_name, value from item_mods where item_id = 28565")
        )
        covenant_mods = dict(
            db.execute("select mod_name, value from item_mods where item_id = 11700")
        )
    finally:
        db.close()

    assert artisan_mods == {"SYNTH_SUCCESS_RATE": 2}
    assert covenant_mods == {"BLOOD_BOON": 3}


def test_build_stats_db_scores_quoted_catseye_job_ability_mods(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "BP_DELAY = 357,",
                "BARRAGE_COUNT = 138,",
                "BP_DELAY_II = 541,",
                "BERSERK_DURATION = 954,",
                "AGGRESSOR_DURATION = 955,",
                "SIC_READY_RECAST = 1052,",
                "DEAD_AIM_EFFECT = 1054,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39000,0,'ability_harness','Ability Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39000,'Ability Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Ability Harness",
                "[Body]All Races",
                '"Blood Pact" ability delay-2 "Blood Pact" recast time II-2 '
                '" Sic " and " Ready " ability delay-2 "Barrage"+1 "Dead Aim"+5 '
                '"Berserk/Aggressor" effect duration+10 "Berserk" effect duration+15',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39000"))
    finally:
        db.close()

    assert mods == {
        "BP_DELAY": 2,
        "BP_DELAY_II": 2,
        "SIC_READY_RECAST": 2,
        "BARRAGE_COUNT": 1,
        "DEAD_AIM_EFFECT": 5,
        "BERSERK_DURATION": 25,
        "AGGRESSOR_DURATION": 10,
    }
    assert result.catseye_equipment_stat_override_count == 7


def test_build_stats_db_scores_quote_wrapped_catseye_passive_mods(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "BINDRES = 247,",
                "TANDEM_STRIKE_POWER = 271,",
                "TANDEM_BLOW_POWER = 272,",
                "MATT = 28,",
                "STEAL = 298,",
                "TRIPLE_ATTACK = 302,",
                "RECYCLE = 305,",
                "NINJA_TOOL = 308,",
                "REGEN_DURATION = 339,",
                "PAEON_EFFECT = 435,",
                "REQUIEM_EFFECT = 436,",
                "SAMBA_DURATION = 490,",
                "OCCULT_ACUMEN = 902,",
                "INDI_DURATION = 960,",
                "PFLUG = 1011,",
                "VIVACIOUS_PULSE_POTENCY = 1012,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39001,0,'passive_harness','Passive Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39001,'Passive Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Passive Harness",
                "[Body]All Races",
                '"Magic Attack Bonus"+6 "Ninja Tool Expertise"+5 "Occult Acumen"+20 '
                '"Paeon"+3 "Pflug"+10 "Recycle"+5 "Regen" Duration+20 '
                '"Requiem"+2 "Resist Bind"+3 "Samba" Duration+20 "Steal"+1 '
                '"Tandem Blow" effect+6 "Tandem Strike" effect+6 "Triple Atk."+3% '
                '"Vivacious Pulse" potency+10% Indicolure spell duration+12',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39001"))
    finally:
        db.close()

    assert mods == {
        "MATT": 6,
        "NINJA_TOOL": 5,
        "OCCULT_ACUMEN": 20,
        "PAEON_EFFECT": 3,
        "PFLUG": 10,
        "RECYCLE": 5,
        "REGEN_DURATION": 20,
        "REQUIEM_EFFECT": 2,
        "BINDRES": 3,
        "SAMBA_DURATION": 20,
        "STEAL": 1,
        "TANDEM_BLOW_POWER": 6,
        "TANDEM_STRIKE_POWER": 6,
        "TRIPLE_ATTACK": 3,
        "VIVACIOUS_PULSE_POTENCY": 10,
        "INDI_DURATION": 12,
    }
    assert result.catseye_equipment_stat_override_count == 16


def test_build_stats_db_scores_one_off_server_backed_effects(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "BP_DAMAGE = 126,",
                "COOK = 135,",
                "DARK = 116,",
                "AMNESIARES = 253,",
                "DOUBLE_ATTACK = 288,",
                "SYNTH_MATERIAL_LOSS = 861,",
                "BREATH_DMG_DEALT = 1075,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39002,0,'server_effect_harness','Server Effect Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39002,'Server Effect Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Server Effect Harness",
                "[Body]All Races",
                "Amnesia Resistance+15 Blood Pact damage+3% Breath damage dealt+10 "
                "Cooking Skill+1 Dark Skill+12 Dbl. Atk+2% "
                "Decreases likelihood of synthesis material loss+2%",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39002"))
    finally:
        db.close()

    assert mods == {
        "AMNESIARES": 15,
        "BP_DAMAGE": 3,
        "BREATH_DMG_DEALT": 10,
        "COOK": 1,
        "DARK": 12,
        "DOUBLE_ATTACK": 2,
        "SYNTH_MATERIAL_LOSS": 2,
    }
    assert result.catseye_equipment_stat_override_count == 7


def test_build_stats_db_scores_catseye_typo_aliases(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "MDEF = 29,",
                "RATT = 24,",
                "GUARD = 107,",
                "ELEM = 115,",
                "NINJUTSU = 118,",
                "ENMITY_LOSS_REDUCTION = 427,",
                "ENSPELL_DMG_BONUS = 432,",
                "OCCULT_ACUMEN = 902,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39003,0,'typo_alias_harness','Typo Alias Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39003,'Typo Alias Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Typo Alias Harness",
                "[Body]All Races",
                "Enmity Loss reduction-20 Enmity Loss Reduction+30 Enspell Damage Bonus+15 "
                "Elemental Skill+15 Guard skill+5 NinjutsuSkill+10 "
                "Occult Acument+5 Occult Occument+30 Ranged Atttack+8 "
                "Magic Def. Bonus-3%",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39003"))
    finally:
        db.close()

    assert mods == {
        "ENMITY_LOSS_REDUCTION": 50,
        "ENSPELL_DMG_BONUS": 15,
        "ELEM": 15,
        "GUARD": 5,
        "NINJUTSU": 10,
        "OCCULT_ACUMEN": 35,
        "RATT": 8,
        "MDEF": -3,
    }
    assert result.catseye_equipment_stat_override_count == 8


def test_build_stats_db_scores_server_backed_catseye_aliases(
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
    (enum_root / "mod.lua").write_text(
        "RAPID_SHOT = 359,\n",
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39004,0,'server_alias_harness','Server Alias Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39004,'Server Alias Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Server Alias Harness",
                "[Body]All Races",
                "Rapid Shot+5% Rapidshot+5 Ranged delay -3% Jig Duration+20 "
                "Lullaby+3 Magic crit. hit rate+5 Magical Critical Hit Dmg+5% "
                "Maximum Finishing Moves+1 Repair Potency+10% "
                "Magic Damage Taken II -5% Physical Damage taken II -10%",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39004"))
    finally:
        db.close()

    assert mods == {
        "RAPID_SHOT": 10,
        "RANGED_DELAYP": -3,
        "JIG_DURATION": 20,
        "LULLABY_EFFECT": 3,
        "MAGIC_CRITHITRATE": 5,
        "MAGIC_CRIT_DMG_INCREASE": 5,
        "MAX_FINISHING_MOVE_BONUS": 1,
        "REPAIR_POTENCY": 10,
        "DMGMAGIC_II": -500,
        "DMGPHYS_II": -1000,
    }
    assert result.catseye_equipment_stat_override_count == 10


def test_build_stats_db_scores_server_backed_catseye_utility_effects(
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
    (enum_root / "mod.lua").write_text(
        "ROLL_RANGE = 528,\n",
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39005,0,'utility_effect_harness','Utility Effect Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39005,'Utility Effect Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Utility Effect Harness",
                "[Body]All Races",
                'Increases "Phantom Roll" area of effect+2 '
                "Grimoire: Spellcasting time-8% "
                '"Dark Arts"+17 "Light Arts"+17 '
                'Adds "Regen" effect Life Cycle+3 '
                'Adds "Regen" effect Utsusemi+1 '
                "Ironskin (Stoneskin+10 "
                "Elemental Debuff Potency+4",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39005"))
    finally:
        db.close()

    assert mods == {
        "ROLL_RANGE": 2,
        "GRIMOIRE_SPELLCASTING": -8,
        "DARK_ARTS_EFFECT": 17,
        "LIGHT_ARTS_EFFECT": 17,
        "LIFE_CYCLE_EFFECT": 3,
        "UTSUSEMI_BONUS": 1,
        "STONESKIN_BONUS_HP": 10,
        "ELEMENTAL_DEBUFF_EFFECT": 4,
    }
    assert result.catseye_equipment_stat_override_count == 8


def test_build_stats_db_scores_catseye_resist_and_cast_aliases(
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
    (enum_root / "mod.lua").write_text(
        "CHARMRES = 252,\n",
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39006,0,'resist_alias_harness','Resist Alias Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39006,'Resist Alias Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Resist Alias Harness",
                "[Body]All Races",
                "Elemental casting time -6% Elemental magic casting time-8% "
                'Resist Charm+15 Potency of "Cure" effect received+5% '
                'Potency of "Cure" received+15% Light Resist+13 Resist All Elements+10',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39006"))
    finally:
        db.close()

    assert mods == {
        "ELEMENTAL_CELERITY": 14,
        "CHARMRES": 15,
        "CURE_POTENCY_RCVD": 20,
        "FIRE_MEVA": 10,
        "ICE_MEVA": 10,
        "WIND_MEVA": 10,
        "EARTH_MEVA": 10,
        "THUNDER_MEVA": 10,
        "WATER_MEVA": 10,
        "LIGHT_MEVA": 23,
        "DARK_MEVA": 10,
    }
    assert result.catseye_equipment_stat_override_count == 11


def test_build_stats_db_does_not_downgrade_existing_server_mod_with_lower_wiki_value(
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
    (enum_root / "mod.lua").write_text(
        "ELEMENTAL_CELERITY = 901,\n",
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39007,0,'server_authority_harness','Server Authority Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39007,'Server Authority Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "INSERT INTO `item_mods` VALUES (39007,901,11);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Server Authority Harness",
                "[Body]All Races",
                "Elemental casting time -6%",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39007"))
        overrides = list(
            db.execute(
                """
                select mod_name, original_value, catseye_value
                from catseye_equipment_stat_overrides
                where item_id = 39007
                """
            )
        )
    finally:
        db.close()

    assert mods == {"ELEMENTAL_CELERITY": 11}
    assert overrides == []
    assert result.catseye_equipment_stat_override_count == 0


def test_build_stats_db_scores_remaining_server_backed_catseye_aliases(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "BLINDRES = 243,",
                "PETRIFYRES = 246,",
                "SILENCERES = 244,",
                "SLEEPRES = 240,",
                "STRING = 120,",
                "SUMMONING = 117,",
                "SONG_DURATION_BONUS = 454,",
                "SUBTLE_BLOW_II = 973,",
                "SPELLINTERRUPT = 168,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39008,0,'server_backed_alias_harness','Server Backed Alias Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39008,'Server Backed Alias Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Server Backed Alias Harness",
                "[Body]All Races",
                "Resist Blind+3 Resist Petrify+15 Resist Silence+3 Resist Sleep+3 "
                "Silence Resistance+15 String Skill+8 Summoning skill+8 "
                "Song Duration Bonus+25 Subtle Blow II+6 "
                "Spell Interrupt-20% Spell Interruption Rate-15% "
                "Spell Interruption Rate Down+5%",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39008"))
    finally:
        db.close()

    assert mods == {
        "BLINDRES": 3,
        "PETRIFYRES": 15,
        "SILENCERES": 18,
        "SLEEPRES": 3,
        "STRING": 8,
        "SUMMONING": 8,
        "SONG_DURATION_BONUS": 25,
        "SUBTLE_BLOW_II": 6,
        "SPELLINTERRUPT": -30,
    }
    assert result.catseye_equipment_stat_override_count == 9


def test_build_stats_db_resolves_catseye_full_names_to_abbreviated_rows(
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
    (enum_root / "mod.lua").write_text(
        "\n".join(
            (
                "AXE = 84,",
                "INT = 12,",
                "MP = 5,",
                "DEF = 1,",
                "CHR = 14,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (10515,0,'axe_gauntlets','Axe. Gauntlets',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (22198,0,'neph_grip','Neph. Grip',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (25557,0,'harv_sun_hat','Harv. Sun Hat',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (28443,0,'brig_eyepatch','Brig. Eyepatch',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (10515,'Axe. Gauntlets',30,0,4194303,0,0,0,64,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (22198,'Neph. Grip',8,0,4194303,0,0,0,2,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (25557,'Harv. Sun Hat',1,0,4194303,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (28443,'Brig. Eyepatch',50,0,4194303,0,0,0,16,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Misc.txt").write_text(
        "\n".join(
            (
                "Axemaster's Gauntlets",
                "[Hands]All Races",
                "DEF:12 Haste+2% Axe skill+7",
                "Lv.30 WAR, DRK, BST, RUN",
                "Obtained via Incursion.",
                "Nephilim Grip",
                "[Grip]All Races",
                "MP+6 INT+1 Hidden Effect: Alchemy Skill+1 Cooking Skill+1",
                "Lv.8 All Jobs",
                "Obtained via Incursion.",
                "Harvester's Sun Hat",
                "[Head]All Races",
                'DEF:1 "Surveyor"+1',
                "Lv.1 All Jobs",
                "Obtained via HELM Ventures.",
                "Brigand's Eyepatch",
                "[Head]All Races",
                'DEF:15 MP+15 CHR+3 +10 "Expert Angler"+2',
                "Lv.50 All Jobs",
                "Crooked Jones shop",
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
        overrides = dict(
            db.execute("select item_id, catseye_name from catseye_equipment_overrides")
        )
        mods = {
            item_id: dict(
                db.execute(
                    "select mod_name, value from item_mods where item_id = ?",
                    (item_id,),
                )
            )
            for item_id in (10515, 22198, 25557, 28443)
        }
        effect_tags = {
            item_id: {
                effect_tag
                for (effect_tag,) in db.execute(
                    "select effect_tag from catseye_equipment_effect_tags where item_id = ?",
                    (item_id,),
                )
            }
            for item_id in (22198, 25557, 28443)
        }
    finally:
        db.close()

    assert overrides == {10515: "Axemaster's Gauntlets"}
    assert mods[10515]["AXE"] == 7
    assert mods[22198] == {"MP": 6, "INT": 1}
    assert mods[25557] == {"DEF": 1}
    assert mods[28443]["DEF"] == 15
    assert mods[28443]["MP"] == 15
    assert mods[28443]["CHR"] == 3
    assert effect_tags[22198] == {"hidden_alchemy_skill", "hidden_cooking_skill"}
    assert effect_tags[25557] == {"surveyor"}
    assert effect_tags[28443] == {"expert_angler"}
    assert result.catseye_equipment_override_count == 1


def test_build_stats_db_tags_manual_review_catseye_mechanics(
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
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39009,0,'manual_review_harness','Manual Review Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39009,'Manual Review Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Manual Review Harness",
                "[Body]All Races",
                'DEF:5 +5 DMG+3 "Overload" rate-5 '
                'Resist DEATH/DMG+3 Healing magic casting time-3% '
                'Weapon skill damage+15% Latent effect: Weapon skill damage+1 Latent effect: DMG+14 '
                'Augments "Reward" Charm+6 Enhances "Reward" effect Charm+2 '
                'Augments "Call Beast" Charm+4 Improves "Tame" success rate Charm+4 '
                'Vs. Lizards: "Charm"+5 "Charm"+3 '
                'Automaton: Magic Skills+9 Automaton: Skills+5 Avatar elemental resistance+25 '
                'Combat skills+8 Magic skills+8 Hidden Effect: Alchemy Skill+1 '
                'Shield Bash+10 Weapon Bash+10 Third Eye+15 Reward+15 '
                '"Angon": Drains movement speed "Angon": Duration+30 '
                'Tomahawk: Grants "Potency" Tomahawk: Duration+30 '
                '"Lunge"+5 Accomplice/Collaborator Effect+15 '
                'Furnace blessing (Regen Potency+1 '
                'Handbell) MP not depleted when magic used+1% '
                'Potency of "Banish" vs. undead+5 Item Add Effect Type+10 '
                '"Feral Heart" (Killer Effects+5% Killer Effects+2 NT+3 '
                "Oggbi's Wisdom (Guard+5% "
                '"Wings-Era Warriors: ": Enchantment: "Recollection" "Treasure Hunter"+1 '
                'Elemental Resistance spells+22 Latent Effect (Cursed): "Conserve MP"+5 '
                'Poison effect+5 Step TP consumed-30 Step TP Consumed-50 '
                'times (Hidden effect: "Tactical Parry"+5% '
                'Absorb Damage to MP+5 Enhances "Snapshot" effect Grants "Rapid Shot" II '
                "Royal Knight's Pledge (Light Def+15 Dark Def-20, Regen+1, Absorb Dmg to MP+2) "
                "Luzaf's Curse (Fire Def-20, Ice Def+15, Light Def-20, Dark Def+15, Regen+1) "
                'Additional effect: Recover MP Additional effect: Flash "Domain Incursion" '
                "(Hidden effect: Deals piercing damage) Latent effect: DMG:42 "
                'Enhances "Resist Silence" effect Enhances effect of "Cursna" received '
                'Enhances monster correlation effects Enhances avatar attack (+10) Enhances Battuta '
                'Adds "Refresh" effect Adds "Regen" effect Converts 50 HP to MP '
                'Occ. Quickens Spellcasting +3% Additional effect: Water Additional effect: TP Drain '
                'Hidden effect: Blunt damage Grants "Tactical Parry" Grants "Magic Burst Bonus" '
                'Augments "Third Eye" Wyvern uses breaths more effectively '
                "Latent effect: Bonus to Magic Accuracy+1~4 "
                "Latent effect: Increases critical hit damage "
                "MP recovered while healing +2 (Latent: Below level 50) "
                "Additional effect: Ice damage Additional effect with wind fan equipped: Wind damage "
                "Additional effect: Poison, Paralysis, or Bind Additional effect: HP Drain "
                "Hidden Effect: Slashing damage Hidden Effect: Pet: Ranged Acccuracy+8 "
                "Hidden Effect: All elements: Magic Potency+15%, Magic Accuracy+30 "
                'Physical damage: "Shock Spikes" effect',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        tags = {
            (effect_tag, status, target, value)
            for effect_tag, status, target, value in db.execute(
                """
                select effect_tag, status, target, value
                from catseye_equipment_effect_tags
                where item_id = 39009
                """
            )
        }
        scored_mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39009"))
    finally:
        db.close()

    expected_tags = {
        ("unlabeled_signed_source_fragment", "manual_review", "source_anomaly", 5),
        ("weapon_damage_delta", "manual_review", "source_anomaly", 3),
        ("overload_rate", "manual_review", "unsupported", -5),
        ("resist_death_damage", "manual_review", "unsupported", 3),
        ("healing_magic_casting_time", "manual_review", "unsupported", -3),
        ("weapon_skill_damage", "manual_review", "unsupported", 15),
        ("latent_weapon_skill_damage", "manual_review", "unsupported", 1),
        ("latent_weapon_damage", "manual_review", "unsupported", 14),
        ("reward_charm_bonus", "manual_review", "unsupported", 6),
        ("reward_effect_charm_bonus", "manual_review", "unsupported", 2),
        ("call_beast_charm_bonus", "manual_review", "unsupported", 4),
        ("tame_charm_bonus", "manual_review", "unsupported", 4),
        ("family_charm_bonus", "manual_review", "unsupported", 5),
        ("charm_bonus", "manual_review", "unsupported", 3),
        ("automaton_magic_skills", "manual_review", "unsupported", 9),
        ("automaton_skills", "manual_review", "unsupported", 5),
        ("avatar_elemental_resistance", "manual_review", "unsupported", 25),
        ("combat_skills", "manual_review", "unsupported", 8),
        ("magic_skills", "manual_review", "unsupported", 8),
        ("hidden_alchemy_skill", "manual_review", "utility", 1),
        ("shield_bash", "manual_review", "unsupported", 10),
        ("weapon_bash", "manual_review", "unsupported", 10),
        ("third_eye", "manual_review", "unsupported", 15),
        ("reward", "manual_review", "unsupported", 15),
        ("angon_effect", "manual_review", "unsupported", 30),
        ("tomahawk_effect", "manual_review", "unsupported", 30),
        ("lunge", "manual_review", "unsupported", 5),
        ("accomplice_collaborator_effect", "manual_review", "unsupported", 15),
        ("furnace_blessing_regen_potency", "manual_review", "unsupported", 1),
        ("handbell_mp_not_depleted", "manual_review", "unsupported", 1),
        ("banish_vs_undead_potency", "manual_review", "unsupported", 5),
        ("item_add_effect_type", "manual_review", "unsupported", 10),
        ("feral_heart_killer_effects", "manual_review", "unsupported", 5),
        ("killer_effects", "manual_review", "unsupported", 2),
        ("nt", "manual_review", "unsupported", 3),
        ("oggbis_wisdom_guard", "manual_review", "unsupported", 5),
        ("wings_era_recollection_treasure_hunter", "manual_review", "unsupported", 1),
        ("elemental_resistance_spells", "manual_review", "unsupported", 22),
        ("latent_cursed_conserve_mp", "manual_review", "unsupported", 5),
        ("poison_effect", "manual_review", "unsupported", 5),
        ("step_tp_consumed", "manual_review", "unsupported", -30),
        ("hidden_tactical_parry", "manual_review", "unsupported", 5),
        ("absorb_damage_to_mp", "manual_review", "unsupported", 5),
        ("snapshot_effect", "manual_review", "unsupported", None),
        ("rapid_shot_trait_tier", "manual_review", "unsupported", None),
        ("royal_knights_pledge", "manual_review", "unsupported", None),
        ("luzafs_curse", "manual_review", "unsupported", None),
        ("additional_effect_recover_mp", "manual_review", "unsupported", None),
        ("additional_effect_flash", "manual_review", "unsupported", None),
        ("domain_incursion_marker", "manual_review", "source_marker", None),
        ("hidden_piercing_damage", "manual_review", "unsupported", None),
        ("latent_weapon_damage_absolute", "manual_review", "unsupported", 42),
        ("generic_enhances_effect", "manual_review", "unsupported", None),
        ("adds_refresh_effect", "manual_review", "unsupported", None),
        ("adds_regen_effect", "manual_review", "unsupported", None),
        ("converts_hp_to_mp", "manual_review", "unsupported", 50),
        ("occ_quickens_spellcasting", "manual_review", "unsupported", 3),
        ("additional_effect_water", "manual_review", "unsupported", None),
        ("additional_effect_tp_drain", "manual_review", "unsupported", None),
        ("hidden_blunt_damage", "manual_review", "unsupported", None),
        ("grants_tactical_parry", "manual_review", "unsupported", None),
        ("grants_magic_burst_bonus", "manual_review", "unsupported", None),
        ("augments_third_eye", "manual_review", "unsupported", None),
        ("wyvern_breaths", "manual_review", "unsupported", None),
        ("latent_range_stat", "manual_review", "unsupported", None),
        ("latent_critical_hit_damage", "manual_review", "unsupported", None),
        ("latent_condition_marker", "manual_review", "conditional", None),
        ("additional_effect_generic", "manual_review", "unsupported", None),
        ("hidden_slashing_damage", "manual_review", "unsupported", None),
        ("hidden_pet_ranged_accuracy", "manual_review", "unsupported", 8),
        ("hidden_all_elements_magic_potency", "manual_review", "unsupported", None),
        ("physical_damage_spikes", "manual_review", "unsupported", None),
        ("light_defense", "manual_review", "unsupported", 15),
        ("dark_defense", "manual_review", "unsupported", -20),
        ("fire_defense", "manual_review", "unsupported", -20),
        ("ice_defense", "manual_review", "unsupported", 15),
    }
    assert expected_tags.issubset(tags)
    assert scored_mods == {"DEF": 5}
    assert result.catseye_equipment_effect_tag_count >= len(expected_tags)


def test_build_stats_db_tags_ram_mantle_augment_paths(tmp_path: Path) -> None:
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
                "INSERT INTO `item_basic` VALUES (13570,0,'ram_mantle','Ram Mantle',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (13575,0,'ram_mantle_+1','Ram Mantle +1',0,'Armor',1,0,0,0);",
            )
        )
        + "\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (13570,'Ram Mantle',36,0,2473971,0,0,0,32768,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (13575,'Ram Mantle +1',36,0,2473971,0,0,0,32768,0,0,0);",
            )
        )
        + "\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Back.txt").write_text(
        "\n".join(
            (
                "Ram Mantle",
                "[Back]All Races",
                "DEF:5 +5 DEX+2 AGI+2 HP recovered while healing +2",
                "Lv.36 WAR, MNK, RDM, THF, PLD, DRK, BST, BRD, RNG, SAM, NIN, DRG, BLU, COR, DNC, RUN",
                "A Matter of Trust III custom quest.",
                "Ram Mantle",
                "[Back]All Races",
                "DEF:5 +5 HP+0~25 Enmity+0~2",
                "Lv.36 WAR, MNK, RDM, THF, PLD, DRK, BST, BRD, RNG, SAM, NIN, DRG, BLU, COR, DNC, RUN",
                "Obtained through EXP Ventures Rewards.",
                "Ram Mantle +1",
                "[Back]All Races",
                "DEF:6 +5 HP+0~25 Enmity+0~2",
                "Lv.36 WAR, MNK, RDM, THF, PLD, DRK, BST, BRD, RNG, SAM, NIN, DRG, BLU, COR, DNC, RUN",
                "Transfer augments from NQ to HQ at with Populox.",
                "Ram Mantle +1",
                "[Back]All Races",
                "DEF:6 +6 DEX+2 AGI+2 HP recovered while healing +2",
                "Lv.36 WAR, MNK, RDM, THF, PLD, DRK, BST, BRD, RNG, SAM, NIN, DRG, BLU, COR, DNC, RUN",
                "Transfer augments from NQ to HQ version with Ametrine.",
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
        tags = {
            item_id: {
                effect_tag
                for (effect_tag,) in db.execute(
                    """
                    select effect_tag
                    from catseye_equipment_effect_tags
                    where item_id = ? and target = 'augment_path'
                    """,
                    (item_id,),
                )
            }
            for item_id in (13570, 13575)
        }
    finally:
        db.close()

    assert tags[13570] == {"ventures_path_random_hp_enmity_augments"}
    assert tags[13575] == {
        "populox_path_random_hp_enmity_augments",
        "ametrine_path_dex_agi_hpheal_augments",
    }


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


def test_build_stats_db_imports_visible_catseye_direct_stats_and_removes_stale_absent_stats(tmp_path: Path) -> None:
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
                "MP = 5,",
                "VIT = 10,",
                "INT = 12,",
                "ENMITY = 27,",
                "MDEF = 29,",
                "MACC = 30,",
                "MEVA = 31,",
                "EVA = 68,",
                "FISH = 127,",
                "DEATHRES = 255,",
                "RETALIATION = 414,",
                "TACTICAL_PARRY = 486,",
                "BP_DELAY = 357,",
                "HASTE_GEAR = 384,",
                "PERPETUATION_REDUCTION = 346,",
                "CURE_CAST_TIME = 519,",
                "DAKEN = 911,",
                "ONE_HOUR_RECAST = 996,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (27767,0,'buremte_hat','Erudite Cap',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (14378,0,'hecatomb_harness','Hecatomb Harness',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (14487,0,'evokers_doublet_p1','Evokers Doublet +1',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (18628,0,'flete_pole','Flete Pole',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (20001,0,'utility_harness','Utility Harness',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (27767,'Erudite Cap',99,0,1589788,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (14378,'Hecatomb Harness',75,0,2593826,0,0,0,32,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (14487,'Evokers Doublet +1',74,0,16384,0,0,0,32,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (18628,'Flete Pole',70,0,16384,0,0,0,1,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (20001,'Utility Harness',75,0,65535,0,0,0,32,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_mods` VALUES (27767,1,84);",
                "INSERT INTO `item_mods` VALUES (27767,5,30);",
                "INSERT INTO `item_mods` VALUES (27767,10,20);",
                "INSERT INTO `item_mods` VALUES (27767,12,24);",
                "INSERT INTO `item_mods` VALUES (27767,29,4);",
                "INSERT INTO `item_mods` VALUES (27767,30,15);",
                "INSERT INTO `item_mods` VALUES (27767,31,65);",
                "INSERT INTO `item_mods` VALUES (27767,68,28);",
                "INSERT INTO `item_mods` VALUES (14378,1,50);",
                "INSERT INTO `item_mods` VALUES (14378,2,16);",
                "INSERT INTO `item_mods` VALUES (14378,8,12);",
                "INSERT INTO `item_mods` VALUES (14378,25,10);",
                "INSERT INTO `item_mods` VALUES (14378,384,-1200);",
                "INSERT INTO `item_mods` VALUES (14487,1,35);",
                "INSERT INTO `item_mods` VALUES (14487,5,45);",
                "INSERT INTO `item_mods` VALUES (14487,357,3);",
                "INSERT INTO `item_mods` VALUES (18628,23,7);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Erudite Cap",
                "[Head]All Races",
                'DEF:25 MP+30 VIT+3 INT+5 Magic Accuracy+5 "Cure" spellcasting time -5% MND+0~5 Enmity-0~5 Fast Cast+0~2%',
                "Lv.70 WHM, BLM, RDM, BRD, SMN, SCH",
                "Dropped by test fixture.",
                "Evokers Doublet +1",
                "[Body]All Races",
                "DEF:35 MP+45 Blood Pact ability delay -4 MP recovered while healing +5",
                "Lv.74 SMN",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Hecatomb Harness",
                "[Body]All Races",
                "DEF:50 HP+16 STR+12 Accuracy+10 Slow+13% DEX+0~3 Store TP+0~3",
                "Lv.75 WAR, PLD, DRK, BST, DRG",
                "Dropped by test fixture.",
                "Utility Harness",
                "[Body]All Races",
                'SP Ability delay -5 Resist "Death"+3 Fishing skill +2 Retaliation+3% Tactical Parry+10 "Daken"+5',
                "Lv.75 WAR, MNK, THF, NIN",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Staff.txt").write_text(
        "\n".join(
            (
                "Flete Pole",
                "[Staff]All Races",
                "DMG:66 Delay:402 Attack+7 Haste+1% Summoning Magic Skill+2 Avatar Perpetuation-2",
                "Lv.70 SMN",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 27767"))
        hecatomb_mods = dict(db.execute("select mod_name, value from item_mods where item_id = 14378"))
        evokers_mods = dict(db.execute("select mod_name, value from item_mods where item_id = 14487"))
        flete_mods = dict(db.execute("select mod_name, value from item_mods where item_id = 18628"))
        utility_mods = dict(db.execute("select mod_name, value from item_mods where item_id = 20001"))
        overrides = {
            mod_name: (original_value, catseye_value)
            for mod_name, original_value, catseye_value in db.execute(
                """
                select mod_name, original_value, catseye_value
                from catseye_equipment_stat_overrides
                where item_id = 27767
                """
            )
        }
    finally:
        db.close()

    assert mods == {
        "DEF": 25,
        "MP": 30,
        "VIT": 3,
        "INT": 5,
        "MACC": 5,
        "CURE_CAST_TIME": -5,
    }
    assert "MDEF" not in mods
    assert "MEVA" not in mods
    assert "EVA" not in mods
    assert hecatomb_mods["HASTE_GEAR"] == -1300
    assert "DEX" not in hecatomb_mods
    assert "STORETP" not in hecatomb_mods
    assert evokers_mods["BP_DELAY"] == 4
    assert flete_mods["PERPETUATION_REDUCTION"] == 2
    assert utility_mods["ONE_HOUR_RECAST"] == 5
    assert utility_mods["DEATHRES"] == 3
    assert utility_mods["FISH"] == 2
    assert utility_mods["RETALIATION"] == 3
    assert utility_mods["TACTICAL_PARRY"] == 10
    assert utility_mods["DAKEN"] == 5
    assert overrides["CURE_CAST_TIME"] == (None, -5)
    assert result.catseye_equipment_stat_override_count == 17


def test_build_stats_db_maps_catseye_hp_mp_percent_to_percent_mods(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "\n".join(("HP = 2,", "HPP = 3,", "MP = 5,", "MPP = 6,")),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (39010,0,'percent_harness','Percent Harness',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (39011,0,'percent_only_harness','Percent Only Harness',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (39010,'Percent Harness',75,0,4194303,0,0,0,32,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (39011,'Percent Only Harness',75,0,4194303,0,0,0,32,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Percent Harness",
                "[Body]All Races",
                "HP+5% MP+3% HP+30 MP+20",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
                "Percent Only Harness",
                "[Body]All Races",
                "HP+5% MP+3%",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39010"))
        percent_only_mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39011"))
    finally:
        db.close()

    assert mods == {"HPP": 5, "MPP": 3, "HP": 30, "MP": 20}
    assert percent_only_mods == {"HPP": 5, "MPP": 3}


def test_build_stats_db_does_not_parse_contextual_mp_effects_as_flat_mp(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "\n".join(("MP = 5,", "MPHEAL = 71,", "CONSERVE_MP = 296,")),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39012,0,'context_mp_harness','Context MP Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39012,'Context MP Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Context MP Harness",
                "[Body]All Races",
                "Conserve MP+2 MP recovered while healing +1",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39012"))
    finally:
        db.close()

    assert mods == {"CONSERVE_MP": 2, "MPHEAL": 1}


def test_build_stats_db_maps_catseye_magic_evasion_to_meva(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "\n".join(("EVA = 68,", "MEVA = 31,")),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "INSERT INTO `item_basic` VALUES (39013,0,'meva_harness','Meva Harness',0,'Armor',1,0,0,0);\n",
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "INSERT INTO `item_equipment` VALUES (39013,'Meva Harness',75,0,4194303,0,0,0,32,0,0,0);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Meva Harness",
                "[Body]All Races",
                "Magic Evasion+3 Evasion+5",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = dict(db.execute("select mod_name, value from item_mods where item_id = 39013"))
    finally:
        db.close()

    assert mods == {"MEVA": 3, "EVA": 5}


def test_build_stats_db_imports_explicit_catseye_enhances_effect_bonuses(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text(
        "\n".join(("DUAL_WIELD = 259,", "FASTCAST = 170,")),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (10893,0,'heroic_hairpin','Heroic Hairpin',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (11544,0,'veela_cape','Veela Cape',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (27194,0,'futhark_trousers','Futhark Trousers',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (10893,'Heroic Hairpin',75,0,65535,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (11544,'Veela Cape',75,0,65535,0,0,0,32768,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (27194,'Futhark Trousers',75,0,65535,0,0,0,128,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Heroic Hairpin",
                "[Head]All Races",
                'HP+15 Haste+2% Physical damage taken -2% Enhances "Dual Wield" effect +3%',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Back.txt").write_text(
        "\n".join(
            (
                "Veela Cape",
                "[Back]All Races",
                'DEF:5 MP+10 Enhances "Fast Cast" effect (+1%)',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Legs.txt").write_text(
        "\n".join(
            (
                "Futhark Trousers",
                "[Legs]All Races",
                "DEF:41 HP+20 MP+20 VIT+7 DEX+7 Enhancing magic duration +10% Enhances Fast Cast effect +10",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = {
            item_id: dict(rows)
            for item_id, rows in (
                (
                    item_id,
                    db.execute(
                        """
                        select mod_name, value
                        from item_mods
                        where item_id = ?
                        """,
                        (item_id,),
                    ),
                )
                for item_id in (10893, 11544, 27194)
            )
        }
        overrides = {
            (item_id, mod_name): value
            for item_id, mod_name, value in db.execute(
                """
                select item_id, mod_name, catseye_value
                from catseye_equipment_stat_overrides
                where item_id in (10893, 11544, 27194)
                    and mod_name in ('DUAL_WIELD', 'FASTCAST')
                """
            )
        }
    finally:
        db.close()

    assert mods[10893]["DUAL_WIELD"] == 3
    assert mods[11544]["FASTCAST"] == 1
    assert mods[27194]["FASTCAST"] == 10
    assert overrides == {
        (10893, "DUAL_WIELD"): 3,
        (11544, "FASTCAST"): 1,
        (27194, "FASTCAST"): 10,
    }


def test_build_stats_db_imports_explicit_catseye_killer_effects(tmp_path: Path) -> None:
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
                "DEMON_KILLER = 234,",
                "BIRD_KILLER = 225,",
                "EMPTY_KILLER = 235,",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (19786,0,'nurigomeyumi','Nurigomeyumi',0,'Weapon',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (11920,0,'melaco_mittens','Melaco Mittens',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (23992,0,'spire_earring','Spire Earring',0,'Armor',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (19786,'Nurigomeyumi',75,0,65535,0,0,0,4,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (11920,'Melaco Mittens',75,0,65535,0,0,0,64,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (23992,'Spire Earring',75,0,65535,0,0,0,6144,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Bow.txt").write_text(
        "\n".join(
            (
                "Nurigomeyumi",
                "[Range]All Races",
                "DMG:76 Delay:600 STR+1 Ranged Accuracy+11 Ranged Attack+5 Demon Killer+2",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Hands.txt").write_text(
        "\n".join(
            (
                "Melaco Mittens",
                "[Hands]All Races",
                'DEF:16 MND+3 Physical damage taken -3% "Bird Killer"+2',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Earring.txt").write_text(
        "\n".join(
            (
                "Spire Earring",
                "[Earring]All Races",
                'MP+10 "Empty Killer"+5 Right ear: Magic skills +3',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = {
            item_id: dict(rows)
            for item_id, rows in (
                (
                    item_id,
                    db.execute(
                        """
                        select mod_name, value
                        from item_mods
                        where item_id = ?
                        """,
                        (item_id,),
                    ),
                )
                for item_id in (19786, 11920, 23992)
            )
        }
    finally:
        db.close()

    assert mods[19786]["DEMON_KILLER"] == 2
    assert mods[11920]["BIRD_KILLER"] == 2
    assert mods[23992]["EMPTY_KILLER"] == 5
    assert result.catseye_equipment_stat_override_count >= 3


def test_build_stats_db_imports_successful_block_rate(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("SHIELDBLOCKRATE = 518,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (23757,0,'sakpatas_helm','Sakpata''s Helm',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (20705,0,'brilliance','Brilliance',0,'Weapon',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (23757,'Sakpata''s Helm',75,0,65535,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (20705,'Brilliance',75,0,65535,0,0,0,3,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Sakpata's Helm",
                "[Head]All Races",
                "DEF:31 HP+25 DEX+5 VIT+5 Shield skill+10 Haste+5% Chance of successful block +3",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Sword.txt").write_text(
        "\n".join(
            (
                "Brilliance",
                "[Sword]All Races",
                'DMG:48 Delay:228 HP+5% MND+10 Enmity+5 "Cure" potency+15% Chance of successful block +5',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = {
            item_id: dict(rows)
            for item_id, rows in (
                (
                    item_id,
                    db.execute(
                        """
                        select mod_name, value
                        from item_mods
                        where item_id = ?
                        """,
                        (item_id,),
                    ),
                )
                for item_id in (23757, 20705)
            )
        }
    finally:
        db.close()

    assert mods[23757]["SHIELDBLOCKRATE"] == 3
    assert mods[20705]["SHIELDBLOCKRATE"] == 5


def test_build_stats_db_imports_drain_aspir_potency(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("ENH_DRAIN_ASPIR = 315,\n", encoding="utf-8")
    (sql_root / "item_basic.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_basic` VALUES (26665,0,'bagua_galero_p1','Bagua Galero +1',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (28445,0,'charmers_sash','Charmer''s Sash',0,'Armor',1,0,0,0);",
                "INSERT INTO `item_basic` VALUES (20901,0,'inanna','Inanna',0,'Weapon',1,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_equipment.sql").write_text(
        "\n".join(
            (
                "INSERT INTO `item_equipment` VALUES (26665,'Bagua Galero +1',75,0,65535,0,0,0,16,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (28445,'Charmer''s Sash',75,0,65535,0,0,0,1024,0,0,0);",
                "INSERT INTO `item_equipment` VALUES (20901,'Inanna',75,0,65535,0,0,0,3,0,0,0);",
            )
        ),
        encoding="utf-8",
    )
    (sql_root / "item_mods.sql").write_text(
        "INSERT INTO `item_mods` VALUES (26665,315,25);\n",
        encoding="utf-8",
    )
    catseye_root = tmp_path / "tools-data" / "catseye-wiki-cache" / "pages"
    catseye_root.mkdir(parents=True)
    (catseye_root / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Bagua Galero +1",
                "[Head]All Races",
                "DEF:26 MP+30 INT+5 MND+5 Drain/Aspir +21 Refresh+0~1 MP+0~30 MAB+0~10",
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Waist.txt").write_text(
        "\n".join(
            (
                "Charmer's Sash",
                "[Waist]All Races",
                'DEF:5 MP+25 INT+5 CHR+5 "Magic Atk. Bonus"+3 "Drain" and "Aspir" potency +5',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )
    (catseye_root / "CatsEyeXI_Content_Equipment_Scythe.txt").write_text(
        "\n".join(
            (
                "Inanna",
                "[Scythe]All Races",
                'DMG:105 Delay:528 STR+10 INT+10 Accuracy+20 TP Bonus+1000 Enhances "Drain" and "Aspir" (+15)',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
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
        mods = {
            item_id: dict(rows)
            for item_id, rows in (
                (
                    item_id,
                    db.execute(
                        """
                        select mod_name, value
                        from item_mods
                        where item_id = ?
                        """,
                        (item_id,),
                    ),
                )
                for item_id in (26665, 28445, 20901)
            )
        }
        override = db.execute(
            """
            select original_value, catseye_value
            from catseye_equipment_stat_overrides
            where item_id = 26665 and mod_name = 'ENH_DRAIN_ASPIR'
            """
        ).fetchone()
    finally:
        db.close()

    assert mods[26665]["ENH_DRAIN_ASPIR"] == 21
    assert mods[28445]["ENH_DRAIN_ASPIR"] == 5
    assert mods[20901]["ENH_DRAIN_ASPIR"] == 15
    assert override == (25, 21)


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


def test_load_item_stats_from_db_exposes_catseye_weaponskills() -> None:
    from oddlua.itemstats import load_item_stats_from_db

    stats_db = Path(__file__).resolve().parents[1] / "data" / "oddlua_stats.sqlite"
    stats = load_item_stats_from_db(stats_db)
    db = sqlite3.connect(stats_db)
    try:
        expected_count = db.execute("select count(*) from weapon_skills").fetchone()[0]
    finally:
        db.close()

    assert "tachi_gekko" in stats.weapon_skills_by_key
    assert stats.weapon_skills_by_key["tachi_gekko"].weapon_family == "great_katana"
    assert "leaden_salute" in stats.weapon_skills_by_key
    assert stats.weapon_skills_by_key["leaden_salute"].element_name == "Dark"
    assert stats.mechanics_counts["weapon_skills"] == expected_count


def test_build_stats_db_imports_skill_caps_and_skill_ranks(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    sql_root = server_root / "sql"
    scripts_items_root = server_root / "scripts" / "items"
    enum_root = server_root / "scripts" / "enum"
    sql_root.mkdir(parents=True)
    scripts_items_root.mkdir(parents=True)
    enum_root.mkdir(parents=True)

    _write_core_sql(sql_root)
    (enum_root / "mod.lua").write_text("", encoding="utf-8")
    (sql_root / "skill_caps.sql").write_text(
        "INSERT INTO `skill_caps` VALUES (65,0,230,220,210,200,190,180,170,160,150,140,130,120,110);\n",
        encoding="utf-8",
    )
    (sql_root / "skill_ranks.sql").write_text(
        "INSERT INTO `skill_ranks` VALUES "
        "(10,'great katana',0,0,0,0,0,0,0,0,0,0,0,1,8,0,0,0,0,0,0,0,0,0);\n",
        encoding="utf-8",
    )

    result = build_stats_db(
        sql_root=sql_root,
        scripts_items_root=scripts_items_root,
        output_path=tmp_path / "oddlua_stats.sqlite",
    )

    db = sqlite3.connect(result.path)
    try:
        skill_caps = db.execute("select count(*) from skill_caps").fetchone()[0]
        skill_ranks = db.execute("select count(*) from skill_ranks").fetchone()[0]
        sam_great_katana_rank = db.execute(
            """
            select rank
            from skill_ranks
            where skill_name = 'great_katana' and job = 'SAM'
            """
        ).fetchone()[0]
        level_65_cap = db.execute(
            "select cap from skill_caps where level = 65 and rank = ?",
            (sam_great_katana_rank,),
        ).fetchone()[0]
    finally:
        db.close()

    assert skill_caps == 14
    assert skill_ranks == 22
    assert level_65_cap >= 225


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
        "skill_caps.sql",
        "skill_ranks.sql",
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
