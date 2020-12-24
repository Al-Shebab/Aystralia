function fcd.clientVal( key )
	if not fcd.cfg.Client[ key ] then return end
	
	return  fcd.cfg.Client[ key ]
end

local blur = Material 'pp/blurscreen'

function fcd.drawBlur( pan, amt )
	local x, y = pan:LocalToScreen( 0, 0 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( '$blur', ( i / 3 ) * ( amt or 6 ) )
		blur:Recompute(  )
		render.UpdateScreenEffectTexture(  )
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

function fcd.drawBox( x, y, w, h, clr )
	if not clr then clr = fcd.clientVal( 'bgColor' ) end
	
	surface.SetDrawColor( clr )
	surface.DrawRect( x, y, w, h )
end

function fcd.drawOutlinedBox( x, y, w, h, clr )
	if not clr then clr = fcd.clientVal( 'bgColor' ) end

	fcd.drawBox( x, y, w, h, clr )

	surface.SetDrawColor( fcd.clientVal( 'lineColors' ) )
	surface.DrawLine( 0, 0, w - 1, 0 )
	surface.DrawLine( w - 1, 0, w - 1, h - 1 )
	surface.DrawLine( 0, h - 1, w - 1, h - 1 )
	surface.DrawLine( 0, 0, h, 0 )
end

function fcd.formatVehicles()
	for k, v in pairs( fcd.dataVehicles ) do
		v.class = k

		fcd.registeredVehicles[ k ] = {}
		fcd.registeredVehicles[ k ].price = v.price
		fcd.registeredVehicles[ k ].class = k

		if v.price == 0 then
			fcd.registeredVehicles[ k ].free = true
		end

		if v.rankRestrict then
			fcd.registeredVehicles[ k ].rankRestrict = function( ply )
				return table.HasValue( v.rankRestrict, ply:GetUserGroup() )
			end
		end

		if v.jobRestrict then
			fcd.registeredVehicles[ k ].jobRestrict = function( ply )
				return table.HasValue( v.jobRestrict, team.GetName( ply:Team() ) )
			end
		end

		if v.category then
			if not table.HasValue( fcd.categories, v.category ) then
				table.insert( fcd.categories, v.category )
			end

			fcd.registeredVehicles[ k ].category = v.category
		end

		for _, v in pairs( fcd.categories ) do
			local found = false

			for k, veh in pairs( fcd.dataVehicles ) do
				if veh.category then
					if veh.category == v then
						found = true
						break
					end
				end
			end

			if not found then
				table.RemoveByValue( fcd.categories, v )
			end
		end

		v.owned = true
	end
end

function fcd.drawCircle( x, y, rad, clr )
	local cir = {}

	table.insert( cir, { 
		x = x, 
		y = y,
		t = 0.5, 
		n = 0.5 
	} )

	for i = 0, 60 do
		local a = math.rad( ( i / 60 ) * -360 )
		table.insert( cir, {
			x = x + math.sin( a ) * rad,
			y = y + math.cos( a ) * rad,
			t = math.sin( a ) / 2 + 0.5, 
			n = math.cos( a ) / 2 + 0.5
		 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { 
		x = x + math.sin( a ) * rad, 
		y = y + math.cos( a ) * rad, 
		t = math.sin( a ) / 2 + 0.5, 
		n = math.cos( a ) / 2 + 0.5 
	} )

	surface.SetDrawColor( color_white )
	surface.DrawPoly( cir )
end

-- The following function is credited to Neth <3

function fcd.fixMdlPos( mdl )
	if !mdl then return end

	local mn, mx = mdl.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
	mdl:SetFOV( 45 )
	mdl:SetCamPos( Vector( size, size, size ) )
	mdl:SetLookAt( (mn + mx) * 0.5 )
end