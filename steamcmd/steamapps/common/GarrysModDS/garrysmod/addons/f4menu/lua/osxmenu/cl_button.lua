local PANEL = {}

AccessorFunc(PANEL, 'LabelColor', 'LabelColor')
AccessorFunc(PANEL, 'BackgroundColor', 'BackgroundColor')

function PANEL:Init()
	self.BaseClass.Init(self)

	self:SetFont('OSXButton')
	self:SetBackgroundColor(F4Menu.Colors.Background)
	self:SetLabelColor(F4Menu.Colors.Button)
	self:SetTall(38)
end

function PANEL:Paint(w, h)
	local outlineColor = self:GetLabelColor()
	local backgroundColor = self.Hovered and outlineColor or self:GetBackgroundColor()

	draw.RoundedBox(6, 0, 0, w, h, outlineColor)
	draw.RoundedBox(6, 2, 2, w - 4, h - 4, backgroundColor)
end

function PANEL:UpdateColours()
	local textColor = self.Hovered and self:GetBackgroundColor() or self:GetLabelColor() or F4Menu.Colors.Background
	self:SetTextStyleColor(textColor)
end

vgui.Register('OSXButton', PANEL, 'DButton')

local PANEL = {}

AccessorFunc(PANEL, 'PropertySheet', 'PropertySheet')
AccessorFunc(PANEL, 'Panel', 'Panel')

function PANEL:Init()
	self.BaseClass.Init(self)

	self:SetFont('OSXButton')
	self:SetTall(38)
	self:SetContentAlignment(4)
	self:SetTextInset(14, 0)
end

function PANEL:Paint(w, h)
	if self.Hovered and self:GetDisabled() then
		local backgroundColor = F4Menu.Colors.ItemSelected
		draw.RoundedBox(6, 0, 0, w, h, backgroundColor)
		return
	end

	if self.Hovered then
		local backgroundColor = F4Menu.Colors.NavItem
		draw.RoundedBox(6, 0, 0, w, h, backgroundColor)
	end
end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()
	self:GetPropertySheet():SetActiveTab(self)
end

function PANEL:DragHoverClick()
	self:DoClick()
end

function PANEL:UpdateColours()
	local textColor = self.Hovered and (not self:GetDisabled()) and F4Menu.Colors.NavItemText or F4Menu.Colors.Text
	self:SetTextStyleColor(textColor)
end

vgui.Register('OSXTab', PANEL, 'DButton')

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)

	self:SetFont('OSXButton')
	self:SetTall(38)
	self:SetContentAlignment(4)
	self:SetTextInset(14, 0)
end

function PANEL:Paint(w, h)
	if self.Hovered and not self:GetDisabled() then
		local backgroundColor = F4Menu.Colors.NavItem
		draw.RoundedBox(6, 0, 0, w, h, backgroundColor)
	end
end

function PANEL:DoClick()
end

function PANEL:DragHoverClick()
	self:DoClick()
end

function PANEL:UpdateColours()
	local textColor = self.Hovered and F4Menu.Colors.NavItemText or F4Menu.Colors.Text

	self:SetTextStyleColor(textColor)
end

vgui.Register('OSXTabButton', PANEL, 'DButton')

local PANEL = {}

function PANEL:Init()
	self:SetSize(100, 1)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, h / 2 - 1, w, 1, F4Menu.Colors.Border)
end

vgui.Register('OSXSpacer', PANEL, 'DPanel')

local PANEL = {}

AccessorFunc(PANEL, 'TextColor', 'TextColor')
AccessorFunc(PANEL, 'BackgroundColor', 'BackgroundColor')
AccessorFunc(PANEL, 'HoverColor', 'HoverColor')

function PANEL:Init()
	self.BaseClass.Init(self)

	self:SetFont('OSXContextMenu')
	self:SetBackgroundColor(F4Menu.Colors.NavItem)
	self:SetHoverColor(F4Menu.Colors.AcceptButtonHover)
	self:SetTextColor(F4Menu.Colors.NavItemText)
	self:SetTall(32)
end

function PANEL:Paint(w, h)
	local backgroundColor = self.Hovered and self:GetHoverColor() or self:GetBackgroundColor()
	draw.RoundedBox(3, 0, 0, w, h, backgroundColor)
end

function PANEL:UpdateColours()
	local textColor = self:GetTextColor() or color_white
	self:SetTextStyleColor(textColor)
end

vgui.Register('OSXAcceptButton', PANEL, 'DButton')

local PANEL = {}

AccessorFunc(PANEL, 'TextColor', 'TextColor')
AccessorFunc(PANEL, 'BackgroundColor', 'BackgroundColor')
AccessorFunc(PANEL, 'HoverColor', 'HoverColor')

function PANEL:Init()
	self.BaseClass.Init(self)

	self:SetFont('OSXContextMenu')
	self:SetTextColor(F4Menu.Colors.TextSmall)
	self:SetTall(32)
end

function PANEL:Paint(w, h)
end

function PANEL:UpdateColours()
	local textColor = self:GetTextColor() or color_white
	self:SetTextStyleColor(textColor)
end

vgui.Register('OSXCancelButton', PANEL, 'DButton')
