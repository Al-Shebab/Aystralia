TEAM_ZRMINE_MINER = DarkRP.createJob("Retro Miner", {
	color = Color(0, 128, 255, 255),
	model = {"models/player/group01/male_02.mdl"},
	description = [[You are mine ores and melting them into metal bars.]],
	weapons = {"zrms_pickaxe","zrms_builder"},
	command = "zrmine_retrominer01",
	max = 4,
	salary = 15,
	admin = 0,
	vote = false,
	category = "Citizens",
	hasLicense = false
})

DarkRP.createCategory{
	name = "RetroMiner",
	categorises = "entities",
	startExpanded = true,
	color = Color(255, 107, 0, 255),
	canSee = function(ply) return true end,
	sortOrder = 104
}

DarkRP.createEntity("Gravel - Crate", {
	ent = "zrms_gravelcrate",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 6,
	cmd = "buyzrms_gravelcrate",
	allowed = TEAM_ZRMINE_MINER,
	category = "RetroMiner"
})

DarkRP.createEntity("Refiner - Crate", {
	ent = "zrms_basket",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 12,
	cmd = "buyzrms_basket",
	allowed = TEAM_ZRMINE_MINER,
	category = "RetroMiner"
})

DarkRP.createEntity("Storagecrate", {
	ent = "zrms_storagecrate",
	model = "models/zerochain/props_mining/zrms_storagecrate.mdl",
	price = 25,
	max = 6,
	cmd = "buyzrms_storagecrate",
	allowed = TEAM_ZRMINE_MINER,
	category = "RetroMiner"
})

DarkRP.createEntity("Mine Entrance", {
	ent = "zrms_mineentrance_base",
	model = "models/zerochain/props_mining/mining_entrance.mdl",
	price = 150000,
	max = 3,
	cmd = "buyzrms_mineentrance_base",
	allowed = TEAM_ZRMINE_MINER,
	category = "RetroMiner"
})

DarkRP.createEntity("Melter", {
	ent = "zrms_melter",
	model = "models/zerochain/props_mining/zrms_melter.mdl",
	price = 7500,
	max = 2,
	cmd = "buyzrms_melter",
	allowed = TEAM_ZRMINE_MINER,
	category = "RetroMiner"
})
