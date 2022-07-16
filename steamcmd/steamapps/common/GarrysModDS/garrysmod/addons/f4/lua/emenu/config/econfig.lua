emenu.config = {}
local cfg = emenu.config

------------------------
/// MAIN CONFIG FILE ///
------------------------
--The file with translations is on the path: emenu/lua/emenu/config/elangs.lua

/// GENERAL ///
cfg.language = "english"   -- russian / english / german / french / turkish / polish
cfg.tag = "[EMENU]" 	   -- In chat / console
cfg.animtime = 0.2 		   -- DEFAULT: 0.2  | Animation speed (in seconds) lower - faster
cfg.greettime = 1   	   -- DEFAULT: 1    | Time (in seconds) that the start message will show
cfg.hide_other = true 	   -- DEFAULT: true | If true, then other tabs are minimized when opened
cfg.override_notify = true -- DEFAULT: true | Overwrites the gm:AddNotify function for a more comfortable experience. If notify starts to behave strangely, change this parameter to false
cfg.hide_jobchange  = true -- DEFAULT: true | Hides the panel with jobs if a new profession is taken

/// EFFECTS SETTINGS ///
cfg.effect          = "dots" 	-- "dots" / "snow" / false current available
cfg.effectPhysics   = true 		-- DEFAULT: true | Eats ~10-20 fps
cfg.effect_speed    = 1 		-- DEFAULT: 1    | Particle speed
cfg.blurStrength 	= 0			-- DEFAULT: 0    | Blur the background 0 for disable

/// FPS SMOOTHING ///
--(effect_fps_suspension) With a small number of fps, it will decrease the number of particles, and with a large number, it will increase
cfg.effect_fps_suspension = true     	-- DEFAULT: true
cfg.dots_amount = {min = 20, max = 110} -- DEFAULT: min = 20, max = 150
cfg.snow_amount = {min = 40, max = 200} -- DEFAULT: min = 40, max = 200


-----------------
/// AUTO OPEN ///
-----------------
-- Use names according to the language file (emenu/lua/emenu/config/elangs.lua)
-- That is, which have already been translated!
cfg.auto_open = {
	--For example, for english language:
	--["Jobs"] = true,
	--For french:
	--["Metiers"] = true,
	--etc...
}

-------------
/// LINKS ///
-------------
--[[ Adding new:
{
	name = "Name", -- Name displayed under the icon
	helptext = "...", -- Text on hover
	type = "link", -- (OPTIONAL "link" - default) link or browser | Link will open the link. Browser will create a window
	icon = "icon_url_here", -- "icon url" or Material("path") Discord and Steam icons already downloaded. To use it, paste that: icon = emenu.Materials["discord"] or icon = emenu.Materials["steam"]
	keyboardinput = true, -- (OPTIONAL) Used by the browser only. If true, then the window will be able to accept keyboard input (only works with the browser)
	url = "any_url_here", -- the link that should open when clicked
},
--]]
cfg.links = {
	{
		name = "Discord",
		helptext = "Join our discord server!", -- text on hover
		type = "link", -- link / browser
		icon = emenu.Materials["discord"],--"https://discord.com/assets/3437c10597c1526c3dbd98c737c2bcae.svg", -- Material / iconlink
		url = "https://google.com", -- url to open
	},
	{
		name = "Steam",
		helptext = "Join our steam group!",
		type = "link",
		icon = emenu.Materials["steam"],
		keyboardinput = false,
		url = "https://google.com",
	},
}


--------------
/// COLORS ///
--------------
emenu.colors = emenu.colors or {}
local clr = emenu.colors
clr.default = {
	red = Color(252, 29, 59),
	white = Color(255,255,255),
	black = Color(13,13,13),
	green = Color(30, 215, 96),
	orange = Color(255, 117, 23),
}
-- ^ Don't change these colors from above ^

--TEXT COLORS
clr.text = {
	dark = Color(13,13,13),
	white = Color(227, 233, 245),
	darken = Color(150, 153, 155),
	hover = Color(30, 215, 96),
	shadow = Color(13,13,13),
}

--MAIN COLORS
clr.main = {
	bg = Color(13,13,26,200),

	main = Color(0, 0, 0, 120),
	
	icon = Color(227, 233, 245),
	iconhover = Color(30, 215, 96),
}

--ADDON WINDOWS
clr.windows = {
	bg = Color(24, 24, 28, 240),
	accent = Color(50, 50, 52),

	text = Color(255,255,255),

	active = Color(30, 215, 96),
	notactive = Color(151, 26, 52),
}

--CONTEXT MENU
clr.context = {
	bg = Color(24, 24, 24, 0),
	separator = Color(58,58,70),

	header = Color(32,32,34),
	headertext = Color(245,245,255),

	button = Color(24, 25, 28),
	buttonhover = Color(48,48,50),

	text = Color(155,155,155),
	texthover = Color(245,245,255),
}

--NOTIFY
clr.notify = {
	bg = Color(28, 28, 30, 254),
	text = Color(255,255,255),

	--Hover text info 
	hoverbg = Color(24, 24, 26, 200),
}

/// TABS ///
--SHOP
emenu.colors.shop = {
	itembg = Color(50, 50, 52),
	itembg_hover = Color(60, 60, 62),

	text = Color(235,235,235),
	text2 = Color(205,205,205),

	favorite = Color(252, 29, 59),
}

--JOBS
emenu.colors.jobs = {
	bgjob = Color(20, 20, 28, 150),
	bghover = Color(50, 50, 58,150),
	jobselbg = Color(24, 24, 28),
	jobselbg2 = Color(38,38,42,250),

	become = Color(40,40,44),

	text = Color(255,255,255),
	text2 = Color(150,150,155),
	texthover = Color(30, 215, 96),

	favorite = Color(252, 29, 59),
	texturecol = Color(100,50,60,150),
}

--QUICK ACTIONS
emenu.colors.quickpanel = {
    bg = Color(24, 24, 26, 200),
    text = Color(255, 255, 255),
}