from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import sqlite3


PHYSICAL_DAMAGE_TYPES = ("slash", "pierce", "h2h", "impact")
ELEMENTS = ("fire", "ice", "wind", "earth", "lightning", "water", "light", "dark")


@dataclass(frozen=True)
class TargetProfile:
    name: str
    source_path: Path
    resist_id: int
    pool_id: int | None
    species_id: int | None
    family: str
    ecosystem: str
    physical_sdt: dict[str, int]
    elemental_sdt: dict[str, int]
    elemental_res_rank: dict[str, int]

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "loaded": True,
            "name": self.name,
            "sourcePath": str(self.source_path),
            "resistId": self.resist_id,
            "poolId": self.pool_id,
            "speciesId": self.species_id,
            "family": self.family,
            "ecosystem": self.ecosystem,
            "physicalSdt": dict(self.physical_sdt),
            "elementalSdt": dict(self.elemental_sdt),
            "elementalResRank": dict(self.elemental_res_rank),
        }


def empty_target_manifest(target_name: str | None = None) -> dict[str, object]:
    return {
        "loaded": False,
        "name": target_name or "",
        "sourcePath": "",
        "resistId": 0,
        "poolId": None,
        "speciesId": None,
        "family": "",
        "ecosystem": "",
        "physicalSdt": {name: 0 for name in PHYSICAL_DAMAGE_TYPES},
        "elementalSdt": {name: 0 for name in ELEMENTS},
        "elementalResRank": {name: 0 for name in ELEMENTS},
    }


def load_target_profile_from_db(
    db_path: Path | str,
    *,
    target_name: str,
) -> TargetProfile | None:
    path = Path(db_path)
    if not path.exists():
        raise FileNotFoundError(f"OddLua stats database not found: {path}")

    db = sqlite3.connect(path)
    try:
        db.row_factory = sqlite3.Row
        if not _has_table(db, "mob_resistances"):
            return None

        normalized = _normalize_name(target_name)
        row = _select_target_row(db, normalized)
        if row is None:
            return None

        return TargetProfile(
            name=str(row["target_name"] or row["resistance_name"]),
            source_path=path,
            resist_id=int(row["resist_id"]),
            pool_id=_optional_int(row["poolid"]),
            species_id=_optional_int(row["speciesid"]),
            family=str(row["family"] or ""),
            ecosystem=str(row["ecosystem"] or ""),
            physical_sdt={name: int(row[f"{name}_sdt"] or 0) for name in PHYSICAL_DAMAGE_TYPES},
            elemental_sdt={name: int(row[f"{name}_sdt"] or 0) for name in ELEMENTS},
            elemental_res_rank={name: int(row[f"{name}_res_rank"] or 0) for name in ELEMENTS},
        )
    finally:
        db.close()


def _select_target_row(db: sqlite3.Connection, normalized: str) -> sqlite3.Row | None:
    if _has_table(db, "mob_pools"):
        joins = ""
        group_predicate = ""
        target_name_expr = "coalesce(p.name, r.name)"
        if _has_table(db, "mob_groups"):
            joins += " left join mob_groups g on g.poolid = p.poolid"
            group_predicate = " or lower(replace(g.name, '_', ' ')) = ?"
            target_name_expr = "coalesce(g.name, p.name, r.name)"
        family_join = ""
        family_select = "'' as family, '' as ecosystem"
        if _has_table(db, "mob_family_system"):
            family_join = " left join mob_family_system f on f.speciesID = p.speciesid"
            family_select = "f.family as family, f.ecosystem as ecosystem"

        params: list[str] = [normalized, normalized, normalized]
        if group_predicate:
            params.append(normalized)
        return db.execute(
            f"""
            select
                {target_name_expr} as target_name,
                r.name as resistance_name,
                p.poolid,
                p.speciesid,
                r.*,
                {family_select}
            from mob_pools p
            join mob_resistances r on r.resist_id = p.resist_id
            {joins}
            {family_join}
            where lower(replace(p.name, '_', ' ')) = ?
               or lower(replace(p.packet_name, '_', ' ')) = ?
               or lower(replace(r.name, '_', ' ')) = ?
               {group_predicate}
            order by p.poolid
            limit 1
            """,
            tuple(params),
        ).fetchone()

    return db.execute(
        """
        select
            r.name as target_name,
            r.name as resistance_name,
            null as poolid,
            null as speciesid,
            r.*,
            '' as family,
            '' as ecosystem
        from mob_resistances r
        where lower(replace(r.name, '_', ' ')) = ?
        limit 1
        """,
        (normalized,),
    ).fetchone()


def _has_table(db: sqlite3.Connection, table: str) -> bool:
    row = db.execute(
        "select 1 from sqlite_master where type = 'table' and name = ?",
        (table,),
    ).fetchone()
    return row is not None


def _normalize_name(name: str) -> str:
    return " ".join(name.strip().lower().replace("_", " ").split())


def _optional_int(value: object) -> int | None:
    if value is None:
        return None
    return int(value)
