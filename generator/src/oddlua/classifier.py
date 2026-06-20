from __future__ import annotations

from dataclasses import dataclass
import re
from typing import Iterable

from .gameconstants import JOB_ID_BY_ABBR
from .gearexport import GearItem
from .itemstats import EQUIPMENT_SLOT_MASKS, EquipmentStats, ItemMod, ItemStatsIndex, WeaponStats


AUGMENT_VALUE_RE = re.compile(r"^(?P<label>.+?)(?P<sign>[+-])\s*(?P<value>\d+)\s*%?$")
AUGMENT_LABEL_NORMALIZE_RE = re.compile(r"[^a-z0-9]+")
AUGMENT_LABEL_MODS = {
    "acc": "ACC",
    "accuracy": "ACC",
    "agi": "AGI",
    "attack": "ATT",
    "att": "ATT",
    "blue magicskill": "BLUE_MAGIC_SKILL",
    "bluemagicskill": "BLUE_MAGIC_SKILL",
    "chr": "CHR",
    "conservemp": "CONSERVE_MP",
    "curepotency": "CURE_POTENCY",
    "def": "DEF",
    "dex": "DEX",
    "enhmageffdur": "ENH_MAGIC_DURATION",
    "enmity": "ENMITY",
    "evasion": "EVA",
    "fastcast": "FASTCAST",
    "haste": "HASTE_GEAR",
    "hp": "HP",
    "int": "INT",
    "magacc": "MACC",
    "magicaccuracy": "MACC",
    "magicatkbonus": "MATT",
    "magicattackbonus": "MATT",
    "magatkbns": "MATT",
    "magicatkbns": "MATT",
    "magdefbns": "MDEF",
    "magicdefensebonus": "MDEF",
    "magicdefbonus": "MDEF",
    "magicdmgtaken": "DMGMAGIC",
    "magicdamagetaken": "DMGMAGIC",
    "mnd": "MND",
    "mp": "MP",
    "mprecoveredwhilehealing": "MPHEAL",
    "physdmgtaken": "DMGPHYS",
    "physicaldamagetaken": "DMGPHYS",
    "rangedaccuracy": "RACC",
    "rangedattack": "RATT",
    "rangedatk": "RATT",
    "rangedacc": "RACC",
    "songspellcastingtime": "SONG_SPELLCASTING_TIME",
    "storetp": "STORETP",
    "str": "STR",
    "subtleblow": "SUBTLE_BLOW",
    "summoningmagicskill": "SUMMONING_MAGIC",
    "vit": "VIT",
    "windinstrumentskill": "WIND_INSTRUMENT",
}
PET_AUGMENT_MOD_ALIASES = {
    "ACC": "PET_ACC",
    "ATT": "PET_ATK",
    "DMGMAGIC": "PET_DMG_TAKEN",
    "DMGPHYS": "PET_DMG_TAKEN",
    "EVA": "PET_EVA",
    "HASTE_GEAR": "PET_HASTE",
    "MACC": "PET_MACC",
    "MATT": "PET_MAB",
    "MDEF": "PET_MDEF",
    "RACC": "PET_ACC",
    "RATT": "PET_ATK",
    "STORETP": "PET_STORETP",
}


