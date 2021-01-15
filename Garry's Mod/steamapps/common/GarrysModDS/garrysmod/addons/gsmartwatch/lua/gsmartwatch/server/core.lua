util.AddNetworkString( "GSmartWatchNW" )
-- resource.AddWorkshop( "2101969034" ) WILL BE BACK ONCE IT'S FIXED 

--[[

    downloadFolderContent

]]--

local function downloadFolderContent( sPath )
	local tFiles, tFolders = file.Find( sPath .. "/*", "GAME" )

    for _, v in pairs( tFiles ) do
		resource.AddFile( sPath .. "/" .. v )
	end

	for _, v in pairs( tFolders ) do
		downloadFolderContent( sPath .. "/" .. v )
	end
end

downloadFolderContent( "materials/gsmartwatch" )
downloadFolderContent( "materials/sterling" )
downloadFolderContent( "models/sterling" )
downloadFolderContent( "sound/gsmartwatch" )

resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
resource.AddFile( "resource/fonts/Rajdhani-Regular.ttf" )

--[[

    requestWatchDeploy

]]--

local function requestWatchDeploy( pPlayer )
    if pPlayer:IsSmartWatchDisabled() then
        return
    end

    if not pPlayer:HasWeapon( "gsmartwatch" ) then
        pPlayer.GSW_LastSWEPGive = ( pPlayer.GSW_LastSWEPGive or 0 )
        if ( CurTime() < ( pPlayer.GSW_LastSWEPGive + .5 ) ) then
            return
        end

        if McPhone and pPlayer:GetNWBool( "McPhone.HasPhone" ) then
            pPlayer:SetNWBool( "McPhone.HasPhone", false )
            pPlayer.bShouldGiveMcPhone = true
        end

        pPlayer.GSW_LastSWEPGive = CurTime()
        pPlayer:Give( "gsmartwatch", true )

        local eWeapon = pPlayer:GetWeapon( "gsmartwatch" )
        pPlayer:SetActiveWeapon( eWeapon )
        eWeapon:Deploy()

        hook.Run( "GSmartWatch_OnDeploy", pPlayer, eWeapon )
    end
end

--[[

    requestWatchHolster

]]--

local function requestWatchHolster( pPlayer )
    if pPlayer:InVehicle() then
        return
    end

    if pPlayer:HasWeapon( "gsmartwatch" ) then
        if ( pPlayer:GetActiveWeapon():GetClass() == "gsmartwatch" ) then
            pPlayer:GetActiveWeapon():Holster()

            if pPlayer.bShouldGiveMcPhone then
                pPlayer:SetNWBool( "McPhone.HasPhone", true )
                pPlayer.bShouldGiveMcPhone = nil
            end
        end
    end
end

--[[

    lockUnlockVehicle

]]--

local function lockUnlockVehicle( pPlayer, i )
    if not DarkRP or not VC then
        return
    end

    local eVehicle = ( GSmartWatch.SpawnedVehicles and GSmartWatch.SpawnedVehicles[ pPlayer ] ) or false 
    if not eVehicle or not IsValid( eVehicle ) or not eVehicle:IsVehicle() then
        return
    end

    if ( pPlayer:GetPos():Distance( eVehicle:GetPos() ) < GSmartWatch.Cfg.CarKeyDistance ) then
        if ( i == 0 ) then
            if DarkRP then
                eVehicle:keysLock()
            else
                eVehicle:VC_lock()                    
            end
        else
            if DarkRP then
                eVehicle:keysUnLock()
            else
                eVehicle:VC_unLock()
            end
        end

        local iAlarmSound = CreateSound( eVehicle, "gsmartwatch/carlock.mp3" )
        iAlarmSound:SetSoundLevel( 90 )
        iAlarmSound:Play()

        if VC then
            if timer.Exists( "GSmartWatch_CarLighting_" .. pPlayer:SteamID() ) then
                timer.Destroy( "GSmartWatch_CarLighting_" .. pPlayer:SteamID() )
            end

            local bOn = false

            timer.Create( "GSmartWatch_CarLighting_" .. pPlayer:SteamID(), .1, 4, function()
                if not pPlayer or not IsValid( pPlayer ) then
                    return
                end

                if not eVehicle or not IsValid( eVehicle ) or not eVehicle:IsVehicle() then
                    return
                end

                bOn = not bOn

                eVehicle:VC_setHazardLights( bOn )
                eVehicle:VC_setRunningLights( bOn )
                eVehicle:VC_setFogLights( bOn )
                eVehicle:VC_setTurnLightLeft( bOn )
                eVehicle:VC_setTurnLightRight( bOn )
            end )
        end
    end
end

--[[

    GSmartWatch:Notify( pPlayer, sNotif, iTime )

]]--

