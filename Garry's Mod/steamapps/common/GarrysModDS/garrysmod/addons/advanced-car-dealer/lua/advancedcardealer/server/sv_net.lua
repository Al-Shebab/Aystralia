local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local CFG = AdvCarDealer.GetConfiglocal CFG = AdvCarDealer.GetConfig

util.AddNetworkString( "AdvCarDealer.OpenTablet" )
util.AddNetworkString( "AdvCarDealer.OpenStandMenu" )
util.AddNetworkString( "AdvCarDealer.BuyCarInTablet" )
util.AddNetworkString( "AdvCarDealer.BuyCar" )
util.AddNetworkString( "AdvCarDealer.OpenGarage" )
util.AddNetworkString( "AdvCarDealer.TakeOutVehicle" )
util.AddNetworkString( "AdvCarDealer.OpenFacture" )
util.AddNetworkString( "AdvCarDealer.ConfirmFacture" )
util.AddNetworkString( "AdvCarDealer.SendCar" )
util.AddNetworkString( "AdvCarDealer.SelectCarStand" )
util.AddNetworkString( "AdvCarDealer.SelectCarStandToClient" )
util.AddNetworkString( "AdvCarDealer.SendConfig" )
util.AddNetworkString( "AdvCarDealer.ResellVehicle" )
util.AddNetworkString( "AdvCarDealer.OpenSwitchMenu" )
util.AddNetworkString( "AdvCarDealer.MoveToAcd" )
util.AddNetworkString( "AdvCarDealer.ChatMessage" )
util.AddNetworkString( "AdvCarDealer.ReceivePlayerInformations" )
util.AddNetworkString( "AdvCarDealer.AskPlayerInformations" )
util.AddNetworkString( "AdvCarDealer.AdminRemoveVehicle" )

net.Receive( "AdvCarDealer.AdminRemoveVehicle", function( len, ply )
	if not CFG().AdminUserGroups[ ply:GetUserGroup() ] then return end

	local SteamID = net.ReadString()
	local VehicleID = net.ReadInt( 32 )

	AdvCarDealer:RemovePlayerCar( SteamID, VehicleID )
end )

net.Receive( "AdvCarDealer.AskPlayerInformations", function( len, ply ) 
	if not CFG().AdminUserGroups[ ply:GetUserGroup() ] then return end

	local SteamID = net.ReadString()
	local SteamID2 = util.SteamIDFrom64( SteamID )

	if SteamID2 ~= "STEAM_0:0:0" then
		SteamID = SteamID2
	end

	AdvCarDealer:GetPlayerCars( SteamID, function( tResults )
		tResults = tResults or {}
		if not istable( tResults ) or not IsValid( ply ) then return end

		net.Start( "AdvCarDealer.ReceivePlayerInformations" )
			net.WriteTable( tResults )
			net.WriteString( SteamID )
		net.Send( ply )
	end )
end )

net.Receive( "AdvCarDealer.MoveToAcd", function( len, ply )
	if not CFG().AdminUserGroups[ ply:GetUserGroup() ] then return end

	local cardealer = net.ReadString()

	if cardealer == "Williams Car Dealer" then
		AdvCarDealer:WCDToACD()
	elseif cardealer == "VCMod" then
		AdvCarDealer:VCModToACD()
	end

	if ( net.ReadBool() or false ) then return end

	local cardealers = AdvCarDealer:CarDealersToMove()

	if cardealers then
		net.Start( "AdvCarDealer.OpenSwitchMenu" )
			net.WriteTable( cardealers )
		net.Send( ply )		
	end
end )

