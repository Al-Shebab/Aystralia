-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝─────── Hooks ─────--

CyberHud.WPS = {
	Slot = 0,
	Pos = 1,
	TimeSelect = 0,
	TimeOpen = CurTime(),
	CountWeapon = 0,
	Cashe = {},
	CasheLength = {},
}

for i = 1, 6 do
	CyberHud.WPS.Cashe[i] = {}
	CyberHud.WPS.CasheLength[i] = 0
end

function CyberHud.UpdateHookInfo()
	
	local hideElements = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true,
		["CHudDamageIndicator"] = true,
		["CHudWeaponSelection"] = CyberHud.Config.WeaponSelectionHud,
		["DarkRP_HUD"] = true,
		["DarkRP_EntityDisplay"] = true,
		["DarkRP_LocalPlayerHUD"] = true,
		["DarkRP_Hungermod"] = true,
		["DarkRP_Agenda"] = true,
		["DarkRP_LockdownHUD"] = true,
		["DarkRP_ArrestedHUD"] = true,
	}
	
	hook.Add("HUDShouldDraw", "CyberHud.HUDShouldDraw", function(name)
		if hideElements[name] then return false end
	end)
	
end

CyberHud.UpdateHookInfo()

hook.Add( "HUDPaint", "CyberHud.HUDPaint", function()
	
	if !IsValid(LocalPlayer()) and GetConVarNumber("cl_drawhud") == 0 then
		return
	end
	
	local enable, int = CyberHud.VitalSigns()
	
	CyberHud.PreDrawGlitch(enable)
	
	CyberHud.DrawInfo()
	
	CyberHud.DrawAmmo()
	
	CyberHud.PlayerInfo()
	
	CyberHud.DrawEntInfo()
	
	CyberHud.DrawNotifications()
	
	CyberHud.PostDrawGlitch(enable, int)
	
	CyberHud.DrawBigNotifications()

end)

local function CyberHudPrecasheWeapons()

	for i = 1, 6 do
		for j = 1, CyberHud.WPS.CasheLength[i] do
			CyberHud.WPS.Cashe[i][j] = nil
		end
		CyberHud.WPS.CasheLength[i] = 0
	end

	CyberHud.WPS.CountWeapon = 0

	for _, wep in pairs(LocalPlayer():GetWeapons()) do
		CyberHud.WPS.CountWeapon = CyberHud.WPS.CountWeapon + 1
		local slot = wep:GetSlot() + 1

		if (slot <= 6) then
			local length = CyberHud.WPS.CasheLength[slot] + 1
			CyberHud.WPS.CasheLength[slot] = length
			CyberHud.WPS.Cashe[slot][length] = wep
		end
	end

	if CyberHud.WPS.Slot ~= 0 then
		local length = CyberHud.WPS.CasheLength[CyberHud.WPS.Slot]

		if length < CyberHud.WPS.Pos then
			if (length == 0) then
				CyberHud.WPS.Slot = 0
			else
				CyberHud.WPS.Pos = length
			end
		end
	end
end

