--[[
    MGangs 2 - UPGRADES - (SH) TYPE: General (max members, max cash, etc.)
    Developed by Zephruz
]]

--[[MAX GANG BALANCE]]
local UPG_MAXBALANCE = MG2_UPGRADES:Register("mg2.maxBalance")
UPG_MAXBALANCE:SetName(mg2.lang:GetTranslation("upgrades.MaxBalance"))
UPG_MAXBALANCE:SetDescription(mg2.lang:GetTranslation("upgrades.MaxBalanceDesc"))
UPG_MAXBALANCE:SetCategory(mg2.lang:GetTranslation("general"))
UPG_MAXBALANCE:SetIcon("materials/mg2/126__cash.png")
UPG_MAXBALANCE:SetEnabled(true)

-- CONFIG
UPG_MAXBALANCE:SetDefaultValue(100000) -- Default/starting value

-- Tiers
UPG_MAXBALANCE:SetTiers({value = 250000, cost = 10000})
UPG_MAXBALANCE:SetTiers({value = 5000000, cost = 125000})
UPG_MAXBALANCE:SetTiers({value = 10000000, cost = 500000})

-- [[FUNCIONALITY - DON'T EDIT]]
UPG_MAXBALANCE:SetHooks({
    ["mg2.balance.Deposit"] = function(upg, ply, gang, amount)
        if (gang) then 
            local upgData = gang:GetUpgrades("mg2.maxBalance")

            if (upgData && amount) then
                local canDeposit = (amount <= upgData.value)
    
                if (IsValid(ply) && !canDeposit) then
                    zlib.notifs:Send(ply, mg2.lang:GetTranslation("upgrades.BalanceMax", upg:formatTierValue(upgData.value)))
    
                    return false
                end
            end
        end
    end,
    ["mg2.gang.SetBalance"] = function(upg, gang, amount)
        if (gang) then
            local upgData = gang:GetUpgrades("mg2.maxBalance")

            if (upgData && amount && amount > upgData.value) then
                return false
            end
        end
    end,
})

function UPG_MAXBALANCE:formatTierValue(val)
    return (mg2.config.balanceSymbol or "$") .. zlib.util:FormatNumber(val)
end

--[[FRIENDLY FIRE]]
local UPG_FRIENDLYFIRE = MG2_UPGRADES:Register("mg2.friendlyFire")
UPG_FRIENDLYFIRE:SetName("Disable Friendly Fire")
UPG_FRIENDLYFIRE:SetDescription("Disables friendly fire!")
UPG_FRIENDLYFIRE:SetCategory("General")
UPG_FRIENDLYFIRE:SetIcon("icon16/users.png")
UPG_FRIENDLYFIRE:SetEnabled(true)
UPG_FRIENDLYFIRE:SetValueType(MG2_UPGRADES.upgradeValueTypes.BOOLEAN)

-- CONFIG
UPG_FRIENDLYFIRE:SetDefaultValue(false) -- Default/starting value

-- Tiers
UPG_FRIENDLYFIRE:SetTiers({value = true, cost = 2500000})

-- [[FUNCTIONALITY - DON'T EDIT]]
UPG_FRIENDLYFIRE:SetHooks({
    ["EntityTakeDamage"] = function(upg, targ, dmgInfo)
        local attacker = dmgInfo:GetAttacker()

        // So much nil checking
        if (attacker != nil && targ != nil && IsEntity(attacker) && IsEntity(targ)) then
            // More checking
            if (attacker:IsPlayer() && targ:IsPlayer() && attacker != targ && targ:IsInGang()) then
                local gang, attGang = targ:GetGang(), attacker:GetGang()
                local targGID, attGID = targ:GetGangID(), attacker:GetGangID()

                if (gang && attGang && targGID == attGID) then
                    local upgData = gang:GetUpgrades("mg2.friendlyFire")
    
                    // upgData must be true to not take damage
                    if (upgData.value == true) then 
                        return true
                    end
                end
            end
        end
    end,
})

--[[MAX MEMBERS - WIP]]
/*
local UPG_MAXMEMBERS = MG2_UPGRADES:Register("mg2.maxMembers")
UPG_MAXMEMBERS:SetName("Max Members")
UPG_MAXMEMBERS:SetDescription("Maximum amount of members.")
UPG_MAXMEMBERS:SetCategory("General")
UPG_MAXMEMBERS:SetIcon("icon16/user.png")
UPG_MAXMEMBERS:SetEnabled(true)

-- CONFIG
UPG_MAXMEMBERS:SetDefaultValue(2) -- Default/starting value

-- Tiers
UPG_MAXMEMBERS:SetTiers({value = 5, cost = 10000})
UPG_MAXMEMBERS:SetTiers({value = 10, cost = 15000})
UPG_MAXMEMBERS:SetTiers({value = 15, cost = 15000})

-- [[FUNCIONALITY - DON'T EDIT]]
UPG_MAXMEMBERS:SetHooks({
    ["mg2.gang.PlayerJoin"] = function(upg, gang, ply)
        
    end,
})
*/