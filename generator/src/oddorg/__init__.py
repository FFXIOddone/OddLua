from __future__ import annotations

import argparse
import csv
import ctypes
import os
from dataclasses import dataclass, replace
from pathlib import Path
import struct
import sys
import time
from typing import Iterable, Sequence


CONTAINER_IDS: dict[str, int] = {
    "inventory": 0,
    "safe": 1,
    "mog safe": 1,
    "storage": 2,
    "temporary": 3,
    "temp": 3,
    "locker": 4,
    "mog locker": 4,
    "satchel": 5,
    "mog satchel": 5,
    "sack": 6,
    "mog sack": 6,
    "case": 7,
    "mog case": 7,
    "wardrobe": 8,
    "wardrobe1": 8,
    "wardrobe 1": 8,
    "safe2": 9,
    "safe 2": 9,
    "mog safe 2": 9,
    "wardrobe2": 10,
    "wardrobe 2": 10,
    "wardrobe3": 11,
    "wardrobe 3": 11,
    "wardrobe4": 12,
    "wardrobe 4": 12,
    "wardrobe5": 13,
    "wardrobe 5": 13,
    "wardrobe6": 14,
    "wardrobe 6": 14,
    "wardrobe7": 15,
    "wardrobe 7": 15,
    "wardrobe8": 16,
    "wardrobe 8": 16,
}

GEAR_ONLY_CONTAINER_IDS = {8, 10, 11, 12, 13, 14, 15, 16}
INVENTORY_CONTAINER_ID = 0
SOCIAL_ITEM_IDS = {512, 513, 514, 515}
SOCIAL_ITEM_NAMES = {"linkshell", "pearlsack", "linkpearl"}
WARDROBE_CONTAINER_IDS = (8, 10, 11, 12, 13, 14, 15, 16)

CANONICAL_CONTAINER_NAMES: dict[int, str] = {
    0: "Inventory",
    1: "Safe",
    2: "Storage",
    3: "Temporary",
    4: "Locker",
    5: "Satchel",
    6: "Sack",
    7: "Case",
    8: "Wardrobe",
    9: "Safe2",
    10: "Wardrobe2",
    11: "Wardrobe3",
    12: "Wardrobe4",
    13: "Wardrobe5",
    14: "Wardrobe6",
    15: "Wardrobe7",
    16: "Wardrobe8",
}

DEFAULT_CAPACITIES: dict[int, int] = {
    0: 80,
    1: 80,
    2: 80,
    4: 30,
    5: 80,
    6: 80,
    7: 80,
    8: 80,
    9: 80,
    10: 80,
    11: 80,
    12: 80,
    13: 80,
    14: 80,
    15: 80,
    16: 80,
}

KEYBOARD_HEADER_SIZE = 8
KEYBOARD_PARAM_SIZE = 8
KEYBOARD_TEXT_SIZE = 2048
KEYBOARD_COMMAND_SIZE = 4 + (KEYBOARD_PARAM_SIZE * 4) + KEYBOARD_TEXT_SIZE
KEYBOARD_TEXT_OFFSET = 4 + (KEYBOARD_PARAM_SIZE * 4)
KEYBOARD_MAP_COMMANDS = 32
KEYBOARD_MAP_SIZE = KEYBOARD_HEADER_SIZE + (KEYBOARD_COMMAND_SIZE * KEYBOARD_MAP_COMMANDS)
KEYBOARD_SEND_STRING_COMMAND = 3

FILE_MAP_ALL_ACCESS = 0x000F001F


@dataclass(frozen=True)
class MoveCommand:
    move_id: str
    character_slug: str
    item_id: int
    quantity: int
    source_container_id: int
    source_index: int
    target_container_id: int
    item_name: str
    stack_size: int = 1

    @classmethod
    def from_csv_row(
        cls,
        sequence: int,
        character_slug: str,
        row: dict[str, str],
    ) -> "MoveCommand":
        source_container_id = parse_container_id(row["source_container"])
        target_container_id = parse_container_id(row["target_container"])
        item_name = clean_item_name(row["name"])

        if target_container_id in GEAR_ONLY_CONTAINER_IDS and not row_looks_equippable(row):
            raise ValueError(
                f"{item_name} cannot be moved to gear-only container "
                f"{row['target_container']}"
            )

        return cls(
            move_id=f"{character_slug}-{sequence:04d}",
            character_slug=character_slug,
            item_id=parse_positive_int(row["item_id"], "item_id"),
            quantity=parse_positive_int(row["count"], "count"),
            source_container_id=source_container_id,
            source_index=parse_nonnegative_int(row["source_index"], "source_index"),
            target_container_id=target_container_id,
            item_name=item_name,
            stack_size=parse_positive_int(row.get("stack") or "1", "stack"),
        )

    @property
    def command(self) -> str:
        return (
            "/oddorg move "
            f"{self.move_id} "
            f"{self.character_slug} "
            f"{self.item_id} "
            f"{self.quantity} "
            f"{self.source_container_id} "
            f"{self.source_index} "
            f"{self.target_container_id} "
            f"{quote_command_arg(self.item_name)}"
        )


@dataclass(frozen=True)
class SnapshotItem:
    container_id: int
    index: int
    item_id: int
    quantity: int
    item_name: str
    stack_size: int
    equippable: bool
    slots: str = ""
    jobs: str = ""
    level: int = 0


@dataclass(frozen=True)
class WardrobeBucket:
    container_id: int
    label: str
    description: str
    categories: tuple[str, ...]


@dataclass(frozen=True)
class WardrobePlanRow:
    item: SnapshotItem
    target_container_id: int
    bucket: str
    reason: str

    def to_csv_row(self) -> dict[str, str]:
        return {
            "priority": "1",
            "name": self.item.item_name,
            "count": str(self.item.quantity),
            "stack": str(self.item.stack_size),
            "source_container": CANONICAL_CONTAINER_NAMES[self.item.container_id],
            "source_index": str(self.item.index),
            "target_container": CANONICAL_CONTAINER_NAMES[self.target_container_id],
            "bucket": self.bucket,
            "slots": self.item.slots,
            "jobs": self.item.jobs,
            "level": str(self.item.level),
            "item_id": str(self.item.item_id),
            "ah_category": "0",
            "reason": self.reason,
        }


@dataclass(frozen=True)
class WardrobeOrganizationPlan:
    rows: list[WardrobePlanRow]
    target_counts: dict[int, int]
    assigned_counts: dict[int, dict[str, int]]


@dataclass(frozen=True)
class NonEquipmentBucket:
    container_id: int
    label: str
    description: str
    categories: tuple[str, ...]


@dataclass(frozen=True)
class NonEquipmentPlanRow:
    item: SnapshotItem
    target_container_id: int
    bucket: str
    reason: str

    def to_csv_row(self) -> dict[str, str]:
        return {
            "priority": "2",
            "name": self.item.item_name,
            "count": str(self.item.quantity),
            "stack": str(self.item.stack_size),
            "source_container": CANONICAL_CONTAINER_NAMES[self.item.container_id],
            "source_index": str(self.item.index),
            "target_container": CANONICAL_CONTAINER_NAMES[self.target_container_id],
            "bucket": self.bucket,
            "slots": "",
            "jobs": "",
            "level": "0",
            "item_id": str(self.item.item_id),
            "ah_category": "0",
            "reason": self.reason,
        }


@dataclass(frozen=True)
class NonEquipmentOrganizationPlan:
    rows: list[NonEquipmentPlanRow]
    target_counts: dict[int, int]
    assigned_counts: dict[int, dict[str, int]]


@dataclass(frozen=True)
class MenuFlowPlan:
    commands: list[MoveCommand]
    final_counts: dict[int, int]
    logical_count: int
    skipped_missing_sources: int = 0


