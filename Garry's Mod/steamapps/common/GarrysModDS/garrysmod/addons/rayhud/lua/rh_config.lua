-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.1

--[[
Here you can set the default settings for RayHUD.
What you set here will be the initial settings for players who will visit your server for the first time.
These settings will also be applied when the player restores default settings in-game.

However, be aware that what you set here will not affect players who have already been on your server with RayHUD installed, at least until they reset HUD to default settings.

You can also set RayHUD.Cfg.EditableForPlayers = false, then nobody but you will have access to RayHUD settings (console command: RayHUD),
you will be able to change settings there and see live changes, and copy selected settings to paste them into this file .
]]

RayHUD.Cfg = RayHUD.Cfg or {} -- Don't touch it

RayHUD.Cfg.EditableForPlayers = false -- main switch, set it to false if you want all players to use the settings from this config and not be able to edit their RayHUD
-- 


RayHUD.Cfg.Scale = 20 	-- value: 10 - 30
RayHUD.Cfg.Rounding = 10	-- value: 0 - 20
RayHUD.Cfg.Opacity = 255   -- value: 0 - 255

RayHUD.Cfg.CrashScreen = false
RayHUD.Cfg.MiniMode = false

RayHUD.Cfg.BlurMode = false

RayHUD.Cfg.TeamColor = false
RayHUD.Cfg.CustomColor = Color(66, 66, 66)

-- 1 - Always Show, 2 - Show on TAB, 3 - Hide, 4 - Show when getting XP (LevelPanel ONLY!)
RayHUD.Cfg.LawsPanel = 3
RayHUD.Cfg.WantedList = 3
RayHUD.Cfg.LevelPanel = 3


-- This one option can only be changed in this config file --
RayHUD.Cfg.Language = "english"