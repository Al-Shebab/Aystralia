-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

--if (FlatUI != nil) then return end

FlatUI = FlatUI or {}

local ply = LocalPlayer()

FlatUI.Icons = {
	AddUser = Material("flat_materials/adduser.png", "smooth" ),
	Ammo = Material("flat_materials/ammo.png", "smooth" ),
	BanUser = Material("flat_materials/banuser.png", "smooth" ),
	Build = Material("flat_materials/build.png", "smooth" ),
	Bulb = Material("flat_materials/bulb.png", "smooth" ),
	Car = Material("flat_materials/car.png", "smooth" ),
	CarLight = Material("flat_materials/carlight.png", "smooth" ),
	Clock = Material("flat_materials/clock.png", "smooth" ),
	Close = Material("flat_materials/close.png", "smooth" ),
	Cog = Material("flat_materials/cog.png", "smooth" ),
	ConnectionLost = Material("flat_materials/connection_lost.png", "smooth" ),
	Crosshair = Material("flat_materials/crosshair.png", "smooth" ),
	Cube = Material("flat_materials/cube.png", "smooth" ),
	Discord = Material("flat_materials/discord.png", "smooth" ),
	Document = Material("flat_materials/document.png", "smooth" ),
	Door = Material("flat_materials/door.png", "smooth" ),
	Engine = Material("flat_materials/engine.png", "smooth" ),
	Exhaust = Material("flat_materials/exhaust.png", "smooth" ),
	Food = Material("flat_materials/food.png", "smooth" ),
	Fuel = Material("flat_materials/fuel.png", "smooth" ),
	Gesture = Material("flat_materials/gesture.png", "smooth" ),
	Ghost = Material("flat_materials/ghost.png", "smooth" ),
	Handcuffs = Material("flat_materials/handcuffs.png", "smooth" ),
	Heart = Material("flat_materials/heart.png", "smooth" ),
	Help = Material("flat_materials/help.png", "smooth" ),
	House = Material("flat_materials/house.png", "smooth" ),
	Interface = Material("flat_materials/interface.png", "smooth" ),
	Internet = Material("flat_materials/internet.png", "smooth" ),
	Law = Material("flat_materials/law.png", "smooth" ),
	Level = Material("flat_materials/level.png", "smooth" ),
	Loading = Material("flat_materials/loading.png", "smooth" ),
	Map = Material("flat_materials/map.png", "smooth" ),
	Menu = Material("flat_materials/menu.png", "smooth" ),
	Money = Material("flat_materials/money.png", "smooth" ),
	Message = Material("flat_materials/message.png", "smooth" ),
	Mute = Material("flat_materials/mute.png", "smooth" ),
	Pistol = Material("flat_materials/pistol.png", "smooth" ),
	Radar = Material("flat_materials/radar.png", "smooth" ),
	Radio = Material("flat_materials/radio.png", "smooth" ),
	RemoveUser = Material("flat_materials/removeuser.png", "smooth" ),
	Run = Material("flat_materials/Run.png", "smooth" ),
	Scissors = Material("flat_materials/scissors.png", "smooth" ),
	Score = Material("flat_materials/score.png", "smooth" ),
	Shield = Material("flat_materials/shield.png", "smooth" ),
	Shopping = Material("flat_materials/shopping.png", "smooth" ),
	Sound = Material("flat_materials/sound.png", "smooth" ),
	Speed = Material("flat_materials/speed.png", "smooth" ),
	Steam = Material("flat_materials/steam.png", "smooth" ),
	Text = Material("flat_materials/text.png", "smooth" ),
	Tire = Material("flat_materials/tire.png", "smooth" ),
	Transfer = Material("flat_materials/transfer.png", "smooth" ),
	Undo = Material("flat_materials/undo.png", "smooth" ),
	User = Material("flat_materials/user.png", "smooth" ),
	Vote = Material("flat_materials/vote.png", "smooth" ),
	Warning = Material("flat_materials/warning.png", "smooth" ),
}

