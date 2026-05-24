local scale = {};

local noValueType = string.char(110, 105, 108);

local function hasValue(value)
    return type(value) ~= noValueType;
end

local function missing(value)
    return type(value) == noValueType;
end

local function noValue()
    return;
end

local state = {
    enabled = true,
    debug = false,
    sets = {},
    intents = {},
    owned = noValue(),
    ownedAvailable = false,
    adapter = noValue(),
    weaponLockEnabled = true,
    preferProfileItems = false,
    fixedWeapons = {},
    debounceEnabled = true,
    lastEquipSignature = noValue(),
    lastEquipSetName = noValue(),
    lastEquipSkipped = false,
    lastEquipSkipSetName = noValue(),
    lastEquipReason = 'none',
    lastEquipAt = 0,
    lastExplain = {}
};

local slotOrder = {
    'Main', 'Sub', 'Range', 'Ammo', 'Head', 'Body', 'Hands', 'Legs',
    'Feet', 'Neck', 'Waist', 'Ear1', 'Ear2', 'Ring1', 'Ring2', 'Back'
};

local slotOrderLookup = {};
for _, slot in ipairs(slotOrder) do
    slotOrderLookup[slot] = true;
end

local tpResetSlots = {
    Main = true,
    Sub = true,
    Range = true
};

local jobNames = {
    WAR = true, MNK = true, WHM = true, BLM = true, RDM = true, THF = true,
    PLD = true, DRK = true, BST = true, BRD = true, RNG = true, SAM = true,
    NIN = true, DRG = true, SMN = true, BLU = true, COR = true, PUP = true,
    DNC = true, SCH = true, GEO = true, RUN = true
};

local weaponFamiliesByName = {
    ['abaddon killer'] = 'great_axe',
    ['almace'] = 'sword',
    ['amanomurakumo'] = 'great_katana',
    ['ammurapi shield'] = 'shield',
    ['apocalypse'] = 'scythe',
    ['acid kukri'] = 'dagger',
    ['atoyac'] = 'dagger',
    ['beestinger'] = 'dagger',
    ['bravura'] = 'great_axe',
    ['carnwenhan'] = 'dagger',
    ['corrosive kukri'] = 'dagger',
    ['death penalty'] = 'gun',
    ['egeking'] = 'sword',
    ['epeolatry'] = 'great_sword',
    ['excalibur'] = 'sword',
    ['genbu\'s shield'] = 'shield',
    ['gigant axe'] = 'great_axe',
    ['gungnir'] = 'polearm',
    ['guttler'] = 'axe',
    ['huge moth axe'] = 'great_axe',
    ['ixtab'] = 'great_axe',
    ['kikoku'] = 'katana',
    ['killer shortbow'] = 'bow',
    ['laevateinn'] = 'staff',
    ['mandau'] = 'dagger',
    ['mekki shakki'] = 'great_katana',
    ['nirvana'] = 'staff',
    ['omni grip'] = 'grip',
    ['oneiros axe'] = 'great_axe',
    ['pole grip'] = 'grip',
    ['raptor strap +1'] = 'grip',
    ['reign grip'] = 'grip',
    ['somnia melodiam'] = 'sword',
    ['spharai'] = 'hand_to_hand',
    ['taming sari'] = 'dagger',
    ['terpsichore'] = 'dagger',
    ['thief\'s knife'] = 'dagger',
    ['tigris grip'] = 'grip',
    ['tizona'] = 'sword',
    ['tupsimati'] = 'staff',
    ['xiutleato'] = 'sword',
    ['yagrush'] = 'club'
};

local weaponFamiliesById = {
    [18519] = 'great_axe',
    [19016] = 'grip',
    [19048] = 'grip',
    [20630] = 'dagger',
    [20872] = 'great_axe',
    [22199] = 'grip'
};

local intentWords = {
    FastCast = { 'chapeau', 'loquac', 'swith', 'nashira', 'quick', 'swift', 'seer' },
    Cure = { 'light staff', 'colossus', 'aqua', 'tamas', 'zenith', 'penitent', 'healing', 'mnd' },
    Healing = { 'light staff', 'colossus', 'aqua', 'tamas', 'zenith', 'penitent', 'healing', 'mnd' },
    Enhancing = { 'duelist', 'dls.', 'warlock', 'enhancing', 'colossus' },
    Enfeebling = { 'enfeebling', 'dls.', 'warlock', 'snow', 'incubus', 'mnd', 'int' },
    Nuke = { 'moldavite', 'novio', 'snow', 'elementium', 'yigit', 'zenith', 'mab' },
    DarkMagic = { 'pluto', 'dark', 'abyssal', 'moldavite', 'novio' },
    Idle = { 'refresh', 'relaxing', 'serket', 'hierarch', 'dalmatica', 'blood cuisses' },
    PDT = { 'terra', 'darksteel', 'dst.', 'shadow', 'karka', 'ram mantle', 'hydra' },
    TP = { 'walahra', 'peacock', 'brutal', 'suppanomimi', 'sniper', 'swift', 'headlong', 'accuracy' },
    Crafting = { 'craft', 'artisan', 'carver', 'carpenter', 'smith', 'goldsmith', 'weaver', 'tanner', 'boneworker', 'alchemist', 'culinarian' },
    Weaponskill = { 'warwolf', 'chivalrous', 'brutal', 'corneus', 'enkidu', 'attack', 'str' },
    RangedPreshot = { 'snapshot', 'rapid', 'commodore', 'comm.' },
    RangedAccuracy = { 'marksman', 'peacock', 'commodore', 'comm.', 'accura', 'ranged accuracy' },
    RangedAttack = { 'commodore', 'comm.', 'ranged attack', 'attack' },
    Song = { 'song', 'singing', 'horn', 'harp', 'flute', 'lute', 'piccolo', 'ocarina' },
    QuickDraw = { 'novio', 'moldavite', 'elementium', 'snow', 'aqua', 'commodore', 'comm.' }
};

