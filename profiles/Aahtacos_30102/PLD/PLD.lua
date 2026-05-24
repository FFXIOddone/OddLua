local profile = {};

local state = {
    Playstyle = 'Tank',
};

local sets = {
    Playstyle_Tank = {
        Main = 'Justice Sword',
        Sub = 'Relic Shield',
        Head = 'Darksteel Cap',
        Neck = 'Coral Gorget',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Valor Surcoat',
        Hands = 'Valor Gauntlets',
        Ring1 = 'Wind Ring',
        Ring2 = 'Water Ring',
        Back = 'Valor Cape',
        Waist = 'Toxon Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    Playstyle_Enmity = {
        Main = 'Justice Sword',
        Sub = 'Relic Shield',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Valor Surcoat',
        Hands = 'Dusk Gloves',
        Ring1 = 'Wind Ring',
        Ring2 = 'Water Ring',
        Back = 'Valor Cape',
        Waist = 'Toxon Belt',
        Legs = 'Valor Breeches',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_Damage = {
        Main = 'Justice Sword',
        Sub = 'Relic Shield',
        Head = 'Walahra Turban',
        Neck = 'Spike Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_MagicDefense = {
        Main = 'Justice Sword',
        Sub = 'Relic Shield',
        Head = 'Valor Coronet',
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Valor Surcoat',
        Hands = 'Valor Gauntlets',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Valor Cape',
        Waist = 'Toxon Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },
};

profile.Sets = sets;
profile.Packer = {};

local setIntents = {
    Playstyle_Tank = 'PDT',
    Playstyle_Enmity = 'Enmity',
    Playstyle_Damage = 'TP',
    Playstyle_MagicDefense = 'MDT',
};

local styleAliases = {
    tank = 'Tank',
    enmity = 'Enmity',
    damage = 'Damage',
    magicdefense = 'MagicDefense',
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
    text = '[Aahtacos PLD] ' .. tostring(text or '');
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
        return 'Tank';
    end
    return state.Playstyle;
end

local function equipCurrent(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        equipNamedSet(setNameFor('Tank'), force);
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

    message('OddLua playstyle swapper loaded for Aahtacos_30102. Default style: ' .. state.Playstyle .. '. Use /lac fwd style tank|enmity|damage|magicdefense.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style tank|enmity|damage|magicdefense.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style tank|enmity|damage|magicdefense.');
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
    elseif sets.Playstyle_Tank then
        equipNamedSet('Playstyle_Tank', false);
    end
end

return profile;
