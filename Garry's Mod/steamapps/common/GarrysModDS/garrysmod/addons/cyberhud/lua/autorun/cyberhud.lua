-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝───────────────────--

CyberHud = {}
CyberHud.Config = {}
CyberHud.ServerID = "CH76561198166995690"

if SERVER then
	util.AddNetworkString( "CyberHud.Alert" )
	util.AddNetworkString( "CyberHud.playerArrested" )
	util.AddNetworkString( "CyberHud.SaveConfig" )
	util.AddNetworkString( "CyberHud.GetData" )
	
	resource.AddWorkshop( '1976257197' )
end

function CyberHudLoad()

	if !DarkRP then 
		MsgC( Color(255, 0, 0), "[CyberHud] Initialization FAILED!\n" )
		MsgC( Color(255, 0, 0), "[CyberHud] DarkRP gamemode is not detected\n" )
		return
	end

	MsgC( Color(0, 255, 0), "[CyberHud] Initialization started\n" )

	if SERVER then
		include("cyberhud/sh_config.lua")
		include("cyberhud/sv_init.lua")
		AddCSLuaFile("cyberhud/sh_config.lua")
		AddCSLuaFile("cyberhud/cl_init.lua")
		AddCSLuaFile("cyberhud/cl_util.lua")
		AddCSLuaFile("cyberhud/cl_hud.lua")
		AddCSLuaFile("cyberhud/cl_hooks.lua")
	else
		include("cyberhud/sh_config.lua")
		include("cyberhud/cl_init.lua")
		include("cyberhud/cl_util.lua")
		include("cyberhud/cl_hud.lua")
		include("cyberhud/cl_hooks.lua")
	end

	MsgC( Color(0, 255, 0), "[CyberHud] Initialization done\n" )
	
end

if SERVER then
	hook.Add("PostGamemodeLoaded", "CyberHud.LoadSV", function() CyberHudLoad() end)	
else
	hook.Add("InitPostEntity", "CyberHud.LoadCL", function() CyberHudLoad() end)
end

if GAMEMODE then
	CyberHudLoad()
end