local profileMatchBonus = 1000;

local nonCombatUtilityNamePrefixes = {
    'field ',
    'fisherman',
    'chocobo '
};

local nonCombatUtilityNames = {
    ['instant warp'] = true,
    ['warp ring'] = true
};

local customAugments = {
    [1251] = { stat = 'Enf. Dur.', offset = 1, percent = true }
};

local intentAugmentWeights = {
    FastCast = {
        { match = 'fast cast', weight = 700 },
        { match = 'quickens spellcasting', weight = 450 },
        { match = 'haste', weight = 120 },
        { match = 'mnd', weight = 25 },
        { match = 'mag atk bns', weight = 20 }
    },
    Cure = {
        { match = 'cure potency', weight = 700 },
        { match = 'healing magic skill', weight = 120 },
        { match = 'mnd', weight = 60 },
        { match = 'fast cast', weight = 80 },
        { match = 'quickens spellcasting', weight = 60 }
    },
    Healing = {
        { match = 'cure potency', weight = 700 },
        { match = 'healing magic skill', weight = 120 },
        { match = 'mnd', weight = 60 },
        { match = 'fast cast', weight = 80 },
        { match = 'quickens spellcasting', weight = 60 }
    },
    Enhancing = {
        { match = 'enh mag eff dur', weight = 500 },
        { match = 'enhancing magic skill', weight = 120 },
        { match = 'enh skill', weight = 120 },
        { match = 'fast cast', weight = 80 },
        { match = 'mnd', weight = 25 }
    },
    Enfeebling = {
        { match = 'enf dur', weight = 500 },
        { match = 'enfeebling skill', weight = 150 },
        { match = 'enfbmag skill', weight = 150 },
        { match = 'magic accuracy', weight = 120 },
        { match = 'mag acc', weight = 120 },
        { match = 'mnd', weight = 50 },
        { match = 'int', weight = 50 },
        { match = 'fast cast', weight = 30 }
    },
    Nuke = {
        { match = 'mag atk bns', weight = 150 },
        { match = 'magic attack bonus', weight = 150 },
        { match = 'magic damage', weight = 120 },
        { match = 'magic accuracy', weight = 110 },
        { match = 'mag acc', weight = 110 },
        { match = 'int', weight = 55 },
        { match = 'mnd', weight = 20 }
    },
    DarkMagic = {
        { match = 'dark magic skill', weight = 140 },
        { match = 'mag atk bns', weight = 120 },
        { match = 'magic accuracy', weight = 110 },
        { match = 'mag acc', weight = 110 },
        { match = 'int', weight = 55 }
    },
    Idle = {
        { match = 'refresh', weight = 1000 },
        { match = 'regen', weight = 200 },
        { match = 'damage taken', weight = 400, lowerIsBetter = true },
        { match = 'magic dmg taken', weight = 250, lowerIsBetter = true },
        { match = 'mag def bns', weight = 60 }
    },
    PDT = {
        { match = 'damage taken', weight = 500, lowerIsBetter = true },
        { match = 'phys dmg taken', weight = 600, lowerIsBetter = true },
        { match = 'magic dmg taken', weight = 250, lowerIsBetter = true },
        { match = 'def', weight = 20 },
        { match = 'evasion', weight = 15 },
        { match = 'mag def bns', weight = 60 }
    },
    TP = {
        { match = 'haste', weight = 250 },
        { match = 'accuracy', weight = 90 },
        { match = 'attack', weight = 70 },
        { match = 'store tp', weight = 180 },
        { match = 'dual wield', weight = 160 }
    },
    Crafting = {
        { match = 'synthesis skill', weight = 500 },
        { match = 'synthesis success', weight = 450 },
        { match = 'material loss', weight = 300, lowerIsBetter = true }
    },
    Weaponskill = {
        { match = 'str', weight = 80 },
        { match = 'dex', weight = 65 },
        { match = 'mnd', weight = 50 },
        { match = 'attack', weight = 80 },
        { match = 'accuracy', weight = 60 },
        { match = 'weapon skill damage', weight = 250 }
    },
    RangedPreshot = {
        { match = 'snapshot', weight = 400 },
        { match = 'rapid shot', weight = 250 }
    },
    RangedAccuracy = {
        { match = 'ranged accuracy', weight = 120 },
        { match = 'accuracy', weight = 80 },
        { match = 'agi', weight = 50 }
    },
    RangedAttack = {
        { match = 'ranged attack', weight = 110 },
        { match = 'attack', weight = 70 },
        { match = 'agi', weight = 45 }
    },
    Song = {
        { match = 'song', weight = 220 },
        { match = 'singing skill', weight = 180 },
        { match = 'wind instrument', weight = 180 },
        { match = 'stringed instrument', weight = 180 },
        { match = 'chr', weight = 45 }
    },
    QuickDraw = {
        { match = 'mag atk bns', weight = 150 },
        { match = 'magic damage', weight = 120 },
        { match = 'magic accuracy', weight = 110 },
        { match = 'mag acc', weight = 110 },
        { match = 'agi', weight = 50 }
    }
};

local function lower(value)
    if missing(value) then
        return '';
    end
    return string.lower(tostring(value));
end

local function trim(value)
    value = tostring(value or '');
    value = string.gsub(value, '^%s+', '');
    value = string.gsub(value, '%s+$', '');
    return value;
