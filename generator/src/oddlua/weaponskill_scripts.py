from __future__ import annotations

import ast
from dataclasses import dataclass, field
import operator
from pathlib import Path
import re

ELEMENT_NAME_BY_LUA = {
    "FIRE": "Fire",
    "ICE": "Ice",
    "WIND": "Wind",
    "LIGHTNING": "Lightning",
    "THUNDER": "Lightning",
    "EARTH": "Earth",
    "WATER": "Water",
    "LIGHT": "Light",
    "DARK": "Dark",
}

_ADOULIN_IF_RE = re.compile(
    r"^\s*if\s+xi\.settings\.main\.USE_ADOULIN_WEAPON_SKILL_CHANGES\s+then\b"
)
_IF_RE = re.compile(r"\bif\b.*\bthen\b")
_END_RE = re.compile(r"\bend\b")
_PARAM_ASSIGN_RE = re.compile(
    r"\bparams\.(?P<name>[A-Za-z_][A-Za-z0-9_]*)\s*=\s*"
    r"(?P<value>.*?)\s*(?=\s*params\.[A-Za-z_][A-Za-z0-9_]*\s*=|$)"
)
_MERIT_LEVEL_FOR_STATIC_PLANNING = 5
_ARITHMETIC_BINOPS = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
}


@dataclass(frozen=True)
class WeaponSkillScript:
    damage_kind: str
    num_hits: int
    ftp_mod: tuple[float, float, float] = (1.0, 1.0, 1.0)
    wsc: dict[str, float] = field(default_factory=dict)
    element_name: str = "None"
    includes_mab: bool = False
    crit_varies: tuple[float, float, float] | None = None
    attack_multiplier: tuple[float, float, float] | None = None
    multi_hit_ftp: bool = False
    additional_effects: tuple[str, ...] = tuple()
    parser_warnings: tuple[str, ...] = tuple()


def parse_weaponskill_script(
    path: Path | str, *, use_adoulin_changes: bool
) -> WeaponSkillScript:
    normalized_path = Path(path)
    if not normalized_path.exists() or not normalized_path.is_file():
        raise FileNotFoundError(f"Catseye weapon skill script not found: {normalized_path}")

    source = normalized_path.read_text(encoding="utf-8", errors="replace")
    parser_warnings: list[str] = []
    base_lines, adoulin_lines = _split_lines_by_adoulin(
        source, parser_warnings=parser_warnings
    )
    if use_adoulin_changes and adoulin_lines:
        parsed = _collect_assignments(base_lines + adoulin_lines)
    else:
        parsed = _collect_assignments(base_lines)

    active_lines = (base_lines + adoulin_lines) if use_adoulin_changes else base_lines
    active_text = "\n".join(active_lines)

    return WeaponSkillScript(
        damage_kind=_damage_kind(active_text),
        num_hits=_parse_int(parsed, "numhits", default=1, warnings=parser_warnings),
        ftp_mod=_parse_float_tuple(
            parsed,
            "ftpmod",
            default=(1.0, 1.0, 1.0),
            warnings=parser_warnings,
        ),
        wsc=_parse_wsc(parsed, warnings=parser_warnings),
        element_name=_parse_element(active_text),
        includes_mab=_parse_bool(parsed, "includemab"),
        crit_varies=_parse_float_tuple(
            parsed,
            "critvaries",
            optional=True,
            warnings=parser_warnings,
        ),
        attack_multiplier=_parse_float_tuple(
            parsed,
            "atkvaries",
            optional=True,
            warnings=parser_warnings,
        ),
        multi_hit_ftp=_parse_bool(parsed, "multihitftp"),
        additional_effects=_parse_additional_effects(active_text),
        parser_warnings=tuple(parser_warnings),
    )


def _split_lines_by_adoulin(
    source: str, *, parser_warnings: list[str] | None = None
) -> tuple[list[str], list[str]]:
    lines = source.splitlines()
    warnings = parser_warnings if parser_warnings is not None else []
    base_lines: list[str] = []
    adoulin_lines: list[str] = []
    index = 0

    while index < len(lines):
        line = _strip_code_for_scanning(lines[index]).strip()
        if _ADOULIN_IF_RE.match(line):
            body, next_index, ended = _extract_if_body(lines, index)
            if ended:
                adoulin_lines.extend(body)
                index = next_index
                continue

            warnings.append(
                "Unterminated USE_ADOULIN_WEAPON_SKILL_CHANGES block in weaponskill script."
            )
            base_lines.extend(_neutralize_param_assignments(lines[index:]))
            break

        base_lines.append(lines[index])
        index += 1

    return base_lines, adoulin_lines


def _extract_if_body(
    lines: list[str], start_index: int
) -> tuple[list[str], int, bool]:
    body: list[str] = []
    depth = 0
    index = start_index

    while index < len(lines):
        raw = lines[index]
        code = _strip_code_for_scanning(raw)
        if index == start_index:
            if _ADOULIN_IF_RE.match(code):
                depth = 1
            index += 1
            continue

        if _IF_RE.search(code):
            depth += len(_IF_RE.findall(code))

        if _END_RE.search(code):
            depth -= len(_END_RE.findall(code))
            if depth <= 0:
                return body, index + 1, True

        if depth > 0:
            body.append(raw)

        index += 1

    return body, index, False


def _collect_assignments(lines: list[str]) -> dict[str, str]:
    assignments: dict[str, str] = {}
    for line in lines:
        code = _strip_code_for_scanning(line)
        for match in _PARAM_ASSIGN_RE.finditer(code):
            name = match.group("name").lower()
            assignments[name] = match.group("value").strip().rstrip(";,")
    return assignments


