local function isTracked(cls)
	return cls == "prop_vehicle_jeep" or cls == "prop_vehicle_jeep_old" or cls:match("^sent_sakarias_car_")
end

local carents = setmetatable({}, {__mode = "v"})
for _,e in pairs(ents.GetAll()) do if isTracked(e:GetClass()) then table.insert(carents, e) end end
hook.Add(SERVER and "OnEntityCreated" or "NetworkEntityCreated", "CarRadio_CarTracker", function(e)
	if isTracked(e:GetClass()) then table.insert(carents, e) end
end)
hook.Add("EntityRemoved", "CarRadio_CarTracker", function(e)
	if isTracked(e:GetClass()) then table.RemoveByValue(carents, e) end
end)

function wyozicr.GetCarEnts()
	return carents
end