FlatUI.Colors = {
	White = Color(240, 240, 240),

	Gray = Color(66, 66, 66),
	Gray2 = Color(97, 97, 97),
	Gray3 = Color(120, 120, 120),

	DarkGray = Color(60, 60, 60),
	DarkGray2 = Color(40, 40, 40),
	DarkGray3 = Color(54, 54, 54),
	DarkGray4 = Color(35, 35, 35),
	DarkGray5 = Color(80, 80, 80),

	LightGray = Color(160, 160, 160),

	LightHP = Color(229, 115, 115),
	HP = Color( 230, 52, 52 ),

	LightArmor = Color(112, 190, 255),
	Armor = Color(0, 138, 255),

	LightOrange = Color(255, 183, 77),
	Orange = Color(255, 120, 0),

	SliderCol = Color(0, 136, 209),
	SliderAlpha = Color(255, 255, 255, 20),

	ComboBox1 = Color(46, 46, 46),
	ComboBox2 = Color(72, 72, 72),

	Blue = Color(0, 150, 255),

	Red = Color(200, 40, 40),

	Green = Color(0, 238, 107),
	LightGreen = Color(154, 255, 209),

	Green2 = Color(126, 199, 48),
	LightGreen2 = Color(200, 255, 141),

	Yellow = Color(245, 195, 6),

	-- FlatBoard and HUD TTT
	InnocentCol = Color(56, 142, 60),
	TraitorCol = Color(211, 47, 47),
	DetectiveCol = Color(25, 118, 210),
}

CreateClientConVar("flatui_col_r", RayHUD.Cfg.CustomColor.r, true, false)
CreateClientConVar("flatui_col_g", RayHUD.Cfg.CustomColor.g, true, false)
CreateClientConVar("flatui_col_b",RayHUD.Cfg.CustomColor.b, true, false)

RayHUD.ColorR = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.CustomColor.r or GetConVar( "flatui_col_r" ):GetInt())
RayHUD.ColorG = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.CustomColor.g or GetConVar( "flatui_col_g" ):GetInt())
RayHUD.ColorB = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.CustomColor.b or GetConVar( "flatui_col_b" ):GetInt())

function FlatUI.GetPlayerCol()
	local PlyCol

	if RayHUD.TeamCol == 1 then
		if engine.ActiveGamemode() == "terrortown" then
			if SpecDM and ply:IsGhost() or GAMEMODE.round_state != ROUND_ACTIVE then
				PlyCol = FlatUI.Colors.Gray3
			elseif ply:GetTraitor() then
				PlyCol = FlatUI.Colors.TraitorCol
			elseif ply:GetDetective() then
				PlyCol = FlatUI.Colors.DetectiveCol
			else
				PlyCol = FlatUI.Colors.InnocentCol
			end
		else
			PlyCol = team.GetColor( ply:Team() )
		end
	else
		PlyCol = Color(RayHUD.ColorR, RayHUD.ColorG, RayHUD.ColorB)
	end

	return PlyCol
end

function FlatUI.DrawMaterialBox(text, x, y, w, h, col, icon)
	local Icon = icon or FlatUI.Icons.Menu
	local color = IsColor( col ) and col or FlatUI.GetPlayerCol()
	if col and !IsColor( col ) then Icon = col end

	draw.RoundedBox(RayHUD.Rounding, x, y, w, h, Color(FlatUI.Colors.Gray.r, FlatUI.Colors.Gray.g, FlatUI.Colors.Gray.b, RayHUD.Opacity)) -- Main Panel
	draw.RoundedBoxEx(RayHUD.Rounding, x, y, w, 41 * RayHUD.Scale, color, true, true, false, false) -- Upper Bar

	surface.SetMaterial( Icon )
	surface.SetDrawColor( FlatUI.Colors.White )
	surface.DrawTexturedRect(x + 8 * RayHUD.Scale, y + 4 * RayHUD.Scale, 33 * RayHUD.Scale, 33 * RayHUD.Scale)

	draw.SimpleText( text, "RayHUD.Main:Big", x + 48 * RayHUD.Scale, y + 6 * RayHUD.Scale, FlatUI.Colors.White )
end

local blur = Material("pp/blurscreen")

