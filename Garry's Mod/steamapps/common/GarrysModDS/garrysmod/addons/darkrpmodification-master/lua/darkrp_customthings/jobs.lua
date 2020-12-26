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



--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
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

TEAM_BANK_MANAGER = DarkRP.createJob("Bank Manager", {
    color = Color(148, 78, 78, 255),
    model = {"models/player/magnusson.mdl"},
    description = [[Manages finances and pawns items to other for a fee. Can not raid/mug]],
    weapons = {},
    command = "TEAM_BANK_MANAGER",
    max = 1,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Citizens"
})
TEAM_PARKOUR_MASTER = DarkRP.createJob("Parkour Master", {
    color = Color(148, 78, 78, 255),
    model = {"models/player/errolliamp/p2_chell_new.mdl"},
    description = [[Hardcore parkour around the entire city. Can not raid/mug.]],
    weapons = {"climb_swep2"},
    command = "TEAM_PARKOUR_MASTER",
    max = 1,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_GRAFFITI_ARTIST = DarkRP.createJob("Graffiti Artist", {
    color = Color(148, 78, 78, 255),
    model = {
        "models/player/Group03/male_03.mdl",
        "models/player/Group03/male_01.mdl",
        "models/player/Group03/female_05.mdl",
        "models/player/Group03/female_03.mdl"
    },
    description = [[Spray your tag all over the city. Can not raid/mug.]],
    weapons = {"weapon_spraymhs"},
    command = "TEAM_GRAFFITI_ARTIST",
    max = 1,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_DJ = DarkRP.createJob("DJ", {
    color = Color(148, 78, 78, 255),
    model = {"models/fortnite/female/dj_bop.mdl"},
    description = [[Allowed to hotmic music to others. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_DJ",
    max = 1,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
