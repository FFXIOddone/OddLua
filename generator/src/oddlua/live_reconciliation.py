from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import sys
from typing import Any, Iterable, Literal, Mapping, Sequence


@dataclass(frozen=True)
class SetReconciliationCounts:
    total_count: int = 0
    match_count: int = 0
    mismatch_count: int = 0
    unknown_count: int = 0
    repair_queued_count: int = 0
    repair_failed_count: int = 0
    unrepaired_mismatch_count: int = 0


LifecycleOutcome = Literal[
    "match",
    "unknown",
    "resolved_transient_mismatch",
    "resolved_queued_repair",
    "unresolved_queued_repair",
    "terminal_repair_failure",
    "unrepaired_mismatch",
]


@dataclass(frozen=True)
class ReconciliationLifecycleKey:
    player: str
    player_id: str
    job: str
    load_cycle_index: int
    profile_build_token: str
    action_sequence: str
    repair_cycle_sequence: int | None
    set_name: str
    playstyle: str
    intent: str
    expected_json: str


@dataclass(frozen=True)
class ReconciliationRowLifecycle:
    row_index: int
    outcome: LifecycleOutcome
    key: ReconciliationLifecycleKey
    resolved_by_row_index: int | None = None
    terminal_source: str = ""


@dataclass(frozen=True)
class ReconciliationLifecycleClassification:
    rows: tuple[ReconciliationRowLifecycle, ...] = ()
    load_cycle_count: int = 0
    raw_total_count: int = 0
    raw_match_count: int = 0
    raw_mismatch_count: int = 0
    raw_unknown_count: int = 0
    raw_repair_queued_count: int = 0
    raw_repair_failed_count: int = 0
    raw_unrepaired_mismatch_count: int = 0
    resolved_transient_mismatch_count: int = 0
    resolved_queued_repair_count: int = 0
    unresolved_queued_repair_count: int = 0
    terminal_repair_failure_count: int = 0
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
    schemas: tuple[str, ...] = ()
    players: tuple[str, ...] = ()
    player_ids: tuple[str, ...] = ()
    jobs: tuple[str, ...] = ()
    set_counts: dict[str, SetReconciliationCounts] = field(default_factory=dict)
    slot_mismatches: dict[str, Counter[tuple[str, str]]] = field(default_factory=dict)
    raw_equipment_differences: dict[str, Counter[tuple[str, str]]] = field(default_factory=dict)
    unknown_reasons: Counter[str] = field(default_factory=Counter)
    lifecycle: ReconciliationLifecycleClassification = field(
        default_factory=ReconciliationLifecycleClassification
    )


def classify_reconciliation_lifecycle(
    rows: Sequence[Mapping[str, object]],
) -> ReconciliationLifecycleClassification:
    """Correlate observations without rewriting their raw audit counts."""
    keyed_rows, load_cycle_count = _key_lifecycle_rows(rows)
    classified = _classify_keyed_lifecycle_rows(keyed_rows)
    return _lifecycle_classification(keyed_rows, classified, load_cycle_count)


def _classify_keyed_lifecycle_rows(
    keyed_rows: Sequence[tuple[Mapping[str, object], ReconciliationLifecycleKey]],
) -> tuple[ReconciliationRowLifecycle, ...]:
    results: list[ReconciliationRowLifecycle | None] = [None] * len(keyed_rows)
    later_match_by_key: dict[ReconciliationLifecycleKey, int] = {}
    for offset in range(len(keyed_rows) - 1, -1, -1):
        row, key = keyed_rows[offset]
        row_index = offset + 1
        resolved_by = later_match_by_key.get(key)
        outcome, terminal_source = _lifecycle_outcome(row, key, resolved_by)
        if outcome == "match":
            later_match_by_key[key] = row_index
        results[offset] = ReconciliationRowLifecycle(
            row_index=row_index,
            outcome=outcome,
            key=key,
            resolved_by_row_index=resolved_by if outcome.startswith("resolved_") else None,
            terminal_source=terminal_source,
        )
    return tuple(result for result in results if result is not None)


