from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
from typing import Iterable, Literal

from .gearexport import GearItem
from .itemstats import ItemStatsIndex
from .mechanics_opportunities import (
    MechanicsOpportunity,
    OpportunityEvidence,
    discover_mechanics_opportunities,
)


AuditStatus = Literal[
    "owned_supported",
    "server_supported_missing_owned",
    "no_server_evidence",
]


@dataclass(frozen=True)
class MechanicsOpportunityAuditEntry:
    key: str
    title: str
    category: str
    status: AuditStatus
    action_window: str
    desired_outputs: tuple[str, ...]
    jobs: tuple[str, ...]
    trigger_mods: tuple[str, ...]
    notes: str
    owned_evidence: tuple[OpportunityEvidence, ...]
    server_examples: tuple[OpportunityEvidence, ...]
    server_evidence_count: int

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "key": self.key,
            "title": self.title,
            "category": self.category,
            "status": self.status,
            "actionWindow": self.action_window,
            "desiredOutputs": list(self.desired_outputs),
            "jobs": list(self.jobs),
            "triggerMods": list(self.trigger_mods),
            "notes": self.notes,
            "ownedEvidence": [
                evidence.manifest_metadata()
                for evidence in self.owned_evidence
            ],
            "serverExamples": [
                evidence.manifest_metadata()
                for evidence in self.server_examples
            ],
            "ownedEvidenceCount": len(self.owned_evidence),
            "serverEvidenceCount": self.server_evidence_count,
        }


@dataclass(frozen=True)
class MechanicsOpportunityAuditResult:
    generated_at: str
    source_path: str
    owned_item_count: int
    summary: dict[str, int]
    entries: tuple[MechanicsOpportunityAuditEntry, ...]
    output_dir: Path | None = None
    json_path: Path | None = None
    markdown_path: Path | None = None

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "generatedAt": self.generated_at,
            "sourcePath": self.source_path,
            "ownedItemCount": self.owned_item_count,
            "summary": dict(self.summary),
            "entries": [
                entry.manifest_metadata()
                for entry in self.entries
            ],
        }


def audit_mechanics_opportunities(
    *,
    item_stats: ItemStatsIndex,
    owned_items: Iterable[GearItem],
    output_root: Path | str | None = None,
    include_no_server_evidence: bool = True,
    server_example_limit: int = 8,
    owned_evidence_limit: int = 24,
    write_files: bool = False,
) -> MechanicsOpportunityAuditResult:
    owned_item_ids = {
        item.id
        for item in owned_items
        if item.id > 0
    }
    opportunities = discover_mechanics_opportunities(
        item_stats,
        include_empty=True,
        evidence_limit=None,
    )
    entries = tuple(
        _audit_entry(
            opportunity,
            owned_item_ids=owned_item_ids,
            server_example_limit=server_example_limit,
            owned_evidence_limit=owned_evidence_limit,
        )
        for opportunity in opportunities
    )
    if not include_no_server_evidence:
        entries = tuple(
            entry
            for entry in entries
            if entry.status != "no_server_evidence"
        )

    summary = Counter(entry.status for entry in entries)
    for status in ("owned_supported", "server_supported_missing_owned", "no_server_evidence"):
        summary[status] += 0
    summary["definition_count"] = len(opportunities)
    summary["reported_count"] = len(entries)
    summary["owned_item_count"] = len(owned_item_ids)
    summary["server_supported"] = summary["owned_supported"] + summary["server_supported_missing_owned"]

    result = MechanicsOpportunityAuditResult(
        generated_at=_timestamp(),
        source_path=str(item_stats.source_path),
        owned_item_count=len(owned_item_ids),
        summary=dict(summary),
        entries=entries,
    )
    if not write_files:
        return result

    root = Path(output_root) if output_root is not None else Path("reports") / "mechanics-opportunities"
    output_dir = _create_unique_output_dir(root, _timestamp_for_path())
    json_path = output_dir / "audit.json"
    markdown_path = output_dir / "audit.md"
    json_path.write_text(json.dumps(result.manifest_metadata(), indent=2, sort_keys=True), encoding="utf-8")
    markdown_path.write_text(markdown_report(result), encoding="utf-8")
    return MechanicsOpportunityAuditResult(
        generated_at=result.generated_at,
        source_path=result.source_path,
        owned_item_count=result.owned_item_count,
        summary=result.summary,
        entries=result.entries,
        output_dir=output_dir,
        json_path=json_path,
        markdown_path=markdown_path,
    )


