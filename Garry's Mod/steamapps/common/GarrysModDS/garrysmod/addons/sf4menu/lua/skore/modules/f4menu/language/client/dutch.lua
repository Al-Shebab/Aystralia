
/*###############################################
	DUTCH LANGUAGE FILE
#################################################

	Author(s): SmOkEwOw (STEAM_0:0:60283521)
			   Liam (STEAM_0:0:98526528)
			   Combrine(STEAM_0:1:60420504)

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
local languageID = "dutch" -- Case-insensitive.

local phrases = {
	-- F4 Menu Phrases: Tabs Names
	["f4menu_dashboardTab"] = "Dashboard",
	["f4menu_jobsTab"] = "Banen",
	["f4menu_entitiesTab"] = "Entities",
	["f4menu_shipmentsTab"] = "Lading",
	["f4menu_weaponsTab"] = "Wapens",
	["f4menu_ammoTab"] = "Ammo",
	["f4menu_foodTab"] = "Eten",
	["f4menu_vehiclesTab"] = "Autos",

	-- F4 Menu Phrases: General
	["f4menu_favouriteCategory"] = "Favorieten",
	["f4menu_favourite"] = "FAVORIET",
	["f4menu_unfavourite"] = "UNFAVOURITE",

	-- F4 Menu Phrases: Job Tab
	["f4menu_becomeJob"] = "WORD BAAN",
	["f4menu_voteJob"] = "STEM",

	-- F4 Menu Phrase: Other Entities
	["f4menu_freePrice"] = "GRATIS",
	["f4menu_buyButton"] = "KOOP",

	-- F4 Menu Phrase: Extra Tabs
	["f4menu_usefulLinks"] = "Handige Links",
	["f4menu_donate"] = "Doneer",
	["f4menu_discord"] = "Discord",
	["f4menu_steamGroup"] = "Steam Groep",
	["f4menu_forums"] = "Forums",

	-- F4 Menu Phrase: Dashboard
	["f4menu_onlineStaff"] = "Online Staff",
	["f4menu_commands"] = "Commandos",
	["f4menu_commands_dropWeapon"] = "Drop Wapen",
	["f4menu_commands_dropMoney"] = "Drop Geld",
	["f4menu_commands_dropMoneyPrompt"] = "Type hoeveel geld je wil droppen.",
	["f4menu_commands_changeName"] = "Verrander naam",
	["f4menu_commands_changeNamePrompt"] = "Type je nieuwe naam.",
	["f4menu_commands_requestLicense"] = "Request License",
	["f4menu_commands_changeJob"] = "Verrander Naam",
	["f4menu_commands_changeJobPrompt"] = "Type je nieuwe baan naam",
	["f4menu_commands_advert"] = "Adverteer",
	["f4menu_commands_advertPrompt"] = "Typ je adverteer bericht.",
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
