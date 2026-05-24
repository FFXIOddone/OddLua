local profile = {};

local state = {
    Playstyle = 'Cure',
};

local sets = {
    Playstyle_Cure = {
        Main = 'Ash Staff',
        Head = 'Sprout Beret',
        Body = 'Kupo Suit',
        Hands = 'Galkan Bracers',
        Ring1 = 'Venture Ring',
        Back = 'S. Reraiser Tank',
        Legs = 'Galkan Braguette',
        Feet = 'Galkan Sandals',
    },

    Playstyle_FastCast = {
        Main = 'Ash Staff',
        Head = 'Sprout Beret',
        Body = 'Kupo Suit',
        Hands = 'Galkan Bracers',
        Ring1 = 'Venture Ring',
        Back = 'S. Reraiser Tank',
        Legs = 'Galkan Braguette',
        Feet = 'Galkan Sandals',
    },

    Playstyle_IdleRefresh = {
        Main = 'Ash Staff',
        Head = 'Sprout Beret',
        Body = 'Kupo Suit',
        Hands = 'Galkan Bracers',
        Ring1 = 'Venture Ring',
        Back = 'S. Reraiser Tank',
        Legs = 'Galkan Braguette',
        Feet = 'Galkan Sandals',
    },

    Playstyle_Damage = {
        Main = 'Ash Staff',
        Head = 'Sprout Beret',
        Body = 'Kupo Suit',
        Hands = 'Galkan Bracers',
        Ring1 = 'Venture Ring',
        Back = 'S. Reraiser Tank',
        Legs = 'Galkan Braguette',
        Feet = 'Galkan Sandals',
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
    text = '[Aahtacos WHM] ' .. tostring(text or '');
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

    message('OddLua playstyle swapper loaded for Aahtacos_30102. Default style: ' .. state.Playstyle .. '. Use /lac fwd style cure|fastcast|idlerefresh|damage.');
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
