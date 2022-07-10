if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Melter_Initialize(Melter)
	zrmine.f.EntList_Add(Melter)
end

/*
	 StateInfo:
	 0 = WAITING_FOR_ORDER
	 1 = CHAMBER_FULL
	 2 = MELTING
	 3 = UNLOADING
*/

// Coal
function zrmine.f.Melter_AddCoal(Melter,coal)

	local mCoal = Melter:GetCoalAmount()
	if mCoal < zrmine.config.Melter_Coal_Capacity then

		local bCoal = coal:GetResourceAmount()

		local sAmount = zrmine.config.Melter_Coal_Capacity - mCoal
		local tAmount

		if sAmount > bCoal then
			tAmount = bCoal
		else
			tAmount = sAmount
		end

		if tAmount >= bCoal then
			if (zrmine.config.ResourceCrates_ReUse) then
				zrmine.f.Basket_EmptyBasket(coal)
			else
				coal:Remove()

				zrmine.f.CreateNetEffect("crate_break",Melter)
			end
		else
			zrmine.f.Basket_DecreaseResource(coal, tAmount, "Coal")
		end

		Melter:SetCoalAmount(mCoal + tAmount)
	end

	zrmine.f.Melter_MeltingCheck(Melter)
end

function zrmine.f.Melter_RemoveCoal(Melter,coal)
	if Melter:GetCoalAmount() > 0 then
		Melter:SetCoalAmount(math.Clamp(Melter:GetCoalAmount() - coal,0,99999))
	end

	zrmine.f.Melter_MeltingCheck(Melter)
end


// Ressources
function zrmine.f.Melter_AddResource(Melter,crate)
	if Melter:GetCurrentState() ~= 0 then return end

	//if zrmine.f.OwnerID_Check(Melter,crate) == false then return end

	local rType = crate:GetResourceType()
	local rAmount = crate:GetResourceAmount()

	if (Melter:GetResourceType() == "Empty" or Melter:GetResourceType() == rType) then

		if (Melter:GetResourceAmount() < zrmine.config.Melter_Vars[rType].OreAmount) then

			Melter:SetResourceType(rType)
			local needAmount = zrmine.config.Melter_Vars[rType].OreAmount - Melter:GetResourceAmount()

			if (needAmount >= rAmount) then

				if (zrmine.config.ResourceCrates_ReUse) then

					zrmine.f.Basket_EmptyBasket(crate)
					crate:SetPos(Melter:GetPos() + Melter:GetUp() * 75)
					zrmine.f.CreateNetEffect("crusher_addressource",Melter)

				else
					crate:Remove()
					zrmine.f.CreateNetEffect("crate_break",Melter)
				end

				Melter:SetResourceAmount(Melter:GetResourceAmount() + rAmount)
			else
				zrmine.f.CreateNetEffect("crusher_addressource",Melter)
				Melter:SetResourceAmount(Melter:GetResourceAmount() + needAmount)

				zrmine.f.Basket_DecreaseResource(crate, needAmount, rType)

				crate:SetPos(Melter:GetPos() + Melter:GetUp() * 75)
			end
		end

		if (Melter:GetResourceAmount() >= zrmine.config.Melter_Vars[rType].OreAmount) then

			Melter:SetCurrentState(1)
		end
	end

	zrmine.f.Melter_MeltingCheck(Melter)
end

function zrmine.f.Melter_CollectResource(Melter,crate)
	local InvAmount = Melter:GetResourceAmount()
	local FillAmount

	if ((Melter:GetCurrentState() == 0 or Melter:GetCurrentState() == 1) and InvAmount > 0) then

		if (InvAmount > zrmine.config.ResourceCrates_Capacity) then
			FillAmount = zrmine.config.ResourceCrates_Capacity
		else
			FillAmount = InvAmount
		end

		zrmine.f.Basket_AddResource(crate, FillAmount, Melter:GetResourceType())
		Melter:SetResourceAmount(InvAmount - FillAmount)

		zrmine.f.CreateNetEffect("crusher_addressource",Melter)

		if Melter:GetResourceAmount() <= 0 then
			Melter:SetCurrentState(0)
			Melter:SetResourceType("Empty")
			Melter:SetResourceAmount(0)
		end
	end
