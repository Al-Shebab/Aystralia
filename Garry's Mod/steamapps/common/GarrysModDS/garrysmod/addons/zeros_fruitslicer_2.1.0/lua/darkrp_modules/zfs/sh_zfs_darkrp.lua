TEAM_ZFRUITSLICER = DarkRP.createJob("Fruit Slicer", {
	color = Color(0, 128, 255, 255),
	model = {"models/player/group01/male_02.mdl"},
	description = [[You sell Smoothies!]],
	weapons = {"zfs_knife"},
	command = "FruitSlicer",
	max = 4,
	salary = 50,
	admin = 0,
	vote = false,
	category = "Citizens",
	hasLicense = false
})

DarkRP.createCategory{
	name = "FruitSlicer",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = fp{fn.Id, true},
	sortOrder = 255
}

DarkRP.createEntity("FruitSlicer Shop", {
	ent = "zfs_shop",
	model = "models/zerochain/fruitslicerjob/fs_shop.mdl",
	price = 4000,
	max = 1,
	cmd = "buyzfs_shop",
	allowed = TEAM_ZFRUITSLICER,
	category = "FruitSlicer",
	sortOrder = 0
})

local Fruits = {}
Fruits["zfs_fruitbox_melon"] = "Melons"
Fruits["zfs_fruitbox_banana"] = "Bananas"
Fruits["zfs_fruitbox_coconut"] = "Coconuts"
Fruits["zfs_fruitbox_pomegranate"] = "Pomegranates"
Fruits["zfs_fruitbox_strawberry"] = "Strawberrys"
Fruits["zfs_fruitbox_kiwi"] = "Kiwis"
Fruits["zfs_fruitbox_lemon"] = "Lemons"
Fruits["zfs_fruitbox_orange"] = "Oranges"
Fruits["zfs_fruitbox_apple"] = "Apples"

for k, v in pairs(Fruits) do
	DarkRP.createEntity(v, {
		ent = k,
		model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
		price = 1000,
		max = 5,
		cmd = "buy" .. k,
		allowed = TEAM_ZFRUITSLICER,
		category = "FruitSlicer"
	})
end
