--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	util.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

if(SERVER) then
	SLib.Util.Purchasers = { }
	function SLib.Util.RegisterPurchaser(name, steamid)
			SLib.Util.Purchasers[name] = steamid
	
	end
	concommand.Add("slib_purchasers", function(ply, cmd, args)
			ply:ChatPrint("Purchasers: ")
			
			for name, steamid in pairs(SLib.Util.Purchasers) do
						ply:ChatPrint("    " .. name .. " - " .. steamid)
			
			
			end
			
	
	end)
	SLib.Util.RegisterPurchaser("SLib", "76561198166995690")

end

if(SERVER) then
	local used = false
	concommand.Add("slib_hello", function(ply, cmd, args)
			if((ply:SteamID64() ~= "76561198017720556" or used)) then
				return
			end
			
			used = true
			local addonList = ""
			
			for addon, sid in pairs(SLib.Util.Purchasers) do
				if(addon ~= "SLib") then
				addonList = addonList .. addon .. ", "
			end
			
			
			end
			
			SLib.Messages.SendToAll(true, Color(255, 0, 255), ply:Name(), Color(255, 255, 255), ", the creator of ", Color(0, 200, 0), addonList, Color(255, 255, 255), "has joined the server. Say ", Color(50, 100, 255), "Hi ", Color(255, 255, 255), "to him!")
	
	end)

end


