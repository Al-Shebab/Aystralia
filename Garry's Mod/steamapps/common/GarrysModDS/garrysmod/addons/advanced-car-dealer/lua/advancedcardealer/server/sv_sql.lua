--[[
	CONFIGURE THE SQL IN THE DARKRP SQL CONFIGURATION.
	THE SCRIPT USE THE SAME DATABASE THAN DARKRP.
	THE DATABASE SPECIFIED BELOW WILL BE USED ONLY
	IF THE DARKRP ONE IS NOT LOADED
]]

AdvCarDealer.SQL.Config.EnableMySQL = false -- set to true to use MySQL, false for SQLite. If you use an external database, set this to true

AdvCarDealer.SQL.Config.Host = "" -- This is the IP address of the MySQL host. Make sure the IP address is correct and in quotation marks (" ")
AdvCarDealer.SQL.Config.Username = "" -- Database username to log in on the MySQL server.
AdvCarDealer.SQL.Config.Password = "" -- Database password (keep away from clients!). Warning : everyone who has access to your FTP can read it.
AdvCarDealer.SQL.Config.Database_name = "" -- This is the name of the Database on the MySQL server. Contact the MySQL server host to find out what this is.
AdvCarDealer.SQL.Config.Database_port = 3306 -- This is the port of the MySQL server. Again, contact the MySQL server host if you don't know this. (3306 by default)
AdvCarDealer.SQL.Config.Preferred_module = "mysqloo" -- Preferred module, case sensitive, must be either "mysqloo" or "tmysql4"
AdvCarDealer.SQL.Config.MultiStatements = false -- Only available in tmysql4: allow multiple SQL statements per query.

local CFG = AdvCarDealer.GetConfig

function AdvCarDealer:CheckDatabaseVersion()
	if SERVER and file.Exists( "adv_cardealer/config.txt", "DATA" ) then
		local sConfig = file.Read( "adv_cardealer/config.txt" )
		local config = util.JSONToTable( sConfig )

		if config.DatabaseVersion == AdvCarDealer.DatabaseVersion then
			return
		end

		local Vehicles = {}
		for class, infos in pairs( list.Get("Vehicles") ) do
			if not infos.Model then continue end 
			Vehicles[ string.lower( infos.Model ) ] = class
		end

		local newVehicles = {}
		for sBrand, tList in pairs( config.Vehicles ) do
			for sModel, tInfos in pairs( tList ) do
				if not Vehicles[ string.lower( sModel ) ] then continue end
				tInfos.model = string.lower( sModel )
				newVehicles[ sBrand ] = newVehicles[ sBrand ] or {}
				newVehicles[ sBrand ][ Vehicles[ string.lower( sModel ) ] ] = tInfos
			end
		end

		config.Vehicles = newVehicles

		-- job garage 
		if config.JobGarage then
			for sMap, tNPC in pairs( config.JobGarage or {} ) do 
				for iID, tInfos in pairs( tNPC or {} ) do
					if tInfos.Vehicles and istable( tInfos.Vehicles ) then
						local newVehiclesTable = {}
						
						for iVehicleID, tVehicleData in pairs( tInfos.Vehicles ) do
							if Vehicles[ tVehicleData.vehicle ] then -- if it's a model
								tVehicleData.model = tVehicleData.vehicle -- replace by a class
								tVehicleData.vehicle = Vehicles[ tVehicleData.vehicle ]

								table.insert( newVehiclesTable, tVehicleData )
							end
						end

						tInfos.Vehicles = newVehiclesTable
					end
				end
			end
		end

		config.DatabaseVersion = AdvCarDealer.DatabaseVersion

		local sConfig = util.TableToJSON( config )

		file.CreateDir( "adv_cardealer" )
		file.Write( "adv_cardealer/config.txt", sConfig )

		for _, data in pairs( newVehicles ) do 
			for k, v in pairs( data ) do
				local mdl = v.model
				if not mdl then return end

				local function errorCallback( error )
					print( "[Advanced Car Dealer] Failed to update a model in the database while migrating." )
					print( error )
				end

				local function callback()
					print( "[Advanced Car Dealer] Updated a model in the database while migrating." )
				end

				local query = MySQLite.query( "UPDATE adv_cardealer_vehicles SET vehicle='" .. k .. "' WHERE vehicle ='" .. mdl .. "';", callback, errorCallback )
			end
		end

		local function errorCallback( error )
			print( "[Advanced Car Dealer] Failed to remove all useless models in the database while migrating." )
			print( error )
		end

		local function callback()
			print( "[Advanced Car Dealer] Removed all useless models in the database while migrating." )
			AdvCarDealer:UpdateConfig()
		end

		MySQLite.query( [[DELETE FROM adv_cardealer_vehicles WHERE vehicle LIKE '%.mdl';]],
		callback, errorCallback )
	end
end

function AdvCarDealer:CheckConfigVersion()
	if file.Exists( "adv_cardealer/config.txt", "DATA" ) then
		local sConfig = file.Read( "adv_cardealer/config.txt" )
		local config = util.JSONToTable( sConfig )

		for sBrand, tVehicles in pairs( config.Vehicles or {} ) do
			for sClass, tData in pairs( tVehicles or {} ) do
				tData.isInCatalog = true
				tData.isInCardealerCatalog = true
			end 
		end  

		AdvCarDealer.Config = config

		file.Rename( "adv_cardealer/config.txt", "adv_cardealer/old_config.txt" )

		AdvCarDealer:SaveConfiguration()
	end
end

function AdvCarDealer:InitDatabase()

	print( "[Advanced Car Dealer] Initializing database.")

	if AdvCarDealer.DatabaseInitialized then
		print( "[Advanced Car Dealer] Database already initialized" )
	else
		MySQLite.initialize( AdvCarDealer.SQL.Config )
	end

	timer.Simple( 0, function() 
		local AUTOINCREMENT = MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"

		local function callback()
			print( "[Advanced Car Dealer] Database created.")
			AdvCarDealer:CheckDatabaseVersion()
			AdvCarDealer:CheckConfigVersion()
			hook.Run( "AdvancedCarDealer.OnConnectedToDatabase" )
		end

		local function errorCallback( error )
			print( "[Advanced Car Dealer] Something went wrong during the database creation:" )
			print( error )
		end

		MySQLite.query( [[
			CREATE TABLE IF NOT EXISTS adv_cardealer_vehicles(
				id INTEGER NOT NULL PRIMARY KEY ]] .. AUTOINCREMENT .. [[,
				steamID VARCHAR( 50 ) NOT NULL,
				vehicle VARCHAR( 255 ),
				color VARCHAR( 50 ),
				underglow VARCHAR( 50 ),
				skin INTEGER,
				bodygroup VARCHAR( 255 )
			)
		]], callback, errorCallback )
	end )
end