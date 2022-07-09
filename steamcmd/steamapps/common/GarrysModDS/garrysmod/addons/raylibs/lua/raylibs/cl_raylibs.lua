-- RayUI Owner: 76561198166995690
-- RayUI Version: 1.4

local ply = LocalPlayer()

-- Variables
local scale = isnumber(RayUI.Configuration.GetConfig( "Scale" )) and RayUI.Configuration.GetConfig( "Scale" ) or 20

RayUI.Scale = math.Round(ScrH() * 0.00085 * scale * 0.05, 2)

RayUI.Rounding = isnumber(RayUI.Configuration.GetConfig( "Rounding" )) and RayUI.Configuration.GetConfig( "Rounding" ) * RayUI.Scale or 16 * RayUI.Scale

RayUI.Blur = RayUI.Configuration.GetConfig( "BlurMode" )

RayUI.Opacity = isnumber(RayUI.Configuration.GetConfig( "Opacity" )) and RayUI.Configuration.GetConfig( "Opacity" ) or 255

RayUI.JobColor = RayUI.Configuration.GetConfig( "JobColor" )
RayUI.HeaderColor = RayUI.Configuration.GetConfig( "HeaderColor" )


// Normal Fonts
surface.CreateFont("RayUI.Normal:Small", {font = "Comfortaa", size = 19 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI.Normal:Small5", {font = "Comfortaa", size = 18 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI.Normal:Smallest", {font = "Comfortaa", size = 18 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI.Normal:Smallest2", {font = "Comfortaa", size = 20 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI.Normal:Largest2", {font = "Comfortaa", size = 31 * RayUI.Scale, extended = true})


// Bold Fonts
surface.CreateFont("RayUI:Smallest", {font = "Comfortaa Bold", size = 17 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI:Small", {font = "Comfortaa Bold", size = 19 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Small2", {font = "Comfortaa Bold", size = 21 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Small3", {font = "Comfortaa Bold", size = 20 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI:Medium", {font = "Comfortaa Bold", size = 22 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Medium2", {font = "Comfortaa Bold", size = 23 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI:Large", {font = "Comfortaa Bold", size = 30 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Large2", {font = "Comfortaa Bold", size = 24 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Large3", {font = "Comfortaa Bold", size = 28 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI:Largest", {font = "Comfortaa Bold", size = 32 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Largest2", {font = "Comfortaa Bold", size = 31 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Largest3", {font = "Comfortaa Bold", size = 80 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Largest4", {font = "Comfortaa Bold", size = 35 * RayUI.Scale, extended = true})

surface.CreateFont("RayUI:Largest5", {font = "Comfortaa Bold", size = 50 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Largest6", {font = "Comfortaa Bold", size = 38 * RayUI.Scale, extended = true})
surface.CreateFont("RayUI:Largest7", {font = "Comfortaa Bold", size = 150 * RayUI.Scale, extended = true})



// Icons Cache
RayUI.Icons = {
	AddUser = Material("rayui_materials/adduser.png", "smooth" ),
	Ammo = Material("rayui_materials/ammo.png", "smooth" ),
	BanUser = Material("rayui_materials/banuser.png", "smooth" ),
	Binds = Material("rayui_materials/binds.png", "smooth" ),
	Build = Material("rayui_materials/build.png", "smooth" ),
	Bubble = Material("rayui_materials/bubble.png", "smooth" ),
	Bulb = Material("rayui_materials/bulb.png", "smooth" ),
	Car = Material("rayui_materials/car.png", "smooth" ),
	CarLight = Material("rayui_materials/carlight.png", "smooth" ),
	Clock = Material("rayui_materials/clock.png", "smooth" ),
	Close = Material("rayui_materials/delete.png", "smooth" ),
	Cog = Material("rayui_materials/cog.png", "smooth" ),
	ConnectionLost = Material("rayui_materials/connection_lost.png", "smooth" ),
	Crosshair = Material("rayui_materials/crosshair.png", "smooth" ),
	Cube = Material("rayui_materials/cube.png", "smooth" ),
	Discord = Material("rayui_materials/discord.png", "smooth" ),
	Document = Material("rayui_materials/document.png", "smooth" ),
	Door = Material("rayui_materials/door.png", "smooth" ),
	Energy = Material("rayui_materials/energy.png", "smooth" ),
	Engine = Material("rayui_materials/engine.png", "smooth" ),
	Exhaust = Material("rayui_materials/exhaust.png", "smooth" ),
	Food = Material("rayui_materials/food.png", "smooth" ),
	Fuel = Material("rayui_materials/fuel.png", "smooth" ),
	Gesture = Material("rayui_materials/gesture.png", "smooth" ),
	Ghost = Material("rayui_materials/ghost.png", "smooth" ),
	Handcuffs = Material("rayui_materials/handcuffs.png", "smooth" ),
	Heart = Material("rayui_materials/heart.png", "smooth" ),
	Help = Material("rayui_materials/help.png", "smooth" ),
	House = Material("rayui_materials/house.png", "smooth" ),
	Interface = Material("rayui_materials/interface.png", "smooth" ),
	Internet = Material("rayui_materials/internet.png", "smooth" ),
	Law = Material("rayui_materials/law.png", "smooth" ),
	Level = Material("rayui_materials/level.png", "smooth" ),
	Loading = Material("rayui_materials/loading.png", "smooth" ),
	Map = Material("rayui_materials/map.png", "smooth" ),
	Menu = Material("rayui_materials/menu.png", "smooth" ),
	Money = Material("rayui_materials/money.png", "smooth" ),
	Message = Material("rayui_materials/message.png", "smooth" ),
	Mute = Material("rayui_materials/mute.png", "smooth" ),
	Pistol = Material("rayui_materials/pistol.png", "smooth" ),
	Radar = Material("rayui_materials/radar.png", "smooth" ),
	Radio = Material("rayui_materials/radio.png", "smooth" ),
	RemoveUser = Material("rayui_materials/removeuser.png", "smooth" ),
	Run = Material("rayui_materials/Run.png", "smooth" ),
	Scissors = Material("rayui_materials/scissors.png", "smooth" ),
	Score = Material("rayui_materials/score.png", "smooth" ),
	Shield = Material("rayui_materials/shield.png", "smooth" ),
	Shopping = Material("rayui_materials/shopping.png", "smooth" ),
	Sound = Material("rayui_materials/sound.png", "smooth" ),
	Speed = Material("rayui_materials/speed.png", "smooth" ),
	Star = Material("rayui_materials/star.png", "smooth" ),
	Steam = Material("rayui_materials/steam.png", "smooth" ),
	Summary = Material("rayui_materials/summary.png", "smooth" ),
	Text = Material("rayui_materials/text.png", "smooth" ),
	Tire = Material("rayui_materials/tire.png", "smooth" ),
	Transfer = Material("rayui_materials/transfer.png", "smooth" ),
	Undo = Material("rayui_materials/undo.png", "smooth" ),
	User = Material("rayui_materials/user.png", "smooth" ),
	Vote = Material("rayui_materials/vote.png", "smooth" ),
	Warning = Material("rayui_materials/warning.png", "smooth" ),

	Eye = Material("rayui_materials/eye.png", "smooth" ),
	Bring = Material("rayui_materials/bring.png", "smooth" ),
	GoTo = Material("rayui_materials/goto.png", "smooth" ),
	Slay = Material("rayui_materials/slay.png", "smooth" ),

	// SimPhys
	CruiseControl = Material("rayui_materials/cruisecontrol.png", "smooth" ),
	HandBrake = Material("rayui_materials/handbrake.png", "smooth" ),
	FogLight = Material("rayui_materials/foglight.png", "smooth" ),
	CarSeat = Material("rayui_materials/carseat.png", "smooth" ),


	Lock = Material("rayui_materials/lock.png", "smooth" ),
	Unlock = Material("rayui_materials/unlock.png", "smooth" ),
}

-- Colors Cache
RayUI.Colors = {
	Invisible =  Color(0, 0, 0, 0),

	White = Color(240, 240, 240),
	White2 = Color(220, 220, 220),

	Gray = Color(66, 66, 66),
	Gray2 = Color(97, 97, 97),
	Gray3 = Color(120, 120, 120),

	DarkGray = Color(60, 60, 60),
	DarkGray2 = Color(40, 40, 40),
	DarkGray3 = Color(54, 54, 54),
	DarkGray4 = Color(35, 35, 35),
	DarkGray5 = Color(80, 80, 80),
	DarkGray6 = Color(48, 48, 48),
	DarkGray7 = Color(70, 70, 70),

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

	Green3 = Color(66, 151, 69),

	Yellow = Color(245, 195, 6),

	-- TTT Related
	Innocent = Color(56, 142, 60),
	Traitor = Color(201, 35, 35),
	Detective = Color(25, 118, 210),
}
function RayUI:GetPlayerCol()
	local PlyCol

	if engine.ActiveGamemode() == "terrortown" then
		if SpecDM and ply:IsGhost() or GAMEMODE.round_state != ROUND_ACTIVE then
			PlyCol = Color(87, 87, 87)
		elseif ply:GetTraitor() then
			PlyCol = RayUI.Colors.Traitor
		elseif ply:GetDetective() then
			PlyCol = RayUI.Colors.Detective
		else
			if RayHUDTTT.CustomRoles[ply:GetRole()] then
				PlyCol = RayHUDTTT.CustomRoles[ply:GetRole()]
			else
				PlyCol = RayUI.Colors.Innocent
			end
		end
	else
		if RayUI.JobColor then
			PlyCol = team.GetColor( ply:Team() )
		else
			PlyCol = RayUI.HeaderColor
		end
	end

	return PlyCol
end

function RayUI:DrawMaterialBox(text, x, y, w, h, col, icon)
	local Icon = icon or RayUI.Icons.Menu
	local color = (IsColor( col ) and col or RayUI:GetPlayerCol()) or Color(86, 86, 86)
	if col and !IsColor( col ) then Icon = col end

	draw.RoundedBox(RayUI.Rounding, x, y, w, h, Color(RayUI.Colors.Gray.r, RayUI.Colors.Gray.g, RayUI.Colors.Gray.b, RayUI.Opacity)) -- Main Panel
	draw.RoundedBoxEx(RayUI.Rounding, x, y, w, math.Round(41 * RayUI.Scale), Color(color.r, color.g, color.b, RayUI.Opacity + 100), true, true, false, false) -- Upper Bar

	surface.SetMaterial( Icon )
	surface.SetDrawColor( RayUI.Colors.White )
	surface.DrawTexturedRect(x + 8 * RayUI.Scale, y + 4 * RayUI.Scale, 34 * RayUI.Scale, 34 * RayUI.Scale)

	draw.SimpleText( text, "RayUI:Largest2", x + 48 * RayUI.Scale, y + 3 * RayUI.Scale, RayUI.Colors.White )
end

local blur = Material("pp/blurscreen")

function RayUI:DrawBlur(panel, x1, x2, y1, y2)
	if RayUI.Blur then

		local x, y = panel:LocalToScreen(0, 0)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(blur)

		if x1 and x2 and y1 and y2 then
			render.SetScissorRect( x1, y1, x1 + x2, y1 + y2, true )
		end

		for i = 1, 3 do
			blur:SetFloat("$blur", (i / 3) * 10)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end

		if x1 and x2 and y1 and y2 then
			render.SetScissorRect( 0, 0, 0, 0, false )
		end	
	end
end

function RayUI:DrawBlur2( x, y, width, height )
	if RayUI.Blur then

		render.SetScissorRect( x, y, x + width, y + height, true )
		surface.SetMaterial(blur)
		surface.SetDrawColor( Color ( 255, 255, 255 ) )
		
		for i = 1, 3 do
			blur:SetFloat("$blur", (i / 3) * 10)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end

		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

function RayUI:CreateBar(x, y, w, h, BackgroundCol, TopCol, func, text, icon)
	local BarWidth = w
	local BarHeight = h

	if icon then
		surface.SetMaterial( icon )
		surface.SetDrawColor( TopCol )
		surface.DrawTexturedRect((x - 32 * RayUI.Scale), (y - 10 * RayUI.Scale), 30 * RayUI.Scale, 30 * RayUI.Scale)
	end

	local FillWidth = BarWidth * func

	if math.floor(BarWidth * func) <= 0 then
		FillWidth = 0
	end

	surface.SetFont( "RayUI:Medium" )
	local TextW = select( 1, surface.GetTextSize( text ) )

	draw.RoundedBox( math.Clamp(RayUI.Rounding / 2, 0, 10), x, y, BarWidth, BarHeight * RayUI.Scale, BackgroundCol ) -- Background
	draw.RoundedBox( math.Clamp(RayUI.Rounding / 2, 0, 10), x, y, FillWidth, BarHeight * RayUI.Scale, TopCol ) -- Fill	

	draw.SimpleText( text, "RayUI:Medium", x + BarWidth / 2 - TextW / 2, (y - 22 * RayUI.Scale), RayUI.Colors.White )
end

function RayUI:MakeLabel(text, font, color, parent)
	local label = vgui.Create("DLabel", parent)
	label:SetText(text)
	label:SetFont(font)
	label:SetColor(color)
	label:SizeToContents()

	return label
end

function RayUI:MakeSlider(parent, convar, text, min, max, dec)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	Main:SetTall(50 * RayUI.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 50))
	end

	local Slider = vgui.Create( "DNumSlider", Main )
	Slider:Dock(FILL)
	Slider:SetText( text )
	Slider:SetMinMax( min, max )
	Slider:SetDecimals( dec )
	Slider:SetConVar( convar )

	Slider.TextArea:SetFont("RayUI:Small2")
	Slider.TextArea:SetTextColor(RayUI.Colors.White)

	Slider.Label:SetFont("RayUI:Small2")
	Slider.Label:SetTextColor(RayUI.Colors.White)
	Slider.Label:DockMargin(12 * RayUI.Scale, 0, 0, 0)

	Slider.Slider.Knob:SetSize(14 * RayUI.Scale, 14 * RayUI.Scale)
	Slider.Slider.Knob.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox(11 * RayUI.Scale, w / 2 - (22 * RayUI.Scale) / 2, h / 2 - (22 * RayUI.Scale) / 2 + (1 * RayUI.Scale), 22 * RayUI.Scale, 22 * RayUI.Scale, RayUI.Colors.SliderAlpha)
		end

		draw.RoundedBox(7 * RayUI.Scale, w / 2 - (14 * RayUI.Scale) / 2, h / 2 - (14 * RayUI.Scale) / 2 + (1 * RayUI.Scale), w, h, RayUI.Colors.SliderCol)
	end

	Slider.Slider.Paint = function(self, w, h)
		draw.RoundedBox(0, 8 * RayUI.Scale, h / 2, select(1, Slider.Slider.Knob:GetPos()), 2 * RayUI.Scale, RayUI.Colors.SliderCol)
		draw.RoundedBox(0, select(1, Slider.Slider.Knob:GetPos()), h / 2, w - 13 * RayUI.Scale - select(1, Slider.Slider.Knob:GetPos()), 2 * RayUI.Scale, RayUI.Colors.LightGray)
	end

	return Slider
end

function RayUI:MakeCheckbox(parent, convar, text)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	Main:SetTall(50 * RayUI.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 50))
	end

	local CheckBox = vgui.Create("DCheckBox", Main)
	CheckBox:SetSize(20 * RayUI.Scale, 20 * RayUI.Scale)
	CheckBox:SetPos(12 * RayUI.Scale, (50 * RayUI.Scale) / 2 - (20 * RayUI.Scale) / 2)
	CheckBox:SetConVar(convar)
	CheckBox.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, RayUI.Colors.Green3)
		draw.RoundedBox(2, 3, 3, w - 6, h - 6, RayUI.Colors.Gray)

		if CheckBox:GetChecked() then
			surface.SetFont("RayUI:Small")

			draw.RoundedBox(5, 0, 0, w, h, RayUI.Colors.Green3)
			draw.SimpleText( "✓", "RayUI:Small", w / 2 - select(1, surface.GetTextSize( "✓" )) / 2, h / 2 - select(2, surface.GetTextSize( "✓" )) / 2, color_white )
		end
	end

	local CheckBoxLabel = vgui.Create("DLabel", Main)
	CheckBoxLabel:SetText(text)
	CheckBoxLabel:SetFont("RayUI:Small2")
	CheckBoxLabel:SetColor(RayUI.Colors.White)
	CheckBoxLabel:SizeToContents()
	CheckBoxLabel:SetPos( 42 * RayUI.Scale, (48 * RayUI.Scale) / 2 - CheckBoxLabel:GetTall() / 2 )

	return CheckBox
end

function RayUI:MakeColorPanel(parent, name)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	Main:SetTall(200 * RayUI.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 50))
	end

	local Label = RayUI:MakeLabel(name, "RayUI:Small2", color_white, Main)
	Label:Dock(TOP)
	Label:DockMargin(12 * RayUI.Scale, 10 * RayUI.Scale, 0, 0)

	local ColorPanel = vgui.Create("DColorMixer", Main)
	ColorPanel:Dock(TOP)
	ColorPanel:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	ColorPanel:SetHeight(Main:GetTall() - 50 * RayUI.Scale)
	ColorPanel:SetPalette(false)
	ColorPanel:SetAlphaBar(false)
	ColorPanel:SetWangs(true)

	return ColorPanel
end

function RayUI:MakeComboBox(parent, text)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	Main:SetTall(50 * RayUI.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 50))
	end

	local Label = RayUI:MakeLabel(text, "RayUI:Small2", color_white, Main)
	Label:Dock(LEFT)
	Label:DockMargin(10, 0, 0, 0)

	local ComboBox = vgui.Create( "DComboBox", Main )
	ComboBox:Dock(RIGHT)
	ComboBox:DockMargin(0, 10 * RayUI.Scale, 12 * RayUI.Scale, 10 * RayUI.Scale)
	ComboBox:SetWide(200 * RayUI.Scale)
	ComboBox:SetFont("RayUI:Small2")
	ComboBox:SetTextColor(RayUI.Colors.White)
	ComboBox.Paint = function( self, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.ComboBox2.r, RayUI.Colors.ComboBox2.g, RayUI.Colors.ComboBox2.b, RayUI.Opacity + 60))
	end
	ComboBox:SetValue( ComboBox:GetSelected() and ComboBox:GetSelected() or "Options" )
	ComboBox.DoClick = function(self, w, h)
		if ( self:IsMenuOpen() ) then
			return self:CloseMenu()
		end
		self:OpenMenu()
		
		if !ComboBox.Menu then return end

		for k,v in ipairs(ComboBox.Menu:GetCanvas():GetChildren()) do
			v:SetFont("RayUI:Small")
			v:SetTextColor(RayUI.Colors.White)

			v.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.ComboBox1 )

				if v:IsHovered() then
					draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.ComboBox2 )
				end
			end
		end
	end

	return ComboBox
end

function RayUI:MakeTextEntry(parent, text)
	local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
	Main:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	Main:SetTall(50 * RayUI.Scale)
	Main.Paint = function( self, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 50))
	end

	local Label = RayUI:MakeLabel(text, "RayUI:Small2", color_white, Main)
	Label:Dock(LEFT)
	Label:DockMargin(12 * RayUI.Scale, 0, 0, 0)

	local TextEntry = vgui.Create("DTextEntry", Main)
	TextEntry:Dock(RIGHT)
	TextEntry:DockMargin(0, 10 * RayUI.Scale, 12 * RayUI.Scale, 10 * RayUI.Scale)
	TextEntry:SetWide(200 * RayUI.Scale)
	TextEntry:SetFont("RayUI:Small2")
	TextEntry.Paint = function( self, w, h )
		draw.RoundedBox(8, 0, 0, w, h,RayUI.Colors.ComboBox2)
		self:DrawTextEntryText(Color(255, 255, 255), Color(60, 60, 60), Color(255, 255, 255))
	end

	return TextEntry
end

function RayUI:MakeIconButton(parent, desc, ColFrom, ColTo, icon, callback)
	local IconButton = vgui.Create("DButton", parent)
	IconButton:SetText("")

	local SmoothColR = ColFrom.r
	local SmoothColG = ColFrom.g
	local SmoothColB = ColFrom.b
	local SmoothColA = ColFrom.a

	IconButton.Paint = function( s, w, h )
		if IconButton:IsEnabled() then
			if IconButton:IsHovered() then
				SmoothColR = Lerp( FrameTime() * 12, SmoothColR, ColTo.r )
				SmoothColG = Lerp( FrameTime() * 12, SmoothColG, ColTo.g )
				SmoothColB = Lerp( FrameTime() * 12, SmoothColB, ColTo.b )
				SmoothColA = Lerp( FrameTime() * 12, SmoothColA, ColTo.a )
			else
				SmoothColR = Lerp( FrameTime() * 12, SmoothColR, ColFrom.r )
				SmoothColG = Lerp( FrameTime() * 12, SmoothColG, ColFrom.g )
				SmoothColB = Lerp( FrameTime() * 12, SmoothColB, ColFrom.b )
				SmoothColA = Lerp( FrameTime() * 12, SmoothColA, ColFrom.a )
			end
		else
			SmoothColR = Lerp( FrameTime() * 12, SmoothColR, 120 )
			SmoothColG = Lerp( FrameTime() * 12, FavColorG, 120 )
			SmoothColB = Lerp( FrameTime() * 12, SmoothColB, 120 )
			SmoothColA = Lerp( FrameTime() * 12, SmoothColA, 255  )
		end

		surface.SetDrawColor( Color(SmoothColR, SmoothColG, SmoothColB, SmoothColA) )
 		surface.SetMaterial(icon)
 		surface.DrawTexturedRect(0, 6 * RayUI.Scale, 28 * RayUI.Scale, 28 * RayUI.Scale)

	--	draw.SimpleText(desc, "RayUI:Large", 34 * RayUI.Scale, 2 * RayUI.Scale, Color(SmoothColR, SmoothColG, SmoothColB, SmoothColA)) 76561198166995699
	end
	IconButton.DoClick = function()
		callback()
	end

	return IconButton
end

local meta = FindMetaTable "Panel"

function meta:FormatRayButton(text, col, hovercol)
	self:SetText(text)
	self:SetTextColor(RayUI.Colors.White)
	self:SetFont("RayUI:Small")

	local FavColorR = col.r
	local FavColorG = col.g
	local FavColorB = col.b
	local FavColorA = col.a

	self.Paint = function( s, w, h )
		if self:IsEnabled() then
			if self:IsHovered() then
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
			FavColorR = Lerp( FrameTime() * 12, FavColorR, 42 )
			FavColorG = Lerp( FrameTime() * 12, FavColorG, 42 )
			FavColorB = Lerp( FrameTime() * 12, FavColorB, 42 )
			FavColorA = Lerp( FrameTime() * 12, FavColorA, 255 )
		end
		draw.RoundedBox( RayUI.Rounding - 4, 0, 0, w, h, Color( FavColorR, FavColorG, FavColorB, FavColorA) )
	end
end

function meta:CustomScrollBar()
	local sbar = self.VBar

	sbar.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
	end
	sbar.btnUp.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.Gray2 )
		else
			draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.DarkGray5 )
		end
	end
	sbar.btnDown.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.Gray2 )
		else
			draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.DarkGray5 )
		end
	end
	sbar.btnGrip:SetCursor( "hand" )
	sbar.btnGrip.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.Gray2 )
		else
			draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.DarkGray5 )
		end
	end

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



