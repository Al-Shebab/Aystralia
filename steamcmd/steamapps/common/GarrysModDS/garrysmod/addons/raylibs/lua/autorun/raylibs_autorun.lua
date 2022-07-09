-- RayUI Owner: 76561198166995690
-- RayUI Version: 1.4

RayUI = RayUI or {}
RayUI.Lang = {}

if SERVER then
	resource.AddWorkshop( "2540046497" )
end

local function LoadClient(path)
	if SERVER then
		AddCSLuaFile( path )
	else
		include( path )
	end
end

local function LoadServer(path)
	if SERVER then
		include( path )
		AddCSLuaFile( path )
	end
end

local function LoadShared(path)
	LoadClient(path)
	LoadServer(path)
end

local function Load()
	// RayLibs
	for _, file in ipairs(file.Find( "raylibs/language/*.lua", "LUA" )) do
		LoadShared( "raylibs/language/" .. file )
	end
	LoadShared("raylibs/sh_raylibs.lua")
	LoadClient("raylibs/cl_raylibs.lua")

	LoadShared("raylibs/sh_raylibs.lua")
	LoadClient("raylibs/cl_raylibs.lua")

	LoadClient("raylibs/cl_raypanel.lua")

	LoadClient("raylibs/cl_settings.lua")
	LoadClient("raylibs/cl_datapanel.lua")

	hook.Run("RayUIReady")
end

hook.Add(CLIENT and "InitPostEntity" or "OnGamemodeLoaded", "RayLibs:Load", function()
	Load()
end)

if GAMEMODE then
	Load()
end

hook.Add( "OnScreenSizeChanged", "RayLibs:OnScreenSizeChanged", function()
	Load()
end )
