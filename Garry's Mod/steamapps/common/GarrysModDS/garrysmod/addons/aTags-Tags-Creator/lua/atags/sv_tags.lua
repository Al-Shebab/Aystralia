include("von.lua")

if not file.Exists("atags", "DATA") then
	file.CreateDir("atags")
end
if not file.Exists("atags/tags.txt", "DATA") then
	file.Write("atags/tags.txt", "")
end
if not file.Exists("atags/playertags.txt", "DATA") then
	file.Write("atags/playertags.txt", "")
end
if not file.Exists("atags/ranktags.txt", "DATA") then
	file.Write("atags/ranktags.txt", "")
end
if not file.Exists("atags/selectedtags.txt", "DATA") then
	file.Write("atags/selectedtags.txt", "")
end
if not file.Exists("atags/rankchattags.txt", "DATA") then
	file.Write("atags/rankchattags.txt", "")
end
if not file.Exists("atags/playerchattags.txt", "DATA") then
	file.Write("atags/playerchattags.txt", "")
end

ATAG.Tags = von.deserialize(file.Read("atags/tags.txt", "DATA")) or {}
ATAG.PlayerTags = von.deserialize(file.Read("atags/playertags.txt", "DATA")) or {}
ATAG.RankTags = von.deserialize(file.Read("atags/ranktags.txt", "DATA")) or {}
ATAG.SelectedTags = von.deserialize(file.Read("atags/selectedtags.txt", "DATA")) or {}
ATAG.RankChatTags = von.deserialize(file.Read("atags/rankchattags.txt", "DATA")) or {}
ATAG.PlayerChatTags = von.deserialize(file.Read("atags/playerchattags.txt", "DATA")) or {}

ATAG.SB_TagTable = {}
ATAG.CH_TagTable = {}
ATAG.CH_TagTable_rank = {}
ATAG.CH_TagTable_player = {}

function GlobalUpdate()

	-- Update all players tags.
	for _, ply in pairs( player.GetAll() ) do
		ATAG:CheckAutoAssignTag( ply )
		ply:updateChatTag()
		ply:updateScoreboardTag()
	end

	-- Send all players tags to all players.
	for _, ply in pairs( player.GetAll() ) do
		ply:sendChatTags()
		ply:sendScoreboardTags()
	end

	-- ATAG:UpdateAllPlayerTags()
	
	-- for _, ply in pairs(player.GetAll()) do
		-- ATAG.SendUserTags(ply)
	-- end
	
end

function UpdateSelectedTags()
	file.Write("atags/selectedtags.txt", von.serialize(ATAG.SelectedTags))
	--GlobalUpdate()
end
function UpdateTags()
	file.Write("atags/tags.txt", von.serialize(ATAG.Tags))
	GlobalUpdate()
end
function UpdatePlayerTags()
	file.Write("atags/playertags.txt", von.serialize(ATAG.PlayerTags))
	GlobalUpdate()
end
function UpdateRankTags()
	file.Write("atags/ranktags.txt", von.serialize(ATAG.RankTags))
	GlobalUpdate()
end
function UpdateRankChatTags()
	file.Write("atags/rankchattags.txt", von.serialize(ATAG.RankChatTags))
	GlobalUpdate()
end
function UpdatePlayerChatTags()
	file.Write("atags/playerchattags.txt", von.serialize(ATAG.PlayerChatTags))
	GlobalUpdate()
end

local function PrepareFiles()
	
	if not ATAG.Tags.Tags then
		ATAG.Tags.NewID = 0
		ATAG.Tags.Tags = {}
		UpdateTags()
	end
	if not ATAG.PlayerTags[1] then
		ATAG.PlayerTags[1] = {}
		ATAG.PlayerTags[2] = {}
		UpdatePlayerTags()
	end
	if not ATAG.RankTags[1] then
		ATAG.RankTags[1] = {}
		ATAG.RankTags[2] = {}
		UpdateRankTags()
	end
	if not ATAG.RankChatTags[1] then
		ATAG.RankChatTags[1] = {}
		ATAG.RankChatTags[2] = {}
		UpdateRankChatTags()
	end
	if not ATAG.PlayerChatTags[1] then
		ATAG.PlayerChatTags[1] = {}
		ATAG.PlayerChatTags[2] = {}
		UpdatePlayerChatTags()
	end
	
end

local function GetPlayerName(SteamID)
	for _, ply in pairs(player.GetAll()) do
		if ply:SteamID() == SteamID then
			return ply:Name()
		end
	end
	return "" -- If the player is not online return an empty string.
end

local function DoesTagExist(TagID)
	for k, v in pairs(ATAG.Tags.Tags) do
		if tonumber(v[1]) == tonumber(TagID) then
			return true
		end
	end
	return false
end

local function DoesCustomTagExist_player(SteamID, TagID)
	if not ATAG.PlayerTags[2][SteamID] then return false end
	for k, v in pairs(ATAG.PlayerTags[2][SteamID].Ctags) do
		if tonumber(v[1]) == tonumber(TagID) then
			return true
		end
	end
	return false
end

local function DoesCustomTagExist_rank(Rank, TagID)
	if not ATAG.RankTags[2][Rank] then return end
	for k, v in pairs(ATAG.RankTags[2][Rank].Ctags) do
		if tonumber(v[1]) == tonumber(TagID) then
			return true
		end
	end
	return false
end

local function DoesGlobalTagExist_player(SteamID, TagID)
	if not ATAG.PlayerTags[2][SteamID] then return end
	for k, v in pairs(ATAG.PlayerTags[2][SteamID].Etags) do
		if tonumber(v) == tonumber(TagID) then
			return true
		end
	end
	return false
end

local function DoesGlobalTagExist_rank(Rank, TagID)
	if not ATAG.RankTags[2][Rank] then return end
	for k, v in pairs(ATAG.RankTags[2][Rank].Etags) do
		if tonumber(v) == tonumber(TagID) then
			return true
		end
	end
	return false
