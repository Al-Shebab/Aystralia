-- 76561198166995690
if SERVER or IsValid(LocalPlayer()) then
	include("skore/shared/init.lua")
else
	hook.Add("InitPostEntity", "sKoreInitialize", function()
		include("skore/shared/init.lua")
	end)
end
