if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

//Init
function zrmine.f.OreSpawn_Initialize(OreSpawn)
	zrmine.f.EntList_Add(OreSpawn)

	zrmine.f.OreSpawn_UpdateVisual(OreSpawn)
end


// Main logic
function zrmine.f.OreSpawn_HasResource(OreSpawn)
	if (OreSpawn:GetResourceAmount() > 0) then
		return true
	else
		return false
	end
end

function zrmine.f.OreSpawn_DecreaseOre(OreSpawn,amount)
	local newAmount = OreSpawn:GetResourceAmount() - amount

	if (newAmount < 0) then
		newAmount = 0
	end

	OreSpawn:SetResourceAmount(newAmount)

	zrmine.f.CreateNetEffect("orespawn_decrease",OreSpawn)
end

function zrmine.f.OreSpawn_RefreshOre(OreSpawn)
	local cur_res = OreSpawn:GetResourceAmount()
	local max_res = OreSpawn:GetMax_ResourceAmount()
	if cur_res < max_res then

		local increaseAmount = cur_res + zrmine.config.Ore_RefreshAmount
		OreSpawn:SetResourceAmount(math.Clamp(increaseAmount,0,max_res))

		zrmine.f.CreateNetEffect("orespawn_refresh",OreSpawn)

		zrmine.f.OreSpawn_UpdateVisual(OreSpawn)
	end
end

function zrmine.f.OreSpawn_GetRandomOre()
	local OreChancePool = {}

	for k, v in pairs(zrmine.config.Mine_ResourceChance) do
		for i = 1, v do
			table.insert(OreChancePool, k)
		end
	end

	local failChance = 100 - zrmine.config.Pickaxe_HarvestChance

	if (failChance > 0) then
		for i = 1, (100 - zrmine.config.Pickaxe_HarvestChance) do
			table.insert(OreChancePool, "Nothing")
		end
	end

	return table.Random(OreChancePool)
end

function zrmine.f.OreSpawn_Harvest(OreSpawn, amount)
	local harvestedResourceTable = {}
	local rtype

	if (OreSpawn:GetResourceType() == "Random") then
		rtype = zrmine.f.OreSpawn_GetRandomOre()

		if (rtype ~= "Nothing") then
			harvestedResourceTable[rtype] = amount
			zrmine.f.OreSpawn_DecreaseOre(OreSpawn,amount)
			zrmine.f.CreateInsertEffect(OreSpawn, rtype)
		end
	else
		local OreChancePool = {}
		local failChance = 100 - zrmine.config.Pickaxe_HarvestChance

		if (failChance > 0) then
			for i = 1, (100 - zrmine.config.Pickaxe_HarvestChance) do
				table.insert(OreChancePool, "Nothing")
			end

			for i = 1, zrmine.config.Pickaxe_HarvestChance do
				table.insert(OreChancePool, OreSpawn:GetResourceType())
			end
		end

		rtype = table.Random(OreChancePool)

		if (rtype ~= "Nothing") then
			harvestedResourceTable[rtype] = amount
			zrmine.f.OreSpawn_DecreaseOre(OreSpawn,amount)
			zrmine.f.CreateInsertEffect(OreSpawn, rtype)
		end
	end

	zrmine.f.OreSpawn_UpdateVisual(OreSpawn)

	return harvestedResourceTable
end

function zrmine.f.OreSpawn_UpdateVisual(OreSpawn)
	zrmine.f.Debug("zrmine.f.OreSpawn_UpdateVisual")
	local rType = OreSpawn:GetResourceType()
	local rAmount = OreSpawn:GetResourceAmount()
	local rMaxAmount = OreSpawn:GetMax_ResourceAmount()

	if (rType == "Random") then
		OreSpawn:SetSkin(0)
	elseif (rType == "Iron") then
		OreSpawn:SetSkin(1)
	elseif (rType == "Bronze") then
		OreSpawn:SetSkin(2)
	elseif (rType == "Silver") then
		OreSpawn:SetSkin(3)
	elseif (rType == "Gold") then
		OreSpawn:SetSkin(4)
	elseif (rType == "Coal") then
		OreSpawn:SetSkin(5)
	end

	if (rAmount <= 0) then
		OreSpawn:SetBodygroup(0, 5)
	elseif (rAmount < rMaxAmount * 0.1) then
		OreSpawn:SetBodygroup(0, 4)
	elseif (rAmount < rMaxAmount * 0.25) then
		OreSpawn:SetBodygroup(0, 3)
	elseif (rAmount < rMaxAmount * 0.5) then
		OreSpawn:SetBodygroup(0, 2)
	elseif (rAmount < rMaxAmount * 0.75) then
		OreSpawn:SetBodygroup(0, 1)
	elseif (rAmount <= rMaxAmount) then
		OreSpawn:SetBodygroup(0, 0)
	end
