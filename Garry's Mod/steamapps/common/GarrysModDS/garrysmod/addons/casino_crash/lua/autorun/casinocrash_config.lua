if not Casino_Crash then --Prevents users from breaking things when saving this!
	Casino_Crash = {}
end

Casino_Crash.Config = {}
Casino_Crash.Config.RenderDistance = 512 --How far away can the screen be seen in a 3D space?
Casino_Crash.Config.Probability = 96 --Probability of the crash. Lower == crashes faster. Higher == longer before crash
Casino_Crash.Config.Interval = 0.01 --How much the multiplier goes up each "tick"
Casino_Crash.Config.Tick = 0.1 --Seconds per addition
Casino_Crash.Config.MaxMultiplier = 5 --Maximum multiplier allowed to bet on
Casino_Crash.Config.MinMultiplier = 0.1 --Minimum multiplier allowed to bet on
Casino_Crash.Config.MaxCash = 5000000 --Maximum multiplier allowed to bet on
Casino_Crash.Config.MinCash = 10 --Minimum multiplier allowed to bet on
Casino_Crash.Config.WaitTimer = 15 --Wait time between rounds
Casino_Crash.Config.CashType = "DarkRP" --Available types are "DarkRP", "Pointshop", Anything else is defaulted to DarkRP. You can also use custom values by setting this equal to your GetCash function...
Casino_Crash.Config.GiveCashType = "DarkRP" --Available types are "DarkRP", "Pointshop", Anything else is defaulted to DarkRP. You can also use custom values by setting this equal to your AddCash function...
Casino_Crash.Config.OnlyRunWithPlayers = true --Are players are required to start new games?
Casino_Crash.Config.Language = "English" --Currently only supports English, but may/can be expanded by adding a second table (Instructions below)
Casino_Crash.Config.AllowManualCashout = true --Allow/Disallow manual cashing out.

Casino_Crash.Config.Translations = {}
Casino_Crash.Config.Translations["English"] = {
	["tool.crash.category"] = "Casino Crash",
	["tool.casinocrash.desc"] = "Create/Remove Casino Crash panels in the world.\nUse 'Undo' key to undo placed panel",
	["tool.casinocrash.name"] = "Placement Tool",
	["tool.crash.clearpanels"] = "Clear All Panels",
	["tool.crash.slider"] = "3D2D Scale",
	["tool.crash.button"] = "Remove all panels",
	["tool.casinocrash.reload"] = "Remove all panels",
	["tool.casinocrash.right"] = "Remove the panel you're looking at",
	["tool.casinocrash.left"] = "Place down a new panel",

	["vgui.casinocrash.currency"] = "$",
	["vgui.casinocrash.multiplier"] = "Multiplier",
	["vgui.casinocrash.default"] = "Default",

	["vgui.casinocrash.placebet"] = "place bet",
	["vgui.casinocrash.manual"] = "manual",
	["vgui.casinocrash.bet"] = "bet:",
	["vgui.casinocrash.autocashout"] = "AUTO CASHOUT:",
	["vgui.casinocrash.roundwaiting"] = "CASH OUT",
	["vgui.casinocrash.roundendwait"] = "WAITING FOR ROUND TO END",
	["vgui.casinocrash.startwaiting"] = "WAITING FOR GAME TO START",

	["vgui.casinocrash.howtoplay"] = "How to Play:",
	["vgui.casinocrash.rule1"] = "• Select a cash value",
	["vgui.casinocrash.rule2"] = "• Select an auto-cashout multiplier",
	["vgui.casinocrash.rule3"] = "• Wait for a game to begin",
	["vgui.casinocrash.rule4"] = "• If crash is ≤ multiplier, you'll receive your money * multiplier",
	["vgui.casinocrash.rule5"] = "• Place your bets with caution!",

	["vgui.casinocrash.player"] = "PLAYER",
	["vgui.casinocrash.bet"] = "BET",
	["vgui.casinocrash.auto"] = "AUTO",
	["vgui.casinocrash.profit"] = "PROFIT",

	["vgui.casinocrash.waitingforplayers"] = "Waiting for players!",
	["vgui.casinocrash.roundstartsin"] = "Round starts in ",
	["vgui.casinocrash.seconds"] = " second(s)",

	["vgui.casinocrash.notenough"] = " You don't have enough money!",
}

