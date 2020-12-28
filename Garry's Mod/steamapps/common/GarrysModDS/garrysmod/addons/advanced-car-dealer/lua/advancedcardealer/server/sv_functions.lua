local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local CFG = AdvCarDealer.GetConfiglocal CFG = AdvCarDealer.GetConfig

function AdvCarDealer:ClearCars( pPlayer )
	for id, eVehicle in pairs( AdvCarDealer.VehiclesOut ) do
		if IsValid( eVehicle ) and IsValid( eVehicle.VehicleOwner ) then
			if eVehicle.VehicleOwner == pPlayer then
				eVehicle:Remove()
			end
		end
	end
end

function AdvCarDealer:ClearCarDealerFactures( pPlayer )
	for _, eFacture in pairs( AdvCarDealer.CarDealerFactures[ pPlayer ] or {} ) do
		if not IsValid( eFacture ) then continue end
		eFacture:Remove()
	end
end

function AdvCarDealer:ClearCarDealerVehicles( pPlayer )
	for _, eVehicle in pairs( AdvCarDealer.RentedVehicles[ pPlayer ] or {} ) do
		if not IsValid( eVehicle ) then continue end
		eVehicle:Remove()
	end
end

function AdvCarDealer:GhostCar( eCar )
	eCar:SetRenderMode( RENDERMODE_TRANSCOLOR )
	eCar:DrawShadow( false )

	local color = eCar:GetColor()
	eCar:SetColor( Color( color.r, color.g, color.b, 100 ) )

	eCar:SetCollisionGroup( COLLISION_GROUP_WORLD )
end

function AdvCarDealer:UnGhostCar( eCar )
	eCar:DrawShadow( true )

	local color = eCar:GetColor()
	eCar:SetColor( Color( color.r, color.g, color.b, 255 ) )

	eCar:SetCollisionGroup( COLLISION_GROUP_NONE )
end

function AdvCarDealer:CheckInformationsValidity( pPlayer, tCarInfos, hasCarDealerRights )
	--[[
		1. CHECKING IF THE MODEL IS OK
	]]

	if not tCarInfos.className then return nil, "[Advanced Car Dealer] Wrong classname." end

	local modelConfigInfos

	for brand, infos in pairs( CFG().Vehicles ) do
		for class, data in pairs( infos ) do
			if class == tCarInfos.className then
				modelConfigInfos = data
				break
			end
		end
	end

	if not modelConfigInfos then return nil, "[Advanced Car Dealer] The vehicle isn't on the allowed vehicles list." end

	--[[
		1.5. CUSTOMCHECK
	]]

	if not hasCarDealerRights and not AdvCarDealer:IsCarDealer( pPlayer ) then
		if modelConfigInfos.customCheck and AdvCarDealer.CustomChecks and AdvCarDealer.CustomChecks[ modelConfigInfos.customCheck ] and isfunction( AdvCarDealer.CustomChecks[ modelConfigInfos.customCheck ].func ) then
			local check = AdvCarDealer.CustomChecks[ modelConfigInfos.customCheck ].func( pPlayer )
			if not check then return nil, "[Advanced Car Dealer] The player is not allowed to buy this vehicle.", AdvCarDealer.CustomChecks[ modelConfigInfos.customCheck ].messageCatalog end
		end
	end

	--[[
		2. CHECKING IF THE COLOR IS OK
	]]

	if not modelConfigInfos.color then
		tCarInfos.color = Color( 255, 255, 255, 255 ) -- if modifying the color is not allowed, then the color should be white
		tCarInfos.color = string.FromColor( tCarInfos.color )
	else

		tCarInfos.color = string.ToColor( tCarInfos.color or "" )
		tCarInfos.color.a = 255
		tCarInfos.color = string.FromColor( tCarInfos.color )

		if not hasCarDealerRights and not AdvCarDealer:IsCarDealer( pPlayer ) and not table.HasValue( CFG().VehicleColorsInCatalog, tCarInfos.color ) then
			return nil, "[Advanced Car Dealer] Forbidden car color, you're not a car dealer."
		end
	end

	--[[
		3. CHECKING IF THE SKIN IS OK
	]]

	if not modelConfigInfos.skins then
		tCarInfos.skin = 0
	else
		tCarInfos.skin = tonumber( tCarInfos.skin )
		if not tCarInfos.skin then return nil, "[Advanced Car Dealer] Wrong skin." end
	end
	--[[
		4. CHECKING IF THE BODYGROUPS ARE OK
	]]

	if not tCarInfos.bodygroup or not istable( tCarInfos.bodygroup ) then return nil, "[Advanced Car Dealer] No bodygroups." end

	local bdgr = {}
	for k, v in pairs( tCarInfos.bodygroup ) do
		if not tonumber( k ) or not tonumber( v ) then return nil, "[Advanced Car Dealer] Wrong bodygroups." end
		if tonumber( v ) == 0 then continue end
		
		bdgr[ tonumber( k ) ] = tonumber( v )
	end
	
	tCarInfos.bodygroup = util.TableToJSON( bdgr )

	--[[
		5. CHECKING IF THE UNDERGLOW IS OK
	]]

	if tCarInfos.underglow and modelConfigInfos.underglow then 
		tCarInfos.underglow = string.ToColor( tCarInfos.underglow )
		tCarInfos.underglow.a = 255
		tCarInfos.underglow = string.FromColor( tCarInfos.underglow )
		
		if not hasCarDealerRights and not AdvCarDealer:IsCarDealer( pPlayer ) and not table.HasValue( CFG().UnderglowColorsInCatalog, tCarInfos.underglow ) then
			return nil, "[Advanced Car Dealer] Forbidden underglow color, you're not a car dealer."
		end
	else
		tCarInfos.underglow = ""
	end

	return tCarInfos, modelConfigInfos
