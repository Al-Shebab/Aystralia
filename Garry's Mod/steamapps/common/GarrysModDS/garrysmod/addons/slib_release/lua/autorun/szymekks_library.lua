--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	szymekks_library.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

if(SERVER) then
	AddCSLuaFile()
	AddCSLuaFile("luaa/luaa.lua")
	AddCSLuaFile("luaa/luaa_objects.lua")
	AddCSLuaFile("luaa/luaa_enumerable.lua")
	AddCSLuaFile("slib/core.lua")

end

include("luaa/luaa.lua")
include("slib/core.lua")

