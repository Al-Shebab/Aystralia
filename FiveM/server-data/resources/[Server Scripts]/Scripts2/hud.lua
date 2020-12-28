Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame( 7 ) -- Area Name
		HideHudComponentThisFrame( 9 ) -- Street Name
		HideHudComponentThisFrame( 6 ) -- Vehicle Name
		HideHudComponentThisFrame( 8 ) -- Vehicle Class
		HideHudComponentThisFrame( 3 ) -- SP Cash display 
		HideHudComponentThisFrame( 4 )  -- MP Cash display
		HideHudComponentThisFrame( 20 ) -- Gun Stats
		HideHudComponentThisFrame( 21 ) -- Gun Stats
		HideHudComponentThisFrame( 22 ) -- Gun Stats
	end
end)

Citizen.CreateThread(function() 
	while true do
		InvalidateIdleCam()
		N_0x9e4cfff989258472() --Disable the vehicle idle camera
		Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
	end 
end)