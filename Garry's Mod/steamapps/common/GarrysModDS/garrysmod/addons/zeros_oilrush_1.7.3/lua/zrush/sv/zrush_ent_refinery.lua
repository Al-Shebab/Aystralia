if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.Refinery_Initialize(Refinery)
	Refinery:SetModel(Refinery.Model)
	Refinery:PhysicsInit(SOLID_VPHYSICS)
	Refinery:SetMoveType(MOVETYPE_VPHYSICS)
	Refinery:SetSolid(SOLID_VPHYSICS)
	Refinery:SetUseType(SIMPLE_USE)

	if (zrush.config.Machine_NoCollide) then
		Refinery:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	local phys = Refinery:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
		phys:SetMass(150)
	end

	Refinery:UseClientSideAnimation()
	Refinery.PhysgunDisabled = true
	zrush.f.CreateSockets(Refinery)

	Refinery.NextChaosEvent = CurTime() + zrush.config.ChaosEvents.Cooldown


	zrush.f.EntList_Add(Refinery)
end

// Called when a player presses e on the Refinery
function zrush.f.Refinery_OnUse(Refinery,ply)
	if (Refinery.Wait or false) then return end

	net.Start("zrush_OpenMachineUI_net")
	net.WriteEntity(Refinery)
	net.WriteTable(zrush.f.Machine_ReturnInstalledModules(Refinery))
	net.Send(ply)

	zrush.f.CreateNetEffect("action_command",Refinery)
end

function zrush.f.Refinery_OnTakeDamage(Refinery,dmg)
	if not Refinery.m_bApplyingDamage then
		Refinery.m_bApplyingDamage = true

		Refinery:TakePhysicsDamage(dmg)
		local damage = dmg:GetDamage()
		local entHealth = zrush.config.Machine["Refinery"].Health

		if (entHealth > 0) then
			Refinery.CurrentHealth = (Refinery.CurrentHealth or entHealth) - damage

			if (Refinery.CurrentHealth <= 0) then
				// This detaches our barrels
				zrush.f.Refinery_DetachBarrel(Refinery,1, Refinery:GetInputBarrel())
				zrush.f.Refinery_DetachBarrel(Refinery,2, Refinery:GetOutputBarrel())

				zrush.f.EntityExplosion(Refinery, "Refinery", true)
			end
		end

		Refinery.m_bApplyingDamage = false
	end
end




////////////////////////////////////////////
////////////// Construction ////////////////
////////////////////////////////////////////
// This places the refinery
function zrush.f.Refinery_Place(Refinery)
	Refinery.PhysgunDisabled = true
	zrush.f.SetMachineState("NEED_OIL_BARREL", Refinery)

	Refinery:SetAngles(Angle(0, Refinery:GetAngles().y, 0))

	local phys = Refinery:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

// This deconstructs the refinery
function zrush.f.Refinery_DeConstruct(Refinery)
	net.Start("zrush_CloseMachineUI_net")
	net.WriteEntity(Refinery)
	net.Broadcast()

	zrush.f.Refinery_RefineCycle_Stop(Refinery)

	local inputBarrel = Refinery:GetInputBarrel()
	local outputBarrel = Refinery:GetOutputBarrel()

	if (IsValid(inputBarrel)) then
		zrush.f.Refinery_DetachBarrel(Refinery,1, inputBarrel)
	end

	if (IsValid(outputBarrel)) then
		zrush.f.Refinery_DetachBarrel(Refinery,2, outputBarrel)
	end

	// This makes the machine too a box
	zrush.f.MachineCrateBuilder.DeConstruct(Refinery)
end

////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
/////////////////// Modules ////////////////
////////////////////////////////////////////

// This updates the machine if a module gets installed
function zrush.f.Refinery_ModulesChanged(Refinery)
	// This resets the refine timer do be sure he has the right time if a speed module got installed
	if (Refinery:GetIsRunning()) then
		zrush.f.Refinery_RefineCycle_Start(Refinery)
	end

	// The Updates the Pitch of the Looped Sound on CLIENT
	zrush.f.UpdateMachineSound(Refinery)
end

////////////////////////////////////////////
////////////////////////////////////////////







