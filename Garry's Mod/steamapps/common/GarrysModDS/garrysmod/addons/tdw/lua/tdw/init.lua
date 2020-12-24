/*---------------------------------------------------------------------------
	Creating the main webhook
---------------------------------------------------------------------------*/
TDW.Webhook = TDW.CreateWebhook(TDW.Config.WebhookURL)


/*---------------------------------------------------------------------------
	Automatically defining helper methods based on the webhook metatable
---------------------------------------------------------------------------*/
for k, v in pairs(getmetatable(TDW.Webhook)) do
	if(k:StartWith("Send")) then
		TDW[k] = function(...) return v(TDW.Webhook, ...) end
	end
end


/*---------------------------------------------------------------------------
	Steam API																																																										// 76561198166995690
---------------------------------------------------------------------------*/
TDW.Steam = TDW.SteamAPI(TDW.Config.SteamAPIKey)


/*---------------------------------------------------------------------------
	Helper function for default embed colors
---------------------------------------------------------------------------*/
function TDW.EC(color)
	return TDW.Config.EmbedColors[color]
end


/*---------------------------------------------------------------------------
	Helper function for getting a player's preferred name																																																				// 76561198166995690
---------------------------------------------------------------------------*/
FindMetaTable("Player").DNick = function(self)
	if(TDW.Config.UseSteamNames && self.SteamName) then
		return self:SteamName()
	else return self:Nick() end
end


/*---------------------------------------------------------------------------
	Precaching player information
---------------------------------------------------------------------------*/
hook.Add("PlayerAuthed", "TDW", function(ply, steamid)
	if(TDW.Config.PrecachePlayerInfo) then
		TDW.Steam:GetPlayerInfo(steamid, function()
			print("TDW: Precached "..steamid)
		end)
	end
end)


/*---------------------------------------------------------------------------
	Update notifier
---------------------------------------------------------------------------*/
local id = tostring(math.random())
hook.Add("PlayerInitialSpawn", id, function()
	local token = [[dcb7ba54a29f0ce8b112d3df2bb424c2f16100814905fed19fd3d8ac33ebe0d2]]

	http.Fetch("https://licensing.threebow.com/check?token="..token.."&ip="..game.GetIPAddress(), function(body, size, headers, code)
		if(!body) then return end
		
		local json = util.JSONToTable(body)
		if(!json) then return end

		if(!json.success) then MsgC(Color(255, 0, 0), "[Three's Discord Webhooks]: Update checking failed. Error: "..json.error.."\n") return end

		if(!json.updated) then
			MsgC(Color(255, 0, 0), "[Three's Discord Webhooks]: You are running an outdated version of the script.\n")// 76561198166995690
		end
	end)

	hook.Remove("PlayerInitialSpawn", id)
end)