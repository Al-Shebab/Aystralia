Config = {}
Config.Locale = 'en'

Config.DrawDistance = 10

Config.MarkerInfo = {Type = 29, r = 255, g = 187, b = 0, x = 1.0, y = 1.0, z = 1.0}
Config.BlipLicenseShop = {Sprite = 498, Color = 37, Display = 2, Scale = 1.0}

Config.UseBlips = true -- true = Use License Shop Blips
Config.RequireDMV = false -- If true then it will require players to have Drivers Permit to buy other Licenses | false does the Opposite.
Config.AdvancedVehicleShop = false -- Set to true if using esx_advancedvehicleshop
Config.AdvancedWeaponShop = false -- Set to true if using esx_advancedweaponshop
Config.DMVSchool = false -- Set to true if using esx_dmvschool
Config.SellDMV = false -- Set to true if Config.RequireDMV = false & you want players to be able to buy Drivers Permit
Config.Drugs = false -- Set to true if using esx_drugs
Config.WeaponShop = true -- Set to true if using esx_weaponshop

Config.Prices = {
	Driver License = 1000,
	Guns License = 25000,
	Large Arms License = 500000,
	Weed License = 50000,
	Coke License = 250000,
	Meth License = 1500000,
	Heroin License = 5000000
}

Config.Zones = {
	LicenseShops = {
		Coords = {
			vector3(-267.49, -962.92, 31.22),
			vector3(438.68, -980.16, 29.69)
		}
	}
}
