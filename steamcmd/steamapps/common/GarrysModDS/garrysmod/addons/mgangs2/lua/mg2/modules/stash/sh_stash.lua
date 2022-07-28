--[[
    MGangs 2 - STASH - (SH)
    Developed by Zephruz
]]

--[[
    MG2_STASH:SetupTempItem(data [table])

    - Sets a temporary item up
]]
function MG2_STASH:SetupTempItem(data)
   local sItem = {}

    zlib.object:SetMetatable("mg2.StashItem", sItem)

    if (data) then
        for k,v in pairs(data) do
            sItem:setRawData(k,v)
        end
    end

    return sItem
end

--[[
    MG2_STASH:SetupItem(id [int], data [table])

    - Sets an item up with the specified data
]]
function MG2_STASH:SetupItem(id, data)
    local item = self:SetupTempItem(data)
    item:SetID(id)

    local cache = zlib.cache:Get("mg2.StashItems")
    
    if (cache) then 
        local id, entry = cache:addEntry(item, id)
        
        if (SERVER && entry) then
            local gangid = entry:GetGangID()
            local gang = mg2.gang:Get(gangid)

            if !(gang) then return end

            self:SendGangItems(gangid,
            function(gItems)
                return {[id] = entry:getDataTable()}
            end)
        end

        return entry
    end

    return item
end

--[[
    MG2_STASH:GetItems()

    - Returns all cached items
]]
function MG2_STASH:GetItems()
    local cache = zlib.cache:Get("mg2.StashItems")

    if !(cache) then return end

    return cache:GetEntries()
end

--[[
    MG2_STASH:GetItem(id [int])

    - Returns a cached item
]]
function MG2_STASH:GetItem(id)
    local cache = zlib.cache:Get("mg2.StashItems")

    if !(cache) then return end

    return cache:getEntry(id)
end

--[[
    MG2_STASH:GetGangsItems(gangid [int])

    - Returns all cached gangs items
]]
function MG2_STASH:GetGangsItems(gangid)
    if !(gangid) then return end

    local gItems = {}

    for k,v in pairs(self:GetItems()) do
        if (v:GetGangID() == gangid) then
            gItems[k] = v
        end
    end

    return gItems
end

--[[
    Networking
]]
local userReqs = {}

userReqs["clearStash"] = function(ply, val, cb)

end

zlib.network:RegisterAction("mg2.stash.userRequest", {
    onReceive = function(ply, val, cb)
        if !(istable(val)) then return end

        local reqName, data = val.reqName, (val.data or {})
        local req = userReqs[reqName]
        
        if (req) then
            req(ply, val, cb)
        end
    end,
})

--[[
    Stash Cache(s)
]]
-- Stash item cache
local sItemCache = zlib.cache:Register("mg2.StashItems")
sItemCache.onPlayerReceive = function(s,data)
    for k,v in pairs(data) do
        local item = MG2_STASH:GetItem(k)

        if (!v && item) then
            // remove item
            item:remove()
        elseif (item) then
            // update item data
            for i,d in pairs(v) do
                item:setRawData(i, d)
            end
        else 
            // setup item
            MG2_STASH:SetupItem(k, v)
        end
    end
end

--[[
    Stash Item Metastructure
]]
local sItemMtbl = zlib.object:Create("mg2.StashItem")

sItemMtbl:setData("ID", false, {shouldSave = false})
sItemMtbl:setData("GangID", false, {shouldSave = false})
sItemMtbl:setData("ItemData", {}, {shouldSave = false})
sItemMtbl:setData("Model", "models/error.mdl", {})
sItemMtbl:setData("Class", false, {})

sItemMtbl:setData("Name", "NAME", {
    onGet = function(s,val)
        local class = s:GetClass()

        if !(class) then return val end

        local entName = MG2_STASH:GetClassName(class)

        return (entName != class && entName || val)
    end,
})

function sItemMtbl:remove()
    local id = self:GetID()

    if !(id) then return end

    local cache = zlib.cache:Get("mg2.StashItems")
    cache:removeEntry(id)

    local gangid = self:GetGangID()

    if (SERVER && gangid) then
        MG2_STASH:SendGangItems(gangid,
        function(gItems)
            return {[id] = false}
        end)
    end
end

function sItemMtbl:onSave(data, cb)
    if (!SERVER or !data) then return end

    local id = self:GetID()
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!id or !dtype) then return end

    dtype:Query("UPDATE `mg2_associations` SET `data`=" .. data .. " WHERE `id`=" .. id,
    function()
        local gangid = self:GetGangID()

        if (gangid) then
            MG2_STASH:SendGangItems(gangid,
            function(gItems)
                return {[id] = self:getDataTable()}
            end)
        end

        if (cb) then cb(self) end
    end)
end

--[[
    Permissions
]]

--[[DEPOSIT ITEM]]
local PERM_DEPOSITITEM = mg2.gang:RegisterPermission("stash.DepositItem")
PERM_DEPOSITITEM:SetName(mg2.lang:GetTranslation("stash.DepositItem"))
PERM_DEPOSITITEM:SetCategory(mg2.lang:GetTranslation("stash"))
PERM_DEPOSITITEM:SetDescription(mg2.lang:GetTranslation("stash.DepositItemDesc"))

function PERM_DEPOSITITEM:onCall(ply, cb, iData)
    local invType = MG2_STASH:GetInventoryType()
    
    if !(invType) then return end

    local gang = ply:GetGang()

    if (!gang or !iData) then cb(false) return false end

    local canDeposit = hook.Run("mg2.stash.DepositItem", ply, gang, iData) -- player, gang, itemData

    if (canDeposit == false) then cb(false, "You cannot deposit that item right now.") return false end

    -- check blocked items
    local isBlocked = table.HasValue(MG2_STASH:GetItemBlacklist(), iData.class)

    if (isBlocked) then cb(false, "That item is blocked from being deposited.") return false end

    -- dpeosit item
    local gangid = gang:GetID()
    local data = invType:onDeposit(ply, iData)

    if !(data) then cb(false) return false end

    MG2_STASH:DepositItem(gangid, data,
    function(item)
        cb(item && true || false)
    end)
end

--[[WITHDRAW ITEM]]
local PERM_WITHDRAWITEM = mg2.gang:RegisterPermission("stash.WithdrawItem")
PERM_WITHDRAWITEM:SetName(mg2.lang:GetTranslation("stash.WithdrawItem"))
PERM_WITHDRAWITEM:SetCategory(mg2.lang:GetTranslation("stash"))
PERM_WITHDRAWITEM:SetDescription(mg2.lang:GetTranslation("stash.WithrdawItemDesc"))

function PERM_WITHDRAWITEM:onCall(ply, cb, itemid)
    local invType = MG2_STASH:GetInventoryType()
    local item = MG2_STASH:GetItem(itemid)

    if (!invType or !item) then return end

    local res = invType:onWithdraw(ply, item)
    
    if !(res) then return end

    MG2_STASH:WithdrawItem(itemid, 
    function()
        cb(true)
    end)
end