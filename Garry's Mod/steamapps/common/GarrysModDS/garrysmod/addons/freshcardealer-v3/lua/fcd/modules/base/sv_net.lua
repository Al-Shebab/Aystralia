util.AddNetworkString 'fcd.notifyPlayer'
util.AddNetworkString 'fcd.openMenu'
util.AddNetworkString 'fcd.sendVehicles'
util.AddNetworkString 'fcd.sendOwned'
util.AddNetworkString 'fcd.purchaseVehicle'
util.AddNetworkString 'fcd.quickSpawnVehicle'
util.AddNetworkString 'fcd.sellVehicle'
util.AddNetworkString 'fcd.spawnVehicle'
util.AddNetworkString 'fcd.lightVehicles'
util.AddNetworkString 'fcd.returnVehicle'

net.Receive( 'fcd.purchaseVehicle', function( len, ply )
	local class = net.ReadString()
	if not class then return end
	
	fcd.purchaseVehicle( ply, class )
end )

net.Receive( 'fcd.quickSpawnVehicle', function( len, ply )
	local class = net.ReadString()
	if not class then return end

	local dealerID = net.ReadString()
	if not dealerID then return end
	
	fcd.spawnVehicle( ply, { class = class, dealerID = dealerID } )
end )

net.Receive( 'fcd.sellVehicle', function( len, ply )
	local class = net.ReadString()
	if not class then return end
	
	fcd.sellVehicle( ply, class )
end )

net.Receive( 'fcd.spawnVehicle', function( len, ply )
	local data = net.ReadTable()
	if not data then return end

	fcd.spawnVehicle( ply, data )
end )

net.Receive( 'fcd.returnVehicle', function( len, ply )
	local id = net.ReadString()
	if not id then return end

	fcd.returnVehicle( ply, id )
end )