CH_BankVault = CH_BankVault or {}
CH_BankVault.Config = CH_BankVault.Config or {}
CH_BankVault.Content = CH_BankVault.Content or {}
CH_BankVault.Design = CH_BankVault.Design or {}
CH_BankVault.CurrentRobbers = CH_BankVault.CurrentRobbers or { "NONE" }

-- General config options.
CH_BankVault.Config.StartMoney = 175000 -- Amount of money the bank will have from server startup. [Default = 1500]
CH_BankVault.Config.MoneyTimer = 60 -- This is the time that defines when money is added to the bank. In seconds! [Default = 60]
CH_BankVault.Config.MoneyOnTime = 1000 -- This is the amount of money to be added to the bank every x minutes/seconds. Defined by the setting above. [Default = 1000]
CH_BankVault.Config.Max = 175000 -- The maximum the bank can have. Set to 0 for no limit. [Default = 30000]

CH_BankVault.Config.AliveTime = 60 -- The amount of SECONDS the player must stay alive before he will receive what the bank has. [Default = 60 seconds]
-- If you own the transport dlc this is also the time the robbers needs to complete the heist/transport of the money in. If not, the mission will fail.

CH_BankVault.Config.CooldownTime = 900 -- The amount of SECONDS the bank is on a cooldown after a robbery! [Default = 600 (10 min)]
CH_BankVault.Config.PlayerLimit = 6 -- The amount of players there must be on the server before you can rob the bank. [Default = 5]
CH_BankVault.Config.PoliceRequired = 3 -- The amount of police officers there must be before a person can rob the bank. [Default = 3]

CH_BankVault.Config.RobberyDistance = 300000 -- The amount of space the player can move away from the armory entity, before the robbery fails. [Default = 300000]
CH_BankVault.Config.DropMoneyOnSucces = false -- Should money drop from the bank when a robbery is successful? true/false option. [Default = false]

CH_BankVault.Config.KillReward = 12500 -- The amount of money a person is rewarded for killing the bank robber. [Default = 1750]
CH_BankVault.Config.RobbersCanJoin = 15 -- Amount of seconds before robbers are no longer able to join a robbery after it has first been started. [Default = 120 (2 minutes)]

-- Alarm Sound Configs
CH_BankVault.Config.EmitSoundOnRob = true -- Should an alarm go off when the bank vault gets robbed. [Default = true]
CH_BankVault.Config.TheSound = "ambient/alarms/alarm_citizen_loop1.wav" -- The sound to be played. [Default = ambient/alarms/alarm1.wav - default gmod sound]
CH_BankVault.Config.SoundVolume = 100 -- The sound volume for the alarm sound. [Default = 100] -- AVAILABLE VALUES https://wiki.facepunch.com/gmod/Enums/SNDLVL
CH_BankVault.Config.SoundDuration = 20 -- Amount of seconds the sound should play for. [Default = 20]

-- Model Requirementsa
CH_BankVault.Config.UseRequiredModels = false -- Should the robber be a specific model to be able to rob the bank? Uses the models from the table below. [Default = false]

CH_BankVault.Config.RequiredModels = { -- These are the models required to rob the bank. These only come in use if the option above (CH_BankVault.Config.UseRequiredModels) is enabled.  
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/Male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl" -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}

-- Team Configuration
CH_BankVault.Config.RequiredTeams = {
	"Police Officer",
	"Police Chief",
	"SWAT",
	"Swat Heavy",
	"Swat Leader",
	"Swat Medic",
	"Swat Marksman",
	"Deadsnot",
	"AUTOBOT",
	"Mayor"
}

CH_BankVault.Config.GovernmentTeams = {
	"Police Officer",
	"Police Chief",
	"SWAT",
	"Swat Heavy",
	"Swat Leader",
	"Swat Medic",
	"Swat Marksman",
	"Deadsnot",
	"AUTOBOT",
	"Mayor"
}

CH_BankVault.Config.AllowedTeams = {
	"Thief",
	"Dr Shadow",
	"1337 Counter",
	"Picolas Cage",
	"LOCUS",
	"Kommissar",
	"Lester Crest",
	"Drip",
	"Deathstroke",
	"Solaire Astora",
	"Marcus",
	"Hitler",
	"Felix Argyle",
	"Ark Knight",
	"Papa Yoda",
	"Sonic",
	"2B",
	"Specialist Thief",
	"Saddam Hussein",
	"Pickle Rick",
	"Noot-Noot",
	"Pro Thief",
	"Pro Hacker",
	"Battle Medic",
	"Blood",
	"Blood Leader",
	"Crip",
	"Crip Leader",
	"Mafia",
	"Mafia Leader",
	"Hacker"
}

-- Vrondakis XP Support
CH_BankVault.Config.VrondakisXPEnable = false -- Enable xp reward for https://github.com/vrondakis/Leveling-System
CH_BankVault.Config.VrondakisXPAmount = 1500 -- Amount of XP given to each robber after a succesful robbery.