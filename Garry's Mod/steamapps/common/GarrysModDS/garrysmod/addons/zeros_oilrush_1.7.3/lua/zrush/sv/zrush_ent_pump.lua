if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.Pump_Initialize(Pump)
	Pump:SetModel("models/zerochain/props_oilrush/zor_oilpump.mdl")
	Pump:PhysicsInit(SOLID_VPHYSICS)
	Pump:SetMoveType(MOVETYPE_VPHYSICS)
	Pump:SetSolid(SOLID_VPHYSICS)
	Pump:SetUseType(SIMPLE_USE)

	if (zrush.config.Machine_NoCollide) then
		Pump:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	local phys = Pump:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
		phys:SetMass(150)
	end

	Pump:UseClientSideAnimation()
	Pump.PhysgunDisabled = true
	Pump:SetBodygroup(0, 1)
	Pump:SetBodygroup(1, 1)
	Pump:SetBodygroup(3, 1)
	Pump:SetBodygroup(5, 1)
	zrush.f.CreateSockets(Pump)

	Pump.NextChaosEvent = CurTime() + zrush.config.ChaosEvents.Cooldown

	zrush.f.EntList_Add(Pump)
end

// Called when a player presses e on the Pump
function zrush.f.Pump_OnUse(Pump,ply)
	if (Pump.Wait or false) then return end

	net.Start("zrush_OpenMachineUI_net")
	net.WriteEntity(Pump)
	net.WriteTable(zrush.f.Machine_ReturnInstalledModules(Pump))
	net.Send(ply)

	zrush.f.CreateNetEffect("action_command",Pump)
end

function zrush.f.Pump_OnTakeDamage(Pump, dmg)
	if not Pump.m_bApplyingDamage then
		Pump.m_bApplyingDamage = true

		Pump:TakePhysicsDamage(dmg)

		local damage = dmg:GetDamage()
		local entHealth = zrush.config.Machine["Pump"].Health

		if (entHealth > 0) then
			Pump.CurrentHealth = (Pump.CurrentHealth or entHealth) - damage

			if (Pump.CurrentHealth <= 0) then
				// This deletes the oilspot and the drillhole
				local hole = Pump:GetHole()

				if (IsValid(hole)) then
					local OilSpot = hole.OilSpot

					if (IsValid(OilSpot)) then
						zrush.f.Oilspot_Remove(OilSpot)
					end
				end

				local sBarrel = Pump:GetBarrel()

				if (IsValid(sBarrel)) then
					zrush.f.Pump_DetachBarrel(Pump)
				end

				zrush.f.EntityExplosion(Pump, "Pump", true)
			end
		end

		Pump.m_bApplyingDamage = false
	end
end




////////////////////////////////////////////
//////////// CONSTRUCTION //////////////////
////////////////////////////////////////////
// This Places the pump on a drill hole
function zrush.f.Pump_PlacePump(Pump,hole)
	if (hole:GetHasPump() or hole:GetHasBurner() or hole:GetHasDrill() or hole.Closed) then return end

	Pump:SetHole(hole)

	zrush.f.DrillHole_HadInteraction(hole)
	hole:SetHasPump(true)

	zrush.f.SetMachineState("NEED_BARREL", Pump)

	local phys = Pump:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	Pump:SetPos(hole:LocalToWorld(Vector(0, 0, 0)))
	Pump:SetAngles(hole:GetAngles())

	Pump.PhysgunDisabled = true

	Pump:SetBodygroup(2, 1)
	Pump:SetBodygroup(4, 1)
end

// This removes the pump from the drillhole
function zrush.f.Pump_DetachPump(Pump)
	net.Start("zrush_CloseMachineUI_net")
	net.WriteEntity(Pump)
	net.Broadcast()

	zrush.f.Pump_PumpCycle_Stop(Pump)

	local sBarrel = Pump:GetBarrel()
	if IsValid(sBarrel) then
		zrush.f.Pump_DetachBarrel(Pump)
	end

	local shole = Pump:GetHole()
	if IsValid(shole) then
		shole:SetHasPump(false)
	end

	Pump.PhysgunDisabled = false

	// This makes the machine too a box
	zrush.f.MachineCrateBuilder.DeConstruct(Pump)
end