def _neutralize_param_assignments(lines: list[str]) -> list[str]:
    def _neutralize(line: str) -> str:
        return _PARAM_ASSIGN_RE.sub(
            r"_oddlua_disabled_params.\g<name> = \g<value>", line
        )

    return [_neutralize(line) for line in lines]


def _damage_kind(text: str) -> str:
    if "doMagicWeaponskill" in text:
        return "magical"
    if "doRangedWeaponskill" in text:
        return "ranged"
    if "doPhysicalWeaponskill" in text:
        return "physical"
    return "physical"


def _parse_int(
    values: dict[str, str],
    name: str,
    *,
    default: int,
    warnings: list[str],
) -> int:
    raw = values.get(name.lower())
    if raw is None:
        return default
    try:
        return int(float(raw))
    except ValueError:
        warnings.append(f"Malformed int value for {name}: {raw}")
        return default


def _parse_bool(values: dict[str, str], name: str) -> bool:
    return values.get(name.lower()) == "true"


def _parse_float_tuple(
    values: dict[str, str],
    name: str,
    *,
    optional: bool = False,
    default: tuple[float, float, float] | None = None,
    warnings: list[str],
) -> tuple[float, float, float] | None:
    raw = values.get(name.lower())
    if raw is None:
        return default

    parsed = _parse_tuple(raw)
    if parsed is None:
        warnings.append(f"Malformed tuple value for {name}: {raw}")
        return None if optional else (default or (1.0, 1.0, 1.0))
    return parsed


def _parse_tuple(raw: str) -> tuple[float, float, float] | None:
    if not (raw.startswith("{") and raw.endswith("}")):
        return None
    inner = raw[1:-1]
    parts = [part.strip() for part in inner.split(",") if part.strip()]
    if len(parts) != 3:
        return None
    parsed: list[float] = []
    for part in parts:
        try:
            parsed.append(float(part))
        except ValueError:
            return None
    return (parsed[0], parsed[1], parsed[2])


def _eval_arithmetic_expr(expr: str) -> float | None:
    try:
        root = ast.parse(expr, mode="eval")
    except SyntaxError:
        return None

    def visit(node: ast.AST) -> float:
        if isinstance(node, ast.Expression):
            return visit(node.body)
        if (
            isinstance(node, ast.Constant)
            and isinstance(node.value, (int, float))
            and not isinstance(node.value, bool)
        ):
            return float(node.value)
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.UAdd, ast.USub)):
            value = visit(node.operand)
            return value if isinstance(node.op, ast.UAdd) else -value
        if isinstance(node, ast.BinOp) and type(node.op) in _ARITHMETIC_BINOPS:
            return _ARITHMETIC_BINOPS[type(node.op)](
                visit(node.left),
                visit(node.right),
            )
        raise ValueError(f"unsupported numeric expression node: {type(node).__name__}")

    try:
        return visit(root)
    except (ArithmeticError, ValueError):
        return None


def _parse_numeric_expression(raw: str) -> float | None:
    cleaned = raw.strip().replace(" ", "")
    try:
        return float(cleaned)
    except ValueError:
        pass

    merit_expr = re.sub(
        r"player:getMerit\([^)]*\)",
        str(_MERIT_LEVEL_FOR_STATIC_PLANNING),
        cleaned,
    )
    if not re.fullmatch(r"[0-9.+\-*/()]+", merit_expr):
        return None

    return _eval_arithmetic_expr(merit_expr)


def _parse_wsc(values: dict[str, str], *, warnings: list[str]) -> dict[str, float]:
    raw_values = {
        "str": ("STR", values.get("str_wsc")),
        "dex": ("DEX", values.get("dex_wsc")),
        "vit": ("VIT", values.get("vit_wsc")),
        "agi": ("AGI", values.get("agi_wsc")),
        "int": ("INT", values.get("int_wsc")),
        "mnd": ("MND", values.get("mnd_wsc")),
        "chr": ("CHR", values.get("chr_wsc")),
    }
    parsed = {}
    for _, (name, raw) in raw_values.items():
        if raw is None:
            continue
        value = _parse_numeric_expression(raw)
        if value is None:
            warnings.append(f"Malformed WSC numeric value for {name}: {raw}")
            continue
        parsed[name] = value
    return parsed


def _parse_element(text: str) -> str:
    matches = re.findall(r"params\.ele\s*=\s*xi\.element\.([A-Z_]+)", text)
    if not matches:
        return "None"
    return ELEMENT_NAME_BY_LUA.get(matches[-1], "None")


def _parse_additional_effects(text: str) -> tuple[str, ...]:
    effects = []
    for name in re.findall(r"\bxi\.effect\.([A-Z_]+)", text):
        effects.append(name.lower())
    return tuple(dict.fromkeys(effects))


def _strip_comment(line: str) -> str:
    return line.split("--", 1)[0]


def _strip_code_for_scanning(line: str) -> str:
    # Skip Lua comments and quoted string contents before control-token matching.
    stripped: list[str] = []
    in_single = False
    in_double = False
    i = 0
    while i < len(line):
        char = line[i]

        if in_single:
            if char == "\\" and i + 1 < len(line):
                i += 2
                continue
            if char == "'":
                in_single = False
            i += 1
            continue

        if in_double:
            if char == "\\" and i + 1 < len(line):
                i += 2
                continue
            if char == '"':
                in_double = False
            i += 1
            continue

        if char == "-" and i + 1 < len(line) and line[i + 1] == "-":
            break

        if char == "'":
            in_single = True
            i += 1
            continue

        if char == '"':
            in_double = True
            i += 1
            continue

        stripped.append(char)
        i += 1

    return "".join(stripped)
