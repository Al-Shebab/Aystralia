function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'ELRP British - https://discord.gg/dxBYUcz')
end)

-- RegisterCommand("poodle",function()
-- 	local model = GetHashKey("a_c_poodle")
-- 	RequestModel(model)
-- 	while (not HasModelLoaded(model)) do
-- 		Wait(1)
-- 	end
-- 	SetPlayerModel(PlayerId(),model)
-- end)

RegisterCommand("register", function()
	TriggerEvent("chatMessage","^6To change your appearance go to a clothes store!")
end)

RegisterCommand("interiorlights",function()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if IsVehicleInteriorLightOn(vehicle) then 
        SetVehicleInteriorlight(vehicle, false)
    else
        SetVehicleInteriorlight(vehicle, true)
    end
end)

AddEventHandler('onClientMapStart', function()
  exports.spawnmanager:setAutoSpawn(true)
  exports.spawnmanager:forceRespawn()
end)
