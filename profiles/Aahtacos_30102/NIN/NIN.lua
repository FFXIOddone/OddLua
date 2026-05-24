local profile = {};

local state = {
    Playstyle = 'Damage',
};

local sets = {
    Playstyle_Damage = {
        Main = 'Garuda\'s Dagger',
        Sub = 'Strider Sword',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_Accuracy = {
        Main = 'Garuda\'s Dagger',
        Sub = 'Strider Sword',
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_Evasion = {
        Main = 'Garuda\'s Dagger',
        Sub = 'Strider Sword',
        Head = 'Darksteel Cap',
        Neck = 'Focus Collar',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Brigandine',
        Hands = 'Dusk Gloves',
        Ring1 = 'Hard Leather Ring',
        Ring2 = 'Wind Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_Ninjutsu = {
        Main = 'Garuda\'s Dagger',
        Sub = 'Strider Sword',
        Head = 'Super Ribbon',
        Neck = 'Goldsm. Torque',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Brigandine',
        Hands = 'Dusk Gloves',
        Ring1 = 'Wind Ring',
        Ring2 = 'Water Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },
};

profile.Sets = sets;
profile.Packer = {};

local setIntents = {
    Playstyle_Damage = 'TP',
    Playstyle_Accuracy = 'Accuracy',
    Playstyle_Evasion = 'Evasion',
    Playstyle_Ninjutsu = 'Ninjutsu',
};

local styleAliases = {
    damage = 'Damage',
    accuracy = 'Accuracy',
    evasion = 'Evasion',
    ninjutsu = 'Ninjutsu',
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
    text = '[Aahtacos NIN] ' .. tostring(text or '');
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
        return 'Damage';
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor('Damage'), force);
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

    message('OddLua playstyle swapper loaded for Aahtacos_30102. Default style: ' .. state.Playstyle .. '. Use /lac fwd style damage|accuracy|evasion|ninjutsu.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style damage|accuracy|evasion|ninjutsu.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style damage|accuracy|evasion|ninjutsu.');
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
    elseif sets.Playstyle_Damage then
        equipNamedSet('Playstyle_Damage', false);
    end
end

return profile;
