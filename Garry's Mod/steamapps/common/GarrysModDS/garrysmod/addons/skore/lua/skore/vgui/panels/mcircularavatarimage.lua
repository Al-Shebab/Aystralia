
local PANEL = {}

sKore.AccessorFunc(PANEL, "cursor", "Cursor", sKore.FORCE_STRING)

function PANEL:Init()
	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:SetPaintedManually(true)
	self.avatar:Dock(FILL)

	self.avatar.OnMousePressed = function()
		if !self.inRange then return end
		self.avatar:MouseCapture(true)
		self.avatar.pressed = true
	end
	self.avatar.OnMouseReleased = function(_, mousecode)
		self.avatar:MouseCapture(false)
		if !self.avatar.pressed then return end

		if self.inRange then
			if mousecode == MOUSE_RIGHT then
				self:DoRightClick()
			elseif mousecode == MOUSE_LEFT then
				self:DoClick()
			elseif mousecode == MOUSE_MIDDLE then
				self:DoMiddleClick()
			end
		end

		self.avatar.pressed = nil
	end
	self.avatar.OnCursorMoved = function(_, mousex, mousey)
		self:OnCursorMoved(mousex, mousey)
	end

	self:SetCursor("arrow")
end

function PANEL:Paint(width, height)
	local x, y = width / 2, height / 2
	local radius = math.max(x, y)
	local circle = sKore.getCircleVertices(x, y, radius)

	draw.NoTexture()
	surface.SetDrawColor(self:GetBackgroundColour())

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

	surface.DrawRect(0, 0, width, height)
	self.avatar:PaintManual()
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
	self.avatar:SetCursor(self.inRange and self:GetCursor() or "arrow")
end

function PANEL:SetPlayer(...) return self.avatar:SetPlayer(...) end
function PANEL:SetSteamID(...) return self.avatar:SetSteamID(...) end

function PANEL:DoClick() end
function PANEL:DoRightClick() end
function PANEL:DoMiddleClick() end

derma.DefineControl("MCircularAvatarImage", "", PANEL, "MPanel")
