
/*###############################################
	Themes Configuration File
###############################################*/

-- Should players be able to change their theme? Or forced to use the defaults?
sKore.config["allowThemeSelection"] = true

-- How should the theme console variable be named?
--
-- This setting defines the name of the theme console variable. This has no
-- direct impact on the addon's behavior. You shouldn't need to change this
-- unless you have a special reason to.
--
-- WARNING: This setting cannot be a name of an already existing console command
-- or console variable. The addon will break silently if it is.
sKore.config["themeConvar"] = "skore_theme"

-- What chat command(s) should open the theme selection menu?
--
-- This setting defines the chat command(s) that open the theme selection
-- menu. Obviously, this setting has no effect if theme selection is not
-- enabled. If you wish to disable the chat command(s) for this menu, leave the
-- table empty.
sKore.config["themeSelectionMenuChat"] = {
	"/customization", "!customization", "/customizationmenu", "!customizationmenu",
	"/changecolor", "!changecolor", "/changecolors", "!changecolors",
	"/setcolors", "!setcolors", "/color", "!color", "/colors", "!colors",
	"/theme", "!theme", "/themes", "!themes", "/changetheme", "!changetheme",
	"/settheme", "!settheme", "/colour", "!colour", "/colours", "!colours",
	"/changecolour", "!changecolour", "/changecolours", "!changecolours"
}

-- What console command(s) should open the theme selection menu?
--
-- This setting defines the console command(s) that open the theme selection
-- menu. Obviously, this setting has no effect if theme selection is not
-- enabled. If you wish to disable the console command(s) for this menu, leave
-- the table empty.
sKore.config["themeSelectionMenuConsole"] = {
	"skore_customizationmenu"
}

-- What should be the default themes? Please remind that, if the
-- theme selection is disabled then players will be forced to use the default
-- theme.
--
-- This setting support setting up different default themes depending on the
-- players' user group. User groups and colour names are case-sensitive!
sKore.config["defaultThemes"] = {
	["default"] = "Red", -- The default theme.
	["donator"] = "Orange", -- Overwrites the default theme for the 'donator' user group.
	["superadmin"] = "Indigo", -- Overwrites the default theme for the 'superadmin' user group.
}

-- In the theme selection menu, what colours should be in the light background
-- colour wheel? A message will be shown to players that try to select a colour
-- that they don't have enough permisison to use.
--
-- WARNING: Colour names are case-sensitive.
sKore.config["lightThemeWheel"] = {
	"Cyan", "Teal", "Green", "Light Green", "Lime", "Yellow", "Amber", "Orange",
	"Brown", "Blue Grey", "Grey", "Deep Orange", "Red", "Pink", "Purple",
	"Deep Purple", "Indigo", "Blue", "Light Blue",
}

-- In the theme selection menu, what colours should be in the dark background
-- colour wheel? A message will be shown to players that try to select a colour
-- that they don't have enough permisison to use.
--
-- WARNING: Colour names are case-sensitive.
sKore.config["darkThemeWheel"] = {
	"Cyan Dark", "Teal Dark", "Green Dark", "Light Green Dark", "Lime Dark",
	"Yellow Dark", "Amber Dark", "Orange Dark", "Brown Dark", "Blue Grey Dark",
	"Grey Dark", "Deep Orange Dark", "Red Dark", "Pink Dark", "Purple Dark",
	"Deep Purple Dark", "Indigo Dark", "Blue Dark", "Light Blue Dark",
}



/*###############################################
	Themes
#################################################

	Deleting, editing or creating themes is more complex. If you don't have
	basic knowledge of Gmod Lua then I wouldn't suggest modifying the themes.
	If you need help, create a ticket on GmodStore, please be as clear as you
	can and explain everything with much detail as needed.

	NOTE: Fail messages prefixed with '#' indicate a language item and will be
	replaced by the full text corresponding to the active language.

*/

