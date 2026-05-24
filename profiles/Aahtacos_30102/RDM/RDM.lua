local profile = {};

local state = {
    Playstyle = 'Enspell',
};

local sets = {
    Playstyle_Enspell = {
        Main = 'Baqil Staff',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Yigit Gomlek',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_MagicAccuracy = {
        Main = 'Baqil Staff',
        Sub = 'Mythril Grip',
        Head = 'Yigit Turban',
        Neck = 'Ire Torque',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Yigit Gomlek',
        Hands = 'Yigit Gages',
        Ring1 = 'Mana Ring',
        Ring2 = 'Wind Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Duelist\'s Boots',
    },

    Playstyle_FastCast = {
        Main = 'Baqil Staff',
        Sub = 'Mythril Grip',
        Head = 'Walahra Turban',
        Neck = 'Ire Torque',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Crow Jupon',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Ring2 = 'Wind Ring',
        Back = 'Aesir Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Crow Hose',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_Cure = {
        Main = 'Baqil Staff',
        Sub = 'Mythril Grip',
        Head = 'Yigit Turban',
        Neck = 'Ire Torque',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Crow Jupon',
        Hands = 'Yigit Gages',
        Ring1 = 'Mana Ring',
        Ring2 = 'Wind Ring',
        Back = 'Aesir Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Crow Hose',
        Feet = 'Duelist\'s Boots',
    },
};

profile.Sets = sets;
profile.Packer = {};

local setIntents = {
    Playstyle_Enspell = 'TP',
    Playstyle_MagicAccuracy = 'MagicAccuracy',
    Playstyle_FastCast = 'FastCast',
    Playstyle_Cure = 'Cure',
};

local styleAliases = {
    enspell = 'Enspell',
    magicaccuracy = 'MagicAccuracy',
    fastcast = 'FastCast',
    cure = 'Cure',
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
    text = '[Aahtacos RDM] ' .. tostring(text or '');
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
        return 'Enspell';
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor('Enspell'), force);
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

    message('OddLua playstyle swapper loaded for Aahtacos_30102. Default style: ' .. state.Playstyle .. '. Use /lac fwd style enspell|magicaccuracy|fastcast|cure.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style enspell|magicaccuracy|fastcast|cure.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style enspell|magicaccuracy|fastcast|cure.');
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
    elseif sets.Playstyle_Enspell then
        equipNamedSet('Playstyle_Enspell', false);
    end
end

return profile;
