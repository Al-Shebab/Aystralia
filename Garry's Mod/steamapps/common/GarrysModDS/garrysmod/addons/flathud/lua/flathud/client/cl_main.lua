-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

-- HUD Icons --


-- Variables --
local width = 390 * FlatHUD.Scale
local height = 200 * FlatHUD.Scale

local x = 12 * FlatHUD.Scale
local y = ScrH() - height - x

local bar_x = 205

local SmoothHealth = 0
local SmoothArmor = 0
local SmoothHunger = 0

local ply = LocalPlayer()

local main_y = 8 * FlatHUD.Scale

-- ConVars --
CreateClientConVar("flathud_crashscreen", FlatHUD.Cfg.CrashScreen and 1 or 0, true, false)
CreateClientConVar("flathud_minimal_mode", FlatHUD.Cfg.MiniMode and 1 or 0, true, false)

CreateClientConVar("flathud_role_color", FlatHUD.Cfg.TeamColor and 1 or 0, true, false)
FlatHUD.TeamCol = (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.Cfg.TeamColor or GetConVar( "flathud_role_color" ):GetInt())

CreateClientConVar("flathud_blur", FlatHUD.Cfg.BlurMode and 1 or 0, true, false)
FlatHUD.Blur = (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.Cfg.Opacity or GetConVar( "flathud_blur" ):GetInt())

-- Fonts --
local fontname = "Caviar Dreams Bold"