end

local function normalizeStat(value)
    local text = lower(value);
    text = string.gsub(text, "[%'\"%.]", '');
    text = string.gsub(text, '%s+', ' ');
    return trim(text);
end

local function formatAugmentText(stat, value, percent)
    local suffix = percent and '%' or '';
    stat = tostring(stat or '');
    if missing(value) then
        return trim(stat);
    elseif value > 0 then
        return trim(stat) .. '+' .. tostring(value) .. suffix;
    elseif value < 0 then
        return trim(stat) .. tostring(value) .. suffix;
    end
    return trim(stat);
end

local function getItemName(value)
    if type(value) == 'string' then
        return value;
    end
    if type(value) == 'table' then
        return value.Name or value.name;
    end
    return;
end

local function safeCall(callback, fallback)
    local ok, value = pcall(callback);
    if ok and hasValue(value) then
        return value;
    end
    return fallback;
end

local function getLocalServerId()
    if missing(AshitaCore) or missing(AshitaCore.GetMemoryManager) then
        return 0;
    end
    local value = safeCall(function()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0);
    end, 0);
    return tonumber(value) or 0;
end

local function defaultAdapter()
    return {
        equipSet = function(set)
            if hasValue(gFunc) and hasValue(gFunc.EquipSet) then
                gFunc.EquipSet(set);
            end
        end,
        forceEquipSet = function(set)
            if hasValue(gFunc) and hasValue(gFunc.ForceEquipSet) then
                gFunc.ForceEquipSet(set);
            elseif hasValue(gFunc) and hasValue(gFunc.EquipSet) then
                gFunc.EquipSet(set);
            end
        end,
        equipSlot = function(slot, item)
            if hasValue(gFunc) and hasValue(gFunc.Equip) then
                gFunc.Equip(slot, item);
            end
        end,
        message = function(text)
            if hasValue(gFunc) and hasValue(gFunc.Message) then
                gFunc.Message(text);
            else
                print(text);
            end
        end,
        getPlayer = function()
            local player;
            if hasValue(gData) and hasValue(gData.GetPlayer) then
                player = gData.GetPlayer();
            end
            if missing(player) then
                return { name = 'Unknown', id = 0, mainJob = 'RDM', mainLevel = 75, subJob = 'WHM', subLevel = 37 };
            end
            local id = player.Id or player.id or 0;
            if missing(tonumber(id)) or tonumber(id) == 0 then
                id = getLocalServerId();
            end
            return {
                name = player.Name or player.name or 'Unknown',
                id = id,
                mainJob = player.MainJob or player.MainJobName or player.mainJob or 'RDM',
                mainLevel = player.MainJobSync or player.MainJobLevel or player.MainLevel or player.mainLevel or 75,
                subJob = player.SubJob or player.SubJobName or player.subJob or 'WHM',
                subLevel = player.SubJobSync or player.SubJobLevel or player.SubLevel or player.subLevel or 37,
                status = player.Status or player.status or 'Idle',
                tp = player.TP or player.tp or 0
            };
        end,
        loadOwnedGear = function(path)
            if missing(path) or path == '' then
                return;
            end
            local chunk = loadfile(path);
            if missing(chunk) then
                return;
            end
            local ok, value = pcall(chunk);
            if ok then
                return value;
            end
            return;
        end,
        installPath = function()
            if hasValue(AshitaCore) and hasValue(AshitaCore.GetInstallPath) then
                return AshitaCore:GetInstallPath();
            end
            return '';
        end
    };
end

local function normalizeJob(job)
    local text = tostring(job or ''):upper();
    if jobNames[text] then
        return text;
    end
    return text;
end

local function slotMatches(item, slot)
    local slots = tostring(item.slots or item.Slots or '');
    if slots == '' then
        return false;
    end
    for token in string.gmatch(slots, '[^/]+') do
        if lower(token) == lower(slot) then
            return true;
        end
    end
    return false;
end

local function jobMatches(item, job)
    local jobs = tostring(item.jobs or item.Jobs or '');
    if jobs == 'ALL' then
        return true;
    end
    job = normalizeJob(job);
    for token in string.gmatch(jobs, '[^/]+') do
        if normalizeJob(token) == job then
            return true;
        end
    end
    return false;
end

local function isLegal(item, slot, player)
    if missing(item) then
        return false;
    end
    local level = tonumber(item.level or item.Level or 0) or 0;
    local mainLevel = tonumber(player.mainLevel or player.MainJobSync or player.MainLevel or player.MainJobLevel or 0) or 0;
    if level > mainLevel then
        return false;
    end
    if not slotMatches(item, slot) then
        return false;
    end
    if jobMatches(item, player.mainJob or player.MainJob) then
        return true;
    end
    return false;
end

local function nameMatches(item, desired)
    return lower(item.name or item.Name) == lower(desired);
end

local function startsWith(value, prefix)
    return string.sub(value, 1, string.len(prefix)) == prefix;
end

local function allowsNonCombatUtility(intent)
    return intent == 'Crafting';
end

local function isNonCombatUtilityItem(item)
    local itemName = lower(item.name or item.Name);
    if nonCombatUtilityNames[itemName] == true then
        return true;
    end
    for _, prefix in ipairs(nonCombatUtilityNamePrefixes) do
        if startsWith(itemName, prefix) then
            return true;
        end
    end
    return false;
end