@dataclass(frozen=True)
class ClassifiedItem:
    item: GearItem
    slot_family: str
    weapon_family: str
    roles: tuple[str, ...]
    tags: tuple[str, ...]
    excluded: bool
    exclusion_reason: str
    reasons: tuple[str, ...]
    confidence: str
    confidence_score: float
    server_mods: tuple[tuple[str, int], ...]
    pet_server_mods: tuple[tuple[str, int], ...]
    augment_mods: tuple[tuple[str, int], ...]
    pet_augment_mods: tuple[tuple[str, int], ...]
    server_level: int | None
    server_jobs_mask: int | None
    server_slot_mask: int | None
    server_removal_slot_mask: int | None
    server_weapon_subskill: int | None = None

    def level_eligible(self, character_level: int) -> bool:
        if self.server_level is not None:
            return character_level > 0 and (self.server_level <= 0 or self.server_level <= character_level)
        return False

    def job_eligible(self, job: str) -> bool:
        if self.server_jobs_mask is None:
            return False
        job_id = JOB_ID_BY_ABBR.get(job.upper())
        if job_id is None:
            return False
        return bool(self.server_jobs_mask & (1 << (job_id - 1)))

    def slot_eligible(self, slot: str) -> bool:
        if self.server_slot_mask is None:
            return False
        slot_mask = EQUIPMENT_SLOT_MASKS.get(slot)
        if slot_mask is None:
            return False
        return bool(self.server_slot_mask & slot_mask)

    @property
    def is_shuriken(self) -> bool:
        return self.weapon_family == "throwing" and self.server_weapon_subskill == 3

    def manifest_metadata(self) -> dict[str, object]:
        return {
            "item": self.item.name,
            "slotFamily": self.slot_family,
            "weaponFamily": self.weapon_family,
            "roles": list(self.roles),
            "tags": list(self.tags),
            "excluded": self.excluded,
            "exclusionReason": self.exclusion_reason,
            "reasons": list(self.reasons),
            "confidence": self.confidence,
            "confidenceScore": self.confidence_score,
            "serverMods": dict(self.server_mods),
            "petServerMods": dict(self.pet_server_mods),
            "augmentMods": dict(self.augment_mods),
            "petAugmentMods": dict(self.pet_augment_mods),
            "serverLevel": self.server_level,
            "serverJobsMask": self.server_jobs_mask,
            "serverSlotMask": self.server_slot_mask,
            "serverRemovalSlotMask": self.server_removal_slot_mask,
            "serverWeaponSubskill": self.server_weapon_subskill,
        }

    def _server_equipment_view(self) -> EquipmentStats | None:
        if self.server_level is None or self.server_jobs_mask is None or self.server_slot_mask is None:
            return None
        return EquipmentStats(
            item_id=self.item.id,
            name=self.item.name,
            level=self.server_level,
            ilevel=0,
            jobs=self.server_jobs_mask,
            shield_size=0,
            slot_mask=self.server_slot_mask,
            removal_slot_mask=self.server_removal_slot_mask or 0,
        )


def classify_items(
    items: Iterable[GearItem],
    *,
    item_stats: ItemStatsIndex | None = None,
) -> tuple[ClassifiedItem, ...]:
    return tuple(classify_item(item, item_stats=item_stats) for item in items)


def classify_item(
    item: GearItem,
    *,
    item_stats: ItemStatsIndex | None = None,
) -> ClassifiedItem:
    server_equipment = _server_equipment_for(item, item_stats)
    weapon_stats = item_stats.weapon_stats_for_item_id(item.id) if item_stats is not None else None
    slot_family = slot_family_for(item, item_stats=item_stats)
    weapon_family = weapon_family_for(item, item_stats=item_stats)
    exclusion_reason = _combat_exclusion_reason_for(weapon_family)
    excluded = bool(exclusion_reason)
    server_mods = _server_mods_for(item, item_stats)
    pet_server_mods = _server_pet_mods_for(item, item_stats)
    server_weapon_family_reason = _server_weapon_family_reason(item, item_stats, weapon_family)
    augment_mods, pet_augment_mods = _augment_mods_for(item)

    roles: list[str] = []
    reasons: list[str] = []

    if excluded:
        roles.extend(_excluded_roles(exclusion_reason))
        reasons.append(exclusion_reason)
    else:
        if server_weapon_family_reason:
            reasons.append(server_weapon_family_reason)
        if slot_family in {"weapon", "armor", "accessory"}:
            roles.append("combat")
        if slot_family == "weapon" and weapon_family not in {"fishing_rod", "fishing_ammo", "unknown"}:
            roles.extend(("melee_offense", "weapon_skill"))
            reasons.append("Equippable combat weapon")
        if weapon_family == "dagger":
            roles.append("dagger_skill")
            reasons.append("Dagger-family weapon")
        elif weapon_family == "sword":
            roles.append("sword_skill")
            reasons.append("Sword-family weapon")
        elif weapon_family == "club":
            roles.append("club_skill")
            reasons.append("Club-family weapon")
        elif weapon_family == "staff":
            roles.append("staff_skill")
            reasons.append("Staff-family weapon")
        elif weapon_family in {"bow", "gun", "throwing", "ammo"}:
            roles.extend(("ranged_offense", "ranged_accuracy"))
            reasons.append("Ranged weapon or ammunition")
        if slot_family == "armor":
            roles.append("defense")
        stat_roles, stat_reasons = _stat_roles_for(
            item_stats,
            server_mods,
            pet_server_mods,
            augment_mods,
            pet_augment_mods,
        )
        roles.extend(stat_roles)
        reasons.extend(stat_reasons)
        if "evasion" in stat_roles:
            roles.append("defense")
            reasons.append("Evasion or survival item")

    roles_tuple = _unique(roles)
    tags = _tags(slot_family, weapon_family, roles_tuple, exclusion_reason)
    if not reasons:
        reasons.append("Server-data classification found no weighted combat evidence")

    return ClassifiedItem(
        item=item,
        slot_family=slot_family,
        weapon_family=weapon_family,
        roles=roles_tuple,
        tags=tags,
        excluded=excluded,
        exclusion_reason=exclusion_reason,
        reasons=tuple(reasons),
        confidence="server_data_tables",
        confidence_score=0.95 if item_stats is not None else 0.0,
        server_mods=tuple((mod.name, mod.value) for mod in server_mods),
        pet_server_mods=tuple((mod.name, mod.value) for mod in pet_server_mods),
        augment_mods=tuple((mod.name, mod.value) for mod in augment_mods),
        pet_augment_mods=tuple((mod.name, mod.value) for mod in pet_augment_mods),
        server_level=server_equipment.level if server_equipment else None,
        server_jobs_mask=server_equipment.jobs if server_equipment else None,
        server_slot_mask=server_equipment.slot_mask if server_equipment else None,
        server_removal_slot_mask=server_equipment.removal_slot_mask if server_equipment else None,
        server_weapon_subskill=weapon_stats.subskill if weapon_stats else None,
    )


