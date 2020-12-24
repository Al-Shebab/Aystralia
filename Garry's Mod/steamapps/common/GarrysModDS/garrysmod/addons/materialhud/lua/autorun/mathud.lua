/*-----------------------------------------------------------
	Material HUD
	
	Copyright © 2015 Szymon (Szymekk) Jankowski 
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
	
	Used Material Design icons and
	http://game-icons.net/john-colburn/originals/pistol-gun.html under CC BY 3.0 (http://creativecommons.org/licenses/by/3.0/)
-------------------------------------------------------------*/

include("slib/core.lua");

if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("mathud_config.lua")

	CreateConVar("mhud_ver", 3, FCVAR_NOTIFY)

	resource.AddWorkshop("664038838")

	resource.AddFile("materials/mathud/heart.png")
	resource.AddFile("materials/mathud/armor.png")
	resource.AddFile("materials/mathud/hunger.png")
	resource.AddFile("materials/mathud/money.png")
	resource.AddFile("materials/mathud/warning.png")

	resource.AddFile("materials/mathud/menu.png")
	resource.AddFile("materials/mathud/info.png")
	resource.AddFile("materials/mathud/mic.png")
	resource.AddFile("materials/mathud/speak.png") 

	resource.AddFile("materials/mathud/prop.png")
	resource.AddFile("materials/mathud/clock.png")
	
	resource.AddFile("materials/mathud/pistol-gun.png")

	resource.AddFile("materials/shadow/u.png")
	resource.AddFile("materials/shadow/l.png") 
	resource.AddFile("materials/shadow/r.png")
	resource.AddFile("materials/shadow/d.png")

	resource.AddFile("materials/shadow/lu.png")
	resource.AddFile("materials/shadow/ru.png") 
	resource.AddFile("materials/shadow/ld.png")
	resource.AddFile("materials/shadow/rd.png")

	SLib.Util.RegisterPurchaser("MaterialHUD", "76561198166995690")

	return
end

include("mathud_config.lua")
local Config = MHUDConfig

local IsDarkRP = true

/*------------------------------------
	Scaling
--------------------------------------*/

local scale = MHUDConfig.Scale
 
if ScrH() < 800 then  
	scale = 0.78 * MHUDConfig.Scale
elseif ScrH() <= 900 then
	scale = 0.84 * MHUDConfig.Scale
end

local shadowOffset1 = 16 * scale
local shadowOffset2 = 32 * scale

local scaled = scale != 1

/*------------------------------------
	Hiding default HUD
--------------------------------------*/

local hidden = { "DarkRP_LocalPlayerHUD", "DarkRP_HUD", "DarkRP_Hungermod", "CHudHealth", "CHudAmmo", "CHudSecondaryAmmo", "DarkRP_Agenda", "CHudBattery"}

hook.Add("HUDShouldDraw", "MHUD_Hide", function(name)
	if table.HasValue(hidden, name) || (name == "DarkRP_EntityDisplay" && Config.HeadHUD) then return false end
end)

/*--------------------------------
	Useful
----------------------------------*/

local function StencilStart()
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS ) 	
	render.SetStencilReferenceValue( 1 )
	render.SetColorModulation( 1, 1, 1 )
end

local function StencilReplace()
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue(0)
end

local function StencilEnd()
	render.SetStencilEnable( false )
end

local smooth = scaled and " smooth" or "";

local MatGradientUp = Material("vgui/gradient-u")
local MatGradientDown = Material("vgui/gradient-d")
local MatBlur = Material("pp/blurscreen")

local MatHealth = Material("mathud/heart.png", "unlitgeneric" .. smooth)
local MatArmor = Material("mathud/armor.png", "unlitgeneric" .. smooth)
local MatHunger = Material("mathud/hunger.png", "unlitgeneric" .. smooth)
local MatMoney = Material("mathud/money.png", "unlitgeneric" .. smooth)
local MatWarning = Material("mathud/warning.png", "unlitgeneric" .. smooth)

local MatMenu = Material("mathud/menu.png", "unlitgeneric" .. smooth)
local MatInfo = Material("mathud/info.png", "unlitgeneric" .. smooth)
local MatMic = Material("mathud/mic.png", "unlitgeneric" .. smooth)
local MatSpeak = Material("mathud/speak.png", "unlitgeneric" .. smooth)

local MatProp = Material("mathud/prop.png", "unlitgeneric" .. smooth)
local MatClock = Material("mathud/clock.png", "unlitgeneric" .. smooth)

local MatGun = Material("mathud/pistol-gun.png", "unlitgeneric" .. smooth)

local SU = Material("shadow/u.png", "unlitgeneric")
local SL = Material("shadow/l.png", "unlitgeneric")
local SR = Material("shadow/r.png", "unlitgeneric")
local SD = Material("shadow/d.png", "unlitgeneric")

local SLU = Material("shadow/lu.png", "unlitgeneric")
local SRU = Material("shadow/ru.png", "unlitgeneric")
local SLD = Material("shadow/ld.png", "unlitgeneric")
local SRD = Material("shadow/rd.png", "unlitgeneric")


