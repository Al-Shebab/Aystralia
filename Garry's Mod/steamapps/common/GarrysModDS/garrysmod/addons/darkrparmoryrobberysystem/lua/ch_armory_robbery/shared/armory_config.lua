CH_ArmoryRobbery = CH_ArmoryRobbery or {}
CH_ArmoryRobbery.Config = CH_ArmoryRobbery.Config or {}
CH_ArmoryRobbery.Weapons = CH_ArmoryRobbery.Weapons or {}
CH_ArmoryRobbery.Design = CH_ArmoryRobbery.Design or {}

-- Section one. Handles money in the armory.
CH_ArmoryRobbery.Config.MoneyTimer = 600 -- This is the time that defines when money is added to the armory. In seconds! [Default = 60 (1 Minute)]
CH_ArmoryRobbery.Config.MoneyOnTime = 0 -- This is the amount of money to be added to the armory every x minutes/seconds. Defined by the setting above. [Default = 2500]
CH_ArmoryRobbery.Config.MaxMoney = 0 -- The maximum amount of money the armory can have. Set to 0 for no limit. [Default = 50000]

-- Section two. Handles the ammonition part.
CH_ArmoryRobbery.Config.AmmoTimer = 240 -- This is the time that defines when ammo is added to the armory. In seconds! [Default = 240 (4 Minutes)]
CH_ArmoryRobbery.Config.AmmoOnTime = 0 -- This is the amount of ammo to be added to the armory every x minutes/seconds. Defined by the setting above. [Default = 5]
CH_ArmoryRobbery.Config.MaxAmmo = 0 -- The maximum amount of ammo the armory can have. Set to 0 for no limit. [Default = 100]

-- Section tree. Handles the shitment part.
CH_ArmoryRobbery.Config.ShipmentsTimer = 360 -- This is the time that defines when shipments are added to the armory. In seconds! [Default = 360 (6 Minutes)]
CH_ArmoryRobbery.Config.ShipmentsOnTime = 0 -- This is the amount of shipments to be added to the armory every x minutes/seconds. Defined by the setting above. [Default = 1]
CH_ArmoryRobbery.Config.MaxShipments = 0 -- The maximum amount of shipments the armory can have. Set to 0 for no limit. [Default = 5]
CH_ArmoryRobbery.Config.ShipmentsAmount = 10 -- Amount of weapons inside of one shipment. [Default = 10]

-- General settings.
CH_ArmoryRobbery.Config.AliveTime = 2 -- The amount of MINUTES the player must stay alive before he will receive what the armory has. IN MINUTES! [Default = 5]
CH_ArmoryRobbery.Config.CooldownTime = 15 -- The amount of MINUTES the armory is on a cooldown after a robbery! (Doesn't matter if the robbery failed or not) [Default = 20]
CH_ArmoryRobbery.Config.RobberyDistance = 700 -- The amount of space the player can move away from the armory entity, before the robbery fails. [Default = 500]
CH_ArmoryRobbery.Config.PlayerLimit = 6 -- The amount of players there must be on the server before you can rob the armory. [Default = 5]
CH_ArmoryRobbery.Config.KillReward = 150000 -- The amount of money a person is rewarded for killing the armory robber. [Default = 2500]
CH_ArmoryRobbery.Config.PoliceRequired = 2 -- The amount of police officers there must be before a person can rob the armory. [Default = 3]

CH_ArmoryRobbery.Config.RequiredTeams = { -- These are the names of the jobs that counts with the option above, the police required. The amount of players on these teams are calculated together in the count.
	"Police Officer",
	"Police Chief",
	"SWAT",
	"Swat Heavy",
	"Swat Leader",
	"Undercover Cop",
	"Swat Medic",
	"Swat Marksman"
}

CH_ArmoryRobbery.Config.GovernmentTeams = { -- These are the names of the jobs that counts with the option above, the police required. The amount of players on these teams are calculated together in the count.
	"Police Officer",
	"Police Chief",
	"SWAT",
	"Swat Heavy",
	"Swat Leader",
	"Undercover Cop",
	"Swat Medic",
	"Swat Marksman",
	"Mayor"
}

CH_ArmoryRobbery.Config.AllowedTeams = {}

-- Weapon armory configuration.
CH_ArmoryRobbery.Weapons.Weapon1Name = "HK MP7"
CH_ArmoryRobbery.Weapons.Weapon1WepName = "m9k_mp7"
CH_ArmoryRobbery.Weapons.Weapon1AmmoType = "m9k_ammo_smg"
CH_ArmoryRobbery.Weapons.Weapon1AmmoAmount = 300
CH_ArmoryRobbery.Weapons.Weapon1Model = "models/weapons/w_mp7_silenced.mdl"

CH_ArmoryRobbery.Weapons.Weapon2Name = "MP9"
CH_ArmoryRobbery.Weapons.Weapon2WepName = "m9k_mp9"
CH_ArmoryRobbery.Weapons.Weapon2AmmoType = "m9k_ammo_smg"
CH_ArmoryRobbery.Weapons.Weapon2AmmoAmount = 300
CH_ArmoryRobbery.Weapons.Weapon2Model = "models/weapons/w_brugger_thomet_mp9.mdl"

CH_ArmoryRobbery.Weapons.Weapon3Name = "Honeybadger"
CH_ArmoryRobbery.Weapons.Weapon3WepName = "m9k_honeybadger"
CH_ArmoryRobbery.Weapons.Weapon3AmmoType = "m9k_ammo_smg"
CH_ArmoryRobbery.Weapons.Weapon3AmmoAmount = 300
CH_ArmoryRobbery.Weapons.Weapon3Model = "models/weapons/w_aac_honeybadger.mdl"

CH_ArmoryRobbery.Weapons.Cooldown = 5 -- Amount of minutes between being able to retrieve a weapon from the police armory as a government official. [Default = 5]
CH_ArmoryRobbery.Weapons.ArmorAmount = 50 -- How much armor should the police jobs get when they press E on the armory. [Default = 100]
CH_ArmoryRobbery.Weapons.Enabled = true -- Should the weapon armory for police jobs be enabled or not? true/false option. [Default = true]