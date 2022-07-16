------------
/* FONTS  */
------------
-- All fonts are automatically added from the resource/efonts folder

local defaultfont = "Amsterdam" --This is not the name of the FILE but the name of the FONT

-- do not change this
local fontname = "emenu"
local function Font(size,weight,fontfamily)
	local name = fontname .. "_" .. size .. "_" .. weight
	surface.CreateFont(name, {
		font = fontfamily or defaultfont,
		size = size,
		weight = (weight or 500),
		extended = true
	})
end


----------------------
/// CREATING FONTS ///
----------------------
--12
Font(12,500) -- emenu_12_500

--14
Font(14,500)

--16
Font(16,500)
Font(16,1000)

--18
Font(18,500)

--20
Font(20,500)

--22
Font(22,500)

--24
Font(24,500)
Font(24,1000)

--26
Font(26,500)

--30
Font(30,500)
Font(30,1000)

--60
Font(60,500)
