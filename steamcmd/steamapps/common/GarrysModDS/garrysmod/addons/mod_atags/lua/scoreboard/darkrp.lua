FAdmin.PlayerIcon = {}
FAdmin.PlayerIcon.RightClickOptions = {}

function FAdmin.PlayerIcon.AddRightClickOption(name, func)
	FAdmin.PlayerIcon.RightClickOptions[name] = func
end

-- FAdminPanelList
local PANEL = {}

function PANEL:Init()
	self.Padding = 5
end

function PANEL:SizeToContents()
	local w, h = self:GetSize()

	w = math.Clamp(w, ScrW()*0.9, ScrW()*0.9) -- Fix size of w to have the same size as the scoreboard
	h = math.Min(h, ScrH()*0.95)
	if #self:GetChildren() == 1 then -- It fucks up when there's only one icon in
		h = math.Max(y or 0, 120)
	end

	self:SetSize(w, h)
	self:PerformLayout()
end

function PANEL:Paint()
end

derma.DefineControl("FAdminPanelList", "DPanellist adapted for FAdmin", PANEL, "DPanelList")

-- FAdmin player row (from the sandbox player row)
PANEL = {}

CreateClientConVar("FAdmin_PlayerRowSize", 30, true, false)
function PANEL:Init()
	self.Size = GetConVarNumber("FAdmin_PlayerRowSize")

	self.lblName 	= vgui.Create("DLabel", self)
	self.lblFrags 	= vgui.Create("DLabel", self)
	self.lblTeam	= vgui.Create("DLabel", self)
	
	self.lblaTag	= vgui.Create("DLabel", self)
	
	self.lblDeaths 	= vgui.Create("DLabel", self)
	self.lblPing 	= vgui.Create("DLabel", self)
	self.lblWanted 	= vgui.Create("DLabel", self)

	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled(false)
	self.lblTeam:SetMouseInputEnabled(false)

	self.lblaTag:SetMouseInputEnabled(false)	
			
	self.lblFrags:SetMouseInputEnabled(false)
	self.lblDeaths:SetMouseInputEnabled(false)
	self.lblPing:SetMouseInputEnabled(false)
	self.lblWanted:SetMouseInputEnabled(false)

	self.lblName:SetColor(Color(255,255,255,200))
	self.lblTeam:SetColor(Color(255,255,255,200))
	
	self.lblaTag:SetColor(Color(255,255,255,200))
			
	self.lblFrags:SetColor(Color(255,255,255,200))
	self.lblDeaths:SetColor(Color(255,255,255,200))
	self.lblPing:SetColor(Color(255,255,255,200))
	self.lblWanted:SetColor(Color(255,255,255,200))

	self.imgAvatar = vgui.Create("AvatarImage", self)

	self:SetCursor("hand")
end

function PANEL:Paint()
	if not IsValid(self.Player) then return end

	self.Size = GetConVarNumber("FAdmin_PlayerRowSize")
	self.imgAvatar:SetSize(self.Size - 4, self.Size - 4)

	local color = Color(100, 150, 245, 255)


	if GAMEMODE.Name == "Sandbox" then
		color = Color(100, 150, 245, 255)
		if self.Player:Team() == TEAM_CONNECTING then
			color = Color(200, 120, 50, 255)
		elseif self.Player:IsAdmin() then
			color = Color(30, 200, 50, 255)
		end

		if self.Player:GetFriendStatus() == "friend" then
			color = Color(236, 181, 113, 255)
		end
	else
		color = team.GetColor(self.Player:Team())
	end

	local hooks = hook.GetTable().FAdmin_PlayerRowColour
	if hooks then
		for k,v in pairs(hooks) do
			color = (v and v(self.Player, color)) or color
			break
		end
	end

	draw.RoundedBox(4, 0, 0, self:GetWide(), self.Size, color)

	surface.SetTexture(0)
	if self.Player == LocalPlayer() or self.Player:GetFriendStatus() == "friend" then
		surface.SetDrawColor(255, 255, 255, 50 + math.sin(RealTime() * 2) * 50)
	end
	surface.DrawTexturedRect(0, 0, self:GetWide(), self.Size)
	return true
