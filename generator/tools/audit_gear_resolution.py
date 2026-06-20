from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from datetime import datetime
import json
from pathlib import Path
import sys
from typing import Any, Iterable


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.builder import (  # noqa: E402
    SLOT_ORDER,
    _action_time_blocked_slots_for_style,
    _dual_wield_gated_sub_families,
    _is_eligible_combat_item,
    _non_damage_sub_families_for_main,
    _occupied_slots_for_selected,
    _score_item,
    _selection_reason,
    _selection_style_name_for_job,
    _selected_rank,
    _script_for_weaponskill,
    _slot_candidates,
    _slot_candidates_with_weights,
    _slot_eligible,
    _sub_families_for_main,
    _weapon_family_policy_for_style,
    _weapon_slot_policy_for_style,
    weights_for_weaponskill,
)
from oddlua.classifier import ClassifiedItem, classify_item  # noqa: E402
from oddlua.gearexport import GearItem, load_character_snapshot, load_gearexport  # noqa: E402
from oddlua.itemstats import ItemStatsIndex, load_item_stats_from_db  # noqa: E402


SPECIAL_EFFECT_MODS = {
    "FIRE_STAFF_BONUS",
    "ICE_STAFF_BONUS",
    "WIND_STAFF_BONUS",
    "EARTH_STAFF_BONUS",
    "THUNDER_STAFF_BONUS",
    "WATER_STAFF_BONUS",
    "LIGHT_STAFF_BONUS",
    "DARK_STAFF_BONUS",
    "IRIDESCENCE",
    "FIRE_AFFINITY_PERP",
    "ICE_AFFINITY_PERP",
    "WIND_AFFINITY_PERP",
    "EARTH_AFFINITY_PERP",
    "THUNDER_AFFINITY_PERP",
    "WATER_AFFINITY_PERP",
    "LIGHT_AFFINITY_PERP",
    "DARK_AFFINITY_PERP",
    "ENSPELL_DMG_PCT",
}
SPECIAL_EFFECT_NAMES = {
    "Chatoyant",
    "Chatoyant Staff",
    "Somnia Melodiam",
}
SPARSE_UTILITY_MISSING_SLOT_STYLES = {
    "craft",
    "crafting",
    "incity",
    "movement",
    "movement_city",
    "movement_dusktodawn",
    "movement_night",
}
PAIRED_SLOT_PREDECESSORS = {
    "Sub": ("Main",),
    "Ear2": ("Ear1",),
    "Ring2": ("Ring1",),
}


ClassifiedGear = tuple[tuple[GearItem, ClassifiedItem], ...]


def audit_manifest_slot(
    *,
    style_name: str,
    slot: str,
    selected_item_name: str | None,
    classified: ClassifiedGear,
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex,
    blocked_selected_item_names: tuple[str, ...] = tuple(),
) -> dict[str, object]:
    selection_style = _effective_selection_style_name(
        style_name=style_name,
        job=job,
        classified=classified,
        character_level=character_level,
    )
    candidates = _ranked_slot_candidates(
        style_name=style_name,
        selection_style=selection_style,
        slot=slot,
        classified=classified,
        job=job,
        character_level=character_level,
        item_stats=item_stats,
        blocked_selected_item_names=blocked_selected_item_names,
    )
    best = candidates[0] if candidates else None
    selected = None
    if selected_item_name is not None:
        selected = _selected_candidate(
            style_name=style_name,
            selection_style=selection_style,
            slot=slot,
            selected_item_name=selected_item_name,
            classified=classified,
            job=job,
            character_level=character_level,
            item_stats=item_stats,
        )
    status = (
        _missing_slot_status(best)
        if selected_item_name is None
        else _slot_status(selected, best)
    )
    finding_tags = _finding_tags(selected, best)

    return {
        "style": style_name,
        "selectionStyle": selection_style,
        "slot": slot,
        "status": status,
        "findingTags": finding_tags,
        "selected": _candidate_json(selected),
        "bestCandidate": _candidate_json(best),
        "topCandidates": [_candidate_json(candidate) for candidate in candidates[:10]],
    }


