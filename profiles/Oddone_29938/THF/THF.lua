local profile = {};

local state = {
    Playstyle = 'Melt',
};

local sets = {
    Playstyle_Melt = {
        Main = 'Crimson Blade',
        Sub = 'Demon\'s Knife',
        Head = 'Empress Hairpin',
        Neck = 'Peacock Charm',
        Ear1 = 'Titanis Earring',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Republic Subligar',
        Feet = 'Leaping Boots',
    },

    Playstyle_Dagger = {
        Main = 'Demon\'s Knife',
        Sub = 'Demon\'s Knife',
        Head = 'Empress Hairpin',
        Neck = 'Peacock Charm',
        Ear1 = 'Titanis Earring',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Republic Subligar',
        Feet = 'Leaping Boots',
    },

    Playstyle_Safe = {
        Main = 'Crimson Blade',
        Sub = 'Demon\'s Knife',
        Head = 'Empress Hairpin',
        Neck = 'Peacock Charm',
        Ear1 = 'Mythril Earring',
        Ear2 = 'Mythril Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Carapace Mittens',
        Ring1 = 'Venture Ring',
        Ring2 = 'Hard Leather Ring',
        Back = 'Ram Mantle',
        Waist = 'Nebimonite Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Mountain Gaiters',
    },

    Playstyle_Treasure = {
        Main = 'Crimson Blade',
        Sub = 'Demon\'s Knife',
        Head = 'Empress Hairpin',
        Neck = 'Peacock Charm',
        Ear1 = 'Titanis Earring',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Republic Subligar',
        Feet = 'Leaping Boots',
    },

    Playstyle_Craft = {
        Body = 'Carpenter\'s Apron',
        Hands = 'Carpenter\'s Gloves',
        Ring1 = 'Craftmaster\'s Ring',
        Ring2 = 'Craftmaster\'s Ring',
    },
};

profile.Sets = sets;
profile.Packer = {};

local setIntents = {
    Playstyle_Melt = 'TP',
    Playstyle_Dagger = 'TP',
    Playstyle_Safe = 'PDT',
    Playstyle_Treasure = 'TP',
    Playstyle_Craft = 'Crafting',
};

local styleAliases = {
    melt = 'Melt',
    dagger = 'Dagger',
    safe = 'Safe',
    treasure = 'Treasure',
    craft = 'Craft',
};

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
    text = '[Oddone THF] ' .. tostring(text or '');
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
        return 'Melt';
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor('Melt'), force);
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
        scale.Configure({
            sets = sets,
            intents = setIntents,
            enabled = true,
            weaponLockEnabled = true,
            preferProfileItems = true,
            debug = false
        });
    end

    message('OddLua playstyle swapper loaded for Oddone_29938. Default style: ' .. state.Playstyle .. '. Use /lac fwd style melt|dagger|safe|treasure|craft.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style melt|dagger|safe|treasure|craft.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style melt|dagger|safe|treasure|craft.');
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
    elseif sets.Playstyle_Melt then
        equipNamedSet('Playstyle_Melt', false);
    end
end

return profile;
