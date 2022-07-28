--[[
    MGangs 2 - STASH - (SH) Config
    Developed by Zephruz
]]

--[[
    MG2_STASH:SetItemBlacklist(table)

    - Classes of blacklisted items

    Examples:
        - "money_printer"
        - "weapon_357"
]]

MG2_STASH:SetItemBlacklist({
    "money_printer",
    "spawned_weapon"
})

--[[
    MG2_STASH:SetInventoryType(invtype) 
    
    - The type of deposit/withdraw inventory your server uses

    Current Types:
        - darkrp
        - itemstore
        - xenin
        - idinventory
]]
MG2_STASH:SetInventoryType("darkrp")

--[[
    MG2_STASH:SetClassName(class, name) 
    
    - These are the translations for the item names, so they actually make sense
]]
MG2_STASH:SetClassName("weapon_357", "357")
MG2_STASH:SetClassName("weapon_ak472", "AK47")
MG2_STASH:SetClassName("weapon_ak47custom", "AK47")