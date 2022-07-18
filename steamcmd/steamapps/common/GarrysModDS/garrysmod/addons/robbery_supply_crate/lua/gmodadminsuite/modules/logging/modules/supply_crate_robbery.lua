local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Supply Crate"
MODULE.Name = "Robbery"
MODULE.Colour = Color( 150, 0, 0 )  

MODULE:Setup(function()
	MODULE:Hook("SUPPLY_CRATE_RobberyInitiated", "supply_crate_robbery_initiated", function( ply, amount )
		MODULE:Log( "{1} has started a robbery on the supply crate.", GAS.Logging:FormatPlayer( ply ) )
	end)
	
	MODULE:Hook("SUPPLY_CRATE_RobberySuccessful", "supply_crate_robbery_successful", function( ply, money, shipments, ammo )
		MODULE:Log( "{1} has successfully robbed the supply crate containing {2}, {3} shipments and {4} rounds of ammunition.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( money ), GAS.Logging:Highlight( shipments ), GAS.Logging:Highlight( ammo ) )
	end)
	
	MODULE:Hook("SUPPLY_CRATE_RobberyFailed", "supply_crate_robbery_failed", function( ply, amount )
		MODULE:Log( "{1} has failed robbing the supply crate.", GAS.Logging:FormatPlayer( ply ) )
	end)
end)

GAS.Logging:AddModule(MODULE)