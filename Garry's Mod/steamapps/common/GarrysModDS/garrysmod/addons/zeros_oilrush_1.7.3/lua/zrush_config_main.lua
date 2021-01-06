zrush = zrush || {}
zrush.config = zrush.config || {}
zrush.f = zrush.f || {}

/////////////////////////////////////////////////////////////////////////////

// Bought by 76561198166995690
// Version 1.7.3


///////////////////////////// Zeros OilRush //////////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////




// General
///////////////////////
zrush.config.Debug = false

// This switches between fast download and workshop
zrush.config.EnableResourceAddfile = false

// What language do we want? en,de,hu,fr,es,pl,cn,ru,it,dk
zrush.config.selectedLanguage = "en"

// The Currency
zrush.config.Currency = "$"

// The Unit of Measurement
zrush.config.UoM = "l" // liter

// These Ranks are allowed do use the save command  !savezrush
zrush.config.AdminRanks = {
	["superadmin"] = true,
}

// These Jobs are allowed to sell fuel, Leave empty to allow everyone to sell fuel
zrush.config.Jobs = {
	[TEAM_OIL_REFINER] = true
}

// The Palette entity can be used if zrush.config.FuelBuyer.SellMode is set to 2
zrush.config.Palette = {
	// How many Barrels can fit on the palette?
	// If its higher then 8 then the barrels will be shrink down a bit to still fit on the palette
	Capacity = 8,
}


zrush.config.Barrel = {
	// If enabled this checks if the player has the correct rank to pickup the FuelBarrel
	Rank_PickUpCheck = true,

	// If enabled this checks if the player is the owner of the FuelBarrel before picking it up
	Owner_PickUpCheck = false
}

// Player Config
zrush.config.Player = {
	// Should the player drop all of the Fuel Barrels he has in his Zrush inventory when he dies?
	DropFuelOnDeath = true,

	// How many acitve drillholes is the player allowed do have?
	MaxActiveDrillHoles = 3,

	// How many barrels can the player transport in his inventory?
	FuelInvSize = 8
}

// This jams or over heats the machines
// The chance of a machine getting hit by a chaos event can be reduced by the correct boost models
zrush.config.ChaosEvents = {
	// How often should we try to send chaos events to the machine
	Interval = 120,

	// How long till a machine can receive a chaos event again
	Cooldown = 120,
}

// The money you get when you sell your machines or modules again
zrush.config.SellValue = 1.0 // You get 50% of the original price

// The system which is used do place machines
zrush.config.MachineBuilder = {

	// See http://wiki.garrysmod.com/page/Enums/BUTTON_CODE

	// The Button which complets the action
	AcceptKey = MOUSE_LEFT,

	// The Button which cancels the action
	CancelKey = MOUSE_RIGHT,
}

// How should the drilling work?
// 0 = The DrillTower dont needs a oilspots and can be placed everywhere
// 1 = The DrillTower can only be placed on OilSpots and OilSpots Refresh after use (OilSpots need do be placed by an Admin)
// 2 = The DrillTower can only be placed on OilSpots which get created at random by a OilSpot Generator. (OilSpot Generator need do be placed by an Admin)
zrush.config.Drill_Mode = 2

// The Fuel Buyer data
zrush.config.FuelBuyer = {

	// 1 = Barrels can be absorbed and sold by the NPC
	// 2 = Barrels need to be moved to the NPC and sold directly
	SellMode = 2,

	// The Model
	Model = "models/odessa.mdl",

	// The Dialogbox Image
	NotifyImage = "entities/npc_odessa.png",

	// The Amount the player can sell at once
	SellAmount = 150,

	// How often should the fuel marked change in seconds
	RefreshRate = 300,

	//% The Max Sell Multiplicator you can get (100 is the Base Price, More means + Profit , Less means - Profit)
	MaxBuyRate = 125,

	//% The Min Sell Multiplicator you can get
	MinBuyRate = 75,

	// The idle animations of the npc
	anim_idle = {"idle_angry","idle_subtle"},

	// The sell animation of the npc
	anim_sell = {"takepackage","cheer1","cheer2"},

	// Just to give them a little Character :I
	names = {"Jeff","Martin","Alex","Henry","Thomas"},
}

zrush.config.VrondakisLevelSystem = false

// Only works if you have Vrondakis LevelSystem installed
zrush.config.Vrondakis = {}
zrush.config.Vrondakis["Selling"] = {XP = 25}		// XP per Sold Unit (5l/gal == 5XP)
zrush.config.Vrondakis["DrillingPipe"] = {XP = 100} // XP per drilled down Pipe
zrush.config.Vrondakis["BurningGas"] = {XP = 25}	// XP per burned gas unit
zrush.config.Vrondakis["ReachingOil"] = {XP = 200}  // XP when reaching Oil
zrush.config.Vrondakis["PumpingOil"] = {XP = 25}	// XP per pumped out Oil (5l/gal == 5XP)
zrush.config.Vrondakis["RefiningOil"] = {XP = 25}	// XP per refined unit of Oil (5l/gal == 5XP)

///////////////////////



// OilSpots
///////////////////////
zrush.config.OilSpot = {

	// This is the time in seconds a oilspot is gonna wait after it was closed before it can get drilled again or before it gets removed
	Cooldown = 60,
}

zrush.config.OilSpot_Generator = {
	// The rate in seconds the generator tries do spawn a new OilSpot if possible
	Rate = 10,

	// The Max count of valid oilspots a generator can have
	MaxOilSpots = 5,

	// This is the max time in seconds a oilspot is gonna wait before it gets removed again if its not used by a Player
	MaxLifeTime = 600,

	// This is the max search count per interval, meaning the generator trys this often do find a valid space for a oilspot befor it stops
	MaxSearchPosCount = 100,
}
///////////////////////
