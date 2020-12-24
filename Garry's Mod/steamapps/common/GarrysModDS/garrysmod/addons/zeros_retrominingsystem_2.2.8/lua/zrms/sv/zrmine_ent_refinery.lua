if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Refinery_Initialize(Refinery)
	Refinery.StoredResource = {}
	Refinery.StoredResource["Coal"] = 0
	Refinery.StoredResource["Iron"] = 0
	Refinery.StoredResource["Bronze"] = 0
	Refinery.StoredResource["Silver"] = 0
	Refinery.StoredResource["Gold"] = 0

	zrmine.f.EntList_Add(Refinery)
end

/*
	StateInfo:
	0 = WAITING_FOR_ORDER
	1 = TRANSPORTING
	2 = REFINING
*/


// Sends the specified ressource type to the connected module
function zrmine.f.Refinery_SendResources(Refinery,target, rtype, ramount)
	local sendTable = {}

	local sendAmount = zrmine.f.Calculate_AmountCap(Refinery.StoredResource[rtype], ramount)
	Refinery.StoredResource[rtype] = Refinery.StoredResource[rtype] - sendAmount
	sendTable[rtype] = sendAmount

	zrmine.f.General_ReceiveResources(target,sendTable)

	zrmine.f.General_UpdateNETResource(Refinery)
end

// Returns a stored ressource thats not the refiner type, for trapsport reasons
function zrmine.f.Refinery_NextTransportType(Refinery)
	local NextGiveType = nil

	for k, v in pairs(Refinery.StoredResource) do
		if (k == Refinery.RefinerType) then
			if (v > Refinery.WorkAmount) then
				NextGiveType = k
				break
			end
		elseif (v > 0) then
			NextGiveType = k
			break
		end
	end

	return NextGiveType
end

// Returns the refind amount of ore
function zrmine.f.Refinery_CalculateRefinedOutput(ResourceAmount, resourceType)
	local RefinedOutput = (ResourceAmount / 100) * zrmine.config.ResourceChance[resourceType]

	return RefinedOutput
end

// This returns the id of a valid resource
function zrmine.f.Refinery_FindValidResource(Refinery)
	local validResource = nil

	for k, v in pairs(Refinery.StoredResource) do
		local sendAmount = zrmine.f.Calculate_AmountCap(v, Refinery.WorkAmount)

		if (sendAmount > 0) then
			validResource = k
			break
		end
	end

	return validResource
end




function zrmine.f.Refinery_ModuleUpdate(Refinery)

	if Refinery:GetCurrentState() == 0 and zrmine.f.General_ReturnStorage(Refinery) > 0 then

		local basket = Refinery:GetBasket()
		local cm = Refinery:GetModuleChild()

		if (IsValid(basket) and Refinery.StoredResource[Refinery.RefinerType] > 0) then

			local basketType = basket:GetResourceType()

			if ((basketType == "Empty" or basketType == Refinery.RefinerType) and basket:GetResourceAmount() < zrmine.config.ResourceCrates_Capacity) then
				zrmine.f.Refinery_Refine(Refinery)
			end
		elseif (IsValid(cm)) then

			if (zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount) then
				zrmine.f.Refinery_MoveOre(Refinery)
			end
		else

			if (IsValid(basket) and basket:GetResourceAmount() >= zrmine.config.ResourceCrates_Capacity) then

				// Detaches our crate and places it a bit away from the machine
				zrmine.f.Refinery_DetachBasket(Refinery,basket)
			end
		end
	end
end

function zrmine.f.Refinery_Refine(Refinery)

	local machineTime = Refinery.RefiningTime

	// Sets the current state to busy
	Refinery:SetCurrentState(2)

	// Sends the crushed gravel too the connected module and basked
	timer.Simple(machineTime, function()
		if (IsValid(Refinery)) then

			// Here we calculate the amount we want to send
			local WorkAmount = zrmine.f.Calculate_AmountCap(Refinery.StoredResource[Refinery.RefinerType], Refinery.WorkAmount)

			zrmine.f.Refinery_PlayRefinedGravelAnim(Refinery, Refinery.RefinerType)

			// Plays the give gravel animation if we have some other resources in the inv and a module is connected
			local NextGiveType = zrmine.f.Refinery_NextTransportType(Refinery)
			local NextGiveAmount = 0

			// Custom Hook
			local ply = zrmine.f.GetOwner(Refinery)
			hook.Run("zrmine_OnOreRefined", ply, Refinery, Refinery.RefinerType, WorkAmount)



			if (NextGiveType == Refinery.RefinerType) then
				// We subtract the ore amount we working on right now from our total stored ore amount of that type
				// and multiply it by 0.5 so we give half of the rest amount to the next module
				NextGiveAmount = (Refinery.StoredResource[NextGiveType] - Refinery.WorkAmount) * 0.5
			else
				NextGiveAmount = Refinery.StoredResource[NextGiveType]
			end

			local cm = Refinery:GetModuleChild()
			if (IsValid(cm) and zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount and NextGiveType ~= nil) then
				zrmine.f.Refinery_PlayGravelAnim(Refinery, NextGiveType)
			end

			timer.Simple(2, function()
				if (IsValid(Refinery)) then

					// Here we Remove the amount we processed
					Refinery.StoredResource[Refinery.RefinerType] = Refinery.StoredResource[Refinery.RefinerType] - WorkAmount

					// Here we fill the RefinedOutput in to our basked
					local RefinedOutput = WorkAmount * Refinery.RefineAmount

					local basket = Refinery:GetBasket()

					if (IsValid(basket) and RefinedOutput > 0) then

						zrmine.f.Basket_AddResource(basket, RefinedOutput, Refinery.RefinerType)
						zrmine.f.CreateInsertEffect(basket, Refinery.RefinerType)

						// If our basket got full then we detach it from the refinery
						if basket:GetResourceAmount() >= zrmine.config.ResourceCrates_Capacity then
							zrmine.f.Refinery_DetachBasket(Refinery,basket)
						end
					end

					//Here we send a workamount load of the next valid resource too the connected part if we have one
					if (IsValid(cm) and zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount and NextGiveType ~= nil) then
						zrmine.f.Refinery_SendResources(Refinery,cm, NextGiveType, NextGiveAmount)
					end

					// This makes sure we update our display
					zrmine.f.General_UpdateNETResource(Refinery)

					Refinery:SetCurrentState(0)
				end
			end)
		end
	end)
