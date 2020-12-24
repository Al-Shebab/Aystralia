function fcd.vehicleRemoved( ent )
	if ent:IsVehicle() then
		if ent.owner then
			local ply = ent.owner
			if not IsValid( ply ) then return end

			ply.curVehicle = nil
		end
	end
end

hook.Add( 'EntityRemoved', 'fcd.vehicleRemoved', fcd.vehicleRemoved )

function fcd.platformGrab( ply, ent )
	if ent:GetClass() == 'vehicleplatform' then
		if fcd.adminAccess( ply ) then
			if ent.draggable then
				return true
			end
		end

		return false
	end
end

hook.Add( 'PhysgunPickup', 'fcd.platformGrab', fcd.platformGrab )

function fcd.precacheModels()
	for k, v in pairs( fcd.registeredVehicles ) do
		local data = fcd.getVehicleList( k )
		if not data then return end
		
		util.PrecacheModel( data.Model or '' )
	end
end

hook.Add( 'InitPostEntity', 'fcd.precacheModels', fcd.precacheModels )

-- This is for the donation systems and making it easier.

function GiveCar( ply, class )
	fcd.giveVehicle( ply, class )
end