net.Receive( "AdvCarDealer.ResellVehicle", function( len, ply )
	if not ply:Alive() then return end

	local eGarage = net.ReadEntity()
	if not IsValid( eGarage ) then return end
	if eGarage:GetClass() ~= "cardealer_garage" then return end
	if eGarage:GetPos():DistToSqr( eGarage:GetPos() ) > 62500 then return end

	local iID = net.ReadInt( 32 )

	AdvCarDealer:GetPlayerCar( ply, iID, function( carInfos )
		if not carInfos or not carInfos[ 1 ] then print( "[Advanced Car Dealer] Someone is trying to sold an inexistant vehicle" ) return end
		carInfos = carInfos[1]

		if not carInfos.vehicle or not AdvCarDealer.GetCarInformations( carInfos.vehicle ) then return end

		-- DLC1 : The car can not be sold
		if carInfos.nextspawn then
			local nextspawn = tonumber( carInfos.nextspawn )

			if nextspawn > os.time() then print( "[Advanced Car Dealer] The car can not be sold currently. Code : 1" ) return end
		end

		local priceCatalog = AdvCarDealer.GetCarInformations( carInfos.vehicle ).priceCatalog
		local percentage = ( CFG().PercentageWhenResell or 0 ) / 100

		percentage = math.Clamp( percentage, 0, 1 )

		local money = priceCatalog * percentage
		AdvCarDealer:RemovePlayerCar( ply, iID )
		DarkRP.notify( ply, AdvCarDealer.NOTIFY_HINT, 10, string.format( sentences[ 59 ], ( AdvCarDealer.GetCarInformations( carInfos.vehicle ).name or "Vehicle" ), DarkRP.formatMoney( money ) ) )
		ply:addMoney( money )
	end )
end )

net.Receive( "AdvCarDealer.SelectCarStand", function( len, ply )
	if not ply:Alive() then return end
	if not AdvCarDealer:IsCarDealer( ply ) then return end

	local eStand = net.ReadEntity()
	if not IsValid( eStand ) then return end
	if eStand:GetClass() ~= "cardealer_stand" then return end
	if eStand:GetPos():DistToSqr( ply:GetPos() ) > 62500 then return end

	local eVehicle = net.ReadEntity()

	if IsValid( eVehicle ) then
		local tVehicle = {}

		tVehicle.className = eVehicle:GetVehicleClass()
		tVehicle.model = eVehicle:GetModel()
		tVehicle.color = string.FromColor( eVehicle:GetColor() )
		tVehicle.skin = eVehicle:GetSkin()

		local bdgr = ""

		for k, v in pairs( eVehicle:GetBodyGroups() ) do
			bdgr = bdgr .. v.id .. eVehicle:GetBodygroup( v.id )
		end

		tVehicle.bodygroup = bdgr

		net.Start( "AdvCarDealer.SelectCarStandToClient" )
			net.WriteInt( eStand:EntIndex(), 32 )
			net.WriteTable( tVehicle )
		net.Broadcast()

		eStand.Vehicle = eVehicle
		eVehicle.Stands = eVehicle.Stands or {}
		eVehicle.Stands[ eStand ] = true
		eStand.VehicleInfos = tVehicle
	else
		net.Start( "AdvCarDealer.SelectCarStandToClient" )
			net.WriteInt( eStand:EntIndex(), 32 )
		net.Broadcast()
		
		if eStand.Vehicle and IsValid( eStand.Vehicle ) and eVehicle.Stands and istable( eVehicle.Stands ) then
			eVehicle.Stands[ eStand ] = nil
		end
		eStand.Vehicle = NULL
		eStand.VehicleInfos = {}
	end
end )

net.Receive( "AdvCarDealer.ConfirmFacture", function( len, ply )
	if not ply:Alive() then return end
	if not AdvCarDealer:IsCarDealer( ply ) then return end

	local eFacture = net.ReadEntity()
	if not IsValid( eFacture ) then return end
	if eFacture:GetClass() ~= "cardealer_facture" then return end
	if eFacture:GetCarDealer() ~= ply then return end
	if eFacture:GetPos():DistToSqr( ply:GetPos() ) > 62500 then return end

	local typeInfo = net.ReadInt( 32 )
	if typeInfo == 2 then
		timer.Simple( 1, function()
			eFacture:Remove()
		end )
		return
	end

	local eVehicle = net.ReadEntity()
	if not IsValid( eVehicle ) then return end
	if not eVehicle.IsRentedCar then return end

	local percentage = net.ReadFloat()
	if percentage < 0 or percentage > 1 then return end

	eFacture:SetVehicle( eVehicle )
	eFacture:SetPercentage( percentage )

end )

