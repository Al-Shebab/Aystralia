GSmartWatch = GSmartWatch or {}

local tLoad = {
    sh = function( sFilePath )
        if SERVER then
            AddCSLuaFile( "gsmartwatch/" .. sFilePath )
            include( "gsmartwatch/" .. sFilePath )
        end
        if CLIENT then
            include( "gsmartwatch/" .. sFilePath )
        end
    end,
    sv = function( sFilePath )
        if SERVER then
            include( "gsmartwatch/" .. sFilePath )
        end
    end,
    cl = function( sFilePath )
        if SERVER then
            AddCSLuaFile( "gsmartwatch/" .. sFilePath )
        end
        if CLIENT then
            include( "gsmartwatch/" .. sFilePath )
        end
    end
}

--[[

    loadGSWApps

]]--

local function loadGSWApps()
    local files, folders = file.Find( "gsmartwatch/client/apps/*", "LUA")

    if ( #files >= 1 ) then
        for k, v in pairs(files) do
            tLoad.cl( "client/apps/" .. v )
        end
    end
end

--[[

    OnGamemodeLoaded

]]--

hook.Add( "OnGamemodeLoaded", "GSmartWatch_OnGamemodeLoaded", function()
    tLoad.sh( "config.lua" )
    tLoad.sh( "shared/i18n/" .. ( GSmartWatch.Cfg.Language or "en" ) .. ".lua" )

    tLoad.sh( "shared/player.lua" )

    tLoad.sv( "server/core.lua" )
    tLoad.sv( "server/hooks.lua" )

    tLoad.cl( "client/core.lua" )
    tLoad.cl( "client/util.lua" )
    tLoad.cl( "client/hooks.lua" )

    tLoad.cl( "client/vgui/main.lua" )
    tLoad.cl( "client/vgui/watchfaces.lua" )

    loadGSWApps()

    hook.Run( "GSmartWatch_OnLoaded" )

    tLoad = nil
end )