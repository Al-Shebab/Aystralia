local f = "usepickup/sh_init.lua"

if SERVER then
    AddCSLuaFile( f )
end

hook.Add( "Initialize", "USEPICKUP.Initialize", function() -- cuz GM overrides :(
    include( f )
end )