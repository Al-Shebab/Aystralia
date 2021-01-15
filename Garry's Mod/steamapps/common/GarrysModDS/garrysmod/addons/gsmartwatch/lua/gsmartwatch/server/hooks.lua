GSmartWatch.SpawnedVehicles = {}

local tChairClasses = {
    [ "Seat_Airboat" ] = true,
    [ "Chair_Office2" ] = true,
    [ "phx_seat" ] = true,
    [ "phx_seat2" ] = true,
    [ "phx_seat3" ] = true,
    [ "Chair_Plastic" ] = true,
    [ "Seat_Jeep" ] = true,
    [ "Chair_Office1" ] = true,
    [ "Chair_Wood" ] = true,
}

--[[

    updateClientVehicleData

]]--

local function updateClientVehicleData( pPlayer, tVehicle, bOnlyUpdatePos )
    if not pPlayer or not IsValid( pPlayer ) or not pPlayer:IsPlayer() then
        return
    end

    if not tVehicle then
        net.Start( "GSmartWatchNW" )
            net.WriteUInt( 0, 3 )
            net.WriteUInt( 0, 2 )
        net.Send( pPlayer )
        
        return
    end

    if bOnlyUpdatePos then
        net.Start( "GSmartWatchNW" )
            net.WriteUInt( 0, 3 )
            net.WriteUInt( 1, 2 )
            net.WriteVector( tVehicle.pos )
            net.WriteFloat( tVehicle.lastUpdate )
        net.Send( pPlayer )

        return
    end

    net.Start( "GSmartWatchNW" )
        net.WriteUInt( 0, 3 )
        net.WriteUInt( 2, 2 )
        net.WriteEntity( tVehicle.entity )
        net.WriteString( tVehicle.name )
        net.WriteVector( tVehicle.pos )
        net.WriteFloat( tVehicle.lastUpdate )
    net.Send( pPlayer )
end

--[[

    app_maps

]]--

if not GSmartWatch.Cfg.DisabledApps[ "app_maps" ] then
    -- InitPostEntity
    hook.Add( "InitPostEntity", "GSmartWatch_InitPostEntity",function( pPlayer )
        local sPath = ( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt" )

        if file.Exists( sPath, "DATA" ) then
            local sJSON = file.Read( sPath, "DATA" )
            local tPublicPOIs = util.JSONToTable( sJSON )

            GSmartWatch.PublicPOIs = tPublicPOIs
        end
    end )

    -- PlayerInitialSpawn
    hook.Add( "PlayerInitialSpawn", "GSmartWatch_PlayerInitialSpawn",function( pPlayer )
        if GSmartWatch.PublicPOIs and not table.IsEmpty( GSmartWatch.PublicPOIs ) then
            local sJSON = util.TableToJSON( GSmartWatch.PublicPOIs )

            net.Start( "GSmartWatchNW" )
                net.WriteUInt( 3, 3 )
                net.WriteString( sJSON )
            net.Send( pPlayer )
        end
    end )
end

--[[

    PlayerLeaveVehicle

]]--

hook.Add( "PlayerLeaveVehicle", "GSmartWatch_PlayerLeaveVehicle", function( pPlayer, eVehicle, iRole )
    if pPlayer:HasWeapon( "gsmartwatch" ) then
        pPlayer:StripWeapon( "gsmartwatch" )

        hook.Run( "GSmartWatch_OnHolster", pPlayer )
    end
end )

--[[

    PlayerSpawnedVehicle

]]--

hook.Add( "PlayerSpawnedVehicle", "GSmartWatch_PlayerSpawnedVehicle", function( pPlayer, eVehicle )
    if tChairClasses[ eVehicle:GetClass() ] then
        return
    end

    GSmartWatch.SpawnedVehicles[ pPlayer ] = eVehicle

    local tVehicle = {
        entity = eVehicle,
        name = GSmartWatch.Lang[ "Vehicle" ],
        pos = eVehicle:GetPos(),
        lastUpdate = CurTime()
    }

    if ( list.Get( "Vehicles" )[ eVehicle:GetVehicleClass() ] ) then
        local t = list.Get( "Vehicles" )[ eVehicle:GetVehicleClass() ]
        tVehicle.name = t.Name
    end

    timer.Simple( .5, function()
        if tVehicle.entity and IsValid( tVehicle.entity ) and tVehicle.entity:IsVehicle() then
            updateClientVehicleData( pPlayer, tVehicle )
        end
    end )
end )

--[[

    EntityRemoved

]]--

hook.Add( "EntityRemoved", "GSmartWatch_EntityRemoved", function( eEntity )
    if not eEntity:IsVehicle() or tChairClasses[ eEntity:GetClass() ] then
        return
    end

    for pPlayer, eVehicle in pairs( GSmartWatch.SpawnedVehicles ) do
        if ( eEntity == eVehicle ) then
            if IsValid( pPlayer ) and pPlayer:IsPlayer() then
                updateClientVehicleData( pPlayer )
            end

            pPlayer = nil
        end
    end
end )

--[[

    PlayerDisconnected

]]--

hook.Add( "PlayerDisconnected", "GSmartWatch_PlayerDisconnected", function( pPlayer )
    if GSmartWatch.SpawnedVehicles[ pPlayer ] then
        GSmartWatch.SpawnedVehicles[ pPlayer ] = nil
    end
end )

--[[

    GSmartWatch_UpdateClientVehicleData

]]--

timer.Create( "GSmartWatch_UpdateClientVehicleData", GSmartWatch.Cfg.CarFinderUpdateTime, 0, function()
    if GSmartWatch.SpawnedVehicles and not table.IsEmpty( GSmartWatch.SpawnedVehicles ) then
        for pPlayer, eVehicle in pairs( GSmartWatch.SpawnedVehicles ) do
            if not pPlayer or not IsValid( pPlayer ) or not pPlayer:IsPlayer() then
                pPlayer = nil

                continue
            end

            if not eVehicle or not IsValid( eVehicle ) or not  eVehicle:IsVehicle() then
                updateClientVehicleData( pPlayer )
                pPlayer = nil
            
                continue
            end

            local tVehicle = {
                pos = eVehicle:GetPos(),
                lastUpdate = CurTime()
            }

            updateClientVehicleData( pPlayer, tVehicle, true )
        end
    end
end )