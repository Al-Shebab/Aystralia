local cfg = gProtect.GetConfig(nil, "spawnrestriction")

gProtect = gProtect or {}

gProtect.HandleSpawnPermission = function(ply, model, type)
    if cfg.enabled then
        local handle = cfg[type]
        local isBlacklist = cfg.blockedModelsisBlacklist
        
        if model then
            model = string.lower(model)

            local result = cfg.blockedModels[model] or false

            if !cfg.bypassGroups[ply:GetUserGroup()] and (isBlacklist == result) and (type ~= "vehicleSpawnPermission" or !cfg.blockedModelsVehicleBypass) then
                slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "model-restricted"), ply)
                return false
            end
        end

        if handle[ply:GetUserGroup()] then
            return true
        elseif handle["*"] then
            return true
        else
            slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "insufficient-permission"), ply)
            return false
        end
    end
end

gProtect.HandleSENTSpawnPermission = function(ply, class)
    if cfg.enabled then
        local blockedclasses = cfg.blockedSENTs
        local result = blockedclasses[class] and blockedclasses[class] or false

        if !cfg.bypassGroups[ply:GetUserGroup()] and (cfg.blockedEntityIsBlacklist == result) then
            slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "classname-restricted"), ply)
            return false
        end
    end
end

hook.Add("PlayerSpawnedProp", "gP:handlePreventComplexity", function(ply, model, ent)
    if cfg.enabled then
        local limit = (cfg.maxPropModelComplexity or 10)

        if limit <= 0 or !IsValid(ent) or cfg.bypassGroups[ply:GetUserGroup()] then return end
        
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            local meshes = #phys:GetMesh()
            local maxs, mins = ent:OBBMaxs(), ent:OBBMins()
            local size = maxs:DistToSqr(mins)

            if (meshes / size) * 100 > limit then
                slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "model-restricted"), ply)
                ent:Remove()
            end
        end
    end
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateSpawnProtection", function(updated)
    if updated ~= "spawnrestriction" then return end
	cfg = gProtect.GetConfig(nil,"spawnrestriction")
end)