
function USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
    if p.USEPICKUP_BYPASS then
        return true
    end

    if p:HasWeapon( wep:GetClass() ) then
        local usepickup = p.USEPICKUP
        if usepickup then
            if usepickup.t + .5 < CurTime() then
                p.USEPICKUP = nil
                return false
            elseif usepickup.w and !isstring(usepickup.w) and IsValid(usepickup.w) and usepickup.w == wep then
                usepickup.w = wep:GetClass() -- needed for the WeaponEquip hook
                hook.Run( "WeaponEquip", wep, p)
                return true
            elseif usepickup.w != wep then
                return false
            end
        end
    end

    if USEPICKUP.Config.AutoPickup then
        return true
    end
end

-- overrides

local g = GM or GAMEMODE

function g:PlayerCanPickupWeapon( p, wep )
    return USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
end