function FlatUI.DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (RayHUD.Blur and amount or 0))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function FlatUI.CreateBar(x, y, w, h, BackgroundCol, TopCol, func, text, icon)
	local BarWidth = w
	local BarHeight = h

	if icon then
		surface.SetMaterial( icon )
		surface.SetDrawColor( TopCol )
		surface.DrawTexturedRect((x - 32) * RayHUD.Scale, (y - 10) * RayHUD.Scale, 27 * RayHUD.Scale, 27 * RayHUD.Scale)
	end

	local FillWidth = BarWidth * func

	if math.floor(BarWidth * func) <= 0 then
		FillWidth = 0
	end

	surface.SetFont( "RayHUD.Main:Small" )
	local TextW = select( 1, surface.GetTextSize( text ) )

	draw.RoundedBox( math.Clamp(RayHUD.Rounding / 2, 0, 10), x * RayHUD.Scale, y * RayHUD.Scale, BarWidth, BarHeight * RayHUD.Scale, BackgroundCol ) -- Background
	draw.RoundedBox( math.Clamp(RayHUD.Rounding / 2, 0, 10), x * RayHUD.Scale, y * RayHUD.Scale, FillWidth, BarHeight * RayHUD.Scale, TopCol ) -- Fill	

	draw.SimpleText( text, "RayHUD.Main:Small", x * RayHUD.Scale + BarWidth / 2 - TextW / 2, (y - 18) * RayHUD.Scale, FlatUI.Colors.White )
end

function FlatUI.MakeLabel(text, font, color, parent)
	local label = vgui.Create("DLabel", parent)
	label:SetText(text)
	label:SetFont(font)
	label:SetColor(color)
	label:SizeToContents()

	return label
end

function FlatUI.MakePanel(w, h, header, sidebar)
	local Main = vgui.Create("EditablePanel")
	Main:SetSize(w * RayHUD.Scale, h * RayHUD.Scale)
	Main:Center()
	Main:SetVisible(true)
	Main:MakePopup()
	Main:SetMouseInputEnabled(true)
	Main:MoveToFront()
	Main:SetDrawOnTop(true)
	Main.Paint = function(self, w, h)
		if GetConVar( "rayhud_blur" ):GetBool() then FlatUI.DrawBlur(self, 6) end
		FlatUI.DrawMaterialBox(header, 0, 0, w, h)
	end
	Main:DockPadding( 0, 41 * RayHUD.Scale, 0, 0 )

	local CloseBut = vgui.Create("DButton", Main)
	CloseBut:SetText( "" )
	CloseBut:SetSize(41 * RayHUD.Scale, 41 * RayHUD.Scale)
	CloseBut:SetPos((550 - 41) * RayHUD.Scale, 0)
	CloseBut:DockMargin(0, 0, 10 * RayHUD.Scale, 0)
	CloseBut.DoClick = function()
		Main:Remove()
	end
	CloseBut.Paint = function( self, w, h )
		surface.SetMaterial( FlatUI.Icons.Close )
		surface.SetDrawColor( FlatUI.Colors.White )
		surface.DrawTexturedRect(8 * RayHUD.Scale, 8 * RayHUD.Scale, 24 * RayHUD.Scale, 24 * RayHUD.Scale)
	end

	if sidebar then
		local LeftPanelBut = vgui.Create("DButton", Main)
		LeftPanelBut:SetText("")
		LeftPanelBut:SetSize(41 * RayHUD.Scale, 52 * RayHUD.Scale)
		LeftPanelBut:SetPos(0, 0)
		LeftPanelBut.Paint = function() end

		local SideBar = vgui.Create("DPanel", Main)
		SideBar:Dock(LEFT)
		SideBar:SetWide(44 * RayHUD.Scale)
		SideBar.Paint = function( self, w, h )

			draw.RoundedBoxEx(RayHUD.Rounding, 0, 0, w, h, FlatUI.Colors.DarkGray3, false, false, true, false)
		end
	end

	return Main
end

