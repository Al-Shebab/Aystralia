
local PANEL = {}

sKore.AccessorFunc(PANEL, "overlayColour", "OverlayColour", sKore.FORCE_COLOUR)
sKore.AccessorFunc(PANEL, "cursor", "Cursor", sKore.FORCE_STRING)

function PANEL:Init()
	self.modelpanel = vgui.Create("DModelPanel", self)
	self.modelpanel:SetPaintedManually(true)
	self.modelpanel:Dock(FILL)

	self.modelpanel.OnMousePressed = function()
		if !self.inRange then return end
		self.modelpanel:MouseCapture(true)

		local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
		self.ripple = {mousex, mousey}
		self.fadeAnimation = nil
		self.rippleAnimation = self:NewAnimation(0.25, 0, -1, function(animation)
			if animation != self.rippleAnimation then return end
			self.rippleAnimation = nil
			if !self.modelpanel.pressed then self:FadeOutAnimation() end
		end)

		self.modelpanel.pressed = true
	end
	self.modelpanel.OnMouseReleased = function(_, mousecode)
		self.modelpanel:MouseCapture(false)
		if !self.modelpanel.pressed then return end

		if self.inRange then
			if mousecode == MOUSE_RIGHT then
				self:DoRightClick()
			elseif mousecode == MOUSE_LEFT then
				self:DoClick()
			elseif mousecode == MOUSE_MIDDLE then
				self:DoMiddleClick()
			end
		end

		if self.rippleAnimation == nil then self:FadeOutAnimation() end

		self.modelpanel.pressed = nil
	end
	self.modelpanel.OnCursorMoved = function(_, mousex, mousey)
		self:OnCursorMoved(mousex, mousey)
	end

	self:SetBackgroundColour(sKore.getPrimaryColour, sKore.PRIMARY)
	self:SetOverlayColour(sKore.getPrimaryColour, sKore.PRIMARY_LIGHT)
	self:SetCursor("arrow")
end

function PANEL:Paint(width, height)
	local x, y = width / 2, height / 2
	local radius = math.max(x, y)
	local circle = sKore.getCircleVertices(x, y, radius)

	draw.NoTexture()
	surface.SetDrawColor(Color(0, 0, 0))

	render.SetStencilFailOperation(STENCILOPERATION_INCR)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

	surface.DrawPoly(circle)

	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(2)

	draw.RoundedBox(0, 0, 0, width, height, self:GetBackgroundColour())

	draw.NoTexture()
	if self.rippleAnimation != nil and self.ripple != nil then
		local fraction = math.min((SysTime() - self.rippleAnimation.StartTime) / (self.rippleAnimation.EndTime - self.rippleAnimation.StartTime), 1)
		self.radius = self.radius or math.sqrt(math.pow(width, 2) + math.pow(height, 2))
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		sKore.drawCircle(self.ripple[1], self.ripple[2], self.radius * fraction)
	elseif self.modelpanel.pressed then
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41))
		surface.DrawRect(0, 0, width, height)
	elseif self.fadeAnimation != nil then
		local fraction = 1 - math.min((SysTime() - self.fadeAnimation.StartTime) / (self.fadeAnimation.EndTime - self.fadeAnimation.StartTime), 1)
		surface.SetDrawColor(ColorAlpha(self:GetOverlayColour(), 41 * fraction))
		surface.DrawRect(0, 0, width, height)
	end

	self.modelpanel:PaintManual()
	sKore.drawShadows(self)

	render.SetStencilFailOperation(STENCILOPERATION_DECR)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	surface.DrawPoly(circle)

	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)
end

function PANEL:PaintShadow(x, y)
	local xOffset, yOffset = self:GetWide() / 2, self:GetTall() / 2
	local radius = math.max(xOffset, yOffset)
	draw.NoTexture()
	surface.SetDrawColor(sKore.getShadowColour())
	sKore.drawCircle(x + xOffset, y + yOffset, radius)
end

function PANEL:OnCursorMoved(mousex, mousey)
	local x, y = self:GetWide() / 2, self:GetTall() / 2
	local radius = math.max(x, y)
	local distance = math.sqrt(math.pow(x - mousex, 2) + math.pow(y - mousey, 2))
	self.inRange = distance <= radius
	self.modelpanel:SetCursor(self.inRange and self:GetCursor() or "arrow")
end

function PANEL:PerformLayout()
	self.radius = nil
	self.modelpanel.LayoutEntity = self.LayoutEntity or self.modelpanel.LayoutEntity
	self.modelpanel.PostDrawModel = self.PostDrawModel or self.modelpanel.PostDrawModel
	self.modelpanel.PreDrawModel = self.PreDrawModel or self.modelpanel.PreDrawModel
end

function PANEL:FadeOutAnimation()
	self.fadeAnimation = self:NewAnimation(0.5, 0, -1, function(animation)
		if animation != self.fadeAnimation then return end
		self.fadeAnimation = nil
		self.ripple = nil
	end)
end

function PANEL:DrawModel(...) return self.modelpanel:DrawModel(...) end
function PANEL:GetAmbientLight(...) return self.modelpanel:GetAmbientLight(...) end
function PANEL:GetAnimated(...) return self.modelpanel:GetAnimated(...) end
function PANEL:GetAnimSpeed(...) return self.modelpanel:GetAnimSpeed(...) end
function PANEL:GetCamPos(...) return self.modelpanel:GetCamPos(...) end
function PANEL:GetColor(...) return self.modelpanel:GetColor(...) end
function PANEL:GetEntity(...) return self.modelpanel:GetEntity(...) end
function PANEL:GetFOV(...) return self.modelpanel:GetFOV(...) end
function PANEL:GetLookAng(...) return self.modelpanel:GetLookAng(...) end
function PANEL:GetLookAt(...) return self.modelpanel:GetLookAt(...) end
function PANEL:GetModel(...) return self.modelpanel:GetModel(...) end
function PANEL:RunAnimation(...) return self.modelpanel:RunAnimation(...) end
function PANEL:SetAmbientLight(...) return self.modelpanel:SetAmbientLight(...) end
function PANEL:SetAnimated(...) return self.modelpanel:SetAnimated(...) end
function PANEL:SetAnimSpeed(...) return self.modelpanel:SetAnimSpeed(...) end
function PANEL:SetAnimSpeed(...) return self.modelpanel:SetAnimSpeed(...) end
function PANEL:SetCamPos(...) return self.modelpanel:SetCamPos(...) end
function PANEL:SetDirectionalLight(...) return self.modelpanel:SetDirectionalLight(...) end
function PANEL:SetEntity(...) return self.modelpanel:SetEntity(...) end
function PANEL:SetFOV(...) return self.modelpanel:SetFOV(...) end
function PANEL:SetLookAng(...) return self.modelpanel:SetLookAng(...) end
function PANEL:SetLookAt(...) return self.modelpanel:SetLookAt(...) end
function PANEL:StartScene(...) return self.modelpanel:StartScene(...) end
function PANEL:SetModel(...) return self.modelpanel:SetModel(...) end

function PANEL:DoClick() end
function PANEL:DoRightClick() end
function PANEL:DoMiddleClick() end

derma.DefineControl("MCircularModelPanel", "", PANEL, "MPanel")
