
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
	   English. Please also change the values around lines 46 and 47 accordingly.

	4. Translate the phrases by changing the values after the equal sign on the
	   'phrases' variable (line 49+). Please do not change none of the values
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

local languageEnglish = "Dutch" -- How do you spell this language's name in english?
local languageNative = "Nederlands" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "Je hebt niet genoeg rechten om deze theme te gebruiken!",

	-- Themes' name translation. Some languages cannot translate properly colors
	-- from english, if that's your case, leave it as it is.
	["theme_cyan"] = "Cyaan",
	["theme_teal"] = "Taling",
	["theme_green"] = "Groen",
	["theme_light_green"] = "Licht Groen",
	["theme_lime"] = "Limoen",
	["theme_yellow"] = "Geel",
	["theme_amber"] = "Amber",
	["theme_orange"] = "Oranje",
	["theme_brown"] = "Bruin",
	["theme_blue_grey"] = "Blauw Grijs",
	["theme_grey"] = "Grijs",
	["theme_deep_orange"] = "Diep Oranje",
	["theme_red"] = "Rood",
	["theme_pink"] = "Roze",
	["theme_purple"] = "Paars",
	["theme_deep_purple"] = "Diep Paars",
	["theme_indigo"] = "Indigo",
	["theme_blue"] = "Blauw",
	["theme_light_blue"] = "Licht Blauw",
	["theme_cyan_dark"] = "Donker Cyaan",
	["theme_teal_dark"] = "Donker Taling",
	["theme_green_dark"] = "Donker Groen",
	["theme_light_green_dark"] = "Licht Donker Groen",
	["theme_lime_dark"] = "Donker Limoen",
	["theme_yellow_dark"] = "Donker Geel",
	["theme_amber_dark"] = "Donker Amber",
	["theme_orange_dark"] = "Donker Oranje",
	["theme_brown_dark"] = "Donker Bruin",
	["theme_blue_grey_dark"] = "Donker Blauw Grijs",
	["theme_grey_dark"] = "Donker Grijs",
	["theme_deep_orange_dark"] = "Donker Diep Oranje",
	["theme_red_dark"] = "Donker Rood",
	["theme_pink_dark"] = "Donker Roze",
	["theme_purple_dark"] = "Donker Paars",
	["theme_deep_purple_dark"] = "Donker Diep Paars",
	["theme_indigo_dark"] = "Donker Indigo",
	["theme_blue_dark"] = "Donker Blauw",
	["theme_light_blue_dark"] = "Donker Licht Blauw",
	["theme_night"] = "Nacht",

	-- Default Search Bar Hint
	["searchBar_defaultHint"] = "Zoek",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Verrander Thema",
	["defaultMenu_openScaling"] = "Herschaal UI",
	["defaultMenu_openLanguage"] = "Verrander Taal",

	-- Customization Menu Phrases: General
	["customization_title"] = "Aanpassen",
	["customization_restoreDefaultTheme"] = "Herstel Standaard Thema",
	["customization_restoreDefaultScaling"] = "Herstel Standaard Schaal",
	["customization_restoreDefaultLanguage"] = "Herstel Standaard Taal",
	["customization_defaultThemeRestored"] = "Het standaard thema is hersteld.",
	["customization_defaultScalingRestored"] = "De standaard schaal is hersteld.",
	["customization_defaultLanguageRestored"] = "De standaard taal is hersteld.",
	["customization_alreadyDefaultTheme"] = "Je bent deze thema al aan het gebruiken!",
	["customization_alreadyDefaultScaling"] = "Je gebruikt al de standaard schaal waarde!",
	["customization_alreadyDefaultLanguage"] = "You bent al de standaard taal aan het gebruiken!",
	["customization_themesTabName"] = "Themas",
	["customization_scalingTabName"] = "Schaal",
	["customization_languageTabName"] = "Taal",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Licht Achterground Palet",
	["customization_lightBackgroundPaletteDescription"] = "Klik op het kleuren wiel onderaan om een thema te kiezen met een lichte achtergrond. Als je jouw kleur hebt geselecteerd, word het gelijk toegepast. Somige Themas kunnen beperkt zijn tot bepaalde gebruikersgroepen",
	["customization_darkBackgroundPaletteTitle"] = "Donker Achterground Palet",
	["customization_darkBackgroundPaletteDescription"] = "Klik op het kleuren wiel onderaan om een kleur te kiezen met een donker achtergrond. Waarneer je een kleur hebt geselecteerd, word het gelijk toegepast. Somige Themas kunnen beperkt zijn tot bepaalde gebruikersgroepen",
	["customization_themeChangedSuccessfully"] = "Jouw thema is succesvol verranderd naar: %s",
	["customization_themeAlreadyInUse"] = "Je gebruikt deze thema al!",
	["customization_otherThemesTitle"] = "Andere Themas",
	["customization_otherThemesDescription"] = "Andere themas die niet passen in de catogorie bovenaan.",
	["customization_defaultThemeButton"] = "HERSTEL STANDAARD",
	["customization_nightThemeButton"] = "NACHT",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "Schaal Aanpassing",
	["customization_scalingTabDescription"] = "Als je jouw UI van schaal wil verranderen, kan je dat doen door de balk hieronder te verranderen. Je wilt de grootte van je UI hoger zetten als je ver weg van je monitor staat. Aan de andere kant, wil je de UI lager zetten als je dicht op een grote monizit zit.",
	["customization_scalingDefaultButton"] = "HERSTEL STANDAARD",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Taal Selectie",
	["customization_languageTabDescription"] = "Here you can choose your preferred language, once chosen all text will be translated instantly. If you're getting english text on a non-english language, then it means that language is only partially translated / supported.",
	["customization_languageSuccessfullyChanged"] = "Je taal is succesvol verranderd naar: %s",
	["customization_languageAlreadyInUse"] = "You gebruikt deze taal al!",

	-- Dialogs
	["dialog_confirm"] = "BEVESTIG",
	["dialog_cancel"] = "ANNULEREN",
	["dialog_ok"] = "OK",
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

sKore.addPhrase(languageID, "language_english", languageEnglish)
sKore.addPhrase(languageID, "language_native", languageNative)

for placeholder, fulltext in pairs(phrases) do
	sKore.addPhrase(languageID, placeholder, fulltext)
end

sKore.reloadLanguage()
