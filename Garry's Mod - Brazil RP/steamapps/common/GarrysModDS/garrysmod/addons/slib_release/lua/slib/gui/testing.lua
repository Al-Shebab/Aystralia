--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	testing.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

SLib.Gui.Tests = { }
if(IsValid(SLib.Gui.TestWindow)) then
	SLib.Gui.TestWindow:Remove()
end

SLib.Gui.TestWindow = nil
function SLib.Gui.AddTest(name, func)
	SLib.Gui.Tests[name] = func

end
function SLib.Gui.AddTestWindow(name, func)
	local testFunc = function()
			if(IsValid(SLib.Gui.TestWindow)) then
				SLib.Gui.TestWindow:Remove()
			end
			
			local wnd = vgui.Create("DFrame")
			SLib.Gui.TestWindow = wnd
			wnd:SetSize(500, 500)
			wnd:SetTitle("SLib GUI test - " .. name)
			wnd:Center()
			wnd:MakePopup()
			func(wnd)
	
	end
	SLib.Gui.Tests[name] = testFunc
	if(IsValid(SLib.Gui.TestWindow)) then
		testFunc()
	end
	

end
function SLib.Gui.RunTest(id)
	local func = SLib.Gui.Tests[id]
	if(not (func)) then
			print("No such test registered id " .. id)
			return
	
	end
	
	print("Running test")
	func()

end
concommand.Add("slib_guitest", function(ply, cmd, args)
	local id = args[1]
	if(not (id)) then
			print("Parameter missing")
			return
	
	end
	
	SLib.Gui.RunTest(id)

end)

