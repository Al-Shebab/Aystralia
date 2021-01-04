zrush = zrush or {}
zrush.AbilityModules = {}
function zrush.f.CreateAbilityModule(data)
	return table.insert(zrush.AbilityModules, data)
end

local job_list = {
	["Oil Refiner"] = true,
}

zrush.f.CreateAbilityModule({
	name = "Speed Boost",
	type = "speed",
	amount = 0.10,
	desc = "Increases the Speed of the Machine a bit.",
	price = 7500,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Production Boost",
	type = "production",
	amount = 0.25,
	desc = "Increases the production amount of the machine a bit.",
	price = 7500,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "AntiJam Boost",
	type = "antijam",
	amount = 0.25,
	desc = "Reduces the chance of jamming the machine a bit.",
	price = 7500,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Cooling Boost",
	type = "cooling",
	amount = 0.25,
	desc = "Reduces the chance of OverHeating the machine a bit.",
	price = 7500,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Extra Pipes",
	type = "pipes",
	amount = 3,
	desc = "Adds some extra space for Pipes in the Queue.",
	price = 7500,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})

zrush.f.CreateAbilityModule({
	name = "Refining Boost",
	type = "refining",
	amount = 0.1,
	desc = "Increases the refined Fuel amount a bit.",
	price = 7500,
	ranks = {},
	jobs = {},
	color = Color(255,201,71)
})