local noCollideEntities = {
	"keyframe_rope",
	"physgun_beam",
	"info_player_start",
	"predicted_viewmodel",
	"cardealer_garage_trigger"
}

local notSolid = {
	[ SOLID_NONE ] = true
}

local function spawnPlayerCar( ply, car )
	if not car or not IsValid( car ) then return end

	local max = LocalToWorld( car:OBBMaxs(), car:GetAngles(), car:GetPos(), car:GetAngles() )
	local min = LocalToWorld( car:OBBMins(), car:GetAngles(), car:GetPos(), car:GetAngles() )

	if AdvCarDealer.InternalGhosting then
		local tEnts = ents.FindInBox( min, max )
		for k, v in pairs( tEnts ) do
			if v ~= car and v:GetClass() ~= "physgun_beam" then
				AdvCarDealer:GhostCar( car )

				local entindex = car:EntIndex()
				timer.Create( "CarCheckGhosting" .. entindex, 3, 0, function()
					if not IsValid( car ) then timer.Remove( "CarCheckGhosting" .. entindex ) return end

					local max = LocalToWorld( car:OBBMaxs(), car:GetAngles(), car:GetPos(), car:GetAngles() )
					local min = LocalToWorld( car:OBBMins(), car:GetAngles(), car:GetPos(), car:GetAngles() )

					local tEnts = ents.FindInBox( min, max )
					for k, v in pairs( tEnts ) do
						if notSolid[ v:GetSolid() ] or not IsValid( v:GetPhysicsObject() ) then
							continue
						end
						if v:GetParent() ~= car and v ~= car and not table.HasValue( noCollideEntities, v:GetClass() ) and not ( v:IsPlayer() and IsValid( v:GetVehicle() ) and ( v:GetVehicle() == car or v:GetVehicle():GetParent() == car ) ) then
							return
						end  
					end

					AdvCarDealer:UnGhostCar( car )
					timer.Remove( "CarCheckGhosting" .. entindex )

				end )

				break
			end
		end
	end

	DarkRP.notify( ply, AdvCarDealer.NOTIFY_HINT, 10, sentences[ 22 ] )

	if CFG().IsPlayerInVehicleWhenSpawned then
		ply:EnterVehicle( car )
	end
end

net.Receive( "AdvCarDealer.TakeOutVehicle", function( len, ply )
	local car
	if not ply:Alive() then return end
	local garage = net.ReadEntity()
	local id = net.ReadInt( 32 )
	if not IsValid( garage ) then return end
	if garage:GetPos():DistToSqr( ply:GetPos() ) > 62500 then return end
	if garage:GetClass() == "cardealer_garage_job" then
		local checkCanSpawn, errorMessage = AdvCarDealer:CanSpawnJobCar( ply, garage, id )
		if not checkCanSpawn then
			if errorMessage then
				DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, errorMessage )
			end
			return
		end

		ply:addMoney( -CFG().JobGarage[ game.GetMap() ][ garage:GetID() ].Vehicles[ id ].price )
		car = AdvCarDealer:SpawnJobCar( ply, garage, id )
		spawnPlayerCar( ply, car )
	elseif garage:GetClass() == "cardealer_garage" then
		if ( ply.VehiclesOut or 0 ) >= ( CFG().MaxSpawnedVehicles or 2 ) then
			DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 63 ] )
			return
		end
		
		if not CFG().GarageSpawns or not CFG().GarageSpawns[ game.GetMap() ] then DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 60 ] ) return end
		
		if not garage.nearestGarage or not CFG().GarageSpawns[ game.GetMap() ][ garage.nearestGarage ] then
			local nearestGarage
			local currentDistance = 0
			for garageInfosID, garageInfos in pairs( CFG().GarageSpawns[ game.GetMap() ] ) do
				if not nearestGarage then
					nearestGarage = garageInfosID
					currentDistance = garageInfos.pos:DistToSqr( garage:GetPos() )
				else
					local newDistance = garageInfos.pos:DistToSqr( garage:GetPos() )
					if newDistance < currentDistance then
						nearestGarage = garageInfosID
						currentDistance = newDistance
					end
				end
			end

			garage.nearestGarage = nearestGarage
		end

		local garageInfosID = garage.nearestGarage
		local garageInfos = CFG().GarageSpawns[ game.GetMap() ][ garageInfosID ]

		if not garageInfos then return end

		car = AdvCarDealer:SpawnPlayerCar( ply, id, garageInfos.pos, garageInfos.ang, function( eCar )
			spawnPlayerCar( ply, eCar )
		end )
	else
		return
	end