Casino_Crash.Config.Translations["French"] = {
	["tool.crash.category"] = "Casino Crash",
	["tool.casinocrash.desc"] = "Crée/Supprime une fenêtre Casino Crash dans le jeu.\nAppuyez sur Undo pour défaire une fenêtre placée.",
	["tool.casinocrash.name"] = "Outil de placement",
	["tool.crash.clearpanels"] = "Supprimer toutes les fenêtres",
	["tool.crash.slider"] = "Taille 3D2D",
	["tool.crash.button"] = "Supprimer toutes les fenêtres",
	["tool.casinocrash.reload"] = "Supprimer toutes les fenêtres",
	["tool.casinocrash.right"] = "Supprimer la fenêtre ciblée",
	["tool.casinocrash.left"] = "Placer une nouvelle fenêtre",

	["vgui.casinocrash.currency"] = "$",
	["vgui.casinocrash.multiplier"] = "Multiplicateur",
	["vgui.casinocrash.default"] = "Défaut",

	["vgui.casinocrash.placebet"] = "placer pari",
	["vgui.casinocrash.manual"] = "manuel",
	["vgui.casinocrash.bet"] = "pari:",
	["vgui.casinocrash.autocashout"] = "MULTIPLICATEUR DE RETRAIT :",
	["vgui.casinocrash.startwaiting"] = "EN ATTENTE DU DÉBUT DE PARTIE",

	["vgui.casinocrash.howtoplay"] = "Comment jouer :",
	["vgui.casinocrash.rule1"] = "• Choisissez une somme à parier",
	["vgui.casinocrash.rule2"] = "• Choisissez votre multiplicateur de retrait",
	["vgui.casinocrash.rule3"] = "• Attendez le début de la partie",
	["vgui.casinocrash.rule4"] = "• Si vous gagnez, vous recevrez votre pari * multiplicateur",
	["vgui.casinocrash.rule5"] = "• Pariez avec modération !",

	--Still waiting for translations
	["vgui.casinocrash.player"] = "PLAYER",
	["vgui.casinocrash.bet"] = "BET",
	["vgui.casinocrash.auto"] = "AUTO",
	["vgui.casinocrash.profit"] = "PROFIT",

	["vgui.casinocrash.waitingforplayers"] = "Waiting for players!",
	["vgui.casinocrash.roundstartsin"] = "Round starts in ",
	["vgui.casinocrash.seconds"] = " second(s)",

	["vgui.casinocrash.notenough"] = " You don't have enough money!",
	["vgui.casinocrash.roundwaiting"] = "CASH OUT",
	["vgui.casinocrash.roundendwait"] = "WAITING FOR ROUND TO END",
}

-- Translating is as simple as changing these values.
-- I'd recommend keeping the English and creating a new table instead of overwriting!

--[[

Casino_Crash.Config.Translations["English"] = { --Replace English with your lang
	["tool.crash.category"] = "Casino Crash",
	["tool.casinocrash.desc"] = "Create/Remove Casino Crash panels in the world.\nUse 'Undo' key to undo placed panel",
	["tool.casinocrash.name"] = "Placement Tool",
	["tool.crash.clearpanels"] = "Clear All Panels",
	["tool.crash.slider"] = "3D2D Scale",
	["tool.crash.button"] = "Remove all panels",
	["tool.casinocrash.reload"] = "Remove all panels",
	["tool.casinocrash.right"] = "Remove the panel you're looking at",
	["tool.casinocrash.left"] = "Place down a new panel",

	["vgui.casinocrash.currency"] = "$",
	["vgui.casinocrash.multiplier"] = "Multiplier",
	["vgui.casinocrash.default"] = "Default",

	["vgui.casinocrash.placebet"] = "place bet",
	["vgui.casinocrash.manual"] = "manual",
	["vgui.casinocrash.bet"] = "bet:",
	["vgui.casinocrash.autocashout"] = "AUTO CASHOUT:",
	["vgui.casinocrash.roundwaiting"] = "WAITING FOR ROUND TO END...",
	["vgui.casinocrash.startwaiting"] = "WAITING FOR GAME TO START",

	["vgui.casinocrash.howtoplay"] = "How to Play:",
	["vgui.casinocrash.rule1"] = "• Select a cash value",
	["vgui.casinocrash.rule2"] = "• Select an auto-cashout multiplier",
	["vgui.casinocrash.rule3"] = "• Wait for a game to begin",
	["vgui.casinocrash.rule4"] = "• If won, you'll receive your money * multiplier",
	["vgui.casinocrash.rule5"] = "• Place your bets with caution!",
}

]]--