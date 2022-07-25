local PrVeh = "prop_vehicle_jeep"
local Cat = "TDM Cars"

local V = {
			Name = "BMW 340i", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster",
			Information = "A drivable BMW 340i by TheDanishMaster",
			Model = "models/tdmcars/bmw_340i.mdl",
			KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmw_340i.txt"
							}
			}
list.Set("Vehicles", "bmw_340itdm", V)

local V = {
			Name = "BMW 507", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW 507 by TheDanishMaster",
			Model = "models/tdmcars/bmw507.mdl",
			KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/507.txt"
							}
			}
list.Set("Vehicles", "507tdm", V)


local V = {
			Name = "BMW 1M", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW 1M by TheDanishMaster",
				Model = "models/tdmcars/bmw_1m.mdl",
				KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmw_1m.txt"
							}
			}
list.Set("Vehicles", "bmw1mtdm", V)

local V = {
			Name = "BMW Isetta 300 Export", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW Isetta by TheDanishMaster",
				Model = "models/tdmcars/bmw_isetta.mdl",
				KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmw_isetta.txt"
							}
			}
list.Set("Vehicles", "bmw_isettatdm", V)

local V = {
			Name = "BMW M3 GTR", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW M3 GTR by TheDanishMaster",
				Model = "models/tdmcars/bmw_m3_gtr.mdl",
				KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmwm3gtr.txt"
							}
			}
list.Set("Vehicles", "bmwm3gtrtdm", V)

local V = {
			Name = "BMW M5 E60", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW M5 E60 by TheDanishMaster",
				Model = "models/tdmcars/bmwm5e60.mdl",
				KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmwm5e60.txt"
							}
			}
list.Set("Vehicles", "bmwm5e60tdm", V)

local V = {
			Name = "BMW M6 2013", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW M6 2013 by TheDanishMaster",
				Model = "models/tdmcars/bmw_m6_13.mdl",
				KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmwm613.txt"
							}
			}
list.Set("Vehicles", "bmwm613tdm", V)

local V = {
			Name = "BMW M1 1981", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW M1 1981 by TheDanishMaster",
				Model = "models/tdmcars/bmwm1.mdl",
							KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/m1.txt"
							}
			}
list.Set("Vehicles", "m1tdm", V)

local V = {
			Name = "BMW M3 E92", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW M3 E92 by TheDanishMaster",
			Model = "models/tdmcars/bmwm3e92.mdl",
			KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmwm3e92.txt"
							}
			}
list.Set("Vehicles", "m3e92tdm", V)

local V = {
			Name = "BMW M5 E34", 
			Class = PrVeh,
			Category = Cat,
			Author = "TheDanishMaster, Turn 10",
			Information = "A drivable BMW M5 E34 by TheDanishMaster",
			Model = "models/tdmcars/bmwm5e34.mdl",
			KeyValues = {
							vehiclescript	=	"scripts/vehicles/TDMCars/bmwm5e34.txt"
						}
			}
list.Set("Vehicles", "m5e34tdm", V)

sound.Add( 
{
    name = "tdm_isetta_hithead",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 90,
	sound =	{ "vehicles/tdmcars/bmw_isetta/hithead_james.mp3", 
	"vehicles/tdmcars/bmw_isetta/hithead_james2.mp3", 
	"vehicles/tdmcars/bmw_isetta/hithead_richard.mp3",  
	"vehicles/tdmcars/bmw_isetta/hithead_richard2.mp3",  
	"","","","","","","","","","","","","","","","","",  
	"vehicles/tdmcars/bmw_isetta/hithead_richard3.mp3" }
} )