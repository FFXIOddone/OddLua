from __future__ import annotations

from typing import Mapping

from .subjobs import JOB_IDS, SubjobProfile


SLOT_ORDER = (
    "Main",
    "Sub",
    "Range",
    "Ammo",
    "Head",
    "Neck",
    "Ear1",
    "Ear2",
    "Body",
    "Hands",
    "Ring1",
    "Ring2",
    "Back",
    "Waist",
    "Legs",
    "Feet",
)

STYLE_INTENTS = {
    "Melt": "TP",
    "Dagger": "TP",
    "Safe": "PDT",
    "Treasure": "TP",
    "Craft": "Crafting",
    "Tank": "PDT",
    "Enmity": "Enmity",
    "Damage": "TP",
    "MagicDefense": "MDT",
    "Nuke": "Nuke",
    "MagicAccuracy": "MagicAccuracy",
    "FastCast": "FastCast",
    "IdleRefresh": "Refresh",
    "Movement": "Movement",
    "Movement_City": "Movement",
    "Movement_Night": "Movement",
    "Movement_DuskToDawn": "Movement",
    "Accuracy": "Accuracy",
    "WeaponSkill": "WS",
    "Survival": "PDT",
    "Evasion": "Evasion",
    "Cure": "Cure",
    "Enspell": "TP",
    "DrainAbsorb": "MagicAccuracy",
    "PetDamage": "PetDamage",
    "PetTank": "PetTank",
    "Song": "Song",
    "RangedDamage": "Ranged",
    "RangedAccuracy": "RangedAccuracy",
    "StoreTP": "TP",
    "Ninjutsu": "Ninjutsu",
    "Jump": "WS",
    "AvatarPerp": "Refresh",
    "BloodPact": "PetDamage",
    "SummoningMagic": "MagicAccuracy",
    "PhysicalBlue": "TP",
    "MagicalBlue": "Nuke",
    "QuickDraw": "QuickDraw",
    "Roll": "Roll",
    "Waltz": "Cure",
    "GeoMagic": "MagicAccuracy",
}

ELEMENT_SUFFIXES = (
    "Fire",
    "Ice",
    "Wind",
    "Earth",
    "Thunder",
    "Lightning",
    "Water",
    "Light",
    "Dark",
)

SEMANTIC_INTENTS = {
    "Idle": "Idle",
    "Resting": "Idle",
    "Movement": "Movement",
    "Movement_City": "Movement",
    "Movement_Night": "Movement",
    "Movement_DuskToDawn": "Movement",
    "Aftercast": "Idle",
    "PDT": "PDT",
    "MDT": "MDT",
    "Crafting": "Crafting",
    "TP": "TP",
    "Hybrid": "TP",
    "TPAccuracy": "Accuracy",
    "Precast": "FastCast",
    "FastCast": "FastCast",
    "Midcast": "MagicAccuracy",
    "Cure": "Cure",
    "Healing": "Healing",
    "Enhancing": "Enhancing",
    "EnhancingDuration": "Enhancing",
    "Stoneskin": "Enhancing",
    "Refresh": "Enhancing",
    "Regen": "Healing",
    "SneakInvisible": "Enhancing",
    "Barspell": "Enhancing",
    "Phalanx": "Enhancing",
    "Aquaveil": "Enhancing",
    "Haste": "Enhancing",
    "Enfeebling": "Enfeebling",
    "Sleep": "Enfeebling",
    "Bind": "Enfeebling",
    "Gravity": "Enfeebling",
    "Silence": "Enfeebling",
    "Slow": "Enfeebling",
    "Paralyze": "Enfeebling",
    "Blind": "Enfeebling",
    "Dispel": "Enfeebling",
    "Dia": "Enfeebling",
    "Bio": "DarkMagic",
    "Divine": "Cure",
    "Elemental": "Nuke",
    "Nuke": "Nuke",
    "DarkMagic": "DarkMagic",
    "DrainAspir": "DarkMagic",
    "Absorb": "DarkMagic",
    "Stun": "DarkMagic",
    "BlueMagic": "BlueMagic",
    "PhysicalBlueMagic": "BlueMagic",
    "MagicalBlueMagic": "Nuke",
    "Song": "Song",
    "SongDebuff": "Song",
    "SongBuff": "Song",
    "Geomancy": "MagicAccuracy",
    "Summoning": "MagicAccuracy",
    "BloodPactRage": "PetDamage",
    "BloodPactWard": "PetTank",
    "AvatarPerp": "Refresh",
    "Ninjutsu": "Ninjutsu",
    "Utsusemi": "FastCast",
    "NinjutsuEnfeeble": "Ninjutsu",
    "Snapshot": "RangedPreshot",
    "RangedPreshot": "RangedPreshot",
    "Ranged": "RangedAccuracy",
    "RangedMidshot": "RangedAccuracy",
    "RangedAccuracy": "RangedAccuracy",
    "RangedAttack": "RangedAttack",
    "QuickDraw": "QuickDraw",
    "Weaponskill": "Weaponskill",
    "WeaponSkillAccuracy": "Weaponskill",
    "WSElemental": "Weaponskill",
    "JobAbility": "TP",
    "Enmity": "Enmity",
    "Waltz": "Cure",
    "Steps": "Accuracy",
    "Samba": "TP",
    "Jump": "Weaponskill",
    "PetReady": "PetDamage",
    "PetMagic": "PetDamage",
    "PetTank": "PetTank",
    "Roll": "Roll",
}

