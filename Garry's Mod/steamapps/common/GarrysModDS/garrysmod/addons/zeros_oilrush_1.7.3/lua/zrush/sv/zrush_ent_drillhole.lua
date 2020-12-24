if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

zrush.DrillHoles = zrush.DrillHoles or {}

function zrush.f.DrillHole_Initialize(DrillHole)
	DrillHole:SetModel( "models/zerochain/props_oilrush/zor_drillhole.mdl")
	DrillHole:PhysicsInit(SOLID_VPHYSICS)
	DrillHole:SetMoveType(MOVETYPE_VPHYSICS)
	DrillHole:SetSolid(SOLID_VPHYSICS)
	DrillHole:SetUseType(SIMPLE_USE)
	DrillHole:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = DrillHole:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	DrillHole:UseClientSideAnimation()
	DrillHole.PhysgunDisabled = true
	DrillHole:SetBodygroup(0, 0)

	if (zrush.config.Machine["DrillHole"].RandomColor) then
		DrillHole:SetColor(HSVToColor(math.Rand(0, 360), 0.4, 0.5))
	else
		DrillHole:SetColor(zrush.config.Machine["DrillHole"].CustomColor)
	end

	// Get DrillHole Information
	local OilHolePool = {}
	for k, v in pairs(zrush.Holes) do
		for i = 1, v.chance do
			table.insert(OilHolePool, k)
		end
	end

	local HoleID = table.Random(OilHolePool)
	DrillHole:SetHoleType(HoleID)
	local HoleData = zrush.Holes[HoleID]
	DrillHole:SetOilAmount(HoleData.oil_amount)
	DrillHole:SetNeededPipes(HoleData.depth)
	DrillHole:SetChaosEventBoost(HoleData.chaos_chance)



	// Setup NetVars
	DrillHole:SetHasDrill(false)
	DrillHole:SetHasBurner(false)
	DrillHole:SetHasPump(false)

	DrillHole.Closed = false
	DrillHole.NoOil_TimeStamp = -1
	DrillHole.LastInteraction_TimeStamp = CurTime()

	zrush.f.SetMachineState("NEED_PIPES", DrillHole)

	table.insert(zrush.DrillHoles,DrillHole)

	zrush.f.EntList_Add(DrillHole)
end

function zrush.f.DrillHole_OnRemove(DrillHole)
	if IsValid(DrillHole.OilSpot) then
		SafeRemoveEntity(DrillHole.OilSpot)
	end

	table.RemoveByValue(zrush.DrillHoles,DrillHole)

	zrush.f.EntList_Remove(DrillHole)
end

////////////////////////////////////////////
//////////////// MAIN LOGIC ////////////////
////////////////////////////////////////////

// This adds a pipe in our Drill Hole
function zrush.f.DrillHole_AddPipe(DrillHole)
	DrillHole:SetPipes(DrillHole:GetPipes() + 1)

	// Custom Hook
	hook.Run("zrush_OnPipeDrilled", DrillHole)

	zrush.f.Debug("Status is:" .. DrillHole:GetPipes() .. "/" .. DrillHole:GetNeededPipes())
end

// This Starts our ButanGas timer
function zrush.f.DrillHole_ButanGasCycle_Start(DrillHole)
	zrush.f.DrillHole_ButanGasCycle_Stop(DrillHole)
	zrush.f.SetMachineState("NEED_BURNER", DrillHole)

	local timerid = "zrush_working_" .. DrillHole:EntIndex()
	zrush.f.Timer_Remove(timerid)
	zrush.f.Timer_Create(timerid, zrush.config.Machine["DrillHole"].ButanGas_Speed, 0, function()
		if IsValid(DrillHole) then
			zrush.f.DrillHole_ButanGasCycle_Complete(DrillHole)
		end
	end)
end

