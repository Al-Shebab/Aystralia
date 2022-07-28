--[[
    MGangs 2 - STASH - (SH) TYPE : DARKRP
    Developed by Zephruz

    - DataTabe: item.DT
]]

local itemDictionary = {
    ["spawned_shipment"] = {
        onDeposit = function(data, item)
            local itemData = item.DT
            local contents = CustomShipments[itemData.contents or ""]

            local fixedName = MG2_STASH:GetClassName(contents && contents.entity || item.Class)
            local itemName = string.format("Shipment - %s (%s)", fixedName, itemData.count)
            
            return {
                ItemData = itemData,
                Class = item.Class,
                Model = (contents && contents.model || item.Model),
                Name = itemName
            }
        end,
    },
    ["spawned_weapon"] = {
        onDeposit = function(data, item)
            local itemData = item.DT

            return {
                ItemData = itemData,
                Class = item.Class,
                Model = item.Model,
                Name = MG2_STASH:GetClassName(itemData && itemData.WeaponClass || item.PrintName),
            }
        end,
    }
}


local TYPE_DARKRP = MG2_STASH:RegisterInventoryType("darkrp")
TYPE_DARKRP:SetName("DarkRP Pocket")

function TYPE_DARKRP:onDeposit(ply, data)
    local items = self:getUserItems(ply)
    local item = (items && items[data.id])
    
    if !(item) then return end

    ply:removePocketItem(data.id)
    
    -- Get & format item data
    local dictItem = itemDictionary[item.Class]

    if (dictItem && dictItem.onDeposit) then
        return dictItem.onDeposit(data, item)
    else
        return {
            ItemData = item.DT,
            Class = item.Class,
            Model = item.Model,
            Name = item.PrintName,
        }
    end
end

function TYPE_DARKRP:onWithdraw(ply, item)
    local iClass, iData = item:GetClass(), item:GetItemData()

    if (!iClass or !iData) then return end

    local tempEnt = ents.Create(iClass)

    for k,v in pairs(iData) do
        local setFunc = tempEnt["Set" .. k]

        if (!setFunc || v == nil) then continue end
        
        setFunc(tempEnt, v)
    end

    if !(IsValid(tempEnt)) then return false end

    tempEnt:Spawn()
    
    ply:addPocketItem(tempEnt)

    return true
end

function TYPE_DARKRP:getUserItems(ply)
    local items = {}

    if (SERVER) then
        return ply.darkRPPocket
    else
        for k,v in pairs(ply:getPocketItems()) do
            table.insert(items, {
                id = k,
                class = v.class,
                model = v.model,
            })
        end
    end

    return items
end