if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.DrillTower_Initialize(DrillTower)
	DrillTower:SetModel("models/zerochain/props_oilrush/zor_drilltower.mdl")
	DrillTower:PhysicsInit(SOLID_VPHYSICS)
	DrillTower:SetMoveType(MOVETYPE_VPHYSICS)
	DrillTower:SetSolid(SOLID_VPHYSICS)
	DrillTower:SetUseType(SIMPLE_USE)

	if (zrush.config.Machine_NoCollide) then
		DrillTower:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	local phys = DrillTower:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
		phys:EnableDrag(true)
		phys:SetDragCoefficient(0.99)
		phys:SetAngleDragCoefficient(0.99)
		phys:SetMass(150)
	end

	DrillTower:UseClientSideAnimation()

	DrillTower.PhysgunDisabled = true
	DrillTower.IsConstructing = false
	zrush.f.CreateSockets(DrillTower)

	DrillTower.NextChaosEvent = CurTime() + zrush.config.ChaosEvents.Cooldown


	zrush.f.EntList_Add(DrillTower)
end

// Called when a player presses e on the drilltower
function zrush.f.DrillTower_OnUse(DrillTower,ply)

	if (DrillTower.Wait or false) then return end

	// If the Tower is constructing then we dont allow any interaction
	if DrillTower.IsConstructing == true then return end

	net.Start("zrush_OpenMachineUI_net")
	net.WriteEntity(DrillTower)
	net.WriteTable(zrush.f.Machine_ReturnInstalledModules(DrillTower))
	net.Send(ply)

	zrush.f.CreateNetEffect("action_command",DrillTower)
end

// Called when the drilltower gets damaged
function zrush.f.DrillTower_OnTakeDamage(DrillTower, dmg)
	if not DrillTower.m_bApplyingDamage then
		DrillTower.m_bApplyingDamage = true

		DrillTower:TakePhysicsDamage(dmg)
		local damage = dmg:GetDamage()
		local entHealth = zrush.config.Machine["Drill"].Health

		if (entHealth > 0) then
			DrillTower.CurrentHealth = (DrillTower.CurrentHealth or entHealth) - damage

			if (DrillTower.CurrentHealth <= 0) then
				// THis deletes the oilspot and the drillhole
				local hole = DrillTower:GetHole()

				if (IsValid(hole)) then
					local OilSpot = hole.OilSpot

					if (IsValid(OilSpot)) then
						zrush.f.Oilspot_Remove(OilSpot)
					end
				end

				zrush.f.EntityExplosion(DrillTower, "Drill", true)
			end
		end

		DrillTower.m_bApplyingDamage = false
	end
end





////////////////////////////////////////////
///////////////// SETUP /////////////////////
////////////////////////////////////////////
//Here we create the drillhole
function zrush.f.DrillTower_CreateDrillHole(DrillTower,ply)
	local hole = ents.Create("zrush_drillhole")
	hole:SetModel("models/zerochain/props_oilrush/zor_drillhole.mdl")
	hole:SetPos(DrillTower:LocalToWorld(Vector(0, 0, 0)))
	hole:SetAngles(DrillTower:GetAngles())
	hole:Spawn()
	hole:Activate()

	local phys = hole:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	constraint.NoCollide(hole, DrillTower, 0, 0)
	DrillTower:SetHole(hole)
	zrush.f.SetOwner(hole, ply)
	ply:zrush_CreatedDrillHole(hole:EntIndex())

	return hole
end

