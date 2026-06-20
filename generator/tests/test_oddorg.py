from pathlib import Path
import struct
import sys

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddorg import (
    KEYBOARD_COMMAND_SIZE,
    KEYBOARD_HEADER_SIZE,
    KEYBOARD_TEXT_OFFSET,
    MoveCommand,
    SnapshotItem,
    apply_target_container_remaps,
    adapt_moves_to_current_snapshot,
    build_menu_flow_plan,
    build_non_equipment_organization_plan,
    build_wardrobe_organization_plan,
    build_keyboard_command_frame,
    equipment_wardrobe_category,
    find_audit_entry,
    filter_social_item_moves,
    filter_moves_present_in_snapshot,
    format_capacity_preflight_lines,
    load_equipped_item_keys,
    load_current_counts_from_snapshot,
    non_equipment_storage_category,
    parse_container_capacity,
    parse_target_container_remap,
    simulate_counts,
    schedule_by_capacity,
)


def test_move_command_formats_exact_oddorg_command() -> None:
    row = {
        "name": "Onion Staff",
        "count": "1",
        "source_container": "Safe",
        "source_index": "50",
        "target_container": "Wardrobe8",
        "item_id": "17104",
        "slots": "Main",
        "level": "1",
    }

    move = MoveCommand.from_csv_row(1, "Oddone_29938", row)

    assert move.command == (
        '/oddorg move Oddone_29938-0001 Oddone_29938 17104 1 1 50 16 "Onion Staff"'
    )


def test_move_command_rejects_non_equipment_to_wardrobe() -> None:
    row = {
        "name": "Honey",
        "count": "11",
        "source_container": "Safe",
        "source_index": "11",
        "target_container": "Wardrobe8",
        "item_id": "4370",
        "slots": "",
        "level": "0",
    }

    with pytest.raises(ValueError, match="gear-only"):
        MoveCommand.from_csv_row(2, "Oddone_29938", row)


def test_keyboard_command_frame_matches_thirdparty_mmf_layout() -> None:
    command = "/oddorg status"

    frame = build_keyboard_command_frame(command)

    assert struct.unpack_from("<I", frame, 0)[0] == 1
    assert frame[4] == 0
    assert struct.unpack_from("<I", frame, KEYBOARD_HEADER_SIZE)[0] == 3
    assert frame[
        KEYBOARD_HEADER_SIZE + KEYBOARD_TEXT_OFFSET : KEYBOARD_HEADER_SIZE
        + KEYBOARD_TEXT_OFFSET
        + len(command)
        + 1
    ] == command.encode("cp932") + b"\0"
    assert len(frame) == KEYBOARD_HEADER_SIZE + KEYBOARD_COMMAND_SIZE


def test_schedule_by_capacity_frees_full_target_before_filling_it() -> None:
    into_sack = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=1,
        quantity=1,
        source_container_id=0,
        source_index=1,
        target_container_id=6,
        item_name="Honey",
    )
    out_of_sack = MoveCommand(
        move_id="Oddone_29938-0002",
        character_slug="Oddone_29938",
        item_id=2,
        quantity=1,
        source_container_id=6,
        source_index=2,
        target_container_id=7,
        item_name="Alexandrite",
    )

    scheduled = schedule_by_capacity(
        [into_sack, out_of_sack],
        current_counts={0: 2, 6: 1, 7: 0},
        capacities={0: 80, 6: 1, 7: 80},
    )

    assert [move.move_id for move in scheduled] == [
        "Oddone_29938-0002",
        "Oddone_29938-0001",
    ]


def test_filter_moves_present_in_snapshot_removes_already_moved_rows(tmp_path: Path) -> None:
    into_sack = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=1,
        quantity=1,
        source_container_id=0,
        source_index=1,
        target_container_id=6,
        item_name="Honey",
    )
    out_of_sack = MoveCommand(
        move_id="Oddone_29938-0002",
        character_slug="Oddone_29938",
        item_id=2,
        quantity=1,
        source_container_id=6,
        source_index=2,
        target_container_id=7,
        item_name="Alexandrite",
    )
    snapshot = tmp_path / "Oddone_29938_character.json"
    snapshot.write_text(
        """
{
  "inventory": {
    "items": [
      {"containerId": 6, "index": 2, "id": 2, "count": 1, "name": "Alexandrite"}
    ]
  }
}
""".strip(),
        encoding="utf-8",
    )

    filtered = filter_moves_present_in_snapshot([into_sack, out_of_sack], snapshot)

    assert [move.move_id for move in filtered] == ["Oddone_29938-0002"]


