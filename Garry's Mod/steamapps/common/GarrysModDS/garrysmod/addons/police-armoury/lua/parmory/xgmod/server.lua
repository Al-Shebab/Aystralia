local addon = "parmory"
local retries = 16

xGMod.Print("NOTIFICATION", "GMS [" .. addon .. "] Waiting for players..")

xGMod.GMS[addon].Load = function()
	local license = xGMod.GMS[addon].License

	local serverip = string.Explode(":", game.GetIPAddress())[1]
	local serverport = GetConVar("hostport"):GetString()

	local hostname = xGMod.Encode(GetHostName())

	local args = "addon=" .. license.addon .. "&version=" .. license.version .. "&userid=" .. license.userid .. "&useridh=" .. license.useridh .. "&hostname=" .. hostname .. "&serverip=" .. serverip .. "&serverport=" .. serverport

	xGMod.Print("NOTIFICATION", "GMS [" .. addon .. "] Attempting to connect..")

	http.Fetch("https://www.xgmod.com/y/gmsload.php?" .. args,
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
					xGMod.GMS[addon].Load()
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
timer.Simple(1.75, xGMod.GMS[addon].Load)