SEMANTIC_SET_PREFERENCES = {
    "Idle": (
        "IdleRefresh",
        "AvatarPerp",
        "Safe",
        "Survival",
        "Evasion",
        "PetTank",
        "Tank",
        "MagicDefense",
        "FastCast",
        "Cure",
    ),
    "Resting": ("IdleRefresh", "AvatarPerp", "Cure", "FastCast", "MagicAccuracy"),
    "Movement": ("Movement",),
    "Movement_City": ("Movement_City", "Movement"),
    "Movement_Night": ("Movement_Night", "Movement"),
    "Movement_DuskToDawn": ("Movement_DuskToDawn", "Movement"),
    "Aftercast": ("IdleRefresh", "Safe", "Survival", "Evasion", "MagicDefense", "FastCast", "Cure"),
    "PDT": ("Safe", "Survival", "Evasion", "PetTank", "Tank", "MagicDefense"),
    "MDT": ("MagicDefense", "Safe", "Survival", "Tank", "IdleRefresh", "AvatarPerp"),
    "Crafting": ("Craft",),
    "TP": (
        "Melt",
        "Damage",
        "Enspell",
        "PhysicalBlue",
        "Accuracy",
        "StoreTP",
        "RangedDamage",
        "Tank",
    ),
    "Hybrid": ("Survival", "Evasion", "Safe", "Tank", "Damage", "Accuracy"),
    "TPAccuracy": ("Accuracy", "Dagger", "RangedAccuracy", "MagicAccuracy", "Damage"),
    "Precast": ("FastCast", "Ninjutsu", "Song", "GeoMagic", "MagicAccuracy"),
    "FastCast": ("FastCast", "Ninjutsu", "Song", "GeoMagic", "MagicAccuracy"),
    "Midcast": ("MagicAccuracy", "Nuke", "MagicalBlue", "GeoMagic", "FastCast"),
    "Cure": ("Cure", "Waltz", "FastCast", "IdleRefresh"),
    "Healing": ("Cure", "Waltz", "FastCast", "IdleRefresh"),
    "Enhancing": ("FastCast", "Cure", "MagicAccuracy", "GeoMagic"),
    "EnhancingDuration": ("FastCast", "Cure", "MagicAccuracy", "GeoMagic"),
    "Stoneskin": ("Cure", "MagicAccuracy", "FastCast", "IdleRefresh"),
    "Refresh": ("IdleRefresh", "FastCast", "MagicAccuracy", "Cure"),
    "Regen": ("Cure", "IdleRefresh", "FastCast"),
    "SneakInvisible": ("FastCast", "IdleRefresh", "MagicAccuracy"),
    "Barspell": ("MagicDefense", "Cure", "FastCast"),
    "Phalanx": ("MagicDefense", "Cure", "FastCast"),
    "Aquaveil": ("FastCast", "Cure", "MagicAccuracy"),
    "Haste": ("FastCast", "Cure", "MagicAccuracy"),
    "Enfeebling": ("MagicAccuracy", "GeoMagic", "Ninjutsu", "Song", "FastCast"),
    "Sleep": ("MagicAccuracy", "DrainAbsorb", "Ninjutsu", "FastCast"),
    "Bind": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Gravity": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Silence": ("MagicAccuracy", "Song", "FastCast"),
    "Slow": ("MagicAccuracy", "FastCast"),
    "Paralyze": ("MagicAccuracy", "FastCast"),
    "Blind": ("MagicAccuracy", "Ninjutsu", "FastCast"),
    "Dispel": ("MagicAccuracy", "FastCast"),
    "Dia": ("MagicAccuracy", "Cure", "FastCast"),
    "Bio": ("DrainAbsorb", "MagicAccuracy", "FastCast"),
    "Divine": ("Nuke", "Cure", "MagicAccuracy", "FastCast"),
    "Elemental": ("Nuke", "MagicalBlue", "GeoMagic", "QuickDraw", "MagicAccuracy", "FastCast"),
    "Nuke": ("Nuke", "MagicalBlue", "GeoMagic", "QuickDraw", "MagicAccuracy", "FastCast"),
    "DarkMagic": ("DrainAbsorb", "MagicAccuracy", "Nuke", "FastCast"),
    "DrainAspir": ("DrainAbsorb", "MagicAccuracy", "Nuke", "FastCast"),
    "Absorb": ("DrainAbsorb", "MagicAccuracy", "FastCast"),
    "Stun": ("MagicAccuracy", "DrainAbsorb", "FastCast"),
    "BlueMagic": ("PhysicalBlue", "MagicalBlue", "Accuracy", "FastCast"),
    "PhysicalBlueMagic": ("PhysicalBlue", "Accuracy", "FastCast"),
    "MagicalBlueMagic": ("MagicalBlue", "Nuke", "MagicAccuracy", "FastCast"),
    "Song": ("Song", "MagicAccuracy", "FastCast"),
    "SongDebuff": ("Song", "MagicAccuracy", "FastCast"),
    "SongBuff": ("Song", "FastCast", "IdleRefresh"),
    "Geomancy": ("GeoMagic", "MagicAccuracy", "FastCast"),
    "Summoning": ("SummoningMagic", "BloodPact", "AvatarPerp", "FastCast"),
    "BloodPactRage": ("BloodPact", "PetDamage", "SummoningMagic", "FastCast"),
    "BloodPactWard": ("SummoningMagic", "PetTank", "AvatarPerp", "FastCast"),
    "AvatarPerp": ("AvatarPerp", "IdleRefresh", "SummoningMagic"),
    "Ninjutsu": ("Ninjutsu", "MagicAccuracy", "FastCast", "Evasion"),
    "Utsusemi": ("FastCast", "Ninjutsu", "Evasion"),
    "NinjutsuEnfeeble": ("Ninjutsu", "MagicAccuracy", "FastCast"),
    "Snapshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "RangedPreshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "Ranged": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Roll"),
    "RangedMidshot": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Accuracy"),
    "RangedAccuracy": ("RangedAccuracy", "RangedDamage", "QuickDraw", "Accuracy"),
    "RangedAttack": ("RangedDamage", "RangedAccuracy", "QuickDraw"),
    "QuickDraw": ("QuickDraw", "MagicAccuracy", "Nuke", "RangedAccuracy"),
    "Weaponskill": (
        "WeaponSkill",
        "Jump",
        "StoreTP",
        "Damage",
        "Melt",
        "Enspell",
        "RangedDamage",
        "Accuracy",
        "PhysicalBlue",
    ),
    "WeaponSkillAccuracy": ("WeaponSkill", "Accuracy", "StoreTP", "RangedAccuracy", "Damage"),
    "WSElemental": ("Nuke", "MagicalBlue", "QuickDraw", "WeaponSkill", "MagicAccuracy"),
    "JobAbility": ("Enmity", "Jump", "Roll", "Waltz", "PetDamage", "Tank"),
    "Enmity": ("Enmity", "Tank", "MagicDefense", "FastCast"),
    "Waltz": ("Waltz", "Cure", "Evasion"),
    "Steps": ("Accuracy", "Damage", "Evasion"),
    "Samba": ("Damage", "Accuracy", "StoreTP"),
    "Jump": ("Jump", "WeaponSkill", "Accuracy", "Damage"),
    "PetReady": ("PetDamage", "PetTank", "Damage"),
    "PetMagic": ("PetDamage", "MagicAccuracy", "Nuke"),
    "PetTank": ("PetTank", "Survival", "Tank"),
    "Roll": ("Roll", "RangedAccuracy", "QuickDraw", "FastCast"),
}