hook.Add("PlayerBindPress", "CyberHud.WeaponSelector", function(ply, bind, pressed)

	if !CyberHud.Config.WeaponSelectionHud then return end
	if !ply:Alive() or ply:InVehicle() and !ply:GetAllowWeaponsInVehicle() then return end
	
	bind = string.lower(bind)
	
	if bind:sub(1, 4) == "slot" then
	
		local slot = tonumber(bind:sub(5))
		
		CyberHud.WPS.TimeOpen = CurTime()
		
		if slot == nil then return end
		
		if !pressed then return true end

		CyberHudPrecasheWeapons()
		
		if CyberHud.WPS.CountWeapon == 0 then return true end

		if slot <= 6 then
			if slot == CyberHud.WPS.Slot then
				if (CyberHud.WPS.Pos == CyberHud.WPS.CasheLength[CyberHud.WPS.Slot]) then
					CyberHud.WPS.Pos = 1
				else
					CyberHud.WPS.Pos = CyberHud.WPS.Pos + 1
				end
			elseif CyberHud.WPS.CasheLength[slot] ~= 0 then
				CyberHud.WPS.Slot = slot
				CyberHud.WPS.Pos = 1
			end

			CyberHud.WPS.TimeSelect = RealTime()
		end
		
		surface.PlaySound(CyberHud.Config.Weapon_Scr)
		
	end
	
	if CyberHud.WPS.Slot ~= 0 then
		if bind == "+attack" then
		
			local wep = CyberHud.WPS.Cashe[CyberHud.WPS.Slot][CyberHud.WPS.Pos]
			CyberHud.WPS.Slot = 0
			
			if wep:IsValid() and wep ~= ply:GetActiveWeapon() then
				input.SelectWeapon(wep)
			end

			CyberHud.WPS.TimeSelect = RealTime()
			
			surface.PlaySound(CyberHud.Config.Weapon_Sel)
			
			return true
		end

		if bind == "+attack2" then
			CyberHud.WPS.TimeSelect = RealTime()
			CyberHud.WPS.Slot = 0
			
			surface.PlaySound(CyberHud.Config.Weapon_Sel)
			
			return true
		end
	end
	
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "weapon_physgun" and (input.IsKeyDown(KEY_E) or input.IsMouseDown(MOUSE_LEFT)) then
		return
	end
	
--	if IsValid(ply:GetActiveWeapon()) and  ply:GetActiveWeapon():GetClass() == "gmod_tool" then
--		return "76561198166995699"
--	end
	
	if bind == "invprev" then
	
		if !pressed then return true end
		
		CyberHud.WPS.TimeOpen = CurTime()
		CyberHudPrecasheWeapons()

		if CyberHud.WPS.CountWeapon == 0 then return true end

		local loop = CyberHud.WPS.Slot == 0
		
		if loop then
			local ply_wep = ply:GetActiveWeapon()

			if ply_wep:IsValid() then
				local slot = ply_wep:GetSlot() + 1
				local cash = CyberHud.WPS.Cashe[slot]
				
				if cash == nil then return end
				
				if cash and (cash[1] ~= ply_wep) then
					CyberHud.WPS.Slot = slot
					CyberHud.WPS.Pos = 1

					for i = 2, CyberHud.WPS.CasheLength[slot] do
						if (cash[i] == ply_wep) then
							CyberHud.WPS.Pos = i - 1

							break
						end
					end

					CyberHud.WPS.TimeSelect = RealTime()
				end

				CyberHud.WPS.Slot = slot
			end
		end

		if loop or CyberHud.WPS.Pos == 1 then
			repeat
				if CyberHud.WPS.Slot <= 1 then
					CyberHud.WPS.Slot = 6
				else
					CyberHud.WPS.Slot = CyberHud.WPS.Slot - 1
				end
			until(CyberHud.WPS.CasheLength[CyberHud.WPS.Slot] ~= 0)

			CyberHud.WPS.Pos = CyberHud.WPS.CasheLength[CyberHud.WPS.Slot]
		else
			CyberHud.WPS.Pos = CyberHud.WPS.Pos - 1
		end

		CyberHud.WPS.TimeSelect = RealTime()
		
		surface.PlaySound(CyberHud.Config.Weapon_Scr)
		
	end

	if bind == "invnext" then
		if !pressed then return true 
		end
		CyberHud.WPS.TimeOpen = CurTime()
		CyberHudPrecasheWeapons()

		if CyberHud.WPS.CountWeapon == 0 then
			return true
		end

		local loop = CyberHud.WPS.Slot == 0
		
		if loop then
			local ply_wep = ply:GetActiveWeapon()

			if ply_wep:IsValid() then
				local slot = ply_wep:GetSlot() + 1
				local length = CyberHud.WPS.CasheLength[slot]
				local slot_c = CyberHud.WPS.Cashe[slot]
					
				if slot_c == nil then return end
					
				if slot_c[length] ~= ply_wep then
					CyberHud.WPS.Slot = slot
					CyberHud.WPS.Pos = 1

					for i = 1, length - 1 do
						if (slot_c[i] == ply_wep) then
							CyberHud.WPS.Pos = i + 1
							break
						end
					end

					CyberHud.WPS.TimeSelect = RealTime()

				end

				CyberHud.WPS.Slot = slot
			end
		end

		if loop or CyberHud.WPS.Pos == CyberHud.WPS.CasheLength[CyberHud.WPS.Slot] then
			repeat
				if (CyberHud.WPS.Slot == 6) then
					CyberHud.WPS.Slot = 1
				else
					CyberHud.WPS.Slot = CyberHud.WPS.Slot + 1
				end
			until(CyberHud.WPS.CasheLength[CyberHud.WPS.Slot] ~= 0)

			CyberHud.WPS.Pos = 1
		else
			CyberHud.WPS.Pos = CyberHud.WPS.Pos + 1
		end

		CyberHud.WPS.TimeSelect = RealTime()
		
		surface.PlaySound(CyberHud.Config.Weapon_Scr)
		
	end
end)

hook.Add( "PostDrawOpaqueRenderables", "CyberHud.PostDrawOpaqueRenderables", function()
	CyberHud.DrawDoorinfo()	
end)

function GAMEMODE:HUDWeaponPickedUp(wep)
	if not (IsValid(wep) and IsValid(LocalPlayer())) or (not LocalPlayer():Alive()) then return end

	local name = wep.GetPrintName and wep:GetPrintName() or wep:GetClass() or "Unknown Weapon Name"
	
	notification.AddLegacy( name, 5, 5, true )
	
	CyberHud.PlayerSwitchWeapon()
end

function GAMEMODE:HUDItemPickedUp( itemname )
	
	if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end
	
	notification.AddLegacy( language.GetPhrase(itemname), 5, 5, true )
	
end

function GAMEMODE:HUDAmmoPickedUp( itemname, amount )

	if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end
	
	notification.AddLegacy( language.GetPhrase(itemname.."_ammo" ).. " ".. amount, 6, 5, true )
	
end

function GAMEMODE.DrawDeathNotice() end