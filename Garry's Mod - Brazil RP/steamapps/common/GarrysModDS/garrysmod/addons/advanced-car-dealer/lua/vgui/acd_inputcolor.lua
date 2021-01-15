PANEL = { }

AccessorFunc( PANEL, 'SelectedColor', 'SelectedColor' )
AccessorFunc( PANEL, 'CoirnerColor', 'CoirnerColor' )
AccessorFunc( PANEL, 'BackgroundColor', 'BackgroundColor' )
AccessorFunc( PANEL, 'BorderRadius', 'BorderRadius', FORCE_NUMBER )

function PANEL:InitVar()
	self.m_SelectedColorMargin = 3
	self.m_CornerHoveredLerp = 0

	self.SelectedColor = Color( 255, 255, 255, 255 )
	self.CornerColor = Color( 255, 255, 255, 255 )

	self.BackgroundColor = Color( 240, 240, 240, 255 )
	self.BorderRadius = 4
	self.Border = { true, true, true, true }
end

function PANEL:Init()
	self:InitVar()
end

function PANEL:SetColor( color )
	self.SelectedColor = color
	return self
end

function PANEL:GetColor()
	return self.SelectedColor
end

function PANEL:OpenSelectorPanel()
	local this = self
	if ( self.Menu and IsValid( self.Menu ) and ispanel( self.Menu ) ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )

	-- the wide will be the size of the Color wheel, so we add in the height the size of the rest
	local wide = math.Clamp( self:GetWide(), 160, 250 )
	local height = wide + 35 + wide * 0.075 + 10 * 2


	self.Menu = vgui.Create( 'DPanel', self )
	self.Menu.GetDeleteSelf = function() end
	RegisterDermaMenuForClose( self.Menu )
	self.Menu.Paint = function( pnl, w, h )
		draw.RoundedBox( 5, 0, 0, w, h - 10, this.BackgroundColor or Color( 43, 45, 48, 255 ) )

		local triangle = {
	        { x = w / 2 - w * 0.05, y = h - 10 },
	        { x = w / 2 + w * 0.05, y = h - 10 };
	        { x = w / 2, y = h },
	    }

	    surface.SetDrawColor( this.BackgroundColor )
	    draw.NoTexture()
	    surface.DrawPoly( triangle )
	end
	self.Menu.GetDeleteSelf = function() return true end

	self.Menu.Header = vgui.Create( 'DPanel', self.Menu )
	self.Menu.Header:Dock( TOP )
	self.Menu.Header:DockMargin( 10, 25, 10, 0 )
	self.Menu.Header:SetTall( 35 )

	self.Menu.Content = vgui.Create( 'DPanel', self.Menu )
	self.Menu.Content:Dock( FILL )
	self.Menu.Content:DockMargin( 10, 10, 10, 0 )
	self.Menu.Content.Paint = function() end

	-- self.Menu.Header.SelectedColor = vgui.Create( 'KVS.Panel', self.Menu.Header ):Dock( LEFT ):SetWide( 35 )
	-- self.Menu.Header.SelectedColor:SetBackgroundColor( self.SelectedColor ):SetBorder( true, true, true, true ):SetBorderRadius( 5 ):DockMargin( 0, 0, 10, 0 )

	self.Menu.Header.RGB = vgui.Create( 'DTextEntry', self.Menu.Header )
	self.Menu.Header.RGB:Dock( FILL )
	self.Menu.Header.RGB:SetWide( ( wide - 75 ) * 0.75 )
	self.Menu.Header.RGB:DockMargin( 0, 0, 0, 0 )
	-- self.Menu.Header.RGB:Prepend( 'RGB', nil, Color( 233, 233, 233, 255 ) )
	self.Menu.Header.RGB:SetText( string.format( 'rgb( %d, %d, %d )', self.SelectedColor.r, self.SelectedColor.g, self.SelectedColor.b ) )
	self.Menu.Header.RGB:SetFont( "CarDealer.Rajdhani15" )

	-- self.Menu.Header.Alpha = vgui.Create( 'DTextEntry', self.Menu.Header )
	-- self.Menu.Header.Alpha:Dock( FILL )
	-- self.Menu.Header.Alpha:DockMargin( 10, 0, 0, 0 )
	-- self.Menu.Header.Alpha:Prepend( 'A', nil, Color( 233, 233, 233, 255 ) )
	-- self.Menu.Header.Alpha:SetText( string.format( '%d', self.SelectedColor.a / 255 * 100 ) .. '%' )

	self.Menu:SetBackgroundColor( Color( 28, 29, 31, 255 ) )
	self.Menu.ColorPicker = vgui.Create( 'CarDealer.ColorPicker', self.Menu.Content )
	-- self.Menu.ColorPicker:GetColorWheel():SetBorderColor( Color( 233, 233, 233, 255 ) )
	self.Menu.ColorPicker:SetSize( self.Menu.Content:GetTall() )
	self.Menu.ColorPicker:SetColor( self.SelectedColor )
	self.Menu.ColorPicker:Dock( FILL )
	function self.Menu.ColorPicker:OnValueChanged( color )
		this.SelectedColor = color
		if isfunction( this.OnValueChanged ) then this:OnValueChanged( color ) end
		-- this.Menu.Header.SelectedColor:SetBackgroundColor( this.SelectedColor )
		-- this.Menu.Header.Alpha:SetText( string.format( '%d', this.SelectedColor.a / 255 * 100 ) .. '%' )
		this.Menu.Header.RGB:SetText( string.format( 'rgb( %d, %d, %d )', this.SelectedColor.r, this.SelectedColor.g, this.SelectedColor.b ) )
	end

	self.Menu.m_bIsMenuComponent = true
	self.Menu.ColorPicker.m_bIsMenuComponent = true
	self.Menu.Header.m_bIsMenuComponent = true
	self.Menu.Content.m_bIsMenuComponent = true
	-- self.Menu.Header.SelectedColor.m_bIsMenuComponent = true
	self.Menu.Header.RGB.m_bIsMenuComponent = true
	-- self.Menu.Header.Alpha.m_bIsMenuComponent = true

	self.Menu:SetSize( wide, height )
	self.Menu:SetPos( math.Clamp( x - (wide - self:GetWide()) / 2, 0, ScrW() ), math.Clamp( y  - height - self:GetTall(), 0, ScrH() - height ) )
	self.Menu:MakePopup()
	self.Menu:SetVisible( true )
