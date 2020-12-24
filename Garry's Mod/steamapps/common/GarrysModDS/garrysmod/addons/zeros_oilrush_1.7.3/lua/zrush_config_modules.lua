zrush = zrush or {}
zrush.AbilityModules = {}
function zrush.f.CreateAbilityModule(data)
	return table.insert(zrush.AbilityModules, data)
end


// AbilityModules
///////////////////////
// Here you can create new Modules

/*
This is just a examble on how the job restriction looks
local job_list = {
	["Fuel Refiner"] = true,
	["Gangster"] = true,
}
*/

////////////////////////////////////////////
///////////////// Basic ////////////////////
////////////////////////////////////////////
zrush.f.CreateAbilityModule({
	name = "Speed Boost",
	type = "speed",
	amount = 0.10,
	desc = "Increases the Speed of the Machine a bit.",
	price = 2000,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Production Boost",
	type = "production",
	amount = 0.25,
	desc = "Increases the production amount of the machine a bit.",
	price = 2000,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "AntiJam Boost",
	type = "antijam",
	amount = 0.25,
	desc = "Reduces the chance of jamming the machine a bit.",
	price = 2000,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Cooling Boost",
	type = "cooling",
	amount = 0.25,
	desc = "Reduces the chance of OverHeating the machine a bit.",
	price = 2000,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Extra Pipes",
	type = "pipes",
	amount = 3,
	desc = "Adds some extra space for Pipes in the Queue.",
	price = 2000,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Refining Boost",
	type = "refining",
	amount = 0.1,
	desc = "Increases the refined Fuel amount a bit.",
	price = 2000,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
/////////////// Advanced ///////////////////
////////////////////////////////////////////
local vip_ranks = {
	["VIP"] = true,
	["superadmin"] = true,
}
zrush.f.CreateAbilityModule({
	name = "Super Speed Boost",
	type = "speed",
	amount = 0.25,
	desc = "Injects High Quallity Oil in the Machine which increases the Speed.",
	price = 6000,
	ranks = vip_ranks,
	jobs = {},
	color = Color(255,136,71)
})

zrush.f.CreateAbilityModule({
	name = "Super Production Boost",
	type = "production",
	amount = 0.50,
	desc = "Integrates a Intel CPU in the Machine which improves the Logistic",
	price = 6000,
	ranks = vip_ranks,
	jobs = {},
	color = Color(255,136,71)
})

zrush.f.CreateAbilityModule({
	name = "Super AntiJam Boost",
	type = "antijam",
	amount = 0.50,
	desc = "Reduces the chance of jamming the machine.",
	price = 6000,
	ranks = vip_ranks,
	jobs = {},
	color = Color(255,136,71)
})

zrush.f.CreateAbilityModule({
	name = "Super Cooling Boost",
	type = "cooling",
	amount = 0.50,
	desc = "Reduces the chance of OverHeating the machine.",
	price = 6000,
	ranks = vip_ranks,
	jobs = {},
	color = Color(255,136,71)
})

zrush.f.CreateAbilityModule({
	name = "Super Extra Pipes",
	type = "pipes",
	amount = 6,
	desc = "Adds much mor extra space for Pipes in the Queue.",
	price = 6000,
	ranks = vip_ranks,
	jobs = {},
	color = Color(255,136,71)
})

zrush.f.CreateAbilityModule({
	name = "Super Refining Boost",
	type = "refining",
	amount = 0.4,
	desc = "Increases the refined Fuel amount a lot.",
	price = 6000,
	ranks = vip_ranks,
	jobs = {},
	color = Color(255,136,71)
})
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
/////////////// Advanced ///////////////////
////////////////////////////////////////////
local vipgold_ranks = {
	["VIP Gold"] = true,
	["superadmin"] = true,
}
zrush.f.CreateAbilityModule({
	name = "Xtreme Speed Boost",
	type = "speed",
	amount = 0.9,
	desc = "Injects High Quallity Oil in the Machine which increases the Speed.",
	price = 9000,
	ranks = vipgold_ranks,
	jobs = {},
	color = Color(255,71,71)
})

zrush.f.CreateAbilityModule({
	name = "Xtreme Production Boost",
	type = "production",
	amount = 2,
	desc = "Integrates a Intel CPU in the Machine which improves the Logistic",
	price = 9000,
	ranks = vipgold_ranks,
	jobs = {},
	color = Color(255,71,71)
})

zrush.f.CreateAbilityModule({
	name = "Xtreme AntiJam Boost",
	type = "antijam",
	amount = 0.9,
	desc = "Reduces the chance of jamming the machine.",
	price = 9000,
	ranks = vipgold_ranks,
	jobs = {},
	color = Color(255,71,71)
})

zrush.f.CreateAbilityModule({
	name = "Xtreme Cooling Boost",
	type = "cooling",
	amount = 0.9,
	desc = "Reduces the chance of OverHeating the machine.",
	price = 9000,
	ranks = vipgold_ranks,
	jobs = {},
	color = Color(255,71,71)
})

zrush.f.CreateAbilityModule({
	name = "Xtreme Extra Pipes",
	type = "pipes",
	amount = 12,
	desc = "Adds much mor extra space for Pipes in the Queue.",
	price = 9000,
	ranks = vipgold_ranks,
	jobs = {},
	color = Color(255,71,71)
})

zrush.f.CreateAbilityModule({
	name = "Xtreme Refining Boost",
	type = "refining",
	amount = 2,
	desc = "Increases the refined Fuel amount a lot.",
	price = 9000,
	ranks = vipgold_ranks,
	jobs = {},
	color = Color(255,71,71)
})
////////////////////////////////////////////
////////////////////////////////////////////
