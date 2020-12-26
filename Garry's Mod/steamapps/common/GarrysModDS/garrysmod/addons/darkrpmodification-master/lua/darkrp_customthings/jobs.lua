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

TEAM_CITIZEN = DarkRP.createJob("Citizen", {
    color = Color(140, 140, 140, 255),
    model = {
        "models/player/Group01/male_07.mdl",
        "models/player/Group01/male_08.mdl",
        "models/player/Group01/male_09.mdl",
        "models/player/Group01/female_06.mdl",
        "models/player/Group01/female_05.mdl",
        "models/player/Group01/female_03.mdl"
    },
    description = [[The Citizen is the most basic level of society you can hold besides being a hobo. You have no specific role in city life.]],
    weapons = {},
    command = "JOB_CITIZEN",
    max = 0,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Citizens"
})

TEAM_BANK_MANAGER = DarkRP.createJob("Bank Manager", {
    color = Color(140, 140, 140, 255),
    model = {"models/player/magnusson.mdl"},
    description = [[Manages finances and pawns items to other for a fee.]],
    weapons = {},
    command = "JOB_BANK_MANAGER",
    max = 1,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Citizens"
})
