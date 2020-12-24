zrush = zrush or {}
zrush.f = zrush.f or {}



// Here we define diffrent effect groups which later make it pretty optimized to create Sound/Particle effects over the network
// The key will be used as the NetworkString
zrush.NetEffectGroups = {
	["module_attached"] = {
		_type = "entity",

		action = function(ent)
			zrush.f.PlayClientAnimation(ent, "plugin", 1.3)

			timer.Simple(1, function()
				if IsValid(ent) then
					ent:EmitSound("zrush_sfx_connect_module")
				end
			end)
		end,
	},
	["module_detached"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_deconnect_module")
		end,
	},

	["barrel_attached"] = {
		_type = "entity",

		action = function(ent)
			zrush.f.PlayClientAnimation(ent, "open", 1)
			ent:EmitSound("zrush_sfx_barrel")

		end,
	},
	["barrel_detached"] = {
		_type = "entity",

		action = function(ent)
			zrush.f.PlayClientAnimation(ent, "close", 1)
			ent:EmitSound("zrush_sfx_barrel")

		end,
	},

	["event_overheat"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_overheat")
		end,
	},

	["action_building"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_build")
		end,
	},
	["action_deconnect"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_deconnect")
		end,
	},
	["action_command"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_command")
		end,
	},
	["action_unjam"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_unjam")
		end,
	},
	["action_cooldown"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_cooldown")
		end,
	},



	["drill_cycle_complete"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_drill_pipedone")

			zrush.f.ParticleEffectAttach("zrush_drillgas", ent, 5)
			zrush.f.ParticleEffectAttach("zrush_drillgas", ent, 6)

		end,
	},
	["drill_anim_drilldown"] = {
		_type = "entity",

		action = function(ent)

			local currentSpeed = zrush.f.ReturnBoostValue("Drill", "speed", ent)
			local drillAnimSpeed = math.Clamp((1 / currentSpeed) * 2, 0, 5)
			zrush.f.PlayClientAnimation(ent, "drilldown", drillAnimSpeed)

		end,
	},
	["drill_anim_idle"] = {
		_type = "entity",

		// Tells the script to play this action on server aswell
		_server = true,

		action = function(ent)
			if SERVER then
				zrush.f.PlayServerAnimation(ent, "idle", 1)
			else
				zrush.f.PlayClientAnimation(ent, "idle", 1)
			end
		end,
	},
	["drill_loadpipe"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_drill_loadpipe")
		end,
	},
	["drill_anim_jammed"] = {
		_type = "entity",

		action = function(ent)

			zrush.f.PlayClientAnimation(ent, "jammed", 3)

		end,
	},

	["burner_anim_burn"] = {
		_type = "entity",

		action = function(ent)
			zrush.f.PlayClientAnimation(ent, "burn", 1)

		end,
	},
	["burner_anim_idle"] = {
		_type = "entity",

		// Tells the script to play this action on server aswell
		_server = true,

		action = function(ent)
			if SERVER then
				zrush.f.PlayServerAnimation(ent, "idle", 1)
			else
				zrush.f.PlayClientAnimation(ent, "idle", 1)
			end
		end,
	},


	["pump_anim_pumping"] = {
		_type = "entity",

		action = function(ent)

			local pumpSpeed = zrush.f.ReturnBoostValue(ent.MachineID, "speed", ent)
			local pumpAnimSpeed = math.Clamp(4 / pumpSpeed, 0, 10)

			zrush.f.PlayClientAnimation(ent, "pump", pumpAnimSpeed)

		end,
	},
	["pump_anim_idle"] = {
		_type = "entity",

		// Tells the script to play this action on server aswell
		_server = true,

		action = function(ent)
			if SERVER then
				zrush.f.PlayServerAnimation(ent, "idle", 1)
			else
				zrush.f.PlayClientAnimation(ent, "idle", 1)
			end
		end,
	},
	["pump_anim_jammed"] = {
		_type = "entity",

		action = function(ent)

			zrush.f.PlayClientAnimation(ent, "jammed", 1.75)

		end,
	},
	["pump_filloil"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_liquidfill")
			zrush.f.ParticleEffectAttach("zrush_barrel_oil_fill", ent, 5)
		end,
	},

	["refinery_fillfuel"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_liquidfill")
			zrush.f.ParticleEffectAttach("zrush_barrel_fuel_fill", ent, 9)
		end,
	},

	["npc_cash"] = {
		_type = "entity",

		action = function(ent)
			ent:EmitSound("zrush_sfx_cash01")
		end,
	},
}

if SERVER then

	// Creates a network string for all the effect groups
	for k, v in pairs(zrush.NetEffectGroups) do
		util.AddNetworkString("zrush_fx_" .. k)
	end

	// Sends a Net Effect Msg to all clients
	function zrush.f.CreateNetEffect(id,data)

		// Data can be a entity or position

		local EffectGroup = zrush.NetEffectGroups[id]

		// Some events should be called on server to
		if EffectGroup._server then
			if EffectGroup._type == "entity" then
				if IsValid(data) then
					EffectGroup.action(data)
				end
			else
				EffectGroup.action(data)
			end
		end


		if EffectGroup._type == "entity" then
			if IsValid(data) then
				net.Start("zrush_fx_" .. id)
				net.WriteEntity(data)
				net.Broadcast()
			end
		else
			net.Start("zrush_fx_" .. id)
			net.WriteVector(data)
			net.Broadcast()
		end
	end
end

if CLIENT then

	for k, v in pairs(zrush.NetEffectGroups) do
		net.Receive("zrush_fx_" .. k, function(len)
			zrush.f.Debug("zrush_fx_" .. k .. " Len: " .. len)

			if v._type == "entity" then
				local ent = net.ReadEntity()

				if IsValid(ent) then

					zrush.NetEffectGroups[k].action(ent)
				end
			else
				local pos = net.ReadVector()
				if pos then
					zrush.NetEffectGroups[k].action(pos)
				end
			end
		end)
	end

	function zrush.f.ParticleEffect(effect, pos, ang, ent)
		if GetConVar("zrush_cl_vfx_particleeffects"):GetInt() == 1 then
			ParticleEffect(effect, pos, ang, ent)
		end
	end

	function zrush.f.ParticleEffectAttach(effect, ent, attachid)
		if GetConVar("zrush_cl_vfx_particleeffects"):GetInt() == 1 then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, attachid)
		end
	end
end
