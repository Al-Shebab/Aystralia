
/*###############################################
	sF4Menu Configuration File
###############################################*/

-- What should be the F4 Menu's title?
-- Leave "" for the current server name.
sF4Menu.config["title"] = ""

-- What tabs should be shown on the F4 Menu?
--
-- If you wish to disable any tab on the F4 you can do it in here by changing
-- the value in front of the tab's name from 'true' to 'false'.
sF4Menu.config["enabledTabs"] = {
	["dashboard"] = true,
	["jobs"] = true,
	["entities"] = true,
	["shipments"] = true,
	["weapons"] = true,
	["ammo"] = true,
	["food"] = true,
	["vehicles"] = true
}

-- Should the favourite system be enabled?
-- 'true' for yes, 'false' for no.
sF4Menu.config["enableFavourites"] = true

-- Should the search bar feature be enabled?
-- 'true' for yes, 'false' for no.
sF4Menu.config["searchBar"] = true

-- Should empty tabs be hidden or disabled?
-- 'true' to hide, 'false' to disable.
sF4Menu.config["hideTabs"] = false

-- Should we draw a background blur?
-- 'true' for yes, 'false' for no.
sF4Menu.config["blurBackground"] = true

-- Should we draw a divider between darkRP tabs and the extra tabs?
-- 'true' for yes, 'false' for no.
sF4Menu.config["showDivider"] = true

-- What should be on the label above extra tabs?
-- "" to disable, prefix text with # if you wish to refer to a language item.
sF4Menu.config["extraTabsLabel"] = "#f4menu_usefulLinks"

-- What ranks should be shown under the 'Online Staff' tab on dashboard?
-- Players with any of those ranks will be shown under the 'Online Staff' tab.
sF4Menu.config["adminRanks"] = {"superadmin", "admin", "moderator", "operator"}

-- Extra tabs configuration, follow the examples below.
-- For a list of all icons, check 'skore/materials/skore/black', the icons' name
-- is the file name without the '.png'
sF4Menu.config["extraTabs"] = {
	{
		["icon"] = "paypal",
		-- The prefix # is optional, it is only used to refer to a translated phrase,
		-- acording to the active langauge.
		["text"] = "#f4menu_donate",
		["url"] = "http://www.google.com",
	},
	{
		["icon"] = "discord",
		["text"] = "#f4menu_discord",
		["url"] = "http://www.google.com",
	},
	{
		["icon"] = "steam",
		["text"] = "#f4menu_steamGroup",
		["url"] = "http://www.google.com",
	},
	{
		["icon"] = "web",
		["text"] = "#f4menu_forums",
		["url"] = "http://www.google.com",
	},
}

-- The dashboard commands configuration.
-- Follow the examples if you wish to add, remove or modify the commands.
sF4Menu.config["dashboardCommands"] = {
	{
		["icon"] = "pistol",
		["buttonText"] = "#f4menu_commands_dropWeapon",
		["command"] = {"say", "/dropweapon"},
	},
	{
		-- For a list of all icons, check 'skore/materials/skore/black', the icons' name
		-- is the file name without the '.png'
		["icon"] = "cash-usd",
		-- The prefix # is optional, it is only used to refer to a translated phrase,
		-- acording to the active langauge.
		["buttonText"] = "#f4menu_commands_dropMoney",
		["command"] = {"say", "/dropmoney %s"}, -- %s will be replaced with prompt input.
		["prompt"] = true, -- Request text input.
		["promptTitle"] = "#f4menu_commands_dropMoney", -- If no title is given, 'buttonText' will be used instead.
		["promptDescription"] = "#f4menu_commands_dropMoneyPrompt",
		["numericPrompt"] = true,
	},
	{
		["icon"] = "pencil",
		["buttonText"] = "#f4menu_commands_changeName",
		["command"] = {"say", "/name %s"},
		["prompt"] = true,
		["promptDescription"] = "#f4menu_commands_changeNamePrompt",
	},
	{
		["icon"] = "certificate",
		["buttonText"] = "#f4menu_commands_requestLicense",
		["command"] = {"say", "/requestlicense"},
	},
	{
		["icon"] = "briefcase-edit",
		["buttonText"] = "#f4menu_commands_changeJob",
		["command"] = {"say", "/job %s"},
		["prompt"] = true,
		["promptDescription"] = "#f4menu_commands_changeJobPrompt",
	},
	{
		["icon"] = "message-alert",
		["buttonText"] = "#f4menu_commands_advert",
		["command"] = {"say", "/advert %s"},
		["prompt"] = true,
		["promptDescription"] = "#f4menu_commands_advertPrompt",
	},
}



sF4Menu.testConfig() -- Tests for any errors on the config. Ignore this line.
