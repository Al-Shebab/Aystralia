-- RayUI Owner: 76561198166995690
-- RayUI Version: 1.4

local PANEL = {}

AccessorFunc( PANEL, "m_bDraggable",		"Draggable",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",		"ScreenLock",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",	"DeleteOnClose",	FORCE_BOOL )

function PANEL:Init()
	self:SetFocusTopLevel( true )

	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function( button )
		self:Close()
	end
	self.CloseButton.Paint = function( self, w, h )
		surface.SetMaterial( RayUI.Icons.Close )
		surface.SetDrawColor( RayUI.Colors.White )
		surface.DrawTexturedRect(8 * RayUI.Scale, 8 * RayUI.Scale, 34 * RayUI.Scale, 34 * RayUI.Scale)
	end

	self.SidebarButton = vgui.Create( "DButton", self )
	self.SidebarButton:SetText( "" )
	self.SidebarButton.DoClick = function( button )
		if self.Sidebar then
			if self.Sidebar:GetWide() != math.Round(180 * RayUI.Scale) then
				self.Sidebar:SizeTo(math.Round(180 * RayUI.Scale), -1, 0.14)
			else
				self.Sidebar:SizeTo(52 * RayUI.Scale, -1, 0.14)		
			end
		end
	end
	self.SidebarButton.Paint = function( self, w, h )
		surface.SetMaterial( RayUI.Icons.Menu )
		surface.SetDrawColor( RayUI.Colors.White )
		surface.DrawTexturedRect(8 * RayUI.Scale, 8 * RayUI.Scale, 38 * RayUI.Scale, 38 * RayUI.Scale)
	end

	self.Label = RayUI:MakeLabel("", "RayUI:Largest", color_white, self)

	self:SetDraggable( true )
	self:SetScreenLock( true )
	self:SetDeleteOnClose( true )

	self:DockPadding(0, 50 * RayUI.Scale, 0, 0)
end

function PANEL:CreateCard(content, id, noscroll, nopopup)
	if nopopup then
		content()
	else
		self.Card = self.Card or {}

		for k,v in ipairs(self.Card) do
			if k != id then
				self.Card[k]:SetAlpha(0)
			else
				self.Card[k]:SetAlpha(255)
			end
		end

		if IsValid(self.Card[id]) then
			self.Card[id]:MoveToFront()
			return
		end

		self.Card[id] = vgui.Create(noscroll and "DPanel" or "DScrollPanel", self)
		self.Card[id]:Dock(FILL)
		self.Card[id]:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)
		self.Card[id].Paint = function(self, w, h)
			draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
		end
		if !noscroll then
			self.Card[id]:CustomScrollBar()
			self.Card[id]:GetVBar():SetWide(16 * RayUI.Scale)
		end

		content(self.Card[id])
	end
end

function PANEL:CreateSidebar(Panels)
	if !IsValid(self.Sidebar) then
		self.Sidebar = vgui.Create("DPanel", self)
		self.Sidebar:Dock(LEFT)
		self.Sidebar:SetWide(52 * RayUI.Scale)
		self.Sidebar.Paint = function( self, w, h )
			draw.RoundedBoxEx(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 50), false, false, true, false)
		end
	end

	if !Panels then return end

	for k, panel in ipairs(Panels) do
		if (panel.ShouldShow and !panel.ShouldShow()) then continue end

		self.PanelButton = vgui.Create("DButton", self.Sidebar)
		self.PanelButton:SetTall(44 * RayUI.Scale)
		self.PanelButton:Dock(panel.dock or TOP)
		self.PanelButton:DockMargin(0, 5 * RayUI.Scale, 0, 0)
		self.PanelButton:FormatRayButton( "", RayUI.Colors.Invisible, RayUI.Colors.DarkGray2)
		local ButOldPaint = self.PanelButton.Paint		
		self.PanelButton.Paint = function( s, w, h )
			ButOldPaint( s, w, h )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial(panel.icon)
			surface.DrawTexturedRect(10 * RayUI.Scale, 7 * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale)
		end
		self.PanelButton.DoClick = function()
			self:CreateCard(panel.callback, k, panel.noscroll, panel.nopopup)
		end

		self.PanelName = RayUI:MakeLabel(panel.text, "RayUI.Normal:Smallest2", RayUI.Colors.White, self.PanelButton)
		self.PanelName:Dock(LEFT)
		self.PanelName:DockMargin(52 * RayUI.Scale, 0, 0, 0)

		if k == 1 and !panel.nopopup then
			self:CreateCard(panel.callback, k, panel.noscroll, panel.nopopup)
		end
	end

end

function PANEL:SetTitle( title )
	self.Label:SetText(title)
end

function PANEL:ShowCloseButton( bShow )
	self.CloseButton:SetVisible( bShow )
end

function PANEL:Close()
	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()
end

function PANEL:OnClose()
end

function PANEL:Center()
	self:InvalidateLayout( true )
	self:CenterVertical()
	self:CenterHorizontal()
end

function PANEL:IsActive()
	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false
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

		self:SetPos( x, y )

	end

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 50 * RayUI.Scale ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end
end

function PANEL:Paint( w, h )
	RayUI:DrawBlur(self)
	draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.Gray.r, RayUI.Colors.Gray.g, RayUI.Colors.Gray.b, RayUI.Opacity)) -- Main Panel
	draw.RoundedBoxEx(RayUI.Rounding, 0, 0, w, 50 * RayUI.Scale, RayUI:GetPlayerCol(), true, true, false, false)
end

function PANEL:OnMousePressed()
	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + 50 * RayUI.Scale ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self:MouseCapture( false )
end

function PANEL:PerformLayout()
	self.CloseButton:SetSize(52 * RayUI.Scale, 52 * RayUI.Scale)
	self.CloseButton:SetPos(self:GetWide() - 52 * RayUI.Scale, 0)
	
	self.SidebarButton:SetSize(52 * RayUI.Scale, 52 * RayUI.Scale)
	self.SidebarButton:SetPos(0, 0)

	self.Label:SetSize(self:GetWide(), 52 * RayUI.Scale)
	self.Label:SetPos(52 * RayUI.Scale, -2 * RayUI.Scale)
end

vgui.Register("RayUI:MainPanel", PANEL, "EditablePanel")