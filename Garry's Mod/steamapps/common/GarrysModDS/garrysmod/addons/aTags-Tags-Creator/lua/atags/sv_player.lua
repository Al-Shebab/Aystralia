local _this = aTags
local meta = FindMetaTable( "Player" )

function meta:updateChatTag()
	
	-- That's all D:
	self:SetVar( "aTags_ch", ATAG:GetChatTagTable( self ) )
	
end

function meta:updateScoreboardTag()
	
	-- That's all D:
	self:SetVar( "aTags_sb", ATAG:GetSelectedScoreboardTag( self ) )
	
end

-- A single players chat tag.
function meta:sendChatTag( ply )
	
	local tag = ply:GetVar( "aTags_ch", nil )
	if not tag then return end
	
	_this.network:send( self, "chat_tag", ply:UniqueID(), tag )
	
end

-- All players chat tag.
function meta:sendChatTags()

	local tags = {}
	for _, ply in pairs( player.GetAll() ) do
		tags[ ply:UniqueID() ] = ply:GetVar( "aTags_ch", nil )
	end
	
	_this.network:send( self, "chat_tags", tags )
	
end

-- A single players scoreboard tag.
function meta:sendScoreboardTag( ply )
	
	local tag = ply:GetVar( "aTags_sb", nil )
	if not tag then return end
	
	_this.network:send( self, "scoreboard_tag", ply:UniqueID(), tag )
	
end

-- All players scoreboard tags.
function meta:sendScoreboardTags()
	
	local tags = {}
	for _, ply in pairs( player.GetAll() ) do
		tags[ ply:UniqueID() ] = ply:GetVar( "aTags_sb", nil )
	end
	
	_this.network:send( self, "scoreboard_tags", tags )
	
end