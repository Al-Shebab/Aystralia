DarkRP.createAmmoType("357", {
	name = "357 Ammo",
	model = "models/Items/357ammobox.mdl",
	price = 300,
	amountGiven = 20,
    category = "Ammo",
})
DarkRP.createAmmoType("ar2", {
	name = "Rifle Ammo",
	model = "models/Items/BoxMRounds.mdl",
	price = 1200,
	amountGiven = 30,
    category = "Ammo",
})
DarkRP.createAmmoType("buckshot", {
	name = "Shotgun Ammo",
	model = "models/Items/BoxBuckshot.mdl",
	price = 400,
	amountGiven = 8,
    category = "Ammo",
})
DarkRP.createAmmoType("pistol", {
	name = "Pistol Ammo",
	model = "models/Items/BoxSRounds.mdl",
	price = 200,
	amountGiven = 20,
    category = "Ammo",
})
DarkRP.createAmmoType("smg1", {
	name = "SMG Ammo",
	model = "models/Items/BoxMRounds.mdl",
	price = 400,
	amountGiven = 60,
    category = "Ammo",
})
DarkRP.createAmmoType("SniperPenetratedRound", "smg1", "pistol", "buckshot", "ar2", "357", {
	name = "Sniper Ammo",
	model = "models/Items/BoxMRounds.mdl",
	price = 1800,
	amountGiven = 6,
    category = "Ammo",
})
DarkRP.createAmmoType("SniperPenetratedRound", {
	name = "All Ammo",
	model = "models/Items/BoxMRounds.mdl",
	price = 5000,
	amountGiven = 30,
    category = "Ammo",
})
