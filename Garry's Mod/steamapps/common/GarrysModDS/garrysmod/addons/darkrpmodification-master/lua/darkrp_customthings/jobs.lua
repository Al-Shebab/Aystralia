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

TEAM_BANK_MANAGER = DarkRP.createJob("Bank Manager", {
    color = Color(74, 255, 69, 255),
    model = {"models/player/magnusson.mdl"},
    description = [[Manages finances and pawns items to other for a fee. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_BANK_MANAGER",
    max = 1,
    salary = 5000,
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
    max = 2,
    salary =750,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})
TEAM_GRAFFITI_ARTIST = DarkRP.createJob("Graffiti Artist", {
    color = Color(74, 255, 69, 255),
    model = {"models/watch_dogs/characters/mgs5_big_boss_trenchcoat.mdl"},
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
    max = 2,
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
    description = [[Ask dogs for money at bankstown station.  Can not raid/mug.]],
    weapons = {"weapon_cigarette_camel","zwf_bong03"},
    command = "TEAM_ESHAY",
    max = 4,
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

-- Services --

TEAM_SECURITY_GUARD = DarkRP.createJob("Security Guard", {
    color = Color(80, 221, 204, 255),
    model = {"models/player/odessa.mdl"},
    description = [[Hired security for any business or person. Can not raid/mug.]],
    weapons = {"weapon_cigarette_camel","m9k_m92beretta"},
    command = "TEAM_SECURITY_GUARD",
    max = 2,
    salary = 650,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Services"
})
TEAM_DOCTER = DarkRP.createJob("Doctor", {
    color = Color(80, 221, 204, 255),
    model = {"models/player/Group03m/male_01.mdl"},
    description = [[Paid good money to help out others in need. Can not raid/mug. Can not use weapons.]],
    weapons = {"weapon_medkit"},
    command = "TEAM_DOCTER",
    max = 1,
    salary = 2000,
    admin = 0,
    vote = false,
    medic = true,
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
    medic = true,
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
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Dealers",
})
TEAM_BLACK_MARKET_DEALER = DarkRP.createJob("Black Market Dealer", {
    color = Color(37, 110, 201, 255),
    model = {"models/player/gru.mdl"},
    description = [[Deliver large arms and explosives to the city. Can not raid/mug. Donator ONLY]],
    weapons = {},
    command = "TEAM_BLACK_MARKET_DEALER",
    max = 2,
    salary = 1500,
    admin = 0,
    vote = false,
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
    end
})
TEAM_DRUG_DEALER = DarkRP.createJob("Drug Dealer", {
    color = Color(37, 110, 201, 255),
    model = {"models/GrandTheftAuto5/Trevor.mdl"},
    description = [[Sell prescription drugs to those in need. Can not raid/mug.]],
    weapons = {},
    command = "TEAM_DRUG_DEALER",
    max = 2,
    salary = 1750,
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
    weapons = {"m9k_usp", "weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker"},
    command = "TEAM_POLICE_OFFICER",
    max = 4,
    salary = 1000,
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
        ply:SetArmor(50)
    end
})
TEAM_POLICE_CHIEF = DarkRP.createJob("Police Chief", {
    color = Color(45, 6, 255, 255),
    model = {"models/sru_sergeant/sru_sergeant.mdl"},
    description = [[Protect and serve. Can not base, raid or mug.]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_mp5", "door_ram"},
    command = "TEAM_POLICE_CHIEF",
    max = 1,
    salary = 2000,
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
        ply:SetArmor(100)
    end
})
TEAM_MAYOR = DarkRP.createJob("Mayor", {
    color = Color(45, 6, 255, 255),
    model = {"models/player/breen.mdl"},
    description = [[Set the laws and protect your people. Can not base, raid or mug.]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_mp5"},
    command = "TEAM_MAYOR",
    max = 1,
    salary = 3000,
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
    description = [[Use big guns and big words. Can not base, raid or mug.]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_m416"},
    command = "TEAM_SWAT",
    max = 2,
    salary = 1500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["ar2"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_HEAVY = DarkRP.createJob("Swat Heavy", {
    color = Color(45, 6, 255, 255),
    model = {"models/mark2580/payday2/pd2_swat_heavy_zeal_player.mdl"},
    description = [[Use bigger guns and bigger words. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_ares_shrike"},
    command = "TEAM_SWAT_HEAVY",
    max = 1,
    salary = 2000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["ar2"] = 400
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_MARKSMAN = DarkRP.createJob("Swat Marksman", {
    color = Color(45, 6, 255, 255),
    model = {"Models/CODMW2/CODMW2M.mdl"},
    description = [[Use biggerer guns and biggerer words. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_intervention"},
    command = "TEAM_SWAT_MARKSMAN",
    max = 1,
    salary = 2000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["SniperRound"] = 40
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_MEDIC = DarkRP.createJob("Swat Medic", {
    color = Color(45, 6, 255, 255),
    model = {"models/payday2/units/medic_player.mdl"},
    description = [[Heal your team. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "med_kit", "m9k_m416"},
    command = "TEAM_SWAT_MEDIC",
    max = 1,
    salary = 2000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    medic = true,
    ammo = {
        ["ar2"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_SWAT_LEADER = DarkRP.createJob("Swat Leader", {
    color = Color(45, 6, 255, 255),
    model = {"Models/CODMW2/CODMW2HE.mdl"},
    description = [[Command your team. Can not base, raid or mug. Donator ONLY]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_m416"},
    command = "TEAM_SWAT_LEADER",
    max = 1,
    salary = 2500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government",
    ammo = {
        ["ar2"] = 120
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    customCheck = function(ply) return
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_UNDERCOVER_COP = DarkRP.createJob("Undercover Cop", {
    color = Color(45, 6, 255, 255),
    model = {"models/player/mossman_arctic.mdl"},
    description = [[Spy on brazil cartels from behind enemy lines. Can not base, raid or mug.]],
    weapons = {"weapon_cuff_police", "arrest_stick", "unarrest_stick", "stunstick" , "weaponchecker", "m9k_usp"},
    command = "TEAM_UNDERCOVER_COP",
    max = 2,
    salary = 1000,
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
        ply:SetArmor(100)
    end
})

-- Illegal --

TEAM_HACKER = DarkRP.createJob("Hacker", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/aiden_pearce.mdl"},
    description = [[Hack into bases using the keypad cracker. Can base, raid and mug.]],
    weapons = {"keypad_cracker"},
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
    end
})
TEAM_THIEF = DarkRP.createJob("Thief", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/arctic.mdl"},
    description = [[Lockpick into bases. Can base, raid and mug.]],
    weapons = {"lockpick"},
    command = "TEAM_THIEF",
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
    end
})
TEAM_HITMAN = DarkRP.createJob("Hitman", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/gman_high.mdl"},
    description = [[Take our your targets for a fee. Can base and raid.]],
    weapons = {"lockpick", "m9k_m24"},
    command = "TEAM_HITMAN",
    max = 1,
    salary = 1250,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Illegal",
    ammo = {
        ["SniperRound"] = 20
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
    end
})
TEAM_BLOOD = DarkRP.createJob("Blood", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/bloodz/slow_3.mdl"},
    description = [[Gang member rival against crips. Can base, raid and mug.]],
    weapons = {},
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
    end
})
TEAM_BLOOD_LEADER = DarkRP.createJob("Blood Leader", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/bloodz/slow_1.mdl"},
    description = [[Gang member rival against crips. Can base, raid and mug.]],
    weapons = {"lockpick"},
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
    end
})
TEAM_CRIP = DarkRP.createJob("Crip", {
    color = Color(0, 0, 255, 255),
    model = {"models/player/cripz/slow_2.mdl"},
    description = [[Gang member rival against bloods. Can base, raid and mug.]],
    weapons = {},
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
    end
})
TEAM_CRIP_LEADER = DarkRP.createJob("Crip Leader", {
    color = Color(0, 0, 255, 255),
    model = {"models/player/cripz/slow_1.mdl"},
    description = [[Gang member rival against bloods. Can base, raid and mug.]],
    weapons = {"lockpick"},
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
    end
})
TEAM_MAFIA_LEADER = DarkRP.createJob("Mafia Leader", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/LaNoire_Detective.mdl"},
    description = [[Tax evading in chicago. Can base, raid and mug.]],
    weapons = {"lockpick"},
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
    end
})
TEAM_MAFIA = DarkRP.createJob("Mafia", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/LaNoire_Gray_Detective.mdl"},
    description = [[Tax evading in chicago. Can base, raid and mug.]],
    weapons = {},
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
    end
})
TEAM_BATTLE_MEDIC = DarkRP.createJob("Battle Medic", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/plague_doktor/PLAYER_Plague_Doktor.mdl"},
    description = [[Heal up your comrades in a brawl. Can base, raid and mug.]],
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
    end
})
TEAM_PRO_THIEF = DarkRP.createJob("Pro Thief", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/pd2_hoxton_p.mdl"},
    description = [[Raid houses at rapid speed. Can base, raid and mug. Donator ONLY]],
    weapons = {"pro_lockpick"},
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
        ply:SetArmor(50)
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_TERRORIST = DarkRP.createJob("Terrorist", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/kuma/taliban_rpg.mdl"},
    description = [[Can blow up an entire city, but only once. May only advert terror once every 30 minutes. Donator ONLY]],
    weapons = {"m9k_suicide_bomb"},
    command = "TEAM_TERRORIST",
    max = 1,
    salary = 1000,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
    end,
    PlayerDeath = function(ply, weapon, killer)
        ply:teamBan()
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
        DarkRP.notifyAll(0, 4, "The terrorist has died.")
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_KIDNAPPER = DarkRP.createJob("Kidnapper", {
    color = Color(255, 0, 0, 255),
    model = {"models/csgo/tr/professional/professional_varient_i.mdl"},
    description = [[Can kidnap anyone. May only advert kidnap once every 15 minutes. Donator ONLY]],
    weapons = {"weapon_leash_elastic"},
    command = "TEAM_KIDNAPPER",
    max = 1,
    salary = 1000,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = false,
    category = "Illegal",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})
TEAM_ASSASSIN = DarkRP.createJob("Assassin", {
    color = Color(255, 0, 0, 255),
    model = {"models/player/agent_47.mdl"},
    description = [[Most dangerous person in any room. Can base and raid. Donator ONLY]],
    weapons = {"m9k_intervention", "pro_lockpick"},
    command = "TEAM_ASSASSIN",
    max = 1,
    salary = 2500,
    admin = 0,
    vote = true,
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
    end,
    customCheck = function(ply) return CLIENT or
        table.HasValue({"sydney", "melbourne", "brisbane", "adelaide", "superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "This job is for donators only.",
})

-- Manufacturing --

TEAM_BITCOIN_MINER = DarkRP.createJob("Bitcoin Miner", {
    color = Color(196, 115, 0, 255),
    model = {"models/obese_male.mdl"},
    description = [[Mine bitcoins before it was cool. Can base.]],
    weapons = {},
    command = "TEAM_BITCOIN_MINER",
    max = 3,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_MONEY_PRINTER = DarkRP.createJob("Money Printer", {
    color = Color(196, 115, 0, 255),
    model = {"models/player/hostage/hostage_01.mdl"},
    description = [[Make fake money. Can base.]],
    weapons = {},
    command = "TEAM_MONEY_PRINTER",
    max = 3,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_LEAN_MANUFACTURER = DarkRP.createJob("Lean Manufacturer", {
    color = Color(196, 115, 0, 255),
    model = {"models/player/anon/anon.mdl"},
    description = [[Get some chemist warehouse cough syrup and put it in a cup. Can base.]],
    weapons = {},
    command = "TEAM_LEAN_MANUFACTURER",
    max = 3,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_WEED_DEALER = DarkRP.createJob("Weed Grower", {
    color = Color(196, 115, 0, 255),
    model = {"models/snoopdogg.mdl"},
    description = [[Sell some green at bankstown station. Can base.]],
    weapons = {"zwf_cable","zwf_shoptablet","zwf_wateringcan"},
    command = "TEAM_WEED_DEALER",
    max = 3,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_LSD_DEALER = DarkRP.createJob("LSD Cook", {
    color = Color(196, 115, 0, 255),
    model = {"models/player/spacesuit.mdl"},
    description = [[Snap off some tabs and give them to the street kids. Can base.]],
    weapons = {"swep_lsd_cellphone"},
    command = "TEAM_LSD_DEALER",
    max = 3,
    salary = 2500,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Manufacturing"
})
TEAM_METH_DEALER = DarkRP.createJob("Meth Cook", {
    color = Color(196, 115, 0, 255),
    model = {"models/bloocobalt/splinter cell/chemsuit_cod.mdl"},
    description = [[Become a gosford local. Can base.]],
    weapons = {"zmlab_extractor"},
    command = "TEAM_METH_DEALER",
    max = 3,
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
    max = 5,
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
        ply:SetArmor(0)
    end
})




TEAM_STAFF_ON_DUTY = DarkRP.createJob("Staff On Duty", {
    color = Color(255, 255, 255, 255),
    model = {"models/player/combine_super_soldier.mdl"},
    description = [[Staff only.]],
    weapons = {"arrest_stick", "unarrest_stick", "stunstick", "weaponchecker", "weapon_keypadchecker", "staff_lockpick", "gas_log_scanner", "itemstore_checker"},
    command = "TEAM_STAFF_ON_DUTY",
    max = 0,
    salary = 15000,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Staff",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(500)
        ply:SetHealth(500)
        ply:SetArmor(500)
    end,
    customCheck = function(ply) return
        table.HasValue({"superadmin", "senior-admin", "staff-manager", "donator-admin", "donator-senior-moderator", "donator-moderator", "donator-trial-moderator", "admin", "senior-moderator", "moderator", "trial-moderator"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Staff only.",
})

TEAM_OIL_REFINER = DarkRP.createJob("Oil Refiner", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/Group03/male_03.mdl"},
    description = [[You are making Fuel!]],
    weapons = {},
    command = "TEAM_OIL_REFINER",
    max = 3,
    salary = 5500,
    admin = 0,
    vote = false,
    category = "Manufacturing",
    hasLicense = false
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
    [TEAM_UNDERCOVER_COP] = true,
}

DarkRP.addHitmanTeam(TEAM_HITMAN)
DarkRP.addHitmanTeam(TEAM_ASSASSIN)