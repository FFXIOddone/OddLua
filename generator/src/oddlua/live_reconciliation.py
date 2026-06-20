from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from dataclasses import dataclass, field
import json
from pathlib import Path
from typing import Any, Iterable, Sequence


@dataclass(frozen=True)
class SetReconciliationCounts:
    total_count: int = 0
    match_count: int = 0
    mismatch_count: int = 0
    unknown_count: int = 0
    repair_queued_count: int = 0
    repair_failed_count: int = 0
    unrepaired_mismatch_count: int = 0


@dataclass(frozen=True)
class ReconciliationSummary:
    total_count: int = 0
    match_count: int = 0
    mismatch_count: int = 0
    unknown_count: int = 0
    repair_queued_count: int = 0
    repair_failed_count: int = 0
    unrepaired_mismatch_count: int = 0
    set_counts: dict[str, SetReconciliationCounts] = field(default_factory=dict)
    slot_mismatches: dict[str, Counter[tuple[str, str]]] = field(default_factory=dict)
    unknown_reasons: Counter[str] = field(default_factory=Counter)


def summarize_reconciliation_log(path: Path | str) -> ReconciliationSummary:
    source = Path(path)
    total_count = 0
    match_count = 0
    mismatch_count = 0
    unknown_count = 0
    repair_queued_count = 0
    repair_failed_count = 0
    unrepaired_mismatch_count = 0
    set_totals: dict[str, Counter[str]] = defaultdict(Counter)
    slot_mismatches: dict[str, Counter[tuple[str, str]]] = defaultdict(Counter)
    unknown_reasons: Counter[str] = Counter()

    for row in _iter_reconciliation_rows(source):
        status = str(row.get("status") or "unknown_observation")
        set_name = str(row.get("set") or "unknown")

        total_count += 1
        set_totals[set_name]["total"] += 1
        if status == "match":
            match_count += 1
            set_totals[set_name]["match"] += 1
        elif status == "mismatch":
            mismatch_count += 1
            set_totals[set_name]["mismatch"] += 1
            if row.get("repairQueued") is True:
                repair_queued_count += 1
                set_totals[set_name]["repair_queued"] += 1
            elif row.get("repair") is True:
                repair_failed_count += 1
                set_totals[set_name]["repair_failed"] += 1
            else:
                unrepaired_mismatch_count += 1
                set_totals[set_name]["unrepaired"] += 1
            for mismatch in _iter_mismatch_rows(row.get("mismatches")):
                slot = str(mismatch.get("slot") or "unknown")
                expected = str(mismatch.get("expected") or "")
                observed = str(mismatch.get("observed") or "")
                slot_mismatches[slot][(expected, observed)] += 1
        else:
            unknown_count += 1
            set_totals[set_name]["unknown"] += 1
            reason = str(row.get("reason") or status)
            unknown_reasons[reason] += 1

    return ReconciliationSummary(
        total_count=total_count,
        match_count=match_count,
        mismatch_count=mismatch_count,
        unknown_count=unknown_count,
        repair_queued_count=repair_queued_count,
        repair_failed_count=repair_failed_count,
        unrepaired_mismatch_count=unrepaired_mismatch_count,
        set_counts={
            set_name: SetReconciliationCounts(
                total_count=counts["total"],
                match_count=counts["match"],
                mismatch_count=counts["mismatch"],
                unknown_count=counts["unknown"],
                repair_queued_count=counts["repair_queued"],
                repair_failed_count=counts["repair_failed"],
                unrepaired_mismatch_count=counts["unrepaired"],
            )
            for set_name, counts in sorted(set_totals.items())
        },
        slot_mismatches={slot: counter for slot, counter in sorted(slot_mismatches.items())},
        unknown_reasons=unknown_reasons,
    )


def format_reconciliation_markdown(summary: ReconciliationSummary) -> str:
    lines = [
        "# OddLua Live Reconciliation Report",
        "",
        (
            f"Total snapshots: {summary.total_count}; matches {summary.match_count}; "
            f"mismatches {summary.mismatch_count}; unknown {summary.unknown_count}."
        ),
        (
            f"Repair outcomes: queued repairs {summary.repair_queued_count}; "
            f"repair verification failures {summary.repair_failed_count}; "
            f"unrepaired mismatches {summary.unrepaired_mismatch_count}."
        ),
        "",
        "## Sets",
    ]

    if summary.set_counts:
        for set_name, counts in summary.set_counts.items():
            lines.append(
                f"- {set_name}: total {counts.total_count}, matches {counts.match_count}, "
                f"mismatches {counts.mismatch_count}, unknown {counts.unknown_count}, "
                f"queued repairs {counts.repair_queued_count}, "
                f"repair failures {counts.repair_failed_count}, "
                f"unrepaired {counts.unrepaired_mismatch_count}"
            )
    else:
        lines.append("- none")

    lines.extend(["", "## Slot Mismatches"])
    if summary.slot_mismatches:
        for slot, counter in summary.slot_mismatches.items():
            for (expected, observed), count in counter.most_common():
                lines.append(f"- {slot}: expected `{expected}`, observed `{observed}` - {count}")
    else:
        lines.append("- none")

    lines.extend(["", "## Unknown Observations"])
    if summary.unknown_reasons:
        for reason, count in summary.unknown_reasons.most_common():
            lines.append(f"- {reason} - {count}")
    else:
        lines.append("- none")

    return "\n".join(lines) + "\n"


def write_reconciliation_report(log_path: Path | str, output_path: Path | str) -> Path:
    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        format_reconciliation_markdown(summarize_reconciliation_log(log_path)),
        encoding="utf-8",
    )
    return output


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Summarize OddLua live reconciliation snapshots.")
    parser.add_argument("log_path", type=Path, help="OddLua reconciliation JSONL log path.")
    parser.add_argument("--output", "-o", type=Path, default=None, help="Optional Markdown report path.")
    args = parser.parse_args(argv)

    if args.output is not None:
        written = write_reconciliation_report(args.log_path, args.output)
        print(written)
    else:
        print(format_reconciliation_markdown(summarize_reconciliation_log(args.log_path)), end="")
    return 0


def _iter_reconciliation_rows(path: Path) -> Iterable[dict[str, Any]]:
    if not path.exists():
        return

    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        if isinstance(row, dict):
            yield row


def _iter_mismatch_rows(value: object) -> Iterable[dict[str, Any]]:
    if not isinstance(value, list):
        return

    for row in value:
        if isinstance(row, dict):
            yield row


if __name__ == "__main__":
    raise SystemExit(main())
