
-- NPC POLICE CONFIG
-- THIS FEATURE IS NOT FINISHED!
-- I would advise NOT using this, but you can test it out if you wish on your development server :)

CH_BankVault.Config.UseNPCCopsDLC = false -- Enables the DLC. Police NPCs will spawn at your positions (the bank most likely) and attack current robbers.

-- Default Config
-- Max NPCs
-- Continue to spawn or just one-time																								

CH_BankVault.Config.NPCCOPS_RandomWeapons = { -- List of random weapons given to the NPC police officers when they spawn.
	"weapon_357",
    "weapon_ar2",
    "weapon_bugbait",
    "weapon_crossbow",
    "weapon_crowbar",
    "weapon_frag",
    "weapon_pistol",
    "weapon_rpg",
    "weapon_shotgun",
    "weapon_smg1",
    "weapon_stunstick"  -- THE LAST TEAM SHOULD NOT HAVE A COMMA
}

CH_BankVault.Config.NPCCOPS_TimerLoop = 4 -- How many rounds of police npcs should there be?
CH_BankVault.Config.NPCCOPS_TimerInterval = 60 -- Seconds between each wave of police npcs. 

CH_BankVault.Config.NPCCOPS_MinHealth = 100 -- Minimum amount of health a npc police will spawn with.
CH_BankVault.Config.NPCCOPS_MaxHealth = 200 -- Maximum amount of health a npc police will spawn with.