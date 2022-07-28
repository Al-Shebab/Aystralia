--[[
    MGangs 2 - STASH - (SH) TYPE : XENIN INVENTORY
    Developed by Zephruz
]]


local TYPE_XENIN = MG2_STASH:RegisterInventoryType("xenin")
TYPE_XENIN:SetName("Xenin Inventory")

function TYPE_XENIN:onDeposit(ply, data)
    local inv = ply:XeninInventory()
    local items = self:getUserItems(ply)
    local item

    if !(inv) then return end

    for k,v in pairs(inv:GetInventory()) do
        if (v.id == data.id) then
            item = v

            break
        end

        return false
    end
    
    item.printname = (data.printname || self:ParseItemName(item.dropEnt) || "Unknown")
    item.model = (data.model || self:ParseItemModel(item.dropEnt))

    inv:ReduceAmount(item.id, 1, false)

    local itemData = table.Copy(item.data)
    itemData.dropEnt = item.dropEnt

    return {
        ItemData = itemData,
        Class = item.ent,
        Model = item.model,
        Name = item.printname,
    }
end

function TYPE_XENIN:onWithdraw(ply, item)
    local inv = ply:XeninInventory()
    local class, data = item:GetClass(), item:GetItemData()

    if (!class or !inv) then return end

    local dropEnt = data.dropEnt // Get drop entity

    data.dropEnt = nil

    -- Deposit item into inventory; OR spawn it if we can't
    if !(inv:Add(class, dropEnt, item:GetModel(), 1, data, false)) then
        local plyFwd = ply:GetForward()

        tempEnt:SetNoDraw(false)
        tempEnt:SetPos(ply:GetPos() + (Vector(plyFwd.x, 0, plyFwd.z) * 75))
    end

    return true
end

function TYPE_XENIN:getUserItems(ply)
    local inv = ply:XeninInventory()
    local items = {}
    
    for k,v in pairs(inv && inv:GetInventory() || {}) do
        table.insert(items, {
            id = v.id,
            class = v.ent,
            model = self:ParseItemModel(v.ent),
            printname = self:ParseItemName(v.ent),
            amount = v.amount
        })
    end

    return items
end

function TYPE_XENIN:ParseItemName(entClass)
    local itemMeta = XeninInventory:CreateItem()
    local itemName = itemMeta:GetName(entClass)
        
    if (istable(itemName)) then
        itemName = (itemName.ent || "Unknown Name")
    elseif (itemName == nil || !isstring(itemName)) then
        itemName = "Unknown Name"
    end

    return itemName
end

function TYPE_XENIN:ParseItemModel(entClass)
    local itemMeta = XeninInventory:CreateItem()
    local itemModel = itemMeta:GetModel(entClass)

    if (isstring(itemModel) && string.EndsWith(itemModel, ".mdl")) then
        return itemModel
    end

    return "xt.mdl"
end