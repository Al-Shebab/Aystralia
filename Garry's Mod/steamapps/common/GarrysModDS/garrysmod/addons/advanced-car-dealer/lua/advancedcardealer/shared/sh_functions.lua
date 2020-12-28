local CFG = AdvCarDealer.GetConfig

function AdvCarDealer:IsCarDealer( pPlayer )
	return CFG().CarDealerJobs[ RPExtraTeams and RPExtraTeams[ pPlayer:Team() or 0 ] and RPExtraTeams[ pPlayer:Team() or 0 ].name or 0 ]
end

function AdvCarDealer:PlayersInCarDealerJob()
	local cardealers
	for k, v in pairs( player.GetAll() ) do
		if AdvCarDealer:IsCarDealer( v ) then
			cardealers = true
			break
		end
	end

	return cardealers
end

function AdvCarDealer.LoadCarInformations()
	print( "[ Advanced Car Dealer ] Loading car informations" )
	

	--[[
		Regular cars
	]]
	local tServerVehicles = list.Get( "Vehicles" )
	AdvCarDealer.ListVehiclesModel = AdvCarDealer.ListVehiclesModel or {}
	AdvCarDealer.ListVehiclesClassname = AdvCarDealer.ListVehiclesClassname or {}

	for sBrand, tInfos in pairs( CFG().Vehicles or {} ) do
		for sClassname, tConfigData in pairs( tInfos or {} ) do
			tConfigData.brand = sBrand
			tConfigData.className = sClassname

			-- Find the table of the config with this is easier.
			-- By this way, no need to loop
			if tConfigData.model then
				AdvCarDealer.ListVehiclesModel[ string.lower( tConfigData.model ) ] = {
					brand = sBrand,
					classname = sClassname
				}
			end
			AdvCarDealer.ListVehiclesClassname[ string.lower( sClassname ) ] = {
				brand = sBrand,
				-- Put the classname here again, so it's not case sensitive
				classname = sClassname
			}

			if tServerVehicles[ sClassname ] then
				if tServerVehicles[ sClassname ].KeyValues and tServerVehicles[ sClassname ].KeyValues.vehiclescript then
					tConfigData.KeyValues = tServerVehicles[ sClassname ].KeyValues
					tConfigData.class = tServerVehicles[ sClassname ].Class

					local fileContent = file.Read( tServerVehicles[ sClassname ].KeyValues.vehiclescript, "GAME" )
					if not fileContent then continue end

					fileContentTable = util.KeyValuesToTable( fileContent )
					if not fileContentTable then continue end

					if fileContentTable.engine then
						tConfigData.horsepower = fileContentTable.engine.horsepower or 0
						tConfigData.maxrpm = fileContentTable.engine.maxrpm or 0 
						tConfigData.maxspeed = fileContentTable.engine.maxspeed or 0
					end
				end
			end
		end
	end

	--[[
		Job cars
	]]
	for iID, tData in pairs( ( CFG().JobGarage and CFG().JobGarage[ game.GetMap() ] ) or {} ) do
		for _, tInfos in pairs( tData.Vehicles or {} ) do 
			if not tInfos.vehicle then tData.Vehicles[ _ ] = nil continue end
			if not tServerVehicles[ tInfos.vehicle ] then tData.Vehicles[ _ ] = nil continue end
			
			local class = tServerVehicles[ tInfos.vehicle ].Class
			local className = tInfos.vehicle
			local KeyValues = tServerVehicles[ tInfos.vehicle ].KeyValues

			if not class or not className or not KeyValues then tData.Vehicles[ _ ] = nil continue end

			tInfos.class = class
			tInfos.className = className
			tInfos.KeyValues = KeyValues
		end
	end 
end

function AdvCarDealer.GetCarInformations( sCar )
	-- sCar can be a Classname or a Model.
	if not sCar then return end

	if AdvCarDealer.ListVehiclesModel[ string.lower( sCar ) ] then

		local brand = AdvCarDealer.ListVehiclesModel[ string.lower( sCar ) ].brand
		local classname = AdvCarDealer.ListVehiclesModel[ string.lower( sCar ) ].classname
		if not brand or not classname or not CFG().Vehicles[ brand ] or not CFG().Vehicles[ brand ][ classname ] then
			return
		end

		return CFG().Vehicles[ brand ][ classname ]

	elseif AdvCarDealer.ListVehiclesClassname[ string.lower( sCar ) ] then

		local brand = AdvCarDealer.ListVehiclesClassname[ string.lower( sCar ) ].brand
		local classname = AdvCarDealer.ListVehiclesClassname[ string.lower( sCar ) ].classname

		if not brand or not classname or not CFG().Vehicles[ brand ] or not CFG().Vehicles[ brand ][ classname ] then
			return
		end

		return CFG().Vehicles[ brand ][ classname ]
		
	end
end