def _effective_selection_style_name(
    *,
    style_name: str,
    job: str,
    classified: ClassifiedGear,
    character_level: int,
) -> str:
    if style_name == "Treasure" and not _has_eligible_treasure_items(classified, job, character_level):
        return _selection_style_name_for_job("Melt", job)
    return _selection_style_name_for_job(style_name, job)


def _has_eligible_treasure_items(classified: ClassifiedGear, job: str, character_level: int) -> bool:
    return any(
        _is_eligible_combat_item(item, classification, job, character_level)
        and "treasure" in classification.roles
        for item, classification in classified
    )


def audit_all_manifests(
    *,
    gearexport_root: Path,
    manifest_root: Path,
    stats_db_path: Path,
    output_root: Path,
    player_filter: str | None = None,
    job_filter: str | None = None,
    compact_json: bool = False,
) -> dict[str, object]:
    item_stats = load_item_stats_from_db(stats_db_path)
    rows: list[dict[str, object]] = []
    profiles: list[dict[str, object]] = []
    classified_cache: dict[str, ClassifiedGear] = {}

    for manifest_path in sorted(manifest_root.glob("*/*/manifest.json")):
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        player = str(manifest["player"])
        player_id = str(manifest["playerId"])
        job = str(manifest["job"])
        if player_filter and player.lower() != player_filter.lower():
            continue
        if job_filter and job.upper() != job_filter.upper():
            continue

        character_key = f"{player}_{player_id}"
        gear_path = gearexport_root / f"{character_key}_gear.lua"
        character_path = gearexport_root / character_key / f"{character_key}_character.json"
        if character_key not in classified_cache:
            export = load_gearexport(gear_path)
            classified_cache[character_key] = tuple(
                (item, classify_item(item, item_stats=item_stats))
                for item in export.items
            )
        character = load_character_snapshot(character_path)
        character_level = int(manifest.get("level") or character.job_level(job))

        selected_items = manifest.get("selectedItems", {})
        if not isinstance(selected_items, dict):
            continue

        slot_count = 0
        finding_count = 0
        for style_name, slots in selected_items.items():
            if not isinstance(slots, dict):
                continue
            selected_slot_names: set[str] = set()
            for slot, selected in _ordered_slot_items(slots):
                if not isinstance(selected, dict) or "item" not in selected:
                    continue
                slot_count += 1
                row = audit_manifest_slot(
                    style_name=str(style_name),
                    slot=str(slot),
                    selected_item_name=str(selected["item"]),
                    classified=classified_cache[character_key],
                    job=job,
                    character_level=character_level,
                    item_stats=item_stats,
                    blocked_selected_item_names=_blocked_selected_item_names(str(slot), slots),
                )
                row.update(
                    {
                        "player": player,
                        "playerId": player_id,
                        "job": job,
                        "level": character_level,
                        "manifestPath": str(manifest_path),
                    }
                )
                if row["status"] != "selected_is_best" or row["findingTags"]:
                    finding_count += 1
                rows.append(row)
                selected_slot_names.add(str(slot))

            occupied_slot_names = _occupied_slots_for_manifest_style(
                style_name=str(style_name),
                slots=slots,
                classified=classified_cache[character_key],
                job=job,
                character_level=character_level,
                item_stats=item_stats,
            )
            for slot in SLOT_ORDER:
                slot_name = str(slot)
                if slot_name in selected_slot_names or slot_name in occupied_slot_names:
                    continue
                if not _should_audit_slot_for_style(style_name=str(style_name), slot=slot_name):
                    continue
                missing_row = audit_manifest_slot(
                    style_name=str(style_name),
                    slot=slot_name,
                    selected_item_name=None,
                    classified=classified_cache[character_key],
                    job=job,
                    character_level=character_level,
                    item_stats=item_stats,
                    blocked_selected_item_names=_blocked_selected_item_names(slot_name, slots),
                )
                if missing_row["status"] != "missing_slot_has_candidate":
                    continue
                slot_count += 1
                missing_row.update(
                    {
                        "player": player,
                        "playerId": player_id,
                        "job": job,
                        "level": character_level,
                        "manifestPath": str(manifest_path),
                    }
                )
                finding_count += 1
                rows.append(missing_row)

        profiles.append(
            {
                "player": player,
                "playerId": player_id,
                "job": job,
                "level": character_level,
                "manifestPath": str(manifest_path),
                "slotRows": slot_count,
                "findings": finding_count,
            }
        )

    summary = {
        "profiles": len(profiles),
        "slotRows": len(rows),
        "statuses": dict(Counter(str(row["status"]) for row in rows)),
        "findingTags": dict(Counter(tag for row in rows for tag in row.get("findingTags", []))),
    }
    report = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "gearexportRoot": str(gearexport_root),
        "manifestRoot": str(manifest_root),
        "statsDbPath": str(stats_db_path),
        "summary": summary,
        "profiles": profiles,
        "rows": rows,
    }

    run_dir = output_root / datetime.now().strftime("%Y%m%d-%H%M%S")
    run_dir.mkdir(parents=True, exist_ok=True)
    json_payload = gear_audit_json_payload(report, compact=compact_json)
    (run_dir / "audit.json").write_text(json.dumps(json_payload, indent=2, sort_keys=True), encoding="utf-8")
    (run_dir / "audit.md").write_text(_markdown_report(report), encoding="utf-8")
    report["outputDir"] = str(run_dir)
    return report