WARDROBE_BUCKETS: tuple[WardrobeBucket, ...] = (
    WardrobeBucket(8, "Wardrobe1", "main-only weapons", ("main",)),
    WardrobeBucket(10, "Wardrobe2", "main/sub weapons and offhands", ("main_sub", "sub")),
    WardrobeBucket(11, "Wardrobe3", "ranged, ammo, capes, and belt utility", ("range", "ammo", "back", "waist")),
    WardrobeBucket(12, "Wardrobe4", "head and neck armor", ("head", "neck")),
    WardrobeBucket(13, "Wardrobe5", "body armor and first hands", ("body", "hands")),
    WardrobeBucket(14, "Wardrobe6", "remaining hands and first legs", ("hands", "legs")),
    WardrobeBucket(15, "Wardrobe7", "remaining legs, feet, and utility overflow", ("legs", "feet", "waist", "neck", "ear", "back")),
    WardrobeBucket(16, "Wardrobe8", "rings and remaining earrings", ("ring", "ear")),
)

NON_EQUIPMENT_BUCKETS: tuple[NonEquipmentBucket, ...] = (
    NonEquipmentBucket(0, "Inventory", "active carry: medicines, food, tools, and use-now rewards", ("active",)),
    NonEquipmentBucket(4, "Locker", "keys, testimonies, missives, chips, and pop/access items", ("access",)),
    NonEquipmentBucket(7, "Case", "currencies, seals, pouches, scrolls, abjurations, tatters, and upgrade tokens", ("progression", "scroll")),
    NonEquipmentBucket(5, "Satchel", "craft materials A: wood, metal, gems, ore, beads, and alchemy base materials", ("craft_a",)),
    NonEquipmentBucket(6, "Sack", "craft materials B: cloth, leather, bone, beast drops, garden, and food ingredients", ("craft_b",)),
    NonEquipmentBucket(1, "Safe", "rare/ex, furnishings, oddities, and long-term overflow", ("rare_misc", "furnishing", "other")),
)


def parse_container_id(value: str) -> int:
    key = value.strip().lower()
    if key not in CONTAINER_IDS:
        raise ValueError(f"unknown container: {value}")
    return CONTAINER_IDS[key]


def parse_target_container_remap(value: str) -> tuple[int, int]:
    if "=" not in value:
        raise ValueError(f"target remap must be Source=Target: {value}")
    source, target = value.split("=", 1)
    return parse_container_id(source), parse_container_id(target)


def parse_container_capacity(value: str) -> tuple[int, int]:
    if "=" not in value:
        raise ValueError(f"capacity override must be Container=Slots: {value}")
    container, capacity = value.split("=", 1)
    return parse_container_id(container), parse_positive_int(capacity, "capacity")


def apply_target_container_remaps(
    commands: Sequence[MoveCommand],
    remaps: dict[int, int],
) -> list[MoveCommand]:
    if not remaps:
        return list(commands)
    return [
        replace(move, target_container_id=remaps.get(move.target_container_id, move.target_container_id))
        for move in commands
    ]


def is_social_item_move(move: MoveCommand) -> bool:
    return move.item_id in SOCIAL_ITEM_IDS or move.item_name.strip().lower() in SOCIAL_ITEM_NAMES


def filter_social_item_moves(commands: Sequence[MoveCommand]) -> tuple[list[MoveCommand], int]:
    filtered = [move for move in commands if not is_social_item_move(move)]
    return filtered, len(commands) - len(filtered)


def equipment_wardrobe_category(slots: str) -> str:
    normalized = slots.strip().lower()
    if normalized == "main":
        return "main"
    if normalized == "main/sub":
        return "main_sub"
    if normalized == "sub":
        return "sub"
    if normalized == "range":
        return "range"
    if normalized == "ammo":
        return "ammo"
    if normalized == "head":
        return "head"
    if normalized == "body":
        return "body"
    if normalized == "hands":
        return "hands"
    if normalized == "legs":
        return "legs"
    if normalized == "feet":
        return "feet"
    if normalized == "neck":
        return "neck"
    if normalized == "back":
        return "back"
    if normalized == "waist":
        return "waist"
    if normalized == "ear1/ear2":
        return "ear"
    if normalized == "ring1/ring2":
        return "ring"
    return "other"


def non_equipment_storage_category(item_name: str) -> str:
    name = item_name.strip().lower()
    compact = name.replace(".", "").replace("'", "")

    active_terms = (
        "holy water",
        "echo drops",
        "eye drops",
        "antidote",
        "remedy",
        "instant warp",
        "instant reraise",
        "silent oil",
        "prism powder",
        "special brew",
        "goblin brew",
        "gysahl greens",
        "chronicles",
        "theory",
        "miratete",
        "mint drop",
        "food",
        "feast",
        "sushi",
        "taco",
        "risotto",
        "pie",
        "parfait",
        "rusk",
        "biscuit",
        "dumpling",
        "indulgence",
        "blank",
        "blnk",
        "shihei",
        "sandwich",
        "hatchet",
        "pickaxe",
    )
    if any(term in name for term in active_terms):
        return "active"

    access_terms = (
        "testimony",
        "coffer key",
        "chest key",
        "missive",
        "codex",
        "chip",
        "lantern",
        "odious",
        "tanscale key",
        "dangruf stone",
        "dream coffer",
        "radiant chip",
    )
    if any(term in name for term in access_terms) or name.endswith(" key") or " key" in name:
        return "access"

    scroll_terms = (" spirit", "scroll", "scroll of")
    if any(term in name for term in scroll_terms):
        return "scroll"

    progression_terms = (
        "seal",
        "crest",
        "voucher",
        "pouch",
        "purse",
        "parcel",
        "case",
        "tatter",
        "abjuration",
        "forgotten",
        "frgtn",
        "void",
        "storage slip",
        "alexandrite",
        "bronzepiece",
        "beitetsu",
        "pluton",
        "rift",
        "commendation",
        "slime spirit",
        "beastcoin",
        "relic iron",
        " mitts -1",
        " -1",
    )
    if any(term in name for term in progression_terms):
        return "progression"

    craft_a_terms = (
        "lumber",
        "lbr",
        " log",
        "ore",
        "ingot",
        "sheet",
        "nugget",
        "rivet",
        "stud",
        "steel",
        "bronze",
        "brass",
        "copper",
        "silver",
        "mythril",
        "gold",
        "darksteel",
        "cobalt",
        "orichalc",
        "adaman",
        "bead",
        "ametrine",
        "garnet",
        "zircon",
        "topaz",
        "sapphire",
        "diamond",
        "ruby",
        "emerald",
        "crystal",
        "cluster",
    )
    if any(term in name for term in craft_a_terms):
        return "craft_a"

    craft_b_terms = (
        "cloth",
        "thread",
        "yarn",
        "silk",
        "cotton",
        "wool",
        "velvet",
        "leather",
        "skin",
        "hide",
        "pelt",
        "fur",
        "doeskin",
        "bone",
        "shell",
        "scale",
        "claw",
        "fang",
        "jaw",
        "wing",
        "feather",
        "hair",
        "meat",
        "root",
        "herb",
        "flower",
        "seed",
        "acorn",
        "almond",
        "fruit",
        "fish",
        "ink",
        "wax",
        "honey",
        "blood",
        "chip",
        "calculus",
        "fiber",
        "acid",
        "horn",
        "tusk",
        "stinger",
        "talon",
        "heart",
        "egg",
        "sugar",
        "nut",
        "garlic",
        "sap",
        "twine",
        "lanolin",
        "salt",
        "persikos",
        "walnut",
        "foliage",
        "shadeleaf",
        "nebimonite",
        "beard",
    )
    if any(term in name for term in craft_b_terms):
        return "craft_b"

    furnishing_terms = ("dream platter", "dream stocking", "red jar", "wood kit", "kit ")
    if any(term in name for term in furnishing_terms) or compact.startswith("wood kit"):
        return "furnishing"

    return "rare_misc"


