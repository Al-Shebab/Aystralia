--[[
    MGangs 2 - DARKRP EXTENSIONS - (SH) Init
    Developed by Zephruz
]]

MG2_DARKRPEXTENSIONS = mg2.modules:Register("darkrp.Extensions")
MG2_DARKRPEXTENSIONS:SetName("DarkRP Extensions")
MG2_DARKRPEXTENSIONS:SetDescription("Implements extended features for DarkRP.")
MG2_DARKRPEXTENSIONS:SetVersion("V1")

--[[
    Includes
]]
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

AddCSLuaFile("sh_gangjobs.lua")
include("sh_gangjobs.lua")