def gear_audit_json_payload(report: dict[str, object], *, compact: bool = False) -> dict[str, object]:
    if not compact:
        return dict(report)
    payload = dict(report)
    rows = payload.get("rows")
    payload["rows"] = []
    payload["rowsOmitted"] = len(rows) if isinstance(rows, list) else 0
    return payload


def gear_audit_exit_code(
    report: dict[str, object],
    *,
    fail_on_status_findings: bool = False,
    max_finding_tags: dict[str, int] | None = None,
) -> int:
    return 1 if gear_audit_failures(
        report,
        fail_on_status_findings=fail_on_status_findings,
        max_finding_tags=max_finding_tags,
    ) else 0


def gear_audit_failures(
    report: dict[str, object],
    *,
    fail_on_status_findings: bool = False,
    max_finding_tags: dict[str, int] | None = None,
) -> tuple[str, ...]:
    if not fail_on_status_findings:
        status_failures: list[str] = []
    else:
        summary = report.get("summary")
        if not isinstance(summary, dict):
            return ("missing summary",)
        statuses = summary.get("statuses")
        if not isinstance(statuses, dict):
            return ("missing status summary",)
        status_failures = []
        for status, count in statuses.items():
            if status != "selected_is_best" and int(count) > 0:
                status_failures.append(f"{status} count {count} exceeds max 0")

    if max_finding_tags is None:
        return tuple(status_failures)

    summary = report.get("summary")
    if not isinstance(summary, dict):
        return ("missing summary",)
    finding_tags = summary.get("findingTags")
    if not isinstance(finding_tags, dict):
        return tuple([*status_failures, "missing finding tag summary"])
    failures = list(status_failures)
    for tag, count in finding_tags.items():
        max_count = int(max_finding_tags.get(str(tag), 0))
        if int(count) > max_count:
            failures.append(f"{tag} tag count {count} exceeds max {max_count}")
    return tuple(failures)


def _ranked_slot_candidates(
    *,
    style_name: str,
    selection_style: str,
    slot: str,
    classified: ClassifiedGear,
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex,
    blocked_selected_item_names: tuple[str, ...] = tuple(),
):
    weaponskill_style = _weaponskill_style(style_name, item_stats)
    if weaponskill_style is not None:
        candidates = _weaponskill_slot_candidates(
            weaponskill_style=weaponskill_style,
            slot=slot,
            classified=classified,
            job=job,
            character_level=character_level,
            item_stats=item_stats,
        )
        candidates = _apply_blocked_item_names(candidates, blocked_selected_item_names)
        return sorted(candidates, key=_selected_rank, reverse=True)

    weapon_family_by_slot = _weapon_family_policy_for_style(job, style_name)
    weapon_policy_by_slot = _weapon_slot_policy_for_style(job, style_name)
    allowed_families = weapon_family_by_slot.get(slot)
    if slot == "Sub":
        main_candidates = _slot_candidates(
            selection_style,
            "Main",
            classified,
            job,
            character_level,
            tuple(),
            allowed_weapon_families=weapon_family_by_slot.get("Main"),
            item_stats=item_stats,
            slot_policy=weapon_policy_by_slot.get("Main"),
        )
        main_candidates = _apply_fixed_weapon_policy(main_candidates, weapon_policy_by_slot.get("Main"))
        main = max(main_candidates, key=_selected_rank, default=None)
        allowed_families = _sub_families_for_main(allowed_families, main)
        allowed_families = _non_damage_sub_families_for_main(selection_style, job, main, allowed_families)
        allowed_families = _dual_wield_gated_sub_families(allowed_families, job, selection_style)

    candidates = _slot_candidates(
        selection_style,
        slot,
        classified,
        job,
        character_level,
        tuple(),
        allowed_weapon_families=allowed_families,
        item_stats=item_stats,
        slot_policy=weapon_policy_by_slot.get(slot),
    )
    candidates = _apply_blocked_item_names(candidates, blocked_selected_item_names)
    candidates = _apply_fixed_weapon_policy(candidates, weapon_policy_by_slot.get(slot))
    return sorted(candidates, key=_selected_rank, reverse=True)


