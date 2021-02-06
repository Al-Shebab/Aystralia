zrmine = zrmine || {}
zrmine.config = zrmine.config || {}

/////////////////////////////////////////////////////////////////////////////

// Bought by 76561198166995690
// Version 2.2.8


/////////////////////////// Zeros RetroMiner /////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////


// Misc
///////////////////////
// This enables fast download
zrmine.config.EnableResourceAddfile = false

// These Ranks are allowed do use the Chat and Console Commands
zrmine.config.AdminRanks = {
	["superadmin"] = true,
}

// This tells the script who can mine ore / sell bars (Leave empty to allow everyone)
zrmine.config.Jobs = {
	[TEAM_MINER] = true
}


// This disables a net message being send to client for the ore insert effect
zrmine.config.DisableVFX = false


// Level System IngGame Config ConsoleCommand: zrms_levelsystem_open

// Chat Commands
//  !zrms_lvlsys_reset SteamID
//  !zrms_lvlsys_xp SteamID Amount
//  !zrms_lvlsys_lvl SteamID Amount

// Console Commands
//  zrms_lvlsys_reset SteamID
//  zrms_lvlsys_xp SteamID Amount
//  zrms_lvlsys_lvl SteamID Amount

// What language do we want? en,de,fr,pl,it,ru,pt,es,cn,dk
zrmine.config.selectedLanguage = "en"

// Currency Display
zrmine.config.Currency = "$"

// Mass Display
zrmine.config.BuyerNPC_Mass = "kg"

// Disables the Owner Checks so everyone can use everyones mining entities
// Note* This should be on true if you want to use the Entities as a Public utility
zrmine.config.SharedOwnership = false

// The Damage the entitys have do take before they get destroyed.
// Setting it to -1 disables it
zrmine.config.Damageable = {}
zrmine.config.Damageable["MineEntrance"] = {EntityHealth = 1000}
zrmine.config.Damageable["Melter"] = {EntityHealth = 500}
zrmine.config.Damageable["Crusher"] = {EntityHealth = 300}
zrmine.config.Damageable["Refinery"] = {EntityHealth = 300}
zrmine.config.Damageable["Conveyorbelt"] = {EntityHealth = 200}
zrmine.config.Damageable["Splitter"] = {EntityHealth = 200}
zrmine.config.Damageable["Sorter"] = {EntityHealth = 200}

// Some debug information
zrmine.config.debug = false
///////////////////////


// The Builder SWEP
///////////////////////
zrmine.config.BuilderSWEP = {

	keys = {
		switch_left = KEY_E,
		switch_right = KEY_R
	},

	// The money the player receives if he deconstructs a entity
	refund_val = 0.5, // 1 = Full , 0.5 = half, 0 = no money back

	// The entity price
	entity_price = {
		["zrms_conveyorbelt_n"] = 150,
		["zrms_conveyorbelt_s"] = 100,
		["zrms_conveyorbelt_c_left"] = 250,
		["zrms_conveyorbelt_c_right"] = 250,

		["zrms_crusher"] = 1000,
		["zrms_splitter"] = 1500,
		["zrms_inserter"] = 1500,

		["zrms_refiner_coal"] = 1500,
		["zrms_refiner_iron"] = 2000,
		["zrms_refiner_bronze"] = 3000,
		["zrms_refiner_silver"] = 4000,
		["zrms_refiner_gold"] = 5000,

		["zrms_sorter_coal"] = 1500,
		["zrms_sorter_iron"] = 2000,
		["zrms_sorter_bronze"] = 3000,
		["zrms_sorter_silver"] = 4000,
		["zrms_sorter_gold"] = 5000
	},

	// How many entites is the player allowed to spawn/buy
	entity_limit = {
		["zrms_conveyorbelt_n"] = 10,
		["zrms_conveyorbelt_s"] = 6,
		["zrms_conveyorbelt_c_left"] = 6,
		["zrms_conveyorbelt_c_right"] = 6,

		["zrms_crusher"] = 2,
		["zrms_splitter"] = 4,
		["zrms_inserter"] = 4,

		["zrms_refiner_coal"] = 2,
		["zrms_refiner_iron"] = 2,
		["zrms_refiner_bronze"] = 2,
		["zrms_refiner_silver"] = 2,
		["zrms_refiner_gold"] = 2,

		["zrms_sorter_coal"] = 2,
		["zrms_sorter_iron"] = 2,
		["zrms_sorter_bronze"] = 2,
		["zrms_sorter_silver"] = 2,
		["zrms_sorter_gold"] = 2
	},
}
///////////////////////




