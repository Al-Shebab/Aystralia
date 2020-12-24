if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.Minebase_Initialize(Minebase)
	zrmine.f.Minebase_CreateCart(Minebase)

	Minebase.PhysgunDisabled = false
	Minebase.PublicEntity = false
	Minebase.InWorldResource = {}
	Minebase:SetCurrentState(0)

	// The last person who send down the minecart
	Minebase.LastUser = nil

	zrmine.f.EntList_Add(Minebase)
end

function zrmine.f.Minebase_CreateCart(Minebase)
	Minebase.svCartModel = ents.Create("zrms_minecart")

	if IsValid(Minebase.svCartModel) then
		local attach = Minebase:GetAttachment(1)

		Minebase.svCartModel:SetPos(attach.Pos)

		local ang = attach.Ang
		ang:RotateAroundAxis(attach.Ang:Up(), 90)
		Minebase.svCartModel:SetAngles(ang)

		Minebase.svCartModel:Spawn()
		Minebase.svCartModel:Activate()

		Minebase.svCartModel:SetParent(Minebase,1)
		Minebase.svCartModel:SetBodygroup(0, 0)

		// Sets the owner,
		timer.Simple(0.4, function()
			if IsValid(Minebase) and IsValid(Minebase.svCartModel) then
				Minebase.svCartModel:CPPISetOwner(Minebase:CPPIGetOwner())
				local ply = zrmine.f.GetOwner(Minebase)
				zrmine.f.SetOwner(Minebase.svCartModel, ply)

				// IF the minebase is a PublicEntity then we also want the minecart to be
				if Minebase.PublicEntity then
					Minebase.svCartModel.PublicEntity = true
				end
			end
		end)
	end
end


/*
	0 = CLOSED
	1 = WAITING_FOR_ORDER
	2 = OPENING
	3 = CLOSING
	4 = MINING
*/



function zrmine.f.Minebase_USE(Minebase,ply)
	zrmine.f.Debug("zrmine.f.Minebase_USE")

	if Minebase.PublicEntity == true and not zrmine.f.IsAdmin(ply) then
		zrmine.f.Notify(ply, zrmine.language.Module_DontOwn, 1)

		return
	end

	if Minebase.PublicEntity == false and not zrmine.f.IsOwner(ply, Minebase) then
		zrmine.f.Notify(ply, zrmine.language.Module_DontOwn, 1)

		return
	end

	local curState = Minebase:GetCurrentState()

	if (curState == 0) then

		zrmine.f.Minebase_OpenMine(Minebase,ply)

	elseif (curState == 1) then

		if IsValid(Minebase.svCartModel) then
			Minebase.svCartModel:SetNoDraw(true)
		end

		zrmine.f.Minebase_Close(Minebase)
		Minebase:SetConnectedOre(NULL)
		Minebase:SetMineResourceType("Nothing")
	end
end


function zrmine.f.Minebase_OpenMine(Minebase,ply)
	zrmine.f.Debug("zrmine.f.Minebase_OpenMine")

	local validMine = zrmine.f.Minebase_SearchOreMine(Minebase)

	if (IsValid(validMine)) then
		if IsValid(Minebase.svCartModel) then
			Minebase.svCartModel:SetNoDraw(false)
		end

		zrmine.f.CreateNetEffect("mine_foundore",validMine)

		Minebase:SetConnectedOre(validMine)
		Minebase:SetMineResourceType(validMine:GetResourceType())
		zrmine.f.Minebase_Open(Minebase)
	else
		if IsValid(ply) then
			zrmine.f.Notify(ply, zrmine.language.Mine_NoOre, 1)
		end
	end
end

function zrmine.f.Minebase_SearchOreMine(Minebase)
	zrmine.f.Debug("zrmine.f.Minebase_SearchOreMine")
	local validOreMine = nil
	local ores = {}

	for k, v in pairs(zrmine.EntList) do
		if (IsValid(v) and zrmine.f.InDistance(Minebase:GetPos(), v:GetPos(),  100 + zrmine.config.Mine_SearchDistance) and string.sub(v:GetClass(), 1, 8) == "zrms_ore") then
			table.insert(ores, v)
		end
	end

	local nearestEnt = zrmine.f.Minebase_FindNearestOreEntity(ores, Minebase:GetPos(), zrmine.config.Mine_SearchDistance)

	if (IsValid(nearestEnt)) then
		validOreMine = nearestEnt
	end

	return validOreMine
end

function zrmine.f.Minebase_FindNearestOreEntity(aents, pos, range)

	local nearestEnt
	local lastDist = 999999
	for i, entity in ipairs(aents) do

		if IsValid(entity) then
			local dist = entity:GetPos():Distance(pos)
			if dist < lastDist  then
				nearestEnt = entity
				lastDist = dist
			end
		end
	end

	return nearestEnt
