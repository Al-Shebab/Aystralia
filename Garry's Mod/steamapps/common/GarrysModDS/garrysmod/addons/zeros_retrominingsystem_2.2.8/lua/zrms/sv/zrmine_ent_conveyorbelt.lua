if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Belt_Initialize(Belt)

	Belt.StoredResource = {}
	Belt.StoredResource["Coal"] = 0
	Belt.StoredResource["Iron"] = 0
	Belt.StoredResource["Bronze"] = 0
	Belt.StoredResource["Silver"] = 0
	Belt.StoredResource["Gold"] = 0

	Belt.Inserter_EndPart = nil

	Belt.FullInitialized = false

	timer.Simple(0.1, function()
		if (IsValid(Belt)) then
			Belt.FullInitialized = true
		end
	end)

	zrmine.f.EntList_Add(Belt)
end

// Spawns ore
function zrmine.f.Belt_SpawnResource(pos, oreamount, bg, rType)
	local ent = ents.Create("zrms_resource")
	ent:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(0, bg)

	if (rType == "Iron") then
		ent:SetSkin(0)
	elseif (rType == "Bronze") then
		ent:SetSkin(1)
	elseif (rType == "Silver") then
		ent:SetSkin(2)
	elseif (rType == "Gold") then
		ent:SetSkin(3)
	elseif (rType == "Coal") then
		ent:SetSkin(4)
	end

	ent:SetResourceType(tostring(rType))
	ent:SetResourceAmount(oreamount)

	return ent
end

/*
	StateInfo:
	0 = WAITING_FOR_ORDER
	1 = TRANSPORTING
*/


// Here we send resources to our Child
function zrmine.f.Belt_SendResources(Belt,target, rtype)
	local sendTable = {}

	local sendAmount = zrmine.f.Calculate_AmountCap(Belt.StoredResource[rtype], Belt.TransportAmount)

	Belt.StoredResource[rtype] = math.Clamp(Belt.StoredResource[rtype] - sendAmount,0,999999)

	if Belt:GetClass() == "zrms_inserter" then
		// Here we calculate the loss rate of the ore
		sendAmount = math.Clamp(sendAmount - (sendAmount * zrmine.config.Inserter_LossRate),0,9999999)
	end

	if sendAmount > 0.1 then

		sendTable[rtype] = sendAmount
		zrmine.f.General_ReceiveResources(target,sendTable)
	end

	zrmine.f.General_UpdateNETResource(Belt)
end

// Clears all stored Resources
function zrmine.f.Belt_ClearResources(Belt)

	zrmine.f.CreateNetEffect("belt_clear",Belt)

	Belt.StoredResource = Belt.StoredResource or {}
	Belt.StoredResource["Coal"] = 0
	Belt.StoredResource["Iron"] = 0
	Belt.StoredResource["Bronze"] = 0
	Belt.StoredResource["Silver"] = 0
	Belt.StoredResource["Gold"] = 0

	zrmine.f.General_UpdateNETResource(Belt)
end

// Removes a stored Resource
function zrmine.f.Belt_DestroyResource(Belt,rtype, amount)
	zrmine.f.CreateNetEffect("belt_destroyressource",Belt)

	if zrmine.config.Inserter_DeleteOnEndPoint == false then

		local attach = Belt:GetAttachment(Belt:LookupAttachment("output"))

		local stonePos = attach.Pos + Belt:GetUp() * 20
		local yOffset = 2

		if (amount > 0) then
			local junkSize
			stonePos = stonePos + Belt:GetUp() * yOffset

			if (amount > 10) then
				junkSize = 1
			else
				junkSize = 2
			end

			zrmine.f.Belt_SpawnResource(stonePos, amount, junkSize, rtype)

			yOffset = yOffset + 10
		end
	end

	Belt.StoredResource = Belt.StoredResource or {}
	Belt.StoredResource[rtype] = Belt.StoredResource[rtype] - amount

	zrmine.f.General_UpdateNETResource(Belt)
end

