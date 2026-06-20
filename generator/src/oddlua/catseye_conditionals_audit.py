from __future__ import annotations

from collections import Counter
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
import re

from .catseye_wiki_stats import (
    parse_wiki_conditional_stat_mods,
    _parse_conditional_stat_mods_from_body,
)
from .statsdb import _iter_catseye_equipment_records, _resolve_catseye_pages_root


RUNTIME_SUPPORTED_CONDITIONS = {
    "day",
    "level_gte",
    "level_lt",
    "mp_gt",
    "mpp_lt",
    "status",
    "weather",
    "zone_region",
}
LATENT_EFFECT_RE = re.compile(
    r"(?i)\blatent\s+effect\s*(?:\([^)]*\))?\s*:\s*(?P<body>.*?)(?=\s*\(?\s*latent\b|$)"
)
LATENT_ACTIVATION_RE = re.compile(r"(?i)\(\s*latent(?:\s+activation)?\s*:\s*(?P<condition>[^)]*)\)")
PET_SCOPE_RE = re.compile(r"(?i)\b(?:pet|avatar|automaton|wyvern|luopan)\s*:")
SPECIAL_EFFECT_RE = re.compile(
    r"(?i)\b(?:additional effect|enhances?|augments?|adds|grants?)\b"
)


@dataclass(frozen=True)
class ParsedConditionalEntry:
    item_name: str
    source_path: str
    condition_type: str
    condition_name: str
    runtime_supported: bool
    mods: tuple[tuple[str, int], ...]
    source_text: str


@dataclass(frozen=True)
class DeferredConditionalEntry:
    item_name: str
    source_path: str
    reason: str
    line: str
    detail: str
    source_text: str


@dataclass(frozen=True)
class ConditionalAuditResult:
    summary: dict[str, int]
    parsed: tuple[ParsedConditionalEntry, ...]
    deferred: tuple[DeferredConditionalEntry, ...]
    output_dir: Path | None = None
    json_path: Path | None = None
    markdown_path: Path | None = None


def audit_catseye_conditionals(
    *,
    catseye_wiki_root: Path | str,
    output_root: Path | str,
    write_files: bool = True,
) -> ConditionalAuditResult:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        raise FileNotFoundError(f"Catseye wiki equipment pages not found: {catseye_wiki_root}")

    parsed: list[ParsedConditionalEntry] = []
    deferred: list[DeferredConditionalEntry] = []
    summary: Counter[str] = Counter()

    for record in _iter_catseye_equipment_records(pages_root):
        summary["records"] += 1
        parsed_mods = parse_wiki_conditional_stat_mods(record.stats_text)
        if parsed_mods:
            summary["parsed_records"] += 1

        grouped: dict[tuple[str, str], list[tuple[str, int]]] = {}
        for mod in parsed_mods:
            grouped.setdefault((mod.condition_type, mod.condition_name), []).append((mod.mod_name, mod.value))
        summary["parsed_mods"] += len(parsed_mods)

        for (condition_type, condition_name), mods in sorted(grouped.items()):
            runtime_supported = condition_type in RUNTIME_SUPPORTED_CONDITIONS
            if runtime_supported:
                summary["runtime_supported_parsed"] += 1
            else:
                summary["runtime_deferred_parsed"] += 1
                deferred.append(
                    DeferredConditionalEntry(
                        item_name=record.name,
                        source_path=record.source_path,
                        reason="runtime_unsupported_condition",
                        line=record.stats_text,
                        detail=f"{condition_type}:{condition_name}",
                        source_text=record.source_text,
                    )
                )

            parsed.append(
                ParsedConditionalEntry(
                    item_name=record.name,
                    source_path=record.source_path,
                    condition_type=condition_type,
                    condition_name=condition_name,
                    runtime_supported=runtime_supported,
                    mods=tuple(sorted(mods)),
                    source_text=record.source_text,
                )
            )

        for entry in _deferred_entries_for_record(record.name, record.source_path, record.stats_text, record.source_text):
            deferred.append(entry)
            summary["deferred_records"] += 1

    summary["deferred_entries"] = len(deferred)
    result = ConditionalAuditResult(
        summary=dict(summary),
        parsed=tuple(parsed),
        deferred=tuple(deferred),
    )
    if not write_files:
        return result

    output_dir = Path(output_root) / _timestamp()
    output_dir.mkdir(parents=True, exist_ok=True)
    json_path = output_dir / "conditionals_audit.json"
    markdown_path = output_dir / "conditionals_audit.md"
    json_path.write_text(_audit_json(result), encoding="utf-8")
    markdown_path.write_text(_audit_markdown(result), encoding="utf-8")
    return ConditionalAuditResult(
        summary=result.summary,
        parsed=result.parsed,
        deferred=result.deferred,
        output_dir=output_dir,
        json_path=json_path,
        markdown_path=markdown_path,
    )


