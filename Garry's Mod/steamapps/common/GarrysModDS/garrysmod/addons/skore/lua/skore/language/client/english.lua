
/*###############################################
	ENGLISH LANGUAGE FILE
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
local languageID = "english" -- Case-insensitive.

local languageEnglish = "English" -- How do you spell this language's name in english?
local languageNative = "English" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "You do not have enough permission to use this theme!",

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
	["searchBar_defaultHint"] = "Search",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Change Theme",
	["defaultMenu_openScaling"] = "Rescale UI",
	["defaultMenu_openLanguage"] = "Change Language",

	-- Customization Menu Phrases: General
	["customization_title"] = "Customization",
	["customization_restoreDefaultTheme"] = "Restore Default Theme",
	["customization_restoreDefaultScaling"] = "Restore Default Scaling",
	["customization_restoreDefaultLanguage"] = "Restore Default Language",
	["customization_defaultThemeRestored"] = "The default theme has been restored.",
	["customization_defaultScalingRestored"] = "The default scaling has been restored.",
	["customization_defaultLanguageRestored"] = "The default language has been restored.",
	["customization_alreadyDefaultTheme"] = "You're already using the default theme!",
	["customization_alreadyDefaultScaling"] = "You're already using the default scale value!",
	["customization_alreadyDefaultLanguage"] = "You're already using the default language!",
	["customization_themesTabName"] = "Themes",
	["customization_scalingTabName"] = "Scaling",
	["customization_languageTabName"] = "Language",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Light Background Palette",
	["customization_lightBackgroundPaletteDescription"] = "Click on the colour wheel below to choose a theme with a light background. When you've selected a colour, it will be applied immediately. Some themes might be restricted to certain user groups.",
	["customization_darkBackgroundPaletteTitle"] = "Dark Background Palette",
	["customization_darkBackgroundPaletteDescription"] = "Click on the colour wheel below to choose a theme with a dark background. When you've selected a colour, it will be applied immediately. Some themes might be restricted to certain user groups.",
	["customization_themeChangedSuccessfully"] = "Your theme has been changed to: %s",
	["customization_themeAlreadyInUse"] = "You're already using this theme!",
	["customization_otherThemesTitle"] = "Other Themes",
	["customization_otherThemesDescription"] = "Other themes that don't fit the categories above.",
	["customization_defaultThemeButton"] = "RESTORE DEFAULT",
	["customization_nightThemeButton"] = "NIGHT",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "Scale Ajustment",
	["customization_scalingTabDescription"] = "If you wish to resize your UI, you may do so here by adjusting the slider below. You might want to increase the size of your UI if you're far from your monitor. On the other hand, you might want to decrease the size of your UI if you're close to a big monitor.",
	["customization_scalingDefaultButton"] = "RESTORE DEFAULT",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Language Selection",
	["customization_languageTabDescription"] = "Here you can choose your preferred language, once chosen all text will be translated instantly. Please bare in mind, not all text is fully translated.",
	["customization_languageSuccessfullyChanged"] = "Your chosen language has been changed to: %s",
	["customization_languageAlreadyInUse"] = "You're already using this language!",

	-- Dialogs
	["dialog_confirm"] = "CONFIRM",
	["dialog_cancel"] = "CANCEL",
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