end

function zrmine.f.Minebase_Close(Minebase)
	zrmine.f.Debug("zrmine.f.Minebase_Close")
	local phys = Minebase:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	Minebase.PhysgunDisabled = false
	Minebase:SetCurrentState(3)

	zrmine.f.CreateNetEffect("mine_close",Minebase)

	timer.Simple(1, function()
		if (IsValid(Minebase)) then
			Minebase:SetIsClosed(true)
			Minebase:SetHideCart(true)
			Minebase:SetCurrentState(0)
		end
	end)
end

function zrmine.f.Minebase_Open(Minebase)
	zrmine.f.Debug("zrmine.f.Minebase_Open")
	local phys = Minebase:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	Minebase.PhysgunDisabled = true
	Minebase:SetCurrentState(2)
	Minebase:SetIsClosed(false)

	zrmine.f.CreateNetEffect("mine_open",Minebase)

	if IsValid(Minebase.svCartModel) then
		Minebase.svCartModel:SetBodygroup(0, 0)
	end
	Minebase:SetHideCart(true)

	timer.Simple(1, function()
		if IsValid(Minebase) then
			Minebase:SetCurrentState(1)
		end
	end)
end

// Logic
function zrmine.f.Minebase_MineCartDown(Minebase,ply)
	zrmine.f.Debug("zrmine.f.Minebase_MineCartDown")
	if (zrmine.f.Minebase_GetValidResourceCount(Minebase) > zrmine.config.Mine_MaxEntCount) then
		zrmine.f.Notify(ply, zrmine.language.Mine_EntLimit, 1)

		return
	end

	local c_Ore = Minebase:GetConnectedOre()

	if (zrmine.f.OreSpawn_HasResource(c_Ore) == false) then
		zrmine.f.Notify(ply, zrmine.language.Mine_Empty, 1)

		return
	end

	// Returns the OreAmount we gonna take from the Mine
	local OreAmount = math.random(zrmine.config.Min_MiningAmount, zrmine.config.Max_MiningAmount)

	if (IsValid(c_Ore)) then
		local CRO_Amount = c_Ore:GetResourceAmount()

		if (OreAmount > CRO_Amount) then
			OreAmount = CRO_Amount
		end

		zrmine.f.OreSpawn_DecreaseOre(c_Ore,OreAmount)
	end

	Minebase:SetHideCart(false)
	Minebase:SetCurrentState(5)

	// Who send down the minecart
	Minebase.LastUser = ply

	zrmine.f.MineCart_RollDown(Minebase.svCartModel)

	zrmine.f.CreateNetEffect("mine_close",Minebase)

	local mineTime = zrmine.config.MiningTime[c_Ore:GetResourceType()]
	Minebase:SetMinningTime(mineTime)
	Minebase:SetStartMinningTime(CurTime())

	if IsValid(Minebase.svCartModel) then
		Minebase.svCartModel:EmitSound("zrmine_minecratemove")
	end
	timer.Simple(2, function()
		if IsValid(Minebase) and IsValid(Minebase.svCartModel) then
			Minebase.svCartModel:StopSound("zrmine_minecratemove")
		end
	end)

	timer.Simple(5, function()
		if (IsValid(Minebase)) then
			Minebase:SetIsClosed(true)

			timer.Simple(mineTime, function()
				if (IsValid(Minebase)) then
					zrmine.f.Minebase_MineCart_SpawnResource(Minebase,OreAmount)
				end
			end)
		end
	end)
end

function zrmine.f.Minebase_GetValidResourceCount(Minebase)
	local validEnts = 0

	for k, v in pairs(Minebase.InWorldResource) do
		if (IsValid(v)) then
			validEnts = validEnts + 1
		end
	end

	return validEnts
end

function zrmine.f.Minebase_GetRandomOre()
	local OreChancePool = {}

	for k, v in pairs(zrmine.config.Mine_ResourceChance) do
		for i = 1, v do
			table.insert(OreChancePool, k)
		end
	end

	return table.Random(OreChancePool)
end