local function weaponFamilyFromName(name)
    local text = lower(name);
    local mapped = weaponFamiliesByName[text];
    if hasValue(mapped) then
        return mapped;
    elseif string.find(text, 'grip', 1, true) or string.find(text, 'strap', 1, true) then
        return 'grip';
    elseif string.find(text, 'shield', 1, true) or string.find(text, 'buckler', 1, true) or string.find(text, 'targe', 1, true) then
        return 'shield';
    elseif string.find(text, 'staff', 1, true) then
        return 'staff';
    elseif string.find(text, 'dagger', 1, true) or string.find(text, 'knife', 1, true) or string.find(text, 'kukri', 1, true) then
        return 'dagger';
    elseif string.find(text, 'katana', 1, true) then
        return 'katana';
    elseif string.find(text, 'sword', 1, true) or string.find(text, 'blade', 1, true) then
        return 'sword';
    elseif string.find(text, 'bow', 1, true) then
        return 'bow';
    elseif string.find(text, 'gun', 1, true) then
        return 'gun';
    elseif string.find(text, 'horn', 1, true)
        or string.find(text, 'harp', 1, true)
        or string.find(text, 'flute', 1, true)
        or string.find(text, 'lute', 1, true)
        or string.find(text, 'piccolo', 1, true)
        or string.find(text, 'ocarina', 1, true)
        or string.find(text, 'syrinx', 1, true) then
        return 'instrument';
    elseif string.find(text, 'boomerang', 1, true)
        or string.find(text, 'chakram', 1, true)
        or string.find(text, 'shuriken', 1, true) then
        return 'throwing';
    elseif string.find(text, 'axe', 1, true) then
        return 'axe';
    end
    return;
end

local function weaponFamilyFromItem(item)
    local mapped = weaponFamiliesById[tonumber(item.id or item.Id or 0) or 0];
    if hasValue(mapped) then
        return mapped;
    end
    return weaponFamilyFromName(item.name or item.Name);
end

local function isSupportFamily(family)
    return family == 'grip' or family == 'shield';
end

local function weaponFamilyMatches(slot, desiredName, item)
    if slot ~= 'Main' and slot ~= 'Sub' and slot ~= 'Range' then
        return true;
    end

    local desiredFamily = weaponFamilyFromName(desiredName);
    if missing(desiredFamily) then
        return true;
    end

    local candidateFamily = weaponFamilyFromItem(item);
    if missing(candidateFamily) then
        return false;
    end

    if isSupportFamily(desiredFamily) or isSupportFamily(candidateFamily) then
        return desiredFamily == candidateFamily;
    end

    if slot == 'Main' or slot == 'Range' then
        return desiredFamily == candidateFamily;
    end

    return desiredFamily == candidateFamily;
end

local function inferIntent(setName)
    local name = tostring(setName or '');
    if string.find(name, 'FastCast') then return 'FastCast'; end
    if string.find(name, 'Cure') then return 'Cure'; end
    if string.find(name, 'Healing') then return 'Healing'; end
    if string.find(name, 'Enhancing') or string.find(name, 'Refresh') or string.find(name, 'Stoneskin') then return 'Enhancing'; end
    if string.find(name, 'Enfeebling') then return 'Enfeebling'; end
    if string.find(name, 'Nuke') or string.find(name, 'Elemental') then return 'Nuke'; end
    if string.find(name, 'Dark') then return 'DarkMagic'; end
    if string.find(name, 'PDT') then return 'PDT'; end
    if string.find(name, 'TP') then return 'TP'; end
    if string.find(name, 'RangedPreshot') then return 'RangedPreshot'; end
    if string.find(name, 'RangedAccuracy') then return 'RangedAccuracy'; end
    if string.find(name, 'RangedAttack') then return 'RangedAttack'; end
    if string.find(name, 'QuickDraw') then return 'QuickDraw'; end
    if string.find(name, 'Weaponskill') then return 'Weaponskill'; end
    return 'Idle';
end

local function getPlayerStatus(player)
    if type(player) ~= 'table' then
        return '';
    end
    return lower(player.status or player.Status or player.StatusName or player.statusName);
end

local function isEngagedStatus(status)
    status = lower(status);
    return status == 'engaged' or status == 'attack' or status == 'attacking' or status == '1';
end

local function getPlayerTp(player)
    if type(player) ~= 'table' then
        return 0;
    end
    return tonumber(player.tp or player.TP or player.TacticalPoints or player.tacticalPoints or 0) or 0;
end

local function isTpResetSlot(slot)
    return tpResetSlots[tostring(slot or '')] == true;
end

local function getWeaponLockPlayer(player)
    if hasValue(player) then
        return player;
    end
    local adapter = state.adapter or defaultAdapter();
    if hasValue(adapter.getPlayer) then
        return adapter.getPlayer();
    end
    return {};
end

local function shouldProtectWeapons(player, intent)
    if state.weaponLockEnabled ~= true then
        return false;
    end
    player = getWeaponLockPlayer(player);
    local status = getPlayerStatus(player);
    if getPlayerTp(player) > 0 then
        return true;
    end
    if isEngagedStatus(status) then
        return intent ~= 'TP';
    end
    return false;
end

local function weaponGuardReason(player)
    player = getWeaponLockPlayer(player);
    return string.format('blocked by TP weapon guard; status=%s tp=%u', tostring(player.status or player.Status or 'unknown'), getPlayerTp(player));
end

local function isFixedWeapon(slot, item)
    local fixed = state.fixedWeapons;
    if type(fixed) ~= 'table' then
        return false;
    end

    local expected = fixed[slot];
    if missing(expected) then
        return false;
    end

    return lower(getItemName(item)) == lower(getItemName(expected));
end

local function filterTpResetSlots(setTable, explanations, player, intent)
    if type(setTable) ~= 'table' or not shouldProtectWeapons(player, intent) then
        return setTable;
    end
    local result = {};
    for slot, item in pairs(setTable) do
        if isTpResetSlot(slot) and not isFixedWeapon(slot, item) then
            if type(explanations) == 'table' then
                explanations[slot] = weaponGuardReason(player);
            end
        else
            result[slot] = item;
        end
    end
    return result;
