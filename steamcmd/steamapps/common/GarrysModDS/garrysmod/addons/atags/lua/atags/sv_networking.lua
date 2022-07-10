-- User Tags
util.AddNetworkString("ATAG_SelectUserTags")
util.AddNetworkString("ATAG_GetUserTags")
util.AddNetworkString("ATAG_SendUserTags")

net.Receive("ATAG_SelectUserTags", function(len, ply)
	
	local TagID = net.ReadString()
	local Type = net.ReadString()
	
	ATAG.SelectUserTag(ply, TagID, Type)
	ply:updateScoreboardTag()
	
	-- Send this player's tags to all other players.
	for _, _player in pairs( player.GetAll() ) do
		
		_player:sendChatTag( ply )
		_player:sendScoreboardTag( ply )
		
	end
	
end)

net.Receive("ATAG_GetUserTags", function(len, ply)
	ATAG.SendUserTags(ply)
end)

function ATAG.SendUserTags(ply)

	local SB_CST = nil
	local CH_CST = nil

	local PlayerTags = table.Copy(ATAG.PlayerTags[2][ply:SteamID()])
	
	SB_CST = ATAG.SB_GetOwnTag(ply)
	
	if PlayerTags then
		for k, v in pairs(PlayerTags.Etags) do
			for n, t in pairs(ATAG.Tags.Tags) do
				if tonumber(t[1]) == tonumber(v) then
					PlayerTags.Etags[k] = t
				end
			end
		end
	end
	
	local RankTags = table.Copy(ATAG.RankTags[2][ATAG:GetUserGroup( ply )])
	
	if RankTags then
		for k, v in pairs(RankTags.Etags) do
			for n, t in pairs(ATAG.Tags.Tags) do
				if tonumber(t[1]) == tonumber(v) then
					RankTags.Etags[k] = t
				end
			end
		end
	end
	
	local Tags = {}
	
	Tags.PTags = PlayerTags or nil
	Tags.RTags = RankTags or nil
	
	Tags.SB_CST = SB_CST or nil
	Tags.CH_CST = CH_CST or nil
	
	net.Start("ATAG_SendUserTags")
		net.WriteTable(Tags)
	net.Send(ply)
end




util.AddNetworkString("ATAG_Scoreboard_SetOwnTag")

net.Receive("ATAG_Scoreboard_SetOwnTag", function(len, ply)
	local Name = net.ReadString()
	local color = net.ReadTable()
	ATAG.SB_SetOwnTag(ply, Name, color)
end)



-- Tags
util.AddNetworkString("ATAG_Tags_GetTags")
util.AddNetworkString("ATAG_Tags_SendTags")

net.Receive("ATAG_Tags_GetTags", function(len, ply)
	if not ATAG:HasPermissions(ply) then return end
	ATAG.SendTagData(ply)
end)

function ATAG.SendTagData(ply)
	net.Start("ATAG_Tags_SendTags")
		net.WriteTable(ATAG.Tags.Tags)
	net.Send(ply)
end

util.AddNetworkString("ATAG_Tags_AddTag")
util.AddNetworkString("ATAG_Tags_RemoveTag")
util.AddNetworkString("ATAG_Tags_EditTag")

net.Receive("ATAG_Tags_AddTag", function(len, ply)
	local name = net.ReadString()
	local color = net.ReadTable()
	color = Color(color[1], color[2], color[3])
	
	ATAG.AddTag(ply, name, color)
end)

net.Receive("ATAG_Tags_EditTag", function(len, ply)
	local ID = net.ReadString()
	local name = net.ReadString()
	local color = net.ReadTable()
	color = Color(color[1], color[2], color[3])
	
	ATAG.EditTag(ply, ID, name, color)
end)

net.Receive("ATAG_Tags_RemoveTag", function(len, ply)
	local ID = net.ReadString()
	ATAG.RemoveTag(ply, ID)
end)




-- Scoreboard Tags
util.AddNetworkString("ATAG_Scoreboard_ToggleCanSetOwnTag")

