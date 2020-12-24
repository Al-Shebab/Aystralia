if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Crusher_Initialize(Crusher)
	Crusher.StoredResource = {}
	Crusher.StoredResource["Coal"] = 0
	Crusher.StoredResource["Iron"] = 0
	Crusher.StoredResource["Bronze"] = 0
	Crusher.StoredResource["Silver"] = 0
	Crusher.StoredResource["Gold"] = 0

	zrmine.f.EntList_Add(Crusher)
end

// Used for adding gravel via pickaxe rightclick
function zrmine.f.Crusher_AddResource_SWEP(Crusher,gravel, ply)
	if zrmine.f.General_ReturnStorage(Crusher) >= zrmine.config.Crusher_Capacity then

		if (IsValid(ply)) then
			zrmine.f.Notify(ply, zrmine.language.Crusher_Full, 1)
		end

		return
	end

	for k, v in pairs(gravel) do
		Crusher.StoredResource[k] = Crusher.StoredResource[k] + v
	end

	zrmine.f.CreateNetEffect("crusher_addressource",Crusher)

	zrmine.f.General_UpdateNETResource(Crusher)
end

// Used for adding gravel via gravel entity
function zrmine.f.Crusher_AddResource_GRAVEL(Crusher,gravel)

	if zrmine.f.General_ReturnStorage(Crusher) >= zrmine.config.Crusher_Capacity then
		return
	end

	local rType = gravel:GetResourceType()
	Crusher.StoredResource[rType] = Crusher.StoredResource[rType] + gravel:GetResourceAmount()
	gravel:Remove()

	zrmine.f.CreateNetEffect("crusher_addressource",Crusher)

	zrmine.f.General_UpdateNETResource(Crusher)
end

// Used for adding gravel via gravelcrate
function zrmine.f.Crusher_AddResource_CRATE(Crusher,crate)
	if (zrmine.f.General_ReturnStorage(Crusher) >= zrmine.config.Crusher_Capacity) then return end

	if (IsValid(crate)) then
		local coal = crate:GetCoal()
		local iron = crate:GetIron()
		local bronze = crate:GetBronze()
		local silver = crate:GetSilver()
		local gold = crate:GetGold()

		local gTable = {}
		gTable["Coal"] = coal
		gTable["Iron"] = iron
		gTable["Bronze"] = bronze
		gTable["Silver"] = silver
		gTable["Gold"] = gold

		for k, v in pairs(gTable) do
			if (v > 0) then
				local needAmount = zrmine.config.Crusher_Capacity - zrmine.f.General_ReturnStorage(Crusher)
				local addAmount = 0

				if (v > needAmount) then
					addAmount = needAmount
				else
					addAmount = v
				end

				if (zrmine.f.General_ReturnStorage(Crusher) > zrmine.config.Crusher_Capacity) then
					break
				end

				Crusher.StoredResource[k] = Crusher.StoredResource[k] + addAmount

				if (k == "Coal") then
					zrmine.f.Gravelcrate_DecreaseResource(crate, addAmount, "Coal")
				elseif (k == "Iron") then
					zrmine.f.Gravelcrate_DecreaseResource(crate, addAmount, "Iron")
				elseif (k == "Bronze") then
					zrmine.f.Gravelcrate_DecreaseResource(crate, addAmount, "Bronze")
				elseif (k == "Silver") then
					zrmine.f.Gravelcrate_DecreaseResource(crate, addAmount, "Silver")
				elseif (k == "Gold") then
					zrmine.f.Gravelcrate_DecreaseResource(crate, addAmount, "Gold")
				end
			end
		end
	end

	zrmine.f.CreateNetEffect("crusher_addressource",Crusher)

	zrmine.f.General_UpdateNETResource(Crusher)
end


/*
	StateInfo:
	0 = WAITING_FOR_ORDER
	1 = CRUSHING
*/