// This returns the id of a valid resource
function zrmine.f.Belt_FindValidResource(Belt)
	local validResource = nil

	for k, v in pairs(Belt.StoredResource) do
		local sendAmount = zrmine.f.Calculate_AmountCap(v, Belt.TransportAmount)

		if (sendAmount > 0) then
			validResource = k
			break
		end
	end

	return validResource
end




function zrmine.f.Belt_ModuleUpdate(Belt)
	if Belt:GetCurrentState() == 0 and zrmine.f.General_ReturnStorage(Belt) > 0 then
		local cm = Belt:GetModuleChild()

		if IsValid(cm) and zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount then

			if cm:GetClass() == "zrms_splitter" then

				if (zrmine.f.General_ReturnStorage(cm) < zrmine.config.SplitterBelt_Capacity) then

					zrmine.f.Belt_Transport(Belt)
				end
			else

				zrmine.f.Belt_Transport(Belt)
			end
		elseif Belt:GetClass() == "zrms_inserter" then

			if not IsValid(cm) then
				zrmine.f.Belt_Transport(Belt)
			end
		end
	end
end

function zrmine.f.Belt_Transport(Belt)

	// Sets the current state to busy
	Belt:SetCurrentState(1)
	local SendResource = zrmine.f.Belt_FindValidResource(Belt)

	// Plays the Transport gravel animation
	zrmine.f.Belt_PlayGravelAnim(Belt, SendResource)

	// Sends the gravel to the connected module if not a inserter
	if Belt:GetClass() == "zrms_inserter" then


		timer.Simple(Belt.TransportSpeed - 1.8, function()

			if (IsValid(Belt)) then

				// Here we send the resources or show the discard gravel effect
				local EndPart = Belt:GetModuleChild()

				if IsValid(EndPart) then

					zrmine.f.Belt_SendResources(Belt,EndPart, SendResource)

					zrmine.f.CreateInsertEffect(EndPart, SendResource)
				else

					// If we dont have a endpart then we output the ressource to the world or destroy it
					zrmine.f.Inserter_OutputRessource(Belt,SendResource)
				end
			end
		end)

		timer.Simple(Belt.TransportSpeed + 0.3, function()

			if IsValid(Belt) then

				Belt:SetCurrentState(0)
			end
		end)
	else
		timer.Simple(Belt.TransportSpeed, function()

			if (IsValid(Belt)) then

				// Here we send the resources or show the discard gravel effect
				local cm = Belt:GetModuleChild()

				if IsValid(cm) then

					if (zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount) then
						zrmine.f.Belt_SendResources(Belt,cm, SendResource)
						zrmine.f.CreateInsertEffect(cm, SendResource)
					end

				else
					local sendAmount = zrmine.f.Calculate_AmountCap(Belt.StoredResource[SendResource], Belt.TransportAmount)
					zrmine.f.Belt_DestroyResource(Belt,SendResource, sendAmount)
				end

			end
		end)

		timer.Simple(Belt.TransportSpeed + 0.1, function()
			if (IsValid(Belt)) then
				Belt:SetCurrentState(0)
			end
		end)
	end
end

function zrmine.f.Inserter_OutputRessource(inserter,SendResource)

	local attach = inserter:GetAttachment(inserter:LookupAttachment("output"))
	local EndPoint = attach.Pos + inserter:GetUp() * 24 + inserter:GetForward() * 5

	local CloseGravelCrate

	for k, v in pairs(zrmine.EntList) do

		if IsValid(v) and string.sub(v:GetClass(), 1, 16) == "zrms_gravelcrate" and zrmine.f.InDistance(EndPoint, v:GetPos(), 100) then
			CloseGravelCrate = v
			break
		end
	end

	local sendAmount = zrmine.f.Calculate_AmountCap(inserter.StoredResource[SendResource], inserter.TransportAmount)

	if inserter:GetClass() == "zrms_inserter" then
		// Here we calculate the loss rate of the ore
		sendAmount = math.Clamp(sendAmount - (sendAmount * zrmine.config.Inserter_LossRate),0.1,9999999)
	end

	// If there is a valid gravelcrate in distance that still has space for some ressource then we fill it instead of destroying the gravel
	if IsValid(CloseGravelCrate) and  zrmine.f.Gravelcrate_ReturnStoredAmount(CloseGravelCrate) < zrmine.config.GravelCrates_Capacity then

		local rtable = {}
		rtable[SendResource] = sendAmount

		zrmine.f.Gravelcrate_AddResource(CloseGravelCrate,rtable, nil)

		inserter.StoredResource = inserter.StoredResource or {}
		inserter.StoredResource[SendResource] = inserter.StoredResource[SendResource] - sendAmount

		zrmine.f.General_UpdateNETResource(inserter)
	else

		zrmine.f.Belt_DestroyResource(inserter,SendResource, sendAmount)
	end