// The Pickaxe
///////////////////////

// The Level System
// If set to true then the data gets writen into sv.db
// If set to false then we write the player data as file at garrysmod\data\zrms\playerdata
zrmine.config.Pickaxe_UseDB = false

// This command migrates data from sv.db to file (It only migrates the data from online players and only if it doesent allready exist as file)
// Console Command: zrms_levelsystem_migrate_data_to_file

// This is the Time in seconds that the Level system gets saved each player it changed
zrmine.config.Pickaxe_LvlSys_SaveTime = 500

// How long after the player has spawned should we wait till we load his Pickaxe Level Data
zrmine.config.Pickaxe_LvlSys_Init_LoadTime = 5

/*
Examble: zrmine.config.Pickaxe_Lvl[Level] =
    {
    NextXP = Amount of XP Needed for the next Level up,
    HarvestAmount = Amount of Resource Harvested per Hit in Kg,
    HarvestInterval = Hit interval ,
    OreInv = Your Pickaxe Ore Inventory Capacity,
    FillCap = The Amount of or you can fill in a Crusher or crate per Right Click
    }
*/
zrmine.config.Pickaxe_Lvl = {}
zrmine.config.Pickaxe_Lvl[0] = {NextXP = 100, HarvestAmount = 0.1, HarvestInterval = 1.3 , OreInv = 20, FillCap = 3}
zrmine.config.Pickaxe_Lvl[1] = {NextXP = 200, HarvestAmount = 0.5, HarvestInterval = 1 , OreInv = 30, FillCap = 5}
zrmine.config.Pickaxe_Lvl[2] = {NextXP = 400, HarvestAmount = 1, HarvestInterval = 0.9 , OreInv = 40, FillCap = 10}
zrmine.config.Pickaxe_Lvl[3] = {NextXP = 500, HarvestAmount = 2, HarvestInterval = 0.75 , OreInv = 50, FillCap = 15}
zrmine.config.Pickaxe_Lvl[4] = {NextXP = 1000, HarvestAmount = 4, HarvestInterval = 0.6 , OreInv = 70, FillCap = 20}
zrmine.config.Pickaxe_Lvl[5] = {NextXP = 1500, HarvestAmount = 5, HarvestInterval = 0.5 , OreInv = 100, FillCap = 25}
zrmine.config.Pickaxe_Lvl[6] = {NextXP = 2000, HarvestAmount = 6, HarvestInterval = 0.5 , OreInv = 200, FillCap = 50}
zrmine.config.Pickaxe_Lvl[7] = {NextXP = 3000, HarvestAmount = 6.5, HarvestInterval = 0.5 , OreInv = 300, FillCap = 50}
zrmine.config.Pickaxe_Lvl[8] = {NextXP = 5000, HarvestAmount = 7, HarvestInterval = 0.5 , OreInv = 400, FillCap = 50}
zrmine.config.Pickaxe_Lvl[9] = {NextXP = 7500, HarvestAmount = 7.5, HarvestInterval = 0.45 , OreInv = 500, FillCap = 100}
zrmine.config.Pickaxe_Lvl[10] = {NextXP = 10000, HarvestAmount = 8, HarvestInterval = 0.4 , OreInv = 600, FillCap = 100}
zrmine.config.Pickaxe_Lvl[11] = {NextXP = 20000, HarvestAmount = 8, HarvestInterval = 0.4 , OreInv = 700, FillCap = 100}
zrmine.config.Pickaxe_Lvl[12] = {NextXP = 40000, HarvestAmount = 9, HarvestInterval = 0.35 , OreInv = 800, FillCap = 100}
zrmine.config.Pickaxe_Lvl[13] = {NextXP = 60000, HarvestAmount = 9, HarvestInterval = 0.35 , OreInv = 900, FillCap = 100}
zrmine.config.Pickaxe_Lvl[14] = {NextXP = 80000, HarvestAmount = 10, HarvestInterval = 0.33 , OreInv = 1000, FillCap = 100}
zrmine.config.Pickaxe_Lvl[15] = {NextXP = 100000, HarvestAmount = 10, HarvestInterval = 0.33 , OreInv = 1000, FillCap = 100}
zrmine.config.Pickaxe_Lvl[16] = {NextXP = 140000, HarvestAmount = 10, HarvestInterval = 0.3 , OreInv = 1000, FillCap = 100}
zrmine.config.Pickaxe_Lvl[17] = {NextXP = 180000, HarvestAmount = 11, HarvestInterval = 0.3 , OreInv = 1000, FillCap = 100}
zrmine.config.Pickaxe_Lvl[18] = {NextXP = 210000, HarvestAmount = 11, HarvestInterval = 0.27 , OreInv = 1000, FillCap = 100}
zrmine.config.Pickaxe_Lvl[19] = {NextXP = 250000, HarvestAmount = 12, HarvestInterval = 0.27 , OreInv = 1000, FillCap = 100}
zrmine.config.Pickaxe_Lvl[20] = {NextXP = 300000, HarvestAmount = 13, HarvestInterval = 0.27 , OreInv = 1000, FillCap = 100}