////////////////////////////////////////////
//////////////// MAIN LOGIC ////////////////
////////////////////////////////////////////
// Called when the fuel gets changed to a new fuel type
function zrush.f.Refinery_ChangeFuel(Refinery,newFuelID)
	local outputBarrel = Refinery:GetOutputBarrel()

	if (IsValid(outputBarrel) and outputBarrel:GetFuel() > 0 and outputBarrel:GetFuelTypeID() ~= newFuelID) then
		zrush.f.Refinery_DetachBarrel(Refinery,2, Refinery:GetOutputBarrel())
	end

	Refinery:SetFuelTypeID(newFuelID)
end

// This function attaches a barrel depending on its type
function zrush.f.Refinery_AttachBarrel(Refinery,bType, barrel)
	if (Refinery:GetOverHeat()) then return end
	local tBarrel = barrel
	DropEntityIfHeld(tBarrel)

	net.Start("zrush_CloseFuelSplitUI_net")
	net.WriteEntity(tBarrel)
	net.Broadcast()

	local angOffset = 0
	local attach

	if (bType == 1) then
		angOffset = 90
		Refinery:SetInputBarrel(tBarrel)
		attach = Refinery:GetAttachment(Refinery:LookupAttachment("barrel01"))
	elseif (bType == 2) then
		angOffset = -90
		tBarrel:SetFuelTypeID(Refinery:GetFuelTypeID())
		Refinery:SetOutputBarrel(tBarrel)
		attach = Refinery:GetAttachment(Refinery:LookupAttachment("barrel02"))
	end

	zrush.f.CreateNetEffect("barrel_attached",tBarrel)

	local phys = tBarrel:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	tBarrel:SetPos(attach.Pos)
	local ang = attach.Ang
	ang:RotateAroundAxis(Refinery:GetUp(), angOffset)
	tBarrel:SetAngles(ang)
	tBarrel:SetParent(Refinery)
	tBarrel.PhysgunDisabled = true
	tBarrel.Machine = Refinery

	zrush.f.Refinery_StateUpdater(Refinery)

	zrush.f.Refinery_RefineCycle_AutoStart(Refinery)
end

// This function detaches a barrel depending on the type
function zrush.f.Refinery_DetachBarrel(Refinery,bType, barrel)
	local tBarrel = barrel

	if (IsValid(Refinery) and IsValid(tBarrel)) then
		local attach
		local posOffset = 0

		if (bType == 1) then
			posOffset = 50
			Refinery:SetInputBarrel(NULL)
			attach = Refinery:GetAttachment(Refinery:LookupAttachment("barrel01"))
		elseif (bType == 2) then
			posOffset = -50
			Refinery:SetOutputBarrel(NULL)
			attach = Refinery:GetAttachment(Refinery:LookupAttachment("barrel02"))
		end

		tBarrel:SetParent(nil)
		zrush.f.Barrel_GotDetached(tBarrel)

		zrush.f.CreateNetEffect("barrel_detached",tBarrel)


		if (attach) then
			local ang = attach.Ang
			tBarrel:SetPos(attach.Pos + Vector(0, 0, 50) + attach.Ang:Right() * posOffset)
			ang:RotateAroundAxis(Refinery:GetUp(), 90)
			tBarrel:SetAngles(ang)
		end

		local phys = tBarrel:GetPhysicsObject()

		if (IsValid(phys)) then
			phys:Wake()
			phys:EnableMotion(true)
		end

		tBarrel.PhysgunDisabled = false
		tBarrel.Machine = nil

		zrush.f.Refinery_RefineCycle_Stop(Refinery)
	end
end