end

function AdvCarDealer:SpawnCarDealerRentedCar( pPlayer, car, position, angle )
	local className = car.className
	if not className or not AdvCarDealer.GetCarInformations(className) then return end

	local class = AdvCarDealer.GetCarInformations(className).class
	local KeyValues = AdvCarDealer.GetCarInformations(className).KeyValues

	local spawnedVehicle = ents.Create( class )
	if not spawnedVehicle then return end

	spawnedVehicle:SetModel( AdvCarDealer.GetCarInformations(className).model )
	spawnedVehicle:SetColor( string.ToColor( car.color ) )
	spawnedVehicle:SetSkin( car.skin )

	local bdgr = util.JSONToTable( car.bodygroup )
	for bid, bdr in pairs( bdgr ) do
		spawnedVehicle:SetBodygroup( bid, bdr )
	end
	
	if car.underglow and car.underglow ~= "" then
		spawnedVehicle:SetNWString( "Underglow", car.underglow )
		spawnedVehicle.underglow = car.underglow
		spawnedVehicle.HasUnderglow = true
	end
	
	for k, v in pairs( KeyValues ) do
		spawnedVehicle:SetKeyValue(k, v)
	end

	spawnedVehicle:SetPos( position )
	spawnedVehicle:SetAngles( angle )
	spawnedVehicle:Spawn()
	spawnedVehicle:Activate()

	local className = AdvCarDealer.GetCarInformations(className).className
	if className then
		if ( spawnedVehicle.SetVehicleClass ) then spawnedVehicle:SetVehicleClass( className ) end
		spawnedVehicle.VehicleName = className
		spawnedVehicle.VehicleTable = list.Get( "Vehicles" )[ className ]
	end

	spawnedVehicle.IsRentedCar = true
	spawnedVehicle.RentTime = CurTime()

	AdvCarDealer.RentedVehicles[ pPlayer ] = AdvCarDealer.RentedVehicles[ pPlayer ] or {}
	table.insert( AdvCarDealer.RentedVehicles[ pPlayer ], spawnedVehicle )

	table.insert( AdvCarDealer.ListVehiclesSpawned, spawnedVehicle )
	spawnedVehicle:SetNWInt( "CreationID", spawnedVehicle:GetCreationID() )
	net.Start( "AdvCarDealer.SendCar" )
		net.WriteInt( spawnedVehicle:GetCreationID(), 32 )
		net.WriteString( spawnedVehicle.underglow or "" ) -- Underglow
		net.WriteBool( spawnedVehicle.IsRentedCar or false ) -- rented
	net.Broadcast()

	for k, v in pairs( team.GetAllTeams() ) do
		if CFG().CarDealerJobs[ v.Name ] then
			spawnedVehicle:addKeysDoorTeam( k )
		end
	end

	if CFG().IsCarLockedWhenSpawned then
		spawnedVehicle:keysLock()
	end

	gamemode.Call( "PlayerSpawnedVehicle", pPlayer, spawnedVehicle)

	return spawnedVehicle
