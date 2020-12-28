local CFG = {}
-- Everything instead of the following things can be configured directly in game
-- Just take the "Adv Car Dealer Configuration" tool ( toolgun )
-- You can place all entities and open the menu of configuration with the tool

--[[
	If you want to use a module like mysqloo or tmysql4, go into server/sv_sql.lua
]]

CFG.CarDealerJobs = {
	["Car dealer"] = true,
}

-- How much different job cars can be out at the same time 
-- eg. for police jobs, with this set to 1, the player will be able to take out 1 different cars from the
-- police car dealer, etc. etc. 
CFG.MaxJobCars = 1

-- 0 = MPH
-- 1 = KMH
CFG.TypeOfSpeed = 0

CFG.IsCarLockedWhenSpawned = false
CFG.IsPlayerInVehicleWhenSpawned = false

CFG.PercentageWhenResell = 10

CFG.PriceUnderglow = 1000
-- how much does the seller get if a car is bought with underglow?
CFG.CommissionUnderglow = 50

-- How much money can be spend to get expositional models of cars
CFG.CarDealerWallet = 1000000

CFG.MinimumTimeToReturnInGarageAfterRenting = 360

CFG.MaxFactureSpawnable = 1

CFG.KeyToStopUnderglow = KEY_L
CFG.KeyToReturnIntoGarage = KEY_G

CFG.MaxSpawnedVehicles = 2

--[[
	People in the Car dealer job have access to more customisation than the other players.
	If they buy directly in the catalog their vehicles, the players can"t choose a custom color,
	they have to choose between a defined list of colors :
]]

CFG.VehicleColorsInCatalog = {
	"0 0 0 255",
	"255 255 255 255",
	"27 79 9 255",
	"58 142 189 255",
	"232 214 48 255",
	"91 60 17 255",
	"38 196 236 255",
	"236 28 38 255",
}

-- Same thing than previously for the underglow colors
CFG.UnderglowColorsInCatalog = {
	"0 0 0 255",
	"255 255 255 255",
	"27 79 9 255",
	"58 142 189 255",
	"232 214 48 255",
	"91 60 17 255",
	"38 196 236 255",
	"236 28 38 255",
}

CFG.AdminUserGroups = {
	[ "superadmin" ] = true,
}

--[[
EXAMPLES OF CUSTOM CHECKS :
Copy/paste them at the end of the file if you want to use them.

AdvCarDealer.CustomChecks = {
	[ "VIP only" ]	= {
		func = function( ply ) return ply:GetUserGroup() == "VIP" end,
		messageCatalog = "This vehicle is limited to VIP users.",
		onlyOnceBuying = false, -- if the check has to be done only once buying, or also when the player try to take it from the garage.
	}
}

AdvCarDealer.CustomChecks = {
	[ "Police only" ]	= {
		func = function( ply ) return ply:isCP() end,
		messageCatalog = "This vehicle is limited to police.",
		onlyOnceBuying = false,
	}
}

AdvCarDealer.CustomChecks = {
	[ "Team name only" ]	= {
		func = function( ply ) return team.GetName( ply:Team() ) == "Team Name" end,
		messageCatalog = "This vehicle is limited to Team name.",
		onlyOnceBuying = false,
	}
}
--]]

AdvCarDealer.Config = CFG