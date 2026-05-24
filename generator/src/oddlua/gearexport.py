from __future__ import annotations

from dataclasses import dataclass
import json
import re
from pathlib import Path
from typing import Any


_ASSIGNMENT_PATTERN = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$", re.DOTALL)


class GearExportParseError(ValueError):
    """Raised when a Catseye gearexport file does not match the expected shape."""


@dataclass(frozen=True)
class GearItem:
    id: int
    name: str
    count: int
    level: int
    slot: str
    category: str
    jobs: tuple[str, ...]
    storage: str
    augments: tuple[str, ...]
    raw_stats: dict[str, Any]
    source_path: Path
    equipped: bool | None = None

    @property
    def slots(self) -> str:
        return self.slot

    @property
    def container(self) -> str:
        return self.storage

    @property
    def augment_text(self) -> str:
        return " | ".join(self.augments)

    def has_job(self, job: str) -> bool:
        normalized = job.upper()
        return "ALL" in self.jobs or normalized in self.jobs

    def has_slot(self, slot: str) -> bool:
        if slot in {"Ear1", "Ear2"}:
            return "Ear" in self.slot
        if slot in {"Ring1", "Ring2"}:
            return "Ring" in self.slot
        return slot in self.slot.split("/")


@dataclass(frozen=True)
class GearExport:
    source_path: Path
    current_job: str
    items: tuple[GearItem, ...]
    raw_metadata: dict[str, Any]

    @property
    def path(self) -> Path:
        return self.source_path

    def items_by_name(self) -> dict[str, list[GearItem]]:
        by_name: dict[str, list[GearItem]] = {}
        for item in self.items:
            by_name.setdefault(item.name, []).append(item)
        return by_name


@dataclass(frozen=True)
class EquippedItem:
    slot: str
    name: str
    id: int
    storage: str
    index: int | None
    augments: tuple[str, ...]
    raw: dict[str, Any]


@dataclass(frozen=True)
class CharacterSnapshot:
    source_path: Path
    current_job: str
    job_levels: dict[str, int]
    current_equipment: tuple[EquippedItem, ...]
    raw: dict[str, Any]

    @property
    def path(self) -> Path:
        return self.source_path

    def job_level(self, job: str) -> int:
        return self.job_levels.get(job.upper(), 0)


def load_gearexport(path: Path | str) -> GearExport:
    source = Path(path)
    if not source.exists():
        raise FileNotFoundError(f"Gear export not found: {source}")

    text = source.read_text(encoding="utf-8", errors="replace")
    current_job = _extract_lua_string(text, "currentJob")
    if not current_job:
        raise GearExportParseError(f"Gear export missing currentJob: {source}")

    items_table = _extract_named_lua_table(text, "items", source)
    item_tables = tuple(_iter_top_level_tables(items_table))
    if not item_tables:
        raise GearExportParseError(f"Gear export has no parseable items table: {source}")

    items = tuple(_gear_item_from_lua_table(item_table, source) for item_table in item_tables)
    metadata = {
        "generatedBy": _extract_lua_string(text, "generatedBy"),
        "mode": _extract_lua_string(text, "mode"),
    }
    return GearExport(source_path=source, current_job=current_job, items=items, raw_metadata=metadata)


