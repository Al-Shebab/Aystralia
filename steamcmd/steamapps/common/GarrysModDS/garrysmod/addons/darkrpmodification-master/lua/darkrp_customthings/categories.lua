--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

-- Jobs --

DarkRP.createCategory{
    name = "Civilians", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 1, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
    name = "Government", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 2, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
    name = "Printing", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 3, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
    name = "Manufacturing", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 4, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
    name = "Illegal Manufacturing", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 5, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
    name = "Illegal Activites", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 6, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
    name = "Dealers", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 7, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
-- Printers -- 

DarkRP.createCategory{
    name = "Money Printers",
    categorises = "entities",
	color = Color(0, 107, 0, 255),
    startExpanded = true,
	sortOrder = 100000
}

DarkRP.createCategory{
    name = "Money Printer Upgrades",
    categorises = "entities",
	color = Color(0, 107, 0, 255),
    startExpanded = true,
	sortOrder = 1000001
}

-- Job Specific Categories --

DarkRP.createCategory{
	name = "Bitcoin Mining",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
    canSee = function(ply) 
         return table.HasValue({BITCOIN_MINER}, ply:Team()) 
    end,
	sortOrder = 1
}

DarkRP.createCategory{
	name = "OP Money Printer",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
    canSee = function(ply) 
         return table.HasValue({MONEY_PRINTER}, ply:Team()) 
    end,
	sortOrder = 1
}

DarkRP.createCategory{
	name = "Oil Refiner",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
    canSee = function(ply) 
         return table.HasValue({OIL_REFINER}, ply:Team()) 
    end,
	sortOrder = 1
}

DarkRP.createCategory{
	name = "Mining Gear",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
    canSee = function(ply) 
         return table.HasValue({MINER}, ply:Team()) 
    end,
	sortOrder = 1
}

DarkRP.createCategory{
	name = "Meth Manufacturing",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
    canSee = function(ply) 
         return table.HasValue({METH_COOK}, ply:Team()) 
    end,
	sortOrder = 1
}

DarkRP.createCategory{
	name = "Weed Grower",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
    canSee = function(ply) 
         return table.HasValue({WEED_GROWER}, ply:Team()) 
    end,
	sortOrder = 1
}


-- Gun Catagories --

DarkRP.createCategory{
    name = "Pistols",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({GUN_DEALER, BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 11,
}
DarkRP.createCategory{
    name = "Heavy Pistols",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({GUN_DEALER, BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 12,
}
DarkRP.createCategory{
    name = "SMGs",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({GUN_DEALER, BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 13,
}
DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({GUN_DEALER, BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 14,
}
DarkRP.createCategory{
    name = "Machine Guns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 15,
}
DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 16,
}
DarkRP.createCategory{
    name = "Explosives",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 17,
}
DarkRP.createCategory{
    name = "Drugs",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0,255,255,255),
    canSee = function(ply) return table.HasValue({DRUG_DEALER}, ply:Team()) end,
    sortOrder = 18,
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

-- Staff --

DarkRP.createCategory{
    name = "Staff",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255,255,255,255),
    canSee = function(ply) return table.HasValue({"superadmin", "staff-manager", "senior-admin", "administrator", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup")) end,
    sortOrder = 9,
}