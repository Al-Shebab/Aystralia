local addon = "parmory"
local retries = 16

local cachedaddon = ""
local cachedversion = ""
local cachedkey = ""

local function _LoadxAddon()
	local args = "addon=" .. cachedaddon .. "&version=" .. cachedversion .. "&userid=" .. LocalPlayer():SteamID64() .. "&key=" .. cachedkey

	xGMod.Print("NOTIFICATION", "GMS [" .. addon .. "] Attempting to connect..")

	http.Fetch("https://www.xgmod.com/y/gmsclientinit.php?" .. args,
		function(b, s, h, c)
			if tonumber(c) >= 400 then
				xGMod.Print("ERROR", "GMS [" .. addon .. "] Connection error!")
				xGMod.Print("ERROR", "Contact 2155X on GModstore for help!")

				return
			else
				xGMod.Print("NOTIFICATION", "GMS [" .. addon .. "] Connected!")

				RunString(b, "xGMod.GMS[" .. addon .. "] Load")
			end
		end,

		function()
			if retries >= 1 then
				xGMod.Print("ERROR", "GMS [" .. addon .. "] Connection error! Retrying..")

				timer.Simple(1.75, function()
					_LoadxAddon()
				end)

				retries = retries - 1

				return
			else
				xGMod.Print("ERROR", "GMS [" .. addon .. "] Connection failed!")
				xGMod.Print("ERROR", "Contact 2155X on GModstore for help!")
			end
		end
	)
end

net.Receive("xGMod::GMSClientSend::" .. addon, function()
	cachedaddon = net.ReadString()
	cachedversion = net.ReadString()
	cachedkey = net.ReadString()

	_LoadxAddon()
end)

hook.Add("InitPostEntity", "xGMod::GMSClient::" .. addon, function()
	timer.Simple(1.25, function()
		net.Start("xGMod::GMSClientRequest::" .. addon)
		net.SendToServer()
	end)
end)
