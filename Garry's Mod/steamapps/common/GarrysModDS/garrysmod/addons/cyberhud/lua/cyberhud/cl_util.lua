-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝───────────────────--
-- ──────── Local Var. ───────--
local render = render
local surface = surface
local cam = cam
local rt, rtm1, rtm2
local table = table
local CurTimeL = UnPredictedCurTime
local ScrW, ScrH = ScrW, ScrH
local ScreenScale = ScreenScale
local math = math
local NewFont = surface.CreateFont
local glitchPattern = {}
local maxStr, maxDis, minCut, maxCut, repeats = 20, 4, 30, 120, 0.05

-- ────────── Fonts ──────────--

NewFont( "CyberHud.Main36", { font = "Jet Set", extended = true, size = 36, antialias = true, weight = 500} )
NewFont( "CyberHud.Main24", { font = "Jet Set", extended = true, size = 24, antialias = true, weight = 500} )
NewFont( "CyberHud.Main18", { font = "Jet Set", extended = true, size = 18, antialias = true, weight = 500} )
NewFont( "CyberHud.Main16", { font = "Jet Set", extended = true, size = 16, antialias = true, weight = 500} )
NewFont( "CyberHud.Sub24", { font = "The Capt", extended = true, size = 24, antialias = true, weight = 800} )

-- ───── Paint Functions ─────--

function CyberHud.Alpha(c, a)
	
	if a < 1 then a = 1 end
	
	return Color(c.r,c.g,c.b,a)
end

local linesType = {
	["st"] = "cyberhud/d_lines.png",
	["rd"] = "cyberhud/lines.png",
	["gr"] = "cyberhud/g_lines.png"
}

function CyberHud.DrawBloomLines(x, y, w, h, color, type)
	
	if !linesType[type] then type = "st" end
	
	local mat = Material(linesType[type])
	
	surface.SetMaterial( mat )
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( x, y, w, h )
	
end

function CyberHud.DrawEdgeRec(x, y, w, h, lw, color)
	
	surface.SetDrawColor(color)
	if lw then
		surface.DrawLine( x, y, x+lw, y )
		surface.DrawLine( w+x-1, y, w+x-lw-1, y )
		surface.DrawLine( x, y+h-1, x+lw, y+h-1 )
		surface.DrawLine( w+x-1, y+h-1, w+x-lw-1, y+h-1 )
		surface.DrawLine( x, y, x, y+lw )
		surface.DrawLine( w+x-1, y, w+x-1, y+lw )
		surface.DrawLine( x, y, x, y+lw )
		surface.DrawLine( w+x-1, y+h-1, w+x-1, y+h-lw-1 )
		surface.DrawLine( x, y+h-1, x, y+h-lw-1 )
	end

end

function CyberHud.DrawStat(x, y, color, stat, mat)
	
	if !stat then return false end
	
	mat = Material(mat)
	CyberHud.DrawBloomLines(x, y, 32, 32, CyberHud.Alpha(color, 50), "gr")
	CyberHud.DrawEdgeRec(x+1, y+1, 32, 32, 5, color_black)
	CyberHud.DrawEdgeRec(x, y, 32, 32, 5, color)
	surface.SetMaterial( mat )
	surface.SetDrawColor( color_black )
	surface.DrawTexturedRect( x+1, y+1, 32, 32 )
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( x, y, 32, 32 )
	
	return true
	
end

function CyberHud.TitleBox(x, y, w, text, align, icon)
	
	surface.SetFont( "CyberHud.Main18" )
	local wl = surface.GetTextSize( text )
	
	if !w or w < (wl + 35) then
		w = wl + 35
	end
	
	if align == "align_right" then
		x = x - w
	end
	
	CyberHud.DrawBloomLines(x + 5, y - 6, w+10, 25, CyberHud.Alpha(CyberHud.Patern["main_l"], 255), "gr")
	draw.RoundedBox(0, x, y, w, 22, CyberHud.Patern["main_l"])
	CyberHud.DrawBloomLines(x, y, w, 24, CyberHud.Alpha(CyberHud.Patern["main_d"], math.random(10,50)), "rd")
	
	if icon then
		surface.SetDrawColor( CyberHud.Alpha(CyberHud.Patern["main_l"], math.random(190,250)) )
		surface.SetMaterial( Material(icon) )
		surface.DrawTexturedRect( x - 30, y-1, 24, 24 )
	end
	
	draw.SimpleTextOutlined(string.upper(text), "CyberHud.Main18", x+10, y + 10,color_black,TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1,  CyberHud.Patern["main_l"])
	
	return w
	
