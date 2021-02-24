-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

local width = 279 * RayHUD.Scale
local height = 194 * RayHUD.Scale

local x = 12 * RayHUD.Scale
local y = ScrH() - height - x

local ply = LocalPlayer()

local SmoothEngine = 0
local SmoothFuel = 0
local Speed = 0
local HP = -1
local Fuel = -1

local MainPanel = vgui.Create("RayHUD:DPanel")
MainPanel:SetSize(width, height) 
MainPanel:SetPos(ScrW() - width - x, y)
MainPanel:ParentToHUD()

local function DrawVCHUD(w, h)
	local veh = ply:GetVehicle()

	if !IsValid(veh) then return end

	width = 279 * RayHUD.Scale
	height = 194 * RayHUD.Scale

	if VC and veh.VC_getHealth and veh:VC_fuelGet(true) > -1 then
		HP = math.floor(veh:VC_getHealth(true))
		Fuel = math.floor(veh:VC_fuelGet(true))

		if GetConVar( "rayhud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end

		FlatUI.DrawMaterialBox(veh:VC_getName(RayHUD.GetPhrase("your_car")), 0, 0, w, h, FlatUI.Icons.Car)
		draw.RoundedBoxEx(10, 0, 41 * RayHUD.Scale, 49 * RayHUD.Scale, h - 41 * RayHUD.Scale, FlatUI.Colors.DarkGray3, false, false, true, false)

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
		surface.DrawTexturedRect(10 * RayHUD.Scale, 50 * RayHUD.Scale, 29 * RayHUD.Scale, 29 * RayHUD.Scale) 

		surface.SetMaterial( FlatUI.Icons.Engine )
		surface.SetDrawColor( EngineCol )
		surface.DrawTexturedRect(10 * RayHUD.Scale, (50 + 35) * RayHUD.Scale, 29 * RayHUD.Scale, 29 * RayHUD.Scale) 

		surface.SetMaterial( FlatUI.Icons.Exhaust )
		surface.SetDrawColor( ExhaustCol )
		surface.DrawTexturedRect(10 * RayHUD.Scale, (50 + 70) * RayHUD.Scale, 29 * RayHUD.Scale, 29 * RayHUD.Scale) 

		surface.SetMaterial( FlatUI.Icons.Tire )
		surface.SetDrawColor( TireCol )
		surface.DrawTexturedRect(10 * RayHUD.Scale, (50 + 70 + 37) * RayHUD.Scale, 29 * RayHUD.Scale, 29 * RayHUD.Scale) 

		SmoothEngine = Lerp(5 * FrameTime(), SmoothEngine, HP)
		local engine = math.Clamp(SmoothEngine, 1, 100) / 100
		FlatUI.CreateBar( 95, 67 + 8, 170 * RayHUD.Scale, 9, FlatUI.Colors.LightHP, FlatUI.Colors.HP, engine, RayHUD.GetPhrase("engine") .. ": " .. HP .. " / 100", FlatUI.Icons.Engine )

		SmoothFuel = Lerp(5 * FrameTime(), SmoothFuel, Fuel)
		local fuel = math.Clamp(SmoothFuel, 1, 100) / 100
		FlatUI.CreateBar( 95, 67 + 34 + 8 * 2, 170 * RayHUD.Scale, 9, FlatUI.Colors.LightGreen, FlatUI.Colors.Green, fuel, RayHUD.GetPhrase("fuel") .. ": " .. Fuel .. " / 100", FlatUI.Icons.Fuel )
	--	FlatUI.CreateBar( 95, 67 + 34 + 8 * 2, 170 * RayHUD.Scale, 9, FlatUI.Colors.LigthGreen2, FlatUI.Colors.Green2, fuel, RayHUD.GetPhrase("fuel") .. ": " .. Fuel .. " / 100", FlatUI.Icons.Fuel )

		surface.SetMaterial( FlatUI.Icons.Speed )
		surface.SetDrawColor( FlatUI.Colors.Armor )
		surface.DrawTexturedRect((95 - 32) * RayHUD.Scale, (67 + 81) * RayHUD.Scale, 27 * RayHUD.Scale, 27 * RayHUD.Scale) 

		draw.RoundedBox(10, 95 * RayHUD.Scale, (67 + 68 + 22 - 10) * RayHUD.Scale, 170 * RayHUD.Scale, 30 * RayHUD.Scale, FlatUI.Colors.DarkGray3) -- Main Panel

		Speed = math.floor(veh:GetVelocity():Length() / (12 * 3280.84 / 3600)) ..  " km/h"

		surface.SetFont("RayHUD.Main:Small")
		draw.SimpleText( Speed, "RayHUD.Main:Small", 95 * RayHUD.Scale + (170 * RayHUD.Scale) / 2 - select(1, surface.GetTextSize(Speed))/2, 153 * RayHUD.Scale, FlatUI.Colors.Armor)
	end
end

local SmoothAmmo = 0
local Props = 0

local PanelIcon = FlatUI.Icons.Build
local BarIcon = FlatUI.Icons.Cube

net.Receive("RayHUD:UpdateProplimit",function(  )
	Props = net.ReadUInt(11)
end)

local function DrawWeaponHUD(w, h)
	local Wep = ply:GetActiveWeapon()
	if !IsValid(Wep) then return end

	MainPanel:SetPos(ScrW() - width - x, ScrH() / 2 - height / 2)

	local Class = Wep:GetClass()
	local BarText

	width = 234 * RayHUD.Scale
	height = 100 * RayHUD.Scale

	if table.HasValue({"gmod_tool", "weapon_physgun", "weapon_physcannon"}, Class) then
		PanelIcon = FlatUI.Icons.Build
		BarIcon = FlatUI.Icons.Cube

		BarText = RayHUD.GetPhrase("props") .. ": " .. Props .. " / " .. GetConVar( "sbox_maxprops" ):GetInt()
		SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, Props / GetConVar( "sbox_maxprops" ):GetInt())
	elseif Wep:Clip1() != -1 and Wep:GetPrimaryAmmoType() != -1 and Class != "weapon_physcannon" then
		PanelIcon = FlatUI.Icons.Pistol
		BarIcon = FlatUI.Icons.Ammo

		BarText = RayHUD.GetPhrase("ammo") .. ": " .. Wep:Clip1() .. " / " .. ply:GetAmmoCount(Wep:GetPrimaryAmmoType())
		SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, Wep:Clip1() / Wep:GetMaxClip1())
	else
		return
	end

	FlatUI.DrawMaterialBox(Wep:GetPrintName(), 0, 0, w, h, PanelIcon)
	FlatUI.CreateBar( 46, 70, 170 * RayHUD.Scale, 9, FlatUI.Colors.LightOrange, FlatUI.Colors.Orange, SmoothAmmo, BarText, BarIcon )
end

MainPanel.Paint = function(self, w, h)
	if GetConVar( "rayhud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end

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