def _lifecycle_outcome(
    row: Mapping[str, object],
    key: ReconciliationLifecycleKey,
    resolved_by: int | None,
) -> tuple[LifecycleOutcome, str]:
    status = str(row.get("status") or "unknown")
    if status not in {"match", "mismatch"}:
        return "unknown", ""
    if bool(row.get("repairFailed") or row.get("repairFailure")):
        return "terminal_repair_failure", "explicit"
    if (
        status == "mismatch"
        and row.get("repair") is True
        and row.get("repairQueued") is not True
    ):
        return "terminal_repair_failure", "legacy_repair_mismatch"
    if status == "mismatch" and row.get("repairQueued") is True:
        if resolved_by is not None:
            return "resolved_queued_repair", ""
        return "unresolved_queued_repair", ""
    if status == "mismatch" and key.action_sequence and resolved_by is not None:
        return "resolved_transient_mismatch", ""
    if status == "mismatch":
        return "unrepaired_mismatch", ""
    return "match", ""


def _key_lifecycle_rows(
    rows: Sequence[Mapping[str, object]],
) -> tuple[
    list[tuple[Mapping[str, object], ReconciliationLifecycleKey]],
    int,
]:
    keyed_rows: list[tuple[Mapping[str, object], ReconciliationLifecycleKey]] = []
    cycle_state: dict[tuple[str, str, str], tuple[int, int | None, str]] = {}
    observed_cycles: set[tuple[str, str, str, int]] = set()
    for row in rows:
        identity = (
            str(row.get("player") or ""),
            str(row.get("playerId") or ""),
            str(row.get("job") or "").upper(),
        )
        sequence = _integer_value(row.get("sequence"))
        build_token = str(
            row.get("profileBuildToken") or row.get("buildToken") or ""
        ).strip().upper()
        cycle_index = 0
        previous = cycle_state.get(identity)
        if previous is not None:
            previous_cycle, previous_sequence, previous_build_token = previous
            transitioned = (
                sequence is not None
                and previous_sequence is not None
                and sequence <= previous_sequence
            ) or (
                build_token != previous_build_token
                and bool(build_token or previous_build_token)
            )
            cycle_index = previous_cycle + int(transitioned)
            if transitioned:
                previous_sequence = None
            if sequence is None:
                sequence = previous_sequence
        cycle_state[identity] = (cycle_index, sequence, build_token)
        observed_cycles.add((*identity, cycle_index))

        action_sequence = str(
            row.get("actionProbeSequence") or row.get("actionSequence") or ""
        ).strip()
        repair_attempt = _integer_value(row.get("repairAttempt"))
        row_sequence = _integer_value(row.get("sequence"))
        explicit_failure = bool(row.get("repairFailed") or row.get("repairFailure"))
        repair_metadata_active = (
            row.get("repair") is True
            or row.get("repairQueued") is True
            or explicit_failure
            or (repair_attempt is not None and repair_attempt > 0)
        )
        repair_cycle_sequence = _integer_value(row.get("cycleSequence"))
        if repair_cycle_sequence is None:
            repair_cycle_sequence = _integer_value(row.get("repairCycleSequence"))
        if (
            repair_cycle_sequence is None
            and not action_sequence
            and "repairAttempt" in row
            and repair_attempt is not None
            and row_sequence is not None
            and repair_metadata_active
        ):
            repair_cycle_sequence = row_sequence - repair_attempt

        keyed_rows.append(
            (
                row,
                ReconciliationLifecycleKey(
                    player=identity[0],
                    player_id=identity[1],
                    job=identity[2],
                    load_cycle_index=cycle_index,
                    profile_build_token=build_token,
                    action_sequence=action_sequence,
                    repair_cycle_sequence=repair_cycle_sequence,
                    set_name=str(row.get("set") or ""),
                    playstyle=str(row.get("playstyle") or ""),
                    intent=str(row.get("intent") or ""),
                    expected_json=json.dumps(
                        row.get("expected"),
                        sort_keys=True,
                        separators=(",", ":"),
                        default=str,
                    ),
                ),
            )
        )
    return keyed_rows, len(observed_cycles)


def _integer_value(value: object) -> int | None:
    if isinstance(value, bool):
        return None
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value) if value.is_integer() else None
    text = str(value or "").strip()
    if re.fullmatch(r"[+-]?\d+", text):
        return int(text)
    return None


