if not SERVER then return end
zrush = zrush or {}
zrush.f = zrush.f or {}
zrush.MachineActions = zrush.MachineActions or {}

util.AddNetworkString("zrush_OpenMachineUI_net")
util.AddNetworkString("zrush_CloseMachineUI_net")
util.AddNetworkString("zrush_ForceCloseMachineUI_net")
util.AddNetworkString("zrush_PurchaseModule_net")
util.AddNetworkString("zrush_SellModule_net")
util.AddNetworkString("zrush_TransactionComplete_net")
util.AddNetworkString("zrush_PerformAction_net")
util.AddNetworkString("zrush_ChangeFuel_net")

local EntityActionClasses = {
	["zrush_drilltower"] = true,
	["zrush_burner"] = true,
	["zrush_pump"] = true,
	["zrush_refinery"] = true
}

net.Receive("zrush_PurchaseModule_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()
	local moduleID = net.ReadInt(16)
	local PurchaseModuleData = zrush.AbilityModules[moduleID]

	if PurchaseModuleData == nil then return end

	if (IsValid(ent) and zrush.f.IsOwner(ply, ent) and EntityActionClasses[ent:GetClass()]) then

		// Add checks for disdtance
		if zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 300) == false then
			zrush.f.Notify(ply, zrush.language.VGUI["TooFarAway"], 1)

			return
		end


		// Does the player have the correct Rank do buy this module?
		if zrush.f.HasAllowedRank(ply, PurchaseModuleData.ranks) == false then
			zrush.f.Notify(ply, zrush.language.VGUI["WrongUserGroup"], 1)

			return
		end


		// Does the player have the correct Job do buy this module?
		if (zrush.f.HasAllowedJob(ply, PurchaseModuleData.jobs) == false) then
			zrush.f.Notify(ply, zrush.language.VGUI["WrongJob"], 1)

			return
		end


		// Check if the player has enough money
		local moduleCost = PurchaseModuleData.price
		if (not zrush.f.HasMoney(ply, moduleCost)) then
			zrush.f.Notify(ply, zrush.language.VGUI["Youcannotafford"], 1)

			return
		end

		// Check if module of same type is allready installed
		local mType = PurchaseModuleData.type
		if (zrush.f.Machine_HasModuleTypeInstalled(ent, mType)) then
			zrush.f.Notify(ply, zrush.language.VGUI[mType] .. zrush.language.VGUI["allreadyinstalled"], 1)

			return
		end

		// This checks if there is a freeSocket for the module
		local freeSocket = zrush.f.Machine_SearchFreeSocket(ent)

		if (freeSocket) then
			// Takes some money from the player
			zrush.f.TakeMoney(ply, moduleCost)

			zrush.f.Machine_AddModule(moduleID, ent, freeSocket)

			local str = zrush.language.VGUI["Youbougt"]
			str = string.Replace(str, "$Name", PurchaseModuleData.name)
			str = string.Replace(str, "$Price", PurchaseModuleData.price)
			str = string.Replace(str, "$Currency", zrush.config.Currency)
			zrush.f.Notify(ply, str, 0)

			zrush.f.CreateNetEffect("npc_cash",ent)

			timer.Simple(0.1, function()
				net.Start("zrush_TransactionComplete_net")
				net.WriteEntity(ent)
				net.WriteTable(zrush.f.Machine_ReturnInstalledModules(ent))
				net.Broadcast()
			end)
		else
			zrush.f.Notify(ply, zrush.language.General["NoFreeSocketAvailable"], 1)
		end
	end
end)

net.Receive("zrush_SellModule_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()
	local moduleID = net.ReadInt(16)

	if (IsValid(ent) and zrush.f.IsOwner(ply, ent) and EntityActionClasses[ent:GetClass()]) then
		// Add checks for disdtance
		if zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 300) == false then
			zrush.f.Notify(ply, zrush.language.VGUI["TooFarAway"], 1)

			return
		end

		// This checks if there is a module with this id installed
		local ModuleKeyPos = zrush.f.Machine_FindModuleOnEntityByID(ent, moduleID)

		if (ModuleKeyPos) then
			zrush.f.Machine_RemoveModule(ent, ent.ModuleSocket[ModuleKeyPos])
			local mData = zrush.AbilityModules[moduleID]
			local earning = mData.price * zrush.config.SellValue

			// Give the player the Cash
			zrush.f.GiveMoney(ply, earning)

			local str = zrush.language.VGUI["YouSold"]
			str = string.Replace(str, "$Name", mData.name)
			str = string.Replace(str, "$Price", tostring(earning))
			str = string.Replace(str, "$Currency", zrush.config.Currency)
			zrush.f.Notify(ply, str, 0)

			zrush.f.CreateNetEffect("npc_cash",ply)

			timer.Simple(0.1, function()
				net.Start("zrush_TransactionComplete_net")
				net.WriteEntity(ent)
				net.WriteTable(zrush.f.Machine_ReturnInstalledModules(ent))
				net.Broadcast()
			end)
		end
	end
