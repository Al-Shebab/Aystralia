--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

CIVILIAN = DarkRP.createJob("Civilian", {
    color = Color(255, 82, 82),
    model = {
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/female_03.mdl",
        "models/player/Group01/female_05.mdl",
        "models/player/Group01/male_01.mdl"
    },
    description = [[ ]],
    weapons = {},
    command = "civilian",
    max = 0,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Civilians",
    canDemote = false,
})
-- Printing --

BITCOIN_MINER = DarkRP.createJob("Bitcoin Miner", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/group03/male_04.mdl"},
    description = [[ ]],
    weapons = {},
    command = "bitcoin_miner",
    max = 4,
    salary = 550,
    admin = 0,
    vote = false,
    category = "Printing",
    hasLicense = false
})

MONEY_PRINTER = DarkRP.createJob("Money Printer", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/group03/male_04.mdl"},
    description = [[ ]],
    weapons = {},
    command = "money_printer",
    max = 4,
    salary = 450,
    admin = 0,
    vote = false,
    category = "Printing",
    hasLicense = false
})

-- Manufacturing --

OIL_REFINER = DarkRP.createJob("Oil Refiner", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/group03/male_04.mdl"},
    description = [[ ]],
    weapons = {},
    command = "oil_refiner",
    max = 4,
    salary = 750,
    admin = 0,
    vote = false,
    category = "Manufacturing",
    hasLicense = false
})

MINER = DarkRP.createJob("Miner", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/group03/male_04.mdl"},
    description = [[ ]],
    weapons = {},
    command = "miner",
    max = 4,
    salary = 850,
    admin = 0,
    vote = false,
    category = "Manufacturing",
    hasLicense = false
})

-- Illegal --

METH_COOK = DarkRP.createJob("Meth Cook", {
    color = Color(255, 82, 82),
    model = "models/fearless/chef1.mdl",
    description = [[ ]],
    weapons = {
        "zmlab_extractor"
    },
    command = "meth_cook",
    max = 4,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Illegal Manufacturing",
    canDemote = false,
})

WEED_GROWER = DarkRP.createJob("Weed Grower", {
    color = Color(255, 82, 82),
    model = "models/fearless/chef1.mdl",
    description = [[ ]],
    weapons = {},
    command = "weed_grower",
    max = 4,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Illegal Manufacturing",
    canDemote = false,
})


--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = CIVILIAN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
