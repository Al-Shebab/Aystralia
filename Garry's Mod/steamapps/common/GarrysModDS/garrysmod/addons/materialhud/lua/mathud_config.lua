/*-----------------------------------------------------------
	Material HUD
	
	Copyright © 2016-2019 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
-------------------------------------------------------------*/

MHUDConfig = { }
local Config = MHUDConfig

/*----------------------------------------------
	Material HUD Configuration

	Matching colors can be found here: http://www.google.com/design/spec/style/color.html#color-color-palette
	You can use this page to convert hex to rgb: http://www.colorhexa.com/

	To make components transparent, add fourth parameter to Color function, so it looks like this Color(red, green, blue, alpha).
	
	At the bottom, there are custom styles.
------------------------------------------------*/

Config.Blur									= false // Only when boxes are transparent
Config.BlurScale							= 4

Config.Scale = 1							// Scales the HUD for every player. The HUD is scaled automatically, so keep this as 1, unless you want it smaller for everyone.

Config.BarColor 							= Color(33, 150, 243)
Config.BgColor 								= Color(255, 255, 255)
Config.TextColor 							= Color(140, 140, 140)

Config.NameFontSize							= 24
Config.NameMargin							= 8

Config.ShowNumbers							= false // Shows numbers of health/armor/hunger
Config.HPColor1, Config.HPColor2			= Color(244, 67, 54), Color(255, 205, 210)
Config.ArmorColor1, Config.ArmorColor2		= Color(63, 81, 181), Color(197, 202, 233)
Config.HungerColor1, Config.HungerColor2	= Color(76, 175, 80), Color(200, 230, 201)

Config.MoneyColor							= Color(139, 195, 74)
Config.SalaryColor							= Color(255, 193, 7)

// For Sandbox
Config.PlayTimeColor						= Color(80, 140, 240)
Config.PropsColor							= Color(120, 200, 100)

Config.AmmoStyle							= 1												// 0 - ammo bar and text, 1 - only text
Config.AmmoColor1, Config.AmmoColor2		= Color(103, 58, 183), Color(209, 196, 233)

Config.EntHPColor1, Config.EntHPColor2		= Color(213, 0, 0), Color(255, 138, 128, 150)
Config.SpeakColor							= Color(255, 255, 255)
Config.SpeakColor							= Color(255, 255, 255, 170)

Config.HeadHUD								= true

// Example of a custom style (uncomment to enable)
/*
Config.BarColor 							= Color(0, 191, 165)
Config.BgColor 								= Color(66, 66, 66)
Config.TextColor 							= Color(240, 240, 240)

Config.HPColor1, Config.HPColor2			= Color(213, 0, 0), Color(255, 138, 128)
Config.ArmorColor1, Config.ArmorColor2		= Color(48, 79, 254), Color(140, 158, 255)
Config.HungerColor1, Config.HungerColor2	= Color(76, 175, 80), Color(200, 230, 201)

Config.MoneyColor							= Color(100, 221, 23)
Config.SalaryColor							= Color(255, 171, 0)

Config.PlayTimeColor						= Color(80, 140, 240)
Config.PropsColor							= Color(120, 200, 100)

Config.AmmoStyle							= 1
Config.AmmoColor1, Config.AmmoColor2		= Color(103, 58, 183), Color(209, 196, 233)
*/


// Blur
/*
Config.Blur									= true
Config.BlurScale							= 4

Config.BarColor 							= Color(33, 150, 243, 200)
Config.BgColor 								= Color(255, 255, 255, 40)

Config.TextColor 							= Color(50, 50, 50)

Config.HPColor1, Config.HPColor2			= Color(200, 0, 0), Color(140, 20, 20)
Config.ArmorColor1, Config.ArmorColor2		= Color(28, 39, 200), Color(70, 90, 180)
Config.HungerColor1, Config.HungerColor2	= Color(26, 195, 20), Color(100, 130, 101)

Config.MoneyColor							= Color(50, 211, 63)
Config.SalaryColor							= Color(255, 171, 0)

Config.PlayTimeColor						= Color(30, 70, 180)
Config.PropsColor							= Color(30, 140, 30)
*/


// Blur 2
/*
Config.Blur									= true
Config.BlurScale							= 4

Config.BarColor 							= Color(33, 150, 243, 150)
Config.BgColor 								= Color(0, 0, 0, 140)

Config.TextColor 							= Color(230, 230, 230)

Config.HPColor1, Config.HPColor2			= Color(213, 0, 0), Color(255, 138, 128)
Config.ArmorColor1, Config.ArmorColor2		= Color(48, 79, 254), Color(140, 158, 255)
Config.HungerColor1, Config.HungerColor2	= Color(76, 175, 80), Color(200, 230, 201)

Config.MoneyColor							= Color(100, 221, 23)
Config.SalaryColor							= Color(255, 171, 0)

Config.PlayTimeColor						= Color(80, 140, 240)
Config.PropsColor							= Color(120, 200, 100)
*/