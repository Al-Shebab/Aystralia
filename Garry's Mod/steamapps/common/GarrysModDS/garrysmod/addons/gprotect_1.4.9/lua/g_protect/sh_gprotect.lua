gProtect = gProtect or {}
gProtect.language = gProtect.language or {}

local sidlink = {}

gProtect.GetOwner = function(ent)
	if !IsValid(ent) then return end
	local result = ent:GetNWString("gPOwner", "")
	local foundply = player.GetBySteamID( result )
	
	foundply = !isstring(foundply) and (IsValid(foundply) and foundply:IsPlayer() and foundply) or foundply

	return (foundply and foundply) or nil
end

gProtect.HasPermission = function(ply)
	local usergroup = ply:GetUserGroup()

	return gProtect.config.ConfigPermission[usergroup] and gProtect.config.ConfigPermission[usergroup] or CAMI and isfunction(CAMI.PlayerHasAccess) and CAMI.PlayerHasAccess(ply, "gProtect_Settings", function() return false end) or false
end

gProtect.HandlePermissions = function(ply, ent, permission)
	if (!IsValid(ent) and !ent:IsWorld()) or ent:IsPlayer() or !IsValid(ply) or !ply:IsPlayer() then return false end

	local owner = gProtect.GetOwner(ent)
	local weapon = permission and permission or IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or "weapon_physgun"
	local ownsid = isstring(owner) and owner or IsValid(owner) and owner:SteamID() or ""

	if (ply == owner) or (gProtect.TouchPermission and gProtect.TouchPermission[ownsid] and gProtect.TouchPermission[ownsid][weapon] and !isnumber(gProtect.TouchPermission[ownsid][weapon]) and gProtect.TouchPermission[ownsid][weapon][ply:SteamID()]) then
		return true
	end
	
	if gProtect.TouchPermission then
		if owner and IsValid(owner) and owner:IsPlayer() then
			local touchtbl = gProtect.TouchPermission["targetPlayerOwned"] and gProtect.TouchPermission["targetPlayerOwned"][weapon]
			if !touchtbl then return false end
			if touchtbl["*"] or touchtbl[ply:GetUserGroup()] then return true end
		else
			local touchtbl = gProtect.TouchPermission["targetWorld"] and gProtect.TouchPermission["targetWorld"][weapon]
			if !touchtbl then return false end
			if touchtbl["*"] or touchtbl[ply:GetUserGroup()] then return true end
		end
	end
	
	if ent:IsWorld() then return nil end

	return false, true
end

local cfg = SERVER and gProtect.GetConfig(nil, "physgunsettings") or {}

hook.Add("PhysgunPickup", "gP:PhysgunPickupLogic", function(ply, ent, norun)
	if SERVER and !cfg.enabled then return nil end
	if TCF and TCF.Config and ent:GetClass() == "cocaine_cooking_pot" and IsValid( ent:GetParent() ) then return nil end --- Compatibilty with the cocaine factory.

	if ent:IsPlayer() then return nil end

	if SERVER then
		local servercheck = gProtect.HandlePhysgunPermission(ply, ent)
		if isbool(servercheck) then
			local result = false
		
			if servercheck then result = nil end

			return result
		end
	end
	
	return gProtect.HandlePermissions(ply, ent, "weapon_physgun")
end )

hook.Add("gP:ConfigUpdated", "gP:UpdatePhysgunSH", function(updated)
	if updated ~= "physgunsettings" then return end
	cfg = gProtect.GetConfig(nil,"physgunsettings")
end)

if CAMI and isfunction(CAMI.RegisterPrivilege) then CAMI.RegisterPrivilege({Name = "gProtect_Settings", hasAccess = false, callback = function() end}) CAMI.RegisterPrivilege({Name = "gProtect_StaffNotifications", MinAccess = "admin", hasAccess = false, callback = function() end}) end