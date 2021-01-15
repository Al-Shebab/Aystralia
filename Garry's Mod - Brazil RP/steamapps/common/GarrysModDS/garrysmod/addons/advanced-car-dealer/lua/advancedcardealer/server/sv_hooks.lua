local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local CFG = AdvCarDealer.GetConfig

hook.Add( "EntityRemoved", "EntityRemoved.AdvancedCarDealer", function( eVehicle )
	if not eVehicle:IsVehicle() then return end
	
	for eStand, bool in pairs( eVehicle.Stands or {} ) do
		if not IsValid( eStand ) then continue end
		net.Start( "AdvCarDealer.SelectCarStandToClient" )
			net.WriteInt( eStand:EntIndex(), 32 )
			net.WriteTable( {} )
		net.Broadcast()
		
		eStand.Vehicle = NULL
		eStand.VehicleInfos = {}
	end

	if eVehicle.id and AdvCarDealer.VehiclesOut[ eVehicle.id ] then
		AdvCarDealer.VehiclesOut[ eVehicle.id ] = nil
		local pPlayer = eVehicle.VehicleOwner
		if IsValid( pPlayer ) then
			pPlayer.VehiclesOut = ( pPlayer.VehiclesOut or 1 ) - 1
		end
	end

	if eVehicle.priceRent then
		SetGlobalFloat( "car_dealer_wallet", GetGlobalFloat( "car_dealer_wallet" ) + eVehicle.priceRent )
	end
end )

hook.Add( "PlayerButtonDown", "PlayerButtonDown.AdvancedCarDealer", function( pPlayer, button )
	if button == CFG().KeyToStopUnderglow and pPlayer:InVehicle() and pPlayer:GetVehicle():GetDriver() == pPlayer then
		local eVehicle = pPlayer:GetVehicle()
		if not IsValid( eVehicle ) then return end
		if not eVehicle.underglow then return end
		if eVehicle:GetNWString( "Underglow" ) == "" then
			eVehicle:SetNWString( "Underglow", eVehicle.underglow )
		else
			eVehicle:SetNWString( "Underglow", "" )
		end
	end

	if button == CFG().KeyToReturnIntoGarage and pPlayer:InVehicle() and pPlayer:GetVehicle():GetDriver() == pPlayer then
		local eVehicle = pPlayer:GetVehicle()
		if not IsValid( eVehicle ) then return end
		if not eVehicle:GetNWBool( "canReturnInGarage" ) then return end

		if eVehicle.IsRentedCar then
			if eVehicle.RentTime + CFG().MinimumTimeToReturnInGarageAfterRenting > CurTime() then
				local timeleft = math.Round( eVehicle.RentTime + CFG().MinimumTimeToReturnInGarageAfterRenting - CurTime() )
				DarkRP.notify( pPlayer, AdvCarDealer.NOTIFY_ERROR, 10, string.format( sentences[ 61 ], timeleft ) )
				return
			end
		end

		local canReturn = hook.Run( "AdvancedCarDealer.OnReturnInGarage", eVehicle )

		if canReturn ~= false then
			eVehicle:Remove()
		end
	end
end )

hook.Add( "PlayerDisconnected", "PlayerDisconnected.AdvancedCarDealer", function( pPlayer )
	AdvCarDealer:ClearCars( pPlayer )
	AdvCarDealer:ClearCarDealerVehicles( pPlayer )
	AdvCarDealer:ClearCarDealerFactures( pPlayer )
end )

hook.Add( "OnPlayerChangedTeam", "OnPlayerChangedTeam.AdvancedCarDealer", function( pPlayer, iOldTeam, iNewTeam )
	AdvCarDealer:ClearJobCars( pPlayer )
	
	local oldTeamName = team.GetName( iOldTeam )
	local newTeamName = team.GetName( iNewTeam )

	if CFG().CarDealerJobs[ oldTeamName ] and not CFG().CarDealerJobs[ newTeamName ] then
		AdvCarDealer:ClearCarDealerVehicles( pPlayer )
		AdvCarDealer:ClearCarDealerFactures( pPlayer )
	end
end )

AdvCarDealer.shouldCheckWCD = AdvCarDealer.shouldCheckWCD or false
AdvCarDealer.shouldCheckVC = AdvCarDealer.shouldCheckVC or false

hook.Add( "Initialize", "Initialize.AdvancedCarDealer", function()
	AdvCarDealer:UpdateConfig()
	AdvCarDealer:InitDatabase()
	SetGlobalFloat( "car_dealer_wallet", CFG().CarDealerWallet )

	if file.Exists( "adv_cardealer/wcd", "DATA" ) then
		for k, v in pairs( file.Find( "adv_cardealer/wcd/*", "DATA" ) ) do
			AdvCarDealer.shouldCheckWCD = true
			break
		end
	end
	if file.Exists( "adv_cardealer/vcmod", "DATA" ) then
		for k, v in pairs( file.Find( "adv_cardealer/vcmod/*", "DATA" ) ) do
			AdvCarDealer.shouldCheckVC = true
			break
		end
	end
end )

hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.AdvancedCarDealer", function( pPlayer )
	timer.Simple( 1, function()
		AdvCarDealer:SendConfig( pPlayer )

		-- send stand config
		for k, v in pairs( ents.FindByClass( "cardealer_stand" ) ) do
			net.Start( "AdvCarDealer.SelectCarStandToClient" )
				net.WriteInt( v:EntIndex(), 32 )
				net.WriteTable( v.VehicleInfos or {} )
			net.Broadcast()
		end

		local unique_id

		if AdvCarDealer.shouldCheckWCD then
			unique_id = unique_id or pPlayer:UniqueID() -- long process so do it only if necessary
			if file.Exists( "adv_cardealer/wcd/" .. unique_id .. ".txt", "DATA" ) then
				local content_s = file.Read( "adv_cardealer/wcd/" .. unique_id .. ".txt", "DATA" )
				local content = util.JSONToTable( content_s )

				for className, info in pairs( content ) do
					local tInfos = {}

					if info.bodygroups then
						tInfos.bodygroup = util.TableToJSON( info.bodygroups )
					else
						tInfos.bodygroup = "[]"
					end
					if info.color then
						tInfos.color = string.FromColor(  Color( info.color.r, info.color.g, info.color.b, 255 ) )
					else
						tInfos.color = string.FromColor( Color( 255, 255, 255, 255 ) )
					end
					if className then
						tInfos.className =	className
					end
					if info.skin then
						tInfos.skin = info.skin
					else
						tInfos.skin = 0
					end
					if info.underglow then
						tInfos.underglow = string.FromColor( Color( info.underglow.r, info.underglow.g, info.underglow.b, 255 ) )
					else
						tInfos.underglow = ""
					end

					AdvCarDealer:AddPlayerCar( pPlayer, tInfos, true )
				end

				file.Delete( "adv_cardealer/wcd/" .. unique_id .. ".txt" )
			end
		end
		if AdvCarDealer.shouldCheckVC then
			unique_id = unique_id or pPlayer:UniqueID() -- long process so do it only if necessary
			if file.Exists( "adv_cardealer/vcmod/" .. unique_id .. ".txt", "DATA" ) then
				local content_s = file.Read( "adv_cardealer/vcmod/" .. unique_id .. ".txt", "DATA" )
				local content = util.JSONToTable( content_s ) or {}

				for model, info in pairs( content.Vehicles or {} ) do
					local tInfos = {}

					model = string.Explode( "$$$_VC_$$$", model )
					model = model[1]

					local sClass
					for class, infos in pairs( list.Get("Vehicles") ) do
						if string.lower( infos.Model ) == string.lower( model ) then
							sClass = class
							break
						end
					end

					if not sClass then continue end
					
					tInfos.className = sClass

					if info.BGroups then
						tInfos.bodygroup = util.TableToJSON( info.BGroups )
					else
						tInfos.bodygroup = "[]"
					end
					if info.Color then
						tInfos.color = string.FromColor(  Color( info.Color.r, info.Color.g, info.Color.b, 255 ) )
					else
						tInfos.color = string.FromColor( Color( 255, 255, 255, 255 ) )
					end
					if model then
						tInfos.model =	model
					end
					if info.Skin then
						tInfos.skin = info.Skin
					else
						tInfos.skin = 0
					end
					
					tInfos.underglow = ""

					AdvCarDealer:AddPlayerCar( pPlayer, tInfos, true )
				end

				file.Delete( "adv_cardealer/vcmod/" .. unique_id .. ".txt" )
			end
		end
	end )

	for _, eVehicle in pairs( AdvCarDealer.ListVehiclesSpawned ) do
		if not IsValid( eVehicle ) then AdvCarDealer.ListVehiclesSpawned[ _ ] = nil continue end
		net.Start( "AdvCarDealer.SendCar" )
			net.WriteInt( eVehicle:GetNWInt( "CreationID" ), 32 )
			net.WriteString( eVehicle.underglow or "" ) -- Underglow
			net.WriteBool( eVehicle.IsRentedCar or false ) -- rented
		net.Send( pPlayer )
	end
end )

hook.Add( "PlayerSay", "PlayerSay.AdvancedCarDealer", function( pPlayer, sMessage )
	if not CFG().AdminUserGroups[ pPlayer:GetUserGroup() ] then return end

	local sMessage = string.lower( sMessage )

	if sMessage == "!movetoacd" then 
		local cardealers = AdvCarDealer:CarDealersToMove()

		if cardealers then
			net.Start( "AdvCarDealer.OpenSwitchMenu" )
				net.WriteTable( cardealers )
			net.Send( pPlayer )		
		end
	end

end )

hook.Add( "InitPostEntity", "InitPostEntity.AdvancedCarDealer", function()
	AdvCarDealer:PlaceEntities()
end )

hook.Add( "PostCleanupMap", "PostCleanupMap.AdvancedCarDealer", function()
	AdvCarDealer:PlaceEntities()
end )

hook.Add( "DatabaseInitialized", "DatabaseInitialized.AdvancedCarDealer", function()
	AdvCarDealer.DatabaseInitialized = true
end )