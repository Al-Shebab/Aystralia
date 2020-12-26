local addon = "parmory"

xGMod = xGMod or {}
xGMod.GMS = xGMod.GMS or {}
xGMod.GMS[addon] = xGMod.GMS[addon] or {}

if SERVER then
	resource.AddWorkshop("1165526642")
	AddCSLuaFile(addon .. "/config.lua")
end

include(addon .. "/config.lua")

xGMod.Unicode = xGMod.Unicode or function(a)
	local a1, a2, a3, a4 = a:byte(1, -1)
	
	local s = string.format("%%%02X", a1)
	
	local n = a2
	if n then
		s = s .. string.format("%%%02X", n)
	end
	
	n = a3
	if n then
		s = s .. string.format("%%%02X", n)
	end
	
	n = a4
	if n then
		s = s .. string.format("%%%02X", n)
	end
	
	return s
end

xGMod.Encode = xGMod.Encode or function(s)
	if s then
		s = string.gsub(s, "([^%w ])", xGMod.Unicode)
		s = string.gsub(s, " ", "+")
	end
	
	return s
end

xGMod.Types = xGMod.Types or {
	["ERROR"] = Color(255, 0, 0),
	["NOTIFICATION"] = Color(0, 255, 0)
}

if SERVER then
	util.AddNetworkString("xGMod::ChatPrint")
else
	net.Receive("xGMod::ChatPrint", function()
		chat.AddText(xGMod.Types[net.ReadString()], "xGMod ", net.ReadString())
	end)
end

xGMod.Print = xGMod.Print or function(type, message)
	MsgC(xGMod.Types[type], "xGMod ", message, "\n")
end

xGMod.PrintChat = xGMod.PrintChat or function(type, message, players)
	if CLIENT then
		chat.AddText(xGMod.Types[type], "xGMod ", message)
		
		return
	end
	
	net.Start("xGMod::ChatPrint")
		net.WriteString(type)
		net.WriteString(message)
	net.Send(players)
end

if SERVER then
	AddCSLuaFile(addon .. "/xgmod/client.lua")
	
	include(addon .. "/xgmod/info.lua")
	include(addon .. "/xgmod/server.lua")
else
	include(addon .. "/xgmod/client.lua")
end