def _lifecycle_classification(
    keyed_rows: Sequence[tuple[Mapping[str, object], ReconciliationLifecycleKey]],
    rows: tuple[ReconciliationRowLifecycle, ...],
    load_cycle_count: int,
) -> ReconciliationLifecycleClassification:
    raw_statuses = Counter(
        str(row.get("status") or "unknown") for row, _key in keyed_rows
    )
    raw_mismatches = [
        row for row, _key in keyed_rows if row.get("status") == "mismatch"
    ]
    outcomes = Counter(row.outcome for row in rows)
    return ReconciliationLifecycleClassification(
        rows=rows,
        load_cycle_count=load_cycle_count,
        raw_total_count=len(keyed_rows),
        raw_match_count=raw_statuses["match"],
        raw_mismatch_count=raw_statuses["mismatch"],
        raw_unknown_count=(
            len(keyed_rows) - raw_statuses["match"] - raw_statuses["mismatch"]
        ),
        raw_repair_queued_count=sum(
            row.get("repairQueued") is True for row in raw_mismatches
        ),
        raw_repair_failed_count=sum(
            row.get("repair") is True and row.get("repairQueued") is not True
            for row in raw_mismatches
        ),
        raw_unrepaired_mismatch_count=sum(
            row.get("repairQueued") is not True and row.get("repair") is not True
            for row in raw_mismatches
        ),
        resolved_transient_mismatch_count=outcomes["resolved_transient_mismatch"],
        resolved_queued_repair_count=outcomes["resolved_queued_repair"],
        unresolved_queued_repair_count=outcomes["unresolved_queued_repair"],
        terminal_repair_failure_count=outcomes["terminal_repair_failure"],
        unrepaired_mismatch_count=outcomes["unrepaired_mismatch"],
    )


def summarize_reconciliation_log(path: Path | str) -> ReconciliationSummary:
    source = Path(path)
    rows = tuple(_iter_reconciliation_rows(source))
    lifecycle = classify_reconciliation_lifecycle(rows)
    total_count = 0
    match_count = 0
    mismatch_count = 0
    unknown_count = 0
    repair_queued_count = 0
    repair_failed_count = 0
    unrepaired_mismatch_count = 0
    set_totals: dict[str, Counter[str]] = defaultdict(Counter)
    slot_mismatches: dict[str, Counter[tuple[str, str]]] = defaultdict(Counter)
    raw_equipment_differences: dict[str, Counter[tuple[str, str]]] = defaultdict(Counter)
    unknown_reasons: Counter[str] = Counter()
    schemas: set[str] = set()
    players: set[str] = set()
    player_ids: set[str] = set()
    jobs: set[str] = set()

    for row in rows:
        status = str(row.get("status") or "unknown_observation")
        set_name = str(row.get("set") or "unknown")
        raw_difference_rows = tuple(_iter_raw_equipment_difference_rows(row))
        mismatch_rows = tuple(_iter_mismatch_rows(row.get("mismatches")))
        if status == "mismatch" and not mismatch_rows:
            mismatch_rows = raw_difference_rows
        _add_nonempty(schemas, row.get("schema"))
        _add_nonempty(players, row.get("player"))
        _add_nonempty(player_ids, row.get("playerId"))
        _add_nonempty(jobs, row.get("job"))

        total_count += 1
        set_totals[set_name]["total"] += 1
        if status == "match":
            match_count += 1
            set_totals[set_name]["match"] += 1
            for mismatch in raw_difference_rows:
                slot = str(mismatch.get("slot") or "unknown")
                expected = str(mismatch.get("expected") or "")
                observed = str(mismatch.get("observed") or "")
                raw_equipment_differences[slot][(expected, observed)] += 1
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
            for mismatch in mismatch_rows:
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
        schemas=tuple(sorted(schemas)),
        players=tuple(sorted(players)),
        player_ids=tuple(sorted(player_ids)),
        jobs=tuple(sorted(jobs)),
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
        raw_equipment_differences={
            slot: counter for slot, counter in sorted(raw_equipment_differences.items())
        },
        unknown_reasons=unknown_reasons,
        lifecycle=lifecycle,
    )