function zrmine.f.Minebase_MineCart_SpawnResource(Minebase,OreAmount)

	zrmine.f.Minebase_MineCartUp(Minebase)

	local Big_JunkAmount = math.random(0, 2)
	local Small_JunkAmount = math.random(1, 2)
	local JunkCount = Big_JunkAmount + Small_JunkAmount
	local FoundResourcesTable = {}
	local foundResource
	local bJunks = Big_JunkAmount
	local bOrePerJunk = (OreAmount * 0.6) / Big_JunkAmount
	local sOrePerJunk = (OreAmount * 0.4) / Small_JunkAmount

	for i = 1, JunkCount do
		if (Minebase:GetMineResourceType() == "Random") then
			foundResource = zrmine.f.Minebase_GetRandomOre()
		else
			foundResource = Minebase:GetMineResourceType()
		end

		if (foundResource ~= "Nothing") then
			table.insert(FoundResourcesTable, i, foundResource)
		end
	end

	timer.Simple(1, function()
		if IsValid(Minebase) and IsValid(Minebase.svCartModel) then
			zrmine.f.MineCart_Unload(Minebase.svCartModel)
		end
	end)

	timer.Simple(1.4, function()
		if (IsValid(Minebase)) then

			// Custom Hook
			if IsValid(Minebase.LastUser) then
				hook.Run("zrmine_OnOreMined", Minebase.LastUser, Minebase)
			end
			local y = 0
			local delay = 0.1

			for k, v in pairs(FoundResourcesTable) do
				y = y + 15
				delay = delay + 0.1

				if (bJunks > 0) then
					zrmine.f.Minebase_ResourceOffsetSpawn(Minebase,y, delay, bOrePerJunk, 1, v)
				else
					zrmine.f.Minebase_ResourceOffsetSpawn(Minebase,y, delay, sOrePerJunk, 0, v)
				end

				bJunks = bJunks - 1
			end

			timer.Simple((JunkCount * 0.1) + 0.1, function()
				if (IsValid(Minebase)) then
					Minebase:SetCurrentState(1)
				end
			end)
		end
	end)
end

function zrmine.f.Minebase_MineCartUp(Minebase)
	zrmine.f.Debug("zrmine.f.Minebase_MineCartUp")
	Minebase:SetIsClosed(false)

	zrmine.f.CreateNetEffect("mine_open",Minebase)


	Minebase.svCartModel:SetBodygroup(0, 1)
	Minebase:SetMinningTime(-1)
	Minebase:SetStartMinningTime(-1)
	local mineType = Minebase:GetMineResourceType()


	if (mineType == "Random") then
		Minebase.svCartModel:SetSkin(0)
	elseif (mineType == "Coal") then
		Minebase.svCartModel:SetSkin(5)
	elseif (mineType == "Iron") then
		Minebase.svCartModel:SetSkin(1)
	elseif (mineType == "Bronze") then
		Minebase.svCartModel:SetSkin(2)
	elseif (mineType == "Silver") then
		Minebase.svCartModel:SetSkin(3)
	elseif (mineType == "Gold") then
		Minebase.svCartModel:SetSkin(4)
	end

	timer.Simple(0.3, function()
		if (IsValid(Minebase)) then
			zrmine.f.EmitSoundENT("zrmine_mine_cartup",Minebase.svCartModel)
		end
	end)

	Minebase:SetHideCart(true)
end





// Utility Spawn Resource
function zrmine.f.Minebase_ResourceOffsetSpawn(Minebase,y, delay, OrePerJunk, bg, rtype)
	timer.Simple(delay, function()
		if (IsValid(Minebase)) then

			local pos = Minebase.svCartModel:GetPos() + Minebase.svCartModel:GetForward() * 30
			pos = pos + Minebase.svCartModel:GetUp() * 10 + Minebase.svCartModel:GetRight() * 1
			pos = pos + Minebase.svCartModel:GetUp() * y

			zrmine.f.Minebase_SpawnResource(Minebase,pos, OrePerJunk, bg, rtype)

			zrmine.f.CreateNetEffect("mine_orejunkspawn",pos)
		end
	end)
end

function zrmine.f.Minebase_SpawnResource(Minebase,pos, oreamount, bg, rType)
	local ent = ents.Create("zrms_resource")
	ent:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(0, bg)

	if (rType == "Iron") then
		ent:SetSkin(0)
	elseif (rType == "Bronze") then
		ent:SetSkin(1)
	elseif (rType == "Silver") then
		ent:SetSkin(2)
	elseif (rType == "Gold") then
		ent:SetSkin(3)
	elseif (rType == "Coal") then
		ent:SetSkin(4)
	end

	table.insert(Minebase.InWorldResource, ent)
	ent:SetResourceType(tostring(rType))
	ent:SetResourceAmount(oreamount)

	if IsValid(Minebase.LastUser) then
		ent:CPPISetOwner(Minebase.LastUser)
		zrmine.f.SetOwner(ent, Minebase.LastUser)
	else
		local ply = zrmin.f.GetOwner(Minebase)
		if IsValid(ply) then
			ent:CPPISetOwner(ply)
			zrmine.f.SetOwner(ent, ply)
		end
	end

	return ent
end






function zrmine.f.Minebase_OnTakeDamage(Minebase,dmg)
	Minebase:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["MineEntrance"].EntityHealth

	if (entHealth > 0) then
		Minebase.CurrentHealth = (Minebase.CurrentHealth or entHealth) - damage

		if (Minebase.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Minebase:GetPos())
			Minebase:Remove()
		end
	end
end
