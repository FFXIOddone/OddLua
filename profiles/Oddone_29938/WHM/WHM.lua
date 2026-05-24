local profile = {};

local state = {
    Playstyle = 'Cure',
};

local sets = {
    Playstyle_Cure = {
        Main = 'Kirin\'s Pole',
        Sub = 'Reign Grip',
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape +1',
        Waist = 'Cleric\'s Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Cleric\'s Duckbills',
    },

    Playstyle_FastCast = {
        Main = 'Kirin\'s Pole',
        Sub = 'Reign Grip',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Succor Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1',
        Waist = 'Headlong Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Nashira Crackows',
    },

    Playstyle_IdleRefresh = {
        Main = 'Terra\'s Staff',
        Sub = 'Omni Grip',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Relaxing Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Succor Ring',
        Ring2 = 'Mana Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Cleric\'s Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    Playstyle_Damage = {
        Main = 'Kirin\'s Pole',
        Sub = 'Reign Grip',
        Head = 'Walahra Turban',
        Neck = 'Peacock Charm',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Brutal Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Headlong Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Nashira Crackows',
    },
};

profile.Sets = sets;
profile.Packer = {};

local setIntents = {
    Playstyle_Cure = 'Cure',
    Playstyle_FastCast = 'FastCast',
    Playstyle_IdleRefresh = 'Refresh',
    Playstyle_Damage = 'TP',
};

local styleAliases = {
    cure = 'Cure',
    fastcast = 'FastCast',
    idlerefresh = 'IdleRefresh',
    damage = 'Damage',
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
    text = '[Oddone WHM] ' .. tostring(text or '');
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
        return 'Cure';
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor('Cure'), force);
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

    message('OddLua playstyle swapper loaded for Oddone_29938. Default style: ' .. state.Playstyle .. '. Use /lac fwd style cure|fastcast|idlerefresh|damage.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style cure|fastcast|idlerefresh|damage.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style cure|fastcast|idlerefresh|damage.');
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
    elseif sets.Playstyle_Cure then
        equipNamedSet('Playstyle_Cure', false);
    end
end

return profile;