end )

net.Receive( "AdvCarDealer.BuyCar", function( len, ply )
	if AdvCarDealer:IsCarDealer( ply ) then return end

	local eFacture = net.ReadEntity()
	local eVehicle = net.ReadEntity()

	if not IsValid( eFacture ) or not IsValid( eVehicle ) then return end
	if not eFacture:GetClass() == "cardealer_facture" or not eVehicle:IsVehicle() or eFacture:GetVehicle() ~= eVehicle then return end
	if eFacture:GetPos():DistToSqr( ply:GetPos() ) > 62500 then return end
	if not IsValid( eFacture:GetCarDealer() ) or not AdvCarDealer:IsCarDealer( eFacture:GetCarDealer() ) then return end
	if not ply:Alive() then return end

	if not eVehicle.IsRentedCar then return end

	local infos = AdvCarDealer.GetCarInformations( eVehicle:GetVehicleClass() or eVehicle:GetModel() )
	if not infos then return end

	if not infos.isInCardealerCatalog and not infos.isInCatalog then return end

	if infos.customCheck then
		if AdvCarDealer.CustomChecks and AdvCarDealer.CustomChecks[ infos.customCheck ] and isfunction( AdvCarDealer.CustomChecks[ infos.customCheck ].func ) then
			local check = AdvCarDealer.CustomChecks[ infos.customCheck ].func( ply )
			if not check then 
				DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, AdvCarDealer.CustomChecks[ infos.customCheck ].messageCatalog )
				return
			end
		end
	end

	local min_price = infos.pricePlayer.min
	local min_earned = infos.moneyEarned.min
	local max_price = infos.pricePlayer.max
	local max_earned = infos.moneyEarned.max
	local percentage = eFacture:GetPercentage()
	local diff = max_price - min_price
	local diff_earned = max_earned - min_earned
	local price = diff * percentage + min_price
	local commission = diff_earned * percentage + min_earned

	if eVehicle.HasUnderglow then
		price = price + CFG().PriceUnderglow
		commission = commission + CFG().CommissionUnderglow
	end

	if not ply:canAfford( price ) then
		DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, string.format( sentences[ 17 ], infos.name ) )
		return
	end

	local bdgr = {}

	for k, v in pairs( eVehicle:GetBodyGroups() ) do
		bdgr[ v.id ] = eVehicle:GetBodygroup( v.id )
	end
	bdgr = util.TableToJSON( bdgr )

	tCarInfos = {
		bodygroup = bdgr,
		color = string.FromColor( Color( eVehicle:GetColor().r, eVehicle:GetColor().g, eVehicle:GetColor().b, 255 ) ),
		model =	eVehicle:GetModel(),
		skin = eVehicle:GetSkin(),
		className = eVehicle:GetVehicleClass(),
		underglow = eVehicle.underglow
	}

	AdvCarDealer:AddPlayerCar( ply, tCarInfos, false, function( addvehicle )
		print( "[Advanced Car Dealer] A vehicle has been added into database. Code : 3" )
		DarkRP.notify( ply, AdvCarDealer.NOTIFY_HINT, 10, string.format( sentences[ 18 ], infos.name ) )

		ply:addMoney( -price )
		eVehicle:Remove()
		eFacture:GetCarDealer():addMoney( commission )
		eFacture:Remove()
	end )

end ) 

