--[[
    ZRewards - (SH) REWARD TYPE - Credit Store (Brick's)
    Developed by Zephruz
]]

--[[REWARD: CREDITS]]
local REWARD_CREDITS = zrewards.rewards:Register("BricksCreditStore.Credits", {})
REWARD_CREDITS:SetName("CreditStore Credits")
REWARD_CREDITS:SetDescription("Credit reward type for Bricks CreditStore.")

function REWARD_CREDITS:onRewardPlayer(ply, val)
    if (!IsValid(ply) or !val) then return end
    
    RunConsoleCommand("addcredits", ply:Name(), val)

    return true
end