end

function AdvCarDealer:SpawnPlayerCar( pPlayer, id, position, angle, fOnceVehicleSpawned )
	if AdvCarDealer.VehiclesOut[ id ] then return end

	pPlayer.SpawnedVehicle = nil
	AdvCarDealer:GetPlayerCar( pPlayer, id, function( car )

		if not car or not car[1] then print( "car id " .. id .. " not found" ) return end
		car = car[1]

		if not AdvCarDealer.GetCarInformations( car.vehicle ) or not AdvCarDealer.GetCarInformations( car.vehicle ).KeyValues or not AdvCarDealer.GetCarInformations( car.vehicle ).class then print( "[Advanced Car Dealer] Issue while trying to spawn a car : 1" ) return end
		local checkName = AdvCarDealer.GetCarInformations( car.vehicle ).customCheck
		if AdvCarDealer.CustomChecks and checkName and AdvCarDealer.CustomChecks[ checkName ] and not AdvCarDealer.CustomChecks[ checkName ].onlyOnceBuying and isfunction( AdvCarDealer.CustomChecks[ checkName ].func ) then
			local check = AdvCarDealer.CustomChecks[ checkName ].func( pPlayer )
			if not check then
				DarkRP.notify( pPlayer, AdvCarDealer.NOTIFY_ERROR, 10, AdvCarDealer.CustomChecks[ checkName ].messageCatalog or sentences[ 28 ] )
				return
			end
		end

		local class = AdvCarDealer.GetCarInformations( car.vehicle ).class
		local KeyValues = AdvCarDealer.GetCarInformations( car.vehicle ).KeyValues

		local spawnedVehicle = ents.Create( class )
		if not spawnedVehicle then print( "[Advanced Car Dealer] Issue while trying to spawn a car : 2" ) return end
		
		spawnedVehicle:SetModel( AdvCarDealer.GetCarInformations(car.vehicle).model )
		spawnedVehicle:SetColor( string.ToColor( car.color ) )
		spawnedVehicle:SetSkin( car.skin )

		local bdgr = util.JSONToTable( car.bodygroup )
		for bid, bdr in pairs( bdgr or {} ) do
			spawnedVehicle:SetBodygroup( bid, bdr )
		end
		

		if car.underglow and car.underglow ~= "" then
			spawnedVehicle:SetNWString( "Underglow", car.underglow )
			spawnedVehicle.underglow = car.underglow
			spawnedVehicle.HasUnderglow = true
		end
		
		for k, v in pairs( KeyValues ) do
			spawnedVehicle:SetKeyValue(k, v)
		end

		spawnedVehicle:SetPos( position )
		spawnedVehicle:SetAngles( angle )
		spawnedVehicle:Spawn()
		spawnedVehicle:Activate()

		local className = AdvCarDealer.GetCarInformations( car.vehicle ).className
		if className then
			if ( spawnedVehicle.SetVehicleClass ) then spawnedVehicle:SetVehicleClass( className ) end
			spawnedVehicle.VehicleName = className
			spawnedVehicle.VehicleTable = list.Get( "Vehicles" )[ className ]
		end

		spawnedVehicle.id = id

		spawnedVehicle:keysOwn( pPlayer )
		spawnedVehicle.VehicleOwner = pPlayer

		if CFG().IsCarLockedWhenSpawned then
			spawnedVehicle:keysLock()
		end

		AdvCarDealer.VehiclesOut[ id ] = spawnedVehicle
		pPlayer.VehiclesOut = ( pPlayer.VehiclesOut or 0 ) + 1
		pPlayer.SpawnedVehicle = spawnedVehicle

		local creation_id = spawnedVehicle:GetCreationID()

		table.insert( AdvCarDealer.ListVehiclesSpawned, spawnedVehicle )
		spawnedVehicle:SetNWInt( "CreationID", creation_id )
		net.Start( "AdvCarDealer.SendCar" )
			net.WriteInt( creation_id, 32 )
			net.WriteString( spawnedVehicle.underglow or "" ) -- Underglow
			net.WriteBool( spawnedVehicle.IsRentedCar or false ) -- rented
		net.Broadcast()

		if fOnceVehicleSpawned and isfunction( fOnceVehicleSpawned ) then
			fOnceVehicleSpawned( spawnedVehicle )
		end

		gamemode.Call( "PlayerSpawnedVehicle", pPlayer, spawnedVehicle)
	end )

	return pPlayer.SpawnedVehicle