def slot_family_for(
    item: GearItem,
    *,
    item_stats: ItemStatsIndex | None = None,
) -> str:
    if item_stats is not None:
        equipment = item_stats.equipment_for_item_id(item.id)
        if equipment is not None:
            return equipment.slot_family()
        if item_stats.weapon_stats_for_item_id(item.id) is not None:
            return "weapon"
    return "unknown"


def weapon_family_for(
    item: GearItem,
    *,
    item_stats: ItemStatsIndex | None = None,
) -> str:
    if item_stats is not None:
        equipment = item_stats.equipment_for_item_id(item.id)
        weapon_stats = item_stats.weapon_stats_for_item_id(item.id)
        if weapon_stats is not None and weapon_stats.skill == 48:
            if equipment is not None and equipment.has_slot("Ammo"):
                return "fishing_ammo"
            if equipment is not None and equipment.has_slot("Range"):
                return "fishing_rod"
        if equipment is not None and equipment.has_slot("Ammo"):
            server_family = item_stats.weapon_family_for_item_id(item.id)
            if server_family == "throwing":
                return server_family
            if weapon_stats is not None and _is_pet_consumable_ammo(weapon_stats):
                return "utility_ammo"
            return "ammo"
        server_family = item_stats.weapon_family_for_item_id(item.id)
        if server_family:
            return server_family
        if equipment is not None and equipment.has_slot("Sub"):
            if equipment.shield_size > 0:
                return "shield"
            if weapon_stats is not None and weapon_stats.skill == 0:
                return "grip"
    return "unknown"


def _combat_exclusion_reason_for(weapon_family: str) -> str:
    if weapon_family in {"fishing_rod", "fishing_ammo"}:
        return "Fishing"
    if weapon_family == "utility_ammo":
        return "Utility"
    return ""


def _is_pet_consumable_ammo(weapon_stats: WeaponStats) -> bool:
    if weapon_stats.skill == 255:
        return True
    return weapon_stats.skill == 0 and weapon_stats.damage >= 100


def _excluded_roles(exclusion_reason: str) -> tuple[str, ...]:
    if exclusion_reason == "Fishing":
        return ("fishing", "utility")
    if exclusion_reason == "Crafting":
        return ("crafting", "utility")
    if exclusion_reason == "Utility":
        return ("utility",)
    return tuple()


