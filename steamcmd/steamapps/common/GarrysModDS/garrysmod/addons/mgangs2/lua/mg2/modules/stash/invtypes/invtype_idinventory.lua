--[[
    MGangs 2 - STASH - (SH) TYPE : IDINVENTORY
    Developed by Zephruz
]]


local TYPE_IDINVENTORY = MG2_STASH:RegisterInventoryType("idinventory")
TYPE_IDINVENTORY:SetName("IDInventory")

function TYPE_IDINVENTORY:onDeposit(ply, data)
    local inv = ply:FetchInventory()
    local items = self:getUserItems(ply)
    local item = false
    
    for k,v in pairs(items) do
        if (v.slotpos == data.slotpos) then
            item = v
        end
    end
    
    if (!inv or !item) then return end

    // remove item
    inv[item.slotpos] = nil
    ply:UpdateInventory(inv)

    return {
        ItemData = item,
        Class = item.class,
        Model = item.model,
        Name = item.printname,
    }
end

function TYPE_IDINVENTORY:onWithdraw(ply, item)
    local inv = ply.Inventory
    local class, data = item:GetClass(), item:GetItemData()

    if (!class or !inv) then return end

    -- Deposit item into inventory
    ply:GiveItem(class, data.model, (data.amount || 1))

    return true
end

function TYPE_IDINVENTORY:getUserItems(ply)
    local inv = (SERVER && ply:FetchInventory() || IDInv.Handlers.Player_Inventory)
    local items = {}

    for k,v in pairs(inv) do
        table.insert(items, {
            id = v.slotpos,
            class = v.class,
            model = v.model,
            printname = v.printname,
            amount = v.amount
        })
    end

    return items
end