//This creates a new drillhole and snaps the drill to it
function zrush.f.DrillTower_SnapTower(DrillTower,ply, hole)
	if not zrush.f.DrillHole_IsOccupied(hole) and hole:GetState() ~= "NEED_BURNER" or hole:GetState() ~= "PUMP_READY" then
		DrillTower.PhysgunDisabled = true
		DrillTower:GetPhysicsObject():EnableMotion(false)
		DrillTower:SetPos(hole:LocalToWorld(Vector(0, 0, 0)))
		DrillTower:SetAngles(hole:GetAngles())

		DrillTower:SetHole(hole)
		hole:SetHasDrill(true)
		zrush.f.DrillHole_HadInteraction(hole)

		if (hole:GetState() == "PUMP_READY") then
			zrush.f.SetMachineState("FINISHED_DRILLING", DrillTower)
		else
			zrush.f.SetMachineState("NEED_PIPES", DrillTower)
		end
		zrush.f.CreateNetEffect("action_building", DrillTower)
	else
		zrush.f.Notify(ply, zrush.language.General["NoDrillholeFound"], 1)
	end
end

// This uses traces do create a new drill hole correctly
function zrush.f.DrillTower_DrillHole_TraceSetup(DrillTower,ply)
	DrillTower.PhysgunDisabled = true
	DrillTower.IsConstructing = true
	DrillTower:GetPhysicsObject():EnableMotion(false)
	local tr

	timer.Simple(0.1, function()
		if (IsValid(DrillTower)) then
			local tracedata = {}
			tracedata.start = DrillTower:GetPos()
			tracedata.endpos = DrillTower:GetPos() + DrillTower:GetUp() * -1000
			tracedata.filter = DrillTower
			tracedata.mask = MASK_SOLID_BRUSHONLY
			tr = util.TraceLine(tracedata)
			DrillTower:SetPos(tr.HitPos)
			local validAng = tr.HitNormal:Angle()
			validAng:RotateAroundAxis(validAng:Right(), -90)
			validAng:RotateAroundAxis(validAng:Up(), 90)
			DrillTower:SetAngles(validAng)

			if (zrush.config.Debug) then
				debugoverlay.Sphere(tr.HitPos, 2, 2, zrush.default_colors["white01"], true)
			end
		end
	end)

	timer.Simple(0.2, function()
		if (IsValid(DrillTower)) then
			local hole = zrush.f.DrillTower_CreateDrillHole(DrillTower,ply)
			hole:SetHasDrill(true)
			zrush.f.SetMachineState("NEED_PIPES", DrillTower)
		end
	end)

	timer.Simple(0.5, function()
		if (IsValid(DrillTower)) then
			zrush.f.CreateNetEffect("action_building", DrillTower)

			DrillTower.IsConstructing = false
		end
	end)
end

// This searches and returns a oilspot
function zrush.f.DrillTower_FindFreeOilSpot(DrillTower)
	local find = ents.FindByClass("zrush_oilspot")
	local ValidOilSpot = nil
	local nearestD = zrush.config.Machine["Drill"].SearchRadius

	for k, v in pairs(find) do
		local loDis = v:GetPos():Distance(DrillTower:GetPos())

		if (loDis < nearestD and v.InUse == false and v.NoOil_TimeStamp == -1) then
			ValidOilSpot = v
			nearestD = loDis
		end
	end

	return ValidOilSpot
end

// This creates a drill hole on a oilspot
function zrush.f.DrillTower_DrillHole_SnapSetup(DrillTower,oilspot,ply)

	if IsValid(oilspot) then
		DrillTower.PhysgunDisabled = true
		DrillTower.IsConstructing = true
		DrillTower:GetPhysicsObject():EnableMotion(false)
		DrillTower:SetAngles(oilspot:GetAngles())
		DrillTower:SetPos(oilspot:GetPos())
		local hole = zrush.f.DrillTower_CreateDrillHole(DrillTower,ply)

		zrush.f.CreateNetEffect("action_building", DrillTower)

		// This tells the oilspot that there is a drillhole on it
		zrush.f.Oilspot_Drill(oilspot,hole)

		hole:SetHasDrill(true)
		zrush.f.SetMachineState("NEED_PIPES", DrillTower)
		DrillTower.IsConstructing = false
	else
		zrush.f.Notify(ply, zrush.language.General["NoOilSpotFound"], 1)
	end
end

