from pathlib import Path
import json
import sqlite3
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from oddlua.statsdb import build_stats_db
from tools.audit_server_equipment_db import audit_server_equipment_db


def test_server_equipment_audit_classifies_current_server_differences(tmp_path: Path) -> None:
    old_server_root = tmp_path / "old-server"
    current_server_root = tmp_path / "current-server"
    scripts_items_root = old_server_root / "scripts" / "items"
    scripts_items_root.mkdir(parents=True)

    _write_server_sql(
        old_server_root / "sql",
        basic_rows=(
            "INSERT INTO `item_basic` VALUES (100,0,'bronze_sword','Bronze Sword',0,'Weapon',1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (101,0,'retail_axe','Retail Axe',0,'Weapon',1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (103,0,'old_only_cap','Old Only Cap',0,'Armor',1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (104,0,'changed_mail','Changed Mail',0,'Armor',1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (105,0,'danger_grip','Danger Grip',0,'Weapon',1,0,0,0);",
        ),
        equipment_rows=(
            "INSERT INTO `item_equipment` VALUES (100,'bronze_sword',1,0,1,0,0,0,3,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (101,'retail_axe',30,0,1,0,0,0,3,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (103,'old_only_cap',1,0,1,0,0,0,16,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (104,'changed_mail',10,0,1,0,0,0,32,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (105,'danger_grip',81,0,4194303,0,0,0,2,0,0,0);",
        ),
        weapon_rows=(
            "INSERT INTO `item_weapon` VALUES (100,'bronze_sword',3,0,0,0,0,0,1,240,8,0);",
            "INSERT INTO `item_weapon` VALUES (101,'retail_axe',5,0,0,0,0,0,1,276,10,0);",
            "INSERT INTO `item_weapon` VALUES (105,'danger_grip',0,0,0,0,0,1,1,999,1,0);",
        ),
    )
    _write_server_sql(
        current_server_root / "sql",
        basic_rows=(
            "INSERT INTO `item_basic` VALUES (100,0,'bronze_sword','bronze_sword',@WEAPON_TYPE,1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (101,0,'retail_axe','retail_axe',@WEAPON_TYPE,1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (102,0,'new_catseye_grip','new_catseye_grip',@WEAPON_TYPE,1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (104,0,'changed_mail','changed_mail',@EQUIPMENT_TYPE,1,0,0,0);",
            "INSERT INTO `item_basic` VALUES (105,0,'danger_grip','danger_grip',@WEAPON_TYPE,1,0,0,0);",
        ),
        equipment_rows=(
            "INSERT INTO `item_equipment` VALUES (100,'bronze_sword',1,0,1,0,0,0,3,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (101,'retail_axe',30,0,1,0,0,0,3,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (102,'new_catseye_grip',8,0,4194303,0,0,0,2,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (104,'changed_mail',11,0,1,0,0,0,32,0,0,0);",
            "INSERT INTO `item_equipment` VALUES (105,'danger_grip',81,0,4194303,0,0,0,2,0,0,0);",
        ),
        weapon_rows=(
            "INSERT INTO `item_weapon` VALUES (100,'bronze_sword',3,0,0,0,0,0,1,240,8,0);",
            "INSERT INTO `item_weapon` VALUES (101,'retail_axe',5,0,0,0,0,0,1,276,10,0);",
            "INSERT INTO `item_weapon` VALUES (102,'new_catseye_grip',0,0,0,0,0,1,1,999,1,0);",
            "INSERT INTO `item_weapon` VALUES (105,'danger_grip',0,0,0,0,0,1,1,999,1,0);",
        ),
    )
    (old_server_root / "scripts" / "enum").mkdir(parents=True)
    (old_server_root / "scripts" / "enum" / "mod.lua").write_text("", encoding="utf-8")

    client_items_path = tmp_path / "client_items.json"
    client_items_path.write_text(
        json.dumps(
            {
                "items": [
                    {
                        "id": 101,
                        "name": "Catseye Axe",
                        "level": 75,
                        "itemLevel": 0,
                        "jobMask": 2,
                        "slotMask": 3,
                        "flags": 0,
                        "stack": 1,
                        "type": 0,
                        "subType": 0,
                        "skill": 5,
                        "damage": 22,
                        "delay": 276,
                        "damageType": 0,
                        "shieldSize": 0,
                        "superiorLevel": 0,
                        "validTargets": 0,
                    }
                    ,
                    {
                        "id": 105,
                        "name": "Danger Grip",
                        "level": 81,
                        "itemLevel": 0,
                        "jobMask": 4194303,
                        "slotMask": 2,
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
                        "validTargets": 0,
                    },
                ]
            }
        ),
        encoding="utf-8",
    )

    db_path = tmp_path / "oddlua_stats.sqlite"
    build_stats_db(
        sql_root=old_server_root / "sql",
        scripts_items_root=scripts_items_root,
        output_path=db_path,
        client_items_path=client_items_path,
    )

    report = audit_server_equipment_db(
        db_path=db_path,
        server_root=current_server_root,
        server_label="test-current-main",
    )

    assert report["summary"]["server_equipment_items"] == 5
    assert report["summary"]["exact_matches"] == 1
    assert report["summary"]["covered_client_resource_differences"] == 2
    assert report["summary"]["unexpected_differences"] == 1
    assert report["summary"]["missing_server_equipment_in_db"] == 1
    assert report["summary"]["db_only_equipment"] == 1
    assert report["summary"]["db_only_client_resource_equipment"] == 0
    assert report["summary"]["db_only_uncovered_equipment"] == 1
    assert report["missing_server_equipment_in_db"][0]["item_id"] == 102
    assert report["db_only_equipment"][0]["item_id"] == 103
    covered_ids = {row["item_id"] for row in report["covered_client_resource_differences"]}
    assert covered_ids == {101, 105}
    assert report["unexpected_differences"][0]["item_id"] == 104
    assert report["unexpected_differences"][0]["field_differences"][0]["field"] == "equipment.level"


