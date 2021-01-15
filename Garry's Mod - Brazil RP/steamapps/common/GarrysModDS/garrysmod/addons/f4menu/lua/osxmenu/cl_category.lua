local PANEL = {}

function PANEL:Init()
	self.Opened = true
	self.Label = vgui.Create('DLabel', self)
	self.Label:Dock(TOP)
	self.Label:SetTall(40)
	self.Label:SetTextInset(30, 0)
	self.Label:DockPadding(0, 0, 30, 0)
	self.Label:SetFont('OSXButton')
	self.Label:SetColor(F4Menu.Colors.Text)
	self.Label:SetMouseInputEnabled(true)
	self.Label:SetCursor('hand')
	self.Label.Paint = function(self, w, h)
		draw.RoundedBox(0, 20, h - 1, w - 40, 1, F4Menu.Colors.Border)
	end
	self.Label.DoClick = function() self:Toggle() end

	self.Arrow = vgui.Create('OSXArrow', self.Label)
	self.Arrow:Dock(RIGHT)
	self.Arrow:SetWide(15)
	self.Arrow:SetCursor('hand')
	self.Arrow.OnMouseReleased = function() self:Toggle() end

	self.Container = vgui.Create('Panel', self)
	self.Container:Dock(TOP)
end

function PANEL:Close()
	self.Arrow:SetOrigin(TOP)
	self.Container:Hide()
  self:InvalidateLayout(true)
	self.Opened = false
	return true
end

function PANEL:Open()
	self.Arrow:SetOrigin(BOTTOM)
	self.Container:Show()
	self:InvalidateLayout(true)
	self.Opened = true
	return true
end

function PANEL:Toggle()
	return self.Opened and self:Close() or self:Open()
end

function PANEL:SetName(name)
	self.Label:SetText(name)
end

function PANEL:AddItem(panel)
	panel:SetParent(self.Container)
	panel:Dock(TOP)
	self:InvalidateLayout(true)
end

local function every(table, functor)
  for k,v in pairs(table) do
    if not functor(v, k, table) then return false end
  end
  return true
end

function PANEL:Refresh()
  local children = self.Container:GetChildren()

	for index, panel in pairs(children) do
		panel:Refresh()
	end

  local isEmpty = every(children, function(panel) return not panel:IsVisible() end)

  if isEmpty then
    self:Hide()
    self:SetTall(0)
    -- self:InvalidateLayout(true)
  else
    self:Show()
    self:InvalidateLayout(true)
  end
end

function PANEL:PerformLayout()
	self.Container:InvalidateLayout(true)
	self.Container:SizeToChildren(true, true)
	self:SizeToChildren(true, true)
end

vgui.Register('OSXCategory', PANEL, 'Panel')