function RayUI:GetAdminMod()
	if ULib and ulx then
		return "ulx"
	elseif sam then
		return "sam"
	elseif xAdmin then
		return "xadmin"
	end
end














-----------------------------------------------------------------------------------
-- Thanks to HandsomeMatt for CircleAvatar (76561198166995699)
-----------------------------------------------------------------------------------

local cos, sin, rad = math.cos, math.sin, math.rad
local PANEL = {}
 
AccessorFunc( PANEL, "m_masksize", "MaskSize", FORCE_NUMBER )
 
function PANEL:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)
    self:SetMaskSize( 24 )
end
 
function PANEL:PerformLayout()
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
end
 
function PANEL:SetPlayer( id )
    self.Avatar:SetPlayer( id, self:GetWide() )
end
 
function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)
 
    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )
 
    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )
   
    local _m = self.m_masksize
   
    local circle, t = {}, 0
    for i = 1, 360 do
        t = rad(i*720)/720
        circle[i] = { x = w/2 + cos(t)*_m, y = h/2 + sin(t)*_m }
    end
    draw.NoTexture()
    surface.SetDrawColor(color_white)
    surface.DrawPoly(circle)
 
    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilReferenceValue( 1 )
 
    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)
 
    render.SetStencilEnable(false)
    render.ClearStencil()
end
vgui.Register( "RoundedAvatar", PANEL )


local cos, sin, rad = math.cos, math.sin, math.rad
local PANEL = {}
 
AccessorFunc( PANEL, "m_masksize", "MaskSize", FORCE_NUMBER )
 
function PANEL:Init()
    self.Avatar = vgui.Create("DImage", self)
    self.Avatar:SetPaintedManually(true)
    self:SetMaskSize( 24 )
end

function PANEL:PerformLayout()
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
end
 
function PANEL:SetMaterial( material )
    self.Avatar:SetMaterial( material )
end
 
function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)
 
    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )
 
    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )
   
    local _m = self.m_masksize
   
    local circle, t = {}, 0
    for i = 1, 360 do
        t = rad(i*720)/720
        circle[i] = { x = w/2 + cos(t)*_m, y = h/2 + sin(t)*_m }
    end
    draw.NoTexture()
    surface.SetDrawColor(color_white)
    surface.DrawPoly(circle)
 
    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilReferenceValue( 1 )
 
    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)
 
    render.SetStencilEnable(false)
    render.ClearStencil()
end
vgui.Register( "RoundedFakeAvatar", PANEL )