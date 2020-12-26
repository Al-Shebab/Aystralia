
include("skore/client/miscellaneous.lua")
include("skore/client/colours.lua")
include("skore/client/scaling.lua")

local function updateFonts()
	include("skore/client/fonts.lua")
end
hook.Add("sKoreScaleUpdated", "sKoreUpdateFonts1", updateFonts)
hook.Add("sKoreScalingReloaded", "sKoreUpdateFonts2", updateFonts)
updateFonts()

include("skore/client/drawing.lua")
include("skore/client/vgui.lua")
include("skore/client/customizationmenu.lua")
