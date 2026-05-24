from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re
import sqlite3
from typing import Iterable

from .itemstats import MOD_NAMES


SQL_FILES = (
    "item_basic.sql",
    "item_equipment.sql",
    "item_weapon.sql",
    "item_mods.sql",
    "augments.sql",
    "merits.sql",
    "traits.sql",
    "weapon_skills.sql",
    "item_usable.sql",
)

MOB_SQL_FILES = (
    "mob_resistances.sql",
    "mob_pools.sql",
    "mob_species_system.sql",
    "mob_groups.sql",
)

MOD_ENUM_RE = re.compile(r"^\s*([A-Z][A-Z0-9_]*)\s*=\s*(-?\d+)\s*,?", re.MULTILINE)
ITEM_ID_RE = re.compile(r"--\s*ID:\s*(\d+)")
ITEM_NAME_RE = re.compile(r"--\s*Item:\s*([^\r\n]+)")
FOOD_TYPE_RE = re.compile(r"xi\.foodType\.([A-Z0-9_]+)")
DURATION_RE = re.compile(r"duration\s*=\s*(\d+)")
ON_EFFECT_GAIN_RE = re.compile(
    r"itemObject\.onEffectGain\s*=\s*function\s*\([^)]*\)(.*?)(?:itemObject\.onEffectLose\s*=|return\s+itemObject|$)",
    re.DOTALL,
)
ADD_MOD_RE = re.compile(r"effect:addMod\s*\(\s*xi\.mod\.([A-Z0-9_]+)\s*,\s*(-?\d+)\s*\)")
ADD_PET_MOD_RE = re.compile(r"target:addPetMod\s*\(\s*xi\.mod\.([A-Z0-9_]+)\s*,\s*(-?\d+)\s*\)")


@dataclass(frozen=True)
class StatsDbBuildResult:
    path: Path
    item_count: int
    item_mod_count: int
    food_count: int
    food_mod_count: int
    mob_resistance_count: int = 0
    mob_pool_count: int = 0
    mob_group_count: int = 0


@dataclass(frozen=True)
class FoodMod:
    target_type: str
    mod_id: int
    mod_name: str
    value: int


@dataclass(frozen=True)
class FoodEffect:
    item_id: int
    name: str
    food_type: str
    duration_seconds: int
    script_path: Path
    mods: tuple[FoodMod, ...]


def build_stats_db(
    *,
    sql_root: Path | str,
    scripts_items_root: Path | str,
    output_path: Path | str,
) -> StatsDbBuildResult:
    sql_path = Path(sql_root)
    scripts_path = Path(scripts_items_root)
    destination = Path(output_path)

    if not sql_path.exists():
        raise FileNotFoundError(f"Server SQL root not found: {sql_path}")
    if not scripts_path.exists():
        raise FileNotFoundError(f"Server item scripts root not found: {scripts_path}")
    for filename in SQL_FILES:
        path = sql_path / filename
        if not path.exists():
            raise FileNotFoundError(f"Required server SQL source not found: {path}")

    destination.parent.mkdir(parents=True, exist_ok=True)
    temp_path = destination.with_suffix(".tmp.sqlite")
    if temp_path.exists():
        temp_path.unlink()

    mod_names = _load_mod_names(sql_path.parent / "scripts" / "enum" / "mod.lua")

    db = sqlite3.connect(temp_path)
    try:
        db.execute("pragma journal_mode = off")
        db.execute("pragma synchronous = off")
        _create_schema(db)

        item_name_by_id = _insert_item_basic(db, sql_path / "item_basic.sql")
        _insert_item_equipment(db, sql_path / "item_equipment.sql")
        _insert_item_weapon(db, sql_path / "item_weapon.sql")
        item_mod_count = _insert_item_mods(db, sql_path / "item_mods.sql", mod_names)
        _insert_augments(db, sql_path / "augments.sql", mod_names)
        _insert_merits(db, sql_path / "merits.sql")
        _insert_traits(db, sql_path / "traits.sql", mod_names)
        _insert_weapon_skills(db, sql_path / "weapon_skills.sql")
        _insert_item_usable(db, sql_path / "item_usable.sql")
        mob_resistance_count, mob_pool_count, mob_group_count = _insert_mob_sources(db, sql_path)
        food_count, food_mod_count = _insert_food_effects(db, scripts_path, item_name_by_id, mod_names)

        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("schema_version", "1"),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("source_sql_root", str(sql_path)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("source_scripts_items_root", str(scripts_path)),
        )
        db.commit()
    finally:
        db.close()

    destination.unlink(missing_ok=True)
    temp_path.replace(destination)

    return StatsDbBuildResult(
        path=destination,
        item_count=len(item_name_by_id),
        item_mod_count=item_mod_count,
        food_count=food_count,
        food_mod_count=food_mod_count,
        mob_resistance_count=mob_resistance_count,
        mob_pool_count=mob_pool_count,
        mob_group_count=mob_group_count,
    )


