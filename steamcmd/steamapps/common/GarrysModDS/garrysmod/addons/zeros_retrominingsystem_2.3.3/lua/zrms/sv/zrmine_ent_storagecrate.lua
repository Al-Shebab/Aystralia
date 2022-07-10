if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.StorageCrate_Initialize(StorageCrate)

	StorageCrate.BarCount = 0
	StorageCrate.wait = false

	zrmine.f.EntList_Add(StorageCrate)
end

function zrmine.f.StorageCrate_Close(StorageCrate)
	StorageCrate.wait = true
	StorageCrate:SetIsClosed(true)

	timer.Simple(0.8, function()
		if (IsValid(StorageCrate)) then

			StorageCrate.wait = false
		end
	end)
end

function zrmine.f.StorageCrate_AddBar(StorageCrate,bar)

	if zrmine.config.SharedOwnership == false and zrmine.f.OwnerID_Check(StorageCrate,bar) == false then return end

	bar.zrms_added = true

	if (bar:GetMetalType() == "Iron") then
		StorageCrate:SetbIron(StorageCrate:GetbIron() + 1)
	elseif (bar:GetMetalType() == "Bronze") then
		StorageCrate:SetbBronze(StorageCrate:GetbBronze() + 1)
	elseif (bar:GetMetalType() == "Silver") then
		StorageCrate:SetbSilver(StorageCrate:GetbSilver() + 1)
	elseif (bar:GetMetalType() == "Gold") then
		StorageCrate:SetbGold(StorageCrate:GetbGold() + 1)
	end

	StorageCrate.BarCount = StorageCrate.BarCount + 1

	SafeRemoveEntityDelayed(bar,0.01)

	if (StorageCrate.BarCount >= 12) then
		zrmine.f.StorageCrate_Close(StorageCrate)
	end
end

function zrmine.f.StorageCrate_Use(StorageCrate, ply)
	if (zrmine.f.Player_IsMiner(ply) and zrmine.f.CanSteal(ply,StorageCrate)) then
		if (StorageCrate.wait) then return end

		if (zrmine.config.StorageCrateFull and StorageCrate.BarCount < 12) then
			zrmine.f.Notify(ply, zrmine.language.StorageCrate_NotFull, 1)

			return
		end

		if (StorageCrate:GetIsClosed()) then
			if (StorageCrate:GetbIron() > 0) then
				ply:zrms_AddMetalBar("Iron", StorageCrate:GetbIron())
			end

			if (StorageCrate:GetbBronze() > 0) then
				ply:zrms_AddMetalBar("Bronze", StorageCrate:GetbBronze())
			end

			if (StorageCrate:GetbSilver() > 0) then
				ply:zrms_AddMetalBar("Silver", StorageCrate:GetbSilver())
			end

			if (StorageCrate:GetbGold() > 0) then
				ply:zrms_AddMetalBar("Gold", StorageCrate:GetbGold())
			end

			zrmine.f.Notify(ply, zrmine.language.StorageCrate_Collect, 0)
			StorageCrate:Remove()
		end

		if (StorageCrate.BarCount < 12 and zrmine.config.StorageCrateFull == false) then
			if (StorageCrate.BarCount > 0) then
				if (StorageCrate:GetIsClosed() == false) then
					zrmine.f.StorageCrate_Close(StorageCrate)
				end
			else
				zrmine.f.Notify(ply, zrmine.language.StorageCrate_NeedMetalBar, 1)
			end
		end
	else
		zrmine.f.Notify(ply, zrmine.language.WrongJob, 1)
	end
end



// Storagechest Despawner
zrmine.DroppedChests = {}

function zrmine.f.AddDroppedChest(ent)
	ent.DeSpawnTime = CurTime() + 60
	table.insert(zrmine.DroppedChests,ent)
end


// This handles the removal of Storage Chest that get dropped when a player dies
function zrmine.f.StorageCrate_TimerExist()
	if zrmine.config.MetalBar_DropOnDeath then

		zrmine.f.Timer_Remove("zrmine_chestdespawner_id")
		zrmine.f.Timer_Create("zrmine_chestdespawner_id", 10, 0, zrmine.f.DespawnCheck)
	end
end
timer.Simple(1,function()
    zrmine.f.StorageCrate_TimerExist()
end)

function zrmine.f.DespawnCheck()
	for k, v in pairs(zrmine.DroppedChests) do
		if (IsValid(v) and CurTime() > v.DeSpawnTime) then
			v:Remove()
		end
	end
end