function FlatUI.MakeSlider(parent, convar, text, min, max, dec)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayHUD.Scale, 6 * RayHUD.Scale, 12 * RayHUD.Scale, 0)
	Main:SetTall(40 * RayHUD.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, FlatUI.Colors.DarkGray3)
	end

	local Slider = vgui.Create( "DNumSlider", Main )
	Slider:Dock(FILL)
	Slider:SetText( text )
	Slider:SetMin( min )
	Slider:SetMax( max )
	Slider:SetDecimals( dec )
	Slider:SetConVar( convar )

	Slider.TextArea:SetFont("RayHUD.Settings:Small")
	Slider.TextArea:SetTextColor(FlatUI.Colors.White)

	Slider.Label:SetFont("RayHUD.Settings:Small")
	Slider.Label:SetTextColor(FlatUI.Colors.White)
	Slider.Label:DockMargin(12, 0, 0, 0)

	Slider.Slider.Knob:SetSize(14 * RayHUD.Scale, 14 * RayHUD.Scale)
	Slider.Slider.Knob.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox(11 * RayHUD.Scale, w / 2 - (22 * RayHUD.Scale) / 2, h / 2 - (22 * RayHUD.Scale) / 2 + (1 * RayHUD.Scale), 22 * RayHUD.Scale, 22 * RayHUD.Scale, FlatUI.Colors.SliderAlpha)
		end

		draw.RoundedBox(7 * RayHUD.Scale, w / 2 - (14 * RayHUD.Scale) / 2, h / 2 - (14 * RayHUD.Scale) / 2 + (1 * RayHUD.Scale), w, h, FlatUI.Colors.SliderCol)
	end

	Slider.Slider.Paint = function(self, w, h)
		draw.RoundedBox(0, 8, h / 2, select(1, Slider.Slider.Knob:GetPos()), 2 * RayHUD.Scale, FlatUI.Colors.SliderCol)
		draw.RoundedBox(0, select(1, Slider.Slider.Knob:GetPos()), h / 2, w - 13 - select(1, Slider.Slider.Knob:GetPos()), 2 * RayHUD.Scale, FlatUI.Colors.LightGray)
	end
end

function FlatUI.MakeCheckbox(parent, convar, text)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayHUD.Scale, 6 * RayHUD.Scale, 12 * RayHUD.Scale, 0)
	Main:SetTall(40 * RayHUD.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, FlatUI.Colors.DarkGray3)
	end

	local CheckBoxCol = FlatUI.Colors.Green

	local CheckBox = vgui.Create("DCheckBox", Main)
	CheckBox:SetSize(20 * RayHUD.Scale, 20 * RayHUD.Scale)
	CheckBox:SetPos(12 * RayHUD.Scale, (40 * RayHUD.Scale) / 2 - (20 * RayHUD.Scale) / 2)
	CheckBox:SetConVar(convar)
	CheckBox.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, CheckBoxCol)
		draw.RoundedBox(1, 4, 4, w - 8, h - 8, FlatUI.Colors.Gray)

		if CheckBox:GetChecked() then
			surface.SetFont("RayHUD.Settings:Small")

			draw.RoundedBox(5, 0, 0, w, h, CheckBoxCol)
			draw.SimpleText( "✓", "RayHUD.Settings:Small", w / 2 - select(1, surface.GetTextSize( "✓" )) / 2, h / 2 - select(2, surface.GetTextSize( "✓" )) / 2, color_white )
		end
	end

	local CheckBoxLabel = vgui.Create("DLabel", Main)
	CheckBoxLabel:SetText(text)
	CheckBoxLabel:SetFont("RayHUD.Settings:Small")
	CheckBoxLabel:SetColor(FlatUI.Colors.White)
	CheckBoxLabel:SizeToContents()
	CheckBoxLabel:SetPos( 42 * RayHUD.Scale, (42 * RayHUD.Scale) / 2 - CheckBoxLabel:GetTall() / 2 )

	return CheckBox
end

