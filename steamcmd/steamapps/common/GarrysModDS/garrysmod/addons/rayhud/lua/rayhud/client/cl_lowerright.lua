-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local width = 278 * RayUI.Scale
local height = 194 * RayUI.Scale

local y = ScrH() - height - RayHUD.OffsetY

local ply = LocalPlayer()

local SmoothEngine = 0
local SmoothFuel = 0
local SmoothRPM = 0
local RPM  = -1
local MaxRPM = -1
local Speed = 0
local HP = -1
local Fuel = -1

local MainPanel = vgui.Create("RayHUD:DPanel")
MainPanel:SetSize(width, height) 
MainPanel:SetPos(ScrW() - width - RayHUD.OffsetX, y)
MainPanel:ParentToHUD()

local function DrawVCHUD(w, h, pnl)
	local veh = ply:GetVehicle()

	if !IsValid(veh) then return end
	if !RayUI.Configuration.GetConfig( "VehicleHUD" ) then return end

	width = 278 * RayUI.Scale
	height = 194 * RayUI.Scale

	if VC and veh.VC_getHealth and veh:VC_fuelGet(true) > -1 then
		RayUI:DrawBlur(pnl)

		HP = math.floor(veh:VC_getHealth(true))
		Fuel = math.floor(veh:VC_fuelGet(true))

		RayUI:DrawMaterialBox(veh:VC_getName(RayUI.GetPhrase("hud", "your_car")), 0, 0, w, h, RayUI.Icons.Car)
		draw.RoundedBoxEx(10, 0, 41 * RayUI.Scale, 49 * RayUI.Scale, h - 41 * RayUI.Scale, RayUI.Colors.DarkGray3, false, false, true, false)

		local parts = veh:VC_getDamagedParts()
		local CarlightCol = RayUI.Colors.DarkGray4
		local EngineCol = RayUI.Colors.DarkGray4
		local ExhaustCol = RayUI.Colors.DarkGray4
		local TireCol = RayUI.Colors.DarkGray4

		if parts["light"] then CarlightCol = RayUI.Colors.Orange else CarlightCol = RayUI.Colors.DarkGray4 end
		if parts["engine"] then EngineCol = RayUI.Colors.Orange else EngineCol = RayUI.Colors.DarkGray4 end
		if parts["exhaust"] then ExhaustCol = RayUI.Colors.Orange else ExhaustCol = RayUI.Colors.DarkGray4 end
		if parts["wheel"] then TireCol = RayUI.Colors.Orange else TireCol = RayUI.Colors.DarkGray4 end

		surface.SetMaterial( RayUI.Icons.CarLight )
		surface.SetDrawColor( CarlightCol )
		surface.DrawTexturedRect(10 * RayUI.Scale, 50 * RayUI.Scale, 29 * RayUI.Scale, 29 * RayUI.Scale) 

		surface.SetMaterial( RayUI.Icons.Engine )
		surface.SetDrawColor( EngineCol )
		surface.DrawTexturedRect(10 * RayUI.Scale, (50 + 35) * RayUI.Scale, 29 * RayUI.Scale, 29 * RayUI.Scale) 

		surface.SetMaterial( RayUI.Icons.Exhaust )
		surface.SetDrawColor( ExhaustCol )
		surface.DrawTexturedRect(10 * RayUI.Scale, (50 + 70) * RayUI.Scale, 29 * RayUI.Scale, 29 * RayUI.Scale) 

		surface.SetMaterial( RayUI.Icons.Tire )
		surface.SetDrawColor( TireCol )
		surface.DrawTexturedRect(10 * RayUI.Scale, (50 + 70 + 37) * RayUI.Scale, 29 * RayUI.Scale, 29 * RayUI.Scale) 

		SmoothEngine = Lerp(5 * FrameTime(), SmoothEngine, HP)
		local engine = math.Clamp(SmoothEngine, 1, 100) / 100
		RayUI:CreateBar( 95 * RayUI.Scale, 75 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightHP, RayUI.Colors.HP, engine, RayUI.GetPhrase("hud", "engine") .. ": " .. HP .. " / 100", RayUI.Icons.Engine )

		SmoothFuel = Lerp(5 * FrameTime(), SmoothFuel, Fuel)
		local fuel = math.Clamp(SmoothFuel, 1, 100) / 100
		RayUI:CreateBar( 95 * RayUI.Scale, 117 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightGreen, RayUI.Colors.Green, fuel, RayUI.GetPhrase("hud", "fuel") .. ": " .. Fuel .. " / 100", RayUI.Icons.Fuel )
	--	RayUI:CreateBar( 95 * RayUI.Scale, 117 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LigthGreen2, RayUI.Colors.Green2, fuel, RayUI.GetPhrase("hud", "fuel") .. ": " .. Fuel .. " / 100", RayUI.Icons.Fuel )

		surface.SetMaterial( RayUI.Icons.Speed )
		surface.SetDrawColor( RayUI.Colors.Armor )
		surface.DrawTexturedRect((95 - 32) * RayUI.Scale, (67 + 81) * RayUI.Scale, 27 * RayUI.Scale, 27 * RayUI.Scale) 

		draw.RoundedBox(10, 95 * RayUI.Scale, (67 + 68 + 22 - 10) * RayUI.Scale, 170 * RayUI.Scale, 30 * RayUI.Scale, RayUI.Colors.DarkGray3) -- Main Panel

		Speed = math.floor(veh:GetVelocity():Length() / (12 * 3280.84 / 3600)) ..  " km/h"

		surface.SetFont("RayUI:Medium2")
		draw.SimpleText( Speed, "RayUI:Medium2", 95 * RayUI.Scale + (170 * RayUI.Scale) / 2 - select(1, surface.GetTextSize(Speed)) / 2, 149 * RayUI.Scale, RayUI.Colors.Armor)
	end