end

local function SB_DoesPlayerExist(SteamID)
	for k, v in pairs(ATAG.PlayerTags[1]) do
		if v[1] == SteamID then
			return true
		end
	end
	return false
end

local function SB_DoesRankExist(Rank)
	for k, v in pairs(ATAG.RankTags[1]) do
		if v[1] == Rank then
			return true
		end
	end
	return false
end



function ATAG:GetPlayerBySteamID( steamid )
	for _, ply in pairs( player.GetAll() ) do
		if ply:SteamID() == steamid or ply:SteamID64() == steamid then
			return ply
		end
	end
	return nil
end

function ATAG:GetUserGroup( ply )
	if evolve then
		return ply:EV_GetRank()
	else
		-- ULib, ServerGuard
		return ply:GetUserGroup()
	end
end


--[[ TagTable
	{ TagTable
	
		name (String),
		color (Color)
		
	}
]]

function ATAG:GetSelectedScoreboardTag( ply ) -- NEW
	
	local TagTable = {
		name = nil,
		color = nil
	}
	
	local SteamID = ply:SteamID()
	local Rank = ATAG:GetUserGroup( ply )
	
	local Tag = ATAG.SelectedTags[SteamID]
	
	if Tag then -- TODO This needs to be done better.
	
		if Tag.Type == "p_custom" then
			if not SB_DoesPlayerExist(SteamID) then ATAG.SelectUserTag(SteamID, Tag.ID, "remove") return TagTable end
			for k, v in pairs(ATAG.PlayerTags[2][SteamID].Ctags) do
				if tonumber(v[1]) == tonumber(Tag.ID) then
					TagTable.name = v[2]
					TagTable.color = v[3]
				end
			end
		elseif Tag.Type == "p_global" then
			if not DoesTagExist(Tag.ID) then return TagTable end
			if not DoesGlobalTagExist_player(SteamID, Tag.ID) then return TagTable end
			for k, v in pairs(ATAG.Tags.Tags) do
				if tonumber(v[1]) == tonumber(Tag.ID) then
					TagTable.name = v[2]
					TagTable.color = v[3]
				end
			end
		elseif Tag.Type == "r_custom" then
			if not SB_DoesRankExist(Rank) then return TagTable end
			if Tag.Rank ~= Rank then return TagTable end
			for k, v in pairs(ATAG.RankTags[2][Rank].Ctags) do
				if tonumber(v[1]) == tonumber(Tag.ID) then
					TagTable.name = v[2]
					TagTable.color = v[3]
				end
			end
		elseif Tag.Type == "r_global" then
			if not DoesTagExist(Tag.ID) then return TagTable end
			if not DoesGlobalTagExist_rank(Rank, Tag.ID) then return TagTable end
			if Tag.Rank ~= Rank then return TagTable end
			for k, v in pairs(ATAG.Tags.Tags) do
				if tonumber(v[1]) == tonumber(Tag.ID) then
					TagTable.name = v[2]
					TagTable.color = v[3]
				end
			end
		elseif Tag.Type == "p_set" then
			if ATAG.SB_CanEditOwnTag(ply) then
				if Tag.Cus_N and Tag.Cus_C then
					TagTable.name = Tag.Cus_N
					TagTable.color = Tag.Cus_C
				end
			end
		end
		
	end
	
	return TagTable
end

function ATAG:GetChatTagTable( ply ) -- NEW
	
	local TagTable = {
		tags = {}
	}
	
	if ATAG.PlayerChatTags[2][ply:SteamID()] then
	
		local steamid = ply:SteamID()

		if ATAG.PlayerChatTags[2][steamid] then
			
			TagTable.tags = ATAG.PlayerChatTags[ 2 ][ steamid ]
			
		else
			return
		end
	
	elseif ATAG.RankChatTags[2][ATAG:GetUserGroup( ply )] then
	
		local rank = ATAG:GetUserGroup( ply )
		
		if ATAG.RankChatTags[2][rank] then
		
			TagTable.tags = ATAG.RankChatTags[ 2 ][ rank ]
		
		else
			return
		end
		
	else
		return
	end
	
	return TagTable
end

function ATAG:CheckAutoAssignTag( ply )
	
	-- Check if tag exists, if it does do nothing
	-- If it does check if there's an auto assigned tag
	local selected_table = ATAG.SelectedTags[ ply:SteamID() ]
	if selected_table then
		
		if selected_table.Rank and ( selected_table.Type == 'r_global' or selected_table.Type == 'r_custom' ) then
			
			if selected_table.Rank != ply:GetUserGroup() then
				ATAG.SelectedTags[ ply:SteamID() ] = nil
			else
				
				local rank_table = ATAG.RankTags[ 2 ][ selected_table.Rank ]
				if rank_table then
					
					local tag_exists = false
					if selected_table.Type == 'r_custom' then
						
						for k, v in pairs( rank_table.Ctags or {} ) do
							if tostring( v[ 1 ] ) == tostring( selected_table.ID ) then
								tag_exists = true
								break
							end
						end
						
					elseif selected_table.Type == 'r_global' then
						
						for k, v in pairs( rank_table.Etags or {} ) do
							if tostring( v ) == tostring( selected_table.ID ) then
								tag_exists = true
								break
							end
						end
						
					end
					
					if not tag_exists then
						ATAG.SelectedTags[ ply:SteamID() ] = nil
					else
						return
					end
				
				else
					ATAG.SelectedTags[ ply:SteamID() ] = nil
				end
				
			end
			
		elseif selected_table.Type == 'p_global' or selected_table.Type == 'p_custom' then
			
			if selected_table.Type == 'p_global' and not DoesGlobalTagExist_player( ply:SteamID(), selected_table.ID )then
				ATAG.SelectedTags[ ply:SteamID() ] = nil
			elseif selected_table.Type == 'p_custom' and not DoesCustomTagExist_player( ply:SteamID(), selected_table.ID ) then
				ATAG.SelectedTags[ ply:SteamID() ] = nil
			else
				return
			end
			
		end
		
	end
	
	local userGroup = ATAG:GetUserGroup( ply )
	for _, rankTable in pairs( ATAG.RankTags[ 1 ] ) do
		
		local rank = rankTable[ 1 ]
		if ( rank != userGroup ) then continue end
		
		local tag = ATAG.RankTags[ 2 ][ rank ].AssignTag
		if tag then
		
			local id, type = tag[1], tag[2]
			
			if type == "c" then
				type = "r_custom"
			elseif type == "e" then
				type = "r_global"
			end
			
			if id and type then
				ATAG.SelectUserTag( ply, id, type )
			end
			
			break
		end
		
	end
	