def format_reconciliation_markdown(
    summary: ReconciliationSummary,
    *,
    generated_profile: Path | str | None = None,
    installed_profile: Path | str | None = None,
) -> str:
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
        (
            "Lifecycle outcomes: "
            f"resolved queued repairs {summary.lifecycle.resolved_queued_repair_count}; "
            "resolved transient mismatches "
            f"{summary.lifecycle.resolved_transient_mismatch_count}; "
            f"unresolved queued repairs {summary.lifecycle.unresolved_queued_repair_count}; "
            f"terminal repair failures {summary.lifecycle.terminal_repair_failure_count}; "
            f"unrepaired mismatches {summary.lifecycle.unrepaired_mismatch_count}."
        ),
        "",
        "## Profile",
        f"- schemas: {_join_or_unknown(summary.schemas)}",
        f"- players: {_join_or_unknown(summary.players)}",
        f"- playerIds: {_join_or_unknown(summary.player_ids)}",
        f"- jobs: {_join_or_unknown(summary.jobs)}",
        *_profile_hash_metadata_lines(
            generated_profile=generated_profile,
            installed_profile=installed_profile,
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

    lines.extend(["", "## Alias-Matched Raw Equipment Differences"])
    if summary.raw_equipment_differences:
        for slot, counter in summary.raw_equipment_differences.items():
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


def write_reconciliation_report(
    log_path: Path | str,
    output_path: Path | str,
    *,
    allow_empty: bool = False,
    generated_profile: Path | str | None = None,
    installed_profile: Path | str | None = None,
) -> Path:
    summary = summarize_reconciliation_log(log_path)
    _validate_reconciliation_summary(summary, log_path=log_path, allow_empty=allow_empty)
    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        format_reconciliation_markdown(
            summary,
            generated_profile=generated_profile,
            installed_profile=installed_profile,
        ),
        encoding="utf-8",
    )
    return output


def write_reconciliation_report_to_root(
    log_path: Path | str,
    output_root: Path | str,
    *,
    timestamp: str | None = None,
    allow_empty: bool = False,
    generated_profile: Path | str | None = None,
    installed_profile: Path | str | None = None,
) -> Path:
    return write_reconciliation_report(
        log_path,
        derive_reconciliation_report_path(log_path, output_root, timestamp=timestamp),
        allow_empty=allow_empty,
        generated_profile=generated_profile,
        installed_profile=installed_profile,
    )


def derive_reconciliation_report_path(
    log_path: Path | str,
    output_root: Path | str,
    *,
    timestamp: str | None = None,
) -> Path:
    source = Path(log_path)
    summary = summarize_reconciliation_log(source)
    profile_slug, job = _report_identity(source, summary)
    stamp = timestamp or _mtime_timestamp(source)
    return Path(output_root) / f"{profile_slug}-{job}-{stamp}.md"


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Summarize OddLua live reconciliation snapshots.")
    parser.add_argument("log_path", type=Path, help="OddLua reconciliation JSONL log path.")
    parser.add_argument("--output", "-o", type=Path, default=None, help="Optional Markdown report path.")
    parser.add_argument(
        "--output-root",
        type=Path,
        default=None,
        help="Write an auto-named Markdown report under this directory.",
    )
    parser.add_argument(
        "--timestamp",
        default=None,
        help="Optional timestamp label for --output-root; defaults to the log file mtime in UTC.",
    )
    parser.add_argument(
        "--allow-empty",
        action="store_true",
        help="Allow writing a report when the log has no valid reconciliation snapshots.",
    )
    parser.add_argument(
        "--generated-profile",
        type=Path,
        default=None,
        help="Generated OddLua Lua profile used for this reconciliation capture.",
    )
    parser.add_argument(
        "--installed-profile",
        type=Path,
        default=None,
        help="Installed LuAshitacast profile used for this reconciliation capture.",
    )
    args = parser.parse_args(argv)
    if args.output is not None and args.output_root is not None:
        parser.error("--output and --output-root are mutually exclusive")

    try:
        if args.output_root is not None:
            written = write_reconciliation_report_to_root(
                args.log_path,
                args.output_root,
                timestamp=args.timestamp,
                allow_empty=args.allow_empty,
                generated_profile=args.generated_profile,
                installed_profile=args.installed_profile,
            )
            print(written)
        elif args.output is not None:
            written = write_reconciliation_report(
                args.log_path,
                args.output,
                allow_empty=args.allow_empty,
                generated_profile=args.generated_profile,
                installed_profile=args.installed_profile,
            )
            print(written)
        else:
            summary = summarize_reconciliation_log(args.log_path)
            _validate_reconciliation_summary(
                summary,
                log_path=args.log_path,
                allow_empty=args.allow_empty,
            )
            print(
                format_reconciliation_markdown(
                    summary,
                    generated_profile=args.generated_profile,
                    installed_profile=args.installed_profile,
                ),
                end="",
            )
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1
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


