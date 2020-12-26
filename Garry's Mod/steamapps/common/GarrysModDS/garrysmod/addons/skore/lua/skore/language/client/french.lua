
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
local languageID = "french" -- Case-insensitive.

local languageEnglish = "French" -- How do you spell this language's name in english?
local languageNative = "Francais" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "Vous n'avez pas assez d'autorité pour utiliser ce thème!",

	-- Themes' name translation. Some languages cannot translate properly colors
	-- from english, if that's your case, leave it as it is.
	["theme_cyan"] = "Cyan",
	["theme_teal"] = "Sarcelle",
	["theme_green"] = "Vert",
	["theme_light_green"] = "Vert Clair",
	["theme_lime"] = "Citron Vert",
	["theme_yellow"] = "Jaune",
	["theme_amber"] = "Ambre",
	["theme_orange"] = "Orange",
	["theme_brown"] = "Marron",
	["theme_blue_grey"] = "Gris Bleu",
	["theme_grey"] = "Gris",
	["theme_deep_orange"] = "Orange Profond",
	["theme_red"] = "Rouge",
	["theme_pink"] = "Rose",
	["theme_purple"] = "Violet",
	["theme_deep_purple"] = "Violet Profond",
	["theme_indigo"] = "Indigo",
	["theme_blue"] = "Bleu",
	["theme_light_blue"] = "Bleu Clair",
	["theme_cyan_dark"] = "Cyan Foncé",
	["theme_teal_dark"] = "Sarcelle Foncée",
	["theme_green_dark"] = "Vert Foncé",
	["theme_light_green_dark"] = "Vert Clair Foncé",
	["theme_lime_dark"] = "Citron Vert Foncé",
	["theme_yellow_dark"] = "Jaune Foncé",
	["theme_amber_dark"] = "Ambre Foncé",
	["theme_orange_dark"] = "Orange Foncé",
	["theme_brown_dark"] = "Brun Foncé",
	["theme_blue_grey_dark"] = "Gris Bleu Foncé",
	["theme_grey_dark"] = "Gris Foncé",
	["theme_deep_orange_dark"] = "Orange Profond Foncé",
	["theme_red_dark"] = "Rouge Foncé",
	["theme_pink_dark"] = "Rose Foncé",
	["theme_purple_dark"] = "Violet Foncé",
	["theme_deep_purple_dark"] = "Violet Profond Foncé",
	["theme_indigo_dark"] = "Indigo Foncé",
	["theme_blue_dark"] = "Bleu Foncé",
	["theme_light_blue_dark"] = "Bleu Clair Foncé",
	["theme_night"] = "Nuit",

	-- Default Search Bar Hint
	["searchBar_defaultHint"] = "Recherche",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Changer de thème",
	["defaultMenu_openScaling"] = "Échelle sur l'interface utilisateur",
	["defaultMenu_openLanguage"] = "Changer de langue",

	-- Customization Menu Phrases: General
	["customization_title"] = "Anpassning",
	["customization_restoreDefaultTheme"] = "Restaurer le thème par défaut",
	["customization_restoreDefaultScaling"] = "Restaurer la mise à l'échelle par défaut",
	["customization_restoreDefaultLanguage"] = "Restaurer la langue par défaut",
	["customization_defaultThemeRestored"] = "Le thème par défaut a été restauré.",
	["customization_defaultScalingRestored"] = "La mise à l'échelle par défaut a été restaurée.",
	["customization_defaultLanguageRestored"] = "La langue par défaut a été restaurée.",
	["customization_alreadyDefaultTheme"] = "Vous utilisez déjà le thème par défaut!",
	["customization_alreadyDefaultScaling"] = "Vous utilisez déjà la valeur de mise à l'échelle par défaut!",
	["customization_alreadyDefaultLanguage"] = "Vous utilisez déjà la langue par défaut!",
	["customization_themesTabName"] = "Thèmes",
	["customization_scalingTabName"] = "Balance",
	["customization_languageTabName"] = "Langue",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Palette de fond clair",
	["customization_lightBackgroundPaletteDescription"] = "Cliquez sur la roue de couleurs ci-dessous pour sélectionner un thème avec un fond clair. Une fois que vous avez sélectionné une couleur, celle-ci est appliquée immédiatement. Certains thèmes peuvent être limités à certains groupes d'utilisateurs.",
	["customization_darkBackgroundPaletteTitle"] = "Palette de fond sombre",
	["customization_darkBackgroundPaletteDescription"] = "Cliquez sur la roue de couleurs ci-dessous pour sélectionner un thème avec un fond clair. Une fois que vous avez sélectionné une couleur, celle-ci est appliquée immédiatement. Certains thèmes peuvent être limités à certains groupes d'utilisateurs.",
	["customization_themeChangedSuccessfully"] = "Votre thème a été changé avec succès en: %s",
	["customization_themeAlreadyInUse"] = "Vous utilisez déjà ce thème!",
	["customization_otherThemesTitle"] = "Autres Thèmes",
	["customization_otherThemesDescription"] = "Autres thèmes qui ne correspondent pas aux catégories ci-dessus.",
	["customization_defaultThemeButton"] = "Réinitialiser le thème",
	["customization_nightThemeButton"] = "Nuit",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "Réglage de l'échelle",
	["customization_scalingTabDescription"] = "Si vous souhaitez redimensionner votre interface utilisateur, vous pouvez le faire en réglant le curseur ci-dessous. Vous voudrez peut-être augmenter la taille de votre interface utilisateur si vous êtes loin de votre moniteur. De l'autre côté, vous pouvez réduire la taille de votre interface utilisateur si vous vous tenez près d'un grand moniteur.",
	["customization_scalingDefaultButton"] = "Réinitialiser la mise à l'échelle",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Sélection de la langue",
	["customization_languageTabDescription"] = "Ici, vous pouvez choisir votre langue préférée. Une fois sélectionné, tout le texte sera traduit directement. Si vous obtenez du texte anglais dans une langue autre que l'anglais, cela signifie que la langue n'est que partiellement traduite / prise en charge.",
	["customization_languageSuccessfullyChanged"] = "Votre langue a été changée avec succès en: %s",
	["customization_languageAlreadyInUse"] = "Vous utilisez déjà cette langue!",

	-- Dialogs
	["dialog_confirm"] = "CONFIRMER",
	["dialog_cancel"] = "ANNULER",
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
