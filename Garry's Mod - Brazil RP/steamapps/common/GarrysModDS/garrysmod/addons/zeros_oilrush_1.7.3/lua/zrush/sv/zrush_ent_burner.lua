if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.Burner_Initialize(Burner)
	Burner:SetModel("models/zerochain/props_oilrush/zor_drillburner.mdl")
	Burner:PhysicsInit(SOLID_VPHYSICS)
	Burner:SetMoveType(MOVETYPE_VPHYSICS)
	Burner:SetSolid(SOLID_VPHYSICS)
	Burner:SetUseType(SIMPLE_USE)

	if (zrush.config.Machine_NoCollide) then
		Burner:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	local phys = Burner:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
		phys:SetMass(150)
	end

	Burner:UseClientSideAnimation()
	Burner.PhysgunDisabled = true
	zrush.f.CreateSockets(Burner)

	Burner.NextChaosEvent = CurTime() + zrush.config.ChaosEvents.Cooldown


	zrush.f.EntList_Add(Burner)
end

// Called when a player presses e on the burner
function zrush.f.Burner_OnUse(Burner,ply)
	if (Burner.Wait or false) then return end

	net.Start("zrush_OpenMachineUI_net")
	net.WriteEntity(Burner)
	net.WriteTable(zrush.f.Machine_ReturnInstalledModules(Burner))
	net.Send(ply)

	zrush.f.CreateNetEffect("action_command",Burner)
end

// Called when the Burner gets damaged
function zrush.f.Burner_OnTakeDamage(Burner, dmg)
	if not Burner.m_bApplyingDamage then
		Burner.m_bApplyingDamage = true

		Burner:TakePhysicsDamage(dmg)
		local damage = dmg:GetDamage()
		local entHealth = zrush.config.Machine["Burner"].Health

		if (entHealth > 0) then
			Burner.CurrentHealth = (Burner.CurrentHealth or entHealth) - damage

			if (Burner.CurrentHealth <= 0) then

				// This deletes the oilspot and the drillhole
				local hole = Burner:GetHole()

				if (IsValid(hole)) then
					local OilSpot = hole.OilSpot

					if (IsValid(OilSpot)) then
						zrush.f.Oilspot_Remove(OilSpot)
					end
				end

				zrush.f.EntityExplosion(Burner, "Burner", true)
			end
		end

		Burner.m_bApplyingDamage = false
	end
end

function zrush.f.Burner_OnRemove(Burner)
	zrush.f.EntList_Remove(Burner)
end

// This gets called if a new module is installed
function zrush.f.Burner_ModulesChanged(Burner)

	// This resets the burn timer do be sure he has the right time if a speed module got installed
	zrush.f.Burner_BurnGasCycle_Start(Burner)
end


////////////////////////////////////////////
////////////// Construction ////////////////
////////////////////////////////////////////
// This gets called from a button
function zrush.f.Burner_DeConstruct(Burner)
	zrush.f.Burner_DetachBurner(Burner)
end

// Attaches the burner on the drillhole
function zrush.f.Burner_AttachBurner(Burner,drillhole)
	Burner:SetHole(drillhole)

	local phys = Burner:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	Burner:SetPos(drillhole:LocalToWorld(Vector(0, 0, 3)))
	Burner:SetAngles(drillhole:GetAngles())

	zrush.f.DrillHole_HadInteraction(drillhole)

	zrush.f.DrillHole_ButanGasCycle_Stop(drillhole)
	drillhole:SetHasBurner(true)

	timer.Simple(0.1, function()
		if IsValid(Burner) then
			zrush.f.Burner_BurnGasCycle_Start(Burner)
		end
	end)
end

// This detaches our burner
function zrush.f.Burner_DetachBurner(Burner)
	net.Start("zrush_CloseMachineUI_net")
	net.WriteEntity(Burner)
	net.Broadcast()

	zrush.f.Burner_BurnGasCycle_Stop(Burner)

	local shole = Burner:GetHole()

	if IsValid(shole) then
		if (shole:GetGas() > 0) then
			zrush.f.DrillHole_ButanGasCycle_Start(shole)
		end
		shole:SetHasBurner(false)
	end

	// This makes the machine too a box
	zrush.f.MachineCrateBuilder.DeConstruct(Burner)
end

////////////////////////////////////////////
////////////////////////////////////////////