def build_non_equipment_organization_plan(
    snapshot_items: Sequence[SnapshotItem],
    *,
    capacities: dict[int, int],
    pin_social_items: bool = True,
) -> NonEquipmentOrganizationPlan:
    movable_items: list[SnapshotItem] = []
    target_counts: dict[int, int] = {bucket.container_id: 0 for bucket in NON_EQUIPMENT_BUCKETS}
    assigned_counts: dict[int, dict[str, int]] = {
        bucket.container_id: {} for bucket in NON_EQUIPMENT_BUCKETS
    }

    for item in snapshot_items:
        if item.item_id <= 0 or item.quantity <= 0 or item.equippable:
            continue
        if item.container_id in GEAR_ONLY_CONTAINER_IDS:
            continue
        if pin_social_items and (
            item.item_id in SOCIAL_ITEM_IDS
            or item.item_name.strip().lower() in SOCIAL_ITEM_NAMES
        ):
            target_counts[item.container_id] = target_counts.get(item.container_id, 0) + 1
            counts = assigned_counts.setdefault(item.container_id, {})
            counts["social_pinned"] = counts.get("social_pinned", 0) + 1
            continue
        movable_items.append(item)

    by_category: dict[str, list[SnapshotItem]] = {}
    for item in movable_items:
        by_category.setdefault(non_equipment_storage_category(item.item_name), []).append(item)

    assignments: dict[tuple[int, int], tuple[SnapshotItem, NonEquipmentBucket, str]] = {}

    def item_key(item: SnapshotItem) -> tuple[int, int]:
        return item.container_id, item.index

    def take_best(category: str, target_container_id: int) -> SnapshotItem | None:
        candidates = by_category.get(category, [])
        if not candidates:
            return None
        candidates.sort(
            key=lambda item: (
                0 if item.container_id == target_container_id else 1,
                item.item_name.lower(),
                item.item_id,
                item.container_id,
                item.index,
            )
        )
        return candidates.pop(0)

    def assign(item: SnapshotItem, bucket: NonEquipmentBucket, category: str) -> None:
        assignments[item_key(item)] = (item, bucket, category)
        target_counts[bucket.container_id] = target_counts.get(bucket.container_id, 0) + 1
        counts = assigned_counts.setdefault(bucket.container_id, {})
        counts[category] = counts.get(category, 0) + 1

    for bucket in NON_EQUIPMENT_BUCKETS:
        capacity = capacities.get(bucket.container_id, 80)
        for category in bucket.categories:
            while target_counts[bucket.container_id] < capacity:
                item = take_best(category, bucket.container_id)
                if item is None:
                    break
                assign(item, bucket, category)

    leftovers = [
        item
        for category_items in by_category.values()
        for item in category_items
    ]
    leftovers.sort(
        key=lambda item: (
            non_equipment_storage_category(item.item_name),
            item.item_name.lower(),
            item.item_id,
            item.container_id,
            item.index,
        )
    )
    overflow_order = (1, 7, 5, 6, 0, 4)
    buckets_by_container = {bucket.container_id: bucket for bucket in NON_EQUIPMENT_BUCKETS}
    for container_id in overflow_order:
        bucket = buckets_by_container[container_id]
        capacity = capacities.get(container_id, 80)
        while target_counts.get(container_id, 0) < capacity and leftovers:
            item = leftovers.pop(0)
            assign(item, bucket, non_equipment_storage_category(item.item_name))
    if leftovers:
        raise RuntimeError(
            f"not enough non-wardrobe capacity for {len(leftovers)} non-equipment items"
        )

    rows: list[NonEquipmentPlanRow] = []
    for item, bucket, category in assignments.values():
        if item.container_id == bucket.container_id:
            continue
        rows.append(
            NonEquipmentPlanRow(
                item=item,
                target_container_id=bucket.container_id,
                bucket=f"{bucket.label}: {bucket.description}",
                reason=f"non-equipment standard: {bucket.description}; category={category}",
            )
        )
    rows.sort(
        key=lambda row: (
            row.target_container_id,
            row.item.container_id,
            row.item.index,
            row.item.item_name.lower(),
        )
    )
    return NonEquipmentOrganizationPlan(
        rows=rows,
        target_counts=target_counts,
        assigned_counts=assigned_counts,
    )


def build_wardrobe_organization_plan(
    snapshot_items: Sequence[SnapshotItem],
    *,
    capacities: dict[int, int],
    pinned_item_keys: set[tuple[int, int]] | None = None,
) -> WardrobeOrganizationPlan:
    pinned_item_keys = pinned_item_keys or set()
    gear_items = [
        item
        for item in snapshot_items
        if item.equippable and item.item_id > 0 and item.quantity > 0
        and (item.container_id, item.index) not in pinned_item_keys
    ]
    by_category: dict[str, list[SnapshotItem]] = {}
    for item in gear_items:
        by_category.setdefault(equipment_wardrobe_category(item.slots), []).append(item)

    assignments: dict[tuple[int, int], tuple[SnapshotItem, WardrobeBucket, str]] = {}
    target_counts: dict[int, int] = {bucket.container_id: 0 for bucket in WARDROBE_BUCKETS}
    assigned_counts: dict[int, dict[str, int]] = {
        bucket.container_id: {} for bucket in WARDROBE_BUCKETS
    }

    for item in snapshot_items:
        if (item.container_id, item.index) not in pinned_item_keys:
            continue
        if item.container_id not in WARDROBE_CONTAINER_IDS:
            continue
        target_counts[item.container_id] = target_counts.get(item.container_id, 0) + 1
        counts = assigned_counts.setdefault(item.container_id, {})
        counts["equipped_pinned"] = counts.get("equipped_pinned", 0) + 1

    def item_key(item: SnapshotItem) -> tuple[int, int]:
        return item.container_id, item.index

    def take_best(category: str, target_container_id: int) -> SnapshotItem | None:
        candidates = by_category.get(category, [])
        if not candidates:
            return None
        candidates.sort(
            key=lambda item: (
                0 if item.container_id == target_container_id else 1,
                item.item_name.lower(),
                item.level,
                item.item_id,
                item.container_id,
                item.index,
            )
        )
        return candidates.pop(0)

    def assign(item: SnapshotItem, bucket: WardrobeBucket, category: str) -> None:
        assignments[item_key(item)] = (item, bucket, category)
        target_counts[bucket.container_id] = target_counts.get(bucket.container_id, 0) + 1
        counts = assigned_counts.setdefault(bucket.container_id, {})
        counts[category] = counts.get(category, 0) + 1

    for bucket in WARDROBE_BUCKETS:
        capacity = capacities.get(bucket.container_id, 80)
        for category in bucket.categories:
            while target_counts[bucket.container_id] < capacity:
                item = take_best(category, bucket.container_id)
                if item is None:
                    break
                assign(item, bucket, category)

    leftovers = [
        item
        for category_items in by_category.values()
        for item in category_items
    ]
    leftovers.sort(
        key=lambda item: (
            equipment_wardrobe_category(item.slots),
            item.item_name.lower(),
            item.level,
            item.item_id,
            item.container_id,
            item.index,
        )
    )
    for bucket in WARDROBE_BUCKETS:
        capacity = capacities.get(bucket.container_id, 80)
        while target_counts[bucket.container_id] < capacity and leftovers:
            item = leftovers.pop(0)
            assign(item, bucket, equipment_wardrobe_category(item.slots))
    if leftovers:
        raise RuntimeError(
            f"not enough wardrobe capacity for {len(leftovers)} equipment items"
        )

    rows: list[WardrobePlanRow] = []
    for item, bucket, category in assignments.values():
        if item.container_id == bucket.container_id:
            continue
        rows.append(
            WardrobePlanRow(
                item=item,
                target_container_id=bucket.container_id,
                bucket=f"{bucket.label}: {bucket.description}",
                reason=f"wardrobe standard: {bucket.description}; category={category}",
            )
        )
    rows.sort(
        key=lambda row: (
            row.target_container_id,
            row.item.container_id,
            row.item.index,
            row.item.item_name.lower(),
        )
    )
    return WardrobeOrganizationPlan(
        rows=rows,
        target_counts=target_counts,
        assigned_counts=assigned_counts,
    )


def write_wardrobe_plan_csv(rows: Sequence[WardrobePlanRow], output_csv: Path) -> None:
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = [
        "priority",
        "name",
        "count",
        "stack",
        "source_container",
        "source_index",
        "target_container",
        "bucket",
        "slots",
        "jobs",
        "level",
        "item_id",
        "ah_category",
        "reason",
    ]
    with output_csv.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row.to_csv_row())


