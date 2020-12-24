zfs = zfs or {}
zfs.f = zfs.f or {}

if SERVER then
	function zfs.f.Notify(ply, msg, ntfType)
		if DarkRP and DarkRP.notify then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end
	end
end

// Checks if the distance between pos01 and pos02 is smaller then dist
function zfs.f.InDistance(pos01, pos02, dist)
	local inDistance = pos01:DistToSqr(pos02) < (dist * dist)
	return  inDistance
end

function zfs.f.RandomChance(chance)
	if math.random(0, 100) < math.Clamp(chance,0,100) then
		return true
	else
		return false
	end
end

function zfs.f.table_randomize( t )
	local out = { }
	// 164285642
	while #t > 0 do
		table.insert( out, table.remove( t, math.random( #t ) ) )
	end

	return out
end

function zfs.f.Calculate_AmountCap(hAmount, cap)
	local sAmount

	if hAmount > cap then
		sAmount = cap
	else
		sAmount = hAmount
	end

	return sAmount
end

// Tells us if the function is valid
function zfs.f.FunctionValidater(func)
	if (type(func) == "function") then return true end

	return false
end


// Creates a new clean table from the given table by removing all the nil entrys
function zfs.f.Table_Clean(tbl)
	local new_tbl = {}

	for k, v in pairs(tbl) do
		if v then
			new_tbl[k] = v
		end
	end

	return new_tbl
end

//Used to fix the Duplication Glitch
function zfs.f.CollisionCooldown(ent)
	if ent.zfs_CollisionCooldown == nil then
		ent.zfs_CollisionCooldown = true

		timer.Simple(0.1,function()
			if IsValid(ent) then
				ent.zfs_CollisionCooldown = false
			end
		end)

		return false
	else
		if ent.zfs_CollisionCooldown then
			return true
		else
			ent.zfs_CollisionCooldown = true

			timer.Simple(0.1,function()
				if IsValid(ent) then
					ent.zfs_CollisionCooldown = false
				end
			end)
			return false
		end
	end
end


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

// Returns the player rank / usergroup
function zfs.f.GetPlayerRank(ply)
	if SG then
		return ply:GetSecondaryUserGroup() or ply:GetUserGroup()
	else
		return ply:GetUserGroup()
	end
end

function zfs.f.PlayerRankCheck(ply,ranks)
	if xAdmin then

		local HasRank = false
		for k, v in pairs(ranks) do
			if ply:IsUserGroup(k) then
				HasRank = true
				break
			end
		end
		return HasRank
	else
		if ranks[zfs.f.GetPlayerRank(ply)] == nil then
			return false
		else
			return true
		end
	end
end


// Returns the players job
function zfs.f.GetPlayerJob(ply)
	return ply:Team()
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
if SERVER then
	// This saves the owners SteamID
	function zfs.f.SetOwnerID(ent, ply)
		if not IsValid(ent) then return end
		if IsValid(ply) then
			ent:SetNWString("zfs_Owner", ply:SteamID())

			if CPPI then
				ent:CPPISetOwner(ply)
			end

		else
			ent:SetNWString("zfs_Owner", "world")
		end
	end
end

// This returns the entites owner SteamID
function zfs.f.GetOwnerID(ent)
	return ent:GetNWString("zfs_Owner", "nil")
end

// This returns the owner
function zfs.f.GetOwner(ent)
	if IsValid(ent) then
		local id = ent:GetNWString("zfs_Owner", "nil")
		local ply = player.GetBySteamID(id)

		if (IsValid(ply)) then
			return ply
		else
			return false
		end
	else
		return false
	end
end

// This returns true if the input is the owner
function zfs.f.IsOwner(ply, ent)
	if IsValid(ent) then
		if (zfs.config.SharedEquipment) then
			return true
		else
			local id = ent:GetNWString("zfs_Owner", "nil")
			local ply_id = ply:SteamID()

			if (IsValid(ply) and id == ply_id or id == "world") then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

// This checks if the player is a admin
function zfs.f.IsAdmin(ply)
	if IsValid(ply) then

		//xAdmin Support
		if xAdmin then
			return ply:IsAdmin()
		// SAM Support
		elseif sam then
			return ply:IsAdmin()
		else
			if zfs.config.AdminRanks[zfs.f.GetPlayerRank(ply)] then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.CreateAllowList(atable)
	local allowedGroups = {}

	for k, v in pairs(atable) do
		if (k ~= nil and v == true) then
			table.insert(allowedGroups, k)
		end
	end

	return allowedGroups
end

// This Calculates our Fruit varation Boni
function zfs.f.CalculateFruitVarationBoni(item)
	local FruitVariationCount = 0

	for k, v in pairs(item.recipe) do
		if (v > 0) then
			FruitVariationCount = FruitVariationCount + 1
		end
	end

	local PriceBoni = (FruitVariationCount / 9)

	return PriceBoni
end


// This calculates the health for all the fruits used in the smoothie
function zfs.f.CalculateFruitHealth(item)
	local _health = 0

	for k, v in pairs(item.recipe) do
		if (v > 0) then
			_health = _health + (zfs.config.Health.Fruits[k] * v)
		end
	end

	return _health
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.Timer_Create(timerid,time,rep,func)
	if zfs.f.FunctionValidater(func) then
		timer.Create(timerid, time, rep,func)
	end
end

function zfs.f.Timer_Remove(timerid)
	if timer.Exists(timerid) then
		timer.Remove(timerid)
	end
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