def _iter_raw_equipment_difference_rows(row: dict[str, Any]) -> Iterable[dict[str, str]]:
    expected = row.get("expected")
    observed = row.get("observed")
    if not isinstance(expected, dict) or not isinstance(observed, dict):
        return

    for slot, expected_item in expected.items():
        expected_name = str(expected_item or "")
        if not expected_name:
            continue
        observed_name = str(observed.get(slot) or "")
        if observed_name != expected_name:
            yield {
                "slot": str(slot),
                "expected": expected_name,
                "observed": observed_name,
            }


def _add_nonempty(values: set[str], value: object) -> None:
    if value is None:
        return
    text = str(value).strip()
    if text:
        values.add(text)


def _validate_reconciliation_summary(
    summary: ReconciliationSummary,
    *,
    log_path: Path | str,
    allow_empty: bool,
) -> None:
    if not allow_empty and summary.total_count == 0:
        raise ValueError(f"no reconciliation snapshots found in {log_path}")
    if _summary_has_mixed_identity(summary):
        raise ValueError(f"mixed reconciliation identities found in {log_path}")


def _summary_has_mixed_identity(summary: ReconciliationSummary) -> bool:
    return len(summary.players) > 1 or len(summary.player_ids) > 1 or len(summary.jobs) > 1


def _join_or_unknown(values: Sequence[str]) -> str:
    if not values:
        return "unknown"
    return ", ".join(values)


def _profile_hash_metadata_lines(
    *,
    generated_profile: Path | str | None,
    installed_profile: Path | str | None,
) -> list[str]:
    lines: list[str] = []
    generated_hash = _profile_hash(generated_profile)
    installed_hash = _profile_hash(installed_profile)
    if generated_profile is not None:
        lines.append(f"- generatedProfilePath: {Path(generated_profile)}")
        if generated_hash:
            lines.append(f"- generatedProfileSha256: {generated_hash}")
    if installed_profile is not None:
        lines.append(f"- installedProfilePath: {Path(installed_profile)}")
        if installed_hash:
            lines.append(f"- installedProfileSha256: {installed_hash}")
    if generated_hash and installed_hash:
        lines.append(
            "- generatedInstalledHashParity: "
            f"{str(generated_hash == installed_hash).lower()}"
        )
    return lines


def _profile_hash(path: Path | str | None) -> str | None:
    if path is None:
        return None
    source = Path(path)
    if not source.is_file():
        return None
    return _sha256(source)


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest().upper()


def _report_identity(source: Path, summary: ReconciliationSummary) -> tuple[str, str]:
    summary_identity = _summary_identity(summary)
    if summary_identity is not None:
        return summary_identity
    filename_identity = _filename_identity(source)
    if filename_identity is not None:
        return filename_identity
    safe_stem = _safe_filename_part(source.stem) or "oddlua-reconciliation"
    return safe_stem, "UNKNOWN"


def _summary_identity(summary: ReconciliationSummary) -> tuple[str, str] | None:
    if len(summary.jobs) != 1 or len(summary.players) != 1:
        return None
    player = summary.players[0]
    player_id = summary.player_ids[0] if len(summary.player_ids) == 1 else ""
    profile_slug = f"{player}_{player_id}" if player_id else player
    return _safe_filename_part(profile_slug), _safe_filename_part(summary.jobs[0]).upper()


def _filename_identity(source: Path) -> tuple[str, str] | None:
    match = re.match(r"^oddlua-reconcile-(?P<slug>.+)-(?P<job>[A-Za-z0-9]+)$", source.stem)
    if not match:
        return None
    return _safe_filename_part(match.group("slug")), _safe_filename_part(match.group("job")).upper()


def _safe_filename_part(value: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", value).strip("_.-")


def _mtime_timestamp(source: Path) -> str:
    if source.exists():
        instant = datetime.fromtimestamp(source.stat().st_mtime, tz=timezone.utc)
    else:
        instant = datetime.now(timezone.utc)
    return instant.strftime("%Y%m%d-%H%M%S")


if __name__ == "__main__":
    raise SystemExit(main())
