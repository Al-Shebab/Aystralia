util.AddNetworkString 'fcd.dealerAdminOpen'
util.AddNetworkString 'fcd.spawnPlatform'
util.AddNetworkString 'fcd.applyChanges'
util.AddNetworkString 'fcd.openAdmin'
util.AddNetworkString 'fcd.giveVehicle'
util.AddNetworkString 'fcd.takeVehicle'
util.AddNetworkString 'fcd.addVehicle'
util.AddNetworkString 'fcd.removeVehicle'

net.Receive( 'fcd.spawnPlatform', function( len, ply )
	if not fcd.adminAccess( ply ) then return end
	
	fcd.spawnPlatform( net.ReadString() )
end )

net.Receive( 'fcd.applyChanges', function( len, ply )
	if not fcd.adminAccess( ply ) then return end
	
	local data = net.ReadTable()
	local dealerID = net.ReadString()

	local dealer = fcd.getDealerByID( dealerID )
	if not dealer then return end

	if data.dealerName then
		fcd.setDealerName( dealer, data.dealerName )
	end

	if data.dealerModel then
		dealer:SetModel( data.dealerModel )
	end

	if data.dealerID then
		fcd.setDealerID( dealer, data.dealerID )
	end

	dealer:SetisSpecific( data.specificDealer )

	fcd.saveDealers()
	fcd.notifyPlayer( ply, 'Applied the changed and saved all dealers!' )
end )

net.Receive( 'fcd.giveVehicle', function( len, ply )
	local str = net.ReadString()
	local trgt = net.ReadEntity()

	if not fcd.adminAccess( ply ) then return end

	fcd.giveVehicle( trgt, str )
end )

net.Receive( 'fcd.takeVehicle', function( len, ply )
	local str = net.ReadString()
	local trgt = net.ReadEntity()

	if not fcd.adminAccess( ply ) then return end

	fcd.takeVehicle( trgt, str )
end )

net.Receive( 'fcd.addVehicle', function( len, ply )
	local data = net.ReadTable()
	if not data then return end

	local class = net.ReadString()
	if not class then return end

	if not fcd.adminAccess( ply ) then return end

	fcd.registerVehicle( class, data )

	for _, ply in pairs( player.GetAll() ) do
		fcd.sendVehicles( ply )
	end

	fcd.notifyPlayer( ply, fcd.cfg.adminTranslate[ 'registeredVehicle' ] )
end )

net.Receive( 'fcd.removeVehicle', function( len, ply )
	local class = net.ReadString()
	if not class then return end

	if not fcd.adminAccess( ply ) then return end

	fcd.removeVehicle( class )

	for _, ply in pairs( player.GetAll() ) do
		fcd.sendVehicles( ply )
	end

	fcd.notifyPlayer( ply, fcd.cfg.adminTranslate[ 'removedVehicle' ] )
end )