end

hook.Add("PlayerInitialSpawn", "aTags", function( ply )
	
	-- Check if the player has an auto assigned tag.
	ATAG:CheckAutoAssignTag( ply )
	
	-- Initialize player tags.
	ply:updateChatTag()
	ply:updateScoreboardTag()
	
	-- Send all tags to the player.
	ply:sendChatTags()
	ply:sendScoreboardTags()
	
	-- Send this players tags to all other players.
	for _, _player in pairs( player.GetAll() ) do
		
		-- Do not send to the player itself. ( We already did that. )
		if ( _player == ply ) then continue end
		
		_player:sendChatTag( ply )
		_player:sendScoreboardTag( ply )
		
	end
	
end)

hook.Add( "PostGamemodeLoaded", "aTags - Initialize", function()

	if ULib then
		
		-- Update tags when a player switches groups.
		hook.Add( ULib.HOOK_UCLAUTH, "aTags", function( ply )
			
			if not IsValid( ply ) then return end
			
			-- Check if the player has an auto assigned tag.
			ATAG:CheckAutoAssignTag( ply )
			
			-- Update player tags.
			ply:updateChatTag()
			ply:updateScoreboardTag()
			
			-- Send this players tags to all players.
			for _, _player in pairs( player.GetAll() ) do
				_player:sendChatTag( ply )
				_player:sendScoreboardTag( ply )
			end
			
		end)
		
	end

	if ( serverguard ) then
		
		-- Remove the PlayerInitialSpawn.
		hook.Remove( "PlayerInitialSpawn", "aTags" )
		
		-- Replace this with the PlayerInitialSpawn.
		hook.Add( "serverguard.LoadPlayerData", "aTags", function( ply )
		
			timer.Simple( 1, function()
				
				-- Check if the player has an auto assigned tag.
				ATAG:CheckAutoAssignTag( ply )
				
				-- Initialize player tags.
				ply:updateChatTag()
				ply:updateScoreboardTag()
				
				-- Send all tags to the player.
				ply:sendChatTags()
				ply:sendScoreboardTags()
				
				-- Send this players tags to all other players.
				for _, _player in pairs( player.GetAll() ) do
					
					-- Do not send to the player itself. ( We already did that. )
					if ( _player == ply ) then continue end
					
					_player:sendChatTag( ply )
					_player:sendScoreboardTag( ply )
					
				end
				
			end)
		
		end)
		
		-- Update tags when this gets called. ( forgot what it does. )
		hook.Add( "serverguard.PostSavePlayerRank", "aTags", function( ply )
			
			-- Check if the player has an auto assigned tag.
			ATAG:CheckAutoAssignTag( ply )
			
			-- Update player tags.
			ply:updateChatTag()
			ply:updateScoreboardTag()
			
			-- Send this players tags to all players.
			for _, _player in pairs( player.GetAll() ) do
				_player:sendChatTag( ply )
				_player:sendScoreboardTag( ply )
			end
			
		end)

	end

end)




-- Leave everything else as it is right now.

-- Select Tag
function ATAG.SelectUserTag(ply, TagID, Type)
	
	local SteamID = nil
	local Rank = nil
	
	if isstring(ply) then
		SteamID = ply
	else
		SteamID = ply:SteamID()
		Rank = ATAG:GetUserGroup( ply )
	end
	
	if not ATAG.SelectedTags[SteamID] then
		ATAG.SelectedTags[SteamID] = {}
	end
	
	if Type == "p_global" or Type == "p_custom" then
	
		if not SB_DoesPlayerExist(SteamID) then return end
	
		if Type == "p_global" then
			if not DoesTagExist(tonumber(TagID)) then return end
		elseif Type == "p_custom" then
			if not DoesCustomTagExist_player(SteamID, TagID) then return end
		end
		
		ATAG.SelectedTags[SteamID] = {ID = TagID, Type = Type}
	
	elseif Type == "r_global" or Type == "r_custom" then
	
		if not SB_DoesRankExist(Rank) then return end
		
		if Type == "r_global" then
			if not DoesTagExist(tonumber(TagID)) then return end
		elseif Type == "r_custom" then
			if not DoesCustomTagExist_rank(Rank, TagID) then return end
		end
		
		ATAG.SelectedTags[SteamID] = {ID = TagID, Type = Type, Rank = Rank}
		
	elseif Type == "remove" then
		
		ATAG.SelectedTags[SteamID] = nil
		
		-- So it instantly updates.
		ATAG:CheckAutoAssignTag( ply )
		
	else
		return
	end
	
	UpdateSelectedTags()
	
end

-- Global Tags
function ATAG.AddTag(ply, TagName, TagColor) -- Name of the tag, color of the tag.
	if not ATAG:HasPermissions(ply) then return end
	if not TagName then return end
	if not TagColor then TagColor = Color(255, 255, 255) end
	
	ATAG.Tags.NewID = ATAG.Tags.NewID + 1
	table.insert(ATAG.Tags.Tags, {ATAG.Tags.NewID, TagName, TagColor})
	
	UpdateTags()
	ATAG.SendTagData(ply)
