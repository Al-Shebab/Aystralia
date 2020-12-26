
/*###############################################
	TURKISH LANGUAGE FILE
#################################################

	Author(s): Wolflix (https://www.gmodstore.com/users/76561198089913075)
	

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
local languageID = "turkish" -- Case-insensitive.

local languageEnglish = "Turkish" -- How do you spell this language's name in english?
local languageNative = "Turkce" -- How do you spell this language's name in that own language?

local phrases = {
	["default_fail_message"] = "You do not have enough permission to use this theme!",

	-- Themes' name translation. Some languages cannot translate properly colors
	-- from english, if that's your case, leave it as it is.
	["theme_cyan"] = "Camgobegi",
	["theme_teal"] = "Teal",
	["theme_green"] = "Yesil",
	["theme_light_green"] = "Acik Yesil",
	["theme_lime"] = "Mikset Limonu Yesili",
	["theme_yellow"] = "Sari",
	["theme_amber"] = "Kehribar Rengi",
	["theme_orange"] = "Turuncu",
	["theme_brown"] = "Kahve Rengi",
	["theme_blue_grey"] = "Mavi-Gri",
	["theme_grey"] = "Gri",
	["theme_deep_orange"] = "Koyu Turuncu",
	["theme_red"] = "Red",
	["theme_pink"] = "Pink",
	["theme_purple"] = "Purple",
	["theme_deep_purple"] = "Deep Purple",
	["theme_indigo"] = "Civit",
	["theme_blue"] = "Mavi",
	["theme_light_blue"] = "Acik Mavi",
	["theme_cyan_dark"] = "Koyu Camgobegi",
	["theme_teal_dark"] = "Koyu Teal",
	["theme_green_dark"] = "Nefti",
	["theme_light_green_dark"] = "Acik-Koyu Yesil",
	["theme_lime_dark"] = "Koyu Misket Limonu Yesili",
	["theme_yellow_dark"] = "Koyu Sari",
	["theme_amber_dark"] = "Koyu Kehribar",
	["theme_orange_dark"] = "Koyu Turuncu",
	["theme_brown_dark"] = "Koyu Kahverengi",
	["theme_blue_grey_dark"] = "Acik-Koyu Mavi",
	["theme_grey_dark"] = "Koyu Gri",
	["theme_deep_orange_dark"] = "Derin-Koyu Turuncu",
	["theme_red_dark"] = "Koyu Kirmizi",
	["theme_pink_dark"] = "Koyu Pembe",
	["theme_purple_dark"] = "Koyu Mor",
	["theme_deep_purple_dark"] = "Derin-Koyu Mor",
	["theme_indigo_dark"] = "Koyu Civit",
	["theme_blue_dark"] = "Koyu Mavi",
	["theme_light_blue_dark"] = "Acik-Koyu Mavi",
	["theme_night"] = "Gece",

	-- Default Search Bar Hint
	["searchBar_defaultHint"] = "Ara",

	-- Default Menu Phrases
	["defaultMenu_openThemes"] = "Tema Degistir",
	["defaultMenu_openScaling"] = "Arayuz Tasarim Boyutu Yeniden Ayarla",
	["defaultMenu_openLanguage"] = "Dil Degistir",

	-- Customization Menu Phrases: General
	["customization_title"] = "Ozellestirme",
	["customization_restoreDefaultTheme"] = "Varsayilan Temayi Geri Ayarla",
	["customization_restoreDefaultScaling"] = "Varsayilan Arayuz Tasarim Boyutu Geri Ayarla",
	["customization_restoreDefaultLanguage"] = "Varsayilan Dili Geri Ayarla",
	["customization_defaultThemeRestored"] = "Varsayilan tema geri ayarlandi.",
	["customization_defaultScalingRestored"] = "Varsayilan arayuz tasarimi boyutu geri ayarlandi.",
	["customization_defaultLanguageRestored"] = "Varsayilan dil ayarlandi.",
	["customization_alreadyDefaultTheme"] = "Zaten varsayilan temayi kullaniyorsun!",
	["customization_alreadyDefaultScaling"] = "Zaten varsayilan arayuz boyutunu kullaniyorsun!",
	["customization_alreadyDefaultLanguage"] = "Zaten varsayilan dili kullaniyorsun!",
	["customization_themesTabName"] = "Temalar",
	["customization_scalingTabName"] = "Olcekleme",
	["customization_languageTabName"] = "Dil",

	-- Customization Menu Phrases: Themes Tab
	["customization_lightBackgroundPaletteTitle"] = "Acik Arkaplan Paleti",
	["customization_lightBackgroundPaletteDescription"] = "Acik Arkaplan rengi secmek istiyorsan renk tekerleginden sec. Bir renk sectigin anda, direk o renk uygulanacak. Bazi temalar ozerl gruplar icin ayrilmis olabilir.",
	["customization_darkBackgroundPaletteTitle"] = "Koyu Arkaplan Paleti",
	["customization_darkBackgroundPaletteDescription"] = "Acik Arkaplan rengi secmek istiyorsan renk tekerleginden sec. Bir renk sectigin anda, direk o renk uygulanacak. Bazi temalar ozerl gruplar icin ayrilmis olabilir.",
	["customization_themeChangedSuccessfully"] = "Tema %s olarak degistirildi",
	["customization_themeAlreadyInUse"] = "Zaten bu temayi kuulaniyorsun!",
	["customization_otherThemesTitle"] = "Diger Temalar",
	["customization_otherThemesDescription"] = "Diger temalarda kategorilere sigmayan temalar bulunur.",
	["customization_defaultThemeButton"] = "VARSAYILANA SIFIRLA",
	["customization_nightThemeButton"] = "GECE",

	-- Customization Menu Phrases: Scaling Tab
	["customization_scalingTabTitle"] = "Olcekleme",
	["customization_scalingTabDescription"] = "Kullanici arayuzunu degistirmek istiyorsaniz, buradan arayuzunuzu kucultup buyutebilirsiniz.",
	["customization_scalingDefaultButton"] = "VARSAYILANA SIFIRLA",

	-- Customization Menu Phrase: Language Tab
	["customization_languageTabTitle"] = "Dil Secimi",
	["customization_languageTabDescription"] = "Buradan kullanacaginiz dili secebilirsiniz. Secildigi anda uygulanicaktir. Unutmayin, tum yazilar cevirili degil.",
	["customization_languageSuccessfullyChanged"] = "Diliniz %s olarak ayarlandi",
	["customization_languageAlreadyInUse"] = "Zaten bu dili kullaniyorsunuz!",

	-- Dialogs
	["dialog_confirm"] = "ONAYLA",
	["dialog_cancel"] = "IPTAL ET",
	["dialog_ok"] = "TAMAM",
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