surface.CreateFont("mhud_name", {
	font = "Roboto",
	size = Config.NameFontSize * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_ammo", {
	font = "Roboto",
	size = 22 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_ammo_big", {
	font = "Roboto",
	size = 30 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 


surface.CreateFont("mhud_names", {
	font = "Roboto",
	size = 19 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_job", {
	font = "Roboto",
	size = 18 * scale,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_mtext", {
	font = "Roboto",
	size = 19 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 


surface.CreateFont("mhud_ename", {
	font = "Roboto",
	size = 48 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_enameb", {
	font = "Roboto",
	size = 48 * scale,
	weight = 5000,
	blursize = 5,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_ejob", {
	font = "Roboto",
	size = 38 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

surface.CreateFont("mhud_ejobb", {
	font = "Roboto",
	size = 38 * scale,
	weight = 5000,
	blursize = 5,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont("mhud_bar_font", {
	font = "Roboto",
	size = 14 * scale,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

local function DrawSimpleCircle(posx, posy, radius, color)
	local poly = { }
	local v = 40
	for i = 0, v do
		poly[i+1] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end

local function DrawCircle(posx, posy, radius, progress, color)
	local poly = { }
	local v = 220
	poly[1] = {x = posx, y = posy}
	for i = 0, v*progress+0.5 do
		poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end

local function DrawCircleGradient(posx, posy, radius, progress, color)
	local poly = { }
	local v = 100
	poly[1] = {x = posx, y = posy}
	for i = 0, v*progress do
		poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
		poly[i+2].u = 0
		poly[i+2].v = 0.6
	end
	surface.SetMaterial(MatGradientDown)
	surface.SetDrawColor(Color(0,0,0,200))
	surface.DrawPoly(poly)
end

local function DrawBlur(panel, layers, density, alpha)
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( MatBlur )

	for i = 1, 3 do
		MatBlur:SetFloat( "$blur", ( i / layers ) * density )
		MatBlur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local function DrawMatShadowC(x, y, w, h, left, top, right, bottom, cs) 
	surface.SetDrawColor(255, 255, 255, 255)

	local s = cs or shadowOffset1

	if top then
		local m = {
			{x = x, y = y-s, u = 0, v = 0},
			{x = x+w, y = y-s, u = 1/w/1024, v = 0},
			{x = x+w, y = y-s+s, u = 1/w/1024, v = 1},
			{x = x, y = y-s+s, u = 0, v = 1},
		}
		surface.SetMaterial(SU)
		surface.DrawPoly(m)
	end

	if right then
		local m = {
			{x = x+w, y = y, u = 0, v = 0},
			{x = x+w+s, y = y, u = 1, v = 0},
			{x = x+w+s, y = y+h, u = 1, v = 1/h/1024},
			{x = x+w, y = y+h, u = 0, v = 1/h/1024},
		}
		surface.SetMaterial(SR)
		surface.DrawPoly(m)
	end

	if bottom then
		local m = {
			{x = x, y = y+h, u = 0, v = 0},
			{x = x+w, y = y+h, u = 1/w/1024, v = 0},
			{x = x+w, y = y+h+s, u = 1/w/1024, v = 1},
			{x = x, y = y+h+s, u = 0, v = 1},
		}
		surface.SetMaterial(SD)
		surface.DrawPoly(m)
	end

	if left then
		local m = {
			{x = x-s, y = y, u = 0, v = 0},
			{x = x-s+s, y = y, u = 1, v = 0},
			{x = x-s+s, y = y+h, u = 1, v = 1/h/1024},
			{x = x-s, y = y+h, u = 0, v = 1/h/1024},
		}
		surface.SetMaterial(SL)
		surface.DrawPoly(m)
	end
end

local function DrawMatShadow(x, y, w, h) 
	surface.SetDrawColor(255, 255, 255, 255)

	local m = {
		{x = x, y = y-16, u = 0, v = 0},
		{x = x+w, y = y-16, u = 1/w/1024, v = 0},
		{x = x+w, y = y-16+16, u = 1/w/1024, v = 1},
		{x = x, y = y-16+16, u = 0, v = 1},
	}
	surface.SetMaterial(SU)
	surface.DrawPoly(m)
	//surface.DrawTexturedRect(x, y-16, w, 16)

	local m = {
		{x = x+w, y = y, u = 0, v = 0},
		{x = x+w+16, y = y, u = 1, v = 0},
		{x = x+w+16, y = y+h, u = 1, v = 1/h/1024},
		{x = x+w, y = y+h, u = 0, v = 1/h/1024},
	}
	surface.SetMaterial(SR)
	surface.DrawPoly(m)
	//surface.DrawTexturedRect(x+w, y, 16, h)

	local m = {
		{x = x, y = y+h, u = 0, v = 0},
		{x = x+w, y = y+h, u = 1/w/1024, v = 0},
		{x = x+w, y = y+h+16, u = 1/w/1024, v = 1},
		{x = x, y = y+h+16, u = 0, v = 1},
	}
	surface.SetMaterial(SD)
	surface.DrawPoly(m)
	//surface.DrawTexturedRect(x, y+h, w, 16)

	local m = {
		{x = x-16, y = y, u = 0, v = 0},
		{x = x-16+16, y = y, u = 1, v = 0},
		{x = x-16+16, y = y+h, u = 1, v = 1/h/1024},
		{x = x-16, y = y+h, u = 0, v = 1/h/1024},
	}
	surface.SetMaterial(SL)
	surface.DrawPoly(m)
	//surface.DrawTexturedRect(x-16, y, 16, h)


	surface.SetMaterial(SLU)
	surface.DrawTexturedRect(x-16, y-16, 16, 16)

	surface.SetMaterial(SRU)
	surface.DrawTexturedRect(x+w, y-16, 16, 16)

	surface.SetMaterial(SRD)
	surface.DrawTexturedRect(x+w, y+h, 16, 16)

	surface.SetMaterial(SLD)
	surface.DrawTexturedRect(x-16, y+h, 16, 16)
end

local function DrawMatBox(x, y, w, h, col)
	surface.SetDrawColor(col)
	surface.DrawRect(x, y, w, h)
end

local function DrawMatBoxS(x, y, w, h, col)
	surface.SetDrawColor(col)
	//surface.DrawRect(x, y, w, h)
	draw.RoundedBox(4, x, y, w, h, col)

	DrawMatShadow(x, y, w, h)
end

/*------------------------------------
	Panel vars
--------------------------------------*/

MHUD = MHUD or nil
MHUDA = MHUDA or nil
MHUDAg = MHUDAg or nil

local HP = 0
local Armor = 0
local Hunger = 0
local Ammo = 0
local MaxAmmo = { }

/*------------------------------------
	Panel creation
--------------------------------------*/

local function CreateHUDPanel()
	if !SLib && (table.HasValue({"admin", "superadmin", "owner", "moderator"}, LocalPlayer():GetUserGroup())) then
		Derma_Message("SLib (Szymekk's Library) isn't installed. You or somebody else probably forgot to put slib_release folder into addons. Please do it ASAP.\nPlease contact Szymekk on ScriptFodder, if you can't fix this issue.", "Please install SLib", "Close")
	end

	IsDarkRP = DarkRP != nil

	if IsValid(MHUD) then
		MHUD:Remove()
	end

	if IsValid(MHUDA) then
		MHUDA:Remove()
	end

	if IsValid(MHUDAg) then
		MHUDAg:Remove()
	end 

	// Main parent
	MHUD = vgui.Create("DPanel")
	MHUD:SetSize(380 * scale, 220 * scale)
	MHUD:SetPos(5, ScrH() - MHUD:GetTall() - 5)
	MHUD:ParentToHUD()
	MHUD:SetExpensiveShadow(10, Color(0,0,0,255))
	function MHUD:Paint(w, h)
		if Config.Blur then
			local x, y = self:LocalToScreen(0, 0);
			SLib.Gui.DrawBlurRect(x + shadowOffset1, y + shadowOffset1, w - shadowOffset2, h - shadowOffset2, Config.BlurScale, Config.BlurScale, 255)
		end
		DrawMatBoxS(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, Config.BgColor)
	end

	// Bar

	local bar = MHUD:Add("DPanel")
	bar:Dock(TOP)
	bar:SetHeight(64 * scale)
	function bar:Paint(w, h)
		DrawMatBox(shadowOffset1, shadowOffset1, math.floor(w-shadowOffset2 + 0.5), h-shadowOffset2, Config.BarColor)
		DrawMatShadowC(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, false, false, false, true, 4)
		DrawMatShadowC(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, false, false, false, true, 4)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(MatMenu)
		surface.DrawTexturedRect(shadowOffset1, shadowOffset1, 32 * scale, 32 * scale)

		local offset = 4 * scale

		if IsDarkRP && LocalPlayer():getDarkRPVar("HasGunlicense") then
			surface.SetDrawColor(Config.BgColor)
			surface.SetMaterial(MatGun)
			surface.DrawTexturedRect(w-shadowOffset1-24 * scale-8 * scale - offset, shadowOffset1, 32 * scale, 32 * scale)
			offset = offset + 32 * scale
		end
		
		if IsDarkRP && LocalPlayer():getDarkRPVar("wanted") then
			surface.SetDrawColor(244, 67, 54)
			surface.SetMaterial(MatWarning)
			surface.DrawTexturedRect(w-shadowOffset1-24 * scale-8 * scale - offset, shadowOffset1, 32 * scale, 32 * scale)
		end
	end

	// Avatar box

	local avatarbox = MHUD:Add("DPanel")
	avatarbox:SetWide(152 * scale)
	avatarbox:DockMargin(shadowOffset1,-shadowOffset1,0,shadowOffset1)
	avatarbox:Dock(LEFT)
	function avatarbox:Paint(w, h)
		DrawMatShadowC(0, 0, w-4, h, false, false, true, false, 4)
		DrawMatShadowC(0, 0, w-4, h, false, false, true, false, 4)
	end

	// Avatar

	local avatar = avatarbox:Add("AvatarImage")
	avatar:SetSize( 72 * scale, 72 * scale )
	avatar:SetPlayer(LocalPlayer(), 128 * scale)
	avatar:SetPos(shadowOffset1+shadowOffset1, avatar:GetParent():GetTall()/2)
	avatar:CenterHorizontal()
	function avatar:PaintOver(w, h)
		if !Config.Blur then
			StencilStart()
			DrawCircle(w/2, h/2, w/2, 1, Color(0,0,0,1))
			StencilReplace()
			surface.SetDrawColor(Config.BgColor)
			surface.DrawRect(0, 0, w, h)
			StencilEnd()
		end
	end
	function avatar:Think() 
		avatar:SetPos(shadowOffset1+shadowOffset1, avatar:GetParent():GetTall()/2 - (72 * scale)/2 - 20  * scale)
		avatar:CenterHorizontal()
	end
	
	// Name

	local name = avatarbox:Add("DLabel")
	name:SetColor(Config.TextColor)
	name:SetFont("mhud_name")
	name:SetSize(name:GetParent():GetWide() - Config.NameMargin * 2, shadowOffset2)
	name:SetPos(shadowOffset1+shadowOffset1, name:GetParent():GetTall()/2 + (72  * scale)/2 + 14  * scale)
	name:CenterHorizontal()
	name:SetContentAlignment(5)
	function name:Think() 
		name:SetPos(shadowOffset1+shadowOffset1, name:GetParent():GetTall()/2 + (72 * scale)/2 - 22 * scale)
		name:CenterHorizontal()
		name:SetContentAlignment(5)
		name:SetText(LocalPlayer():Name())
	end

	// Job

	local job = avatarbox:Add("DLabel")
	job:SetColor(Config.TextColor)
	job:SetFont("mhud_job")
	job:SetSize( job:GetParent():GetWide(), shadowOffset2)
	job:SetPlayer(LocalPlayer(), 128)
	job:SetPos(shadowOffset1+shadowOffset1, job:GetParent():GetTall()/2 + (72 * scale)/2 + 14 * scale)
	job:CenterHorizontal()
	job:SetContentAlignment(5)
	function job:Think() 
		job:SetPos(shadowOffset1+shadowOffset1, job:GetParent():GetTall()/2 + (72 * scale)/2 - 2  * scale)
		job:CenterHorizontal()
		job:SetContentAlignment(5)
		if IsDarkRP then
			job:SetText(LocalPlayer():getDarkRPVar("job") or "")
		else
			job:SetText(team.GetName(LocalPlayer():Team()))
		end
	end

	// Right box

	local rbox = MHUD:Add("DPanel")
	rbox:SetWide(152)
	rbox:DockMargin(-4,-shadowOffset1,shadowOffset1,shadowOffset1)
	rbox:Dock(FILL)
	function rbox:Paint(w, h) end

	local function MakeEntry()
		local entry = rbox:Add("DPanel")
		if IsDarkRP then
			entry:DockMargin(8, LocalPlayer():getDarkRPVar("Energy") and 4 or 6, 8, LocalPlayer():getDarkRPVar("Energy") and -12 * scale or 0)
		else
			entry:DockMargin(8 * scale, 6 * scale, 8 * scale, 0)
		end
		entry:SetTall(shadowOffset2)
		entry:Dock(TOP)

		function entry:Paint(w, h) end

		local img = entry:Add("DPanel")
		if !Config.ShowNumbers then
			img:SetSize(32 * scale, 32 * scale)
		else
			img:SetSize(56 * scale, 32 * scale)
		end
		img:Dock(LEFT)
		function img:Paint(w, h)
			surface.SetDrawColor(entry.color1)
			surface.SetMaterial(entry.mat)
			surface.DrawTexturedRect(0, 0, h, h)
			if Config.ShowNumbers then
				draw.SimpleText( math.floor(entry.value + 0.5), "mhud_bar_font", w, h / 2, entry.color1, 2, 1)
			end
		end

		local pbar = entry:Add("DPanel")
		entry.aprog = 0
		pbar:SetSize(128 * scale,4 * scale)
		pbar:DockMargin(8 * scale, 14 * scale, 8 * scale, 14 * scale)
		pbar:Dock(FILL)
		function pbar:Paint(w, h)
			surface.SetDrawColor(entry.color2)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(entry.color1)
			surface.DrawRect(0, 0, w*(math.Clamp(entry.aprog or 0, 0, 1)), h)
		end
		function pbar:Think()
			entry.aprog = Lerp(FrameTime()*10, entry.aprog, entry.prog)
		end

		return entry
	end

	local lastHP = 100
	local animHP = 0
	local toAdd = 0

	local maxHP = 100

	local hpEntry = MakeEntry()
	hpEntry.color1 = Config.HPColor1
	hpEntry.color2 = Config.HPColor2
	hpEntry.mat = MatHealth
	function hpEntry:Think()
		maxHP = math.max(maxHP, LocalPlayer():Health())

		toAdd = 20*math.sin(math.Clamp(animHP-RealTime(), 0, 9000)*20)
		self.prog = LocalPlayer():Health() / maxHP
		self.value = LocalPlayer():Health()
		self.color1 = Color(Config.HPColor1.r+toAdd,Config.HPColor1.g+toAdd,Config.HPColor1.b+toAdd)
		self.color2 = Color(Config.HPColor2.r+toAdd,Config.HPColor2.g+toAdd,Config.HPColor2.b+toAdd)
		if LocalPlayer():Health() < lastHP then
			animHP = RealTime() + 4
		end
		lastHP = LocalPlayer():Health()
	end

	local lastArmor = 0
	local animArmor = 0
	local toAdd = 0
	
	local maxArmor = 100

	local armorEntry = MakeEntry()
	armorEntry.color1 = Config.ArmorColor1
	armorEntry.color2 = Config.ArmorColor2
	armorEntry.mat = MatArmor
	function armorEntry:Think()
		maxArmor = math.max(maxArmor, LocalPlayer():Armor())
	
		toAdd = 20*math.sin(math.Clamp(animArmor-RealTime(), 0, 9000)*20)
		self.prog = LocalPlayer():Armor() / maxArmor
		self.value = LocalPlayer():Armor()
		self.color1 = Color(Config.ArmorColor1.r+toAdd,Config.ArmorColor1.g+toAdd,Config.ArmorColor1.b+toAdd)
		self.color2 = Color(Config.ArmorColor2.r+toAdd,Config.ArmorColor2.g+toAdd,Config.ArmorColor2.b+toAdd)
		if LocalPlayer():Armor() < lastArmor then
			animArmor = RealTime() + 4
		end
		lastArmor = LocalPlayer():Armor()
	end

	if IsDarkRP then
		if LocalPlayer():getDarkRPVar("Energy") then
			local hungerEntry = MakeEntry()
			hungerEntry.color1 = Config.HungerColor1
			hungerEntry.color2 = Config.HungerColor2
			hungerEntry.mat = MatHunger
			function hungerEntry:Think()
				self.prog = (LocalPlayer():getDarkRPVar("Energy") or 60)/100
				self.value = LocalPlayer():getDarkRPVar("Energy") or 60
			end
		end
	end

	// Money box

	local mbox = rbox:Add("DPanel")
	mbox:SetWide(152 * scale)
	mbox:DockMargin(-4 * scale, 0, 0, 0)
	mbox:SetTall(72 * scale)
	mbox:Dock(BOTTOM)
	function mbox:Paint(w, h)
		DrawMatShadowC(0, 4, w, h, false, true, false, false, 2)
		DrawMatShadowC(0, 4, w, h, false, true, false, false, 2)
	end

	// Microphone

	local mic = mbox:Add("DPanel")
	mic:SetSize(64 * scale,64 * scale)
	function mic:Think() 
		mic:SetPos(mbox:GetWide()-64 * scale-2 * scale, mbox:GetTall()-64 * scale-2 * scale)
	end

	local micAnim = 0

	function mic:Paint(w, h) 
		surface.SetDrawColor(Color(Config.TextColor.r,Config.TextColor.g,Config.TextColor.b,255*math.Clamp(micAnim,0,1)))
		surface.SetMaterial(MatMic)
		surface.DrawTexturedRect(0, 0, w, h)
		if LocalPlayer():IsSpeaking() then
			micAnim = Lerp(FrameTime()*2, micAnim, 5)
		else
			micAnim = Lerp(FrameTime()*5, micAnim, 0)
		end
	end

	// Bars

	local function MakeEntry()
		local entry = mbox:Add("DPanel")
		entry:DockMargin(12 * scale, 6 * scale, 8 * scale, -6 * scale)
		entry:SetTall(32 * scale)
		entry:Dock(TOP)

		function entry:Paint(w, h) end

		local img = entry:Add("DPanel")
		img:SetSize(32 * scale, 32 * scale)
		img:Dock(LEFT)
		function img:Paint(w, h)
			surface.SetDrawColor(entry.color1)
			surface.SetMaterial(entry.mat)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		local text = entry:Add("DLabel")
		entry.text = text
		text:SetFont("mhud_mtext")
		text:SetSize(128 * scale,2 * scale)
		text:DockMargin(8 * scale, 2 * scale, shadowOffset1, 2 * scale)
		text:Dock(FILL)
		text:SetColor(entry.color1)
		text:SetContentAlignment(4)

		return entry
	end

	if IsDarkRP then

		local moneyEntry = MakeEntry()
		moneyEntry.color1 = Config.MoneyColor
		moneyEntry.mat = MatMoney
		moneyEntry.text:SetColor(Config.MoneyColor)
		function moneyEntry:Think()
			self.text:SetText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")))
		end

		local salaryEntry = MakeEntry()
		salaryEntry.color1 = Config.SalaryColor
		salaryEntry.mat = MatMoney
		salaryEntry.text:SetColor(Config.SalaryColor)
		function salaryEntry:Think()
			self.text:SetText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary")))
		end

	else

		local props = 1

		local moneyEntry = MakeEntry()
		moneyEntry.color1 = Config.PlayTimeColor
		moneyEntry.mat = MatClock
		moneyEntry.text:SetColor(Config.PlayTimeColor)
		function moneyEntry:Think()
			local timeTbl = string.FormattedTime(RealTime())
			self.text:SetText(string.format("%02i:%02i", timeTbl.h, timeTbl.m))
		end

		local salaryEntry = MakeEntry()
		salaryEntry.color1 = Config.PropsColor
		salaryEntry.mat = MatProp
		salaryEntry.text:SetColor(Config.PropsColor)
		function salaryEntry:Think()
			self.text:SetText(props)
		end

		timer.Create("mathud_count_props", 5, 0, function()
			props = 0
			for k, v in pairs(ents.FindByClass("prop_physics")) do
				if v.CPPIGetOwner && v:CPPIGetOwner() == LocalPlayer() then
					props = props + 1
				end
			end
		end)

	end




	// Ammo
	MHUDA = vgui.Create("DPanel")
	MHUDA:SetSize(220 * scale, 140 * scale)
	MHUDA:SetPos(ScrW() - MHUDA:GetWide() - 5, ScrH() - MHUDA:GetTall() - 5)
	MHUDA:ParentToHUD()
	function MHUDA:Paint(w, h)
		if Config.Blur then
			local x, y = self:LocalToScreen(0, 0);
			SLib.Gui.DrawBlurRect(x + shadowOffset1, y + shadowOffset1, w - shadowOffset2, h - shadowOffset2, Config.BlurScale, Config.BlurScale, 255)
		end
		DrawMatBoxS(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, Config.BgColor)
	end

	// Bar

	local bar = MHUDA:Add("DPanel")
	bar:Dock(TOP)
	bar:SetHeight(64 * scale)
	function bar:Paint(w, h)
		DrawMatBox(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, Config.BarColor)
		DrawMatShadowC(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, false, false, false, true, 4)
		DrawMatShadowC(shadowOffset1, shadowOffset1, w-shadowOffset2, h-shadowOffset2, false, false, false, true, 4)

		surface.SetMaterial(MatMenu)
		surface.DrawTexturedRect(shadowOffset1, shadowOffset1, 32 * scale, 32 * scale)
	end

	local MaxAmmo = { }
	local MaxAllAmmo = { }
	
	local pbar, ammo, ammo1, ammo2, box1, box2

	if Config.AmmoStyle == 0 then
		ammo = MHUDA:Add("DLabel")
		ammo:SetColor(Config.TextColor)
		ammo:SetFont("mhud_ammo")
		ammo:SetSize( ammo:GetParent():GetWide(), shadowOffset2)
		ammo:CenterHorizontal()
		ammo:SetContentAlignment(5)
		function ammo:Think() 
			local weapon = LocalPlayer():GetActiveWeapon()

			if !IsValid(weapon) then
				return
			end

			local clip = tonumber(weapon:Clip1()) or -1
			local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")

			ammo:SetContentAlignment(5)
			if clip >= 0 || (MaxAmmo[weapon] or -1) >= 0 then
				ammo:SetFont("mhud_ammo")
				ammo:SetText("Ammo: " .. clip .. " / " .. allAmmo)
				ammo:SetPos(shadowOffset1+shadowOffset1, shadowOffset1+32+8) 
				ammo:CenterHorizontal()
			else
				ammo:SetText("Ammo: " .. allAmmo)
				ammo:SetFont("mhud_ammo_big")
				ammo:SetPos(shadowOffset1+shadowOffset1, shadowOffset1+32+18)
				ammo:CenterHorizontal()
			end
		end

		pbar = MHUDA:Add("DPanel")
		pbar.aprog = 0
		pbar.prog = 0.5
		pbar:SetSize(MHUDA:GetWide()-shadowOffset2-shadowOffset2, 4)
		pbar:SetPos(0,100 * scale)
		pbar:CenterHorizontal()
		function pbar:Paint(w, h)
			surface.SetDrawColor(Config.AmmoColor2)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(Config.AmmoColor1)
			surface.DrawRect(0, 0, w*(math.Clamp(pbar.aprog or 0, 0, 1)), h)
		end
		function pbar:Think()
			local weapon = LocalPlayer():GetActiveWeapon()

			if !IsValid(weapon) then
				return
			end

			local clip = tonumber(weapon:Clip1()) or -1
			local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")

			pbar.prog = clip/(MaxAmmo[weapon] or 1)

			pbar.aprog = Lerp(FrameTime()*10, pbar.aprog, pbar.prog)
		end
	else
		box1 = MHUDA:Add("DPanel")
		box1:DockMargin(shadowOffset1,-shadowOffset1,shadowOffset1,shadowOffset1)
		box1:Dock(LEFT)
		box1:SetWide(MHUDA:GetWide()/2-shadowOffset1+4)
		function box1:Paint(w, h)
			local weapon = LocalPlayer():GetActiveWeapon()

			if !IsValid(weapon) then
				return
			end

			local clip = tonumber(weapon:Clip1()) or -1
			local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")

			if clip >= 0 || (MaxAmmo[weapon] or -1) >= 0 then
				DrawMatShadowC(0, 0, w-4, h, false, false, true, false, 4)
				DrawMatShadowC(0, 0, w-4, h, false, false, true, false, 4)
			end
		end

		box2 = MHUDA:Add("DPanel")
		box2:DockMargin(shadowOffset1,-shadowOffset1,shadowOffset1,shadowOffset1)
		box2:Dock(RIGHT)
		box2:SetWide(MHUDA:GetWide()/2-shadowOffset1)
		function box2:Paint(w, h) end

		ammo = box1:Add("DLabel")
		ammo:SetColor(Config.TextColor)
		ammo:SetFont("mhud_ammo")
		ammo:SetSize( ammo:GetParent():GetWide(), 32 * scale)
		ammo:CenterHorizontal()
		ammo:SetContentAlignment(5)
		function ammo:Think() 
			local weapon = LocalPlayer():GetActiveWeapon()

			if !IsValid(weapon) then
				return
			end

			local clip = tonumber(weapon:Clip1()) or -1
			local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")

			ammo:SetContentAlignment(5)
			if clip >= 0 || (MaxAmmo[weapon] or -1) >= 0 then
				ammo:SetFont("mhud_ammo_big")
				ammo:SetText("" .. clip)
				ammo:SetPos(shadowOffset1+shadowOffset1, 14 * scale)
				ammo:CenterHorizontal()
			else
				ammo:SetFont("mhud_ammo_big")
				ammo:SetText("" .. allAmmo)
				ammo:SetPos(shadowOffset1+shadowOffset1, 14 * scale)
				ammo:CenterHorizontal()
			end
		end

		ammoU = box1:Add("DLabel")
		ammoU:SetColor(Config.TextColor)
		ammoU:SetFont("mhud_job")
		ammoU:SetText("Clip")
		ammoU:SetSize(ammoU:GetParent():GetWide(), 32 * scale)
		ammoU:CenterHorizontal()
		ammoU:SetContentAlignment(5)
		function ammoU:Think() 
			ammoU:SetPos(shadowOffset1+shadowOffset1, 14 * scale+24 * scale)
			ammoU:CenterHorizontal()
		end

		ammo2 = box2:Add("DLabel")
		ammo2:SetColor(Config.TextColor)
		ammo2:SetFont("mhud_ammo")
		ammo2:SetSize( ammo2:GetParent():GetWide(), 32 * scale)
		ammo2:CenterHorizontal()
		ammo2:SetContentAlignment(5)
		function ammo2:Think() 
			local weapon = LocalPlayer():GetActiveWeapon()

			if !IsValid(weapon) then
				return
			end

			local clip = tonumber(weapon:Clip1()) or -1
			local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")

			ammo2:SetContentAlignment(5)
			if clip >= 0 || (MaxAmmo[weapon] or -1) >= 0 then
				ammo2:SetFont("mhud_ammo_big")
				ammo2:SetText("" .. allAmmo)
				ammo2:SetPos(shadowOffset1+shadowOffset1, 14 * scale)
				ammo2:CenterHorizontal()
			end
		end

		ammo2U = box2:Add("DLabel")
		ammo2U:SetColor(Config.TextColor)
		ammo2U:SetFont("mhud_job")
		ammo2U:SetText("Reserve")
		ammo2U:SetSize(ammo2U:GetParent():GetWide(), 32 * scale)
		ammo2U:CenterHorizontal()
		ammo2U:SetContentAlignment(5)
		function ammo2U:Think() 
			ammo2U:SetPos(shadowOffset1+shadowOffset1, 14 * scale+24 * scale)
			ammo2U:CenterHorizontal()
		end

	end

	hook.Add("Tick", "MHUDATick", function()
		local weapon = LocalPlayer():GetActiveWeapon()

		if !IsValid(weapon) then 
			MHUDA:SetVisible(false)
			return
		end

		local clip = tonumber(weapon:Clip1()) or -1
		local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")

		if !MaxAmmo[weapon] || MaxAmmo[weapon] < clip then
			MaxAmmo[weapon] = clip
		end

		if !MaxAllAmmo[weapon] || MaxAllAmmo[weapon] < allAmmo then
			MaxAllAmmo[weapon] = allAmmo
		end

		if clip == -1 && allAmmo == 0 && MaxAllAmmo[weapon] <= 0 || clip == 0 && allAmmo == 0 && MaxAmmo[weapon] == 0 then
			MHUDA:SetVisible(false)
			return
		end // Hey baby - 76561198167061226 && 1.5.5

		if Config.AmmoStyle == 0 then
			if clip >= 0 || (MaxAmmo[weapon] or -1) >= 0 then
				pbar:SetVisible(true)
			else
				pbar:SetVisible(false)
			end
		else
			if clip >= 0 || (MaxAmmo[weapon] or -1) >= 0 then
				box2:SetVisible(true)
				MHUDA:SetWide(220 * scale)
				box1:SetWide(MHUDA:GetWide()/2-shadowOffset1+4)
				MHUDA:SetPos(ScrW() - MHUDA:GetWide() - 5 * scale, ScrH() - MHUDA:GetTall() - 5 * scale)
			else
				box2:SetVisible(false)
				MHUDA:SetWide(shadowOffset10)
				box1:SetWide(MHUDA:GetWide()-32 * scale)
				MHUDA:SetPos(ScrW() - MHUDA:GetWide() - 5 * scale, ScrH() - MHUDA:GetTall() - 5 * scale)
			end
		end
	
		MHUDA:SetVisible(true)
	end)

	if !IsDarkRP then return end

	// Agenda
	MHUDAg = vgui.Create("DPanel")
	MHUDAg:SetSize(380 * scale, 160 * scale)
	MHUDAg:SetPos(5 * scale, 5 * scale)
	MHUDAg:ParentToHUD()
	MHUDAg:SetExpensiveShadow(10, Color(0,0,0,255))
	function MHUDAg:Paint(w, h) 
		if Config.Blur then
			local x, y = self:LocalToScreen(0, 0);
			SLib.Gui.DrawBlurRect(x + shadowOffset1, y + shadowOffset1, w - shadowOffset2, h - shadowOffset2, Config.BlurScale, Config.BlurScale, 255)
		end
		DrawMatBoxS(shadowOffset1, shadowOffset1, w-32 * scale, h-32 * scale, Config.BgColor)
	end

	local bar = MHUDAg:Add("DPanel")
	bar:Dock(TOP)
	bar:SetHeight(64 * scale)
	function bar:Paint(w, h)
		DrawMatBox(shadowOffset1, shadowOffset1, w-32 * scale, h-32 * scale, Config.BarColor)
		DrawMatShadowC(shadowOffset1, shadowOffset1, w-32 * scale, h-32 * scale, false, false, false, true, 4)
		DrawMatShadowC(shadowOffset1, shadowOffset1, w-32 * scale, h-32 * scale, false, false, false, true, 4)

		surface.SetMaterial(MatMenu)
		surface.DrawTexturedRect(shadowOffset1, shadowOffset1, 32 * scale, 32 * scale)
	end

	local title = bar:Add("DLabel")
	title:Dock(FILL)
	title:DockMargin(shadowOffset1,2 * scale,0,0)
	title:SetColor(Color(255,255,255))
	title:SetFont("mhud_names")
	title:SetContentAlignment(5)
	title:SetText("Agenda")


	local text = MHUDAg:Add("DLabel")
	text:Dock(FILL)
	text:DockMargin(shadowOffset1+8 * scale,-shadowOffset1+8 * scale,shadowOffset1+8 * scale,shadowOffset1+8 * scale)
	text:SetWrap(true)
	text:SetColor(Config.TextColor)
	text:SetFont("mhud_job")
	text:SetContentAlignment(7)
	text:SetText("")
	function text:Think()
		local agenda = LocalPlayer():getAgendaTable()
		if !agenda then
			self:SetText("")
			return
		end

		self:SetText(LocalPlayer():getDarkRPVar("agenda") or "")
	end

	hook.Add("Tick", "MHUDAgTick", function()
		local agenda = LocalPlayer():getAgendaTable()
		if !agenda then
			MHUDAg:SetVisible(false)
			return
		end

		MHUDAg:SetVisible(true)
	end)

end

/*------------------------------------
	Entity Display
--------------------------------------*/

local function DrawEntityDisplay()
	local shootPos = LocalPlayer():GetShootPos()
	local aimVec = LocalPlayer():GetAimVector()

	for k, ply in pairs(players or player.GetAll()) do
		if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then continue end
		local hisPos = ply:GetShootPos()
		if IsDarkRP then
			if ply:getDarkRPVar("wanted") && ply.drawWantedInfo then ply:drawWantedInfo() end
		end

		if hisPos:DistToSqr(shootPos) < 100000 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.95 then
				local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
				if trace.Hit and trace.Entity ~= ply then return end
			
				local pos = (ply:EyePos()+Vector(0,0,15)):ToScreen()
				pos.y = pos.y - 90

				if ply:IsSpeaking() then
					surface.SetMaterial(MatSpeak)
					surface.SetDrawColor(Config.SpeakColor)
					surface.DrawTexturedRect(pos.x - 64, pos.y - 64 - 50, 128, 128)
				end
				
				if IsDarkRP && ply:getDarkRPVar("HasGunlicense") then
					surface.SetMaterial(MatGun)
					surface.SetDrawColor(Color(255, 255, 255))
					surface.DrawTexturedRect(pos.x - shadowOffset1, pos.y - shadowOffset1 - 10, 32, 32)
				end

				draw.DrawText(ply:Name(), "mhud_enameb", pos.x, pos.y, Color(0,0,0), 1)

				local a, b, c = ColorToHSV(team.GetColor(ply:Team()))
				draw.DrawText(ply:Name(), "mhud_ename", pos.x, pos.y, HSVToColor(a,b*0.8,0.9), 1)

				if IsDarkRP then
					draw.DrawText(ply:getDarkRPVar("job") or "", "mhud_ejobb", pos.x, pos.y + 40, Color(0,0,0), 1)
					draw.DrawText(ply:getDarkRPVar("job") or "", "mhud_ejob", pos.x, pos.y + 40, Color(255,255,255), 1)
				else
					draw.DrawText(team.GetName(ply:Team()), "mhud_ejobb", pos.x, pos.y + 40, Color(0,0,0), 1)
					draw.DrawText(team.GetName(ply:Team()), "mhud_ejob", pos.x, pos.y + 40, Color(255,255,255), 1)
				end

				local w, h = 100, 4
				surface.SetDrawColor(Config.EntHPColor2)
				surface.DrawRect(pos.x - w/2, pos.y + 90, w, h)
				surface.SetDrawColor(Config.EntHPColor1)
				surface.DrawRect(pos.x - w/2, pos.y + 90, w*math.Clamp(ply:Health()/100,0,1), h)
			end
		end
	end

	local tr = LocalPlayer():GetEyeTrace()

	if IsDarkRP && IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
		tr.Entity:drawOwnableInfo()
	end
end

local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
	timer.Destroy("DarkRP_AdminTell")
	local Message = msg:ReadString()

	AdminTell = function()
		draw.RoundedBox(4, 10, 10, Scrw - 20, 110, colors.darkblack)
		draw.DrawNonParsedText(DarkRP.getPhrase("listen_up"), "GModToolName", Scrw / 2 + 10, 10, colors.white, 1)
		draw.DrawNonParsedText(Message, "ChatFont", Scrw / 2 + 10, 90, colors.brightred, 1)
	end

	timer.Create("DarkRP_AdminTell", 10, 1, function()
		AdminTell = function() end
	end)
end)


hook.Add("HUDPaint", "MHUDEntityDisplay", function()
	if Config.HeadHUD then
		DrawEntityDisplay()
	end
	AdminTell()
end)

/*------------------------------------
	HUD Loading
--------------------------------------*/

local function HideMic()
	local mat, mat2, mat3, mat4, bt

	mat = Material( "invisible" )
	bt = mat:GetMaterialTexture( "$basetexture" )

	mat2 = Material( "voice/icntlk_local" )
	mat3 = Material( "voice/icntlk_sv" )
	mat4 = Material( "voice/icntlk_pl" )

	mat2:SetMaterialTexture( "$basetexture", bt )
	mat3:SetMaterialTexture( "$basetexture", bt )
	mat4:SetMaterialTexture( "$basetexture", bt )
end

//hook.Add("Initialize", "MHUDHideMic", HideMic)

if MHUD then
	CreateHUDPanel()
end

hook.Add("InitPostEntity", "MHUDInit", function()
	CreateHUDPanel()
end)

hook.Add("Tick", "MHUDTick", function()
	if Config != MHUDConfig then
		Config = MHUDConfig
		CreateHUDPanel()
	end
end)

/*------------------------------------
	Hide while holding camera
--------------------------------------*/

hook.Add("PlayerSwitchWeapon", "MHUDPlayerSwitchWeapon", function(ply, oldWeapon, newWeapon)
	local class = newWeapon:GetClass()
	MHUD:SetVisible(class != "gmod_camera")
end) 