def write_non_equipment_plan_csv(rows: Sequence[NonEquipmentPlanRow], output_csv: Path) -> None:
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = [
        "priority",
        "name",
        "count",
        "stack",
        "source_container",
        "source_index",
        "target_container",
        "bucket",
        "slots",
        "jobs",
        "level",
        "item_id",
        "ah_category",
        "reason",
    ]
    with output_csv.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row.to_csv_row())


def load_equipped_item_keys(snapshot_path: Path) -> set[tuple[int, int]]:
    import json

    data = json.loads(snapshot_path.read_text(encoding="utf-8"))
    equipped: set[tuple[int, int]] = set()
    for item in data.get("currentEquipment", []):
        item_id = int(item.get("itemId", 0) or 0)
        if item_id <= 0:
            continue
        container_id = int(item.get("containerId", 0) or 0)
        index = int(item.get("index", 0) or 0)
        if container_id > 0 and index > 0:
            equipped.add((container_id, index))
    return equipped


def format_wardrobe_plan_summary(plan: WardrobeOrganizationPlan) -> list[str]:
    lines: list[str] = []
    for bucket in WARDROBE_BUCKETS:
        counts = plan.assigned_counts.get(bucket.container_id, {})
        category_text = ", ".join(
            f"{category}={count}" for category, count in sorted(counts.items())
        )
        lines.append(
            f"wardrobe_standard {bucket.label} "
            f"target={CANONICAL_CONTAINER_NAMES[bucket.container_id]} "
            f"count={plan.target_counts.get(bucket.container_id, 0)} "
            f"role=\"{bucket.description}\" "
            f"categories=\"{category_text}\""
        )
    lines.append(f"wardrobe_moves count={len(plan.rows)}")
    return lines


def format_non_equipment_plan_summary(plan: NonEquipmentOrganizationPlan) -> list[str]:
    lines: list[str] = []
    for bucket in NON_EQUIPMENT_BUCKETS:
        counts = plan.assigned_counts.get(bucket.container_id, {})
        category_text = ", ".join(
            f"{category}={count}" for category, count in sorted(counts.items())
        )
        lines.append(
            f"storage_standard {bucket.label} "
            f"target={CANONICAL_CONTAINER_NAMES[bucket.container_id]} "
            f"count={plan.target_counts.get(bucket.container_id, 0)} "
            f"role=\"{bucket.description}\" "
            f"categories=\"{category_text}\""
        )
    lines.append(f"non_equipment_moves count={len(plan.rows)}")
    return lines


def parse_positive_int(value: str, field: str) -> int:
    parsed = parse_nonnegative_int(value, field)
    if parsed <= 0:
        raise ValueError(f"{field} must be positive: {value}")
    return parsed


def parse_nonnegative_int(value: str, field: str) -> int:
    try:
        parsed = int(str(value).strip())
    except ValueError as exc:
        raise ValueError(f"{field} must be an integer: {value}") from exc
    if parsed < 0:
        raise ValueError(f"{field} must be non-negative: {value}")
    return parsed


def row_looks_equippable(row: dict[str, str]) -> bool:
    slots = (row.get("slots") or "").strip()
    if slots:
        return True
    try:
        return int((row.get("level") or "0").strip()) > 0
    except ValueError:
        return False


def clean_item_name(value: str) -> str:
    name = value.strip()
    if not name:
        raise ValueError("item name cannot be empty")
    if '"' in name or "\n" in name or "\r" in name:
        raise ValueError(f"unsupported item name for command quoting: {name}")
    return name


def quote_command_arg(value: str) -> str:
    clean = clean_item_name(value)
    return f'"{clean}"'


def load_move_commands(
    moves_csv: Path,
    character_slug: str,
    *,
    limit: int | None = None,
    start: int = 1,
) -> list[MoveCommand]:
    commands: list[MoveCommand] = []
    with moves_csv.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        for row_number, row in enumerate(reader, start=1):
            if row_number < start:
                continue
            commands.append(MoveCommand.from_csv_row(row_number, character_slug, row))
            if limit is not None and len(commands) >= limit:
                break
    return commands


