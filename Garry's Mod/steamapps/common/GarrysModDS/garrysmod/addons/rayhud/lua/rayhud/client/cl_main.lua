-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

-- HUD Icons --


-- Variables --
local width = 390 * RayHUD.Scale
local height = 200 * RayHUD.Scale

local x = 12 * RayHUD.Scale
local y = ScrH() - height - x

local bar_x = 205

local SmoothHealth = 0
local SmoothArmor = 0
local SmoothHunger = 0

local ply = LocalPlayer()

local main_y = 8 * RayHUD.Scale

-- ConVars --
CreateClientConVar("rayhud_crashscreen", RayHUD.Cfg.CrashScreen and 1 or 0, true, false)
CreateClientConVar("rayhud_minimal_mode", RayHUD.Cfg.MiniMode and 1 or 0, true, false)

CreateClientConVar("rayhud_role_color", RayHUD.Cfg.TeamColor and 1 or 0, true, false)
RayHUD.TeamCol = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.TeamColor or GetConVar( "rayhud_role_color" ):GetInt())

CreateClientConVar("rayhud_blur", RayHUD.Cfg.BlurMode and 1 or 0, true, false)
RayHUD.Blur = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.Opacity or GetConVar( "rayhud_blur" ):GetInt())

-- Fonts --
local fontname = "Caviar Dreams Bold"