end

function zrmine.f.Refinery_MoveOre(Refinery)
	local SendResource = zrmine.f.Refinery_FindValidResource(Refinery)

	// Sets the current state to busy
	Refinery:SetCurrentState(1)

	// Plays the give gravel animation
	zrmine.f.Refinery_PlayGravelAnim(Refinery, SendResource)

	// Sends the crushed gravel too the connected module
	timer.Simple(2.35, function()
		if (IsValid(Refinery)) then

			local cm = Refinery:GetModuleChild()

			// Here we send the stored Rest amount to the next module
			if (IsValid(cm) and zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount) then
				zrmine.f.Refinery_SendResources(Refinery,cm, SendResource, Refinery.WorkAmount)
			end

			// This makes sure we update our display
			zrmine.f.General_UpdateNETResource(Refinery)

			Refinery:SetCurrentState(0)
		end
	end)
end






// The Basket
function zrmine.f.Refinery_SpawnBasket(Refinery)
	local ent = ents.Create("zrms_basket")
	ent:SetAngles(Angle(0, 0, 0))
	ent:SetPos(Refinery:GetPos())
	ent:Spawn()
	ent:Activate()
	zrmine.f.Refinery_PlaceBasket(Refinery,ent)
end

// This Attaches the Basket to the Refiner
function zrmine.f.Refinery_PlaceBasket(Refinery,basket)
	if IsValid(Refinery:GetBasket()) then return end

	if (basket:GetResourceType() ~= "Empty" and basket:GetResourceType() ~= Refinery.RefinerType) then return end

	zrmine.f.CreateNetEffect("place_crate",Refinery)

	local pos = Refinery:GetPos() + Refinery:GetUp() * 3 + Refinery:GetRight() * 50
	local ang = Refinery:GetAngles()
	ang:RotateAroundAxis(Refinery:GetUp(), 180)

	basket:SetAngles(ang)
	basket:SetPos(pos)
	basket:SetParent(Refinery)

	local phys = basket:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	Refinery:SetBasket(basket)
end

// This detaches the basket
function zrmine.f.Refinery_DetachBasket(Refinery,basket)

	zrmine.f.CreateNetEffect("place_crate",Refinery)

	Refinery:SetBasket(NULL)

	basket:SetParent(nil)

	local phys = basket:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	local pos = Refinery:GetPos() + Refinery:GetUp() * 3 + Refinery:GetRight() * 50
	basket:SetPos(pos)
end




// Handels the Gravel Animation
function zrmine.f.Refinery_PlayGravelAnim(Refinery, rtype)

	zrmine.f.CreateNetEffect("refinery_refine",Refinery)

	if (rtype == "Iron") then
		Refinery:SetGravelAnim_Type(1)
	elseif (rtype == "Bronze") then
		Refinery:SetGravelAnim_Type(2)
	elseif (rtype == "Silver") then
		Refinery:SetGravelAnim_Type(3)
	elseif (rtype == "Gold") then
		Refinery:SetGravelAnim_Type(4)
	elseif (rtype == "Coal") then
		Refinery:SetGravelAnim_Type(5)
	else
		Refinery:SetGravelAnim_Type(0)
	end

	timer.Simple(2.25, function()
		if IsValid(Refinery) then
			Refinery:SetGravelAnim_Type(-1)
		end
	end)
end

// Handles the Refined Gravel Animation
function zrmine.f.Refinery_PlayRefinedGravelAnim(Refinery, rtype)
	if (rtype == "Iron") then
		Refinery:SetRefineAnim_Type(1)
	elseif (rtype == "Bronze") then
		Refinery:SetRefineAnim_Type(2)
	elseif (rtype == "Silver") then
		Refinery:SetRefineAnim_Type(3)
	elseif (rtype == "Gold") then
		Refinery:SetRefineAnim_Type(4)
	elseif (rtype == "Coal") then
		Refinery:SetRefineAnim_Type(5)
	else
		Refinery:SetRefineAnim_Type(0)
	end

	timer.Simple(Refinery.RefiningTime + 0.25, function()
		if IsValid(Refinery) then
			Refinery:SetRefineAnim_Type(-1)
		end
	end)
end


// Damage Stuff
function zrmine.f.Refinery_OnTakeDamage(Refinery,dmg)
	Refinery:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["Refinery"].EntityHealth

	if (entHealth > 0) then
		Refinery.CurrentHealth = (Refinery.CurrentHealth or entHealth) - damage

		if (Refinery.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Refinery:GetPos())
			Refinery:Remove()
		end
	end
end
