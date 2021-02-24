-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

RayHUD = RayHUD or {}
RayHUD.FlatPanels = RayHUD.FlatPanels or {}

include( "rh_config.lua" )
AddCSLuaFile( "rh_config.lua" )

if CLIENT then
	local scale = CreateClientConVar("rayhud_scale", RayHUD.Cfg.Scale, true, false)
	RayHUD.Scale = ScrH() * 0.00085 * (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.Scale or scale:GetInt()) * 0.05

	local round = CreateClientConVar("rayhud_rounding", RayHUD.Cfg.Rounding, true, false)
	RayHUD.Rounding = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.Rounding or round:GetInt()) * RayHUD.Scale

	local opacity = CreateClientConVar("rayhud_opacity", RayHUD.Cfg.Opacity, true, false)
	RayHUD.Opacity = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.Opacity or opacity:GetInt())

	local PANEL = {}

	function PANEL:Init()
		table.insert( RayHUD.FlatPanels, self )
	end

	vgui.Register( "RayHUD:DPanel", PANEL, "DPanel" )
else
	resource.AddWorkshop( "2239141042" )
end

local function LoadClient(path)
	if DarkRP then
		if SERVER then
			for _, file in ipairs(file.Find( path .. "/*.lua", "LUA" )) do
				AddCSLuaFile( path .. "/" .. file )
			end
		else
			for _, file in ipairs(file.Find( path .. "/*.lua", "LUA" )) do
				include( path .. "/" .. file )
			end
		end
	end
end

local function LoadServer(path)
	if SERVER and DarkRP then
		for _, file in ipairs(file.Find( path .. "/*.lua", "LUA" )) do
			include( path .. "/" .. file )
			AddCSLuaFile( path .. "/" .. file )
		end
	end
end

local function LoadShared(path)
	LoadClient(path)
	LoadServer(path)
end

local function LoadRayHUD()
	LoadShared("rayhud/shared")
	LoadShared("rayhud/shared/lang")

	LoadServer("rayhud/server")

	LoadClient("rayhud/client/vgui")
	LoadClient("rayhud/client")
end

hook.Add(CLIENT and "InitPostEntity" or "OnGamemodeLoaded", "RayHUD:LoadAddon", function()
	LoadRayHUD()
end)

if GAMEMODE then
	LoadRayHUD()
end

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
	
--	["VCMod"] = true,
	["VCMod_Damage"] = true,
	["VCMod_Fuel"] = true,
	["VCMod_Health"] = true,
	["VCMod_Icons"] = true,
	["VCMod_Name"] = true,
}

hook.Add("HUDShouldDraw", "RayHUD:HideHUD", function( name )
	if HideHUD[name] then return false end
end)