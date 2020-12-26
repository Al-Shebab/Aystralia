
local PANEL = {}

sKore.AccessorFunc(PANEL, "barWidth", "BarWidth", sKore.FORCE_NUMBER_NIL, sKore.invalidateLayoutNow)

function PANEL:Init()
	self:SetBackgroundColour(sKore.getBackgroundColour, 3)
	self:SetTextColour(sKore.getBackgroundTextColour, sKore.HIGH_EMPHASIS)
	self:SetHintText("#searchBar_defaultHint")
	self:SetHintTextColour(sKore.getBackgroundTextColour, sKore.MEDIUM_EMPHASIS)
	self:SetText("")
	self:SetHighlightColour(sKore.getPrimaryColour, sKore.PRIMARY_DARK)
	self:SetMaterial(sKore.getBackgroundMaterial, "magnify")
	self:SetBarWidth(function()
		return self:GetParent():GetWide() * 0.3
	end)

	self.textEntry.OnValueChange = function(_, newValue)
		newValue = string.Trim(newValue)
		self.frame.searchBar = newValue != "" and newValue or nil
		self.frame:InvalidateChildren(true)
		for panel, _ in pairs(self.frame.updateOnSearch) do
			panel:InvalidateLayout()
		end
	end
end

function PANEL:PerformLayout()
	local height = sKore.scaleR(46)
	self:SetHeight(height)
	self:SetWidth(self:GetBarWidth() or self:GetWide())

	self:DockMargin(0, sKore.scaleRC(1, 1), sKore.scale(8), 0)

	local material = self:GetMaterial()
	if material != nil then
		self.icon:SetVisible(true)
		self.icon:SetMaterial(material)
		local margin = sKore.scaleR(9)
		self.icon:DockMargin(sKore.scaleR(8), margin, 0, margin)
		self.icon:SetWidth(self.icon:GetTall())
	else
		self.icon:SetVisible(false)
		self.icon:SetWidth(0)
		self.icon:DockMargin(0, 0, 0, 0)
	end

	self.textEntry:SetTextColor(self:GetTextColour())
	self.textEntry:SetCursorColor(self:GetTextColour())
	self.textEntry:SetPlaceholderColor(self:GetHintTextColour())
	self.textEntry:SetPlaceholderText(sKore.getPhrase(self:GetHintText()))
	self.textEntry:SetHighlightColor(self:GetHighlightColour())
	self.textEntry:DockMargin(sKore.scale(8), 0, sKore.scale(8), 0)
end

derma.DefineControl("MSearchBar", "", PANEL, "MRaisedTextEntry")
