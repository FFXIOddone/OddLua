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

local function hasBuff(context, buff)
    if type(context) == 'table' and type(context.hasBuff) == 'function' then
        return context.hasBuff(buff) == true;
    end
    if gData and gData.GetBuffCount then
        local ok, count = pcall(gData.GetBuffCount, buff);
        return ok == true and type(count) == 'number' and count > 0;
    end
    return false;
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

function conditionals.ConditionMatches(condition, context)
    if type(condition) ~= 'table' then
        return false;
    end

    local conditionType = normalize(condition.type);
    if conditionType == 'status' then
        if type(condition.buffs) == 'table' then
            for _, buff in ipairs(condition.buffs) do
                if hasBuff(context, buff) then
                    return true;
                end
            end
        end
        return hasBuff(context, condition.name);
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

function conditionals.BuildOverlay(entries, context)
    if type(entries) ~= 'table' then
        return {};
    end

    local overlay = {};
    for _, entry in ipairs(entries) do
        if conditionals.ConditionMatches(entry.condition, context) then
            for slot, item in pairs(entry.slots or {}) do
                overlay[slot] = item;
            end
        end
    end

    if type(context) == 'table'
        and type(context.state) == 'table'
        and context.state.WarpRingLocked == true then
        overlay.Ring2 = nil;
    end
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
