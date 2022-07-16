local x = ScrW()
local y = ScrH()

local PANEL={}

AccessorFunc( PANEL, "m_bDraggable",		"Draggable",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",		"ScreenLock",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",			"Sizable",			FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth",			"MinWidth",			FORCE_NUMBER )
AccessorFunc( PANEL, "m_iMinHeight",		"MinHeight",		FORCE_NUMBER )

function PANEL:Init()
	self:SetSize(400,400)
	self.color = emenu.colors.windows.bg or Color(13,13,13)
	self.roundsize = 16

	self.title = emenu.text["win_title"]
	self.titlexoffset = 5
	self.titlecolor = emenu.colors.windows.accent or Color(255,255,255)
	self.titlealignx = TEXT_ALIGN_LEFT
	self.titlealigny = TEXT_ALIGN_CENTER
	self.titlefont = "emenu_26_500"
	self.paintbg = true
	self.titlepaint = true

	self.mustdark = emenu.util.TextColMustDark(self.titlecolor)

	--CONTENT
	if not IsValid(self.content) then
		self.content = vgui.Create( "DPanel", self )
	end 
	self.content.Paint = function(self, w, h)
		--for override
	end

	self:PerformLayout()

	if IsValid(self.titlepanel) then self.titlepanel:Remove() end
	self.titlepanel = vgui.Create("DDragBase",self)
	self.titlepanel:SetMouseInputEnabled(false)
	self.titlepanel:SetSize(self:GetWide(), self.titlesize.height)

	--closebutton
	self.closebutton = vgui.Create("DButton",self)
	self.closebutton:SetText( "" )
	function self.closebutton.Paint(_,w,h)
		local hover = self.closebutton:IsHovered()
		local color = hover and (emenu.colors.default.red) or (self.mustdark and emenu.colors.text.dark or emenu.colors.text.white)
		draw.SimpleText("r",
			"Marlett",
			w*0.5,
			h*0.5,
			color, 
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
	function self.closebutton.DoClick() self:Close() end

	self.minbutton = vgui.Create("DButton",self)
	self.minbutton:SetText( "" )
	function self.minbutton.Paint(_,w,h)
		local hover = self.minbutton:IsHovered()
		local color = hover and (emenu.colors.text.hover) or (self.mustdark and emenu.colors.text.dark or emenu.colors.text.white)
		draw.SimpleText("⎯",
			"Trebuchet24",
			w*0.5,
			h*0.5,
			color, 
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
	function self.minbutton.DoClick() self:Minimize() end

	if emenu.config.hide_other then
		self.pinbutton = vgui.Create("DButton",self)
		self.pinbutton:SetText( "" )
		function self.pinbutton.Paint(_,w,h)
			local hover = self.pinbutton:IsHovered()
			local color = hover and (emenu.colors.text.hover) or (self.mustdark and emenu.colors.text.dark or emenu.colors.text.white)
			local active = self.state == "pinned"
			local rotation = 0
			if active then
				rotation = 45
			end
			emenu.util:DrawMaterialCenteredRotated(w*0.5,h*0.5,h*0.3,rotation,color,emenu.Materials["pin"])
		end
		function self.pinbutton.DoClick()
			if self.state ~= "pinned" then
				self.state = "pinned"
			else
				self.state = "normal"
			end
		end
		emenu:AddHelpText(self.pinbutton,function() return self.state ~= "pinned" and emenu.text["pin"] or emenu.text["unpin"] end,nil,5,"top")
		-- self:AddHelpText(button,window.description,nil,5,"top")
	end

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetMinWidth( 100 )
	self:SetMinHeight( 50 )
	self:SetScreenLock( false )
end

function PANEL:EnableMinimizeButton(bool)
	self.minbutton:SetVisible(bool)
	if IsValid(self.pinbutton) then
		self.pinbutton:SetVisible(bool)
	end
end

function PANEL:EnableCloseButton(bool)
	self.closebutton:SetVisible(bool)
end

-- USER INPUT
function PANEL:SetTitle(title,color,font,alignx,aligny)
	if color then
		if IsColor(color) then self.titletextcolor = color end
	end
	if font then
		self.titlefont = font
	end
	if alignx then
		self.titlealignx = alignx
	end
	if aligny then
		self.titlealigny = aligny
	end
	if title then
		self.title = title
	end
	self:PerformLayout()
end

function PANEL:SetIcon(icon)
	self.icon = icon
	self.titlexoffset = self.titlepanel:GetTall()+5
end

function PANEL:GetTitle() return self.title end

function PANEL:SetBackgroundColor(col) 
	if IsColor(col) then self.color = col end 
end

function PANEL:GetColor() return self.color end


function PANEL:SetTitleColor(col)
	if IsColor(col) then self.titlecolor = col end
end

function PANEL:GetTitleColor() return self.titlecolor end


function PANEL:GetContent() return self.content end

function PANEL:SetRoundSize(size)
	self.roundsize = size
	self:PerformLayout()
end


function PANEL:Close(anim)
	self:OnClose()
	if anim == nil then anim = true end
	if anim then 
		local x, y = self:GetPos()
		self:SizeTo(1,1,emenu.config.animtime,0,3,function(anim, pnl)
			pnl:Remove()
		end)
	else
		self:Remove()
	end
end

function PANEL:OnClose()
	--
end

function PANEL:PerformLayout()
	surface.SetFont(self.titlefont or "emenu_18_500")
	local wide, height = surface.GetTextSize(self.title)

	self.titlesize = {
		wide = wide+2,
		height = height+2
	}

	self.content:SetSize(self:GetWide(),self:GetTall()-self.titlesize.height-self.roundsize)
	self.content:SetPos(0,self.titlesize.height)
	if IsValid(self.titlepanel) then
		self.mustdark = emenu.util.TextColMustDark(self.titlecolor)
		self.titlepanel:SetSize(self:GetWide(), self.titlesize.height)

		self.closebutton:SetSize(30,self.titlepanel:GetTall())
		local ost = self:GetWide()-self.closebutton:GetWide()
		self.closebutton:SetPos(ost,0)

		self.minbutton:SetSize(30,self.titlepanel:GetTall())
		ost = ost - self.minbutton:GetWide()-3
		self.minbutton:SetPos(ost,0)

		if IsValid(self.pinbutton) then
			self.pinbutton:SetSize(30,self.titlepanel:GetTall())
			ost = ost - self.pinbutton:GetWide()-3
			self.pinbutton:SetPos(ost,0)
		end
	end

	self:DockPadding(0, self.titlesize.height, 0, 0)
end



--MOUSE DRAGGING
function PANEL:OnMousePressed()
	self:OnPress()
	local screenX, screenY = self:LocalToScreen( 0, 0 )
	if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
		self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
		self:MouseCapture( true )
		return
	end

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		self:OnStartDragging(self:GetX(),self:GetY())
		return
	end
end

function PANEL:OnMouseReleased()
	self:OnUnpress()
	if self.Dragging then
		self.Dragging = nil
		self:OnEndDragging(self:GetX(),self:GetY())
	end
	if self.Sizing then
		self.Sizing = nil
		self:InvalidateChildren(true)
	end
	self:MouseCapture( false )
end

function PANEL:OnDragging(newx,newy)
	--for override
end

function PANEL:OnStartDragging(x,y)
	--for override
end

function PANEL:OnEndDragging(newx,newy)
	--for override
end

function PANEL:OnPress()
	--for override
end

function PANEL:OnUnpress()
	--for override
end

function PANEL:Think()

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:OnDragging(newx,newy)
		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		return

	end

	local screenX, screenY = self:LocalToScreen( 0, 0 )
	if ( self.Hovered && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + self:GetTall() - 20 ) ) then
		self:SetCursor( "sizenwse" )
		return
	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

end

function PANEL:PaintTitle(w,h)
	if not self.titlepaint then return end
	local textmustdark = self.mustdark
	--Title bg
	draw.RoundedBoxEx(self.roundsize,0,0,w,self.titlesize.height, self.titlecolor, true,true,false,false)

	if self.icon then
		surface.SetDrawColor( textmustdark and emenu.colors.text.dark or emenu.colors.text.white )
		surface.SetMaterial( self.icon )
		surface.DrawTexturedRect( 10, 5, h-10, h-10 )
	end

	--titleh-10
	draw.SimpleText(self.title,
		self.titlefont,
		(self.titlealignx == TEXT_ALIGN_CENTER) and (w/2) or self.titlexoffset+5,
		(self.titlealigny == TEXT_ALIGN_CENTER) and (self.titlesize.height/2) or 0,
		textmustdark and emenu.colors.text.dark or emenu.colors.text.white,
		self.titlealignx,
		self.titlealigny)
end

--BACKGROUND
function PANEL:PaintBG(w,h)
	local sizey = self.titlepanel:GetTall()
	--bg
	draw.RoundedBoxEx(self.roundsize,0,sizey,w,h-sizey,self.color,false,false,true,true)
end

function PANEL:Paint(w,h)
	--background
	if self.PaintBG then self:PaintBG(w,h) end
	function self.titlepanel.Paint(_,w,h) 
		self:PaintTitle(w,h) 
	end 

	local posx,posy = self:GetPos()
	local mx,my = input.GetCursorPos()
	if (mx >= posx) and (mx <= posx+w) then
		if (my >= posy) and (my <= posy+h) then
			self.Hovered = true
		else
			self.Hovered = false
		end
	else
		self.Hovered = false
	end

 	
	return true
end

function PANEL:Minimize(anim)
	if anim == nil then anim = true end
	if self.state == "normal" then
		local px,py = self:LocalToScreen(0,0)
		self.oldx,self.oldy = px,py
		self:SetZPos(1)
		self:SetMouseInputEnabled(false)
		if anim then
			self:MoveTo(px,ScrH(),emenu.config.animtime,0,-1,function()
				self:Hide()
				self:SetPos(px,py)
				self.state = "minimized"
				self:OnMinimize()
				self:SetMouseInputEnabled(true)
			end)
		else
			self:Hide()
			self:SetPos(px,py)
			self.state = "minimized"
			self:OnMinimize()
			self:SetMouseInputEnabled(true)
		end
	end
end

function PANEL:Maximize(anim)
	if anim == nil then anim = true end
	if self.state == "minimized" then
		self.state = "opening"
		self:SetMouseInputEnabled(false)
		self:SetPos(self.oldx,ScrH())
		self:Show()
		self:SetZPos(2)
		if anim then
			self:MoveTo(self.oldx,self.oldy,emenu.config.animtime,0,-1,function()
				self:SetZPos(1)
				self.state = "normal"
				self:OnMaximize()
				self:SetMouseInputEnabled(true)
			end)
		else
			self:SetZPos(1)
			self.state = "normal"
			self:OnMaximize()
			self:SetMouseInputEnabled(true)
		end
	end
end

function PANEL:ChangeMode()
	if self.state == "normal" then self:Minimize()
	elseif self.state == "minimized" then self:Maximize()
	end
end

--for override
function PANEL:OnMaximize()
end

--for override
function PANEL:OnMinimize()
end

function PANEL:GetState()
	return self.state
end

-- function PANEL:OnFocusChanged(gain)
-- 	print(self,gain)
-- 	if gain then
-- 		self:FocusNext()
-- 	else
-- 		self:FocusPrevious()
-- 	end
-- end


vgui.Register( "emenu.window", PANEL );