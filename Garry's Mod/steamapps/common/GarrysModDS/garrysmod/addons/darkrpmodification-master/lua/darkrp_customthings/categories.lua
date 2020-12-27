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


Add new categories under the next line!
---------------------------------------------------------------------------]]

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 1, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Services", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 2, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Dealers", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 3, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Government", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 4, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Illegal", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 5, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Homeless", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 6, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Manufacturing", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 7, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.fault.
}
DarkRP.createCategory{
    name = "Donator Classes", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = false, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return table.HasValue({"sydney", "melbourne", "brisbane", "perth", "adelaide", "hobart", "darwin", "superadmin", "senior-admin", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup")) end,
    sortOrder = 8, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Staff", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return table.HasValue({"superadmin", "staff-manager", "senior-admin", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup")) end,
    sortOrder = 9, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

-- Gun Catagories --

DarkRP.createCategory{
    name = "Ammo",
    categorises = "ammo",
    startExpanded = true,
    color = Color(255, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 10,
}



DarkRP.createCategory{
    name = "Pistols",
    categorises = "shipments",
    startExpanded = false,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 11,
}
DarkRP.createCategory{
    name = "SMGs",
    categorises = "shipments",
    startExpanded = false,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 12,
}
DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = false,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 13,
}
DarkRP.createCategory{
    name = "Machine Guns",
    categorises = "shipments",
    startExpanded = false,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 14,
}
DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = false,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 15,
}
DarkRP.createCategory{
    name = "Explosives",
    categorises = "shipments",
    startExpanded = false,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 16,
}