// This deconstructs our drill tower
function zrush.f.DrillTower_DeConstruct(DrillTower)
	net.Start("zrush_CloseMachineUI_net")
	net.WriteEntity(DrillTower)
	net.Broadcast()

	zrush.f.DrillTower_EmptyDrillTower(DrillTower)
	local hole = DrillTower:GetHole()

	if IsValid(hole) then
		hole:SetHasDrill(false)
	end

	// This makes the machine too a box
	zrush.f.MachineCrateBuilder.DeConstruct(DrillTower)
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
/////////// ModuleChanged Logic ////////////
////////////////////////////////////////////

// This gets called if a new module is installed
function zrush.f.DrillTower_ModulesChanged(DrillTower)
	// This checks if we have more pipes then the limit in out drill and removes pipes
	zrush.f.DrillTower_CheckMaxPipes(DrillTower)

	// This resets the drill timer do be sure he has the right time if a speed module got installed
	if (DrillTower:GetIsRunning()) then
		zrush.f.DrillTower_DrillCycle_Start(DrillTower)
	end

	// The Updates the Pitch of the Looped Sound on CLIENT
	zrush.f.UpdateMachineSound(DrillTower)
end

// This checks if we have more pipes then the limit in our drill and removes pipes
function zrush.f.DrillTower_CheckMaxPipes(DrillTower)
	local PipesInMachine = DrillTower:GetPipes()
	local maxPipes = zrush.f.ReturnBoostValue(DrillTower.MachineID, "pipes", DrillTower)

	// If we have more pipes in the Queue then we can carry then we remove some
	if (PipesInMachine > maxPipes) then
		local diff = PipesInMachine - maxPipes
		zrush.f.DrillTower_DropPipeHolders(DrillTower,diff)
		DrillTower:SetPipes(maxPipes)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
/////////////// Drill Logic ////////////////
////////////////////////////////////////////

// This Toggles the work status of the machine
function zrush.f.DrillTower_ToggleMachineWork(DrillTower,ply)
	if (DrillTower:GetState() == "FINISHED_DRILLING") then
		zrush.f.Notify(ply, zrush.language.DrillTower["AllreadyReachedOil"], 1)

		return
	end

	if DrillTower:GetPipes() <= 0 then
		zrush.f.Notify(ply, zrush.language.DrillTower["DrillPipesMissing"], 1)

		return
	end

	DrillTower:SetIsRunning(not DrillTower:GetIsRunning())

	if (DrillTower:GetIsRunning()) then
		zrush.f.DrillTower_DrillCycle_Start(DrillTower)
	else
		zrush.f.DrillTower_DrillCycle_Stop(DrillTower)
	end

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(DrillTower, true)
end

// This AutoStarts the machine if we have everything we need
function zrush.f.DrillTower_DrillCycle_AutoStart(DrillTower)
	local sHole = DrillTower:GetHole()
	if DrillTower:GetPipes() > 0 and DrillTower:GetJammed() == false and IsValid(sHole) and sHole:GetPipes() < sHole:GetNeededPipes() then
		zrush.f.DrillTower_DrillCycle_Start(DrillTower)
	end
end

// This Starts the Drilling
function zrush.f.DrillTower_DrillCycle_Start(DrillTower)
	// Do we still have pipes?
	if (DrillTower:GetPipes() <= 0) then
		zrush.f.SetMachineState("NEED_PIPES", DrillTower)

		return
	end

	if not DrillTower:GetJammed() then
		DrillTower:SetIsRunning(true)
		zrush.f.SetMachineState("IS_WORKING", DrillTower)

		// This sends a UI update message do all players
		zrush.f.UpdateMachineUI(DrillTower, false)

		// If we did not reach our depth then just reset the drill animation and wait for the timer
		local currentSpeed = zrush.f.ReturnBoostValue("Drill", "speed", DrillTower)

		local timerid = "zrush_working_" .. DrillTower:EntIndex()
		zrush.f.Timer_Remove(timerid)
		zrush.f.Timer_Create(timerid, currentSpeed, 0, function()
			if IsValid(DrillTower) then
				zrush.f.DrillTower_DrillCycle_Complete(DrillTower)
			end
		end)

		zrush.f.CreateNetEffect("drill_anim_drilldown", DrillTower)
	end
