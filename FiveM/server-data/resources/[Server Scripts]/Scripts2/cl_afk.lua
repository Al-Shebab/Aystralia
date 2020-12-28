secondsUntilKick = 1800
kickWarning = true

Citizen.CreateThread(function()
	while true do
		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed)
			currentHeading = GetEntityHeading(playerPed)
			if currentPos == prevPos and currentHeading == previousHeading then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick - 1500) then
						TriggerEvent("chatMessage", "^7^*You're getting kicked in 5 minutes for being ^8^*AFK!")
					end
					if kickWarning and time == math.ceil(secondsUntilKick - 1740) then
						TriggerEvent("chatMessage", "^7^*You're getting kicked in 1 minute for being ^8^*AFK!")
					end
					time = time - 1
				else
					TriggerServerEvent("kick:AFK")
				end
			else
				time = secondsUntilKick
			end
			prevPos = currentPos
			previousHeading = currentHeading
		end
		Wait(1000)
	end
end)