end
// 164285642
// Saving
function zrmine.f.OreSpawn_Save(ply)
	local data = {}

	for u, j in pairs(ents.FindByClass("zrms_ore")) do
		table.insert(data, {
			class = j:GetClass(),
			pos = j:GetPos(),
			ang = j:GetAngles(),
			rtype = j:GetResourceType(),
			ramount = j:GetMax_ResourceAmount()
		})
	end

	if not file.Exists("zrms", "DATA") then
		file.CreateDir("zrms")
	end

	file.Write("zrms/" .. string.lower(game.GetMap()) .. "_OreSpawns" .. ".txt", util.TableToJSON(data))
	zrmine.f.Notify(ply, "Ore Spawner´s have been saved for the map " .. string.lower(game.GetMap()) .. "!", 0)
end

function zrmine.f.OreSpawn_Remove(ply)
	for u, j in pairs(ents.FindByClass("zrms_ore")) do
		if IsValid(j) then
			j:Remove()
		end
	end

	if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_OreSpawns" .. ".txt", "DATA") then
        file.Delete("zrms/" .. string.lower(game.GetMap()) .. "_OreSpawns" .. ".txt")
    end
	zrmine.f.Notify(ply, "Ore Spawner´s have been removed for the map " .. string.lower(game.GetMap()) .. "!", 0)
end

function zrmine.f.OreSpawn_Load()
	if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_OreSpawns" .. ".txt", "DATA") then
		local data = file.Read("zrms/" .. string.lower(game.GetMap()) .. "_OreSpawns" .. ".txt", "DATA")
		data = util.JSONToTable(data)

		for k, v in pairs(data) do
			local oreSpawner = ents.Create("zrms_ore")
			oreSpawner:SetPos(v.pos)
			oreSpawner:SetAngles(v.ang)
			oreSpawner:SetResourceType(v.rtype)
			oreSpawner:SetResourceAmount(v.ramount)
			oreSpawner:SetMax_ResourceAmount(v.ramount)
			oreSpawner:Spawn()
		end

		print("[Zeros Retro MiningSystem] Finished loading OreSpawn entities.")
	else
		print("[Zeros Retro MiningSystem] No map data found for ResourceOre entities. Please place some and do !savezrms to create the data.")
	end
end
hook.Add("InitPostEntity", "a_zrmine_SpawnOreSpawner", zrmine.f.OreSpawn_Load)
hook.Add("PostCleanupMap", "a_zrmine_SpawnOreSpawnerPostCleanUp", zrmine.f.OreSpawn_Load)



//Ore Refresher
function zrmine.f.OreSpawn_Refresh()
	for k, v in pairs(zrmine.EntList) do
		if IsValid(v) and v:GetClass() == "zrms_ore" then
			zrmine.f.OreSpawn_RefreshOre(v)
		end
	end
end

function zrmine.f.OreSpawn_TimerExist()
	zrmine.f.Timer_Remove("zrmine_orerefresher_id")
	if zrmine.config.Ore_Refresh then
		zrmine.f.Timer_Create("zrmine_orerefresher_id", zrmine.config.Ore_Refreshrate, 0, zrmine.f.OreSpawn_Refresh)
	end
end

hook.Add("InitPostEntity", "a_zrmine_spawn_OreRefresh_OnMapLoad", zrmine.f.OreSpawn_TimerExist)