// This Toggles the work status of the machine
function zrush.f.Refinery_ToggleMachineWork(Refinery,ply)
	local inputBarrel = Refinery:GetInputBarrel()
	local outputBarrel = Refinery:GetOutputBarrel()

	if (not IsValid(inputBarrel)) then
		zrush.f.Notify(ply, zrush.language.Refinery["MissingOilBarrel"], 1)

		return
	end

	if (not IsValid(outputBarrel)) then
		zrush.f.Notify(ply, zrush.language.Refinery["MissingEmptyBarrel"], 1)

		return
	elseif (outputBarrel:GetFuel() >= zrush.config.Machine["Barrel"].Storage) then
		zrush.f.Notify(ply, zrush.language.VGUI.Refinery["FUELBARREL_FULL"], 1)

		return
	end

	Refinery:SetIsRunning(not Refinery:GetIsRunning())

	if (Refinery:GetIsRunning()) then
		zrush.f.Refinery_RefineCycle_Start(Refinery)
	else
		zrush.f.Refinery_RefineCycle_Stop(Refinery)
	end

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Refinery, true)
end

// This AutoStarts the machine if we have everything we need
function zrush.f.Refinery_RefineCycle_AutoStart(Refinery)
	local inputBarrel = Refinery:GetInputBarrel()
	local outputBarrel = Refinery:GetOutputBarrel()

	if (IsValid(inputBarrel) and IsValid(outputBarrel) and outputBarrel:GetFuel() < zrush.config.Machine["Barrel"].Storage) then
		zrush.f.Refinery_RefineCycle_Start(Refinery)
	end
end

// This Starts our timer
function zrush.f.Refinery_RefineCycle_Start(Refinery)
	local inputBarrel = Refinery:GetInputBarrel()
	local outputBarrel = Refinery:GetOutputBarrel()

	if (not IsValid(inputBarrel) or not IsValid(outputBarrel)) then return end

	if (Refinery:GetOverHeat()) then return end

	zrush.f.Refinery_RefineCycle_Stop(Refinery)

	Refinery:SetIsRunning(true)

	local refineSpeed = zrush.f.ReturnBoostValue("Refinery", "speed", Refinery)
	zrush.f.SetMachineState("REFINING", Refinery)

	local timerid = "zrush_working_" .. Refinery:EntIndex()
	zrush.f.Timer_Remove(timerid)
	zrush.f.Timer_Create(timerid, refineSpeed, 0, function()
		if (IsValid(Refinery)) then
			zrush.f.Refinery_RefineCycle_Complete(Refinery)
		end
	end)
end

// This Stops our pump timer
function zrush.f.Refinery_RefineCycle_Stop(Refinery)

	zrush.f.Timer_Remove("zrush_working_" .. Refinery:EntIndex())

	Refinery:SetIsRunning(false)
	zrush.f.Refinery_StateUpdater(Refinery)

	zrush.f.Refinery_StopOverHeat(Refinery)
	zrush.f.Debug("Destroyed PumpTimer (" .. Refinery:EntIndex() .. ")")
end

// This handels the main pump logic
function zrush.f.Refinery_RefineCycle_Complete(Refinery)
	if (Refinery:GetOverHeat()) then return end
	local inputBarrel = Refinery:GetInputBarrel()
	local outputBarrel = Refinery:GetOutputBarrel()

	// Do we have a Oil Barrel?
	if (IsValid(inputBarrel)) then

		// Do we have a Empty Barrel?
		if (IsValid(outputBarrel)) then
			local oil = inputBarrel:GetOil()
			local Fuel = outputBarrel:GetFuel()

			// Does the Input Barrel has Oil?
			if (oil > 0) then

				// Is the Output Barrel full?
				if (Fuel >= zrush.config.Machine["Barrel"].Storage) then

					zrush.f.Refinery_RefineCycle_Stop(Refinery)
				else

					///// This is the Oil Refining Function
					local takeAmount = zrush.f.ReturnBoostValue("Refinery", "production", Refinery)

					zrush.f.CreateNetEffect("refinery_fillfuel",Refinery)

					local outputAmount = takeAmount * zrush.f.ReturnBoostValue(Refinery.MachineID, "refining", Refinery)


					// Custom Hook
					hook.Run("zrush_OnFuelRefined", Refinery,outputAmount,Refinery:GetFuelTypeID())


					zrush.f.Barrel_RemoveLiquid(inputBarrel,"Oil", takeAmount)
					zrush.f.Barrel_AddLiquid(outputBarrel,Refinery:GetFuelTypeID(), outputAmount)

					zrush.f.SetMachineState("REFINING", Refinery)
					/////
				end
			else
				inputBarrel:SetOil(0)
				inputBarrel:SetFuelTypeID(0)
				inputBarrel:SetFuel(0)

				zrush.f.Refinery_DetachBarrel(Refinery,1, inputBarrel)
				zrush.f.Refinery_RefineCycle_Stop(Refinery)
			end

			// Is the Output Barrel full?
			// We test again do make sure we remove it after the action
			if (Fuel >= zrush.config.Machine["Barrel"].Storage) then

				zrush.f.Refinery_RefineCycle_Stop(Refinery)
			end
		else
			zrush.f.Refinery_RefineCycle_Stop(Refinery)
		end
	else
		zrush.f.Refinery_RefineCycle_Stop(Refinery)
	end

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Refinery)
end