end

local function SimphysHUD(w, h, pnl)
	local veh = ply:GetSimfphys()

	if !IsValid(veh) then return end

	local slushbox = GetConVar( "cl_simfphys_auto" ):GetBool()

	if RayUI.Configuration.GetConfig( "VehicleHUD" ) != true then
		if GetConVar("cl_simfphys_hud"):GetBool() == false then
			GetConVar("cl_simfphys_hud"):SetBool( true )
		end
		return
	else
		if GetConVar("cl_simfphys_hud"):GetBool() then
			GetConVar("cl_simfphys_hud"):SetBool( false )
		end
	end

	local gear = veh:GetGear()
	local DrawGear = !slushbox and (gear == 1 and "R" or gear == 2 and "N" or (gear - 2)) or (gear == 1 and "R" or gear == 2 and "N" or "(".. (gear - 2)..")")

	RayUI:DrawBlur(pnl)

	width = 278 * RayUI.Scale
	height = 194 * RayUI.Scale

	Fuel = math.floor(veh:GetFuel())
	RPM = math.floor(veh:GetRPM())
	MaxRPM = veh:GetLimitRPM()

	RayUI:DrawMaterialBox("Your Car", 0, 0, w, h, RayUI.Icons.Car)
	draw.RoundedBoxEx(10, 0, 41 * RayUI.Scale, 49 * RayUI.Scale, h - 41 * RayUI.Scale, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 30), false, false, true, false)

	local HandBrakeOn = veh:GetHandBrakeEnabled()
	local CruiseControlOn = veh:GetIsCruiseModeOn()
	local FogLightsOn = veh:GetFogLightsEnabled()
	local LightsOn = veh:GetLightsEnabled()
	local LampsOn =  veh:GetLampsEnabled()

	local HandBrakeCol = HandBrakeOn and RayUI.Colors.Red or RayUI.Colors.DarkGray4
	local CruiseControlCol = CruiseControlOn and RayUI.Colors.Yellow or RayUI.Colors.DarkGray4
	local FogLightCol = FogLightsOn and RayUI.Colors.Orange or RayUI.Colors.DarkGray4
	local CarlightCol = LightsOn and (LampsOn and RayUI.Colors.Blue or RayUI.Colors.Green) or RayUI.Colors.DarkGray4

	// Handbrake Icon
	surface.SetMaterial( RayUI.Icons.HandBrake )
	surface.SetDrawColor( HandBrakeCol )
	surface.DrawTexturedRect(10 * RayUI.Scale, 50 * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale) 

	// Cruise Control Icon
	surface.SetMaterial( RayUI.Icons.CruiseControl )
	surface.SetDrawColor( CruiseControlCol )
	surface.DrawTexturedRect(8 * RayUI.Scale, (50 + 35) * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale) 
		
	// Fog Lights Icon
	surface.SetMaterial( RayUI.Icons.FogLight )
	surface.SetDrawColor( FogLightCol )
	surface.DrawTexturedRect(10 * RayUI.Scale, (50 + 70) * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale) 

	// Lights Icon
	surface.SetMaterial( RayUI.Icons.CarLight )
	surface.SetDrawColor( CarlightCol )
	surface.DrawTexturedRect(10 * RayUI.Scale, (50 + 70 + 37) * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale) 

	// Fuel
	SmoothFuel = Lerp(5 * FrameTime(), SmoothFuel, Fuel)
	local fuel = math.Clamp(SmoothFuel, 1, 100) / 100
	RayUI:CreateBar( 95 * RayUI.Scale, 75 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightGreen, RayUI.Colors.Green, fuel, RayUI.GetPhrase("hud", "fuel") .. ": " .. Fuel .. " / 100", RayUI.Icons.Fuel )

	// RPM
	local rpmcol = RPM != MaxRPM and RayUI.Colors.Gray3 or RayUI.Colors.Red
	local rpm = math.Clamp(SmoothRPM, 1, MaxRPM) / MaxRPM
	SmoothRPM = Lerp(5 * FrameTime(), SmoothRPM, RPM)
	RayUI:CreateBar( 95 * RayUI.Scale, 116 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightGray, rpmcol, rpm, "RPM: " .. RPM, RayUI.Icons.Speed )

	-- Speed-o-meter and gear
	draw.RoundedBox(10, 65 * RayUI.Scale, (67 + 68 + 12) * RayUI.Scale, 160 * RayUI.Scale, 30 * RayUI.Scale, RayUI.Colors.DarkGray3)
	draw.RoundedBox(10, 234 * RayUI.Scale, (67 + 68 + 12) * RayUI.Scale, 30 * RayUI.Scale, 30 * RayUI.Scale, RayUI.Colors.DarkGray3)

	Speed = math.Round(veh:GetVelocity():Length() * 0.09144, 0) ..  " km/h"

	surface.SetFont("RayUI:Medium2")
	draw.SimpleText( Speed, "RayUI:Medium2", 65 * RayUI.Scale + (160 * RayUI.Scale) / 2 - select(1, surface.GetTextSize(Speed))/2, 149 * RayUI.Scale, RayUI.Colors.Armor)
	draw.SimpleText( DrawGear, "RayUI:Medium2", 234 * RayUI.Scale + (30 * RayUI.Scale) / 2 - select(1, surface.GetTextSize(DrawGear))/2, 149 * RayUI.Scale, RayUI.Colors.Armor)
