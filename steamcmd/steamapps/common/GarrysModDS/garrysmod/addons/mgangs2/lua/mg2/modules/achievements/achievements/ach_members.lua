--[[
     MGangs 2 - ACHIEVEMENTS - (SH) Member Achievements
    Developed by Zephruz
]]

local ACH_MEMBERS = MG2_GANGACHIEVEMENTS:Register("memberAchievement")
ACH_MEMBERS:SetName(mg2.lang:GetTranslation("achievements.Members"), {shouldSave = false})
ACH_MEMBERS:SetDescription(mg2.lang:GetTranslation("achievements.MembersDesc"), {shouldSave = false})
ACH_MEMBERS:SetCategory(mg2.lang:GetTranslation("members"), {shouldSave = false})
ACH_MEMBERS:SetIcon("icon16/group.png", {shouldSave = false})

ACH_MEMBERS:SetTiers(2, {EXP = 25})
ACH_MEMBERS:SetTiers(5, {EXP = 50})
ACH_MEMBERS:SetTiers(10, {EXP = 75})
ACH_MEMBERS:SetTiers(20, {EXP = 100})

ACH_MEMBERS:SetHooks({
    ["mg2.gang.PlayerJoin"] = function(ach, gang, ply)
        if (gang) then
            mg2.gang:GetMembers(gang:GetID(),
            function(mems)
                local tiers = ach:GetTiers()
                
                for k,v in pairs(tiers) do
                    if (#mems >= k) then
                        ach:rewardGang(gang, k)
                    end
                end
            end)
        end
    end,
})

function ACH_MEMBERS:formatTierValue(val)
    return zlib.util:FormatNumber(val) .. " " .. mg2.lang:GetTranslation("members")
end