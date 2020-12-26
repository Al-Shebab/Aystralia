
local PANEL = {}

sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)

function PANEL:Init()
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)
	self:SetBackgroundColour(sKore.getShadowColour)
	self:SetOverlayColour(sKore.getShadowColour)
end

function PANEL:GetRippleRadius()
	if !self.radius then
		self.radius = math.sqrt(math.pow(self:GetWide(), 2) + math.pow(self:GetTall(), 2))
	end
	return self.radius
end

function PANEL:Paint(width, height)
	draw.NoTexture()
	if self.rippleAnimation != nil and self.ripple != nil then
		local fraction = math.min((SysTime() - self.rippleAnimation.StartTime) / (self.rippleAnimation.EndTime - self.rippleAnimation.StartTime), 1)
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(self.ripple[1], self.ripple[2], self:GetRippleRadius() * fraction)
	elseif self:IsPressed() then
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		surface.DrawRect(0, 0, width, height)
	elseif self.fadeAnimation != nil then
		local fraction = 1 - math.min((SysTime() - self.fadeAnimation.StartTime) / (self.fadeAnimation.EndTime - self.fadeAnimation.StartTime), 1)
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41 * fraction))
		surface.DrawRect(0, 0, width, height)
	end
	surface.SetDrawColor(self:GetBackgroundColour())
	surface.DrawRect(0, 0, width, height)
	sKore.drawShadows(self)
end

function PANEL:PerformLayout()
	self.radius = nil
	local parent = self:GetParent()

	self:SetWidth(math.Clamp(self:GetWide(), 0, parent:GetWide()))
	self:SetHeight(math.Clamp(self:GetTall(), 0, parent:GetTall()))
	self:SetPos(
		math.Clamp(self.x, 0, parent:GetWide() - self:GetWide()),
		math.Clamp(self.y, 0, parent:GetTall() - self:GetTall())
	)
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
	local parent = self:GetParent()
	local x, y = parent:ScreenToLocal(gui.MouseX(), gui.MouseY())
	self.dragging = {x - self.x, y - self.y}
end

function PANEL:OnMouseReleased(mousecode)
	self:MouseCapture(false)
	if self:IsDisabled() or !self:IsPressed() then return end
	if self.rippleAnimation == nil then self:FadeOutAnimation() end
	self.pressed = nil
end

function PANEL:Think()
	if self.dragging then
		if !input.IsMouseDown(MOUSE_LEFT) then
			self.dragging = nil
		else
			local parent = self:GetParent()
			local x, y = parent:ScreenToLocal(gui.MouseX(), gui.MouseY())
			x = math.Clamp(x - self.dragging[1], 0, parent:GetWide() - self:GetWide())
			y = math.Clamp(y - self.dragging[2], 0, parent:GetTall() - self:GetTall())
			self:SetPos(x, y)
		end
	end
end

derma.DefineControl("MScrollBarGrip", "", PANEL, "MPanel")
