--[[
    MGangs 2 - STASH - (SV) Init
    Developed by Zephruz
]]

--[[
    MG2_STASH:DepositItem(gangid [int], data [table], callback [function])

    - Deposits an item into the gangs stash
]]
function MG2_STASH:DepositItem(gangid, data, callback)
    if !(gangid) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    local sData = zlib.util:Serialize(istable(data) && data || {})

    dtype:Query("INSERT INTO `mg2_stashitems` (`gang_id`, `data`) VALUES (" .. dtype:EscapeString(gangid) .. ", '" .. sData .. "')",
    function(resdata, id)
        data.GangID = gangid

        local item = self:SetupItem(id, data)

        if (callback) then callback(item) end
    end)
end

--[[
    MG2_STASH:WithdrawItem(id [int], callback [function])

    - Withdraws an item from the stash
]]
function MG2_STASH:WithdrawItem(id, callback)
    local item = self:GetItem(id)

    if !(item) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end
    
    dtype:Query("DELETE FROM `mg2_stashitems` WHERE `id`=" .. dtype:EscapeString(id),
    function()
        item:remove()

        if (callback) then callback(true) end
    end)
end

--[[
    MG2_STASH:LoadGangItems(gangid [int], callback [function])

    - Loads all of a gangs items
]]
function MG2_STASH:LoadGangItems(gangid, callback)
    if !(gangid) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("SELECT id, gang_id, data FROM `mg2_stashitems` WHERE `gang_id`=" .. dtype:EscapeString(gangid),
    function(items)
        local gItems = {}
        local inv = self:GetGangsItems(gangid)

        -- Get previous items & clear
        for k,v in pairs(inv) do
            gItems[k] = false
        end
        
        -- Get current/stored items
        for k,v in pairs(items) do
            v.data = zlib.util:Deserialize(v.data)
            v.data.GangID = v.gang_id

            gItems[v.id] = self:SetupItem(v.id, v.data)
        end

        -- Send to online members
        self:SendGangItems(gangid)

        if (callback) then callback(gItems) end
    end)
end

--[[
    MG2_STASH:SendGangItems(gangid [int], modifierFunc [function], plys [player OR table of players])

    - Sends the gangs items to all online members
]]
function MG2_STASH:SendGangItems(gangid, modifierFunc, plys)
    if !(gangid) then return end

    local onPlys = mg2.gang:GetOnlineMembers(gangid)

    mg2.gang:SendCacheToPlayer("mg2.StashItems", (plys or onPlys),
    function(entries)
        local gItems = {}

        for k,v in pairs(entries) do
            if (gangid == v.GangID) then
                gItems[k] = v
            end
        end
        
        if (modifierFunc) then gItems = (modifierFunc(gItems) or gItems) end

        return gItems
    end)
end

--[[
    Data
]]
local function loadData(dtype)
    if !(dtype) then return end

    dtype:Query([[CREATE TABLE IF NOT EXISTS `mg2_stashitems` (
		`id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `gang_id` INTEGER NOT NULL,
		`data` LONGTEXT NOT NULL
    )]], nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)
end

hook.Add("mg2.data.Initialized", "mg2.stash.LoadData",
function(mg2, dtype)
    loadData(dtype)
end)

loadData(zlib.data:GetConnection("mg2.Main"))

--[[
    Hooks
]]
hook.Add("mg2.gang.Loaded", "mg2.stash[mg2.gang.Loaded]",
function(gang)
    local gid = (gang && gang:GetID())

    if !(gid) then return end

    MG2_STASH:LoadGangItems(gid)
end)

hook.Add("mg2.player.Loaded", "mg2.stash[mg2.player.Loaded]",
function(ply, gang)
    local gid = (gang && gang:GetID())

    if !(gid) then return end
    
    MG2_STASH:SendGangItems(gid, nil, ply)
end)