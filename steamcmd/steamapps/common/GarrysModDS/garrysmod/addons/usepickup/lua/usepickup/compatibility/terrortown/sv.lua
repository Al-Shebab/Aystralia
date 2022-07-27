-- this is just here to protect it

function USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
	if not IsValid(wep) or not IsValid(p) then return end
	if p:IsSpec() or (p.IsGhost and p:IsGhost()) then return false end

	local usepickup = p.USEPICKUP
	if usepickup then
		if usepickup.t + .5 < CurTime() then
			p.USEPICKUP = nil
			return false
		elseif IsValid(usepickup.w) and usepickup.w == wep then
			local _wep
			if !p:CanCarryWeapon(wep) then
				_wep = USEPICKUP.COMP:FindWeaponToDrop( p, wep )
			end

			if (IsValid(_wep) && !_wep.AllowDrop) then
				return false
			end

			return true
		elseif usepickup.w != wep then
			return false
		end
	end

	-- he
	if !self.WEPS_IsEquipment then
		self.WEPS_IsEquipment = WEPS.IsEquipment
	end
	-- he

	if p:HasWeapon(wep:GetClass()) then
		return false
	elseif not p:CanCarryWeapon(wep) then
		return false
	elseif self.WEPS_IsEquipment(wep) and wep.IsDropped and (not p:KeyDown(IN_USE)) then
		return false
	end

	if p.USEPICKUP_BYPASS then
		return true
	end

	if !USEPICKUP.Config.AutoPickup then
		return false
	end

	local tr = util.TraceEntity({start=wep:GetPos(), endpos=p:GetShootPos(), mask=MASK_SOLID}, wep)
	if tr.Fraction == 1.0 or tr.Entity == p then
		wep:SetPos(p:GetShootPos())
	end

	return true
end

-- override

local g = GM or GAMEMODE

function g:PlayerCanPickupWeapon( p, wep )
	return USEPICKUP.COMP:PlayerCanPickupWeapon( p, wep )
end