end

local function findCaseInsensitiveKey(tableValue, key)
    if type(tableValue) ~= 'table' then
        return;
    end
    if hasValue(tableValue[key]) then
        return key;
    end
    local wanted = lower(key);
    for existing, _ in pairs(tableValue) do
        if lower(existing) == wanted then
            return existing;
        end
    end
    return;
end

local function hasEntries(tableValue)
    if type(tableValue) ~= 'table' then
        return false;
    end
    for _, _ in pairs(tableValue) do
        return true;
    end
    return false;
end

local function getClock()
    local adapter = state.adapter;
    if hasValue(adapter) and hasValue(adapter.clock) then
        return tonumber(adapter.clock()) or 0;
    end
    return os.clock();
end

local function getSetItemName(item)
    local name = getItemName(item);
    if hasValue(name) then
        return tostring(name);
    end
    return tostring(item);
end

local function buildSetSignature(setTable)
    if type(setTable) ~= 'table' then
        return '<none>';
    end
    local parts = {};
    local seen = {};
    for _, slot in ipairs(slotOrder) do
        local item = setTable[slot];
        if hasValue(item) then
            seen[slot] = true;
            table.insert(parts, slot .. '=' .. getSetItemName(item));
        end
    end
    local extraSlots = {};
    for slot, _ in pairs(setTable) do
        if seen[slot] ~= true and slotOrderLookup[slot] ~= true then
            table.insert(extraSlots, { key = slot, label = tostring(slot) });
        end
    end
    table.sort(extraSlots, function(left, right)
        return left.label < right.label;
    end);
    for _, slot in ipairs(extraSlots) do
        table.insert(parts, slot.label .. '=' .. getSetItemName(setTable[slot.key]));
    end
    return table.concat(parts, '|');
end

local function clearEquipCache(reason)
    state.lastEquipSignature = noValue();
    state.lastEquipSetName = noValue();
    state.lastEquipSkipped = false;
    state.lastEquipSkipSetName = noValue();
    state.lastEquipReason = reason or 'cleared';
    state.lastEquipAt = 0;
end

local function equipSetIfChanged(adapter, setName, setTable, intent, force)
    local signature = buildSetSignature(setTable);
    local requested = setName or 'unknown';
    if force ~= true and state.debounceEnabled == true and state.lastEquipSignature == signature then
        state.lastEquipSkipped = true;
        state.lastEquipSkipSetName = requested;
        state.lastEquipReason = 'duplicate gear signature';
        if state.debug == true and hasValue(adapter.message) then
            adapter.message('Skipped duplicate equip set: ' .. tostring(requested));
        end
        return false;
    end
    if force == true and hasValue(adapter.forceEquipSet) then
        adapter.forceEquipSet(setTable);
    else
        adapter.equipSet(setTable);
    end
    state.lastEquipSignature = signature;
    state.lastEquipSetName = requested;
    state.lastEquipSkipped = false;
    state.lastEquipSkipSetName = noValue();
    if force == true then
        state.lastEquipReason = 'forced ' .. tostring(intent or 'unknown');
    else
        state.lastEquipReason = 'equipped ' .. tostring(intent or 'unknown');
    end
    state.lastEquipAt = getClock();
    return true;
end

local function isAlpha(value)
    return value ~= '' and string.match(value, '%a') ~= nil;
end

local function intentWordMatchesName(itemName, word)
    local itemText = lower(itemName);
    local token = lower(word);
    if token == '' then
        return false;
    end

    if string.match(token, '^%a%a?%a?$') then
        local startIndex = 1;
        while true do
            local firstIndex, lastIndex = string.find(itemText, token, startIndex, true);
            if not firstIndex then
                return false;
            end

            local before = firstIndex > 1 and string.sub(itemText, firstIndex - 1, firstIndex - 1) or '';
            local after = lastIndex < string.len(itemText) and string.sub(itemText, lastIndex + 1, lastIndex + 1) or '';
            if not isAlpha(before) and not isAlpha(after) then
                return true;
            end

            startIndex = lastIndex + 1;
        end
    end

    return string.find(itemText, token, 1, true) ~= nil;
end

local function scoreIntent(item, intent)
    local score = tonumber(item.level or item.Level or 0) or 0;
    local itemName = lower(item.name or item.Name);
    local reasons = { 'level ' .. tostring(score) };
    local words = intentWords[intent] or {};
    for _, word in ipairs(words) do
        if intentWordMatchesName(itemName, word) then
            score = score + 1000;
            table.insert(reasons, 'name ' .. tostring(word) .. ' +1000');
        end
    end
    return score, reasons;
end

local function cloneAugmentValue(value)
    local copy = {};
    if type(value) == 'table' then
        for key, entry in pairs(value) do
            copy[key] = entry;
        end
    end
    return copy;
end

local function enrichAugmentValue(value)
    local output = cloneAugmentValue(value);
    local id = tonumber(output.id or output.Id);
    local custom = customAugments[id];
    if hasValue(custom) and (missing(output.stat) or output.stat == '' or missing(output.computedValue)) then
        local rawValue = tonumber(output.value or output.Value or 0) or 0;
        local computed = rawValue;
        if hasValue(custom.offset) then
            computed = computed + custom.offset;
        end
        if hasValue(custom.multiplier) then
            computed = computed * custom.multiplier;
        end
        output.stat = custom.stat;
        output.computedValue = computed;
        output.percent = custom.percent == true;
        output.text = formatAugmentText(custom.stat, computed, output.percent);
    end
    return output;
