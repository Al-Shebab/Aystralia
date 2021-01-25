-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝─────── Config ────--

-- ╔══╦════╦════╦═══╦╗─╔╦════╦══╦══╦╗─╔╦╦╦╗
-- ║╔╗╠═╗╔═╩═╗╔═╣╔══╣╚═╝╠═╗╔═╩╗╔╣╔╗║╚═╝║║║║
-- ║╚╝║─║║───║║─║╚══╣╔╗─║─║║──║║║║║║╔╗─║║║║
-- ║╔╗║─║║───║║─║╔══╣║╚╗║─║║──║║║║║║║╚╗╠╩╩╝
-- ║║║║─║║───║║─║╚══╣║─║║─║║─╔╝╚╣╚╝║║─║╠╦╦╗
-- ╚╝╚╝─╚╝───╚╝─╚═══╩╝─╚╝─╚╝─╚══╩══╩╝─╚╩╩╩╝

-- You can edit the config throw the game!!!
-- Just type ch_confing command in the console

CyberHud.Patern = {
	["main_l"] = Color(255,55,40),  -- This is main HUD color
	["main_d"] = Color(155,55,40),	-- Main color but darker
	["main_s"] = Color(245,45,70),	-- This color used only in health bar as the second slider
	["sub_l"] = Color(170,255,250), -- Sub color (for armor and etc)
	["hunger"] = Color(54,217,107), -- Hunger bar and wallet color
	["red"] = Color(255,55,40),		-- Red notifications
	["yellow"] = Color(255,200,40),	-- Yellow notifications
	["blue"] = Color(170,255,250),	-- Blue notifications
	["shadow"] = Color(0,0,0,100),	-- Shadows
	["bgr"] = Color(0,0,0,155)		-- Same as shadows but darker
}

-- If you still want to edit the config manually, lock the config to block

CyberHud.LockedConfig = false				-- Locking the config disable ingame configurator menu

CyberHud.Config.GlitchEffect = true			-- Enable HUD glitching effect when player got damaged or player's health is less than 60%

CyberHud.Config.ColorCor = true				-- Enable color correction when player's health gets lower

CyberHud.Config.BloodStains = true			-- Enable blood stains on the screen when player's health is low

CyberHud.Config.HeartBeat = true			-- Enable heart beating sound when player's health is low

CyberHud.Config.MainColorBased = true		-- Draw notifications with the same color as a hud

CyberHud.Config.EnableFlash = false			-- Enable flash on alert notifications (middle screen notifications)

CyberHud.Config.HiddenWallet = false		-- Show player's wallet only if it was changed (when player drops/gets money or salary)

CyberHud.Config.DrawPlayerHalo = false		-- Draw halo around players when they are close to you

CyberHud.Config.EnablePlayerInfo = true		-- Enable overhead hud information above other players

CyberHud.Config.ShowPlayerJob = false		-- Display player's overhead job title

CyberHud.Config.UseTeamColors = false		-- Use team colors for overhead hud information

CyberHud.Config.DrawDoorHalo = false		-- Draw halo around entities (doors and cars) when you are close and looking at them

CyberHud.Config.WeaponSelectionHud = true	-- Enable weapon selection hud

CyberHud.Config.WeaponInfo = true			-- Enable weapon information on hud

CyberHud.Config.Weapon_Sel = "cyberhud/sel.wav" -- Weapon selection sound

CyberHud.Config.Weapon_Scr = "cyberhud/scr.wav"	-- Weapon scroll sound

/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
-- ───────────────────────────--/////////////////////////////////////
-- Do not edit anything below --/////////////////////////////////////
-- ───────────────────────────--/////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////

function CyberHud.DrawGlitchEffect()
	
	if CLIENT and GetConVar("mat_picmip"):GetInt() > 0 then
		return false
	end
	
	if CLIENT and CyberHud.Config.GlitchEffect then
		return true
	end
	
	return false
	
end

net.Receive( "CyberHud.GetData", function(l, ply)
	
	if CLIENT then
		local config = net.ReadTable()
			
		CyberHud.Config = config
		
		CyberHud.UpdateHookInfo()
	else
		net.Start("CyberHud.GetData")
			net.WriteTable(CyberHud.Config)
		net.Send(ply)
	end
		
end)

if CLIENT then 
	
	net.Start("CyberHud.GetData") net.SendToServer()
	
end

if SERVER then
	
	net.Receive( "CyberHud.SaveConfig", function(l, ply)
		
		if !ply:IsSuperAdmin() then return end
		
		if CyberHud.LockedConfig then return end
		
		local config = net.ReadTable()
		
		CyberHud.Config = config
		
		net.Start("CyberHud.GetData")
			net.WriteTable(config)
		net.Send(player.GetAll())
		
		json_table = util.TableToJSON( config, true )
		
		file.Write("cyberhud_config_v2.txt",json_table)
		
	end)

	
	if CyberHud.LockedConfig then return end
	
	if !file.Exists("cyberhud_config_v2.txt","DATA") then
		
		json_table = util.TableToJSON( CyberHud.Config, true )
		
		file.Write("cyberhud_config_v2.txt",json_table)
		
	else
	
		local config = util.JSONToTable(file.Read("cyberhud_config_v2.txt","DATA"))
		
		CyberHud.Config = config
		
		net.Start("CyberHud.GetData")
			net.WriteTable(config)
		net.Send(player.GetAll())
	end
	
end