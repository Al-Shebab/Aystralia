
local PANEL = {}

sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)
sKore.AccessorFunc(PANEL, "material", "Material", sKore.FORCE_MATERIAL_NIL, sKore.invalidateLayout)

function PANEL:Init()
	self.image = vgui.Create("DImage", self)
	self.image:SetMouseInputEnabled(false)
	self.image:Dock(FILL)

	self:SetPaintShadow(false)
	self:SetDrawShadows(false)
	self:SetOverlayColour(sKore.getPrimaryColour, 3)
end

function PANEL:GetRippleRadius()
	if !self.radius then
		self.radius = math.sqrt(math.pow(self:GetWide(), 2) + math.pow(self:GetTall(), 2))
	end
	return self.radius
end

function PANEL:Paint(width, height)
	if self.rippleAnimation != nil and self.ripple != nil then
		local fraction = math.min((SysTime() - self.rippleAnimation.StartTime) / (self.rippleAnimation.EndTime - self.rippleAnimation.StartTime), 1)
		draw.NoTexture()
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(self.ripple[1], self.ripple[2], self:GetRippleRadius() * fraction)
	elseif self:IsPressed() then
		draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(self:GetOverlayColour(), 41))
	elseif self.fadeAnimation != nil then
		local fraction = 1 - math.min((SysTime() - self.fadeAnimation.StartTime) / (self.fadeAnimation.EndTime - self.fadeAnimation.StartTime), 1)
		draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(self:GetOverlayColour(), 41 * fraction))
	end
	if self:IsHovered() then
		draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(self:GetOverlayColour(), 41))
	end
	sKore.drawShadows(self)
end

function PANEL:PerformLayout(width, height)
	self.radius = nil
	self:SetCursor(self:IsEnabled() and "hand" or "arrow")

	if self.material then
		self.image:SetVisible(true)
		self.image:SetMaterial(self:GetMaterial())
		local margin = sKore.scaleC(1, 1)
		self.image:DockMargin(margin, margin, margin, margin)
	else
		self.image:SetVisible(false)
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

function PANEL:OnMousePressed()
	if self:IsDisabled() then return end
	self:MouseCapture(true)
	local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	self.ripple = {mousex, mousey}
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

derma.DefineControl("MWindowBarButton", "", PANEL, "MPanel")
