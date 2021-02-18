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


-- Civilians --
TEAM_CITIZEN = DarkRP.createJob("Citizen", {
    color = Color(74, 255, 69, 255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[The Citizen is the most basic level of society you can hold besides being a hobo. You have no specific role in city life.]],
    weapons = {},
    command = "citizen",
    max = 0,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
})
JOB_CASINO_SECURITY = DarkRP.createJob("Casino Security", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/portal/Male_04_security.mdl"},
    description = [[Protect the casino from angery gamblers]],
    weapons = {"m9k_colt1911"},
    command = "JOB_CASINO_SECURITY",
    max = 4,
    salary = 7500,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Citizens"
})
JOB_CASINO_MANAGER = DarkRP.createJob("Casino Manager", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/kleiner.mdl"},
    description = [[Make sure the casino isn't earning too much money.]],
    weapons = {"weapon_cigarette_camel"},
    command = "JOB_CASINO_MANAGER",
    max = 1,
    salary = 25000,
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
    max = 4,
    salary =750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_GRAFFITI_ARTIST = DarkRP.createJob("Graffiti Artist", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/Group03/female_04.mdl"},
    description = [[Spray your tag all over the city. Can not raid/mug.]],
    weapons = {"weapon_spraymhs"},
    command = "TEAM_GRAFFITI_ARTIST",
    max = 2,
    salary =750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_DJ = DarkRP.createJob("DJ", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/daftpunk/daft_silver.mdl"},
    description = [[Allowed to hotmic music to others. Can not raid/mug. Can not use weapons.]],
    weapons = {},
    command = "TEAM_DJ",
    max = 1,
    salary =750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_VAPIST = DarkRP.createJob("Vapist", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/daftpunk/daft_gold.mdl"},
    description = [[Vape Nation. Can not raid/mug. Can not use weapons.]],
    weapons = {"weapon_vape_juicy"},
    command = "TEAM_VAPIST",
    max = 4,
    salary =750,
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
TEAM_PIANIST = DarkRP.createJob("Eshay", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/phoenix.mdl"},
    description = [[Ask dogs for money at bankstown station.  Can not raid. Can mug others.]],
    weapons = {"weapon_cigarette_camel","zwf_bong03","csgo_default_t"},
    command = "TEAM_ESHAY",
    max = 6,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
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
TEAM_RAPIST = DarkRP.createJob("Predator", {
    color = Color(74, 255, 69, 255),
    model = {
        "models/player/Group01/male_08.mdl",
        "models/player/Group01/male_04.mdl"
    },
    description = [[Commit some *crimes* on civilians. MAY ONLY *** ONCE EVERY 5 MINUTES, MUST ADVERT!]],
    weapons = {"weapon_rape"},
    command = "TEAM_RAPIST",
    max = 1,
    salary = 1,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Citizens",
    PlayerDeath = function(ply, weapon, killer)
        ply:teamBan()
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
        DarkRP.notifyAll(0, 4, "The predator has died.")
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_PROSTITUTE = DarkRP.createJob("Prostitute", {
    color = Color(74, 255, 69, 255),
    model = {"models/konnie/tifff13/tifff13_s.mdl"},
    description = [[Pleasure the inner truck drivers of the server.]],
    weapons = {"weapon_cigarette_camel"},
    command = "TEAM_PROSTITUTE",
    max = 4,
    salary = 30000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Citizens"
})

-- Services --

TEAM_SECURITY_GUARD = DarkRP.createJob("Security Guard", {
    color = Color(204,128,255, 255),
    model = {"models/player/odessa.mdl"},
    description = [[Hired security for any business or person. Can not raid/mug.]],
    weapons = {"weapon_cigarette_camel","m9k_m92beretta"},
    command = "TEAM_SECURITY_GUARD",
    max = 4,
    salary = 650,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Services"
})
TEAM_DOCTER = DarkRP.createJob("Medic", {
    color = Color(204,128,255, 255),
    model = {"models/player/Group03m/male_01.mdl"},
    description = [[Paid good money to help out others in need. Can not raid/mug. Can not use weapons.]],
    weapons = {"med_kit"},
    command = "TEAM_DOCTER",
    max = 2,
    salary = 10000,
    admin = 0,
    vote = false,
    medic = true,
    hasLicense = false,
    candemote = false,
    category = "Services"
})

-- Dealers --

TEAM_GUN_DEALER = DarkRP.createJob("Gun Dealer", {
    color = Color(204,0,255, 255),
    model = {"models/player/monk.mdl"},
    description = [[Deliver small arms to the city. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_GUN_DEALER",
    max = 2,
    salary = 7500,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Dealers",
})
TEAM_BLACK_MARKET_DEALER = DarkRP.createJob("Black Market Dealer", {
    color = Color(204,0,255, 255),
    model = {"models/player/gru.mdl"},
    description = [[Deliver large arms and explosives to the city. Can not raid/mug]],
    weapons = {},
    command = "TEAM_BLACK_MARKET_DEALER",
    max = 2,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Dealers",
    ammo = {
        ["AR2"] = 60
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(25)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_DRUG_DEALER = DarkRP.createJob("Drug Dealer", {
    color = Color(204,0,255, 255),
    model = {"models/GrandTheftAuto5/Trevor.mdl"},
    description = [[Sell prescription drugs to those in need. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_DRUG_DEALER",
    max = 2,
    salary = 17500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Dealers",
})

-- Government --

TEAM_POLICE_OFFICER = DarkRP.createJob("Police Officer", {
    color = Color(45, 6, 255, 255),
    model = {"models/player/santosrp/Male_02_santosrp.mdl"},
    description = [[Protect and serve. Can not base, raid or mug.]],
    weapons = {"m9k_usp", "weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker"},
    command = "TEAM_POLICE_OFFICER",
    max = 4,
    salary = 3000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["pistol"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"trusted", "member", "sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for members with over 2 hours.",
})
TEAM_POLICE_CHIEF = DarkRP.createJob("Police Chief", {
    color = Color(45, 6, 255, 255),
    model = {"models/sru_sergeant/sru_sergeant.mdl"},
    description = [[Protect and serve. Can not base, raid or mug.]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_mp5", "door_ram"},
    command = "TEAM_POLICE_CHIEF",
    max = 1,
    salary = 6000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    chief = true,
    NeedToChangeFrom = TEAM_POLICE_OFFICER,
    ammo = {
        ["smg1"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(25)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"trusted", "member", "sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for members with over 2 hours.",
})
TEAM_MAYOR = DarkRP.createJob("Mayor", {
    color = Color(45, 6, 255, 255),
    model = {"models/player/breen.mdl"},
    description = [[Set the laws and protect your people. Can not base, raid or mug.]],
    weapons = {},
    command = "TEAM_MAYOR",
    max = 1,
    salary = 15000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    mayor = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    PlayerDeath = function(ply, weapon, killer)
        ply:teamBan()
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
        DarkRP.notifyAll(0, 4, "The mayor has died.")
    end
})
TEAM_SWAT = DarkRP.createJob("SWAT", {
    color = Color(45, 6, 255, 255),
    model = {"Models/CODMW2/CODMW2.mdl"},
    description = [[Use big guns and big words. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_mp5"},
    command = "TEAM_SWAT",
    max = 2,
    salary = 9000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["smg1"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_HEAVY = DarkRP.createJob("Swat Heavy", {
    color = Color(45, 6, 255, 255),
    model = {"models/mark2580/payday2/pd2_swat_heavy_zeal_player.mdl"},
    description = [[Use bigger guns and bigger words. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_ares_shrike"},
    command = "TEAM_SWAT_HEAVY",
    max = 1,
    salary = 10000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["ar2"] = 400
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_MARKSMAN = DarkRP.createJob("Swat Marksman", {
    color = Color(45, 6, 255, 255),
    model = {"Models/CODMW2/CODMW2M.mdl"},
    description = [[Use biggerer guns and biggerer words. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_intervention"},
    command = "TEAM_SWAT_MARKSMAN",
    max = 1,
    salary = 10000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["SniperRound"] = 40
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_MEDIC = DarkRP.createJob("Swat Medic", {
    color = Color(45, 6, 255, 255),
    model = {"models/payday2/units/medic_player.mdl"},
    description = [[Heal your team. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker", "med_kit", "m9k_mp5"},
    command = "TEAM_SWAT_MEDIC",
    max = 1,
    salary = 10000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Government",
    medic = true,
    ammo = {
        ["smg1"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_LEADER = DarkRP.createJob("Swat Leader", {
    color = Color(45, 6, 255, 255),
    model = {"Models/CODMW2/CODMW2HE.mdl"},
    description = [[Command your team. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_m416"},
    command = "TEAM_SWAT_LEADER",
    max = 1,
    salary = 10000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["ar2"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})

-- Illegal --

TEAM_HACKER = DarkRP.createJob("Hacker", {
    color = Color(255,255,163, 255),
    model = {"models/player/aiden_pearce.mdl"},
    description = [[Hack into bases using the keypad cracker. Can base, raid and mug.]],
    weapons = {"keypad_cracker","lockpick", "unarrest_stick", "pickpocket"},
    command = "TEAM_HACKER",
    max = 4,
    salary =750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_THIEF = DarkRP.createJob("Thief", {
    color = Color(255,255,163, 255),
    model = {"models/player/arctic.mdl"},
    description = [[Lockpick into bases. Can base, raid and mug.]],
    weapons = {"keypad_cracker","lockpick", "unarrest_stick", "pickpocket"},
    command = "TEAM_THIEF",
    max = 8,
    salary =750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_HITMAN = DarkRP.createJob("Hitman", {
    color = Color(255,255,163, 255),
    model = {"models/player/gman_high.mdl"},
    description = [[Take our your targets for a fee. Can base and raid.]],
    weapons = {"lockpick", "unarrest_stick", "m9k_usp"},
    command = "TEAM_HITMAN",
    max = 1,
    salary = 1250,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"trusted", "member", "sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for members with over 2 hours.",
})
TEAM_BLOOD = DarkRP.createJob("Blood", {
    color = Color(255,255,163, 255),
    model = {"models/player/bloodz/slow_3.mdl"},
    description = [[Gang member rival against crips. Can base, raid and mug.]],
    weapons = {"unarrest_stick"},
    command = "TEAM_BLOOD",
    max = 3,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_BLOOD_LEADER = DarkRP.createJob("Blood Leader", {
    color = Color(255,255,163, 255),
    model = {"models/player/bloodz/slow_1.mdl"},
    description = [[Gang member rival against crips. Can base, raid and mug.]],
    weapons = {"lockpick", "unarrest_stick"},
    command = "TEAM_BLOOD_LEADER",
    max = 1,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_CRIP = DarkRP.createJob("Crip", {
    color = Color(255,255,163, 255),
    model = {"models/player/cripz/slow_2.mdl"},
    description = [[Gang member rival against bloods. Can base, raid and mug.]],
    weapons = {"unarrest_stick"},
    command = "TEAM_CRIP",
    max = 3,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_CRIP_LEADER = DarkRP.createJob("Crip Leader", {
    color = Color(255,255,163, 255),
    model = {"models/player/cripz/slow_1.mdl"},
    description = [[Gang member rival against bloods. Can base, raid and mug.]],
    weapons = {"lockpick", "unarrest_stick"},
    command = "TEAM_CRIP_LEADER",
    max = 1,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_MAFIA_LEADER = DarkRP.createJob("Mafia Leader", {
    color = Color(255,255,163, 255),
    model = {"models/player/LaNoire_Detective.mdl"},
    description = [[Tax evading in chicago. Can base, raid and mug.]],
    weapons = {"lockpick", "unarrest_stick"},
    command = "TEAM_MAFIA_LEADER",
    max = 1,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_MAFIA = DarkRP.createJob("Mafia", {
    color = Color(255,255,163, 255),
    model = {"models/player/LaNoire_Gray_Detective.mdl"},
    description = [[Tax evading in chicago. Can base, raid and mug.]],
    weapons = {"unarrest_stick"},
    command = "TEAM_MAFIA",
    max = 3,
    salary = 750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_BATTLE_MEDIC = DarkRP.createJob("Battle Medic", {
    color = Color(255,255,163, 255),
    model = {"models/player/plague_doktor/PLAYER_Plague_Doktor.mdl"},
    description = [[Heal up your comrades in a brawl. Can base and raid.]],
    weapons = {"med_kit"},
    command = "TEAM_BATTLE_MEDIC",
    max = 2,
    salary = 1000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_PRO_THIEF = DarkRP.createJob("Pro Thief", {
    color = Color(255,255,163, 255),
    model = {"models/player/pd2_hoxton_p.mdl"},
    description = [[Raid houses at rapid speed. Can base, raid and mug. Donator ONLY]],
    weapons = {"prokeypadcracker", "pickpocket","pro_lockpick"},
    command = "TEAM_PRO_THIEF",
    max = 4,
    salary = 1000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_PRO_HACKER = DarkRP.createJob("Pro Hacker", {
    color = Color(255,255,163, 255),
    model = {"models/player/anonymous_hacktivist.mdl"},
    description = [[Get into fading doors at rapid speed. Can base, raid and mug. Donator ONLY]],
    weapons = {"prokeypadcracker", "pickpocket","pro_lockpick"},
    command = "TEAM_PRO_HACKER",
    max = 4,
    salary = 1000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_TERRORIST = DarkRP.createJob("Terrorist", {
    color = Color(255,255,163, 255),
    model = {"models/player/kuma/taliban_rpg.mdl"},
    description = [[Can blow up an entire city, but only once. May only advert terror once every hour. Donator ONLY. CAN NOT TERROR INSIDE OF CASINO]],
    weapons = {"m9k_ak47"},
    command = "TEAM_TERRORIST",
    max = 1,
    salary = 1000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    PlayerDeath = function(ply, weapon, killer)
        ply:teamBan()
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
        DarkRP.notifyAll(0, 4, "The terrorist has died.")
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_KIDNAPPER = DarkRP.createJob("Kidnapper", {
    color = Color(255,255,163, 255),
    model = {"models/csgo/tr/professional/professional_varient_i.mdl"},
    description = [[Can kidnap anyone. May only advert kidnap once every 15 minutes. Donator ONLY]],
    weapons = {"weapon_leash_elastic"},
    command = "TEAM_KIDNAPPER",
    max = 1,
    salary = 1000,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_ASSASSIN = DarkRP.createJob("Assassin", {
    color = Color(255,255,163, 255),
    model = {"models/player/agent_47.mdl"},
    description = [[Most dangerous person in any room. Can base and raid. Donator ONLY]],
    weapons = {"m9k_intervention", "pro_lockpick"},
    command = "TEAM_ASSASSIN",
    max = 1,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    ammo = {
        ["SniperRound"] = 100
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "ayssie", "melbourne", "brisbane", "perth", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})

-- Manufacturing --

TEAM_BITCOIN_MINER = DarkRP.createJob("Bitcoin Miner", {
    color = Color(255,0,0, 255),
    model = {"models/obese_male.mdl"},
    description = [[Mine bitcoins before it was cool. Can base.]],
    weapons = {},
    command = "TEAM_BITCOIN_MINER",
    max = 4,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_MONEY_PRINTER = DarkRP.createJob("Money Printer", {
    color = Color(255,0,96, 255),
    model = {"models/player/hostage/hostage_01.mdl"},
    description = [[Make fake money. Can base.]],
    weapons = {},
    command = "TEAM_MONEY_PRINTER",
    max = 4,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_WEED_DEALER = DarkRP.createJob("Weed Grower", {
    color = Color(255,0,160, 255),
    model = {"models/snoopdogg.mdl"},
    description = [[Sell some green at bankstown station. Can base.]],
    weapons = {"zwf_cable","zwf_shoptablet","zwf_wateringcan"},
    command = "TEAM_WEED_DEALER",
    max = 4,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_METH_DEALER = DarkRP.createJob("Meth Cook", {
    color = Color(255,0,32, 255),
    model = {"models/Agent_47/agent_47.mdl"},
    description = [[Become a bankstown local. Can base.]],
    weapons = {"zmlab_extractor"},
    command = "TEAM_METH_DEALER",
    max = 4,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})

-- Homeless --

TEAM_MUTANT = DarkRP.createJob("Mutant", {
    color = Color(112, 112, 112, 255),
    model = {"models/player/charple.mdl"},
    description = [[Live in the sewers and shit yourself. KOS Outside the sewers.]],
    weapons = {"weapon_crowbar", "weapon_bugbait"},
    command = "TEAM_MUTANT",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Homeless",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetRunSpeed(340)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end
})
TEAM_HOBO = DarkRP.createJob("Hobo", {
    color = Color(112, 112, 112, 255),
    model = {"models/player/scavenger/scavenger.mdl"},
    description = [[Live on the streets of centerlink. Allowed to build anywhere.]],
    weapons = {"weapon_bugbait"},
    command = "TEAM_HOBO",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Homeless",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(100)
    end
})
TEAM_MUTANT_KING = DarkRP.createJob("Mutant King", {
    color = Color(112, 112, 112, 255),
    model = {"models/player/charple.mdl"},
    description = [[Live in the sewers and shit yourself. KOS Outside the sewers.]],
    weapons = {"weapon_crowbar", "weapon_bugbait"},
    command = "TEAM_MUTANT_KING",
    max = 1,
    salary = 1,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Homeless",
    NeedToChangeFrom = TEAM_MUTANT,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
        ply:SetRunSpeed(340)
    end
})




TEAM_STAFF_ON_DUTY = DarkRP.createJob("Staff On Duty", {
    color = Color(255, 255, 255, 255),
    model = {"models/player/combine_super_soldier.mdl"},
    description = [[Staff only.]],
    weapons = {"arrest_stick", "stungun", "door_ram", "unarrest_stick", "stunstick", "weaponchecker", "weapon_keypadchecker", "staff_lockpick", "gas_log_scanner", "itemstore_checker"},
    command = "TEAM_STAFF_ON_DUTY",
    max = 0,
    salary = 45000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Staff",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(1500)
        ply:SetHealth(1500)
        ply:SetArmor(1500)
    end,
    customCheck = function(ply) return
        table.HasValue({"superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Staff only.",
})

TEAM_OIL_REFINER = DarkRP.createJob("Oil Refiner", {
    color = Color(255,0,128, 255),
    model = {"models/hazmat/bmhaztechs.mdl"},
    description = [[You are making Petrol!]],
    weapons = {},
    command = "TEAM_OIL_REFINER",
    max = 4,
    salary = 5500,
    admin = 0,
    vote = false,
    category = "Manufacturing",
    hasLicense = false
})

TEAM_FRUIT_SLICER = DarkRP.createJob("Fruit Slicer", {
	color = Color(74, 255, 69, 255),
	model = {"models/fortnite/female/dj_bop.mdl"},
	description = [[You sell Smoothies!]],
	weapons = {"zfs_knife"},
	command = "TEAM_FRUIT_SLICER",
	max = 2,
	salary = 5000,
	admin = 0,
	vote = false,
	category = "Citizens",
	hasLicense = false
})

TEAM_MINER = DarkRP.createJob("Miner", {
	color = Color(255,0,64, 255),
	model = {"models/player/blockdude.mdl"},
	description = [[Find Diamonds]],
	weapons = {"zrms_pickaxe","zrms_builder"},
	command = "TEAM_MINER",
	max = 4,
	salary = 1500,
	admin = 0,
	vote = false,
	category = "Manufacturing",
	hasLicense = false
})

TEAM_CHELL = DarkRP.createJob("Papa Yoda", {
    color = Color(106,95,255, 255),
    model = {"models/player/b4p/b4p_yoda.mdl"},
    description = [[As you know it is a very bright summer day today and we will be celebrating it with this class.
This class is a fine class, the finest class you will soon to understand why it is a fine class.
Come step into my office, I will show you more.
This job comes with ability to raid, mug and base with anyone on the server.
If you like Al Shebab, then you will most likely love Kebabs. | Thief]],
    weapons = {"climb_swep2", "m9k_browningauto5", "prokeypadcracker", "pickpocket", "pro_lockpick"},
    command = "TEAM_CHELL",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:1:53337546", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Joey only.",
})
TEAM_MERCENARY = DarkRP.createJob("Mercenary", {
    color = Color(106,95,255, 255),
    model = {"models/kerry/killa_suka_blat/killa_blat.mdl"},
    description = [[One bad motherfucker, Never failed a hit. | Hitman]],
    weapons = {"m9k_m249lmg", "climb_swep2", "pro_lockpick"},
    command = "TEAM_MERCENARY",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:1:197708528"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Kaotic only.",
})
TEAM_SONIC = DarkRP.createJob("Sonic", {
    color = Color(106,95,255, 255),
    model = {"models/kaesar/moviesonic/moviesonic.mdl"},
    description = [[It Sonic, enough said. Can do everything. | Thief]],
    weapons = {"m9k_dragunov", "pro_lockpick", "unarrest_stick", "prokeypadcracker", "pickpocket", "invisibility_cloak"},
    command = "TEAM_SONIC",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:86866846", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jim only.",
})
TEAM_SOWAKA = DarkRP.createJob("Noot-Noot", {
    color = Color(106,95,255, 255),
    model = {"models/pacagma/houkai_impact_3rd/gyakushinn_miko/gyakushinn_miko_player.mdl"},
    description = [[Just your average healslut | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_m98b", "med_kit", "m9k_l85", "weapon_armorkit"},
    command = "TEAM_SOWAKA",
    max = 1,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:55954273", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Gwacko only.",
})
TEAM_KERMIT = DarkRP.createJob("Dr Shadow", {
    color = Color(106,95,255, 255),
    model = {"models/shadow_ssb4.mdl"},
    description = [[Ill help ya anytime ;) | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_m3", "weapon_armorkit"},
    command = "TEAM_KERMIT",
    max = 1,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:579690494"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jaspereeno only.",
})
TEAM_2B = DarkRP.createJob("2B", {
    color = Color(106,95,255, 255),
    model = {"models/kuma96/2b/2b_pm.mdl"},
    description = [[For the Glory of Mankind | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_dragunov", "climb_swep2"},
    command = "TEAM_2B",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:68387277"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jay Z only.",
})
TEAM_PICKLE_RICK = DarkRP.createJob("Pickle Rick", {
    color = Color(106,95,255, 255),
    model = {"models/oldbill/Weird_Pickle.mdl"},
    description = [[Come down my ends you'll get sheffed up you hear me | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "invisibility_cloak", "m9k_browningauto5"},
    command = "TEAM_PICKLE_RICK",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:579690494", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jaspereeno only.",
})
TEAM_RAT_KING = DarkRP.createJob("Ark Knight", {
    color = Color(106,95,255, 255),
    model = {"models/Platinum/Arknights/rstar/Platinum/Platinum.mdl"},
    description = [[the night is coming | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "invisibility_cloak", "m9k_honeybadger"},
    command = "TEAM_RAT_KING",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:492844137", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Widepeeked only.",
})
TEAM_FELIX_ARGYLE = DarkRP.createJob("Felix Argyle", {
    color = Color(106,95,255, 255),
    model = {"models/player/shi/Felix_Argyle.mdl"},
    description = [["Don't be Tricked by this cute neko girl since there is a trap under it's skirts | Thief/Miner"]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_scar", "climb_swep2","zrms_pickaxe","zrms_builder"},
    command = "TEAM_FELIX_ARGYLE",
    max = 1,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:25949007"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Dog only.",
})
TEAM_HITLER = DarkRP.createJob("Hitler", {
    color = Color(106,95,255, 255),
    model = {"models/minson97/hitler/hitler.mdl"},
    description = [[Jew mad bro? | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_fg42", "sieghail"},
    command = "TEAM_HITLER",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:1:33953368"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Majoron only.",
})
TEAM_MARCUS = DarkRP.createJob("Marcus", {
    color = Color(106,95,255, 255),
    model = {"models/characters/gallaha.mdl"},
    description = [[This job is only for the best, most skilled player. | Thief]],
    weapons = {"m9k_dragunov", "prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "weapon_cigarette_camel"},
    command = "TEAM_MARCUS",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:186632053", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Johhny only.",
})
TEAM_1337_COUNTER = DarkRP.createJob("1337 Counter", {
    color = Color(106,95,255, 255),
    model = {"models/jessev92/player/military/cod4_sniper.mdl"},
    description = [[1337 counter lua | Thief]],
    weapons = {"m9k_m98b", "climb_swep2", "pickpocket", "prokeypadcracker", "pickpocket", "pro_lockpick"},
    command = "TEAM_1337_COUNTER",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:1:107335883", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Moa only.",
})
TEAM_PICOLAS_CAGE = DarkRP.createJob("Picolas Cage", {
    color = Color(106,95,255, 255),
    model = {"models/aap15/foldername/Picolas_Cage_pm/picolas_cage_reference.mdl"},
    description = [[I'm a pickle but better than Rick | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_browningauto5", "weapon_idubbbz"},
    command = "TEAM_PICOLAS_CAGE",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:98102011", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Moist_Sausage only.",
})
TEAM_JOHN_WICK = DarkRP.createJob("John Wick", {
    color = Color(106,95,255, 255),
    model = {"models/player/korka007/wick.mdl"},
    description = [[The man with a dog | Hitman]],
    weapons = {"m9k_m98b", "w_hammer", "pro_lockpick"},
    command = "TEAM_JOHN_WICK",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:123344808", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jordan only.",
})
TEAM_DECEPTICON = DarkRP.createJob("Decepticon", {
    color = Color(106,95,255, 255),
    model = {"models/devastation/kingblueyoshi/soundwave_pm.mdl"},
    description = [[Decepticon | Hitman]],
    weapons = {"m9k_scar", "climb_swep2", "pro_lockpick"},
    command = "TEAM_DECEPTICON",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:174848051", "STEAM_0:0:103364981", "STEAM_0:1:53337546"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for SOUNDWAVE only.",
})
TEAM_DRIP = DarkRP.createJob("Drip", {
    color = Color(106,95,255, 255),
    model = {"models/player/Taiga_Aisaka.mdl"},
    description = [[im back on my drip | Thief]],
    weapons = {"m9k_honeybadger", "invisibility_cloak", "prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick"},
    command = "TEAM_DRIP",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981","STEAM_0:0:437291733"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for binchicken only.",
})
TEAM_KOMMISSAR = DarkRP.createJob("Kommissar", {
    color = Color(106,95,255, 255),
    model = {"models/cakez/wolfenstein/blackguard_p.mdl"},
    description = [[A good soldier follows orders. | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "climb_swep2", "m9k_an94"},
    command = "TEAM_KOMMISSAR",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:1:32893562"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Rick Castle only.",
})
TEAM_KEN_KANEKI = DarkRP.createJob("Deadsnot", {
    color = Color(0,0,0, 255),
    model = {"models/kryptonite/inj2_ios_deadshot/inj2_ios_deadshot.mdl"},
    description = [[Just your friendly neighborhood vigilante *sniff* | Government]],
    weapons = {"weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick", "weaponchecker", "weapon_armorkit", "m9k_m98b", "med_kit"},
    command = "TEAM_KEN_KANEKI",
    max = 1,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:55954273", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Gwacko only.",
})
TEAM_AUTOBOT = DarkRP.createJob("AUTOBOT", {
    color = Color(106,95,255, 255),
    model = {"models/cybertronautobot/g2_optimus.mdl"},
    description = [[AUTOBOT | Government]],
    weapons = {"m9k_m16a4_acog", "weapon_cuff_police", "arrest_stick", "vc_spikestrip_wep", "stungun", "door_ram", "unarrest_stick", "stunstick", "weaponchecker", "climb_swep2"},
    command = "TEAM_AUTOBOT",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:174848051"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for SOUNDWAVE only.",
})
TEAM_CONNOR_KENWAY = DarkRP.createJob("Connor Kenway", {
    color = Color(106,95,255, 255),
    model = {"models/nikout/AC3/Connor_playermodel.mdl"},
    description = [[We work in the dark, to serve the light. | Hitman]],
    weapons = {"m9k_dragunov", "weapon_thehiddenblade", "pro_lockpick"},
    command = "TEAM_CONNOR_KENWAY",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:68387277"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jay Z only.",
})
TEAM_SADDAM_HUSSEIN = DarkRP.createJob("Saddam Hussein", {
    color = Color(106,95,255, 255),
    model = {"models/jessev92/player/misc/saddam.mdl"},
    description = [[The ultimate weapons dealer, he has everything and anything, just ask. | Doubles as a Thief/Gun Dealer]],
    weapons = {"m9k_dragunov", "prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "med_kit"},
    command = "TEAM_SADDAM_HUSSEIN",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:86866846"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jim only.",
})
TEAM_SPECIALIST_THIEF = DarkRP.createJob("Specialist Thief", {
    color = Color(106,95,255, 255),
    model = {"models/kuma96/gta5_specops/gta5_specops_pm.mdl"},
    description = [[Raiding and mug these hoes | Thief]],
    weapons = {"prokeypadcracker", "pickpocket", "pro_lockpick", "unarrest_stick", "m9k_m249lmg", "weapon_armorkit"},
    command = "TEAM_SPECIALIST_THIEF",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:123344808"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Jordan only.",
})
TEAM_SOLAIRE_ASTORA = DarkRP.createJob("Solaire Astora", {
    color = Color(106,95,255, 255),
    model = {"models/player_solaire.mdl"},
    description = [[Praise the Sun &amp; fuck bitches | Thief]],
    weapons = {"m9k_scar", "climb_swep2", "pro_lockpick", "unarrest_stick", "prokeypadcracker", "pickpocket"},
    command = "TEAM_SOLAIRE_ASTORA",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:1:74022863"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Adrenaline only.",
})
TEAM_LOCUS = DarkRP.createJob("LOCUS", {
    color = Color(25,68,25, 255),
    model = {"models/redvsblue/halo/locus_pm.mdl"},
    description = [[Hitman/Thief]],
    weapons = {"climb_swep2", "pro_lockpick", "unarrest_stick", "prokeypadcracker", "pickpocket", "m9k_m98b", "m9k_m3", "invisibility_cloak"},
    command = "TEAM_LOCUS",
    max = 2,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:174848051", "STEAM_0:1:53337546"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for SOUNDWAVE &amp; Joey only.",
})
TEAM_DUTCH_COOK = DarkRP.createJob("Dutch Cook", {
    color = Color(106,95,255, 255),
    model = {"models/postal3/Dude.mdl"},
    description = [[He only speaks dutch | Meth Cook]],
    weapons = {"weapon_cigarette_camel", "m9k_deagle", "zmlab_extractor"},
    command = "TEAM_DUTCH_COOK",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:1:45141952", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Don only.",
})
TEAM_DEATHSTROKE = DarkRP.createJob("Deathstroke", {
    color = Color(106,95,255, 255),
    model = {"models/norpo/ArkhamOrigins/Assassins/Deathstroke_ValveBiped.mdl"},
    description = [[can raid mug and base | Thief]],
    weapons = {"pro_lockpick", "unarrest_stick", "prokeypadcracker", "pickpocket", "invisibility_cloak", "m9k_an94"},
    command = "TEAM_DEATHSTROKE",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:0:117246347"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Mike Pence only.",
})
TEAM_TIME_TRAVELLER = DarkRP.createJob("Time Traveller", {
    color = Color(106,95,255, 255),
    model = {"models/player/assasinge/db.mdl"},
    description = [[A time traveller that went back in time to mine Bitcoin after finding out it booms in price. He has brought an old gun back from the future to protect himself from anyone who might find out he travels time, and a invisibility module to walk around un-noticed. | Bitcoin Miner]],
    weapons = {"invisibility_cloak", "m9k_winchester73"},
    command = "TEAM_TIME_TRAVELLER",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:1:32981097", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for UE only.",
})

TEAM_THE_ROCK = DarkRP.createJob("The Rock", {
    color = Color(106,95,255, 255),
    model = {"models/models/konnie/rock/therock.mdl"},
    description = [[Fight Club Manager]],
    weapons = {"m9k_g36"},
    command = "TEAM_THE_ROCK",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:55650188", "STEAM_0:0:103364981"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Lemonetoe only.",
})
TEAM_CLAY_FACE = DarkRP.createJob("Clay Face", {
    color = Color(106,95,255, 255),
    model = {"models/player/bobert/ACClayface.mdl"},
    description = [[BIG FUCKY WUCK BOI]],
    weapons = {"pro_lockpick", "invisibility_cloak", "m9k_m98b"},
    command = "TEAM_CLAY_FACE",
    max = 1,
    salary = 8000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Donator Classes",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:0:103364981", "STEAM_0:1:463427717"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This job is for Tyler49765 only.",
})

GAMEMODE.DefaultTeam = TEAM_CITIZEN

GAMEMODE.CivilProtection = {
    [TEAM_POLICE_OFFICER] = true,
    [TEAM_POLICE_CHIEF] = true,
    [TEAM_MAYOR] = true,
    [TEAM_SWAT] = true,
    [TEAM_SWAT_HEAVY] = true,
    [TEAM_SWAT_MARKSMAN] = true,
    [TEAM_SWAT_MEDIC] = true,
    [TEAM_SWAT_LEADER] = true,
    [TEAM_AUTOBOT] = true,
}