end

function CyberHud.TextBox(x, y, w, text, align, icon, alfa, color)
	
	if !alfa then alfa = 255 end
	
	if !color then color = CyberHud.Patern["main_l"] end
	
	surface.SetFont( "CyberHud.Main18" )
	local wl = surface.GetTextSize( text )
	
	if !w or w < (wl + 35) then
		w = wl + 35
	end
	
	if align == "align_right" then
		x = x - w
	end
	
	CyberHud.DrawBloomLines(x, y, w, 22, CyberHud.Alpha(color, alfa-100), "gr")
	
	if icon then
		surface.SetDrawColor( CyberHud.Alpha(color, alfa-math.random(190,250)) )
		surface.SetMaterial( Material(icon) )
		surface.DrawTexturedRect( x - 30, y-1, 24, 24 )
	end
	
	draw.SimpleTextOutlined(text, "CyberHud.Main18", x+10, y + 10,CyberHud.Alpha(color, alfa),TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, CyberHud.Alpha(CyberHud.Patern["shadow"], alfa-100))
	
	return w
	
end

function CyberHud.TextLineCustom(x, y, text, align, font, alfa, outline, color)
	
	if !alfa then alfa = 255 end
	
	if !color then color = CyberHud.Patern["main_l"] end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	if w < 150 and outline then
		w = 150
	end
	
	local al = w/2
	
	if align == TEXT_ALIGN_RIGHT then
		x = x - w
		al = 0
	elseif align == TEXT_ALIGN_LEFT then
		al = 0
	end
	
	CyberHud.DrawBloomLines(x-al, y+h/2, w+35, 22, CyberHud.Alpha(color, alfa-200), "gr")
	
	if outline then
	
		CyberHud.DrawEdgeRec(x-w/2+6,y+h/2-4, w+15,h+10, 5, CyberHud.Alpha(CyberHud.Patern["shadow"], alfa))
		
		CyberHud.DrawEdgeRec(x-w/2+5,y+h/2-5, w+15,h+10, 5, CyberHud.Alpha(color, alfa))
		
	end
	
	draw.SimpleTextOutlined(text, font, x+10, y + 10,CyberHud.Alpha(color, alfa),align, 0, 1, CyberHud.Alpha(CyberHud.Patern["shadow"],alfa))
	
	return w, h
	
end

local function prepareTable(x,y,tbl)

	tbl = table.Copy(tbl)

	for _,v in pairs(tbl) do
	
		v.x = v.x
		v.y = v.y
		
		v.x = math.ceil( v.x + x )
		v.y = math.ceil( v.y + y )
		
	end
	
	return tbl
end

function CyberHud.DrawPoly(x,y,h,color,len)
	draw.NoTexture(-1)
	surface.SetDrawColor( color ) 
	local tbl = {
		{x = 0,y = 0},
		{x = math.max(0,len ),y = 0},
		{x = math.max(0,len ),y = h/2},
		{x = math.max(0,len-h/2 ),y = h},
		{x = 0,y = h}
	}
	surface.DrawPoly(prepareTable(x, y,tbl))
end

function CyberHud.DrawPolyMoving(x,y,h,color,len,max)
	draw.NoTexture(-1)
	surface.SetDrawColor( color )
	if len >= (max - h/2) then
		local tbl = {
			{x = 0,y = 0},
			{x = math.max(0,len ),y = 0},
			{x = math.max(0,len ),y = h/2+(max-len)},
			{x = math.max(0,max-h/2 ),y = h},
			{x = 0,y = h}
		}	
		surface.DrawPoly(prepareTable(x, y,tbl))
	else
		surface.DrawRect( x, y, len, h )
	end
end

function CyberHud.DrawCyberBoards(x,y,w,h,a,c)
	
	if w < 100 or h < 100 then return end
	
	
	surface.SetDrawColor( c or CyberHud.Alpha(CyberHud.Patern["main_l"], a) )
	surface.SetMaterial( Material("cyberhud/ui/corner_50f.png") )
	surface.DrawTexturedRect( x, y, 50, 50 )
	surface.DrawTexturedRectRotated( x+w-25, y+25, 50, 50, -90 )
	surface.SetMaterial( Material("cyberhud/ui/corner_50.png") )
	surface.DrawTexturedRectRotated( x+w-25, y+h-25, 50, 50, 90 )
	surface.DrawTexturedRect( x, y+h-50, 50, 50 )
	
end