local red = sKore.Theme("Red")
--red:SetBackgroundColour(sKore.LIGHT)
--red:SetBackgroundColour(sKore.DARK)
red:SetPrimaryColours("#D32F2F", "#F44336", "#FFCDD2")
red:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)
--red:RestrictToUsergroups("donator", "admin", "superadmin")
--red:SetFailMessage("#default_fail_message")

local pink = sKore.Theme("Pink")
pink:SetPrimaryColours("#C2185B", "#E91E63", "#F8BBD0")
pink:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local purple = sKore.Theme("Purple")
purple:SetPrimaryColours("#7B1FA2", "#9C27B0", "#E1BEE7")
purple:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local deepPurple = sKore.Theme("Deep Purple")
deepPurple:SetPrimaryColours("#512DA8", "#673AB7", "#D1C4E9")
deepPurple:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local indigo = sKore.Theme("Indigo")
indigo:SetPrimaryColours("#303F9F", "#3F51B5", "#C5CAE9")
indigo:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local blue = sKore.Theme("Blue")
blue:SetPrimaryColours("#1976D2", "#2196F3", "#BBDEFB")
blue:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local lightBlue = sKore.Theme("Light Blue")
lightBlue:SetPrimaryColours("#0288D1", "#03A9F4", "#B3E5FC")
lightBlue:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local cyan = sKore.Theme("Cyan")
cyan:SetPrimaryColours("#0097A7", "#00BCD4", "#B2EBF2")
cyan:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local teal = sKore.Theme("Teal")
teal:SetPrimaryColours("#00796B", "#009688", "#B2DFDB")
teal:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local green = sKore.Theme("Green")
green:SetPrimaryColours("#388E3C", "#4CAF50", "#C8E6C9")
green:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local lightGreen = sKore.Theme("Light Green")
lightGreen:SetPrimaryColours("#689F38", "#8BC34A", "#DCEDC8")
lightGreen:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local lime = sKore.Theme("Lime")
lime:SetPrimaryColours("#AFB42B", "#CDDC39", "#F0F4C3")
lime:SetPrimaryTextColours(sKore.DARK, sKore.DARK, sKore.DARK)

local yellow = sKore.Theme("Yellow")
yellow:SetPrimaryColours("#FBC02D", "#FFEB3B", "#FFF9C4")
yellow:SetPrimaryTextColours(sKore.DARK, sKore.DARK, sKore.DARK)

