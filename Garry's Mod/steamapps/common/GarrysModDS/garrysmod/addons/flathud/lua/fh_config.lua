-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

--[[
Here you can set the default settings for FlatHUD.
What you set here will be the initial settings for players who will visit your server for the first time.
These settings will also be applied when the player restores default settings in-game.

However, be aware that what you set here will not affect players who have already been on your server with FlatHUD installed, at least until they reset HUD to default settings.

You can also set FlatHUD.Cfg.EditableForPlayers = false, then nobody but you will have access to FlatHUD settings (console command: flathud),
you will be able to change settings there and see live changes, and copy selected settings to paste them into this file .
]]

FlatHUD.Cfg = FlatHUD.Cfg or {} -- Don't touch it

FlatHUD.Cfg.EditableForPlayers = false -- main switch, set it to false if you want all players to use the settings from this config and not be able to edit their FlatHUD
-- 


FlatHUD.Cfg.Scale = 20 	-- value: 10 - 30
FlatHUD.Cfg.Rounding = 10	-- value: 0 - 20
FlatHUD.Cfg.Opacity = 255   -- value: 0 - 255

FlatHUD.Cfg.CrashScreen = false
FlatHUD.Cfg.MiniMode = false

FlatHUD.Cfg.BlurMode = false

FlatHUD.Cfg.TeamColor = false
FlatHUD.Cfg.CustomColor = Color(66, 66, 66)

-- 1 - Always Show, 2 - Show on TAB, 3 - Hide, 4 - Show when getting XP (LevelPanel ONLY!)
FlatHUD.Cfg.LawsPanel = 3
FlatHUD.Cfg.WantedList = 3
FlatHUD.Cfg.LevelPanel = 3


-- This one option can only be changed in this config file --
FlatHUD.Cfg.Language = "english"