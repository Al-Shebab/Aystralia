zrush = zrush or {}
zrush.Holes = {}
function zrush.f.CreateOilSource(data)
    return table.insert(zrush.Holes, data)
end

// Oil Hole Settings
///////////////////////
// OilSource Registration
/*
	Values for this are
	Chance (1-100)	     : The Chance of getting this Hole
	Depth			     : How many pipes it will need
	Burnchance (1-100)   : how high the chance is that it needs to be burned after hitting the oil
    oil_amount			 : how much oil is in the Hole
	gas_amount           : how much gas is in the Hole
	chaos_chance         : The Chance of the Machine do have a OverHeat/Jam -Event when working on this OilSource (This gets added do the Base OverHeat/Jam -Chance of the machine)
*/

zrush.f.CreateOilSource({
    chance = 50,
    depth = 15,
    burnchance = 7,
    oil_amount = math.Round(math.random(3000, 10000)),
    gas_amount = math.Round(math.random(1000, 5000)),
    chaos_chance = 5
})

zrush.f.CreateOilSource({
    chance = 30,
    depth = 20,
    burnchance = 15,
    oil_amount = math.Round(math.random(6000, 20000)),
    gas_amount = math.Round(math.random(5000, 8000)),
    chaos_chance = 10
})

zrush.f.CreateOilSource({
    chance = 20,
    depth = 25,
    burnchance = 75,
    oil_amount = math.Round(math.random(15000, 40000)),
    gas_amount = math.Round(math.random(5000, 10000)),
    chaos_chance = 20
})
///////////////////////
