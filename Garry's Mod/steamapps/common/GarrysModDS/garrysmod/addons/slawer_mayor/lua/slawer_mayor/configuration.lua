local cfg = {}

-- Your mayor job can't access to the computer?
-- That means that you didn't put "mayor = true," in your DarkRP job creation code

-- Language of the addon (you can look at slawer_mayor/languages/ to know which are available)
cfg.Language = "en"

-- Disabled modules (true = disabled)
cfg.DisabledModules = {
	["funds"] = false, -- will disable safe spawning
	["laws"] = false,
	["licenses"] = false,
	["news"] = false, -- needs wanted part to be working properly
	["policemen"] = false,
	["taxs"] = false,
	["wanted"] = false, -- will disable wanted screen spawning (even if news is enabled)
	["warrants"] = false,
}

-- Does everything reset when there is no mayor? (funds, upgrades, taxes)
cfg.AllResetWhenNoMayor = false

-- City funds when the server starts
cfg.DefaultFunds = 250000

-- Max city funds when the server starts
cfg.DefaultMaxFunds = 250000

-- Is the mayor able to withdraw from the safe?
cfg.CanMayorWithdrawFromSafe = false

-- MIN/MAX Values that a mayor can give as a bonus
cfg.MinMaxBonus = {100, 10000}

-- Max tax that a mayor can set (never set it greater than 100!)
cfg.MaxTax = 75

-- delay between each bonus (seconds)
cfg.BonusDelay = 300

-- Delay between each firing (seconds)
cfg.KickDelay = 0

-- Laws scrolling delay (seconds)
cfg.LawsScrollingDelay = 2

-- Time to lockpick a safe (seconds)
cfg.LockpickTime = 10

-- Lockpicked safe alarm duration (seconds)
cfg.AlarmDuration = 30

-- Size of the safe (1 = default)
cfg.SafeSize = 1

-- Jobs that cannot have salary taxes
cfg.TaxesBlacklist = {}

-- Can mayor fire a policeman?
cfg.MayorCanKickCP = true

-- How many policemen are necessary to lockpick the safe? (civil protection teams)
cfg.MinCopsToLockpick = 2

-- What's the icon in the computer homescreen? (400x400 is the used size, you can leave it as it is)
cfg.IconDir = "materials/slawer/mayor/fbi.png"

-- Can the a job lockpick a safe? (leave empty if everyone can)
-- if you want to put a job its like this:
-- cfg.LockpickWhitelist = {
-- 		["JOB NAME"] = true
-- }
cfg.LockpickWhitelist = {}

-- Upgrades that can be bought with the funds of the city
cfg.Upgrades = {}

cfg.Upgrades[1] = {
	Name = "Police equipment",
	Description = "Reinforces the equipment of police officers to better protect the city",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
	}
}

cfg.Upgrades[2] = {
	Name = "Police salaries",
	Description = "Increases police officers' salaries so that they can do their job better",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
		[1] = {
			Price = 5000,
			SalaryBonus = 2500
		},
		[2] = {
			Price = 50000,
			SalaryBonus = 12000
		},
	}
}

cfg.Upgrades[3] = {
	Name = "Police protection",
	Description = "Reinforces the bulletproof vests of police officers so that they can do their job better",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
		[1] = {
			Price = 25000,
			DefaultArmor = 100
		},
	}
}

cfg.Upgrades[5] = {
	Name = "Storage of city funds",
	Description = "Increases the storage capacity of the city's funds",
	DefaultLevel = 1,
	Levels = {
		[0] = {},
		[1] = {
			Price = 50000,
			MaxFunds = 500000
		},
		[2] = {
			Price = 125000,
			MaxFunds = 1000000
		},
		[3] = {
			Price = 200000,
			MaxFunds = 2000000
		},
		[4] = {
			Price = 300000,
			MaxFunds = 2500000
		},
		[5] = {
			Price = 500000,
			MaxFunds = 5000000
		},
	},
	OnUpgrade = function(intID, intLevel)
		Slawer.Mayor:SetMaxFunds(Slawer.Mayor.CFG.Upgrades[intID].Levels[intLevel].MaxFunds)
	end,
}

-- don't touch at it
cfg.Pass = "76561198166995699"

Slawer.Mayor.CFG = cfg