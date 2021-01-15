--[[
    ZRewards - (SV) Rewards
    Developed by Zephruz
]]

--[[
    zrewards.rewards:GetPlayerRewards(ply [player], callback [function])

    - Returns a players rewards
]]
function zrewards.rewards:GetPlayerRewards(steamid, callback)
    if !(steamid) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    dType:Query("SELECT id, steamid, rewardType, rewardFor, extraVal, rewardData FROM `zrewards_rewards` WHERE `steamid`=" .. dType:EscapeString(steamid),
    function(data)
        rews = (data or {})

        for k,v in pairs(rews) do
            local rewData = rews[k].rewardData

            if (rewData && rewData != "nil") then
                rews[k].rewardData = (zlib.util:Deserialize(rewData) or {})
            else
                rews[k].rewardData = {}
            end
        end

        if (callback) then callback(rews) end
    end)
end

--[[
    zrewards.rewards:SetPlayerReward(steamid [string], rewType [string], rewFor [string], extraVal [string], rewData [table], callback [function])

    [INTERNAL FUNCTION]
    - Adds a player reward to the database
]]
function zrewards.rewards:SetPlayerReward(steamid, rewType, rewFor, extraVal, rewData, callback)
    if (!steamid or !rewType or !rewFor) then return end

    local dType = zlib.data:GetConnection("zrewards.Main")

    if !(dType) then return end

    rewData = zlib.util:Serialize(rewData || {})

    dType:Query("INSERT INTO `zrewards_rewards` (steamid, rewardType, rewardFor, extraVal, rewardData) VALUES (" .. dType:EscapeString(steamid) .. ", " .. dType:EscapeString(rewType) .. ", " .. dType:EscapeString(rewFor) .. ", " .. dType:EscapeString(extraVal or "") .. ", '" .. rewData .. "')",
    function(...)
        if (callback) then callback() end
    end)
end

--[[
    zrewards.methods:ClearRewards(steamid [string], callback [function])

    - Clears all rewards for the specified player steamid
]]
function zrewards.rewards:ClearRewards(steamid, callback)
    local dType = zlib.data:GetConnection("zrewards.Main")

    if (!dType or !steamid) then return end

    dType:Query("DELETE FROM `zrewards_rewards` WHERE `steamid`=" .. dType:EscapeString(steamid),
    function()
        if (callback) then callback(true) end
    end)
end

--[[
    zrewards.rewards:RewardPlayerFor(ply [player], rewTbl [table], callback [function])

    - Validates & rewards a player for the specified rewTbl values
    ARGUMENTS:
        - rewTbl - A table of rewards to reward the player for (these will be checked for uniqueness)
            [rewTbl EXAMPLE]
            {
                {rewFor = "steamgroup"},
                {rewFor = "discordgroup"},
                {rewFor = "referral", extraVal = "STEAM_0:0:0"},
            }
        - extraVal - Is optional, used to identify unique reward variants
]]
function zrewards.rewards:RewardPlayerFor(ply, rewTbl, callback)
    if (!IsValid(ply) or !rewTbl) then return end

    local nick, stid = ply:Nick(), ply:SteamID()

    self:GetPlayerRewards(stid,
    function(rewards)
        if (!IsValid(ply) or !rewards) then return end

        for k,v in pairs(rewTbl) do
            local rewFor, extraVal = v.rewFor, (v.extraVal or false)

            -- Get specific rewardFor types
            local checkTypes = {}

            for k,v in pairs(self:GetAllTypes()) do
                local val = v:GetRewardFor(rewFor)
                
                if (val) then
                    checkTypes[k] = (checkTypes[k] or {})
                    checkTypes[k][rewFor] = val
                end
            end

            -- Validate already rewarded for
            for k,v in pairs(rewards) do
                local rewUName, rewFor = v.rewardType, v.rewardFor
                local checkType = checkTypes[rewUName]
                
                if !(checkType) then continue end

                if (checkType[rewFor] && (!extraVal or extraVal == v.extraVal)) then
                    checkTypes[rewUName][rewFor] = nil
                    
                    if (callback) then callback(rewUName, rewFor, false, "rewardsFailedAlreadyRewarded") end
                end
            end

            -- Reward
            for k,v in pairs(checkTypes) do
                local rewType = self:GetType(k)

                if !(rewType) then continue end

                local rewName, rewUName = rewType:GetName(), rewType:GetUniqueName()

                for i,j in pairs(v) do
                    if (j == nil) then continue end

                    local rewSuc, rewMsg = rewType:onRewardPlayer(ply, j)

                    if (rewSuc) then
                        self:SetPlayerReward(stid, rewUName, rewFor, (extraVal or false), {val = j, date = os.time()},
                        function()
                            local rewInfo = "(Reward: " .. rewName .. " | Amount: " .. tostring(j) .. " | For: " .. rewFor .. ")"
                            
                            zrewards:ConsoleMessage("Rewarded " .. nick .. " (" .. stid .. ") "  .. rewInfo)

                            if (callback) then callback(rewUName, rewFor, true, "rewardsSuccess") end

                            hook.Run("zrewards.rewards.PlayerRewarded", ply, j, rewFor)
                        end)
                    else
                        zrewards:ConsoleMessage("Reward for type '" .. rewUName .. "' was unsuccessful, most likely not a valid gamemode/addon function." .. (rewMsg || ""))

                        if (callback) then callback(rewUName, rewFor, false, "rewardsFailedNotValid") end
                    end
                end
            end
        end
    end)
end

--[[
    Hooks
]]

hook.Add("zrewards.data.Initialized", "zrewards.rewards.LoadData",
function(zrew, dtype)
    dtype:Query([[CREATE TABLE IF NOT EXISTS
        `zrewards_rewards` (
        `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `steamid` VARCHAR(64),
        `rewardType` VARCHAR(64),
        `rewardFor` VARCHAR(64),
        `extraVal` VARCHAR(120),
        `rewardData` TEXT)]], nil, function(err, sSql) zrewards:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)
end)
