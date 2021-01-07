local cfg = gProtect.GetConfig(nil,"toolgunsettings")

gProtect = gProtect or {}

gProtect.HandleToolgunPermissions = function(ply, tr, tool)
    if cfg.enabled then
        local ent = tr.Entity
        local owner = gProtect.GetOwner(ent)

        if !owner then
            local result = ent:GetNWString("gPOwner", "")
            owner = (string.find(result, "STEAM") and "Disconnected") or "World"
        end
        
        local usergroup = ply:GetUserGroup()

        if !cfg.groupToolRestrictions[usergroup] and !cfg.bypassGroups[usergroup] and cfg.groupToolRestrictions["default"] then usergroup = "default" end

        if cfg.entityTargetability and cfg.entityTargetability["list"] and !cfg.bypassGroups[usergroup] and IsValid(ent) and !cfg.bypassTargetabilityTools[tool] then
            if cfg.entityTargetability["isBlacklist"] == tobool(cfg.entityTargetability["list"][ent:GetClass()]) then return false end
        end
        
        if cfg.groupToolRestrictions[usergroup] and cfg.groupToolRestrictions[usergroup]["list"] then
            if cfg.groupToolRestrictions[usergroup]["isBlacklist"] == tobool(cfg.groupToolRestrictions[usergroup]["list"][tool]) then return false end
        end

        if cfg.restrictTools[tool] and !cfg.bypassGroups[usergroup] then
            return false
        end

        if !isstring(owner) and IsValid(owner) and owner:IsPlayer() or owner == "Disconnected" then
            if cfg.targetPlayerOwned["*"] or cfg.targetPlayerOwned[usergroup] then return true end
        end
       
        if ent:IsWorld() then
            return nil
        end

        if owner == "World" then
            if cfg.targetWorld["*"] or cfg.targetWorld[usergroup] then return true end

            return false
        end
    end
end

hook.Add("gP:ConfigUpdated", "gP:UpdateToolgunSettings", function(updated)
    if updated ~= "toolgunsettings" then return end
	cfg = gProtect.GetConfig(nil,"toolgunsettings")
end)