function FlatUI.MakeColorPanel(parent, r, g, b)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayHUD.Scale, 6 * RayHUD.Scale, 12 * RayHUD.Scale, 0)
	Main:SetTall(200 * RayHUD.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, FlatUI.Colors.DarkGray3)
	end

	local Label = FlatUI.MakeLabel(RayHUD.GetPhrase("custom_header_color"), "RayHUD.Settings:Smaller", color_white, Main)
	Label:Dock(TOP)
	Label:DockMargin(12 * RayHUD.Scale, 10 * RayHUD.Scale, 0, 0)

	local ColorPanel = vgui.Create("DColorMixer", Main)
	ColorPanel:Dock(TOP)
	ColorPanel:DockMargin(10, 10, 10, 0)
	ColorPanel:SetTall(Main:GetTall() - 50)
	ColorPanel:SetPalette(false)
	ColorPanel:SetAlphaBar(false)
	ColorPanel:SetWangs(true)
	ColorPanel:SetConVarR( r )
	ColorPanel:SetConVarG( g )
	ColorPanel:SetConVarB( b )
end

function FlatUI.MakeComboBox(parent, text)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayHUD.Scale, 6 * RayHUD.Scale, 12 * RayHUD.Scale, 0)
	Main:SetTall(40 * RayHUD.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, FlatUI.Colors.DarkGray3)
	end

	local Label = FlatUI.MakeLabel(text, "RayHUD.Settings:Small", color_white, Main)
	Label:Dock(LEFT)
	Label:DockMargin(10, 0, 0, 0)

	local ComboBox = vgui.Create( "DComboBox", Main )
	ComboBox:Dock(RIGHT)
	ComboBox:DockMargin(0, 6, 10, 6)
	ComboBox:SetWide(160)
	ComboBox:SetFont("RayHUD.Settings:Smaller")
	ComboBox:SetTextColor(FlatUI.Colors.White)
	ComboBox.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, FlatUI.Colors.ComboBox2 )
	end

	ComboBox:SetValue( ComboBox:GetSelected() and ComboBox:GetSelected() or "Options" )
	ComboBox.OnSelect = function( self, index, value, data )
		ply:ConCommand( data )
	end

	ComboBox.DoClick = function(self, w, h)
		if ( self:IsMenuOpen() ) then
			return self:CloseMenu()
		end
		self:OpenMenu()
		
		if !ComboBox.Menu then return end

		for k,v in ipairs(ComboBox.Menu:GetCanvas():GetChildren()) do
			v:SetFont("RayHUD.Settings:Smaller")
			v:SetTextColor(FlatUI.Colors.White)

			v.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.ComboBox1 )

				if v:IsHovered() then
					draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.ComboBox2 )
				end
			end
		end
	end

	return ComboBox
end

function FlatUI.CreateFlatButton(parent, text, col, hovercol, callback)
	local FlatBut = vgui.Create("DButton", parent)
	FlatBut:SetText(text)
	FlatBut:SetTextColor(FlatUI.Colors.White)
	FlatBut:SetFont("RayHUD.Main:Small")

	local FavColorR = col.r
	local FavColorG = col.g
	local FavColorB = col.b
	local FavColorA = col.a

	FlatBut.Paint = function( s, w, h )
		if FlatBut:IsEnabled() then
			if FlatBut:IsHovered() then
				FavColorR = Lerp( FrameTime() * 12, FavColorR, hovercol.r )
				FavColorG = Lerp( FrameTime() * 12, FavColorG, hovercol.g )
				FavColorB = Lerp( FrameTime() * 12, FavColorB, hovercol.b )
				FavColorA = Lerp( FrameTime() * 12, FavColorA, hovercol.a )
			else
				FavColorR = Lerp( FrameTime() * 12, FavColorR, col.r )
				FavColorG = Lerp( FrameTime() * 12, FavColorG, col.g )
				FavColorB = Lerp( FrameTime() * 12, FavColorB, col.b )
				FavColorA = Lerp( FrameTime() * 12, FavColorA, col.a )
			end
		else
			FavColorR = Lerp( FrameTime() * 12, FavColorR, 120 )
			FavColorG = Lerp( FrameTime() * 12, FavColorG, 120 )
			FavColorB = Lerp( FrameTime() * 12, FavColorB, 120 )
			FavColorA = Lerp( FrameTime() * 12, FavColorA, 255 )
		end
		draw.RoundedBox( 8 * RayHUD.Scale, 0, 0, w, h, Color( FavColorR, FavColorG, FavColorB, FavColorA) )
	end
	FlatBut:CircleClick(col, 1 )
	FlatBut.DoClick = function()
		callback()
	end

	return FlatBut
