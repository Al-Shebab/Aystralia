if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

zrush.OilSpotGenerators = zrush.OilSpotGenerators or {}


function zrush.f.OilspotGenerator_Initialize(OilspotGenerator)
	OilspotGenerator:SetModel("models/props_junk/sawblade001a.mdl")
	OilspotGenerator:DrawShadow(false)
	OilspotGenerator:PhysicsInit(SOLID_VPHYSICS)
	OilspotGenerator:SetSolid(SOLID_VPHYSICS)
	OilspotGenerator:SetMoveType(MOVETYPE_NONE)
	OilspotGenerator:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = OilspotGenerator:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	OilspotGenerator.PhysgunDisable = true
	OilspotGenerator.CreatedOilSpots = {}

	table.insert(zrush.OilSpotGenerators,OilspotGenerator)

	zrush.f.EntList_Add(OilspotGenerator)
end

function zrush.f.OilspotGenerator_OnRemove(OilspotGenerator)
	table.RemoveByValue(zrush.OilSpotGenerators,OilspotGenerator)
end




function zrush.f.OilspotGenerator_RemoveOilSpotFromList(OilspotGenerator,oilspot)
	table.RemoveByValue(OilspotGenerator.CreatedOilSpots, oilspot)
end


// This gets called from the global OilSpot generator timer
function zrush.f.OilspotGenerator_RequestOilSpot(OilspotGenerator)
	// Here we check if there is any oilspot in our table thats ready for Deletion
	for k, v in pairs(OilspotGenerator.CreatedOilSpots) do
		if (IsValid(v)) then
			if (v.NoOil_TimeStamp > 0 and zrush.f.Oilspot_ReadyForRefresh(v)) then
				if (v.NoOil_TimeStamp < CurTime()) then
					zrush.f.Oilspot_Remove(v)

				end
			elseif (CurTime() > v.Created_TimeStamp and v.InUse == false) then
				zrush.f.Oilspot_Remove(v)
			end
		end
	end

	// If we allready have the max count of oilspots in our table then we stop here
	if (zrush.f.OilspotGenerator_ReturnValidOilSpot(OilspotGenerator) >= zrush.config.OilSpot_Generator.MaxOilSpots) then return end
	local validPos, validAng = zrush.f.OilspotGenerator_FindValidSpace(OilspotGenerator)

	if (validPos and validAng) then
		zrush.f.OilspotGenerator_SpawnOilSpot(OilspotGenerator,validPos, validAng)
	end
end

// This returns a count of all valid oilspots from the generator
function zrush.f.OilspotGenerator_ReturnValidOilSpot(OilspotGenerator)
	local validOilSpotsCount = 0

	for k, v in pairs(OilspotGenerator.CreatedOilSpots) do
		if (IsValid(v) and not IsValid(OilspotGenerator.DrillHole)) then
			validOilSpotsCount = validOilSpotsCount + 1
		end
	end

	return validOilSpotsCount
end

// Returns a random position in a Radius
function zrush.f.OilspotGenerator_GetRandomPositionInRadius(originalPos, radius)
	local insideRadius = false
	local randomPos
	local HalfRadius = radius / 1.5

	while insideRadius == false do
		randomPos = Vector(originalPos.x + math.Rand(-HalfRadius, HalfRadius), originalPos.y + math.Rand(-HalfRadius, HalfRadius), originalPos.z)

		if (originalPos:Distance(randomPos) < radius) then
			insideRadius = true
		end
	end

	return randomPos
end

// This returns a valid position for a oilspot
function zrush.f.OilspotGenerator_FindValidSpace(OilspotGenerator)
	local validPos, validAng
	local searchRadius = OilspotGenerator:GetSpawnRadius()
	local SearchValidPos, i = true, 1
	local FoundValidPos = true
	local tr
	local tracedata = {}
	local entsInRadius = ents.FindInSphere(OilspotGenerator:GetPos(), searchRadius)

	while SearchValidPos do
		local randomPos = zrush.f.OilspotGenerator_GetRandomPositionInRadius(OilspotGenerator:GetPos() + Vector(0, 0, 50), searchRadius)

		// Here we check if the random pos is not outside of the world
		if (util.IsInWorld(randomPos)) then
			// 164285642
			tracedata.start = randomPos
			tracedata.endpos = randomPos + OilspotGenerator:GetUp() * -1000
			tracedata.filter = OilspotGenerator
			tracedata.mask = MASK_SOLID_BRUSHONLY
			tr = util.TraceLine(tracedata)

			// Here we check if the pos is far enough away from the other oilspots
			for k, v in pairs(entsInRadius) do
				if ((v:GetClass() == "zrush_oilspot" or v:GetClass() == "zrush_drillhole") and zrush.f.InDistance(v:GetPos(), tr.HitPos, zrush.config.Machine["Drill"].NewDrillRadius)) then
					FoundValidPos = false
					break
				end
			end

			if (FoundValidPos) then
				validPos = tr.HitPos
				validAng = tr.HitNormal:Angle()
				validAng:RotateAroundAxis(validAng:Right(), -90)
			end
		end

		i = i + 1

		if (i > zrush.config.OilSpot_Generator.MaxSearchPosCount or FoundValidPos) then
			SearchValidPos = false
		end
	end

	return validPos, validAng
end

// This creates the oilspot
function zrush.f.OilspotGenerator_SpawnOilSpot(OilspotGenerator,pos, ang)
	local ent = ents.Create("zrush_oilspot")
	if not ent:IsValid() then return end
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	OilspotGenerator:DeleteOnRemove(ent)
	local phys = ent:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	ent.OilSpotGenerator = OilspotGenerator
	table.insert(OilspotGenerator.CreatedOilSpots, ent)
end