-- ────── Notifications ──────--

local notifications = {}

local icons = {
	[NOTIFY_ERROR]	= Material( "cyberhud/notifications/error.png" ),
	[NOTIFY_UNDO] = Material( "cyberhud/notifications/undo.png" ),
	[NOTIFY_HINT] = Material( "cyberhud/notifications/hint.png" ),
	[NOTIFY_GENERIC] = Material( "cyberhud/notifications/generic.png" ),
	[NOTIFY_CLEANUP] = Material( "cyberhud/notifications/clean.png" ),
	[5] = Material( "cyberhud/notifications/item.png" ),
	[6] = Material( "cyberhud/notifications/ammo.png" ),
	["loading"] = Material( "cyberhud/notifications/loading.png" ),
}

local n_colors = {
	[NOTIFY_ERROR]	= CyberHud.Patern["red"],
	[NOTIFY_UNDO] = CyberHud.Patern["blue"],
	[NOTIFY_HINT] = CyberHud.Patern["yellow"],
	[NOTIFY_GENERIC] = CyberHud.Patern["yellow"],
	[NOTIFY_CLEANUP] = CyberHud.Patern["blue"],
	[5] = CyberHud.Patern["blue"],
	[6] = CyberHud.Patern["blue"],
	["loading"] = CyberHud.Patern["hunger"],
}

local function DrawNotification( x, y, w, h, text, icon, type, a, sub )
	
	surface.SetFont( "CyberHud.Main18" )
	local wl = surface.GetTextSize( string.sub(text,1,w) )
	local main_color = CyberHud.Patern["main_l"]
	
	if sub then
		main_color = CyberHud.Patern["sub_l"]
	end
	
	if !CyberHud.Config.MainColorBased then
		main_color = n_colors[type]
	end
	
	CyberHud.DrawBloomLines(x - wl - 40, y, wl+30, 30, CyberHud.Alpha(main_color, math.Clamp(a - math.random(100,180),0,100) ), "gr")
	
	draw.SimpleTextOutlined( string.sub(text,1,w), "CyberHud.Main18", x - 32 - 10, y + h / 2, main_color,TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1 , CyberHud.Patern["shadow"])
	
	if !icon and type == "loading" then icon = icons["loading"] end
	
	if icon then
		surface.SetDrawColor( CyberHud.Alpha(main_color, a) )
		surface.SetMaterial( icon )
		
		if type == "loading" then
			surface.DrawTexturedRectRotated( x - 22, y + 16, 16, 16, -CurTime() * 360 % 360 )
		else
			surface.DrawTexturedRect( x - 30, y + 4, 24, 24 )
		end
	end
end

function notification.AddLegacy( text, type, time, sub )

	local w, h, x ,y, t, a, s
	w = 0
	h = 32
	x = ScrW()
	y = 15
	t = 0
	a = 0
	s = sub

	table.insert( notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,
		t = t,
		a = a,
		s = sub,
		text = text,
		type = type,
		icon = icons[ type ],
		time = CurTime() + time,
	} )
end

function notification.AddProgress( id, text, args )

	if args then return end
	
	local w, h, x ,y, t, a
	w = 0
	h = 32
	x = ScrW()
	y = 15
	t = 0
	a = 0
	
	table.insert( notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,
		t = t,
		a = a,
		id = id,
		text = text,
		type = "loading",
		icon = icons[ type ],
		time = math.huge,
	} )
end

function notification.Kill( id )
	for k, v in ipairs( notifications ) do
		if v.id == id then v.time = 0 end
	end 
end

function CyberHud.DrawNotifications()
	
	for k, v in ipairs( notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.type, v.a, v.s )
		v.x = ScrW() - 10 or ScrW() + 1
		v.y = Lerp( FrameTime() * 10, v.y, (15 + (CyberHud.Spacing or 0) ) + ( k - 1 ) * ( v.h + 5 ) )
		if v.time > CurTime() then
			if (CurTime() > v.t) and v.w < string.len(v.text) then
				v.w = v.w + 1
				v.t = CurTime() + FrameTime() * 3
			end
			v.a = Lerp( FrameTime() * 10, v.a, 255 )
		else
			if (CurTime() > v.t) then
				v.w = v.w - 1
				v.t = CurTime() + FrameTime() * 3
			end
			v.a = Lerp( FrameTime() * 10, v.a, 0 )
		end
	end

	for k, v in ipairs( notifications ) do
		if v.w <= 1 and v.time < CurTime() then
			table.remove( notifications, k )
		end
	end
	
