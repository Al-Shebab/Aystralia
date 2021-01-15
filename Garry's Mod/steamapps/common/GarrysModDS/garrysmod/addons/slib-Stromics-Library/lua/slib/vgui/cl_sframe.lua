local PANEL = {}

slib.setTheme("maincolor", Color(36,36,36))
slib.setTheme("accentcolor", Color(66,179,245))
slib.setTheme("margin", slib.getScaledSize(3, "x"))
slib.setTheme("textcolor", Color(255,255,255))
slib.setTheme("neutralcolor", Color(0,0,200,40))
slib.setTheme("topbarcolor", Color(44,44,44))
slib.setTheme("sidebarcolor", Color(34,34,34))
slib.setTheme("sidebarbttncolor", Color(39,39,39))
slib.setTheme("whitecolor", Color(255,255,255))
slib.setTheme("hovercolor", Color(255,255,255,100))
slib.setTheme("orangecolor", Color(130, 92, 10))
slib.setTheme("successcolor", Color(0,200,0))
slib.setTheme("failcolor", Color(200,0,0))
slib.setTheme("bgblur", true)

local topbarcolor, topbarcolor_min10, sidebarcolor, sidebarbttncolor, textcolor, accentcolor, maincolor, maincolor_7, maincolor_15, hovercolor = slib.getTheme("topbarcolor"), slib.getTheme("topbarcolor", -10), slib.getTheme("sidebarcolor"), slib.getTheme("sidebarbttncolor"), slib.getTheme("textcolor"), slib.getTheme("accentcolor"), slib.getTheme("maincolor"), slib.getTheme("maincolor", 7), slib.getTheme("maincolor", 15), slib.getTheme("hovercolor")
local accentcol_a100 = slib.getTheme("accentcolor")
accentcol_a100.a = 100

local black_a160 = Color(0,0,0,160)
local black_a140 = Color(0,0,0,140)

function PANEL:Init()
	self.topbarheight = slib.getScaledSize(30, "y")
	self.font = slib.createFont("Roboto", 21)
	self.tab = {}

	self.topbar = vgui.Create("EditablePanel", self)
	self.topbar:SetCursor("sizeall")
	self.topbar:SetSize(self:GetWide(), self.topbarheight)

	self.topbar.OnSizeChanged = function()
		if IsValid(self.close) then
			self.close:SetPos(self.topbar:GetWide() - self.close:GetWide() - slib.getScaledSize(3,"x"), 0)
		end
	end

	self.topbar.Paint = function(s, w, h)
		if !s.Holding and s:IsHovered() and input.IsMouseDown(MOUSE_LEFT) then
				s.Holding = true
				local x, y = gui.MouseX(), gui.MouseY()
				s.startedx, s.startedy = s:ScreenToLocal(x, y)
		elseif s.Holding and !input.IsMouseDown(MOUSE_LEFT) then
			s.Holding = nil
		end

		if s.Holding then
			local x, y = gui.MouseX(), gui.MouseY()
			local offsetx, offsety =  s:ScreenToLocal(x, y)
			
			self:SetPos(x - s.startedx, y - s.startedy)
		end

		draw.RoundedBoxEx(5, 0, 0, w, h, topbarcolor, true, true)

		surface.SetDrawColor(black_a160)
		surface.DrawRect(0, h - 1, w, 1)

		surface.SetDrawColor(black_a140)
		surface.DrawRect(0, h - 2, w, 1)
		draw.SimpleText(self.title, self.font, slib.getScaledSize(3,"x"), h * .5, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.frame = vgui.Create("EditablePanel", self)

	self.frame.Resize = function()
		local wide = 0

		if self.tabmenu then
			wide = wide + self.tabmenu:GetWide()
		end

		self.frame:SetPos(wide,self.topbarheight)
		self.frame:SetSize(self:GetWide() - wide, self:GetTall() - self.topbarheight)
		
		for k,v in pairs(self.tab) do
			self.tab[k]:SetSize(self.frame:GetWide(), self.frame:GetTall())
		end
	end

	self.frame.Resize()

	self.MadePanel = SysTime()

	slib.wrapFunction(self, "SetSize", nil, function() return self end, true)
	slib.wrapFunction(self, "Center", nil, function() return self end, true)
	slib.wrapFunction(self, "SetPos", nil, function() return self end, true)
	slib.wrapFunction(self, "MakePopup", nil, function() return self end, true)
	slib.wrapFunction(self, "DockPadding", nil, function() return self end, true)
end

function PANEL:SetDraggable(bool)
	if IsValid(self.topbar) then
		self.topbar:SetMouseInputEnabled(bool)
	end
end

function PANEL:setTitle(str, font)
	self.title = str

	if font then
		self.font = font
	end
	
	return self
end

function PANEL:addCloseButton()
	self.close = vgui.Create("DButton", self)
	self.close:SetSize(slib.getScaledSize(25, "y"),slib.getScaledSize(25, "y"))
	self.close:SetMouseInputEnabled(true)
	self.close:SetPos(self.topbar:GetWide() - self.close:GetWide() - slib.getScaledSize(3,"x"), self.topbarheight * .5 - self.close:GetTall() * .5)
	self.close:SetText("")

	self.close.DoClick = function()
		self:Remove()
	end

	self.close.Paint = function(s,w,h)
		local width = slib.getScaledSize(2, "X")
		local height = h * .7

		draw.NoTexture()

		local wantedCol = s:IsHovered() and color_white or hovercolor

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
		surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, 45)
		surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, -45)
	end

	return self
