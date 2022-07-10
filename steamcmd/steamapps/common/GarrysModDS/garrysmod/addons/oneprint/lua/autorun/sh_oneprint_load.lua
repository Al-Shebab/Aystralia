OnePrint = OnePrint or {}

local tLoad = {
    sh = function( sFilePath )
        if SERVER then
            AddCSLuaFile( "oneprint/" .. sFilePath )
            include( "oneprint/" .. sFilePath )
        end
        if CLIENT then
            include( "oneprint/" .. sFilePath )
        end
    end,
    sv = function( sFilePath )
        if SERVER then
            include( "oneprint/" .. sFilePath )
        end
    end,
    cl = function( sFilePath )
        if SERVER then
            AddCSLuaFile( "oneprint/" .. sFilePath )
        end
        if CLIENT then
            include( "oneprint/" .. sFilePath )
        end
    end
}

--[[

    loadTabs

]]--

local function loadTabs()
    local tFiles, _ = file.Find( "oneprint/client/vgui/tabs/*", "LUA")

    if ( #tFiles >= 1 ) then
        for k, v in pairs( tFiles ) do
            tLoad.cl( "client/vgui/tabs/" .. v )
        end
    end
end

--[[

    OnGamemodeLoaded

]]--

hook.Add( "OnGamemodeLoaded", "OnePrint_OnGamemodeLoaded", function()
    tLoad.sh( "config.lua" )
    tLoad.sh( "shared/i18n/" .. ( OnePrint.Cfg.Language or "en" ) .. ".lua" )

    tLoad.sh( "shared/util.lua" )
    tLoad.sh( "shared/init.lua" )
    tLoad.sh( "shared/player.lua" )    

    tLoad.sv( "server/util.lua" )
    tLoad.sv( "server/init.lua" )
    tLoad.sv( "server/hooks.lua" )

    tLoad.cl( "client/init.lua" )
    tLoad.cl( "client/vgui/3d2dvgui.lua" )
    tLoad.cl( "client/vgui/derma.lua" )

    loadTabs()

    hook.Run( "OnePrint_OnLoaded" )
    print( "-------------------------\n[OnePrint] Script loaded\n-------------------------\n" )

    tLoad = nil
    loadTabs = nil

    hook.Remove( "OnGamemodeLoaded", "OnePrint_OnGamemodeLoaded" )
end )