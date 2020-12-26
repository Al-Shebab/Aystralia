
/*###############################################
	POLISH LANGUAGE FILE
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
local languageID = "polish" -- Case-insensitive.

local languageEnglish = "Polish" -- How do you spell this language's name in english?
local languageNative = "Polski" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "Nie masz wystarczających uprawnień do używania tego motywu!",

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
	["searchBar_defaultHint"] = "Szukaj",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Zmień Motyw",
	["defaultMenu_openScaling"] = "Skaluj UI",
	["defaultMenu_openLanguage"] = "Zmień Język",

	-- Customization Menu Phrases: General
	["customization_title"] = "Customization",
	["customization_restoreDefaultTheme"] = "Domyślny Motyw",
	["customization_restoreDefaultScaling"] = "Domyślne Skalowanie",
	["customization_restoreDefaultLanguage"] = "Domyślny Język",
	["customization_defaultThemeRestored"] = "Przywrócono domyślny motyw.",
	["customization_defaultScalingRestored"] = "Domyślne skalowanie zostało przywrócone.",
	["customization_defaultLanguageRestored"] = "Domyślny język został przywrócony.",
	["customization_alreadyDefaultTheme"] = "Używasz już domyślnego motywu!",
	["customization_alreadyDefaultScaling"] = "Używasz już domyślnej wartości skalowania!",
	["customization_alreadyDefaultLanguage"] = "Używasz już domyślnego języka!",
	["customization_themesTabName"] = "Motywy",
	["customization_scalingTabName"] = "Skalowanie",
	["customization_languageTabName"] = "Język",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Jasne Tło",
	["customization_lightBackgroundPaletteDescription"] = "Kliknij kółko kolorów poniżej, aby wybrać motyw z jasnym tłem. Po wybraniu koloru zostanie zastosowany natychmiast. Niektóre motywy mogą być ograniczone do określonych grup użytkowników.",
	["customization_darkBackgroundPaletteTitle"] = "Ciemne Tło",
	["customization_darkBackgroundPaletteDescription"] = "Kliknij kółko kolorów poniżej, aby wybrać motyw z ciemnym tłem. Po wybraniu koloru zostanie zastosowany natychmiast. Niektóre motywy mogą być ograniczone do określonych grup użytkowników.",
	["customization_themeChangedSuccessfully"] = "Twój motyw został pomyślnie zmieniony na: %s",
	["customization_themeAlreadyInUse"] = "Używasz już tego motywu!",
	["customization_otherThemesTitle"] = "Inne motywy",
	["customization_otherThemesDescription"] = "Inne kolory, które nie pasują do powyższych kategorii",
	["customization_defaultThemeButton"] = "Domyślny",
	["customization_nightThemeButton"] = "Noc",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "Dostosowanie Skali",
	["customization_scalingTabDescription"] = "Jeśli chcesz zmienić rozmiar interfejsu użytkownika, możesz to zrobić tutaj, dostosowując suwak poniżej. Możesz zwiększyć rozmiar swojego interfejsu, jeśli stoisz daleko od monitora. Z drugiej strony możesz zmniejszyć rozmiar swojego interfejsu, jeśli stoisz blisko dużego monitora.",
	["customization_scalingDefaultButton"] = "Domyślny",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Wybór Języka",
	["customization_languageTabDescription"] = "Tutaj możesz wybrać preferowany język, po wybraniu cały tekst zostanie natychmiast przetłumaczony. Jeśli otrzymujesz angielski tekst w języku innym niż angielski, oznacza to, że język jest tylko częściowo przetłumaczony / obsługiwany.",
	["customization_languageSuccessfullyChanged"] = "Twój język został zmieniony z powodzeniem na: %s",
	["customization_languageAlreadyInUse"] = "Już używasz tego języka!",

	-- Dialogs
	["dialog_confirm"] = "POTWIERDZAĆ",
	["dialog_cancel"] = "ANULUJ",
	["dialog_ok"] = "Dobrze",
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