surface.CreateFont("RayHUD.Main:Small", {font = fontname, size = 18 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD.Main:Medium", {font = fontname, size = 22 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD.Main:Big", {font = fontname, size = 27 * RayHUD.Scale, extended = true})

surface.CreateFont("RayHUD:TopRight", {font = fontname, size = 20 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD:Notification", {font = fontname, size = 24 * RayHUD.Scale, extended = true})

surface.CreateFont("RayHUD.2D3D:DoorHeader", {font = fontname, size = 52 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD.2D3D:DoorSubHeader", {font = fontname, size = 30 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD.2D3D:Name", {font = fontname, size = 60 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD.2D3D:Job", {font = fontname, size = 40 * RayHUD.Scale, extended = true})

surface.CreateFont("RayHUD.CrashScreen:Big", {font = fontname, size = 120 * RayHUD.Scale, extended = true})
surface.CreateFont("RayHUD.CrashScreen:Small", {font = fontname, size = 36 * RayHUD.Scale, extended = true})

surface.CreateFont("RayHUD:VoiceVisualiser", {font = fontname, size = 22 * RayHUD.Scale, extended = true})

surface.CreateFont("RayHUD.Settings:Small", {font = fontname, size = 17 * RayHUD.Scale, extended = true})

surface.CreateFont("RayHUD.Settings:Smaller", {font = fontname, size = 15 * RayHUD.Scale, extended = true})

--

if GetConVar( "rayhud_minimal_mode" ):GetBool() then width = 230 * RayHUD.Scale; bar_x = 44 end

local MainPanel = vgui.Create("RayHUD:DPanel")
MainPanel:SetSize(width, height)
MainPanel:SetPos(x, y)
MainPanel:ParentToHUD()
MainPanel.Paint = function (self, w, h)
	if GetConVar( "rayhud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end

	FlatUI.DrawMaterialBox(!GetConVar( "rayhud_minimal_mode" ):GetBool() and ply:GetName() or "", 0, 0, w, h, ply:IsSpeaking() and FlatUI.Icons.Sound)

	if !GetConVar( "rayhud_minimal_mode" ):GetBool() then
		draw.RoundedBoxEx(RayHUD.Rounding, 0, 41 * RayHUD.Scale, 160 * RayHUD.Scale, h - 41 * RayHUD.Scale, Color(FlatUI.Colors.DarkGray.r, FlatUI.Colors.DarkGray.g, FlatUI.Colors.DarkGray.b, RayHUD.Opacity + 20), false, false, true, false) -- Left Part

		surface.SetFont( "RayHUD.Main:Medium" )
		local JobSize = select(1, surface.GetTextSize( team.GetName(ply:Team())))

		draw.RoundedBox(math.Clamp(RayHUD.Rounding, 0, 24), (160 * RayHUD.Scale - (JobSize + 12)) / 2, 155 * RayHUD.Scale, JobSize + 12 * RayHUD.Scale, 35 * RayHUD.Scale, FlatUI.Colors.DarkGray2) -- Nick and Job background
		draw.SimpleText( team.GetName(ply:Team()), "RayHUD.Main:Medium", (160 * RayHUD.Scale - JobSize) / 2, (67 + 68 + 26) * RayHUD.Scale, team.GetColor(ply:Team()) )
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
	surface.DrawTexturedRect(width - 40 * RayHUD.Scale, 4 * RayHUD.Scale, 33 * RayHUD.Scale, 33 * RayHUD.Scale)
	
	surface.SetMaterial( FlatUI.Icons.Pistol )
	surface.SetDrawColor( PistolIconColor )
	surface.DrawTexturedRect(width - 80 * RayHUD.Scale, 4 * RayHUD.Scale, 33 * RayHUD.Scale, 33 * RayHUD.Scale)
	
	-- Hunger Bar
	if !DarkRP.disabledDefaults["modules"]["hungermod"] then
		main_y = 0
		
		local energy = math.ceil(ply:getDarkRPVar("Energy") or 0)
		SmoothHunger = Lerp(5 * FrameTime(), SmoothHunger, energy)
		local hunger = math.Clamp(SmoothHunger, 0, 100) / 100
		FlatUI.CreateBar( bar_x, 67 + 34 + 34, 170 * RayHUD.Scale, 9, FlatUI.Colors.LightOrange, FlatUI.Colors.Orange, hunger, RayHUD.GetPhrase("hunger") .. ": " .. energy .. " / 100", FlatUI.Icons.Food )
	end

	-- Health Bar
	SmoothHealth = Lerp(5 * FrameTime(), SmoothHealth, ply:Health())
	local hl = math.Clamp(SmoothHealth, 1, ply:GetMaxHealth()) / ply:GetMaxHealth()
	local HPText = RayHUD.GetPhrase("health") .. ": " .. math.Clamp(ply:Health(), 0, ply:Health()) .. " / " .. ply:GetMaxHealth()
	local Var = math.Clamp(  math.abs( math.sin( CurTime() * 5 ) ), 0.75, 1 )
	local HPColor = FlatUI.Colors.HP
	if ply:Health() <= 20 then
		HPColor = Color( Var * 198, Var * 40, Var * 40 )
	end
	FlatUI.CreateBar( bar_x, 67 + main_y, 170 * RayHUD.Scale, 9, FlatUI.Colors.LightHP, HPColor, hl, HPText, FlatUI.Icons.Heart )

	-- Armor Bar
	SmoothArmor = Lerp(5 * FrameTime(), SmoothArmor, ply:Armor())
	local armor = math.Clamp(SmoothArmor, 1, 255) / 255
	FlatUI.CreateBar( bar_x, 67 + 34 + main_y * 2, 170 * RayHUD.Scale, 9, FlatUI.Colors.LightArmor, FlatUI.Colors.Armor, armor, RayHUD.GetPhrase("armor") .. ": " .. ply:Armor() .. " / 255", FlatUI.Icons.Shield )

	-- Money Bar
	surface.SetMaterial( FlatUI.Icons.Money )
	surface.SetDrawColor( FlatUI.Colors.Green )
	surface.DrawTexturedRect((bar_x - 32) * RayHUD.Scale, (67 + 22 + 34 + 35 - main_y) * RayHUD.Scale, 27 * RayHUD.Scale, 27 * RayHUD.Scale)

	draw.RoundedBox(math.Clamp(RayHUD.Rounding, 0, 24), bar_x * RayHUD.Scale, (67 + 68 + 22 - main_y) * RayHUD.Scale, 110 * RayHUD.Scale, 30 * RayHUD.Scale, FlatUI.Colors.DarkGray3)
	draw.RoundedBox(math.Clamp(RayHUD.Rounding, 0, 24), (bar_x + 115) * RayHUD.Scale, (67 + 68 + 22 - main_y) * RayHUD.Scale, 55 * RayHUD.Scale, 30 * RayHUD.Scale, FlatUI.Colors.DarkGray3)

	surface.SetFont("RayHUD.Main:Small")
	draw.SimpleText( "+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary")), "RayHUD.Main:Small", (bar_x + 115 + 55 / 2) * RayHUD.Scale - select(1, surface.GetTextSize("+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary")))) / 2, (163 - main_y) * RayHUD.Scale, FlatUI.Colors.Orange )
end

local lerpedMoney = ply:getDarkRPVar("money") or 0

local SalaryText = vgui.Create("DLabel", MainPanel)
SalaryText:SetText(DarkRP.formatMoney(lerpedMoney))
SalaryText:SetTextColor(FlatUI.Colors.Green)
SalaryText:SetFont("RayHUD.Main:Small")
SalaryText:SizeToContents()
SalaryText:SetPos((bar_x + 110 / 2) * RayHUD.Scale - SalaryText:GetWide() / 2, (163 - main_y) * RayHUD.Scale)

SalaryText.Think = function(self)
	local curMoney = ply:getDarkRPVar("money") or 0

	if math.Round(lerpedMoney) != curMoney then
		lerpedMoney = Lerp(FrameTime() * 8, lerpedMoney, curMoney)

		self:SetText(DarkRP.formatMoney(math.Round(lerpedMoney)))
		self:SizeToContents()
	end

	self:SetPos((bar_x + 110 / 2) * RayHUD.Scale - self:GetWide() / 2, (163 - main_y) * RayHUD.Scale)
end

if !GetConVar( "rayhud_minimal_mode" ):GetBool() then
	local HUDAvatar = vgui.Create("AvatarCircleMask", MainPanel)
	HUDAvatar:SetPlayer(ply)
	HUDAvatar:SetSize(98 * RayHUD.Scale, 98 * RayHUD.Scale)
	HUDAvatar:SetPos(31 * RayHUD.Scale, 50 * RayHUD.Scale)
	HUDAvatar:SetMaskSize((98 * RayHUD.Scale) / 2)
end

hook.Add( "OnScreenSizeChanged", "ChangeHUDSize", function()
	for k, v in ipairs(RayHUD.FlatPanels) do
		v:Remove()
	end

	include("autorun/rayhud_autorun.lua")
end )