
if SERVER then
    include( "sv.lua" )
    --AddCSLuaFile( "cl.lua" ) not needed
else
    --include( "cl.lua" )
end

local TypeColors = {
    [WEAPON_HEAVY]  = Color( 255, 150, 0 ),
    [WEAPON_PISTOL] = Color( 255, 75, 0 ),
    [WEAPON_NADE]   = Color( 75, 150, 75 ),
    [WEAPON_EQUIP1] = Color( 255, 0, 0 ),   -- ?
    [WEAPON_EQUIP2] = Color( 255, 0, 0 ),   -- ?
    [WEAPON_ROLE]   = Color( 255, 255, 255 ),   -- ?
    [WEAPON_MELEE]  = Color( 255, 255, 255 ),   -- ?
}

-----------------------

local cfg = USEPICKUP.Config

function USEPICKUP.COMP:FindWeaponToDrop( p, wep, nodrop )
    for k, v in pairs(p:GetWeapons()) do
        if v.Kind and v.Kind == (wep.Kind or -100) then
            if v.AllowDrop && !nodrop then
                WEPS.DropNotifiedWeapon( p, v, false )
            end

            return v
        end
    end
end

function USEPICKUP.COMP:CanInteract( p )
    return p and IsValid( p ) and !p:IsSpec() and p:Alive() and true or false
end

function USEPICKUP.COMP:GetWeaponColor( wep )
    return wep and wep.Kind and TypeColors[wep.Kind] or COLOR_WHITE
end

local TryTranslation = LANG.TryTranslation -- hehe
function USEPICKUP.COMP:GetWeaponName( wep )
    if cfg.NameOverride[wep:GetClass()] then return cfg.NameOverride[wep:GetClass()] end
    return TryTranslation( wep.GetPrintName and wep:GetPrintName() or wep:GetClass() or "Unknown" )
end

-- stats compare validation
function USEPICKUP.COMP:CanCompare( a, b )
    local a_stats = a and USEPICKUP.STATS:GetWeaponStats( a )
    local b_stats = b and USEPICKUP.STATS:GetWeaponStats( b )
    return a_stats and a_stats != {} and b_stats and b_stats != {} and USEPICKUP_COMPARE_WEAPON or USEPICKUP_COMPARE_GLOBAL
end