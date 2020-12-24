Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 10,
	CokeProcessing = 1000 * 10,
	MethProcessing = 1000 * 10,
	HeroinProcessing = 1000 * 10,
}

Config.DrugDealerItems = {
	weed = 784,
	coke = 1027,
	meth = 1635,
	heroin = 546,
}

Config.ChemicalsConvertionItems = {
	hydrochloric_acid = 0,
	sodium_hydroxide = 0,
	sulfuric_acid = 0,
	lsa = 0,
}

Config.ChemicalsLicenseEnabled = false --Will Enable or Disable the need for a Chemicals License.
Config.MoneyWashLicenseEnabled = false --Will Enable or Disable the need for a MoneyWash License.

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 15000}
}

Config.Licenses = {
	moneywash = 75000,
	chemicalslisence = 100000,
}

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	--Weed
	WeedField = {coords = vector3(2224.64, 5577.03, 53.85), name = _U('blip_WeedFarm'), color = 25, sprite = 496, radius = 100.0},
	WeedProcessing = {coords = vector3(2329.12, 2571.86, 46.68), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 100.0},
	
	--Coke
	CokeField = {coords = vector3(-310.43, 2496.34, 76.60), name = _U('blip_CokeFarm'), color = 25, sprite = 496, radius = 20.0},
	CokeProcessing = {coords = vector3(1689.14, 3291.36, 41.15), name = _U('blip_Cokeprocessing'),color = 25, sprite = 496, radius = 20.0},

	--meth
	MethProcessing = {coords = vector3(1390.33, 3608.5, 38.94), name = _U('blip_methprocessing'), color = 25, sprite = 496, radius = 0.0},
	HydrochloricAcidFarm = {coords = vector3(2724.12, 1583.03, 24.5), name = _U('blip_HydrochloricAcidFarm'), color = 25, sprite = 496, radius = 7.0},

	--Heroin
	HeroinField = {coords = vector3(16.34, 6875.94, 12.64), name = _U('blip_heroinfield'), color = 25, sprite = 496, radius = 20},
	HeroinProcessing = {coords = vector3(-65.43, 6243.36, 31.08), name = _U('blip_heroinprocessing'), color = 25, sprite = 496, radius = 100.0},

	--DrugDealer
	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0},
}
