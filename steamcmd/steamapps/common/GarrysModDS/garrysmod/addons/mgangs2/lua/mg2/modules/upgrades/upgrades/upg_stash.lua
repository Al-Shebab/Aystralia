--[[
    MGangs 2 - UPGRADES - (SH) TYPE: Stash
    Developed by Zephruz
]]

--[[MAX STASH ITEMS]]
local UPG_MAXSTASHITEMS = MG2_UPGRADES:Register("mg2.maxStashItems")
UPG_MAXSTASHITEMS:SetName(mg2.lang:GetTranslation("upgrades.MaxStash"))
UPG_MAXSTASHITEMS:SetDescription(mg2.lang:GetTranslation("upgrades.MaxStashDesc"))
UPG_MAXSTASHITEMS:SetCategory(mg2.lang:GetTranslation("stash"))
UPG_MAXSTASHITEMS:SetIcon("materials/mg2/120__application.png")
UPG_MAXSTASHITEMS:SetEnabled(true)

-- CONFIG
UPG_MAXSTASHITEMS:SetDefaultValue(5) -- Default/starting value

-- Tiers
UPG_MAXSTASHITEMS:SetTiers({value = 10, cost = 10000})
UPG_MAXSTASHITEMS:SetTiers({value = 20, cost = 15000})
UPG_MAXSTASHITEMS:SetTiers({value = 45, cost = 25000})

-- [[FUNCIONALITY - DON'T EDIT]]
UPG_MAXSTASHITEMS:SetHooks({
    ["mg2.stash.DepositItem"] = function(upg, ply, gang)
        if (gang) then
            local upgData = gang:GetUpgrades("mg2.maxStashItems")
            local gangItems = MG2_STASH:GetGangsItems(gang:GetID())
    
            if (upgData && gangItems) then 
                local canDeposit = (table.Count(gangItems) < upgData.value)
    
                if (IsValid(ply) && !canDeposit) then
                    zlib.notifs:Send(ply, mg2.lang:GetTranslation("upgrades.StashMax", upg:formatTierValue(upgData.value)))

                    return false
                end
            end
        end
    end,
})

function UPG_MAXSTASHITEMS:formatTierValue(val)
    return zlib.util:FormatNumber(val)
end