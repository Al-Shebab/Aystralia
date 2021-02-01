local Entity = FindMetaTable("Entity")

function Entity:WCR_SetChannel(chan)
	self:SetNW2Int("wcr_chan", chan)
end
function Entity:WCR_GetChannel()
	return self:GetNW2Int("wcr_chan")
end

function Entity:WCR_IsCarEntity()
	if not self:IsVehicle() then return false end

	local par = self:GetParent()
	if par:IsValid() then return false end

	if IsValid(self:GetNWEntity("SCarEnt")) then
		return true
	end

	local cls = self:GetClass()
	return cls == "prop_vehicle_jeep" or
		cls == "prop_vehicle_jeep_old" or
		cls:sub(1, 18) == "sent_sakarias_car_"
end

local disabledModelsSet = nil
function Entity:WCR_GetCarEntity()
	if not IsValid(self) then return end

	if not disabledModelsSet then
		disabledModelsSet = {}
		for _,dm in pairs(wyozicr.DisabledModels or {}) do
			disabledModelsSet[dm] = true
		end
	end

	 -- SCars
	local scarent = self:GetNWEntity("SCarEnt")
	if IsValid(scarent) then
		if disabledModelsSet[scarent:GetModel()] then return end
		return scarent
	end

	-- Sit anywhere
	if self:GetClass() == "prop_vehicle_prisoner_pod" and
		not self:GetParent():IsVehicle() then
		return
	end

	-- TDMCar stuff
	if self:GetClass() ~= "prop_vehicle_jeep" then
		local par = self:GetParent()
		if IsValid(par) then
			if disabledModelsSet[par:GetModel()] then return end
			return par
		end
	end

	if disabledModelsSet[self:GetModel()] then return end
	return self
end

function Entity:WCR_IsCarHealthy()
	-- NovaCars
	local health = self:GetNWFloat("VehicleHealth", 999)
	if health <= 0 then
		return false
	end

	return true
end

-- Whether this car entity can _currently_ play radio
function Entity:WCR_HasRadioCapability()
	return self:WCR_IsCarHealthy()
end