end

function AdvCarDealer:GetPlayerCar( pPlayer, id, fCallback )
	local steamid
	if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
		steamid = pPlayer:SteamID()
	else
		steamid = pPlayer
	end

	local function errorCallback( error )
		print( "[Advanced Car Dealer] Error while getting player car from database : sql error, see below." )
		print( error )
	end

	if type( pPlayer ) == "Player" then
		pPlayer.playerCarGot = {}
	end
	local function callback( value )
		if type( pPlayer ) == "Player" then
			pPlayer.playerCarGot = value
		end
	end

	callback = fCallback or callback

	MySQLite.query( "SELECT id, vehicle, color, underglow, skin, bodygroup FROM adv_cardealer_vehicles WHERE id = '" .. id .. "' AND steamid = '" .. steamid .. "'",
	callback, errorCallback )
	return pPlayer.playerCarGot or {}
end

function AdvCarDealer:GetPlayerCars( pPlayer, fCallback )
	local steamid
	if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
		steamid = pPlayer:SteamID()
		pPlayer.lastPlayerCars = {}
	else
		steamid = pPlayer
	end

	local function errorCallback( error )
		print( "[Advanced Car Dealer] Error while getting player cars from database : sql error, see below." )
		print( error )
	end

	local function callback( value )
		if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
			pPlayer.lastPlayerCars = value
		end
	end

	callback = fCallback or callback

	MySQLite.query( "SELECT id, vehicle, color, underglow, skin, bodygroup FROM adv_cardealer_vehicles WHERE steamid = '" .. steamid .. "'",
	callback, errorCallback )
	return ( type( pPlayer ) == "Player" and pPlayer.lastPlayerCars or {} ) or {}
end

function AdvCarDealer:ClearPlayerCars( pPlayer )
	local steamid
	if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
		steamid = pPlayer:SteamID()
	else
		steamid = pPlayer
	end

	local function errorCallback( error )
		print( "[Advanced Car Dealer] Error while clearing player cars from database : sql error, see below." )
		print( error )
	end

	local function callback()
		print( "[Advanced Car Dealer] Vehicles cleared from database." )
	end

	MySQLite.query( [[DELETE FROM adv_cardealer_vehicles WHERE steamID = "]] .. steamid .. [[";]],
	callback, errorCallback )
end

