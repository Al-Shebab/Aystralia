
local PANEL = {}

sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)
sKore.AccessorFunc(PANEL, "darkOverlay", "IsDarkOverlay", sKore.FORCE_BOOL_NIL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "material", "Material", sKore.FORCE_MATERIAL, sKore.invalidateLayout)

function PANEL:Init()
	self.image = vgui.Create("DImage", self)
	self.image:SetMouseInputEnabled(false)

	self:SetElevation(0)
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)
	self:SetMaterial(sKore.getPrimaryMaterial, sKore.PRIMARY, "dots-vertical")
	self:SetIsDarkOverlay(sKore.isPrimaryTextBlack, sKore.PRIMARY)
end

function PANEL:Paint(width, height)
	draw.NoTexture()
	if self.rippleAnimation != nil and self.ripple != nil then
		local fraction = math.min((SysTime() - self.rippleAnimation.StartTime) / (self.rippleAnimation.EndTime - self.rippleAnimation.StartTime), 1)
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(width / 2, height / 2, (height / 2) * fraction)
	elseif self:IsPressed() then
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(width / 2, height / 2, height / 2)
	elseif self.fadeAnimation != nil then
		local fraction = 1 - math.min((SysTime() - self.fadeAnimation.StartTime) / (self.fadeAnimation.EndTime - self.fadeAnimation.StartTime), 1)
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41 * fraction))
		sKore.drawCircle(width / 2, height / 2, height / 2)
	end
	if self:IsHovered() then
		local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
		local radius = self:GetTall() / 2
		local distance = math.sqrt(math.pow((self:GetWide() / 2) - mousex , 2) + math.pow(mousey - radius, 2))
		if distance <= radius then
			surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
			sKore.drawCircle(width / 2, height / 2, height / 2)
		end
	end
end

function PANEL:PerformLayout(width, height)
	if !self:IsVisible() then return end
	height = sKore.scaleR(48)
	width = height
	self:SetSize(width, height)

	if self:GetIsDarkOverlay() != nil then
		if self:GetIsDarkOverlay() then
			self:SetOverlayColour(Color(0, 0, 0))
		else
			self:SetOverlayColour(Color(255, 255, 255))
		end
	end

	self.image:SetMaterial(self:GetMaterial())
	self.image:SetSize(sKore.scaleR(28), sKore.scaleR(28))
	self.image:Center()
end

function PANEL:IsPressed()
	return self.pressed
end

function PANEL:FadeOutAnimation()
	self.fadeAnimation = self:NewAnimation(0.4, 0, -1, function(animation)
		if animation != self.fadeAnimation then return end
		self.fadeAnimation = nil
		self.ripple = nil
	end)
end

function PANEL:OnMousePressed(mousecode)
	if self:IsDisabled() then return end

	local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	local radius = self:GetTall() / 2
	local distance = math.sqrt(math.pow((self:GetWide() / 2) - mousex , 2) + math.pow(mousey - radius, 2))
	if distance > radius then return end

	self:MouseCapture(true)
	local x, y = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	self.ripple = {x, y}
	self.fadeAnimation = nil
	self.rippleAnimation = self:NewAnimation(0.2, 0, -1, function(animation)
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

	local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	local radius = self:GetTall() / 2
	local distance = math.sqrt(math.pow((self:GetWide() / 2) - mousex , 2) + math.pow(mousey - radius, 2))

	if self:IsHovered() and distance <= radius then
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

function PANEL:OnCursorMoved(mousex, mousey)
	local radius = self:GetTall() / 2
	local distance = math.sqrt(math.pow((self:GetWide() / 2) - mousex , 2) + math.pow(mousey - radius, 2))
	self:SetCursor(distance <= radius and "hand" or "arrow")
end

derma.DefineControl("MAppBarButton", "", PANEL, "MPanel")
