--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	blur.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

local blurMaterial = Material("pp/blurscreen")
function SLib.Gui.DrawBlurFullscreen(layers, density, alpha)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blurMaterial)
	
	local i = 1
	while i <= layers do
			blurMaterial:SetFloat("$blur", (i / layers) * density)
			blurMaterial:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	
	
	i = i + 1
	end
	

end
function SLib.Gui.DrawBlurRect(x, y, w, h, layers, density, alpha)
	cam.Start2D()
	render.SetScissorRect(x, y, x + w, y + h, true)
	SLib.Gui.DrawBlurFullscreen(layers, density, alpha)
	render.SetScissorRect(0, 0, 0, 0, false)
	cam.End2D()

end

