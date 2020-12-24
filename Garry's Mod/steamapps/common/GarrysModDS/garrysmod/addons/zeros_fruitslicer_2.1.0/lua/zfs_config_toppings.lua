zfs = zfs or {}
zfs.config = zfs.config or {}
zfs.utility = zfs.utility or {}

//Available Benefits
// ["Health"] = ExtraHealth - 100
// ["ParticleEffect"] = Effectname   // In Mod Effects: zfs_health_effect,zfs_money_effect,zfs_energetic,zfs_ghost_effect
// ["SpeedBoost"] = SpeedBoost - 200
// ["AntiGravity"] = JumpBoost - 300
// ["Ghost"] = Alpha  - 0/255
// ["Drugs"] = ScreenEffectName  // In Mod ScreenEffects: MDMA,CACTI

// The Toppings we can add on the FruitCup
zfs.config.Toppings = {
	// This is the item for NoTopping and should not be removed
	[1] = {
		Name = "No Topping",
		ExtraPrice = 0,
		Icon = Material("materials/zfruitslicer/ui/zfs_ui_nothing.png","smooth"),
		Model = nil,
		mScale = 1,
		Info = "At least its Free xD",
		ToppingBenefits = {},
		ToppingBenefit_Duration = -1,
		ConsumInfo = "Tasty!",
		Ranks_consume = {},
		Ranks_create = {},
		Job_consume = {}
	},
	//
	[2] = {
		// The Name of the Topping
		Name = "Baby",

		// The Extra price when adding this topping
		ExtraPrice = 1000,

		// If specified we use a icon instead of the model itself
		Icon = nil,

		// The Topping Model that gets placed on the cup
		Model = "models/props_c17/doll01.mdl",

		// The Scale of the Topping Model
		mScale = 0.5,

		// The Info of the Topping
		Info = "Stem Cells can cure cancer, so \neating this gives you extra Health!",

		// The Benefits the player gets when consuming this topping
		ToppingBenefits = {
			["Health"] = 200 // This Gives the Player extra Health
		},

		// The Duration of the Benefits, this only applys to benefits that have a length. Wont to anything on Health since its Instant
		ToppingBenefit_Duration = 0,

		// The Info the Player gets when consuming the Fruicup
		ConsumInfo = "You feel very Healthy!",

		// This defines the Ranks who are allowed to consume the fruit cup if he has this topping, Leave empty to not Restrict it
		Ranks_consume = {},

		// This defines the Ranks who are allowed to add this topping to the fruit cup, Leave empty to not Restrict it
		Ranks_create = {
			["superadmin"] = true
		},

		// This defines the Jobs who are allowed to consume the fruit cup if he has this topping, Leave empty to not Restrict it
		Job_consume = {
			//[TEAM_POLICE] = true,
			//[TEAM_GANG] = true,
		}
	},
	[3] = {
		Name = "Coffee",
		ExtraPrice = 1000,
		Icon = nil,
		Model = "models/props_junk/garbage_metalcan002a.mdl",
		mScale = 0.5,
		Info = "Not good for the Health\nbut gives you an enery boost!",
		ToppingBenefits = {
			["ParticleEffect"] = "zfs_energetic",
			["SpeedBoost"] = 5
		},
		ToppingBenefit_Duration = 25,
		ConsumInfo = "You feel high on Energy!",
		Ranks_consume = {},
		Ranks_create = {},
		Job_consume = {}
	},
	[4] = {
		Name = "Floating Orb",
		ExtraPrice = 5000,
		Icon = nil,
		Model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
		mScale = 0.2,
		Info = "I found it in a crater so\ndo you want it?",
		ToppingBenefits = {
			["AntiGravity"] = 400
		},
		ToppingBenefit_Duration = 30,
		ConsumInfo = "You feel very light!",
		Ranks_consume = {},
		Ranks_create = {
			["superadmin"] = true
		},
		Job_consume = {}
	},
	[5] = {
		Name = "Old Skull",
		ExtraPrice = 3000,
		Icon = nil,
		Model = "models/Gibs/HGIBS.mdl",
		mScale = 0.5,
		Info = "Some say you can enter the \nGhost Dimension by licking it.",
		ToppingBenefits = {
			["Ghost"] = 25,
			["ParticleEffect"] = "zfs_ghost_effect"
		},
		ToppingBenefit_Duration = 30,
		ConsumInfo = "You filled with Dark Energy!",
		Ranks_consume = {},
		Ranks_create = {},
		Job_consume = {}
	},
	[6] = {
		Name = "Mis Hulala",
		ExtraPrice = 6000,
		Icon = nil,
		Model = "models/props_lab/huladoll.mdl",
		mScale = 0.8,
		Info = "It says Party on the Bottom.",
		ToppingBenefits = {
			["Drugs"] = "MDMA"
		},
		ToppingBenefit_Duration = 45,
		ConsumInfo = "You tripping Ballz!",
		Ranks_consume = {},
		Ranks_create = {
			["superadmin"] = true,
		},
		Job_consume = {}
	},
	[7] = {
		Name = "Cactus juice",
		ExtraPrice = 6000,
		Icon = nil,
		Model = "models/props_lab/cactus.mdl",
		mScale = 0.8,
		Info = "Drink cactus juice. It'll quench ya!\nIt's the quenchiest!",
		ToppingBenefits = {
			["Drugs"] = "CACTI"
		},
		ToppingBenefit_Duration = 45,
		ConsumInfo = "I feel quenchier!",
		Ranks_consume = {},
		Ranks_create = {},
		Job_consume = {}
	},
	[8] = {
		Name = "Energy Drink",
		ExtraPrice = 5000,
		Icon = nil,
		Model = "models/props_junk/PopCan01a.mdl",
		mScale = 0.5,
		Info = "Not good for the Health\nbut gives you an enery boost!",
		ToppingBenefits = {
			["ParticleEffect"] = "zfs_energetic",
			["SpeedBoost"] = 10
		},
		ToppingBenefit_Duration = 25,
		ConsumInfo = "You feel high on Energy!",
		Ranks_consume = {},
		Ranks_create = {
			["superadmin"] = true
		},
		Job_consume = {}
	},
	[9] = {
		Name = "Helium",
		ExtraPrice = 500,
		Icon = nil,
		Model = "models/Items/combine_rifle_ammo01.mdl",
		mScale = 0.4,
		Info = "Makes you feel light headed.",
		ToppingBenefits = {
			["AntiGravity"] = 50
		},
		ToppingBenefit_Duration = 30,
		ConsumInfo = "You feel very light!",
		Ranks_consume = {},
		Ranks_create = {},
		Job_consume = {}
	},
	[10] = {
		Name = "Cough Syrup",
		ExtraPrice = 100,
		Icon = nil,
		Model = "models/Items/HealthKit.mdl",
		mScale = 0.2,
		Info = "Needs no prescription.",
		ToppingBenefits = {
			["Health"] = 25
		},
		ToppingBenefit_Duration = 0,
		ConsumInfo = "You feel very Healthy!",
		Ranks_consume = {},
		Ranks_create = {},
		Job_consume = {}
	},
	[11] = {
		Name = "CTD",
		ExtraPrice = 5000,
		Icon = nil,
		Model = "models/Items/battery.mdl",
		mScale = 0.5,
		Info = "Thats one of these new Cell\nTarning Devices.",
		ToppingBenefits = {
			["Ghost"] = 25
		},
		ToppingBenefit_Duration = 30,
		ConsumInfo = "You feel almost invisible!",
		Ranks_consume = {},
		Ranks_create = {
			["superadmin"] = true
		},
		Job_consume = {
			["Gangster"] = true
		}
	}
}

zfs.utility.SortedToppingsTable = zfs.config.Toppings
table.sort(zfs.utility.SortedToppingsTable, function(a, b) return table.Count(a.Ranks_create) < table.Count(b.Ranks_create) end)
