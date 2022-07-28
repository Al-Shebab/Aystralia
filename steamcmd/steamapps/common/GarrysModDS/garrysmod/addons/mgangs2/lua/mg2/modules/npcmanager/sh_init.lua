--[[
     MGangs 2 - NPC MANAGER - (SH) Init
    Developed by Zephruz
]]

MG2_NPCMANAGER = mg2.modules:Register("gang.NPCManager")
MG2_NPCMANAGER:SetName("Gang NPC Manager")
MG2_NPCMANAGER:SetDescription("Implements an NPC manager for NPCs.")
MG2_NPCMANAGER:SetVersion("V1")

--[[
    Includes
]]
AddCSLuaFile("sh_npcmanager.lua")
include("sh_npcmanager.lua")

if (SERVER) then include("sv_init.lua") end

AddCSLuaFile("vgui/menu_npcmanager.lua")
include("vgui/menu_npcmanager.lua")

AddCSLuaFile("vgui/menu_selection.lua")
include("vgui/menu_selection.lua")