def load_character_snapshot(path: Path | str) -> CharacterSnapshot:
    source = Path(path)
    if not source.exists():
        raise FileNotFoundError(f"Character snapshot not found: {source}")

    try:
        data = json.loads(source.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise GearExportParseError(f"Character snapshot is not valid JSON: {source}") from exc

    if not isinstance(data, dict):
        raise GearExportParseError(f"Character snapshot root must be an object: {source}")

    current_job = _string_value(data.get("currentJob"))
    if not current_job:
        raise GearExportParseError(f"Character snapshot missing currentJob: {source}")

    raw_job_levels = data.get("jobLevels")
    if not isinstance(raw_job_levels, list):
        raise GearExportParseError(f"Character snapshot missing jobLevels list: {source}")

    job_levels: dict[str, int] = {}
    for row in raw_job_levels:
        if not isinstance(row, dict):
            continue
        abbr = _string_value(row.get("abbr")).upper()
        if abbr:
            job_levels[abbr] = _int_value(row.get("level"))

    if not job_levels:
        raise GearExportParseError(f"Character snapshot has no parseable job levels: {source}")

    current_equipment = tuple(
        _equipped_item_from_json(row)
        for row in data.get("currentEquipment", [])
        if isinstance(row, dict) and _string_value(row.get("name"))
    )
    return CharacterSnapshot(
        source_path=source,
        current_job=current_job,
        job_levels=job_levels,
        current_equipment=current_equipment,
        raw=data,
    )


def _gear_item_from_lua_table(table_text: str, source: Path) -> GearItem:
    fields = _parse_lua_table_fields(table_text)
    name = _string_value(fields.get("name"))
    if not name:
        raise GearExportParseError(f"Gear item missing name in {source}: {table_text[:120]}")

    augment_text = _string_value(fields.get("augment_text") or fields.get("augmentText"))
    return GearItem(
        id=_int_value(fields.get("id") if "id" in fields else fields.get("itemId")),
        name=name,
        count=_int_value(fields.get("count")),
        level=_int_value(fields.get("level")),
        slot=_string_value(fields.get("slots") if "slots" in fields else fields.get("slot")),
        category=_string_value(fields.get("category")),
        jobs=_parse_jobs(_string_value(fields.get("jobs"))),
        storage=_string_value(fields.get("container") if "container" in fields else fields.get("storage")),
        augments=_parse_augments(augment_text),
        raw_stats=fields,
        source_path=source,
        equipped=_optional_bool(fields.get("equipped")),
    )


def _equipped_item_from_json(row: dict[str, Any]) -> EquippedItem:
    augment_text = _string_value(row.get("augmentText") or row.get("augment_text"))
    augments = _parse_augments(augment_text)
    raw_augments = row.get("augments")
    if not augments and isinstance(raw_augments, list):
        augments = tuple(
            _string_value(augment.get("text"))
            for augment in raw_augments
            if isinstance(augment, dict) and _string_value(augment.get("text"))
        )

    return EquippedItem(
        slot=_string_value(row.get("slotName") or row.get("slot")),
        name=_string_value(row.get("name")),
        id=_int_value(row.get("itemId") if "itemId" in row else row.get("id")),
        storage=_string_value(row.get("container") if "container" in row else row.get("storage")),
        index=_optional_int(row.get("index")),
        augments=augments,
        raw=dict(row),
    )


def _extract_lua_string(text: str, key: str) -> str:
    match = re.search(rf"\b{re.escape(key)}\s*=\s*\"((?:\\.|[^\"])*)\"", text)
    if not match:
        return ""
    return _unquote_lua_string(f'"{match.group(1)}"')


def _extract_named_lua_table(text: str, key: str, source: Path) -> str:
    match = re.search(rf"\b{re.escape(key)}\s*=\s*{{", text)
    if not match:
        raise GearExportParseError(f"Gear export missing {key} table: {source}")
    open_index = text.find("{", match.start())
    close_index = _find_matching_brace(text, open_index)
    if close_index is None:
        raise GearExportParseError(f"Gear export has unterminated {key} table: {source}")
    return text[open_index + 1 : close_index]


def _iter_top_level_tables(text: str) -> tuple[str, ...]:
    tables: list[str] = []
    depth = 0
    start: int | None = None
    in_string = False
    escaped = False

    for index, char in enumerate(text):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
            continue
        if char == "{":
            if depth == 0:
                start = index
            depth += 1
        elif char == "}":
            if depth == 0:
                raise GearExportParseError("Unexpected closing brace while parsing items table")
            depth -= 1
            if depth == 0 and start is not None:
                tables.append(text[start : index + 1])
                start = None

    if depth != 0:
        raise GearExportParseError("Unterminated item table in gearexport items block")
    return tuple(tables)


def _parse_lua_table_fields(table_text: str) -> dict[str, Any]:
    stripped = table_text.strip()
    if not (stripped.startswith("{") and stripped.endswith("}")):
        raise GearExportParseError(f"Expected Lua table, got: {table_text[:120]}")

    fields: dict[str, Any] = {}
    inner = stripped[1:-1]
    for part in _split_top_level_commas(inner):
        assignment = part.strip()
        if not assignment:
            continue
        match = _ASSIGNMENT_PATTERN.match(assignment)
        if not match:
            continue
        fields[match.group(1)] = _parse_lua_value(match.group(2).strip())
    return fields


def _split_top_level_commas(text: str) -> tuple[str, ...]:
    parts: list[str] = []
    start = 0
    depth = 0
    in_string = False
    escaped = False

    for index, char in enumerate(text):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
        elif char == "," and depth == 0:
            parts.append(text[start:index])
            start = index + 1

    parts.append(text[start:])
    return tuple(parts)


def _parse_lua_value(value: str) -> Any:
    if value == "nil":
        return None
    if value == "true":
        return True
    if value == "false":
        return False
    if value.startswith('"') and value.endswith('"'):
        return _unquote_lua_string(value)
    if value.startswith("{") and value.endswith("}"):
        return value
    if re.fullmatch(r"-?\d+", value):
        return int(value)
    return value


def _find_matching_brace(text: str, open_index: int) -> int | None:
    depth = 0
    in_string = False
    escaped = False

    for index in range(open_index, len(text)):
        char = text[index]
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return index
    return None


def _unquote_lua_string(value: str) -> str:
    inner = value[1:-1]
    replacements = {
        r"\\": "\\",
        r"\"": '"',
        r"\n": "\n",
        r"\r": "\r",
        r"\t": "\t",
    }
    for escaped, unescaped in replacements.items():
        inner = inner.replace(escaped, unescaped)
    return inner


def _parse_jobs(value: str) -> tuple[str, ...]:
    if not value:
        return tuple()
    return tuple(part.strip().upper() for part in value.split("/") if part.strip())


def _parse_augments(value: str) -> tuple[str, ...]:
    if not value:
        return tuple()
    return tuple(part.strip() for part in value.split("|") if part.strip())


def _string_value(value: Any) -> str:
    if value is None:
        return ""
    return str(value)


def _int_value(value: Any) -> int:
    if value is None or value == "":
        return 0
    return int(value)


def _optional_int(value: Any) -> int | None:
    if value is None or value == "":
        return None
    return int(value)


def _optional_bool(value: Any) -> bool | None:
    if value is None or value == "":
        return None
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        folded = value.lower()
        if folded in {"true", "1", "yes"}:
            return True
        if folded in {"false", "0", "no"}:
            return False
    return bool(value)