net.Receive( "AdvCarDealer.BuyCarInTablet", function( len, ply ) 
	if not ply:Alive() then return end

	local tablet = net.ReadEntity()
	if not IsValid( tablet ) then return end

	if not tablet:IsWeapon() then
		if tablet:GetClass() ~= "cardealer_tablet_ent" and tablet:GetClass() ~= "tablet_f4" then return end
		if tablet:GetPos():DistToSqr( ply:GetPos() ) > 62500 then return end
	elseif not IsValid( ply:GetActiveWeapon() ) or ply:GetActiveWeapon() ~= tablet or ply:GetActiveWeapon():GetClass() ~= "cardealer_tablet" then
		return
	end

	local tCarInfos, tData, sNotify = AdvCarDealer:CheckInformationsValidity( ply, net.ReadTable() )

	if sNotify then
		DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, sNotify )
	end

	if not tCarInfos then
		print("[Advanced Car Dealer] An error has occured while buying a car from the player : " .. ply:Name() .. "( " .. ply:SteamID() .. " )" )
		print( tData ) 
		return 
	end

	if not tData.isInCardealerCatalog and not tData.isInCatalog then return end

	local price = tData.priceCatalog

	if tCarInfos.underglow and tCarInfos.underglow ~= "" then
		price = price + CFG().PriceUnderglow
	end

	if AdvCarDealer:IsCarDealer( ply ) then
		local fCarDealerMoney = GetGlobalFloat( "car_dealer_wallet" )

		if fCarDealerMoney < price then 
			DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, string.format( sentences[ 29 ], tData.name ) )
			return
		end

		local tSpawnInfo = CFG().CarDealerSpawns and CFG().CarDealerSpawns[ game.GetMap() ] or { pos = Vector(), ang = Angle( 0, 0, 0 ) }

		local car = AdvCarDealer:SpawnCarDealerRentedCar( ply, tCarInfos, tSpawnInfo.pos, tSpawnInfo.ang )

		if not IsValid( car ) then return end

		if AdvCarDealer.InternalGhosting then
			local max = LocalToWorld( car:OBBMaxs(), car:GetAngles(), car:GetPos(), car:GetAngles() )
			local min = LocalToWorld( car:OBBMins(), car:GetAngles(), car:GetPos(), car:GetAngles() )

			local tEnts = ents.FindInBox( min, max )
			for k, v in pairs( tEnts ) do
				if v ~= car and v:GetClass() ~= "physgun_beam" then
					AdvCarDealer:GhostCar( car )

					local entindex = car:EntIndex()
					timer.Create( "CarCheckGhosting" .. entindex, 3, 0, function()
						if not IsValid( car ) then timer.Remove( "CarCheckGhosting" .. entindex ) return end

						local max = LocalToWorld( car:OBBMaxs(), car:GetAngles(), car:GetPos(), car:GetAngles() )
						local min = LocalToWorld( car:OBBMins(), car:GetAngles(), car:GetPos(), car:GetAngles() )

						local tEnts = ents.FindInBox( min, max )
						for k, v in pairs( tEnts ) do
							if notSolid[ v:GetSolid() ] or not IsValid( v:GetPhysicsObject() ) then
								continue
							end
							if v:GetParent() ~= car and v ~= car and not table.HasValue( noCollideEntities, v:GetClass() ) and not ( v:IsPlayer() and IsValid( v:GetVehicle() ) and ( v:GetVehicle() == car or v:GetVehicle():GetParent() == car ) ) then
								return
							end
						end

						AdvCarDealer:UnGhostCar( car )
						timer.Remove( "CarCheckGhosting" .. entindex )

					end )

					break
				end
			end
		end
		
		car.priceRent = price
		car.carDealer = ply

		SetGlobalFloat( "car_dealer_wallet", fCarDealerMoney - price ) 
		DarkRP.notify( ply, AdvCarDealer.NOTIFY_HINT, 10, string.format( sentences[ 30 ], tData.name ) )

	elseif not AdvCarDealer:PlayersInCarDealerJob() then
		if not tData.isInCatalog then return end

		if not ply:canAfford( price ) then
			DarkRP.notify( ply, AdvCarDealer.NOTIFY_ERROR, 10, string.format( sentences[ 17 ], tData.name ) )
			return
		end

		AdvCarDealer:AddPlayerCar( ply, tCarInfos, false, function( addvehicle )
			print( "[Advanced Car Dealer] A vehicle has been added into database. Code : 1" )
			DarkRP.notify( ply, AdvCarDealer.NOTIFY_HINT, 10, string.format( sentences[ 18 ], tData.name ) )

			ply:addMoney( -price )
		end )
	end
end )