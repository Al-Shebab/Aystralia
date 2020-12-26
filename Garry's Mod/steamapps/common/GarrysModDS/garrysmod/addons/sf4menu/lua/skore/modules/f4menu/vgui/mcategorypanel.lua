
local PANEL = {}

function PANEL:Init()
	self.titleButton = vgui.Create("MCategoryButton", self)
	self.titleButton:Dock(TOP)
	self.titleButton.DoClick = function()
		self:Toggle()
	end

	self.scale = 1
	self.show = 1

	self.lastItem = self.titleButton

	self:SetDrawShadows(false)
end

function PANEL:SetCollapsed(collapsed)
	if !isbool(collapsed) then error("'collapsed' argument is not a boolean!", 2) end
	self.scale = collapsed and 1 or 0
end

function PANEL:GetCollapsed()
	return self.scale > 0
end
PANEL.IsCollapsed = PANEL.GetCollapsed

function PANEL:GetUncollapsedHeight()
	return self.titleButton:GetTall()
end

function PANEL:GetCollapsedHeight()
	return self.lastItem.y + self.lastItem:GetTall()
end

function PANEL:GetOffsetHeight()
	return self:GetCollapsedHeight() - self:GetUncollapsedHeight()
end

function PANEL:Open(instantly)
	if self.opening == true then return end
	if instantly then self.scale = 1 return end
	self.opening = true
	local origin = self.scale
	local offset = 1 - origin

	self.animation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.animation != animation then return end
		self.animation = nil
		self.opening = nil
	end)
	self.animation.Think = function(animation, panel, fraction)
		if self.animation != animation then return end
		self.scale = origin + offset * fraction
		self:InvalidateLayout(true)
	end
end

function PANEL:Close(instantly)
	if self.opening == false then return end
	if instantly then self.scale = 0 return end
	self.opening = false
	local origin = self.scale
	local offset = 0 - origin

	self.animation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.animation != animation then return end
		self.animation = nil
		self.opening = nil
	end)
	self.animation.Think = function(animation, panel, fraction)
		if self.animation != animation then return end
		self.scale = origin + offset * fraction
		self:InvalidateLayout(true)
	end
end

function PANEL:Toggle()
	if self.opening == true then
		self:Close()
	elseif self.opening == false then
		self:Open()
	elseif self.scale == 1 then
		self:Close()
	else
		self:Open()
	end
end

function PANEL:Show(instantly)
	if self.hiding == false then return end
	if instantly then self.show = 1 return end
	if self.show == 1 then return end
	self.hiding = false
	local origin = self.show
	local offset = 1 - origin

	self.showAnimation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.showAnimation != animation then return end
		self.showAnimation = nil
		self.hiding = nil
	end)
	self.showAnimation.Think = function(animation, panel, fraction)
		if self.showAnimation != animation then return end
		self.show = origin + offset * fraction
		self:InvalidateLayout(true)
	end
end

function PANEL:Hide(instantly)
	if self.hiding == true then return end
	if instantly then self.show = 0 return end
	if self.show == 0 then return end
	self.hiding = true
	local origin = self.show
	local offset = 0 - origin

	self.showAnimation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.showAnimation != animation then return end
		self.showAnimation = nil
		self.hiding = nil
	end)
	self.showAnimation.Think = function(animation, panel, fraction)
		if self.showAnimation != animation then return end
		self.show = origin + offset * fraction
		self:InvalidateLayout(true)
	end
end

function PANEL:ShouldShow()
	for _, child in pairs(self:GetChildren()) do
		if child != self.titleButton and child:GetTall() != 0 then
			return true
		end
	end
	return false
end

function PANEL:OnChildAdded(child)
	child:Dock(TOP)
	self.lastItem = child
end

function PANEL:PerformLayout()
	if self:ShouldShow() then self:Show() else self:Hide() end

	local height = (self:GetUncollapsedHeight() + self:GetOffsetHeight() * self.scale) * self.show
	self:SetHeight(height)
	self:SetPaintShadow(height > sKore.scale(6))
	local topMargin, sideMargin = sKore.scale(8) * self.show, sKore.scale(16)
	self:DockMargin(sideMargin, topMargin, sideMargin, topMargin)
end

function PANEL:SetText(...) return self.titleButton:SetText(...) end
function PANEL:GetText(...) return self.titleButton:GetText(...) end
function PANEL:SetTextColour(...) return self.titleButton:SetTextColour(...) end
function PANEL:GetTextColour(...) return self.titleButton:GetTextColour(...) end

derma.DefineControl("MCategoryPanel", "", PANEL, "MPanel")
