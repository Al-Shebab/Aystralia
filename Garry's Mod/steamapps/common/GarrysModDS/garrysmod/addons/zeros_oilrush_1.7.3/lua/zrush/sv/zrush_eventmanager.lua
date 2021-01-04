if not SERVER then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

concommand.Add("zrush_ResetEventManager", function(ply, cmd, args)
	if zrush.f.IsAdmin(ply) then
		zrush.f.EventManager_TimerExist()
	end
end)

function zrush.f.EventManager_TimerExist()
	local timerid = "zrush_eventmanager_id"
	zrush.f.Timer_Remove(timerid)
	zrush.f.Timer_Create(timerid, zrush.config.ChaosEvents.Interval, 0, zrush.f.EventManager_TriggerEvent)
end
//hook.Add("InitPostEntity", "a.zrush.InitPostEntity.eventmanager_OnMapLoad", zrush.f.EventManager_TimerExist)
zrush.f.EventManager_TimerExist()

local eventEntity = {
	["zrush_drilltower"] = true,
	["zrush_pump"] = true,
	["zrush_refinery"] = true,
	["zrush_burner"] = true
}
function zrush.f.EventManager_TriggerEvent()
	for k, v in pairs(zrush.EntList) do
		if (IsValid(v) and eventEntity[v:GetClass()]) then
			zrush.f.EventManager_CheckEvent(v)
		end
	end
end

function zrush.f.TableRandomize( t )
	local out = { }

	while #t > 0 do
		table.insert( out, table.remove( t, math.random( #t ) ) )
	end

	return out
end

function zrush.f.EventManager_ReadyForEvent(ent)
	local class = ent:GetClass()

	if class == "zrush_drilltower" then
		return zrush.f.DrillTower_ReadyForEvent(ent)
	elseif class == "zrush_pump" then
		return zrush.f.Pump_ReadyForEvent(ent)
	elseif class == "zrush_refinery" then
		return zrush.f.Refinery_ReadyForEvent(ent)
	elseif class == "zrush_burner" then
		return zrush.f.Burner_ReadyForEvent(ent)
	end
end

function zrush.f.EventManager_CheckEvent(ent)
	//zrush.f.Debug("zrush.f.EventManager_CheckEvent")
	local entClass = ent:GetClass()
	local EventPool = {}

	if zrush.f.EventManager_ReadyForEvent(ent) then
		if ent.NextChaosEvent and CurTime() < ent.NextChaosEvent then return end

		local eventChance
		if (entClass == "zrush_drilltower" or entClass == "zrush_pump") then
			eventChance = math.Round(zrush.f.ReturnBoostValue(ent.MachineID, "antijam", ent))
		elseif (entClass == "zrush_refinery" or entClass == "zrush_burner") then
			eventChance = math.Round(zrush.f.ReturnBoostValue(ent.MachineID, "cooling", ent))
		end

		for i = 1, eventChance do
			table.insert(EventPool, true)
		end

		for i = 1, (100 - eventChance) do
			table.insert(EventPool, false)
		end

		EventPool = zrush.f.TableRandomize(EventPool)

		if table.Random(EventPool) then
			ent.NextChaosEvent = CurTime() + zrush.config.ChaosEvents.Cooldown

			if (entClass == "zrush_drilltower" or entClass == "zrush_pump") then
				zrush.f.JamEvent(ent)
			elseif (entClass == "zrush_refinery" or entClass == "zrush_burner") then
				zrush.f.HeatEvent(ent)
			end
		end
	end
end

function zrush.f.JamEvent(ent)
	zrush.f.Debug("JamEvent (" .. ent:EntIndex() .. ")")

	local class = ent:GetClass()

	if class == "zrush_drilltower" then
		zrush.f.DrillTower_JamMachine(ent)
	elseif class == "zrush_pump" then
		zrush.f.Pump_JamMachine(ent)
	end
end

function zrush.f.HeatEvent(ent)
	zrush.f.Debug("HeatEvent (" .. ent:EntIndex() .. ")")
	local class = ent:GetClass()

	if class == "zrush_refinery" then
		zrush.f.Refinery_OverHeatMachine(ent)
	elseif class == "zrush_burner" then
		zrush.f.Burner_OverHeatMachine(ent)
	end
end
