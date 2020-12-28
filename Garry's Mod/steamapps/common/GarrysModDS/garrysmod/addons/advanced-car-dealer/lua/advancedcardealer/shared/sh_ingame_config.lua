local CFG = AdvCarDealer.GetConfig
if SERVER then

local tConfiguredInGame = {
	[ "CarDealerSpawns" ] = true,
	[ "EntitiesSpawns" ] = true,
	[ "GarageSpawns" ] = true,
	[ "GarageZones" ] = true,
	[ "JobGarage" ] = true,
	[ "DatabaseVersion" ] = true,
	[ "Vehicles" ] = true,
}
function AdvCarDealer:SaveConfiguration()
	local config = table.Copy( CFG() or {} )
	config.DatabaseVersion = AdvCarDealer.DatabaseVersion

	-- Do not save things configured in files
	for key, value in pairs( config ) do 
		if not tConfiguredInGame[ key ] then
			config[ key ] = nil
		end 
	end 

	local sConfig = util.TableToJSON( config )

	file.CreateDir( "adv_cardealer" )
	file.Write( "adv_cardealer/configuration.txt", sConfig )
	
	AdvCarDealer:BroadcastConfig()
	AdvCarDealer:LoadCarInformations()
end


function AdvCarDealer:UpdateConfig()
	if file.Exists( "adv_cardealer/configuration.txt", "DATA" ) then
		local sConfig = file.Read( "adv_cardealer/configuration.txt" )
		local config = util.JSONToTable( sConfig )
		
		AdvCarDealer.Config = table.Merge( AdvCarDealer.Config or {}, config or {} )
    else
		AdvCarDealer:SaveConfiguration()
		return
	end

	AdvCarDealer:BroadcastConfig()
	AdvCarDealer:LoadCarInformations()
end

function AdvCarDealer:BroadcastConfig()
	local json_data = util.TableToJSON( CFG() )
	local compressed_data = util.Compress( json_data )
	local bytes_number = string.len( compressed_data )
	
	net.Start( "AdvCarDealer.SendConfig" )
		net.WriteInt( bytes_number, 32 )
		net.WriteData( compressed_data, bytes_number )
	net.Broadcast()
end

function AdvCarDealer:SendConfig( pPlayer )
	local json_data = util.TableToJSON( CFG() )
	local compressed_data = util.Compress( json_data )
	local bytes_number = string.len( compressed_data )
	
	net.Start( "AdvCarDealer.SendConfig" )
		net.WriteInt( bytes_number, 32 )
		net.WriteData( compressed_data, bytes_number )
	net.Send( pPlayer )
end

function AdvCarDealer:CleanEntities()
    for _, eEntity in pairs( AdvCarDealer.GarageTriggers or {} ) do
        if not IsValid( eEntity ) then continue end
        eEntity:Remove()
    end
    for _, eEntity in pairs( AdvCarDealer.JobGarageNPC or {} ) do
        if not IsValid( eEntity ) then continue end
        eEntity:Remove()
    end
    for sClass, tTable in pairs( AdvCarDealer.EntitiesSpawned or {} ) do
        for _, eEntity in pairs( tTable or {} ) do 
            if not IsValid( eEntity ) then continue end
            eEntity:Remove()
        end
    end
end

function AdvCarDealer:PlaceEntities()
	if CFG().GarageZones and CFG().GarageZones[ game.GetMap() ] then
		for iId, tPos in pairs( CFG().GarageZones[ game.GetMap() ] ) do
			local ent = ents.Create( "cardealer_garage_trigger" )
			if not IsValid( ent ) then continue end
			ent.PointA = tPos.pointA
			ent.PointB = tPos.pointB
			ent:Spawn()

            AdvCarDealer.GarageTriggers = AdvCarDealer.GarageTriggers or {}
			table.insert( AdvCarDealer.GarageTriggers, ent )
		end
	end

	if CFG().JobGarage and CFG().JobGarage[ game.GetMap() ] then
		for iId, tInfos in pairs( CFG().JobGarage[ game.GetMap() ] ) do
			if not tInfos.NPC then continue end
			if not tInfos.SpawnGarage then continue end

			local ent = ents.Create( "cardealer_garage_job" )
			if not IsValid( ent ) then continue end
			ent:SetPos( tInfos.NPC.pos )
			ent:SetAngles( tInfos.NPC.ang )
			ent:Spawn()
			ent:SetModel( tInfos.NPC.model or "models/barney.mdl" )
			ent:SetGName( tInfos.NPC.name or "Job Garage" )
			ent:SetID( iId )
			ent.GarageSpawn = tInfos.SpawnGarage

			AdvCarDealer.JobGarageNPC = AdvCarDealer.JobGarageNPC or {}
			table.insert( AdvCarDealer.JobGarageNPC, ent )
		end
	end

	if CFG().EntitiesSpawns and CFG().EntitiesSpawns[ game.GetMap() ]  then		
		AdvCarDealer.EntitiesSpawned = {}
		
		for sClass, tList in pairs( CFG().EntitiesSpawns[ game.GetMap() ] ) do
			for k, tInfos in pairs( tList ) do
				local eEntity = ents.Create( sClass )
				if not IsValid( eEntity ) then continue end
				eEntity:SetPos( tInfos.pos )
				eEntity:SetAngles( tInfos.ang )
				eEntity:Spawn()
				
				local phys = eEntity:GetPhysicsObject()
				if phys:IsValid() then
					phys:EnableMotion( false )
				end
				
				AdvCarDealer.EntitiesSpawned[ sClass ] = AdvCarDealer.EntitiesSpawned[ sClass ] or {}
				table.insert( AdvCarDealer.EntitiesSpawned[ sClass ], eEntity )
			end
		end
	end
end


else

net.Receive( "AdvCarDealer.SendConfig", function()
	local bytes_number = net.ReadInt( 32 )
	local compressed_data = net.ReadData( bytes_number )
	local json_data = util.Decompress( compressed_data )
	local real_data = util.JSONToTable( json_data )

	AdvCarDealer.Config = real_data

	AdvCarDealer.LoadCarInformations()

	if IsValid( AdvCarDealer.FrameAdminVehicle ) then
		AdvCarDealer.FrameAdminVehicle:Remove()
		AdvCarDealer.AdminVehiclesMenu()
	end
end )

end