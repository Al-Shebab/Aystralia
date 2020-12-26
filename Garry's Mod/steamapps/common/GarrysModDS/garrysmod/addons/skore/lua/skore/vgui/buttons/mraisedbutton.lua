
local PANEL = {}

sKore.AccessorFunc(PANEL, "darkOverlay", "IsDarkOverlay", sKore.FORCE_BOOL_NIL, sKore.invalidateLayout)

function PANEL:Init()
	self:SetElevation(2)
	self:SetPaintShadow(true)
	self:SetDrawShadows(true)
	self:SetBackgroundColour(sKore.getPrimaryColour, sKore.PRIMARY)
	self:SetTextColour(sKore.getPrimaryTextColour, sKore.PRIMARY, sKore.HIGH_EMPHASIS)
	self:SetIsDarkOverlay(sKore.isPrimaryTextBlack, sKore.PRIMARY)
	self:SetText("BUTTON")
end

function PANEL:Paint(width, height)
	draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
	if self.rippleAnimation != nil and self.ripple != nil then
		local fraction = math.min((SysTime() - self.rippleAnimation.StartTime) / (self.rippleAnimation.EndTime - self.rippleAnimation.StartTime), 1)
		self.radius = self.radius or math.sqrt(math.pow(width, 2) + math.pow(height, 2))
		draw.NoTexture()
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(self.ripple[1], self.ripple[2], self.radius * fraction)
	elseif self:IsPressed() then
		draw.RoundedBox(sKore.scale(6), 0, 0, width, height, ColorAlpha(self:GetOverlayColour(), 41))
	elseif self.fadeAnimation != nil then
		local fraction = 1 - math.min((SysTime() - self.fadeAnimation.StartTime) / (self.fadeAnimation.EndTime - self.fadeAnimation.StartTime), 1)
		draw.RoundedBox(sKore.scale(6), 0, 0, width, height, ColorAlpha(self:GetOverlayColour(), 41 * fraction))
	end
	if self:IsHovered() then
		draw.RoundedBox(sKore.scale(6), 0, 0, width, height, ColorAlpha(self:GetOverlayColour(), 41))
	end
end

function PANEL:PaintOver()
	sKore.drawShadows(self)
end

function PANEL:PaintShadow(x, y)
	draw.RoundedBox(sKore.scale(6), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour())
end

function PANEL:PerformLayout(width, height)
	height = sKore.scaleR(36)
	self:SetTall(height)
	self.radius = nil
	self:SetCursor(self:IsEnabled() and "hand" or "arrow")

	if self:GetIsDarkOverlay() != nil then
		if self:GetIsDarkOverlay() then
			self:SetOverlayColour(Color(0, 0, 0))
		else
			self:SetOverlayColour(Color(255, 255, 255))
		end
	end

	self.label:SetTextColor(self:GetTextColour())
	self.label:SetText(sKore.getPhrase(self:GetText()) or self:GetText())
	self.label:SizeToContents()

	if self:GetMaterial() != nil then
		local x = (self:GetWide() - self.label:GetWide() - self.image:GetWide() - sKore.scaleR(8)) / 2
		self.image:SetVisible(true)
		self.image:SetMaterial(self:GetMaterial())
		self.image:SetSize(sKore.scaleR(28), sKore.scaleR(28))
		self.image:SetPos(x, (self:GetTall() - self.image:GetTall()) / 2)
		self.label:SetPos(x + self.image:GetWide() + sKore.scaleR(8), (self:GetTall() - self.label:GetTall()) / 2)
	else
		self.image:SetVisible(false)
		self.label:Center()
	end
end

derma.DefineControl("MRaisedButton", "", PANEL, "MFlatButton")