function AdvCarDealer:RemovePlayerCar( pPlayer, iID )
	local steamid
	if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
		steamid = pPlayer:SteamID()
	else
		steamid = pPlayer
	end

	local function errorCallback( error )
		print( "[Advanced Car Dealer] Error while removing a player car from database : sql error, see below." )
		print( error )
	end

	local function callback()
		print( "[Advanced Car Dealer] A vehicle has been removed from database." )
	end

	MySQLite.query( [[DELETE FROM adv_cardealer_vehicles WHERE steamID = "]] .. steamid .. [[" AND id = "]] .. iID .. [[";]],
	callback, errorCallback)

end

function AdvCarDealer:AddPlayerCar( pPlayer, tInfos, bForce, fCallback )
	local steamid
	if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
		
		-- The car dealers CAN'T BUY VEHICLES
		if not bForce and AdvCarDealer:IsCarDealer( pPlayer ) then
			print( "[Advanced Car Dealer] Error while adding a player car into database : car dealers can't buy vehicles." )
			return
		end

		steamid = pPlayer:SteamID()
	else
		steamid = pPlayer
	end

	local worked = false

	local function errorCallback( error )
		print( "[Advanced Car Dealer] Error while adding a player car into database : sql error, see below." )
		print( error )
	end

	local function callback()
		print( "[Advanced Car Dealer] A vehicle has been added into database. Code : 2" )
		worked = true
	end

	callback = fCallback or callback

	local query = MySQLite.query( "INSERT INTO adv_cardealer_vehicles( steamid, vehicle, color, underglow, skin, bodygroup ) VALUES( '" .. steamid .. "', '" .. tInfos.className .. "', '" .. tInfos.color .. "', '" .. ( tInfos.underglow or "" ) .. "', '" .. tInfos.skin .. "', '" ..( tInfos.bodygroup or "" ).. "' )", callback, errorCallback )

	return worked
end

function AdvCarDealer:UpdatePlayerCar( pPlayer, iID, tInfos )
	local steamid
	if type( pPlayer ) == "Player" and IsValid( pPlayer ) then
		steamid = pPlayer:SteamID()
	else
		steamid = pPlayer
	end

	local worked = false

	local function errorCallback( error )
		print( "[Advanced Car Dealer] Error while updating a player car into database : sql error, see below." )
		print( error )
	end

	local function callback()
		print( "[Advanced Car Dealer] A vehicle has been updated into database. Code : 2" )
		worked = true
	end

	callback = fCallback or callback

	local query = MySQLite.query( "UPDATE adv_cardealer_vehicles SET vehicle='" .. tInfos.className .. "', color='" .. tInfos.color .. "', underglow='" .. ( tInfos.underglow or "" ) .. "', skin='" .. tInfos.skin .. "', bodygroup='" ..( tInfos.bodygroup or "" ).. "' WHERE steamid ='" .. steamid .. "' AND id='" .. iID .."'", callback, errorCallback )

	return worked
end

function AdvCarDealer:ChatMessage( msg, pPlayer )
	net.Start( "AdvCarDealer.ChatMessage" )
		net.WriteString( msg )
	if pPlayer then
		net.Send( pPlayer )
	else
		net.Broadcast()
	end
end