def build_menu_flow_plan(
    commands: Sequence[MoveCommand],
    *,
    snapshot_items: Sequence[SnapshotItem],
    capacities: dict[int, int],
) -> MenuFlowPlan:
    items_by_slot = {
        (item.container_id, item.index): item
        for item in snapshot_items
        if item.quantity > 0 and item.item_id > 0
    }
    counts = count_snapshot_items(snapshot_items)
    inventory_slots = {
        item.index
        for item in snapshot_items
        if item.container_id == INVENTORY_CONTAINER_ID
        and item.quantity > 0
        and item.item_id > 0
    }
    pending: list[tuple[int, MoveCommand]] = [
        (index, move)
        for index, move in enumerate(commands)
        if move.source_container_id != move.target_container_id
    ]
    physical: list[MoveCommand] = []
    skipped_missing = 0
    next_synthetic_index = -1

    def pending_source_keys() -> set[tuple[int, int]]:
        return {(move.source_container_id, move.source_index) for _, move in pending}

    def remove_missing_sources() -> None:
        nonlocal pending, skipped_missing
        source_keys = set(items_by_slot)
        kept: list[tuple[int, MoveCommand]] = []
        for original_index, move in pending:
            if (move.source_container_id, move.source_index) in source_keys:
                kept.append((original_index, move))
            else:
                skipped_missing += 1
        pending = kept

    def first_open_inventory_slot() -> int:
        capacity = capacities.get(INVENTORY_CONTAINER_ID, 80)
        for index in range(1, capacity + 1):
            if index not in inventory_slots:
                return index
        raise RuntimeError("Inventory would overfill; no open Inventory slots remain")

    def has_inventory_room_for(move: MoveCommand, blocked_keys: set[tuple[int, int]]) -> bool:
        if _find_stack_target_key(
            move,
            items_by_slot=items_by_slot,
            blocked_source_keys=blocked_keys,
            stack_reservations={},
        ):
            return True
        return len(inventory_slots) < capacities.get(INVENTORY_CONTAINER_ID, 80)

    def target_accepts(
        move: MoveCommand,
        *,
        blocked_keys: set[tuple[int, int]],
        target_reservations: dict[int, int],
        stack_reservations: dict[tuple[int, int], int],
    ) -> tuple[bool, tuple[int, int] | None]:
        stack_key = _find_stack_target_key(
            move,
            items_by_slot=items_by_slot,
            blocked_source_keys=blocked_keys,
            stack_reservations=stack_reservations,
        )
        if stack_key is not None:
            return True, stack_key

        target_capacity = capacities.get(move.target_container_id)
        if target_capacity is None:
            return True, None
        reserved = target_reservations.get(move.target_container_id, 0)
        return counts.get(move.target_container_id, 0) + reserved < target_capacity, None

    def reserve_target(
        move: MoveCommand,
        stack_key: tuple[int, int] | None,
        target_reservations: dict[int, int],
        stack_reservations: dict[tuple[int, int], int],
    ) -> None:
        if stack_key is not None:
            stack_reservations[stack_key] = stack_reservations.get(stack_key, 0) + move.quantity
        else:
            target_reservations[move.target_container_id] = (
                target_reservations.get(move.target_container_id, 0) + 1
            )

    def remove_source_item(source_container_id: int, source_index: int) -> SnapshotItem:
        source_key = (source_container_id, source_index)
        item = items_by_slot.pop(source_key)
        counts[source_container_id] = max(0, counts.get(source_container_id, 0) - 1)
        if source_container_id == INVENTORY_CONTAINER_ID:
            inventory_slots.discard(source_index)
        return item

    def place_item(
        item: SnapshotItem,
        *,
        target_container_id: int,
        stack_key: tuple[int, int] | None,
        inventory_index: int | None = None,
    ) -> int | None:
        nonlocal next_synthetic_index
        if stack_key is not None:
            target_item = items_by_slot[stack_key]
            items_by_slot[stack_key] = replace(
                target_item,
                quantity=target_item.quantity + item.quantity,
            )
            return None

        if target_container_id == INVENTORY_CONTAINER_ID:
            index = inventory_index if inventory_index is not None else first_open_inventory_slot()
            items_by_slot[(INVENTORY_CONTAINER_ID, index)] = replace(
                item,
                container_id=INVENTORY_CONTAINER_ID,
                index=index,
            )
            inventory_slots.add(index)
            counts[INVENTORY_CONTAINER_ID] = counts.get(INVENTORY_CONTAINER_ID, 0) + 1
            return index

        synthetic_index = next_synthetic_index
        next_synthetic_index -= 1
        items_by_slot[(target_container_id, synthetic_index)] = replace(
            item,
            container_id=target_container_id,
            index=synthetic_index,
        )
        counts[target_container_id] = counts.get(target_container_id, 0) + 1
        return synthetic_index

    def append_physical(
        logical: MoveCommand,
        *,
        suffix: str,
        source_container_id: int,
        source_index: int,
        target_container_id: int,
    ) -> None:
        command_source_index = source_index
        if suffix == "put" and source_container_id == INVENTORY_CONTAINER_ID:
            command_source_index = 0
        physical.append(
            replace(
                logical,
                move_id=f"{logical.move_id}-{suffix}",
                source_container_id=source_container_id,
                source_index=command_source_index,
                target_container_id=target_container_id,
            )
        )

    def candidate_key(candidate: tuple[int, MoveCommand]) -> tuple[int, int, int, int]:
        original_index, move = candidate
        blocked_keys = pending_source_keys()
        stack_rank = 0
        if _find_stack_target_key(
            move,
            items_by_slot=items_by_slot,
            blocked_source_keys=blocked_keys,
            stack_reservations={},
        ) is None:
            stack_rank = 1
        source_count = counts.get(move.source_container_id, 0)
        source_capacity = capacities.get(move.source_container_id, max(source_count, 80))
        source_free = source_capacity - source_count
        return (stack_rank, source_free, move.target_container_id, original_index)

    def deposit_inventory_sources() -> bool:
        nonlocal pending
        progressed = False
        while True:
            blocked_keys = pending_source_keys()
            candidates: list[tuple[int, MoveCommand, tuple[int, int] | None]] = []
            for original_index, move in pending:
                if move.source_container_id != INVENTORY_CONTAINER_ID:
                    continue
                accepts, stack_key = target_accepts(
                    move,
                    blocked_keys=blocked_keys - {(move.source_container_id, move.source_index)},
                    target_reservations={},
                    stack_reservations={},
                )
                if accepts:
                    candidates.append((original_index, move, stack_key))

            if not candidates:
                return progressed

            original_index, move, stack_key = min(
                candidates,
                key=lambda candidate: candidate_key((candidate[0], candidate[1])),
            )
            item = remove_source_item(move.source_container_id, move.source_index)
            append_physical(
                move,
                suffix="put",
                source_container_id=INVENTORY_CONTAINER_ID,
                source_index=move.source_index,
                target_container_id=move.target_container_id,
            )
            place_item(item, target_container_id=move.target_container_id, stack_key=stack_key)
            pending = [(idx, candidate) for idx, candidate in pending if idx != original_index]
            progressed = True

    def pull_storage_batch() -> bool:
        nonlocal pending
        blocked_keys = pending_source_keys()
        target_reservations: dict[int, int] = {}
        stack_reservations: dict[tuple[int, int], int] = {}
        staged_deposits: list[tuple[MoveCommand, int, SnapshotItem, tuple[int, int] | None]] = []
        selected_indexes: set[int] = set()
        progressed = False

        for original_index, move in sorted(pending, key=candidate_key):
            if move.source_container_id == INVENTORY_CONTAINER_ID:
                continue

            source_key = (move.source_container_id, move.source_index)
            if source_key not in items_by_slot:
                continue

            if move.target_container_id == INVENTORY_CONTAINER_ID:
                if not has_inventory_room_for(move, blocked_keys - {source_key}):
                    continue
                source_item = remove_source_item(move.source_container_id, move.source_index)
                stack_key = _find_stack_target_key(
                    move,
                    items_by_slot=items_by_slot,
                    blocked_source_keys=blocked_keys - {source_key},
                    stack_reservations={},
                )
                inventory_index = None if stack_key is not None else first_open_inventory_slot()
                append_physical(
                    move,
                    suffix="pull",
                    source_container_id=move.source_container_id,
                    source_index=move.source_index,
                    target_container_id=INVENTORY_CONTAINER_ID,
                )
                place_item(
                    source_item,
                    target_container_id=INVENTORY_CONTAINER_ID,
                    stack_key=stack_key,
                    inventory_index=inventory_index,
                )
                selected_indexes.add(original_index)
                progressed = True
                if len(inventory_slots) >= capacities.get(INVENTORY_CONTAINER_ID, 80):
                    break
                continue

            if len(inventory_slots) >= capacities.get(INVENTORY_CONTAINER_ID, 80):
                break

            accepts, stack_key = target_accepts(
                move,
                blocked_keys=blocked_keys - {source_key},
                target_reservations=target_reservations,
                stack_reservations=stack_reservations,
            )
            if not accepts:
                continue

            reserve_target(move, stack_key, target_reservations, stack_reservations)
            source_item = remove_source_item(move.source_container_id, move.source_index)
            inventory_index = first_open_inventory_slot()
            append_physical(
                move,
                suffix="pull",
                source_container_id=move.source_container_id,
                source_index=move.source_index,
                target_container_id=INVENTORY_CONTAINER_ID,
            )
            place_item(
                source_item,
                target_container_id=INVENTORY_CONTAINER_ID,
                stack_key=None,
                inventory_index=inventory_index,
            )
            staged_deposits.append((move, inventory_index, source_item, stack_key))
            selected_indexes.add(original_index)
            progressed = True

        for move, inventory_index, _source_item, stack_key in staged_deposits:
            staged_item = remove_source_item(INVENTORY_CONTAINER_ID, inventory_index)
            append_physical(
                move,
                suffix="put",
                source_container_id=INVENTORY_CONTAINER_ID,
                source_index=inventory_index,
                target_container_id=move.target_container_id,
            )
            place_item(staged_item, target_container_id=move.target_container_id, stack_key=stack_key)

        if selected_indexes:
            pending = [(idx, move) for idx, move in pending if idx not in selected_indexes]
        return progressed

    while pending:
        remove_missing_sources()
        if not pending:
            break
        if deposit_inventory_sources():
            continue
        if pull_storage_batch():
            continue

        blocked_targets = sorted({move.target_container_id for _, move in pending})
        inventory_used = len(inventory_slots)
        inventory_capacity = capacities.get(INVENTORY_CONTAINER_ID, 80)
        raise RuntimeError(
            "no menu-flow move is currently schedulable; "
            f"inventory={inventory_used}/{inventory_capacity}; "
            f"blocked_targets={blocked_targets}"
        )

    return MenuFlowPlan(
        commands=physical,
        final_counts=dict(counts),
        logical_count=len(commands),
        skipped_missing_sources=skipped_missing,
    )


def _find_stack_target_key(
    move: MoveCommand,
    *,
    items_by_slot: dict[tuple[int, int], SnapshotItem],
    blocked_source_keys: set[tuple[int, int]],
    stack_reservations: dict[tuple[int, int], int],
) -> tuple[int, int] | None:
    if move.stack_size <= 1:
        return None

    source_key = (move.source_container_id, move.source_index)
    candidates: list[tuple[int, tuple[int, int]]] = []
    for key, item in items_by_slot.items():
        if item.container_id != move.target_container_id:
            continue
        if key == source_key or key in blocked_source_keys:
            continue
        if item.item_id != move.item_id:
            continue
        if item.item_name.strip().lower() != move.item_name.strip().lower():
            continue
        stack_size = min(move.stack_size, item.stack_size)
        reserved = stack_reservations.get(key, 0)
        if item.quantity + reserved + move.quantity <= stack_size:
            candidates.append((stack_size - item.quantity - reserved, key))

    if not candidates:
        return None
    return min(candidates)[1]


