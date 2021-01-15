--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	core.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

include("luaa/luaa.lua")
local version = 1
if((not (slib_dbg) and (SLibVersion and SLibVersion >= version))) then
	return

end

SLibVersion = version
SLib = { }
SLib.Gui = { }
SLib.Config = { }
SLib.Util = { }
SLib.Messages = { }
print("Initializing SLib")
if(SERVER) then
	AddCSLuaFile("config.lua")
	AddCSLuaFile("gui/message_box.lua")
	AddCSLuaFile("gui/blur.lua")
	AddCSLuaFile("gui/testing.lua")
	AddCSLuaFile("gui/collapsible_panel.lua")
	AddCSLuaFile("messages.lua")
	AddCSLuaFile("util.lua")

end

include("util.lua")
include("messages.lua")
include("config.lua")
if(CLIENT) then
	include("gui/testing.lua")
	include("gui/blur.lua")
	include("gui/message_box.lua")
	include("gui/collapsible_panel.lua")

end


