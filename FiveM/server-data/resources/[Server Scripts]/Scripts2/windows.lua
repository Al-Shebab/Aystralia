local windowup = true
RegisterNetEvent("roll")
AddEventHandler('roll', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then 
            SetEntityAsMissionEntity( playerCar, true, true )
		
			if ( windowup ) then
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				TriggerEvent('chatMessage', '', {255,0,0}, 'Windows down')
				windowup = false
			else
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				TriggerEvent('chatMessage', '', {255,0,0}, 'Windows up')
				windowup = true
			end
		end
	end
end )

RegisterCommand("Roll", function(source, args, raw)
    TriggerEvent("roll")
end, false) --False, allow everyone to run it(thnx @Havoc)
RegisterCommand("Windows", function(source, args, raw)
    TriggerEvent("roll")
end, false) --False, allow everyone to run it(thnx @Havoc)