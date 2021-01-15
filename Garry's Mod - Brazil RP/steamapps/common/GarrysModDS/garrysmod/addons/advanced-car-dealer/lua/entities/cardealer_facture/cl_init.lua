include("shared.lua")

local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local config = KVS.GetConfig
local font = KVS.GetFont
local CFG = AdvCarDealer.GetConfig

function AdvCarDealer.OpenFacture( eFacture )
	local margin = 40
	local size_y = ScrH() - margin
	local size_x = size_y * 0.707 -- A4 ratio

	local date_time = os.time()
	local date = os.date( "%d/%m/%Y" , date_time )

	local selectedVehicle = eFacture:GetVehicle()

	local currentPrice = 0
	if IsValid( selectedVehicle ) and eFacture:GetPercentage() then
		local sData = selectedVehicle:GetVehicleClass() or selectedVehicle:GetModel()
		local tInfos = AdvCarDealer.GetCarInformations( sData )
		local min = tInfos.pricePlayer.min
		local max = tInfos.pricePlayer.max

		local percentage = eFacture:GetPercentage()
		currentPrice = tInfos.pricePlayer.min + ( tInfos.pricePlayer.max - tInfos.pricePlayer.min ) * percentage
	end

	local dFrame = vgui.Create( "DFrame" )
	dFrame:SetSize( size_x, size_y )
	dFrame:SetPos( ScrW() / 2 - size_x / 2, ScrH() )
	dFrame:MoveTo( ScrW() / 2 - size_x / 2, margin / 2, 0.5 )
	dFrame:SetDraggable( false )
	dFrame:ShowCloseButton( false )
	dFrame:MakePopup()
	function dFrame:Paint( w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( AdvCarDealer.facture_material )
		surface.DrawTexturedRect( 0, 0, w, h )

		local name = "Not found"
		if IsValid( eFacture ) and isfunction( eFacture.GetCarDealer ) and IsValid( eFacture:GetCarDealer() ) then
			name = eFacture:GetCarDealer():Name()
		end

		local text_color = config( "vgui.color.black_hard" )

		draw.SimpleText( sentences[ 31 ], font( "Montserrat Bold", 40 ), w / 2, size_y * 0.08, text_color, TEXT_ALIGN_CENTER )
		draw.SimpleText( sentences[ 32 ], font( "Montserrat Bold", 40 ), w / 2, size_y * 0.14, text_color, TEXT_ALIGN_CENTER )
		draw.SimpleText( sentences[ 33 ] .. " : " .. name, font( "Montserrat Bold", 30 ), size_x * 0.1, size_y * 0.27, text_color )
		draw.SimpleText( sentences[ 34 ] .. " : " .. date, font( "Montserrat Bold", 30 ), size_x * 0.1, size_y * 0.30, text_color )
		
		draw.SimpleText( sentences[ 40 ], font( "Montserrat", 18 ), size_x * 0.10, size_y * 0.37, Color( 255, 255, 255, 255 ) )
		draw.SimpleText( sentences[ 41 ], font( "Montserrat", 18 ), size_x * 0.302, size_y * 0.37, Color( 255, 255, 255, 255 ) )
		draw.SimpleText( sentences[ 42 ], font( "Montserrat", 18 ), size_x * 0.504, size_y * 0.37, Color( 255, 255, 255, 255 ) )
		draw.SimpleText( sentences[ 43 ], font( "Montserrat", 18 ), size_x * 0.706, size_y * 0.37, Color( 255, 255, 255, 255 ) )

		draw.SimpleText( sentences[ 35 ] .. " :", font( "Montserrat Bold", 25 ), size_x * 0.1, size_y * 0.72, text_color )
		draw.SimpleText( name, "CarDealer.Signature", size_x * 0.1, size_y * 0.76, text_color )
	
		draw.SimpleText( sentences[ 36 ] .. " :", font( "Montserrat Bold", 25 ), size_x * 0.9, size_y * 0.72, text_color, TEXT_ALIGN_RIGHT )
		
		if IsValid( selectedVehicle ) then
			local sData = selectedVehicle:GetVehicleClass() or selectedVehicle:GetModel()
			local tInfos = AdvCarDealer.GetCarInformations( sData )

			local color = selectedVehicle:GetColor()
			local unique_id = selectedVehicle:GetNWInt( "CreationID" )
			local is_underglow = AdvCarDealer.UnderglowVehicles[ unique_id ]
			
			if not AdvCarDealer:IsCarDealer( LocalPlayer() ) then
				draw.SimpleText( sentences[ 44 ] .. " : " .. ( tInfos.name or "No name" ), font( "Montserrat Bold", 15 ), size_x * 0.102, size_y * 0.403, text_color )
			end
			draw.SimpleText( sentences[ 45 ] .. " : " .. string.format( "%i, %i, %i", color.r, color.g, color.b ), font( "Montserrat Bold", 15 ), size_x * 0.302, size_y * 0.43, text_color )
			draw.SimpleText( DarkRP.formatMoney( 0 ), font( "Montserrat Bold", 15 ), size_x * 0.702, size_y * 0.43, text_color, TEXT_ALIGN_RIGHT )
			
			local price = currentPrice
			draw.SimpleText( DarkRP.formatMoney( math.Round( price ) ), font( "Montserrat Bold", 15 ), size_x * 0.702, size_y * 0.403, text_color, TEXT_ALIGN_RIGHT )
			
			local yposTotalPrice = 0.457
			if is_underglow then
				price = price + CFG().PriceUnderglow
				yposTotalPrice = 0.484
				local underglowcolor = string.ToColor( is_underglow )
				draw.SimpleText( sentences[ 46 ] .. " : " .. string.format( "%i, %i, %i", underglowcolor.r, underglowcolor.g, underglowcolor.b ), font( "Montserrat Bold", 15 ), size_x * 0.302, size_y * 0.457, text_color )
				draw.SimpleText( DarkRP.formatMoney( CFG().PriceUnderglow ), font( "Montserrat Bold", 15 ), size_x * 0.702, size_y * 0.457, text_color, TEXT_ALIGN_RIGHT )
			end

			draw.SimpleText( DarkRP.formatMoney( math.Round( price ) ), font( "Montserrat Bold", 15 ), size_x * 0.902, size_y * yposTotalPrice, text_color, TEXT_ALIGN_RIGHT )
		end
	end

	local dNumsliderPrice

	if AdvCarDealer:IsCarDealer( LocalPlayer() ) then
		local dInvoiceVehicleChoice = vgui.Create( "DComboBox", dFrame )
		dInvoiceVehicleChoice:SetPos( size_x * 0.097, size_y * 0.400 )
		dInvoiceVehicleChoice:SetSize( size_x * 0.204, size_y * 0.028 )

		for _, eVehicle in pairs ( AdvCarDealer.ListVehiclesSpawned ) do
			if not IsValid( eVehicle ) then AdvCarDealer.ListVehiclesSpawned[ _ ] = nil continue end

			if not AdvCarDealer.RentedVehicles[ eVehicle:GetNWInt( "CreationID" ) ] then continue end

			local sData = eVehicle:GetVehicleClass() or eVehicle:GetModel()
			local tInfos = AdvCarDealer.GetCarInformations( sData )

			if not tInfos then continue end
			dInvoiceVehicleChoice:AddChoice( tInfos.name, eVehicle )

			if IsValid( selectedVehicle ) and selectedVehicle == eVehicle then
				dInvoiceVehicleChoice:SetValue( tInfos.name )
			end
		end

		dInvoiceVehicleChoice.OnSelect = function( self, index, value, data )
			selectedVehicle = data

			local sData = selectedVehicle:GetVehicleClass() or selectedVehicle:GetModel()
			local tInfos = AdvCarDealer.GetCarInformations( sData )
			local min = tInfos.pricePlayer.min
			local max = tInfos.pricePlayer.max

			currentPrice = max
			dNumsliderPrice:SetMin( min )
			dNumsliderPrice:SetMax( max )
			dNumsliderPrice:SetValue( max )
		end

		local dFooter = vgui.Create( "DPanel", dFrame )
		dFooter:Dock( BOTTOM )
		dFooter:SetTall( size_y * 0.1 )
		function dFooter:Paint( w, h )
			local comm = 0
			local price = 0
			if IsValid( selectedVehicle ) then
				local sData = selectedVehicle:GetVehicleClass() or selectedVehicle:GetModel()
				local tInfos = AdvCarDealer.GetCarInformations( sData )
				price = currentPrice

				local max_price = tInfos.pricePlayer.max
				local min_price = tInfos.pricePlayer.min
				local percentageCommission = ( price - min_price ) / ( max_price - min_price )

				local min_comm = tInfos.moneyEarned.min
				local max_comm = tInfos.moneyEarned.max
				comm = min_comm + ( max_comm - min_comm ) * percentageCommission
				

				local underglow = selectedVehicle.underglow
				if underglow and underglow ~= "" then
					price = price + CFG().PriceUnderglow
					comm = comm + CFG().CommissionUnderglow
				end
			end
			draw.SimpleText( sentences[ 47 ] .. " : " .. DarkRP.formatMoney( math.Round( comm ) ), font( "Montserrat", 15 ), w / 2, 10, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER )
		end

		local dButtonsPanel = vgui.Create( "DPanel", dFooter )
		dButtonsPanel:Dock( BOTTOM )
		dButtonsPanel:SetTall( size_y * 0.03 )
		dButtonsPanel.Paint = function() end

		local button_size_x, button_size_y = size_x * 0.2, size_y * 0.035

		local dConfirmationButton = vgui.Create( "KVS.Button", dButtonsPanel )
		dConfirmationButton:SetPos( size_x / 2 - button_size_x - 5, 0 )
		dConfirmationButton:SetSize( button_size_x, button_size_y )
		dConfirmationButton:SetText( sentences[ 48 ] )
		dConfirmationButton:SetBorder( false, false, false, false )
		dConfirmationButton:SetFont( font( "Montserrat Bold", 15 ) )
		function dConfirmationButton:DoClick()
			if IsValid( dFrame ) then
				dFrame:MoveTo( ScrW() / 2 - size_x / 2, ScrH(), 0.5, 0, -1, function() dFrame:Close() end )
			end
			if not IsValid( selectedVehicle ) then return end
			local min = dNumsliderPrice:GetMin()
			local max = dNumsliderPrice:GetMax()
			local current = dNumsliderPrice:GetValue()
			local percentage = ( current - min ) / ( max - min )
			net.Start( "AdvCarDealer.ConfirmFacture" )
				net.WriteEntity( eFacture )
				net.WriteInt( 1, 32 )
				net.WriteEntity( selectedVehicle )
				net.WriteFloat( percentage )
			net.SendToServer()
		end

		local dAbortButton = vgui.Create( "KVS.Button", dButtonsPanel )
		dAbortButton:SetPos( size_x / 2 + 5, 0 )
		dAbortButton:SetSize( button_size_x, button_size_y )
		dAbortButton:SetText( sentences[ 49 ] )
		dAbortButton:SetBorder( false, false, false, false )
		dAbortButton:SetFont( font( "Montserrat Bold", 15 ) )
		dAbortButton:SetColor( config( "vgui.color.dark_red" ) )
		function dAbortButton:DoClick()
			if IsValid( dFrame ) then
				dFrame:MoveTo( ScrW() / 2 - size_x / 2, ScrH(), 0.5, 0, -1, function() dFrame:Close() end )
			end

			net.Start( "AdvCarDealer.ConfirmFacture" )
				net.WriteEntity( eFacture )
				net.WriteInt( 2, 32 )
			net.SendToServer()
		end

		dNumsliderPrice = vgui.Create( "KVS.Slider", dFooter )
		dNumsliderPrice:Dock( BOTTOM )
		dNumsliderPrice:SetTall( size_y * 0.02 )
		dNumsliderPrice:DockMargin( size_x * 0.2, 0, size_x * 0.2, 10 )
		dNumsliderPrice:SetMin( 0 )
		dNumsliderPrice:SetMax( 0 )
		dNumsliderPrice:SetValue( 0 )

		if IsValid( selectedVehicle ) then

			local sData = selectedVehicle:GetVehicleClass() or selectedVehicle:GetModel()
			local tInfos = AdvCarDealer.GetCarInformations( sData )

			local min = tInfos.pricePlayer.min
			local max = tInfos.pricePlayer.max
			dNumsliderPrice:SetMin( min )
			dNumsliderPrice:SetMax( max )
			dNumsliderPrice:SetValue( min + ( max - min ) * eFacture:GetPercentage() )

		end
		dNumsliderPrice:SetDecimals( 0 )
		function dNumsliderPrice:OnValueChanged( value )
			currentPrice = math.Round( value )
		end
	else
		local dButtonsPanel = vgui.Create( "DPanel", dFrame )
		dButtonsPanel:Dock( BOTTOM )
		dButtonsPanel:SetTall( size_y * 0.03 )
		dButtonsPanel.Paint = function() end

		local button_size_x, button_size_y = size_x * 0.2, size_y * 0.03
		local dConfirmationButton = vgui.Create( "DButton", dButtonsPanel )
		dConfirmationButton:SetPos( size_x / 2 - button_size_x - 5, 0 )
		dConfirmationButton:SetSize( button_size_x, button_size_y )
		dConfirmationButton:SetText( "" )
		function dConfirmationButton:Paint( w, h )
			if self:IsHovered() then
				draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.dark_blue )
			else
				draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.light_blue )
				draw.RoundedBoxEx( 0, 0, h - 5, w, 5, AdvCarDealer.UIColors.dark_blue, false, false, true, true )
			end
			
			draw.SimpleText( sentences[ 51 ], font( "Montserrat", 15 ), w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		function dConfirmationButton:DoClick()
			if IsValid( dFrame ) then
				dFrame:MoveTo( ScrW() / 2 - size_x / 2, ScrH(), 0.5, 0, -1, function() dFrame:Close() end )
			end
			if not IsValid( selectedVehicle ) then return end
			if not IsValid( eFacture ) then return end
			net.Start( "AdvCarDealer.BuyCar" )
				net.WriteEntity( eFacture )
				net.WriteEntity( selectedVehicle )
			net.SendToServer()
		end

		local dAbortButton = vgui.Create( "DButton", dButtonsPanel )
		dAbortButton:SetPos( size_x / 2 + 5, 0 )
		dAbortButton:SetSize( button_size_x, button_size_y )
		dAbortButton:SetText( "" )
		function dAbortButton:Paint( w, h )
			if self:IsHovered() then
				draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.dark_orange )
			else
				draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.light_orange )
				draw.RoundedBoxEx( 0, 0, h - 5, w, 5, AdvCarDealer.UIColors.dark_orange, false, false, true, true )
			end
			
			draw.SimpleText( sentences[ 52 ], font( "Montserrat", 15 ), w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		function dAbortButton:DoClick()
			if IsValid( dFrame ) then
				dFrame:MoveTo( ScrW() / 2 - size_x / 2, ScrH(), 0.5, 0, -1, function() dFrame:Close() end )
			end
		end
	end
end

function ENT:Draw()

    self:DrawModel()

    local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
	if dist > 250000 then return end
	
	local ang = self:GetAngles()
		
	local position = self:GetPos() + ang:Up() * 0.1

	ang:RotateAroundAxis(ang:Forward(), 0)
	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Up(), 90)

	cam.Start3D2D(position, ang, 0.1)
		
		draw.SimpleTextOutlined( sentences[ 31 ], font( "Montserrat Bold", 15 ), 0, -55, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
		draw.SimpleTextOutlined( sentences[ 32 ], font( "Montserrat Bold", 12 ), 0, -43, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))

	cam.End3D2D()
end

function ENT:Initialize()
	sentences = sentences or AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
end