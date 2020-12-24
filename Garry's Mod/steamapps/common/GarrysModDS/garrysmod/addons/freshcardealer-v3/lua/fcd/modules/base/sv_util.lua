function fcd.notifyServer( msg )
	if not msg then return end
	if not isstring( msg ) then msg = tostring( msg ) end

	MsgC( Color( 25, 255, 25 ), 'FRESH CAR DEALER: ', color_white, msg .. '\n' )
end

function fcd.notifyPlayer( ply, msg )
	if not msg then return end
	if not isstring(msg) then msg = tostring(msg) end
	
	if fcd.cfg.notifyType == 'chat' or fcd.notifyType == 'both' then
		net.Start( 'fcd.notifyPlayer' )
			net.WriteString( msg )
		net.Send( ply )
	end

	if fcd.cfg.notifyType == 'default' or fcd.notifyType == 'both' then
		DarkRP.notify( ply, 1, 5, msg )
	end
end

function fcd.registerVehicle(class, data)
	if not class then return end
	if not data then return end
	
	if not data.price then return false end

	fcd.registeredVehicles[ class ] = {}
	fcd.registeredVehicles[ class ].price = data.price

	if data.price == 0 then
		fcd.registeredVehicles[ class ].free = true
	end	

	fcd.subRegVehicle(class, data)
	fcd.dataRegVehicle(class, data)

	for _, ply in pairs( player.GetAll() ) do
		fcd.sendVehicles( ply )
	end
end

function fcd.subRegVehicle( class, data )
	if not class then return end
	if not data then return end
	
	if fcd.registeredVehicles[ class ] then
		if data.rankRestrict then
			fcd.registeredVehicles[ class ].rankRestrict = function( ply )
				return table.HasValue( data.rankRestrict, ply:GetUserGroup() )
			end
		end

		if data.jobRestrict then
			fcd.registeredVehicles[ class ].jobRestrict = function( ply )
				return table.HasValue( data.jobRestrict, team.GetName( ply:Team() ) )
			end
		end

		if data.failMsg then
			fcd.registeredVehicles[ class ].failMsg = data.failMsg
		end

		if data.specificDealer then
			fcd.registeredVehicles[ class ].specificDealer = data.specificDealer
		end
	end
end

function fcd.removeVehicle( class )
	if not fcd.registeredVehicles[ class ] then return end
	
	fcd.registeredVehicles[ class ] = nil
	fcd.dataVehicles[ class ] = nil
	
	fcd.saveRegisteredVehicles()
end