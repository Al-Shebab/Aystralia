ITEM.Name = "Fuel Barrel"
ITEM.Description = "A Barrel of Fuel"
ITEM.Model = "models/zerochain/props_oilrush/zor_barrel.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetName()
	local name = self.Name
	local fuelID = self:GetData("FuelTypeID")
	local fuelamount = self:GetData("FuelAmount")
	local oil = self:GetData("OilAmount")

	if fuelamount > 0 then
		if (zrush.Fuel[fuelID]) then
			name = zrush.Fuel[fuelID].name .. " Barrel"
		else
			name = "[Not Valid Fuel] Barrel"
		end
	elseif (oil > 0) then
		name = "Oil Barrel"
	else
		name = "Empty Barrel"
	end

	return self:GetData("Name", name)
end

function ITEM:GetDescription()
	local desc = self.Description

	local fuelamount = self:GetData("FuelAmount")
	local oil = self:GetData("OilAmount")

	if fuelamount > 0 then
		desc = "Fuel: " .. tostring(math.Round(fuelamount))
	elseif (oil > 0) then
		desc = "Oil: " .. tostring(math.Round(oil))
	else
		desc = "Empty"
	end

	return self:GetData("Description", desc)
end

function ITEM:GetColor()
	local col = zrush.default_colors["grey02"]
	local fuelamount = self:GetData("FuelAmount")

	if (fuelamount > 0) then
		local fuelID = self:GetData("FuelTypeID")

		if (zrush.Fuel[fuelID]) then
			col = zrush.Fuel[fuelID].color
		else
			col = zrush.default_colors["white01"]
		end
	else
		col = zrush.default_colors["white01"]
	end

	return self:GetData("Color", col)
end

function ITEM:CanPickup(pl, ent)
	if not IsValid(ent.Machine) then

		if zrush.config.Barrel.Owner_PickUpCheck and not zrush.f.IsOwner(pl, ent) then
			zrush.f.Notify(pl, zrush.language.General["YouDontOwnThis"], 1)
			return false
		end

		if (ent:GetFuel() > 0 and ent:GetFuelTypeID() > 0) then

			if not zrush.f.BarrelRank_PickUpCheck(pl, zrush.Fuel[ent:GetFuelTypeID()].ranks) then
				zrush.f.Notify(pl, zrush.language.VGUI["WrongUserGroup"], 1)

				return false
			else
				return true
			end

		elseif (ent:GetOil() > 0) then
			return true
		else
			return true
		end

	else
		return false
	end
end

function ITEM:SaveData(ent)
	self:SetData("OilAmount", ent:GetOil())
	self:SetData("FuelTypeID", ent:GetFuelTypeID())
	self:SetData("FuelAmount", ent:GetFuel())
	self:SetData("ZRushOwner", zrush.f.GetOwnerID(ent))
end

function ITEM:LoadData(ent)
	ent:SetOil(self:GetData("OilAmount"))
	ent:SetFuel(self:GetData("FuelAmount"))
	ent:SetFuelTypeID(self:GetData("FuelTypeID"))

	if SERVER then
		zrush.f.SetOwnerID(ent, self:GetData("ZRushOwner"))
	end
end