def _deferred_entries_for_record(
    item_name: str,
    source_path: str,
    stats_text: str,
    source_text: str,
) -> tuple[DeferredConditionalEntry, ...]:
    entries: list[DeferredConditionalEntry] = []
    parsed_mods = parse_wiki_conditional_stat_mods(stats_text)

    for line in _stat_lines(stats_text):
        lower = line.lower()
        if "latent effect" in lower:
            for body, activation in _latent_bodies(line):
                mods = _parse_conditional_stat_mods_from_body(body)
                if mods and not parsed_mods:
                    entries.append(
                        DeferredConditionalEntry(
                            item_name=item_name,
                            source_path=source_path,
                            reason="unparsed_latent_condition",
                            line=line,
                            detail=activation or "unknown latent activation",
                            source_text=source_text,
                        )
                    )

        if PET_SCOPE_RE.search(line):
            entries.append(
                DeferredConditionalEntry(
                    item_name=item_name,
                    source_path=source_path,
                    reason="pet_or_summon_scope",
                    line=line,
                    detail="Pet/avatar/wyvern/automaton/luopan stats need pet-aware set scoring.",
                    source_text=source_text,
                )
            )

        if SPECIAL_EFFECT_RE.search(line) and "latent effect" not in lower:
            entries.append(
                DeferredConditionalEntry(
                    item_name=item_name,
                    source_path=source_path,
                    reason="special_effect_text",
                    line=line,
                    detail="Effect text may need a named mechanic mapping before scoring.",
                    source_text=source_text,
                )
            )
    return tuple(entries)


def _latent_bodies(line: str) -> tuple[tuple[str, str], ...]:
    activation_match = LATENT_ACTIVATION_RE.search(line)
    activation = activation_match.group("condition").strip() if activation_match else ""
    results = []
    for match in LATENT_EFFECT_RE.finditer(line):
        body = LATENT_ACTIVATION_RE.sub("", match.group("body")).strip()
        if body:
            results.append((body, activation))
    return tuple(results)


def _stat_lines(stats_text: str) -> list[str]:
    return [line.strip() for line in stats_text.replace("\u00a0", " ").splitlines() if line.strip()]


def _audit_json(result: ConditionalAuditResult) -> str:
    payload = {
        "summary": result.summary,
        "parsed": [asdict(entry) for entry in result.parsed],
        "deferred": [asdict(entry) for entry in result.deferred],
    }
    return json.dumps(payload, indent=2, sort_keys=True)


def _audit_markdown(result: ConditionalAuditResult) -> str:
    lines = [
        "# Catseye Conditional Gear Audit",
        "",
        "## Summary",
        "",
    ]
    for key, value in sorted(result.summary.items()):
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Parsed Conditions", ""])
    for entry in result.parsed:
        support = "runtime" if entry.runtime_supported else "stored-only"
        mods = ", ".join(f"{name}{value:+d}" for name, value in entry.mods)
        lines.append(f"- {entry.item_name}: {entry.condition_type}:{entry.condition_name} ({support}) -> {mods}")
    lines.extend(["", "## Deferred Conditions", ""])
    for entry in result.deferred:
        lines.append(f"- {entry.item_name}: {entry.reason} - {entry.detail}")
        lines.append(f"  - `{entry.line}`")
    lines.append("")
    return "\n".join(lines)


def _timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