def _ordered_slot_items(slots: dict[str, object]) -> list[tuple[str, object]]:
    slot_rank = {slot: index for index, slot in enumerate(SLOT_ORDER)}
    return sorted(slots.items(), key=lambda item: (slot_rank.get(str(item[0]), len(slot_rank)), str(item[0])))


def _blocked_selected_item_names(slot: str, slots: dict[str, object]) -> tuple[str, ...]:
    blocked: list[str] = []
    for predecessor in PAIRED_SLOT_PREDECESSORS.get(slot, tuple()):
        selected = slots.get(predecessor)
        if isinstance(selected, dict) and selected.get("item"):
            blocked.append(str(selected["item"]))
    return tuple(blocked)


def _occupied_slots_for_manifest_style(
    *,
    style_name: str,
    slots: dict[str, object],
    classified: ClassifiedGear,
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex,
) -> set[str]:
    selection_style = _effective_selection_style_name(
        style_name=style_name,
        job=job,
        classified=classified,
        character_level=character_level,
    )
    occupied: set[str] = set()
    for slot, selected in _ordered_slot_items(slots):
        if not isinstance(selected, dict) or "item" not in selected:
            continue
        candidate = _selected_candidate(
            style_name=style_name,
            selection_style=selection_style,
            slot=str(slot),
            selected_item_name=str(selected["item"]),
            classified=classified,
            job=job,
            character_level=character_level,
            item_stats=item_stats,
        )
        if candidate is None:
            occupied.add(str(slot))
            continue
        occupied.update(_occupied_slots_for_selected(candidate))
    return occupied


def _apply_blocked_item_names(candidates: list[Any], blocked_selected_item_names: tuple[str, ...]) -> list[Any]:
    if not blocked_selected_item_names:
        return candidates
    remaining_blocks = Counter(blocked_selected_item_names)
    filtered = []
    for candidate in candidates:
        name = candidate.item.name
        if remaining_blocks[name] > 0:
            remaining_blocks[name] -= 1
            continue
        filtered.append(candidate)
    return filtered


def _apply_fixed_weapon_policy(candidates: list[Any], slot_policy: Any) -> list[Any]:
    fixed_item_ids = set(slot_policy.fixed_item_ids) if slot_policy else set()
    if not fixed_item_ids:
        return candidates
    fixed_candidates = [candidate for candidate in candidates if candidate.item.id in fixed_item_ids]
    return fixed_candidates or candidates


