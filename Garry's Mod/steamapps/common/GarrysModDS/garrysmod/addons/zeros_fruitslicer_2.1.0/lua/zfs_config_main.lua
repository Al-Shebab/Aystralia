zfs = zfs or {}
zfs.config = zfs.config or {}

/////////////////////////////////////////////////////////////////////////////

// Bought by 76561198166995690
// Version 2.1.0


/////////////////////////// Zeros FruitSlicer /////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//////////////BEFORE YOU START BE SURE TO READ THE README.TXT////////////////
/////////////////////////////////////////////////////////////////////////////


zfs.config.Debug = false

// This enables FastDownload
zfs.config.EnableResourceAddfile = false

// What Language should we use
// Currently we support: en , de , fr , pl , pt , es , cn
zfs.config.selectedLanguage = "en"

// The Currency
zfs.config.Currency = "$"

// Can everyone use the fruitslicer?
// If you plan on using publice fruit stands then this needs to be set to true
zfs.config.SharedEquipment = false

// Players with these Ranks are allowed to use the save command !savezfs
// If xAdmin or SAM is installed then this table can be ignored
zfs.config.AdminRanks = {
	["superadmin"] = true,
}

// These Jobs are allowed do interact with the fruitslicer, Leave empty to disable job check
zfs.config.Jobs = {
	[TEAM_ZFRUITSLICER] = true,
}

// This defines the Background Color of the Items
zfs.config.Item_BG = Color(87,122,136)

// This defines the Background Color of the Items if its ulx group exlusive
zfs.config.Restricted_Topping_BG = Color(229,167,48)

// Can the Creator of the fruitcup buy the fruitcup?
zfs.config.FruitcupCreatorBuy = true

// What should the SmoothieShop look like,  1 = California, 2 = India
zfs.config.Theme = 1



// These are the fruits which get loaded in the entity on spawn
zfs.config.StartStorage = {}
zfs.config.StartStorage["zfs_melon"] = 3
zfs.config.StartStorage["zfs_banana"] = 10
zfs.config.StartStorage["zfs_strawberry"] = 15



zfs.config.Price = {
	// Do we allow the players do change the price of each Product
	// *Note* If set to false then there will be a Fruit Variation Charge on the Base Price
	// that uses the zfs.config.Price.FruitMultiplicator too incourage the Production of more complex Smoothies
	Custom = false,

	// This is the minimum Custom Price the players can set it to
	Minimum = 250,

	// This is the maximum Custom Price the players can set it to
	Maximum = 10000,

	// This is the percentage of what the Smoothie will cost more when using multiple fruit types
	// *Note Only works if zfs.config.Price.Custom is set to false
	FruitMultiplicator = 0.5 // 0.5 = +50% extra cost
}


zfs.config.Health = {
	// How much Health/Energy does the fruits give the player
	Fruits = {
		["zfs_melon"] = 15,
		["zfs_banana"] = 5,
		["zfs_coconut"] = 10,
		["zfs_pomegranate"] = 7,
		["zfs_strawberry"] = 2,
		["zfs_kiwi"] = 3,
		["zfs_lemon"] = 1,
		["zfs_orange"] = 1,
		["zfs_apple"] = 3
	},

	// Do we want do cap the Health to MaxHealth if we get over it
	// *Examble* Player has 90 Health , MaxHealth = 100 , FruitCup gives Player 25 ExtraHealth , Players Health gets caped at 100
	HealthCap = true,

	// This is the Max Health the player can get from the Smoothies
	MaxHealthCap = 200,

	// This will give the player Energy rather then Health.
	UseHungermod = false
}
