from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Iterable

from .gearexport import GearItem
from .itemstats import ItemMod, ItemStatsIndex


ARMOR_SLOTS = {"Head", "Body", "Hands", "Legs", "Feet"}
ACCESSORY_SLOTS = {"Neck", "Ear1", "Ear2", "Ring1", "Ring2", "Back", "Waist"}
WEAPON_SLOTS = {"Main", "Sub", "Range", "Ammo"}

UTILITY_NAMES = {
    "anniversary ring",
    "chariot band",
    "dcl.grd. ring",
    "echad ring",
    "emperor band",
    "empress band",
    "instant warp",
    "sprinter's shoes",
    "warp ring",
}
UTILITY_WORDS = ("teleport", "warp", "exp bonus", "experience point", "movement speed")
FISHING_WORDS = ("fish", "fsh.", "fishing", "rod", "lure", "insect ball", "minnow", "bait")
CRAFTING_WORDS = (
    "artisan",
    "bonewrk.",
    "carpenter",
    "clothcraft",
    "craft",
    "goldsmith",
    "leathercraft",
    "smithing",
    "weaver",
    "woodworking",
)

DAGGER_WORDS = ("baselard", "beestinger", "dagger", "dirk", "jambiya", "knife", "kris", "kukri", "pugio", "stiletto")
SWORD_WORDS = ("blade", "epee", "falchion", "fleuret", "rapier", "saber", "sabre", "scimitar", "spatha", "sword", "tuck")
CLUB_WORDS = ("club", "hammer", "mace", "maul", "wand")
STAFF_WORDS = ("cane", "pole", "rod", "staff")
HAND_TO_HAND_WORDS = ("baghnakhs", "cesti", "claws", "h2h", "knuckles", "patas")
GREAT_AXE_WORDS = ("great axe", "greataxe", "labrys", "voulge")
GREAT_SWORD_WORDS = ("claymore", "great sword", "greatsword", "zweihander")
GREAT_KATANA_WORDS = ("great katana", "greatkatana", "nodachi", "odachi", "tachi")
KATANA_WORDS = ("gatana", "katana", "kunai", "ninjato", "wakizashi")
SCYTHE_WORDS = ("scythe", "sickle", "zaghnal")
POLEARM_WORDS = ("glaive", "halberd", "lance", "partisan", "spear", "trident")
AXE_WORDS = ("axe", "tabar", "tomahawk")
BOW_WORDS = ("bow", "longbow", "shortbow")
GUN_WORDS = ("arquebus", "bullet", "gun", "hexagun", "pistol", "rifle")
THROWING_WORDS = ("boomerang", "chakram", "dart", "shuriken", "throwing")
INSTRUMENT_WORDS = ("flute", "harp", "horn", "instrument", "lute")
AMMO_WORDS = ("arrow", "bolt", "bullet", "cartridge", "quiver", "shot")
STAT_ROLE_WORDS = {
    "accuracy": ("accuracy", "acc+"),
    "dex": ("dex", "dexterity"),
    "agi": ("agi", "agility"),
    "str": ("str", "strength"),
    "evasion": ("evasion", "eva+"),
}
EXACT_ITEM_ROLE_HINTS = {
    "acid kukri": ("accuracy",),
    "corrosive kukri": ("accuracy",),
    "life belt": ("accuracy",),
    "peacock charm": ("accuracy",),
    "sniper's mantle": ("accuracy",),
    "sniper's ring": ("accuracy",),
    "rajas ring": ("str", "dex"),
    "spike necklace": ("str", "dex"),
    "wing earring": ("dex", "agi"),
    "brawn earring": ("str",),
    "sun ring": ("str",),
    "crow beret": ("evasion",),
    "crow bracers": ("evasion",),
    "crow hose": ("evasion",),
    "crow jupon": ("evasion",),
    "dodge earring": ("evasion",),
    "eris' earring": ("evasion",),
    "noct brais": ("agi", "evasion"),
    "noct gaiters": ("agi", "evasion"),
}
TREASURE_WORDS = ("assassin's armlets", "raider", "rogue", "thief's knife", "treasure hunter", "vajra")
NON_STAT_RAW_KEYS = {
    "id",
    "name",
    "count",
    "level",
    "slot",
    "slots",
    "slot_mask",
    "category",
    "jobs",
    "job_mask",
    "container",
    "container_id",
    "storage",
    "index",
    "flags",
    "stack",
    "extra",
    "augment_type",
    "augment_path",
    "augment_rank",
    "augment_trial",
    "augment_trial_complete",
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

    def level_eligible(self, character_level: int) -> bool:
        if character_level <= 0:
            return False
        return self.item.level <= 0 or self.item.level <= character_level

    def job_eligible(self, job: str) -> bool:
        return self.item.has_job(job)

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
        }


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
    slot_family = slot_family_for(item)
    weapon_family = weapon_family_for(item)
    search_text = _search_text(item)
    excluded, exclusion_reason = _exclusion(search_text)
    server_mods = _server_mods_for(item, item_stats)

    roles: list[str] = []
    reasons: list[str] = []

    if excluded:
        roles.extend(_excluded_roles(exclusion_reason))
        reasons.append(exclusion_reason)
    else:
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
        stat_roles, stat_reasons = _stat_roles_for(item, item_stats, server_mods)
        roles.extend(stat_roles)
        reasons.extend(stat_reasons)
        if "evasion" in stat_roles:
            roles.append("defense")
            reasons.append("Evasion or survival item")
        if _contains_any(search_text, TREASURE_WORDS):
            roles.extend(("treasure", "farming"))
            reasons.append("Treasure Hunter or farming item")

    roles_tuple = _unique(roles)
    tags = _tags(slot_family, weapon_family, roles_tuple, exclusion_reason)
    if not reasons:
        reasons.append("Rule-based local gearexport classification")

    return ClassifiedItem(
        item=item,
        slot_family=slot_family,
        weapon_family=weapon_family,
        roles=roles_tuple,
        tags=tags,
        excluded=excluded,
        exclusion_reason=exclusion_reason,
        reasons=tuple(reasons),
        confidence="rule_based_local_gearexport",
        confidence_score=0.8 if not excluded else 0.9,
        server_mods=tuple((mod.name, mod.value) for mod in server_mods),
    )