def _stat_roles_for(
    item_stats: ItemStatsIndex | None,
    server_mods: tuple[ItemMod, ...],
    pet_server_mods: tuple[ItemMod, ...],
    augment_mods: tuple[ItemMod, ...],
    pet_augment_mods: tuple[ItemMod, ...],
) -> tuple[tuple[str, ...], tuple[str, ...]]:
    roles: list[str] = []
    reasons: list[str] = []

    if item_stats is not None:
        roles.extend(item_stats.role_names_for_mods(
            server_mods + pet_server_mods + augment_mods + pet_augment_mods
        ))
        if server_mods:
            role_text = ", ".join(
                f"{mod.name}{mod.value:+d}"
                for mod in server_mods
                if mod.value != 0
            )
            if role_text:
                reasons.append(f"Server item_mods: {role_text}")
        if pet_server_mods:
            role_text = ", ".join(
                f"{mod.name}{mod.value:+d}"
                for mod in pet_server_mods
                if mod.value != 0
            )
            if role_text:
                reasons.append(f"Server item_mods_pet: {role_text}")
        if augment_mods:
            role_text = ", ".join(
                f"{mod.name}{mod.value:+d}"
                for mod in augment_mods
                if mod.value != 0
            )
            if role_text:
                reasons.append(f"Gear augments: {role_text}")
        if pet_augment_mods:
            role_text = ", ".join(
                f"{mod.name}{mod.value:+d}"
                for mod in pet_augment_mods
                if mod.value != 0
            )
            if role_text:
                reasons.append(f"Pet gear augments: {role_text}")

    return _unique(roles), tuple(reasons)


def _augment_mods_for(item: GearItem) -> tuple[tuple[ItemMod, ...], tuple[ItemMod, ...]]:
    player_values: dict[str, int] = {}
    pet_values: dict[str, int] = {}
    for augment in item.augments:
        parsed = _parse_augment_mod(augment)
        if parsed is None:
            continue

        mod_name, value, is_pet = parsed
        target = pet_values if is_pet else player_values
        target[mod_name] = target.get(mod_name, 0) + value

    return (
        tuple(ItemMod(0, name, value) for name, value in player_values.items() if value != 0),
        tuple(ItemMod(0, name, value) for name, value in pet_values.items() if value != 0),
    )


def _parse_augment_mod(augment: str) -> tuple[str, int, bool] | None:
    text = augment.replace('"', "").replace("'", "").strip()
    match = AUGMENT_VALUE_RE.match(text)
    if match is None:
        return None

    label = match.group("label").strip()
    is_pet = False
    normalized_label = label.lower()
    for prefix in ("pet:", "automaton:", "avatar:"):
        if normalized_label.startswith(prefix):
            is_pet = True
            label = label[len(prefix):].strip()
            break

    label_key = AUGMENT_LABEL_NORMALIZE_RE.sub("", label.lower())
    mod_name = AUGMENT_LABEL_MODS.get(label_key)
    if mod_name is None:
        return None
    if is_pet:
        mod_name = PET_AUGMENT_MOD_ALIASES.get(mod_name, f"PET_{mod_name}")

    sign = -1 if match.group("sign") == "-" else 1
    return mod_name, sign * int(match.group("value")), is_pet


def _server_mods_for(
    item: GearItem,
    item_stats: ItemStatsIndex | None,
) -> tuple[ItemMod, ...]:
    if item_stats is None:
        return tuple()
    return item_stats.mods_for_item_id(item.id)


def _server_pet_mods_for(
    item: GearItem,
    item_stats: ItemStatsIndex | None,
) -> tuple[ItemMod, ...]:
    if item_stats is None:
        return tuple()
    return item_stats.pet_mods_for_item_id(item.id)


def _server_equipment_for(
    item: GearItem,
    item_stats: ItemStatsIndex | None,
) -> EquipmentStats | None:
    if item_stats is None:
        return None
    return item_stats.equipment_for_item_id(item.id)


def _server_weapon_family_reason(
    item: GearItem,
    item_stats: ItemStatsIndex | None,
    weapon_family: str,
) -> str:
    if item_stats is None or weapon_family == "unknown":
        return ""
    equipment = item_stats.equipment_for_item_id(item.id)
    if equipment is not None and equipment.has_slot("Ammo") and weapon_family == "ammo":
        return "Server item_equipment slot identifies ammo family."
    weapon_stats = item_stats.weapon_stats_for_item_id(item.id)
    if weapon_stats is None:
        return ""
    return f"Server item_weapon skill {weapon_stats.skill} identifies {weapon_family} family."


def _tags(slot_family: str, weapon_family: str, roles: tuple[str, ...], exclusion_reason: str) -> tuple[str, ...]:
    tags = [f"slot:{slot_family}"]
    if weapon_family != "unknown":
        tags.append(f"family:{weapon_family}")
    tags.extend(f"role:{role}" for role in roles)
    if exclusion_reason:
        tags.append(f"exclude:{exclusion_reason}")
    return tuple(tags)


def _unique(values: Iterable[str]) -> tuple[str, ...]:
    return tuple(dict.fromkeys(value for value in values if value))
