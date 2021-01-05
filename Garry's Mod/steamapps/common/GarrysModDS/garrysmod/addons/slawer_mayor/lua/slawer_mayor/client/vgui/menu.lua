local PANEL = {}

local matLaws = Material("materials/slawer/mayor/laws.png", "smooth")
local matTaxs = Material("materials/slawer/mayor/taxs.png", "smooth")
local matFunds = Material("materials/slawer/mayor/funds.png", "smooth")
local matLicenses = Material("materials/slawer/mayor/licenses.png", "smooth")
local matPolicemen = Material("materials/slawer/mayor/policemen.png", "smooth")
local matWarrants = Material("materials/slawer/mayor/warrants.png", "smooth")
local matWanted = Material("materials/slawer/mayor/exclamation.png", "smooth")
local matLockdown = Material("materials/slawer/mayor/lockdown.png", "smooth")
local matUnlockdown = Material("materials/slawer/mayor/unlockdown.png", "smooth")
local matMegaphone = Material("materials/slawer/mayor/megaphone.png", "smooth")

local matFBI = Material(Slawer.Mayor.CFG.IconDir, "noclamp smooth")

local tblSidebar = {}

if not Slawer.Mayor.CFG.DisabledModules["funds"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Funds"),
		icon = matFunds,
		callback = function(pnl)
			Slawer.Mayor:ShowFunds(pnl)
		end,
	})
end

if not Slawer.Mayor.CFG.DisabledModules["taxs"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Taxs"),
		icon = matTaxs,
		callback = function(pnl)
			Slawer.Mayor:ShowTaxs(pnl)
		end,
	})
end


if not Slawer.Mayor.CFG.DisabledModules["laws"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Laws"),
		icon = matLaws,
		callback = function(pnl)
			Slawer.Mayor:ShowLaws(pnl)
		end,
	})
end

if not Slawer.Mayor.CFG.DisabledModules["licenses"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Licenses"),
		icon = matLicenses,
		callback = function(pnl)
			Slawer.Mayor:ShowLicenses(pnl)
		end,
	})
end

if not Slawer.Mayor.CFG.DisabledModules["policemen"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Policemen"),
		icon = matPolicemen,
		callback = function(pnl)
			Slawer.Mayor:ShowPolicemen(pnl)
		end,
	})
end

if not Slawer.Mayor.CFG.DisabledModules["warrants"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Warrants"),
		icon = matWarrants,
		callback = function(pnl)
			Slawer.Mayor:ShowWarrants(pnl)
		end,
	})
end

if not Slawer.Mayor.CFG.DisabledModules["wanted"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("Wanted"),
		icon = matWanted,
		callback = function(pnl)
			Slawer.Mayor:ShowWanted(pnl)
		end,
	})
end

if not Slawer.Mayor.CFG.DisabledModules["news"] then
	table.insert(tblSidebar, {
		text = Slawer.Mayor:L("News"),
		icon = matMegaphone,
		callback = function(pnl)
			Slawer.Mayor:ShowNews(pnl)
		end,
	})
end

table.insert(tblSidebar, {
	text = Slawer.Mayor:L("Lockdown"),
	icon = matLockdown,
	callback = function(pnl, btn)
		LocalPlayer():ConCommand("darkrp " .. (GetGlobalBool("DarkRP_LockDown") && "un" || "") .. "lockdown")
	end,
	think = function(btn)
		if GetGlobalBool("DarkRP_LockDown") then
			btn.icon = matUnlockdown
			btn.color = Slawer.Mayor.Colors.Green
		else
			btn.icon = matLockdown
			btn.color = Slawer.Mayor.Colors.Red
		end
	end,
	noGo = true
})

