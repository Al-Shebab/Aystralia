--[[
    ZRewards - (SV) Referrals
    Developed by Zephruz
]]

--[[ Local Methods ]]
local function getSteamAccountInfo(stids, callback)
    local apiKey = zrewards.config.steamApiKey

    stids = zlib.util:Serialize(istable(stids) && stids || {})

    zlib.http:JSONFetch("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=" .. apiKey .. "&steamids=" .. stids, 
    function(data)
        data = (data && data.response)
        data = (data && data.players)

        if (callback) then callback(data) end
    end, 
    function(data) 
        if (callback) then callback(false) end
    end)
end

--[[
    zrewards.referral:GenerateReferralID()

    - Generates a referral ID
]]
function zrewards.referral:GenerateReferralID()
    return string.random(16)
end

--[[
    zrewards.referral:GetReferrals(ply [player], callback [function])

    - Returns a players referrals
]]
function zrewards.referral:GetReferrals(ply, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    local stid = ply:SteamID()

    dType:Query("SELECT referred_steamid, referrer_steamid, refer_data FROM `zrewards_referrals` WHERE `referrer_steamid`=" .. dType:EscapeString(stid),
    function(refs)
        refs = (refs or {})

        for k,v in pairs(refs) do
            local refData = refs[k].refer_data

            if (refData) then
                refs[k].refer_data = (zlib.util:Deserialize(refData) or {})
            end
        end

        if (callback) then callback(refs) end
    end)
end

--[[
    zrewards.referral:SetReferrer(ply [player], referrerid [string], callback [function])

    - Sets a players referrer
]]
function zrewards.referral:SetReferrer(ply, referrerid, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    local stid, prefid = ply:SteamID(), ply:GetReferralID()

    if (referrerid == prefid) then
        if (callback) then callback(false, "cantReferSelf") end

        return 
    end

    self:GetReferrer(ply,
    function(refstid, data)
        if (refstid) then
            if (callback) then callback(false, "alreadyReferred") end

            return
        end

        self:GetInfoByReferrerID(referrerid,
        function(refstid, referrerid)
            if (refstid) then
                ply:SetReferrerID(referrerid)
                
                local refdata = zlib.util:Serialize({nick = ply:Nick(), date = os.time(), referrer_id = referrerid})
                
                dType:Query("INSERT INTO `zrewards_referrals` (referred_steamid, referrer_steamid, refer_data) VALUES (" .. dType:EscapeString(stid) .. ", " .. dType:EscapeString(refstid) .. ", '" .. refdata .. "')",
                function()
                    if (callback) then callback(true, "yourReferrerSet") end

                    hook.Run("zrewards.referral.PlayerReferred", ply, refstid, referrerid)

                    -- Send message
                    local plys = player.GetAll()

                    table.RemoveByValue(plys, ply)

                    zlib.notifs:Send(plys, zrewards.lang:GetTranslation("hasBeenRewardedRefer", ply:Nick()))
                end)
            else
                if (callback) then callback(false, "invalidReferrer") end
            end
        end)
    end)
end

--[[
    zrewards.referral:GetReferrer(ply [player], callback [function])

    - Returns a players referrer (or false if not found)
]]
function zrewards.referral:GetReferrer(ply, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    local stid = ply:SteamID()

    dType:Query("SELECT referred_steamid, referrer_steamid, refer_data FROM `zrewards_referrals` WHERE `referred_steamid`=" .. dType:EscapeString(stid),
    function(data)
        data = (data && data[1])

        if (data) then
            local refData = (data.refer_data or {})
            refData = (zlib.util:Deserialize(refData) or {})

            ply:SetReferrerID(refData.referrer_id)

            if (callback) then callback(data.referrer_steamid, refData) end
        else
            if (callback) then callback(false) end
        end
    end)
end

--[[
    zrewards.referral:GetInfoByReferrerID(referrerid [string], callback [function])

    - Returns a referrers info by the referral ID (or false if not found)
]]
function zrewards.referral:GetInfoByReferrerID(referrerid, callback)
    if !(referrerid) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    dType:Query("SELECT steamid, referral_id FROM `zrewards_users` WHERE `referral_id`=" .. dType:EscapeString(referrerid) .. " LIMIT 1",
    function(data)
        data = (data && data[1])

        if (data) then
            if (callback) then callback(data.steamid, data.referral_id) end
        else
            if (callback) then callback(false) end
        end
    end)
end

--[[
    zrewards.referral:Register(ply [player], [callback])

    - Registers a player with new referreal data (or returns existing)
]]
function zrewards.referral:Register(ply, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")
    
    if !(dType) then return end

    local stid, referralid = ply:SteamID(), self:GenerateReferralID()

    dType:Query("INSERT INTO `zrewards_users` (steamid, referral_id) VALUES (" .. dType:EscapeString(stid) .. ", " .. dType:EscapeString(referralid) .. ")",
    function(data)
        self:LoadReferralInfo(ply, 
        function(...)
            if (callback) then callback(...) end
        end)
    end, 
    function(err) 
        local dup = (err && err:StartWith("Duplicate"))

        -- This player already exists, load them
        if (dup) then
            self:LoadReferralInfo(ply, 
            function(...)
                if (callback) then callback(...) end
            end)
        end
    end)
end

--[[
    zrewards.referral:LoadReferralInfo(ply [player], callback [function])

    - Loads a players referral info (referral id, referrals)
    - Also rewards for any referrals that weren't rewarded for
]]
function zrewards.referral:LoadReferralInfo(ply, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")
    
    if !(dType) then return end

    dType:Query("SELECT referral_id FROM `zrewards_users` WHERE `steamid`=" .. dType:EscapeString(ply:SteamID()),
    function(data)
        data = (data && data[1])
        
        if (data) then
            ply:SetReferralID(data.referral_id)

            self:GetReferrals(ply,
            function(referrals)
                local rewTbl = {}

                -- Check rewards
                for k,v in pairs(referrals) do
                    table.insert(rewTbl, {
                        rewFor = "referral",
                        extraVal = v.referred_steamid
                    })
                end

                zrewards.rewards:RewardPlayerFor(ply, rewTbl)

                if (callback) then callback(ply, data.referral_id, referrals) end
            end)
        else
            -- Register the player
            self:Register(ply,
            function(...)
                if (callback) then callback(...) end
            end)
        end
    end)
end

--[[
    zrewards.referall:GetHiscores(limit [integer], callback [function])

    - Returns the top [limit] players by referrals
]]
function zrewards.referral:GetHiscores(limit, callback)
    local dType = zlib.data:GetConnection("zrewards.Main")
    
    if !(dType) then return end

    local uLimit = (limit or 5)
    local sQuery = "SELECT referrer_steamid As SteamID, COUNT(referrer_steamid) AS Count FROM `zrewards_referrals` GROUP BY `referrer_steamid` ORDER BY Count DESC LIMIT %s"
    sQuery = string.format(sQuery, uLimit)
    
    dType:Query(sQuery,
    function(data)
        local stids = {}

        for k,v in pairs(data) do
            data[k].SteamID = util.SteamIDTo64(v.SteamID)

            table.insert(stids, v.SteamID)
        end

        getSteamAccountInfo(stids,
        function(pData)
            if (pData) then
                for k,v in pairs(pData) do
                    for i,j in pairs(data) do
                        if (v.steamid == j.SteamID) then
                            data[i].Nick = v.personaname
                            data[i].Avatar = v.avatarmedium
                        end
                    end
                end
            end
        
            if (callback) then callback(data) end
        end)
    end)
end

--[[
    Hooks
]]
hook.Add("PlayerInitialSpawn", "zrewards.referral[PlayerInitialSpawn]",
function(ply)
    zrewards.referral:LoadReferralInfo(ply,
    function(ply, refid, referrals)
        refid = (!refid && "Unknown" || refid)
        referrals = (!referrals && {} || referrals)

        if (IsValid(ply)) then
            zrewards.referral:GetReferrer(ply)
            resultMsg = "Loaded " .. ply:Nick() .. "'s (" .. ply:SteamID() .. ") referral information."
        else
            resultMsg = "Unable to load player."
        end

        zrewards:ConsoleMessage(resultMsg .. " (Referral ID: " .. refid .. ", Total Referrals: " .. #referrals .. ")")
    end)
end)

hook.Add("zrewards.data.Initialized", "zrewards.referral.LoadData",
function(zrew, dtype)
    dtype:Query([[CREATE TABLE IF NOT EXISTS
        `zrewards_users` (
        `steamid` VARCHAR(64) PRIMARY KEY,
        `referral_id` VARCHAR(60))]], nil, function(err, sSql) zrewards:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)

    dtype:Query([[CREATE TABLE IF NOT EXISTS
        `zrewards_referrals` (
        `referred_steamid` VARCHAR(64) PRIMARY KEY,
        `referrer_steamid` VARCHAR(64),
        `refer_data` TEXT)]], nil, function(err, sSql) zrewards:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)
end)