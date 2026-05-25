from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import re
import sqlite3
from typing import Iterable

from .itemstats import EQUIPMENT_SLOT_MASKS, JOB_ID_BY_ABBR, MOD_NAMES


SQL_FILES = (
    "item_basic.sql",
    "item_equipment.sql",
    "item_weapon.sql",
    "item_mods.sql",
    "item_latents.sql",
    "augments.sql",
    "merits.sql",
    "traits.sql",
    "weapon_skills.sql",
    "item_usable.sql",
)

CORE_MECHANICS_SQL_FILES = (
    "abilities.sql",
    "spell_list.sql",
    "status_effects.sql",
    "item_mods_pet.sql",
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
CATSEYE_EQUIPMENT_HEADER_RE = re.compile(r"^\[([^\]]+)\]All Races$")
CATSEYE_LEVEL_RE = re.compile(r"^Lv\.(\d+)\s*(.*)$")
CATSEYE_NAME_NORMALIZE_RE = re.compile(r"[^a-z0-9]+")
CATSEYE_RECIPE_MARKER_RE = re.compile(r"(^|\s)\*+(\s|$)")
CATSEYE_MOVEMENT_SPEED_RE = re.compile(r"\bmovement\s+speed\s*\+?\s*(\d+)\s*%", re.IGNORECASE)
CATSEYE_MOUNT_MOVEMENT_RE = re.compile(r"\bmount\s+movement\s+speed\b", re.IGNORECASE)
CATSEYE_STAT_LOOKAHEAD_LINES = 16

ALL_JOB_MASK = sum(1 << (job_id - 1) for job_id in JOB_ID_BY_ABBR.values())
CATSEYE_EQUIPMENT_NAME_ALIASES = {
    # Catseye renamed the retail Ephemeron item in-game/wiki-side but keeps the
    # server item row under its retail name/id.
    "somniamelodiam": 18904,
}
CATSEYE_SLOT_FAMILIES = {
    "Ammo": ("Ammo",),
    "Trinket": ("Ammo",),
    "Item": ("Ammo",),
    "Jug": ("Ammo",),
    "Throwing": ("Ammo",),
    "Head": ("Head",),
    "Body": ("Body",),
    "Hands": ("Hands",),
    "Legs": ("Legs",),
    "Feet": ("Feet",),
    "Neck": ("Neck",),
    "Waist": ("Waist",),
    "Back": ("Back",),
    "Earring": ("Ear1", "Ear2"),
    "Ring": ("Ring1", "Ring2"),
    "Shield": ("Sub",),
    "Grip": ("Sub",),
    "Bell": ("Range",),
    "Bow": ("Range",),
    "Crossbow": ("Range",),
    "Gun": ("Range",),
    "Instrument": ("Range",),
    "Sword": ("Main", "Sub"),
    "Dagger": ("Main", "Sub"),
    "Axe": ("Main", "Sub"),
    "Katana": ("Main", "Sub"),
    "Club": ("Main", "Sub"),
    "Hand-to-Hand": ("Main",),
    "Great Axe": ("Main",),
    "Great Katana": ("Main",),
    "Great Sword": ("Main",),
    "Polearm": ("Main",),
    "Scythe": ("Main",),
    "Staff": ("Main",),
}


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
    ability_count: int = 0
    spell_count: int = 0
    status_effect_count: int = 0
    pet_item_mod_count: int = 0
    item_latent_count: int = 0
    catseye_equipment_override_count: int = 0
    catseye_equipment_stat_override_count: int = 0
    client_item_count: int = 0
    client_equipment_update_count: int = 0
    client_weapon_update_count: int = 0


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


@dataclass(frozen=True)
class CatseyeEquipmentRecord:
    name: str
    level: int
    jobs_mask: int
    slot_mask: int
    stats_text: str
    source_text: str
    source_path: str


@dataclass(frozen=True)
class CatseyeEquipmentStatOverride:
    item_id: int
    mod_id: int
    mod_name: str
    value: int
    source_path: str
    source_text: str


@dataclass(frozen=True)
class ClientItemResource:
    item_id: int
    name: str
    level: int
    ilevel: int
    client_jobs_mask: int
    jobs_mask: int
    slot_mask: int
    flags: int
    stack_size: int
    item_type: int
    sub_type: int
    skill: int
    damage: int
    delay: int
    damage_type: int
    shield_size: int
    su_level: int
    valid_targets: int


@dataclass(frozen=True)
class ClientItemResourceImport:
    source_path: Path | None
    item_count: int = 0
    equipment_update_count: int = 0
    weapon_update_count: int = 0


def build_stats_db(
    *,
    sql_root: Path | str,
    scripts_items_root: Path | str,
    output_path: Path | str,
    catseye_wiki_root: Path | str | None = None,
    client_items_path: Path | str | None = None,
) -> StatsDbBuildResult:
    sql_path = Path(sql_root)
    scripts_path = Path(scripts_items_root)
    destination = Path(output_path)

    if not sql_path.exists():
        raise FileNotFoundError(f"Server SQL root not found: {sql_path}")
    if not scripts_path.exists():
        raise FileNotFoundError(f"Server item scripts root not found: {scripts_path}")
    for filename in SQL_FILES + CORE_MECHANICS_SQL_FILES:
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
        catseye_equipment_override_count = _apply_catseye_equipment_overrides(db, catseye_wiki_root)
        _insert_item_weapon(db, sql_path / "item_weapon.sql")
        client_item_import = _apply_client_item_resources(db, client_items_path)
        item_mod_count = _insert_item_mods(db, sql_path / "item_mods.sql", mod_names)
        catseye_equipment_stat_override_count = _apply_catseye_equipment_stat_overrides(
            db,
            catseye_wiki_root,
            mod_names,
        )
        item_latent_count = _insert_item_latents(db, sql_path / "item_latents.sql", mod_names)
        _insert_augments(db, sql_path / "augments.sql", mod_names)
        _insert_merits(db, sql_path / "merits.sql")
        _insert_traits(db, sql_path / "traits.sql", mod_names)
        _insert_weapon_skills(db, sql_path / "weapon_skills.sql")
        _insert_item_usable(db, sql_path / "item_usable.sql")
        ability_count = _insert_abilities(db, sql_path / "abilities.sql")
        spell_count = _insert_spells(db, sql_path / "spell_list.sql")
        status_effect_count = _insert_status_effects(db, sql_path / "status_effects.sql")
        pet_item_mod_count = _insert_item_mods_pet(db, sql_path / "item_mods_pet.sql", mod_names)
        mob_resistance_count, mob_pool_count, mob_group_count = _insert_mob_sources(db, sql_path)
        food_count, food_mod_count = _insert_food_effects(db, scripts_path, item_name_by_id, mod_names)

        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("schema_version", "6"),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("item_latent_count", str(item_latent_count)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("source_sql_root", str(sql_path)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("source_scripts_items_root", str(scripts_path)),
        )
        if catseye_wiki_root is not None:
            db.execute(
                "insert into metadata(key, value) values (?, ?)",
                ("source_catseye_wiki_root", str(Path(catseye_wiki_root))),
            )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("catseye_equipment_override_count", str(catseye_equipment_override_count)),
        )
        db.execute(
            "insert into metadata(key, value) values (?, ?)",
            ("catseye_equipment_stat_override_count", str(catseye_equipment_stat_override_count)),
        )
        if client_item_import.source_path is not None:
            db.executemany(
                "insert into metadata(key, value) values (?, ?)",
                (
                    ("source_client_items_path", str(client_item_import.source_path)),
                    ("client_item_count", str(client_item_import.item_count)),
                    ("client_equipment_update_count", str(client_item_import.equipment_update_count)),
                    ("client_weapon_update_count", str(client_item_import.weapon_update_count)),
                ),
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
        ability_count=ability_count,
        spell_count=spell_count,
        status_effect_count=status_effect_count,
        pet_item_mod_count=pet_item_mod_count,
        item_latent_count=item_latent_count,
        catseye_equipment_override_count=catseye_equipment_override_count,
        catseye_equipment_stat_override_count=catseye_equipment_stat_override_count,
        client_item_count=client_item_import.item_count,
        client_equipment_update_count=client_item_import.equipment_update_count,
        client_weapon_update_count=client_item_import.weapon_update_count,
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

        create table catseye_equipment_overrides (
            item_id integer primary key,
            server_name text not null,
            catseye_name text not null,
            original_level integer not null,
            catseye_level integer not null,
            original_ilevel integer not null,
            catseye_ilevel integer not null,
            original_jobs integer not null,
            catseye_jobs integer not null,
            original_slot integer not null,
            catseye_slot integer not null,
            source_path text not null,
            source_text text not null,
            stats_text text not null
        );

        create table catseye_equipment_stat_overrides (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            original_value integer,
            catseye_value integer not null,
            source_path text not null,
            source_text text not null
        );
        create index catseye_equipment_stat_overrides_item_idx
            on catseye_equipment_stat_overrides(item_id);

        create table catseye_client_items (
            item_id integer primary key,
            name text not null,
            level integer not null,
            ilevel integer not null,
            client_jobs integer not null,
            jobs integer not null,
            slot integer not null,
            flags integer not null,
            stack_size integer not null,
            item_type integer not null,
            sub_type integer not null,
            skill integer not null,
            damage integer not null,
            delay integer not null,
            damage_type integer not null,
            shield_size integer not null,
            su_level integer not null,
            valid_targets integer not null,
            source_path text not null
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

        create table item_latents (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            condition_id integer not null,
            condition_value integer not null
        );
        create index item_latents_item_id_idx on item_latents(item_id);
        create index item_latents_condition_idx on item_latents(condition_id, condition_value);

        create table item_mods_pet (
            item_id integer not null,
            mod_id integer not null,
            mod_name text not null,
            value integer not null,
            pet_type integer not null
        );
        create index item_mods_pet_item_id_idx on item_mods_pet(item_id);

        create table abilities (
            ability_id integer primary key,
            name text not null,
            job integer not null,
            level integer not null,
            valid_target integer not null,
            recast_time integer not null,
            recast_id integer not null,
            message1 integer not null,
            message2 integer not null,
            animation integer not null,
            animation_time integer not null,
            cast_time integer not null,
            action_type integer not null,
            range integer not null,
            is_aoe integer not null,
            radius integer not null,
            ce integer not null,
            ve integer not null,
            merit_mod_id integer not null,
            add_type integer not null,
            content_tag text
        );
        create index abilities_job_level_idx on abilities(job, level);
        create index abilities_recast_id_idx on abilities(recast_id);

        create table spells (
            spell_id integer primary key,
            name text not null,
            jobs_hex text not null,
            spell_group integer not null,
            family integer not null,
            element integer not null,
            zone_misc integer not null,
            valid_targets integer not null,
            skill integer not null,
            mp_cost integer not null,
            cast_time integer not null,
            recast_time integer not null,
            message integer not null,
            magic_burst_message integer not null,
            animation integer not null,
            animation_time integer not null,
            aoe integer not null,
            base integer not null,
            multiplier real not null,
            ce integer not null,
            ve integer not null,
            requirements integer not null,
            spell_range integer not null,
            radius integer not null,
            content_tag text
        );
        create index spells_skill_idx on spells(skill);
        create index spells_element_idx on spells(element);

        create table status_effects (
            status_id integer primary key,
            name text not null,
            flags integer not null,
            status_type integer not null,
            negative_id integer not null,
            overwrite integer not null,
            block_id integer not null,
            remove_id integer not null,
            element integer not null,
            min_duration integer not null,
            sort_key integer not null
        );
        create index status_effects_name_idx on status_effects(name);

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


def _apply_catseye_equipment_overrides(
    db: sqlite3.Connection,
    catseye_wiki_root: Path | str | None,
) -> int:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        return 0

    equipment_records = tuple(_iter_catseye_equipment_records(pages_root))
    if not equipment_records:
        return 0

    item_ids_by_name = _build_equipment_item_name_index(db)
    applied_item_ids: set[int] = set()
    override_rows: list[tuple[object, ...]] = []
    update_rows: list[tuple[object, ...]] = []

    for record in equipment_records:
        if record.level > 75 or record.jobs_mask <= 0 or record.slot_mask <= 0:
            continue

        item_id = _match_catseye_equipment_item_id(record, item_ids_by_name)
        if item_id is None or item_id in applied_item_ids:
            continue

        existing = db.execute(
            """
            select name, level, ilevel, jobs, slot
            from item_equipment
            where item_id = ?
            """,
            (item_id,),
        ).fetchone()
        if existing is None:
            continue

        server_name, original_level, original_ilevel, original_jobs, original_slot = existing
        if int(original_level) <= 75:
            continue

        override_rows.append(
            (
                item_id,
                str(server_name),
                record.name,
                int(original_level),
                record.level,
                int(original_ilevel),
                0,
                int(original_jobs),
                record.jobs_mask,
                int(original_slot),
                record.slot_mask,
                record.source_path,
                record.source_text,
                record.stats_text,
            )
        )
        update_rows.append((record.level, 0, record.jobs_mask, record.slot_mask, item_id))
        applied_item_ids.add(item_id)

    if not override_rows:
        return 0

    db.executemany(
        """
        insert into catseye_equipment_overrides(
            item_id, server_name, catseye_name, original_level, catseye_level,
            original_ilevel, catseye_ilevel, original_jobs, catseye_jobs,
            original_slot, catseye_slot, source_path, source_text, stats_text
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        override_rows,
    )
    db.executemany(
        """
        update item_equipment
        set level = ?, ilevel = ?, jobs = ?, slot = ?
        where item_id = ?
        """,
        update_rows,
    )
    return len(override_rows)


def _apply_catseye_equipment_stat_overrides(
    db: sqlite3.Connection,
    catseye_wiki_root: Path | str | None,
    mod_names: dict[int, str],
) -> int:
    pages_root = _resolve_catseye_pages_root(catseye_wiki_root)
    if pages_root is None:
        return 0

    item_ids_by_name = _build_equipment_item_name_index(db)
    if not item_ids_by_name:
        return 0

    movement_mod_id = _mod_id_by_name(mod_names, "MOVE_SPEED_GEAR_BONUS", fallback=76)
    movement_mod_name = _mod_name(mod_names, movement_mod_id)
    candidates: dict[tuple[int, int], CatseyeEquipmentStatOverride] = {}
    for path in sorted(pages_root.glob("*.txt")):
        for candidate in _iter_catseye_movement_speed_overrides(
            path,
            pages_root,
            item_ids_by_name,
            movement_mod_id,
            movement_mod_name,
        ):
            key = (candidate.item_id, candidate.mod_id)
            existing = candidates.get(key)
            if existing is None or candidate.value > existing.value:
                candidates[key] = candidate

    override_rows: list[tuple[object, ...]] = []
    for candidate in sorted(candidates.values(), key=lambda value: (value.item_id, value.mod_id)):
        existing_values = [
            int(row[0])
            for row in db.execute(
                "select value from item_mods where item_id = ? and mod_id = ?",
                (candidate.item_id, candidate.mod_id),
            )
        ]
        original_value = max(existing_values) if existing_values else None
        if original_value == candidate.value:
            continue

        db.execute(
            "delete from item_mods where item_id = ? and mod_id = ?",
            (candidate.item_id, candidate.mod_id),
        )
        db.execute(
            "insert into item_mods(item_id, mod_id, mod_name, value) values (?, ?, ?, ?)",
            (candidate.item_id, candidate.mod_id, candidate.mod_name, candidate.value),
        )
        override_rows.append(
            (
                candidate.item_id,
                candidate.mod_id,
                candidate.mod_name,
                original_value,
                candidate.value,
                candidate.source_path,
                candidate.source_text,
            )
        )

    if not override_rows:
        return 0

    db.executemany(
        """
        insert into catseye_equipment_stat_overrides(
            item_id, mod_id, mod_name, original_value, catseye_value,
            source_path, source_text
        ) values (?, ?, ?, ?, ?, ?, ?)
        """,
        override_rows,
    )
    return len(override_rows)


def _iter_catseye_movement_speed_overrides(
    path: Path,
    pages_root: Path,
    item_ids_by_name: dict[str, set[int]],
    mod_id: int,
    mod_name: str,
) -> Iterable[CatseyeEquipmentStatOverride]:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = [line.strip() for line in text.replace("\u00a0", " ").splitlines()]
    lines = [line for line in lines if line]
    try:
        source_path = path.relative_to(pages_root.parent).as_posix()
    except ValueError:
        source_path = path.as_posix()

    for index, line in enumerate(lines):
        item_id = _match_catseye_equipment_name(line, item_ids_by_name)
        if item_id is None:
            continue

        source_lines = _catseye_stat_source_lines(lines, index, item_ids_by_name)
        value = _first_catseye_movement_speed_value(source_lines)
        if value is None:
            continue

        yield CatseyeEquipmentStatOverride(
            item_id=item_id,
            mod_id=mod_id,
            mod_name=mod_name,
            value=value,
            source_path=source_path,
            source_text=" ".join(source_lines),
        )


def _catseye_stat_source_lines(
    lines: list[str],
    item_index: int,
    item_ids_by_name: dict[str, set[int]],
) -> list[str]:
    source_lines = [lines[item_index]]
    saw_stats = False

    for line in lines[item_index + 1:item_index + 1 + CATSEYE_STAT_LOOKAHEAD_LINES]:
        if "used in synthesis for" in line.lower():
            break
        if saw_stats and _match_catseye_equipment_name(line, item_ids_by_name) is not None:
            break

        source_lines.append(line)
        if _line_looks_like_catseye_stats(line):
            saw_stats = True
        if _first_catseye_movement_speed_value((line,)) is not None:
            break

    return source_lines


def _line_looks_like_catseye_stats(line: str) -> bool:
    compact = line.strip()
    if re.fullmatch(r"\d+", compact):
        return True
    return bool(
        re.search(
            r"\b(DEF|DMG|Delay|HP|MP|STR|DEX|VIT|AGI|INT|MND|CHR|Accuracy|Attack|Evasion|Enmity|Haste|Damage)\b",
            compact,
            re.IGNORECASE,
        )
    )


def _first_catseye_movement_speed_value(lines: Iterable[str]) -> int | None:
    for line in lines:
        if CATSEYE_MOUNT_MOVEMENT_RE.search(line):
            continue
        match = CATSEYE_MOVEMENT_SPEED_RE.search(line)
        if match is not None:
            return int(match.group(1))
    return None


def _resolve_catseye_pages_root(catseye_wiki_root: Path | str | None) -> Path | None:
    if catseye_wiki_root is None:
        return None

    root = Path(catseye_wiki_root)
    candidates = (
        root,
        root / "pages",
        root / "tools-data" / "catseye-wiki-cache" / "pages",
    )
    for candidate in candidates:
        if candidate.exists() and any(candidate.glob("CatsEyeXI_Content_Equipment_*.txt")):
            return candidate
    return None


def _build_equipment_item_name_index(db: sqlite3.Connection) -> dict[str, set[int]]:
    item_ids_by_name: dict[str, set[int]] = {}
    rows = db.execute(
        """
        select i.item_id, i.name, i.sort_name, e.name
        from items i
        join item_equipment e on e.item_id = i.item_id
        """
    )
    for item_id, item_name, sort_name, equipment_name in rows:
        for value in (item_name, sort_name, equipment_name):
            normalized = _normalize_catseye_equipment_name(str(value))
            if normalized:
                item_ids_by_name.setdefault(normalized, set()).add(int(item_id))
    return item_ids_by_name


def _match_catseye_equipment_item_id(
    record: CatseyeEquipmentRecord,
    item_ids_by_name: dict[str, set[int]],
) -> int | None:
    return _match_catseye_equipment_name(record.name, item_ids_by_name)


def _match_catseye_equipment_name(
    name: str,
    item_ids_by_name: dict[str, set[int]],
) -> int | None:
    if CATSEYE_RECIPE_MARKER_RE.search(name):
        return None

    normalized_name = _normalize_catseye_equipment_name(name)
    alias_item_id = CATSEYE_EQUIPMENT_NAME_ALIASES.get(normalized_name)
    if alias_item_id is not None:
        return alias_item_id

    item_ids = item_ids_by_name.get(normalized_name)
    if item_ids is None or len(item_ids) != 1:
        return None
    return next(iter(item_ids))


def _iter_catseye_equipment_records(pages_root: Path) -> Iterable[CatseyeEquipmentRecord]:
    for path in sorted(pages_root.glob("CatsEyeXI_Content_Equipment_*.txt")):
        yield from _parse_catseye_equipment_page(path, pages_root)


def _parse_catseye_equipment_page(path: Path, pages_root: Path) -> Iterable[CatseyeEquipmentRecord]:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = [line.strip() for line in text.replace("\u00a0", " ").splitlines()]
    lines = [line for line in lines if line]
    header_indexes = [
        index for index, line in enumerate(lines)
        if CATSEYE_EQUIPMENT_HEADER_RE.match(line) is not None
    ]

    for header_position, header_index in enumerate(header_indexes):
        if header_index <= 0:
            continue

        header_match = CATSEYE_EQUIPMENT_HEADER_RE.match(lines[header_index])
        if header_match is None:
            continue

        next_header_index = header_indexes[header_position + 1] if header_position + 1 < len(header_indexes) else len(lines)
        record_end = max(header_index + 1, next_header_index - 1)
        level_index = next(
            (
                index for index in range(header_index + 1, record_end)
                if CATSEYE_LEVEL_RE.match(lines[index]) is not None
            ),
            -1,
        )
        if level_index < 0:
            continue

        level_match = CATSEYE_LEVEL_RE.match(lines[level_index])
        if level_match is None:
            continue

        try:
            source_path = path.relative_to(pages_root.parent).as_posix()
        except ValueError:
            source_path = path.as_posix()

        source_lines = [
            line for line in lines[level_index + 1:record_end]
            if not re.fullmatch(r"\d+", line)
        ]
        source_text = " ".join(source_lines) or f"Listed on {path.name}."
        yield CatseyeEquipmentRecord(
            name=lines[header_index - 1],
            level=int(level_match.group(1)),
            jobs_mask=_catseye_jobs_mask(level_match.group(2)),
            slot_mask=_catseye_slot_mask(header_match.group(1)),
            stats_text=" ".join(lines[header_index + 1:level_index]),
            source_text=source_text,
            source_path=source_path,
        )


def _catseye_jobs_mask(job_text: str) -> int:
    text = " ".join((job_text or "").replace(",", " ").replace("/", " ").split())
    if not text or text == "All Jobs":
        return ALL_JOB_MASK

    mask = 0
    for token in text.split(" "):
        job_id = JOB_ID_BY_ABBR.get(token.upper())
        if job_id is not None:
            mask |= 1 << (job_id - 1)
    return mask


def _catseye_slot_mask(slot_family: str) -> int:
    mask = 0
    for slot in CATSEYE_SLOT_FAMILIES.get(slot_family, (slot_family,)):
        mask |= EQUIPMENT_SLOT_MASKS.get(slot, 0)
    return mask


def _normalize_catseye_equipment_name(name: str) -> str:
    return CATSEYE_NAME_NORMALIZE_RE.sub("", name.lower())


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


def _apply_client_item_resources(
    db: sqlite3.Connection,
    client_items_path: Path | str | None,
) -> ClientItemResourceImport:
    if client_items_path is None:
        return ClientItemResourceImport(source_path=None)

    dump_path = _resolve_client_items_dump_path(client_items_path)
    resources = tuple(_iter_client_item_resources(dump_path))
    if not resources:
        return ClientItemResourceImport(source_path=dump_path)

    db.executemany(
        """
        insert into catseye_client_items(
            item_id, name, level, ilevel, client_jobs, jobs, slot, flags,
            stack_size, item_type, sub_type, skill, damage, delay, damage_type,
            shield_size, su_level, valid_targets, source_path
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            (
                item.item_id,
                item.name,
                item.level,
                item.ilevel,
                item.client_jobs_mask,
                item.jobs_mask,
                item.slot_mask,
                item.flags,
                item.stack_size,
                item.item_type,
                item.sub_type,
                item.skill,
                item.damage,
                item.delay,
                item.damage_type,
                item.shield_size,
                item.su_level,
                item.valid_targets,
                str(dump_path),
            )
            for item in resources
        ),
    )

    equipment_update_count = 0
    weapon_update_count = 0
    for item in resources:
        if item.slot_mask > 0 and item.jobs_mask > 0:
            _upsert_client_equipment_resource(db, item)
            equipment_update_count += 1

        if item.skill > 0 or item.damage > 0 or item.delay > 0:
            _upsert_client_weapon_resource(db, item)
            weapon_update_count += 1

    return ClientItemResourceImport(
        source_path=dump_path,
        item_count=len(resources),
        equipment_update_count=equipment_update_count,
        weapon_update_count=weapon_update_count,
    )


def _resolve_client_items_dump_path(client_items_path: Path | str) -> Path:
    path = Path(client_items_path)
    if path.is_file():
        return path
    if path.is_dir():
        matches = sorted(
            path.rglob("*_client_items.json"),
            key=lambda candidate: candidate.stat().st_mtime,
            reverse=True,
        )
        if matches:
            return matches[0]
    raise FileNotFoundError(f"Catseye client item resource dump not found: {path}")


def _iter_client_item_resources(path: Path) -> Iterable[ClientItemResource]:
    payload = json.loads(path.read_text(encoding="utf-8", errors="replace"))
    raw_items = payload if isinstance(payload, list) else payload.get("items", ())
    for raw in raw_items:
        if not isinstance(raw, dict):
            continue
        item_id = _json_int(raw, "id")
        name = _json_text(raw, "name")
        if item_id <= 0 or not name:
            continue

        client_jobs_mask = _json_int(raw, "jobMask")
        yield ClientItemResource(
            item_id=item_id,
            name=name,
            level=_json_int(raw, "level"),
            ilevel=_json_int(raw, "itemLevel"),
            client_jobs_mask=client_jobs_mask,
            jobs_mask=_server_jobs_mask_from_client(client_jobs_mask),
            slot_mask=_json_int(raw, "slotMask"),
            flags=_json_int(raw, "flags"),
            stack_size=_json_int(raw, "stack", default=1),
            item_type=_json_int(raw, "type"),
            sub_type=_json_int(raw, "subType"),
            skill=_json_int(raw, "skill"),
            damage=_json_int(raw, "damage"),
            delay=_json_int(raw, "delay"),
            damage_type=_json_int(raw, "damageType"),
            shield_size=_json_int(raw, "shieldSize"),
            su_level=_json_int(raw, "superiorLevel"),
            valid_targets=_json_int(raw, "validTargets"),
        )


def _server_jobs_mask_from_client(client_jobs_mask: int) -> int:
    return client_jobs_mask >> 1


def _upsert_client_equipment_resource(db: sqlite3.Connection, item: ClientItemResource) -> None:
    cursor = db.execute(
        """
        update item_equipment
        set name = ?, level = ?, ilevel = ?, jobs = ?, shield_size = ?, slot = ?, su_level = ?
        where item_id = ?
        """,
        (
            item.name,
            item.level,
            item.ilevel,
            item.jobs_mask,
            item.shield_size,
            item.slot_mask,
            item.su_level,
            item.item_id,
        ),
    )
    if cursor.rowcount:
        return

    db.execute(
        """
        insert into item_equipment(
            item_id, name, level, ilevel, jobs, model_id, shield_size, script_type,
            slot, rslot, rslot_look, su_level
        ) values (?, ?, ?, ?, ?, 0, ?, 0, ?, 0, 0, ?)
        """,
        (
            item.item_id,
            item.name,
            item.level,
            item.ilevel,
            item.jobs_mask,
            item.shield_size,
            item.slot_mask,
            item.su_level,
        ),
    )


def _upsert_client_weapon_resource(db: sqlite3.Connection, item: ClientItemResource) -> None:
    cursor = db.execute(
        """
        update item_weapon
        set name = ?, skill = ?, damage_type = ?, delay = ?, damage = ?
        where item_id = ?
        """,
        (
            item.name,
            item.skill,
            item.damage_type,
            item.delay,
            item.damage,
            item.item_id,
        ),
    )
    if cursor.rowcount:
        return

    db.execute(
        """
        insert into item_weapon(
            item_id, name, skill, subskill, ilvl_skill, ilvl_parry,
            ilvl_magic_accuracy, damage_type, hit, delay, damage, unlock_points
        ) values (?, ?, ?, 0, 0, 0, 0, ?, 0, ?, ?, 0)
        """,
        (
            item.item_id,
            item.name,
            item.skill,
            item.damage_type,
            item.delay,
            item.damage,
        ),
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


def _insert_item_latents(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> int:
    rows = _read_insert_rows(path, "item_latents")
    mapped = [
        (
            _as_int(row[0]),
            _as_int(row[1]),
            _mod_name(mod_names, _as_int(row[1])),
            _as_int(row[2]),
            _as_int(row[3]),
            _as_int(row[4]),
        )
        for row in rows
        if len(row) >= 5
    ]
    db.executemany(
        """
        insert into item_latents(item_id, mod_id, mod_name, value, condition_id, condition_value)
        values (?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_item_mods_pet(db: sqlite3.Connection, path: Path, mod_names: dict[int, str]) -> int:
    rows = _read_insert_rows(path, "item_mods_pet")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        if len(row) < 4:
            continue
        mod_id = _as_int(row[1])
        base_name = _mod_name(mod_names, mod_id)
        mapped.append(
            (
                _as_int(row[0]),
                mod_id,
                _pet_mod_name(base_name),
                _as_int(row[2]),
                _as_int(row[3]),
            )
        )
    db.executemany(
        "insert into item_mods_pet(item_id, mod_id, mod_name, value, pet_type) values (?, ?, ?, ?, ?)",
        mapped,
    )
    return len(mapped)


def _insert_abilities(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "abilities")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "abilities", row, 20)
        values = [
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
            _as_int(row[12]),
            _as_int(row[13]),
            _as_int(row[14]),
            _as_int(row[15]),
            _as_int(row[16]),
            _as_int(row[17]),
            _as_int(row[18]),
            _as_int(row[19]),
            None if len(row) < 21 or row[20] is None else _as_text(row[20]),
        ]
        mapped.append(tuple(values))
    db.executemany(
        """
        insert into abilities(
            ability_id, name, job, level, valid_target, recast_time, recast_id,
            message1, message2, animation, animation_time, cast_time, action_type,
            range, is_aoe, radius, ce, ve, merit_mod_id, add_type, content_tag
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_spells(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "spell_list")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "spell_list", row, 24)
        values = [
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
            _as_int(row[16]),
            _as_int(row[17]),
            _as_float(row[18]),
            _as_int(row[19]),
            _as_int(row[20]),
            _as_int(row[21]),
            _as_int(row[22]),
            _as_int(row[23]),
            None if len(row) < 25 or row[24] is None else _as_text(row[24]),
        ]
        mapped.append(tuple(values))
    db.executemany(
        """
        insert into spells(
            spell_id, name, jobs_hex, spell_group, family, element, zone_misc,
            valid_targets, skill, mp_cost, cast_time, recast_time, message,
            magic_burst_message, animation, animation_time, aoe, base, multiplier,
            ce, ve, requirements, spell_range, radius, content_tag
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        mapped,
    )
    return len(mapped)


def _insert_status_effects(db: sqlite3.Connection, path: Path) -> int:
    rows = _read_insert_rows(path, "status_effects")
    mapped: list[tuple[object, ...]] = []
    for row in rows:
        _expect_minimum(path, "status_effects", row, 10)
        values = [
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
            _as_int(row[10]) if len(row) > 10 else 0,
        ]
        mapped.append(tuple(values))
    db.executemany(
        """
        insert into status_effects(
            status_id, name, flags, status_type, negative_id, overwrite, block_id,
            remove_id, element, min_duration, sort_key
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
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


def _mod_id_by_name(mod_names: dict[int, str], mod_name: str, *, fallback: int) -> int:
    for mod_id, candidate_name in mod_names.items():
        if candidate_name == mod_name:
            return mod_id
    return fallback


def _pet_mod_name(base_name: str) -> str:
    if base_name.startswith("PET_"):
        return base_name
    return {
        "ACC": "PET_ACC",
        "RACC": "PET_ACC",
        "ATT": "PET_ATK",
        "ATTP": "PET_ATK",
        "RATT": "PET_ATK",
        "RATTP": "PET_ATK",
        "MATT": "PET_MAB",
        "MAGIC_DAMAGE": "PET_MAB",
        "MACC": "PET_MACC",
        "STORETP": "PET_STORETP",
        "HASTE_GEAR": "PET_HASTE",
        "DEF": "PET_DEF",
        "EVA": "PET_EVA",
        "MDEF": "PET_MDEF",
        "DMGPHYS": "PET_DMG_TAKEN",
        "DMGMAGIC": "PET_DMG_TAKEN",
        "UDMGPHYS": "PET_DMG_TAKEN",
        "UDMGMAGIC": "PET_DMG_TAKEN",
        "REGEN": "PET_REGEN",
        "REFRESH": "PET_REFRESH",
    }.get(base_name, base_name)


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


def _json_int(row: dict[str, object], key: str, default: int = 0) -> int:
    value = row.get(key)
    if value is None:
        return default
    if isinstance(value, bool):
        return int(value)
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value)
    text = str(value).strip()
    try:
        return int(text, 0)
    except ValueError:
        return default


def _json_text(row: dict[str, object], key: str) -> str:
    value = row.get(key)
    return "" if value is None else str(value)


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
