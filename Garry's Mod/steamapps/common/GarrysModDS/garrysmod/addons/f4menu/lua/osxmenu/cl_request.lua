local L = F4Menu.GetTranslation
local PANEL = {}

function PANEL:Init()
	self:SetZPos(9999)
	self.Opened = true
	self.OverlayAlpha = 0
end

function PANEL:Paint(w, h)
	self.OverlayAlpha = math.Approach(self.OverlayAlpha, self.Opened and 246 or 0, FrameTime() * 1400)
	local overlayColor = Color(0, 0, 0, self.OverlayAlpha)
	draw.RoundedBox(F4Menu.Colors.BorderRadius, 0, 0, w, h, overlayColor)
end

function PANEL:Setup(requestPlaceholder, requestTitle, requestCallback, numeric)
	local w, h = self:GetSize()

	self.Dialog = vgui.Create('Panel', self)
	self.Dialog:SetSize(460, 243)
	self.Dialog:SetPos(w / 2 - 100, h / 2 - 40)
	self.Dialog:Center()
	self.Dialog:DockPadding(0, 20, 0, 0)
	self.Dialog.Paint = function(self, w, h)
		draw.RoundedBox(F4Menu.Colors.BorderRadius, 0, 0, w, h, F4Menu.Colors.Background)
	end

	self.Bottom = vgui.Create('Panel', self.Dialog)
	self.Bottom:Dock(BOTTOM)
	self.Bottom:SetTall(57)
	self.Bottom:DockPadding(24, 11, 24, 11)
	self.Bottom.Paint = function(self, w, h)
		draw.RoundedBoxEx(F4Menu.Colors.BorderRadius, 0, 0, w, h, F4Menu.Colors.RequestBottomBar, false, false, true, true)
		draw.RoundedBox(0, 0, 0, w, 1, F4Menu.Colors.Border)
	end

	self.Submit = vgui.Create('OSXAcceptButton', self.Bottom)
	self.Submit:Dock(RIGHT)
	self.Submit:SetWide(90)
	self.Submit:SetText(L'submit')
	self.Submit.DoClick = function()
		self:Close()
		requestCallback(self.TextEntry:GetValue())
	end

	self.Cancel = vgui.Create('OSXCancelButton', self.Bottom)
	self.Cancel:Dock(RIGHT)
	self.Cancel:SetWide(90)
	self.Cancel:SetText(L'cancel')
	self.Cancel.DoClick = function()
		self:Close()
	end

	local textColor, textSelected, textCaret = F4Menu.Colors.Text, F4Menu.Colors.ContextMenuSelected, F4Menu.Colors.CaretColor

	self.TextEntry = vgui.Create('DTextEntry', self.Dialog)
	self.TextEntry:Dock(BOTTOM)
	self.TextEntry:DockMargin(24, 0, 24, 54)
	self.TextEntry:SetTall(37)
	self.TextEntry:SetFont('OSXContextMenu')
	self.TextEntry:SetNumeric(numeric)
	self.TextEntry:SetDrawLanguageID(false)
	self.TextEntry:RequestFocus()
	self.TextEntry:SelectAllText(true)

	self.TextEntry.Paint = function(self, w, h)
		if #self:GetValue() == 0 then
			draw.SimpleText(requestPlaceholder, 'OSXContextMenu', 3, h/2, F4Menu.Colors.TextSmall, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		if self:HasFocus() then
			draw.RoundedBox(0, 0, h - 2, w, 2, F4Menu.Colors.NavItem)
		else
			draw.RoundedBox(0, 0, h - 2, w, 1, F4Menu.Colors.Border)
		end
		self:DrawTextEntryText(textColor, textSelected, textCaret)
		return false
	end

	self.TextEntry.OnEnter = function(entry)
		self:Close()
		requestCallback(entry:GetValue())
	end
	timer.Simple(0.02, function() -- RequestFocus fix
		self.Title = vgui.Create('DLabel', self.Dialog)
		self.Title:Dock(BOTTOM)
		self.Title:DockMargin(28, 0, 28, 2)
		self.Title:SetFont('OSXSmall')
		self.Title:SetText(requestTitle:upper())
		self.Title:SetColor(F4Menu.Colors.Text)
	end)
end

function PANEL:OnMouseReleased()
	self:Close()
end

function PANEL:Close()
	self.Opened = false
	self.Dialog:Remove()
end

function PANEL:Think()
	if not self.Opened and self.OverlayAlpha == 0 then
		self:Remove()
	end 
end

vgui.Register('OSXRequest', PANEL, 'DPanel')