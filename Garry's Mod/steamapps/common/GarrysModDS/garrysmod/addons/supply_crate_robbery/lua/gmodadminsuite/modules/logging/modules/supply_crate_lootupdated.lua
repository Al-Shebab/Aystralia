local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Supply Crate"
MODULE.Name = "Loot Updates"
MODULE.Colour = Color( 150, 0, 0 ) 

MODULE:Setup(function()
	MODULE:Hook("SUPPLY_CRATE_MoneyLootUpdated", "supply_crate_robbery_money_loot", function( added, total )
		MODULE:Log( "{1} was added to the crate loot. The total is now {2}.", GAS.Logging:FormatMoney( added ), GAS.Logging:FormatMoney( total ) )
	end)
	
	MODULE:Hook("SUPPLY_CRATE_AmmoLootUpdated", "supply_crate_robbery_ammo_loot", function( added, total )
		MODULE:Log( "{1} rounds of ammunition was added to the crate loot. The total is now {2} rounds.", GAS.Logging:Highlight( added ), GAS.Logging:Highlight( total ) )
	end)
	
	MODULE:Hook("SUPPLY_CRATE_ShipmentsLootUpdated", "supply_crate_robbery_shipments_loot", function( added, total )
		MODULE:Log( "{1} shipments was added to the crate loot. The total is now {2} shipments.", GAS.Logging:Highlight( added ), GAS.Logging:Highlight( total ) )
	end)
end)

GAS.Logging:AddModule(MODULE)