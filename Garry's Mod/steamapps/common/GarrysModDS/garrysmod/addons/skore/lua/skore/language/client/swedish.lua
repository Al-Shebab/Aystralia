
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
local languageID = "swedish" -- Case-insensitive.

local languageEnglish = "Swedish" -- How do you spell this language's name in english?
local languageNative = "Svenska" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "Du har inte tillräckligt med behörighet att använda det här temat!",

	-- Themes' name translation. Some languages cannot translate properly colors
	-- from english, if that's your case, leave it as it is.
	["theme_cyan"] = "Cyan",
	["theme_teal"] = "Teal",
	["theme_green"] = "Grön",
	["theme_light_green"] = "Ljus Grön",
	["theme_lime"] = "Lime",
	["theme_yellow"] = "Gul",
	["theme_amber"] = "Amber",
	["theme_orange"] = "Orange",
	["theme_brown"] = "Brun",
	["theme_blue_grey"] = "Blå Grått",
	["theme_grey"] = "Grå",
	["theme_deep_orange"] = "Djup Orange",
	["theme_red"] = "Röd",
	["theme_pink"] = "Rosa",
	["theme_purple"] = "Lila",
	["theme_deep_purple"] = "Djup Lila",
	["theme_indigo"] = "Indigo",
	["theme_blue"] = "Blå",
	["theme_light_blue"] = "Ljus Blå",
	["theme_cyan_dark"] = "Mörk Cyan",
	["theme_teal_dark"] = "Mörk Teal",
	["theme_green_dark"] = "Mörk Grön",
	["theme_light_green_dark"] = "Ljus Grön Mörk",
	["theme_lime_dark"] = "Mörk Lime",
	["theme_yellow_dark"] = "Mörk Gul",
	["theme_amber_dark"] = "Mörk Amber",
	["theme_orange_dark"] = "Mörk Orange",
	["theme_brown_dark"] = "Mörk Brun",
	["theme_blue_grey_dark"] = "Mörk Blå Grå",
	["theme_grey_dark"] = "Mörk Grå",
	["theme_deep_orange_dark"] = "Djup Orange Mörk",
	["theme_red_dark"] = "Mörk Röd",
	["theme_pink_dark"] = "Mörk Rosa",
	["theme_purple_dark"] = "Mörk Lila",
	["theme_deep_purple_dark"] = "Djup Lila Mörk",
	["theme_indigo_dark"] = "Mörk Indigo",
	["theme_blue_dark"] = "Mörk Blå",
	["theme_light_blue_dark"] = "Ljug Blå Mörk",
	["theme_night"] = "Natt",

	-- Default Search Bar Hint
	["searchBar_defaultHint"] = "Sök",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Byt Tema",
	["defaultMenu_openScaling"] = "Skala om UI",
	["defaultMenu_openLanguage"] = "Byt Språk",

	-- Customization Menu Phrases: General
	["customization_title"] = "Anpassning",
	["customization_restoreDefaultTheme"] = "Återställ standardtema",
	["customization_restoreDefaultScaling"] = "Återställ standardskalning",
	["customization_restoreDefaultLanguage"] = "Återställ standard språk",
	["customization_defaultThemeRestored"] = "Standardtemat har återställts.",
	["customization_defaultScalingRestored"] = "Standardskalningen har återställts.",
	["customization_defaultLanguageRestored"] = "Standard språk har återställts.",
	["customization_alreadyDefaultTheme"] = "Du använder redan standardtemat!",
	["customization_alreadyDefaultScaling"] = "Du använder redan standardskalningsvärdet",
	["customization_alreadyDefaultLanguage"] = "Du använder redan standardspråket!",
	["customization_themesTabName"] = "Teman",
	["customization_scalingTabName"] = "Skalor",
	["customization_languageTabName"] = "Språk",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Ljus bakgrundspalett",
	["customization_lightBackgroundPaletteDescription"] = "Klicka på färghjulet nedan för att välja ett tema med ljus bakgrund. När du har valt en färg appliceras den omedelbart. Vissa teman kan vara begränsade till vissa användargrupper.",
	["customization_darkBackgroundPaletteTitle"] = "Mörk bakgrundspalett",
	["customization_darkBackgroundPaletteDescription"] = "Klicka på färghjulet nedan för att välja ett tema med ljus bakgrund. När du har valt en färg appliceras den omedelbart. Vissa teman kan vara begränsade till vissa användargrupper.",
	["customization_themeChangedSuccessfully"] = "Ditt tema har ändrats framgångsrikt till: %s",
	["customization_themeAlreadyInUse"] = "Du använder redan det här temat!",
	["customization_otherThemesTitle"] = "Andra Teman",
	["customization_otherThemesDescription"] = "Andra teman som inte passar med kategorierna ovan.",
	["customization_defaultThemeButton"] = "ÅTERSTÄLL STANDARD",
	["customization_nightThemeButton"] = "NATT",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "Skaljustering",
	["customization_scalingTabDescription"] = "Om du vill ändra storlek på ditt användargränssnitt, kan du göra det här genom att justera reglaget nedan. Du kanske vill öka storleken på din UI om du står långt ifrån din bildskärm. På andra sidan kan du minska storleken på din UI om du står nära en stor bildskärm.",
	["customization_scalingDefaultButton"] = "ÅTERSTÄLL STANDARD",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Språkval",
	["customization_languageTabDescription"] = "Här kan du välja ditt föredragna språk, när en gång valts kommer all text att översättas direkt. Om du får engelsk text på ett icke-engelska språk betyder det att språket endast delvis översätts / stöds.",
	["customization_languageSuccessfullyChanged"] = "Ditt språk har ändrats framgångsrikt till: %s",
	["customization_languageAlreadyInUse"] = "Du använder redan det här Språket!",

	-- Dialogs
	["dialog_confirm"] = "BEKRÄFTA",
	["dialog_cancel"] = "AVBRYT",
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
