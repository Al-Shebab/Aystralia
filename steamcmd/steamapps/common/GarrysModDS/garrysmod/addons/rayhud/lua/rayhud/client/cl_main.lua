-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

// Variables

local width = 390 * RayUI.Scale
local height = 200 * RayUI.Scale

local bar_x = 205 * RayUI.Scale

local SmoothHealth = 0
local SmoothArmor = 0
local SmoothHunger = 0

local ply = LocalPlayer()

local main_y = 8 * RayUI.Scale

RayHUD.OffsetX = RayUI.Configuration and isnumber(RayUI.Configuration.GetConfig( "OffsetX" )) and RayUI.Configuration.GetConfig( "OffsetX" ) * RayUI.Scale or 0
RayHUD.OffsetY = RayUI.Configuration and isnumber(RayUI.Configuration.GetConfig( "OffsetY" )) and RayUI.Configuration.GetConfig( "OffsetY" ) * RayUI.Scale or 0

local y = ScrH() - height - RayHUD.OffsetY

local MiniMode = RayUI.Configuration.GetConfig( "MiniMode" )

//

if MiniMode then width = 230 * RayUI.Scale; bar_x = 44 * RayUI.Scale end

local MainPanel = vgui.Create("RayHUD:DPanel")
MainPanel:SetSize(width, height)
MainPanel:SetPos(RayHUD.OffsetX, y)
MainPanel:ParentToHUD()
MainPanel.Paint = function (self, w, h)
	RayUI:DrawBlur(self)

	RayUI:DrawMaterialBox((MiniMode and "") or (RayBoard and RayBoard:GetNick(ply) or ply:GetName()), 0, 0, w, h, ply:IsSpeaking() and RayUI.Icons.Sound)

	if !MiniMode then
		draw.RoundedBoxEx(RayUI.Rounding, 0, 41 * RayUI.Scale, 160 * RayUI.Scale, h - 41 * RayUI.Scale, Color(RayUI.Colors.DarkGray.r, RayUI.Colors.DarkGray.g, RayUI.Colors.DarkGray.b, RayUI.Opacity + 40), false, false, true, false) -- Left Part

		surface.SetFont( "RayUI:Large2" )
		local JobSize = select(1, surface.GetTextSize( team.GetName(ply:Team())))

		draw.RoundedBox(math.Clamp(RayUI.Rounding, 0, 24), (160 * RayUI.Scale - (JobSize + 12)) / 2, 155 * RayUI.Scale, JobSize + 12 * RayUI.Scale, 35 * RayUI.Scale, Color(RayUI.Colors.DarkGray2.r, RayUI.Colors.DarkGray2.g, RayUI.Colors.DarkGray2.b, RayUI.Opacity + 20)) -- Nick and Job background
		draw.SimpleText( team.GetName(ply:Team()), "RayUI:Large2", (160 * RayUI.Scale - JobSize) / 2, (160) * RayUI.Scale, team.GetColor(ply:Team()) )
	end

	local WantedColor = RayUI.Colors.Gray
	local PistolIconColor = RayUI.Colors.Gray

	if ply:getDarkRPVar("wanted") == true then
		WantedColor = RayUI.Colors.White
	elseif ply:getDarkRPVar("Arrested") == true then
		WantedColor = RayUI.Colors.HP
	end

	if ply:getDarkRPVar("HasGunlicense") == true then
		PistolIconColor = RayUI.Colors.White
	end
	surface.SetMaterial( RayUI.Icons.Handcuffs )
	surface.SetDrawColor( WantedColor )
	surface.DrawTexturedRect(width - 40 * RayUI.Scale, 4 * RayUI.Scale, 33 * RayUI.Scale, 33 * RayUI.Scale)
	
	surface.SetMaterial( RayUI.Icons.Pistol )
	surface.SetDrawColor( PistolIconColor )
	surface.DrawTexturedRect(width - 80 * RayUI.Scale, 4 * RayUI.Scale, 33 * RayUI.Scale, 33 * RayUI.Scale)

	// Hunger Bar
	if !DarkRP.disabledDefaults["modules"]["hungermod"] then
		main_y = 0
		
		local energy = math.ceil(ply:getDarkRPVar("Energy") or 0)
		SmoothHunger = Lerp(5 * FrameTime(), SmoothHunger, energy)
		local hunger = math.Clamp(SmoothHunger, 0, 100) / 100
		RayUI:CreateBar( bar_x, (67 + 34 + 34) * RayUI.Scale, 170 * RayUI.Scale, 9, RayUI.Colors.LightOrange, RayUI.Colors.Orange, hunger, RayUI.GetPhrase("hud", "hunger") .. ": " .. energy .. " / 100", RayUI.Icons.Food )
	end

	// Health Bar
	SmoothHealth = Lerp(5 * FrameTime(), SmoothHealth, ply:Health())
	local hl = math.Clamp(SmoothHealth, 1, ply:GetMaxHealth()) / ply:GetMaxHealth()
	local HPText = RayUI.GetPhrase("hud", "health") .. ": " .. math.Clamp(ply:Health(), 0, ply:Health()) .. ""
	local Var = math.Clamp(  math.abs( math.sin( CurTime() * 5 ) ), 0.75, 1 )
	local HPColor = RayUI.Colors.HP
	if ply:Health() <= 20 then
		HPColor = Color( Var * 198, Var * 40, Var * 40 )
	end
	RayUI:CreateBar( bar_x, 67 * RayUI.Scale + main_y, 170 * RayUI.Scale, 9, RayUI.Colors.LightHP, HPColor, hl, HPText, RayUI.Icons.Heart )

	// Armor Bar
	SmoothArmor = Lerp(5 * FrameTime(), SmoothArmor, ply:Armor())
	local armor = math.Clamp(SmoothArmor, 1, 255) / 255
	RayUI:CreateBar( bar_x, (67 + 34) * RayUI.Scale + main_y * 2, 170 * RayUI.Scale, 9, RayUI.Colors.LightArmor, RayUI.Colors.Armor, armor, RayUI.GetPhrase("hud", "armor") .. ": " .. ply:Armor() .. "", RayUI.Icons.Shield )

	// Money Bar
	surface.SetMaterial( RayUI.Icons.Money )
	surface.SetDrawColor( RayUI.Colors.Green )
	surface.DrawTexturedRect(bar_x - 31 * RayUI.Scale, 158 * RayUI.Scale - main_y, 28 * RayUI.Scale, 28 * RayUI.Scale)

	draw.RoundedBox(math.Clamp(RayUI.Rounding, 0, 24), bar_x, (67 + 68 + 22) * RayUI.Scale - main_y, 110 * RayUI.Scale, 30 * RayUI.Scale, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
	draw.RoundedBox(math.Clamp(RayUI.Rounding, 0, 24), bar_x + 115 * RayUI.Scale, (67 + 68 + 22) * RayUI.Scale - main_y, 55 * RayUI.Scale, 30 * RayUI.Scale, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))

	surface.SetFont("RayUI:Medium")
	draw.SimpleText( "+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary")), "RayUI:Medium", bar_x + ( (115 + 67 + 68 + 30) * RayUI.Scale) / 2 - select(1, surface.GetTextSize("+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary")))) / 2, 160 * RayUI.Scale - main_y, RayUI.Colors.Orange )