end

local isSVHUDVisible = true
local function DrawSVHUD(w, h, pnl)

	local veh = ply:GetVehicle()

	if !IsValid(veh) then return end

	if RayUI.Configuration.GetConfig( "VehicleHUD" ) == true then
		if isSVHUDVisible then
			SVMOD:DisableHUD()
			isSVHUDVisible = false
		end
	end

	RayUI:DrawBlur(pnl)

	width = 229 * RayUI.Scale
	height = 194 * RayUI.Scale

	HP = math.floor(veh:SV_GetPercentHealth())
	Fuel = math.floor(veh:SV_GetPercentFuel())

	RayUI:DrawMaterialBox("Your Car", 0, 0, w, h, RayUI.Icons.Car)

	// Health
	SmoothEngine = Lerp(5 * FrameTime(), SmoothEngine, HP)
	local engine = math.Clamp(SmoothEngine, 1, 100) / 100
	RayUI:CreateBar( 46 * RayUI.Scale, 75 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightHP, RayUI.Colors.HP, engine, RayUI.GetPhrase("hud", "engine") .. ": " .. HP .. " / 100", RayUI.Icons.Engine )

	// Fuel
	SmoothFuel = Lerp(5 * FrameTime(), SmoothFuel, Fuel)
	local fuel = math.Clamp(SmoothFuel, 1, 100) / 100
	RayUI:CreateBar( 46 * RayUI.Scale, 117 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightGreen, RayUI.Colors.Green, fuel, RayUI.GetPhrase("hud", "fuel") .. ": " .. Fuel .. " / 100", RayUI.Icons.Fuel )

	// Speed-o-meter
	surface.SetMaterial( RayUI.Icons.Speed )
	surface.SetDrawColor( RayUI.Colors.Armor )
	surface.DrawTexturedRect((46 - 32) * RayUI.Scale, (67 + 81) * RayUI.Scale, 27 * RayUI.Scale, 27 * RayUI.Scale) 

	draw.RoundedBox(10, 46 * RayUI.Scale, (67 + 68 + 22 - 10) * RayUI.Scale, 170 * RayUI.Scale, 30 * RayUI.Scale, RayUI.Colors.DarkGray3) -- Main Panel

	Speed = veh:SV_GetCachedSpeed() ..  " km/h"

	surface.SetFont("RayUI:Medium2")
	draw.SimpleText( Speed, "RayUI:Medium2", 46 * RayUI.Scale + (170 * RayUI.Scale) / 2 - select(1, surface.GetTextSize(Speed)) / 2, 149 * RayUI.Scale, RayUI.Colors.Armor)
