--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	messages.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

if(SERVER) then
	util.AddNetworkString("slib_msg")
	function SLib.Messages.Send(ply, ...)
			local lst = { }
			
			for _, v in pairs({ ..., }) do
						if(type(v) == "table") then
							lst[#lst + 1] = { v.r, v.g, v.b, }
						else
							lst[#lst + 1] = v
						end
						
			
			
			end
			
			net.Start("slib_msg")
			net.WriteTable(lst)
			net.Send(ply)
	
	end
	function SLib.Messages.SendToAll(...)
			local lst = { }
			
			for _, v in pairs({ ..., }) do
						if(type(v) == "table") then
							lst[#lst + 1] = { v.r, v.g, v.b, }
						else
							lst[#lst + 1] = v
						end
						
			
			
			end
			
			net.Start("slib_msg")
			net.WriteTable(lst)
			net.Broadcast()
	
	end

end

if(CLIENT) then
	net.Receive("slib_msg", function()
			local lst = net.ReadTable()
			local toPrint = { }
			local printToChat = false
			if(isbool(lst[1])) then
						printToChat = lst[1]
			
			end
			
			
			for _, v in pairs(lst) do
						if(not (isbool(v))) then
										if(type(v) == "table") then
											toPrint[#toPrint + 1] = Color(v[1], v[2], v[3])
										else
											toPrint[#toPrint + 1] = v
										end
										
						
						end
						
			
			
			end
			
			if(printToChat) then
				chat.AddText(unpack(toPrint))
			else
				MsgC(unpack(toPrint), "\n")
			end
			
	
	end)

end


