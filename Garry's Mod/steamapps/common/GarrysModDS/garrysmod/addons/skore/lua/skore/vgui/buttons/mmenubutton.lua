
local PANEL = {}

sKore.AccessorFunc(PANEL, "textColour", "TextColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)
sKore.AccessorFunc(PANEL, "text", "Text", sKore.FORCE_STRING, sKore.invalidateLayoutNow)

function PANEL:Init()
	self.label = vgui.Create("DLabel", self)
	self.label:SetFont("sKoreButton")
	self.label:SetContentAlignment(4)
	self.label:Dock(FILL)

	self:SetElevation(0)
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)

	self:SetEnabled(true)
	self:SetTextColour(function()
		return sKore.getBackgroundTextColour(self:IsEnabled() and sKore.HIGH_EMPHASIS or sKore.MEDIUM_EMPHASIS)
	end)
	self:SetOverlayColour(sKore.primaryTextColourAlgorithm)
	self:SetText("BUTTON")
end

function PANEL:GetMinimumWidth()
	surface.SetFont("sKoreButton")
	local textWidth = surface.GetTextSize(sKore.getPhrase(self:GetText()))
	return textWidth + sKore.scaleR(16) * 2
end

function PANEL:Paint(width, height)
	draw.NoTexture()
	if self.rippleAnimation != nil and self.ripple != nil then
		local fraction = math.min((SysTime() - self.rippleAnimation.StartTime) / (self.rippleAnimation.EndTime - self.rippleAnimation.StartTime), 1)
		self.radius = self.radius or math.sqrt(math.pow(width, 2) + math.pow(height, 2))
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(self.ripple[1], self.ripple[2], self.radius * fraction)
	elseif self:IsPressed() then
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		surface.DrawRect(0, 0, width, height)
	elseif self.fadeAnimation != nil then
		local fraction = 1 - math.min((SysTime() - self.fadeAnimation.StartTime) / (self.fadeAnimation.EndTime - self.fadeAnimation.StartTime), 1)
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41 * fraction))
		surface.DrawRect(0, 0, width, height)
	end
	if self:IsHovered() then
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		surface.DrawRect(0, 0, width, height)
	end
end

function PANEL:PerformLayout(width, height)
	height = sKore.scaleR(48)
	self:SetTall(height)
	self.radius = nil
	self:SetCursor(self:IsEnabled() and "hand" or "arrow")

	self.label:SetTextColor(self:GetTextColour())
	self.label:SetText(sKore.getPhrase(self:GetText()))
	self.label:DockMargin(sKore.scale(16), 0, sKore.scale(16), 0)
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

derma.DefineControl("MMenuButton", "", PANEL, "MPanel")