def test_simulate_counts_reports_final_counts_without_overfill() -> None:
    moves = [
        MoveCommand(
            move_id="Oddone_29938-0001",
            character_slug="Oddone_29938",
            item_id=1,
            quantity=1,
            source_container_id=0,
            source_index=1,
            target_container_id=6,
            item_name="Honey",
        ),
        MoveCommand(
            move_id="Oddone_29938-0002",
            character_slug="Oddone_29938",
            item_id=2,
            quantity=1,
            source_container_id=6,
            source_index=2,
            target_container_id=7,
            item_name="Alexandrite",
        ),
    ]

    result = simulate_counts(
        moves,
        current_counts={0: 2, 6: 1, 7: 0},
        capacities={0: 80, 6: 80, 7: 80},
    )

    assert result == {0: 1, 6: 1, 7: 1}


def test_simulate_counts_rejects_target_overfill() -> None:
    move = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=1,
        quantity=1,
        source_container_id=0,
        source_index=1,
        target_container_id=2,
        item_name="Honey",
    )

    with pytest.raises(RuntimeError, match="Storage would overfill"):
        simulate_counts(
            [move],
            current_counts={0: 1, 2: 80},
            capacities={0: 80, 2: 80},
        )


def test_format_capacity_preflight_lines_reports_touched_containers() -> None:
    move = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=1,
        quantity=1,
        source_container_id=0,
        source_index=1,
        target_container_id=2,
        item_name="Honey",
    )

    lines = format_capacity_preflight_lines(
        [move],
        start_counts={0: 66, 2: 79},
        final_counts={0: 65, 2: 80},
        capacities={0: 80, 2: 80},
    )

    assert lines == [
        "capacity_preflight container=Inventory start=66 final=65 capacity=80 free=15",
        "capacity_preflight container=Storage start=79 final=80 capacity=80 free=0",
    ]


def test_load_current_counts_from_snapshot_ignores_empty_slots(tmp_path: Path) -> None:
    snapshot = tmp_path / "Oddone_29938_character.json"
    snapshot.write_text(
        """
{
  "inventory": {
    "items": [
      {"containerId": 0, "index": 0, "id": 0, "count": 0, "name": ""},
      {"containerId": 0, "index": 1, "id": 4154, "count": 12, "name": "Holy Water"}
    ]
  }
}
""".strip(),
        encoding="utf-8",
    )

    assert load_current_counts_from_snapshot(snapshot) == {0: 1}


def test_adapt_moves_to_current_snapshot_recovers_items_already_staged_in_inventory(tmp_path: Path) -> None:
    move = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=1935,
        quantity=1,
        source_container_id=5,
        source_index=12,
        target_container_id=1,
        item_name="Benedict Yarn",
        stack_size=12,
    )
    snapshot = tmp_path / "Oddone_29938_character.json"
    snapshot.write_text(
        """
{
  "inventory": {
    "items": [
      {"containerId": 0, "index": 54, "id": 1935, "count": 1, "name": "Benedict Yarn"}
    ]
  }
}
""".strip(),
        encoding="utf-8",
    )

    adapted, skipped, staged = adapt_moves_to_current_snapshot([move], snapshot)

    assert skipped == 0
    assert staged == 1
    assert adapted == [
        MoveCommand(
            move_id="Oddone_29938-0001",
            character_slug="Oddone_29938",
            item_id=1935,
            quantity=1,
            source_container_id=0,
            source_index=54,
            target_container_id=1,
            item_name="Benedict Yarn",
            stack_size=12,
        )
    ]


def test_menu_flow_routes_storage_to_storage_through_inventory() -> None:
    move = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=4370,
        quantity=11,
        source_container_id=1,
        source_index=11,
        target_container_id=6,
        item_name="Honey",
        stack_size=12,
    )
    snapshot_items = [
        SnapshotItem(
            container_id=1,
            index=11,
            item_id=4370,
            quantity=11,
            item_name="Honey",
            stack_size=12,
            equippable=False,
        ),
        SnapshotItem(
            container_id=0,
            index=1,
            item_id=4154,
            quantity=12,
            item_name="Holy Water",
            stack_size=12,
            equippable=False,
        ),
    ]

    plan = build_menu_flow_plan(
        [move],
        snapshot_items=snapshot_items,
        capacities={0: 80, 1: 80, 6: 80},
    )

    assert [command.command for command in plan.commands] == [
        '/oddorg move Oddone_29938-0001-pull Oddone_29938 4370 11 1 11 0 "Honey"',
        '/oddorg move Oddone_29938-0001-put Oddone_29938 4370 11 0 0 6 "Honey"',
    ]


