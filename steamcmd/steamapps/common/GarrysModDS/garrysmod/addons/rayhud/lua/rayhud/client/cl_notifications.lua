-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local ScreenPos = ScrH() - 300 * RayUI.Scale - (RayHUD.OffsetY + 12 * RayUI.Scale)

local Colors = {}
Colors[ NOTIFY_GENERIC ] = RayUI.Colors.Yellow
Colors[ NOTIFY_ERROR ] = RayUI.Colors.HP
Colors[ NOTIFY_UNDO ] = RayUI.Colors.LightArmor
Colors[ NOTIFY_HINT ] = RayUI.Colors.Armor
Colors[ NOTIFY_CLEANUP ] = RayUI.Colors.Green
local LoadingColor = RayUI.Colors.Green

local Icons = {}
Icons[ NOTIFY_GENERIC ] = RayUI.Icons.Bulb
Icons[ NOTIFY_ERROR ] = RayUI.Icons.Warning
Icons[ NOTIFY_UNDO ] = RayUI.Icons.Undo
Icons[ NOTIFY_HINT ] = RayUI.Icons.Help
Icons[ NOTIFY_CLEANUP ] = RayUI.Icons.Scissors
local LoadingIcon = RayUI.Icons.Loading

local Notifications = {}

function notification.AddLegacy( text, type, time )
	surface.SetFont( "RayUI:Large" )

	local w = select(1, surface.GetTextSize( text )) + 64 * RayUI.Scale
	local h = 42 * RayUI.Scale
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[ type ],
		icon = Icons[ type ],
		time = CurTime() + time,
		progress = nil,
	} )
end

notification.AddProgress = function( id, text, frac )
	for k, v in ipairs( Notifications ) do
		if v.id == id then
			v.text = text
			v.progress = frac

			return
		end
	end

	surface.SetFont( "RayUI:Large" )

	local w = surface.GetTextSize( text ) + 64 * RayUI.Scale
	local h = 42 * RayUI.Scale
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		col = LoadingColor,
		icon = LoadingIcon,
		time = math.huge,

		progress = math.Clamp( frac or 0, 0, 1 ),
	} )
end

notification.Kill = function( id )
	for k, v in ipairs( Notifications ) do
		if v.id == id then v.time = 0 end
	end
end

local function DrawNotification( x, y, w, h, text, icon, col, progress )

	 RayUI:DrawBlur2(x, y, w, h)

	draw.RoundedBox( 8, x, y, w, h, Color(RayUI.Colors.Gray.r, RayUI.Colors.Gray.g, RayUI.Colors.Gray.b, RayUI.Opacity))
	draw.RoundedBox( 8, x, y, h, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))

	surface.SetFont( "RayUI:Large" )
	draw.SimpleText( text, "RayUI:Large", x + 52 * RayUI.Scale, y + 18 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	surface.SetDrawColor( col )
	surface.SetMaterial( icon )

	if progress then
		surface.DrawTexturedRectRotated( x + 21 * RayUI.Scale, y + h / 2, 26 * RayUI.Scale, 26 * RayUI.Scale, -CurTime() * 360 % 360 )
	else
		surface.DrawTexturedRect( x + 8 * RayUI.Scale, y + 8 * RayUI.Scale, 26 * RayUI.Scale, 26 * RayUI.Scale )
	end
end

hook.Add( "HUDPaint", "RayHUD:DrawNotify", function()
	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.col, v.progress )

		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - RayHUD.OffsetX or ScrW() + 1 )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	end

	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end
end )

hook.Add("RayHUD:Reload", "RayHUD:UnloadNotifications", function()
	hook.Remove("HUDPaint", "RayHUD:DrawNotify")
end)

timer.Simple(0, function( )
	local function DisplayNotify(msg)
		local txt = msg:ReadString()

		GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
		surface.PlaySound("buttons/lightswitch2.wav")

		MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
	end

	usermessage.Hook("_Notify", DisplayNotify)
end)