end

local function appendAugmentValues(output, values)
    if type(values) ~= 'table' then
        return;
    end
    for _, value in ipairs(values) do
        table.insert(output, enrichAugmentValue(value));
    end
end

local function hasAugmentId(values, id)
    for _, value in ipairs(values) do
        if tonumber(value.id or value.Id) == id then
            return true;
        end
    end
    return false;
end

local function getAugmentValues(item)
    local output = {};
    local augments = item.augments or item.Augments;
    if type(augments) == 'table' then
        appendAugmentValues(output, augments.values or augments.Values);
        if type(augments.raw or augments.Raw) == 'table' then
            for _, raw in ipairs(augments.raw or augments.Raw) do
                local id = tonumber(raw.id or raw.Id);
                if hasValue(id) and not hasAugmentId(output, id) then
                    table.insert(output, enrichAugmentValue(raw));
                end
            end
        end
    end
    return output;
end

local function scoreAugments(item, intent)
    local score = 0;
    local reasons = {};
    local rules = intentAugmentWeights[intent] or {};
    for _, augment in ipairs(getAugmentValues(item)) do
        local stat = normalizeStat(augment.stat or augment.text);
        local text = augment.text or formatAugmentText(augment.stat, augment.computedValue, augment.percent == true);
        local value = tonumber(augment.computedValue or augment.value or augment.Value or 0) or 0;
        for _, rule in ipairs(rules) do
            if string.find(stat, rule.match, 1, true) then
                local magnitude = value;
                if rule.lowerIsBetter == true then
                    magnitude = -magnitude;
                end
                local contribution = magnitude * rule.weight;
                if contribution > 0 then
                    score = score + contribution;
                    table.insert(reasons, 'augment ' .. tostring(text) .. ' +' .. tostring(contribution));
                end
                break;
            end
        end
    end
    return score, reasons;
end

local function getTags(item)
    if type(item) ~= 'table' then
        return {};
    end
    return item.tags or item.Tags or {};
end

local function getTagNumber(value, key, default)
    if type(value) ~= 'table' then
        return default or 0;
    end
    local exact = value[key];
    local folded = value[lower(key)];
    return tonumber(exact or folded or default or 0) or (default or 0);
end

local function getPlayerMainLevel(player)
    if type(player) ~= 'table' then
        return 0;
    end
    return tonumber(player.mainLevel or player.MainJobSync or player.MainLevel or player.MainJobLevel or 0) or 0;
end

local function ruleApplies(rule, player, ruleName)
    if type(rule) ~= 'table' then
        return false;
    end
    local applies = lower(rule.applies_when or rule.appliesWhen or '');
    local mainLevel = getPlayerMainLevel(player);
    if lower(ruleName) == 'low_level_special' and applies == '' then
        return mainLevel < 30;
    end
    if applies == '' then
        return true;
    elseif applies == 'main_level < 30' then
        return mainLevel < 30;
    elseif applies == 'main_level >= 30' then
        return mainLevel >= 30;
    end
    return false;
end

local function scoreTags(item, intent, player)
    local tags = getTags(item);
    local score = 0;
    local reasons = {};
    local intents = tags.intents or tags.Intents;
    local intentTag;
    if type(intents) == 'table' then
        intentTag = intents[intent] or intents[lower(intent)];
    end
    local intentScore = getTagNumber(intentTag, 'score', 0);
    if intentScore ~= 0 then
        score = score + intentScore;
        table.insert(reasons, 'tag ' .. tostring(intent) .. ' +' .. tostring(intentScore));
    end
    local rules = tags.rules or tags.Rules;
    if type(rules) == 'table' then
        for ruleName, rule in pairs(rules) do
            if ruleApplies(rule, player, ruleName) then
                local priority = getTagNumber(rule, 'priority', 0);
                if priority ~= 0 then
                    score = score + priority;
                    table.insert(reasons, 'tag ' .. tostring(ruleName) .. ' +' .. tostring(priority));
                end
            end
        end
    end
    return score, reasons;
end

local function scoreItem(item, intent, desiredName, player)
    local score, reasons = scoreIntent(item, intent);
    if hasValue(desiredName) and nameMatches(item, desiredName) then
        score = score + profileMatchBonus;
        table.insert(reasons, 'profile +' .. tostring(profileMatchBonus));
    end
    local augmentScore, augmentReasons = scoreAugments(item, intent);
    score = score + augmentScore;
    for _, reason in ipairs(augmentReasons) do
        table.insert(reasons, reason);
    end
    local tagScore, tagReasons = scoreTags(item, intent, player or {});
    score = score + tagScore;
    for _, reason in ipairs(tagReasons) do
        table.insert(reasons, reason);
    end
    return score, reasons;
end

local function joinReasons(reasons)
    if type(reasons) ~= 'table' or #reasons == 0 then
        return '';
    end
    return table.concat(reasons, '; ');
end

local function joinPath(left, right)
    if missing(left) or left == '' then
        return right;
    end
    local last = string.sub(left, -1);
    if last == '\\' or last == '/' then
        return left .. right;
    end
    return left .. '\\' .. right;
end