def _create_schema(db: sqlite3.Connection) -> None:
    db.executescript(
        """
        create table items (
            item_id integer primary key,
            sub_id integer not null,
            name text not null,
            sort_name text not null,
            item_type text not null,
            stack_size integer not null,
            flags text not null,
            auction_house text not null,
            base_sell integer not null
        );

        create table item_equipment (
            item_id integer primary key,
            name text not null,
            level integer not null,
            ilevel integer not null,
            jobs integer not null,
            model_id integer not null,
            shield_size integer not null,
            script_type integer not null,
            slot integer not null,
            rslot integer not null,
            rslot_look integer not null,
            su_level integer not null
        );

        create table item_weapon (
            item_id integer primary key,
            name text not null,
            skill integer not null,
            subskill integer not null,
            ilvl_skill integer not null,
            ilvl_parry integer not null,
            ilvl_magic_accuracy integer not null,
            damage_type integer not null,
            hit integer not null,
            delay integer not null,
            damage integer not null,
            unlock_points integer not null
        );

        create table item_mods (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null
        );
        create index item_mods_item_id_idx on item_mods(item_id);

        create table augments (
            augment_id integer not null,
            multiplier integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            is_pet integer not null,
            pet_type integer not null
        );

        create table merits (
            merit_id integer not null,
            name text not null,
            upgrade integer not null,
            value integer not null,
            jobs integer not null,
            upgrade_id integer not null,
            category_id integer not null
        );

        create table traits (
            trait_id integer not null,
            name text not null,
            job integer not null,
            level integer not null,
            rank integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            content_tag text,
            merit_id integer not null
        );

        create table weapon_skills (
            weapon_skill_id integer not null,
            name text not null,
            jobs_hex text not null,
            weapon_type integer not null,
            skill_level integer not null,
            element integer not null,
            animation integer not null,
            animation_time integer not null,
            range integer not null,
            aoe integer not null,
            radius integer not null,
            primary_sc integer not null,
            secondary_sc integer not null,
            tertiary_sc integer not null,
            main_only integer not null,
            unlock_id integer not null
        );

        create table item_usable (
            item_id integer primary key,
            name text not null,
            valid_targets integer not null,
            activation integer not null,
            animation integer not null,
            animation_time integer not null,
            max_charges integer not null,
            use_delay integer not null,
            reuse_delay integer not null,
            aoe integer not null
        );

        create table food_effects (
            item_id integer primary key,
            name text not null,
            food_type text not null,
            duration_seconds integer not null,
            script_path text not null
        );

        create table food_effect_mods (
            item_id integer not null,
            target_type text not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null
        );
        create index food_effect_mods_item_id_idx on food_effect_mods(item_id);

        create table mob_resistances (
            resist_id integer primary key,
            name text not null,
            slash_sdt integer not null,
            pierce_sdt integer not null,
            h2h_sdt integer not null,
            impact_sdt integer not null,
            magical_sdt integer not null,
            fire_sdt integer not null,
            ice_sdt integer not null,
            wind_sdt integer not null,
            earth_sdt integer not null,
            lightning_sdt integer not null,
            water_sdt integer not null,
            light_sdt integer not null,
            dark_sdt integer not null,
            fire_res_rank integer not null,
            ice_res_rank integer not null,
            wind_res_rank integer not null,
            earth_res_rank integer not null,
            lightning_res_rank integer not null,
            water_res_rank integer not null,
            light_res_rank integer not null,
            dark_res_rank integer not null,
            paralyze_res_rank integer not null,
            bind_res_rank integer not null,
            silence_res_rank integer not null,
            slow_res_rank integer not null,
            poison_res_rank integer not null,
            light_sleep_res_rank integer not null,
            dark_sleep_res_rank integer not null,
            blind_res_rank integer not null
        );

        create table mob_pools (
            poolid integer primary key,
            name text not null,
            packet_name text not null,
            speciesid integer not null,
            mjob integer not null,
            sjob integer not null,
            cmb_skill integer not null,
            cmb_delay integer not null,
            cmb_dmg_mult integer not null,
            aggro integer not null,
            links integer not null,
            mob_type integer not null,
            immunity integer not null,
            spell_list integer not null,
            skill_list_id integer not null,
            resist_id integer not null
        );
        create index mob_pools_name_idx on mob_pools(name);
        create index mob_pools_resist_id_idx on mob_pools(resist_id);

        create table mob_family_system (
            speciesID integer primary key,
            family text not null,
            superFamilyID integer not null,
            superFamily text not null,
            ecosystemID integer not null,
            ecosystem text not null,
            HP integer not null,
            MP integer not null,
            STR integer not null,
            DEX integer not null,
            VIT integer not null,
            AGI integer not null,
            INT integer not null,
            MND integer not null,
            CHR integer not null,
            ATT integer not null,
            DEF integer not null,
            ACC integer not null,
            EVA integer not null,
            Element real not null,
            detects integer not null,
            charmable integer not null
        );

        create table mob_groups (
            groupid integer not null,
            poolid integer not null,
            zoneid integer not null,
            name text not null,
            respawntime integer not null,
            spawntype integer not null,
            dropid integer not null,
            HP integer not null,
            MP integer not null,
            allegiance integer not null,
            content_tag text
        );
        create index mob_groups_poolid_idx on mob_groups(poolid);
        create index mob_groups_name_idx on mob_groups(name);

        create table metadata (
            key text primary key,
            value text not null
        );
        """
    )


