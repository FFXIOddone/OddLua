local profile = {};

local state = {
    Playstyle = 'PhysicalBlue',
};

local sets = {
    Playstyle_PhysicalBlue = {
        Main = 'Stormblade',
        Sub = 'Crimson Blade',
        Head = 'Walahra Turban',
        Neck = 'Peacock Charm',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Titanis Earring',
        Body = 'Homam Corazza',
        Hands = 'Alucinor Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Mirage Mantle',
        Waist = 'Headlong Belt',
        Legs = 'Homam Cosciales',
        Feet = 'Homam Gambieras',
    },

    Playstyle_MagicalBlue = {
        Main = 'Stormblade',
        Sub = 'Crimson Blade',
        Head = 'Yigit Turban',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Blood Scale Mail',
        Hands = 'Swift Gages',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Playstyle_FastCast = {
        Main = 'Stormblade',
        Sub = 'Crimson Blade',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Blood Scale Mail',
        Hands = 'Alucinor Mitts',
        Ring1 = 'Succor Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1',
        Waist = 'Headlong Belt',
        Legs = 'Homam Cosciales',
        Feet = 'Homam Gambieras',
    },

    Playstyle_Accuracy = {
        Main = 'Stormblade',
        Sub = 'Crimson Blade',
        Head = 'Walahra Turban',
        Neck = 'Peacock Charm',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Brutal Earring',
        Body = 'Homam Corazza',
        Hands = 'Alucinor Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Mirage Mantle',
        Waist = 'Headlong Belt',
        Legs = 'Homam Cosciales',
        Feet = 'Homam Gambieras',
    },
};

profile.Sets = sets;
profile.Packer = {};

local setIntents = {
    Playstyle_PhysicalBlue = 'TP',
    Playstyle_MagicalBlue = 'Nuke',
    Playstyle_FastCast = 'FastCast',
    Playstyle_Accuracy = 'Accuracy',
};

local styleAliases = {
    physicalblue = 'PhysicalBlue',
    magicalblue = 'MagicalBlue',
    fastcast = 'FastCast',
    accuracy = 'Accuracy',
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
    text = '[Oddone BLU] ' .. tostring(text or '');
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
        return 'PhysicalBlue';
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor('PhysicalBlue'), force);
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

    message('OddLua playstyle swapper loaded for Oddone_29938. Default style: ' .. state.Playstyle .. '. Use /lac fwd style physicalblue|magicalblue|fastcast|accuracy.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style physicalblue|magicalblue|fastcast|accuracy.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style physicalblue|magicalblue|fastcast|accuracy.');
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
    elseif sets.Playstyle_PhysicalBlue then
        equipNamedSet('Playstyle_PhysicalBlue', false);
    end
end

return profile;