local function loadOwnedGear()
    if hasValue(state.owned) then
        return state.owned, state.ownedAvailable == true;
    end
    local adapter = state.adapter or defaultAdapter();
    local player = adapter.getPlayer();
    local exportPath = state.exportPath;
    if missing(exportPath) and hasValue(adapter.installPath) then
        local installPath = adapter.installPath() or '';
        local relative = string.format('config\\addons\\gearexport\\%s_%s_gear.lua', tostring(player.name or 'Unknown'), tostring(player.id or 0));
        exportPath = joinPath(installPath, relative);
    end
    local loaded = adapter.loadOwnedGear(exportPath);
    if type(loaded) == 'table' and type(loaded.items) == 'table' then
        state.owned = loaded.items;
        state.ownedAvailable = true;
    elseif type(loaded) == 'table' then
        state.owned = loaded;
        state.ownedAvailable = true;
    else
        state.owned = {};
        state.ownedAvailable = false;
    end
    return state.owned, state.ownedAvailable == true;
end

local function findBest(slot, desiredName, intent, player)
    local owned = loadOwnedGear();
    local best;
    local bestScore = -1;
    local bestReasons = {};
    local bestIsProfile = false;
    for _, item in ipairs(owned) do
        if isLegal(item, slot, player)
            and weaponFamilyMatches(slot, desiredName, item)
            and (allowsNonCombatUtility(intent) or not isNonCombatUtilityItem(item)) then
            local isProfile = hasValue(desiredName) and nameMatches(item, desiredName);
            if state.preferProfileItems == true and isProfile then
                return item, 'profile item selected; preferProfileItems=true';
            end
            local score, reasons = scoreItem(item, intent, desiredName, player);
            if score > bestScore or (score == bestScore and isProfile and not bestIsProfile) then
                best = item;
                bestScore = score;
                bestReasons = reasons;
                bestIsProfile = isProfile;
            end
        end
    end
    if hasValue(best) then
        local prefix = bestIsProfile and 'profile item selected' or ('selected best owned legal ' .. intent .. ' item');
        return best, string.format('%s; score=%u (%s)', prefix, bestScore, joinReasons(bestReasons));
    end
    return noValue(), 'no owned legal fallback';
end

function scale.Configure(options)
    options = options or {};
    state.enabled = options.enabled ~= false;
    state.debug = options.debug == true;
    state.sets = options.sets or {};
    state.intents = options.intents or {};
    state.adapter = options.adapter or defaultAdapter();
    state.exportPath = options.exportPath;
    state.weaponLockEnabled = options.weaponLockEnabled ~= false;
    state.preferProfileItems = options.preferProfileItems == true;
    state.fixedWeapons = options.fixedWeapons or {};
    state.debounceEnabled = options.debounceEnabled ~= false;
    if type(options.owned) == 'table' and type(options.owned.items) == 'table' then
        state.owned = options.owned.items;
    else
        state.owned = options.owned;
    end
    state.ownedAvailable = hasValue(state.owned);
    state.lastExplain = {};
    clearEquipCache('configured');
    return scale;
end

function scale.IsEnabled()
    return state.enabled == true;
end

function scale.SetEnabled(enabled)
    state.enabled = enabled == true;
end

function scale.SetWeaponLockEnabled(enabled)
    state.weaponLockEnabled = enabled == true;
end

function scale.CanSwapWeapons(player)
    return not shouldProtectWeapons(player, 'TP');
end

function scale.EquipWeapon(slot, item, reason, player)
    if isTpResetSlot(slot) and shouldProtectWeapons(player) then
        if state.debug == true then
            local adapter = state.adapter or defaultAdapter();
            adapter.message(string.format('Skipped %s=%s: %s', tostring(slot), tostring(item), weaponGuardReason(player)));
        end
        return false;
    end
    local adapter = state.adapter or defaultAdapter();
    if hasValue(adapter.equipSlot) then
        adapter.equipSlot(slot, item);
    elseif hasValue(gFunc) and hasValue(gFunc.Equip) then
        gFunc.Equip(slot, item);
    end
    return true;
end

function scale.ResolveSet(setName, setTable, intent, player)
    local result = {};
    local explanations = {};
    if type(setTable) ~= 'table' then
        state.lastExplain[setName or 'unknown'] = explanations;
        return result;
    end
    player = player or (state.adapter or defaultAdapter()).getPlayer();
    intent = intent or state.intents[setName] or inferIntent(setName);
    local _, ownedAvailable = loadOwnedGear();
    if not ownedAvailable then
        explanations.Source = 'owned gear export unavailable; using original profile set';
        local filtered = filterTpResetSlots(setTable, explanations, player, intent);
        state.lastExplain[setName or 'unknown'] = explanations;
        return filtered;
    end
    for _, slot in ipairs(slotOrder) do
        local desired = setTable[slot];
        if hasValue(desired) then
            if isTpResetSlot(slot) and shouldProtectWeapons(player, intent) and not isFixedWeapon(slot, desired) then
                explanations[slot] = weaponGuardReason(player);
            else
                local desiredName = getItemName(desired);
                local item, reason = findBest(slot, desiredName, intent, player);
                if hasValue(item) then
                    result[slot] = item.name or item.Name;
                    explanations[slot] = string.format('%s -> %s: %s', tostring(desiredName), tostring(result[slot]), reason);
                else
                    explanations[slot] = string.format('%s left unchanged: %s', tostring(desiredName), reason);
                end
            end
        end
    end
    state.lastExplain[setName or 'unknown'] = explanations;
    return result;
end

function scale.EquipSet(setName, setTable, intent)
    local adapter = state.adapter or defaultAdapter();
    local resolvedIntent = intent or state.intents[setName] or inferIntent(setName);
    if state.enabled ~= true then
        local player = hasValue(adapter.getPlayer) and adapter.getPlayer() or noValue();
        local explanations = {};
        local filtered = filterTpResetSlots(setTable, explanations, player, resolvedIntent);
        state.lastExplain[setName or 'unknown'] = explanations;
        equipSetIfChanged(adapter, setName, filtered, resolvedIntent);
        return filtered;
    end
    local resolved = scale.ResolveSet(setName, setTable, resolvedIntent);
    equipSetIfChanged(adapter, setName, resolved, resolvedIntent);
    return resolved;