// Here you can set what Ore Ressource requires what Pickaxe Level
zrmine.config.Pickaxe_OreRestriction = {
	["Coal"] = 0,
	["Iron"] = 0,
	["Bronze"] = 2,
	["Silver"] = 5,
	["Gold"] = 10,
	["Random"] = 8,
}


// How many pickaxe hits before we get another XP
zrmine.config.Pickaxe_MaxNextXP = 14
zrmine.config.Pickaxe_MinNextXP = 4

// What Color Theme should the Pickaxe UI have
zrmine.config.PickaxeThemeLight = false

// This Defines a offset for the main UI of the Pickaxe
zrmine.config.PickaxeUI_Offset = Vector(0,0,0)

// Defines the harvest chance in % per Hit
zrmine.config.Pickaxe_HarvestChance = 75 //1-100% 75% means we have a 25% chance of getting no resource

// This Values are % Multiplicators for the diffrend resource types
// *Note* Examble : Amount: 0.5% = -50% You get only half the amount per hit   Speed: 1.3% = +30% more time needed do harvest
zrmine.config.Pickaxe_HarvestMul = {}
zrmine.config.Pickaxe_HarvestMul["Random"] = {Amount = 0.5, Speed = 1.3,XP = 2}
zrmine.config.Pickaxe_HarvestMul["Coal"] =  {Amount = 1.3, Speed = 0.5,XP = 1}
zrmine.config.Pickaxe_HarvestMul["Iron"] = {Amount = 1.2, Speed = 0.7,XP = 1}
zrmine.config.Pickaxe_HarvestMul["Bronze"] = {Amount = 0.6, Speed = 1,XP = 1}
zrmine.config.Pickaxe_HarvestMul["Silver"] = {Amount = 0.5, Speed = 1.1,XP = 2}
zrmine.config.Pickaxe_HarvestMul["Gold"] = {Amount = 0.25, Speed = 1.5,XP = 3}
///////////////////////



// The Bar
///////////////////////

/*
// Real Metal Price (This is for Reference only and does not change anything inGame)

local Gold_1kg = 3000 //$
local Silver_1kg = 1400 //$
local Bronze_1kg = 700 //$
local Iron_1kg = 550 //$
*/

local Gold_1kg = 3000 //$
local Silver_1kg = 1400 //$
local Bronze_1kg = 700 //$
local Iron_1kg = 550 //$

local Mass_per_Bar = 10

// The Cash Value of 1 bar
zrmine.config.BarValue = {}
zrmine.config.BarValue["Iron"] = Iron_1kg * Mass_per_Bar
zrmine.config.BarValue["Bronze"] = Bronze_1kg * Mass_per_Bar
zrmine.config.BarValue["Silver"] = Silver_1kg * Mass_per_Bar
zrmine.config.BarValue["Gold"] = Gold_1kg * Mass_per_Bar