def count_snapshot_items(snapshot_items: Sequence[SnapshotItem]) -> dict[int, int]:
    counts: dict[int, int] = {}
    for item in snapshot_items:
        if item.quantity <= 0 or item.item_id <= 0:
            continue
        counts[item.container_id] = counts.get(item.container_id, 0) + 1
    return counts


def schedule_by_capacity(
    commands: Sequence[MoveCommand],
    *,
    current_counts: dict[int, int],
    capacities: dict[int, int],
) -> list[MoveCommand]:
    pending: list[tuple[int, MoveCommand]] = list(enumerate(commands))
    scheduled: list[MoveCommand] = []
    counts = dict(current_counts)

    while pending:
        candidates: list[tuple[int, MoveCommand]] = []
        for original_index, move in pending:
            target_capacity = capacities.get(move.target_container_id)
            target_count = counts.get(move.target_container_id, 0)
            if target_capacity is None or target_count < target_capacity:
                candidates.append((original_index, move))

        if not candidates:
            targets = sorted({move.target_container_id for _, move in pending})
            raise RuntimeError(f"no schedulable moves; target containers are full: {targets}")

        def candidate_key(candidate: tuple[int, MoveCommand]) -> tuple[int, int, int]:
            original_index, move = candidate
            source_count = counts.get(move.source_container_id, 0)
            source_capacity = capacities.get(move.source_container_id, max(source_count, 80))
            source_free = source_capacity - source_count
            target_count = counts.get(move.target_container_id, 0)
            target_capacity = capacities.get(move.target_container_id, max(target_count + 1, 80))
            target_free = target_capacity - target_count
            return (source_free, target_free, original_index)

        chosen_index, chosen = min(candidates, key=candidate_key)
        scheduled.append(chosen)
        counts[chosen.source_container_id] = max(0, counts.get(chosen.source_container_id, 0) - 1)
        counts[chosen.target_container_id] = counts.get(chosen.target_container_id, 0) + 1
        pending = [(idx, move) for idx, move in pending if idx != chosen_index]

    return scheduled


def simulate_counts(
    commands: Sequence[MoveCommand],
    *,
    current_counts: dict[int, int],
    capacities: dict[int, int],
) -> dict[int, int]:
    counts = dict(current_counts)

    for move in commands:
        if move.source_container_id != move.target_container_id:
            target_count = counts.get(move.target_container_id, 0)
            target_capacity = capacities.get(move.target_container_id)
            if target_capacity is not None and target_count >= target_capacity:
                target_name = CANONICAL_CONTAINER_NAMES.get(
                    move.target_container_id,
                    f"container {move.target_container_id}",
                )
                raise RuntimeError(
                    f"{target_name} would overfill before {move.move_id}: "
                    f"{target_count}/{target_capacity}"
                )

            counts[move.source_container_id] = max(
                0,
                counts.get(move.source_container_id, 0) - 1,
            )
            counts[move.target_container_id] = target_count + 1

    return counts


def format_capacity_preflight_lines(
    commands: Sequence[MoveCommand],
    *,
    start_counts: dict[int, int],
    final_counts: dict[int, int],
    capacities: dict[int, int],
) -> list[str]:
    touched_containers = set(start_counts) | set(final_counts)
    for move in commands:
        touched_containers.add(move.source_container_id)
        touched_containers.add(move.target_container_id)

    lines: list[str] = []
    for container_id in sorted(touched_containers):
        capacity = capacities.get(container_id)
        if capacity is None:
            continue
        name = CANONICAL_CONTAINER_NAMES.get(container_id, f"Container{container_id}")
        final_count = final_counts.get(container_id, 0)
        lines.append(
            f"capacity_preflight container={name} "
            f"start={start_counts.get(container_id, 0)} "
            f"final={final_count} "
            f"capacity={capacity} "
            f"free={capacity - final_count}"
        )
    return lines


def load_snapshot_items(snapshot_path: Path) -> list[SnapshotItem]:
    import json

    data = json.loads(snapshot_path.read_text(encoding="utf-8"))
    items: list[SnapshotItem] = []
    for item in data.get("inventory", {}).get("items", []):
        quantity = int(item.get("count", 0))
        item_id = int(item.get("id", 0))
        item_name = str(item.get("name", "")).strip()
        slots = str(item.get("slots", "") or "").strip()
        level = int(item.get("level", 0) or 0)
        items.append(
            SnapshotItem(
                container_id=int(item["containerId"]),
                index=int(item["index"]),
                item_id=item_id,
                quantity=quantity,
                item_name=item_name,
                stack_size=max(1, int(item.get("stack", 1) or 1)),
                equippable=bool(slots) or level > 0,
                slots=slots,
                jobs=str(item.get("jobs", "") or "").strip(),
                level=level,
            )
        )
    return items


def load_current_counts_from_snapshot(snapshot_path: Path) -> dict[int, int]:
    return count_snapshot_items(load_snapshot_items(snapshot_path))


def filter_moves_present_in_snapshot(
    commands: Sequence[MoveCommand],
    snapshot_path: Path,
) -> list[MoveCommand]:
    import json

    data = json.loads(snapshot_path.read_text(encoding="utf-8"))
    items: dict[tuple[int, int], dict[str, object]] = {}
    for item in data.get("inventory", {}).get("items", []):
        key = (int(item["containerId"]), int(item["index"]))
        items[key] = item

    filtered: list[MoveCommand] = []
    for move in commands:
        item = items.get((move.source_container_id, move.source_index))
        if item is None:
            continue
        if int(item.get("id", 0)) != move.item_id:
            continue
        if int(item.get("count", 0)) < move.quantity:
            continue
        if str(item.get("name", "")).strip().lower() != move.item_name.strip().lower():
            continue
        filtered.append(move)
    return filtered


def adapt_moves_to_current_snapshot(
    commands: Sequence[MoveCommand],
    snapshot_path: Path,
) -> tuple[list[MoveCommand], int, int]:
    import json

    data = json.loads(snapshot_path.read_text(encoding="utf-8"))
    items_by_slot: dict[tuple[int, int], dict[str, object]] = {}
    inventory_items: list[dict[str, object]] = []
    for item in data.get("inventory", {}).get("items", []):
        if int(item.get("id", 0)) <= 0 or int(item.get("count", 0)) <= 0:
            continue
        key = (int(item["containerId"]), int(item["index"]))
        items_by_slot[key] = item
        if int(item["containerId"]) == INVENTORY_CONTAINER_ID:
            inventory_items.append(item)

    adapted: list[MoveCommand] = []
    staged_recoveries = 0
    skipped = 0
    claimed_inventory_indexes: set[int] = set()

    for move in commands:
        item = items_by_slot.get((move.source_container_id, move.source_index))
        if _snapshot_item_matches_move(item, move):
            adapted.append(move)
            continue

        if move.target_container_id != INVENTORY_CONTAINER_ID:
            staged_item = _find_matching_inventory_snapshot_item(
                inventory_items,
                move,
                claimed_inventory_indexes,
            )
            if staged_item is not None:
                claimed_inventory_indexes.add(int(staged_item["index"]))
                adapted.append(
                    replace(
                        move,
                        source_container_id=INVENTORY_CONTAINER_ID,
                        source_index=int(staged_item["index"]),
                    )
                )
                staged_recoveries += 1
                continue

        skipped += 1

    return adapted, skipped, staged_recoveries


def _snapshot_item_matches_move(item: dict[str, object] | None, move: MoveCommand) -> bool:
    if item is None:
        return False
    if int(item.get("id", 0)) != move.item_id:
        return False
    if int(item.get("count", 0)) < move.quantity:
        return False
    return str(item.get("name", "")).strip().lower() == move.item_name.strip().lower()


def _find_matching_inventory_snapshot_item(
    inventory_items: Sequence[dict[str, object]],
    move: MoveCommand,
    claimed_inventory_indexes: set[int],
) -> dict[str, object] | None:
    fallback: dict[str, object] | None = None
    for item in inventory_items:
        index = int(item.get("index", 0))
        if index in claimed_inventory_indexes:
            continue
        if not _snapshot_item_matches_move(item, move):
            continue
        if int(item.get("count", 0)) == move.quantity:
            return item
        fallback = fallback or item
    return fallback


