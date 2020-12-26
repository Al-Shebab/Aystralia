
local PANEL = {}

sKore.AccessorFunc(PANEL, "textColour", "TextColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)
sKore.AccessorFunc(PANEL, "text", "Text", sKore.FORCE_STRING, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "material", "Material", sKore.FORCE_MATERIAL_NIL, sKore.invalidateLayoutNow)

function PANEL:Init()
	self.image = vgui.Create("DImage", self)
	self.image:SetMouseInputEnabled(false)
	self.image:Dock(LEFT)

	self.label = vgui.Create("DLabel", self)
	self.label:SetFont("sKoreNavigationDrawerButton")
	self.label:SetContentAlignment(4)
	self.label:Dock(FILL)

	self:SetElevation(0)
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)

	self:SetTextColour(function()
		return sKore.getBackgroundTextColour(self:IsEnabled() and sKore.HIGH_EMPHASIS or sKore.DISABLED_EMPHASIS)
	end)
	self:SetOverlayColour(sKore.primaryTextColourAlgorithm)
	self:SetText("BUTTON")
end

function PANEL:GetMinimumWidth()
	surface.SetFont("sKoreNavigationDrawerButton")
	local textWidth = surface.GetTextSize(sKore.getPhrase(self:GetText()))
	return self.label.x + textWidth + sKore.scaleR(16) + sKore.scaleR(8)
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
	height = sKore.scaleR(40)
	self:SetTall(height)
	self.radius = nil
	self:SetCursor(self:IsEnabled() and "hand" or "arrow")
	local margin = sKore.scale(8)
	self:DockMargin(margin, sKore.scale(3), margin, sKore.scale(3))
	self:DockPadding(margin, 0, margin, 0)

	self.label:SetTextColor(self:GetTextColour())
	self.label:SetText(sKore.getPhrase(self:GetText()))

	local material = self:GetMaterial()
	if material != nil then
		self.image:SetVisible(true)
		self.image:SetMaterial(material)
		local size = height - sKore.scaleR(6) * 2
		self.image:SetSize(size, size)
		self.image:DockMargin(0, sKore.scaleR(6), sKore.scale(28), sKore.scaleR(6))
	else
		self.image:SetVisible(false)
		self.image:SetWidth(0)
		self.image:DockMargin(0, 0, 0, 0)
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

derma.DefineControl("MNavigationDrawerButton", "", PANEL, "MPanel")