end

function PANEL:SetPlayer(ply)
	self.Player = ply

	self.imgAvatar:SetPlayer(ply)

	self:UpdatePlayerData()
end

function PANEL:UpdatePlayerData()
	if not self.Player then return end
	if not self.Player:IsValid() then return end

	self.lblName:SetText(DarkRP.deLocalise(self.Player:Nick()))
	self.lblTeam:SetText((self.Player.DarkRPVars and DarkRP.deLocalise(self.Player:getDarkRPVar("job") or "")) or team.GetName(self.Player:Team()))
	self.lblTeam:SizeToContents()
	
	local name, color = hook.Call( "aTag_GetScoreboardTag", nil, self.Player )
	
	self.lblaTag:SetText(name or "")
	self.lblaTag:SetColor(color or Color(255, 255, 255))
	

	self.lblFrags:SetText(self.Player:Frags())
	self.lblDeaths:SetText(self.Player:Deaths())
	self.lblPing:SetText(self.Player:Ping())
	self.lblWanted:SetText(self.Player:isWanted() and DarkRP.getPhrase("Wanted_text") or "")
end

function PANEL:ApplySchemeSettings()
	self.lblName:SetFont("ScoreboardPlayerNameBig")
	self.lblTeam:SetFont("ScoreboardPlayerNameBig")
	
	self.lblaTag:SetFont("ScoreboardPlayerNameBig")
	
	self.lblFrags:SetFont("ScoreboardPlayerName")
	self.lblDeaths:SetFont("ScoreboardPlayerName")
	self.lblPing:SetFont("ScoreboardPlayerName")
	self.lblWanted:SetFont("ScoreboardPlayerNameBig")

	self.lblName:SetFGColor(color_white)
	self.lblTeam:SetFGColor(color_white)
	
	self.lblaTag:SetFGColor(color_white)
	
	self.lblFrags:SetFGColor(color_white)
	self.lblDeaths:SetFGColor(color_white)
	self.lblPing:SetFGColor(color_white)
	self.lblWanted:SetFGColor(color_white)
end

function PANEL:DoClick(x, y)
	if not IsValid(self.Player) then self:Remove() return end
	FAdmin.ScoreBoard.ChangeView("Player", self.Player)
end

function PANEL:DoRightClick()
	if table.Count(FAdmin.PlayerIcon.RightClickOptions) < 1 then return end
	local menu = DermaMenu()

	menu:SetPos(gui.MouseX(), gui.MouseY())

	for Name, func in pairs(FAdmin.PlayerIcon.RightClickOptions) do
		menu:AddOption(Name, function() if IsValid(self.Player) then func(self.Player, self) end end)
	end

	menu:Open()
end

function PANEL:Think()
	if not self.PlayerUpdate or self.PlayerUpdate < CurTime() then
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
	end
end

function PANEL:PerformLayout()
	self.imgAvatar:SetPos(2, 2)
	self.imgAvatar:SetSize(32, 32)

	self:SetSize(self:GetWide(), self.Size)

	self.lblName:SizeToContents()
	self.lblName:SetPos(24, 2)
	self.lblName:MoveRightOf(self.imgAvatar, 8)

	local COLUMN_SIZE = 75

	self.lblPing:SetPos(self:GetWide() - COLUMN_SIZE * 0.4, 0)
	self.lblDeaths:SetPos(self:GetWide() - COLUMN_SIZE * 1.4, 0)
	self.lblFrags:SetPos(self:GetWide() - COLUMN_SIZE * 2.4, 0)

	self.lblTeam:SetPos(self:GetWide() / 2 - (0.5*self.lblTeam:GetWide()))
	
	
	self.lblaTag:SizeToContents()
	self.lblaTag:SetPos((self:GetWide() * 0.70) - (0.5*self.lblaTag:GetWide()) + ATAG.scoreboardPosition, 5)
	
	
	self.lblWanted:SizeToContents()
	self.lblWanted:SetPos(math.floor(self:GetWide() / 4), 2)
end
vgui.Register("FadminPlayerRow", PANEL, "Button")