def default_snapshot_path(character_slug: str) -> Path:
    return (
        Path(r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport")
        / character_slug
        / f"{character_slug}_character.json"
    )


def default_audit_log_path() -> Path:
    return Path(r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\oddorg\events.tsv")


def find_audit_entry(
    audit_log: Path,
    move_id: str,
    *,
    start_position: int,
) -> tuple[str, str, str] | None:
    if not audit_log.exists():
        return None

    with audit_log.open("rb") as handle:
        handle.seek(start_position)
        content = handle.read().decode("utf-8", errors="replace")

    for line in content.splitlines():
        parts = line.split("\t")
        if len(parts) < 5:
            continue
        if parts[1] == move_id:
            return parts[2], parts[3], parts[4]
    return None


def wait_for_audit_entry(
    audit_log: Path,
    move_id: str,
    *,
    start_position: int,
    timeout_seconds: float,
) -> tuple[str, str, str]:
    deadline = time.monotonic() + timeout_seconds
    while time.monotonic() < deadline:
        entry = find_audit_entry(audit_log, move_id, start_position=start_position)
        if entry is not None:
            return entry
        time.sleep(0.05)
    raise TimeoutError(f"OddOrg audit entry not observed for {move_id}")


def build_keyboard_command_frame(command: str) -> bytes:
    encoded = encode_command(command)
    frame = bytearray(KEYBOARD_HEADER_SIZE + KEYBOARD_COMMAND_SIZE)
    struct.pack_into("<I", frame, 0, 1)
    frame[4] = 0
    struct.pack_into("<I", frame, KEYBOARD_HEADER_SIZE, KEYBOARD_SEND_STRING_COMMAND)
    text_start = KEYBOARD_HEADER_SIZE + KEYBOARD_TEXT_OFFSET
    frame[text_start : text_start + len(encoded)] = encoded
    return bytes(frame)


def encode_command(command: str) -> bytes:
    if not command or not command.startswith("/"):
        raise ValueError("Ashita command must start with '/'")
    encoded = command.encode("cp932") + b"\0"
    if len(encoded) > KEYBOARD_TEXT_SIZE:
        raise ValueError(f"command is too long for Thirdparty MMF: {len(encoded)} bytes")
    return encoded


def send_command_to_pid(pid: int, command: str, *, timeout_seconds: float = 2.0) -> None:
    if os.name != "nt":
        raise RuntimeError("Thirdparty MMF command sending only works on Windows")

    encoded = encode_command(command)
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    kernel32.OpenFileMappingW.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_wchar_p]
    kernel32.OpenFileMappingW.restype = ctypes.c_void_p
    kernel32.MapViewOfFile.argtypes = [
        ctypes.c_void_p,
        ctypes.c_uint32,
        ctypes.c_uint32,
        ctypes.c_uint32,
        ctypes.c_size_t,
    ]
    kernel32.MapViewOfFile.restype = ctypes.c_void_p
    kernel32.UnmapViewOfFile.argtypes = [ctypes.c_void_p]
    kernel32.UnmapViewOfFile.restype = ctypes.c_int
    kernel32.CloseHandle.argtypes = [ctypes.c_void_p]
    kernel32.CloseHandle.restype = ctypes.c_int

    mapping_name = f"WindowerMMFKeyboardHandler_{pid}"
    handle = kernel32.OpenFileMappingW(FILE_MAP_ALL_ACCESS, 0, mapping_name)
    if not handle:
        raise ctypes.WinError(ctypes.get_last_error())

    view = kernel32.MapViewOfFile(handle, FILE_MAP_ALL_ACCESS, 0, 0, KEYBOARD_MAP_SIZE)
    if not view:
        try:
            raise ctypes.WinError(ctypes.get_last_error())
        finally:
            kernel32.CloseHandle(handle)

    try:
        _write_u32(view, 0, 0)
        _write_u8(view, 4, 1)
        ctypes.memset(view + KEYBOARD_HEADER_SIZE, 0, KEYBOARD_COMMAND_SIZE)
        _write_u32(view, KEYBOARD_HEADER_SIZE, KEYBOARD_SEND_STRING_COMMAND)
        ctypes.memmove(view + KEYBOARD_HEADER_SIZE + KEYBOARD_TEXT_OFFSET, encoded, len(encoded))
        _write_u8(view, 4, 0)
        _write_u32(view, 0, 1)
        wait_for_command_processed(view, timeout_seconds=timeout_seconds)
    finally:
        kernel32.UnmapViewOfFile(view)
        kernel32.CloseHandle(handle)


def wait_for_command_processed(view: int, *, timeout_seconds: float) -> None:
    deadline = time.monotonic() + timeout_seconds
    while time.monotonic() < deadline:
        number_of_commands = _read_u32(view, 0)
        handled = _read_u8(view, 4)
        if number_of_commands == 0 and handled != 0:
            return
        time.sleep(0.05)
    raise TimeoutError("Thirdparty MMF command was not marked handled before timeout")


def _write_u32(base: int, offset: int, value: int) -> None:
    ctypes.memmove(base + offset, struct.pack("<I", value), 4)


def _write_u8(base: int, offset: int, value: int) -> None:
    ctypes.memmove(base + offset, bytes([value]), 1)


def _read_u32(base: int, offset: int) -> int:
    return struct.unpack("<I", ctypes.string_at(base + offset, 4))[0]


def _read_u8(base: int, offset: int) -> int:
    return ctypes.string_at(base + offset, 1)[0]


def find_pid_by_window_title(title: str) -> int:
    if os.name != "nt":
        raise RuntimeError("window title process discovery only works on Windows")

    user32 = ctypes.WinDLL("user32", use_last_error=True)
    matches: list[int] = []

    enum_windows_proc = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)

    def callback(hwnd: int, _lparam: int) -> bool:
        if not user32.IsWindowVisible(hwnd):
            return True
        length = user32.GetWindowTextLengthW(hwnd)
        if length <= 0:
            return True
        buffer = ctypes.create_unicode_buffer(length + 1)
        user32.GetWindowTextW(hwnd, buffer, length + 1)
        if buffer.value == title:
            pid = ctypes.c_uint32()
            user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
            matches.append(int(pid.value))
        return True

    user32.EnumWindows(enum_windows_proc(callback), 0)
    if not matches:
        raise RuntimeError(f"no visible window title matched {title!r}")
    if len(matches) > 1:
        raise RuntimeError(f"multiple visible windows matched {title!r}: {matches}")
    return matches[0]


def execute_commands(
    commands: Iterable[MoveCommand],
    *,
    character: str,
    pid: int | None = None,
    live: bool,
    timeout_seconds: float = 2.0,
    delay_seconds: float = 0.8,
    audit_log: Path | None = None,
    audit_timeout_seconds: float = 4.0,
) -> int:
    pid = pid if live and pid is not None else (find_pid_by_window_title(character) if live else None)
    audit_start_position = 0
    if live:
        audit_path = audit_log or default_audit_log_path()
        audit_start_position = audit_path.stat().st_size if audit_path.exists() else 0

    count = 0
    for move in commands:
        count += 1
        print(move.command)
        if live:
            assert pid is not None
            send_command_to_pid(pid, move.command, timeout_seconds=timeout_seconds)
            status, message, details = wait_for_audit_entry(
                audit_path,
                move.move_id,
                start_position=audit_start_position,
                timeout_seconds=audit_timeout_seconds,
            )
            audit_start_position = audit_path.stat().st_size
            if status != "SENT":
                raise RuntimeError(
                    f"OddOrg live move rejected: {move.move_id} {status} {message} {details}"
                )
            time.sleep(delay_seconds)
    return count


