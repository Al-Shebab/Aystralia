
local PANEL = {}

sKore.AccessorFunc(PANEL, "text", "Text", sKore.FORCE_STRING, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "textColour", "TextColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)

function PANEL:Init()
	self:SetZPos(self.frame:GetZPos() + 1500)

	self.label = vgui.Create("DLabel", self)
	self.label:SetFont("sKoreSnackbar")
	self.label:SetWrap(true)

	self:SetElevation(7)
	self:SetText("Snackbar")
	self:SetTextColour(sKore.getBackgroundTextColourInverted, sKore.HIGH_EMPHASIS)
	self:SetBackgroundColour(sKore.getBackgroundColourInverted, 3)
	self:SetGlobalShadow(true)
end

function PANEL:PerformLayout(width, height)
	if self.skipPerformLayout then self.skipPerformLayout = nil return end
	local parent = self:GetParent()
	if !IsValid(parent) then return end

	self.label:SetWide(parent:GetWide() - sKore.scaleR(24) * 4)
	self.label:SetText(sKore.getPhrase(self:GetText()))
	self.label:SetTextColor(self:GetTextColour())
	self.label:SetPos(sKore.scaleR(24), sKore.scaleR(12))
	timer.Simple(0, function()
		timer.Simple(0, function()
			if !IsValid(self) then return end
			self.label:SizeToContentsY()
			self.label:SizeToContentsX()

			self:SetSize(self.label:GetWide() + sKore.scaleR(24) * 2, self.label:GetTall() + sKore.scaleR(12) * 2)
			self.skipPerformLayout = true
		end)
	end)
end

function PANEL:Paint(width, height)
	draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
end

function PANEL:PaintOver()
	sKore.drawShadows(self)
end

derma.DefineControl("MSnackbar", "", PANEL, "MPanel")
