
/*###############################################
	SWEDISH LANGUAGE FILE
#################################################

	Author(s): SmOkEwOw (STEAM_0:0:60283521)
			   Liam (STEAM_0:0:98526528)

#################################################

	This file contains all the language phrases of the language mentioned above.
	If you wish to translate this addon, you might be able to do it in here, but
	that is not the way it is supposed to be done. Down below is a simple, step
	by step on how you should do it:

	1. Create a copy of this file and rename it (the name of the file is not
	   important but it will usually be the name of the language you're
	   translating to, in English).

	2. Optionally rename the 'ENGLISH LANGUAGE FILE' on line 3 to 'MY NEW
	   LANGUAGE FILE'.

	3. Change the variable 'languageID' around line 44 to something that easily
	   identifies your language, preferably how you type that language in
	   English.

	4. Translate the phrases by changing the values after the equal sign on the
	   'phrases' variable (line 46+). Please do not change none of the values
	   before the equal sign, doing so will result in a faulty translation.

	5. If you wish this to be the default language, check the language
	   configuration on 'skore/config/language.lua' and change the default
	   language to the language identification name (set on step 3).

	6. [OPTIONAL STEP] Set or add yourself as the author on line 6. Also
	   consider helping the developer translate this addon by sending your
	   translation to him.

	If you encounter any problems or have any doubts, make a support ticket on
	gmodstore.
*/

-- Language identification name, this is usually how you type the language's name in English.
local languageID = "swedish" -- Case-insensitive.

local phrases = {
	-- F4 Menu Phrases: Tabs Names
	["f4menu_dashboardTab"] = "Panel",
	["f4menu_jobsTab"] = "Yrken",
	["f4menu_entitiesTab"] = "Entiteter",
	["f4menu_shipmentsTab"] = "Shipments",
	["f4menu_weaponsTab"] = "Vapen",
	["f4menu_ammoTab"] = "Ammunition",
	["f4menu_foodTab"] = "Mat",
	["f4menu_vehiclesTab"] = "Bilar",

	-- F4 Menu Phrases: General
	["f4menu_favouriteCategory"] = "Favourites",
	["f4menu_favourite"] = "FAVORIT",
	["f4menu_unfavourite"] = "TA BORT FRÅN FAVORITER",

	-- F4 Menu Phrases: Job Tab
	["f4menu_becomeJob"] = "BLI JOBB",
	["f4menu_voteJob"] = "RÖSTA",

	-- F4 Menu Phrase: Other Entities
	["f4menu_freePrice"] = "GRATIS",
	["f4menu_buyButton"] = "KÖP",

	-- F4 Menu Phrase: Extra Tabs
	["f4menu_usefulLinks"] = "Användbara Länkar",
	["f4menu_donate"] = "Donera",
	["f4menu_discord"] = "Discord",
	["f4menu_steamGroup"] = "Steam Grupp",
	["f4menu_forums"] = "Forums",

	-- F4 Menu Phrase: Dashboard
	["f4menu_onlineStaff"] = "Staff som är Online",
	["f4menu_commands"] = "Kommandon",
	["f4menu_commands_dropWeapon"] = "Släpp Vapnet",
	["f4menu_commands_dropMoney"] = "Släpp Pengar",
	["f4menu_commands_dropMoneyPrompt"] = "Skriv det belopp du vill släppa.",
	["f4menu_commands_changeName"] = "Byt Namn",
	["f4menu_commands_changeNamePrompt"] = "Skriv ditt nya namn.",
	["f4menu_commands_requestLicense"] = "Begära om Licens",
	["f4menu_commands_changeJob"] = "Byt Jobb",
	["f4menu_commands_changeJobPrompt"] = "Skriv ditt nya jobbs namn.",
	["f4menu_commands_advert"] = "Annons",
	["f4menu_commands_advertPrompt"] = "Skriv din annons.",
}



/*################################################################
	END OF CONFIGURATION FILE. PLEASE IGNORE EVERYTHING BELOW!
##################################################################

	If, even though you have read the text above, you have read this far,
	here is an explanation of what the code below does:

	The following code searchs for as much mistaskes you might have commited on
	the configuration and throws an error if it finds any. The addon will most
	likely not work properly until you get rid of the errors.

*/

for placeholder, fulltext in pairs(phrases) do
	sKore.addPhrase(languageID, placeholder, fulltext)
end

sKore.reloadLanguage()
