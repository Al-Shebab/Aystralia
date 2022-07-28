--[[
    MGangs 2 - UPGRADES - (SH) TYPE: Territories
    Developed by Zephruz
]]

--[[MAX TERRITORIES]]
local UPG_MAXTERRITORIES = MG2_UPGRADES:Register("mg2.maxTerritories")
UPG_MAXTERRITORIES:SetName(mg2.lang:GetTranslation("upgrades.MaxTerritories"))
UPG_MAXTERRITORIES:SetDescription(mg2.lang:GetTranslation("upgrades.MaxTerritoriesDesc"))
UPG_MAXTERRITORIES:SetCategory(mg2.lang:GetTranslation("territories"))
UPG_MAXTERRITORIES:SetIcon("materials/mg2/102__warehouse.png")
UPG_MAXTERRITORIES:SetEnabled(true)

-- CONFIG
UPG_MAXTERRITORIES:SetDefaultValue(1) -- Default/starting value

-- Tiers
UPG_MAXTERRITORIES:SetTiers({value = 2, cost = 10000})
UPG_MAXTERRITORIES:SetTiers({value = 5, cost = 15000})
UPG_MAXTERRITORIES:SetTiers({value = 8, cost = 25000})

-- [[FUNCIONALITY - DON'T EDIT]]
UPG_MAXTERRITORIES:SetHooks({
    ["mg2.territories.StartClaim"] = function(upg, ply)
        if (IsValid(ply)) then  
            local gang = ply:GetGang()

            if (gang) then 
                local upgData = gang:GetUpgrades("mg2.maxTerritories")
    
                if (upgData) then 
                    local totalTerrs = 0
        
                    for k,v in pairs(MG2_TERRITORIES:GetAll()) do
                        local claimData = v:GetClaimed()
                        
                        if !(claimData) then continue end
            
                        if (claimData.gangid == gang:GetID()) then
                            totalTerrs = totalTerrs + 1
                        end
                    end
                    
                    if (totalTerrs >= upgData.value) then
                        return false, mg2.lang:GetTranslation("upgrades.TerritoryMax", upg:formatTierValue(upgData.value))
                    end
                end
            end
        end
    end,
})

function UPG_MAXTERRITORIES:formatTierValue(val)
    return zlib.util:FormatNumber(val)
end