for _element in ELEMENT_SUFFIXES:
    SEMANTIC_INTENTS[f"Elemental_{_element}"] = "Nuke"
    SEMANTIC_INTENTS[f"Weather_{_element}"] = "Nuke"
    SEMANTIC_INTENTS[f"Day_{_element}"] = "Nuke"
    SEMANTIC_SET_PREFERENCES[f"Elemental_{_element}"] = (
        f"Elemental_{_element}",
        "Nuke",
        "MagicalBlue",
        "GeoMagic",
        "QuickDraw",
        "MagicAccuracy",
    )
    SEMANTIC_SET_PREFERENCES[f"Weather_{_element}"] = (
        f"Weather_{_element}",
        f"Elemental_{_element}",
        "Nuke",
        "MagicalBlue",
        "GeoMagic",
        "QuickDraw",
        "MagicAccuracy",
        "FastCast",
    )
    SEMANTIC_SET_PREFERENCES[f"Day_{_element}"] = (
        f"Day_{_element}",
        f"Elemental_{_element}",
        "Nuke",
        "MagicalBlue",
        "GeoMagic",
        "QuickDraw",
        "MagicAccuracy",
        "FastCast",
    )


def lua_quote(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


def render_lua_table(name: str, values: dict[str, str]) -> str:
    lines = [f"    {name} = {{"]
    if not values:
        for slot in SLOT_ORDER:
            lines.append(f"        {slot} = 'remove',")
    else:
        for slot in SLOT_ORDER:
            item = values.get(slot)
            if item:
                lines.append(f"        {slot} = {lua_quote(item)},")
    lines.append("    },")
    return "\n".join(lines)


def derive_semantic_sets(
    sets: Mapping[str, dict[str, str]],
    default_playstyle: str,
) -> dict[str, dict[str, str]]:
    semantic_sets: dict[str, dict[str, str]] = {}
    for semantic_name in SEMANTIC_SET_PREFERENCES:
        semantic_sets[semantic_name] = dict(sets.get(semantic_name) or {})
    return semantic_sets


def render_subjob_profiles(profiles: Mapping[str, SubjobProfile]) -> str:
    if not profiles:
        return "local subjobs = {};"

    lines = ["local subjobs = {"]
    for abbr, profile in profiles.items():
        lines.append(f"    {abbr} = {{")
        lines.append(f"        level = {profile.level},")
        lines.append("        capabilities = {")
        for capability in profile.capabilities:
            lines.append(f"            {lua_quote(capability)},")
        lines.append("        },")
        lines.append("        abilities = {")
        for ability in profile.abilities:
            lines.append(
                "            "
                f"{{ name = {lua_quote(ability.name)}, level = {ability.level}, "
                f"recast = {ability.recast_time}, recastId = {ability.recast_id}, "
                f"ce = {ability.ce}, ve = {ability.ve} }},"
            )
        lines.append("        },")
        lines.append("        traits = {")
        for trait in profile.traits:
            lines.append(
                "            "
                f"{{ name = {lua_quote(trait.name)}, level = {trait.level}, rank = {trait.rank}, "
                f"mod = {lua_quote(trait.mod_name)}, value = {trait.value} }},"
            )
        lines.append("        },")
        lines.append("        spells = {")
        for spell in profile.spells:
            lines.append(
                "            "
                f"{{ name = {lua_quote(spell.name)}, level = {spell.level}, mp = {spell.mp_cost}, "
                f"cast = {spell.cast_time}, recast = {spell.recast_time} }},"
            )
        lines.append("        },")
        lines.append("    },")
    lines.append("};")
    return "\n".join(lines)


def render_job_id_table() -> str:
    lines = ["local jobIdToAbbr = {"]
    for abbr, job_id in JOB_IDS.items():
        lines.append(f"    [{job_id}] = {lua_quote(abbr)},")
    lines.append("};")
    return "\n".join(lines)


def render_profile(
    *,
    player: str,
    player_id: str,
    job: str,
    sets: dict[str, dict[str, str]],
    default_playstyle: str,
    playstyle_names: tuple[str, ...] | None = None,
    style_intents: dict[str, str] | None = None,
    subjob_profiles: Mapping[str, SubjobProfile] | None = None,
    default_subjob: str = "",
) -> str:
    style_intents = style_intents or STYLE_INTENTS
    subjob_profiles = subjob_profiles or {}
    default_subjob = default_subjob.upper()
    playstyle_names = playstyle_names or tuple(sets)
    default_set_name = f"Playstyle_{default_playstyle}"
    semantic_sets = derive_semantic_sets(sets, default_playstyle)
    playstyle_sets = {
        name: sets[name]
        for name in playstyle_names
        if name in sets
    }
    exact_sets = dict(sets)
    rendered_sets = {
        **{f"Playstyle_{name}": gear for name, gear in playstyle_sets.items()},
        **exact_sets,
        **semantic_sets,
    }
    rendered_intents = {
        **{
            name: style_intents.get(name, STYLE_INTENTS.get(name, SEMANTIC_INTENTS.get(name, "TP")))
            for name in exact_sets
        },
        **{
            f"Playstyle_{name}": style_intents.get(name, STYLE_INTENTS.get(name, "TP"))
            for name in playstyle_sets
        },
        **SEMANTIC_INTENTS,
    }
    set_blocks = "\n\n".join(
        render_lua_table(name, gear)
        for name, gear in rendered_sets.items()
    )
    intent_lines = "\n".join(
        f"    {name} = {lua_quote(rendered_intents.get(name, 'Idle'))},"
        for name in rendered_sets
    )
    style_alias_lines = "\n".join(
        f"    {name.lower()} = {lua_quote(name)},"
        for name in playstyle_sets
    )
    style_names = "|".join(name.lower() for name in playstyle_sets)
    subjob_block = render_subjob_profiles(subjob_profiles)
    job_id_block = render_job_id_table()
    subjob_load_message = (
        f"Configured default Subjob={default_subjob}. Use /lac fwd subjob for level-37 capabilities."
        if default_subjob
        else "Use /lac fwd subjob for level-37 subjob capabilities."
    )

    return f"""local profile = {{}};

local state = {{
    Playstyle = {lua_quote(default_playstyle)},
    WarpRingLocked = false,
    WarpUsePending = false,
    WarpClearPending = false,
    WarpUseAt = nil,
    WarpClearAt = nil,
}};

local sets = {{
{set_blocks}
}};

profile.Sets = sets;
profile.Packer = {{}};

{subjob_block}

profile.Subjobs = subjobs;

{job_id_block}

local setIntents = {{
{intent_lines}
}};

local styleAliases = {{
{style_alias_lines}
}};

local dangerousStatusBuffs = {{
    bind = true,
    doom = true,
    ['gradual petrification'] = true,
    petrification = true,
    sleep = true,
    stun = true,
    terror = true,
}};

local dangerousStatusIds = {{ 2, 7, 10, 11, 15, 18, 19, 28 }};

local cityZoneIds = {{
    [26] = true,  -- Tavnazian Safehold
    [48] = true,  -- Al Zahbi
    [50] = true,  -- Aht Urhgan Whitegate
    [53] = true,  -- Nashmau
    [80] = true,  -- Southern San d'Oria [S]
    [87] = true,  -- Bastok Markets [S]
    [94] = true,  -- Windurst Waters [S]
    [230] = true, -- Southern San d'Oria
    [231] = true, -- Northern San d'Oria
    [232] = true, -- Port San d'Oria
    [233] = true, -- Chateau d'Oraguille
    [234] = true, -- Bastok Mines
    [235] = true, -- Bastok Markets
    [236] = true, -- Port Bastok
    [237] = true, -- Metalworks
    [238] = true, -- Windurst Waters
    [239] = true, -- Windurst Walls
    [240] = true, -- Port Windurst
    [241] = true, -- Windurst Woods
    [242] = true, -- Heavens Tower
    [243] = true, -- Ru'Lude Gardens
    [244] = true, -- Upper Jeuno
    [245] = true, -- Lower Jeuno
    [246] = true, -- Port Jeuno
    [247] = true, -- Rabao
    [248] = true, -- Selbina
    [249] = true, -- Mhaura
    [250] = true, -- Kazham
    [252] = true, -- Norg
    [256] = true, -- Western Adoulin
    [257] = true, -- Eastern Adoulin
}};

local cityAreas = {{
    ["southern san d'oria"] = true,
    ["northern san d'oria"] = true,
    ["port san d'oria"] = true,
    ["chateau d'oraguille"] = true,
    ["bastok mines"] = true,
    ["bastok markets"] = true,
    ["port bastok"] = true,
    ["metalworks"] = true,
    ["windurst waters"] = true,
    ["windurst walls"] = true,
    ["port windurst"] = true,
    ["windurst woods"] = true,
    ["heavens tower"] = true,
    ["ru'lude gardens"] = true,
    ["upper jeuno"] = true,
    ["lower jeuno"] = true,
    ["port jeuno"] = true,
    ["aht urhgan whitegate"] = true,
    ["al zahbi"] = true,
    ["nashmau"] = true,
    ["tavnazian safehold"] = true,
    ["rabao"] = true,
    ["selbina"] = true,
    ["mhaura"] = true,
    ["norg"] = true,
    ["kazham"] = true,
    ["western adoulin"] = true,
    ["eastern adoulin"] = true,
    ["residential area"] = true,
    ["southern san d'oria [s]"] = true,
    ["bastok markets [s]"] = true,
    ["windurst waters [s]"] = true,
}};

local equipmentSlots = {{
    'Main',
    'Sub',
    'Range',
    'Ammo',
    'Head',
    'Neck',
    'Ear1',
    'Ear2',
    'Body',
    'Hands',
    'Ring1',
    'Ring2',
    'Back',
    'Waist',
    'Legs',
    'Feet',
}};

local scale = nil;
if gFunc and gFunc.LoadFile then
    local ok, loaded = pcall(function()
        return gFunc.LoadFile('common/scale.lua');
    end);
    if ok then
        scale = loaded;
    end
end

local function message(text)
    text = '[{player} {job}] ' .. tostring(text or '');
    if gFunc and gFunc.Message then
        gFunc.Message(text);
    else
        print(text);
    end
end

local function queueTypedCommand(command, mode)
    if not AshitaCore or not AshitaCore.GetChatManager then
        return false;
    end

    local chatManager = AshitaCore:GetChatManager();
    if not chatManager or not chatManager.QueueCommand then
        return false;
    end

    local ok = pcall(function()
        chatManager:QueueCommand(mode or 1, command);
    end);
    return ok == true;
end

local function nowSeconds()
    if os and os.time then
        return os.time();
    elseif os and os.clock then
        return os.clock();
    end
    return 0;
end

local function scheduleTask(delay, callback)
    if ashita and ashita.tasks and ashita.tasks.once then
        local ok = pcall(function()
            ashita.tasks.once(delay, callback);
        end);
        return ok == true;
    end
    return false;
end

local function normalize(value)
    return string.lower(tostring(value or ''));
end

local function getPlayer()
    if gData and gData.GetPlayer then
        return gData.GetPlayer();
    end
    return nil;
end

local function getAction()
    if gData and gData.GetAction then
        return gData.GetAction();
    end
    return nil;
end

local function getEnvironment()
    if gData and gData.GetEnvironment then
        local ok, environment = pcall(gData.GetEnvironment);
        if ok then
            if environment and AshitaCore and AshitaCore.GetMemoryManager then
                local okZone, zoneId = pcall(function()
                    return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
                end);
                if okZone then
                    environment.ZoneId = zoneId;
                end
            end
            return environment;
        end
    end
    return nil;
end

local function truthy(value)
    if value == true then
        return true;
    end
    local text = normalize(value);
    return text == 'true' or text == '1' or text == 'yes';
end

local function environmentHour(environment)
    if not environment then
        return nil;
    end

    local timestamp = environment.Timestamp or environment.timestamp;
    if type(timestamp) == 'table' then
        local hour = tonumber(timestamp.hour or timestamp.Hour);
        if hour then
            return hour;
        end
    end

    local hour = tonumber(environment.Hour or environment.hour or environment.VanaHour or environment.vanaHour);
    if hour then
        return hour;
    end

    local time = tonumber(environment.Time or environment.time or environment.VanaTime or environment.vanaTime);
    if time then
        return math.floor(time);
    end
    return nil;
end

local function isCity(environment)
    if not environment then
        return false;
    end

    if truthy(environment.inCity or environment.InCity or environment.city or environment.City) then
        return true;
    end

    local zoneId = tonumber(environment.ZoneId or environment.zoneId or environment.Zone or environment.zone);
    if zoneId and cityZoneIds[zoneId] then
        return true;
    end

    local area = normalize(environment.Area or environment.area or environment.ZoneName or environment.zoneName);
    return cityAreas[area] == true;
end

local function isNight(environment)
    local hour = environmentHour(environment);
    if hour == nil then
        return false;
    end
    return hour >= 20 or hour < 4;
end

local function isDuskToDawn(environment)
    local hour = environmentHour(environment);
    if hour == nil then
        return false;
    end
    return hour >= 18 or hour < 6;
end

local function getBuffCount(name)
    if not gData or not gData.GetBuffCount then
        return 0;
    end

    local ok, count = pcall(gData.GetBuffCount, name);
    if ok and type(count) == 'number' then
        return count;
    end
    return 0;
end

local function hasDangerousStatus()
    for name in pairs(dangerousStatusBuffs) do
        if getBuffCount(name) > 0 then
            return true;
        end
    end
    for _, id in ipairs(dangerousStatusIds) do
        if getBuffCount(id) > 0 then
            return true;
        end
    end
    return false;
end

local function activeSubjob()
    local player = getPlayer();
    if player then
        local subjob = player.SubJob or player.subJob or player.Subjob or player.subjob or player.SubJobName or player.subJobName;
        if subjob and tostring(subjob) ~= '' then
            local numeric = tonumber(subjob);
            if numeric and jobIdToAbbr[numeric] then
                return jobIdToAbbr[numeric];
            end
            return string.upper(tostring(subjob));
        end
    end
    return {lua_quote(default_subjob)};
end

local function currentSubjobProfile()
    local subjob = activeSubjob();
    return subjobs[subjob], subjob;
end

local function hasSubjobCapability(capability)
    local subjob = currentSubjobProfile();
    if not subjob or not capability then
        return false;
    end
    local wanted = normalize(capability);
    for _, value in ipairs(subjob.capabilities or {{}}) do
        if normalize(value) == wanted then
            return true;
        end
    end
    return false;
end

profile.HasSubjobCapability = hasSubjobCapability;

local function summarizeSubjobEntries(entries, label)
    local parts = {{}};
    for _, entry in ipairs(entries or {{}}) do
        local text = tostring(entry.name or '');
        if entry.level then
            text = text .. '@' .. tostring(entry.level);
        end
        if entry.mod and entry.value then
            text = text .. '(' .. tostring(entry.mod) .. tostring(entry.value) .. ')';
        end
        table.insert(parts, text);
    end
    if #parts == 0 then
        return label .. '=none';
    end
    return label .. '=' .. table.concat(parts, ',');
end

local function isEngaged(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'engaged' or status == 'attack' or status == 'attacking' or status == '1';
end

local function isResting(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'resting' or status == 'healing' or status == '33' or status == '34';
end

local function playerHpp(player)
    if not player then
        return nil;
    end

    local hpp = player.HPP or player.hpp or player.HPPercent or player.hpPercent or player.HPPercentage or player.hpPercentage;
    if hpp then
        return tonumber(hpp);
    end

    local hp = tonumber(player.HP or player.hp);
    local maxHp = tonumber(player.MaxHP or player.maxHP);
    if hp and maxHp and maxHp > 0 then
        return (hp / maxHp) * 100;
    end
    return nil;
end

local function isEmergencyHp(player)
    local hpp = playerHpp(player);
    return hpp ~= nil and hpp <= 35;
end

local function setNameFor(styleName)
    return 'Playstyle_' .. tostring(styleName or state.Playstyle);
end

local function isClearSet(set)
    if type(set) ~= 'table' then
        return false;
    end

    for _, slot in ipairs(equipmentSlots) do
        local item = set[slot];
        if item == nil then
            return false;
        end

        if type(item) == 'string' then
            if normalize(item) ~= 'remove' then
                return false;
            end
        elseif type(item) == 'table' then
            if normalize(item.Name or item.name) ~= 'remove' then
                return false;
            end
        else
            return false;
        end
    end

    return true;
end

local function applyWarpRingLock(set)
    if state.WarpRingLocked ~= true or type(set) ~= 'table' then
        return set;
    end

    local lockedSet = {{}};
    for slot, item in pairs(set) do
        lockedSet[slot] = item;
    end
    lockedSet.Ring2 = 'Warp Ring';
    return lockedSet;
end

local function equipNamedSet(setName, force)
    local set = sets[setName];
    if not set then
        return false;
    end

    if state.WarpRingLocked == true then
        local lockedSet = applyWarpRingLock(set);
        if force == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(lockedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(lockedSet);
        end
        return true;
    end

    if isClearSet(set) then
        if force == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(set);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(set);
        end
    elseif force == true and scale and scale.ForceEquipSet then
        scale.ForceEquipSet(setName, set, setIntents[setName]);
    elseif force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(set);
    elseif scale and scale.EquipSet then
        scale.EquipSet(setName, set, setIntents[setName]);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(set);
    end
    return true;
end

local function equipNamedSetIfNotClear(setName, force)
    local set = sets[setName];
    if not set or isClearSet(set) then
        return false;
    end
    return equipNamedSet(setName, force);
end

local function forceEquipInlineSet(set, ignoreWarpRingLock)
    if type(set) ~= 'table' then
        return false;
    end

    local setToEquip = set;
    if ignoreWarpRingLock ~= true then
        setToEquip = applyWarpRingLock(set);
    end

    if gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(setToEquip);
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(setToEquip);
        return true;
    end
    return false;
end

local function clearWarpRing()
    state.WarpRingLocked = false;
    state.WarpUsePending = false;
    state.WarpClearPending = false;
    state.WarpUseAt = nil;
    state.WarpClearAt = nil;

    if forceEquipInlineSet({{ Ring2 = 'remove' }}, true) then
        message('Warp Ring removed from Ring2.');
    else
        message('Warp Ring cleanup failed: unable to force Ring2 remove.');
    end
end

local function processWarpRingTimers()
    local handled = false;
    local now = nowSeconds();

    if state.WarpRingLocked == true and state.WarpUsePending == true and state.WarpUseAt and now >= state.WarpUseAt then
        handled = true;
        state.WarpUsePending = false;
        forceEquipInlineSet({{ Ring2 = 'Warp Ring' }});
        local useQueued = queueTypedCommand('/item "Warp Ring" <me>', 1);
        if useQueued then
            message('Warp Ring use queued after 9 seconds.');
        else
            message('Warp Ring use failed: unable to queue item command.');
        end
    end

    if state.WarpClearPending == true and state.WarpClearAt and now >= state.WarpClearAt then
        handled = true;
        clearWarpRing();
    end

    return handled;
end

local function useWarpRing()
    state.WarpRingLocked = true;
    if not forceEquipInlineSet({{ Ring2 = 'Warp Ring' }}) then
        state.WarpRingLocked = false;
        message('Warp Ring equip failed: unable to force Ring2.');
        return;
    end

    local now = nowSeconds();
    state.WarpUsePending = true;
    state.WarpClearPending = true;
    state.WarpUseAt = now + 9;
    state.WarpClearAt = now + 30;

    local useScheduled = scheduleTask(9, processWarpRingTimers);
    local cleanupScheduled = scheduleTask(30, processWarpRingTimers);
    if useScheduled and cleanupScheduled then
        message('Warp Ring armed: Ring2 locked; use in 9 seconds; Ring2 cleanup at 30 seconds.');
    else
        message('Warp Ring armed with default-tick fallback: Ring2 locked; use in 9 seconds; Ring2 cleanup at 30 seconds.');
    end
end

local function equipFirstAvailable(setNames, force)
    for _, setName in ipairs(setNames or {{}}) do
        if setName and equipNamedSet(setName, force) then
            return true;
        end
    end
    return false;
end

local function canonicalElement(element)
    local value = normalize(element);
    if value == 'fire' then
        return 'Fire';
    elseif value == 'ice' then
        return 'Ice';
    elseif value == 'wind' then
        return 'Wind';
    elseif value == 'earth' then
        return 'Earth';
    elseif value == 'thunder' or value == 'lightning' then
        return 'Thunder';
    elseif value == 'water' then
        return 'Water';
    elseif value == 'light' then
        return 'Light';
    elseif value == 'dark' then
        return 'Dark';
    end
    return nil;
end

local function elementMatches(left, right)
    local leftElement = canonicalElement(left);
    local rightElement = canonicalElement(right);
    return leftElement ~= nil and rightElement ~= nil and leftElement == rightElement;
end

local function setNameForElement(prefix, element)
    local canonical = canonicalElement(element);
    if not canonical then
        return nil;
    end

    local setName = tostring(prefix or '') .. '_' .. canonical;
    if sets[setName] then
        return setName;
    end

    if canonical == 'Thunder' then
        local lightningName = tostring(prefix or '') .. '_Lightning';
        if sets[lightningName] then
            return lightningName;
        end
    end

    return nil;
end

local function activeCombatStyle()
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        return {lua_quote(default_playstyle)};
    end
    return state.Playstyle;
end

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor({lua_quote(default_playstyle)}), force) then
            return true;
        end
        return equipNamedSet('TP', force);
    end

    local activeSet = setNameFor(activeCombatStyle());
    if equipNamedSet(activeSet, force) then
        return true;
    end
    if equipNamedSet('TP', force) then
        return true;
    end
    return equipNamedSet({lua_quote(default_set_name)}, force);
end

local function equipMovement(environment, force)
    local equipped = false;

    if equipNamedSetIfNotClear('Movement', force) then
        equipped = true;
    end
    if isCity(environment) and equipNamedSetIfNotClear('Movement_City', force) then
        equipped = true;
    end
    if isNight(environment) and equipNamedSetIfNotClear('Movement_Night', force) then
        equipped = true;
    end
    if isDuskToDawn(environment) and equipNamedSetIfNotClear('Movement_DuskToDawn', force) then
        equipped = true;
    end

    return equipped;
end

local function equipIdleState(player, force)
    if isClearSet(sets['Aftercast']) then
        equipNamedSet('Aftercast', force);
        return true;
    end

    local equipped = equipNamedSetIfNotClear('Aftercast', force);
    if not equipped then
        if isClearSet(sets['Idle']) then
            equipNamedSet('Idle', force);
            return true;
        end
        equipped = equipNamedSetIfNotClear('Idle', force);
    end

    equipMovement(getEnvironment(), force);
    if equipped then
        return true;
    end
    return equipNamedSet('Idle', force);
end

local function equipDefaultForPlayer(player, force)
    if hasDangerousStatus() then
        equipNamedSet('PDT', force);
    elseif player and isEngaged(player) and isEmergencyHp(player) then
        equipNamedSet('PDT', force);
    elseif player and isEngaged(player) then
        equipCombatStyle(force);
    elseif state.Playstyle == 'Craft' then
        if not equipNamedSet('Crafting', force) then
            equipNamedSet('Idle', force);
        end
    elseif player and isResting(player) then
        equipNamedSet('Resting', force);
    else
        equipIdleState(player, force);
    end
end

local function equipBlueMagic()
    local active = activeCombatStyle();
    if active == 'MagicalBlue' and equipNamedSet('Playstyle_MagicalBlue', false) then
        return;
    elseif active == 'PhysicalBlue' and equipNamedSet('Playstyle_PhysicalBlue', false) then
        return;
    end
    equipNamedSet('BlueMagic', false);
end

local function equipElementalMagic(action)
    action = action or {{}};
    local environment = getEnvironment();
    local element = action.Element;
    local candidates = {{}};

    if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
        table.insert(candidates, setNameForElement('Weather', element));
    end
    if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
        table.insert(candidates, setNameForElement('Day', element));
    end
    table.insert(candidates, setNameForElement('Elemental', element));
    table.insert(candidates, 'Elemental');
    table.insert(candidates, 'Nuke');
    table.insert(candidates, 'Midcast');
    equipFirstAvailable(candidates, false);
end

local function equipEnhancingMagic(name)
    local value = normalize(name);
    if string.find(value, 'stoneskin', 1, true) then
        equipFirstAvailable({{ 'Stoneskin', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'refresh', 1, true) then
        equipFirstAvailable({{ 'Refresh', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'regen', 1, true) then
        equipFirstAvailable({{ 'Regen', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'sneak', 1, true) or string.find(value, 'invisible', 1, true) or string.find(value, 'deodorize', 1, true) then
        equipFirstAvailable({{ 'SneakInvisible', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'bar', 1, true) == 1 then
        equipFirstAvailable({{ 'Barspell', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'phalanx', 1, true) then
        equipFirstAvailable({{ 'Phalanx', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'aquaveil', 1, true) then
        equipFirstAvailable({{ 'Aquaveil', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    elseif string.find(value, 'haste', 1, true) then
        equipFirstAvailable({{ 'Haste', 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'EnhancingDuration', 'Enhancing', 'Midcast' }}, false);
    end
end

local function equipEnfeeblingMagic(name)
    local value = normalize(name);
    if string.find(value, 'sleep', 1, true) or string.find(value, 'lullaby', 1, true) then
        equipFirstAvailable({{ 'Sleep', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'bind', 1, true) then
        equipFirstAvailable({{ 'Bind', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'gravity', 1, true) then
        equipFirstAvailable({{ 'Gravity', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'silence', 1, true) then
        equipFirstAvailable({{ 'Silence', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'slow', 1, true) then
        equipFirstAvailable({{ 'Slow', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'paraly', 1, true) then
        equipFirstAvailable({{ 'Paralyze', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'blind', 1, true) then
        equipFirstAvailable({{ 'Blind', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'dispel', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({{ 'Dispel', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'dia', 1, true) then
        equipFirstAvailable({{ 'Dia', 'Enfeebling', 'Midcast' }}, false);
    elseif string.find(value, 'bio', 1, true) then
        equipFirstAvailable({{ 'Bio', 'DarkMagic', 'Enfeebling', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'Enfeebling', 'Midcast' }}, false);
    end
end

local function equipDarkMagic(name)
    local value = normalize(name);
    if string.find(value, 'drain', 1, true) or string.find(value, 'aspir', 1, true) then
        equipFirstAvailable({{ 'DrainAspir', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'absorb', 1, true) then
        equipFirstAvailable({{ 'Absorb', 'DarkMagic', 'Midcast' }}, false);
    elseif string.find(value, 'stun', 1, true) then
        equipFirstAvailable({{ 'Stun', 'DarkMagic', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'DarkMagic', 'Midcast' }}, false);
    end
end

local function equipSong(name)
    local value = normalize(name);
    if string.find(value, 'elegy', 1, true) or string.find(value, 'requiem', 1, true)
        or string.find(value, 'threnody', 1, true) or string.find(value, 'lullaby', 1, true)
        or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({{ 'SongDebuff', 'Song', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'SongBuff', 'Song', 'Midcast' }}, false);
    end
end

local function equipNinjutsu(name)
    local value = normalize(name);
    if string.find(value, 'utsusemi', 1, true) then
        equipFirstAvailable({{ 'Utsusemi', 'Precast', 'FastCast' }}, false);
    elseif string.find(value, 'kurayami', 1, true) or string.find(value, 'hojo', 1, true)
        or string.find(value, 'jubaku', 1, true) or string.find(value, 'dokumori', 1, true) then
        equipFirstAvailable({{ 'NinjutsuEnfeeble', 'Ninjutsu', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'Ninjutsu', 'Midcast' }}, false);
    end
end

local function equipSummoning(name)
    local value = normalize(name);
    if string.find(value, 'siphon', 1, true) then
        equipFirstAvailable({{ 'Summoning', 'AvatarPerp', 'Midcast' }}, false);
    else
        equipFirstAvailable({{ 'Summoning', 'Midcast' }}, false);
    end
end

local function equipAbility()
    local action = getAction();
    local name = normalize(action and action.Name);
    local actionType = normalize(action and action.Type);
    if actionType == 'quick draw' then
        equipFirstAvailable({{ 'QuickDraw', 'MagicAccuracy', 'Midcast' }}, false);
    elseif actionType == 'corsair roll' then
        equipFirstAvailable({{ 'Roll', 'JobAbility' }}, false);
    elseif actionType == 'blood pact: rage' then
        equipFirstAvailable({{ 'BloodPactRage', 'PetReady', 'JobAbility' }}, false);
    elseif actionType == 'blood pact: ward' then
        equipFirstAvailable({{ 'BloodPactWard', 'PetTank', 'JobAbility' }}, false);
    elseif string.find(name, 'provoke', 1, true) or string.find(name, 'sentinel', 1, true)
        or string.find(name, 'warcry', 1, true) or string.find(name, 'cover', 1, true)
        or string.find(name, 'palisade', 1, true) or string.find(name, 'flash', 1, true) then
        equipFirstAvailable({{ 'Enmity', 'JobAbility' }}, false);
    elseif string.find(name, 'waltz', 1, true) then
        equipFirstAvailable({{ 'Waltz', 'Cure', 'JobAbility' }}, false);
    elseif string.find(name, 'step', 1, true) then
        equipFirstAvailable({{ 'Steps', 'Accuracy', 'JobAbility' }}, false);
    elseif string.find(name, 'samba', 1, true) then
        equipFirstAvailable({{ 'Samba', 'TP', 'JobAbility' }}, false);
    elseif string.find(name, 'jump', 1, true) then
        equipFirstAvailable({{ 'Jump', 'Weaponskill', 'JobAbility' }}, false);
    elseif string.find(name, 'ready', 1, true) or string.find(name, 'sic', 1, true) then
        equipFirstAvailable({{ 'PetReady', 'PetDamage', 'JobAbility' }}, false);
    else
        equipNamedSet('JobAbility', false);
    end
end

local function equipWeaponskill()
    local action = getAction();
    local name = normalize(action and action.Name);
    if state.Playstyle == 'Accuracy' then
        equipFirstAvailable({{ 'WeaponSkillAccuracy', 'Weaponskill' }}, false);
    elseif string.find(name, 'aeolian', 1, true) or string.find(name, 'cyclone', 1, true)
        or string.find(name, 'energy', 1, true) or string.find(name, 'red lotus', 1, true)
        or string.find(name, 'seraph', 1, true) or string.find(name, 'sanguine', 1, true)
        or string.find(name, 'wildfire', 1, true) or string.find(name, 'leaden', 1, true)
        or string.find(name, 'jinpu', 1, true) or string.find(name, 'koki', 1, true)
        or string.find(name, 'goten', 1, true) or string.find(name, 'kagero', 1, true) then
        equipFirstAvailable({{ 'WSElemental', 'Elemental', 'Weaponskill' }}, false);
    else
        equipNamedSet('Weaponskill', false);
    end
end

profile.OnLoad = function()
    if gSettings then
        gSettings.AllowAddSet = true;
        gSettings.AllowSyncEquip = true;
    end

    if scale and scale.Configure then
        scale.Configure({{
            sets = sets,
            intents = setIntents,
            enabled = true,
            weaponLockEnabled = true,
            preferProfileItems = true,
            debug = false
        }});
    end

    message('OddLua dynamic profile loaded for {player}_{player_id}. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd style {style_names}.');
    message({lua_quote(subjob_load_message)});
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if scale and scale.HandleCommand and scale.HandleCommand(args) then
        return;
    end

    if not args or not args[1] then
        return;
    end

    local command = normalize(args[1]);
    local value = normalize(args[2]);

    if command == 'style' or command == 'playstyle' then
        if value == '' or value == 'status' then
            message('Current style: ' .. state.Playstyle .. '. Use style {style_names}.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style {style_names}.');
            return;
        end

        state.Playstyle = selected;
        if selected == 'Craft' and isEngaged(getPlayer()) then
            message('Style=Craft. Craft cannot equip while engaged.');
            equipDefaultForPlayer(getPlayer(), true);
            return;
        end

        message('Style=' .. state.Playstyle);
        equipDefaultForPlayer(getPlayer(), true);
    elseif command == 'warp' then
        useWarpRing();
    elseif command == 'warpclear' then
        clearWarpRing();
    elseif command == 'status' then
        local subjob, subjobName = currentSubjobProfile();
        local capabilityText = 'none';
        if subjob and subjob.capabilities then
            capabilityText = table.concat(subjob.capabilities, ',');
        end
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle() .. '; Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. capabilityText);
    elseif command == 'subjob' or command == 'sj' then
        local subjob, subjobName = currentSubjobProfile();
        if not subjob then
            message('Subjob=' .. tostring(subjobName or '') .. '; no configured level-37 subjob profile.');
            return;
        end
        local detail = normalize(args[2]);
        if detail == 'traits' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.traits, 'traits'));
        elseif detail == 'spells' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.spells, 'spells'));
        elseif detail == 'abilities' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.abilities, 'abilities'));
        else
            message('Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. table.concat(subjob.capabilities or {{}}, ',') .. '; use subjob traits|spells|abilities');
        end
    end
end

profile.HandleDefault = function()
    local handledWarpTimer = processWarpRingTimers();
    if handledWarpTimer and state.WarpRingLocked ~= true then
        return;
    end
    equipDefaultForPlayer(getPlayer(), false);
end

profile.HandleAbility = function()
    equipAbility();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    equipNamedSet('FastCast', false);
    equipNamedSet('Precast', false);
end

profile.HandleMidcast = function()
    local action = getAction();
    if not action then
        return;
    end

    local name = normalize(action.Name);
    local skill = normalize(action.Skill);
    if skill == 'healing magic' then
        if string.find(name, 'cure', 1, true) or string.find(name, 'curaga', 1, true) then
            equipNamedSet('Cure', false);
        else
            equipNamedSet('Healing', false);
        end
    elseif skill == 'enhancing magic' then
        equipEnhancingMagic(name);
    elseif skill == 'enfeebling magic' then
        equipEnfeeblingMagic(name);
    elseif skill == 'divine magic' then
        equipNamedSet('Divine', false);
    elseif skill == 'elemental magic' then
        equipElementalMagic(action);
    elseif skill == 'dark magic' then
        equipDarkMagic(name);
    elseif skill == 'blue magic' then
        equipBlueMagic();
    elseif skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        equipSong(name);
    elseif skill == 'geomancy' then
        equipNamedSet('Geomancy', false);
    elseif skill == 'summoning magic' or skill == 'summoning' then
        equipSummoning(name);
    elseif skill == 'ninjutsu' then
        equipNinjutsu(name);
    end
end

profile.HandlePreshot = function()
    if not equipNamedSet('Snapshot', false) then
        equipNamedSet('RangedPreshot', false);
    end
end

profile.HandleMidshot = function()
    equipFirstAvailable({{ 'RangedMidshot', 'RangedAccuracy', 'Ranged' }}, false);
end

profile.HandleWeaponskill = function()
    equipWeaponskill();
end

return profile;
"""
