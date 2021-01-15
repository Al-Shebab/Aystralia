local _material = Material('effects/flashlight001')

local function preDrawCircle(poly)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	draw.NoTexture()
	surface.SetMaterial(_material)
	surface.SetDrawColor(color_black)
	surface.DrawPoly(poly)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)
end

local function postDrawCircle()
	render.SetStencilEnable(false)
	render.ClearStencil()
end

local PANEL = {}

function PANEL:Init()
	self.Avatar = vgui.Create('AvatarImage', self)
	self.Avatar:SetPaintedManually()
	self.Avatar.OnMouseReleased = function(...) self.OnMouseReleased(...) end
end

function PANEL:SetFullSize(w, h)
	self.Avatar:SetSize(w, h)
	self.Poly = draw.GenerateCircle(w / 2, h / 2, w / 2, 48)
end

function PANEL:Paint(w, h)
	preDrawCircle(self.Poly)

	self.Avatar:SetPaintedManually(false)
	self.Avatar:PaintManual()
	self.Avatar:SetPaintedManually(true)

	postDrawCircle()
end

function PANEL:SetSteamID(...)
	self.Avatar:SetSteamID(...)
end

function PANEL:SetPlayer(...)
	self.Avatar:SetPlayer(...)
end

function PANEL:OnMouseReleased()
end

vgui.Register('OSXAvatar', PANEL)

local PANEL = {}

function PANEL:Init()
	self.ModelImage = vgui.Create('ModelImage', self)
	self.ModelImage:SetPaintedManually()
	self.ModelImage.OnMouseReleased = function(...) self.OnMouseReleased(...) end
end

function PANEL:SetFullSize(w, h)
	self.ModelImage:SetSize(w, h)
	self.Poly = draw.GenerateCircle(w / 2, h / 2, w / 2, 36)
end

function PANEL:Paint(w, h)
	preDrawCircle(self.Poly)

	self.ModelImage:SetPaintedManually(false)
	self.ModelImage:PaintManual()
	self.ModelImage:SetPaintedManually(true)

	postDrawCircle()
end

function PANEL:SetModel(...)
	self.ModelImage:SetModel(...)
end

function PANEL:OnMouseReleased()
end

vgui.Register('OSXModelImage', PANEL)

local PANEL = {}

function PANEL:Init()
	self.Origin = BOTTOM
end

function PANEL:SetOrigin(originEnum)
	if not (originEnum == TOP
		or originEnum == LEFT
		or originEnum == RIGHT
		or originEnum == BOTTOM)
	then
		return error('invalid origin')
	end
	self.Origin = originEnum
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(F4Menu.Colors.Arrow)
	surface.SetTexture(0)
	if self.Origin == TOP or self.Origin == BOTTOM then
		local isBottom = self.Origin == BOTTOM
		local y = isBottom and h/2 - 3 or h/2 + 3
		surface.DrawTexturedRectRotated(0, y, 1, 22, isBottom and 45 or -45)
		surface.DrawTexturedRectRotated(w, y, 1, 22, isBottom and -45 or 45)
	else
		local isRight = self.Origin == RIGHT
		surface.DrawTexturedRectRotated(w/2 - 3, h/2 + 7, 2, 22, isRight and -45 or 45)
		surface.DrawTexturedRectRotated(w/2 - 3, h/2 - 7, 2, 22, isRight and 45 or -45)
	end
end

vgui.Register('OSXArrow', PANEL)
