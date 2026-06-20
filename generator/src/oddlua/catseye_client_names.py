from __future__ import annotations

from typing import Any


KNOWN_SPECIAL_CLIENT_NAME_COLLISION_ITEM_ID_SETS = {
    # Catseye ships two all-jobs Judge's Sword client rows with the same display
    # name but different weapon/slot signatures. They are GM/special rows, not a
    # player equipment upgrade chain.
    frozenset({16622, 17644}),
}


def client_collision_is_expected(
    rows: list[tuple[int, dict[str, Any]]],
    *,
    allow_special_cases: bool = False,
) -> bool:
    if client_collision_is_expected_upgrade_chain(rows):
        return True
    return allow_special_cases and client_collision_is_known_special_case(rows)


def client_collision_is_known_special_case(rows: list[tuple[int, dict[str, Any]]]) -> bool:
    return frozenset(item_id for item_id, _row in rows) in KNOWN_SPECIAL_CLIENT_NAME_COLLISION_ITEM_ID_SETS


def client_collision_is_expected_upgrade_chain(rows: list[tuple[int, dict[str, Any]]]) -> bool:
    level_upgrade_shapes = {
        (
            int(row["jobs"]),
            int(row["slot"]),
            int(row["shield_size"]),
            int(row["su_level"]),
            int(row["skill"]),
            int(row["damage_type"]),
        )
        for _item_id, row in rows
    }
    if len(level_upgrade_shapes) == 1:
        levels = {int(row["level"]) for _item_id, row in rows}
        if len(levels) > 1:
            return True

    core_level_upgrade_shapes = {
        (
            int(row["slot"]),
            int(row["su_level"]),
            int(row["skill"]),
            int(row["damage_type"]),
        )
        for _item_id, row in rows
    }
    levels = {int(row["level"]) for _item_id, row in rows}
    if len(core_level_upgrade_shapes) == 1 and len(levels) > 1:
        return True

    same_level_weapon_shapes = {
        (
            int(row["level"]),
            int(row["jobs"]),
            int(row["slot"]),
            int(row["shield_size"]),
            int(row["su_level"]),
            int(row["skill"]),
            int(row["damage_type"]),
        )
        for _item_id, row in rows
    }
    if len(same_level_weapon_shapes) != 1:
        return False
    if not any(int(row["skill"]) > 0 for _item_id, row in rows):
        return False
    damage_delay_pairs = {(int(row["damage"]), int(row["delay"])) for _item_id, row in rows}
    return len(damage_delay_pairs) > 1
