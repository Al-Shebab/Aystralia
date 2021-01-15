for k, v in next, DarkRPEntities do
    if v.ent:match("^sent_elegant_printer") then
        DarkRP.removeEntity(k)
    end
end

DarkRP.createCategory({
    name = elegant_printers.config.CommunityName,
    categorises = "entities",
    color = elegant_printers.config.CommunityColor,
    startExpanded = true
})

local config = elegant_printers.config

for tier, data in SortedPairs(config.Tiers) do
    local itemData = {
        ent = "sent_elegant_printer",
        model = "models/freeman/compact_printer.mdl",
        tier = tier, -- Tier name is case insensitive
    }
    local tierConfig = table.Merge(table.Copy(config), data)
    table.Inherit(itemData, tierConfig)
    if not itemData.max then itemData.max = config.MaxPrinters end
    if not itemData.category then itemData.category = config.CommunityName end
    if not itemData.level then itemData.level = tierConfig.VrondrakisLevelSystem_MinLevel end
    DarkRP.createEntity(itemData.PrintName, itemData)
end

-- Upgrades
for class, data in next, elegant_printers.Upgrades do
    if not data.Disabled then
        local itemData = {
            ent = class
        }
        table.Inherit(itemData, data)
        if not itemData.max then itemData.max = math.huge end
        if not itemData.category then itemData.category = config.CommunityName end
        DarkRP.createEntity(itemData.PrintName, itemData)
    end
end
