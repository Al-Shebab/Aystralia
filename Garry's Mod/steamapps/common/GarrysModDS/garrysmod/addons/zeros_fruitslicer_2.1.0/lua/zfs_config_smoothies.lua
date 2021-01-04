zfs = zfs or {}
zfs.config = zfs.config or {}

// The Smoothies we can make in the Shop
zfs.config.FruitCups = {
	[1] = {
		// The Name of our FruitCup
		Name = "Monster Melon",

		// The Base Price of the FruitCup, This value can change depending on the fruit varation if zfs.config.FruitPriceMultiplier is true
		Price = 1500,

		// The Icon of the FruitCup
		Icon = Material("materials/zfruitslicer/ui/fs_ui_monstermelon.png","smooth"),

		// The Info of the FruitCup
		Info = "A Tasty Melon Cup with Rainbows, Sparks and a fruity melon smell.",

		// The Color of the Fruitcup
		fruitColor = Color(255, 25, 0),

		// What Fruits are needed do make the Smoothie
		// Dont add more then 22 fruits max or it gets complicated
		recipe = {
			["zfs_melon"] = 3,
			["zfs_banana"] = 0,
			["zfs_coconut"] = 0,
			["zfs_pomegranate"] = 0,
			["zfs_strawberry"] = 0,
			["zfs_kiwi"] = 0,
			["zfs_lemon"] = 0,
			["zfs_orange"] = 0,
			["zfs_apple"] = 0
		}
	},
	[2] = {
		Name = "General Banana",
		Price = 1200,
		Icon = Material("materials/zfruitslicer/ui/fs_ui_generalbanana.png","smooth"),
		Info = "A tasty Bananas Smoothie full of Rainbows.",
		fruitColor = Color(255, 223, 126),
		recipe = {
			["zfs_melon"] = 0,
			["zfs_banana"] = 5,
			["zfs_coconut"] = 0,
			["zfs_pomegranate"] = 0,
			["zfs_strawberry"] = 0,
			["zfs_kiwi"] = 0,
			["zfs_lemon"] = 0,
			["zfs_orange"] = 0,
			["zfs_apple"] = 0
		}
	},
	[3] = {
		Name = "Chianka Cup",
		Price = 2500,
		Icon = Material("materials/zfruitslicer/ui/fs_ui_chikichanga.png","smooth"),
		Info = "A tropical yummi sweet Cup of Hawai.",
		fruitColor = Color(221, 112, 161),
		recipe = {
			["zfs_melon"] = 0,
			["zfs_banana"] = 1,
			["zfs_coconut"] = 3,
			["zfs_pomegranate"] = 2,
			["zfs_strawberry"] = 0,
			["zfs_kiwi"] = 0,
			["zfs_lemon"] = 0,
			["zfs_orange"] = 0,
			["zfs_apple"] = 0
		}
	},
	[4] = {
		Name = "Super Fruit Cup",
		Price = 5000,
		Icon = Material("materials/zfruitslicer/ui/fs_ui_superfruit.png","smooth"),
		Info = "The Ultimate Vitamin Bomb!",
		fruitColor = Color(140, 119, 219),
		recipe = {
			["zfs_melon"] = 1,
			["zfs_banana"] = 3,
			["zfs_coconut"] = 1,
			["zfs_pomegranate"] = 1,
			["zfs_strawberry"] = 1,
			["zfs_kiwi"] = 2,
			["zfs_lemon"] = 1,
			["zfs_orange"] = 2,
			["zfs_apple"] = 2
		}
	},
	[5] = {
		Name = "Strawberry Bomb",
		Price = 3000,
		Icon = Material("materials/zfruitslicer/ui/fs_ui_strawberrybomb.png","smooth"),
		Info = "Taste the blood of your Enemys!",
		fruitColor = Color(174, 36, 56),
		recipe = {
			["zfs_melon"] = 0,
			["zfs_banana"] = 0,
			["zfs_coconut"] = 0,
			["zfs_pomegranate"] = 0,
			["zfs_strawberry"] = 5,
			["zfs_kiwi"] = 0,
			["zfs_lemon"] = 0,
			["zfs_orange"] = 0,
			["zfs_apple"] = 0
		}
	},
	[6] = {
		Name = "Lava Burst Delight",
		Price = 3000,
		Icon = Material("materials/zfruitslicer/ui/fs_ui_lavaburst.png","smooth"),
		Info = "The Power of the Earth combined in a Fruity Delight!",
		fruitColor = Color(255, 119, 0),
		recipe = {
			["zfs_melon"] = 1,
			["zfs_banana"] = 2,
			["zfs_coconut"] = 0,
			["zfs_pomegranate"] = 0,
			["zfs_strawberry"] = 2,
			["zfs_kiwi"] = 0,
			["zfs_lemon"] = 0,
			["zfs_orange"] = 0,
			["zfs_apple"] = 4
		}
	},
	[7] = {
		Name = "Rouges Vortex",
		Price = 4000,
		Icon = Material("materials/zfruitslicer/ui/fs_ui_fruitrougesvortex.png","smooth"),
		Info = "A Vortex of tasty red fruits!",
		fruitColor = Color(199, 48, 62),
		recipe = {
			["zfs_melon"] = 1,
			["zfs_banana"] = 0,
			["zfs_coconut"] = 0,
			["zfs_pomegranate"] = 5,
			["zfs_strawberry"] = 2,
			["zfs_kiwi"] = 0,
			["zfs_lemon"] = 0,
			["zfs_orange"] = 0,
			["zfs_apple"] = 3
		}
	}
}