function zrush.f.Refinery_StateUpdater(Refinery)
	local inputBarrel = Refinery:GetInputBarrel()
	local outputBarrel = Refinery:GetOutputBarrel()
	//112273954
	// Do we have a Oil Barrel?
	if (IsValid(inputBarrel)) then
		// Do we have a Empty Barrel?
		if (IsValid(outputBarrel)) then
			if (outputBarrel:GetFuel() >= zrush.config.Machine["Barrel"].Storage) then
				zrush.f.SetMachineState("FUELBARREL_FULL", Refinery)
			else
				zrush.f.SetMachineState("READY_FOR_WORK", Refinery)
			end
		else
			zrush.f.SetMachineState("NEED_EMPTY_BARREL", Refinery)
		end
	else
		zrush.f.SetMachineState("NEED_OIL_BARREL", Refinery)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////






////////////////////////////////////////////
//////////// OVERHEAT EVENT ////////////////
////////////////////////////////////////////
// This tells us if its ready for a chaos event
function zrush.f.Refinery_ReadyForEvent(Refinery)
	if (Refinery:GetIsRunning() and not Refinery:GetOverHeat() and Refinery:GetState() == "REFINING" and IsValid(Refinery:GetInputBarrel()) and IsValid(Refinery:GetOutputBarrel())) then
		return true
	else
		return false
	end
end

// For The OverHeat Event
function zrush.f.Refinery_OverHeatMachine(Refinery)
	zrush.f.SetMachineState("OVERHEAT", Refinery)
	Refinery:SetOverHeat(true)

	zrush.f.CreateNetEffect("event_overheat", Refinery)

	zrush.f.Timer_Remove("zrush_working_" .. Refinery:EntIndex())

	// Add Timer for big explosion
	local timerid = "zrush_explosiontimer_" .. Refinery:EntIndex()
	zrush.f.Timer_Remove(timerid)
	zrush.f.Timer_Create(timerid, zrush.config.Machine["Refinery"].OverHeat_Countown, 1, function()
		if (IsValid(Refinery)) then
			zrush.f.Refinery_ExplodeMachine(Refinery)
		end
	end)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Refinery, true)
end

function zrush.f.Refinery_StopOverHeat(Refinery)
	Refinery:SetOverHeat(false)

	// Remove timer for big explosion
	zrush.f.Timer_Remove("zrush_explosiontimer_" .. Refinery:EntIndex())


	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Refinery, true)
end

// This function gets called when the machine explodes because of the overheat event
function zrush.f.Refinery_ExplodeMachine(Refinery)
	// This detaches our barrels
	zrush.f.Refinery_DetachBarrel(Refinery,1, Refinery:GetInputBarrel())
	zrush.f.Refinery_DetachBarrel(Refinery,2, Refinery:GetOutputBarrel())

	zrush.f.EntityExplosion(Refinery, "Refinery", true)
end

// Cools down the machine so it doesent explode
function zrush.f.Refinery_CoolDownMachine(Refinery)
	if (not Refinery:GetOverHeat()) then return end
	Refinery:SetOverHeat(false)
	zrush.f.SetMachineState("COOLED", Refinery)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(Refinery, true)

	// Remove timer for big explosion
	zrush.f.Timer_Remove("zrush_explosiontimer_" .. Refinery:EntIndex())

	zrush.f.Refinery_RefineCycle_Start(Refinery)
end
////////////////////////////////////////////
////////////////////////////////////////////
