if (bLogs and CLIENT) then
	if (IsValid(bLogs.Menu)) then
		bLogs.Menu:Close()
	end
end

bLogs = {}
bLogs.Version = "Remastered-21"
bLogs.Licensee = "76561198166995690"

if (SERVER) then
	AddCSLuaFile("blogs/sh.lua")
	AddCSLuaFile("blogs_config.lua")
	AddCSLuaFile("blogs/cl.lua")
	AddCSLuaFile("blogs/default_config.lua")
	AddCSLuaFile("blogs_theme.lua")
	for _,v in pairs((file.Find("blogs/lang/*.lua","LUA"))) do
		AddCSLuaFile("blogs/lang/" .. v)
	end
	for _,v in pairs((file.Find("vgui/blogs/*.lua","LUA"))) do
		AddCSLuaFile("vgui/blogs/" .. v)
	end
end
include("blogs_theme.lua")
include("blogs/sh.lua")