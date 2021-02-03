-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

local ScreenPos = ScrH() - 300 * FlatHUD.Scale

local Colors = {}
Colors[ NOTIFY_GENERIC ] = FlatUI.Colors.Yellow
Colors[ NOTIFY_ERROR ] = FlatUI.Colors.HP
Colors[ NOTIFY_UNDO ] = FlatUI.Colors.LightArmor
Colors[ NOTIFY_HINT ] = FlatUI.Colors.Armor
Colors[ NOTIFY_CLEANUP ] = FlatUI.Colors.Green
local LoadingColor = FlatUI.Colors.Green

local Icons = {}
Icons[ NOTIFY_GENERIC ] = FlatUI.Icons.Bulb
Icons[ NOTIFY_ERROR ] = FlatUI.Icons.Warning
Icons[ NOTIFY_UNDO ] = FlatUI.Icons.Undo
Icons[ NOTIFY_HINT ] = FlatUI.Icons.Help
Icons[ NOTIFY_CLEANUP ] = FlatUI.Icons.Scissors
local LoadingIcon = FlatUI.Icons.Loading

local Notifications = {}

function notification.AddLegacy( text, type, time )
	surface.SetFont( "FlatHUD:Notification" )

	local w = surface.GetTextSize( text ) + 64 * FlatHUD.Scale
	local h = 43 * FlatHUD.Scale
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

	surface.SetFont( "FlatHUD:Notification" )

	local w = surface.GetTextSize( text ) + 64 * FlatHUD.Scale
	local h = 43 * FlatHUD.Scale
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
	draw.RoundedBox( 8, x, y, w, h, Color(FlatUI.Colors.DarkGray.r, FlatUI.Colors.Gray.g, FlatUI.Colors.Gray.b, FlatHUD.Opacity))
	draw.RoundedBox( 8, x, y, h, h, FlatUI.Colors.DarkGray3)

	draw.SimpleText( text, "FlatHUD:Notification", x + 52 * FlatHUD.Scale, y + h / 2, FlatUI.Colors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	surface.SetDrawColor( col )
	surface.SetMaterial( icon )

	if progress then
		surface.DrawTexturedRectRotated( x + 21 * FlatHUD.Scale, y + h / 2, 26 * FlatHUD.Scale, 26 * FlatHUD.Scale, -CurTime() * 360 % 360 )
	else
		surface.DrawTexturedRect( x + 8 * FlatHUD.Scale, y + 8 * FlatHUD.Scale, 26 * FlatHUD.Scale, 26 * FlatHUD.Scale )
	end
end

hook.Add( "HUDPaint", "FlatHUD:DrawNotify", function()
	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.col, v.progress )

		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1 )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	end

	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end
end )

timer.Simple(0,function( )
	local function DisplayNotify(msg)
		local txt = msg:ReadString()

		GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
		surface.PlaySound("buttons/lightswitch2.wav")

		MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
	end

	usermessage.Hook("_Notify", DisplayNotify)
end)