end
// 164285642



function zrmine.f.Melter_MeltingCheck(Melter)
	local rType = Melter:GetResourceType()
	local cState = Melter:GetCurrentState()
	local MelterData = zrmine.config.Melter_Vars[rType]

	if (rType ~= "Empty" and Melter:GetResourceAmount() >= MelterData.OreAmount and Melter:GetCoalAmount() >= MelterData.CoalAmount and cState ~= 2 and cState ~= 3) then
		zrmine.f.Melter_StartMelting(Melter)
	end
end

function zrmine.f.Melter_StartMelting(Melter)
	Melter:SetCurrentState(2)

	timer.Simple(2, function()
		if (IsValid(Melter)) then

			Melter:SetIsLowered(true)
			zrmine.f.Melter_RemoveCoal(Melter,zrmine.config.Melter_Vars[Melter:GetResourceType()].CoalAmount)
		end
	end)

	timer.Simple(zrmine.config.Melter_Vars[Melter:GetResourceType()].MeltDuration + 3, function()
		if (IsValid(Melter)) then
			zrmine.f.Melter_Unloading(Melter)
		end
	end)
end

function zrmine.f.Melter_Unloading(Melter)
	Melter:SetCurrentState(3)
	Melter:SetIsLowered(false)

	timer.Simple(zrmine.config.Melter_UnloadTime, function()
		if IsValid(Melter) then
			zrmine.f.Melter_CoolingBars(Melter)
		end
	end)
end

function zrmine.f.Melter_CoolingBars(Melter)
	local rType = Melter:GetResourceType()

	timer.Simple(zrmine.config.Melter_Vars[rType].CoolingTime + 1.75, function()
		if IsValid(Melter) then

			zrmine.f.Melter_UnloadingBars(Melter,rType)

			local ply = zrmine.f.GetOwner(Melter)
			hook.Run("zrmine_OnMelting", ply, Melter,rType)
		end
	end)

	timer.Simple(zrmine.config.Melter_Vars[rType].CoolingTime + 4, function()
		if (IsValid(Melter)) then
			zrmine.f.Melter_EmptyMelter(Melter)
		end
	end)
end

// Spawns the Metal Bars
function zrmine.f.Melter_UnloadingBars(Melter,btype)
	local delay = 0

	for i = 1, 6 do
		timer.Simple(delay, function()
			local ent = ents.Create("zrms_bar")
			local ang = Melter:GetAngles()
			ang:RotateAroundAxis(Melter:GetRight(), -60)
			ent:SetAngles(ang)
			ent:SetPos(Melter:GetPos() + Melter:GetUp() * 45 + Melter:GetForward() * -55 + Melter:GetRight() * -22 + Melter:GetRight() * (6 * i))
			ent:Spawn()
			ent:Activate()
			ent:SetMetalType(btype)
			ent:UpdateVisuals()

			if Melter.PublicEntity then
				// Giving it nil will set the id to "world"
				zrmine.f.SetOwner(ent, nil)

			else
				zrmine.f.SetOwner(ent, zrmine.f.GetOwner(Melter))
			end
		end)

		delay = delay + 0.05
	end
end

function zrmine.f.Melter_EmptyMelter(Melter)
	Melter:SetCurrentState(0)
	Melter:SetResourceType("Empty")
	Melter:SetResourceAmount(0)
end



// Damage Stuff
function zrmine.f.Melter_OnTakeDamage(Melter,dmg)
	Melter:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["Melter"].EntityHealth

	if (entHealth > 0) then
		Melter.CurrentHealth = (Melter.CurrentHealth or entHealth) - damage

		if (Melter.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Melter:GetPos())
			Melter:Remove()
		end
	end
end
