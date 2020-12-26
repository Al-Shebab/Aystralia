
local PANEL = {}

sKore.AccessorFunc(PANEL, "textColour", "TextColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)
sKore.AccessorFunc(PANEL, "text", "Text", sKore.FORCE_STRING, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "material", "Material", sKore.FORCE_MATERIAL_NIL, sKore.invalidateLayoutNow)

function PANEL:Init()
	self.label = vgui.Create("DLabel", self)
	self.label:SetFont("sKoreButton")
	self.label:SetContentAlignment(4)

	self.image = vgui.Create("DImage", self)
	self.image:SetMouseInputEnabled(false)

	self:SetElevation(0)
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)

	self:SetEnabled(true)
	self:SetTextColour(sKore.primaryTextColourAlgorithm)
	self:SetOverlayColour(sKore.primaryTextColourAlgorithm)
	self:SetText("BUTTON")
end

function PANEL:Paint(width, height)
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

function PANEL:PerformLayout(width, height)
	height = sKore.scaleR(36)
	self:SetTall(height)
	self.radius = nil
	self:SetCursor(self:IsEnabled() and "hand" or "arrow")

	self.label:SetTextColor(self:GetTextColour())
	self.label:SetText(sKore.getPhrase(self:GetText()))
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

function PANEL:SizeToContents()
	self.label:SizeToContents()
	if self:GetMaterial() != nil then
		self:SetWide(self.label:GetWide() + self.image:GetWide() + sKore.scaleR(8) * 3)
		self.image:SetPos(sKore.scaleR(8), (self:GetTall() - self.image:GetTall()) / 2)
		self.label:SetPos(sKore.scaleR(8) * 2 + self.image:GetWide(), (self:GetTall() - self.label:GetTall()) / 2)
	else
		self:SetWide(self.label:GetWide() + sKore.scaleR(8) * 2)
		self.label:Center()
	end
end

function PANEL:IsPressed()
	return self.pressed
end

function PANEL:FadeOutAnimation()
	self.fadeAnimation = self:NewAnimation(0.5, 0, -1, function(animation)
		if animation != self.fadeAnimation then return end
		self.fadeAnimation = nil
		self.ripple = nil
	end)
end

function PANEL:OnMousePressed(mousecode)
	if self:IsDisabled() then return end

	self:MouseCapture(true)
	local x, y = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	self.ripple = {x, y}
	self.fadeAnimation = nil
	self.rippleAnimation = self:NewAnimation(0.25, 0, -1, function(animation)
		if animation != self.rippleAnimation then return end
		self.rippleAnimation = nil
		if !self:IsPressed() then self:FadeOutAnimation() end
	end)
	self.pressed = true
	self:OnPressed()
end

function PANEL:OnMouseReleased(mousecode)
	self:MouseCapture(false)
	if self:IsDisabled() or !self:IsPressed() then return end

	if self:IsHovered() then
		if mousecode == MOUSE_LEFT then
			self:DoClick()
		elseif mousecode == MOUSE_RIGHT then
			self:DoRightClick()
		elseif mousecode == MOUSE_MIDDLE then
			self:DoMiddleClick()
		end
	end

	if self.rippleAnimation == nil then self:FadeOutAnimation() end

	self.pressed = nil
	self:OnReleased()
end

function PANEL:OnPressed() end
function PANEL:OnReleased() end
function PANEL:DoClick() end
function PANEL:DoRightClick() end
function PANEL:DoMiddleClick() end

derma.DefineControl("MFlatButton", "", PANEL, "MPanel")