// This Stops our ButanGas timer
function zrush.f.DrillHole_ButanGasCycle_Stop(DrillHole)

	zrush.f.Timer_Remove("zrush_working_" .. DrillHole:EntIndex())
	zrush.f.Debug("Destroyed BurnTimer (" .. DrillHole:EntIndex() .. ")")
end

// This handels the main Butan logic
function zrush.f.DrillHole_ButanGasCycle_Complete(DrillHole)
	if IsValid(DrillHole) and DrillHole:GetState() == "NEED_BURNER" then
		local gas = DrillHole:GetGas()

		if (gas > 0) then
			DrillHole:SetGas(gas - 1)
		else
			// No more gas do emit
			zrush.f.DrillHole_ButanGas_Finished(DrillHole)
		end

		// The Damage gets Handeled via the Damage Handler!
	end
end

// This gets called when all of the gas is gone
function zrush.f.DrillHole_ButanGas_Finished(DrillHole)
	zrush.f.DrillHole_ReachedOil(DrillHole)
end

// Gets called when we finished the drilling
function zrush.f.DrillHole_HasGas(DrillHole)
	local BurnChancePool = {}

	for i = 1, zrush.Holes[DrillHole:GetHoleType()].burnchance do
		table.insert(BurnChancePool, true)
	end

	for i = 1, (100 - (zrush.Holes[DrillHole:GetHoleType()].burnchance)) do
		table.insert(BurnChancePool, false)
	end
	// 164285642
	local NeedsDoBurn = table.Random(BurnChancePool)

	if (NeedsDoBurn) then
		// This adds the gas it needs do burn
		DrillHole:SetGas(zrush.Holes[DrillHole:GetHoleType()].gas_amount)
		zrush.f.DrillHole_ButanGasCycle_Start(DrillHole)

		return true
	else
		zrush.f.DrillHole_ReachedOil(DrillHole)

		return false
	end
end

// Gets called when we reach the Oil
function zrush.f.DrillHole_ReachedOil(DrillHole)
	// This means its ready for the Pump
	zrush.f.SetMachineState("PUMP_READY", DrillHole)
end

// This gets called by the Pump when there is no more oil in the hole
function zrush.f.DrillHole_NoOil(DrillHole)
	zrush.f.SetMachineState("NO_OIL", DrillHole)
	DrillHole.Closed = true
	DrillHole.NoOil_TimeStamp = CurTime()

	if IsValid(DrillHole.OilSpot) then
		zrush.f.Oilspot_Close(DrillHole.OilSpot)
	end

	DrillHole:SetBodygroup(0, 1)
end

// This gets called by the pump do remove oil
function zrush.f.DrillHole_RemoveOil(DrillHole,lamount)
	DrillHole:SetOilAmount(DrillHole:GetOilAmount() - lamount)
end

// This tells us if the DrillHole is Occupied by other entities
function zrush.f.DrillHole_IsOccupied(DrillHole)
	if (DrillHole:GetHasPump() or DrillHole:GetHasDrill() or DrillHole:GetHasBurner() or DrillHole.Closed) then
		return true
	else
		return false
	end
end

// This gets called by all the machines that are using this drillhole
function zrush.f.DrillHole_HadInteraction(DrillHole)
	DrillHole.LastInteraction_TimeStamp = CurTime()
end

// This gets called by the drillhole remover do check if its due do removal
function zrush.f.DrillHole_RemoverCheck(DrillHole)
	if DrillHole:GetHasPump() or DrillHole:GetHasDrill() or DrillHole:GetHasBurner() then return end

	if DrillHole.NoOil_TimeStamp > 0 then
		if (DrillHole.NoOil_TimeStamp + zrush.config.Machine["DrillHole"].PostCooldown) < CurTime() then
			SafeRemoveEntity(DrillHole)
		end
	elseif (DrillHole.LastInteraction_TimeStamp + zrush.config.Machine["DrillHole"].Cooldown) < CurTime() then
		SafeRemoveEntity(DrillHole)
	end
end

////////////////////////////////////////////
////////////////////////////////////////////
