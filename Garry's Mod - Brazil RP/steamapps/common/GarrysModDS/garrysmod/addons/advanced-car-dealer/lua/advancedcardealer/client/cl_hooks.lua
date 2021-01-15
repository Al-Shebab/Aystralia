local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local CFG = AdvCarDealer.GetConfig
local font = KVS.GetFont

hook.Add( "OnEntityCreated", "OnEntityCreated.AdvancedCarDealer", function( eEnt )
	if eEnt:IsVehicle() then
		table.insert( AdvCarDealer.ListVehiclesSpawned, eEnt )
	end
end )

hook.Add( "Think", "Think.AdvancedCarDealer", function()
	for _, eVehicle in pairs( AdvCarDealer.ListVehiclesSpawned ) do
		if not IsValid( eVehicle ) then AdvCarDealer.ListVehiclesSpawned[ _ ] = nil continue end

		if not eVehicle.UnderglowPreviewColor and ( not AdvCarDealer.UnderglowVehicles[ eVehicle:GetNWInt( "CreationID" ) ] or eVehicle:GetNWString( "Underglow" ) == "" ) then continue end

		local dlight = DynamicLight( eVehicle:EntIndex() )
		if ( dlight ) then
			local color = string.ToColor( eVehicle.UnderglowPreviewColor or eVehicle:GetNWString( "Underglow" ) )
			local min = LocalToWorld( eVehicle:OBBMins(), eVehicle:GetAngles(), eVehicle:GetPos(), eVehicle:GetAngles() )
			local center = LocalToWorld( eVehicle:OBBCenter(), eVehicle:GetAngles(), eVehicle:GetPos(), eVehicle:GetAngles() )
			dlight.pos = Vector( center.x, center.y, min.z )
			dlight.r = color.r
			dlight.g = color.g
			dlight.b = color.b
			dlight.brightness = 3
			dlight.Decay = 1000
			dlight.Size = 500
			dlight.DieTime = CurTime() + 1
		end
	end
end )

hook.Add( "HUDPaint", "HUDPaint.AdvancedCarDealer", function()
	local posx, posy = 0, 0

	if LocalPlayer():InVehicle() and AdvCarDealer.UnderglowVehicles[ LocalPlayer():GetVehicle():GetNWInt( "CreationID" ) ] then
		KVS:DrawLinearGradient( posx, posy, 300, 45, Color( 40, 40, 40, 255 ), Color( 0, 0, 0, 0 ), false )
		draw.RoundedBox( 3, posx + 10, posy + 10, 24, 24, Color( 150, 150, 150 ) )
		draw.RoundedBox( 1, posx + 13, posy + 13, 18, 18, Color( 200, 200, 200 ) )
		draw.SimpleText( string.upper( input.GetKeyName( CFG().KeyToStopUnderglow ) ), font( "Rajdhani Bold", 20 ), posx + 10 + 25 / 2, posy + 10 + 23 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( sentences[ 24 ], font( "Rajdhani Bold", 20 ), posx + 40, posy + 23, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		posx, posy = 0, 50
	end
	if LocalPlayer():InVehicle() and LocalPlayer():GetVehicle():GetNWBool( "canReturnInGarage" ) then
		KVS:DrawLinearGradient( posx, posy, 300, 45, Color( 40, 40, 40, 255 ), Color( 0, 0, 0, 0 ), false )
		draw.RoundedBox( 3, posx + 10, posy + 10, 24, 24, Color( 150, 150, 150 ) )
		draw.RoundedBox( 1, posx + 13, posy + 13, 18, 18, Color( 200, 200, 200 ) )
		draw.SimpleText( string.upper( input.GetKeyName( CFG().KeyToReturnIntoGarage ) ), font( "Rajdhani Bold", 20 ), posx + 10 + 25 / 2, posy + 10 + 23 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( sentences[ 57 ], font( "Rajdhani Bold", 20 ), posx + 40, posy + 23, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
end )

AdvCarDealer.LoadCarInformations()
