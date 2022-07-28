--[[
     MGangs 2 - ACHIEVEMENTS - (SH) Achievements
    Developed by Zephruz
]]

--[[
    MG2_GANGACHIEVEMENTS:Register(name [string], data [table])

    - Registers an achievement
]]
function MG2_GANGACHIEVEMENTS:Register(name, data)
    local prevAch = self:Get(name)

    if (prevAch) then return prevAch end

    local ach = {}

    zlib.object:SetMetatable("mg2.Achievement", ach)

    ach:SetUniqueName(name)

    if (data) then
        for k,v in pairs(data) do
            ach:setData(k,v)
        end
    end

    -- Cache
    local cache = zlib.cache:Get("mg2.Achievements")

    if (cache) then
        local id, entry = cache:addEntry(ach, name)

        return entry
    end

    return ach
end

--[[
    MG2_GANGACHIEVEMENTS:Get(name [string])

    - Returns an achievement
]]
function MG2_GANGACHIEVEMENTS:Get(name)
    local cache = zlib.cache:Get("mg2.Achievements")

    if !(cache) then return end

    return cache:getEntry(name)
end

--[[
    MG2_GANGACHIEVEMENTS:GetAll()

    - Returns all achievements
]]
function MG2_GANGACHIEVEMENTS:GetAll(name)
    local cache = zlib.cache:Get("mg2.Achievements")

    if !(cache) then return end

    return cache:GetEntries()
end


--[[
    Rewards
]]
MG2_GANGACHIEVEMENTS.rewards = {
    EXP = function(gang, val)
        if (!gang or !val) then return end

        local exp = gang:GetEXP()

        return gang:SetEXP(exp + val)
    end,
}

--[[
    Achievement Cache(s)
]]
zlib.cache:Register("mg2.Achievements")

--[[
    Achievement Metastructure
]]
local achMeta = zlib.object:Create("mg2.Achievement")

achMeta:setData("UniqueName", false, {shouldSave = false})
achMeta:setData("Name", "ACH.NAME", {shouldSave = false})
achMeta:setData("Description", "ACH.DESCRIPTION", {shouldSave = false})
achMeta:setData("Category", "General", {shouldSave = false})
achMeta:setData("Icon", "icon16/cross.png", {shouldSave = false})
achMeta:setData("Tiers", {}, {
    shouldSave = false,
    onGet = function(s,val,tier)
        if !(tier) then return val end

        return (val[tier] or false)
    end,
    onSet = function(s,tier,oVal,val)
        if !(val) then return tier end // Likely setting the entire table
        if !(oVal) then oVal = {} end

        oVal[tier] = val

        return oVal
    end,
})
achMeta:setData("Hooks", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal)
        if !(SERVER) then return val end
        
        local uName = s:GetUniqueName()
        local hookName = "[achievement." .. uName .. "]"

        for k,v in pairs(oVal) do
            hook.Remove(k, k .. hookName)
        end
        
        for k,v in pairs(val) do
            hook.Add(k, k .. hookName,
            function(...)
                local result = v(s, ...)
                
                if (result != nil) then
                    //return unpack({result}) 
                end
            end)
        end
    end,
})

function achMeta:rewardGang(gang, tierVal)
    if (!gang or !tierVal) then return end

    local uName, tierRews = self:GetUniqueName(), self:GetTiers(tierVal)

    if (!uName or !tierRews) then return end
    
    local ach = gang:GetAchievements(uName, tierVal)

    if !(ach) then
        for k,v in pairs(tierRews) do
            local rew = MG2_GANGACHIEVEMENTS.rewards[k]

            if (rew) then 
                rew(gang, v)
            end
        end

        gang:SetAchievements(uName, tierVal, true)
    end
end

function achMeta:formatTierValue(val) return "" end
function achMeta:getGangCurrentValue(gang) return false end