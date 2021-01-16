GSmartWatch.Apps = GSmartWatch.Apps or {}

local tDefaultCfg = {
    [ "BandColor" ] = GSmartWatch.Cfg.Bands[ 1 ],
    [ "Is24hCycle" ] = true,
    [ "IsToggle" ] = true,
    -- [ "LeftHanded" ] = false,
    [ "UIVolume" ] = 1,
    [ "WatchFace" ] = 1
}

--[[

    Fonts

]]--

surface.CreateFont( "GSmartWatch.32", { font = "Rajdhani Regular", size = 46, weight = 600, antialias = true } )
surface.CreateFont( "GSmartWatch.48", { font = "Rajdhani Bold", size = 60, weight = 600, antialias = true } )
surface.CreateFont( "GSmartWatch.64", { font = "Rajdhani Bold", size = 72, weight = 600, antialias = true } )
surface.CreateFont( "GSmartWatch.96", { font = "Rajdhani Bold", size = 96, weight = 600, antialias = true } )
surface.CreateFont( "GSmartWatch.128", { font = "Rajdhani Bold", size = 128, weight = 600, antialias = true } )
surface.CreateFont( "GSmartWatch.200", { font = "Rajdhani Bold", size = 200, weight = 600, antialias = true } )

--[[

    GSmartWatch:InitClientSettings

]]--

function GSmartWatch:InitClientSettings()
    if not file.Exists( "gsmartwatch", "DATA" ) then
        file.CreateDir( "gsmartwatch" )
    end

    if file.Exists( "gsmartwatch/client_settings.txt", "DATA" ) then
        local sClientData = file.Read( "gsmartwatch/client_settings.txt", "DATA" )
        local tClientData = util.JSONToTable( sClientData )

        for k, v in pairs( tClientData ) do
            tClientData[ k ] = ( ( tDefaultCfg[ k ] ~= nil ) and tClientData[ k ] or nil )
        end

        for k, v in pairs( tDefaultCfg ) do
            tClientData[ k ] = ( ( tClientData[ k ] ~= nil ) and tClientData[ k ] or v )
        end

        GSmartWatch.ClientSettings = tClientData
    else
        GSmartWatch.ClientSettings = tDefaultCfg
    end

    file.Write( "gsmartwatch/client_settings.txt", util.TableToJSON( GSmartWatch.ClientSettings, true ) )
end

GSmartWatch:InitClientSettings()

--[[

    GSmartWatch:SaveClientSetting

]]--

function GSmartWatch:SaveClientSetting( sSetting, xValue )
    if not file.Exists( "gsmartwatch", "DATA" ) or not file.Exists( "gsmartwatch/client_settings.txt", "DATA" ) then
        GSmartWatch:InitClientSettings()
    end

    local sClientData = file.Read( "gsmartwatch/client_settings.txt", "DATA" )
    local tData = util.JSONToTable( sClientData )

    if ( tDefaultCfg[ sSetting ] ~= nil ) then
        tData[ sSetting ] = xValue
        
        GSmartWatch.ClientSettings[ sSetting ] = xValue

        file.Write( "gsmartwatch/client_settings.txt", util.TableToJSON( tData, true ) )

        return true
    end

    return false
end

--[[

	GSmartWatch:RegisterApp

]]--

function GSmartWatch:RegisterApp( tApp )
    if not tApp or not istable( tApp ) or not tApp.ID then
        return
    end

	GSmartWatch.Apps[ tApp.ID ] = tApp

	hook.Run( "GSmartWatch_OnAppRegistered", tApp.ID )
end

--[[

	GSmartWatch:AppExists

]]--

function GSmartWatch:AppExists( xAppID )
    if not xAppID or not GSmartWatch.Apps[ xAppID ] then
        return false
    end

	return true
end


--[[

	GSmartWatch:RemoveApp

]]--

function GSmartWatch:RemoveApp( xAppID )
    if not xAppID then
        return
    end

	GSmartWatch.Apps[ xAppID ] = nil

	hook.Run( "GSmartWatch_OnAppRemoved", xAppID )
end

--[[

	GSmartWatch:GetApps

]]--

function GSmartWatch:GetApps()
	return GSmartWatch.Apps
end

--[[

    GSmartWatch:GetActiveApp

]]--

function GSmartWatch:GetActiveApp()
    return GSmartWatch.CurrentApp
end

--[[

	GSmartWatch:RunApp

]]--