end

local SmoothAmmo = 0
local Props = 0

local PanelIcon = RayUI.Icons.Build
local BarIcon = RayUI.Icons.Cube

net.Receive("RayHUD:UpdateProplimit",function(  )
	Props = net.ReadUInt(11)
end)

local function DrawWeaponHUD(w, h, pnl)

	local Wep = ply:GetActiveWeapon()
	if !IsValid(Wep) then return end

	local Class = Wep:GetClass()
	local BarText

	width = 234 * RayUI.Scale
	height = 100 * RayUI.Scale

	if table.HasValue({"gmod_tool", "weapon_physgun", "weapon_physcannon"}, Class) then
		RayUI:DrawBlur(pnl)
		PanelIcon = RayUI.Icons.Build
		BarIcon = RayUI.Icons.Cube

		BarText = RayUI.GetPhrase("hud", "props") .. ": " .. Props .. " / " .. GetConVar( "sbox_maxprops" ):GetInt()
		SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, Props / GetConVar( "sbox_maxprops" ):GetInt())
	elseif Wep:Clip1() != -1 and Wep:GetPrimaryAmmoType() != -1 and Class != "weapon_physcannon" then
		RayUI:DrawBlur(pnl)
		PanelIcon = RayUI.Icons.Pistol
		BarIcon = RayUI.Icons.Ammo

		BarText = RayUI.GetPhrase("hud", "ammo") .. ": " .. Wep:Clip1() .. " / " .. ply:GetAmmoCount(Wep:GetPrimaryAmmoType())
		SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, Wep:Clip1() / Wep:GetMaxClip1())
	else
		return
	end

	RayUI:DrawMaterialBox(Wep:GetPrintName(), 0, 0, w, h, PanelIcon)
	RayUI:CreateBar( 46 * RayUI.Scale, 70 * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightOrange, RayUI.Colors.Orange, SmoothAmmo, BarText, BarIcon )

end

MainPanel.Paint = function(self, w, h)
	if ply:InVehicle() then
		if Photon and ply:GetVehicle():IsEMV() and self:GetX() != (ScrW() - width - RayHUD.OffsetX * 2 - 170) then
			self:SetPos(ScrW() - width - RayHUD.OffsetX * 2 - 170, ScrH() - height - RayHUD.OffsetY)
		else
			if self:GetX() != (ScrW() - width - RayHUD.OffsetX) then
				self:SetPos(ScrW() - width - RayHUD.OffsetX, ScrH() - height - RayHUD.OffsetY)
			end
		end

		if simfphys and GetConVar( "cl_simfphys_auto" ) then
			SimphysHUD(w, h, self)
		elseif VC then
			DrawVCHUD(w, h, self)
		elseif SVMOD and SVMOD:IsVehicle(ply:GetVehicle()) then
			DrawSVHUD(w, h, self)
		end

	elseif ply:GetActiveWeapon() then
		if self:GetX() != (ScrW() - width - RayHUD.OffsetX) then
			self:SetPos(ScrW() - width - RayHUD.OffsetX, ScrH() - height - RayHUD.OffsetY)
		end

		DrawWeaponHUD(w, h, self)
	end

	if (self:GetWide() != width and self:GetTall() != height) then
		self:SetSize(width, height)

		if ply:InVehicle() and Photon and ply:GetVehicle():IsEMV() and self:GetX() != (ScrW() - width - RayHUD.OffsetX * 2 - 170) then
			self:SetPos(ScrW() - width - RayHUD.OffsetX * 2 - 170, ScrH() - height - RayHUD.OffsetY)
		else
			self:SetPos(ScrW() - width - RayHUD.OffsetX, ScrH() - height - RayHUD.OffsetY)
		end
	end
end

local VCModHUD = {
--	["VCMod"] = true,
	["VCMod_Damage"] = true,
	["VCMod_Fuel"] = true,
	["VCMod_Health"] = true,
	["VCMod_Icons"] = true,
	["VCMod_Name"] = true,
}

hook.Add("HUDShouldDraw", "RayHUD:HideVCModHUD", function( name )
	if RayUI.Configuration.GetConfig( "VehicleHUD" ) and VCModHUD[name] then return false end
end)

hook.Add("RayHUD:Reload","RayHUD:UnloadHideVCModHUD",function(  )
	hook.Remove("HUDShouldDraw", "RayHUD:HideVCModHUD")
end)
