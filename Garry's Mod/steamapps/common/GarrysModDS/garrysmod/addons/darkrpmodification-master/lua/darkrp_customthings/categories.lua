--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

DarkRP.createCategory{
    name = "Citizens",
    categorises = "jobs",
    startExpanded = true,
    color = Color(74, 255, 69,255),
    canSee = function(ply) return true end,
    sortOrder = 1,
}
DarkRP.createCategory{
    name = "Services",
    categorises = "jobs",
    startExpanded = true,
    color = Color(204,128,255,255),
    canSee = function(ply) return true end,
    sortOrder = 2,
}
DarkRP.createCategory{
    name = "Dealers",
    categorises = "jobs",
    startExpanded = true,
    color = Color(204,0,255,255),
    canSee = function(ply) return true end,
    sortOrder = 3,
}
DarkRP.createCategory{
    name = "Government",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0,0,255,255),
    canSee = function(ply) return true end,
    sortOrder = 4,
}
DarkRP.createCategory{
    name = "Illegal",
    categorises = "jobs",
    startExpanded = true,
    color = Color(106,95,255,255),
    canSee = function(ply) return true end,
    sortOrder = 5,
}
DarkRP.createCategory{
    name = "Homeless",
    categorises = "jobs",
    startExpanded = true,
    color = Color(112, 112, 112,255),
    canSee = function(ply) return true end,
    sortOrder = 6,
}
DarkRP.createCategory{
    name = "Manufacturing",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255,0,0,255),
    canSee = function(ply) return true end,
    sortOrder = 7,
}
DarkRP.createCategory{
    name = "Donator Classes",
    categorises = "jobs",
    startExpanded = true,
    color = Color(106,95,255,255),
    canSee = function(ply) return table.HasValue({"sydney", "ayssie" "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup")) end,
    sortOrder = 8,
}
DarkRP.createCategory{
    name = "Staff",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255,255,255,255),
    canSee = function(ply) return table.HasValue({"superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup")) end,
    sortOrder = 9,
}

-- Ammo --

DarkRP.createCategory{
    name = "Ammo",
    categorises = "ammo",
    startExpanded = true,
    color = Color(255, 255, 255, 255),
    canSee = function(ply) return true end,
    sortOrder = 10,
}

-- Gun Catagories --

DarkRP.createCategory{
    name = "Pistols",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 11,
}
DarkRP.createCategory{
    name = "Heavy Pistols",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 12,
}
DarkRP.createCategory{
    name = "SMGs",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 13,
}
DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 14,
}
DarkRP.createCategory{
    name = "Machine Guns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 15,
}
DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 16,
}
DarkRP.createCategory{
    name = "Explosives",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER,TEAM_SADDAM_HUSSEIN}, ply:Team()) end,
    sortOrder = 17,
}
DarkRP.createCategory{
    name = "Drugs",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_DRUG_DEALER}, ply:Team()) end,
    sortOrder = 18,
}

-- Job Entities --

DarkRP.createCategory{
    name = "Bitcoin",
    categorises = "entities",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_BITCOIN_MINER}, ply:Team()) end,
    sortOrder = 1
}
DarkRP.createCategory{
    name = "Advanced Money Printers",
    categorises = "entities",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_MONEY_PRINTER,TEAM_SONIC}, ply:Team()) end,
    sortOrder = 2
}
DarkRP.createCategory{
    name = "Weed Materials",
    categorises = "entities",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_WEED_DEALER}, ply:Team()) end,
    sortOrder = 4
}
DarkRP.createCategory{
    name = "Meth Materials",
    categorises = "entities",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_METH_DEALER}, ply:Team()) end,
    sortOrder = 5
}

DarkRP.createCategory{
    name = "Supplies",
    categorises = "entities",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return true end,
    sortOrder = 20
}

DarkRP.createCategory{
    name = "Oil Refiner",
    categorises = "entities",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_OIL_REFINER,TEAM_KOMMISSAR}, ply:Team()) end,
    sortOrder = 9
}

DarkRP.createCategory{
	name = "Fruit Slicer",
	categorises = "entities",
	startExpanded = true,
	color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_FRUIT_SLICER}, ply:Team()) end,
	sortOrder = 10
}

DarkRP.createCategory{
	name = "Mining",
	categorises = "entities",
	startExpanded = true,
	color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({TEAM_MINER,TEAM_FELIX_ARGYLE,TEAM_SOWAKA}, ply:Team()) end,
	sortOrder = 11
}