function GSmartWatch:RunApp( xAppID )
    if not xAppID or not GSmartWatch.Apps[ xAppID ] then
        return false
    end

    if not LocalPlayer():IsUsingSmartWatch() then
        return false
    end

    local xCurApp = ( GSmartWatch.CurrentApp or false )
    local eWeapon = LocalPlayer():GetActiveWeapon()

    if xCurApp and GSmartWatch.Apps[ xCurApp ].OnShutdown and eWeapon.BaseUI then
        hook.Run( "GSmartWatch_PreAppShutdown", xCurApp )

        GSmartWatch.Apps[ xCurApp ].OnShutdown()

        hook.Run( "GSmartWatch_PostAppShutdown", xCurApp )
    end

    GSmartWatch.CurrentApp = xAppID

    if GSmartWatch.Apps[ xAppID ].Run and eWeapon.BaseUI and IsValid( eWeapon.BaseUI ) then
        if eWeapon.BaseUI.RunningApp and IsValid( eWeapon.BaseUI.RunningApp ) then
            eWeapon.BaseUI.RunningApp:Remove()
        end

        GSmartWatch.Apps[ xAppID ].Run( eWeapon.BaseUI )

        local dApp = false

        if GSmartWatch.Apps[ xAppID ].ShowTime then
            dApp = ( dApp or eWeapon.BaseUI.RunningApp )
            dApp.bShowTime = true
        end

        if dApp and dApp.bShowTime then 
            function dApp:PaintOver( iW, iH )
                draw.SimpleText( GSmartWatch:GetTime(), "GSmartWatch.48", ( iW * .5 ), ( iH * .12 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
            end
        end
    end

    hook.Run( "GSmartWatch_OnAppRun", xAppID )

	return true
end

--[[

    GSmartWatchNW

]]--

local tPacket = {
    -- Update vehicle data
    [ 0 ] = function()
        local iAction = net.ReadUInt( 2 )
    
        if not iAction or ( iAction == 0 ) then
            GSmartWatch.VehicleData = nil
            return
        end

        if ( iAction == 1 ) then
            GSmartWatch.VehicleData = GSmartWatch.VehicleData or {}
            GSmartWatch.VehicleData.pos = net.ReadVector()
            GSmartWatch.VehicleData.lastUpdate = net.ReadFloat()
            return
        end

        GSmartWatch.VehicleData = GSmartWatch.VehicleData or {}
        GSmartWatch.VehicleData.entity = net.ReadEntity()
        GSmartWatch.VehicleData.name = net.ReadString()
        GSmartWatch.VehicleData.pos = net.ReadVector()
        GSmartWatch.VehicleData.lastUpdate = net.ReadFloat()
    end,

    -- Holster
    [ 1 ] = function()
        local eWeapon = LocalPlayer():GetActiveWeapon()
        if not eWeapon or not IsValid( eWeapon ) or ( eWeapon:GetClass() ~= "gsmartwatch" ) then
            return
        end

        if eWeapon.BaseUI and IsValid( eWeapon.BaseUI ) then
            eWeapon.BaseUI:Remove()

            if GSmartWatch.CurrentApp then
                hook.Run( "GSmartWatch_PostAppShutdown", GSmartWatch.CurrentApp )
            end

            hook.Remove( "Think", "GSmartWatch_SWEPLightEmitter" )
        end

        hook.Run( "GSmartWatch_OnHolster" )

        timer.Simple( .6, function()
            if LocalPlayer().GSW_OldWeapon and IsValid( LocalPlayer().GSW_OldWeapon ) then
                input.SelectWeapon( LocalPlayer().GSW_OldWeapon )
            end

            LocalPlayer():GetViewModel():SetSubMaterial( 1 )
        end )
    end,

    -- Notify
    [ 2 ] = function()
        local sNotif = net.ReadString()
        local iTime = net.ReadUInt( 4 )

        GSmartWatch:Notify( sNotif, iTime )
    end,

    -- Update public POIs
    [ 3 ] = function()
        local sJSON = net.ReadString()
        local tData = util.JSONToTable( sJSON )

        for k, v in pairs( tData ) do
            if v[ 2 ] and isstring( v[ 2 ] ) then
                v[ 2 ] = string.ToColor( v[ 2 ] )
            end
        end

        GSmartWatch.PublicPOIs = tData

        hook.Run( "GSmartWatch_OnMapPublicPOIUpdate", tData )
    end
}

net.Receive( "GSmartWatchNW", function()
    local iMsg = net.ReadUInt( 3 )
    if not iMsg or not tPacket[ iMsg ] then
        return
    end

    tPacket[ iMsg ]()
end )