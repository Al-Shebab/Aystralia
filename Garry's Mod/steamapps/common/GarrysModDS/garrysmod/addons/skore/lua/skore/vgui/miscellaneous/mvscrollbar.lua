
local PANEL = {}

function PANEL:Init()
	self.scroll = 0
	self.canvasSize = 1

	self.grip = vgui.Create("MScrollBarGrip", self)

	self:SetPaintShadow(false)
	self:SetDrawShadows(false)
	self:SetBackgroundColour(sKore.getShadowColour)
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(self:GetBackgroundColour())
	surface.DrawRect(0, 0, width, height)
	sKore.drawShadows(self)
end

function PANEL:SetUp(canvasSize)
	local height = self:GetTall()
	self.canvasSize = math.max(canvasSize, 1)
	self:SetEnabled(canvasSize > height)
	self:AddScroll(0)
	self:InvalidateLayout()
end

function PANEL:OnMousePressed()
	if self:IsDisabled() then return end
	local _, y = self:ScreenToLocal(0, gui.MouseY())
	local pageSize = self:GetTall()

	if y > self.grip.y then
		self:AddScroll(pageSize * 0.9)
	else
		self:AddScroll(pageSize * -0.9)
	end
end

function PANEL:OnMouseWheeled(dlta)
	if self:IsDisabled() then return end
	return self:AddScroll(dlta * -50)
end

function PANEL:AddScroll(scroll)
	self:SetScroll(self:GetScroll() + scroll)
end

function PANEL:SetScroll(scroll)
	if self:IsDisabled() then self.scroll = 0 return end
	self.scroll = math.Clamp(scroll, 0, self.canvasSize)
	self:InvalidateLayout()

	local parent = self:GetParent()
	if parent.OnVScroll then
		parent:OnVScroll(self:GetOffset())
	else
		parent:InvalidateLayout()
	end
end

function PANEL:GetScroll()
	if self:IsDisabled() then self.scroll = 0 end
	return self.scroll
end

function PANEL:GetOffset()
	return (self:GetScroll() / self.canvasSize) * -(self.canvasSize - self:GetTall())
end

function PANEL:PerformLayout()
	local width, height = self:GetSize()
	local barSize = math.Clamp(math.Round((height / self.canvasSize) * height), sKore.scaleR(32), height)
	local track = height - barSize
	local scroll = (self:GetScroll() / self.canvasSize) * track

	self.grip:SetPos(0, scroll)
	self.grip:SetSize(width, barSize)
end

function PANEL:Think()
	if self.grip.dragging then
		local height = self:GetTall()
		local barSize = math.Clamp(math.Round((height / self.canvasSize) * height), sKore.scaleR(32), height)
		local track = height - barSize
		self:SetScroll((self.grip.y / track) * self.canvasSize)
	end
end

derma.DefineControl("MVScrollBar", "", PANEL, "MPanel")
