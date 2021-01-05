local PANEL = {}

AccessorFunc(PANEL, "m_intHeaderTall", "HeaderTall", FORCE_NUMBER)
AccessorFunc(PANEL, "m_strHeaderText", "HeaderText", FORCE_STRING)

function PANEL:Init()
	-- self:SetAlpha(0)
	-- self:AlphaTo(255, 0.25)

	self.btnClose = vgui.Create("DImageButton", self)
	self.btnClose:SetSize(24, 24)
	self.btnClose:SetImage("materials/slawer/mayor/logout.png")
	-- self.btnClose:SetText("✕")
	-- self.btnClose:SetTextColor(color_white)
	-- self.btnClose:SetFont("Slawer.Mayor:R20")
	-- function self.btnClose:Paint() end
	function self.btnClose:DoClick()
		self:GetParent():LoadLockScreen()
	end

	self:SetHeaderTall(70)
	self:SetHeaderText("Default")
end

function PANEL:Delete()
	self:SetAlpha(255)
	self:AlphaTo(0, 0.25, 0, function()
		self:Remove()
	end)
end

function PANEL:Paint(intW, intH)
	surface.SetDrawColor(Slawer.Mayor.Colors.Grey)
	surface.DrawRect(0, 0, intW, intH)

	surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
	surface.DrawRect(0, 0, intW, self:GetHeaderTall())

	surface.SetDrawColor(Slawer.Mayor.Colors.Black)
	surface.DrawRect(0, self:GetHeaderTall() - 1, intW, 1)

	draw.SimpleText(self:GetHeaderText(), "Slawer.Mayor:B30", intW / 2, self:GetHeaderTall() / 2, color_white, 1, 1)
end

function PANEL:PerformLayout(intW, intH)
	if !IsValid(self.btnClose) then return end

	self.btnClose:SetPos(intW - self.btnClose:GetWide() - (Slawer.Mayor.IsTooLowResolution and 55 or 20), self:GetHeaderTall() * 0.5 - self.btnClose:GetTall() * 0.5)
end

vgui.Register("Slawer.Mayor:EditablePanel", PANEL, "EditablePanel")