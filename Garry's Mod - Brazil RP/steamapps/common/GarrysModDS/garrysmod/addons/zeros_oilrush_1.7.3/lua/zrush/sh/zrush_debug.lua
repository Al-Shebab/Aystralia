zrush = zrush or {}
zrush.f = zrush.f or {}

if SERVER then
	concommand.Add("zrush_debug", function(ply, cmd, args)
		if zrush.f.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()
			local trEnt = tr.Entity

			if (IsValid(trEnt)) then
				print(zrush.f.GetOwner(trEnt):Nick())
			end
		end
	end)

	concommand.Add("zrush_debug_spawn_oil", function(ply, cmd, args)
		if zrush.f.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()

			if tr.HitPos then
				local ent = ents.Create("zrush_barrel")
				ent:SetPos(tr.HitPos)
				ent:Spawn()
				ent:Activate()
				zrush.f.SetOwner(ent, ply)

				zrush.f.Barrel_AddLiquid(ent,"Oil", zrush.config.Machine["Barrel"].Storage)
			end
		end
	end)

	concommand.Add("zrush_debug_spawn_fuel", function(ply, cmd, args)
		if zrush.f.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()

			if tr.HitPos then
				local ent = ents.Create("zrush_barrel")
				ent:SetPos(tr.HitPos)
				ent:Spawn()
				ent:Activate()
				zrush.f.SetOwner(ent, ply)

				zrush.f.Barrel_AddLiquid(ent,math.random(1,table.Count(zrush.Fuel)), zrush.config.Machine["Barrel"].Storage)
			end
		end
	end)
end
