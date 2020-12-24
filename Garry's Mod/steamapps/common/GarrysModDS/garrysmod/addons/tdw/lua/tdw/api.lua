/*---------------------------------------------------------------------------
	Basic wrapper for the Steam API
---------------------------------------------------------------------------*/
local steamMeta = {}
steamMeta.__index = steamMeta
steamMeta.BaseURL = "https://api.steampowered.com/"
steamMeta.UserCache = {}


/*---------------------------------------------------------------------------
	Simplified HTTP Request making
---------------------------------------------------------------------------*/
steamMeta.HTTPRequest = function(self, url, callback)
	http.Fetch(self.BaseURL..url.."&key="..self.ApiKey, function(body)
		callback(util.JSONToTable(body))
	end, function()
		error("[TDW] Steam API Error - This shouldn't ever happen, contact Threebow via support ticket.")
	end)
end


/*---------------------------------------------------------------------------
	Ensures a SteamID is Steam64
---------------------------------------------------------------------------*/
steamMeta.FormatSteamID = function(self, steamIdOrPly)
	if(isentity(steamIdOrPly) && IsValid(steamIdOrPly) && steamIdOrPly:IsPlayer()) then
		if(!steamIdOrPly:IsBot()) then return steamIdOrPly:SteamID64() else return end
	end
	return steamIdOrPly:StartWith("STEAM_") && util.SteamIDTo64(steamIdOrPly) || steamIdOrPly
end


/*---------------------------------------------------------------------------
	Returns a table of the player's info from the Steam API
---------------------------------------------------------------------------*/
steamMeta.GetPlayerInfo = function(self, steamId, callback)
	steamId = self:FormatSteamID(steamId)
	if(!steamId) then return end

	local cached = self.UserCache[steamId]
	if(cached) then
		return callback(cached)
	end

	self:HTTPRequest("/ISteamUser/GetPlayerSummaries/v002/?steamids="..steamId, function(profile)
		local ply = profile.response.players[1]
		callback(ply)
		self.UserCache[steamId] = ply
	end)
end


/*---------------------------------------------------------------------------
	Constructor
---------------------------------------------------------------------------*/
function TDW.SteamAPI(apiKey)
	local api = {ApiKey = apiKey}
	return setmetatable(api, steamMeta)
end