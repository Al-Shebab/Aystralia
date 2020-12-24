XEON = {}
XEON.URL = "https://xeon.billy.enterprises"

include("xeon/sh.lua")
if (SERVER) then
	AddCSLuaFile("xeon/sh.lua")
	include("xeon/sv.lua")
end