end

// This Stops a drill cycle
function zrush.f.DrillTower_DrillCycle_Stop(DrillTower)
	zrush.f.Debug("zrush.f.DrillTower_DrillCycle_Stop")

	zrush.f.Timer_Remove("zrush_working_" .. DrillTower:EntIndex())

	DrillTower:SetIsRunning(false)

	local sHole = DrillTower:GetHole()

	if (IsValid(sHole)) then
		if (sHole:GetPipes() < sHole:GetNeededPipes() and DrillTower:GetPipes() <= 0) then
			zrush.f.SetMachineState("NEED_PIPES", DrillTower)
		elseif (sHole:GetPipes() < sHole:GetNeededPipes() and DrillTower:GetPipes() > 0) then
			zrush.f.SetMachineState("READY_FOR_WORK", DrillTower)
		else
			zrush.f.SetMachineState("FINISHED_DRILLING", DrillTower)
		end
	end

	zrush.f.CreateNetEffect("drill_anim_idle", DrillTower)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(DrillTower, true)
end

//This function gets called when we complete a drill cycle
function zrush.f.DrillTower_DrillCycle_Complete(DrillTower)
	if (DrillTower:GetJammed()) then return end
	local sHole = DrillTower:GetHole()
	if not IsValid(sHole) then return end

	// Adds a pipe do our hole
	zrush.f.DrillHole_AddPipe(sHole)
	local pipes = DrillTower:GetPipes()
	local newC = math.Clamp(pipes - 1, 0, 1000)
	DrillTower:SetPipes(newC)
	zrush.f.Debug("Drill Cycle Complete (" .. DrillTower:EntIndex() .. ") " .. newC .. " pipes left")

	zrush.f.CreateNetEffect("drill_cycle_complete", DrillTower)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(DrillTower, false)

	// Did we reach the the required Depth
	if sHole:GetPipes() >= sHole:GetNeededPipes() then
		zrush.f.DrillTower_FinishedDrilling(DrillTower)
	else
		// If we did not reach our depth then just reset the drill animation and wait for the timer
		zrush.f.CreateNetEffect("drill_anim_drilldown", DrillTower)


		// Do we still have pipes in the machine?
		if newC <= 0 then
			zrush.f.DrillTower_DrillCycle_Stop(DrillTower)
		end
	end
end

// This function gets called when we fnished drilling
function zrush.f.DrillTower_FinishedDrilling(DrillTower)
	zrush.f.Debug("zrush.f.DrillTower_FinishedDrilling")
	zrush.f.SetMachineState("FINISHED_DRILLING", DrillTower)
	zrush.f.DrillTower_DrillCycle_Stop(DrillTower)

	// If we hole has gas then we remove ourDrillTower
	if zrush.f.DrillHole_HasGas(DrillTower:GetHole()) then
		zrush.f.DrillTower_DeConstruct(DrillTower)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
/////////// DrillPipes Add/Remove //////////
////////////////////////////////////////////

// This spawns a pipeholder
function zrush.f.DrillTower_Spawn_PipeHolders(DrillTower,pos, amount)
	local ent = ents.Create("zrush_drillpipe_holder")
	ent:SetAngles(Angle(0, 0, 0))
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	ent:SetPipeCount(amount)
	local ply = zrush.f.GetOwner(DrillTower)

	if (ply) then
		zrush.f.SetOwner(ent, ply)
	end

	return ent
end

// This emptys all the pipes from the drill complete
function zrush.f.DrillTower_EmptyDrillTower(DrillTower)
	zrush.f.DrillTower_DropPipeHolders(DrillTower,DrillTower:GetPipes())
end

