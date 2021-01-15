-- Money withdraw
local MODULE = GAS.Logging:MODULE()
MODULE.Category = "OnePrint"
MODULE.Name     = "Money withdraw"
MODULE.Colour   = Color(255,130,0)
MODULE:Setup(function()
	MODULE:Hook( "OnePrint_OnWithdraw", "OP_BlogsSupport",function( pPlayer, iMoney, ePrinter )
		MODULE:LogPhrase( "{1} withdrew " .. OnePrint:FormatMoney( iMoney ) .. " in {2}'s printer", GAS.Logging:FormatPlayer( pPlayer ), GAS.Logging:FormatPlayer( ePrinter:GetOwnerObject() ) )
	end )
end )
GAS.Logging:AddModule( MODULE )

-- Hacked
local MODULE = GAS.Logging:MODULE()
MODULE.Category = "OnePrint"
MODULE.Name     = "Hacked"
MODULE.Colour   = Color(255,130,0)
MODULE:Setup(function()
	MODULE:Hook( "OnePrint_OnPrinterHacked", "OP_BlogsSupport",function( ePrinter, pPlayer )
		MODULE:LogPhrase( "{1} hacked {2}'s printer", GAS.Logging:FormatPlayer( pPlayer ), GAS.Logging:FormatPlayer( ePrinter:GetOwnerObject() ) )
	end )
end )
GAS.Logging:AddModule( MODULE )

-- Destroyed
local MODULE = GAS.Logging:MODULE()
MODULE.Category = "OnePrint"
MODULE.Name     = "Destroyed"
MODULE.Colour   = Color(255,130,0)
MODULE:Setup(function()
	MODULE:Hook( "OnePrint_OnPlayerDestroyedPrinter", "OP_BlogsSupport",function( pPlayer, ePrinter )
		MODULE:LogPhrase( "{1} destroyed {2}'s printer", GAS.Logging:FormatPlayer( pPlayer ), GAS.Logging:FormatPlayer( ePrinter:GetOwnerObject() ) )
	end )
end )
GAS.Logging:AddModule( MODULE )