def send_one_command(
    character: str,
    command: str,
    *,
    pid: int | None = None,
    timeout_seconds: float = 2.0,
) -> None:
    target_pid = pid if pid is not None else find_pid_by_window_title(character)
    send_command_to_pid(target_pid, command, timeout_seconds=timeout_seconds)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="IDE-side runner for the OddOrg Ashita storage mover.")
    subparsers = parser.add_subparsers(dest="command_name", required=True)

    send = subparsers.add_parser("send", help="Send one Ashita command to a character window.")
    send.add_argument("--character", required=True, help="Exact game window title, e.g. Oddone.")
    send.add_argument("--pid", type=int, default=None, help="Target process id when window-title lookup is unavailable.")
    send.add_argument("--command", required=True, help="Ashita command beginning with '/'.")
    send.add_argument("--timeout", type=float, default=2.0)

    plan_wardrobes = subparsers.add_parser(
        "plan-wardrobes",
        help="Create a slot-family wardrobe organization CSV from current gearexport data.",
    )
    plan_wardrobes.add_argument("--character-slug", required=True, help="Expected live slug, e.g. Oddone_29938.")
    plan_wardrobes.add_argument("--current-json", type=Path, default=None, help="Current gearexport character JSON.")
    plan_wardrobes.add_argument("--output-csv", required=True, type=Path)
    plan_wardrobes.add_argument(
        "--capacity",
        action="append",
        default=[],
        help="Override live container capacity, e.g. Wardrobe2=80.",
    )
    plan_wardrobes.add_argument(
        "--include-equipped",
        action="store_true",
        help="Allow moves for currently equipped items. Default pins equipped gear in place.",
    )

    plan_storage = subparsers.add_parser(
        "plan-storage",
        help="Create a bucketed non-equipment organization CSV from current gearexport data.",
    )
    plan_storage.add_argument("--character-slug", required=True, help="Expected live slug, e.g. Oddone_29938.")
    plan_storage.add_argument("--current-json", type=Path, default=None, help="Current gearexport character JSON.")
    plan_storage.add_argument("--output-csv", required=True, type=Path)
    plan_storage.add_argument(
        "--capacity",
        action="append",
        default=[],
        help="Override live container capacity, e.g. Safe=50 or Storage=1.",
    )
    plan_storage.add_argument(
        "--include-social-items",
        action="store_true",
        help="Allow Linkshell/Pearlsack/Linkpearl moves. Default pins social-shell items in place.",
    )

    execute = subparsers.add_parser("execute", help="Print or send move commands from a storage CSV.")
    execute.add_argument("--character", required=True, help="Exact game window title, e.g. Oddone.")
    execute.add_argument("--pid", type=int, default=None, help="Target process id when window-title lookup is unavailable.")
    execute.add_argument("--character-slug", required=True, help="Expected live slug, e.g. Oddone_29938.")
    execute.add_argument("--moves-csv", required=True, type=Path)
    execute.add_argument("--limit", type=int, default=None)
    execute.add_argument("--start", type=int, default=1)
    execute.add_argument("--live", action="store_true", help="Actually send commands through Thirdparty.")
    execute.add_argument("--timeout", type=float, default=2.0)
    execute.add_argument("--delay", type=float, default=0.8, help="Delay between live move commands.")
    execute.add_argument("--audit-log", type=Path, default=None, help="OddOrg audit log path for live SENT/REJECT confirmation.")
    execute.add_argument("--audit-timeout", type=float, default=4.0, help="Seconds to wait for each live move audit entry.")
    execute.add_argument(
        "--capacity",
        action="append",
        default=[],
        help="Override live container capacity, e.g. Safe=50 or Storage=1.",
    )
    execute.add_argument("--schedule", action="store_true", help="Reorder moves to avoid filling target containers too early.")
    execute.add_argument("--current-json", type=Path, default=None, help="Current gearexport character JSON for scheduled runs.")
    execute.add_argument(
        "--target-remap",
        action="append",
        default=[],
        help="Remap planned target container only, e.g. Storage=Satchel.",
    )
    execute.add_argument(
        "--skip-social-items",
        action="store_true",
        help="Skip Linkshell/Pearlsack/Linkpearl moves; these have identity data and can be active-state sensitive.",
    )
    execute.add_argument("--summary-only", action="store_true", help="Run scheduled capacity preflight without printing or sending moves.")

    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    if args.command_name == "send":
        send_one_command(args.character, args.command, pid=args.pid, timeout_seconds=args.timeout)
        return 0

    if args.command_name == "plan-wardrobes":
        capacities = dict(DEFAULT_CAPACITIES)
        capacities.update(parse_container_capacity(value) for value in args.capacity)
        snapshot_path = args.current_json or default_snapshot_path(args.character_slug)
        pinned_item_keys = set() if args.include_equipped else load_equipped_item_keys(snapshot_path)
        plan = build_wardrobe_organization_plan(
            load_snapshot_items(snapshot_path),
            capacities=capacities,
            pinned_item_keys=pinned_item_keys,
        )
        write_wardrobe_plan_csv(plan.rows, args.output_csv)
        if pinned_item_keys:
            print(f"skipped_equipped_items count={len(pinned_item_keys)}")
        for line in format_wardrobe_plan_summary(plan):
            print(line)
        print(f"output_csv={args.output_csv}")
        return 0

    if args.command_name == "plan-storage":
        capacities = dict(DEFAULT_CAPACITIES)
        capacities.update(parse_container_capacity(value) for value in args.capacity)
        snapshot_path = args.current_json or default_snapshot_path(args.character_slug)
        plan = build_non_equipment_organization_plan(
            load_snapshot_items(snapshot_path),
            capacities=capacities,
            pin_social_items=not args.include_social_items,
        )
        write_non_equipment_plan_csv(plan.rows, args.output_csv)
        for line in format_non_equipment_plan_summary(plan):
            print(line)
        print(f"output_csv={args.output_csv}")
        return 0

    if args.command_name == "execute":
        commands = load_move_commands(
            args.moves_csv,
            args.character_slug,
            limit=args.limit,
            start=args.start,
        )
        remaps = dict(parse_target_container_remap(value) for value in args.target_remap)
        capacities = dict(DEFAULT_CAPACITIES)
        capacities.update(parse_container_capacity(value) for value in args.capacity)
        commands = apply_target_container_remaps(commands, remaps)
        if args.skip_social_items:
            commands, skipped_social = filter_social_item_moves(commands)
            if skipped_social:
                print(f"skipped_social_items count={skipped_social}")
        if args.schedule:
            snapshot_path = args.current_json or default_snapshot_path(args.character_slug)
            snapshot_items = load_snapshot_items(snapshot_path)
            current_counts = count_snapshot_items(snapshot_items)
            before_filter = len(commands)
            commands, skipped, staged_recoveries = adapt_moves_to_current_snapshot(commands, snapshot_path)
            if skipped:
                print(f"filtered_already_moved_or_changed count={skipped}")
            if staged_recoveries:
                print(f"recovered_already_staged_inventory count={staged_recoveries}")
            menu_plan = build_menu_flow_plan(
                commands,
                snapshot_items=snapshot_items,
                capacities=capacities,
            )
            if menu_plan.skipped_missing_sources:
                print(f"menu_flow_skipped_missing_sources count={menu_plan.skipped_missing_sources}")
            final_counts = menu_plan.final_counts
            commands = menu_plan.commands
            for line in format_capacity_preflight_lines(
                commands,
                start_counts=current_counts,
                final_counts=final_counts,
                capacities=capacities,
            ):
                print(line)
            print(
                "menu_flow_preflight "
                f"logical_count={menu_plan.logical_count} "
                f"physical_count={len(menu_plan.commands)}"
            )
            if args.summary_only:
                print(f"commands=preflighted count={len(commands)}")
                return 0
        elif args.summary_only:
            parser.error("--summary-only requires --schedule")

        count = execute_commands(
            commands,
            character=args.character,
            pid=args.pid,
            live=args.live,
            timeout_seconds=args.timeout,
            delay_seconds=args.delay,
            audit_log=args.audit_log,
            audit_timeout_seconds=args.audit_timeout,
        )
        print(f"commands={'sent' if args.live else 'planned'} count={count}")
        return 0

    parser.error(f"unknown command: {args.command_name}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
