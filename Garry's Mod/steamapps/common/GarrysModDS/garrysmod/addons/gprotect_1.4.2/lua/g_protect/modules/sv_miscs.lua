local cfg = gProtect.GetConfig(nil,"miscs")
local blacklist = gProtect.GetConfig("blacklist", "general")

gProtect = gProtect or {}

hook.Add( "CanPlayerUnfreeze", "gP:StopMotion", function(ply, ent)
	if cfg.enabled and cfg.DisableMotion and blacklist[ent:GetClass()] then
		return false
	end
end )

gProtect.HandleMiscToolGun = function(ply, tr, tool)
	if cfg.enabled then
		if tool == "fading_door" and IsValid(tr.Entity) and blacklist[tr.Entity:GetClass()] then
			if cfg.FadingDoorLag then
				local physics = tr.Entity:GetPhysicsObject()
				
				if IsValid(physics) then
					physics:EnableMotion(false)
				end
			end
			
			if cfg.NoBlackoutGlitch > 0 then
				local toolgun = ply:GetTool(tool)
				if toolgun:GetClientInfo("mat") == "pp/copy" then 
					if cfg.NoBlackoutGlitch == 1 then
						gProtect.NotifyStaff(ply, "attempted-blackout")
					elseif cfg.NoBlackoutGlitch == 2 then
						slib.punish(ply, 1, gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "attempted-blackout"))
					elseif cfg.NoBlackoutGlitch == 3 then
						slib.punish(ply, 2, gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "attempted-blackout"))
					end
				return false end
			end
		end
	end
	
	return true
end

hook.Add("PhysgunDrop", "gP:MiscDisableMotion", function(ply, ent)
	if cfg.enabled and cfg.DisableMotion then
		local physics = ent:GetPhysicsObject()
		
		if IsValid(physics) then
			physics:EnableMotion(false)
		end
	end
end)

hook.Add("PlayerSpawnedProp", "gP:MiscHandeler", function(ply, model, ent)
	if cfg.enabled and IsValid(ent) and blacklist[ent:GetClass()] and cfg.DisableMotion then
		local physics = ent:GetPhysicsObject()
		
		if IsValid(physics) then
			physics:EnableMotion(false)
		end
	end
end)

hook.Add("PlayerSpawnProp", "gP:PreventSpawningTooClose", function(ply, model)
	if cfg.enabled then
		if cfg.preventSpawnNearbyPlayer <= 0 then return nil end
		local vStart = ply:GetShootPos()
		local vForward = ply:GetAimVector()

		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + ( vForward * 2048 )
		trace.filter = ply

		local tr = util.TraceLine( trace )

		local sphere = ents.FindInSphere(tr.HitPos, cfg.preventSpawnNearbyPlayer)
		
		for k,v in pairs(sphere) do
			if IsValid(v) and v:IsPlayer() then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "spawn-to-close"), ply) return false end
		end
	end

	return nil
end)

hook.Add("playerBoughtCustomEntity", "gP:HandleOwnershipForcing", function(ply, enttbl, ent, price)
	if cfg.DRPEntForceOwnership[enttbl.ent] then
		gProtect.SetOwner(ply, ent)
	end
end)

hook.Add("gP:NumpadRegistered", "gP:FadingDoorStopper", function(name, func)
	if name == "Fading Door onUp" or name == "Fading Door onDown" then
		local function newfunc(ply, ent)
			if cfg.preventFadingDoorAbuse then
				local obscurants = gProtect.ObscureDetection(ent)
				local prevent = false

				if obscurants and istable(obscurants) then
					for k,v in pairs(obscurants) do
						if v:IsPlayer() then prevent = true break end
					end
				end

				if prevent then return end
			end

			func(ply, ent)
		end

		return newfunc
	end
end)

local setTimer = cfg.ClearDecals

local function gPClearDecals()
	if !cfg.enabled or !cfg.ClearDecals then return end
	if setTimer <= 0 then return end
	
	for k,v in pairs ( player.GetAll() ) do
		v:ConCommand( "r_cleardecals" )
	end
		
	if setTimer ~= cfg.ClearDecals then
		setTimer = cfg.ClearDecals
		timer.Adjust( "gP:onclearDecalsTimer", setTimer, 0, function()
			gPClearDecals()
		end)
	end
end

timer.Create( "gP:onclearDecalsTimer", isnumber(setTimer) and setTimer or 120, 0, function()
	gPClearDecals()
end )

hook.Add("gP:ConfigUpdated", "gP:UpdateMiscs", function(updated)
	if updated ~= "miscs" and updated ~= "general" then return end
	cfg = gProtect.GetConfig(nil,"miscs")
	blacklist = gProtect.GetConfig("blacklist", "general")
end)