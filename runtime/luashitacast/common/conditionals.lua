local conditionals = {};

local function normalize(value)
    return string.lower(tostring(value or ''));
end

local function asNumber(value)
    return tonumber(value);
end

local function threshold(condition)
    if type(condition) ~= 'table' then
        return nil;
    end
    return asNumber(condition.threshold or condition.name);
end

local function playerLevel(player)
    if type(player) ~= 'table' then
        return nil;
    end

    return asNumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
        or player.Level
        or player.level
    );
end

local function playerMp(player)
    if type(player) ~= 'table' then
        return nil;
    end
    return asNumber(player.MP or player.mp);
end

local function playerMaxMp(player)
    if type(player) ~= 'table' then
        return nil;
    end
    return asNumber(player.MaxMP or player.maxMP);
end

local function playerMpp(player)
    if type(player) ~= 'table' then
        return nil;
    end

    local mpp = asNumber(player.MPP or player.mpp or player.MPPercent or player.mpPercent);
    if mpp ~= nil then
        return mpp;
    end

    local mp = playerMp(player);
    local maxMp = playerMaxMp(player);
    if mp ~= nil and maxMp ~= nil and maxMp > 0 then
        return (mp / maxMp) * 100;
    end
    return nil;
end

local function buffState(context, buff)
    if type(context) == 'table' and type(context.getBuffCount) == 'function' then
        local ok, count, known = pcall(context.getBuffCount, buff);
        if ok ~= true or known ~= true or type(count) ~= 'number' then
            return nil;
        end
        return count > 0;
    end
    if type(context) == 'table' and type(context.hasBuff) == 'function' then
        local ok, active = pcall(context.hasBuff, buff);
        if ok ~= true or type(active) ~= 'boolean' then
            return nil;
        end
        return active;
    end
    if gData and gData.GetBuffCount then
        local ok, count = pcall(gData.GetBuffCount, buff);
        if ok == true and type(count) == 'number' then
            return count > 0;
        end
    end
    return nil;
end

function conditionals.StatusSpellTypeMatches(statusName, spellType, context)
    if type(context) ~= 'table' or type(context.action) ~= 'table' then
        return false;
    end
    local action = context.action;
    local actionSpellType = action.Type or action.type or action.SpellType or action.spellType;
    if normalize(actionSpellType) ~= normalize(spellType) then
        return false;
    end
    return buffState(context, statusName) == true;
end

local function getPlayer(context)
    if type(context) == 'table' and type(context.getPlayer) == 'function' then
        return context.getPlayer();
    end
    if gData and gData.GetPlayer then
        return gData.GetPlayer();
    end
    return nil;
end

local function getEnvironment(context)
    if type(context) == 'table' and type(context.getEnvironment) == 'function' then
        return context.getEnvironment();
    end
    if gData and gData.GetEnvironment then
        local ok, environment = pcall(gData.GetEnvironment);
        if ok then
            return environment;
        end
    end
    return nil;
end

local function itemHasUsesLeft(context, entry)
    if type(entry) ~= 'table' or type(entry.item) ~= 'table' then
        return true;
    end
    if type(context) == 'table' and type(context.itemHasUsesLeft) == 'function' then
        return context.itemHasUsesLeft(entry) == true;
    end
    return false;
end

local function environmentAreaText(environment)
    if type(environment) ~= 'table' then
        return '';
    end

    return table.concat({
        tostring(environment.Area or environment.area or ''),
        tostring(environment.ZoneName or environment.zoneName or ''),
        tostring(environment.Zone or environment.zone or ''),
        tostring(environment.Region or environment.region or ''),
    }, ' ');
end

local function areaMatches(condition, environment)
    local areaText = normalize(environmentAreaText(environment));
    if areaText == '' then
        return false;
    end

    if type(condition.areas) == 'table' then
        for _, area in ipairs(condition.areas) do
            if string.find(areaText, normalize(area), 1, true) ~= nil then
                return true;
            end
        end
    end

    local name = normalize(condition.name);
    if name == 'tu_lia' or name == 'tulia' then
        return string.find(areaText, "ru'aun", 1, true) ~= nil
            or string.find(areaText, "ru'avitau", 1, true) ~= nil
            or string.find(areaText, "ve'lugannon", 1, true) ~= nil
            or string.find(areaText, "la'loff", 1, true) ~= nil
            or string.find(areaText, 'hall of the gods', 1, true) ~= nil
            or string.find(areaText, 'celestial nexus', 1, true) ~= nil;
    end
    return false;
end

