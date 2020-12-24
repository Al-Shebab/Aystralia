function fcd.getDealerByID( id )
	if not id then return false end

	local found = false
	local dealer

	for k, ent in pairs( ents.FindByClass( 'freshcardealer' ) ) do
		if fcd.getDealerID( ent ) == id then
			found = true
			dealer = ent
			break
		end
	end

	if not found then
		fcd.notifyServer( 'Unable to find dealer under the ID ' .. id )
		return false
	end

	return dealer
end

function fcd.getDealerID( ent )
	if not ent then return end
	
	return ent:GetdealerID()
end

function fcd.getDealerName( ent )
	if not ent then return end
	
	return ent:GetdealerName()
end

function fcd.getDealerPlatforms( id )
	if not id then return end

	local plats = {}

	for k, ent in pairs( ents.FindByClass( 'vehicleplatform' ) ) do
		if ent.dealerID == id then
			plats[ k ] = {
				pos = ent:GetPos(),
				ang = ent:GetAngles()
			}
		end
	end

	return plats
end