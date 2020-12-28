--[[---------------------------------------------------------
	The list below is empty at the beginning
	Use this as a memo for developers
-----------------------------------------------------------]]
-- CFG.CarDealerSpawns = {
-- 	[ "gm_construct" ] = {
-- 		ang = Angle( 360, 0, 0 ),
-- 		pos = Vector( -661, -1432, -144 )
-- 	}
-- }

-- CFG.EntitiesSpawns = { -- cardealer_printer, cardealer_tablet_ent
-- 	[ "gm_construct" ] = {
-- 		[ "cardealer_custom_visual" ] = {
-- 			{
-- 				ang = Angle( 0, 117, 0 ),
-- 				pos = Vector( -314, -1134, -144 )
-- 			}
-- 		},
-- 		[ "cardealer_garage" ] = {
-- 			{
-- 				ang = Angle( 0, 0, 0 ),
-- 				pos = Vector( -830, -1083, -144)
-- 			}
-- 		}
-- 	}
-- }

-- CFG.GarageSpawns = {
-- 	[ "gm_construct" ] ={
-- 		{ 
-- 			ang = Angle( 360, 0, 0 ),
-- 			pos	= Vector( -672.250000, -1423.000000, -143.968796 )
-- 		}
-- 	}
-- }

-- CFG.GarageZones = {
-- 	[ "gm_construct" ] ={
-- 		{ 
-- 			pointA = Vector(),
-- 			pointB = Vector()
-- 		}
-- 	}
-- }

--- NOT DONE YET :

--CFG.Vehicles = {
	-- [ "Brand test" ] = {
	-- 	[ "subaru_22b_lw" ] = {
	-- 		-- KeyValues = {
	-- 		-- 	vehiclescript	=	"scripts/vehicles/TDMCars/che_blazer.txt"
	-- 		-- },
	-- 		bodygroups	=	true,
	-- 		-- brand	=	"Brand name",
	-- 		-- class	=	"prop_vehicle_jeep",
	-- 		-- className	=	"che_blazertdm",
	-- 		color	=	true,
	-- 		-- horsepower	=	300,
	-- 		-- maxrpm	=	4000,
	-- 		-- maxspeed	=	67,
	-- 		model	=	"models/lonewolfie/subaru_22b.mdl",
	-- 		moneyEarned = {
	-- 			max	=	1000,
	-- 			min	=	900
	-- 		},
	-- 		name	=	"Tout le monde",
	-- 		priceCatalog	=	10000,
	-- 		pricePlayer = {
	-- 				max	=	10000,
	-- 				min	=	9000
	-- 		},
	-- 		skins	=	true,
	-- 		underglow	=	true,
	--		customCheck = "VIP",
	-- 		-- new
	-- 		isInCardealerCatalog = true,
	-- 		isInCatalog = true,
	-- 	},

-- JobGarage:
-- 		gm_flatgrass:
-- 				1:
-- 						Jobs:
-- 								1	=	Citizen
-- 						NPC:
-- 								ang	=	0.000 86.000 0.000
-- 								model	=	models/barney.mdl
-- 								name	=	Test
-- 								pos	=	274.281311 -919.937500 -12287.968750
-- 						SpawnGarage:
-- 								ang	=	360.000 86.000 0.000
-- 								pos	=	150.906296 -807.062500 -12287.968750
-- 						Vehicles:
-- 								1:
-- 										bodygroup	=	[]
-- 										color	=	255 255 255 255
-- 										model	=	models/sentry/taurussho.mdl
-- 										name	=	2010 Ford Taurus SHO
-- 										price	=	1000
-- 										skin	=	0
-- 										underglow	=	
-- 										vehicle	=	taurussho
-- 								2:
-- 										bodygroup	=	[]
-- 										color	=	255 255 255 255
-- 										model	=	models/sentry/taurussho.mdl
-- 										name	=	Honda Civic Type R FK8 '17
-- 										price	=	1000
-- 										skin	=	0
-- 										underglow	=	
-- 										vehicle	=	crsk_honda_civic_typer_fk8_2017



-- CFG.DatabaseVersion = 1


--[[---------------------------------------------------------
	This doesn't exist currently
-----------------------------------------------------------]]
-- Ability to not show in the Tablet a vehicle (jobs, expliquer aussi comment faire pour mettre un véhicule en édition limité, VIP etc. genre on le met dans le shop puis au lieu de le supprimer on le cache )
-- Ajouter zone rangement véhicule JobGarage
-- Nom du job garage



--[[---------------------------------------------------------
	Noms de variables qui ont changé :
-----------------------------------------------------------]]
-- Vehicle list .isInCatalog = true/false à remettre à true par défaut -> Si il est dans le catalogue ou non
-- Vehicle list .isInCardealerCatalog = true/false à remettre à true par défaut -> Si il est dans le catalogue du car dealer uniquement ou non

-- AdvCarDealer.Config = CFG