end

local lerpedMoney = ply:getDarkRPVar("money") or 0

local SalaryText = vgui.Create("DLabel", MainPanel)
SalaryText:SetText(DarkRP.formatMoney(lerpedMoney))
SalaryText:SetTextColor(RayUI.Colors.Green)
SalaryText:SetFont("RayUI:Medium")
SalaryText:SizeToContents()
SalaryText:SetPos(bar_x + (110 * RayUI.Scale ) / 2 - SalaryText:GetWide() / 2, 160 * RayUI.Scale - main_y)

SalaryText.Think = function(self)
	local curMoney = ply:getDarkRPVar("money") or 0

	if math.Round(lerpedMoney) != curMoney then
		lerpedMoney = Lerp(FrameTime() * 8, lerpedMoney, curMoney)

		self:SetText(DarkRP.formatMoney(math.Round(lerpedMoney)))
		self:SizeToContents()
	end

	self:SetPos(bar_x + (110 * RayUI.Scale ) / 2 - self:GetWide() / 2, 160 * RayUI.Scale - main_y)
end

if !MiniMode then
	local HUDAvatar = vgui.Create("RoundedAvatar", MainPanel)
	HUDAvatar:SetPlayer(ply)
	HUDAvatar:SetSize(98 * RayUI.Scale, 98 * RayUI.Scale)
	HUDAvatar:SetPos(31 * RayUI.Scale, 50 * RayUI.Scale)
	HUDAvatar:SetMaskSize((98 * RayUI.Scale) / 2)
end