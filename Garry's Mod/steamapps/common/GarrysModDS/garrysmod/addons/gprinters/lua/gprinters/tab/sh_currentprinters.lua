if SERVER then
	util.AddNetworkString( "gPrinters.removePrinter" )
	net.Receive( "gPrinters.removePrinter", function( len, ply )
		local printer = net.ReadString()
		if !ply:IsSuperAdmin() then return end
		gPrinters.removePrinter( printer )
	end )
end

gPrinters.tabs[ 2 ] = { loadPanels = function( parent )
	local scrollPanel = vgui.Create( "gPrinters.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )
	local panel = vgui.Create( "DPanel", scrollPanel )
	panel:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	panel:SetPos( 0, 0 )
	local printerCat = vgui.Create( "DPanelList", scrollPanel )
	panel.Paint = function( slf, w, h )
		gPrinters.drawText( 0, "Current Printers", 25, 20, 45, Color( 255, 0, 0, 150 ), 0 )
		gPrinters.drawBox( 0, 7, 60, w - 14, 35, Color( 5, 5, 5, 100 ) )
		gPrinters.drawText( 0, "If you click on one of this printers they will be removed from the server permanently and you will have to add it back again.", 16, scrollPanel:GetWide() / 2, 77, Color( 163, 163, 163, 150 ), 1 )
		gPrinters.drawPicture( 20, 63, 32, 32, "materials/f1menu/alert.png", Color( 255, 163, 0, 200 ) )

		if ( #printerCat:GetItems() ) <= 0 then
			gPrinters.drawPicture( -40, 125, 256, 256, "materials/gprinters/multiserver_256.png", Color( 255, 163, 0, 200 ) )
			gPrinters.drawBox( 0, 7, 180, w - 14, 150, Color( 5, 5, 5, 100 ) )
			gPrinters.drawBox( 0, w - 106, 180, 100, 25, Color( 5, 5, 5, 100 ) )
			gPrinters.drawText( 0, "V3", 20, w - 20, h / 2 - 58, Color( 125, 125, 255, 195 ), TEXT_ALIGN_RIGHT )
			gPrinters.drawText( 0, "It looks like you don't have any printers, create them to use this tab.", 23, w / 2, h / 2 - 20, Color( 163, 163, 163, 150 ), 1 )
			gPrinters.drawText( 0, "Go to Add Printers tab", 23, w / 2, h / 2, Color( 163, 163, 163, 150 ), 1 )
		end
	end

	printerCat:SetPos( 7, 100 )
	printerCat:SetSize( 900, 400 )
	printerCat:SetSpacing( 2 )
	printerCat:EnableVerticalScrollbar( true )
	printerCat:EnableHorizontal( true )
	printerCat:hideBar()

	for _, printer in pairs( gPrinters.printers or {} ) do
		for k, v in pairs( gPrinters.printers[ "Printers" ][ printer ] or printer ) do
			local greyColor = Color( 255, 50, 50, 75 )
			local printer = vgui.Create( "DButton", scrollPanel )
			printer:SetText( "" )
			printer:SetSize( 220, 250 )
			printer.Paint = function( slf, w, h )
				gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
				gPrinters.drawBox( 0, 4, 4, w - 8, 25, Color( 5, 5, 5, 100 ) )
				gPrinters.drawText( 0, v.name, 17, w / 2, 15, Color( v.color.r, v.color.g, v.color.b, 75 ), TEXT_ALIGN_CENTER )
				gPrinters.drawText( 0, "Health", 14, 5, 40, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Print Amount", 14, 5,  55, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Print Time", 14, 5,  70, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Printer Overheat?", 14, 5,  85, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Overheat Chance", 14, 5,  100, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "CP Removal?", 14, 5,  115, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "CP Reward", 14, 5,  130, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Color", 14, 5,  145, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Cmd", 14, 5,  160, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "F4 Price", 14, 5,  175, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "F4 Amount", 14, 5,  190, Color( 163, 163, 163, 75 ), 0 )
				gPrinters.drawText( 0, "Sort Order", 14, 5,  205, Color( 163, 163, 163, 75 ), 0 )

				gPrinters.drawBox( 0, 4, h - 30, w - 8, 25, greyColor )
				gPrinters.drawText( 0, "Remove", 14, w / 2, h - 20, Color( 255, 50, 50, 150 ), 1 )
				gPrinters.drawText( 0, v.health, 14, 210, 40, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.pamount, 14, 210, 55, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.ptime, 14, 210, 70, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.poverh, 14, 210, 85, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.ochance, 14, 210, 100, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.cpremove, 14, 210, 115, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.remrew, 14, 210, 130, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, math.Round( v.color.r ) .. " " .. math.Round( v.color.g ) .. " " .. math.Round( v.color.b ), 14, 210, 145, Color( v.color.r, v.color.g, v.color.b, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.cmd, 14, 210, 160, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.f4price, 14, 210, 175, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.f4amount, 14, 210, 190, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				gPrinters.drawText( 0, v.sortOrder, 14, 210, 205, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
				if slf:IsHovered() then
					greyColor = Color( 255, 50, 50, 25 )
				else
					greyColor = Color( 255, 50, 50, 15 )
				end
			end

			printer.DoClick = function( slf )
				local notice = vgui.Create( "DFrame", scrollPanel )
				notice:SetTitle( "" )
				notice:SetPos( printer:GetBounds( "x" ) + 8, 0 )
				notice:MoveTo( printer:GetBounds( "x" ) + 8, 150, 1, 0 )
				notice:SetSize( 220, 125 )
				notice:ShowCloseButton( false )
				notice.Paint = function( slf, w, h )
					gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 32, 32, 32, 225 ) )
					gPrinters.drawBox( 0, 4, 4, slf:GetWide() - 8, 25, Color( 255, 0, 0, 25 ) )
					gPrinters.drawPicture( 1, 1, 32, 32, "materials/f1menu/alert.png", Color( 255, 255, 255, 125 ) )
					gPrinters.drawText( 0, "REMOVING PRINTER", 16, w / 2, 15, Color( 255, 255, 255, 150 ), 1 )

					gPrinters.drawText( 1, v.name, 16, w / 2, 42, Color( 125, 125, 125, 75 ), 1 )
				end

				local remove = vgui.Create( "DButton", notice )
				remove:SetSize( 220, 32 )
				remove:SetPos( 0, 50 )
				remove:SetText( "" )
				remove.Paint = function( slf, w, h )
					gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 32, 32, 32, 225 ) )
					if !slf:IsHovered() then
						gPrinters.drawBox( 0, 4, 4, slf:GetWide() - 8, slf:GetTall() - 8, Color( 255, 163, 0, 25 ) )
						gPrinters.drawText( 0, "Remove", 14, w / 2, h / 2, Color( 163, 163, 163, 150 ), 1 )
					else
						gPrinters.drawBox( 0, 4, 4, slf:GetWide() - 8, slf:GetTall() - 8, Color( 255, 163, 0, 75 ) )
						gPrinters.drawText( 0, "Remove", 14, w / 2, h / 2, Color( 32, 32, 32, 200 ), 1 )
					end
				end

				local cancel = vgui.Create( "DButton", notice )
				cancel:SetSize( 220, 32 )
				cancel:SetPos( 0, 85 )
				cancel:SetText( "" )
				cancel.Paint = function( slf, w, h )
					gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 32, 32, 32, 225 ) )
					if !slf:IsHovered() then
						gPrinters.drawBox( 0, 4, 4, slf:GetWide() - 8, slf:GetTall() - 8, Color( 0, 255, 0, 25 ) )
						gPrinters.drawText( 0, "Cancel", 14, w / 2, h / 2, Color( 163, 163, 163, 150 ), 1 )
					else
						gPrinters.drawBox( 0, 4, 4, slf:GetWide() - 8, slf:GetTall() - 8, Color( 0, 255, 0, 75 ) )
						gPrinters.drawText( 0, "Cancel", 14, w / 2, h / 2, Color( 32, 32, 32, 200 ), 1 )
					end
				end

				cancel.DoClick = function()
					notice:Remove()
				end

				remove.DoClick = function()
					net.Start( "gPrinters.removePrinter" )
						net.WriteString( v.uid )
					net.SendToServer()
					printerCat:RemoveItem( printer )
					slf:Remove()
					notice:Remove()
				end
			end
			printerCat:AddItem( printer )
		end
	end

end	}