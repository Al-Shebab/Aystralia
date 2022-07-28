--[[
    MGangs 2 - UPGRADES - (SH)
    Developed by Zephruz
]]

MG2_UPGRADES.upgradeValueTypes = {
    BOOLEAN = 0,
    INTEGER = 1
}

--[[
    MG2_UPGRADES:Register(name [string], data [table])

    - Registers an upgrade
]]
function MG2_UPGRADES:Register(name, data)
    local upg = {}

    zlib.object:SetMetatable("mg2.Upgrade", upg)

    upg:SetUniqueName(name)

    if (data) then
        for k,v in pairs(data) do
            upg:setData(k,v)
        end
    end

    -- Cache
    local cache = zlib.cache:Get("mg2.Upgrades")

    if (cache) then
        local id, entry = cache:addEntry(upg, name)

        return entry
    end

    return upg
end

--[[
    MG2_UPGRADES:Get(name [string])

    - Returns an upgrade
]]
function MG2_UPGRADES:Get(name)
    local cache = zlib.cache:Get("mg2.Upgrades")

    if !(cache) then return end

    return cache:getEntry(name)
end

--[[
    MG2_UPGRADES:GetAll()

    - Returns all upgrades
]]
function MG2_UPGRADES:GetAll()
    local cache = zlib.cache:Get("mg2.Upgrades")

    if !(cache) then return end

    return cache:GetEntries()
end

--[[
    Upgrade Cache(s)
]]
zlib.cache:Register("mg2.Upgrades")

--[[
    Upgrade Metastructure
]]
local upgTypeMtbl = zlib.object:Create("mg2.Upgrade")

upgTypeMtbl:setData("UniqueName", "UNIQUE.NAME", {shouldSave = false})
upgTypeMtbl:setData("Name", "Name", {shouldSave = false})
upgTypeMtbl:setData("Description", "Description", {shouldSave = false})
upgTypeMtbl:setData("Category", "Uncategorized", {shouldSave = false})
upgTypeMtbl:setData("Icon", "icon16/exclamation.png", {shouldSave = false})
upgTypeMtbl:setData("Enabled", true, {shouldSave = false})
upgTypeMtbl:setData("DefaultValue", false, {shouldSave = false})
upgTypeMtbl:setData("ValueType", MG2_UPGRADES.upgradeValueTypes.INTEGER)
upgTypeMtbl:setData("Tiers", {}, {
    shouldSave = false,
    onGet = function(s,val,tier)
        if !(tier) then return val end
        
        local tierData = val[tier]
        local tierDataMod = (tierData or {cost = 0, value = s:GetDefaultValue()})
        tierDataMod.id = (tierData && tier || 0)

        return tierDataMod
    end,
    onSet = function(s,tierData,oVal)
        if !(tierData) then return {} end -- Likely setting the entire table
        if !(oVal) then oVal = {} end

        table.insert(oVal, tierData)

        return oVal
    end,
})
upgTypeMtbl:setData("Hooks", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal)
        if !(SERVER) then return val end

        local uName = s:GetUniqueName()
        local hookName = "[upgrade." .. uName .. "]"
        
        for k,v in pairs(oVal) do
            hook.Remove(k, k .. hookName)
        end
        
        for k,v in pairs(val) do
            hook.Add(k, k .. hookName,
            function(...)
                if (s && s:GetEnabled()) then
                    local result = v(s, ...)
                
                    if (result != nil) then
                        return unpack({result}) 
                    end
                end
            end)
        end
    end,
})

function upgTypeMtbl:formatTierValue(val) return val end

--[[
    Permissions
]]

--[[PURCHASE UPGRADE]]
local PERM_PURCHASEUPGRADE = mg2.gang:RegisterPermission("upgrades.Purchase")
PERM_PURCHASEUPGRADE:SetName(mg2.lang:GetTranslation("upgrades.Purchase"))
PERM_PURCHASEUPGRADE:SetCategory(mg2.lang:GetTranslation("upgrades"))
PERM_PURCHASEUPGRADE:SetDescription(mg2.lang:GetTranslation("upgrades.PurchaseDesc"))

function PERM_PURCHASEUPGRADE:onCall(ply, cb, upgUName, tier)
    local gang = ply:GetGang()

    if (!gang or !upgUName or !tier) then return false end

    local gangUpgs = gang:GetUpgrades()
    local upg = MG2_UPGRADES:Get(upgUName)
    local upgTier = (upg && upg:GetTiers(tier))
    local curTier = (gangUpgs && gangUpgs[upgUName] || 0)

    if (!upgTier or !curTier or (curTier + 1) != tier) then return false end
    
    local gangBal = gang:GetBalance()
    
    if (gangBal < upgTier.cost) then
        cb({res = false, msg = mg2.lang:GetTranslation("upgrades.CantAfford")})

        return false 
    end

    gang:SetUpgrades(upgUName, tier)
    gang:SetBalance(gangBal - upgTier.cost)
    
    cb({res = true, msg = mg2.lang:GetTranslation("upgrades.TierPurchased")})
end