end
// 164285642



// Inserter Functions
// Checks if the child of the inserter is still valid, otherwhise researches for a new child
function zrmine.f.Inserter_VerifyConnection(inserter)

	if not IsValid(inserter:GetModuleChild()) then
		zrmine.f.Inserter_SearchEndPart(inserter)
	end
end

// Returns the nearest entity from the list
function zrmine.f.Inserter_FindNearestEntity(inserter,aents, pos, range)
	local nearestEnt

	local ClosestDist = 9999

	for i, entity in ipairs(aents) do
		if IsValid(entity) and zrmine.f.InDistance(pos, entity:GetPos(), range) and zrmine.f.InDistance(pos, entity:GetPos(), ClosestDist) then
			ClosestDist = entity:GetPos():Distance(pos)
			nearestEnt = entity
		end
	end

	return nearestEnt
end

// Searches for a ChildModule in distance of inserter
function zrmine.f.Inserter_SearchEndPart(inserter)
	local attach = inserter:GetAttachment(inserter:LookupAttachment("output"))

	local searchPos = attach.Pos + attach.Ang:Forward() * 7

	local searchSize = 55

	zrmine.f.Debug_Sphere(searchPos, searchSize, 3, Color(0, 255, 0, 100), false)

	local validEnts = {}

	for k, v in pairs(zrmine.EntList) do
		if IsValid(v) and zrmine.f.InDistance(searchPos, v:LocalToWorld(v:OBBCenter()), searchSize) and string.sub(v:GetClass(), 1, 17) == "zrms_conveyorbelt" then
			table.insert(validEnts, v)
		end
	end

	local nearestEnt = zrmine.f.Inserter_FindNearestEntity(inserter,validEnts, searchPos, searchSize)

	if (IsValid(nearestEnt)) then
		inserter:SetModuleChild(nearestEnt)
	end
end






// Handels the Gravel Animation
function zrmine.f.Belt_PlayGravelAnim(Belt, rtype)

	if (rtype == "Iron") then
		Belt:SetGravelAnim_Type(1)
	elseif (rtype == "Bronze") then
		Belt:SetGravelAnim_Type(2)
	elseif (rtype == "Silver") then
		Belt:SetGravelAnim_Type(3)
	elseif (rtype == "Gold") then
		Belt:SetGravelAnim_Type(4)
	elseif (rtype == "Coal") then
		Belt:SetGravelAnim_Type(5)
	else
		Belt:SetGravelAnim_Type(0)
	end

	timer.Simple(Belt.TransportSpeed + 0.25, function()
		if IsValid(Belt) then
			Belt:SetGravelAnim_Type(-1)
		end
	end)
end



// Custom Hook
// Verifys if the connection between inserter and child module still exists
hook.Add("zrms_VerifyInserterConnection", "a_zrmine_InserterConnectionUpdater", function()

	for k, v in pairs(zrmine.EntList) do

		if IsValid(v) and v:GetClass() == "zrms_inserter" then

			zrmine.f.Inserter_VerifyConnection(v)
		end
	end
end)


// Damage Stuff
function zrmine.f.Belt_OnTakeDamage(Belt,dmg)
	Belt:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["Conveyorbelt"].EntityHealth

	if (entHealth > 0) then
		Belt.CurrentHealth = (Belt.CurrentHealth or entHealth) - damage

		if (Belt.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Belt:GetPos())
			Belt:Remove()
		end
	end
end
