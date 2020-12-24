function fcd.precacheModels()
	for k, v in pairs( fcd.dataVehicles ) do
		local data = fcd.getVehicleList( v.id )
		if not data then return end
		
		util.PrecacheModel( data.Model or '' )
	end
end

hook.Add( 'InitPostEntity', 'fcd.precacheModels', fcd.precacheModels )