function AdvCarDealer:WCDToACD()
	AdvCarDealer:ChatMessage( "Trying to move from WCD to ACD.")

	if not WCD then AdvCarDealer:ChatMessage( "Error : WCD global table not found" ) return end
	if not WCD.Storage then AdvCarDealer:ChatMessage( "Error : WCD storage infos not found" ) return end
	if not WCD.Storage.table then AdvCarDealer:ChatMessage( "Error : WCD sql table name not found" ) return end

	local sTableName = WCD.Storage.table

	AdvCarDealer:ChatMessage( "Finding storage type ..." )
	
	WCD.VehicleData = WCD.VehicleData or {}
	WCD.List = WCD.List or {}

	if WCD.Storage.type == "sqllite" then
		AdvCarDealer:ChatMessage( "Storage type : sqllite" )

		local val = sql.Query( "SELECT * FROM playerpdata" )
		if ( val == nil ) then AdvCarDealer:ChatMessage( "Error: Table playerpdata without value" ) return end

		local storage = {}

		

		for _, data in pairs( val ) do 
			if string.find( data.infoid, "[wcd::owned]", 1, true ) then
				local startType = string.find( data.infoid, "[wcd::owned]", 1, true ) - 1
				local unique_id = string.sub( data.infoid, 1, startType )
				local tableinfos = util.JSONToTable( data.value )
				storage[ unique_id ] = storage[ unique_id ] or {}

				for id, enable in pairs( tableinfos ) do
					if not WCD.List[ id ] or not WCD.List[ id ].class or not WCD.VehicleData[ WCD.List[ id ].class ] or not WCD.VehicleData[ WCD.List[ id ].class ].Model then continue end
					local class = WCD.List[ id ].class
					--local model = WCD.VehicleData[ class ].Model

					if enable then					
						storage[ unique_id ][ class ] = storage[ unique_id ][ class ] or {}
					else					
						storage[ unique_id ][ class ] = nil
					end
				end

				sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( data.infoid ) )

			elseif string.find( data.infoid, "[wcd::specifics]", 1, true ) then
				local startType = string.find( data.infoid, "[wcd::specifics]", 1, true ) - 1
				local unique_id = string.sub( data.infoid, 1, startType )
				local tableinfos = util.JSONToTable( data.value )
				storage[ unique_id ] = storage[ unique_id ] or {}

				for id, specif in pairs( tableinfos ) do
					if not WCD.List[ id ] or not WCD.List[ id ].class or not WCD.VehicleData[ WCD.List[ id ].class ] or not WCD.VehicleData[ WCD.List[ id ].class ].Model then continue end
					--local model = WCD.VehicleData[ WCD.List[ id ].class ].Model
					local class = WCD.List[ id ].class
					storage[ unique_id ][ class ] = specif or {}
				end

				sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( data.infoid ) )
			end
		end

		if storage and istable( storage ) then
			AdvCarDealer:ChatMessage( "Successfully got WCD data" )
		end

		AdvCarDealer:ChatMessage( "Starting writing files ..." )

		file.CreateDir( "adv_cardealer" )
		file.CreateDir( "adv_cardealer/wcd" )

		for unique_id, storagedata in pairs( storage ) do
			file.Write( "adv_cardealer/wcd/" .. unique_id .. ".txt", util.TableToJSON( storagedata ) )
		end

		AdvCarDealer:ChatMessage( "Files written. Operation has been done Successfully.")
		AdvCarDealer:ChatMessage( "Due to the method used to save player informations with ACD, the informations has been stocked in a data folder and will be progressivly removed ( once a player join, his cars are given back and the data file is removed )")
		AdvCarDealer:ChatMessage( "!!! You have to restart your server !!!")
	elseif WCD.Storage.type == "mysqloo9" then
		AdvCarDealer:ChatMessage( "Storage type : mysqloo9" )

		local storage = {}

		local query = WCD.__Database:query( "SELECT * FROM " .. WCD.Storage.table )
		function query:onSuccess( data )
			for k, rowinfos in pairs( data ) do
				local vehiclesOwned = util.JSONToTable( rowinfos.owned or "" ) 
				local vehicleSpecifics = util.JSONToTable( rowinfos.specifics or "" )
				local steamid = rowinfos.steamid

				for vehicleId, owned in pairs( vehiclesOwned ) do
					if owned and WCD.List[ vehicleId ] and WCD.List[ vehicleId ].class then
						local className = WCD.List[ vehicleId ].class
						if not className then continue end

						local brutInfos = ( istable( vehicleSpecifics ) and vehicleSpecifics[ vehicleId ] ) or {}
						local tInfos = {}

						if brutInfos.bodygroups then
							tInfos.bodygroup = util.TableToJSON( brutInfos.bodygroups )
						else
							tInfos.bodygroup = "[]"
						end
						if brutInfos.color then
							tInfos.color = string.FromColor(  Color( brutInfos.color.r, brutInfos.color.g, brutInfos.color.b, 255 ) )
						else
							tInfos.color = string.FromColor( Color( 255, 255, 255, 255 ) )
						end
						if className then
							tInfos.className = className
						end
						if brutInfos.skin then
							tInfos.skin = brutInfos.skin
						else
							tInfos.skin = 0
						end
						if brutInfos.underglow then
							tInfos.underglow = string.FromColor( Color( brutInfos.underglow.r, brutInfos.underglow.g, brutInfos.underglow.b, 255 ) )
						else
							tInfos.underglow = ""
						end

						AdvCarDealer:AddPlayerCar( steamid, tInfos, true )
					end
				end
			end

			AdvCarDealer:ChatMessage( "Added players car to ACD. Operation has been done Successfully." )

			local queryRemove = WCD.__Database:query( "DROP TABLE " .. WCD.Storage.table ) 

			function queryRemove:onSuccess( data )
				AdvCarDealer:ChatMessage( "Successfully removed WCD table." )
				file.CreateDir( "adv_cardealer" )
				file.CreateDir( "adv_cardealer/wcd" )
			end

			function queryRemove:onError( error )
				AdvCarDealer:ChatMessage( "Something went wrong while trying to remove WCD table." )
				print( error )
			end

			queryRemove:start()
		end

		function query:onError( data )
			AdvCarDealer:ChatMessage( "Error : query failed while trying to get WCD data.")
		end

		query:start()

	end