net.Receive("ATAG_Scoreboard_ToggleCanSetOwnTag", function(len, ply)
	local Type = net.ReadString()
	local Value = net.ReadString()
	
	ATAG.SB_ToggleCanSetOwnTag(ply, Type, Value)
end)


util.AddNetworkString("ATAG_Scoreboard_SetAutoAssignedTag_rank")

net.Receive("ATAG_Scoreboard_SetAutoAssignedTag_rank", function(len, ply)
	local Rank = net.ReadString()
	local TagID = net.ReadString()
	local Type = net.ReadString()
	
	ATAG.SB_SetAutoAssignedTag_rank(ply, Rank, TagID, Type)
end)


-- PLAYERS
util.AddNetworkString("ATAG_Scoreboard_GetPlayers")
util.AddNetworkString("ATAG_Scoreboard_SendPlayers")

net.Receive("ATAG_Scoreboard_GetPlayers", function(len, ply)
	ATAG.SB_SendPlayers(ply)
end)

function ATAG.SB_SendPlayers(ply)
	net.Start("ATAG_Scoreboard_SendPlayers")
		net.WriteTable(ATAG.SB_GetPlayers(ply))
	net.Send(ply)
end

util.AddNetworkString("ATAG_Scoreboard_AddPlayer")
util.AddNetworkString("ATAG_Scoreboard_RemovePlayer")
util.AddNetworkString("ATAG_Scoreboard_ChangePlayerName")

net.Receive("ATAG_Scoreboard_AddPlayer", function(len, ply)
	local SteamID = net.ReadString()
	ATAG.SB_AddPlayer(ply, SteamID)
end)

net.Receive("ATAG_Scoreboard_RemovePlayer", function(len, ply)
	local SteamID = net.ReadString()
	ATAG.SB_RemovePlayer(ply, SteamID)
end)

net.Receive("ATAG_Scoreboard_ChangePlayerName", function(len, ply)
	local SteamID = net.ReadString()
	local Name = net.ReadString()
	if Name == "\nil" then Name = nil end
	
	ATAG.SB_ChangePlayerName(ply, SteamID, Name)
end)

-- Send Tags
util.AddNetworkString("ATAG_Scoreboard_GetTags_player")
util.AddNetworkString("ATAG_Scoreboard_SendTags_player")

net.Receive("ATAG_Scoreboard_GetTags_player", function(len, ply)
	if not ATAG:HasPermissions(ply) then return end
	
	local SteamID = net.ReadString()
	ATAG.SB_SendTags_player(ply, SteamID)
end)

function ATAG.SB_SendTags_player(ply, SteamID)
	net.Start("ATAG_Scoreboard_SendTags_player")
		net.WriteTable(ATAG.SB_GetTags_player(ply, SteamID))
	net.Send(ply)
end


-- RANKS
util.AddNetworkString("ATAG_Scoreboard_GetRanks")
util.AddNetworkString("ATAG_Scoreboard_SendRanks")

net.Receive("ATAG_Scoreboard_GetRanks", function(len, ply)
	ATAG.SB_SendRanks(ply)
end)

function ATAG.SB_SendRanks(ply)
	net.Start("ATAG_Scoreboard_SendRanks")
		net.WriteTable(ATAG.SB_GetRanks(ply))
	net.Send(ply)
end

util.AddNetworkString("ATAG_Scoreboard_AddRank")
util.AddNetworkString("ATAG_Scoreboard_RemoveRank")

net.Receive("ATAG_Scoreboard_AddRank", function(len, ply)
	local Rank = net.ReadString()
	ATAG.SB_AddRank(ply, Rank)
end)

net.Receive("ATAG_Scoreboard_RemoveRank", function(len, ply)
	local Rank = net.ReadString()
	ATAG.SB_RemoveRank(ply, Rank)
end)

-- Send Tags
util.AddNetworkString("ATAG_Scoreboard_GetTags_rank")
util.AddNetworkString("ATAG_Scoreboard_SendTags_rank")

