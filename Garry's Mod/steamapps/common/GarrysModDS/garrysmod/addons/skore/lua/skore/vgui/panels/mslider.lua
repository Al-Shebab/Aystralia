
local PANEL = {}

sKore.AccessorFunc(PANEL, "minimumValue", "MinimumValue", sKore.FORCE_NUMBER)
sKore.AccessorFunc(PANEL, "maximumValue", "MaximumValue", sKore.FORCE_NUMBER)
sKore.AccessorFunc(PANEL, "barColour", "BarColour", sKore.FORCE_COLOUR)

function PANEL:Init()
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)
	self:SetMinimumValue(0)
	self:SetMaximumValue(1)
	self:SetValue(0.5)
	self:SetBarColour(sKore.primaryTextColourAlgorithm)

	self.circleExtraRadius = 0

	self:SetCursor("hand")
end

function PANEL:SetValue(newValue)
	if !isnumber(newValue) then error("'newValue' argument is not a number!", 2) end
	local oldValue = self.value
	self.value = newValue
	if newValue != oldValue then self:OnValueChanged(self.value) end
end

function PANEL:GetValue()
	return math.Clamp(self.value, self:GetMinimumValue(), self:GetMaximumValue())
end

function PANEL:GetProgress()
	local minValue = self:GetMinimumValue()
	return (self:GetValue() - minValue) / (self:GetMaximumValue() - minValue)
end

function PANEL:IsPressed()
	return self.pressed or false
end

function PANEL:Paint(width, height)
	local tall = sKore.scaleRC(2, 2)
	local y = (height - tall) / 2
	local x = sKore.scaleR(11)
	local trackSize = width - x * 2
	local progress = self:GetProgress()
	local barColor = self:GetBarColour()

	draw.NoTexture()
	surface.SetDrawColor(ColorAlpha(barColor, 66))
	surface.DrawRect(x, y, trackSize, tall)
	surface.SetDrawColor(barColor)
	surface.DrawRect(x, y, trackSize * progress, tall)

	surface.SetDrawColor(barColor)
	sKore.drawCircle(x + trackSize * progress, y + tall / 2, sKore.scaleR(8 + self.circleExtraRadius))
end

function PANEL:PerformLayout(width, height)
	height = sKore.scaleR(32)
	self:SetTall(height)
end

function PANEL:OnMousePressed(mousecode)
	self:MouseCapture(true)

	self.pressAnimation = self:NewAnimation(0.1, 0)
	self.pressAnimation.Think = function(anim, panel, fraction)
		if self.pressAnimation != anim then return end
		self.circleExtraRadius = 3 * fraction
	end

	self.pressed = true
	self:OnPressed()
end

function PANEL:OnMouseReleased(mousecode)
	self:MouseCapture(false)

	self.pressAnimation = self:NewAnimation(0.1, 0)
	local pressedState = self.circleExtraRadius
	self.pressAnimation.Think = function(anim, panel, fraction)
		if self.pressAnimation != anim then return end
		self.circleExtraRadius = pressedState * (1 - fraction)
	end

	self.pressed = nil
	self:OnReleased()
end

function PANEL:Think()
	if self:IsPressed() then
		local x = self:ScreenToLocal(gui.MouseX(), 0)
		x = x - sKore.scaleR(11)

		local trackSize = self:GetWide() - sKore.scaleR(11) * 2
		local progress = math.Clamp(x / trackSize, 0, 1)
		local minValue = self:GetMinimumValue()

		self:SetValue(minValue + (self:GetMaximumValue() - minValue) * progress)
	end
end

function PANEL:OnPressed() end
function PANEL:OnReleased() end
function PANEL:OnValueChanged() end

derma.DefineControl("MSlider", "", PANEL, "MPanel")
