--[[
    MGangs 2 - UPGRADES - (SH) TYPE: Associations
    Developed by Zephruz
]]

--[[MAX ASSOCIATIONS]]
local UPG_MAXASSOCIATIONS = MG2_UPGRADES:Register("mg2.maxAssociations")
UPG_MAXASSOCIATIONS:SetName(mg2.lang:GetTranslation("upgrades.MaxAssociations"))
UPG_MAXASSOCIATIONS:SetDescription(mg2.lang:GetTranslation("upgrades.MaxAssociationsDesc"))
UPG_MAXASSOCIATIONS:SetCategory(mg2.lang:GetTranslation("associations"))
UPG_MAXASSOCIATIONS:SetIcon("materials/mg2/147__heart.png")
UPG_MAXASSOCIATIONS:SetEnabled(true)

-- CONFIG
UPG_MAXASSOCIATIONS:SetDefaultValue(2) -- Default/starting value

-- Tiers
UPG_MAXASSOCIATIONS:SetTiers({value = 5, cost = 10000})
UPG_MAXASSOCIATIONS:SetTiers({value = 8, cost = 15000})
UPG_MAXASSOCIATIONS:SetTiers({value = 12, cost = 25000})

-- [[FUNCIONALITY - DON'T EDIT]]
local function canAssociate(upg, ply, gang)
    if (gang) then 
        local upgData = gang:GetUpgrades("mg2.maxAssocations")
        local gangAssocs = MG2_ASSOCIATIONS:GetGangs(gang:GetID())
    
        if (upgData && gangAssocs) then 
            local canAssociate = (table.Count(gangAssocs) < upgData.value)
    
            if (IsValid(ply) && !canAssociate) then
                zlib.notifs:Send(ply, mg2.lang:GetTranslation("upgrades.AssociationsMax", upg:formatTierValue(upgData.value)))
    
                return false
            end
        end
    end
end

UPG_MAXASSOCIATIONS:SetHooks({
    ["mg2.associations.Request"] = canAssociate,
    ["mg2.associations.Respond"] = canAssociate,
})

function UPG_MAXASSOCIATIONS:formatTierValue(val)
    return zlib.util:FormatNumber(val)
end