function GSmartWatch:Notify( pPlayer, sNotif, iTime )
    if not pPlayer or not IsValid( pPlayer ) then
        return
    end

    if not sNotif or not isstring( sNotif ) then
        return
    end

    local iTime = ( iTime or 2 )

    if ( iTime > 15 ) then
        iTime = 15
    elseif ( iTime < 1 ) then
        iTime = 1
    end

    net.Start( "GSmartWatchNW" )
        net.WriteUInt( 2, 3 )
        net.WriteString( sNotif )
        net.WriteUInt( iTime, 4 )
    net.Send( pPlayer )
end

--[[

    GSmartWatchNW

]]--

local tPacket = {
    -- Deploy
    [ 0 ] = function( pPlayer )
        requestWatchDeploy( pPlayer )
    end,

    -- Holster
    [ 1 ] = function( pPlayer )
        requestWatchHolster( pPlayer )
    end,

    -- Car keys
    [ 2 ] = function( pPlayer )
        local i = net.ReadUInt( 2 )
        if not i or ( i > 1 ) or ( i < 0 ) then
            return
        end

        lockUnlockVehicle( pPlayer, i )
    end,

    -- Taxi
    [ 3 ] = function( pPlayer )
        if SlownLS and SlownLS.Taxi and SlownLS.Taxi.Call then
            SlownLS.Taxi:Call( pPlayer )
        end
    end,

    -- Add public POI
    [ 4 ] = function( pPlayer )
        if not pPlayer:IsSuperAdmin() then
            return
        end

        local sName = net.ReadString()
        local tColor = net.ReadColor()
        local iIcon = net.ReadUInt( 8 )

        local tPos = pPlayer:GetPos()

        if not file.Exists( "gsmartwatch", "DATA" ) then
            file.CreateDir( "gsmartwatch" )
        end

        if not file.Exists( "gsmartwatch/publicpois", "DATA" ) then
            file.CreateDir( "gsmartwatch/publicpois" )
        end

        local tSavedPOIs = {}

        if file.Exists( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt", "DATA" ) then
            local sSavedPOIs = file.Read( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt", "DATA" )
            tSavedPOIs = util.JSONToTable( sSavedPOIs )
        end

        if tSavedPOIs[ sName ] or tSavedPOIs[ string.lower( sName ) ] then
            return GSmartWatch:Notify( pPlayer, GSmartWatch.Lang[ "Canceled. POI already exists" ] )
        end

        tSavedPOIs[ sName ] = {
            [ 1 ] = Vector( math.Round( tPos.x, 1 ), math.Round( tPos.y, 1 ), math.Round( tPos.z, 1 ) ),
            [ 2 ] = tColor,
            [ 3 ] = ( iIcon or 1 )
        }

        GSmartWatch.PublicPOIs = tSavedPOIs

        file.Write( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt", util.TableToJSON( tSavedPOIs, true ) )

		local sJSON = util.TableToJSON( tSavedPOIs )
--		local sCompressed = util.Compress( sJSON )

        for k, v in pairs( player.GetAll() ) do
            net.Start( "GSmartWatchNW" )
                net.WriteUInt( 3, 3 )
                net.WriteString( sJSON )
--                net.WriteUInt( #sCompressed, 16 )
--                net.WriteData( sCompressed, #sCompressed )
            net.Send( v )
        end

        GSmartWatch:Notify( pPlayer, GSmartWatch.Lang[ "New public POI saved" ], 2 )
    end,

    -- Remove public POI
    [ 5 ] = function( pPlayer )
        if not pPlayer:IsSuperAdmin() then
            return
        end

        local sName = net.ReadString()
        if not sName then
            return
        end

        if file.Exists( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt", "DATA" ) then
            local sSavedPOIs = file.Read( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt", "DATA" )
            local tSavedPOIs = util.JSONToTable( sSavedPOIs )

            if tSavedPOIs[ sName ] then
                tSavedPOIs[ sName ] = nil
                GSmartWatch.PublicPOIs = tSavedPOIs

                file.Write( "gsmartwatch/publicpois/" .. game.GetMap() .. ".txt", util.TableToJSON( tSavedPOIs, true ) )

		        local sJSON = util.TableToJSON( tSavedPOIs )

                for k, v in pairs( player.GetAll() ) do
                    net.Start( "GSmartWatchNW" )
                        net.WriteUInt( 3, 3 )
                        net.WriteString( sJSON )
                    net.Send( v )
                end

                GSmartWatch:Notify( pPlayer, "POI removed" )
            end
        end
    end
}

net.Receive( "GSmartWatchNW", function( iLen, pPlayer )
    pPlayer.GSW_LastPacketSent = ( pPlayer.GSW_LastPacketSent or 0 )
    if ( CurTime() < ( pPlayer.GSW_LastPacketSent + .2 ) ) then
        return
    end

    pPlayer.GSW_LastPacketSent = CurTime()

    local iMsg = net.ReadUInt( 3 )
    if not iMsg or not tPacket[ iMsg ] then
        return
    end

    tPacket[ iMsg ]( pPlayer )    
end )