local function slotSideMatches(condition, slot)
    if type(condition) ~= 'table' or normalize(condition.type) ~= 'slot_side' then
        return false;
    end

    local side = normalize(condition.name);
    local normalizedSlot = normalize(slot);
    return (side == 'right_ear' and normalizedSlot == 'ear2')
        or (side == 'left_ear' and normalizedSlot == 'ear1');
end

function conditionals.ConditionMatches(condition, context)
    if type(condition) ~= 'table' then
        return false;
    end

    local conditionType = normalize(condition.type);
    if conditionType == 'status' then
        if type(condition.buffs) == 'table' and #condition.buffs > 0 then
            for _, buff in ipairs(condition.buffs) do
                if buffState(context, buff) == true then
                    return true;
                end
            end
            return false;
        end
        return buffState(context, condition.name) == true;
    elseif conditionType == 'status_all' then
        if type(condition.buffs) ~= 'table' or #condition.buffs == 0 then
            return false;
        end
        for _, buff in ipairs(condition.buffs) do
            if buffState(context, buff) ~= true then
                return false;
            end
        end
        return true;
    elseif conditionType == 'missing_status' then
        if type(condition.buffs) == 'table' and #condition.buffs > 0 then
            for _, buff in ipairs(condition.buffs) do
                if buffState(context, buff) ~= false then
                    return false;
                end
            end
            return true;
        end
        return buffState(context, condition.name) == false;
    elseif conditionType == 'weather' then
        local environment = getEnvironment(context);
        local wanted = normalize(condition.name);
        return normalize(environment and environment.WeatherElement) == wanted
            or normalize(environment and environment.Weather) == wanted;
    elseif conditionType == 'day' then
        local environment = getEnvironment(context);
        local wanted = normalize(condition.name);
        local day = normalize(environment and environment.Day);
        return normalize(environment and environment.DayElement) == wanted
            or string.find(day, wanted, 1, true) ~= nil;
    elseif conditionType == 'level_lt' then
        local level = playerLevel(getPlayer(context));
        local value = threshold(condition);
        return level ~= nil and value ~= nil and level < value;
    elseif conditionType == 'level_gte' then
        local level = playerLevel(getPlayer(context));
        local value = threshold(condition);
        return level ~= nil and value ~= nil and level >= value;
    elseif conditionType == 'mpp_lt' then
        local mpp = playerMpp(getPlayer(context));
        local value = threshold(condition);
        return mpp ~= nil and value ~= nil and mpp < value;
    elseif conditionType == 'mp_gt' then
        local mp = playerMp(getPlayer(context));
        local value = threshold(condition);
        return mp ~= nil and value ~= nil and mp > value;
    elseif conditionType == 'zone_region' then
        return areaMatches(condition, getEnvironment(context));
    end

    return false;
end

function conditionals.ResolveOverlay(entries, context)
    if type(entries) ~= 'table' then
        return {}, {};
    end

    local overlay = {};
    local owners = {};
    for index, entry in ipairs(entries) do
        if itemHasUsesLeft(context, entry) then
            local conditionType = normalize(entry.condition and entry.condition.type);
            local entryMatches = conditionType ~= 'slot_side'
                and conditionals.ConditionMatches(entry.condition, context);
            for slot, item in pairs(entry.slots or {}) do
                if entryMatches or slotSideMatches(entry.condition, slot) then
                    overlay[slot] = item;
                    owners[slot] = {
                        conditionType = conditionType,
                        conditionName = normalize(entry.condition and entry.condition.name),
                        item = item,
                        index = index,
                    };
                end
            end
        end
    end

    if type(context) == 'table'
        and type(context.state) == 'table'
        and context.state.WarpRingLocked == true then
        overlay.Ring2 = nil;
        owners.Ring2 = nil;
    end
    return overlay, owners;
end

function conditionals.BuildOverlay(entries, context)
    local overlay = conditionals.ResolveOverlay(entries, context);
    return overlay;
end

function conditionals.ApplyForSet(conditionalEquips, setName, context)
    if type(conditionalEquips) ~= 'table' then
        return false;
    end

    local overlay = conditionals.BuildOverlay(conditionalEquips[setName], context);
    if next(overlay) == nil then
        return false;
    end

    local equipper = gFunc;
    if type(context) == 'table' and context.gFunc then
        equipper = context.gFunc;
    end

    if type(context) == 'table' and context.force == true and equipper and equipper.ForceEquipSet then
        equipper.ForceEquipSet(overlay);
    elseif equipper and equipper.EquipSet then
        equipper.EquipSet(overlay);
    else
        return false;
    end
    return true;
end

return conditionals;
