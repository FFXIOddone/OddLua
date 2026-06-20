from __future__ import annotations

from dataclasses import dataclass
from collections.abc import Mapping
from pathlib import Path
import re
import sqlite3

from .gameconstants import JOB_ID_BY_ABBR, WEAPON_FAMILY_BY_SKILL


ELEMENT_NAME_BY_ID = {
    0: "None",
    1: "Fire",
    2: "Ice",
    4: "Earth",
    6: "Water",
    16: "Wind",
    32: "Ice",
    64: "Lightning",
    128: "Light",
    255: "Dark",
}


@dataclass(frozen=True)
class CatseyeWeaponSkill:
    weapon_skill_id: int
    name: str
    key: str
    display_name: str
    set_name: str
    accuracy_set_name: str
    jobs_hex: str
    weapon_type: int
    weapon_family: str
    skill_level: int
    element_id: int
    element_name: str
    main_only: bool
    unlock_id: int


@dataclass(frozen=True)
class WeaponSkillEligibilityContext:
    job: str
    character_level: int
    skill_caps_by_level_rank: Mapping[tuple[int, int], int]
    skill_ranks_by_skill_job: Mapping[tuple[int, str], int]
    learned_unlock_ids: frozenset[int] = frozenset()


def normalize_weaponskill_key(name: str) -> str:
    text = str(name).strip().lower().replace(":", "_").replace("-", "_").replace(" ", "_")
    text = re.sub(r"[^a-z0-9_]+", "", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text


def display_name_for_weaponskill(name: str) -> str:
    key = normalize_weaponskill_key(name)
    parts = key.split("_")
    if len(parts) >= 2 and parts[0] in {"tachi", "blade"}:
        return f"{parts[0].title()}: {' '.join(part.title() for part in parts[1:])}"
    return " ".join(part.title() for part in parts)


def set_name_for_weaponskill(name: str, *, accuracy: bool = False) -> str:
    prefix = "WSAcc" if accuracy else "WS"
    key = normalize_weaponskill_key(name)
    return f"{prefix}_{'_'.join(part.title() for part in key.split('_'))}"


def job_level_from_jobs_hex(value: object, job: str) -> int:
    job_id = JOB_ID_BY_ABBR.get(str(job).upper())
    if job_id is None:
        return 0
    try:
        number = int(str(value).strip(), 0)
    except (ValueError, TypeError):
        return 0
    data = number.to_bytes(22, "big", signed=False)
    index = job_id - 1
    if index < 0 or index >= len(data):
        return 0
    return int(data[index])


def load_weaponskill_catalog(db_path: Path | str) -> dict[str, CatseyeWeaponSkill]:
    path = Path(db_path)
    if not path.exists():
        raise FileNotFoundError(f"OddLua stats database not found: {path}")

    db = sqlite3.connect(path)
    try:
        return load_weaponskill_catalog_from_connection(db)
    finally:
        db.close()


def load_weaponskill_catalog_from_connection(db: sqlite3.Connection) -> dict[str, CatseyeWeaponSkill]:
    catalog: dict[str, CatseyeWeaponSkill] = {}
    rows = db.execute(
        """
        select weapon_skill_id, name, jobs_hex, weapon_type, skill_level, element,
               main_only, unlock_id
        from weapon_skills
        order by weapon_skill_id
        """
    ).fetchall()

    for row in rows:
        raw_name = str(row[1])
        key = normalize_weaponskill_key(raw_name)
        weapon_type = int(row[3])
        element_id = int(row[5])
        catalog[key] = CatseyeWeaponSkill(
            weapon_skill_id=int(row[0]),
            name=raw_name,
            key=key,
            display_name=display_name_for_weaponskill(raw_name),
            set_name=set_name_for_weaponskill(raw_name),
            accuracy_set_name=set_name_for_weaponskill(raw_name, accuracy=True),
            jobs_hex=str(row[2]),
            weapon_type=weapon_type,
            weapon_family=WEAPON_FAMILY_BY_SKILL.get(weapon_type, "unknown"),
            skill_level=int(row[4]),
            element_id=element_id,
            element_name=ELEMENT_NAME_BY_ID.get(element_id, "None"),
            main_only=bool(int(row[6])),
            unlock_id=int(row[7]),
        )
    return catalog


def eligible_weaponskills_for_job(
    catalog: dict[str, CatseyeWeaponSkill],
    context: WeaponSkillEligibilityContext | None = None,
    *,
    job: str | None = None,
    character_level: int | None = None,
) -> tuple[CatseyeWeaponSkill, ...]:
    if context is None:
        if job is None or character_level is None:
            raise TypeError("eligible_weaponskills_for_job requires an eligibility context.")
        context = WeaponSkillEligibilityContext(
            job=job,
            character_level=character_level,
            skill_caps_by_level_rank={},
            skill_ranks_by_skill_job={},
        )

    normalized_job = context.job.upper()
    eligible: list[CatseyeWeaponSkill] = []
    for ws in catalog.values():
        job_access = job_level_from_jobs_hex(ws.jobs_hex, normalized_job)
        if job_access <= 0:
            continue
        if context.character_level <= 0:
            continue

        if ws.unlock_id != 0 and ws.unlock_id not in context.learned_unlock_ids:
            continue

        if ws.skill_level <= 0:
            if ws.unlock_id != 0 and context.character_level >= 75:
                eligible.append(ws)
            continue

        rank = context.skill_ranks_by_skill_job.get((ws.weapon_type, normalized_job))
        if rank is None:
            continue
        cap = _skill_cap_for_context(context, rank)
        if cap < ws.skill_level:
            continue

        eligible.append(ws)
    return tuple(sorted(eligible, key=lambda ws: (ws.weapon_type, ws.skill_level, ws.weapon_skill_id)))


def _skill_cap_for_context(context: WeaponSkillEligibilityContext, rank: int) -> int:
    direct = context.skill_caps_by_level_rank.get((context.character_level, rank))
    if direct is not None:
        return direct

    eligible_levels = [
        level
        for level, candidate_rank in context.skill_caps_by_level_rank
        if candidate_rank == rank and level <= context.character_level
    ]
    if not eligible_levels:
        return 0
    return context.skill_caps_by_level_rank[(max(eligible_levels), rank)]
