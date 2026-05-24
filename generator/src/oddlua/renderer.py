from __future__ import annotations


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
}


def lua_quote(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


def render_lua_table(name: str, values: dict[str, str]) -> str:
    lines = [f"    {name} = {{"]
    for slot in SLOT_ORDER:
        item = values.get(slot)
        if item:
            lines.append(f"        {slot} = {lua_quote(item)},")
    lines.append("    },")
    return "\n".join(lines)


def render_profile(
    *,
    player: str,
    player_id: str,
    job: str,
    sets: dict[str, dict[str, str]],
    default_playstyle: str,
    style_intents: dict[str, str] | None = None,
) -> str:
    style_intents = style_intents or STYLE_INTENTS
    default_set_name = f"Playstyle_{default_playstyle}"
    set_blocks = "\n\n".join(
        render_lua_table(f"Playstyle_{name}", gear)
        for name, gear in sets.items()
    )
    intent_lines = "\n".join(
        f"    Playstyle_{name} = {lua_quote(style_intents.get(name, STYLE_INTENTS.get(name, 'TP')))},"
        for name in sets
    )
    style_alias_lines = "\n".join(
        f"    {name.lower()} = {lua_quote(name)},"
        for name in sets
    )
    style_names = "|".join(name.lower() for name in sets)

    return f"""local profile = {{}};

local state = {{
    Playstyle = {lua_quote(default_playstyle)},
}};

local sets = {{
{set_blocks}
}};

profile.Sets = sets;
profile.Packer = {{}};

local setIntents = {{
{intent_lines}
}};

local styleAliases = {{
{style_alias_lines}
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

local function normalize(value)
    return string.lower(tostring(value or ''));
end

local function getPlayer()
    if gData and gData.GetPlayer then
        return gData.GetPlayer();
    end
    return nil;
end

local function isEngaged(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'engaged' or status == 'attack' or status == 'attacking' or status == '1';
end

local function setNameFor(styleName)
    return 'Playstyle_' .. tostring(styleName or state.Playstyle);
end

local function equipNamedSet(setName, force)
    local set = sets[setName];
    if not set then
        return;
    end

    if force == true and scale and scale.ForceEquipSet then
        scale.ForceEquipSet(setName, set, setIntents[setName]);
    elseif force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(set);
    elseif scale and scale.EquipSet then
        scale.EquipSet(setName, set, setIntents[setName]);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(set);
    end
end

local function activeCombatStyle()
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        return {lua_quote(default_playstyle)};
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor({lua_quote(default_playstyle)}), force);
        return;
    end
    equipNamedSet(setNameFor(activeCombatStyle()), force);
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

    message('OddLua playstyle swapper loaded for {player}_{player_id}. Default style: ' .. state.Playstyle .. '. Use /lac fwd style {style_names}.');
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
            return;
        end

        message('Style=' .. state.Playstyle);
        equipCurrent(true);
    elseif command == 'status' then
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle());
    end
end

profile.HandleDefault = function()
    equipCurrent(false);
end

profile.HandleAbility = function()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    local active = activeCombatStyle();
    local activeSet = setNameFor(active);
    if sets[activeSet] then
        equipNamedSet(activeSet, false);
    elseif sets.{default_set_name} then
        equipNamedSet({lua_quote(default_set_name)}, false);
    end
end

return profile;
"""
