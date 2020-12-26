
if SERVER then
    include( "sv.lua" )
end

local cfg = USEPICKUP.Config

function USEPICKUP.COMP:FindWeaponToDrop( p, kind, nodrop ) -- from ttt, not needed in other gamemodes afaik
    return false
end

function USEPICKUP.COMP:CanInteract( p ) -- MOVE TO sh_funcs LATER
    return p and IsValid( p ) and p:Alive() or false
end

function USEPICKUP.COMP:GetWeaponColor( wep )
    local ammotype = USEPICKUP.STATS:GetWeaponAmmoType( wep )

    if cfg.ColorOverride[ammotype] then
        return cfg.ColorOverride[ammotype]
    end

    return USEPICKUP.FUNCS:GenerateColorFromString( ammotype )
end

function USEPICKUP.COMP:GetWeaponName( wep ) -- add translation later pls
    return wep.GetPrintName and wep:GetPrintName() or wep.Name or wep.PrintName or weapon.GetClass and weapon:GetClass() or "Unknown"
end

-- stats compare validation
function USEPICKUP.COMP:CanCompare( a, b )
    return USEPICKUP_COMPARE_GLOBAL
end