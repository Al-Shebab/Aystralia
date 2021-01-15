if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

zrush.OilSpots = zrush.OilSpots or {}


function zrush.f.Oilspot_Initialize(Oilspot)
	Oilspot:SetModel("models/zerochain/props_oilrush/zor_oilspot.mdl")
	Oilspot:PhysicsInit(SOLID_VPHYSICS)
	Oilspot:SetMoveType(MOVETYPE_VPHYSICS)
	Oilspot:SetSolid(SOLID_VPHYSICS)
	Oilspot:SetUseType(SIMPLE_USE)
	Oilspot:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	Oilspot:DrawShadow(false)

	local phys = Oilspot:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	Oilspot.InUse = false
	Oilspot.NoOil_TimeStamp = -1
	Oilspot.Created_TimeStamp = CurTime() + zrush.config.OilSpot_Generator.MaxLifeTime
	Oilspot.DrillHole = nil

	table.insert(zrush.OilSpots,Oilspot)

	zrush.f.EntList_Add(Oilspot)
end

function zrush.f.Oilspot_OnRemove(Oilspot)
	table.RemoveByValue(zrush.OilSpots,Oilspot)
end

// Connects the OilSpot with a DrillHole
function zrush.f.Oilspot_Drill(Oilspot,Drillhole)
	Oilspot.InUse = true
	Oilspot:SetNoDraw(true)
	Oilspot.DrillHole = Drillhole
	Oilspot:SetHasDrillHole(true)
	Drillhole.OilSpot = Oilspot
end

// Sets the time at which the oilspot got closed for later refresh
function zrush.f.Oilspot_Close(Oilspot)
	Oilspot.NoOil_TimeStamp = CurTime() + zrush.config.OilSpot.Cooldown
end

// Checks if the Oilspot is ready to get refreshed
function zrush.f.Oilspot_ReadyForRefresh(Oilspot)
	if not Oilspot.DrillHole:GetHasPump() and not Oilspot.DrillHole:GetHasDrill() and not Oilspot.DrillHole:GetHasBurner() then
		return true
	else
		return false
	end
end

// Called to correctly remove the oilspot
function zrush.f.Oilspot_Remove(Oilspot)
	if IsValid(Oilspot.DrillHole) then

		SafeRemoveEntity(Oilspot.DrillHole)
		Oilspot:SetHasDrillHole(false)
	end

	SafeRemoveEntity(Oilspot)
end

// Resets the OilSpot
function zrush.f.Oilspot_Reset(Oilspot)
	zrush.f.Debug(Oilspot:EntIndex() .. " OilSpot Reset!")
	Oilspot.InUse = false
	Oilspot.NoOil_TimeStamp = -1
	Oilspot:SetNoDraw(false)

	if IsValid(Oilspot.DrillHole) then
		SafeRemoveEntity(Oilspot.DrillHole)
		Oilspot:SetHasDrillHole(false)
	end
end