end

function PANEL:Paint( w, h )
	draw.RoundedBoxEx( self.BorderRadius, 0, 0, w, h, self.BackgroundColor, unpack( self.Border  ) )

	local selected_box_size = h - self.m_SelectedColorMargin * 2
	draw.RoundedBoxEx( self.BorderRadius / 2, self.m_SelectedColorMargin, self.m_SelectedColorMargin, selected_box_size, selected_box_size, self.SelectedColor, unpack( self.Border  ))

	local to = 0
	if self:IsHovered() then to = 255 end
	self.m_CornerHoveredLerp = Lerp( FrameTime() * 10, self.m_CornerHoveredLerp, to )

	local corner = {
		{ x = self.m_SelectedColorMargin + selected_box_size * 0.6, y = self.m_SelectedColorMargin + selected_box_size * 0.92 },
		{ x = self.m_SelectedColorMargin + selected_box_size * 0.92, y = self.m_SelectedColorMargin + selected_box_size * 0.6 },
		{ x = self.m_SelectedColorMargin + selected_box_size * 0.92, y = self.m_SelectedColorMargin + selected_box_size * 0.92 }
	}
	local corner_color = self.CornerColor
	if self.IsPressed then corner_color = Color( corner_color.r - 10, corner_color.g - 10, corner_color.b - 10 ) end

	surface.SetDrawColor( corner_color.r, corner_color.g, corner_color.b, self.m_CornerHoveredLerp )
	draw.NoTexture()
	surface.DrawPoly( corner )

	if self:IsHovered() then
		self:SetCursor( 'hand' )
	else
		self:SetCursor( 'none' )
	end

	draw.SimpleText( string.format( 'rgb( %d, %d, %d )', self.SelectedColor.r, self.SelectedColor.g, self.SelectedColor.b ), 'CarDealer.Rajdhani15', self.m_SelectedColorMargin * 3 + selected_box_size, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
end

function PANEL:OnMousePressed()
	self.IsPressed = true
end

function PANEL:IsSelectorOpened()
	return ( self.Menu and IsValid( self.Menu ) )
end

function PANEL:OnMouseReleased()
	self.IsPressed = false
	if self:IsSelectorOpened() then
		self.Menu:Remove()
	else
		-- open derma
		self:OpenSelectorPanel()
	end
end

derma.DefineControl( 'CarDealer.InputColor', nil, PANEL, 'EditablePanel' )