// This gets called by the UI Button
function zrush.f.Pump_DeConstruct(Pump)
	zrush.f.Pump_DetachPump(Pump)
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
//////////////// MODULES ///////////////////
////////////////////////////////////////////
// Gets called when something on the Modules change
function zrush.f.Pump_ModulesChanged(Pump)
	// This resets the pump timer do be sure he has the right time if a speed module got installed
	if (Pump:GetIsRunning()) then
		zrush.f.Pump_PumpCycle_Start(Pump)
	end

	zrush.f.UpdateMachineSound(Pump)
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
////////////// MAIN LOGIC //////////////////
////////////////////////////////////////////

// This adds a barrel
function zrush.f.Pump_AddBarrel(Pump,Barrel)
	local sHole = Pump:GetHole()
	if (IsValid(sHole) and sHole.Closed) then return end
	if (Pump:GetJammed()) then return end

	if (not IsValid(Pump:GetBarrel()) and Barrel:GetFuel() <= 0 and Barrel:GetOil() < zrush.config.Machine["Barrel"].Storage) then
		Pump:SetBarrel(Barrel)
		Barrel.Machine = Pump
		Barrel.PhysgunDisabled = true

		Barrel:SetPos(Pump:GetAttachment(Pump:LookupAttachment("barrel01")).Pos)
		local ang = Pump:GetAngles()
		ang:RotateAroundAxis(Pump:GetUp(), 180)
		Barrel:SetAngles(ang)

		local phys = Barrel:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(false)
		end

		zrush.f.CreateNetEffect("barrel_attached",Barrel)

		zrush.f.SetMachineState("PUMP_READY", Pump)

		zrush.f.Pump_PumpCycle_AutoStart(Pump)
	end
end

// This removes a barrel
function zrush.f.Pump_DetachBarrel(Pump)
	local barrel = Pump:GetBarrel()

	if (IsValid(barrel) and IsValid(Pump)) then
		Pump:SetBarrel(NULL)
		barrel.Machine = nil
		barrel.PhysgunDisabled = false
		local attach = Pump:GetAttachment(Pump:LookupAttachment("barrel01"))

		if (attach) then
			barrel:SetPos(attach.Pos + Pump:GetUp() * 45)
			barrel:SetAngles(attach.Ang)
		end


		zrush.f.CreateNetEffect("barrel_detached",barrel)

		zrush.f.Barrel_GotDetached(barrel)
		local phys = barrel:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion(true)
		end

		if timer.Exists("zrush_working_" .. Pump:EntIndex()) == true then
			zrush.f.Pump_PumpCycle_Stop(Pump)
		end

		if (Pump:GetHole().Closed == false) then
			zrush.f.SetMachineState("NEED_BARREL", Pump)
		else
			if (Pump:GetState() == "NO_OIL") then
				Pump:SetBodygroup(2, 0)
			end
		end
	end
end

// This Toggles the work status of the machine
function zrush.f.Pump_ToggleMachineWork(Pump,ply)
	if not IsValid(Pump:GetHole()) or Pump:GetHole():GetOilAmount() <= 0 then
		zrush.f.Notify(ply, zrush.language.Pump["OilSourceEmpty"], 1)
		zrush.f.Pump_NoOil(Pump)
		return
	end

	if not IsValid(Pump:GetBarrel()) then
		zrush.f.Notify(ply, zrush.language.Pump["MissingBarrel"], 1)

		return
	end

	Pump:SetIsRunning(not Pump:GetIsRunning())

	if (Pump:GetIsRunning()) then
		zrush.f.Pump_PumpCycle_Start(Pump)
	else
		zrush.f.Pump_PumpCycle_Stop(Pump)
	end

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Pump, true)
end

// This AutoStarts the machine if we have everything we need
function zrush.f.Pump_PumpCycle_AutoStart(Pump)
	local sHole = Pump:GetHole()
	local Barrel = Pump:GetBarrel()
	if IsValid(Barrel) and Barrel:GetOil() < zrush.config.Machine["Barrel"].Storage and Pump:GetJammed() == false and IsValid(sHole) and sHole.Closed == false then
		zrush.f.Pump_PumpCycle_Start(Pump)
	end
end