surface.CreateFont("FlatHUD.Main:Small", {font = fontname, size = 18 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD.Main:Medium", {font = fontname, size = 22 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD.Main:Big", {font = fontname, size = 27 * FlatHUD.Scale, extended = true})

surface.CreateFont("FlatHUD:TopRight", {font = fontname, size = 20 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD:Notification", {font = fontname, size = 24 * FlatHUD.Scale, extended = true})

surface.CreateFont("FlatHUD.2D3D:DoorHeader", {font = fontname, size = 52 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD.2D3D:DoorSubHeader", {font = fontname, size = 30 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD.2D3D:Name", {font = fontname, size = 60 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD.2D3D:Job", {font = fontname, size = 40 * FlatHUD.Scale, extended = true})

surface.CreateFont("FlatHUD.CrashScreen:Big", {font = fontname, size = 120 * FlatHUD.Scale, extended = true})
surface.CreateFont("FlatHUD.CrashScreen:Small", {font = fontname, size = 36 * FlatHUD.Scale, extended = true})

surface.CreateFont("FlatHUD:VoiceVisualiser", {font = fontname, size = 22 * FlatHUD.Scale, extended = true})

surface.CreateFont("FlatHUD.Settings:Small", {font = fontname, size = 17 * FlatHUD.Scale, extended = true})

surface.CreateFont("FlatHUD.Settings:Smaller", {font = fontname, size = 15 * FlatHUD.Scale, extended = true})

--

if GetConVar( "flathud_minimal_mode" ):GetBool() then width = 230 * FlatHUD.Scale; bar_x = 44 end

local MainPanel = vgui.Create("FlatHUD:DPanel")
MainPanel:SetSize(width, height)
MainPanel:SetPos(x, y)
MainPanel:ParentToHUD()
MainPanel.Paint = function (self, w, h)
	if GetConVar( "flathud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end

	FlatUI.DrawMaterialBox(!GetConVar( "flathud_minimal_mode" ):GetBool() and ply:GetName() or "", 0, 0, w, h, ply:IsSpeaking() and FlatUI.Icons.Sound)

	if !GetConVar( "flathud_minimal_mode" ):GetBool() then
		draw.RoundedBoxEx(FlatHUD.Rounding, 0, 41 * FlatHUD.Scale, 160 * FlatHUD.Scale, h - 41 * FlatHUD.Scale, Color(FlatUI.Colors.DarkGray.r, FlatUI.Colors.DarkGray.g, FlatUI.Colors.DarkGray.b, FlatHUD.Opacity + 20), false, false, true, false) -- Left Part

		surface.SetFont( "FlatHUD.Main:Medium" )
		local JobSize = select(1, surface.GetTextSize( team.GetName(ply:Team())))

		draw.RoundedBox(math.Clamp(FlatHUD.Rounding, 0, 24), (160 * FlatHUD.Scale - (JobSize + 12)) / 2, 155 * FlatHUD.Scale, JobSize + 12 * FlatHUD.Scale, 35 * FlatHUD.Scale, FlatUI.Colors.DarkGray2) -- Nick and Job background
		draw.SimpleText( team.GetName(ply:Team()), "FlatHUD.Main:Medium", (160 * FlatHUD.Scale - JobSize) / 2, (67 + 68 + 26) * FlatHUD.Scale, team.GetColor(ply:Team()) )
	end

	local WantedColor = FlatUI.Colors.Gray
	local PistolIconColor = FlatUI.Colors.Gray

	if ply:getDarkRPVar("wanted") == true then
		WantedColor = FlatUI.Colors.White
	elseif ply:getDarkRPVar("Arrested") == true then
		WantedColor = FlatUI.Colors.HP
	end

	if ply:getDarkRPVar("HasGunlicense") == true then
		PistolIconColor = FlatUI.Colors.White
	end
	surface.SetMaterial( FlatUI.Icons.Handcuffs )
	surface.SetDrawColor( WantedColor )
	surface.DrawTexturedRect(width - 40 * FlatHUD.Scale, 4 * FlatHUD.Scale, 33 * FlatHUD.Scale, 33 * FlatHUD.Scale)
	
	surface.SetMaterial( FlatUI.Icons.Pistol )
	surface.SetDrawColor( PistolIconColor )
	surface.DrawTexturedRect(width - 80 * FlatHUD.Scale, 4 * FlatHUD.Scale, 33 * FlatHUD.Scale, 33 * FlatHUD.Scale)
	
	-- Hunger Bar
	if !DarkRP.disabledDefaults["modules"]["hungermod"] then
		main_y = 0
		
		local energy = math.ceil(ply:getDarkRPVar("Energy") or 0)
		SmoothHunger = Lerp(5 * FrameTime(), SmoothHunger, energy)
		local hunger = math.Clamp(SmoothHunger, 0, 100) / 100
		FlatUI.CreateBar( bar_x, 67 + 34 + 34, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LightOrange, FlatUI.Colors.Orange, hunger, FlatHUD.GetPhrase("hunger") .. ": " .. energy .. " / 100", FlatUI.Icons.Food )
	end

	-- Health Bar
	SmoothHealth = Lerp(5 * FrameTime(), SmoothHealth, ply:Health())
	local hl = math.Clamp(SmoothHealth, 1, ply:GetMaxHealth()) / ply:GetMaxHealth()
	local HPText = FlatHUD.GetPhrase("health") .. ": " .. math.Clamp(ply:Health(), 0, ply:Health()) .. " / " .. ply:GetMaxHealth()
	local Var = math.Clamp(  math.abs( math.sin( CurTime() * 5 ) ), 0.75, 1 )
	local HPColor = FlatUI.Colors.HP
	if ply:Health() <= 20 then
		HPColor = Color( Var * 198, Var * 40, Var * 40 )
	end
	FlatUI.CreateBar( bar_x, 67 + main_y, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LightHP, HPColor, hl, HPText, FlatUI.Icons.Heart )

	-- Armor Bar
	SmoothArmor = Lerp(5 * FrameTime(), SmoothArmor, ply:Armor())
	local armor = math.Clamp(SmoothArmor, 1, 255) / 255
	FlatUI.CreateBar( bar_x, 67 + 34 + main_y * 2, 170 * FlatHUD.Scale, 9, FlatUI.Colors.LightArmor, FlatUI.Colors.Armor, armor, FlatHUD.GetPhrase("armor") .. ": " .. ply:Armor() .. " / 255", FlatUI.Icons.Shield )

	-- Money Bar
	surface.SetMaterial( FlatUI.Icons.Money )
	surface.SetDrawColor( FlatUI.Colors.Green )
	surface.DrawTexturedRect((bar_x - 32) * FlatHUD.Scale, (67 + 22 + 34 + 35 - main_y) * FlatHUD.Scale, 27 * FlatHUD.Scale, 27 * FlatHUD.Scale)

	draw.RoundedBox(math.Clamp(FlatHUD.Rounding, 0, 24), bar_x * FlatHUD.Scale, (67 + 68 + 22 - main_y) * FlatHUD.Scale, 110 * FlatHUD.Scale, 30 * FlatHUD.Scale, FlatUI.Colors.DarkGray3)
	draw.RoundedBox(math.Clamp(FlatHUD.Rounding, 0, 24), (bar_x + 115) * FlatHUD.Scale, (67 + 68 + 22 - main_y) * FlatHUD.Scale, 55 * FlatHUD.Scale, 30 * FlatHUD.Scale, FlatUI.Colors.DarkGray3)

	surface.SetFont("FlatHUD.Main:Small")
	draw.SimpleText( "+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary")), "FlatHUD.Main:Small", (bar_x + 115 + 55 / 2) * FlatHUD.Scale - select(1, surface.GetTextSize("+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary")))) / 2, (163 - main_y) * FlatHUD.Scale, FlatUI.Colors.Orange )
end

local lerpedMoney = ply:getDarkRPVar("money") or 0

local SalaryText = vgui.Create("DLabel", MainPanel)
SalaryText:SetText(DarkRP.formatMoney(lerpedMoney))
SalaryText:SetTextColor(FlatUI.Colors.Green)
SalaryText:SetFont("FlatHUD.Main:Small")
SalaryText:SizeToContents()
SalaryText:SetPos((bar_x + 110 / 2) * FlatHUD.Scale - SalaryText:GetWide() / 2, (163 - main_y) * FlatHUD.Scale)

SalaryText.Think = function(self)
	local curMoney = ply:getDarkRPVar("money") or 0

	if math.Round(lerpedMoney) != curMoney then
		lerpedMoney = Lerp(FrameTime() * 8, lerpedMoney, curMoney)

		self:SetText(DarkRP.formatMoney(math.Round(lerpedMoney)))
		self:SizeToContents()
	end

	self:SetPos((bar_x + 110 / 2) * FlatHUD.Scale - self:GetWide() / 2, (163 - main_y) * FlatHUD.Scale)
end

if !GetConVar( "flathud_minimal_mode" ):GetBool() then
	local HUDAvatar = vgui.Create("AvatarCircleMask", MainPanel)
	HUDAvatar:SetPlayer(ply)
	HUDAvatar:SetSize(98 * FlatHUD.Scale, 98 * FlatHUD.Scale)
	HUDAvatar:SetPos(31 * FlatHUD.Scale, 50 * FlatHUD.Scale)
	HUDAvatar:SetMaskSize((98 * FlatHUD.Scale) / 2)
end

hook.Add( "OnScreenSizeChanged", "ChangeHUDSize", function()
	for k, v in ipairs(FlatHUD.FlatPanels) do
		v:Remove()
	end

	include("autorun/rflathud_autorun.lua")
end )