
USEPICKUP = USEPICKUP or {}

if SERVER then
    AddCSLuaFile( "usepickup/sh_resources.lua" )
end

include( "usepickup/sh_resources.lua" )

USEPICKUP_COMPARE_WEAPON = 1 -- compare A to B (atm ttt only)
USEPICKUP_COMPARE_GLOBAL = 2 -- compare A to EVERYTHING (darkrp etc)

function USEPICKUP:Debug( s )
    MsgC( Color( 120, 120, 255 ), "<USEPICKUP> ", Color( 255, 255, 255 ), s, "\n" )
end

--
local r = USEPICKUP.RESOURCES

r.AddShared( "config" )

r.AddShared( "sh_lang" )
r.AddShared( "sh_funcs" )

r.AddServer( "sv_detour" )
r.AddServer( "sv_core" )
r.AddServer( "sv_version" )

r.AddClient( "cl_core" )
r.AddClient( "cl_stats" )
r.AddClient( "cl_debug" )

r.AddVGUI( "DUsePickup" )
r.AddVGUI( "DUsePickupRow" )
--r.AddVGUI( "DUsePickupRowAlt" ) we dont need this shit anymore
--

do

    local files, directories = file.Find( "usepickup/compatibility/*", "LUA" )
    local c = USEPICKUP.Config

    USEPICKUP.COMP = {}

    if c.LoadGM == "auto" then
        if table.HasValue( directories, engine.ActiveGamemode() ) then
            r.AddShared( "compatibility/" .. engine.ActiveGamemode() .. "/sh" )
        else
            if DarkRP then -- fuck everyone who uses darkrp but renamed it for absolutely no reason
                r.AddShared( "compatibility/darkrp/sh" )
            elseif JB then
                r.AddShared( "compatibility/excel_jailbreak/sh" ) -- hope it works
            else
                r.AddShared( "compatibility/fallback/sh" )
            end
        end
    else
        if table.HasValue( directories, c.LoadGM ) then
            r.AddShared( "compatibility/" .. c.LoadGM .. "/sh" )
        else
            r.AddShared( "compatibility/fallback/sh" )
        end
    end

    USEPICKUP.LANG:Initialize()

end