end

function PANEL:OnSizeChanged()
	self.topbar:SetSize(self:GetWide(), self.topbarheight)
	self.frame.Resize()
end

function PANEL:setBlur(bool)
	self.blur = bool

	return self
end

function PANEL:setDoClick(func)
	self.DoClick = func

	return self
end

function PANEL:Paint(w, h)
	if slib.getTheme("bgblur") and self.blur then
		Derma_DrawBackgroundBlur( self, self.MadePanel )
	end
	
	draw.RoundedBox(5, 0, 0, w, h, maincolor)
end

function PANEL:addTab(name, icon)
	if !IsValid(self.tabmenu) then
		self.tabmenu = vgui.Create("DScrollPanel", self)
		self.tabmenu:SetTall(self:GetTall() - self.topbarheight)
		self.tabmenu:SetPos(0, self.topbarheight)
		self.tabmenu.font = slib.createFont("Roboto", 14)
		self.tabmenu.Paint = function(s,w,h)
			draw.RoundedBoxEx(5, 0, 0, w, h, sidebarcolor, false, false, true, false)
		end

		self.tabmenu.OnSizeChanged = function()
			self.frame.Resize()
		end

		self.frame.Resize()
	end

	self.tab[name] = vgui.Create("EditablePanel", self.frame)
	self.tab[name]:SetSize(self.frame:GetWide(), self.frame:GetTall())

	local height = slib.getScaledSize(25, "y")

	local tabbttn = vgui.Create("DButton", self.tabmenu)
	tabbttn:Dock(TOP)
	tabbttn:SetTall(height)
	tabbttn:SetText("")

	tabbttn.getFrame = function()
		return self.tab[name]
	end

	if icon then
		tabbttn.icon = Material(icon, "smooth")
	end

	local icosize = height * .6
	local gap = height * .20

	tabbttn.Paint = function(s,w,h)
		surface.SetDrawColor(sidebarbttncolor)
		surface.DrawRect(0, 0, w, h)

		local wantedh = self.seltab == name and h or 0
		local curH = slib.lerpNum(s, wantedh, .9, true)

		if self.seltab == name then
			surface.SetDrawColor(accentcol_a100)
			surface.DrawRect(0, h * .5 - curH * .5, w, curH)
		end

		if s.icon then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(s.icon)
			surface.DrawTexturedRect(gap,gap,icosize,icosize)
		end

		draw.SimpleText(name, self.tabmenu.font, (s.icon and icosize + gap or 0) + slib.getTheme("margin"), h * .5, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	tabbttn.DoClick = function()
		self:setActiveTab(name)
	end
	
	surface.SetFont(self.tabmenu.font)
	local w = select(1, surface.GetTextSize(name)) + (slib.getTheme("margin") * 4)

	if w > self.tabmenu:GetWide() then
		self.tabmenu:SetWide(w + height)
	end

	return self, tabbttn
end

function PANEL:setActiveTab(name)
	for k,v in pairs(self.tab) do
		v:SetVisible(false)
	end

	self.seltab = name

	self.tab[name]:SetVisible(true)

	return self
end

vgui.Register("SFrame", PANEL, "EditablePanel")