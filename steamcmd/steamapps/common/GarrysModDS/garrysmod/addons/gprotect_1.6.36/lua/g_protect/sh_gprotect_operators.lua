gProtect = gProtect or {config = {}}
gProtect.config = gProtect.config or {}

gProtect.config.ModuleCoordination = {
	["general"] = -3,
	["ghosting"] = 2,
	["damage"] = 3,
	["anticollide"] = 4,
	["spamprotection"] = 5,
	["spawnrestriction"] = 6,
	["toolgunsettings"] = 7,
	["physgunsettings"] = 8,
	["gravitygunsettings"] = 9,
	["canpropertysettings"] = 10,
	["advdupe2"] = 11,
	["miscs"] = 12
}

gProtect.config.ModuleShouldDisplay = {
	["advdupe2"] = function()
		if !AdvDupe2 then return false end
	end,
}

gProtect.config.sortOrders = {
	["general"] = {
		["blacklist"] = 0,
		["remDiscPlyEnt"] = 2,
		["remDiscPlyEntSpecific"] = 3,
		["remOutOfBounds"] = 4,
		["remOutOfBoundsWhitelist"] = 5,
		["protectedFrozenEnts"] = 6,
		["protectedFrozenGroup"] = 7,
		["maxModelSize"] = 8
	},

	["ghosting"] = {
		["enabled"] = 1,
		["ghostColor"] = 2,
		["antiObscuring"] = 3,
		["onPhysgun"] = 4,
		["useBlacklist"] = 5,
		["entities"] = 6,
		["forceUnfrozen"] = 7,
		["forceUnfrozenEntities"] = 8
	},

	["damage"] = {
		["enabled"] = 1,
		["useBlacklist"] = 2,
		["entities"] = 3,
		["blacklistedEntPlayerDamage"] = 4,
		["vehiclePlayerDamage"] = 5,
		["worldPlayerDamage"] = 6,
		["immortalEntities"] = 7,
		["bypassGroups"] = 8,
		["canDamageWorldEntities"] = 9
	},

	["anticollide"] = {
		["enabled"] = 1,
		["notifyStaff"] = 2,
		["protectDarkRPEntities"] = 3,
		["DRPentitiesThreshold"] = 4,
		["DRPentitiesException"] = 5,
		["protectSpawnedEntities"] = 6,
		["entitiesThreshold"] = 7,
		["entitiesException"] = 8,
		["protectSpawnedProps"] = 9,
		["propsThreshold"] = 10,
		["propsException"] = 11,
		["playerPropAction"] = 12,
		["playerPropThreshold"] = 13,
		["useBlacklist"] = 14,
		["ghostEntities"] = 15,
		["specificEntities"] = 16,
		["squaredPhysicsMaxSize"] = 17,
		["squaredPhysicsEnts"] = 18
	},

	["spamprotection"] = {
		["enabled"] = 1,
		["threshold"] = 2,
		["delay"] = 3,
		["action"] = 4,
		["notifyStaff"] = 5,
		["protectProps"] = 6,
		["protectEntities"] = 7,
	},

	["spawnrestriction"] = {
		["enabled"] = 1,
		["propSpawnPermission"] = 2,
		["SENTSpawnPermission"] = 3,
		["SWEPSpawnPermission"] = 4,
		["vehicleSpawnPermission"] = 5,
		["NPCSpawnPermission"] = 6,
		["ragdollSpawnPermission"] = 7,
		["effectSpawnPermission"] = 8,
		["blockedSENTs"] = 9,
		["blockedEntityIsBlacklist"] = 10,
		["blockedModels"] = 11,
		["blockedModelsisBlacklist"] = 12,
		["blockedModelsVehicleBypass"] = 13,
		["bypassGroups"] = 14,
		["maxPropModelComplexity"] = 15
	},

	["toolgunsettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["targetPlayerOwnedProps"] = 4,
		["restrictTools"] = 5,
		["groupToolRestrictions"] = 6,
		["entityTargetability"] = 7,
		["bypassTargetabilityTools"] = 8,
		["bypassGroups"] = 9,
		["antiSpam"] = 10
	},

	["physgunsettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["targetPlayerOwnedProps"] = 4,
		["DisableReloadUnfreeze"] = 5,
		["PickupVehiclePermission"] = 6,
		["StopMotionOnDrop"] = 7,
		["blockMultiplePhysgunning"] = 8,
		["maxDropObstructs"] = 9,
		["maxDropObstructsAction"] = 10,
		["blockedEntities"] = 11,
		["bypassGroups"] = 12
	},

	["gravitygunsettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["targetPlayerOwnedProps"] = 4,
		["DisableGravityGunPunting"] = 5,
		["blockedEntities"] = 6,
		["bypassGroups"] = 7
	},

	["canpropertysettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["targetPlayerOwnedProps"] = 4,
		["blockedProperties"] = 5,
		["blockedPropertiesisBlacklist"] = 6,
		["blockedEntities"] = 7,
		["bypassGroups"] = 8
	},

	["advdupe2"] = {
		["enabled"] = 1,
		["notifyStaff"] = 2,
		["PreventRopes"] = 3,
		["PreventScaling"] = 4,
		["PreventNoGravity"] = 5,
		["PreventTrail"] = 6,
		["PreventUnreasonableValues"] = 7,
		["PreventUnfreezeAll"] = 8,
		["BlacklistedCollisionGroups"] = 9,
		["WhitelistedConstraints"] = 10,
		["DelayBetweenUse"] = 11
	},

	["miscs"] = {
		["enabled"] = 1,
		["ClearDecals"] = 2,
		["blacklistedFadingDoorMats_punishment"] = 3,
		["blacklistedFadingDoorMats"] = 4,
		["FadingDoorLag"] = 5,
		["DisableReloadUnfreeze"] = 6,
		["DisableMotion"] = 7,
		["DisableMotionEntities"] = 8,
		["DisableGravityGunPunting"] = 9,
		["freezeOnSpawn"] = 10,
		["preventFadingDoorAbuse"] = 11,
		["preventSpawnNearbyPlayer"] = 12,
		["DRPEntForceOwnership"] = 13,
		["DRPMaxObstructsOnPurchaseEnts"] = 14,
		["DRPObstructsFilter"] = 15
	}
}