def test_menu_flow_dumps_inventory_before_storage_pulls_when_inventory_is_full() -> None:
    inventory_dump = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=750,
        quantity=6,
        source_container_id=0,
        source_index=1,
        target_container_id=1,
        item_name="Silver Beastcoin",
        stack_size=12,
    )
    storage_move = MoveCommand(
        move_id="Oddone_29938-0002",
        character_slug="Oddone_29938",
        item_id=4370,
        quantity=11,
        source_container_id=5,
        source_index=8,
        target_container_id=6,
        item_name="Honey",
        stack_size=12,
    )
    snapshot_items = [
        SnapshotItem(0, 1, 750, 6, "Silver Beastcoin", 12, False),
        SnapshotItem(0, 2, 4154, 12, "Holy Water", 12, False),
        SnapshotItem(5, 8, 4370, 11, "Honey", 12, False),
    ]

    plan = build_menu_flow_plan(
        [storage_move, inventory_dump],
        snapshot_items=snapshot_items,
        capacities={0: 2, 1: 80, 5: 80, 6: 80},
    )

    assert [command.move_id for command in plan.commands] == [
        "Oddone_29938-0001-put",
        "Oddone_29938-0002-pull",
        "Oddone_29938-0002-put",
    ]


def test_menu_flow_allows_stack_deposit_into_full_target_container() -> None:
    move = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=4370,
        quantity=3,
        source_container_id=0,
        source_index=1,
        target_container_id=6,
        item_name="Honey",
        stack_size=12,
    )
    snapshot_items = [
        SnapshotItem(0, 1, 4370, 3, "Honey", 12, False),
        SnapshotItem(6, 10, 4370, 8, "Honey", 12, False),
    ]

    plan = build_menu_flow_plan(
        [move],
        snapshot_items=snapshot_items,
        capacities={0: 80, 6: 1},
    )

    assert [command.command for command in plan.commands] == [
        '/oddorg move Oddone_29938-0001-put Oddone_29938 4370 3 0 0 6 "Honey"'
    ]
    assert plan.final_counts == {0: 0, 6: 1}


def test_find_audit_entry_returns_matching_live_result(tmp_path: Path) -> None:
    audit = tmp_path / "events.tsv"
    audit.write_text(
        "\n".join(
            [
                "2026-05-31T17:00:00Z\tother\tSENT\tvalidated\tInventory[1] -> Safe",
                "2026-05-31T17:00:01Z\tOddone_29938-0001-put\tREJECT\ttarget container is full\tSafe 80/80",
            ]
        ),
        encoding="utf-8",
    )

    entry = find_audit_entry(audit, "Oddone_29938-0001-put", start_position=0)

    assert entry == (
        "REJECT",
        "target container is full",
        "Safe 80/80",
    )


def test_apply_target_container_remaps_only_changes_destinations() -> None:
    move = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=720,
        quantity=1,
        source_container_id=2,
        source_index=1,
        target_container_id=2,
        item_name="Ancient Lumber",
        stack_size=12,
    )

    remapped = apply_target_container_remaps(
        [move],
        {parse_target_container_remap("Storage=Satchel")[0]: parse_target_container_remap("Storage=Satchel")[1]},
    )

    assert remapped[0].source_container_id == 2
    assert remapped[0].target_container_id == 5


def test_filter_social_item_moves_skips_linkshell_identity_items() -> None:
    linkshell = MoveCommand(
        move_id="Oddone_29938-0001",
        character_slug="Oddone_29938",
        item_id=513,
        quantity=1,
        source_container_id=5,
        source_index=72,
        target_container_id=0,
        item_name="Linkshell",
    )
    honey = MoveCommand(
        move_id="Oddone_29938-0002",
        character_slug="Oddone_29938",
        item_id=4370,
        quantity=11,
        source_container_id=1,
        source_index=11,
        target_container_id=6,
        item_name="Honey",
        stack_size=12,
    )

    filtered, skipped = filter_social_item_moves([linkshell, honey])

    assert skipped == 1
    assert filtered == [honey]


def test_equipment_wardrobe_category_maps_ffxi_slot_families() -> None:
    assert equipment_wardrobe_category("Main") == "main"
    assert equipment_wardrobe_category("Main/Sub") == "main_sub"
    assert equipment_wardrobe_category("Ear1/Ear2") == "ear"
    assert equipment_wardrobe_category("Ring1/Ring2") == "ring"


