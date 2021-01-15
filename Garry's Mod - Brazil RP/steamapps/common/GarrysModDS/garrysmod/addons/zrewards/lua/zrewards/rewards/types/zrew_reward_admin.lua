--[[
    ZRewards - (SH) REWARD TYPE - ADMIN
    Developed by Zephruz
]]

--[[REWARD: RANK]]
local REWARD_RANK = zrewards.rewards:Register("Admin.Rank", {})
REWARD_RANK:SetName("Rank")
REWARD_RANK:SetDescription("Rank reward.")

function REWARD_RANK:onRewardPlayer(ply, val)
    if (!IsValid(ply) or !val) then return end

    zlib.util:SetUserGroup(ply, val)
    
    return true
end