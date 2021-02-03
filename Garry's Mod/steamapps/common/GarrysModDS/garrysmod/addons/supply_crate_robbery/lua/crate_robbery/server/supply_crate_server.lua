-- Overwrite shipment model for DarkRP
local function CRATE_DarkRP_BoughtShipment( ent )
	timer.Simple( 0.1, function()
		if IsValid( ent ) then
			if ent:GetClass() == "spawned_shipment" then
				if CH_SupplyCrate.Config.OverwriteModel then
					if ent:GetModel() != "models/craphead_scripts/supply_crate/mil_crate.mdl" then
						ent:SetModel( "models/craphead_scripts/supply_crate/mil_crate.mdl" )
					end
				end
			end
		end
	end )
end
hook.Add( "OnEntityCreated", "CRATE_DarkRP_BoughtShipment", CRATE_DarkRP_BoughtShipment )

-- Adding custom shipments if any are set in DarkRP.
-- You can add armorywhitelist = true to any shipment in your darkrpmodification.
local function CRATE_AddingWhitelist_Shipments( ent )
    for k, v in pairs( CustomShipments ) do
		if v.armorywhitelist == true then
			table.insert( CH_SupplyCrate.ShipWhiteList, k, v )
			print( "[Supply Crate Robbery] - Adding ".. v.entity .." to the armory whiteList" )
        end
    end
	
	--[[
    if table.Count( CH_SupplyCrate.ShipWhiteList ) > 0 then
        print( "[Supply Crate Robbery] - Using custom table for armory loot." )
    else
        print( "[Supply Crate Robbery] - Using default shipments table for armory loot." )
    end
	--]]
end
hook.Add( "PostGamemodeLoaded", "CRATE_AddingWhitelist_Shipments", CRATE_AddingWhitelist_Shipments )