// Sends the specified ressource type to the connected module
function zrmine.f.Crusher_SendResources(Crusher,rtype)
	if IsValid(Crusher:GetModuleChild()) then
		local sendTable = {}

		local sendAmount = zrmine.f.Calculate_AmountCap(Crusher.StoredResource[rtype], zrmine.config.Crusher_WorkAmount)

		Crusher.StoredResource[rtype] = Crusher.StoredResource[rtype] - sendAmount

		sendTable[rtype] = sendAmount

		zrmine.f.General_ReceiveResources(Crusher:GetModuleChild(),sendTable)

		// Custom Hook
		local ply = zrmine.f.GetOwner(Crusher)
		hook.Run("zrmine_OnOreCrushing", ply, Crusher, rtype, sendAmount)

		zrmine.f.CreateNetEffect("entity_sendressource",Crusher)

		zrmine.f.General_UpdateNETResource(Crusher)
	end
end

// This returns the id of a valid resource we can crush and send to the connected module
function zrmine.f.Crusher_FindValidResource(Crusher)
	local validResource = nil

	local ValidTypes = {}

	for k, v in pairs(Crusher.StoredResource) do
		local sendAmount = zrmine.f.Calculate_AmountCap(v, zrmine.config.Crusher_WorkAmount)

		if (sendAmount > 0) then
			table.insert(ValidTypes,k)
			break
		end
	end

	// This gives us a random ressource pick
	if table.Count(ValidTypes) > 0 then
		validResource = ValidTypes[math.random(#ValidTypes)]
	end

	return validResource
end



// Checks if the child module is ready to receive ressources
function zrmine.f.Crusher_ModuleUpdate(Crusher)
	if (Crusher:GetCurrentState() == 0 and zrmine.f.General_ReturnStorage(Crusher) > 0) then
		local cm = Crusher:GetModuleChild()

		if IsValid(cm) and zrmine.f.General_ReturnStorage(cm) < cm.HoldAmount then
			zrmine.f.Crusher_Crushing(Crusher)
		end
	end
end

// Main Crush Logic
function zrmine.f.Crusher_Crushing(Crusher)

	// Sets the current state to busy
	Crusher:SetCurrentState(1)

	// Returns a valid resource we can send
	local SendResource = zrmine.f.Crusher_FindValidResource(Crusher)

	// Plays the give gravel animation
	timer.Simple(zrmine.config.Crusher_Time / 2, function()
		if IsValid(Crusher) and IsValid(Crusher:GetModuleChild()) then

			// Plays the gravel animation with the correct skin
			zrmine.f.Crusher_PlayGravelAnim(Crusher, SendResource)
		end
	end)

	// Sends the crushed gravel to the connected child
	timer.Simple(zrmine.config.Crusher_Time, function()
		if (IsValid(Crusher)) then
			local mChild = Crusher:GetModuleChild()
			if IsValid(mChild) then

				zrmine.f.Crusher_SendResources(Crusher,SendResource)

				zrmine.f.CreateInsertEffect(mChild, SendResource)
			end

			Crusher:SetCurrentState(0)
		end
	end)
end




// Handels the Gravel Animation
function zrmine.f.Crusher_PlayGravelAnim(Crusher, rtype)

	if (rtype == "Iron") then
		Crusher:SetGravelAnim_Type(1)
	elseif (rtype == "Bronze") then
		Crusher:SetGravelAnim_Type(2)
	elseif (rtype == "Silver") then
		Crusher:SetGravelAnim_Type(3)
	elseif (rtype == "Gold") then
		Crusher:SetGravelAnim_Type(4)
	elseif (rtype == "Coal") then
		Crusher:SetGravelAnim_Type(0)
	else
		Crusher:SetGravelAnim_Type(0)
	end

	timer.Simple(2.25,function()
		if IsValid(Crusher) then
			Crusher:SetGravelAnim_Type(-1)
		end
	end)
end





// Damage Stuff
function zrmine.f.Crusher_OnTakeDamage(Crusher,dmg)
	Crusher:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["Crusher"].EntityHealth

	if (entHealth > 0) then
		Crusher.CurrentHealth = (Crusher.CurrentHealth or entHealth) - damage

		if (Crusher.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Crusher:GetPos())
			Crusher:Remove()
		end
	end
end
