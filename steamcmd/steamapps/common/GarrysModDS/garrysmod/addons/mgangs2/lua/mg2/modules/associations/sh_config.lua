--[[
    MGangs 2 - ASSOCIATIONS - (SH) Config
    Developed by Zephruz
]]

--[[
    Association Types - Types of associations made available to gangs
]]
MG2_ASSOCIATIONS:SetAssociationTypes({
    ["Allies"] = {
        color = Color(125,255,125),
        icon = "icon16/flag_green.png",
        canWar = false,
    },
    ["Enemies"] = {
        color = Color(255,125,125),
        icon = "icon16/flag_red.png",
        canWar = true,
    },
    ["Neutral"] = {
        color = Color(255,255,125),
        icon = "icon16/flag_yellow.png",
        canWar = false,
    },
})
