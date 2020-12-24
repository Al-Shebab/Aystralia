local PANEL = {} -- fcdDFrame

function PANEL:Init()
	self.title = ''
	self.titleSize = 20

	self:SetTitle('')
	self:SetDraggable( false )
	self:ShowCloseButton( false )
	self:MakePopup()
end

function PANEL:Paint( w, h )
	fcd.drawBlur( self, 6 )
	fcd.drawOutlinedBox( 0, 0, w, h )

	fcd.drawBox( 0, 0, w, 25, fcd.clientVal( 'titleBgColor' ) )
	draw.SimpleText( self.title, 'fcd_font_' .. self.titleSize, 3, 3, fcd.clientVal( 'mainTextColor' ) )
end

function PANEL:addCloseButton()
	self.close = self:Add( 'DButton' )
	self.close:SetSize( 25, 25 )
	self.close:SetPos( self:GetWide() - 25, 0 )
	self.close:SetText( '' )

	local clr = fcd.clientVal( 'closeButtonColor' )

	function self.close:Paint( w, h )
		if self:IsHovered() then
			fcd.drawBox( 0, 0, w, h, clr )
		else
			fcd.drawBox( 0, 0, w, h, Color( clr.r, clr.g, clr.b, 200 ) )
		end
		
		draw.SimpleText( '✖', 'fcd_font_25', w / 2, h / 2, fcd.clientVal( 'mainTextColor' ), 1, 1 )
	end

	function self.close:DoClick()
		self:GetParent():Remove()
	end
end

vgui.Register( 'fcdDFrame', PANEL, 'DFrame' )

PANEL = {} -- fcdDPanel

function PANEL:Init()
	self.title = ''
	self.drawTitle = false
end

function PANEL:Paint( w, h )
	fcd.drawBox( 0, 0, w, h, fcd.clientVal( 'secondaryBgColor' ) )

	if self.drawTitle then
		fcd.drawBox( 0, 0, w, 20, fcd.clientVal( 'secondaryTitleBgColor' ) )
	end

	draw.SimpleText( self.title, 'fcd_font_15', 3, 3, fcd.clientVal( 'mainTextColor' ) )
end

vgui.Register( 'fcdDPanel', PANEL, 'DPanel' )

PANEL = {} -- fcdCheck

function PANEL:Init()
	local w, h = 550, 225

	self:SetSize( w, h )
	self:SetPos( ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 ) )
	self:addCloseButton()

	self.question = ''

	self.yes = self:Add( 'fcdDButton' )
	self.yes:SetSize( w - 10, ( h - 35) / 2 - 7.5 )
	self.yes:SetPos( 5, 35 )
	self.yes.text = 'Yes'
	self.yes.textSize = 25

	self.yes.onYesClicked = function() end

	function self.yes:DoClick()
		self.onYesClicked()
	end

	self.no = self:Add( 'fcdDButton' )
	self.no:SetSize( w - 10, ( h - 35) / 2 - 7.5 )
	self.no:SetPos( 5, 35 + ( h - 35) / 2 - 6 + 5 )
	self.no.text = 'No'
	self.no.textSize = 25

	self.no.onNoClicked = function()
		self:Remove()
	end

	function self.no:DoClick()
		self.onNoClicked()
	end
end

function PANEL:Paint( w, h )
	fcd.drawBlur( self, 6 )
	fcd.drawOutlinedBox( 0, 0, w, h )

	draw.SimpleText( self.question, 'fcd_font_25', 5, 5, fcd.clientVal( 'mainTextColor' ) )
end

vgui.Register( 'fcdCheck', PANEL, 'fcdDFrame' )

PANEL = {} -- fcdDButton

function PANEL:Init()
	self:SetText( '' )

	self.text = ''
	self.textSize = 15
	self.clickable = true
	self.circle = false
end

function PANEL:Paint( w, h )
	local clr = fcd.clientVal( 'normalButtonColor' )

	if self.clickable then
		if not self.circle then
			if not self:IsHovered() then
				fcd.drawBox( 0, 0, w, h, clr )
			else
				fcd.drawBox( 0, 0, w, h, Color( clr.r, clr.g, clr.b, clr.a - 50 ) )
			end
		else
			if not self:IsHovered() then
				fcd.drawCircle( 0, 0, w / 2, clr )
			else
				fcd.drawCircle( 0, 0, w / 2, Color( clr.r, clr.g, clr.b, clr.a - 50 ) )
			end
		end
	else
		fcd.drawBox( 0, 0, w, h, Color( clr.r, clr.g, clr.b, clr.a - 50 ) )
	end

	draw.SimpleText( self.text or '', 'fcd_font_' .. self.textSize or 15, w / 2, h / 2, fcd.clientVal( 'mainTextColor' ), 1, 1 )
end

vgui.Register( 'fcdDButton', PANEL, 'DButton' )


PANEL = {} -- fcdDComboBox

function PANEL:Init()
	self:SetFont( 'fcd_font_15' )
	self:SetTextColor( fcd.clientVal('mainTextColor' ) )
end

function PANEL:Paint( w, h )
	fcd.drawOutlinedBox( 0, 0, w, h )
end

vgui.Register( 'fcdDComboBox', PANEL, 'DComboBox' )

PANEL = {} -- fcdDTextEntry

function PANEL:Init()
	self:SetFont( 'DermaDefault' )
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, fcd.clientVal( 'textEntryColor' ) )

	self:DrawTextEntryText( fcd.clientVal( 'mainTextColor' ), Color( 150, 150, 150, 150 ), color_white )
end

vgui.Register( 'fcdDTextEntry', PANEL, 'DTextEntry' )

PANEL = {} -- fcdDCheckBox

function PANEL:Init()
end

function PANEL:Paint( w, h )
	fcd.drawOutlinedBox( 0, 0, w, h )
end

vgui.Register( 'fcdDCheckBox', PANEL, 'DCheckBox' )