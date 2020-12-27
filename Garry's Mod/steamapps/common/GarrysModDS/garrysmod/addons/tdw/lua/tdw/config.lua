
cfg.WebhookURL = "https://canary.discord.com/api/webhooks/792215268192682029/Qea94Y-Gnc_NZTEE4c3ZHjNhfCLEZa_Amq8EjkYh2PewtbKimzlPG67DMtLLiwITCDbx"


cfg.SteamAPIKey = "CB2CD369E7B7A8FD95DDD35D5ED94719"


---------------------------------------------------------------------------
	Should we fetch and cache player info from the Steam API when a
	player connects instead of fetching and caching it when it is first used?
---------------------------------------------------------------------------*/
cfg.PrecachePlayerInfo = true


/*---------------------------------------------------------------------------
	Should logs show players roleplay names, or their steam names? This
	will work if you are running DarkRP or a derivative - or if you
	implement the <Player>.SteamName method yourself.
---------------------------------------------------------------------------*/
cfg.UseSteamNames = true


/*---------------------------------------------------------------------------
	Should we print a success message in console whenever a message was sent?
---------------------------------------------------------------------------*/
cfg.NotifySuccess = true


/*---------------------------------------------------------------------------
	This is where you can disable certain modules, meaning events that
	are handled within them will not be sent to Discord.
	You can also disable individual events within modules.

	To disable a module, simply set its value here to true. All included
	modules are shown below by default. For instance, if you run TTT and
	want to disable DarkRP, set DarkRP to true and TTT to false.

	To disable individual events within a module, do this:

	["Base"] = {
		["PlayerDeath"] = true,
		["AnotherHook"] = true
	}

cfg.DisabledModules = {
	//Relays everything from bLogs to Discord, set everything else to true for maximum effectiveness.
	["bLogs"] = false,

	["Base"] = false,
	["Sandbox"] = {
		//This is disabled by default because people could spam props (and dupes!!!) and by extension your channel, enable at your own discretion.
		["PlayerSpawnedProp"] = true
	},
	["DarkRP"] = false,
	["ULX"] = false,
	["Join and Leave"] = false,

	["Serverguard"] = true,
	["Awarn2"] = true,
	["TTT"] = true,
	["Cuffs"] = true,
	["Enhanced Raiding"] = true
}


/*---------------------------------------------------------------------------
	Should every color of every included embed be randomized? The above
	option is ignored when this is true.
---------------------------------------------------------------------------*/
cfg.RandomEmbedColors = false


/*---------------------------------------------------------------------------
	These are the colors that various embeds from included modules will
	use. External modules may have their own configuration elsewhere.
---------------------------------------------------------------------------*/
cfg.EmbedColors = {
	//Base
	PlayerDeath = Color(192, 57, 43, 255),

	//Sandbox
	PlayerSpawnedProp = Color(241, 196, 15, 255),
	PlayerSpawnedSENT = Color(155, 89, 182, 255),

	//ULX
	ULibPlayerKicked = Color(41, 128, 185, 255),
	ULibPlayerBanned = Color(192, 57, 43, 255),
	ULibPlayerUnBanned = Color(39, 174, 96, 255),

	//DarkRP
	addLaw = Color(52, 152, 219, 255),
	removeLaw = Color(192, 57, 43, 255),
	resetLaws = Color(192, 57, 43, 255),

	playerArrested = Color(192, 57, 43, 255),
	playerUnArrested = Color(52, 152, 219, 255),

	playerWanted = Color(192, 57, 43, 255),
	playerUnWanted = Color(52, 152, 219, 255),

	onPlayerDemoted = Color(230, 126, 34, 255),
	onPlayerChangedName = Color(142, 68, 173, 255),
	onHitCompleted = Color(22, 160, 133, 255),
	onHitFailed = Color(192, 57, 43, 255),

	playerBoughtCustomEntity = Color(52, 152, 219, 255),
	playerBoughtAmmo = Color(52, 152, 219, 255),
	playerBoughtPistol = Color(52, 152, 219, 255),
	playerBoughtShipment = Color(52, 152, 219, 255),

	//TTT
	TTTPrepareRound = Color(155, 89, 182, 255),
	TTTBeginRound = Color(22, 160, 133, 255),
	TTTEndRound = Color(46, 204, 113, 255),

	//Cuffs
	OnHandcuffed = Color(155, 89, 182, 255, 255),
	OnHandcuffBreak = Color(192, 57, 43, 255),

	//Enhanced Raiding
	onPlayerStartedRaid = Color(22, 160, 133, 255),
	onRaidStopped = Color(192, 57, 43, 255),

	//Serverguard, this is the same for every command that is ran
	serverguard = Color(22, 160, 133, 255),
	
	//AWarn2
	AWarnPlayerWarned = Color(22, 160, 133, 255),
	AWarnLimitKick = Color(192, 57, 43, 255),
	AWarnLimitBan = Color(192, 57, 43, 255),

	//Join and Leave
	player_connect = Color(22, 160, 133, 255),
	player_disconnect = Color(192, 57, 43, 255)
}