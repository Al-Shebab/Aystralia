Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame( 7 ) -- Area Name
		HideHudComponentThisFrame( 9 ) -- Street Name
		HideHudComponentThisFrame( 6 ) -- Vehicle Name
		HideHudComponentThisFrame( 8 ) -- Vehicle Class
	end
end)

Citizen.CreateThread(function() 
	while true do
		InvalidateIdleCam()
		N_0x9e4cfff989258472() --Disable the vehicle idle camera
		Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
	end 
end)