end

local meta = FindMetaTable "Panel"

function meta:CustomScrollBar()
	self.VBar:SetSize(14, 14)
	self.VBar.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
	end
	self.VBar.btnUp.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.Gray2 )
		else
			draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.DarkGray5 )
		end
	end
	self.VBar.btnDown.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.Gray2 )
		else
			draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.DarkGray5 )
		end
	end
	self.VBar.btnGrip:SetCursor( "hand" )
	self.VBar.btnGrip.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.Gray2 )
		else
			draw.RoundedBox( 0, 0, 0, w, h, FlatUI.Colors.DarkGray5 )
		end
	end

	local sbar = self.VBar
	sbar:SetWide(20)
	sbar.LerpTarget = 0

	function sbar:AddScroll(dlta)
		local OldScroll = self.LerpTarget or self:GetScroll()
		dlta = dlta * 50
		self.LerpTarget = math.Clamp(self.LerpTarget + dlta, -self.btnGrip:GetTall(), self.CanvasSize + self.btnGrip:GetTall())
		return OldScroll != self:GetScroll()
	end

	sbar.Think = function(s)
		if (input.IsMouseDown(MOUSE_LEFT)) then
			s.LerpTarget = s:GetScroll()
		end
		local frac = FrameTime() * 5
		if (math.abs(s.LerpTarget - s:GetScroll()) <= (s.CanvasSize/10)) then
			frac = FrameTime() * 2
		end
		local newpos = Lerp(frac, s:GetScroll(), s.LerpTarget)
		newpos = math.Clamp(newpos, 0, s.CanvasSize)
		s:SetScroll(newpos)
		if (s.LerpTarget < 0 and s:GetScroll() == 0) then
			s.LerpTarget = 0
		end
		if (s.LerpTarget > s.CanvasSize and s:GetScroll() == s.CanvasSize) then
			s.LerpTarget = s.CanvasSize
		end
	end
end

-----------------------------------------------------------------------------------
-- Thanks to Beast (https://www.gmodstore.com/users/beast) for CircleClick function
-----------------------------------------------------------------------------------

local function CreateCircle( x, y, r, c )
	local circle = {}

	for i = 1, 360 do
		circle[ i ] = {}
		circle[ i ].x = x + math.cos( math.rad( i * 360 ) / 360 ) * r
		circle[ i ].y = y + math.sin( math.rad( i * 360 ) / 360 ) * r
	end

	draw.NoTexture()
	surface.SetDrawColor( c )
	surface.DrawPoly( circle )
end

function meta:CircleClick( color, speed )
	local oldPaint = self.Paint
	local oldClick = self.OnMousePressed

	self.DrawCircle = false
	self.CircleColor = color
	self.GrowSpeed = speed
	self.Speed = 0
	self.mx = 0
	self.my = 0

	self.Paint = function( s, w, h )
		if oldPaint then
			oldPaint( s, w, h )
		end

		if self.DrawCircle then
		self.Speed = Lerp( self.GrowSpeed / 100, self.Speed, 255 )

			if self.Speed > 255 then
				self.DrawCircle = false
				self.Speed = 0
			end
		end

		if self.DrawCircle then
			CreateCircle( self.mx, self.my, self.Speed, Color( self.CircleColor.r, self.CircleColor.g, self.CircleColor.b, 255 - self.Speed ) )
		end
	end

	self.OnMousePressed = function( s, mouse )
		if oldClick then
			oldClick( s, mouse )
		end

		if !self.DrawCircle then
			self.DrawCircle = true
		else
			self.Speed = 0
		end

		self.mx, self.my = self:ScreenToLocal( gui.MousePos() )
	end
end