////////////////////////////////////////////
///////////////// MainLogic ////////////////
////////////////////////////////////////////
// This Starts our ButanGas timer
function zrush.f.Burner_BurnGasCycle_Start(Burner)
	local hole = Burner:GetHole()

	if IsValid(hole) then
		local gas = hole:GetGas()

		if (gas <= 0) then
			zrush.f.SetMachineState("NO_GAS_LEFT", Burner)

			return
		end

		zrush.f.Burner_BurnGasCycle_Stop(Burner)

		zrush.f.SetMachineState("BURNING_GAS", Burner)
		zrush.f.SetMachineState("HAS_BURNER", hole)

		zrush.f.CreateNetEffect("burner_anim_burn",Burner)

		Burner:SetIsRunning(true)

		// How long does it take do emit one butan gas unit
		local burnSpeed = zrush.f.ReturnBoostValue("Burner", "speed", Burner)

		local timerid = "zrush_working_" .. Burner:EntIndex()
		zrush.f.Timer_Remove(timerid)
		zrush.f.Timer_Create(timerid, burnSpeed, 0, function()
			if (IsValid(Burner)) then
				zrush.f.Burner_BurnGasCycle_Complete(Burner)
			end
		end)
	end
end

// This Stops our ButanGas timer
function zrush.f.Burner_BurnGasCycle_Stop(Burner)

	zrush.f.Timer_Remove("zrush_working_" .. Burner:EntIndex())

	zrush.f.CreateNetEffect("burner_anim_idle",Burner)

	zrush.f.SetMachineState("IDLE", Burner)
	Burner:SetIsRunning(false)
	zrush.f.Debug("Destroyed BurnTimer (" .. Burner:EntIndex() .. ")")
end

// This handels the main Butan logic
function zrush.f.Burner_BurnGasCycle_Complete(Burner)
	if (IsValid(Burner) and Burner:GetState() == "BURNING_GAS") then
		aHole = Burner:GetHole()

		if (IsValid(aHole)) then
			local gas = aHole:GetGas()

			if (gas > 0) then
				local burnAmount = zrush.f.ReturnBoostValue("Burner", "production", Burner)

				// Custom Hook
				hook.Run("zrush_OnGasBurned", Burner,burnAmount)

				aHole:SetGas(gas - burnAmount)
			else
				// No more gas do burn
				zrush.f.Burner_BurnGas_Finished(Burner)
			end
		end

		// This sends a UI update message do all players
		zrush.f.UpdateMachineUI(Burner, false)
	end
end

// This gets called when all of the gas is gone
function zrush.f.Burner_BurnGas_Finished(Burner)
	zrush.f.SetMachineState("PUMP_READY", Burner:GetHole())
	zrush.f.SetMachineState("NO_GAS_LEFT", Burner)

	zrush.f.CreateNetEffect("burner_anim_idle",Burner)

	// Custom Hook
	hook.Run("zrush_OnGasBurnedFinished", Burner)
end

////////////////////////////////////////////
////////////////////////////////////////////





////////////////////////////////////////////
//////////////// Heat Event ////////////////
////////////////////////////////////////////
// This tells us if its ready for a event
function zrush.f.Burner_ReadyForEvent(Burner)
	if (Burner:GetIsRunning() and not Burner:GetOverHeat() and Burner:GetState() == "BURNING_GAS") then
		return true
	else
		return false
	end
end

// For The OverHeat Event
function zrush.f.Burner_OverHeatMachine(Burner)
	zrush.f.SetMachineState("OVERHEAT", Burner)
	Burner:SetOverHeat(true)

	zrush.f.CreateNetEffect("event_overheat", Burner)


	zrush.f.Timer_Remove("zrush_working_" .. Burner:EntIndex())
	zrush.f.Timer_Remove("zrush_explosiontimer_" .. Burner:EntIndex())

	// Add Timer for big explosion
	zrush.f.Timer_Create("zrush_explosiontimer_" .. Burner:EntIndex(), zrush.config.Machine["Burner"].OverHeat_Countown, 1, function()
		if IsValid(Burner) then

			zrush.f.Timer_Remove("zrush_explosiontimer_" .. Burner:EntIndex())

			// THis deletes the oilspot and the drillhole
			local hole = Burner:GetHole()

			if (IsValid(hole)) then
				local OilSpot = hole.OilSpot

				if (IsValid(OilSpot)) then
					zrush.f.Oilspot_Remove(OilSpot)
				end
			end

			zrush.f.EntityExplosion(Burner, "Burner", true)
		end
	end)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Burner, true)
end

// This gets called from the cooldown button
function zrush.f.Burner_CoolDownMachine(Burner)
	if (not Burner:GetOverHeat()) then return end

	Burner:SetOverHeat(false)
	zrush.f.SetMachineState("COOLED", Burner)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Burner, true)

	// Remove timer for big explosion
	zrush.f.Timer_Remove("zrush_explosiontimer_" .. Burner:EntIndex())

	zrush.f.Burner_BurnGasCycle_Start(Burner)
end
////////////////////////////////////////////
////////////////////////////////////////////