def _insert_item_basic(db: sqlite3.Connection, path: Path) -> dict[int, str]:
    rows = _read_insert_rows(path, "item_basic")
    mapped: list[tuple[object, ...]] = []
    item_name_by_id: dict[int, str] = {}
    for row in rows:
        _expect_minimum(path, "item_basic", row, 10)
        item_id = _as_int(row[0])
        name = _as_text(row[2])
        item_name_by_id[item_id] = name
        mapped.append(
            (
                item_id,
                _as_int(row[1]),
                name,
                _as_text(row[3]),
                _as_text(row[5]),
                _as_int(row[6]),
                _as_text(row[7]),
                _as_text(row[8]),
                _as_int(row[9]),
            )
        )
    db.executemany(
        """
        insert into items(
            item_id, sub_id, name, sort_name, item_type, stack_size, flags, auction_house, base_sell
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return item_name_by_id


def _insert_item_equipment(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "item_equipment")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "item_equipment", row, 12)
        mapped.append(
            (
                _as_int(row[0]),
                _as_text(row[1]),
                _as_int(row[2]),
                _as_int(row[3]),
                _as_int(row[4]),
                _as_int(row[5]),
                _as_int(row[6]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                _as_int(row[10]),
                _as_int(row[11]),
            )
        )
    db.executemany(
        """
        insert into item_equipment(
            item_id, name, level, ilevel, jobs, model_id, shield_size, script_type,
            slot, rslot, rslot_look, su_level
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_item_weapon(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "item_weapon")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "item_weapon", row, 12)
        mapped.append(tuple(_as_int(row[index]) if index != 1 else _as_text(row[index]) for index in range(12)))
    db.executemany(
        """
        insert into item_weapon(
            item_id, name, skill, subskill, ilvl_skill, ilvl_parry, ilvl_magic_accuracy,
            damage_type, hit, delay, damage, unlock_points
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_item_mods(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> int:
    rows = _read_insert_rows(path, "item_mods")
    mapped = [
        (_as_int(row[0]), _as_int(row[1]), _mod_name(mod_names, _as_int(row[1])), _as_int(row[2]))
        for row in rows
        if len(row) >= 3
    ]
    db.executemany(
        "insert into item_mods(item_id, mod_id, mod_name, value) values (?, ?, ?, ?)",
        mapped,
    )
    return len(mapped)


def _insert_augments(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> None:
    rows = _read_insert_rows(path, "augments")
    mapped = [
        (
            _as_int(row[0]),
            _as_int(row[1]),
            _as_int(row[2]),
            _mod_name(mod_names, _as_int(row[2])),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
        )
        for row in rows
        if len(row) >= 6
    ]
    db.executemany(
        """
        insert into augments(augment_id, multiplier, mod_id, mod_name, value, is_pet, pet_type)
        values (?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_merits(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "merits")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
        )
        for row in rows
        if len(row) >= 7
    ]
    db.executemany(
        """
        insert into merits(merit_id, name, upgrade, value, jobs, upgrade_id, category_id)
        values (?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_traits(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> None:
    rows = _read_insert_rows(path, "traits")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _mod_name(mod_names, _as_int(row[5])),
            _as_int(row[6]),
            None if row[7] is None else _as_text(row[7]),
            _as_int(row[8]),
        )
        for row in rows
        if len(row) >= 9
    ]
    db.executemany(
        """
        insert into traits(trait_id, name, job, level, rank, mod_id, mod_name, value, content_tag, merit_id)
        values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_weapon_skills(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "weapon_skills")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_text(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
            _as_int(row[10]),
            _as_int(row[11]),
            _as_int(row[12]),
            _as_int(row[13]),
            _as_int(row[14]),
            _as_int(row[15]),
        )
        for row in rows
        if len(row) >= 16
    ]
    db.executemany(
        """
        insert into weapon_skills(
            weapon_skill_id, name, jobs_hex, weapon_type, skill_level, element, animation,
            animation_time, range, aoe, radius, primary_sc, secondary_sc, tertiary_sc,
            main_only, unlock_id
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_item_usable(db: sqlite3.Connection, path: Path) -> None:
    rows = _read_insert_rows(path, "item_usable")
    mapped = [
        (
            _as_int(row[0]),
            _as_text(row[1]),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
            _as_int(row[5]),
            _as_int(row[6]),
            _as_int(row[7]),
            _as_int(row[8]),
            _as_int(row[9]),
        )
        for row in rows
        if len(row) >= 10
    ]
    db.executemany(
        """
        insert into item_usable(
            item_id, name, valid_targets, activation, animation, animation_time,
            max_charges, use_delay, reuse_delay, aoe
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )


def _insert_mob_sources(db: sqlite3.Connection, sql_path: Path) -> tuple[int, int, int]:
    paths = {filename: sql_path / filename for filename in MOB_SQL_FILES}
    if not all(path.exists() for path in paths.values()):
        return 0, 0, 0

    resistance_count = _insert_mob_resistances(db, paths["mob_resistances.sql"])
    pool_count = _insert_mob_pools(db, paths["mob_pools.sql"])
    _insert_mob_family_system(db, paths["mob_species_system.sql"])
    group_count = _insert_mob_groups(db, paths["mob_groups.sql"])
    return resistance_count, pool_count, group_count


def _insert_mob_resistances(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_resistances")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_resistances", row, 23)
        values = [_as_int(row[index]) if index != 1 else _as_text(row[index]) for index in range(min(len(row), 31))]
        while len(values) < 31:
            values.append(0)
        mapped.append(tuple(values[:31]))
    db.executemany(
        """
        insert into mob_resistances(
            resist_id, name, slash_sdt, pierce_sdt, h2h_sdt, impact_sdt, magical_sdt,
            fire_sdt, ice_sdt, wind_sdt, earth_sdt, lightning_sdt, water_sdt, light_sdt, dark_sdt,
            fire_res_rank, ice_res_rank, wind_res_rank, earth_res_rank, lightning_res_rank,
            water_res_rank, light_res_rank, dark_res_rank, paralyze_res_rank, bind_res_rank,
            silence_res_rank, slow_res_rank, poison_res_rank, light_sleep_res_rank,
            dark_sleep_res_rank, blind_res_rank
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_mob_pools(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_pools")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_pools", row, 26)
        mapped.append(
            (
                _as_int(row[0]),
                _as_text(row[1]),
                _as_text(row[2]),
                _as_int(row[3]),
                _as_int(row[5]),
                _as_int(row[6]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                _as_int(row[11]),
                _as_int(row[13]),
                _as_int(row[14]),
                _as_int(row[15]),
                _as_int(row[21]),
                _as_int(row[24]),
                _as_int(row[25]),
            )
        )
    db.executemany(
        """
        insert into mob_pools(
            poolid, name, packet_name, speciesid, mjob, sjob, cmb_skill, cmb_delay,
            cmb_dmg_mult, aggro, links, mob_type, immunity, spell_list, skill_list_id, resist_id
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_mob_family_system(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_family_system")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_family_system", row, 23)
        mapped.append(
            (
                _as_int(row[0]),
                _as_text(row[1]),
                _as_int(row[2]),
                _as_text(row[3]),
                _as_int(row[4]),
                _as_text(row[5]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                _as_int(row[10]),
                _as_int(row[11]),
                _as_int(row[12]),
                _as_int(row[13]),
                _as_int(row[14]),
                _as_int(row[15]),
                _as_int(row[16]),
                _as_int(row[17]),
                _as_int(row[18]),
                _as_int(row[19]),
                _as_float(row[20]),
                _as_int(row[21]),
                _as_int(row[22]),
            )
        )
    db.executemany(
        """
        insert into mob_family_system(
            speciesID, family, superFamilyID, superFamily, ecosystemID, ecosystem,
            HP, MP, STR, DEX, VIT, AGI, INT, MND, CHR, ATT, DEF, ACC, EVA,
            Element, detects, charmable
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_mob_groups(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "mob_groups")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "mob_groups", row, 11)
        mapped.append(
            (
                _as_int(row[0]),
                _as_int(row[1]),
                _as_int(row[2]),
                _as_text(row[3]),
                _as_int(row[4]),
                _as_int(row[5]),
                _as_int(row[6]),
                _as_int(row[7]),
                _as_int(row[8]),
                _as_int(row[9]),
                None if row[10] is None else _as_text(row[10]),
            )
        )
    db.executemany(
        """
        insert into mob_groups(
            groupid, poolid, zoneid, name, respawntime, spawntype, dropid,
            HP, MP, allegiance, content_tag
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_food_effects(
    db: sqlite3.Connection,
    scripts_path: Path,
    item_name_by_id: dict[int, str],
    mod_names: dict[int, str],
) -> tuple[int, int]:
    item_id_by_name = {name.lower(): item_id for item_id, name in item_name_by_id.items()}
    effects = tuple(_iter_food_effects(scripts_path, item_id_by_name, mod_names))

    db.executemany(
        """
        insert into food_effects(item_id, name, food_type, duration_seconds, script_path)
        values (?, ?, ?, ?, ?)
        """,
        (
            (
                effect.item_id,
                effect.name,
                effect.food_type,
                effect.duration_seconds,
                str(effect.script_path),
            )
            for effect in effects
        ),
    )

    food_mod_rows = [
        (effect.item_id, mod.target_type, mod.mod_id, mod.mod_name, mod.value)
        for effect in effects
        for mod in effect.mods
    ]
    db.executemany(
        """
        insert into food_effect_mods(item_id, target_type, mod_id, mod_name, value)
        values (?, ?, ?, ?, ?)
        """,
        food_mod_rows,
    )
    return len(effects), len(food_mod_rows)


def _iter_food_effects(
    scripts_path: Path,
    item_id_by_name: dict[str, int],
    mod_names: dict[int, str],
) -> Iterable[FoodEffect]:
    mod_ids_by_name = {name: mod_id for mod_id, name in mod_names.items()}
    for path in sorted(scripts_path.glob("*.lua")):
        text = path.read_text(encoding="utf-8", errors="replace")
        if "foodOnItemCheck" not in text and "xi.foodType" not in text:
            continue

        item_id_match = ITEM_ID_RE.search(text)
        item_id = int(item_id_match.group(1)) if item_id_match else item_id_by_name.get(path.stem.lower())
        if item_id is None:
            continue

        item_name_match = ITEM_NAME_RE.search(text)
        item_name = item_name_match.group(1).strip() if item_name_match else path.stem
        food_type_match = FOOD_TYPE_RE.search(text)
        duration_match = DURATION_RE.search(text)
        gain_match = ON_EFFECT_GAIN_RE.search(text)
        gain_text = gain_match.group(1) if gain_match else ""

        mods: list[FoodMod] = []
        for mod_name, value in ADD_MOD_RE.findall(gain_text):
            mods.append(
                FoodMod(
                    target_type="player",
                    mod_id=mod_ids_by_name.get(mod_name, 0),
                    mod_name=mod_name,
                    value=int(value),
                )
            )
        for mod_name, value in ADD_PET_MOD_RE.findall(gain_text):
            mods.append(
                FoodMod(
                    target_type="pet",
                    mod_id=mod_ids_by_name.get(mod_name, 0),
                    mod_name=mod_name,
                    value=int(value),
                )
            )

        yield FoodEffect(
            item_id=item_id,
            name=item_name,
            food_type=food_type_match.group(1) if food_type_match else "UNKNOWN",
            duration_seconds=int(duration_match.group(1)) if duration_match else 0,
            script_path=path,
            mods=tuple(mods),
        )


def _load_mod_names(enum_path: Path) -> dict[int, str]:
    mod_names = dict(MOD_NAMES)
    if not enum_path.exists():
        return mod_names

    text = enum_path.read_text(encoding="utf-8", errors="replace")
    for name, value in MOD_ENUM_RE.findall(text):
        mod_names[int(value)] = name
    return mod_names


def _mod_name(mod_names: dict[int, str], mod_id: int) -> str:
    return mod_names.get(mod_id, f"MOD_{mod_id}")


def _read_insert_rows(path: Path, table: str) -> tuple[tuple[object | None, ...], ...]:
    text = path.read_text(encoding="utf-8", errors="replace")
    rows: list[tuple[object | None, ...]] = []
    insert_re = re.compile(
        rf"INSERT\s+INTO\s+`?{re.escape(table)}`?\s+VALUES\s*(.*?);",
        re.IGNORECASE | re.DOTALL,
    )
    for match in insert_re.finditer(text):
        for tuple_text in _split_tuples(match.group(1)):
            rows.append(tuple(_parse_sql_atom(value) for value in _split_sql_tuple(tuple_text)))
    return tuple(rows)


def _split_tuples(values_text: str) -> Iterable[str]:
    in_quote = False
    depth = 0
    start = 0
    index = 0
    while index < len(values_text):
        char = values_text[index]
        if char == "'" and (index == 0 or values_text[index - 1] != "\\"):
            if in_quote and index + 1 < len(values_text) and values_text[index + 1] == "'":
                index += 2
                continue
            in_quote = not in_quote
        elif not in_quote:
            if char == "(":
                if depth == 0:
                    start = index + 1
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    yield values_text[start:index]
        index += 1


def _split_sql_tuple(tuple_text: str) -> tuple[str, ...]:
    values: list[str] = []
    in_quote = False
    start = 0
    index = 0
    while index < len(tuple_text):
        char = tuple_text[index]
        if char == "'" and (index == 0 or tuple_text[index - 1] != "\\"):
            if in_quote and index + 1 < len(tuple_text) and tuple_text[index + 1] == "'":
                index += 2
                continue
            in_quote = not in_quote
        elif char == "," and not in_quote:
            values.append(tuple_text[start:index].strip())
            start = index + 1
        index += 1
    values.append(tuple_text[start:].strip())
    return tuple(values)


def _parse_sql_atom(value: str) -> object | None:
    value = value.strip()
    if value.upper() == "NULL":
        return None
    if len(value) >= 2 and value[0] == "'" and value[-1] == "'":
        return value[1:-1].replace("''", "'").replace("\\'", "'")
    try:
        return int(value, 0)
    except ValueError:
        return value


def _as_int(value: object | None, default: int = 0) -> int:
    if value is None:
        return default
    if isinstance(value, int):
        return value
    text = str(value).strip()
    try:
        return int(text, 0)
    except ValueError:
        return default


def _as_text(value: object | None) -> str:
    return "" if value is None else str(value)


def _as_float(value: object | None, default: float = 0.0) -> float:
    if value is None:
        return default
    if isinstance(value, float):
        return value
    if isinstance(value, int):
        return float(value)
    text = str(value).strip()
    try:
        return float(text)
    except ValueError:
        return default


def _expect_minimum(path: Path, table: str, row: tuple[object | None, ...], minimum: int) -> None:
    if len(row) < minimum:
        raise ValueError(f"{path} {table} row has {len(row)} values, expected at least {minimum}: {row!r}")
