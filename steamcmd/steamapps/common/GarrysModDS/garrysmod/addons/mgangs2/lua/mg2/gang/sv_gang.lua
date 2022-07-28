--[[
    MGangs 2 - (SV) Gang
    Developed by Zephruz
]]


--[[
    mg2.gang:SendCacheToPlayer(cacheName [string], ply [player or table of players], modifierFunc [function])
    
    - Sends all entries in the specified cache to the player(s)
    - If modifierFunc is set, you can modify what cache entries are sent
]]
function mg2.gang:SendCacheToPlayer(cacheName, ply, modifierFunc)
    local cache = zlib.cache:Get(cacheName)

    if !(cache) then return end
    
    cache:sendToPlayer(ply,
    function(entries)
        local toSend = {}

        for k,v in pairs(entries) do
            toSend[k] = v:getDataTable()
        end

        if (modifierFunc) then toSend = (modifierFunc(toSend) or toSend) end

        return toSend
    end)
end

// Create tables
local function createTbls(mg2, dtype)
    if !(dtype) then return end

    -- Gang table
    dtype:Query("CREATE TABLE IF NOT EXISTS `mg2_gangs` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT,`data` LONGTEXT NOT NULL)", nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)

    -- Gang group table
    dtype:Query("CREATE TABLE IF NOT EXISTS `mg2_groups` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT,`gang_id` INTEGER NOT NULL,`data` LONGTEXT NOT NULL)", nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)

    -- User table
    dtype:Query("CREATE TABLE IF NOT EXISTS `mg2_users` (`steamid` VARCHAR(64) PRIMARY KEY,`gang_id` INTEGER,`group_id` INTEGER,`data` LONGTEXT NOT NULL)", nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)

    -- Gang invite table
    dtype:Query("CREATE TABLE IF NOT EXISTS `mg2_invites` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT,`invitee_steamid` VARCHAR(64),`inviter_steamid` VARCHAR(64),`gang_id` INTEGER NOT NULL,`data` LONGTEXT NOT NULL)", nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)
end
hook.Add("mg2.data.Initialized", "mg2.gang.LoadData", createTbls)

createTbls(mg2, zlib.data:GetConnection("mg2.Main"))