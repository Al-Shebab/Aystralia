zrush = zrush or {}
zrush.Fuel = {}
function zrush.f.CreateFuelTypes(data)
    return table.insert(zrush.Fuel, data)
end

// Fuel Settings
///////////////////////
// Fuel Registration
/*
	Values for this are
	Name			   : The Name of the Fuel
	FuelColor		   : The Color of the Fuel
	VCmodfuel (0||1)   : What VC Mod fuel is it (Petrol or Diesel) (Only usefull if you have VCMod installed!)
	RefineOutput	   : How much Fuel do we get from the refined Oil (0.5 = 50%)
	BasePrice		   : The Start Sell Price of the Fuel per Unit (Liter,etc..)
	Ranks			   : The Ranks which are allowed do refine this Fuel
*/


local vip_ranks = {
	["VIP"] = true,
	["superadmin"] = true
}

zrush.f.CreateFuelTypes({
	name = "Regular Petrol",
	color = Color(211,190,255),
	vcmodfuel = 0,
	refineoutput = 0.55,
	price = 15,
	ranks = {}
})

zrush.f.CreateFuelTypes({
	name = "Premium Petrol",
	color = Color(255,236,110),
	vcmodfuel = 0,
	refineoutput = 0.25,
	price = 125,
	ranks = {}
})

zrush.f.CreateFuelTypes({
	name = "Premium Ultra Petrol",
	color = Color(211,255,149),
	vcmodfuel = 0,
	refineoutput = 0.1,
	price = 2400,
	ranks = vip_ranks
})



zrush.f.CreateFuelTypes({
	name = "Regular Diesel",
	color = Color(255,227,190),
	vcmodfuel = 1,
	refineoutput = 0.55,
	price = 20,
	ranks = {}
})

zrush.f.CreateFuelTypes({
	name = "Premium Diesel",
	color = Color(248,154,53),
	vcmodfuel = 1,
	refineoutput = 0.25,
	price = 150,
	ranks = {}
})

zrush.f.CreateFuelTypes({
	name = "Premium Ultra Diesel",
	color = Color(255,68,31),
	vcmodfuel = 1,
	refineoutput = 0.1,
	price = 2500,
	ranks = vip_ranks
})
///////////////////////
