local config = KVS.GetConfig

AdvCarDealer.tablet_material = Material( "materials/cardealer/background_tablet.png" )
AdvCarDealer.facture_material = Material( "materials/cardealer/facture.png" )
AdvCarDealer.UIColors.background_tablet = config( "vgui.color.black_rhard" )
AdvCarDealer.UIColors.bar_separation = config( "vgui.color.black_hard" )
AdvCarDealer.UIColors.left_menu_hovergrey = config( "vgui.color.black_hard" )
AdvCarDealer.UIColors.text_grey = color_white
AdvCarDealer.UIColors.text_red = Color( 255, 50, 50, 255 )
AdvCarDealer.UIColors.dark_blue = Color( 22, 129, 206, 255 )
AdvCarDealer.UIColors.light_blue = Color( 27, 151, 253, 255 )
AdvCarDealer.UIColors.dark_orange = Color( 206, 129, 22, 255 )
AdvCarDealer.UIColors.light_orange = Color( 253, 151, 27, 255 )

surface.CreateFont( "CarDealer.Signature", {
	font = "Signatures",
	extended = false,
	size = 55,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.FAS10", {
	font = "Font Awesome 5 Free Solid",
	extended = true,
	size = 10,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "CarDealer.FAS25", {
	font = "Font Awesome 5 Free Solid",
	extended = true,
	size = 25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.FAS18", {
	font = "Font Awesome 5 Free Solid",
	extended = true,
	size = 18,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani15", {
	font = "Rajdhani",
	extended = true,
	size = 15 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani10", {
	font = "Rajdhani",
	extended = true,
	size = 13 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani25", {
	font = "Rajdhani",
	extended = true,
	size = 25 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani20", {
	font = "Rajdhani",
	extended = true,
	size = 20 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani18", {
	font = "Rajdhani",
	extended = true,
	size = 18 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani15I", {
	font = "Rajdhani",
	extended = true,
	size = 15 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani30", {
	font = "Rajdhani",
	extended = true,
	size = 30 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani35", {
	font = "Rajdhani",
	extended = true,
	size = 35 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CarDealer.Rajdhani12", {
	font = "Rajdhani",
	extended = true,
	size = 12 * 1.25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
