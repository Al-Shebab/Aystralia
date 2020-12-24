if CLIENT then
	net.Receive( "gPrinters.openUpgrades", function( len, ply )
		local ent = net.ReadEntity()
		local name = net.ReadString()
		gPrinters.openUpgrades( ent, name )
	end )

	concommand.Add( "gPrinters.openMenu", function()
		if !LocalPlayer():IsSuperAdmin() then
			chat.AddText( Color( 255, 163, 0 ), "[gPrinter]:", Color( 255, 255, 255 ), "You're not allowed to access this menu." )
			return
		end
		gPrinters.openMenu()
	end )

	function gPrinters.openUpgrades( ent, name )
		if uPMenu && uPMenu:IsValid() then
			uPMenu:Remove()
			uPMenu = nil
		end

		local sizeY = 80
		local multY = 46
		if ( gPrinters.plugins[ "General" ].antenna == true ) then sizeY = sizeY + multY end
		if ( gPrinters.plugins[ "General" ].armour == true ) then sizeY = sizeY + multY end
		if ( gPrinters.plugins[ "General" ].silencer == true ) then sizeY = sizeY + multY end
		if ( gPrinters.plugins[ "General" ].moreprint == true ) then sizeY = sizeY + multY end
		if ( gPrinters.plugins[ "General" ].fastprint == true ) then sizeY = sizeY + multY end
		if ( gPrinters.plugins[ "General" ].scanner == true ) then sizeY = sizeY + multY end
		if ( gPrinters.plugins[ "General" ].cooler == true ) then sizeY = sizeY + multY end

		if sizeY <= 90 then
			sizeY = 400
		end
		uPMenu = vgui.Create( "gPrinters.upgradesMenu" )
		uPMenu:SetSize( 400, sizeY )
		uPMenu:SetTitle( "" )
		uPMenu:Center()
		uPMenu:MakePopup()
		uPMenu:Init( ent, name )
		uPMenu:Install()
	end

	local P1 = {}

	function P1:Init( ent, name )
		self:SetTitle( "" )
		self:ShowCloseButton( false )
		self.startTime = SysTime()
		self.ent = ent
		self.name = name
	end

	function P1:Paint( w, h )
		Derma_DrawBackgroundBlur( self, self.startTime )
		gPrinters.drawBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
		gPrinters.drawBox( 0, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color( 29, 33, 44, 255 ) )

		gPrinters.drawBox( 0, 1, 25, self:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 1, 56, self:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawText( 0, self.name .. " Upgrades Menu", 17, w / 2, 40, Color( 255, 163, 0, 75 ), 1 )

		if self:GetTall() == 400 then
			gPrinters.drawText( 0, "No Attachments Available", 17, w / 2, h / 2, Color( 255, 163, 0, 75 ), 1 )
		end
	end

	function P1:Install()
		local y = 30
		local multY = 45
		if ( gPrinters.plugins[ "General" ].antenna == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].antenna == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Antenna", "This will allow you to remote-access.", 1, self.ent, self.ent:Getantenna(), gPrinters.plugins[ "General" ].antennaup )
		end

		if ( gPrinters.plugins[ "General" ].armour == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].armour == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Armour", "This will provide " .. tonumber( gPrinters.plugins[ "General" ].armorUpgrade ) .. " armor to your printer", 2, self.ent, self.ent:Getarmour(), gPrinters.plugins[ "General" ].armourup )
		end

		if ( gPrinters.plugins[ "General" ].cooler == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].cooler == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Fan", "This will reduce your overheat chance", 3, self.ent, self.ent:Getfan(), gPrinters.plugins[ "General" ].fanup )
		end

		if ( gPrinters.plugins[ "General" ].moreprint == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].moreprint == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Print", "This will boost your printers print amount", 4, self.ent, self.ent:Getmoreprint(), gPrinters.plugins[ "General" ].moreprintup )
		end

		if ( gPrinters.plugins[ "General" ].silencer == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].silencer == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Silencer", "This will reduce your printers sound", 5, self.ent, self.ent:Getsilencer(), gPrinters.plugins[ "General" ].silencerup )
		end

		if ( gPrinters.plugins[ "General" ].fastprint == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].fastprint == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Pipes", "This will boost your printers speed", 6, self.ent, self.ent:Getpipes(), gPrinters.plugins[ "General" ].pipesup )
		end

		if ( gPrinters.plugins[ "General" ].scanner == true ) then y = y + multY end
		if ( gPrinters.plugins[ "General" ].scanner == true ) then
			local Antenna = vgui.Create( "gprinter_button", self )
			Antenna:SetPos( 5, y )
			Antenna:SetSize( self:GetWide() - 10, 40 )
			Antenna:Information( "Scanner", "This will secure your printer to avoid stealing", 7, self.ent, self.ent:Getscanner(), gPrinters.plugins[ "General" ].scannerup )
		end

		local close = vgui.Create( "DButton", uPMenu )
		close:SetPos( uPMenu:GetWide() - 32, -3 )
		close:SetColor( Color( 255 ,255 ,255 ) )
		close:SetSize( 32, 32 )
		close:SetText( "" )
		close.DoClick = function()
			uPMenu:Remove()
		end

		close.Paint = function( slf, w, h )
			if slf:IsHovered() then
				gPrinters.drawPicture( 0, 0, 32, 32, "materials/f1menu/cross.png", Color( 255, 255, 255, 200 ) )
			else
				gPrinters.drawPicture( 0, 0, 32, 32, "materials/f1menu/cross.png", Color( 163, 163, 163, 255 ) )
			end
		end
	end

	vgui.Register( "gPrinters.upgradesMenu", P1, "DFrame" )

	function gPrinters.openMenu()
		if gPMenu && gPMenu:IsValid() then
			gPMenu:Remove()
			gPMenu = nil
		end

		gPMenu = vgui.Create( "gPrinters.menu" )
		gPMenu:SetSize( 900, 500 )
		gPMenu:SetTitle( "" )
		gPMenu:Center()
		gPMenu:MakePopup()
		gPMenu:Install()
	end

	local P2 = {}

	function P2:Init()
		self:SetTitle( "" )
		self:ShowCloseButton( false )
		self.currentTab = ""
		self.tabContents = vgui.Create( "DPanel", self )
		self.tabContents:SetPos( 0, 0 )
		self.tabContents:SetSize( 900, 500 )
		self.tabContents:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
		self.startTime = SysTime()
		mode = ""
		gPrinters.tabs[ 0 ].loadPanels( self.tabContents )
	end

	function P2:Paint()
		Derma_DrawBackgroundBlur( self, self.startTime )
		gPrinters.drawBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
		gPrinters.drawBox( 0, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color( 29, 33, 44, 255 ) )

		gPrinters.drawBox( 0, 1, 25, self:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 1, 56, self:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
	end

	function P2:Install()
		self.cat = vgui.Create( "DPanelList", gPMenu )
		self.cat:SetPos( 4, 26 )
		self.cat:SetSize( gPMenu:GetWide() - 6, 30 )
		self.cat:SetSpacing( 1 )
		self.cat:EnableVerticalScrollbar( true )
		self.cat:EnableHorizontal( true )

		for k, v in pairs( gPrinters.tabCategories ) do
			local category = vgui.Create( "DButton", gPMenu )
			category:SetSize( 222.5, 30 )
			category:SetText( "" )
			category.tab = nil
			category.Paint = function( slf, w, h )
			gPrinters.drawBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 16, 19, 26, 255 ) )

			if mode == v.name then
				gPrinters.drawPicture( 4, 0, 32, 32, v.icon, Color( 255, 163, 0, 255 ) )
				gPrinters.drawText( 0, v.name, 17, w / 2, h / 2, Color( 255, 163, 0, 75 ), 1 )
			else
				if slf:IsHovered() then
					gPrinters.drawPicture( 4, 0, 32, 32, v.icon, Color( 255, 255, 255, 255 ) )
				else
					gPrinters.drawPicture( 4, 0, 32, 32, v.icon, Color( 163, 163, 163, 150 ) )
				end
				gPrinters.drawText( 0, v.name, 17, w / 2, h / 2, Color( 163, 163, 163, 75 ), 1 )
			end

			if slf:IsHovered() && ( gPrinters.plugins[ "Other" ].adminSystem == "" ) then
				category:SetCursor( "no" )
			end
		end

		if ( gPrinters.plugins[ "Other" ].adminSystem == "" ) then
			category:SetEnabled( false )
			category:SetCursor( "no" )
		else
			category:SetEnabled( true )
			category:SetCursor( "hand" )
		end

		category.DoClick = function()
			mode = v.name
			surface.PlaySound( "buttons/lightswitch2.wav" )

			for _, panel in pairs ( self.tabContents:GetChildren() ) do
				panel:Remove()
			end
				gPrinters.tabs[ v.id ].loadPanels( self.tabContents )
			end
			self.cat:AddItem( category )
		end

		local close = vgui.Create( "DButton", gPMenu )
		close:SetPos( gPMenu:GetWide() - 32, -3 )
		close:SetColor( Color( 255 ,255 ,255 ) )
		close:SetSize( 32, 32 )
		close:SetText( "" )
		close.DoClick = function()
			//gPrinters.openMenu()
			gPMenu:Remove()
		end

		close.Paint = function( slf, w, h )
			if slf:IsHovered() then
				gPrinters.drawPicture( 0, 0, 32, 32, "materials/f1menu/cross.png", Color( 255, 255, 255, 200 ) )
			else
				gPrinters.drawPicture( 0, 0, 32, 32, "materials/f1menu/cross.png", Color( 163, 163, 163, 255 ) )
			end
		end
	end

	function P2:closeMenu()
		if gPMenu && gPMenu:IsValid() then
			gPMenu:Remove()
			gPMenu = nil
		end
	end
	vgui.Register( "gPrinters.menu", P2, "DFrame" )
end