end)

// This returns the index if there is a module with this id installed
function zrush.f.Machine_FindModuleOnEntityByID(ent, id)
	local tModule

	for k, v in pairs(ent.ModuleSocket) do
		if (IsValid(v.Module) and v.ModuleID == id) then
			zrush.f.Debug("Entity has module with ID: " .. id)
			tModule = k
			break
		end
	end

	return tModule
end

// This searches for a free module spot on out entity
function zrush.f.Machine_SearchFreeSocket(ent)
	local freeSocket

	for k, v in pairs(ent.ModuleSocket) do
		if (not IsValid(v.Module)) then
			zrush.f.Debug("Found Empty Socket on position " .. k .. " with attachmentPoint " .. tostring(v.attachpoint))
			freeSocket = k
			break
		end
	end

	return freeSocket
end

// This checks if we allready have a module of that type installed
function zrush.f.Machine_HasModuleTypeInstalled(ent, mtype)
	local IsInstalled = false

	for k, v in pairs(ent.ModuleSocket) do
		if IsValid(v.Module) then

			local moduleType = zrush.AbilityModules[v.ModuleID].type

			if (moduleType == mtype) then
				IsInstalled = true
				break
			end
		end
	end

	return IsInstalled
end

// This returns us a table with all the installed ids
function zrush.f.Machine_ReturnInstalledModules(ent)
	local installedModules = {}

	for k, v in pairs(ent.ModuleSocket) do
		if (IsValid(v.Module)) then
			table.insert(installedModules, v.ModuleID)
		end
	end

	return installedModules
end

// This creates a Module on a machine
function zrush.f.Machine_AddModule(moduleID, ent, freeSocketID)
	local freeSocket = ent.ModuleSocket[freeSocketID]
	local moduledata = zrush.AbilityModules[moduleID]

	local attach = ent:GetAttachment(freeSocket.attachpoint)
	local aModule = ents.Create("zrush_module")
	aModule:SetPos(attach.Pos + attach.Ang:Up() * 3)
	local ang = attach.Ang
	ang:RotateAroundAxis(attach.Ang:Right(), 180)
	ang:RotateAroundAxis(attach.Ang:Up(), -180)

	aModule:SetAngles(ang)
	aModule:Spawn()
	aModule:Activate()
	aModule:SetNoDraw(true)
	aModule:SetParent(ent, freeSocket.attachpoint)
	aModule:SetAbilityID(moduleID)

	freeSocket.ModuleID = moduleID
	freeSocket.Module = aModule

	local mType = moduledata.type
	if (mType == "speed") then
		ent:SetSpeedBoost(moduledata.amount)
	elseif (mType == "production") then
		ent:SetProductionBoost(moduledata.amount)
	elseif (mType == "antijam") then
		ent:SetAntiJamBoost(moduledata.amount)
	elseif (mType == "cooling") then
		ent:SetCoolingBoost(moduledata.amount)
	elseif (mType == "pipes") then
		ent:SetExtraPipes(moduledata.amount)
	elseif (mType == "refining") then
		ent:SetRefineBoost(moduledata.amount)
	end

	timer.Simple(0.1, function()
		if IsValid(aModule) then
			aModule:SetNoDraw(false)
			zrush.f.CreateNetEffect("module_attached", aModule)
		end
	end)

	zrush.f.Machine_ModulesChanged(ent)
end

// Here is some stuff we do when applying a new Module to a machine
function zrush.f.Machine_ModulesChanged(ent)
	local class = ent:GetClass()

	if class == "zrush_burner" then
		zrush.f.Burner_ModulesChanged(ent)
	elseif class == "zrush_drilltower" then
		zrush.f.DrillTower_ModulesChanged(ent)
	elseif class == "zrush_refinery" then
		zrush.f.Refinery_ModulesChanged(ent)
	elseif class == "zrush_pump" then
		zrush.f.Pump_ModulesChanged(ent)
	end
end

