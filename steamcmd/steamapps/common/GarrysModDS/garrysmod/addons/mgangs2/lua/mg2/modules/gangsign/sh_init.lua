--[[
    MGangs 2 - GANGSIGN - (SH) Init
    Developed by Zephruz
]]

MG2_GANGSIGN = mg2.modules:Register("gang.Sign")
MG2_GANGSIGN:SetName("Gang Sign")
MG2_GANGSIGN:SetDescription("Implements gang signs.")
MG2_GANGSIGN:SetVersion("V1")

--[[
    Includes
]]
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

AddCSLuaFile("sh_gangsign.lua")
include("sh_gangsign.lua")

if (SERVER) then include("sv_init.lua") end