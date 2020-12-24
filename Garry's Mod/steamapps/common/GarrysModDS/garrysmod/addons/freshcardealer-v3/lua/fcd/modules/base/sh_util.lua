function fcd.ownsVehicle( ply, class )
	if not ply then return end
	if not class then return end
	
	return table.HasValue( fcd.playerVehicles[ ply:UniqueID() ], class ) or false 
end

function fcd.getVehicleList( class )
	local data = list.Get( 'Vehicles' )[ class ]
	if not data then return false end
	
	return data
end