function PANEL:Init()
	Slawer.Mayor.IsTooLowResolution = (ScrW() <= 1024 or ScrH() <= 768)

	self:SetSize(1100, 620)
	self:ParentToHUD()
	self:SetHeaderText(Slawer.Mayor:L("CityManagement"))
	self:SetMouseInputEnabled(true)

	self.pnlContent = vgui.Create("DPanel", self)
	self.pnlContent:SetSize(self:GetWide() - 200, self:GetTall() - self:GetHeaderTall())
	self.pnlContent:SetPos(200, self:GetHeaderTall())
	self.pnlContent.Paint = nil

	Slawer.Mayor.pnlActive = nil

	self.pnlSidebar = vgui.Create("DScrollPanel", self)
	self.pnlSidebar:SetSize(200, self:GetTall() - self:GetHeaderTall())
	self.pnlSidebar:SetPos(0, self:GetHeaderTall())
	self.pnlSidebar.intLerpY = 0
	self.pnlSidebar.intLerpToY = 0
	self.pnlSidebar.VBar:SetWide(0)
	function self.pnlSidebar:Paint(intW, intH)
		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(0, 0, intW, intH)
		
		if not Slawer.Mayor.pnlActive then return end
		
		self.intLerpY = Lerp(RealFrameTime() * 10, self.intLerpY, self.intLerpToY)

		surface.SetDrawColor(Slawer.Mayor.Colors.Grey)
		surface.DrawRect(0, self.intLerpY, Slawer.Mayor.pnlActive:GetWide(), Slawer.Mayor.pnlActive:GetTall())
	end

	self.pnlAvatar = vgui.Create("AvatarImage", self)
	self.pnlAvatar:SetSize(32, 32)
	self.pnlAvatar:SetPos(10, self:GetHeaderTall() * 0.5 - self.pnlAvatar:GetTall() * 0.5)
	self.pnlAvatar:SetPlayer(LocalPlayer(), 64)

	self.lblName = vgui.Create("DLabel", self)
	self.lblName:SetSize(300, 32)
	self.lblName:SetPos(52, self:GetHeaderTall() * 0.5 - self.lblName:GetTall() * 0.5)
	self.lblName:SetText(LocalPlayer():Nick() or "76561198166995690")
	self.lblName:SetFont("Slawer.Mayor:R20")

	local isAnim = false

	for _, tbl in pairs(tblSidebar) do
		local btn = vgui.Create("Slawer.Mayor:DButton", self.pnlSidebar)
		btn:SetSize(self.pnlSidebar:GetWide(), 50)
		btn:SetPos(0, (_-1) * 50)
		btn:SetText("")
		btn.intLerp = 0
		btn.strLinked = tbl.text
		btn.icon = tbl.icon
		btn.color = tbl.color or nil
		function btn:Paint(intW, intH)
			if tbl.think then tbl.think(self) end

			local col = (self.color != nil && self.color || (Slawer.Mayor.pnlActive == self && color_white || Slawer.Mayor.Colors.LightGrey))

			surface.SetMaterial(self.icon)
			surface.SetDrawColor(col)
			surface.DrawTexturedRect(10 + 4, intH * 0.5 - 12, 24, 24)

			draw.SimpleText(self.strLinked, "Slawer.Mayor:R20", 60, intH * 0.5, col, 0, 1)
		end
		function btn:DoClick()
			if isAnim then return end
			-- if Slawer.Mayor.pnlActive == self then return end

			local p = self:GetParent():GetParent():GetParent()

			if tbl.noGo then
				tbl.callback(p.pnlContent, self)
			else
				isAnim = true

				local x, y = self:GetPos()
				
				self:GetParent():GetParent().intLerpToY = y
				Slawer.Mayor.pnlActive = self
		
				p.pnlContent:AlphaTo(0, 0.25, 0, function()
					p.pnlContent:Clear()
					tbl.callback(p.pnlContent, self)
					p.pnlContent:AlphaTo(255, 0.25, 0, function()
						isAnim = false
					end)
				end)
			end

		end

		if tbl.init then tbl.init(btn) end
		
		if not IsValid(Slawer.Mayor.pnlActive) then btn:DoClick() end
	end

	self:LoadLockScreen()
end

function PANEL:Unlock()
	if IsValid(self.Lock) then
		self.Lock.sizeTo = 0
		self.Lock:SizeTo(self.Lock:GetWide(), 0, 0.5)
		surface.PlaySound("buttons/button9.wav")
		LocalPlayer():SetNoDraw(true)
		self.pnlContent:SetVisible(true)
	end
end

function PANEL:LoadLockScreen()
	if IsValid(Slawer.Mayor.FakeTextEntry) then Slawer.Mayor.FakeTextEntry:Remove() end

	LocalPlayer():SetNoDraw(false)

	self.pnlContent:SetVisible(false)

	if IsValid(self.Lock) then
		self.Lock:SizeTo(self:GetWide(), self:GetTall(), 0.5)
		self.Lock.sizeTo = 400
		Slawer.Mayor.LookingTo = nil
		gui.EnableScreenClicker(false)
		return
	end

	self.Lock = vgui.Create("DPanel", self)
	self.Lock:SetSize(self:GetWide(), self:GetTall())
	self.Lock.defH = self.Lock:GetTall()
	self.Lock.sizeTo = 400
	self.Lock.size = 400
	self.Lock.bg = Slawer.Mayor.Colors.DarkGrey
	function self.Lock:Paint(intW, intH)
		if self.size != self.sizeTo then
			self.size = Lerp(RealFrameTime() * 3, self.size, self.sizeTo)
		end

		surface.SetDrawColor(self.bg)
		surface.DrawRect(0, 0, intW, intH)

		surface.SetMaterial(matFBI)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRectRotated(intW * 0.5, self.defH * 0.5, self.size, self.size, 0)
	end
	function self.Lock:OnFail()
		self.bg = Slawer.Mayor.Colors.Red
		surface.PlaySound("buttons/button10.wav")
		timer.Simple(0.25, function()
			if IsValid(self) then
				self.bg = Slawer.Mayor.Colors.DarkGrey
			end
		end)
	end
end

vgui.Register("Slawer.Mayor:Menu", PANEL, "Slawer.Mayor:EditablePanel")