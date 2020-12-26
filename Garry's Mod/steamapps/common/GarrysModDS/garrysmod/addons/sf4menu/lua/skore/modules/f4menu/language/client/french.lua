
/*###############################################
	FRENCH LANGUAGE FILE
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
local languageID = "french" -- Case-insensitive.

local phrases = {
	-- F4 Menu Phrases: Tabs Names
	["f4menu_dashboardTab"] = "Dashboard",
	["f4menu_jobsTab"] = "Emplois",
	["f4menu_entitiesTab"] = "Entités",
	["f4menu_shipmentsTab"] = "Shipments",
	["f4menu_weaponsTab"] = "Armes",
	["f4menu_ammoTab"] = "Munitions",
	["f4menu_foodTab"] = "Aliments",
	["f4menu_vehiclesTab"] = "Véhicules",

	-- F4 Menu Phrases: General
	["f4menu_favouriteCategory"] = "Favoris",
	["f4menu_favourite"] = "PRÉFÉRÉ",
	["f4menu_unfavourite"] = "RETIRER DES FAVORIS",

	-- F4 Menu Phrases: Job Tab
	["f4menu_becomeJob"] = "DEVENIR EMPLOI",
	["f4menu_voteJob"] = "VOTE",

	-- F4 Menu Phrase: Other Entities
	["f4menu_freePrice"] = "GRATIS",
	["f4menu_buyButton"] = "ACHAT",

	-- F4 Menu Phrase: Extra Tabs
	["f4menu_usefulLinks"] = "Liens Utiles",
	["f4menu_donate"] = "Donner",
	["f4menu_discord"] = "Discord",
	["f4menu_steamGroup"] = "Steam Groupe",
	["f4menu_forums"] = "Forums",

	-- F4 Menu Phrase: Dashboard
	["f4menu_onlineStaff"] = "Personnel en Ligne",
	["f4menu_commands"] = "Les Commandes",
	["f4menu_commands_dropWeapon"] = "Laissez tomber l'arme",
	["f4menu_commands_dropMoney"] = "Déposer de l'argent",
	["f4menu_commands_dropMoneyPrompt"] = "Tapez le montant que vous souhaitez déposer.",
	["f4menu_commands_changeName"] = "Changer de Nom",
	["f4menu_commands_changeNamePrompt"] = "Tapez votre nouveau nom.",
	["f4menu_commands_requestLicense"] = "Demander une Licence",
	["f4menu_commands_changeJob"] = "Changer de Travail",
	["f4menu_commands_changeJobPrompt"] = "Tapez le nouveau nom de votre travail.",
	["f4menu_commands_advert"] = "Publicité",
	["f4menu_commands_advertPrompt"] = "Tapez votre message d'annonce.",
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