def test_wardrobe_organization_plan_assigns_slot_family_buckets() -> None:
    items = [
        SnapshotItem(11, 1, 100, 1, "Two-Hander", 1, True, "Main", "WAR", 75),
        SnapshotItem(8, 2, 101, 1, "Dagger", 1, True, "Main/Sub", "THF", 75),
        SnapshotItem(10, 3, 102, 99, "Bullet", 99, True, "Ammo", "COR", 1),
        SnapshotItem(13, 4, 103, 1, "Crown", 1, True, "Head", "ALL", 1),
        SnapshotItem(12, 5, 104, 1, "Band", 1, True, "Ring1/Ring2", "ALL", 1),
    ]

    plan = build_wardrobe_organization_plan(
        items,
        capacities={8: 80, 10: 80, 11: 80, 12: 80, 13: 80, 14: 80, 15: 80, 16: 80},
    )
    targets = {row.item.item_name: row.target_container_id for row in plan.rows}

    assert targets["Two-Hander"] == 8
    assert targets["Dagger"] == 10
    assert targets["Bullet"] == 11
    assert targets["Crown"] == 12
    assert targets["Band"] == 16
    assert max(plan.target_counts.values()) <= 80


def test_wardrobe_organization_plan_pins_equipped_items_in_place() -> None:
    equipped = SnapshotItem(8, 1, 14651, 1, "Mana Ring", 1, True, "Ring1/Ring2", "ALL", 1)
    movable = SnapshotItem(10, 2, 17104, 1, "Onion Staff", 1, True, "Main", "ALL", 1)

    plan = build_wardrobe_organization_plan(
        [equipped, movable],
        capacities={8: 80, 10: 80, 11: 80, 12: 80, 13: 80, 14: 80, 15: 80, 16: 80},
        pinned_item_keys={(8, 1)},
    )

    assert all(row.item.item_name != "Mana Ring" for row in plan.rows)
    assert plan.assigned_counts[8]["equipped_pinned"] == 1
    assert plan.target_counts[8] == 2


def test_load_equipped_item_keys_reads_current_equipment_slots(tmp_path: Path) -> None:
    snapshot = tmp_path / "Oddone_29938_character.json"
    snapshot.write_text(
        """
{
  "currentEquipment": [
    {"itemId": 14651, "containerId": 8, "index": 34, "name": "Mana Ring"},
    {"itemId": 0, "containerId": 0, "index": 0, "name": ""}
  ]
}
""".strip(),
        encoding="utf-8",
    )

    assert load_equipped_item_keys(snapshot) == {(8, 34)}


def test_non_equipment_storage_category_maps_common_storage_buckets() -> None:
    assert non_equipment_storage_category("Holy Water") == "active"
    assert non_equipment_storage_category("Chocobo Blnk.") == "active"
    assert non_equipment_storage_category("Shihei") == "active"
    assert non_equipment_storage_category("Om. Sandwich") == "active"
    assert non_equipment_storage_category("Beastmen's Seal") == "progression"
    assert non_equipment_storage_category("Clr. Mitts -1") == "progression"
    assert non_equipment_storage_category("Kuftal Coffer Key") == "access"
    assert non_equipment_storage_category("Garlaige Key") == "access"
    assert non_equipment_storage_category("Ancient Lumber") == "craft_a"
    assert non_equipment_storage_category("Hefty Oak Lbr.") == "craft_a"
    assert non_equipment_storage_category("Cotton Cloth") == "craft_b"
    assert non_equipment_storage_category("Gabbrath Horn") == "craft_b"
    assert non_equipment_storage_category("Granulated Sugar") == "craft_b"
    assert non_equipment_storage_category("Royal Jelly") == "rare_misc"


def test_non_equipment_organization_plan_assigns_storage_buckets_and_pins_social_items() -> None:
    items = [
        SnapshotItem(6, 1, 1126, 10, "Beastmen's Seal", 99, False),
        SnapshotItem(6, 2, 1430, 1, "Rdm. Testimony", 1, False),
        SnapshotItem(6, 3, 720, 11, "Ancient Lumber", 12, False),
        SnapshotItem(5, 4, 825, 1, "Cotton Cloth", 12, False),
        SnapshotItem(7, 5, 4154, 12, "Holy Water", 12, False),
        SnapshotItem(5, 6, 513, 1, "Linkshell", 1, False),
    ]

    plan = build_non_equipment_organization_plan(
        items,
        capacities={0: 80, 1: 50, 2: 1, 4: 30, 5: 80, 6: 80, 7: 80},
    )
    targets = {row.item.item_name: row.target_container_id for row in plan.rows}

    assert targets["Beastmen's Seal"] == 7
    assert targets["Rdm. Testimony"] == 4
    assert targets["Ancient Lumber"] == 5
    assert targets["Cotton Cloth"] == 6
    assert targets["Holy Water"] == 0
    assert "Linkshell" not in targets
    assert plan.assigned_counts[5]["social_pinned"] == 1


def test_parse_container_capacity_accepts_names() -> None:
    assert parse_container_capacity("Safe=50") == (1, 50)
    assert parse_container_capacity("Storage=1") == (2, 1)