net.Receive("ATAG_Scoreboard_GetTags_rank", function(len, ply)
	if not ATAG:HasPermissions(ply) then return end
	
	local Rank = net.ReadString()
	ATAG.SB_SendTags_rank(ply, Rank)
end)

function ATAG.SB_SendTags_rank(ply, Rank)
	net.Start("ATAG_Scoreboard_SendTags_rank")
		net.WriteTable(ATAG.SB_GetTags_rank(ply, Rank))
	net.Send(ply)
end


-- Custom Tag
util.AddNetworkString("ATAG_Scoreboard_AddCustomTag")
util.AddNetworkString("ATAG_Scoreboard_RemoveCustomTag")

net.Receive("ATAG_Scoreboard_AddCustomTag", function(len, ply)
	local Type = net.ReadString()
	local PKey = net.ReadString()
	local TagName = net.ReadString()
	local TagColor = net.ReadTable()
	TagColor = Color(TagColor[1], TagColor[2], TagColor[3])
	
	if Type == "player" then
		ATAG.SB_AddCustomTag_player(ply, PKey, TagName, TagColor)
	elseif Type == "rank" then
		ATAG.SB_AddCustomTag_rank(ply, PKey, TagName, TagColor)
	end
end)

net.Receive("ATAG_Scoreboard_RemoveCustomTag", function(len, ply)
	local Type = net.ReadString()
	local PKey = net.ReadString()
	local TagID = net.ReadString()
	
	if Type == "player" then
		ATAG.SB_RemoveCustomTag_player(ply, PKey, TagID)
	elseif Type == "rank" then
		ATAG.SB_RemoveCustomTag_rank(ply, PKey, TagID)
	end
end)


-- Global Tag
util.AddNetworkString("ATAG_Scoreboard_AddTag")
util.AddNetworkString("ATAG_Scoreboard_RemoveTag")

net.Receive("ATAG_Scoreboard_AddTag", function(len, ply)
	local Type = net.ReadString()
	local PKey = net.ReadString()
	local TagID = net.ReadString()
	
	if Type == "player" then
		ATAG.SB_AddTag_player(ply, PKey, TagID)
	elseif Type == "rank" then
		ATAG.SB_AddTag_rank(ply, PKey, TagID)
	end
end)

net.Receive("ATAG_Scoreboard_RemoveTag", function(len, ply)
	local Type = net.ReadString()
	local PKey = net.ReadString()
	local TagID = net.ReadString()
	
	if Type == "player" then
		ATAG.SB_RemoveTag_player(ply, PKey, TagID)
	elseif Type == "rank" then
		ATAG.SB_RemoveTag_rank(ply, PKey, TagID)
	end
end)

-- Ranks
util.AddNetworkString("ATAG_Chat_GetTags_rank")
util.AddNetworkString("ATAG_Chat_SendTags_rank")

net.Receive("ATAG_Chat_GetTags_rank", function(len, ply)
	local Rank = net.ReadString()
	ATAG.CH_SendTags_rank(ply, Rank)
end)

function ATAG.CH_SendTags_rank(ply, Rank, Pos)
	net.Start("ATAG_Chat_SendTags_rank")
		net.WriteTable(ATAG.CH_GetTags_rank(ply, Rank))
		if Pos then
			net.WriteString(tostring(Pos))
		end
	net.Send(ply)
end

util.AddNetworkString("ATAG_Chat_GetRanks")
util.AddNetworkString("ATAG_Chat_SendRanks")

net.Receive("ATAG_Chat_GetRanks", function(len, ply)
	ATAG.CH_SendRanks(ply)
end)

function ATAG.CH_SendRanks(ply)
	net.Start("ATAG_Chat_SendRanks")
		net.WriteTable(ATAG.CH_GetRanks(ply))
	net.Send(ply)
end

util.AddNetworkString("ATAG_Chat_AddRank")
util.AddNetworkString("ATAG_Chat_RemoveRank")

net.Receive("ATAG_Chat_AddRank", function(len, ply)
	local Rank = net.ReadString()
	ATAG.CH_AddRank(ply, Rank)
end)