end

function scale.ForceEquipSet(setName, setTable, intent)
    local adapter = state.adapter or defaultAdapter();
    local resolvedIntent = intent or state.intents[setName] or inferIntent(setName);
    if state.enabled ~= true then
        local player = hasValue(adapter.getPlayer) and adapter.getPlayer() or noValue();
        local explanations = {};
        local filtered = filterTpResetSlots(setTable, explanations, player, resolvedIntent);
        state.lastExplain[setName or 'unknown'] = explanations;
        equipSetIfChanged(adapter, setName, filtered, resolvedIntent, true);
        return filtered;
    end
    local resolved = scale.ResolveSet(setName, setTable, resolvedIntent);
    equipSetIfChanged(adapter, setName, resolved, resolvedIntent, true);
    return resolved;
end

function scale.Status()
    local owned = loadOwnedGear();
    local adapter = state.adapter or defaultAdapter();
    local player = hasValue(adapter.getPlayer) and adapter.getPlayer() or {};
    return {
        enabled = state.enabled == true,
        ownedCount = #owned,
        weaponLockEnabled = state.weaponLockEnabled == true,
        debounceEnabled = state.debounceEnabled == true,
        canSwapWeapons = scale.CanSwapWeapons(player),
        status = player.status or player.Status or 'unknown',
        tp = getPlayerTp(player),
        lastSet = state.lastEquipSetName or 'none',
        lastSkipped = state.lastEquipSkipped == true,
        lastSkipSet = state.lastEquipSkipSetName or 'none',
        lastReason = state.lastEquipReason or 'none'
    };
end

function scale.Explain(setName)
    local adapter = state.adapter or defaultAdapter();
    local requested = setName or 'Idle';
    local resolvedName = findCaseInsensitiveKey(state.sets, requested) or findCaseInsensitiveKey(state.lastExplain, requested) or requested;
    local explanations = state.lastExplain[resolvedName] or {};
    if not hasEntries(explanations) and type(state.sets[resolvedName]) == 'table' then
        scale.ResolveSet(resolvedName, state.sets[resolvedName], state.intents[resolvedName] or inferIntent(resolvedName));
        explanations = state.lastExplain[resolvedName] or {};
    end
    adapter.message('Scale explain for ' .. tostring(resolvedName) .. ':');
    local printed = false;
    if hasValue(explanations.Source) then
        adapter.message('Source: ' .. tostring(explanations.Source));
        printed = true;
    end
    for _, slot in ipairs(slotOrder) do
        if hasValue(explanations[slot]) then
            adapter.message(slot .. ': ' .. explanations[slot]);
            printed = true;
        end
    end
    if not printed then
        adapter.message('No explanation available yet. Use a configured set name or equip the set once.');
    end
end

function scale.HandleCommand(args)
    if type(args) ~= 'table' or lower(args[1]) ~= 'scale' then
        return false;
    end
    local adapter = state.adapter or defaultAdapter();
    local command = lower(args[2]);
    if command == 'on' then
        state.enabled = true;
        clearEquipCache('enabled');
        adapter.message('Level-scaling gear resolver enabled.');
    elseif command == 'off' then
        state.enabled = false;
        clearEquipCache('disabled');
        adapter.message('Level-scaling gear resolver disabled.');
    elseif command == 'status' then
        local status = scale.Status();
        adapter.message(string.format('Level-scaling resolver: enabled=%s owned=%u weaponlock=%s debounce=%s canSwapWeapons=%s status=%s tp=%u lastSet=%s lastSkipped=%s lastSkipSet=%s reason=%s', tostring(status.enabled), status.ownedCount, tostring(status.weaponLockEnabled), tostring(status.debounceEnabled), tostring(status.canSwapWeapons), tostring(status.status), status.tp, tostring(status.lastSet), tostring(status.lastSkipped), tostring(status.lastSkipSet), tostring(status.lastReason)));
    elseif command == 'rebuild' then
        state.owned = noValue();
        clearEquipCache('rebuilt');
        local status = scale.Status();
        adapter.message(string.format('Level-scaling resolver rebuilt owned gear cache: owned=%u', status.ownedCount));
    elseif command == 'explain' then
        scale.Explain(args[3] or 'Idle');
    elseif command == 'flush' or command == 'clear' then
        clearEquipCache('manual flush');
        adapter.message('Scale equip cache flushed.');
    elseif command == 'debounce' then
        local value = lower(args[3]);
        if value == 'on' then
            state.debounceEnabled = true;
            clearEquipCache('debounce enabled');
        elseif value == 'off' then
            state.debounceEnabled = false;
            clearEquipCache('debounce disabled');
        end
        adapter.message(string.format('Scale duplicate-equip debounce: enabled=%s', tostring(state.debounceEnabled == true)));
    elseif command == 'weapon' or command == 'weaponlock' then
        local value = lower(args[3]);
        if value == 'on' then
            state.weaponLockEnabled = true;
        elseif value == 'off' then
            state.weaponLockEnabled = false;
        end
        local status = scale.Status();
        adapter.message(string.format('TP weapon guard: enabled=%s canSwapWeapons=%s status=%s tp=%u', tostring(status.weaponLockEnabled), tostring(status.canSwapWeapons), tostring(status.status), status.tp));
    else
        adapter.message('Scale commands: /lac fwd scale on|off|status|rebuild|flush|debounce on|off|status|explain <set>|weaponlock on|off|status');
    end
    return true;
end

return scale;
