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
		max = 1,
		cmd = "buy" .. k,
		allowed = TEAM_FRUIT_SLICER,
		category = "Fruit Slicer"
	})
end

DarkRP.createEntity("Melons", {
	ent = "zfs_fruitbox_melon",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_melon",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Bananas", {
	ent = "zfs_fruitbox_banana",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_banana",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Coconuts", {
	ent = "zfs_fruitbox_coconut",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_coconut",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Pomegranates", {
	ent = "zfs_fruitbox_pomegranate",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_pomegranate",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Strawberrys", {
	ent = "zfs_fruitbox_strawberry",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_strawberry",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Kiwis", {
	ent = "zfs_fruitbox_kiwi",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_kiwi",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Lemons", {
	ent = "zfs_fruitbox_lemon",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_lemon",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Oranges", {
	ent = "zfs_fruitbox_orange",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_orange",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})
DarkRP.createEntity("Apples", {
	ent = "zfs_fruitbox_apple",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_apple",
	allowed = TEAM_FRUIT_SLICER,
	category = "Fruit Slicer"
})