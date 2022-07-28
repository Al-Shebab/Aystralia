
USEPICKUP.RESOURCES = {}

local p = "usepickup/"

function USEPICKUP.RESOURCES.AddShared( f )
    local f = p .. f .. ".lua"

    if SERVER then
        AddCSLuaFile( f )
    end

    include( f )
end

function USEPICKUP.RESOURCES.AddServer( f )
    if SERVER then
        include( p .. f .. ".lua" )
    end
end

function USEPICKUP.RESOURCES.AddClient( f )
    local f = p .. f .. ".lua"

    if SERVER then
        AddCSLuaFile( f )
    else
        include( f )
    end
end

function USEPICKUP.RESOURCES.AddVGUI( f )
    local f = p .. "vgui/" .. f .. ".lua"

    if SERVER then
        AddCSLuaFile( f )
    else
        include( f )
    end
end

-- 76561194162976502