--[[
	This will be the antenna menu!
]]

if SERVER then
	util.AddNetworkString( "gPrinters.retrieveMoney" )
	net.Receive( "gPrinters.retrieveMoney", function( len, ply )
		local ent = net.ReadEntity()
		local level = ( ply:GetPos():Distance( ent:GetPos() ) )

		if level < tonumber( gPrinters.plugins[ "General" ].antenaRange ) then
			if ent.dt.owning_ent != ply then return end --> Check if the user who's trying to use this retrieveMoney feature is the actual owner of the printer after checking the range.
			if ent:Getstoredmoney() >= 1 then
				if gPrinters.plugins[ "General" ].pickupNotification && ent:Getstoredmoney() >= 1 then
					DarkRP.notify( ply, 0, 3, string.format( gPrinters.plugins[ "General" ].pickupNote, tonumber( ent:Getstoredmoney() ) ) )
				end

				if ent:Getstoredmoney() >= 1 then
					ply:addMoney( ent:Getstoredmoney() )
					ent:Setstoredmoney( 0 )
				end
			else
				gPrinters.sendChat( ply, "[gPrinter]", Color( 255, 163, 0 ), "There's nothing to retrieve." )
			end
		else
			gPrinters.sendChat( ply, "[gPrinter]", Color( 255, 163, 0 ), "Out of range." )
		end
	end )

	hook.Add( "PlayerSay", "gPrinters.antenna", function( ply, text )
		if ( text == "!" .. gPrinters.plugins[ "General" ].printersCommand || text == "/" .. gPrinters.plugins[ "General" ].printersCommand ) then
			ply:ConCommand( "gPrinters.openAntenna" )
		end
	end )
end