local amber = sKore.Theme("Amber")
amber:SetPrimaryColours("#FFA000", "#FFC107", "#FFECB3")
amber:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local orange = sKore.Theme("Orange")
orange:SetPrimaryColours("#F57C00", "#FF9800", "#FFE0B2")
orange:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local deepOrange = sKore.Theme("Deep Orange")
deepOrange:SetPrimaryColours("#E64A19", "#FF5722", "#FFCCBC")
deepOrange:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local brown = sKore.Theme("Brown")
brown:SetPrimaryColours("#5D4037", "#795548", "#D7CCC8")
brown:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local grey = sKore.Theme("Grey")
grey:SetPrimaryColours("#616161", "#9E9E9E", "#F5F5F5")
grey:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local blueGrey = sKore.Theme("Blue Grey")
blueGrey:SetPrimaryColours("#455A64", "#607D8B", "#CFD8DC")
blueGrey:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local redDark = sKore.Theme("Red Dark")
redDark:SetBackgroundColour(sKore.DARK)
redDark:SetPrimaryColours("#8C251D", "#A62C23", "#FF8880")
redDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local pinkDark = sKore.Theme("Pink Dark")
pinkDark:SetBackgroundColour(sKore.DARK)
pinkDark:SetPrimaryColours("#8C123B", "#A61646", "#FF88AA")
pinkDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local purpleDark = sKore.Theme("Purple Dark")
purpleDark:SetBackgroundColour(sKore.DARK)
purpleDark:SetPrimaryColours("#7C1F8C", "#9224A6", "#EC80FF")
purpleDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local deepPurpleDark = sKore.Theme("Deep Purple Dark")
deepPurpleDark:SetBackgroundColour(sKore.DARK)
deepPurpleDark:SetPrimaryColours("#502D8C", "#5E35A6", "#AE80FF")
deepPurpleDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local indigoDark = sKore.Theme("Indigo Dark")
indigoDark:SetBackgroundColour(sKore.DARK)
indigoDark:SetPrimaryColours("#313F8C", "#3A4AA6", "#8093FF")
indigoDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local blueDark = sKore.Theme("Blue Dark")
blueDark:SetBackgroundColour(sKore.DARK)
blueDark:SetPrimaryColours("#14568C", "#1766A6", "#80C6FF")
blueDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local lightBlueDark = sKore.Theme("Light Blue Dark")
lightBlueDark:SetBackgroundColour(sKore.DARK)
lightBlueDark:SetPrimaryColours("#01608C", "#0272A6", "#80D7FF")
lightBlueDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local cyanDark = sKore.Theme("Cyan Dark")
cyanDark:SetBackgroundColour(sKore.DARK)
cyanDark:SetPrimaryColours("#007C8C", "#0092A6", "#00E1FF")
cyanDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local tealDark = sKore.Theme("Teal Dark")
tealDark:SetBackgroundColour(sKore.DARK)
tealDark:SetPrimaryColours("#008C7E", "#00A695", "#80FFF2")
tealDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local greenDark = sKore.Theme("Green Dark")
greenDark:SetBackgroundColour(sKore.DARK)
greenDark:SetPrimaryColours("#3C8C3F", "#47A64A", "#80FF84")
greenDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local lightGreenDark = sKore.Theme("Light Green Dark")
lightGreenDark:SetBackgroundColour(sKore.DARK)
lightGreenDark:SetPrimaryColours("#648C35", "#76A63F", "#C3FF80")
lightGreenDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local limeDark = sKore.Theme("Lime Dark")
limeDark:SetBackgroundColour(sKore.DARK)
limeDark:SetPrimaryColours("#828C24", "#99A62B", "#F2FF80")
limeDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local yellowDark = sKore.Theme("Yellow Dark")
yellowDark:SetBackgroundColour(sKore.DARK)
yellowDark:SetPrimaryColours("#8C8120", "#A69926", "#FFF280")
yellowDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local amberDark = sKore.Theme("Amber Dark")
amberDark:SetBackgroundColour(sKore.DARK)
amberDark:SetPrimaryColours("#8C6A04", "#A67E05", "#FFDF80")
amberDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local orangeDark = sKore.Theme("Orange Dark")
orangeDark:SetBackgroundColour(sKore.DARK)
orangeDark:SetPrimaryColours("#8C5400", "#A66300", "#FFCC80")
orangeDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local deepOrangeDark = sKore.Theme("Deep Orange Dark")
deepOrangeDark:SetBackgroundColour(sKore.DARK)
deepOrangeDark:SetPrimaryColours("#8C2F12", "#A63716", "#FF9D80")
deepOrangeDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local brownDark = sKore.Theme("Brown Dark")
brownDark:SetBackgroundColour(sKore.DARK)
brownDark:SetPrimaryColours("#4D362E", "#66483D", "#FFC7B3")
brownDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local greyDark = sKore.Theme("Grey Dark")
greyDark:SetBackgroundColour(sKore.DARK)
greyDark:SetPrimaryColours("#494949", "#757575", "#a4a4a4")
greyDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local blueGreyDark = sKore.Theme("Blue Grey Dark")
blueGreyDark:SetBackgroundColour(sKore.DARK)
blueGreyDark:SetPrimaryColours("#35454D", "#465B66", "#B3E5FF")
blueGreyDark:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)

local night = sKore.Theme("Night")
night:SetBackgroundColour(sKore.DARK)
night:SetPrimaryColours("#000000", "#212121", "#484848")
night:SetPrimaryTextColours(sKore.LIGHT, sKore.LIGHT, sKore.LIGHT)



sKore.reloadThemes() -- Ignore this line.
