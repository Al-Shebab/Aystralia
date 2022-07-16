local PANEL = {}

function PANEL:Init()
	self.list = {}
	self.seqlist = {}
	self.panels = {}
	self.navfont = "emenu_20_500"
	self.activetextcol = emenu.colors.text.white
	self.textcol = emenu.colors.text.white
	self.textcolhover = emenu.colors.text.hover
	self.minsize = 30
	self.dock = LEFT

	self.navbar = self:Add("DPanel")
	local navbar = self.navbar
	local accent = Color(13,13,13,100)
	self.navbar.PaintBG = false
	self.navbar.ColorBG = emenu.colors.windows.accent
	self.navbar.Accent = emenu.colors.text.hover
	function navbar.Paint(pnl,w,h)
		if self.activename then
			local button = self.list[self.activename]
			if not IsValid(button) then return end

			if self.navbar.PaintBG then
				surface.SetDrawColor(self.navbar.ColorBG:Unpack())
				surface.DrawRect(0,0,w,h)
			end

			surface.SetDrawColor(accent:Unpack())
			surface.DrawRect(0,h-3,w,3)

			local xb,yb,wb,hb = button:GetBounds()
			surface.SetDrawColor(pnl.Accent:Unpack())
			surface.DrawRect(xb,h-3,wb,3)
		end
	end

	self.content = self:Add("DPanel")
	self.content.Paint = nil
end

function PANEL:Invalidate()
	local navsize = draw.GetFontHeight(self.navfont)
	self.navbar:SetSize(self:GetWide(),navsize+10)

	self.content:SetSize(self:GetWide(),self:GetTall()-self.navbar:GetTall())
	self.content:SetPos(0,self.navbar:GetTall())
end

function PANEL:SetPaintBG(bool)
	self.navbar.PaintBG = bool
end

function PANEL:SetBGColor(col)
	if IsColor(col) then
		self.navbar.ColorBG = col
	end
end

function PANEL:SetAccentColor(col)
	if IsColor(col) then
		self.navbar.Accent = col
	end
end


function PANEL:SetActiveTextColor(col)
	if IsColor(col) then
		self.activetextcol = col
	end
end


function PANEL:SetTextColor(col)
	if IsColor(col) then
		self.textcol = col
	end
end

function PANEL:SetTextHoverColor(col)
	if IsColor(col) then
		self.textcolhover = col
	end
end

function PANEL:SetFont(font)
	self.navfont = font
	self:Invalidate()
end

function PANEL:AddTab(name,func,customCheck)
	if isfunction(customCheck) then
		if not customCheck() then return end
	end

	self:Invalidate()
	table.insert(self.seqlist,name)

	self.list[name] = vgui.Create("DButton",self.navbar)
	local button = self.list[name]
	button:SetText(name)
	button:SetFont(self.navfont)
	button:SetTextColor(self.textcol)
	function button.Paint(pnl,w,h)
		local active = self.activename == name
		if pnl:IsHovered() then
			button:SetTextColor(self.textcolhover)
		else
			button:SetTextColor(active and self.activetextcol or self.textcol)
		end
	end

	local tsize = emenu.util.GetTextSize(name,self.navfont)
	button:SetWide(math.max(self.minsize,tsize.w+20))
	button:Dock(self.dock)

	function button.DoClick(pnl)
		self:SetActive(name)
	end

	self.panels[name] = func

	if #self.seqlist == 1 then
		self:SetActive(name)
	end

	return button
end

function PANEL:GetCurrentPanel()
	return self.active
end

function PANEL:SetActive(name)
	if self.activename == name then return end
	if IsValid(self.active) then
		self.active:Remove()
	end

	if self.panels[name] then
		self.active = self.panels[name](self.content)
		self.activename = name
	end
end

function PANEL:GetActive()
	return self.activename
end

function PANEL:Paint(w,h)
	--for override
end

vgui.Register( "emenu.combolist", PANEL, "DPanel" )