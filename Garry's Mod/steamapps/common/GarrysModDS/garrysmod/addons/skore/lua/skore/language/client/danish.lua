/*###############################################
	DANISH LANGUAGE FILE
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
local languageID = "danish" -- Case-insensitive.

local languageEnglish = "Danish" -- How do you spell this language's name in english?
local languageNative = "Dansk" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "Du har ikke rettighederne til at andvende dette object!",

	-- Themes' name translation. Some languages cannot translate properly colors
	-- from english, if that's your case, leave it as it is.
	["theme_cyan"] = "Cyan",
	["theme_teal"] = "Teal",
	["theme_green"] = "Green",
	["theme_light_green"] = "Light Green",
	["theme_lime"] = "Lime",
	["theme_yellow"] = "Yellow",
	["theme_amber"] = "Amber",
	["theme_orange"] = "Orange",
	["theme_brown"] = "Brown",
	["theme_blue_grey"] = "Blue Grey",
	["theme_grey"] = "Grey",
	["theme_deep_orange"] = "Deep Orange",
	["theme_red"] = "Red",
	["theme_pink"] = "Pink",
	["theme_purple"] = "Purple",
	["theme_deep_purple"] = "Deep Purple",
	["theme_indigo"] = "Indigo",
	["theme_blue"] = "Blue",
	["theme_light_blue"] = "Light Blue",
	["theme_cyan_dark"] = "Cyan Dark",
	["theme_teal_dark"] = "Teal Dark",
	["theme_green_dark"] = "Green Dark",
	["theme_light_green_dark"] = "Light Green Dark",
	["theme_lime_dark"] = "Lime Dark",
	["theme_yellow_dark"] = "Yellow Dark",
	["theme_amber_dark"] = "Amber Dark",
	["theme_orange_dark"] = "Orange Dark",
	["theme_brown_dark"] = "Brown Dark",
	["theme_blue_grey_dark"] = "Blue Grey Dark",
	["theme_grey_dark"] = "Grey Dark",
	["theme_deep_orange_dark"] = "Deep Orange Dark",
	["theme_red_dark"] = "Red Dark",
	["theme_pink_dark"] = "Pink Dark",
	["theme_purple_dark"] = "Purple Dark",
	["theme_deep_purple_dark"] = "Deep Purple Dark",
	["theme_indigo_dark"] = "Indigo Dark",
	["theme_blue_dark"] = "Blue Dark",
	["theme_light_blue_dark"] = "Light Blue Dark",
	["theme_night"] = "Night",

	-- Default Search Bar Hint
	["searchBar_defaultHint"] = "søg",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Skift tema",
	["defaultMenu_openScaling"] = "skaler UI",
	["defaultMenu_openLanguage"] = "Skift sprog",

	-- Customization Menu Phrases: General
	["customization_title"] = "Tilpasning",
	["customization_restoreDefaultTheme"] = "Gendan standard tema",
	["customization_restoreDefaultScaling"] = "Gendan standard skalering",
	["customization_restoreDefaultLanguage"] = "Gendan standard sprog",
	["customization_defaultThemeRestored"] = "Standard temaet er blevet gendannet.",
	["customization_defaultScalingRestored"] = "Standard skaleringen er blevet gendannet.",
	["customization_defaultLanguageRestored"] = "Standard sproget er blevet gendannet.",
	["customization_alreadyDefaultTheme"] = "Du bruger allerede standard temaet!",
	["customization_alreadyDefaultScaling"] = "Du bruger allerede standard skaleringen!",
	["customization_alreadyDefaultLanguage"] = "Du bruger allerede standard sproget!",
	["customization_themesTabName"] = "Temaer",
	["customization_scalingTabName"] = "skalering",
	["customization_languageTabName"] = "sprog",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Lys baggrunds palette",
	["customization_lightBackgroundPaletteDescription"] = "Klik på farvehjulet nedenfor, for at vælge et tema med lys baggrund. Når du har valgt en farve, vil den blive anvendt straks. Nogle temaer kan være begrænset til bestemte brugergrupper.",
	["customization_darkBackgroundPaletteTitle"] = "Mørk baggrunds palette",
	["customization_darkBackgroundPaletteDescription"] = "Klik på farvehjulet nedenfor, for at vælge et tema med mørk baggrund. Når du har valgt en farve, vil den blive anvendt straks. Nogle temaer kan være begrænset til bestemte brugergrupper.",
	["customization_themeChangedSuccessfully"] = "Dit tema er blevet ændret til: %s",
	["customization_themeAlreadyInUse"] = "Du bruger allerede dette tema!",
	["customization_otherThemesTitle"] = "andre temaer",
	["customization_otherThemesDescription"] = "Andre temaer, der ikke passer til kategorierne ovenfor.",
	["customization_defaultThemeButton"] = "GENDAN STANDARD",
	["customization_nightThemeButton"] = "NAT",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "juster skalering",
	["customization_scalingTabDescription"] = "Hvis du ønsker at ændre størrelsen på dit brugerinterface, kan du gøre det ved at justere skyderen nedenfor. Du vil muligvis gerne øge størrelsen af ​​dit brugernavn, hvis du står langt væk fra din skærm. På den anden side vil du måske reducere størrelsen af ​​din brugerflade, hvis du står tæt på en stor skærm.",
	["customization_scalingDefaultButton"] = "GENDAN STANDARD",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Prog selektion",
	["customization_languageTabDescription"] = "Her kan du vælge dit fortrukne sprof. Når du har valgt vil alt tekst blive oversat med det samme. Hvis du får engelsk tekst på et ikke-engelsk sprog, betyder det, at sproget kun oversættes / understøttes delvist.",
	["customization_languageSuccessfullyChanged"] = "Dit sprog er blevet ændret til: %s",
	["customization_languageAlreadyInUse"] = "Du bruger allerede dette sprog!",

	-- Dialogs
	["dialog_confirm"] = "BEKRÆFT",
	["dialog_cancel"] = "ANNULLER",
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