def slot_family_for(item: GearItem) -> str:
    category = item.category.lower()
    if "craft" in category or "fishing" in category:
        return "utility"
    if "weapon" in category:
        return "weapon"
    if "armor" in category:
        return "armor"
    if "accessory" in category:
        return "accessory"

    slots = set(_split_slots(item.slot))
    if slots & WEAPON_SLOTS:
        return "weapon"
    if slots & ARMOR_SLOTS:
        return "armor"
    if slots & ACCESSORY_SLOTS:
        return "accessory"
    return "unknown"


def weapon_family_for(item: GearItem) -> str:
    text = _search_text(item)
    slot_text = item.slot.lower()
    if "ammo" in slot_text and _contains_any(text, AMMO_WORDS):
        return "ammo"
    if _contains_any(text, ("lure", "insect ball", "bait", "minnow")) and "ammo" in item.slot.lower():
        return "fishing_ammo"
    if "rod" in text and ("range" in item.slot.lower() or "fishing" in text):
        return "fishing_rod"
    if "grip" in text:
        return "grip"
    if "shield" in text:
        return "shield"
    if _contains_any(text, INSTRUMENT_WORDS):
        return "instrument"
    if _contains_any(text, HAND_TO_HAND_WORDS):
        return "hand_to_hand"
    if _contains_any(text, DAGGER_WORDS):
        return "dagger"
    if _contains_any(text, GREAT_AXE_WORDS):
        return "great_axe"
    if _contains_any(text, GREAT_SWORD_WORDS):
        return "great_sword"
    if _contains_any(text, GREAT_KATANA_WORDS):
        return "great_katana"
    if _contains_any(text, KATANA_WORDS):
        return "katana"
    if _contains_any(text, SCYTHE_WORDS):
        return "scythe"
    if _contains_any(text, POLEARM_WORDS):
        return "polearm"
    if _contains_any(text, SWORD_WORDS):
        return "sword"
    if _contains_any(text, CLUB_WORDS):
        return "club"
    if _contains_any(text, STAFF_WORDS):
        return "staff"
    if _contains_any(text, AXE_WORDS):
        return "axe"
    if _contains_any(text, BOW_WORDS):
        return "bow"
    if _contains_any(text, GUN_WORDS):
        return "gun"
    if _contains_any(text, THROWING_WORDS):
        return "throwing"
    return "unknown"


