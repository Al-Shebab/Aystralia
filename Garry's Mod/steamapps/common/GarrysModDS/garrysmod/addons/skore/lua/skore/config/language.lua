
/*###############################################
	Language Configuration File
###############################################*/

-- Should players be able to select their preferred language (from a list of
-- available and supported ones)? Or should players be forced to use the default
-- language?
sKore.config["allowLanguageSelection"] = true

-- What chat command(s) should open the language selection menu?
--
-- This setting defines the chat command(s) that open the language selection
-- menu. Obviously, this setting has no effect if language selection is not
-- enabled. If you wish to disable the chat command(s) for this menu, leave the
-- table empty.
sKore.config["languageSelectionMenuChat"] = {
	"/language", "!language", "/lang", "!lang"
}

-- What console command(s) should open the language selection menu?
--
-- This setting defines the console command(s) that open the language selection
-- menu. Obviously, this setting has no effect if language selection is not
-- enabled. If you wish to disable the console command(s) for this menu, leave
-- the table empty.
sKore.config["languageSelectionMenuConsole"] = {}

-- How should the language console variable be named?
--
-- This settings defines the name of the language console variable. This has no
-- direct impact on the addon's behavior. You shouldn't need to change this
-- unless you have a special reason to.
--
-- WARNING: This setting cannot be a name of an already existing console command
-- or console variable. The addon will break silently if it is.
sKore.config["languageConvar"] = "skore_language"

-- What is the default language?
--
-- New players will have, by default, their language set to this. Whenver a
-- translation is not found, the english phrase is used instead. If language
-- selection is disabled, all players will be forced to use this language.
sKore.config["defaultLanguage"] = "english"

-- What is the server's language?
--
-- Any information printed to the server's console will be written on this
-- language. Whenver a translation is not found, the english phrase is used
-- instead.
sKore.config["serverLanguage"] = "english"

-- Should we prompt the language selection menu whenever a player joins for the
-- server for the first time?
sKore.config["promptLanguageSelection"] = true



sKore.reloadLanguage() -- Ignore this line.
