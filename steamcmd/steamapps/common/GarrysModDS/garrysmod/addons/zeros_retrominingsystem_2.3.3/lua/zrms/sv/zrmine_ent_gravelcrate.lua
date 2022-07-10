if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Gravelcrate_Initialize(Gravelcrate)
	zrmine.f.EntList_Add(Gravelcrate)
end

function zrmine.f.Gravelcrate_OnTouch(Gravelcrate,other)
	if not IsValid(other) then return end

	if zrmine.config.SharedOwnership == false and zrmine.f.OwnerID_Check(Gravelcrate,other) == false then return end


	if (other:GetClass() == "zrms_crusher" and zrmine.f.Gravelcrate_ReturnStoredAmount(Gravelcrate) > 0) then

		if zrmine.f.CollisionCooldown(other) then return end

		zrmine.f.Crusher_AddResource_CRATE(other,Gravelcrate)
	end
end

function zrmine.f.Gravelcrate_AddResource(Gravelcrate,rtable, ply)
	for k, v in pairs(rtable) do
		if (v > 0) then
			if (k == "Iron") then
				Gravelcrate:SetIron(math.Round(Gravelcrate:GetIron() + v,1))
			elseif (k == "Bronze") then
				Gravelcrate:SetBronze(math.Round(Gravelcrate:GetBronze() + v,1))
			elseif (k == "Silver") then
				Gravelcrate:SetSilver(math.Round(Gravelcrate:GetSilver() + v,1))
			elseif (k == "Gold") then
				Gravelcrate:SetGold(math.Round(Gravelcrate:GetGold() + v,1))
			elseif (k == "Coal") then
				Gravelcrate:SetCoal(math.Round(Gravelcrate:GetCoal() + v,1))
			end
		end
	end
end

function zrmine.f.Gravelcrate_ResourceJunk(Gravelcrate,gravel)

	if zrmine.f.Gravelcrate_ReturnStoredAmount(Gravelcrate) >= zrmine.config.GravelCrates_Capacity then
		return
	end

	local rtype = gravel:GetResourceType()
	local ramount = gravel:GetResourceAmount()

	if (rtype == "Iron") then
		Gravelcrate:SetIron(Gravelcrate:GetIron() + ramount)
	elseif (rtype == "Bronze") then
		Gravelcrate:SetBronze(Gravelcrate:GetBronze() + ramount)
	elseif (rtype == "Silver") then
		Gravelcrate:SetSilver(Gravelcrate:GetSilver() + ramount)
	elseif (rtype == "Gold") then
		Gravelcrate:SetGold(Gravelcrate:GetGold() + ramount)
	elseif (rtype == "Coal") then
		Gravelcrate:SetCoal(Gravelcrate:GetCoal() + ramount)
	end

	gravel:Remove()
end

function zrmine.f.Gravelcrate_ReturnStoredAmount(Gravelcrate)
	local storedAmount = Gravelcrate:GetIron() + Gravelcrate:GetBronze() + Gravelcrate:GetSilver() + Gravelcrate:GetGold() + Gravelcrate:GetCoal()

	return storedAmount
end

function zrmine.f.Gravelcrate_DecreaseResource(Gravelcrate,amount, rtype)
	if (rtype == "Iron") then
		Gravelcrate:SetIron(Gravelcrate:GetIron() - amount)
	elseif (rtype == "Bronze") then
		Gravelcrate:SetBronze(Gravelcrate:GetBronze() - amount)
	elseif (rtype == "Silver") then
		Gravelcrate:SetSilver(Gravelcrate:GetSilver() - amount)
	elseif (rtype == "Gold") then
		Gravelcrate:SetGold(Gravelcrate:GetGold() - amount)
	elseif (rtype == "Coal") then
		Gravelcrate:SetCoal(Gravelcrate:GetCoal() - amount)
	end

	if zrmine.f.Gravelcrate_ReturnStoredAmount(Gravelcrate) <= 0 then
		if (zrmine.config.GravelCrates_ReUse == false) then
			Gravelcrate:Remove()
		else
			zrmine.f.Gravelcrate_EmptyBasket(Gravelcrate)
		end
	end
end

function zrmine.f.Gravelcrate_EmptyBasket(Gravelcrate)
	Gravelcrate:SetIron(0)
	Gravelcrate:SetBronze(0)
	Gravelcrate:SetSilver(0)
	Gravelcrate:SetGold(0)
	Gravelcrate:SetCoal(0)
end
