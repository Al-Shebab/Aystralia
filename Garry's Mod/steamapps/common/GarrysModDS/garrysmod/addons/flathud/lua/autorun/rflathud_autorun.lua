-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

-- if (FlatHUD != nil) then error("Some addon uses the same global table name ('FlatHUD')") end

FlatHUD = FlatHUD or {}
FlatHUD.FlatPanels = FlatHUD.FlatPanels or {}

include( "fh_config.lua" )
AddCSLuaFile( "fh_config.lua" )

if CLIENT then
	local scale = CreateClientConVar("flathud_scale", FlatHUD.Cfg.Scale, true, false)
	FlatHUD.Scale = ScrH() * 0.00085 * (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.Cfg.Scale or scale:GetInt()) * 0.05

	local round = CreateClientConVar("flathud_rounding", FlatHUD.Cfg.Rounding, true, false)
	FlatHUD.Rounding = (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.Cfg.Rounding or round:GetInt()) * FlatHUD.Scale

	local opacity = CreateClientConVar("flathud_opacity", FlatHUD.Cfg.Opacity, true, false)
	FlatHUD.Opacity = (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.Cfg.Opacity or opacity:GetInt())

	local PANEL = {}

	function PANEL:Init()
		table.insert( FlatHUD.FlatPanels, self )
	end

	vgui.Register( "FlatHUD:DPanel", PANEL, "DPanel" )
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

local function LoadFlatHUD()
	LoadShared("flathud/shared")
	LoadShared("flathud/shared/lang")

	LoadServer("flathud/server")

	LoadClient("flathud/client/vgui")
	LoadClient("flathud/client")
end

hook.Add(CLIENT and "InitPostEntity" or "OnGamemodeLoaded", "FlatHUD:LoadAddon", function()
	LoadFlatHUD()
end)

if GAMEMODE then
	LoadFlatHUD()
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

hook.Add("HUDShouldDraw", "FlatHUD:HideHUD", function( name )
	if HideHUD[name] then return false end
end)