net.Receive("ATAG_Chat_RemoveRank", function(len, ply)
	local Rank = net.ReadString()
	ATAG.CH_RemoveRank(ply, Rank)
end)

-- Tag Piece
util.AddNetworkString("ATAG_Chat_AddTag_rank")
util.AddNetworkString("ATAG_Chat_RemoveTag_rank")
util.AddNetworkString("ATAG_Chat_MoveTag_rank")

net.Receive("ATAG_Chat_AddTag_rank", function(len, ply)
	local Rank = net.ReadString()
	local Name = net.ReadString()
	local color = net.ReadTable()
	color = Color(color[1], color[2], color[3])
	ATAG.CH_AddTagPiece_rank(ply, Rank, Name, color)
end)

net.Receive("ATAG_Chat_RemoveTag_rank", function(len, ply)
	local Rank = net.ReadString()
	local Pos = net.ReadString()
	ATAG.CH_RemoveTagPiece_rank(ply, Rank, Pos)
end)

net.Receive("ATAG_Chat_MoveTag_rank", function(len, ply)
	local Rank = net.ReadString()
	local Pos = net.ReadString()
	local NewPos = net.ReadString()
	ATAG.CH_MoveTagPiece_rank(ply, Rank, Pos, NewPos)
end)


-- Players
util.AddNetworkString("ATAG_Chat_GetTags_player")
util.AddNetworkString("ATAG_Chat_SendTags_player")

net.Receive("ATAG_Chat_GetTags_player", function(len, ply)
	local SteamID = net.ReadString()
	ATAG.CH_SendTags_player(ply, SteamID)
end)

function ATAG.CH_SendTags_player(ply, SteamID, Pos)
	net.Start("ATAG_Chat_SendTags_player")
		net.WriteTable(ATAG.CH_GetTags_player(ply, SteamID))
		if Pos then
			net.WriteString(tostring(Pos))
		end
	net.Send(ply)
end

util.AddNetworkString("ATAG_Chat_GetPlayers")
util.AddNetworkString("ATAG_Chat_SendPlayers")

net.Receive("ATAG_Chat_GetPlayers", function(len, ply)
	ATAG.CH_SendPlayers(ply)
end)

function ATAG.CH_SendPlayers(ply)
	net.Start("ATAG_Chat_SendPlayers")
		net.WriteTable(ATAG.CH_GetPlayers(ply))
	net.Send(ply)
end

util.AddNetworkString("ATAG_Chat_AddPlayer")
util.AddNetworkString("ATAG_Chat_RemovePlayer")

net.Receive("ATAG_Chat_AddPlayer", function(len, ply)
	local SteamID = net.ReadString()
	ATAG.CH_AddPlayer(ply, SteamID)
end)

net.Receive("ATAG_Chat_RemovePlayer", function(len, ply)
	local SteamID = net.ReadString()
	ATAG.CH_RemovePlayer(ply, SteamID)
end)

util.AddNetworkString("ATAG_Chat_ChangePlayerName")

net.Receive("ATAG_Chat_ChangePlayerName", function(len, ply)
	local SteamID = net.ReadString()
	local Name = net.ReadString()
	if Name == "\nil" then Name = nil end
	
	ATAG.CH_ChangePlayerName(ply, SteamID, Name)
end)

-- Tag Piece
util.AddNetworkString("ATAG_Chat_AddTag_player")
util.AddNetworkString("ATAG_Chat_RemoveTag_player")
util.AddNetworkString("ATAG_Chat_MoveTag_player")

net.Receive("ATAG_Chat_AddTag_player", function(len, ply)
	local SteamID = net.ReadString()
	local Name = net.ReadString()
	local color = net.ReadTable()
	color = Color(color[1], color[2], color[3])
	ATAG.CH_AddTagPiece_player(ply, SteamID, Name, color)
end)

net.Receive("ATAG_Chat_RemoveTag_player", function(len, ply)
	local SteamID = net.ReadString()
	local Pos = net.ReadString()
	ATAG.CH_RemoveTagPiece_player(ply, SteamID, Pos)
end)

