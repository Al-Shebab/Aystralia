local cfg = gProtect.GetConfig(nil,"anticollide")
local blacklist = gProtect.GetConfig("blacklist", "general")

gProtect = gProtect or {}

local collidedCounter = {}
local timeout = {}

hook.Add("playerBoughtCustomEntity", "gP:AntiColliderDarkRP", function(ply, enttable, ent)
	if cfg.enabled and cfg.protectDarkRPEntities > -1 then
		if !IsValid(ent) then return end
		local oldfunc = ent.PhysicsCollide
		local collThreshold = tonumber(cfg.specificEntities[ent:GetClass()] or cfg.DRPentitiesThreshold or 0)
		if collThreshold <= 0 then return end
		ent.PhysicsCollide = function(...)
			if isfunction(oldfunc) then oldfunc(...) end

			if cfg.enabled and cfg.protectDarkRPEntities > -1 then
				local args = {...}

				local collider = args[2].HitEntity

				if IsValid(collider) and IsValid(ent) then
					if cfg.DRPentitiesException == 1 then
						if gProtect.GetOwner(ent) ~= gProtect.GetOwner(collider) then return end
					elseif cfg.DRPentitiesException == 2 then
						if !IsValid(gProtect.GetOwner(collider)) then return end
					end

					if !timeout[ent] then timeout[ent] = CurTime() end
					collidedCounter[ent] = collidedCounter[ent] or 0
					collidedCounter[ent] = collidedCounter[ent] + 1
					if collidedCounter[ent] > collThreshold then
						if cfg.notifyStaff then gProtect.NotifyStaff(ply,"colliding-too-much", 3, ent:GetClass(), collidedCounter[ent]) end
						timer.Simple(0, function()
							if !IsValid(ent) then return end

							if cfg.protectDarkRPEntities == 1 then
								gProtect.GhostHandler(ent, true, true)

								timer.Simple(3, function()
									if !IsValid(ent) then return end
									gProtect.GhostHandler(ent, false, true)
								end)
							elseif cfg.protectDarkRPEntities == 2 then
								local phys = ent:GetPhysicsObject()
								if IsValid(phys) then
									phys:EnableMotion(false)
								end
							elseif cfg.protectDarkRPEntities == 3 then
								ent:Remove()
							elseif cfg.protectDarkRPEntities == 4 then
								ent:Remove()

								if IsValid(ply) and !ent.refunded then
									ent.refunded = true
									ply:addMoney(enttable.price)
								end
							end
						end)
					end
					
					if CurTime() - timeout[ent] >= 1 then
						collidedCounter[ent] = 0
						timeout[ent] = nil
					end
				end
			end
		end
	end
end)

hook.Add("PlayerSpawnedProp", "gP:AntiColliderProp", function(ply, model, ent)
	if cfg.enabled and cfg.protectSpawnedProps > -1 then
		if !IsValid(ent) then return end
		
		local collThreshold = tonumber(cfg.specificEntities[ent:GetClass()] or cfg.propsThreshold or 0)
		if collThreshold <= 0 then return end

		ent:AddCallback( "PhysicsCollide", function( ent, data )
			if cfg.enabled and IsValid(ent) then
				local obstructs = gProtect.ObscureDetection(ent)
				local colliders = {}
				
				local owner = gProtect.GetOwner(ent)
					
				if IsValid(owner) and cfg.playerPropAction > -1 and owner == gProtect.GetOwner(data.HitEntity) then
					owner.gp_curCollissions = owner.gp_curCollissions or 0
					owner.gp_curCollissions = owner.gp_curCollissions + 1

					owner.gp_curCollTimeout = owner.gp_curCollTimeout or CurTime() + 1

					if CurTime() >= owner.gp_curCollTimeout then
						owner.gp_curCollissions = 1
						owner.gp_curCollTimeout = CurTime() + 1
					end

					if owner.gp_curCollissions > cfg.playerPropThreshold then
						local owned_ents = gProtect.GetOwnedEnts(owner)
						if cfg.notifyStaff then gProtect.NotifyStaff(ply,"props-colliding-too-much", 3, owner.gp_curCollissions) end

						timer.Simple(0, function()
							if cfg.playerPropAction == 1 then
								for k,v in pairs(owned_ents) do
									gProtect.GhostHandler(k, true)
								end
							elseif cfg.playerPropAction == 2 then
								for k,v in pairs(owned_ents) do
									if !IsValid(k) then continue end
									local phys = k:GetPhysicsObject()
									if IsValid(phys) then
										phys:EnableMotion(false)
									end
								end
							elseif cfg.playerPropAction == 3 then						
								for k,v in pairs(owned_ents) do
									if !IsValid(k) then continue end
									k:Remove()
								end
							elseif cfg.playerPropAction == 4 then
								for k,v in pairs(owned_ents) do
									gProtect.GhostHandler(k, true, true)
								end

								timer.Simple(3, function()
									for k,v in pairs(owned_ents) do
										gProtect.GhostHandler(k, false, true)
									end
								end)
							end
						end)

						owner.gp_curCollissions = 1
					end
				end

				if cfg.protectSpawnedProps > -1 then
					if cfg.propsException == 1 then
						for k,v in ipairs(obstructs) do
							if owner == gProtect.GetOwner(v) then table.insert(colliders, v) end
						end
					elseif cfg.propsException == 2 then
						for k,v in ipairs(obstructs) do
							if IsValid(gProtect.GetOwner(v)) then table.insert(colliders, v) end
						end
					else
						colliders = obstructs
					end

					table.insert(colliders, ent)

					if !timeout[ent] then timeout[ent] = CurTime() end
					collidedCounter[ent] = collidedCounter[ent] or 0
					collidedCounter[ent] = collidedCounter[ent] + 1
					if collidedCounter[ent] > collThreshold then
						if cfg.notifyStaff then gProtect.NotifyStaff(ply,"colliding-too-much", 3, ent:GetClass(), collidedCounter[ent]) end

						timer.Simple(0, function()
							if !IsValid(ent) then return end						
							if cfg.protectSpawnedProps == 1 then
								for k,v in ipairs(colliders) do
									gProtect.GhostHandler(v, true)
								end
							elseif cfg.protectSpawnedProps == 2 then
								for k,v in ipairs(colliders) do
									local phys = v:GetPhysicsObject()
									if IsValid(phys) then
										phys:EnableMotion(false)
									end
								end
							elseif cfg.protectSpawnedProps == 3 then						
								for k,v in ipairs(colliders) do
									v:Remove()
								end
							end
						end)
					end
					
					if CurTime() - timeout[ent] >= 1 then
						collidedCounter[ent] = 0
						timeout[ent] = nil
					end
				end
			end
		end )
	end
end)

