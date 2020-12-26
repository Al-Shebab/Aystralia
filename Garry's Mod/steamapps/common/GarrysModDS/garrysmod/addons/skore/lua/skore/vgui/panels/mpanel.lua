
local PANEL = {}

table.Merge(PANEL, sKore.elevationGAS)
table.Merge(PANEL, sKore.shadowGAS)
table.Merge(PANEL, sKore.enabledGAS)
sKore.AccessorFunc(PANEL, "backgroundColour", "BackgroundColour", sKore.FORCE_COLOUR)

function PANEL:Init()
	self:SetElevation(2)
	self:SetShadowOffsetX(1)
	self:SetShadowOffsetY(1)
	self:SetPaintShadow(true)
	self:SetDrawShadows(true)
	self:SetDrawGlobalShadows(true)
	self:SetBackgroundColour(sKore.getBackgroundColour, 3)
	self:SetEnabled(true)

	local parent = self:GetParent()
	if parent.AddShadow then parent:AddShadow(self) end
	self.frame = sKore.getFrame(self)
end

function PANEL:Paint(width, height)
	draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
	sKore.drawShadows(self)
end

function PANEL:PaintShadow(x, y)
	draw.RoundedBox(sKore.scale(6), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour())
end

derma.DefineControl("MPanel", "", PANEL, "Panel")
