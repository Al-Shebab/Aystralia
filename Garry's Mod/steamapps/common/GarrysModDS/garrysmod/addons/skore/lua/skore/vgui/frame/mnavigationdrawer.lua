
local PANEL = {}

sKore.AccessorFunc(PANEL, "minimumWidth", "MinimumWidth", sKore.FORCE_NUMBER, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "maximumWidth", "MaximumWidth", sKore.FORCE_NUMBER, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "drawerWidth", "DrawerWidth", sKore.FORCE_NUMBER, sKore.invalidateLayoutNow)

function PANEL:Init()
	self:SetZPos(self.frame:GetZPos() + 1002)
	self:SetElevation(3)
	self:SetShadowOffsetY(0)
	self:SetGlobalShadow(true)

	self.canvasPanel = vgui.Create("MVScrollPanel", self)
	self.canvasPanel:Dock(FILL)
	self.canvasPanel:SetScrollbarWidth(0)

	self.items = {}
	self.scale = 0

	self:SetMinimumWidth(function() return self:GetParent():GetWide() * 0.166 end)
	self:SetMaximumWidth(function() return self:GetParent():GetWide() * 0.25 end)
	self:SetDrawerWidth(0)
end

function PANEL:GetNavigationDrawerWidth()
	local minimumChildrenWidth = {0}
	for _, child in pairs(self.items) do
		if child.GetMinimumWidth then
			table.insert(minimumChildrenWidth, child:GetMinimumWidth())
		end
	end
	minimumChildrenWidth = math.max(unpack(minimumChildrenWidth))

	local maximumWidth = self:GetMaximumWidth()
	minimumWidth = math.max(minimumChildrenWidth, self:GetMinimumWidth())
	minimumWidth = math.min(minimumWidth, maximumWidth)
	return math.Clamp(self:GetDrawerWidth(), minimumWidth, maximumWidth)
end

function PANEL:AddOption(text, icon)
	if !isstring(text) then error("'text' argument is not a string!", 2) end
	if !isstring(icon) and icon != nil then error("'icon' argument is neither a string nor nil!", 2) end
	local button = vgui.Create("MNavigationDrawerButton", self.canvasPanel)
	button:SetText(text)
	button:Dock(TOP)
	if icon then button:SetMaterial(sKore.getBackgroundMaterial, icon) end

	table.insert(self.items, button)
	return button
end
PANEL.AddButton = PANEL.AddOption

function PANEL:AddSpacer()
	local spacer = vgui.Create("MPanel", self.canvasPanel)
	spacer:SetPaintShadow(false)
	spacer:Dock(TOP)
	spacer.PerformLayout = function()
		spacer:SetTall(sKore.scaleRC(1, 1))
		spacer:DockMargin(0, sKore.scale(3), 0, sKore.scale(4))
	end
	spacer.Paint = function(_, width, height)
		draw.RoundedBox(0, 0, 0, width, height, sKore.getShadowColour())
	end

	table.insert(self.items, spacer)
	return spacer
end
PANEL.AddDivider = PANEL.AddSpacer

function PANEL:AddLabel(text)
	local base = vgui.Create("MPanel", self.canvasPanel)
	base:SetPaintShadow(false)
	base.Paint = function() end
	base:Dock(TOP)
	base.PerformLayout = function()
		base:SetTall(sKore.scaleR(28))
		base:DockPadding(sKore.scale(16), 0, sKore.scale(16), 0)
		base:DockMargin(0, sKore.scale(3), 0, sKore.scale(4))
	end

	local label = vgui.Create("DLabel", base)
	label:SetFont("sKoreNavigationDrawerLabel")
	label:SetContentAlignment(1)
	label:Dock(FILL)
	label.PerformLayout = function()
		label:SetText(sKore.getPhrase(text))
		label:SetTextColor(sKore.getBackgroundTextColour(sKore.MEDIUM_EMPHASIS))
	end

	base.GetMinimumWidth = function()
		surface.SetFont("sKoreNavigationDrawerLabel")
		local width = surface.GetTextSize(sKore.getPhrase(text))
		return width + sKore.scaleR(16) * 2
	end

	table.insert(self.items, base)
	return base
end

function PANEL:Open(instantly)
	if self.opening == true then return end
	if instantly then self.scale = 0 return end
	self.opening = true
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

	self:SetVisible(true)
end

function PANEL:Close(instantly)
	if self.opening == false then return end
	if instantly then self.scale = 1 return end
	self.opening = false
	local origin = self.scale
	local offset = 1 - origin

	self.animation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.animation != animation then return end
		self:SetVisible(false)
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
	elseif self.scale == 0 then
		self:Close()
	else
		self:Open()
	end
end

function PANEL:Paint(width, height)
	draw.RoundedBoxEx(sKore.scale(8), 0, 0, width, height, sKore.getBackgroundColour(3), false, false, true, false)
end

function PANEL:PaintOver()
	sKore.drawShadows(self)
end

function PANEL:PaintShadow(x, y)
	draw.RoundedBoxEx(sKore.scale(8), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour(), false, false, true, false)
end

function PANEL:PerformLayout()
	self:SetWidth(self:GetNavigationDrawerWidth())

	local position = (self:GetWide() + sKore.scale(8)) * -self.scale
	self:SetPos(position, self.y)
	self:DockMargin(position, 0, 0, 0)

	self.canvasPanel:SetPadding(0, sKore.scale(5), 0, sKore.scale(8))
end

derma.DefineControl("MNavigationDrawer", "", PANEL, "MPanel")