hook.Add("PlayerSpawnedSENT", "gP:AntiColliderEntities", function(ply, ent)
	if cfg.enabled and cfg.protectSpawnedEntities > -1 then
		if !IsValid(ent) then return end
		local oldfunc = ent.PhysicsCollide
		local collThreshold = tonumber(cfg.specificEntities[ent:GetClass()] or cfg.entitiesThreshold or 0)
		if collThreshold <= 0 then return end

		ent.PhysicsCollide = function(...)
			if isfunction(oldfunc) then oldfunc(...) end
			
			if cfg.enabled and cfg.protectSpawnedEntities > -1 then
				local args = {...}

				local collider = args[2].HitEntity

				if IsValid(collider) and IsValid(ent) then					
					if cfg.entitiesException == 1 then
						if gProtect.GetOwner(ent) ~= gProtect.GetOwner(collider) then return end
					elseif cfg.entitiesException == 2 then
						if !IsValid(gProtect.GetOwner(collider)) then return end
					end

					if !timeout[ent] then timeout[ent] = CurTime() end
					collidedCounter[ent] = collidedCounter[ent] or 0
					collidedCounter[ent] = collidedCounter[ent] + 1

					if collidedCounter[ent] > collThreshold then					
						if cfg.notifyStaff then gProtect.NotifyStaff(ply,"colliding-too-much", 3, ent:GetClass(), collidedCounter[ent]) end
						timer.Simple(0, function()
							if !IsValid(ent) then return end

							if cfg.protectSpawnedEntities == 1 then
								gProtect.GhostHandler(ent, true)
							elseif cfg.protectSpawnedEntities == 2 then
								local phys = ent:GetPhysicsObject()
								if IsValid(phys) then
									phys:EnableMotion(false)
								end
							elseif cfg.protectSpawnedEntities == 3 then
								ent:Remove()
							end
						end)
					end

					if CurTime() - timeout[ent] >= 1 then
						collidedCounter[ent] = 0
						timeout[ent] = nil
					end
				end
			end
		end
	end
end)

hook.Add("OnEntityCreated", "gP:RegisterComplexShapes", function(ent)
	if ent:IsWorld() or (cfg.squaredPhysicsMaxSize or 0) <= 0 then return end
	timer.Simple(.1, function()
		if !IsValid(ent) then return end
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			local meshes = #phys:GetMesh()
			local maxs, mins = ent:OBBMaxs(), ent:OBBMins()
			local size = maxs:DistToSqr(mins)

			if (size <= cfg.squaredPhysicsMaxSize and meshes / size > .6) or cfg.squaredPhysicsEnts[ent:GetClass()] then
				ent:PhysicsInitBox(mins, maxs)
				ent:PhysWake()
			end
		end
	end)
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateAntiCollide", function(updated)
	if updated ~= "anticollide" and updated ~= "general" then return end
	blacklist = gProtect.GetConfig("blacklist", "general")
	cfg = gProtect.GetConfig(nil,"anticollide")
end)