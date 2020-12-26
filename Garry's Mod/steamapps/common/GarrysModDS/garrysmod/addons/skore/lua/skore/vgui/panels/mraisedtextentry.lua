
local PANEL = {}

sKore.AccessorFunc(PANEL, "material", "Material", sKore.FORCE_MATERIAL_NIL, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "textColour", "TextColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "hintTextColour", "HintTextColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "hintText", "HintText", sKore.FORCE_STRING, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "hightlightColour", "HighlightColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)

function PANEL:Init()
	self.icon = vgui.Create("DImage", self)
	self.icon:SetMouseInputEnabled(false)
	self.icon:Dock(LEFT)

	self.textEntry = vgui.Create("DTextEntry", self)
	self.textEntry:SetPaintBackground(false)
	self.textEntry:SetFont("sKoreRaisedTextEntry")
	self.textEntry:Dock(FILL)
	self.textEntry:SetUpdateOnType(true)

	self.textEntry.OnValueChange = function(_, newValue)
		self.text = newValue
	end

	self:SetElevation(2)
	self:SetBackgroundColour(sKore.getBackgroundColour, 3)
	self:SetTextColour(sKore.getBackgroundTextColour, sKore.HIGH_EMPHASIS)
	self:SetHintText("")
	self:SetHintTextColour(sKore.getBackgroundTextColour, sKore.MEDIUM_EMPHASIS)
	self:SetHighlightColour(sKore.getPrimaryColour, sKore.PRIMARY_DARK)
end

function PANEL:Paint(width, height)
	draw.RoundedBox(sKore.scale(8), 0, 0, self:GetWide(), self:GetTall(), self:GetBackgroundColour())
end

function PANEL:PaintOver()
	sKore.drawShadows(self)
end

function PANEL:PaintShadow(x, y)
	draw.RoundedBox(sKore.scale(8), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour())
end

function PANEL:PerformLayout()
	local height = sKore.scaleR(46)
	self:SetHeight(height)

	local material = self:GetMaterial()
	if material != nil then
		self.icon:SetVisible(true)
		self.icon:SetMaterial(material)
		local margin = sKore.scaleR(9)
		self.icon:DockMargin(sKore.scale(8), margin, 0, margin)
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

function PANEL:SetText(...) return self.textEntry:SetText(...) end
function PANEL:GetText(...) return self.text end

derma.DefineControl("MRaisedTextEntry", "", PANEL, "MPanel")