// Does the storage crate need do be full before it can be collected
zrmine.config.StorageCrateFull = false

zrmine.config.MetalBar_Stealing = {

	// Can other Players steal the Bars or the storagecrate?
	Enabled = true,

	// These Jobs can steal metalbars and storagecrates. (Leave empty to allow everyone to steal)
	// You probably also want to add the job names to zrmine.config.Jobs so these Jobs can also sell the metal bars
	Jobs = {
		[TEAM_THIEF] = true,
		[TEAM_HACKER] = true,
		[TEAM_BLOOD] = true,
		[TEAM_CRIP] = true,
		[TEAM_BLOOD_LEADER] = true,
		[TEAM_CRIP_LEADER] = true,
		[TEAM_MAFIA] = true,
		[TEAM_MAFIA_LEADER] = true,
		[TEAM_BATTLE_MEDIC] = true,
		[TEAM_PRO_THIEF] = true,
		[TEAM_PRO_HACKER] = true,
	}
}

// Do we want the metal bars from the players inventory to drop on death?
zrmine.config.MetalBar_DropOnDeath = false
///////////////////////



// The Buyer NPC
///////////////////////
zrmine.config.MetalBuyer = {

	// Model of the NPC
	model = "models/Humans/Group03/male_07.mdl",
	// Note* You need do make sure the Model got compiled with the animations you want to use

	// The Idle Animations of the Buyer NPC
	anim_idle = {"idle_angry","idle_subtle"},

	// The Sell Animations of the Buyer NPC
	anim_sell = {"takepackage","cheer1","cheer2"},

	// This is the time in seconds the buyer npcs refresh their buy rate
	RefreshRate = 600, //seconds

	// This defines the range at which some Buyers gonna buy your metals
	MaxRate = 125, //%
	MinRate = 75, //%
}
///////////////////////



// The Resource Junk
///////////////////////
// This Values Defines the Despawn Time in seconds, set to -1 do Disable it
zrmine.config.Resource_DespawnTime = 120
///////////////////////



// The Ore Spawns
///////////////////////

// Do we want the Ore Spawns do refresh?
zrmine.config.Ore_Refresh = true

// How often do we want do refresh the ore spawns?
zrmine.config.Ore_Refreshrate = 600

// How much gets refreshed?
zrmine.config.Ore_RefreshAmount = 800 //kg
///////////////////////



// The Mine
///////////////////////

// If you want do set the name of the Mine Entrance yourself rather then using the player name
// This can be usefull if the MineEntrace is public
// Set this to nil if you dont want to use Public Mining Entities
zrmine.config.Mine_CustomName = nil

// Defines the chance in % what the MineEntrance Enity gives you
zrmine.config.Mine_ResourceChance = {}
zrmine.config.Mine_ResourceChance["Coal"] = 35
zrmine.config.Mine_ResourceChance["Iron"] = 30
zrmine.config.Mine_ResourceChance["Bronze"] = 15
zrmine.config.Mine_ResourceChance["Silver"] = 10
zrmine.config.Mine_ResourceChance["Gold"] = 10

// This Value Defines the Mining Time in seconds for the MineEntrace Entity
zrmine.config.MiningTime = {}
zrmine.config.MiningTime["Random"] = 30
zrmine.config.MiningTime["Coal"] = 15
zrmine.config.MiningTime["Iron"] = 30

zrmine.config.MiningTime["Bronze"] = 40
zrmine.config.MiningTime["Silver"] = 50
zrmine.config.MiningTime["Gold"] = 60

// The Ore Search distance of the Mine
zrmine.config.Mine_SearchDistance = 400

// This Value Defines the Amount one Minning Load gives the player in kg
zrmine.config.Max_MiningAmount = 45
zrmine.config.Min_MiningAmount = 15

// This defines how many ore entites 1 mine is allowed to spawn until it tells the user to refine some of the allready spawned ore
zrmine.config.Mine_MaxEntCount = 3
///////////////////////