if CLIENT then
	concommand.Add( "gPrinters.openAntenna", function()
		gPrinters.openAntenna()
	end )

	local printers = {}
	function gPrinters.openAntenna()
		if aPMenu && aPMenu:IsValid() then
			aPMenu:Remove()
			aPMenu = nil
		end

		for _, ent in pairs( ents.GetAll() ) do
			if ( IsValid( ent ) && ( ent.Base == "gbase" ) && IsValid( ent:Getowning_ent() ) && ( LocalPlayer() == ent:Getowning_ent() ) && not table.HasValue( printers, ent ) && ( ent:Getantenna() == 1 ) ) then
				table.insert( printers, ent )
			end

			if not IsValid( ent ) then
				table.RemoveByValue( printers, ent )
			end
		end

		aPMenu = vgui.Create( "gPrinters.antenaMenu" )
		if #printers >= 11 then
			aPMenu:SetSize( 400, 600 )
		else
			aPMenu:SetSize( 400, 400 )
		end
		aPMenu:SetTitle( "" )
		aPMenu:Center()
		aPMenu:MakePopup()
		aPMenu:Init()
		aPMenu:Install()
	end

	local PANEL = {}

	function PANEL:Init()
		self:SetTitle( "" )
		self:ShowCloseButton( false )
		self.startTime = SysTime()
	end

	function PANEL:Paint( w, h )
		Derma_DrawBackgroundBlur( self, self.startTime )
		gPrinters.drawBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
		gPrinters.drawBox( 0, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color( 29, 33, 44, 255 ) )

		gPrinters.drawBox( 0, 1, 25, self:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 1, 56, self:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawText( 0, "Printers Remote Menu", 17, w / 2, 40, Color( 163, 163, 163, 75 ), 1 )

		if table.Count( printers ) >= 1 then
			gPrinters.drawText( 0, "Your printers", 17, 10, 70, Color( 163, 163, 163, 75 ), 0 )
			gPrinters.drawBox( 0, 200, 56, 1, self:GetTall(), Color( 57, 64, 77, 255 ) )
		else
			gPrinters.drawText( 0, "You don't have printers with antenna upgrade.", 20, w / 2, h / 2, Color( 2, 2, 2, 150 ), 1 )
		end
	end

	function PANEL:Install()
		local close = vgui.Create( "DButton", aPMenu )
		close:SetPos( aPMenu:GetWide() - 32, -3 )
		close:SetColor( Color( 255 ,255 ,255 ) )
		close:SetSize( 32, 32 )
		close:SetText( "" )
		close.DoClick = function()
			aPMenu:Remove()
		end

		close.Paint = function( slf, w, h )
			if slf:IsHovered() then
				gPrinters.drawPicture( 0, 0, 32, 32, "materials/f1menu/cross.png", Color( 255, 255, 255, 200 ) )
			else
				gPrinters.drawPicture( 0, 0, 32, 32, "materials/f1menu/cross.png", Color( 163, 163, 163, 255 ) )
			end
		end
		--Panel of Printers
		impresoras_dinero = vgui.Create( "DPanelList", aPMenu )
		impresoras_dinero:SetPos( 3, 90 )
		impresoras_dinero:SetSize( 200, aPMenu:GetTall() )
		impresoras_dinero:SetSpacing( 1 )
		impresoras_dinero:EnableVerticalScrollbar( true )
		impresoras_dinero:EnableHorizontal( true )

		for k, v in pairs( printers ) do

			if not IsValid( v ) then
				impresoras_dinero:RemoveItem( slf )
				table.RemoveByValue( printers, v )
				return
			end
			
			local balpha = 100
			local printer = vgui.Create( "DButton", aPMenu )
			printer:SetSize( 196, 30 )
			printer:SetText( "" )
			printer.Paint = function( slf, w, h )
				if slf:IsHovered() then
					gPrinters.drawBox( 0, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
					gPrinters.drawBox( 0, 1, 1, w - 2, h - 2, Color( 57, 64, 77, 255 ) )
					gPrinters.drawBox( 0, 2, 2, w - 4, h - 4, Color( 29, 33, 44, 255 ) )
					if IsValid( v ) then
						gPrinters.drawText( 0, v.data.name, 17, w / 2, h / 2, Color( 163, 163, 163, 200 ), 1 )
					else
						gPrinters.drawText( 0, "Removed", 17, w / 2, h / 2, Color( 255, 0, 0, 50 ), 1 )
					end
				else
					gPrinters.drawBox( 0, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
					gPrinters.drawBox( 0, 1, 1, w - 2, h - 2, Color( 57, 64, 77, 255 ) )
					gPrinters.drawBox( 0, 2, 2, w - 4, h - 4, Color( 29, 33, 44, 200 ) )
					if IsValid( v ) then
						gPrinters.drawText( 0, v.data.name, 17, w / 2, h / 2, Color( 163, 163, 163, 100 ), 1 )
					else
						gPrinters.drawText( 0, "Removed", 17, w / 2, h / 2, Color( 255, 0, 0, 50 ), 1 )
					end
				end
			end

			printer.DoClick = function( slf )
				if not IsValid( v ) then
					impresoras_dinero:RemoveItem( slf )
					return
				end

				aPMenu.PaintOver = function( pslf, w, h )
					if IsValid( v ) then
						local distancia = math.Round( LocalPlayer():GetPos():Distance( v:GetPos() ) )
					
						gPrinters.drawText( 0, "Printer Information", 17, 210, 70, Color( 163, 163, 163, 75 ), 0 )
						gPrinters.drawText( 0, "Distance", 17, 210, 97, Color( 163, 163, 163, 75 ), 0 )
						if distancia < tonumber( gPrinters.plugins[ "General" ].antenaRange ) then
							gPrinters.drawText( 0, distancia, 17, 390, 97, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )
						else
							gPrinters.drawText( 0, "out of range", 17, 390, 97, Color( 255, 0, 0, 75 ), TEXT_ALIGN_RIGHT )
						end

						local attachs = {
							[1] = { model = "Antenna", status = 0 },
							[2] = { model = "Armour", status = 0 },
							[3] = { model = "Cooler", status = 0 },
							[4] = { model = "More Print", status = 0 },
							[5] = { model = "Silencer", status = 0 },
							[6] = { model = "Fast Print", status = 0 },
							[7] = { model = "Scanner", status = 0 },
						}

						if v:Getantenna() == 1 then attachs[ 1 ].status = 1 end
						if v:Getarmour() == 1 then attachs[ 2 ].status = 1 end
						if v:Getfan() == 1 then attachs[ 3 ].status = 1 end
						if v:Getmoreprint() == 1 then attachs[ 4 ].status = 1 end
						if v:Getsilencer() == 1 then attachs[ 5 ].status = 1 end
						if v:Getpipes() == 1 then attachs[ 6 ].status = 1 end
						if v:Getscanner() == 1 then attachs[ 7 ].status = 1 end

						for i = 1, 7 do
							gPrinters.drawBox( 0, 200, 82 + ( i * 33 ), w, 32, Color( 0, 0, 0, 50 ) )
							gPrinters.drawText( 0, attachs[ i ].model, 15, 210, 100 + ( i * 32 ), Color( 163, 163, 163, 75 ), 0 )

							if attachs[ i ].status == 1 then
								gPrinters.drawPicture( 365, 82 + ( i * 33 ), 32, 32, "materials/f1menu/tick.png", Color( 50, 125, 50, 100 ) )
							else
								gPrinters.drawPicture( 365, 82 + ( i * 33 ), 32, 32, "materials/f1menu/cross.png", Color( 255, 50, 50, 100 ) )
							end
						end

						--Retrieve Button
						local width, height = 197, 32
						gPrinters.drawBox( 0, 201, 365, width - 1, height - 2, Color( 0, 0, 0, balpha ) )
						if distancia < tonumber( gPrinters.plugins[ "General" ].antenaRange ) then
							gPrinters.drawText( 0, "Retrieve Now!", 15, 300, 380, Color( 163, 163, 163, 75 ), 1 )
						else
							gPrinters.drawText( 0, "Out of range", 15, 300, 380, Color( 163, 163, 163, 75 ), 1 )
							gPrinters.drawPicture( 200, 363, 32, 32, "materials/f1menu/cross.png", Color( 255, 50, 50, 50 ) )
						end

						gPrinters.drawText( 0, "Stored Money", 15, 210, 355, Color( 163, 163, 163, 75 ), 0 )
						gPrinters.drawText( 0, "$" .. gPrinters.moneyFormat( v:Getstoredmoney() ), 15, 390, 355, Color( 163, 163, 163, 75 ), TEXT_ALIGN_RIGHT )

						gPrinters.drawBox( 0, 200, 80, 198, 1, Color( 57, 64, 77, 255 ) )
						gPrinters.drawBox( 0, 200, 115, 198, 1, Color( 57, 64, 77, 255 ) )
						gPrinters.drawBox( 0, 200, 345, 198, 1, Color( 57, 64, 77, 255 ) )
					end
				end

				local retrieve = vgui.Create( "DButton", aPMenu )
				retrieve:SetSize( 197, 32 )
				retrieve:SetPos( 201, 365 )
				retrieve:SetText( "" )
				retrieve.DoClick = function()
					net.Start( "gPrinters.retrieveMoney" )
						net.WriteEntity( v )
					net.SendToServer()
				end
				retrieve.Paint = function( solf )
					if solf:IsHovered() then
						balpha = 150
					else
						balpha = 100
					end
				end

			end

			if not IsValid( v ) then
				impresoras_dinero:RemoveItem( printer )
			end

			impresoras_dinero:AddItem( printer )
		end


		
	end
	vgui.Register( "gPrinters.antenaMenu", PANEL, "DFrame" )


end