// This Starts our timer
function zrush.f.Pump_PumpCycle_Start(Pump)
	if not IsValid(Pump:GetBarrel()) then return end

	zrush.f.Pump_PumpCycle_Stop(Pump)

	local pumpSpeed = zrush.f.ReturnBoostValue(Pump.MachineID, "speed", Pump)

	timer.Simple(0.1,function()
		if IsValid(Pump) then
			zrush.f.CreateNetEffect("pump_anim_pumping",Pump)
		end
	end)

	zrush.f.SetMachineState("PUMPING", Pump)

	Pump:SetIsRunning(true)

	local timerid = "zrush_working_" .. Pump:EntIndex()
	zrush.f.Timer_Remove(timerid)
	zrush.f.Timer_Create(timerid, pumpSpeed, 0, function()
		if (IsValid(Pump)) then
			zrush.f.Pump_PumpCycle_Complete(Pump)
		end
	end)
end

// This Stops our pump timer
function zrush.f.Pump_PumpCycle_Stop(Pump)
	zrush.f.Timer_Remove("zrush_working_" .. Pump:EntIndex())

	if (IsValid(Pump:GetBarrel())) then
		if zrush.f.Barrel_IsFull(Pump:GetBarrel()) then
			zrush.f.SetMachineState("BARREL_FULL", Pump)
		else
			zrush.f.SetMachineState("PUMP_READY", Pump)
		end
	else
		zrush.f.SetMachineState("NEED_BARREL", Pump)
	end

	Pump:SetIsRunning(false)
	zrush.f.Debug("Destroyed PumpTimer (" .. Pump:EntIndex() .. ")")

	zrush.f.CreateNetEffect("pump_anim_idle",Pump)
end

// This handels the main pump logic
function zrush.f.Pump_PumpCycle_Complete(Pump)
	if (Pump:GetJammed()) then return end
	local shole = Pump:GetHole()
	local sbarrel = Pump:GetBarrel()

	// Do we have a oil hole
	if (IsValid(shole)) then

		// Do we have a barrel
		if (IsValid(sbarrel)) then

			// Is the Barrel full?
			if (sbarrel:GetOil() >= zrush.config.Machine["Barrel"].Storage) then

				zrush.f.SetMachineState("BARREL_FULL", Pump)

				if timer.Exists("zrush_working_" .. Pump:EntIndex()) == true then
					zrush.f.Pump_PumpCycle_Stop(Pump)
				end
			else
				local Oil = shole:GetOilAmount()

				if (Oil > 0) then
					local pumpAmount = zrush.f.ReturnBoostValue("Pump", "production", Pump)

					// Custom Hook
					hook.Run("zrush_OnOilPumped", Pump,pumpAmount)


					zrush.f.CreateNetEffect("pump_filloil",Pump)

					zrush.f.DrillHole_RemoveOil(shole,pumpAmount)
					zrush.f.Barrel_AddLiquid(sbarrel,"Oil", pumpAmount)
				else
					// No Oil
					zrush.f.Pump_NoOil(Pump)
				end
			end
		end

		// This sends a UI update message do all players
		zrush.f.UpdateMachineUI(Pump, false)
	end
end

function zrush.f.Pump_NoOil(Pump)

	zrush.f.DrillHole_NoOil(Pump:GetHole())
	zrush.f.Pump_PumpCycle_Stop(Pump)
	zrush.f.SetMachineState("NO_OIL", Pump)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Pump, false)
	Pump:SetBodygroup(4, 0)
end

////////////////////////////////////////////
////////////////////////////////////////////





////////////////////////////////////////////
////////////// JAMM EVENT //////////////////
////////////////////////////////////////////

// This tells us if its ready for a event
function zrush.f.Pump_ReadyForEvent(Pump)
	if (Pump:GetIsRunning() and not Pump:GetJammed() and Pump:GetState() == "PUMPING") then
		return true
	else
		return false
	end
end

// For The Jam Event
function zrush.f.Pump_JamMachine(Pump)
	zrush.f.Pump_PumpCycle_Stop(Pump)
	Pump:SetJammed(true)
	zrush.f.SetMachineState("JAMMED", Pump)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Pump, true)

	// Play Jam Animation
	zrush.f.CreateNetEffect("pump_anim_jammed",Pump)
end

function zrush.f.Pump_UnJamMachine(Pump)
	if (not Pump:GetJammed()) then return end
	Pump:SetJammed(false)
	zrush.f.SetMachineState("UNJAMMED", Pump)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Pump, true)

	zrush.f.CreateNetEffect("pump_anim_idle",Pump)

	zrush.f.Pump_PumpCycle_Start(Pump)
end

////////////////////////////////////////////
////////////////////////////////////////////
