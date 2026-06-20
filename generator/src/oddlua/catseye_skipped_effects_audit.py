from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
import re
from typing import Iterable

from . import catseye_wiki_stats as wiki_stats
from .statsdb import (
    CATSEYE_MANUAL_REVIEW_EFFECT_PATTERNS,
    CatseyeEquipmentRecord,
    _iter_catseye_equipment_records,
    _resolve_catseye_pages_root,
)


SIGNED_EFFECT_FRAGMENT_RE = re.compile(
    r"""
    (?P<fragment>
        (?<![A-Za-z0-9])
        (?P<label>[A-Za-z"][A-Za-z0-9 ./'"&()/:+-]*?[A-Za-z0-9)"])
        \s*:?\s*
        (?P<value>[+-]\s*\d+%?)
    )
    (?!\s*~)
    """,
    re.IGNORECASE | re.VERBOSE,
)
RANGED_AUGMENT_RE = re.compile(r"[+-]?\s*\d+\s*~\s*[+-]?\s*\d+")
UNLABELED_SIGNED_VALUE_RE = re.compile(r"^[+-]\s*\d+%?$")
PET_SCOPED_RE = re.compile(r"(?i)\b(?:pet|avatar|wyvern|luopan):")
LATENT_ACTIVATION_RE = re.compile(r"(?i)\(\s*latent(?:\s+activation)?\s*:[^)]*\)")
HANDLED_SPECIAL_FRAGMENT_RES = (
    re.compile(r"\b(?:DMG|Delay):\s*[+-]\s*\d+", re.IGNORECASE),
    re.compile(r"\bmovement\s+speed\s*\+?\s*\d+\s*%", re.IGNORECASE),
    re.compile(r'"?\bSurveyor\b"?\s*\+\d+', re.IGNORECASE),
    re.compile(r'"?\bExpert Angler\b"?\s*\+\d+', re.IGNORECASE),
    re.compile(r"\bFatigue limit\s*\+\d+%", re.IGNORECASE),
    re.compile(r"\bGolden Arrow Rate\s*\+\d+%", re.IGNORECASE),
    re.compile(r"\bMagic\s+Potency\s*\+?\s*\d+%", re.IGNORECASE),
    re.compile(r"\b(?:right|left)\s+ear\s*:\s*Magic\s+skills\s*\+?\s*\d+", re.IGNORECASE),
    re.compile(r"(?<![A-Za-z]\s)\bMagic\s+skill\s*\+?\s*\d+", re.IGNORECASE),
    re.compile(r"\bSynthesis\s+skill\s*\+?\s*\d+", re.IGNORECASE),
    re.compile(r"\bFencer\s*\+?\s*\d+", re.IGNORECASE),
)
MANUAL_REVIEW_SPECIAL_FRAGMENT_RES = tuple(
    pattern
    for _effect_tag, pattern, _target, _note in CATSEYE_MANUAL_REVIEW_EFFECT_PATTERNS
)


@dataclass(frozen=True)
class SkippedEffectFragment:
    label: str
    fragment: str
    item_name: str
    source_path: str
    stats_text: str


@dataclass(frozen=True)
class SkippedEffectGroup:
    label: str
    count: int
    examples: tuple[SkippedEffectFragment, ...]


@dataclass(frozen=True)
class SkippedEffectsAuditResult:
    summary: dict[str, int]
    groups: tuple[SkippedEffectGroup, ...]
    output_dir: Path | None = None
    json_path: Path | None = None
    markdown_path: Path | None = None


def audit_catseye_skipped_effects(
    *,
    catseye_wiki_root: Path | str,
    output_root: Path | str,
    write_files: bool = True,
    max_examples_per_group: int = 5,
) -> SkippedEffectsAuditResult:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        raise FileNotFoundError(f"Catseye wiki equipment pages not found: {catseye_wiki_root}")

    records = tuple(_iter_catseye_equipment_records(pages_root))
    fragments = [
        fragment
        for record in records
        for fragment in skipped_effect_fragments_for_record(record)
    ]
    groups = _group_fragments(fragments, max_examples_per_group=max_examples_per_group)
    summary = {
        "records": len(records),
        "fragment_groups": len(groups),
        "fragments": len(fragments),
    }
    result = SkippedEffectsAuditResult(summary=summary, groups=groups)
    if not write_files:
        return result

    output_dir = Path(output_root) / _timestamp()
    output_dir.mkdir(parents=True, exist_ok=True)
    json_path = output_dir / "skipped_effect_fragments.json"
    markdown_path = output_dir / "skipped_effect_fragments.md"
    json_path.write_text(_audit_json(result), encoding="utf-8")
    markdown_path.write_text(_audit_markdown(result), encoding="utf-8")
    return SkippedEffectsAuditResult(
        summary=summary,
        groups=groups,
        output_dir=output_dir,
        json_path=json_path,
        markdown_path=markdown_path,
    )


def skipped_effect_fragments_for_record(record: CatseyeEquipmentRecord) -> tuple[SkippedEffectFragment, ...]:
    return tuple(
        SkippedEffectFragment(
            label=label,
            fragment=fragment,
            item_name=record.name,
            source_path=record.source_path,
            stats_text=record.stats_text,
        )
        for label, fragment in skipped_effect_fragments_for_text(record.stats_text)
    )


