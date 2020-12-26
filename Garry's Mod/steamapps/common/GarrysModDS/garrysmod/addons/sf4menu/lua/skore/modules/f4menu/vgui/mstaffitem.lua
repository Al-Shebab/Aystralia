
local PANEL = {}

sKore.AccessorFunc(PANEL, "title", "Title", sKore.FORCE_STRING, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "description", "Description", sKore.FORCE_STRING, sKore.invaldiateLayout)

function PANEL:Init()
	self.avatar = vgui.Create("MCircularAvatarImage", self)
	self.avatar:SetCursor("hand")

	self.nameLabel = vgui.Create("DLabel", self)
	self.nameLabel:SetFont("sF4MenuItemTitle")
	self.nameLabel:SetWrap(true)
	self.nameLabel:SetPaintedManually(true)
	self.nameLabel:Dock(TOP)

	self.rankLabel = vgui.Create("DLabel", self)
	self.rankLabel:SetFont("sF4MenuItemDescription")
	self.rankLabel:SetWrap(true)
	self.rankLabel:SetPaintedManually(true)
	self.rankLabel:Dock(TOP)

	self:SetPaintShadow(false)
	self:SetElevation(0)
	self:SetTitle("")
	self:SetDescription("")
end

function PANEL:SetPlayer(ply)
	if !ply:IsPlayer() then error("'player' argument is not a player!", 2) end
	self.avatar:SetPlayer(ply, 184)
	self:SetTitle(ply:GetName())
	self:SetDescription(ply:GetUserGroup())
	self.avatar.DoClick = function()
		ply:ShowProfile()
	end
end

function PANEL:SizeToContentsY()
	local height = self.avatar.y + self.avatar:GetTall() + sKore.scale(16)
	self:SetTall(height)
end

function PANEL:Paint(width, height)
	draw.RoundedBox(0, 0, 0, width, sKore.scaleRC(1, 1), sKore.getShadowColour())
	self.nameLabel:PaintManual()
	self.rankLabel:PaintManual()
	sKore.drawShadows(self)
end

function PANEL:PerformLayout(width, height)
	self.avatar:SetSize(sKore.scale(92), sKore.scale(92))
	self.avatar:SetPos(sKore.scale(16), sKore.scale(16))
	self:SizeToContentsY()

	local textColour = sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS)
	local leftMargin = self.avatar.x + self.avatar:GetWide() + sKore.scale(16)
	local title = sKore.getPhrase(self:GetTitle())
	local description = sKore.getPhrase(self:GetDescription())

	self.nameLabel:DockMargin(leftMargin, sKore.scale(14), sKore.scale(8), 0)
	self.nameLabel:SetText(title)
	self.nameLabel:SetTextColor(textColour)
	self.nameLabel:SizeToContentsY()

	self.rankLabel:DockMargin(leftMargin, sKore.scale(8), sKore.scale(8), 0)
	self.rankLabel:SetText(description)
	self.rankLabel:SetTextColor(textColour)
	self.rankLabel:SizeToContentsY()
end

function PANEL:SetBackgroundColor(...) self.avatar:SetBackgroundColor(...) end
function PANEL:GetBackgroundColor(...) self.avatar:GetBackgroundColor(...) end

derma.DefineControl("MStaffItem", "", PANEL, "MPanel")
