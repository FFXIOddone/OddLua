from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
ADDON_PATH = REPO_ROOT.parent / "client" / "Ashita" / "addons" / "oddorg" / "oddorg.lua"


def test_oddorg_addon_contains_guarded_move_packet_only() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert 'args[1] ~= "/oddorg"' in text
    assert "validate_move" in text
    assert "resolve_inventory_source" in text
    assert "move.source_index ~= 0" in text
    assert "can_stack_into_target" in text
    assert "target container is full" in text
    assert "not can_stack_into_target" in text
    assert "GEAR_ONLY_CONTAINERS" in text
    assert "AddOutgoingPacket(0x029" in text
    assert "struct.pack('IIBBBB'" in text
    assert "AddOutgoingPacket(0x028" not in text
    assert "AddOutgoingPacket(0x084" not in text
    assert "AddOutgoingPacket(0x085" not in text


def test_oddorg_addon_writes_audit_log_under_config_only() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "config\\\\addons\\\\oddorg\\\\events.tsv" in text
    assert "write_audit" in text
    assert "os.execute" not in text


def test_oddorg_addon_contains_self_contained_organizer_surface() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "collect_live_items" in text
    assert "collect_equipped_keys" in text
    assert "build_wardrobe_plan" in text
    assert "build_storage_plan" in text
    assert "build_organize_plan" in text
    assert "build_physical_queue" in text
    assert "run_organizer_tick" in text
    assert 'args[2] == "organize"' in text
    assert 'args[3] == "preview"' in text
    assert 'args[3] == "run"' in text
    assert 'args[3] == "stop"' in text
    assert 'args[3] == "status"' in text
    assert 'ashita.events.register("d3d_present", "oddorg_organizer_tick"' in text


def test_oddorg_addon_contains_removable_probe_surface() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "PROBES_ENABLED" in text
    assert "write_probe" in text
    assert "probe_path" in text
    assert "config\\\\addons\\\\oddorg\\\\probes.tsv" in text
    assert "set_probes_enabled" in text
    assert 'args[2] == "probes"' in text
    assert 'args[3] == "on"' in text
    assert 'args[3] == "off"' in text
    assert 'args[3] == "clear"' in text
    assert 'args[3] == "status"' in text
    for event in (
        "snapshot_start",
        "snapshot_done",
        "equipped_scan_done",
        "classify_summary",
        "pin_social",
        "pin_equipped",
        "capacity_preflight",
        "plan_done",
        "queue_start",
        "queue_step",
        "queue_done",
        "validation_reject",
    ):
        assert event in text


def test_oddorg_addon_documents_bucket_standards_and_respects_menu_flow() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "main-only weapons" in text
    assert "main/sub weapons and offhands" in text
    assert "rings and remaining earrings" in text
    assert "active carry: medicines, food, tools, and use-now rewards" in text
    assert "keys, testimonies, missives, chips, and pop/access items" in text
    assert "craft materials A: wood, metal, gems, ore, beads, and alchemy base materials" in text
    assert "craft materials B: cloth, leather, bone, beast drops, garden, and food ingredients" in text
    assert "source_container_id = INVENTORY_CONTAINER_ID" in text
    assert "source_index = 0" in text
    assert 'suffix = "pull"' in text
    assert 'suffix = "put"' in text
    assert "is_social_item" in text
    assert "include_social" in text
    assert "allow_equipped" in text


def test_oddorg_addon_waits_for_inventory_stage_before_put_after_pull() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "awaiting_inventory" in text
    assert "find_inventory_item_for_move" in text
    assert "queue_wait_inventory" in text
    assert "inventory_stage_visible" in text
    assert "inventory_stage_timeout" in text
    assert "maybe_start_inventory_wait" in text
    assert "pull_matches_put" in text
    assert "inventory_wait_timeout" in text


def test_oddorg_addon_has_full_container_cycle_staging_probe() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "target_containers_for_pending" in text
    assert "queue_stage" in text
    assert "staged item to break blocked full-container flow" in text


def test_oddorg_addon_planner_does_not_assume_full_target_stack_acceptance() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "STACKING_IS_LIVE_VALIDATION_ONLY" in text
    assert "planner treats stack deposits as slot-consuming" in text
    target_accepts = text.split("local function target_accepts", 1)[1].split(
        "local function remove_state_item",
        1,
    )[0]
    assert "find_stack_target" not in target_accepts
    assert "return (counts[move.target_container_id] or 0) < capacity" in target_accepts


