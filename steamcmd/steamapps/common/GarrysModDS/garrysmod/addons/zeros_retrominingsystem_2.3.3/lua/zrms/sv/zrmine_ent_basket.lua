if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.Basket_AddResource(Basket, amount, rtype)
	Basket:SetResourceType(rtype)
	Basket:SetResourceAmount(Basket:GetResourceAmount() + amount)
end

function zrmine.f.Basket_DecreaseResource(Basket, amount, rtype)
	Basket:SetResourceType(rtype)
	Basket:SetResourceAmount(Basket:GetResourceAmount() - amount)

	if Basket:GetResourceAmount() <= 0 then
		zrmine.f.Basket_EmptyBasket(Basket)
	end
end

function zrmine.f.Basket_EmptyBasket(Basket)
	Basket:SetResourceType("Empty")
	Basket:SetResourceAmount(0)
end

function zrmine.f.Basket_StartTouch(Basket,other)
	if not IsValid(other) then return end
	if zrmine.f.CollisionCooldown(other) then return end

	if zrmine.config.SharedOwnership == false and zrmine.f.OwnerID_Check(Basket,other) == false then return end

	if other:GetClass() == "zrms_melter" then

		local basket_rAmount = Basket:GetResourceAmount()
		local basket_rType = Basket:GetResourceType()


		if (basket_rAmount <= 0 and basket_rType == "Empty") then
			zrmine.f.Melter_CollectResource(other,Basket)
		elseif (basket_rType == "Coal") then
			zrmine.f.Melter_AddCoal(other,Basket)
		elseif (basket_rType ~= "Empty") then
			zrmine.f.Melter_AddResource(other,Basket, nil)
		end
	elseif string.sub(other:GetClass(), 1, 12) == "zrms_refiner" then
		timer.Simple(0,function()
			if IsValid(other) and IsValid(Basket) then
				zrmine.f.Refinery_PlaceBasket(other,Basket)
			end
		end)
	elseif (string.sub(other:GetClass(), 1, 11) == "zrms_basket") then

		local c_Refinery = other:GetParent()

		local s_type = Basket:GetResourceType()
		local s_amount = Basket:GetResourceAmount()

		local o_type = other:GetResourceType()
		local o_amount = other:GetResourceAmount()

		-- Here we fill the resource amount in to another basket and subtracting it from itself
		if (not IsValid(c_Refinery) and (s_type == o_type or o_type == "Empty") and o_amount < zrmine.config.ResourceCrates_Capacity and other.IsMergingResoures == false) then

			Basket.IsMergingResoures = true

			local o_Space = zrmine.config.ResourceCrates_Capacity - o_amount

			local add_amount = 0

			if (s_amount >= o_Space) then
				add_amount = o_Space
			else
				add_amount = s_amount
			end

			zrmine.f.Debug("Entity: [" .. Basket:EntIndex() .. "] AmountToAdd: " .. add_amount)

			zrmine.f.Basket_AddResource(other, add_amount, s_type)

			zrmine.f.Basket_DecreaseResource(Basket, add_amount, s_type)

			timer.Simple(1,function()
				if IsValid(other) then

					Basket.IsMergingResoures = false
				end
			end)
		end
	end
end


-- Empty Refiner Crate
hook.Add("PlayerButtonDown", "a_zrmine_PlayerButtonDown_EmptyRefinerCrate", function(ply, key)
	if key == MOUSE_MIDDLE and IsValid(ply) then
		local tr = ply:GetEyeTrace()

		if tr.Hit and tr.HitSky == false and zrmine.f.InDistance(ply:GetPos(), tr.HitPos, 500) and IsValid(tr.Entity) and string.sub(tr.Entity:GetClass(), 1, 11) == "zrms_basket" and not IsValid(tr.Entity:GetParent()) then
			if (zrmine.config.ResourceCrates_Sharing) then

				zrmine.f.CreateNetEffect("entity_despawn",tr.Entity)
				zrmine.f.Basket_EmptyBasket(tr.Entity)
			else
				if not zrmine.f.IsOwner(ply, tr.Entity) then
					zrmine.f.Notify(ply, zrmine.language.Module_DontOwn, 1)
				else
					zrmine.f.CreateNetEffect("entity_despawn",tr.Entity)
					zrmine.f.Basket_EmptyBasket(tr.Entity)
				end
			end
		end
	end
end)