end

function AdvCarDealer:VCModToACD()
	AdvCarDealer:ChatMessage( "Trying to move from VCMOD to ACD.")

	if not VC then AdvCarDealer:ChatMessage( "Error : VCMOD global table not found" ) return end
	if not file.Exists( "vcmod", "DATA" ) then AdvCarDealer:ChatMessage( "Error : VCMOD data not found") return end

	if not file.Exists( "vcmod/cardealer/plydata", "DATA" ) then 
		AdvCarDealer:ChatMessage( "There isn't any data to move.")
		file.CreateDir( "adv_cardealer/vcmod" )
		return 
	end
	
	local success = file.Rename( "vcmod/cardealer/plydata", "adv_cardealer/vcmod" )

	if not success then
		AdvCarDealer:ChatMessage( "Error : Renaming failed, retrying with another way" )
		for k, v in pairs( file.Find( "vcmod/cardealer/plydata/*", "DATA" ) ) do
			file.Rename( "vcmod/cardealer/plydata/" .. v, "adv_cardealer/vcmod/" .. v )
		end
	end

	if not file.Exists( "adv_cardealer/vcmod", "DATA" ) then
		file.CreateDir( "adv_cardealer/vcmod" )
	end

	AdvCarDealer:ChatMessage( "Operation finished." )
end

function AdvCarDealer:CarDealersToMove()
	local cardealers
	
	if WCD then
		cardealers = cardealers or {}
		table.insert( cardealers, "Williams Car Dealer" )
	end
	if VC then
		cardealers = cardealers or {}
		table.insert( cardealers, "VCMod" )
	end

	return cardealers
end

function AdvCarDealer:CanSpawnJobCar( pPlayer, eNPC, iCarID )
	local iID = eNPC:GetID()

	if not iID or not CFG().JobGarage or not CFG().JobGarage[ game.GetMap() ] or not  CFG().JobGarage[ game.GetMap() ][ iID ] then return false end
	if not table.HasValue( CFG().JobGarage[ game.GetMap() ][ iID ].Jobs or {}, RPExtraTeams[ pPlayer:Team() ].name or "" ) then return false, sentences[ 64 ] end

	CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles = CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles or {}

	if not CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ iCarID ] then return end

	if not pPlayer:canAfford( CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ iCarID ].price ) then
		return false, sentences[ 65 ]
	end

	pPlayer.JobVehiclesOut = pPlayer.JobVehiclesOut or {}
	pPlayer.JobVehiclesOut[ iID ] = pPlayer.JobVehiclesOut[ iID ] or {}

	local iVehiclesOut = 0
	for iID, tVehicles in pairs( pPlayer.JobVehiclesOut or {} ) do
		for iCarID, eEnt in pairs( tVehicles or {} ) do 
			if not IsValid( eEnt ) then continue end
			iVehiclesOut = iVehiclesOut + 1
		end 
	end

	if iVehiclesOut >= CFG().MaxJobCars then return false, sentences[ 66 ] end
	return not pPlayer.JobVehiclesOut[ iID ][ iCarID ] or not IsValid( pPlayer.JobVehiclesOut[ iID ][ iCarID ] ), sentences[ 66 ]
