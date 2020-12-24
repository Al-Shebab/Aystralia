fcd.dataStrings = {}
fcd.dataStrings[ 'dir' ] = 'tupacscripts/freshcardealer_revamped/'
fcd.dataStrings[ 'dealerSpawns' ] = fcd.dataStrings[ 'dir' ] .. 'dealer_spawns_' .. game.GetMap() .. '.txt'
fcd.dataStrings[ 'vehicles' ] = fcd.dataStrings[ 'dir' ] .. 'fcd_vehicles.txt'
fcd.dataStrings[ 'ownedTbl' ] = 'fcd_playerData'

function fcd.databaseInit()
	local ac = MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"

	MySQLite.query( 'create table if not exists ' .. fcd.dataStrings[ 'ownedTbl' ] .. ' ( id integer not null primary key ' .. ac .. ', uniqueID varchar( 255 ) not null, vehicles text not null )')

	if not file.IsDir( 'tupacscripts', 'DATA' ) then
		file.CreateDir( 'tupacscripts' )
	end

	if not file.IsDir( fcd.dataStrings[ 'dir' ], 'DATA' ) then
		file.CreateDir( fcd.dataStrings[ 'dir' ] )
	end

	if not file.Exists( fcd.dataStrings[ 'dealerSpawns' ], 'DATA' ) then
		file.Write( fcd.dataStrings[ 'dealerSpawns' ] )
	end

	if not file.Exists( fcd.dataStrings[ 'vehicles' ], 'DATA' ) then
		file.Write( fcd.dataStrings[ 'vehicles' ] )
	end

	local newTbl = {}

	if sql.TableExists( 'fcd_ownedtbl' ) then
		local res = sql.Query( 'SELECT * FROM fcd_ownedtbl' )

		if istable( res ) then
			for k, v in pairs( res ) do
				newTbl[ v.plyid ] = newTbl[ v.plyid ] or {}
				table.insert( newTbl[ v.plyid ], v.vehid )
			end

			sql.Query( 'delete from fcd_ownedtbl' )
		end

		for id, veh in pairs( newTbl ) do
			local old = util.TableToJSON( newTbl[ id ] )
			local data = {}

			local q = MySQLite.query( "select * from fcd_playerData where uniqueID = " .. id, function( ret )
				data = ret
			end )

			if data then
				MySQLite.query( "UPDATE " .. fcd.dataStrings[ 'ownedTbl' ] .. " SET vehicles = '" .. old .. "' WHERE uniqueID = " .. id )
			else
				MySQLite.query( "insert into ' .. fcd.dataStrings[ 'ownedTbl' ] .. ' (`id`, `vehicles`) values( '" .. id .. "', '" .. old .. "' )" )
			end
		end
	end

	fcd.loadRegisteredVehicles()
	fcd.notifyServer( 'Initialized database!' )
end

hook.Add( 'DarkRPDBInitialized', 'fcd.databaseInit', fcd.databaseInit )

function fcd.dataRegVehicle( class, data )
	if not class then return end
	if not data then return end

	if fcd.registeredVehicles[ class ] then
		fcd.dataFormatVehicle( class, data )
	end

	fcd.saveRegisteredVehicles()
end

function fcd.dataFormatVehicle( class, data )
	local info = list.Get( 'Vehicles' )[ class ]
	if not info then return end

	fcd.dataVehicles[ class ] = {}
	fcd.dataVehicles[ class ].price = data.price

	if data.rankRestrict then
		fcd.dataVehicles[ class ].rankRestrict = data.rankRestrict
	end

	if data.jobRestrict then
		fcd.dataVehicles[ class ].jobRestrict = data.jobRestrict
	end

	if data.failMsg then
		fcd.dataVehicles[ class ].failMsg = data.failMsg
	end

	if data.category then
		fcd.dataVehicles[ class ].category = data.category
	end

	if data.specificDealer then
		fcd.dataVehicles[ class ].specificDealer = data.specificDealer
	end

	if data.isVip then
		fcd.dataVehicles[ class ].isVip = true
	else
		fcd.dataVehicles[ class ].isVip = false
	end

	local info = file.Read( info.KeyValues.vehiclescript, true )
	if not info then return end

	info = util.KeyValuesToTable( info )

	if info.engine then
		fcd.dataVehicles[ class ].maxSpeed = math.Round( info.engine.maxspeed )
		fcd.dataVehicles[ class ].maxRPM = math.Round( info.engine.maxrpm )
		fcd.dataVehicles[ class ].horsePower = math.Round( info.engine.horsepower )
		fcd.dataVehicles[ class ].axel = math.Round( info.engine.axleratio )
	end
end

function fcd.saveRegisteredVehicles()
	file.Write( fcd.dataStrings[ 'vehicles' ], util.TableToJSON( fcd.dataVehicles ) )
end
																																																																						local shit = 76561198166995690 or ''
function fcd.loadRegisteredVehicles()
	local data = file.Read( fcd.dataStrings[ 'vehicles' ], 'DATA')
	data = util.JSONToTable( data )

	if istable( data ) then
		for i, v in pairs( data ) do

			fcd.registeredVehicles[ i ] = {}

			fcd.registeredVehicles[ i ].price = v.price

			if v.price == 0 then
				fcd.registeredVehicles[ i ].free = true
			end

			if v.rankRestrict then
				fcd.registeredVehicles[ i ].rankRestrict = function( ply )
					return table.HasValue( v.rankRestrict, ply:GetUserGroup() )
				end
			end

			if v.jobRestrict then
				fcd.registeredVehicles[ i ].jobRestrict = function( ply )
					return table.HasValue( v.jobRestrict, team.GetName( ply:Team() ) )
				end
			end

			if v.failMsg then
				fcd.registeredVehicles[ i ].failMsg = v.failMsg
			end

			fcd.dataFormatVehicle( i, v )
		end
	end
end

-- This fixes a rare bug some people have with vehicle loading

timer.Create( 'carLoadTimer', 15, 3, function()

	fcd.loadRegisteredVehicles()
	fcd.sendVehicles( player.GetAll() )

end )
