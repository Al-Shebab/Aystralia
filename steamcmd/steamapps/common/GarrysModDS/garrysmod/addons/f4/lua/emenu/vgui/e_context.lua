local PANEL={}

function PANEL:Init()
	local parent = self:GetParent()
	local outpnl = vgui.Create("DButton",parent)
	outpnl:SetSize(parent:GetWide(),parent:GetTall())
	outpnl:SetText("")
	outpnl:SetZPos(10)
	outpnl.Paint = nil
	outpnl:SetCursor("arrow")
	self.contextbackground = outpnl
	function outpnl:Close()
		self:SizeTo(1,1,emenu.config.animtime*1.1,0,-1,function()
			self:Remove()
		end)
	end
	function outpnl.DoClick()
		outpnl:Close()
		if IsValid(self) then self:Close(true) end
	end
	function outpnl.DoRightClick()
		outpnl:Close()
		if IsValid(self) then self:Close(true) end
	end
	parent.contextbg = outpnl

	self.buttonheight = 30
	self.sepheight = 2
	self.spacey = 0

	self.headerfont = "emenu_20_500"
	self.buttonfont = "emenu_18_500"

	self.player = LocalPlayer()
	self:SetParent(outpnl)

	self:SetSize(100,self.buttonheight)
	self.list = vgui.Create("DIconLayout", self)
	self.list:SetSpaceY(self.spacey)
	self.list:SetSize(self:GetWide(),self:GetSize())
end

function PANEL:SetWide(wide)
	self:SetSize(wide,self:GetTall())
	self.list:SetSize(wide,self:GetTall())
end

function PANEL:Close(anim)
	if anim then
		self:SizeTo(1,1,emenu.config.animtime,0,-1,function()
			self:Remove()
			if IsValid(self.contextbackground) then self.contextbackground:Remove() end
		end)
	else
		self:Remove()
		if IsValid(self.contextbackground) then self.contextbackground:Remove() end
	end
end

function PANEL:SetPly(ply)
	self.player = ply
end

function PANEL:GetPly(ply)
	return self.player
end

function PANEL:SetPosClamped(posx,posy)
	local x = math.Clamp( posx, 0, ScrW() - self:GetWide() )
	local y = math.Clamp( posy, 0, ScrH() - self:GetTall() )
	self:SetPos(x,y)
end

function PANEL:E_InvalidateLayout()
	local sizex = 1
	local sizey = 0
	for _,v in ipairs(self.list:GetChildren()) do
		local textsize = {w = 200, h = 100}
		if v.text then
			textsize = emenu.util.GetTextSize(v.text,self.buttonfont)
		end
		sizex = math.max(sizex,textsize.w+30)
		sizey = sizey + v:GetTall() + self.spacey
	end

	self:SetSize(sizex, sizey )
	self.list:SetSize(self:GetWide(),self:GetSize())
	self.contextbackground:SetZPos(10)

	for _,v in ipairs(self.list:GetChildren()) do
		v:SetWide(sizex)
		if IsValid(v.lbl) then
			v.lbl:Center()
		end
	end
end

function PANEL:AddButton(text,func,icon)
	local button = vgui.Create("DButton",self.list)
	button:SetSize(self.list:GetWide(), self.buttonheight)
	button:SetText("")
	button.TextColor = emenu.colors.context.text
	button.TextHoverColor = emenu.colors.context.texthover
	button.IconColor = button.TextColor
	button.IconHoverColor = button.TextHoverColor
	button.text = text
	if icon then button.icon = icon end
	function button:Paint(w,h)
		local hover = self:IsHovered()
		draw.RoundedBox(0,0,0,w,h,
			hover and emenu.colors.context.buttonhover or emenu.colors.context.button
		)
	end

	local lbl = button:Add("DLabel")
	local size = emenu.util.GetTextSize(text,self.buttonfont)
	lbl:SetSize(size.w+5,size.h+3)
	local iconsize = icon and button:GetTall()*0.5 or 1
	lbl:SetSize(size.w+iconsize+5,math.max(size.h,iconsize))
	lbl:SetText("")
	button.lbl = lbl
	function lbl.Paint(pnl,w,h)
		if button.icon then
			emenu.util:DrawMaterial(0,0,iconsize,iconsize,hover and button.IconHoverColor or button.IconColor, button.icon)
		end
		draw.SimpleText(
			text,
			self.buttonfont,
			iconsize+5,h*0.5,
			hover and button.TextHoverColor or button.TextColor,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER
		)
	end
	lbl:Center()

	function button.DoClick()
		self:Close()
		func(self.player)
	end

	function button:SetTextColor(col)
		if IsColor(col) then self.TextColor = col end
	end

	function button:SetTextHoverColor(col)
		if IsColor(col) then self.TextHoverColor = col end
	end

	function button:SetIconColor(col)
		if IsColor(col) then self.IconColor = col end
	end

	function button:SetIconHoverColor(col)
		if IsColor(col) then self.IconHoverColor = col end
	end

	self:E_InvalidateLayout()
	return button
end

function PANEL:OnClick()
end

function PANEL:AddHeader(text,col)
	local pnl = vgui.Create("DPanel",self.list)
	pnl.TextColor = col or emenu.colors.context.headertext
	pnl:SetSize(self.list:GetWide(), self.buttonheight)
	pnl.text = text
	function pnl.Paint(sel,w,h)
		draw.RoundedBox(0,0,0,w,h,emenu.colors.context.header)
		draw.SimpleText(text, self.headerfont, w*0.5, h*0.5, sel.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function pnl:SetTextColor(col)
		if IsColor(col) then self.TextColor = col end
	end

	self:E_InvalidateLayout()
	return pnl
end

function PANEL:AddSeparator()
	local pnl = vgui.Create("DPanel",self.list)
	pnl.text = ""
	pnl:SetSize(self.list:GetWide(), self.sepheight)
	function pnl:Paint(w,h)
		surface.SetDrawColor(emenu.colors.context.separator:Unpack())
		surface.DrawRect(0,0,w,h)
	end
	self:E_InvalidateLayout()
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(emenu.colors.context.bg:Unpack())
	surface.DrawRect(0,0,w,h)
end


vgui.Register( "emenu.contextmenu", PANEL )