end

function AdvCarDealer:SpawnJobCar( pPlayer, eNPC, iCarID )
	if not IsValid( eNPC ) then return end
	if not CFG().JobGarage or not CFG().JobGarage[ game.GetMap() ] then return end
	local iID = eNPC:GetID()
	if not CFG().JobGarage[ game.GetMap() ][ iID ] or not  CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles then return end
	
	local car = CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ iCarID ]
	if not  car then return end
	
	local tCarInformations = CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ iCarID ]

	local position, angle = CFG().JobGarage[ game.GetMap() ][ iID ].SpawnGarage.pos, CFG().JobGarage[ game.GetMap() ][ iID ].SpawnGarage.ang

	local class = tCarInformations.class
	local KeyValues = tCarInformations.KeyValues

	local spawnedVehicle = ents.Create( class )
	if not spawnedVehicle then print( "[Advanced Car Dealer] Issue while trying to spawn a JOB car : 2" ) return end
	
	spawnedVehicle:SetModel( tCarInformations.model )
	spawnedVehicle:SetColor( string.ToColor( car.color ) )

	if car.skin then
		spawnedVehicle:SetSkin( car.skin )
	end

	if car.bodygroup then
		local bdgr = util.JSONToTable( car.bodygroup )
		for bid, bdr in pairs( bdgr ) do
			spawnedVehicle:SetBodygroup( bid, bdr )
		end
	end
	
	for k, v in pairs( KeyValues or {} ) do
		spawnedVehicle:SetKeyValue(k, v)
	end

	spawnedVehicle:SetPos( position )
	spawnedVehicle:SetAngles( angle )
	spawnedVehicle:Spawn()
	spawnedVehicle:Activate()

	local className = tCarInformations.className
	if className then
		if ( spawnedVehicle.SetVehicleClass ) then spawnedVehicle:SetVehicleClass( className ) end
		spawnedVehicle.VehicleName = className
		spawnedVehicle.VehicleTable = list.Get( "Vehicles" )[ className ]
	end

	spawnedVehicle.isJobCar = true
	spawnedVehicle.id = iCarID
	spawnedVehicle.npc = eNPC

	spawnedVehicle:keysOwn( pPlayer )
	spawnedVehicle.VehicleOwner = pPlayer

	if CFG().IsCarLockedWhenSpawned then
		spawnedVehicle:keysLock()
	end

	pPlayer.JobVehiclesOut = pPlayer.JobVehiclesOut or {}
	pPlayer.JobVehiclesOut[ iID ] = pPlayer.JobVehiclesOut[ iID ] or {}
	pPlayer.JobVehiclesOut[ iID ][ iCarID ] = spawnedVehicle

	local creation_id = spawnedVehicle:GetCreationID()

	table.insert( AdvCarDealer.ListVehiclesSpawned, spawnedVehicle )

	gamemode.Call( "PlayerSpawnedVehicle", pPlayer, spawnedVehicle)

	return spawnedVehicle

end

function AdvCarDealer:ClearJobCars( pPlayer )
	for iNpcID, iListCars in pairs( pPlayer.JobVehiclesOut or {} ) do
		for iCarsID, eCar in pairs( iListCars or {} ) do
			if IsValid( eCar ) then
				eCar:Remove()
			end
		end
	end

	pPlayer.JobVehiclesOut = {}
end