end

function CyberHud.DrawBigNotifications()

end

function CyberHud.Alert(text)
	local stime = CurTime()
	local mat = Material("cyberhud/warning_big_a.png")
	local color = CyberHud.Patern["red"]
	local bloom = 1
	local a = 0
	local x, y = ScrW()/2, ScrH()/2-300
	
	local stext = string.Explode("\n", text)
	
	CyberHud.DrawBigNotifications = function()
		
		bloom = math.Approach( bloom, 0, 0.5 * FrameTime() )
		
		if bloom > 0 and CyberHud.Config.EnableFlash then
			DrawBloom( 0, bloom, 11, 11, 11, 2, color.r*0.001,color.g*0.001,color.b*0.001 )
		end
		
		surface.SetFont( "CyberHud.Main24" )
		local w, h = surface.GetTextSize( stext[1] )
		
		CyberHud.DrawCyberBoards(x-w/2-90,y-30,w+125,math.Clamp( #stext*h+50,100,ScrH()),a,CyberHud.Alpha(color, a))
		
		surface.SetMaterial(mat)
		surface.SetDrawColor(255,255,255,a)
		surface.DrawTexturedRect(x-w/2-70,y-20,64,64)
	
		for i = 0, #stext-1 do
			CyberHud.DrawBloomLines(x-w/2, (y-5)+(i*h), w, 30, CyberHud.Alpha(CyberHud.Patern["main_l"], math.Clamp(a,0,25)), "gr")
			draw.SimpleTextOutlined( stext[i+1] ,"CyberHud.Main24", x-w/2,(y-5)+(i*h),CyberHud.Alpha(color, a), 3, 2, 1, Color(0, 0, 0, math.Clamp(a,0,50)) )
		end
		
		if stime + 7 < CurTime() then
			a = math.Approach( a, 0, 300 * FrameTime() )
		else
			a = math.Approach( a, 255, 700 * FrameTime() ) 
		end
		
		if stime + 10 < CurTime() then
			CyberHud.DrawBigNotifications = function() end
		end
	end
end

net.Receive( "CyberHud.Alert", function()

	local text = net.ReadString()
	
	CyberHud.Alert(text)
	
end)

net.Receive( "CyberHud.playerArrested", function()

	local time = net.ReadFloat()
	
	ply.CyberHudInfo = {CurTime(), time}
	
end)

-- ───── Door Information ────--

function CyberHud.GetDoorPos( ent )
    local dvec = ent:OBBMaxs() - ent:OBBMins()
    local cvec = ent:OBBCenter()
    local imin, ikey, normv, ang, pos, idot
    
    for i = 1, 3 do
        if !imin or dvec[i] <= imin then
            ikey = i
            imin = dvec[i]
        end
    end

    normv = Vector()
    normv[ikey] = 1
    ang = Angle( 0, normv:Angle().y + 90, 90 )

    if ent:GetClass() == "prop_door_rotating" then
        pos = Vector( cvec.x, cvec.y, 15 ) + ang:Up() * ( imin / 6 )
    else
        pos = cvec + Vector( 0, 0, 20 ) + ang:Up() * ( ( imin * 0.5 ) - 0.1 )
    end

    local n_ang = ent:LocalToWorldAngles( ang )
    idot = n_ang:Up():Dot( LocalPlayer():GetShootPos() -ent:WorldSpaceCenter() )

    if idot < 0 then
        ang:RotateAroundAxis( ang:Right(), 180 )

        pos = pos - ( 2 * pos * -ang:Up() )
        n_ang = ent:LocalToWorldAngles( ang )
    end
    pos = ent:LocalToWorld( pos )

    return pos, n_ang
end

function CyberHud.DrawDoorinfo()
	
    local door = CyberHud.DrawDoorInfoEnt
	
	if !door or !IsValid( door ) then return end
	
    if !door.isDoor or !door:isKeysOwnable() then return end
    if !door.getKeysNonOwnable then return end
    
    local pos, ang = CyberHud.GetDoorPos( door )

    cam.Start3D2D( pos, ang, .09 )
        CyberHud.EntInfoFunction(door, 0, 0)
    cam.End3D2D()
	
end

-- ─ Glitches Paint Functions --
-- ─ Copyright (C) 2018 DBot ─--

local function refreshRT()
	local textureFlags = 0
	textureFlags = textureFlags + 16
	textureFlags = textureFlags + 256
	textureFlags = textureFlags + 2048
	textureFlags = textureFlags + 32768
	
	rt = GetRenderTargetEx('chg_rt', ScrW(), ScrH(), RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_ONLY, textureFlags, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888)
	local salt = '_4'

	rtm1 = CreateMaterial('chg_rtm1' .. salt, 'UnlitGeneric', {
		['$basetexture'] = 'models/debug/debugwhite',
		['$translucent'] = '1',
		['$halflambert'] = '1',
		['$color'] = '1 0.9 0',
		['$color2'] = '1 0.9 0',
		['$alpha'] = '1',
		['$additive'] = '0',
	})

	rtm2 = CreateMaterial('chg_rtm2' .. salt, 'UnlitGeneric', {
		['$basetexture'] = 'models/debug/debugwhite',
		['$translucent'] = '1',
		['$halflambert'] = '1',
		['$color'] = '0 0.98 1',
		['$color2'] = '0 0.98 1',
		['$additive'] = '1',
	})

	rtm1:SetTexture('$basetexture', rt)
	rtm2:SetTexture('$basetexture', rt)

	rtm1:SetVector('$color', Color(255, 255, 255):ToVector())
	rtm1:SetVector('$color2', Color(255, 255, 255):ToVector())
	rtm2:SetVector('$color', Color(255, 200, 200):ToVector())
	rtm2:SetVector('$color2', Color(255, 200, 200):ToVector())
end
refreshRT()

local function generateGlitches(iterations, frameRepeats, strength)
	strength = strength or 1
	frameRepeats = frameRepeats or repeats
	iterations = iterations or 20
	local rTime = CurTimeL()
	local w, h = ScrW(), ScrH()
	local initial = math.floor(rTime / repeats)
	minCut = ScreenScale(7) * strength
	maxCut = ScreenScale(16) * strength
	maxStr = ScreenScale(24) * strength
	maxDis = ScreenScale(3.5) * strength

	for i = 1, iterations do
		local data = {
			xStrength = math.random(-maxStr, maxStr),
			yStrength = math.random(-maxStr, maxStr),
			xDistort = math.random(0, maxDis),
			yDistort = math.random(0, maxDis),
			ttl = rTime + i * frameRepeats,
			seed = lookupSeed,
			iterations = {}
		}

		table.insert(glitchPattern, data)

		local ty = -8

		while ty < h do
			local height = math.random(minCut, maxCut)
			local strengthValue = math.random(data.xStrength, data.yStrength + data.xStrength) * 0.4
			local distortValue = math.random(data.xDistort * 0.25, data.xDistort)

			local iteration = {
				math.floor(ty + 9),
				math.floor(height),
				strengthValue
			}

			iteration[4] = 0
			iteration[5] = ty / h
			iteration[6] = 1
			iteration[7] = (ty + height) / h

			iteration[8] = distortValue * 2
			table.insert(data.iterations, iteration)

			ty = ty + height
			if ty >= h then break end
		end

	end

	return glitchPattern
end

function CyberHud.PreDrawGlitch(enabled)
	if !enabled or !CyberHud.DrawGlitchEffect() then return end
	render.PushRenderTarget(rt)

	if math.random() >= 0.5 then
		render.Clear(0, 0, 0, 0, true, true)
	else
		render.Clear(0, 0, 0, 0, true, true)
	end

	cam.Start2D()
end

function CyberHud.PostDrawGlitch(enabled, int)
	if !enabled or !CyberHud.DrawGlitchEffect() then return end
	cam.End2D()
	render.PopRenderTarget()
	
	if int then
		int = {math.Clamp(1-int,0.1,1), 1}
		
		if int[1] > 0.9 then int[2] = 2 end
		
	else
		int = {0.1, 1}
	end
	
	local rTime = CurTimeL()
	local glitch = glitchPattern[1]

	while glitch and glitch.ttl < rTime do
		table.remove(glitchPattern, 1)
		glitch = glitchPattern[1]
	end

	if not glitch then
		generateGlitches(20, 0.10, int[1])
		glitch = glitchPattern[1]
	end

	local w, h = ScrW(), ScrH()

	for i, iteration in ipairs(glitch.iterations) do
		surface.SetMaterial(rtm1)
		surface.DrawTexturedRectUV(iteration[3], iteration[int[2]], w, iteration[2], iteration[4], iteration[5], iteration[6], iteration[7])

		surface.SetMaterial(rtm2)
		surface.DrawTexturedRectUV(iteration[3] - iteration[8], iteration[1], w, iteration[2], iteration[4], iteration[5], iteration[6], iteration[7])
	end
end