end

function ATAG.EditTag(ply, TagID, TagName, TagColor) -- Name of the tag, color of the tag.
	if not ATAG:HasPermissions(ply) then return end
	if not TagID then return end
	if not TagName then return end
	if not TagColor then TagColor = Color(255, 255, 255) end
	
	for k, v in pairs(ATAG.Tags.Tags) do
		if tonumber(v[1]) == tonumber(TagID) then
			v[2] = TagName
			v[3] = TagColor
		end
	end
	
	UpdateTags()
	ATAG.SendTagData(ply)
end

function ATAG.RemoveTag(ply, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not TagID then return end
	
	for k, v in pairs(ATAG.Tags.Tags) do
		if tonumber(v[1]) == tonumber(TagID) then
			table.remove(ATAG.Tags.Tags, k)
		end
	end
	
	UpdateTags()
	ATAG.SendTagData(ply)
	ATAG.SB_CheckForRemovedTag_player(ply, TagID)
	ATAG.SB_CheckForRemovedTag_rank(ply, TagID)
end







-- Scoreboard Tags

function ATAG.SB_CanEditOwnTag(ply)

	for k, v in pairs(ATAG.PlayerTags[1]) do
		if v[1] == ply:SteamID() then
			if v.CST then
				return true
			end
		end
	end
	
	for k, v in pairs(ATAG.RankTags[1]) do
		if v[1] == ATAG:GetUserGroup( ply ) then
			if v.CST then
				return true
			end
		end
	end
	
	return false
end

function ATAG.SB_SetAutoAssignedTag_rank(ply, Rank, TagID, Type)

	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesRankExist(Rank) then return end
	if not TagID or not Type then return end
	
	if not ATAG.RankTags[2][Rank].AssignTag then
		ATAG.RankTags[2][Rank].AssignTag = {TagID, Type}
	else
		if ATAG.RankTags[2][Rank].AssignTag[1] == TagID and ATAG.RankTags[2][Rank].AssignTag[2] == Type then
			ATAG.RankTags[2][Rank].AssignTag = nil
		else
			ATAG.RankTags[2][Rank].AssignTag = {TagID, Type}
		end
	end
	
	UpdateRankTags()
	
	for _, _player in pairs( player.GetAll() ) do
	
		if not ( ATAG:GetUserGroup( _player ) == Rank ) then continue end
		
		-- Check if the player has an auto assigned tag.
		ATAG:CheckAutoAssignTag( _player )
		
		_player:updateScoreboardTag()
		
		-- Send this players tags to all other players.
		for _, _player2 in pairs( player.GetAll() ) do
			_player2:sendScoreboardTag( _player )
		end
		
	end
	
	ATAG.SB_SendTags_rank(ply, Rank)
	
end

function ATAG.SB_ToggleCanSetOwnTag(ply, Type, Value)
	if not ATAG:HasPermissions(ply) then return end
	
	if Type == "player" then
	
		if not SB_DoesPlayerExist(Value) then return end
		
		for k, v in pairs(ATAG.PlayerTags[1]) do
			if v[1] == Value then
				if v.CST then
					v.CST = false
				else
					v.CST = true
				end
			end
		end
		
		UpdatePlayerTags()
		ATAG.SB_SendPlayers(ply)
		
	elseif Type == "rank" then
		
		if not SB_DoesRankExist(Value) then return end
		
		for k, v in pairs(ATAG.RankTags[1]) do
			if v[1] == Value then
				if v.CST then
					v.CST = false
				else
					v.CST = true
				end
			end
		end
		
		UpdateRankTags()
		ATAG.SB_SendRanks(ply)
	
	end
end

function ATAG.SB_SetOwnTag(ply, Name, color)
	if not ATAG.SB_CanEditOwnTag(ply) then return end
	if not Name then return end
	if not color then return end
	
	local SteamID = ply:SteamID()
	
	if not ATAG.SelectedTags[SteamID] then
		ATAG.SelectedTags[SteamID] = {}
	end
	
	ATAG.SelectedTags[SteamID] = {}
	
	ATAG.SelectedTags[SteamID].Type = "p_set"
	ATAG.SelectedTags[SteamID].Cus_N = Name
	ATAG.SelectedTags[SteamID].Cus_C = color
	
	-- Save the tag.
	UpdateSelectedTags()
	
	-- Update the players tag.
	ply:updateScoreboardTag()
	
	-- Send this players tag to all other players.
	for _, _player in pairs( player.GetAll() ) do
		_player:sendScoreboardTag( ply )
	end
	
end

function ATAG.SB_GetOwnTag(ply)
	if not ATAG.SB_CanEditOwnTag(ply) then return end

	if not ATAG.SelectedTags[SteamID] then return {} end -- Still has permissions to edit his own tag, but doesn't have one.
	
	return {ATAG.SelectedTags[SteamID].Cus_N, ATAG.SelectedTags[SteamID].Cus_C}
end


function ATAG.SB_ToggleCanSetOwnTag(ply, Type, Value)
	if not ATAG:HasPermissions(ply) then return end
	
	if Type == "player" then
	
		if not SB_DoesPlayerExist(Value) then return end
		
		for k, v in pairs(ATAG.PlayerTags[1]) do
			if v[1] == Value then
				if v.CST then
					v.CST = false
				else
					v.CST = true
				end
			end
		end
		
		UpdatePlayerTags()
		ATAG.SB_SendPlayers(ply)
		
	elseif Type == "rank" then
		
		if not SB_DoesRankExist(Value) then return end
		
		for k, v in pairs(ATAG.RankTags[1]) do
			if v[1] == Value then
				if v.CST then
					v.CST = false
				else
					v.CST = true
				end
			end
		end
		
		UpdateRankTags()
		ATAG.SB_SendRanks(ply)
	
	end
end


-- PLAYER
function ATAG.SB_GetPlayers(ply)
	if not ATAG:HasPermissions(ply) then return {} end
	
	return ATAG.PlayerTags[1]
end

function ATAG.SB_AddPlayer(ply, SteamID, force)
	if not ATAG:HasPermissions(ply) then return end
	if SB_DoesPlayerExist(SteamID) then return end
	
	table.insert(ATAG.PlayerTags[1], {SteamID, GetPlayerName(SteamID)} )
	ATAG.PlayerTags[2][SteamID] = { Etags = {}, NewID = 0, Ctags = {} }

	UpdatePlayerTags()
	ATAG.SB_SendPlayers(ply)
end

function ATAG.SB_RemovePlayer(ply, SteamID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end
	
	for k, v in pairs(ATAG.PlayerTags[1]) do
		if v[1] == SteamID then
			table.remove(ATAG.PlayerTags[1], k)
		end
	end
	
	ATAG.PlayerTags[2][SteamID] = nil
	
	UpdatePlayerTags()
	ATAG.SB_SendPlayers(ply)
end

function ATAG.SB_ChangePlayerName(ply, SteamID, Name)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end
	
	for k, v in pairs(ATAG.PlayerTags[1]) do
		if v[1] == SteamID then
			if Name ~= nil then
				ATAG.PlayerTags[1][k][2] = Name
			else
				local plyName = GetPlayerName(SteamID)
				if plyName ~= "" then
					ATAG.PlayerTags[1][k][2] = GetPlayerName(SteamID)
				end
			end
		end
	end
	
	UpdatePlayerTags()
	ATAG.SB_SendPlayers(ply)
end

-- RANK
function ATAG.SB_GetRanks(ply)
	if not ATAG:HasPermissions(ply) then return {} end
	return ATAG.RankTags[1]
end

function ATAG.SB_AddRank(ply, Rank)
	if not ATAG:HasPermissions(ply) then return end
	if SB_DoesRankExist(Rank) then return end
	
	table.insert(ATAG.RankTags[1], {Rank})
	ATAG.RankTags[2][Rank] = { Etags = {}, NewID = 0, Ctags = {} }

	UpdateRankTags()
	ATAG.SB_SendRanks(ply)
end

function ATAG.SB_RemoveRank(ply, Rank)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesRankExist(Rank) then return end
	
	for k, v in pairs(ATAG.RankTags[1]) do
		if v[1] == Rank then
			table.remove(ATAG.RankTags[1], k)
		end
	end
	
	ATAG.RankTags[2][Rank] = nil
	
	UpdateRankTags()
	ATAG.SB_SendRanks(ply)
end

-- Tags Player
function ATAG.SB_GetTags_player(ply, SteamID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end

	return ATAG.PlayerTags[2][SteamID]
end

-- Custom Tags Player
function ATAG.SB_AddCustomTag_player(ply, SteamID, TagName, TagColor)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end
	
	ATAG.PlayerTags[2][SteamID].NewID = ATAG.PlayerTags[2][SteamID].NewID + 1
	table.insert(ATAG.PlayerTags[2][SteamID].Ctags, {ATAG.PlayerTags[2][SteamID].NewID, TagName, TagColor})
	
	UpdatePlayerTags()
	ATAG.SB_SendTags_player(ply, SteamID)
end

function ATAG.SB_RemoveCustomTag_player(ply, SteamID, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end
	
	for n, t in pairs(ATAG.PlayerTags[2][SteamID].Ctags) do
		if tonumber(t[1]) == tonumber(TagID) then
			table.remove(ATAG.PlayerTags[2][SteamID].Ctags, n)
		end
	end
	
	UpdatePlayerTags()
	ATAG.SB_SendTags_player(ply, SteamID)
end

-- Existing Tags Player

function ATAG.SB_AddTag_player(ply, SteamID, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end
	if not DoesTagExist(tonumber(TagID)) then return end
	
	if not table.HasValue(ATAG.PlayerTags[2][SteamID].Etags, tonumber(TagID)) then
		table.insert(ATAG.PlayerTags[2][SteamID].Etags, tonumber(TagID))
	end
	
	UpdatePlayerTags()
	ATAG.SB_SendTags_player(ply, SteamID)
end

function ATAG.SB_RemoveTag_player(ply, SteamID, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesPlayerExist(SteamID) then return end
	
	for k, v in pairs(ATAG.PlayerTags[2][SteamID].Etags) do
		if tonumber(v) == tonumber(TagID) then
			table.remove(ATAG.PlayerTags[2][SteamID].Etags, k)
		end
	end
	
	UpdatePlayerTags()
	ATAG.SB_SendTags_player(ply, SteamID)
end

function ATAG.SB_CheckForRemovedTag_player(ply, TagID)
	if DoesTagExist(tonumber(TagID)) then return end
	
	for _, player in pairs(ATAG.PlayerTags[1]) do
		for k, v in pairs(ATAG.PlayerTags[2][player[1]].Etags) do
			if tonumber(v) == tonumber(TagID) then
				table.remove(ATAG.PlayerTags[2][player[1]].Etags, k)
				ATAG.SB_SendTags_player(ply, player[1])
			end
		end
	end
	
	UpdatePlayerTags()
end

-- Tags Rank
function ATAG.SB_GetTags_rank(ply, Rank)
	if not ATAG:HasPermissions(ply) then return {} end
	if not SB_DoesRankExist(Rank) then return {} end
	
	return ATAG.RankTags[2][Rank]
end

-- Custom Tags Player
function ATAG.SB_AddCustomTag_rank(ply, Rank, TagName, TagColor)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesRankExist(Rank) then return end
	
	ATAG.RankTags[2][Rank].NewID = ATAG.RankTags[2][Rank].NewID + 1
	table.insert(ATAG.RankTags[2][Rank].Ctags, {ATAG.RankTags[2][Rank].NewID, TagName, TagColor})
	
	UpdateRankTags()
	ATAG.SB_SendTags_rank(ply, Rank)
end

function ATAG.SB_RemoveCustomTag_rank(ply, Rank, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesRankExist(Rank) then return end
	
	for n, t in pairs(ATAG.RankTags[2][Rank].Ctags) do
		if tonumber(t[1]) == tonumber(TagID) then
			table.remove(ATAG.RankTags[2][Rank].Ctags, n)
		end
	end
	
	UpdateRankTags()
	ATAG.SB_SendTags_rank(ply, Rank)
end

-- Existing Tags Player

function ATAG.SB_AddTag_rank(ply, Rank, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesRankExist(Rank) then return end
	if not DoesTagExist(tonumber(TagID)) then return end
	
	if not table.HasValue(ATAG.RankTags[2][Rank].Etags, tonumber(TagID)) then
		table.insert(ATAG.RankTags[2][Rank].Etags, tonumber(TagID))
	end
	
	UpdateRankTags()
	ATAG.SB_SendTags_rank(ply, Rank)
end

function ATAG.SB_RemoveTag_rank(ply, Rank, TagID)
	if not ATAG:HasPermissions(ply) then return end
	if not SB_DoesRankExist(Rank) then return end
	
	for k, v in pairs(ATAG.RankTags[2][Rank].Etags) do
		if tonumber(v) == tonumber(TagID) then
			table.remove(ATAG.RankTags[2][Rank].Etags, k)
		end
	end
	
	UpdateRankTags()
	ATAG.SB_SendTags_rank(ply, Rank)
end

function ATAG.SB_CheckForRemovedTag_rank(ply, TagID)
	if DoesTagExist(tonumber(TagID)) then return end
	
	for _, rank in pairs(ATAG.RankTags[1]) do
		for k, v in pairs(ATAG.RankTags[2][rank[1]].Etags) do
			if tonumber(v) == tonumber(TagID) then
				table.remove(ATAG.RankTags[2][rank[1]].Etags, k)
				ATAG.SB_SendTags_rank(ply, rank[1])
			end
		end
	end
	
	UpdateRankTags()
end






-- Chat Tags
local function DoesRankChatTagExist(Rank)
	for k, v in pairs(ATAG.RankChatTags[1]) do
		if v[1] == Rank then
			return true
		end
	end
	return false
end

local function DoesPlayerChatTagExist(SteamID)
	for k, v in pairs(ATAG.PlayerChatTags[1]) do
		if v[1] == SteamID then
			return true
		end
	end
	return false
end

-- RANK

function ATAG.CH_GetTags_rank(ply, Rank)
	if not ATAG:HasPermissions(ply) then return {} end
	if not DoesRankChatTagExist(Rank) then return {} end
	return ATAG.RankChatTags[2][Rank]
end

function ATAG.CH_GetRanks(ply)
	if not ATAG:HasPermissions(ply) then return {} end
	return ATAG.RankChatTags[1]
end

function ATAG.CH_AddRank(ply, Rank)
	if not ATAG:HasPermissions(ply) then return end
	if DoesRankChatTagExist(Rank) then return end
	
	table.insert(ATAG.RankChatTags[1], {Rank})
	ATAG.RankChatTags[2][Rank] = {}
	
	UpdateRankChatTags()
	ATAG.CH_SendRanks(ply)
end

function ATAG.CH_RemoveRank(ply, Rank)
	if not ATAG:HasPermissions(ply) then return end
	
	for k, v in pairs(ATAG.RankChatTags[1]) do
		if v[1] == Rank then
			table.remove(ATAG.RankChatTags[1], k)
		end
	end
	
	ATAG.RankChatTags[2][Rank] = nil
	
	UpdateRankChatTags()
	ATAG.CH_SendRanks(ply)
end

-- Chat Piece
function ATAG.CH_AddTagPiece_rank(ply, Rank, Name, color)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesRankChatTagExist(Rank) then return end
	
	table.insert(ATAG.RankChatTags[2][Rank], {Name, color})
	
	UpdateRankChatTags()
	ATAG.CH_SendTags_rank(ply, Rank)
end

function ATAG.CH_RemoveTagPiece_rank(ply, Rank, Pos)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesRankChatTagExist(Rank) then return end
	
	table.remove(ATAG.RankChatTags[2][Rank], tonumber(Pos))
	
	UpdateRankChatTags()
	ATAG.CH_SendTags_rank(ply, Rank)
end

function ATAG.CH_MoveTagPiece_rank(ply, Rank, Pos, NewPos)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesRankChatTagExist(Rank) then return end
	
	local Pos = tonumber(Pos)
	local NewPos = tonumber(NewPos)
	
	if NewPos < 1 then return end
	if NewPos > table.getn(ATAG.RankChatTags[2][Rank]) + 1 then return end
	
	local Table = table.Copy(ATAG.RankChatTags[2][Rank][Pos])
	
	local PosDifference = Pos - NewPos
	local SelectPos = 0
		
	table.insert(ATAG.RankChatTags[2][Rank], NewPos, Table)
	
	if PosDifference < 1 then
		table.remove(ATAG.RankChatTags[2][Rank], Pos)
		SelectPos = NewPos-1
	else
		table.remove(ATAG.RankChatTags[2][Rank], Pos+1)
		SelectPos = NewPos
	end
	
	UpdateRankChatTags()
	ATAG.CH_SendTags_rank(ply, Rank, SelectPos)
end

function ATAG:CH_ChangeRank( ply, old, new )
	
	if not self:HasPermissions( ply ) then return end
	if not ATAG.RankChatTags[2][ old ] then return end
	if ATAG.RankChatTags[2][ new ] then return end
	
	for k, v in pairs( ATAG.RankChatTags[1] ) do
		
		if v[1] == old then
			v[1] = new
		end
		
	end
	
	ATAG.RankChatTags[2][ new ] = ATAG.RankChatTags[2][ old ]
	
	ATAG.RankChatTags[2][ old ] = nil
	
	UpdateRankChatTags()
	ATAG.CH_SendRanks( ply )
	
end

function ATAG:CH_ChangePlayer( ply, old, new )
	
	if not self:HasPermissions( ply ) then return end
	if not ATAG.PlayerChatTags[2][ old ] then return end
	--if ATAG.PlayerChatTags[2][ new ] then return end
	
	for k, v in pairs( ATAG.PlayerChatTags[1] ) do
		
		if v[1] == old then
			v[1] = new
		end
		
	end
	
	ATAG.PlayerChatTags[2][ new ] = ATAG.PlayerChatTags[2][ old ]
	
	ATAG.PlayerChatTags[2][ old ] = nil
	
	UpdatePlayerChatTags()
	ATAG.CH_SendPlayers( ply )
	
end

function ATAG:SB_ChangeRank( ply, old, new )
	
	if not self:HasPermissions( ply ) then return end
	if not ATAG.RankTags[2][ old ] then return end
	if ATAG.RankTags[2][ new ] then return end
	
	for k, v in pairs( ATAG.RankTags[1] ) do
	
		if v[1] == old then
			v[1] = new
		end
		
	end
	
	ATAG.RankTags[2][ new ] = ATAG.RankTags[2][ old ]
	
	ATAG.RankTags[2][ old ] = nil
	
	for steamID, v in pairs( ATAG.SelectedTags ) do
	
		if ( v.Type == "r_custom" or v.Type == "r_global" ) and v.Rank == old then
			
			v.Rank = new
			
		end
		
	end
	
	UpdateRankTags()
	ATAG.SB_SendRanks( ply )
	
	UpdateSelectedTags()
	
end

function ATAG:SB_ChangePlayer( ply, old, new )
	
	if not self:HasPermissions( ply ) then return end
	if not ATAG.PlayerTags[2][ old ] then return end
	--if ATAG.PlayerTags[2][ new ] then return end
	
	for k, v in pairs( ATAG.PlayerTags[1] ) do
	
		if v[1] == old then
			v[1] = new
		end
		
	end
	
	ATAG.PlayerTags[2][ new ] = ATAG.PlayerTags[2][ old ]
	
	ATAG.PlayerTags[2][ old ] = nil

	if ATAG.SelectedTags[ old ] then
		
		ATAG.SelectedTags[ new ] = ATAG.SelectedTags[ old ]
		ATAG.SelectedTags[ old ] = nil
		
	end
	
	UpdatePlayerTags()
	ATAG.SB_SendPlayers( ply )
	
	UpdateSelectedTags()
	
end


-- PLAYER

function ATAG.CH_GetTags_player(ply, SteamID)
	if not ATAG:HasPermissions(ply) then return {} end
	if not DoesPlayerChatTagExist(SteamID) then return {} end
	return ATAG.PlayerChatTags[2][SteamID]
end

function ATAG.CH_GetPlayers(ply)
	if not ATAG:HasPermissions(ply) then return {} end
	return ATAG.PlayerChatTags[1]
end

function ATAG.CH_AddPlayer(ply, SteamID, force)
	if not ATAG:HasPermissions(ply) then return end
	if DoesPlayerChatTagExist(SteamID) then return end
	
	table.insert(ATAG.PlayerChatTags[1], {SteamID, GetPlayerName(SteamID)})
	ATAG.PlayerChatTags[2][SteamID] = {}
	
	UpdatePlayerChatTags()
	ATAG.CH_SendPlayers(ply)
end

function ATAG.CH_RemovePlayer(ply, SteamID)
	if not ATAG:HasPermissions(ply) then return end
	
	for k, v in pairs(ATAG.PlayerChatTags[1]) do
		if v[1] == SteamID then
			table.remove(ATAG.PlayerChatTags[1], k)
		end
	end
	
	ATAG.PlayerChatTags[2][SteamID] = nil
	
	UpdatePlayerChatTags()
	ATAG.CH_SendPlayers(ply)
end

function ATAG.CH_ChangePlayerName(ply, SteamID, Name)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	for k, v in pairs(ATAG.PlayerChatTags[1]) do
		if v[1] == SteamID then
			if Name ~= nil then
				ATAG.PlayerChatTags[1][k][2] = Name
			else
				local plyName = GetPlayerName(SteamID)
				if plyName ~= "" then
					ATAG.PlayerChatTags[1][k][2] = GetPlayerName(SteamID)
				end
			end
		end
	end
	
	UpdatePlayerChatTags()
	ATAG.CH_SendPlayers(ply)
end

-- Chat Piece
function ATAG.CH_AddTagPiece_player(ply, SteamID, Name, color)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	table.insert(ATAG.PlayerChatTags[2][SteamID], {Name, color})
	
	UpdatePlayerChatTags()
	ATAG.CH_SendTags_player(ply, SteamID, SelectPos)
end

function ATAG.CH_RemoveTagPiece_player(ply, SteamID, Pos)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	table.remove(ATAG.PlayerChatTags[2][SteamID], tonumber(Pos))
	
	UpdatePlayerChatTags()
	ATAG.CH_SendTags_player(ply, SteamID, SelectPos)
end

function ATAG.CH_MoveTagPiece_player(ply, SteamID, Pos, NewPos)
	if not ATAG:HasPermissions(ply) then return end
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	local Pos = tonumber(Pos)
	local NewPos = tonumber(NewPos)
	
	if NewPos < 1 then return end
	if NewPos > table.getn(ATAG.PlayerChatTags[2][SteamID]) + 1 then return end
	
	local Table = table.Copy(ATAG.PlayerChatTags[2][SteamID][Pos])
	
	local PosDifference = Pos - NewPos
	local SelectPos = 0
		
	table.insert(ATAG.PlayerChatTags[2][SteamID], NewPos, Table)
	
	if PosDifference < 1 then
		table.remove(ATAG.PlayerChatTags[2][SteamID], Pos)
		SelectPos = NewPos-1
	else
		table.remove(ATAG.PlayerChatTags[2][SteamID], Pos+1)
		SelectPos = NewPos
	end
	
	UpdatePlayerChatTags()
	ATAG.CH_SendTags_player(ply, SteamID, SelectPos)
end





-- Own Tag
function ATAG.CH_CanEditOwnTag(ply)

	if not ply then return end

	for k, v in pairs(ATAG.PlayerChatTags[1]) do
		if v[1] == ply:SteamID() then
			if v.CST then
				return true
			end
		end
	end
	
	for k, v in pairs(ATAG.RankChatTags[1]) do
		if v[1] == ATAG:GetUserGroup( ply ) then
			if v.CST then
				return true
			end
		end
	end
	
	return false
	
end

function ATAG.CH_ToggleCanSetOwnTag(ply, Type, Value)
	if not ATAG:HasPermissions(ply) then return end
	
	if Type == "player" then
	
		if not DoesPlayerChatTagExist(Value) then return end
		
		for k, v in pairs(ATAG.PlayerChatTags[1]) do
			if v[1] == Value then
				if v.CST then
					v.CST = false
				else
					v.CST = true
				end
			end
		end
		
		UpdatePlayerChatTags()
		ATAG.CH_SendPlayers(ply)
		
	elseif Type == "rank" then
		
		if not DoesRankChatTagExist(Value) then return end
		
		for k, v in pairs(ATAG.RankChatTags[1]) do
			if v[1] == Value then
				if v.CST then
					v.CST = false
				else
					v.CST = true
				end
			end
		end
		
		UpdateRankChatTags()
		ATAG.CH_SendRanks(ply)
	
	end
end

function ATAG.CH_GetOwnTag(ply)
	if not ATAG.CH_CanEditOwnTag(ply) then return end
	if not DoesPlayerChatTagExist(ply:SteamID()) then return end
	
	return ATAG.PlayerChatTags[2][ply:SteamID()]
end

function ATAG.CH_OwnTag_AddPlayer(ply, Rank)
	if not ATAG.CH_CanEditOwnTag(ply) then return end
	if DoesPlayerChatTagExist(ply:SteamID()) then return end
	
	table.insert(ATAG.PlayerChatTags[1], {ply:SteamID(), ply:Name(), AA = Rank})
	ATAG.PlayerChatTags[2][ply:SteamID()] = {}
	
	UpdatePlayerChatTags()
end

function ATAG.CH_AddTagPiece_owntag(ply, Name, color)
	if not ATAG.CH_CanEditOwnTag(ply) then return end
	
	if not DoesPlayerChatTagExist(ply:SteamID()) then
		ATAG.CH_OwnTag_AddPlayer(ply, ATAG:GetUserGroup( ply ))
	end
	
	local SteamID = ply:SteamID()
	
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	table.insert(ATAG.PlayerChatTags[2][SteamID], {Name, color})
	
	UpdatePlayerChatTags()
	ATAG.CH_SendOwnTags(ply)
end

function ATAG.CH_RemoveTagPiece_owntag(ply, Pos)
	if not ATAG.CH_CanEditOwnTag(ply) then return end
	
	if not DoesPlayerChatTagExist(ply:SteamID()) then
		ATAG.CH_OwnTag_AddPlayer(ply, ATAG:GetUserGroup( ply ))
	end
	
	local SteamID = ply:SteamID()
	
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	table.remove(ATAG.PlayerChatTags[2][SteamID], tonumber(Pos))
	
	UpdatePlayerChatTags()
	ATAG.CH_SendOwnTags(ply)
end

function ATAG.CH_MoveTagPiece_owntag(ply, Pos, NewPos)
	if not ATAG.CH_CanEditOwnTag(ply) then return end
	
	if not DoesPlayerChatTagExist(ply:SteamID()) then
		ATAG.CH_OwnTag_AddPlayer(ply, ATAG:GetUserGroup( ply ))
	end
	
	local SteamID = ply:SteamID()
	
	if not DoesPlayerChatTagExist(SteamID) then return end
	
	local Pos = tonumber(Pos)
	local NewPos = tonumber(NewPos)
	
	if NewPos < 1 then return end
	if NewPos > table.getn(ATAG.PlayerChatTags[2][SteamID]) + 1 then return end
	
	local Table = table.Copy(ATAG.PlayerChatTags[2][SteamID][Pos])
	
	local PosDifference = Pos - NewPos
	local SelectPos = 0
		
	table.insert(ATAG.PlayerChatTags[2][SteamID], NewPos, Table)
	
	if PosDifference < 1 then
		table.remove(ATAG.PlayerChatTags[2][SteamID], Pos)
		SelectPos = NewPos-1
	else
		table.remove(ATAG.PlayerChatTags[2][SteamID], Pos+1)
		SelectPos = NewPos
	end
	
	UpdatePlayerChatTags()
	ATAG.CH_SendOwnTags(ply, SelectPos)
end

PrepareFiles()

--[[ -- Table Structure

{ -- Tags
	
	.NewID
	
	} -- Tags .Tags
		{TagID, "TagName", TagColor}
	}
	
}

{ -- PlayerTags

	{ -- Players .[1]
		{"SteamID", "PlayerName"}
	}
	
	{ -- Tags .[2]
		{ -- .["SteamID"]
			
			{ -- ExistingTag .Etags
				TagID(int)
			}
			
			.NewID
			
			{ -- CustomTag .Ctags
				
				{CustomTagID(int), "TagName", TagColor}
			}

		}
	}
	
}

{ -- Scoreboard Data

	{ .["SteamID"]
		{"TagName", TagColor}
	}
	
}

{ -- RankChatTags
	
	{ RankNames .[1]
		"RankName"
	}
	
	{ .[2]
		{ .["Rankname"]
			{"TagPart", Color}
		}
	}
	
}

]]