--[[
    MGangs 2 - STASH - (SH) TYPE : ITEMSTORE
    Developed by Zephruz
]]


local TYPE_ITEMSTORE = MG2_STASH:RegisterInventoryType("itemstore")
TYPE_ITEMSTORE:SetName("ItemStore")

function TYPE_ITEMSTORE:onDeposit(ply, data)
    local inv = ply.Inventory
    local items = self:getUserItems(ply)
    local item = false
    
    for k,v in pairs(items) do
        if (v.slot == data.slot) then
            item = v
        end
    end
    
    if (!inv or !item) then return end

    item:TakeOne()
    inv:SetItem(item:GetSlot(), (item:GetAmount() > 0 && item || nil))
    
    return {
        ItemData = item.Data,
        Class = (item.Data && item.Data.Class || item:GetClass()),
        Model = item:GetModel(),
        Name = item:GetName(),
    }
end

function TYPE_ITEMSTORE:onWithdraw(ply, item)
    local inv = ply.Inventory
    local class, data = item:GetClass(), item:GetItemData()

    if (!class or !inv) then return end

    local tempEnt = ents.Create(class)

    for k,v in pairs(data) do
        local setFunc = tempEnt["Set" .. k]

        if (setFunc) then
            setFunc(tempEnt,v)
        end
    end

    if !(IsValid(tempEnt)) then return end

    tempEnt:Spawn()
    tempEnt:Activate()
    tempEnt:SetNoDraw(true)
    tempEnt.locked = false	-- Shipment lock workaround

    -- Deposit item into inventory; OR spawn it if we can't
    if !(ply:PickupItem(tempEnt)) then
        local plyFwd = ply:GetForward()

        tempEnt:SetNoDraw(false)
        tempEnt:SetPos(ply:GetPos() + (Vector(plyFwd.x, 0, plyFwd.z) * 75))
    end

    return true
end

function TYPE_ITEMSTORE:getUserItems(ply)
    local invid = ply.InventoryID
    local inv = (SERVER && ply.Inventory || itemstore.containers.Get(invid))
    local items = {}

    if (CLIENT) then
        for k,v in pairs(inv && inv.Items or {}) do
            table.insert(items, {
                id = v:GetSlot(),
                class = v:GetClass(),
                model = v:GetModel(),
                printname = v:GetName(),
                amount = v:GetAmount()
            })
        end
    else
        items = (inv:GetItems() or {})
    end

    return items
end