BANK_CUSTOM_MoneyTimer = 60 -- This is the time that defines when money is added to the bank. In seconds! [Default = 60]
BANK_CUSTOM_MoneyOnTime = 10000 -- This is the amount of money to be added to the bank every x minutes/seconds. Defined by the setting above. [Default = 500]
BANK_Custom_Max = 1500000 -- The maximum the bank can have. Set to 0 for no limit. [Default = 30000]
BANK_Custom_AliveTime = 3 -- The amount of MINUTES the player must stay alive before he will receive what the bank has. IN MINUTES! [Default = 5]
BANK_Custom_CooldownTime = 15 -- The amount of MINUTES the bank is on a cooldown after a robbery! (Doesn't matter if the robbery failed or not) [Default = 20]
BANK_Custom_RobberyDistance = 500 -- The amount of space the player can move away from the bank entity, before the bank robbery fails. [Default = 500]
BANK_Custom_PlayerLimit = 6 -- The amount of players there must be on the server before you can rob the bank. [Default = 5]
BANK_Custom_KillReward = 100000 -- The amount of money a person is rewarded for killing the bank robber. [Default = 1000]
BANK_Custom_PoliceRequired = 3 -- The amount of police officers there must be before a person can rob the bank. [Default = 3] 
BANK_Custom_DropMoneyOnSucces = true -- Should money drop from the bank when a robbery is succesful? true/false option. [Default = false]

RequiredTeams = {
	"Police Officer",
	"Police Chief",
	"SWAT",
	"Swat Heavy",
	"Swat Leader",
	"Swat Medic",
	"Swat Marksman",
	"AUTOBOT",
	"Mayor"
}

GovernmentTeams = {
	"Police Officer",
	"Police Chief",
	"SWAT",
	"Swat Heavy",
	"Swat Leader",
	"Swat Medic",
	"Swat Marksman",
	"AUTOBOT",
	"Mayor"
}

AllowedTeams = {
	"Thief",
	"Dr Shadow",
	"Kommissar",
	"1337 Counter",
	"Solaire Astora",
	"Picolas Cage",
	"LOCUS",
	"Drip",
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

-- Design options for the bank entity display.
BANK_Design_BankVaultName = Color(153, 0, 0, 255)
BANK_Design_BankVaultNameBoarder = Color(0, 0, 0, 255)

BANK_Design_BankVaultAmount = Color(0, 153, 0, 255)
BANK_Design_BankVaultAmountBoarder = Color(0, 0, 0, 255)

BANK_Design_BankVaultCountdownName = Color(150, 150, 150, 255)
BANK_Design_BankVaultCountdownBoarderName = Color(0, 0, 0, 255)
BANK_Design_BankVaultCountdown = Color(150, 150, 150, 255)
BANK_Design_BankVaultCountdownBoarder = Color(0, 0, 0, 255)

BANK_Design_BankVaultCooldownName = Color(150, 150, 150, 255)
BANK_Design_BankVaultCooldownBoarderName = Color(0, 0, 0, 255)
BANK_Design_BankVaultCooldown = Color(150, 150, 150, 255)
BANK_Design_BankVaultCooldownBoarder = Color(0, 0, 0, 255)