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
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 1, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Services", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 2, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Dealers", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 3, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Government", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 4, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Illegal", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 5, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Homeless", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 6, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Manufacturing", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 7, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.fault.
}
DarkRP.createCategory{
    name = "Donator Classes", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return table.HasValue({"sydney", "melbourne", "brisbane", "perth", "adelaide", "hobart", "darwin", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup")) end,
    sortOrder = 8, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}
DarkRP.createCategory{
    name = "Staff", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return table.HasValue({"superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup")) end,
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
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 11,
}
DarkRP.createCategory{
    name = "Heavy Pistols",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 12,
}
DarkRP.createCategory{
    name = "SMGs",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 13,
}
DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 14,
}
DarkRP.createCategory{
    name = "Machine Guns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 15,
}
DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 16,
}
DarkRP.createCategory{
    name = "Explosives",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BLACK_MARKET_DEALER}, ply:Team()) end,
    sortOrder = 17,
}



-- Job Entities --


DarkRP.createCategory{
    name = "Bitcoin",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_BITCOIN_MINER}, ply:Team()) end,
    sortOrder = 1
}
DarkRP.createCategory{
    name = "Advanced Money Printers",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_MONEY_PRINTER}, ply:Team()) end,
    sortOrder = 2
}
DarkRP.createCategory{
    name = "Money Printers",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_CITIZEN, TEAM_BANK_MANAGER, TEAM_PARKOUR_MASTER, TEAM_GRAFFITI_ARTIST, TEAM_DJ, TEAM_VAPIST, TEAM_FIGHT_CLUB_OWNER, TEAM_PIANIST, TEAM_GAMBLING_ADDICT, TEAM_SECURITY_GUARD, TEAM_DOCTER, TEAM_NURSE, TEAM_GUN_DEALER, TEAM_BLACK_MARKET_DEALER, TEAM_DRUG_DEALER, TEAM_HACKER, TEAM_THIEF, TEAM_HITMAN, TEAM_BLOOD, TEAM_BLOOD_LEADER, TEAM_CRIP, TEAM_CRIP_LEADER, TEAM_BATTLE_MEDIC, TEAM_MAFIA, TEAM_MAFIA_LEADER, TEAM_PRO_THIEF, TEAM_TERRORIST, TEAM_ASSASSIN, TEAM_KIDNAPPER, TEAM_MUTANT, TEAM_MUTANT_KING, TEAM_BITCOIN_MINER, TEAM_MONEY_PRINTER, TEAM_LEAN_MANUFACTURER, TEAM_WEED_DEALER, TEAM_LSD_DEALER, TEAM_METH_DEALER}, ply:Team()) end,
    sortOrder = 113
}
DarkRP.createCategory{
    name = "Lean Materials",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_LEAN_MANUFACTURER}, ply:Team()) end,
    sortOrder = 4
}
DarkRP.createCategory{
    name = "Weed Materials",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_WEED_DEALER}, ply:Team()) end,
    sortOrder = 5
}
DarkRP.createCategory{
    name = "Meth Materials",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_METH_DEALER}, ply:Team()) end,
    sortOrder = 6
}
DarkRP.createCategory{
    name = "Piano",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return table.HasValue({TEAM_PIANIST}, ply:Team()) end,
    sortOrder = 7
}