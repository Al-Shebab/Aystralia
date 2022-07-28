--[[
    MGangs 2 - TERRITORIES - (SH) Init
    Developed by Zephruz
]]

MG2_TERRITORIES = mg2.modules:Register("territories")
MG2_TERRITORIES:SetName("Territories")
MG2_TERRITORIES:SetDescription("Implements gang controlled territories.")
MG2_TERRITORIES:SetVersion("V1")

--[[
    Includes
]]
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

AddCSLuaFile("vgui/menu_territory.lua")
include("vgui/menu_territory.lua")

AddCSLuaFile("vgui/menu_territoryadmin.lua")
include("vgui/menu_territoryadmin.lua")

AddCSLuaFile("vgui/menu_territorycreate.lua")
include("vgui/menu_territorycreate.lua")

AddCSLuaFile("sh_territories.lua")
include("sh_territories.lua")

AddCSLuaFile("cl_init.lua")
include((SERVER && "sv" || "cl") .. "_init.lua")