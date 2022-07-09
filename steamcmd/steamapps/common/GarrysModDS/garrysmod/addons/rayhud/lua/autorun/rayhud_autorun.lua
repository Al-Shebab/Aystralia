-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

if RayHUD then
	hook.Run("RayHUD:Reload")
end

RayHUD = RayHUD or {}
RayHUD.FlatPanels = RayHUD.FlatPanels or {}

if CLIENT then
	local PANEL = {}

	function PANEL:Init()
		table.insert( RayHUD.FlatPanels, self )
	end

	vgui.Register( "RayHUD:DPanel", PANEL, "DPanel" )
end

local function LoadClient(path)
	if DarkRP then
		if SERVER then
			AddCSLuaFile( path )
		else
			include( path )
		end
	end
end

local function LoadServer(path)
	if SERVER and DarkRP then
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

	LoadClient("raylibs/cl_settings.lua")
	LoadClient("raylibs/cl_datapanel.lua")

	// RayHUD
	LoadShared("rayhud/shared/sh_setup.lua")
	
	LoadServer("rayhud/server/sv_misc.lua")

	LoadClient("rayhud/client/cl_main.lua")
	LoadClient("rayhud/client/cl_lowerright.lua")
	LoadClient("rayhud/client/cl_topleft.lua")
	LoadClient("rayhud/client/cl_topright.lua")
	LoadClient("rayhud/client/cl_misc.lua")
	LoadClient("rayhud/client/cl_2d3d.lua")
	LoadClient("rayhud/client/cl_notifications.lua")
	
end




hook.Add(CLIENT and "InitPostEntity" or "OnGamemodeLoaded", "RayHUD:Load", function()
	Load()
end)

if GAMEMODE then
	Load()
end

hook.Add( "OnScreenSizeChanged", "RayHUD:Reload", function()
	Load()
end)









local HideHUD = {
	["DarkRP_HUD"] = true,
	["DarkRP_Hungermod"] = true,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_EntityDisplay"] = true,
	["DarkRP_Agenda"] = true,
	["DarkRP_LockdownHUD"] = true,
	["DarkRP_ArrestedHUD"] = true,
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudPoisonDamageIndicator"] = true,
	["CHudSquadStatus"] = true,
	["CHudBattery"] = true,
}

hook.Add("HUDShouldDraw", "RayHUD:HideHUD", function( name )
	if HideHUD[name] then return false end
end)



