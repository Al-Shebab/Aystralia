local PlyHeight = 48

local PLAYER = {}
PLAYER.Padding = 8

function PLAYER:Init()

	self:SetTall( PlyHeight )

	self.Name = Label( "Unknown", self )
	self.Name:SetFont( "ScoreboardName" )
	self.Name:SetColor( Color( 255, 255, 255 ) )

	self.Location = Label( "Unknown", self )
	self.Location:SetFont( "ScoreboardLocation" )
	self.Location:SetColor( Color( 255, 255, 255, 80 ) )
	self.Location:SetPos( 0, 8 )

	self.AvatarButton = vgui.Create("DButton", self)
	self.AvatarButton:SetSize( 32, 32 )
	
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:SetSize( 32, 32 )
	self.Avatar:SetZPos( 1 )
	self.Avatar:SetVisible( false )
	self.Avatar:SetMouseInputEnabled( false )

	self.Ping = vgui.Create( "ScoreboardPlayerPing", self )
	
	self.aTags = Label( "", self )
	self.aTags:SetFont( "ScoreboardName" )
	self.aTags:SetColor( Color( 255, 255, 255 ) )

end

function PLAYER:UpdatePlayer()

	if !IsValid(self.Player) then

		local parent = self:GetParent()
		if ValidPanel(parent) and parent.RemovePlayer then
			parent:RemovePlayer(self.Player)
		end

		return

	end

	self.Name:SetText( self.Player:Name() )
	self.Location:SetText( string.upper( self.Player:GetLocationName() or "Unknown" ) )
	self.Ping:Update()
	
	local name, color = hook.Call( "aTag_GetScoreboardTag", nil, self.Player )
	
	self.aTags:SetText( name or "")
	self.aTags:SetColor( color or Color( 255, 255, 255 ) )

end

function PLAYER:SetPlayer( ply )

	self.Player = ply
	
	self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

	self.Avatar:SetPlayer( ply, 64 )
	self.Avatar:SetVisible( true )

	self.Ping:SetPlayer( ply )

	self:UpdatePlayer()

end

function PLAYER:PerformLayout()

	self.Name:SizeToContents()
	self.Name:AlignTop( self.Padding - 2 )
	self.Name:AlignLeft( self.Avatar:GetWide() + 16 )

	self.Location:SizeToContents()
	self.Location:AlignTop( self.Name:GetTall() + 5 )
	self.Location:AlignLeft( self.Avatar:GetWide() + 16 )
	
	self.AvatarButton:AlignTop( self.Padding )
	self.AvatarButton:AlignLeft( self.Padding )
	self.AvatarButton:CenterVertical()
	
	self.Avatar:SizeToContents()
	self.Avatar:AlignTop( self.Padding )
	self.Avatar:AlignLeft( self.Padding )
	self.Avatar:CenterVertical()

	self.Ping:InvalidateLayout()
	self.Ping:SizeToContents()
	self.Ping:AlignRight( self.Padding )
	self.Ping:CenterVertical()
	
	self.aTags:SizeToContents()
	self.aTags:AlignRight( self.Padding + 120 )
	self.aTags:CenterVertical()
	
end

local PixeltailIcon = Material( "theater/pixeltailicon.png" )
local AdminIcon = Material( "theater/adminicon.png" )

function PLAYER:Paint( w, h )

	surface.SetDrawColor( 38, 41, 49, 255 )
	surface.DrawRect( 0, 0, self:GetSize() )

	surface.SetDrawColor( 255, 255, 255, 255 )

	if self.Player.IsPixelTail && self.Player:IsPixelTail() then

		surface.SetMaterial( PixeltailIcon )
		surface.DrawTexturedRect( self.Name.x + self.Name:GetWide() + 5, self.Name.y + 3, 40, 16 )
	
	elseif self.Player:IsAdmin() then
		
		surface.SetMaterial( AdminIcon )
		surface.DrawTexturedRect( self.Name.x + self.Name:GetWide() + 5, self.Name.y + 3, 40, 16 )

	end
	
end

vgui.Register( "ScoreboardPlayer", PLAYER )