local function getEntitiesList()
	local tbl = {
		["prop_physics"] = true,
		["prop_physics_multiplayer"] = true,
		["prop_vehicle_jeep"] = true
	}

	for k,v in pairs(scripted_ents.GetList()) do
		tbl[v.ClassName or k] = true
	end
	
	return tbl
end

local function getUsergroups()
	local tbl = {}

	if CAMI and CAMI.GetUsergroups then for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end end

	return tbl
end

local function getTools()
	local tbl = {}

	for k,v in pairs(spawnmenu.GetTools()) do
		for i,z in pairs(v.Items) do
			for key, data in pairs(z) do
				if istable(data) and data.ItemName then
					if data.ItemName ~= string.lower(data.ItemName) then continue end
					tbl[data.ItemName] = true
				end
			end
		end
	end
	
	return tbl
end

local function getProperties()
	local tbl = {
		["ignite"] = true
	}

	module( "properties", package.seeall )
	
	for k,v in pairs(List) do tbl[k] = true end

	return tbl
end

gProtect.config.valueRules = { --- This is because the tableviewer is modular and coded to be as efficient as possible hence its structure.76561198166995699
	["general"] = {
		["blacklist"] = {tableAlternatives = getEntitiesList},
		["notifyType"] = {intLimit = {min = 0, max = 2}},
		["remDiscPlyEnt"] = {intLimit = {min = -1, max = 999}},
		["remDiscPlyEntSpecific"] = {customTable = "int", tableAlternatives = getEntitiesList},
		["remOutOfBounds"] = {intLimit = {min = -1, max = 999}},
		["remOutOfBoundsWhitelist"] = {customTable = "int", tableAlternatives = getEntitiesList},
		["protectedFrozenEnts"] = {tableAlternatives = getEntitiesList},
		["maxModelSize"] = {intLimit = {min = 0, max = 100000}}
	},
	["ghosting"] = {
		["entities"] = {tableAlternatives = getEntitiesList},
		["forceUnfrozenEntities"] = {tableAlternatives = getEntitiesList},
		["antiObscuring"] = {tableAlternatives = getEntitiesList}
	},
	["damage"] = {
		["entities"] = {tableAlternatives = getEntitiesList},
		["immortalEntities"] = {tableAlternatives = getEntitiesList},
		["bypassGroups"] = {tableAlternatives = getUsergroups},
		["canDamageWorldEntities"] = {tableAlternatives = getUsergroups},
	},
	["anticollide"] = {
		["ghostEntities"] = {tableAlternatives = getEntitiesList},
		["threshold"] = {intLimit = {min = 0, max = 100000}},
		["delay"] = {intLimit = {min = 0, max = 30}},
		["action"] = {intLimit = {min = 1, max = 3}},
		["exception"] = {intLimit = {min = 0, max = 2}},
		["protectDarkRPEntities"] = {intLimit = {min = 0, max = 4}},
		["protectSpawnedEntities"] = {intLimit = {min = 0, max = 3}},
		["protectSpawnedProps"] = {intLimit = {min = 0, max = 3}},
		["specificEntities"] = {customTable = "int", tableAlternatives = getEntitiesList},
		["squaredPhysicsEnts"] = {tableAlternatives = getEntitiesList},
		["playerPropAction"] = {intLimit = {min = 0, max = 4}},
	},
	["spamprotection"] = {
		["threshold"] = {intLimit = {min = 0, max = 100000}},
		["delay"] = {intLimit = {min = 0, max = 30}},
		["action"] = {intLimit = {min = 0, max = 2}}
 	},
	["spawnrestriction"] = {
		["blockedSENTs"] = {tableAlternatives = getEntitiesList},
		["bypassGroups"] = {tableAlternatives = getUsergroups},
		["propSpawnPermission"] = {tableAlternatives = getUsergroups},
		["SENTSpawnPermission"] = {tableAlternatives = getUsergroups},
		["SWEPSpawnPermission"] = {tableAlternatives = getUsergroups},
		["vehicleSpawnPermission"] = {tableAlternatives = getUsergroups},
		["NPCSpawnPermission"] = {tableAlternatives = getUsergroups},
		["ragdollSpawnPermission"] = {tableAlternatives = getUsergroups},
		["effectSpawnPermission"] = {tableAlternatives = getUsergroups},
		["maxPropModelComplexity"] = {intLimit = {min = 0, max = 100}}
	},
	["toolgunsettings"] = {
		["restrictTools"] = {tableAlternatives = getTools},
		["groupToolRestrictions"] = {addRules = {list = {}, isBlacklist = true}, toggleableValue = "isBlacklist", tableDeletable = true, undeleteableTable = "list", tableAlternatives = getTools},
		["entityTargetability"] = {tableAlternatives = getEntitiesList, toggleableValue = "isBlacklist", onlymodifytable = true},
		["targetWorld"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwned"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwnedProps"] = {tableAlternatives = getUsergroups},
		["blockedEntities"] = {tableAlternatives = getEntitiesList},
		["bypassTargetabilityTools"] = {tableAlternatives = getTools},
		["bypassGroups"] = {tableAlternatives = getUsergroups},
		["antiSpam"] = {customTable = "int", tableAlternatives = getTools},

	},
	["physgunsettings"] = {
		["targetWorld"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwned"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwnedProps"] = {tableAlternatives = getUsergroups},
		["maxDropObstructs"] = {intLimit = {min = 0, max = 10000}},
		["maxDropObstructsAction"] = {intLimit = {min = 1, max = 3}},
		["blockedEntities"] = {tableAlternatives = getEntitiesList},
		["bypassGroups"] = {tableAlternatives = getUsergroups},
		["PickupVehiclePermission"] = {tableAlternatives = getUsergroups}
	},
	["gravitygunsettings"] = {
		["targetWorld"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwned"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwnedProps"] = {tableAlternatives = getUsergroups},
		["blockedEntities"] = {tableAlternatives = getEntitiesList},
		["bypassGroups"] = {tableAlternatives = getUsergroups}
	},
	["canpropertysettings"] = {
		["blockedProperties"] = {tableAlternatives = getProperties},
		["targetWorld"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwned"] = {tableAlternatives = getUsergroups},
		["targetPlayerOwnedProps"] = {tableAlternatives = getUsergroups},
		["bypassGroups"] = {tableAlternatives = getUsergroups},
		["blockedEntities"] = {tableAlternatives = getEntitiesList}
	},
	["advdupe2"] = {
		["WhitelistedConstraints"] = {tableAlternatives = {["weld"] = true, ["rope"] = true, ["axis"] = true, ["ballsocket"] = true, ["elastic"] = true, ["hydraulic"] = true, ["motor"] = true, ["muscle"] = true, ["pulley"] = true, ["slider"] = true, ["winch"] = true}},
		["PreventRopes"] = {intLimit = {min = 0, max = 2}},
		["PreventScaling"] = {intLimit = {min = 0, max = 2}},
		["PreventNoGravity"] =  {intLimit = {min = 0, max = 2}},
		["PreventTrail"] =  {intLimit = {min = 0, max = 2}}
	},

	["miscs"] = {
		["ClearDecals"] = {intLimit = {min = 0, max = 1200}},
		["NoBlackoutGlitch"] = {intLimit = {min = 0, max = 3}},
		["DRPEntForceOwnership"] = {tableAlternatives = getEntitiesList},
		["DisableMotionEntities"] = {tableAlternatives = getEntitiesList},
	}
}