// The Conveyorbelt
///////////////////////
zrmine.config.Belt_Capacity = 15
zrmine.config.SplitterBelt_Capacity = 25
///////////////////////



// The Inserter
///////////////////////
// Should Resources be deleted when no module is connected
zrmine.config.Inserter_DeleteOnEndPoint = true
//*Note* When a ressource reeaches the end of a inserter belt then it either gets Deleted or outputed as gravel entity
// By putting a GravelCrate near the inserter end point you can collect the moved ressource rather then it getting destroyed.

// This defines the loss rate of the ore when transported via inserter.
// 0 = No loss at all.  0.5 = Half of the Ore gets lost.
zrmine.config.Inserter_LossRate = 0.25  // 0 - 0.9
///////////////////////



// The Crusher
///////////////////////

// Whats the crush process duration
zrmine.config.Crusher_Time = 4

// Whats the work amount
zrmine.config.Crusher_WorkAmount = 5

// Whats the crusher inventory capacity?
zrmine.config.Crusher_Capacity = 1000
///////////////////////



// The Gravel Crate
///////////////////////

// The Capacity of the Crates
zrmine.config.GravelCrates_Capacity = 1000

// Do we want do reuse the gravel crates or should they get deleted when emtpy
zrmine.config.GravelCrates_ReUse = true
///////////////////////



// The Refiner Crate
///////////////////////
// Do we want that everyone can attach or detach the refiner basket
zrmine.config.ResourceCrates_Sharing = true
// The Capacity of the Crates
zrmine.config.ResourceCrates_Capacity = 500
// Do we want do reuse the crate or destroy it when emtpy
zrmine.config.ResourceCrates_ReUse = true
///////////////////////



// The Refiner
///////////////////////
// This Values Defines the Refining Time in seconds
zrmine.config.Gold_RefiningTime = 15
zrmine.config.Silver_RefiningTime = 15
zrmine.config.Bronze_RefiningTime = 10
zrmine.config.Iron_RefiningTime = 5
zrmine.config.Coal_RefiningTime = 5

// How much of the Refined ore is metal
zrmine.config.RefiningAmount = 0.75 // 75%

// The Ore Capacity of the Refiner
zrmine.config.Refiner_Capacity = 25

// Do we want to that a Refiner Crate spawns with the Refiner?
// Note* This only applys to Refiners used in a Public Pipeline!
zrmine.config.Refiner_AutoSpawnCrate = true
///////////////////////



// The Melter
///////////////////////
// The Coal Capacity of the Melter
zrmine.config.Melter_Coal_Capacity = 1000

// The Unload Time
zrmine.config.Melter_UnloadTime = 10

zrmine.config.Melter_Vars = {}
zrmine.config.Melter_Vars["Iron"] = {OreAmount = 50, MeltDuration = 5,CoalAmount = 5,CoolingTime = 2}
zrmine.config.Melter_Vars["Bronze"] = {OreAmount = 30, MeltDuration = 10,CoalAmount = 10,CoolingTime = 3}
zrmine.config.Melter_Vars["Silver"] = {OreAmount = 20, MeltDuration = 15,CoalAmount = 15,CoolingTime = 5}
zrmine.config.Melter_Vars["Gold"] = {OreAmount = 10, MeltDuration = 15,CoalAmount = 20,CoolingTime = 5}
///////////////////////



// Vrondakis Leveling System
///////////////////////

// How much XP do we get for completing these Tasks
// *Note01 Only works if Vrondakis Leveling System is installed
// *Note02 Also needs Faclos or NaMad PropProtection script installed do determine the owner
zrmine.config.Vrondakis = {}
zrmine.config.Vrondakis["Mining_mine"] = {XP = 5} // Per Mine Load
zrmine.config.Vrondakis["Mining_pickaxe"] = {XP = 1} // Per Hit
zrmine.config.Vrondakis["Crushing"] = {XP = 1} // Per WorkLoad
zrmine.config.Vrondakis["Refining"] = {XP = 2} // Per WorkLoad
zrmine.config.Vrondakis["Melting"] = {XP = 10} // Per WorkLoad
zrmine.config.Vrondakis["Selling"] = {XP = 5} // Per Sell
///////////////////////
