-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

local width = 279 * FlatHUD.Scale
local height = 194 * FlatHUD.Scale

local x = 12 * FlatHUD.Scale
local y = ScrH() - height - x

local ply = LocalPlayer()

local SmoothEngine = 0
local SmoothFuel = 0
local Speed = 0
local HP = -1
local Fuel = -1

local MainPanel = vgui.Create("FlatHUD:DPanel")
MainPanel:SetSize(width, height) 
MainPanel:SetPos(ScrW() - width - x, y)
MainPanel:ParentToHUD()

local function DrawVCHUD(w, h)
	local veh = ply:GetVehicle()

	if !IsValid(veh) then return end

	width = 279 * FlatHUD.Scale
	height = 194 * FlatHUD.Scale

	if VC and veh.VC_getHealth and veh:VC_fuelGet(true) > -1 then
		HP = math.floor(veh:VC_getHealth(true))
		Fuel = math.floor(veh:VC_fuelGet(true))

		if GetConVar( "flathud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end

		FlatUI.DrawMaterialBox(veh:VC_getName(FlatHUD.GetPhrase("your_car")), 0, 0, w, h, FlatUI.Icons.Car)
		draw.RoundedBoxEx(10, 0, 41 * FlatHUD.Scale, 49 * FlatHUD.Scale, h - 41 * FlatHUD.Scale, FlatUI.Colors.DarkGray3, false, false, true, false)

		local parts = veh:VC_getDamagedParts()
		local CarlightCol = FlatUI.Colors.DarkGray4
		local EngineCol = FlatUI.Colors.DarkGray4
		local ExhaustCol = FlatUI.Colors.DarkGray4
		local TireCol = FlatUI.Colors.DarkGray4

		if parts["light"] then CarlightCol = FlatUI.Colors.Orange else CarlightCol = FlatUI.Colors.DarkGray4 end
		if parts["engine"] then EngineCol = FlatUI.Colors.Orange else EngineCol = FlatUI.Colors.DarkGray4 end
		if parts["exhaust"] then ExhaustCol = FlatUI.Colors.Orange else ExhaustCol = FlatUI.Colors.DarkGray4 end
		if parts["wheel"] then TireCol = FlatUI.Colors.Orange else TireCol = FlatUI.Colors.DarkGray4 end

		surface.SetMaterial( FlatUI.Icons.CarLight )
		surface.SetDrawColor( CarlightCol )
		surface.DrawTexturedRect(10 * FlatHUD.Scale, 50 * FlatHUD.Scale, 29 * FlatHUD.Scale, 29 * FlatHUD.Scale) 

		surface.SetMaterial( FlatUI.Icons.Engine )
		surface.SetDrawColor( EngineCol )
		surface.DrawTexturedRect(10 * FlatHUD.Scale, (50 + 35) * FlatHUD.Scale, 29 * FlatHUD.Scale, 29 * FlatHUD.Scale) 

		surface.SetMaterial( FlatUI.Icons.Exhaust )
		surface.SetDrawColor( ExhaustCol )
		surface.DrawTexturedRect(10 * FlatHUD.Scale, (50 + 70) * FlatHUD.Scale, 29 * FlatHUD.Scale, 29 * FlatHUD.Scale) 

		surface.SetMaterial( FlatUI.Icons.Tire )
		surface.SetDrawColor( TireCol )
		surface.DrawTexturedRect(10 * FlatHUD.Scale, (50 + 70 + 37) * FlatHUD.Scale, 29 * FlatHUD.Scale, 29 * FlatHUD.Scale) 

		SmoothEngine = Lerp(5 * FrameTime(), SmoothEngine, HP)
		local engine = math.Clamp(SmoothEngine, 1, 100) / 100
		FlatUI.CreateBar( 95, 67 + 8, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LightHP, FlatUI.Colors.HP, engine, FlatHUD.GetPhrase("engine") .. ": " .. HP .. " / 100", FlatUI.Icons.Engine )

		SmoothFuel = Lerp(5 * FrameTime(), SmoothFuel, Fuel)
		local fuel = math.Clamp(SmoothFuel, 1, 100) / 100
		FlatUI.CreateBar( 95, 67 + 34 + 8 * 2, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LightGreen, FlatUI.Colors.Green, fuel, FlatHUD.GetPhrase("fuel") .. ": " .. Fuel .. " / 100", FlatUI.Icons.Fuel )
	--	FlatUI.CreateBar( 95, 67 + 34 + 8 * 2, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LigthGreen2, FlatUI.Colors.Green2, fuel, FlatHUD.GetPhrase("fuel") .. ": " .. Fuel .. " / 100", FlatUI.Icons.Fuel )

		surface.SetMaterial( FlatUI.Icons.Speed )
		surface.SetDrawColor( FlatUI.Colors.Armor )
		surface.DrawTexturedRect((95 - 32) * FlatHUD.Scale, (67 + 81) * FlatHUD.Scale, 27 * FlatHUD.Scale, 27 * FlatHUD.Scale) 

		draw.RoundedBox(10, 95 * FlatHUD.Scale, (67 + 68 + 22 - 10) * FlatHUD.Scale, 170 * FlatHUD.Scale, 30 * FlatHUD.Scale, FlatUI.Colors.DarkGray3) -- Main Panel

		Speed = math.floor(veh:GetVelocity():Length() / (12 * 3280.84 / 3600)) ..  " km/h"

		surface.SetFont("FlatHUD.Main:Small")
		draw.SimpleText( Speed, "FlatHUD.Main:Small", 95 * FlatHUD.Scale + (170 * FlatHUD.Scale) / 2 - select(1, surface.GetTextSize(Speed))/2, 153 * FlatHUD.Scale, FlatUI.Colors.Armor)
	end
end

local SmoothAmmo = 0
local Props = 0

local PanelIcon = FlatUI.Icons.Build
local BarIcon = FlatUI.Icons.Cube

net.Receive("FlatHUD:UpdateProplimit",function(  )
	Props = net.ReadUInt(11)
end)

local function DrawWeaponHUD(w, h)
	local Wep = ply:GetActiveWeapon()
	if !IsValid(Wep) then return end

	MainPanel:SetPos(ScrW() - width - x, ScrH() / 2 - height / 2)

	local Class = Wep:GetClass()
	local BarText

	width = 234 * FlatHUD.Scale
	height = 100 * FlatHUD.Scale

	if table.HasValue({"gmod_tool", "weapon_physgun", "weapon_physcannon"}, Class) then
		PanelIcon = FlatUI.Icons.Build
		BarIcon = FlatUI.Icons.Cube

		BarText = FlatHUD.GetPhrase("props") .. ": " .. Props ..
		SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, Props)
	elseif Wep:Clip1() != -1 and Wep:GetPrimaryAmmoType() != -1 and Class != "weapon_physcannon" then
		PanelIcon = FlatUI.Icons.Pistol
		BarIcon = FlatUI.Icons.Ammo

		BarText = FlatHUD.GetPhrase("ammo") .. ": " .. Wep:Clip1() .. " / " .. ply:GetAmmoCount(Wep:GetPrimaryAmmoType())
		SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, Wep:Clip1() / Wep:GetMaxClip1())
	else
		return
	end

	FlatUI.DrawMaterialBox(Wep:GetPrintName(), 0, 0, w, h, PanelIcon)
	FlatUI.CreateBar( 46, 70, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LightOrange, FlatUI.Colors.Orange, SmoothAmmo, BarText, BarIcon )
end

MainPanel.Paint = function(self, w, h)
	if GetConVar( "flathud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end

	if ply:InVehicle() then
		DrawVCHUD(w, h)
	elseif ply:GetActiveWeapon() then
		DrawWeaponHUD(w, h)
	end

	if (self:GetWide() != width and self:GetTall() != height) then
		self:SetSize(width, height)
		self:SetPos(ScrW() - width - x, ScrH() - height - x)
	end
end