// This removes a Module from a machine
function zrush.f.Machine_RemoveModule(ent, moduleSocket)
	local moduledata = zrush.AbilityModules[moduleSocket.ModuleID]
	local mType = moduledata.type

	if (mType == "speed") then
		ent:SetSpeedBoost(0)
	elseif (mType == "production") then
		ent:SetProductionBoost(0)
	elseif (mType == "antijam") then
		ent:SetAntiJamBoost(0)
	elseif (mType == "cooling") then
		ent:SetCoolingBoost(0)
	elseif (mType == "pipes") then
		ent:SetExtraPipes(0)
	elseif (mType == "refining") then
		ent:SetRefineBoost(0)
	end

	moduleSocket.ModuleID = -1
	SafeRemoveEntity(moduleSocket.Module)
	moduleSocket.Module = nil
	zrush.f.CreateNetEffect("module_detached",ent)

	zrush.f.Machine_ModulesChanged(ent)
end

net.Receive("zrush_PerformAction_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()
	local actionID = net.ReadInt(16)

	if (IsValid(ent) and EntityActionClasses[ent:GetClass()]) then

		// Add checks for disdtance, is allowed etc
		if zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 300) == false then
			zrush.f.Notify(ply, zrush.language.VGUI["TooFarAway"], 1)

			return
		end

		zrush.MachineActions[actionID](ply, ent)
	end
end)

zrush.MachineActions = {
	// DeConstruct the Machine
	[1] = function(ply, ent)
		if (not zrush.f.IsOwner(ply, ent)) then
			zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)

			return
		end

		zrush.f.CreateNetEffect("action_deconnect",ent)
		zrush.f.Machine_Deconstruct(ent)
	end,

	// UnJam the Machine
	[2] = function(ply, ent)
		zrush.f.CreateNetEffect("action_unjam",ent)
		zrush.f.Machine_Repair(ent)
	end,

	// CoolDown the Machine
	[3] = function(ply, ent)
		zrush.f.CreateNetEffect("action_cooldown",ent)
		zrush.f.Machine_CoolDown(ent)
	end,

	// Start the Machine Working
	[4] = function(ply, ent)
		if (not zrush.f.IsOwner(ply, ent)) then
			zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)

			return
		end

		zrush.f.Machine_Toggle(ent,ply)
	end,

	// Stop the Machine Working
	[5] = function(ply, ent)
		if (not zrush.f.IsOwner(ply, ent)) then
			zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)

			return
		end

		zrush.f.Machine_Toggle(ent,ply)
	end
}

function zrush.f.Machine_Deconstruct(ent)
	local class = ent:GetClass()

	if class == "zrush_burner" then
		zrush.f.Burner_DeConstruct(ent)
	elseif class == "zrush_drilltower" then
		zrush.f.DrillTower_DeConstruct(ent)
	elseif class == "zrush_refinery" then
		zrush.f.Refinery_DeConstruct(ent)
	elseif class == "zrush_pump" then
		zrush.f.Pump_DeConstruct(ent)
	end
end

function zrush.f.Machine_Toggle(ent,ply)
	local class = ent:GetClass()

	if class == "zrush_drilltower" then
		zrush.f.DrillTower_ToggleMachineWork(ent,ply)
	elseif class == "zrush_refinery" then
		zrush.f.Refinery_ToggleMachineWork(ent,ply)
	elseif class == "zrush_pump" then
		zrush.f.Pump_ToggleMachineWork(ent,ply)
	end
end

function zrush.f.Machine_CoolDown(ent)
	local class = ent:GetClass()

	if class == "zrush_burner" then
		zrush.f.Burner_CoolDownMachine(ent)
	elseif class == "zrush_refinery" then
		zrush.f.Refinery_CoolDownMachine(ent)
	end
end

function zrush.f.Machine_Repair(ent)
	local class = ent:GetClass()

	if class == "zrush_drilltower" then
		zrush.f.DrillTower_UnJamMachine(ent)
	elseif class == "zrush_pump" then
		zrush.f.Pump_UnJamMachine(ent)
	end
end

net.Receive("zrush_ChangeFuel_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()
	local fuelID = net.ReadInt(16)

	if (IsValid(ent) and ent:GetClass() == "zrush_refinery") then
		if (not zrush.f.IsOwner(ply, ent)) then
			zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)

			return
		end

		// Add checks for disdtance, have money, is allowed etc
		if zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 300) == false then
			zrush.f.Notify(ply, zrush.language.VGUI["TooFarAway"], 1)

			return
		end

		if zrush.f.HasAllowedRank(ply, zrush.Fuel[fuelID].ranks) then
			zrush.f.Refinery_ChangeFuel(ent, fuelID)
		else
			zrush.f.Notify(ply, zrush.language.VGUI["WrongUserGroup"], 1)
		end
	end
end)
