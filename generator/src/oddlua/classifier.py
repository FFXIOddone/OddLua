from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

from .gearexport import GearItem
from .itemstats import EquipmentStats, ItemMod, ItemStatsIndex


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
    server_level: int | None
    server_jobs_mask: int | None
    server_slot_mask: int | None
    server_removal_slot_mask: int | None

    def level_eligible(self, character_level: int) -> bool:
        if self.server_level is not None:
            return character_level > 0 and (self.server_level <= 0 or self.server_level <= character_level)
        return False

    def job_eligible(self, job: str) -> bool:
        equipment = self._server_equipment_view()
        if equipment is not None:
            return equipment.job_eligible(job)
        return False

    def slot_eligible(self, slot: str) -> bool:
        equipment = self._server_equipment_view()
        if equipment is not None:
            return equipment.has_slot(slot)
        return False

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
            "serverLevel": self.server_level,
            "serverJobsMask": self.server_jobs_mask,
            "serverSlotMask": self.server_slot_mask,
            "serverRemovalSlotMask": self.server_removal_slot_mask,
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
    slot_family = slot_family_for(item, item_stats=item_stats)
    weapon_family = weapon_family_for(item, item_stats=item_stats)
    excluded = False
    exclusion_reason = ""
    server_mods = _server_mods_for(item, item_stats)
    pet_server_mods = _server_pet_mods_for(item, item_stats)
    server_weapon_family_reason = _server_weapon_family_reason(item, item_stats, weapon_family)

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
        stat_roles, stat_reasons = _stat_roles_for(item, item_stats, server_mods, pet_server_mods)
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
        server_level=server_equipment.level if server_equipment else None,
        server_jobs_mask=server_equipment.jobs if server_equipment else None,
        server_slot_mask=server_equipment.slot_mask if server_equipment else None,
        server_removal_slot_mask=server_equipment.removal_slot_mask if server_equipment else None,
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
        server_family = item_stats.weapon_family_for_item_id(item.id)
        if server_family:
            return server_family
        equipment = item_stats.equipment_for_item_id(item.id)
        weapon_stats = item_stats.weapon_stats_for_item_id(item.id)
        if equipment is not None and equipment.has_slot("Sub"):
            if equipment.shield_size > 0:
                return "shield"
            if weapon_stats is not None and weapon_stats.skill == 0:
                return "grip"
    return "unknown"


def _excluded_roles(exclusion_reason: str) -> tuple[str, ...]:
    if exclusion_reason == "Fishing":
        return ("fishing", "utility")
    if exclusion_reason == "Crafting":
        return ("crafting", "utility")
    if exclusion_reason == "Utility":
        return ("utility",)
    return tuple()


def _stat_roles_for(
    item: GearItem,
    item_stats: ItemStatsIndex | None,
    server_mods: tuple[ItemMod, ...],
    pet_server_mods: tuple[ItemMod, ...],
) -> tuple[tuple[str, ...], tuple[str, ...]]:
    roles: list[str] = []
    reasons: list[str] = []
    explicit_roles: list[str] = []

    if item_stats is not None:
        roles.extend(item_stats.role_names_for_mods(server_mods + pet_server_mods))
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

    return _unique(roles), tuple(reasons)


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
