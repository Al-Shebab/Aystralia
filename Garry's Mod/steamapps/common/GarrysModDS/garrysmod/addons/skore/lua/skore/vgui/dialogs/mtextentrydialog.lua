
local PANEL = {}

function PANEL:Init()
	self.textEntry = vgui.Create("MRaisedTextEntry", self)
	self.textEntry:SetBackgroundColour(sKore.getBackgroundColour, 2)
	self.textEntry:SetZPos(2103)
	self.textEntry:Dock(TOP)

	self:InvalidateLayout(true)
	self:Open()
end

function PANEL:PerformLayout()
	if self.ripple then self.ripple[3] = nil end

	self:SetWide(sKore.scale(560))

	self.titleLabel:SetTextColor(self:GetTitleColour())
	self.titleLabel:SetText(sKore.getPhrase(self:GetTitle()))
	self.titleLabel:DockMargin(sKore.scale(24), sKore.scale(24), sKore.scale(24), 0)
	self.titleLabel:SizeToContentsY()

	self.descriptionLabel:SetTextColor(self:GetDescriptionColour())
	self.descriptionLabel:SetText(sKore.getPhrase(self:GetDescription()))
	self.descriptionLabel:DockMargin(sKore.scale(24), sKore.scale(16), sKore.scale(24), sKore.scale(28))
	self.descriptionLabel:SizeToContentsY()

	self.textEntry:DockMargin(sKore.scale(24), sKore.scale(8), sKore.scale(24), sKore.scale(8))

	self.actionBar:DockMargin(sKore.scale(24), sKore.scale(16), sKore.scale(16), sKore.scale(16))
	for _, item in pairs(self.items) do
		item:SizeToContents()
		item:DockMargin(sKore.scale(16), 0, 0, 0)
	end
	self.actionBar:SizeToChildren(false, true)

	self:SetHeight(self.actionBar.y + self.actionBar:GetTall() + sKore.scale(16))
	self:Center()
end

function PANEL:SetHintText(...) return self.textEntry:SetHintText(...) end
function PANEL:GetHintText(...) return self.textEntry:GetHintText(...) end
function PANEL:SetHintTextColour(...) return self.textEntry:SetHintTextColour(...) end
function PANEL:GetHintTextColour(...) return self.textEntry:GetHintTextColour(...) end
function PANEL:SetHighlightColour(...) return self.textEntry:SetHighlightColour(...) end
function PANEL:GetHighlightColour(...) return self.textEntry:GetHighlightColour(...) end
function PANEL:SetText(...) return self.textEntry:SetText(...) end
function PANEL:GetText(...) return self.textEntry:GetText(...) end
function PANEL:SetTextColour(...) return self.textEntry:SetTextColour(...) end
function PANEL:GetTextColour(...) return self.textEntry:GetTextColour(...) end
function PANEL:SetMaterial(...) return self.textEntry:SetMaterial(...) end
function PANEL:GetMaterial(...) return self.textEntry:GetMaterial(...) end

derma.DefineControl("MTextEntryDialog", "", PANEL, "MDialog")