def skipped_effect_fragments_for_text(stats_text: str) -> tuple[tuple[str, str], ...]:
    fragments: list[tuple[str, str]] = []
    for source_line in _player_stat_lines(stats_text):
        for match in SIGNED_EFFECT_FRAGMENT_RE.finditer(source_line):
            fragment = _normalize_fragment(match.group("fragment"))
            if not fragment or _is_known_or_ignored_fragment(fragment):
                continue
            fragments.append((_fragment_label(fragment), fragment))
    return tuple(fragments)


def _player_stat_lines(stats_text: str) -> tuple[str, ...]:
    lines: list[str] = []
    for raw_line in stats_text.replace("\u00a0", " ").splitlines():
        for line in _split_compact_stat_text(raw_line.strip()):
            if not line:
                continue
            line = LATENT_ACTIVATION_RE.sub("", line).strip()
            if not line:
                continue
            pet_match = PET_SCOPED_RE.search(line)
            if pet_match is not None:
                line = line[: pet_match.start()].strip()
            if line:
                lines.append(line)
    return tuple(lines)


def _split_compact_stat_text(text: str) -> tuple[str, ...]:
    if not text:
        return ()
    # Catseye page ingestion collapses item stat blocks into a single line.
    # Split before common structural clauses so a parsed stat does not swallow a
    # later unresolved effect label during regex scanning.
    text = re.sub(
        r"\s+(?=(?:Latent Effect|Hidden Effect|Set Bonus|Image:|Lv\.)\b)",
        "\n",
        text,
        flags=re.IGNORECASE,
    )
    return tuple(part.strip() for part in text.splitlines() if part.strip())


def _is_known_or_ignored_fragment(fragment: str) -> bool:
    if RANGED_AUGMENT_RE.search(fragment):
        return True
    if UNLABELED_SIGNED_VALUE_RE.match(fragment):
        return True
    if any(pattern.search(fragment) for pattern in HANDLED_SPECIAL_FRAGMENT_RES):
        return True
    if any(pattern.search(fragment) for pattern in MANUAL_REVIEW_SPECIAL_FRAGMENT_RES):
        return True
    if wiki_stats.parse_wiki_stat_mods(fragment):
        return True
    if wiki_stats.parse_wiki_weapon_stats(fragment):
        return True
    if wiki_stats.parse_wiki_conditional_stat_mods(fragment):
        return True
    return False


def _normalize_fragment(fragment: str) -> str:
    fragment = " ".join(fragment.replace("\u00a0", " ").split())
    previous = None
    while previous != fragment:
        previous = fragment
        fragment = re.sub(r"(?i)^(?:DMG|Delay|DEF):?\s*\d+\s+", "", fragment).strip()
    fragment = re.sub(r"\s+([+-])", r"\1", fragment)
    fragment = re.sub(r"([+-])\s+", r"\1", fragment)
    fragment = re.sub(r"\s+:", ":", fragment)
    fragment = re.sub(r":(?=[A-Za-z\"])", ": ", fragment)
    return fragment.strip(" ,;")


def _fragment_label(fragment: str) -> str:
    label = re.sub(r"\s*:?\s*[+-]\s*\d+%?\s*$", "", fragment).strip()
    label = re.sub(r"\s+", " ", label)
    label = label.strip(" :")
    return label or "Unlabeled signed value"


def _group_fragments(
    fragments: Iterable[SkippedEffectFragment],
    *,
    max_examples_per_group: int,
) -> tuple[SkippedEffectGroup, ...]:
    counts: dict[str, int] = {}
    examples: dict[str, list[SkippedEffectFragment]] = {}
    for fragment in fragments:
        counts[fragment.label] = counts.get(fragment.label, 0) + 1
        bucket = examples.setdefault(fragment.label, [])
        if len(bucket) < max_examples_per_group:
            bucket.append(fragment)

    groups = [
        SkippedEffectGroup(
            label=label,
            count=count,
            examples=tuple(examples.get(label, ())),
        )
        for label, count in counts.items()
    ]
    return tuple(sorted(groups, key=lambda group: (-group.count, group.label.lower())))


def _audit_json(result: SkippedEffectsAuditResult) -> str:
    payload = {
        "summary": result.summary,
        "groups": [
            {
                "label": group.label,
                "count": group.count,
                "examples": [asdict(example) for example in group.examples],
            }
            for group in result.groups
        ],
    }
    return json.dumps(payload, indent=2, sort_keys=True)


def _audit_markdown(result: SkippedEffectsAuditResult) -> str:
    lines = [
        "# Catseye Skipped Effect Fragment Audit",
        "",
        "## Summary",
        "",
    ]
    for key, value in result.summary.items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Top Groups", ""])
    for group in result.groups[:50]:
        lines.append(f"- {group.label}: {group.count}")
        for example in group.examples[:2]:
            lines.append(f"  - {example.item_name} ({example.source_path}): `{example.fragment}`")
    lines.append("")
    return "\n".join(lines)


def _timestamp() -> str:
    return datetime.now(timezone.utc).astimezone().strftime("%Y%m%d-%H%M%S")
