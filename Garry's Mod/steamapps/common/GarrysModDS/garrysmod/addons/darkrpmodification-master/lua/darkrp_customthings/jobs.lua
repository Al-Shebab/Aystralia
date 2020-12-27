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


-- Civilians --

TEAM_BANK_MANAGER = DarkRP.createJob("Bank Manager", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/magnusson.mdl"},
    description = [[Manages finances and pawns items to other for a fee. Can not raid/mug.]],
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
    color = Color(74, 255, 69, 255),
    model = {"models/player/errolliamp/p2_chell_new.mdl"},
    description = [[Hardcore parkour around the entire city. Can not raid/mug. Can not use weapons.]],
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
    color = Color(74, 255, 69, 255),
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
    color = Color(74, 255, 69, 255),
    model = {"models/fortnite/female/dj_bop.mdl"},
    description = [[Allowed to hotmic music to others. Can not raid/mug. Can not use weapons.]],
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
TEAM_VAPIST = DarkRP.createJob("Vapist", {
    color = Color(74, 255, 69, 255),
    model = {"models/snoopdogg.mdl"},
    description = [[Vape Nation. Can not raid/mug. Can not use weapons.]],
    weapons = {"weapon_vape_juicy"},
    command = "TEAM_VAPIST",
    max = 2,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_FIGHT_CLUB_OWNER = DarkRP.createJob("Fight Club Owner", {
    color = Color(74, 255, 69, 255),
    model = {"models/errolliamp/super_smash_bros_brawl/ssbb_little_mac_player.mdl"},
    description = [[Start up an underground boxing competition. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_FIGHT_CLUB_OWNER",
    max = 1,
    salary = 1200,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_GAMBLING_ADDICT = DarkRP.createJob("Gambling Addict", {
    color = Color(74, 255, 69, 255),
    model = {"models/jessev92/player/l4d/m9-hunter.mdl"},
    description = [[Go hit the slaps and then drop a set in the AU Falcon. Can not raid/mug.]],
    weapons = {"weapon_cigarette_camel"},
    command = "TEAM_GAMBLING_ADDICT",
    max = 0,
    salary = 1000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})

-- Services --

TEAM_SECURITY_GUARD = DarkRP.createJob("Security Guard", {
    color = Color(80, 221, 204, 255),
    model = {"models/player/odessa.mdl"},
    description = [[Hired security for any business or person. Can not raid/mug.]],
    weapons = {"weapon_cigarette_camel"},
    command = "TEAM_SECURITY_GUARD",
    max = 2,
    salary = 650,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Services"
})
TEAM_DOCTER = DarkRP.createJob("Docter", {
    color = Color(80, 221, 204, 255),
    model = {"models/player/Group03m/male_01.mdl"},
    description = [[Paid good money to help out others in need. Can not raid/mug. Can not use weapons.]],
    weapons = {"weapon_medkit"},
    command = "TEAM_DOCTER",
    max = 1,
    salary = 2000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Services"
})
TEAM_NURSE = DarkRP.createJob("Nurse", {
    color = Color(80, 221, 204, 255),
    model = {
        "models/player/Group03m/female_02.mdl",
        "models/player/Group03m/female_01.mdl",
        "models/player/Group03m/female_03.mdl"
    },
    description = [[Paid decent money to help out others in need. Can not raid/mug. Can not use weapons.]],
    weapons = {"weapon_medkit"},
    command = "TEAM_NURSE",
    max = 2,
    salary = 800,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Services"
})

-- Dealers --

TEAM_GUN_DEALER = DarkRP.createJob("Gun Dealer", {
    color = Color(37, 110, 201, 255),
    model = {"models/player/monk.mdl"},
    description = [[Deliver small arms to the city. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_GUN_DEALER",
    max = 2,
    salary = 750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Dealers",
})
TEAM_BLACK_MARKET_DEALER = DarkRP.createJob("Black Market Dealer", {
    color = Color(37, 110, 201, 255),
    model = {"models/GrandTheftAuto5/Trevor.mdl"},
    description = [[Deliver large arms and explosives to the city. Can not raid/mug.]],
    weapons = {"m9k_ak47"},
    command = "TEAM_BLACK_MARKET_DEALER",
    max = 2,
    salary = 1500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Dealers",
    ammo = {
        ["AR2"] = 60
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "melbourne", "brisbane", "perth", "adelaide", "hobart", "darwin", "superadmin", "senior-admin", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_DRUG_DEALER = DarkRP.createJob("Drug Dealer", {
    color = Color(37, 110, 201, 255),
    model = {"models/player/MKX_Jax.mdl"},
    description = [[Sell prescription drugs to those in need. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_DRUG_DEALER",
    max = 2,
    salary = 1750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Dealers",
})