gPrinters.tabs[ 0 ] = { loadPanels = function( parent )
	local scrollPanel = vgui.Create( "gPrinters.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )


	local panel = vgui.Create( "DPanel", scrollPanel )
	panel:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	panel:SetPos( 0, 0 )
	panel.Paint = function( slf, w, h )

		if ( gPrinters.plugins[ "Other" ].adminSystem  == "" ) then
			local y = 100
	        gPrinters.drawBox( 0, 7, 60 + y, w - 14, 35, Color( 5, 5, 5, 100 ) )
			gPrinters.drawText( 0, "You must choose your admin system before configuring your printers, the menu will automatically close.", 16, scrollPanel:GetWide() / 2, 77 + y, Color( 255, 163, 0, 150 ), 1 )
			gPrinters.drawPicture( 20, 60 + y, 32, 32, "materials/f1menu/alert.png", Color( 255, 163, 0, 200 ) )
		else
			local y = 20
	        gPrinters.drawBox( 0, 7, 50 + y, 95, 40, Color( 5, 5, 5, 100 ) )
			gPrinters.drawBox( 0, 7, 90 + y, 240, 5, Color( 5, 5, 5, 100 ) )
			gPrinters.drawText( 0, "gPrinters " .. gPrinters.version, 16, 15, 60 + y, Color( 255, 255, 255, 150 ), 0 )

			gPrinters.drawText( 0, "You're currently using:", 16, 15, 77 + y, Color( 255, 255, 255, 150 ), 0 )
			gPrinters.drawText( 0, gPrinters.plugins[ "Other" ].adminSystem, 16, 150, 77 + y, Color( 255, 255, 127, 150 ), 0 )

		end

		gPrinters.drawPicture( slf:GetWide() - 210, 10, 256, 256, "materials/gprinters/circle_256.png", Color( 255, 255, 255, 5 ) )
		gPrinters.drawPicture( -125, 360, 256, 256, "materials/gprinters/circle_256.png", Color( 255, 255, 255, 5 ) )

		local y = 0
		gPrinters.drawBox( 0, 27, 230 + y, 845, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 7, 240 + y, 885, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 27, 440 + y, 845, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 7, 450 + y, 885, 1, Color( 57, 64, 77, 255 ) )
	end

	local adminModes = vgui.Create( "DPanelList", panel )
	adminModes:SetPos( 20, 260 )
	adminModes:SetSize( panel:GetWide(), 185 )
	adminModes:SetSpacing( 1 )
	adminModes:SetPadding( 1 )
	adminModes:EnableVerticalScrollbar( true )
	adminModes:EnableHorizontal( true )
	adminModes:hideBar()

	for k, v in pairs( gPrinters.adminModes or {} ) do
		local heartColor = Color( 255, 255, 255, 200 )
		local amb = vgui.Create( "DButton", panel )
		amb:SetSize( 170, 160 )
		amb:SetText( "" )
		amb.Paint = function( slf, w, h )
			gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
			gPrinters.drawBox( 0, slf:GetWide() - 30, 10, 30, 22, Color( 0, 0, 0, 100 ) )
			gPrinters.drawBox( 0, 0, 10, 70, 22, Color( 0, 0, 0, 100 ) )
			gPrinters.drawBox( 0, slf:GetWide() - 30, 30, 30, 2, Color( 0, 0, 0, 50 ) )
			gPrinters.drawBox( 0, 0, 0, slf:GetWide(), 10, Color( 0, 0, 0, 50 )  )
			gPrinters.drawBox( 0, 0, slf:GetTall() - 10, slf:GetWide(), 10, Color( 0, 0, 0, 50 ) )
			gPrinters.drawText( 0, v.displayName, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )

			gPrinters.drawPicture( slf:GetWide() / 2 - 16, slf:GetTall() / 2 + 5, 32, 32, "materials/f1menu/heart.png", heartColor )

			if slf:IsHovered() then
				v.displayColor.a = 75
				heartColor = Color( 255, 163, 0, 100 )
			else
				v.displayColor.a = 15
				heartColor = Color( 255, 255, 255, 200 )
			end

			if gPrinters.plugins[ "Other" ].adminSystem == v.displayName then
				gPrinters.drawPicture( slf:GetWide() - 32, 5, 32, 32, "materials/f1menu/tick.png", Color( 125, 255, 125, 20 ) )
				heartColor = v.displayColor
			end

			if v.enableFunction() then
				if gPrinters.plugins[ "Other" ].adminSystem == v.displayName then
					gPrinters.drawText( 0, "Selected", 16, 30, 20,Color( 59, 255, 125, 50 ), 1 )
				else
					gPrinters.drawText( 0, "Available", 16, 30, 20,Color( 59, 255, 255, 50 ), 1 )
				end
			else
				gPrinters.drawText( 0, "Disabled", 16, 30, 20,Color( 255, 59, 59, 150 ), 1 )
			end
		end

		if !v.enableFunction() then
			amb:SetEnabled( false )
			amb:SetCursor( "no" )
		end

		amb.DoClick = function()
			for setting, value in pairs( gPrinters.plugins[ "Other" ] ) do
				net.Start( "gPrinters.changeSetting" )
					net.WriteTable( { plugin = "Other", setting = "adminSystem", value = v.displayName } )
				net.SendToServer()
			end

			gPMenu:Remove()
			gPMenu = nil

			timer.Simple( 0.1, function()
				gPrinters.openMenu()
			end )
		end

		adminModes:AddItem( amb )
	end
end	}