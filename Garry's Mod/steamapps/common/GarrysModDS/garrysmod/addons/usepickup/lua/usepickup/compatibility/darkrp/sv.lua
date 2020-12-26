
-- 1:1 copy
local adminCopWeapons = {
	["door_ram"] = true,
	["arrest_stick"] = true,
	["unarrest_stick"] = true,
	["stunstick"] = true,
	["weaponchecker"] = true,
}
function USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
	if not IsValid(wep) or not IsValid(p) then return end

	if p:isArrested() then return false end
	--if wep.PlayerUse == false then return false end -- not needed anymore
	if p:IsAdmin() and GAMEMODE.Config.AdminsCopWeapons and adminCopWeapons[wep:GetClass()] then return true end

	local jobTable = p:getJobTable()
	if jobTable.PlayerCanPickupWeapon then
		local val = jobTable.PlayerCanPickupWeapon(p, wep)

		return val == nil or val
	end

	if GAMEMODE.Config.license and not p:getDarkRPVar("HasGunlicense") and not p.RPLicenseSpawn then
		if GAMEMODE.NoLicense[string.lower(wep:GetClass())] or not wep:IsWeapon() then
			return true
		end
		return false
	end

	if p.USEPICKUP_BYPASS then
		return true
	end

	--if wep:IsWeapon() then
		local usepickup = p.USEPICKUP
		if usepickup then
			if usepickup.t + .5 < CurTime() then
				p.USEPICKUP = nil
				return false
			elseif isentity(usepickup.w) and IsValid(usepickup.w) and usepickup.w == wep then
				return true -- let it pass
			elseif usepickup.w == wep:GetClass() then
				return true
			end
		end
	--end

	if p:HasWeapon( wep:GetClass() ) then return false end

	if USEPICKUP.Config.AutoPickup then
		return true
	end
end

-- overrides

local g = GM or GAMEMODE

function g:PlayerCanPickupWeapon( p, wep )
	return USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
end

