function fcd.underLights()
	for k, veh in pairs( fcd.lightVehicles ) do
		if veh:IsVehicle() then
			if veh:GetNWBool( 'enableUnderLights' ) then
				if veh:GetPos():Distance( LocalPlayer():GetPos() ) > 1500 then continue end

				veh:DrawShadow( false )

				local clr = veh:GetNWVector( 'underLightColor', Vector( 25, 255, 25 ) )
				clr = Color( clr[ 1 ], clr[ 2 ], clr[ 3 ] )

				local pos = veh:GetPos()
				local ang = veh:GetAngles()

				veh.lights = {}

				veh.lights[ 1 ] = {
					lightPos = pos + ang:Right() * 100
				}
				veh.lights[ 2 ] = {
					lightPos = pos + ang:Right() * -75
				}
				veh.lights[ 3 ] = {
					lightPos = pos
				}
				veh.lights[ 4 ] = {
					lightPos = pos + ang:Forward() * 50
				}
				veh.lights[ 5 ] = {
					lightPos = pos + ang:Forward() * -50
				}
				veh.lights[ 6 ] = {
					lightPos = pos + ang:Forward() * -50 + ang:Right() * -75
				}
				veh.lights[ 7 ] = {
					lightPos = pos + ang:Forward() * 50 + ang:Right() * 100
				}
				veh.lights[ 8 ] = {
					lightPos = pos + ang:Forward() * -50 + ang:Right() * 100
				}
				veh.lights[ 9 ] = {
					lightPos = pos + ang:Forward() * 50 + ang:Right() * -75
				}

				for i = 1, #veh.lights do
					local underLight = DynamicLight( veh:EntIndex() + i )

					if underLight then
						underLight.pos = veh.lights[ i ].lightPos
						underLight.r = clr.r
						underLight.g = clr.g
						underLight.b = clr.b
						underLight.brightness = 6
						underLight.Decay = 0
						underLight.Size = 100
						underLight.DieTime = CurTime() + 1
					end
				end
			end
		end
	end
end

hook.Add( 'Think', 'fcd.underLights', fcd.underLights )

hook.Add( 'OnEntityCreated', 'underLightsEntCreated', function( ent )
	if not IsValid( ent ) then return end
	if not ent:IsVehicle() then return end

	table.insert( fcd.lightVehicles, ent )
end )