def test_server_equipment_audit_covers_catseye_stat_overrides(tmp_path: Path) -> None:
    server_root = tmp_path / "server"
    scripts_items_root = server_root / "scripts" / "items"
    scripts_items_root.mkdir(parents=True)

    _write_server_sql(
        server_root / "sql",
        basic_rows=(
            "INSERT INTO `item_basic` VALUES (200,0,'wiki_mace','wiki_mace',0,'Weapon',1,0,0,0);",
        ),
        equipment_rows=(
            "INSERT INTO `item_equipment` VALUES (200,'wiki_mace',75,0,1,0,0,0,3,0,0,0);",
        ),
        weapon_rows=(
            "INSERT INTO `item_weapon` VALUES (200,'wiki_mace',11,0,0,0,0,0,1,240,30,0);",
        ),
    )
    (server_root / "scripts" / "enum").mkdir(parents=True)
    (server_root / "scripts" / "enum" / "mod.lua").write_text("", encoding="utf-8")

    db_path = tmp_path / "oddlua_stats.sqlite"
    build_stats_db(
        sql_root=server_root / "sql",
        scripts_items_root=scripts_items_root,
        output_path=db_path,
    )

    db = sqlite3.connect(db_path)
    try:
        db.execute("update item_weapon set damage = 20, delay = 210 where item_id = 200")
        db.executemany(
            """
            insert into catseye_equipment_stat_overrides
                (item_id, mod_id, mod_name, original_value, catseye_value, source_path, source_text)
            values (?, ?, ?, ?, ?, ?, ?)
            """,
            (
                (200, -1, "WEAPON_DAMAGE", 30, 20, "fixture", "DMG:20"),
                (200, -2, "WEAPON_DELAY", 240, 210, "fixture", "Delay:210"),
            ),
        )
        db.commit()
    finally:
        db.close()

    report = audit_server_equipment_db(
        db_path=db_path,
        server_root=server_root,
        server_label="test-current-main",
    )

    assert report["summary"]["unexpected_differences"] == 0
    assert report["summary"]["covered_equipment_override_differences"] == 1
    row = report["covered_equipment_override_differences"][0]
    assert row["item_id"] == 200
    assert row["covered_by"] == ["catseye_equipment_stat_overrides"]
    assert {diff["field"] for diff in row["field_differences"]} == {
        "weapon.damage",
        "weapon.delay",
    }


def _write_server_sql(
    sql_root: Path,
    *,
    basic_rows: tuple[str, ...],
    equipment_rows: tuple[str, ...],
    weapon_rows: tuple[str, ...],
) -> None:
    sql_root.mkdir(parents=True)
    (sql_root / "item_basic.sql").write_text("\n".join(basic_rows) + "\n", encoding="utf-8")
    (sql_root / "item_equipment.sql").write_text("\n".join(equipment_rows) + "\n", encoding="utf-8")
    (sql_root / "item_weapon.sql").write_text("\n".join(weapon_rows) + "\n", encoding="utf-8")
    for name in (
        "item_mods.sql",
        "item_latents.sql",
        "augments.sql",
        "merits.sql",
        "traits.sql",
        "weapon_skills.sql",
        "item_usable.sql",
        "abilities.sql",
        "spell_list.sql",
        "status_effects.sql",
        "item_mods_pet.sql",
    ):
        (sql_root / name).write_text("", encoding="utf-8")