def markdown_report(result: MechanicsOpportunityAuditResult) -> str:
    lines = [
        "# Mechanics Opportunity Audit",
        "",
        f"- Generated: {result.generated_at}",
        f"- Stats source: `{result.source_path}`",
        f"- Owned item ids: {result.owned_item_count}",
        f"- Owned-supported opportunities: {result.summary.get('owned_supported', 0)}",
        f"- Server-supported missing owned gear: {result.summary.get('server_supported_missing_owned', 0)}",
        f"- No server evidence: {result.summary.get('no_server_evidence', 0)}",
        "",
        "## Owned Supported",
        "",
    ]
    _append_entries(lines, result.entries, "owned_supported")
    lines.extend(("", "## Missing Owned Gear", ""))
    _append_entries(lines, result.entries, "server_supported_missing_owned")
    lines.extend(("", "## No Server Evidence", ""))
    _append_entries(lines, result.entries, "no_server_evidence")
    return "\n".join(lines).rstrip() + "\n"


def _append_entries(
    lines: list[str],
    entries: tuple[MechanicsOpportunityAuditEntry, ...],
    status: AuditStatus,
) -> None:
    filtered = [
        entry
        for entry in entries
        if entry.status == status
    ]
    if not filtered:
        lines.append("- None")
        return
    for entry in filtered:
        lines.append(f"- **{entry.title}** (`{entry.key}`): {entry.action_window}")
        if entry.owned_evidence:
            lines.append(f"  Owned: {_evidence_text(entry.owned_evidence)}")
        elif entry.server_examples:
            lines.append(f"  Server examples: {_evidence_text(entry.server_examples)}")
        lines.append(f"  Outputs: {', '.join(entry.desired_outputs)}")


def _audit_entry(
    opportunity: MechanicsOpportunity,
    *,
    owned_item_ids: set[int],
    server_example_limit: int,
    owned_evidence_limit: int,
) -> MechanicsOpportunityAuditEntry:
    owned_evidence = tuple(
        evidence
        for evidence in opportunity.evidence
        if evidence.item_id in owned_item_ids
    )
    if owned_evidence:
        status: AuditStatus = "owned_supported"
    elif opportunity.evidence:
        status = "server_supported_missing_owned"
    else:
        status = "no_server_evidence"

    return MechanicsOpportunityAuditEntry(
        key=opportunity.key,
        title=opportunity.title,
        category=opportunity.category,
        status=status,
        action_window=opportunity.action_window,
        desired_outputs=opportunity.desired_outputs,
        jobs=opportunity.jobs,
        trigger_mods=opportunity.trigger_mods,
        notes=opportunity.notes,
        owned_evidence=owned_evidence[:owned_evidence_limit],
        server_examples=opportunity.evidence[:server_example_limit],
        server_evidence_count=len(opportunity.evidence),
    )


def _evidence_text(evidence_rows: tuple[OpportunityEvidence, ...]) -> str:
    return "; ".join(
        f"{row.item_name} ({', '.join(row.mods)})"
        for row in evidence_rows[:6]
    )


def _timestamp() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def _timestamp_for_path() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def _create_unique_output_dir(root: Path, timestamp_slug: str) -> Path:
    for index in range(1000):
        suffix = "" if index == 0 else f"-{index + 1:02d}"
        output_dir = root / f"{timestamp_slug}{suffix}"
        try:
            output_dir.mkdir(parents=True, exist_ok=False)
        except FileExistsError:
            continue
        return output_dir
    raise RuntimeError(f"Could not create unique mechanics audit directory under {root}")
