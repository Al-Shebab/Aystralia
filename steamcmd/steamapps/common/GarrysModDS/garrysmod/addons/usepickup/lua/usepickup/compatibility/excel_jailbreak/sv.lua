
function USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
	if not p:Alive() then return false end

	if wep:GetClass() == "weapon_physgun" then
		return p:IsSuperAdmin()
	end

    if p.USEPICKUP_BYPASS then
        return true
    end

    local usepickup = p.USEPICKUP
    if usepickup then
        if usepickup.bypass and usepickup.bypass == wep:GetClass() then return true end

        if usepickup.t + .5 < CurTime() then
            p.USEPICKUP = nil
            return false
        elseif IsValid(usepickup.w) and usepickup.w == wep then
            local replace = self:JBCheckWeaponReplacements(p, wep)
            if replace then
                wep:Remove()

                local _wep = weapons.Get( replace )
                for k, v in pairs(p:GetWeapons()) do
                    if v.Slot and v.Slot == _wep.Slot then
                        v.IsDropped = true
                        v.BeingPickedUp = false

                        p:DropWeapon(v)
                    end
                end

                p.USEPICKUP.bypass = replace

                timer.Simple( 0, function() p:Give(replace) end)
                return false
            else
                USEPICKUP.COMP:FindWeaponToDrop( p, wep )                                                                                                                                                                                                                                                                                                                                                                                                                                                               --76561198211994030
                return true
            end
        elseif usepickup.w != wep then
            return false
        end
    end

	if not p:CanPickupWeapon(wep) then return false end

	if wep.IsDropped and (not wep.BeingPickedUp or wep.BeingPickedUp ~= p) then
		return false;
	end

	if JB:CheckWeaponReplacements(p,wep) then wep:Remove(); return false end

	if USEPICKUP.Config.AutoPickup then
        return true
    end
end

-- override

local g = GM or GAMEMODE

function g:PlayerCanPickupWeapon( p, wep )
    return USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
end