// This drops the specified amount of pipes
function zrush.f.DrillTower_DropPipeHolders(DrillTower,PipeCount)
	if (PipeCount > 0) then
		// Do we have more pipes as the max capacity as a pipeholder can hold?
		if (PipeCount > 10) then
			local totalPipes = PipeCount
			local HolderCount = totalPipes / 10
			local full_HolderCount = math.floor(HolderCount)

			// This spawns the full pipeholders
			for i = 1, full_HolderCount do

				zrush.f.DrillTower_Spawn_PipeHolders(DrillTower,DrillTower:LocalToWorld(Vector(40, 0, 50 * i)), 10)
			end

			local restamount = totalPipes - (full_HolderCount * 10)

			if (restamount > 0) then
				// This spawns the rest amount in a holder
				zrush.f.DrillTower_Spawn_PipeHolders(DrillTower,DrillTower:LocalToWorld(Vector(40, 0, 50)), restamount)
			end
		else

			zrush.f.DrillTower_Spawn_PipeHolders(DrillTower,DrillTower:LocalToWorld(Vector(40, 0, 50)), PipeCount)
		end
	end
end

// This functions adds a pipeholder in the tower
function zrush.f.DrillTower_AddPipesHolder(DrillTower,pipeholder)
	if DrillTower:GetJammed() then return end
	if DrillTower:GetState() == "FINISHED_DRILLING" then return end
	if DrillTower:GetState() == "JAMMED" then return end

	if (CurTime() < (DrillTower.LastPipesAdd or 0)) then
		return
	end

	DrillTower.LastPipesAdd = CurTime() + 1

	local pipes = DrillTower:GetPipes()
	local maxPipe = zrush.f.ReturnBoostValue(DrillTower.MachineID, "pipes", DrillTower)

	// Do we need pipes?
	if pipes < maxPipe then
		// PipesCount the holder has
		local pipeholderPipes = pipeholder:GetPipeCount()
		// The Amount we need
		local needAmount = maxPipe - pipes
		// The Amount we add
		local addAmount = 1

		if (pipeholderPipes > needAmount) then
			addAmount = needAmount
			pipeholder:SetPipeCount(pipeholderPipes - addAmount)
		else
			pipeholder:SetPipeCount(0)
			addAmount = pipeholderPipes
		end

		pipeholder:PipesUpdates()
		zrush.f.CreateNetEffect("drill_loadpipe",DrillTower)
		zrush.f.CreateNetEffect("action_deconnect",DrillTower)

		DrillTower:SetPipes(DrillTower:GetPipes() + addAmount)
		zrush.f.Debug("Added a pipes " .. addAmount)

		if not DrillTower:GetIsRunning() then
			zrush.f.SetMachineState("READY_FOR_WORK", DrillTower)
		end

		zrush.f.DrillTower_DrillCycle_AutoStart(DrillTower)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
////////////// Jammed Event ////////////////
////////////////////////////////////////////

// This tells us if its ready for a event
function zrush.f.DrillTower_ReadyForEvent(DrillTower)
	if (DrillTower:GetIsRunning() and not DrillTower:GetJammed() and DrillTower:GetPipes() > math.Round(zrush.config.Machine["Drill"].MaxHoldPipes * 0.3)) then
		return true
	else
		return false
	end
end

// For The Jam Event
function zrush.f.DrillTower_JamMachine(DrillTower)
	DrillTower:SetJammed(true)

	zrush.f.DrillTower_DrillCycle_Stop(DrillTower)

	zrush.f.SetMachineState("JAMMED", DrillTower)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(DrillTower, true)

	// This Updates the Sound
	zrush.f.UpdateMachineSound(DrillTower)

	// Play Jam Animation
	zrush.f.CreateNetEffect("drill_anim_jammed",DrillTower)
end

function zrush.f.DrillTower_UnJamMachine(DrillTower)
	if (not DrillTower:GetJammed()) then return end
	DrillTower:SetJammed(false)
	zrush.f.SetMachineState("UNJAMMED", DrillTower)

	// This sends a UI update message do all players
	zrush.f.UpdateMachineUI(DrillTower, true)

	zrush.f.DrillTower_DrillCycle_Start(DrillTower)
end
////////////////////////////////////////////
////////////////////////////////////////////
