if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

// Give the player the Cash
function zfs.f.GiveMoney(ply, money)

	if DarkRP then
		ply:addMoney(money)
	elseif nut then
		ply:getChar():giveMoney(money)
	elseif BaseWars then
		ply:GiveMoney(money)
	end
end

// Give the player the Cash
function zfs.f.TakeMoney(ply, money)

	if DarkRP then
		ply:addMoney(-money)
	elseif nut then
		ply:getChar():takeMoney(money)
	elseif BaseWars then
		ply:GiveMoney(-money)
	end
end

// Does the player have money?
function zfs.f.HasMoney(ply, money)

	if DarkRP then
		if (ply:getDarkRPVar("money") or 0) >= money then
			return true
		else
			return false
		end
	elseif nut then
		if ply:getChar():hasMoney(money) then
			return true
		else
			return false
		end
	elseif BaseWars then
		if (ply:GetMoney() or 0) >= money then
			return true
		else
			return false
		end
	elseif engine.ActiveGamemode() == "sandbox" then
		return true
	end
end
