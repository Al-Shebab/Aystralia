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
        "models/smalls_civilians/pack2/female/parkajeans/female_01_parkajeans_pm.mdl",
        "models/smalls_civilians/pack2/female/parkasweats/female_01_parkasweats_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiepulloverjeans/female_01_hoodiepulloverjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedjeans/female_01_hoodiezippedjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedsweats/female_01_hoodiezippedsweats_pm.mdl",
        "models/smalls_civilians/pack2/female/parkajeans/female_02_parkajeans_pm.mdl",
        "models/smalls_civilians/pack2/female/parkasweats/female_02_parkasweats_pm.mdl",
        "models/smalls_civilians/pack1/zipper_female_02_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedjeans/female_02_hoodiezippedjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedsweats/female_02_hoodiezippedsweats_pm.mdl",
        "models/smalls_civilians/pack2/female/parkajeans/female_03_parkajeans_pm.mdl",
        "models/smalls_civilians/pack2/female/parkasweats/female_03_parkasweats_pm.mdl",
        "models/smalls_civilians/pack1/zipper_female_03_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedjeans/female_03_hoodiezippedjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedsweats/female_03_hoodiezippedsweats_pm.mdl",
        "models/smalls_civilians/pack2/female/parkajeans/female_04_parkajeans_pm.mdl",
        "models/smalls_civilians/pack2/female/parkasweats/female_04_parkasweats_pm.mdl",
        "models/smalls_civilians/pack1/zipper_female_04_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedjeans/female_04_hoodiezippedjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedsweats/female_04_hoodiezippedsweats_pm.mdl",
        "models/smalls_civilians/pack2/female/parkajeans/female_06_parkajeans_pm.mdl",
        "models/smalls_civilians/pack2/female/parkasweats/female_06_parkasweats_pm.mdl",
        "models/smalls_civilians/pack1/zipper_female_06_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedjeans/female_06_hoodiezippedjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedsweats/female_06_hoodiezippedsweats_pm.mdl",
        "models/smalls_civilians/pack2/female/parkajeans/female_07_parkajeans_pm.mdl",
        "models/smalls_civilians/pack2/female/parkasweats/female_07_parkasweats_pm.mdl",
        "models/smalls_civilians/pack1/zipper_female_07_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedjeans/female_07_hoodiezippedjeans_pm.mdl",
        "models/smalls_civilians/pack2/female/hoodiezippedsweats/female_07_hoodiezippedsweats_pm.mdl",
        "models/smalls_civilians/pack2/male/baseballtee/male_01_baseballtee_pm.mdl",
        "models/smalls_civilians/pack2/male/flannel/male_01_flannel_pm.mdl",
        "models/smalls_civilians/pack1/hoodie_male_01_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_jeans/male_01_hoodiejeans_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_sweatpants/male_01_hoodiesweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/jacket_open/male_01_jacketopen_pm.mdl",
        "models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_01_jacketvneck_sweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/leatherjacket/male_01_leather_jacket_pm.mdl",
        "models/smalls_civilians/pack1/puffer_male_01_pm.mdl",
        "models/smalls_civilians/pack2/male/baseballtee/male_02_baseballtee_pm.mdl",
        "models/smalls_civilians/pack2/male/flannel/male_02_flannel_pm.mdl",
        "models/smalls_civilians/pack1/hoodie_male_02_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_jeans/male_02_hoodiejeans_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_sweatpants/male_02_hoodiesweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/jacket_open/male_02_jacketopen_pm.mdl",
        "models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_02_jacketvneck_sweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/leatherjacket/male_02_leather_jacket_pm.mdl",
        "models/smalls_civilians/pack1/puffer_male_02_pm.mdl",
        "models/smalls_civilians/pack2/male/baseballtee/male_03_baseballtee_pm.mdl",
        "models/smalls_civilians/pack2/male/flannel/male_03_flannel_pm.mdl",
        "models/smalls_civilians/pack1/hoodie_male_03_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_jeans/male_03_hoodiejeans_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_sweatpants/male_03_hoodiesweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/jacket_open/male_03_jacketopen_pm.mdl",
        "models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_03_jacketvneck_sweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/leatherjacket/male_03_leather_jacket_pm.mdl",
        "models/smalls_civilians/pack1/puffer_male_03_pm.mdl",
        "models/smalls_civilians/pack2/male/baseballtee/male_04_baseballtee_pm.mdl",
        "models/smalls_civilians/pack2/male/flannel/male_04_flannel_pm.mdl",
        "models/smalls_civilians/pack1/hoodie_male_04_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_jeans/male_04_hoodiejeans_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_sweatpants/male_04_hoodiesweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/jacket_open/male_04_jacketopen_pm.mdl",
        "models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_04_jacketvneck_sweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/leatherjacket/male_04_leather_jacket_pm.mdl",
        "models/smalls_civilians/pack1/puffer_male_04_pm.mdl",
        "models/smalls_civilians/pack2/male/baseballtee/male_05_baseballtee_pm.mdl",
        "models/smalls_civilians/pack2/male/flannel/male_05_flannel_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_jeans/male_07_hoodiejeans_pm.mdl",
        "models/smalls_civilians/pack2/male/hoodie_sweatpants/male_07_hoodiesweatpants_pm.mdl",
        "models/smalls_civilians/pack2/male/jacket_open/male_07_jacketopen_pm.mdl",
        "models/smalls_civilians/pack2/male/jacketvneck_sweatpants/male_07_jacketvneck_sweatpants_pm.mdl",
        "models/smalls_civilians/pack1/puffer_male_07_pm.mdl",
        "models/smalls_civilians/pack2/male/baseballtee/male_09_baseballtee_pm.mdl",
        "models/smalls_civilians/pack2/male/flannel/male_09_flannel_pm.mdl",
        "models/smalls_civilians/pack1/hoodie_male_09_pm.mdl",
        "models/smalls_civilians/pack1/puffer_male_09_pm.mdl",
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
    model = {"models/enhanced_survivors/player/player_namvet.mdl"},
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