def _selected_candidate(
    *,
    style_name: str,
    selection_style: str,
    slot: str,
    selected_item_name: str,
    classified: ClassifiedGear,
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex,
):
    weaponskill_style = _weaponskill_style(style_name, item_stats)
    if weaponskill_style is not None:
        for candidate in _weaponskill_slot_candidates(
            weaponskill_style=weaponskill_style,
            slot=slot,
            classified=classified,
            job=job,
            character_level=character_level,
            item_stats=item_stats,
        ):
            if candidate.item.name == selected_item_name:
                return candidate
        return None

    for item, classification in classified:
        if item.name != selected_item_name:
            continue
        if not _slot_eligible(item, classification, slot):
            continue
        if not _is_eligible_combat_item(item, classification, job, character_level):
            continue
        weapon_family_by_slot = _weapon_family_policy_for_style(job, style_name)
        weapon_policy_by_slot = _weapon_slot_policy_for_style(job, style_name)
        allowed_families = weapon_family_by_slot.get(slot)
        slot_policy = weapon_policy_by_slot.get(slot)
        score = _score_item(
            selection_style,
            slot,
            item,
            classification,
            tuple(),
            item_stats=item_stats,
            slot_policy=slot_policy,
            allowed_weapon_families=allowed_families,
            job=job,
            character_level=character_level,
        )
        return _AuditCandidate(
            slot=slot,
            item=item,
            classification=classification,
            reason=_selection_reason(
                selection_style,
                slot,
                item,
                classification,
                tuple(),
                item_stats=item_stats,
                slot_policy=slot_policy,
                allowed_weapon_families=allowed_families,
                job=job,
                character_level=character_level,
            ),
            score=score,
        )
    return None


def _weaponskill_style(style_name: str, item_stats: ItemStatsIndex):
    for ws in item_stats.weapon_skills_by_key.values():
        if style_name == ws.set_name:
            return ws, False
        if style_name == ws.accuracy_set_name:
            return ws, True
    return None


def _weaponskill_slot_candidates(
    *,
    weaponskill_style,
    slot: str,
    classified: ClassifiedGear,
    job: str,
    character_level: int,
    item_stats: ItemStatsIndex,
):
    ws, accuracy = weaponskill_style
    script = _script_for_weaponskill(ws, item_stats)
    weights = weights_for_weaponskill(ws, script, accuracy=accuracy)
    return _slot_candidates_with_weights(
        "WeaponSkill",
        slot,
        weights,
        classified,
        job,
        character_level,
        tuple(),
        item_stats=item_stats,
        reason_prefix=f"Calculated for {'WSAcc' if accuracy else 'WS'} {ws.display_name}",
    )


class _AuditCandidate:
    def __init__(self, *, slot: str, item: GearItem, classification: ClassifiedItem, reason: str, score: int) -> None:
        self.slot = slot
        self.item = item
        self.classification = classification
        self.reason = reason
        self.score = score


def _slot_status(selected: Any, best: Any) -> str:
    if selected is None and best is None:
        return "empty_no_candidates"
    if selected is None:
        return "selected_not_in_ranked_candidates"
    if best is None:
        return "selected_no_candidates"
    if selected.item.name != best.item.name:
        return "candidate_beats_selected"
    return "selected_is_best"


def _missing_slot_status(best: Any) -> str:
    return "missing_slot_has_candidate" if best is not None else "empty_no_candidates"


def _should_audit_slot_for_style(*, style_name: str, slot: str) -> bool:
    if style_name.lower() in SPARSE_UTILITY_MISSING_SLOT_STYLES:
        return False
    return slot not in _action_time_blocked_slots_for_style(style_name)


def _finding_tags(selected: Any, best: Any) -> list[str]:
    tags: list[str] = []
    candidates = [candidate for candidate in (selected, best) if candidate is not None]
    for candidate in candidates:
        mod_names = {name for name, value in candidate.classification.server_mods if value}
        if mod_names & SPECIAL_EFFECT_MODS:
            tags.append("manual_review_special_effect")
        if candidate.item.name in SPECIAL_EFFECT_NAMES:
            tags.append("manual_review_named_effect")
    return sorted(set(tags))


def _candidate_json(candidate: Any) -> dict[str, object]:
    if candidate is None:
        return {}
    return {
        "id": candidate.item.id,
        "item": candidate.item.name,
        "score": candidate.score,
        "reason": candidate.reason,
        "level": candidate.item.level,
        "serverLevel": candidate.classification.server_level,
        "storage": candidate.item.storage,
        "augments": list(candidate.item.augments),
        "serverMods": dict(candidate.classification.server_mods),
    }


