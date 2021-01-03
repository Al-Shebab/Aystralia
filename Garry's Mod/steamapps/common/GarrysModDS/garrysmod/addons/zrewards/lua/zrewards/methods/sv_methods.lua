--[[
    ZRewards - (SV) Methods
    Developed by Zephruz
]]

--[[
    zrewards.methods:SetMethod(ply [player], regType [string], extraVal [any value], callback [function])

    - Sets a players method (or doesn't if it's already set)
]]
function zrewards.methods:SetMethod(ply, regType, extraVal, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    local stid = ply:SteamID()
    local escStid = dType:EscapeString(stid)
    local escRType = dType:EscapeString(regType)
    local escEVal = dType:EscapeString(extraVal or "")
    local escEValStr = (!extraVal && "" || " AND `extraVal`=" .. escEVal)

    dType:Query("SELECT COUNT(steamid) AS total FROM `zrewards_methods` WHERE `steamid`=" .. escStid .. " AND `type`=" .. escRType .. escEValStr,
    function(data)
        local count = data[1]["total"]

        if (count > 0) then 
            if (callback) then callback(false) end 

            return 
        end
        
        dType:Query("INSERT INTO `zrewards_methods` (steamid, type, extraVal, date) VALUES (" .. escStid .. ", " .. escRType .. ", " .. escEVal .. ", " .. dType:EscapeString(os.time()) .. ")",
        function()
            if (callback) then callback(true) end
        end)
    end)
end

--[[
    zrewards.methods:GetMethod(ply [player], methodName [string], callback [funtcion])

    - Returns a single method for a player
]]
function zrewards.methods:GetMethod(ply, methodName, callback)
    if (!IsValid(ply) or !methodName) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    local stid = ply:SteamID()

    dType:Query("SELECT id, steamid, type, extraVal, date FROM `zrewards_methods` WHERE `steamid`=" .. dType:EscapeString(stid) .. " AND `type`=" .. dType:EscapeString(methodName),
    function(data)
        local mData = (#data > 0 && data || false)

        if (callback) then callback(mData) end  
    end)
end

--[[
    zrewards.methods:GetMethods(ply [player], callback [function])

    - Gets a players methods
]]
function zrewards.methods:GetMethods(ply, callback)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    local stid = ply:SteamID()

    dType:Query("SELECT id, steamid, type, extraVal, date FROM `zrewards_methods` WHERE `steamid`=" .. dType:EscapeString(stid),
    function(data)
        if (callback) then callback(data) end
    end)
end

--[[
    zrewards.methods:ClearMethods(steamid [string], callback [function])

    - Clears all methods & rewards for the specified player steamid
]]
function zrewards.methods:ClearMethods(steamid, callback)
    local dType = zlib.data:GetConnection("zrewards.Main")

    if (!dType or !steamid) then return end

    dType:Query("DELETE FROM `zrewards_methods` WHERE `steamid`=" .. dType:EscapeString(steamid),
    function()
        -- Set methods if player is online
        local ply = player.GetBySteamID(steamid)

        if (IsValid(ply)) then
            local methods = self:GetAllTypes()

            for k,v in pairs(methods) do
                ply:SetMethodVerified(k, false)
            end
        end

        -- Clear rewards
        zrewards.rewards:ClearRewards(steamid)

        if (callback) then callback(true) end
    end)
end

--[[
    zrewards.methods:VerifyPlayerMethod(ply [player], methodName [string], callback [function])

    - Verifies a single method for a player
]]
function zrewards.methods:VerifyPlayerMethod(ply, methodName, callback)
    if !(IsValid(ply)) then return end

    local method = self:GetType(methodName)
    
    if !(method) then return end
    
    local res = method:isUserMethodVerified(ply,
    function(isVerif, errMsg)
        if (isVerif) then
            method:getExtraValue(ply,
            function(extraVal)
                extraVal = (extraVal or false)
                
                -- Store method
                self:SetMethod(ply, methodName, extraVal,
                function(res)
                    -- Set Method
                    ply:SetMethodVerified(methodName, isVerif)

                    if (callback) then callback(methodName, isVerif) end

                    -- Reward player
                    zrewards.rewards:RewardPlayerFor(ply, { {rewFor = methodName, extraVal = extraVal} })
                    
                    -- Send message
                    local desc, icon = method:GetDescription(), method:GetIcon()
                    local plys = player.GetAll()

                    table.RemoveByValue(plys, ply)
                    
                    -- Rewarded player message
                    zlib.notifs:Send(ply, zrewards.lang:GetTranslation("successfullyRewarded"), (icon or false))

                    -- Global reward message
                    if (zrewards.config.notifications.showGlobal) then
                        zlib.notifs:Send(plys, zrewards.lang:GetTranslation("hasBeenRewardedMethod", ply:Nick()) .. (desc && zrewards.lang:GetTranslation("toAlsoReceiveRewards") .. ", " .. desc || ""), (icon or false))
                    end
                end)
            end)
        elseif (callback) then 
            callback(methodName, isVerif)
        end

        if (errMsg) then
            zrewards:ConsoleMessage("[" .. methodName .. "] " .. errMsg)
        end

        hook.Run("zrewards.methods.VerifiedPlayer", ply, method, isVerif)
    end)

    if (res == false) then
        zlib.notifs:Send(ply, zrewards.lang:GetTranslation("verifySomethingWentWrong", methodName))
    end
end

--[[
    zrewards.methods:VerifyPlayerMethods(ply [player], callback [function], isSpawn [bool (optional)])

    - Verifies a players method with all enabled method types
]]
function zrewards.methods:VerifyPlayerMethods(ply, callback, isSpawn)
    if !(IsValid(ply)) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    self:GetMethods(ply,
    function(data)
        local checkTypes = {}

        for k,v in pairs(self:GetAllTypes()) do
            checkTypes[k] = true
        end

        for k,v in pairs(data) do
            local regType = (checkTypes[v.type] && self:GetType(v.type))

            if !(regType) then continue end

            regType:getExtraValue(ply,
            function(extraVal)
                if (extraVal && v.extraVal != extraVal) then return end

                checkTypes[v.type] = nil

                -- Set Method
                ply:SetMethodVerified(v.type, true)

                -- Reward Player
                zrewards.rewards:RewardPlayerFor(ply, { {rewFor = v.type} })

                if (callback) then callback(v.type, true) end
            end)
        end

        -- Verify method
        for k,v in pairs(checkTypes) do
            local method = self:GetType(k)

            if !(method) then continue end

            local enabled = method:GetEnabled()
            local vOnSpawn = method:GetVerifyOnSpawn()

            if (enabled && (!isSpawn || vOnSpawn)) then
                local uName = method:GetUniqueName()

                self:VerifyPlayerMethod(ply, uName,
                function(...)
                    if (callback) then callback(...) end
                end)
            end
        end
    end)
end

--[[
    Hooks
]]
hook.Add("PlayerInitialSpawn", "zrewards.methods[PlayerInitialSpawn]",
function(ply)
    // Wait [zrewards.config.spawnRewardWaitTime] seconds since some addons aren't fully initialized at this point
    timer.Simple(zrewards.config.spawnRewardWaitTime,
    function()
        zrewards.methods:VerifyPlayerMethods(ply, 
        function(regName, isVerif)
            if !(IsValid(ply)) then return end
    
            local regType = zrewards.methods:GetType(regName)
    
            if !(regType) then return end
    
            zrewards:ConsoleMessage("Verified " .. ply:Nick() .. "'s (" .. ply:SteamID() .. ") method for '" .. regName .. "' (" .. (!isVerif && "Not " || "") .. "Verified)!")
        
            // Open menu
            if (zrewards.config.disablePopupMenu == false) then
                local open = true

                if (zrewards.config.disablePopupOnComplete) then
                    local notVerified = false

                    for k,v in pairs(zrewards.methods:GetAllTypes()) do
                        if (v && !v:GetEnabled()) then continue end
            
                        local verified = ply:GetMethodVerified(v:GetUniqueName())
            
                        if !(verified) then
                            notVerified = true
                            break
                        end
                    end

                    open = notVerified
                end

                // Open menu
                if (open) then
                    zrewards.vgui:OpenMenu(ply, "zrew.Popup")
                end
            end
        end, true)
    end)
end)

hook.Add("zrewards.data.Initialized", "zrewards.methods.LoadData",
function(zrew, dtype)
    dtype:Query([[CREATE TABLE IF NOT EXISTS
        `zrewards_methods` (
        `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `steamid` VARCHAR(64) NOT NULL,
        `type` VARCHAR(64) NOT NULL,
        `extraVal` VARCHAR(120),
        `date` INTEGER(12))]], 
        nil, 
        function(err, sSql) 
            zrewards:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) 
        end)
        
    -- zrewards_methods - Add new column 'extraVal'
    dtype:Query("ALTER TABLE `zrewards_methods` ADD COLUMN IF NOT EXISTS `extraVal` VARCHAR(255) AFTER `type`", 
    function(data)
        /*if (#data > 0) then
            dtype:Query("ALTER TABLE `zrewards_methods` ADD COLUMN `extraVal` VARCHAR(255) AFTER `type`")
        end*/
    end)
end)