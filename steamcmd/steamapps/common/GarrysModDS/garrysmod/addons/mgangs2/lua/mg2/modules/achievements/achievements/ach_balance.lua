--[[
     MGangs 2 - ACHIEVEMENTS - (SH) Member Achievements
    Developed by Zephruz
]]

local ACH_BALANCE = MG2_GANGACHIEVEMENTS:Register("balanceAchievement")
ACH_BALANCE:SetName(mg2.lang:GetTranslation("achievements.Balance"), {shouldSave = false})
ACH_BALANCE:SetDescription(mg2.lang:GetTranslation("achievements.BalanceDesc"), {shouldSave = false})
ACH_BALANCE:SetCategory(mg2.lang:GetTranslation("balance"), {shouldSave = false})
ACH_BALANCE:SetIcon("icon16/coins.png", {shouldSave = false})

ACH_BALANCE:SetTiers(10000, {EXP = 25})
ACH_BALANCE:SetTiers(100000, {EXP = 50})
ACH_BALANCE:SetTiers(1000000, {EXP = 75})
ACH_BALANCE:SetTiers(10000000, {EXP = 100})

ACH_BALANCE:SetHooks({
    ["mg2.gang.SetBalance"] = function(ach, gang, bal)
        if (gang) then
            local tiers = ach:GetTiers()

            for k,v in pairs(tiers) do
                if (bal >= k) then
                    ach:rewardGang(gang, k)
                end
            end
        end
    end,
})

function ACH_BALANCE:getGangCurrentValue(gang)
    if !(gang) then return end

    return gang:GetBalance()
end

function ACH_BALANCE:formatTierValue(val)
    return (mg2.config.balanceSymbol or "$").. zlib.util:FormatNumber(val)
end