def _markdown_report(report: dict[str, object]) -> str:
    summary = report["summary"]
    assert isinstance(summary, dict)
    rows = report["rows"]
    assert isinstance(rows, list)

    lines = [
        "# OddLua Gear Resolution Audit",
        "",
        f"- Generated: {report['generatedAt']}",
        f"- Profiles: {summary['profiles']}",
        f"- Slot rows: {summary['slotRows']}",
        f"- Statuses: `{json.dumps(summary['statuses'], sort_keys=True)}`",
        f"- Finding tags: `{json.dumps(summary['findingTags'], sort_keys=True)}`",
        "",
        "## Findings",
        "",
    ]
    findings_by_status: dict[str, list[dict[str, object]]] = defaultdict(list)
    for row in rows:
        if row["status"] != "selected_is_best" or row.get("findingTags"):
            findings_by_status[str(row["status"])].append(row)

    if not findings_by_status:
        lines.append("No findings.")
        return "\n".join(lines) + "\n"

    for status, grouped_rows in sorted(findings_by_status.items()):
        lines.extend([f"### {status}", ""])
        for row in grouped_rows[:250]:
            selected = row.get("selected") or {}
            best = row.get("bestCandidate") or {}
            assert isinstance(selected, dict)
            assert isinstance(best, dict)
            lines.append(
                "- {player} {job} {style}.{slot}: selected `{selected}`; best `{best}`; tags `{tags}`".format(
                    player=row["player"],
                    job=row["job"],
                    style=row["style"],
                    slot=row["slot"],
                    selected=selected.get("item", ""),
                    best=best.get("item", ""),
                    tags=", ".join(row.get("findingTags", [])),
                )
            )
        if len(grouped_rows) > 250:
            lines.append(f"- ... {len(grouped_rows) - 250} more rows omitted from markdown; see audit.json.")
        lines.append("")
    return "\n".join(lines)


def parse_args(argv: Iterable[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit generated OddLua set slots against current owned-gear scorer output.")
    parser.add_argument("--gearexport-root", default=r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport", type=Path)
    parser.add_argument("--manifest-root", default=ODDLUA_ROOT / "dist" / "packs", type=Path)
    parser.add_argument("--stats-db-path", default=ODDLUA_ROOT / "data" / "oddlua_stats.sqlite", type=Path)
    parser.add_argument("--output-root", default=ODDLUA_ROOT / "reports" / "gear-audit", type=Path)
    parser.add_argument("--player", default=None)
    parser.add_argument("--job", default=None)
    parser.add_argument(
        "--compact-json",
        action="store_true",
        help="Write summary/profiles JSON without per-slot rows.",
    )
    parser.add_argument("--fail-on-status-findings", action="store_true")
    parser.add_argument(
        "--max-finding-tag",
        action="append",
        default=[],
        metavar="TAG=COUNT",
        help="Allowed finding-tag count. Tags not listed default to 0 when any tag budget is supplied.",
    )
    return parser.parse_args(argv)


def main(argv: Iterable[str] | None = None) -> int:
    args = parse_args(argv)
    report = audit_all_manifests(
        gearexport_root=args.gearexport_root,
        manifest_root=args.manifest_root,
        stats_db_path=args.stats_db_path,
        output_root=args.output_root,
        player_filter=args.player,
        job_filter=args.job,
        compact_json=args.compact_json,
    )
    print(f"Wrote audit: {report['outputDir']}")
    print(json.dumps(report["summary"], indent=2, sort_keys=True))
    max_finding_tags = parse_finding_tag_budgets(args.max_finding_tag) if args.max_finding_tag else None
    failures = gear_audit_failures(
        report,
        fail_on_status_findings=args.fail_on_status_findings,
        max_finding_tags=max_finding_tags,
    )
    for failure in failures:
        print(f"Gate failed: {failure}", file=sys.stderr)
    return 1 if failures else 0


def parse_finding_tag_budgets(entries: Iterable[str]) -> dict[str, int]:
    budgets: dict[str, int] = {}
    for entry in entries:
        if "=" not in entry:
            raise ValueError(f"Finding tag budget must use TAG=COUNT: {entry}")
        tag, raw_count = entry.split("=", 1)
        if not tag:
            raise ValueError(f"Finding tag budget must use TAG=COUNT: {entry}")
        try:
            count = int(raw_count)
        except ValueError as exc:
            raise ValueError(f"Finding tag budget count must be a non-negative integer: {entry}") from exc
        if count < 0:
            raise ValueError(f"Finding tag budget count must be a non-negative integer: {entry}")
        budgets[tag] = count
    return budgets


if __name__ == "__main__":
    raise SystemExit(main())
