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