def _exclusion(search_text: str) -> tuple[bool, str]:
    name = search_text.split("\n", 1)[0]
    if name in UTILITY_NAMES or _contains_any(search_text, UTILITY_WORDS):
        return True, "Utility"
    if _contains_any(search_text, FISHING_WORDS):
        return True, "Fishing"
    if _contains_any(search_text, CRAFTING_WORDS):
        return True, "Crafting"
    return False, ""


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
) -> tuple[tuple[str, ...], tuple[str, ...]]:
    roles: list[str] = []
    reasons: list[str] = []
    explicit_roles: list[str] = []
    stat_text = _stat_text(item)

    if item_stats is not None:
        roles.extend(item_stats.role_names_for_mods(server_mods))
        if server_mods:
            role_text = ", ".join(
                f"{mod.name}{mod.value:+d}"
                for mod in server_mods
                if mod.value != 0
            )
            if role_text:
                reasons.append(f"Server item_mods: {role_text}")

    for role, words in STAT_ROLE_WORDS.items():
        if _contains_any(stat_text, words):
            explicit_roles.append(role)

    roles.extend(explicit_roles)
    if explicit_roles:
        reasons.append("Explicit stat evidence: " + ", ".join(_unique(explicit_roles)))

    if item_stats is None:
        hinted_roles = EXACT_ITEM_ROLE_HINTS.get(item.name.lower(), tuple())
        if hinted_roles:
            roles.extend(hinted_roles)
            reasons.append(f"Exact item role hint: {item.name}")

    return _unique(roles), tuple(reasons)


def _server_mods_for(
    item: GearItem,
    item_stats: ItemStatsIndex | None,
) -> tuple[ItemMod, ...]:
    if item_stats is None:
        return tuple()
    return item_stats.mods_for_item_id(item.id)


def _tags(slot_family: str, weapon_family: str, roles: tuple[str, ...], exclusion_reason: str) -> tuple[str, ...]:
    tags = [f"slot:{slot_family}"]
    if weapon_family != "unknown":
        tags.append(f"family:{weapon_family}")
    tags.extend(f"role:{role}" for role in roles)
    if exclusion_reason:
        tags.append(f"exclude:{exclusion_reason}")
    return tuple(tags)


def _search_text(item: GearItem) -> str:
    fields: list[str] = [item.name.lower(), item.category.lower(), item.augment_text.lower()]
    for key, value in item.raw_stats.items():
        if key in {"jobs", "job_mask", "container", "container_id", "index", "extra"}:
            continue
        fields.append(str(key).lower())
        fields.append(_raw_value_text(value))
    return "\n".join(field for field in fields if field)


def _stat_text(item: GearItem) -> str:
    fields: list[str] = [item.augment_text.lower()]
    for key, value in item.raw_stats.items():
        normalized_key = str(key).lower()
        if normalized_key in NON_STAT_RAW_KEYS:
            continue
        fields.append(normalized_key)
        fields.append(_raw_value_text(value))
    return "\n".join(field for field in fields if field)


def _raw_value_text(value: Any) -> str:
    if value is None:
        return ""
    return str(value).lower()


def _split_slots(slot: str) -> tuple[str, ...]:
    return tuple(part.strip() for part in slot.split("/") if part.strip())


def _contains_any(text: str, needles: Iterable[str]) -> bool:
    return any(needle in text for needle in needles)


def _unique(values: Iterable[str]) -> tuple[str, ...]:
    return tuple(dict.fromkeys(value for value in values if value))