def test_oddorg_addon_validates_unlocked_storage_tabs_before_preview_planning() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "ASSUME_UNVERIFIED_OPTIONAL_CONTAINERS = false" in text
    assert "OPTIONAL_FLAGGED_CONTAINERS" in text
    assert "[11] = 0x04" in text
    assert "[16] = 0x80" in text
    assert "read_account_storage_flags" in text
    assert "container_is_unlocked" in text
    assert "collect_container_access" in text
    assert "container_access_summary" in text

    snapshot = text.split("local function collect_live_items", 1)[1].split(
        "function counts_to_details",
        1,
    )[0]
    assert "local container_access = collect_container_access(inv)" in snapshot
    assert "capacities[container_id] = access.capacity" in snapshot
    assert "if access.unlocked and access.capacity > 0 then" in snapshot

    validate_move = text.split("local function validate_move", 1)[1].split(
        "local function send_move_packet",
        1,
    )[0]
    compact_validate_move = "".join(validate_move.split())
    assert "container_is_unlocked(inv,move.source_container_id" in compact_validate_move
    assert "container_is_unlocked(inv,move.target_container_id" in compact_validate_move
    assert "source storage tab locked" in validate_move
    assert "target storage tab locked" in validate_move


def test_oddorg_addon_contains_ephemeral_dump_command_surface() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert 'args[2] == "ephemeral"' in text
    assert "handle_ephemeral" in text
    assert 'args[3] == "dump"' in text
    assert 'args[3] == "status"' in text
    assert 'args[3] == "stop"' in text
    assert "/oddorg ephemeral dump" in text
    assert "ephemeral running=" in text


def test_oddorg_addon_uses_catseye_ephemeral_crystal_unit_constants() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "EPHEMERAL_UNIT_CAP = 5000" in text
    assert "EPHEMERAL_ITEMS" in text
    for item_id in range(4096, 4112):
        assert f"[{item_id}]" in text
    assert 'kind = "crystal"' in text
    assert 'kind = "cluster"' in text
    assert "unit_value = 1" in text
    assert "unit_value = 12" in text
    assert "ephemeral_units_for_item" in text


def test_oddorg_addon_targets_current_ephemeral_moogle_without_event_id_whitelist() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "get_current_target" in text
    assert "GetTargetIndex" in text
    assert "GetServerId" in text
    assert "GetName" in text
    assert "target is not an Ephemeral Moogle" in text
    assert "EPHEMERAL_MOOGLE_TRADE_EVENTS_BY_SERVER_ID" not in text
    assert "unknown Ephemeral Moogle server id" not in text
    assert "Mog Garden Ephemeral Moogle is not enabled" not in text


def test_oddorg_addon_sends_guarded_ephemeral_trade_only_batches() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "EPHEMERAL_TRADE_PACKET_ID = 0x036" in text
    assert "EPHEMERAL_TRADE_BATCH_SIZE = 8" in text
    assert "EPHEMERAL_TRADE_ANIMATION_DELAY = 10" in text
    assert "send_ephemeral_trade_packet" in text
    assert "build_ephemeral_trade_batch" in text
    assert "struct.pack('IIIIIIIIIIIIBBBBBBBBBBHBBBB'" in text
    assert "0,\n        target.server_id" in text
    assert "AddOutgoingPacket(EPHEMERAL_TRADE_PACKET_ID" in text
    assert "animation_wait_until" in text
    assert "ephemeral_trade_animation_wait" in text
    assert "EPHEMERAL_EVENT_UPDATE_PACKET_ID" not in text
    assert "AddOutgoingPacket(0x05B" not in text
    assert "send_ephemeral_event_update_packet" not in text
    assert "send_ephemeral_event_end_packet" not in text
    assert "pending_event_update" not in text
    assert "pending_event_finish" not in text


def test_oddorg_addon_stages_storage_crystals_through_inventory_before_ephemeral_trade() -> None:
    text = ADDON_PATH.read_text(encoding="utf-8")

    assert "build_ephemeral_dump_queue" in text
    assert "run_ephemeral_tick" in text
    assert "ephemeral_wait_inventory" in text
    assert "ephemeral_inventory_stage_visible" in text
    assert "ephemeral_inventory_stage_timeout" in text
    assert "source_container_id = INVENTORY_CONTAINER_ID" in text
    assert "target_container_id = INVENTORY_CONTAINER_ID" in text
    assert "resolve_inventory_source" in text
    assert "send_move_packet(stage_move)" in text
    assert "organizer running; stop it before ephemeral dump" in text