net.Receive("ATAG_Chat_MoveTag_player", function(len, ply)
	local SteamID = net.ReadString()
	local Pos = net.ReadString()
	local NewPos = net.ReadString()
	ATAG.CH_MoveTagPiece_player(ply, SteamID, Pos, NewPos)
end)

-- Own Tag
util.AddNetworkString("ATAG_Chat_GetOwnTag")
util.AddNetworkString("ATAG_Chat_SendOwnTag")

net.Receive("ATAG_Chat_GetOwnTag", function(len, ply)
	ATAG.CH_SendOwnTags(ply)
end)

function ATAG.CH_SendOwnTags(ply, Pos)
	local OwnTag = ATAG.CH_GetOwnTag(ply)
	
	if OwnTag then
		net.Start("ATAG_Chat_SendOwnTag")
			net.WriteTable(OwnTag)
			if Pos then
				net.WriteString(tostring(Pos))
			end
		net.Send(ply)
	end
end

util.AddNetworkString("ATAG_Chat_GetCanSetOwnTag")
util.AddNetworkString("ATAG_Chat_SendCanSetOwnTag")

net.Receive("ATAG_Chat_GetCanSetOwnTag", function(len, ply)
	ATAG.CH_SendCanSetOwnTag(ply)
end)

function ATAG.CH_SendCanSetOwnTag(ply)

	local bool = ATAG.CH_CanEditOwnTag(ply) or false
	
	net.Start("ATAG_Chat_SendCanSetOwnTag")
		if bool then
			net.WriteString("true")
		else
			net.WriteString("false")
		end
	net.Send(ply)
end


util.AddNetworkString("ATAG_Chat_ToggleCanSetOwnTag")

net.Receive("ATAG_Chat_ToggleCanSetOwnTag", function(len, ply)
	local Type = net.ReadString()
	local Value = net.ReadString()
	
	ATAG.CH_ToggleCanSetOwnTag(ply, Type, Value)
end)

util.AddNetworkString("ATAG_Chat_AddTag_owntag")
util.AddNetworkString("ATAG_Chat_RemoveTag_owntag")
util.AddNetworkString("ATAG_Chat_MoveTag_owntag")

net.Receive("ATAG_Chat_AddTag_owntag", function(len, ply)
	local Name = net.ReadString()
	local color = net.ReadTable()
	color = Color(color[1], color[2], color[3])
	ATAG.CH_AddTagPiece_owntag(ply, Name, color)
end)

net.Receive("ATAG_Chat_RemoveTag_owntag", function(len, ply)
	local Pos = net.ReadString()
	ATAG.CH_RemoveTagPiece_owntag(ply, Pos)
end)

net.Receive("ATAG_Chat_MoveTag_owntag", function(len, ply)
	local Pos = net.ReadString()
	local NewPos = net.ReadString()
	ATAG.CH_MoveTagPiece_owntag(ply, Pos, NewPos)
end)




util.AddNetworkString( "ATAG_ChangePrimaryKey" ) -- Change Rank Name / Steam ID
net.Receive( "ATAG_ChangePrimaryKey", function( len, ply )
	
	local type = net.ReadString()
	local old = net.ReadString()
	local new = net.ReadString()
	
	if type == "c_rank" then
		ATAG:CH_ChangeRank( ply, old, new )
	elseif type == "c_player" then
		ATAG:CH_ChangePlayer( ply, old, new )
	elseif type == "sb_rank" then
		ATAG:SB_ChangeRank( ply, old, new )
	elseif type == "sb_player" then
		ATAG:SB_ChangePlayer( ply, old, new )
	end
	
end)


-- Open Menu Hook
util.AddNetworkString("ATAG_OpenMenu")

hook.Add("PlayerSay", "ATAGS_OnPlayerSay", function(ply, msg)
	if msg ~= ATAG.ChatCommand then return end
	net.Start("ATAG_OpenMenu")
	net.Send(ply)
end)