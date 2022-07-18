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
    model = {"models/obese_male.mdl"},
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
    model = {
        "models/player/Suits/male_09_shirt_tie.mdl",
        "models/player/Suits/male_08_shirt_tie.mdl",
        "models/player/Suits/male_07_shirt_tie.mdl",
        "models/player/Suits/male_06_shirt_tie.mdl",
        "models/player/Suits/male_05_shirt_tie.mdl",
        "models/player/Suits/male_04_shirt_tie.mdl",
        "models/player/Suits/male_03_shirt_tie.mdl",
        "models/player/Suits/male_02_shirt_tie.mdl",
        "models/player/Suits/male_01_shirt_tie.mdl",
    },
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
    model = {"models/player/blockdude.mdl"},
    description = [[ ]],
    weapons = {
        "zrms_pickaxe",
        "zrms_builder",
    },
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
    model = "models/walter_white/walter_white.mdl",
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
    model = "models/player/voikanaa/snoop_dogg.mdl",
    description = [[ ]],
    weapons = {
        "zwf_shoptablet",
        "zwf_wateringcan",
        "zwf_cable",
    },
    command = "weed_grower",
    max = 4,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Illegal Manufacturing",
    canDemote = false,
})

-- Government -- 

POLICE_OFFICER = DarkRP.createJob("Police Officer", {
    color = Color(30, 0, 255),
    model = {
        "models/sentry/hkpd/sentryhkpdmale5pm.mdl",
        "models/sentry/hkpd/sentryhkpdmale7pm.mdl",
    },
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "m9k_usp",
        "weaponchecker",
    },
    command = "police_officer",
    max = 4,
    salary = 1500,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
})

POLICE_CHIEF = DarkRP.createJob("Police Chief", {
    color = Color(30, 0, 255),
    model = "models/sentry/auspd/sentryauspdmale9pm.mdl",
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "stunstick",
        "m9k_m3",
        "m9k_usp",
        "weaponchecker",
    },
    command = "police_chief",
    max = 1,
    salary = 3000,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
    chief = true,
    NeedToChangeFrom = POLICE_OFFICER,
})

SWAT = DarkRP.createJob("SWAT", {
    color = Color(30, 0, 255),
    model = {
        "models/payday2/units/zeal_taser_player.mdl",
    },
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "weaponchecker",
        "m9k_auga3",
    },
    command = "swat",
    max = 2,
    salary = 2750,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
})

SWAT_MEDIC = DarkRP.createJob("SWAT Medic", {
    color = Color(30, 0, 255),
    model = {
        "models/payday2/units/medic_player.mdl",
    },
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "weaponchecker",
        "m9k_auga3",
        "med_kit",
    },
    command = "swat_medic",
    max = 1,
    salary = 2750,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
})

SWAT_SNIPER = DarkRP.createJob("SWAT Sniper", {
    color = Color(30, 0, 255),
    model = {
        "models/mark2580/payday2/pd2_cloaker_player.mdl",
    },
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "weaponchecker",
        "m9k_m98b",
    },
    command = "swat_sniper",
    max = 1,
    salary = 2750,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
})

SWAT_HEAVY = DarkRP.createJob("SWAT Heavy", {
    color = Color(30, 0, 255),
    model = {
        "models/mark2580/payday2/pd2_bulldozer_player.mdl",
    },
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "weaponchecker",
        "m9k_m249lmg",
        "m9k_m61_frag",
        "m9k_matador",
    },
    command = "swat_heavy",
    max = 1,
    salary = 2750,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
})

SWAT_LEADER = DarkRP.createJob("SWAT Leader", {
    color = Color(30, 0, 255),
    model = {
        "models/mark2580/payday2/pd2_gs_elite_player.mdl",
    },
    description = [[ ]],
    weapons = {
        "arrest_stick",
        "unarrest_stick",
        "stunstick",
        "weaponchecker",
        "m9k_m416",
        "m9k_m61_frag",
    },
    command = "swat_leader",
    max = 1,
    salary = 3500,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
})

MAYOR = DarkRP.createJob("Mayor", {
    color = Color(30, 0, 255),
    model = "models/player/Suits/male_07_closed_coat_tie.mdl",
    description = [[
          
    ]],
    weapons = {
        "unarrest_stick",
    },
    command = "mayor",
    max = 1,
    salary = 5000,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Government",
    canDemote = true,
    mayor = true,
})

-- Thief --

THIEF = DarkRP.createJob("Thief", {
    color = Color(30, 0, 255),
    model = {
        "models/shaklin/payday2/pd2_dallas.mdl",
        "models/shaklin/payday2/pd2_chains.mdl",
    },
    description = [[
          
    ]],
    weapons = {
        "unarrest_stick",
        "keypad_cracker",
        "lockpick",
    },
    command = "thief",
    max = 8,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Illegal Activites",
    canDemote = false,
})

BATTLE_MEDIC = DarkRP.createJob("Battle Medic", {
    color = Color(30, 0, 255),
    model = {
        "models/player/plague_doktor/PLAYER_Plague_Doktor.mdl",
    },
    description = [[
          
    ]],
    weapons = {
        "unarrest_stick",
        "keypad_cracker",
        "lockpick",
        "med_kit",
    },
    command = "battle_medic",
    max = 2,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Illegal Activites",
    canDemote = false,
})

PRO_THIEF = DarkRP.createJob("Pro Thief", {
    color = Color(30, 0, 255),
    model = {
        "models/shaklin/payday2/pd2_wolf.mdl",
        "models/shaklin/payday2/pd2_hoxton.mdl",
    },
    description = [[
          
    ]],
    weapons = {
        "unarrest_stick",
        "prokeypadcracker",
        "pro_lockpick",
    },
    command = "pro_thief",
    max = 8,
    salary = 1500,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Illegal Activites",
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
    [MAYOR] = true,
    [POLICE_CHIEF] = true,
    [SWAT_LEADER] = true,
    [SWAT_HEAVY] = true,
    [SWAT_SNIPER] = true,
    [SWAT_MEDIC] = true,
    [SWAT] = true,
    [POLICE_OFFICER] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
