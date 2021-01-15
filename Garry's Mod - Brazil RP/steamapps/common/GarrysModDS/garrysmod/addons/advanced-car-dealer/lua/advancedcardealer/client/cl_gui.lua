local speed_f = AdvCarDealer.Speed
local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local config = KVS.GetConfig
local font = KVS.GetFont
local CFG = AdvCarDealer.GetConfig

local function GetVehiclesWithParameters( categories, searchname )
	local list = {}

	if table.IsEmpty( categories ) then
		for category, infos in pairs( CFG().Vehicles or {} ) do 
			for sclass, vinfos in pairs( infos ) do
				if ( not vinfos.isInCatalog ) and not ( AdvCarDealer:IsCarDealer( LocalPlayer() ) and vinfos.isInCardealerCatalog ) then continue end

				if searchname and isstring( searchname ) and searchname ~= "" then
					if string.find( vinfos.name, searchname ) then
						vinfos.brand = category
						list[ sclass ] = vinfos
					end
				else
					vinfos.brand = category
					list[ sclass ] = vinfos
				end
			end
		end
	else
		for _, category in pairs( categories ) do 
			for sclass, vinfos in pairs( CFG().Vehicles[ category ] or {} ) do
				if ( not vinfos.isInCatalog ) and not ( AdvCarDealer:IsCarDealer( LocalPlayer() ) and vinfos.isInCardealerCatalog ) then continue end

				if searchname and isstring( searchname ) and searchname ~= "" then
					if string.find( vinfos.name, searchname ) then
						vinfos.brand = category
						list[ sclass ] = vinfos
					end
				else
					vinfos.brand = category
					list[ sclass ] = vinfos
				end
			end
		end
	end

	return list
end

function AdvCarDealer.Preview( tData, dParent )

	local dVehicleModel = vgui.Create( "DModelPanel", dParent )

	local model = tData.model or AdvCarDealer.GetCarInformations( tData.vehicle ).model

	dVehicleModel:SetModel( model )
	dVehicleModel:SetColor( string.ToColor( tData.color ) or color_white )
	dVehicleModel.Entity:SetSkin( tData.skin or 0 )

	local bdgr = tData.bodygroup and ( ( not istable( tData.bodygroup ) and util.JSONToTable( tData.bodygroup ) ) or tData.bodygroup )
	for id, bdr in pairs( istable( bdgr ) and bdgr or {} ) do
		dVehicleModel.Entity:SetBodygroup( id, bdr )
	end

	local mn, mx = dVehicleModel.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

	dVehicleModel.LerpPos = 0

	function dVehicleModel:LayoutEntity(ent)
		if self:IsDown() then
			local xCursPos, yCursPos = self:CursorPos()
			if not self.xAng then self.xAng = xCursPos end

			self.LerpPos = Lerp(RealFrameTime()*4, self.LerpPos, xCursPos - 180)
			ent:SetAngles(Angle(0, self.LerpPos, 0))
		else
			self.xAng = nil
		end
	end

	dVehicleModel:SetFOV( 45 )
	dVehicleModel:SetCamPos( Vector( size, size, size ) )
	dVehicleModel:SetLookAt( ( mn + mx ) * 0.5 )

	return dVehicleModel
end

function AdvCarDealer.OpenGarage( eGarage, tVehicles, isJobGarage )
	local dlc_lang = AdvCarDealer.DLC1 and AdvCarDealer.DLC1.GetLang

	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetDraggable( false )
	dFrame:SetPos( -500, 10 )
	dFrame:MoveTo( 10, 10, 0.5 )
	dFrame:SetSize( 500, 330 )
    dFrame:SetFont("Montserrat")
    dFrame:SetTitle( sentences[ 19 ] )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf494, color_white )
	dFrame:MakePopup()

	local VehicleModel
	local BottomPanelTS
	local TakeOut
	local Resell

	-- DLC
	local InsuranceButton

	function dFrame:SelectCar( tSelectedVehicle )
		if self.RightMenu and IsValid( self.RightMenu ) then self.RightMenu:Remove() end
		local dRightMenu = vgui.Create( "KVS.Panel", self )
		self.RightMenu = dRightMenu
		dRightMenu:Dock( RIGHT )
		dRightMenu:SetWide( 290 )
		function dRightMenu:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, 2, h, AdvCarDealer.UIColors.bar_separation )
			if not tSelectedVehicle or ( not isJobGarage and not AdvCarDealer.GetCarInformations( tSelectedVehicle.vehicle ) ) then
				draw.SimpleText( sentences[ 21 ], font( "Montserrat Bold", 25 ), w / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end

		if not tSelectedVehicle or ( not isJobGarage and not AdvCarDealer.GetCarInformations( tSelectedVehicle.vehicle ) ) or not tSelectedVehicle.id then
			return
		end 

		local dVehicleModel = AdvCarDealer.Preview( tSelectedVehicle, dRightMenu )
		dVehicleModel:Dock( TOP )
		dVehicleModel:SetTall( 290 )

		local dButtonsPanel = vgui.Create( "KVS.Panel", dRightMenu )
		dButtonsPanel:Dock( BOTTOM )
		dButtonsPanel:SetTall( 30 )

		local dTakeOut = vgui.Create( "KVS.Button", dButtonsPanel )
		dTakeOut:Dock( FILL )
		dTakeOut:SetWide( 290 / 2 )
		dTakeOut:SetText( "TAKE OUT" )
		dTakeOut:SetFont( font( "Montserrat Bold", 15 ) )
		dTakeOut:SetBorder( false, false, false, false )

		if not tSelectedVehicle.nextspawn or tonumber( tSelectedVehicle.nextspawn ) < os.time() then
			if isJobGarage and tSelectedVehicle.price then
				dTakeOut:SetText( sentences[ 20 ] .. " ( " .. DarkRP.formatMoney( tSelectedVehicle.price ) .. " )" )
			else
				dTakeOut:SetText( sentences[ 20 ] )
			end
		else
			local iTimestamp = tSelectedVehicle.nextspawn
			local sTimeString = os.date( AdvCarDealer.DLC1.DateFormat or "%H:%M:%S - %d/%m/%Y" , iTimestamp )

			dTakeOut:SetText( sTimeString )
			dTakeOut:SetDisabled( true )
		end

		function dTakeOut:DoClick()
			if not tSelectedVehicle.nextspawn or tonumber( tSelectedVehicle.nextspawn ) < os.time() then
				net.Start("AdvCarDealer.TakeOutVehicle")
					net.WriteEntity( eGarage )
					net.WriteInt( tSelectedVehicle.id, 32 )
				net.SendToServer()
				
				if IsValid( dFrame ) then dFrame:Remove() end
			end
		end

		if not isJobGarage then
			local dResell = vgui.Create( "KVS.Button", dButtonsPanel )
			dResell:Dock( RIGHT )
			dResell:SetTall( 30 )
			dResell:SetWide( 290 / 2 )
			dResell:SetText( sentences[ 58 ] )
			dResell:SetColor( config( "vgui.color.dark_red" ) )
			dResell:SetFont( font( "Montserrat Bold", 15 ) )
			dResell:SetBorder( false, false, false, false )

			local priceCatalog = AdvCarDealer.GetCarInformations( tSelectedVehicle.vehicle ).priceCatalog or 0
			local percentage = ( CFG().PercentageWhenResell or 0 ) / 100
			percentage = math.Clamp( percentage, 0, 1 )
			local money = priceCatalog * percentage

			function dResell:DoClick()	
				local dPopup = vgui.Create( 'KVS.Popup' )
					:SetTitle( sentences[ 58 ] )
					:SetContent( string.format( sentences[ 68 ], DarkRP.formatMoney( money or 0 ) ) )
					:SetMainColor( config('vgui.color.dark_red'))
					:SetIcon( font( 'FAS', 50, 'extended' ), 0xf05a )
					:SetSize( 400, 200 )
					:SetBlur( true )
					:SetAcceptText( sentences[ 69 ] )
					:SetDenyText( sentences[ 70 ] )
					:MakePopup()
					:Center()
					:SetAnimation( true )
					:SetAnimationDelay( 0.2 )
				function dPopup:OnAccept()
					net.Start("AdvCarDealer.ResellVehicle")
						net.WriteEntity( eGarage )
						net.WriteInt( tSelectedVehicle.id, 32 )
					net.SendToServer()
					
					if IsValid( dFrame ) then dFrame:Remove() end
				end
			end


			if AdvCarDealer.DLC1 then
				local dInsuranceButton = vgui.Create( "DButton", dRightMenu )
				dInsuranceButton:SetSize( 290 - 2, 30 )
				dInsuranceButton:SetPos( 2, 0 )
				dInsuranceButton:SetText( "" )
				dInsuranceButton:DockMargin( 0, 0, 0, 5 )
				function dInsuranceButton:Paint( w, h )
					if self:IsHovered() then
						draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.left_menu_hovergrey )
					end

					draw.RoundedBox( 0, 0, 0, w, 1, AdvCarDealer.UIColors.bar_separation )
					local x, y = draw.SimpleText( dlc_lang()[8] .. " : " .. ( ( tSelectedVehicle.insurance == "1" or tSelectedVehicle.insurance == 1 ) and dlc_lang()[16] or dlc_lang()[17] ), font( "Montserrat Bold", 15 ), ( w ) / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					surface.SetDrawColor( AdvCarDealer.UIColors.text_grey )
					surface.SetMaterial( AdvCarDealer.InsuranceMat )
					surface.DrawTexturedRect( 5, ( h - 24 ) / 2, 24, 24 )
					draw.RoundedBox( 0, 0, h - 1, w, 1, AdvCarDealer.UIColors.bar_separation )
				end
				function dInsuranceButton:DoClick()
					if tSelectedVehicle.insurance ~= "1" and tSelectedVehicle.insurance ~= 1 then
						AdvCarDealer.OpenInsurance( tSelectedVehicle.vehicle, tSelectedVehicle.id, dFrame )
					end
				end
			end
		end
	end

	local tSelectedVehicle

	if tVehicles and not table.IsEmpty( tVehicles ) then
		for k, v in pairs( tVehicles ) do
			tSelectedVehicle = v
			-- DLC addition
			if tSelectedVehicle.nextspawn then tSelectedVehicle.nextspawn = tonumber( tSelectedVehicle.nextspawn ) end
			tSelectedVehicle.id = v.id or k
			break
		end
	end

	dFrame:SelectCar( tSelectedVehicle )

	local dLeftMenu = vgui.Create( "KVS.ScrollPanel", dFrame )
	dLeftMenu:Dock( FILL )
	dLeftMenu:SetWide( 200 )
	for _, tCustomInfos in pairs( tVehicles ) do
		local tVehicleInfos = ( isJobGarage and tCustomInfos ) or AdvCarDealer.GetCarInformations( tCustomInfos.vehicle )

		if not tVehicleInfos then continue end

		local dCategories = vgui.Create( "DButton", dLeftMenu )
		dCategories:Dock( TOP )
		dCategories:SetText( "" )
		dCategories:SetTall( 35 )
		dCategories:DockMargin( 0, 0, 0, 5 )
		function dCategories:Paint( w, h )
			if self:IsHovered() or tCustomInfos == tSelectedVehicle then
				draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.left_menu_hovergrey )
			end

			draw.RoundedBox( 0, 0, 0, w, 1, AdvCarDealer.UIColors.bar_separation )
			draw.SimpleText( tCustomInfos.name or tVehicleInfos.name, font( "Montserrat", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.RoundedBox( 0, 0, h - 1, w, 1, AdvCarDealer.UIColors.bar_separation )
		end
		function dCategories:DoClick()
			tSelectedVehicle = tCustomInfos
			tSelectedVehicle.id = tCustomInfos.id or _

			dFrame:SelectCar( tSelectedVehicle )
		end
	end
end

function AdvCarDealer.OpenTablet( eTablet, topleft, bottomright )

	local selected_categories = {}
	local dCenterMenu
	
	if ( topleft and not topleft.visible ) or ( bottomright and not bottomright.visible ) then
		topleft, bottomright = nil, nil
	end
	
	local tablet_sizex, tablet_sizey = 840, 530
	local tablet_posx, tablet_posy = ScrW() / 2 - tablet_sizex / 2, ScrH() / 2 - tablet_sizey / 2
	if topleft then
		tablet_sizex, tablet_sizey = bottomright.x - topleft.x, bottomright.y - topleft.y
		tablet_posx, tablet_posy = topleft.x, topleft.y
		
		if tablet_sizex < 100 or tablet_sizey <  100 then
			topleft, bottomright = nil, nil
			tablet_sizex, tablet_sizey = 840, 530
			tablet_posx, tablet_posy = ScrW() / 2 - tablet_sizex / 2, ScrH() / 2 - tablet_sizey / 2
		end
	end
	local animationTime = 0.5

	local dFrame = vgui.Create( "DFrame" )
	dFrame:SetSize( 0, 0 )
	if topleft then
		dFrame:SetPos( topleft.x, topleft.y )
	else
		dFrame:SetPos( ScrW() / 2, ScrH() / 2 )
	end
	dFrame:ShowCloseButton( false )
	dFrame:SetTitle( "" )
	dFrame:SetAlpha( 0 )
	dFrame:MoveTo( tablet_posx, tablet_posy, animationTime )
	dFrame:SizeTo( tablet_sizex, tablet_sizey, animationTime )
	dFrame:AlphaTo( 255, animationTime )
	dFrame:MakePopup()
	function dFrame:Paint( w, h )
		if not topleft then
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.SetMaterial( AdvCarDealer.tablet_material )
			surface.DrawTexturedRect( 0, 0, w, h )
		end
	end
	function dFrame:Close()
		if IsValid( dFrame ) then
			dFrame:SizeTo( 0, 0, 0.9 )
			dFrame:AlphaTo( 0, 0.9 )
			if not topleft then
				dFrame:MoveTo( ScrW() / 2, ScrH() / 2, 1, 0, -1, function() 
					if IsValid( dFrame ) then
						dFrame:Remove()
					end 
					if IsValid( eTablet ) and eTablet:IsWeapon() and IsValid( LocalPlayer():GetActiveWeapon() ) and LocalPlayer():GetActiveWeapon() == eTablet then 
						eTablet:Unfocus() 
					end
				end )
			else
				dFrame:MoveTo( tablet_posx, tablet_posy, 1, 0, -1, function() 
					if IsValid( dFrame ) then
						dFrame:Remove()
					end 
					if IsValid( eTablet ) and eTablet:IsWeapon() and IsValid( LocalPlayer():GetActiveWeapon() ) and LocalPlayer():GetActiveWeapon() == eTablet then 
						eTablet:Unfocus()
					end
				end )
			end
		end
	end

	local dTabletContent = vgui.Create( "DPanel", dFrame )
	if topleft then
		dTabletContent:SetPos( 0, 0 )
		dTabletContent:SetSize( tablet_sizex, tablet_sizey )
	else
		dTabletContent:SetPos( 77 / 2, 78 / 2 )
		dTabletContent:SetSize( tablet_sizex - 77, tablet_sizey - 78 )
	end
	dTabletContent:SetBackgroundColor( AdvCarDealer.UIColors.background_tablet )

	--[[
		LEFT MENU
	]]

	local dLeftMenu = vgui.Create( "KVS.Panel", dTabletContent )
	dLeftMenu:Dock( LEFT )
	dLeftMenu:SetWide( 150 )

	local dSearchBar = vgui.Create( "KVS.Input", dLeftMenu )
	dSearchBar:Dock( TOP )
	dSearchBar:DockMargin( 5, 5, 5, 10 )
	dSearchBar:SetTall( 30 )
	dSearchBar:SetPlaceholderText( sentences[ 2 ] .. "..." )
	function dSearchBar:OnValueChange()
		dCenterMenu:LoadResearch()
	end

	local dLeftCategories = vgui.Create( "KVS.ScrollPanel", dLeftMenu )
	dLeftCategories:Dock( FILL )
	dLeftCategories:DockMargin( 0, 5, 0, 5 )

	local dCategoryAll = vgui.Create( "DButton", dLeftCategories )
	dCategoryAll:Dock( TOP )
	dCategoryAll:DockMargin( 0, 0, 0, 5 )
	dCategoryAll:SetText( "" )
	dCategoryAll:SetTall( 35 )
	function dCategoryAll:Paint( w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.left_menu_hovergrey )
		end

		if table.IsEmpty( selected_categories ) then
			draw.SimpleText( utf8.char( 0xf00c ), font( "FAS", 18, "extended" ), 5, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

		draw.RoundedBox( 0, 0, 0, w, 1, AdvCarDealer.UIColors.bar_separation )
		draw.SimpleText( sentences[ 3 ], font( "Montserrat", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.RoundedBox( 0, 0, h - 1, w, 1, AdvCarDealer.UIColors.bar_separation )
	end

	function dCategoryAll:DoClick()
		selected_categories = {}
		dCenterMenu:LoadResearch()
	end

	for BrandName, Vehicles in pairs( CFG().Vehicles or {} ) do
		local dCategory = vgui.Create( "DButton", dLeftCategories )
		dCategory:Dock( TOP )
		dCategory:SetText( "" )
		dCategory:SetTall( 35 )
		dCategory:DockMargin( 0, 0, 0, 5 )
		function dCategory:Paint( w, h )
			if self:IsHovered() then
				draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.left_menu_hovergrey )
			end

			if table.HasValue( selected_categories, BrandName ) then
				draw.SimpleText( utf8.char( 0xf00c ), font( "FAS", 18, "extended" ), 5, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end

			draw.RoundedBox( 0, 0, 0, w, 1, AdvCarDealer.UIColors.bar_separation )
			draw.SimpleText( BrandName, font( "Montserrat", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.RoundedBox( 0, 0, h - 1, w, 1, AdvCarDealer.UIColors.bar_separation )
		end

		function dCategory:DoClick()
			if table.HasValue( selected_categories, BrandName ) then
				table.RemoveByValue( selected_categories, BrandName )
			else
				table.insert( selected_categories, BrandName )
			end

			dCenterMenu:LoadResearch()
		end
	end

	local dLeaveButton = vgui.Create( "DButton", dLeftMenu )
	dLeaveButton:Dock( BOTTOM )
	dLeaveButton:SetText( "" )
	dLeaveButton:SetTall( 30 )
	function dLeaveButton:Paint( w, h )
		if self:IsHovered() then
			draw.SimpleText( utf8.char( 0xf2f5 ), font( "FAS", 18, "extended" ), 10, h / 2, AdvCarDealer.UIColors.text_red, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( sentences[ 1 ], font( "Montserrat Bold", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( utf8.char( 0xf2f5 ), font( "FAS", 18, "extended" ), 10, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( sentences[ 1 ], font( "Montserrat Bold", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	function dLeaveButton:DoClick()
		dFrame:Close()
	end

	--[[
		CENTER MENU
	]]

	dCenterMenu = vgui.Create( "DPanel", dTabletContent )
	dCenterMenu:Dock( FILL )
	function dCenterMenu:Paint( w, h ) 
		draw.SimpleText( sentences[ 4 ], font( "Montserrat", 20 ), 10, 10, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		if AdvCarDealer:IsCarDealer( LocalPlayer() ) then
			draw.SimpleText( sentences[ 14 ] .. ": " .. DarkRP.formatMoney( math.Round( GetGlobalFloat( "car_dealer_wallet" ) ) ), font( "Montserrat", 15 ), w - 5, 10, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( sentences[ 15 ], font( "Montserrat", 15 ), 10, 35, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else
			draw.SimpleText( sentences[ 5 ] .. ": " .. DarkRP.formatMoney( math.Round( LocalPlayer():getDarkRPVar( "money" ) ) ), font( "Montserrat", 15 ), w - 5, 10, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		end
	end

	function dCenterMenu:Clear()
		for _, ui in pairs ( dCenterMenu:GetChildren() ) do
			ui:AlphaTo( 0, 0.3, 0, function() if IsValid( ui ) then ui:Remove() end end )
		end
	end

	function dCenterMenu:MoreInfos( vehclass, vehinfos )
		dCenterMenu:Clear()

		local dVehicleBox = vgui.Create( "KVS.ScrollPanel", dCenterMenu )
		dVehicleBox:SetTall( dTabletContent:GetTall() - 60 )
		dVehicleBox:Dock( BOTTOM )
		dVehicleBox:DockMargin( 10, 0, 10, 10 )
		dVehicleBox:SetAlpha( 0 )
		dVehicleBox:AlphaTo( 255, 0.3, 0.3 )

		local dDetailsHeader = vgui.Create( "KVS.Panel", dVehicleBox )
		dDetailsHeader:Dock( TOP )
		dDetailsHeader:SetTall( 250 )

		local dDetailsModel = vgui.Create( "DModelPanel", dDetailsHeader )
		dDetailsModel:Dock( LEFT )
		dDetailsModel:SetWide( 250 )
		dDetailsModel:SetModel( vehinfos.model )

		local mn, mx = dDetailsModel.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		dDetailsModel.LerpPos = 0

		function dDetailsModel:LayoutEntity(ent)
			if self:IsDown() then
				local xCursPos, yCursPos = self:CursorPos()
				if not self.xAng then self.xAng = xCursPos end

				self.LerpPos = Lerp(RealFrameTime()*4, self.LerpPos, xCursPos - 180)
				ent:SetAngles(Angle(0, self.LerpPos, 0))
			else
				self.xAng = nil
			end
		end

		dDetailsModel:SetFOV( 45 )
		dDetailsModel:SetCamPos( Vector( size, size, size ) )
		dDetailsModel:SetLookAt( ( mn + mx ) * 0.5 )

		local dDetailsHeaderRight = vgui.Create( "KVS.Panel", dDetailsHeader )
		dDetailsHeaderRight:Dock( FILL )
		function dDetailsHeaderRight:Paint( w, h )
			draw.SimpleText( vehinfos.name, "CarDealer.Rajdhani25", w / 2, 20, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( sentences[ 7 ] .. " : " .. DarkRP.formatMoney( vehinfos.priceCatalog ), font( "Montserrat", 15 ), w / 2, 50, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			
			local speed, speed_text = speed_f( vehinfos.maxspeed )
			draw.SimpleText( sentences[ 25 ] .. " : " .. ( speed_text or 0 ), font( "Montserrat Bold", 20 ), 5, 80, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( sentences[ 26 ] .. " : " .. ( vehinfos.maxrpm or 0 ), font( "Montserrat Bold", 20 ), 5, 105, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( sentences[ 27 ] .. " : " .. ( vehinfos.horsepower or 0 ), font( "Montserrat Bold", 20 ), 5, 130, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		if vehinfos.customCheck and AdvCarDealer.CustomChecks[ vehinfos.customCheck ] and AdvCarDealer.CustomChecks[ vehinfos.customCheck ].messageCatalog then
			local dCustomCheckMessage = vgui.Create( "DLabel", dDetailsHeaderRight )
			dCustomCheckMessage:Dock( FILL )
			dCustomCheckMessage:DockMargin( 5, 5, 5, 5 )
			dCustomCheckMessage:SetText( AdvCarDealer.CustomChecks[ vehinfos.customCheck ].messageCatalog )
			dCustomCheckMessage:SetTextColor( AdvCarDealer.UIColors.text_red )
			dCustomCheckMessage:SetFont( font( "Montserrat Bold", 15 ) )
			dCustomCheckMessage:SetContentAlignment( 2 )
		end

		local dDetailsHeadererBuy = vgui.Create( "KVS.Button", dDetailsHeaderRight )
		dDetailsHeadererBuy:Dock( BOTTOM )
		dDetailsHeadererBuy:DockMargin( 40, 0, 40, 15 )
		dDetailsHeadererBuy:SetTall( 30 )
		dDetailsHeadererBuy:SetFont( font( "Montserrat Bold", 15 ) )

		local price = vehinfos.priceCatalog
		if dDetailsModel.UnderglowColor then
			price = price + CFG().PriceUnderglow
		end

		if AdvCarDealer:IsCarDealer( LocalPlayer() ) then
			dDetailsHeadererBuy:SetText( sentences[ 13 ] .. " (" .. DarkRP.formatMoney( price ) .. ")" )
		else
			dDetailsHeadererBuy:SetText( sentences[ 10 ] .. " (" .. DarkRP.formatMoney( price ) .. ")" )
		end
		
		if AdvCarDealer:PlayersInCarDealerJob() and not AdvCarDealer:IsCarDealer( LocalPlayer() ) then
			dDetailsHeadererBuy:SetDisabled( true )
			dDetailsHeadererBuy:SetText( sentences[ 23 ] )
		end
		function dDetailsHeadererBuy:DoClick()
			if not AdvCarDealer:PlayersInCarDealerJob() or AdvCarDealer:IsCarDealer( LocalPlayer() ) then
				dFrame:Close()

				local bdgr = {}

				for k, v in pairs( dDetailsModel.Entity:GetBodyGroups() ) do
					bdgr[ v.id ] = dDetailsModel.Entity:GetBodygroup( v.id )
				end
				
				if dDetailsModel.UnderglowColor then dDetailsModel.UnderglowColor = string.FromColor( dDetailsModel.UnderglowColor ) end

				local vehiclesinfos = {
					className = vehclass,
					model = vehinfos.model,
					color = string.FromColor( dDetailsModel:GetColor() ),
					underglow = dDetailsModel.UnderglowColor,
					skin = dDetailsModel.Entity:GetSkin(),
					bodygroup = bdgr
				}

				net.Start( "AdvCarDealer.BuyCarInTablet" )
					net.WriteEntity( eTablet )
					net.WriteTable( vehiclesinfos )
				net.SendToServer()
			end
		end

		local dDetailsBottom
		if vehinfos.color or vehinfos.underglow then
			dDetailsBottom = vgui.Create( "KVS.Panel", dVehicleBox )
			dDetailsBottom:Dock( TOP )
			dDetailsBottom:SetTall( 125 )
		end

		if vehinfos.color then
			local dDetailsVehicleColor = vgui.Create( "DPanel", dDetailsBottom )
			dDetailsVehicleColor:Dock( LEFT )
			dDetailsVehicleColor:SetWide( 250 )
			function dDetailsVehicleColor:Paint( w, h )
			end

			local dDetailsColorTitle = vgui.Create( "DLabel", dDetailsVehicleColor )
			dDetailsColorTitle:Dock( TOP )
			dDetailsColorTitle:DockMargin( 10, 10, 5, 0 )
			dDetailsColorTitle:SetText( sentences[ 8 ] .. ":" )
			dDetailsColorTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
			dDetailsColorTitle:SetFont( "CarDealer.Rajdhani18" )
			dDetailsColorTitle:SetContentAlignment( 7 )

			local dDetailsColorList = vgui.Create( "DIconLayout", dDetailsVehicleColor )
			dDetailsColorList:Dock( TOP )
			dDetailsColorList:DockMargin( 10, 0, 10, 0 )
			dDetailsColorList:SetSpaceX( 5 )
			dDetailsColorList:SetSpaceY( 5 )

			for _, color in pairs( CFG().VehicleColorsInCatalog ) do
				color = string.ToColor( color )
				local dColorButton = dDetailsColorList:Add( "DButton" )
				dColorButton:SetSize( 25, 25 )
				dColorButton:SetText( "" )
				function dColorButton:Paint( w, h )
					if dDetailsModel:GetColor() == color then
						draw.RoundedBox( 5, 0, 0, w, h, color )
					else
						draw.RoundedBox( 5, 2.5, 2.5, 20, 20, color )
					end
				end

				function dColorButton:DoClick()
					dDetailsModel:SetColor( color )
				end
			end

			if AdvCarDealer:IsCarDealer( LocalPlayer() ) then
				local dDetailsColorInput = vgui.Create( "KVS.InputColor", dDetailsVehicleColor )
				dDetailsColorInput:Dock( BOTTOM )
				dDetailsColorInput:DockMargin( 10, 0, 10, 10 )
				dDetailsColorInput:SetTall( 25 )
				dDetailsColorInput:SetColor( dDetailsModel:GetColor() )
				function dDetailsColorInput:OnValueChanged( color )
					dDetailsModel:SetColor( color )
				end
			end
		end

		if vehinfos.underglow then
			local dDetailsUnderglowPanel = vgui.Create( "DPanel", dDetailsBottom )
			dDetailsUnderglowPanel:Dock( FILL )
			dDetailsUnderglowPanel:SetWide( 200 )
			function dDetailsUnderglowPanel:Paint( w, h )
			end

			local dDetailsUnderglowTitle = vgui.Create( "DLabel", dDetailsUnderglowPanel )
			dDetailsUnderglowTitle:Dock( TOP )
			dDetailsUnderglowTitle:DockMargin( 10, 10, 5, 0 )
			dDetailsUnderglowTitle:SetText( sentences[ 9 ] .. " (+" .. DarkRP.formatMoney( CFG().PriceUnderglow ) .. ") :" )
			dDetailsUnderglowTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
			dDetailsUnderglowTitle:SetFont( "CarDealer.Rajdhani18" )
			dDetailsUnderglowTitle:SetContentAlignment( 7 )

			local dDetailsUnderglowList = vgui.Create( "DIconLayout", dDetailsUnderglowPanel )
			dDetailsUnderglowList:Dock( TOP )
			dDetailsUnderglowList:DockMargin( 10, 0, 10, 0 )
			dDetailsUnderglowList:SetSpaceX( 5 )
			dDetailsUnderglowList:SetSpaceY( 5 )

			local dUnderglowNoColor = dDetailsUnderglowList:Add( "DButton" )
			dUnderglowNoColor:SetSize( 25, 25 )
			dUnderglowNoColor:SetText( "" )
			function dUnderglowNoColor:Paint( w, h )
				if not dDetailsModel.UnderglowColor then
					draw.SimpleText( utf8.char( 0xf057 ), "CarDealer.FAS25", w / 2, h / 2, AdvCarDealer.UIColors.text_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( utf8.char( 0xf057 ), font( "FAS", 18, "extended" ), w / 2, h / 2, AdvCarDealer.UIColors.text_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end

			function dUnderglowNoColor:DoClick()
				dDetailsModel.UnderglowColor = nil
			end

			for _, color in pairs( CFG().UnderglowColorsInCatalog ) do
				color = string.ToColor( color )

				local dColorButton = dDetailsUnderglowList:Add( "DButton" )
				dColorButton:SetSize( 25, 25 )
				dColorButton:SetText( "" )
				function dColorButton:Paint( w, h )
					if dDetailsModel.UnderglowColor == color then
						draw.RoundedBox( 5, 0, 0, w, h, color )
					else
						draw.RoundedBox( 5, 2.5, 2.5, 20, 20, color )
					end
				end

				function dColorButton:DoClick()
					dDetailsModel.UnderglowColor = color
				end
			end

			if AdvCarDealer:IsCarDealer( LocalPlayer() ) then
				local dDetailsUnderglowInput = vgui.Create( "KVS.InputColor", dDetailsUnderglowPanel )
				dDetailsUnderglowInput:Dock( BOTTOM )
				dDetailsUnderglowInput:DockMargin( 10, 0, 10, 10 )
				dDetailsUnderglowInput:SetTall( 25 )
				dDetailsUnderglowInput:SetColor( dDetailsModel.UnderglowColor or Color( 255, 255, 255, 255 ) )
				function dDetailsUnderglowInput:OnValueChanged( color )
					dDetailsModel.UnderglowColor = color
				end
			end
		end

		local dDetailsBack = vgui.Create( "DButton", dVehicleBox )
		dDetailsBack:SetPos( 0, 0 )
		dDetailsBack:SetText( "" )
		dDetailsBack:SetTall( 30 )
		function dDetailsBack:Paint( w, h )
			if self:IsHovered() then
				draw.SimpleText( "< " .. sentences[ 16 ], font( "Montserrat Bold", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "< " .. sentences[ 16 ], font( "Montserrat Bold", 15 ), w / 2, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end

		function dDetailsBack:DoClick()
			dCenterMenu:LoadResearch()
		end

		if not AdvCarDealer:IsCarDealer( LocalPlayer() ) or (not vehinfos.skins and not vehinfos.bodygroups) then return end

		local dDetailsSkins = vgui.Create( "KVS.ScrollPanel", dVehicleBox )
		dDetailsSkins:Dock( TOP )
		dDetailsSkins:SetTall( 165 )
		
		local dFootPanel = vgui.Create( "KVS.Panel", dDetailsSkins )
		dFootPanel:Dock( BOTTOM )
		dFootPanel:SetTall( 20 )

		if vehinfos.skins then
			local dDetailsSkinsTitle = vgui.Create( "DLabel", dDetailsSkins )
			dDetailsSkinsTitle:Dock( TOP )
			dDetailsSkinsTitle:DockMargin( 10, 10, 5, 0 )
			dDetailsSkinsTitle:SetText( sentences[ 11 ] .. ":" )
			dDetailsSkinsTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
			dDetailsSkinsTitle:SetFont( "CarDealer.Rajdhani18" )
			dDetailsSkinsTitle:SetContentAlignment( 7 )

			local dDetailsSkinsChoose = vgui.Create( "KVS.ComboBox", dDetailsSkins )
			dDetailsSkinsChoose:Dock( TOP )
			dDetailsSkinsChoose:DockMargin( 10, 0, 5, 0 )
			dDetailsSkinsChoose:SetTall( 20 )
			dDetailsSkinsChoose:SetValue( dDetailsModel.Entity:GetSkin() )
			for i=0, dDetailsModel.Entity:SkinCount() do
				dDetailsSkinsChoose:AddChoice( i )
			end
			dDetailsSkinsChoose.OnSelect = function( self, index, value )
				dDetailsModel.Entity:SetSkin( value )
			end
		end

		if vehinfos.bodygroups then
			local dDetailsBodygroupTitle = vgui.Create( "DLabel", dDetailsSkins )
			dDetailsBodygroupTitle:Dock( TOP )
			dDetailsBodygroupTitle:DockMargin( 10, 10, 5, 0 )
			dDetailsBodygroupTitle:SetText( sentences[ 12 ] .. ":" )
			dDetailsBodygroupTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
			dDetailsBodygroupTitle:SetFont( "CarDealer.Rajdhani18" )
			dDetailsBodygroupTitle:SetContentAlignment( 7 )

			local dDetailsBodygroupLayout = vgui.Create( "DIconLayout", dDetailsSkins )
			dDetailsBodygroupLayout:Dock( FILL )
			dDetailsBodygroupLayout:DockMargin( 10, 0, 10, 10 )
			dDetailsBodygroupLayout:SetSpaceX( 5 )
			dDetailsBodygroupLayout:SetSpaceY( 5 )

			for _, infos in pairs( dDetailsModel.Entity:GetBodyGroups() ) do
				-- Display it only if ther is a choice to do.
				if not infos.submodels or #infos.submodels <= 1 then continue end

				local dDetailsBodygroupPanel = dDetailsBodygroupLayout:Add( "KVS.Panel" )
				dDetailsBodygroupPanel:SetSize( 160, 45 )

				local dDetailsBodygroupName = vgui.Create( "DLabel", dDetailsBodygroupPanel )
				dDetailsBodygroupName:Dock( TOP )
				dDetailsBodygroupName:DockMargin( 0, 2.5, 0, 0 )
				dDetailsBodygroupName:SetText( infos.name )
				dDetailsBodygroupName:SetTextColor( AdvCarDealer.UIColors.text_grey )
				dDetailsBodygroupName:SetFont( font( "Montserrat", 15 ) )
				dDetailsBodygroupName:SetContentAlignment( 8 )

				local dDetailsBodygroupChoose = vgui.Create( "KVS.ComboBox", dDetailsBodygroupPanel )
				dDetailsBodygroupChoose:Dock( BOTTOM )
				dDetailsBodygroupChoose:DockMargin( 0, 0, 0, 0 )
				dDetailsBodygroupChoose:SetTall( 25 )
				dDetailsBodygroupChoose:SetValue( string.Replace( infos.submodels[ dDetailsModel.Entity:GetBodygroup( infos.id ) ] or "", ".smd", "" ) )
				for k, name in pairs( infos.submodels ) do
					dDetailsBodygroupChoose:AddChoice( string.Replace( name, ".smd", "" ), { id = k } )
				end
				dDetailsBodygroupChoose.OnSelect = function( self, index, value, data )
					dDetailsModel.Entity:SetBodygroup( infos.id, data.id )
				end
			end

		end
	end

	function dCenterMenu:LoadResearch()
		dCenterMenu:Clear()

		local tSelectedVehiclesList = GetVehiclesWithParameters( selected_categories, dSearchBar:GetValue() )

		print( #tSelectedVehiclesList )

		local dCenterList = vgui.Create( "KVS.ScrollPanel", dCenterMenu )
		dCenterList:Dock( BOTTOM )
		dCenterList:SetTall( dTabletContent:GetTall() - 50 )

		local num = 0
		local line = -1
		local rep = table.Count( tSelectedVehiclesList )

		if rep > 0 then 
			timer.Create( "LoadCarsTablet", 0.2, rep, function()
				if not IsValid( dCenterList ) then return end

				local tVehicleInfos, sVehicleClass = table.Random( tSelectedVehiclesList )

				if not tVehicleInfos or not sVehicleClass then return end

				local vmodel = tVehicleInfos.model

				if not vmodel then return end

				if math.fmod( num, 3 ) == 0 then
					line = line + 1
				end 

				local dVehicleBox = vgui.Create( "KVS.Panel", dCenterList )
				dVehicleBox:SetSize( ( dTabletContent:GetWide() - dLeftMenu:GetWide() - 20 - 20 - 15) / 3, 180 )
				dVehicleBox:SetPos( 10 * ( math.fmod( num, 3 ) + 1 ) + dVehicleBox:GetWide() * math.fmod( num, 3 ),  ( dVehicleBox:GetTall() + 15 ) * line )
				dVehicleBox:SetAlpha( 0 )
				dVehicleBox:AlphaTo( 255, 0.2, 0 )
				function dVehicleBox:Paint( w, h )
					draw.RoundedBox( 3, 0, 0, w, h, config( "vgui.color.black_hard" ) )
				end 
				num = num + 1

				local dSpawnIcon = vgui.Create( "SpawnIcon", dVehicleBox )
				dSpawnIcon:Dock( TOP )
				dSpawnIcon:SetTall( 100 )
				dSpawnIcon:SetModel( vmodel )

				local dVehicleName = vgui.Create( "DLabel", dVehicleBox )
				dVehicleName:Dock( TOP )
				dVehicleName:DockMargin( 0, 10, 0, 0 )
				dVehicleName:SetText( tVehicleInfos.name )
				dVehicleName:SetTextColor( AdvCarDealer.UIColors.text_grey )
				dVehicleName:SetFont( font( "Montserrat", 15 ) )
				dVehicleName:SetContentAlignment( 8 )

				local dVehiclePrice = vgui.Create( "DLabel", dVehicleBox )
				dVehiclePrice:Dock( TOP )
				dVehiclePrice:DockMargin( 0, 5, 0, 0 )
				dVehiclePrice:SetText( DarkRP.formatMoney( tVehicleInfos.priceCatalog ) )
				dVehiclePrice:SetTextColor( AdvCarDealer.UIColors.text_grey )
				dVehiclePrice:SetFont( font( "Montserrat", 15 ) )
				dVehiclePrice:SetContentAlignment( 8 )

				local dVehicleMore = vgui.Create( "KVS.Button", dVehicleBox )
				dVehicleMore:Dock( TOP )
				dVehicleMore:SetTall( 25 )
				dVehicleMore:SetText( sentences[ 6 ] )
				dVehicleMore:DockMargin( 5, 0, 5, 0 )
				dVehicleMore:SetFont( font( "Montserrat Bold", 15 ) )
				function dVehicleMore:DoClick()
					dCenterMenu:MoreInfos( sVehicleClass, tVehicleInfos )
				end

				tSelectedVehiclesList[ sVehicleClass ] = nil
			end )
		end
	end 

	dCenterMenu:LoadResearch()
end

--[[---------------------------------------------------------
	AdvCarDealer.OpenSwitchingMenu( tCarDealers )

	tCarDealers is the list of other car dealers used by the script.
	This UI allow the player to switch his players data from a car dealer to another.
-----------------------------------------------------------]]

function AdvCarDealer.OpenSwitchingMenu( tCarDealers )
	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetDraggable( false )
	dFrame:SetSize( 410, 100 + 70 * #tCarDealers )
	dFrame:Center()
	dFrame:SetTitle( "Advanced Car Dealer" )
	dFrame:SetSubTitle( "Switch from other car dealers" )
	dFrame:MakePopup()

	local dTitle = vgui.Create( "DLabel", dFrame )
	dTitle:Dock( TOP )
	dTitle:DockMargin( 15, 15, 15, 15 )
	dTitle:SetTall( 25 )
	dTitle:SetText( "MOVE TO ADVANCED CAR DEALER" )
	dTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
	dTitle:SetFont( font( "Montserrat", 20 ) )
	dTitle:SetContentAlignment( 5 )

	for _, sName in pairs( tCarDealers ) do 
		local dButtonSwitch = vgui.Create( "KVS.Button", dFrame )
		dButtonSwitch:Dock( TOP )
		dButtonSwitch:DockMargin( 20, 5, 20, 5 )
		dButtonSwitch:SetTall( 30 )
		dButtonSwitch:SetText( sName .. " to ACD" )
		dButtonSwitch:SetFont( font( "Montserrat Bold", 15 ) )
		function dButtonSwitch:DoClick()
			net.Start( "AdvCarDealer.MoveToAcd")
				net.WriteString( sName )
			net.SendToServer()
			
			if IsValid( dFrame ) then
				dFrame:Close()
			end
		end
	end
end

--[[---------------------------------------------------------
	AdvCarDealer.AdminVehiclesMenu()

	Admin menu to create new brands and cars.
-----------------------------------------------------------]]
local function EditVehicle( sBrand, sClass, tInfos )
	if not sClass then return end

	sBrand = sBrand or "New brand"
	tInfos = tInfos or ( CFG().Vehicles and CFG().Vehicles[ sBrand ] and CFG().Vehicles[ sBrand ][ sClass ] ) or {}

	tInfos.name = tInfos.name or "No name"
	tInfos.model = tInfos.model or "models/.mdl"
	tInfos.priceCatalog = tInfos.priceCatalog or 10000
	tInfos.moneyEarned = tInfos.moneyEarned or {
		max	=	1100,
		min	=	900
	}
	tInfos.pricePlayer = tInfos.pricePlayer or {
		max	=	11000,
		min	=	9000
	}

	if type( tInfos.bodygroups ) ~= "boolean" then
		tInfos.bodygroups = true
	end
	if type( tInfos.color ) ~= "boolean" then
		tInfos.color = true
	end
	if type( tInfos.skins ) ~= "boolean" then
		tInfos.skins = true
	end
	if type( tInfos.underglow ) ~= "boolean" then
		tInfos.underglow = true
	end
	if type( tInfos.isInCardealerCatalog ) ~= "boolean" then
		tInfos.isInCardealerCatalog = true
	end
	if type( tInfos.isInCatalog ) ~= "boolean" then
		tInfos.isInCatalog = true
	end

	local sEditedClass = sClass

	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetDraggable( false )
	dFrame:SetSize( ScrW() * 0.4, ScrH() * 0.9 )
	dFrame:Center()
	dFrame:SetTitle( "Advanced Car Dealer" )
	dFrame:SetSubTitle( "Vehicle edition" )
	dFrame:MakePopup()

	local dContainer = vgui.Create( "KVS.ScrollPanel", dFrame )
	dContainer:Dock( FILL )

	local dTitle = vgui.Create( "DLabel", dContainer )
	dTitle:Dock( TOP )
	dTitle:DockMargin( 15, 15, 15, 15 )
	dTitle:SetTall( 25 )
	dTitle:SetText( "EDIT VEHICLE" )
	dTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
	dTitle:SetFont( font( "Montserrat Bold", 20 ) )
	dTitle:SetContentAlignment( 5 )

	--[[--------------------------------------------
		MODEL : Dmodel
	--------------------------------------------]]--
	local dModelPanel = vgui.Create( "DModelPanel", dContainer )
	dModelPanel:Dock( TOP )
	dModelPanel:DockMargin( dFrame:GetWide() / 4, 0, dFrame:GetWide() / 4, 10 ) 
	dModelPanel:SetTall( dFrame:GetWide() / 2 )
	dModelPanel.OldSetModel = dModelPanel.SetModel
	function dModelPanel:SetModel( sModel )
		dModelPanel:OldSetModel( sModel )
		local mn, mx = dModelPanel.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
		dModelPanel.LerpPos = 0
		function dModelPanel:LayoutEntity(ent)
			if self:IsDown() then
				local xCursPos, yCursPos = self:CursorPos()
				if not self.xAng then self.xAng = xCursPos end

				self.LerpPos = Lerp(RealFrameTime()*4, self.LerpPos, xCursPos - 180)
				ent:SetAngles(Angle(0, self.LerpPos, 0))
			else
				self.xAng = nil
			end
		end
		dModelPanel:SetFOV( 45 )
		dModelPanel:SetCamPos( Vector( size, size, size ) )
		dModelPanel:SetLookAt( ( mn + mx ) * 0.5 )
	end
	dModelPanel:SetModel( tInfos.model )
	--[[--------------------------------------------
		NAME : Textentry
	--------------------------------------------]]--
	local dName = vgui.Create( "KVS.Input", dContainer )
	dName:Dock( TOP )
	dName:DockMargin( 20, 0, 20, 10 )
	dName:SetTall( 30 )
	dName:SetText( tInfos.name )
	function dName:OnValueChange()
		tInfos.name = self:GetValue()
	end
	--[[--------------------------------------------
		CLASS : Combobox
	--------------------------------------------]]--
	local dClass = vgui.Create( "KVS.ComboBox", dContainer )
	dClass:Dock( TOP )
	dClass:DockMargin( 20, 0, 20, 10 )
	dClass:SetTall( 30 )
	dClass:SetValue( sClass )
	for sChoiceClass, tData in pairs( list.Get( "Vehicles" ) ) do
		if not tData or not istable( tData ) or not tData.Model or not tData.Name then continue end
		if CFG().Vehicles and CFG().Vehicles[ sBrand ] and CFG().Vehicles[ sBrand ][ sChoiceClass ] then continue end

		dClass:AddChoice( sChoiceClass )
	end
	dClass.OnSelect = function( self, index, value )
		sClass = value
		tInfos.model = list.Get( "Vehicles" )[ sClass ].Model
		if IsValid( dModelPanel ) then dModelPanel:SetModel( tInfos.model ) end
		tInfos.name = list.Get( "Vehicles" )[ sClass ].Name
		if IsValid( dName ) then dName:SetText( tInfos.name ) end
	end
	--[[--------------------------------------------
		CATALOG PRICE : Textentry
	--------------------------------------------]]--
	local dCatalogPricePanel = vgui.Create( "KVS.Panel", dContainer )
	dCatalogPricePanel:Dock( TOP )
	dCatalogPricePanel:DockMargin( 20, 0, 20, 10 )
	dCatalogPricePanel:SetTall( 30 )

	local dCatalogPriceTitle = vgui.Create( "DLabel", dCatalogPricePanel )
	dCatalogPriceTitle:Dock( LEFT )
	dCatalogPriceTitle:DockMargin( 0, 0, 10, 0 )
	dCatalogPriceTitle:SetText( "Price in the tablet catalog :" )
	dCatalogPriceTitle:SetFont( font( "Montserrat", 20 ) )
	dCatalogPriceTitle:SizeToContents()

	local dCatalogPriceInput = vgui.Create( "KVS.Input", dCatalogPricePanel )
	dCatalogPriceInput:Dock( FILL )
	dCatalogPriceInput:SetTall( 30 )
	dCatalogPriceInput:SetText( tInfos.priceCatalog )
	dCatalogPriceInput:SetNumeric( true )
	function dCatalogPriceInput:OnValueChange()
		tInfos.priceCatalog = tonumber( self:GetValue() or "0" )
	end
	
	--[[--------------------------------------------
		PLAYER PRICE : Textentry
	--------------------------------------------]]--
	local dPlayerPricePanel = vgui.Create( "KVS.Panel", dContainer )
	dPlayerPricePanel:Dock( TOP )
	dPlayerPricePanel:DockMargin( 20, 0, 20, 10 )
	dPlayerPricePanel:SetTall( 30 )

	local dPlayerPriceTitle = vgui.Create( "DLabel", dPlayerPricePanel )
	dPlayerPriceTitle:Dock( LEFT )
	dPlayerPriceTitle:DockMargin( 0, 0, 10, 0 )
	dPlayerPriceTitle:SetText( "Price range for the car dealer :" )
	dPlayerPriceTitle:SetFont( font( "Montserrat", 20 ) )
	dPlayerPriceTitle:SizeToContents()

	local dPlayerPriceInputMin = vgui.Create( "KVS.Input", dPlayerPricePanel )
	dPlayerPriceInputMin:Dock( LEFT )
	dPlayerPriceInputMin:SetTall( 30 )
	dPlayerPriceInputMin:SetText( tInfos.pricePlayer.min )
	dPlayerPriceInputMin:SetNumeric( true )
	function dPlayerPriceInputMin:OnValueChange()
		tInfos.pricePlayer.min = tonumber( self:GetValue() or "0" )
	end

	local dPlayerPriceText = vgui.Create( "DLabel", dPlayerPricePanel )
	dPlayerPriceText:Dock( LEFT )
	dPlayerPriceText:DockMargin( 10, 0, 10, 0 )
	dPlayerPriceText:SetText( "to" )
	dPlayerPriceText:SetFont( font( "Montserrat", 20 ) )
	dPlayerPriceText:SizeToContents()

	local dPlayerPriceInputMax = vgui.Create( "KVS.Input", dPlayerPricePanel )
	dPlayerPriceInputMax:Dock( LEFT )
	dPlayerPriceInputMax:SetTall( 30 )
	dPlayerPriceInputMax:SetText( tInfos.pricePlayer.max )
	dPlayerPriceInputMax:SetNumeric( true )
	function dPlayerPriceInputMax:OnValueChange()
		tInfos.pricePlayer.max = tonumber( self:GetValue() or "0" )
	end

	--[[--------------------------------------------
		PLAYER EARNED : Textentry
	--------------------------------------------]]--
	local dPlayerEarnedPanel = vgui.Create( "KVS.Panel", dContainer )
	dPlayerEarnedPanel:Dock( TOP )
	dPlayerEarnedPanel:DockMargin( 20, 0, 20, 10 )
	dPlayerEarnedPanel:SetTall( 30 )

	local dPlayerEarnedTitle = vgui.Create( "DLabel", dPlayerEarnedPanel )
	dPlayerEarnedTitle:Dock( LEFT )
	dPlayerEarnedTitle:DockMargin( 0, 0, 10, 0 )
	dPlayerEarnedTitle:SetText( "Money range earned by car dealer :" )
	dPlayerEarnedTitle:SetFont( font( "Montserrat", 20 ) )
	dPlayerEarnedTitle:SizeToContents()

	local dPlayerEarnedInputMin = vgui.Create( "KVS.Input", dPlayerEarnedPanel )
	dPlayerEarnedInputMin:Dock( LEFT )
	dPlayerEarnedInputMin:SetTall( 30 )
	dPlayerEarnedInputMin:SetText( tInfos.moneyEarned.min )
	dPlayerEarnedInputMin:SetNumeric( true )
	function dPlayerEarnedInputMin:OnValueChange()
		tInfos.moneyEarned.min = tonumber( self:GetValue() or "0" )
	end

	local dPlayerEarnedText = vgui.Create( "DLabel", dPlayerEarnedPanel )
	dPlayerEarnedText:Dock( LEFT )
	dPlayerEarnedText:DockMargin( 10, 0, 10, 0 )
	dPlayerEarnedText:SetText( "to" )
	dPlayerEarnedText:SetFont( font( "Montserrat", 20 ) )
	dPlayerEarnedText:SizeToContents()

	local dPlayerEarnedInputMax = vgui.Create( "KVS.Input", dPlayerEarnedPanel )
	dPlayerEarnedInputMax:Dock( LEFT )
	dPlayerEarnedInputMax:SetTall( 30 )
	dPlayerEarnedInputMax:SetText( tInfos.moneyEarned.max )
	dPlayerEarnedInputMax:SetNumeric( true )
	function dPlayerEarnedInputMax:OnValueChange()
		tInfos.moneyEarned.max = tonumber( self:GetValue() or "0" )
	end

	--[[--------------------------------------------
		CHECKBOX :
		bodygroups
		color
		skins
		underglow
		isInCardealerCatalog
		isInCatalog
	--------------------------------------------]]--
	local tCheckboxes = {
		bodygroups = "Bodygroups can be customized",
		color = "Color can be customized",
		skins = "Skin can be customized",
		underglow = "Underglow can be customized",
		isInCardealerCatalog = "Is in cardealer's catalog",
		isInCatalog = "Is in catalog",
	}

	for sIndex, sDescription in pairs( tCheckboxes ) do 
		local dCheckboxPanel = vgui.Create( "KVS.Panel", dContainer )
		dCheckboxPanel:Dock( TOP )
		dCheckboxPanel:DockMargin( 20, 0, 20, 10 )
		dCheckboxPanel:SetTall( 30 )

		local dCheckboxTitle = vgui.Create( "DLabel", dCheckboxPanel )
		dCheckboxTitle:Dock( LEFT )
		dCheckboxTitle:DockMargin( 0, 0, 10, 0 )
		dCheckboxTitle:SetText( sDescription .. " :" )
		dCheckboxTitle:SetFont( font( "Montserrat", 20 ) )
		dCheckboxTitle:SizeToContents()

		local dCheckboxBox = vgui.Create( "KVS.CheckBox", dCheckboxPanel )
		dCheckboxBox:Dock( LEFT )
		dCheckboxBox:DockMargin( 0, 5, 0, 5 )
		dCheckboxBox:SetWide( 20 )
		dCheckboxBox:SetChecked( tInfos[ sIndex ] )
		function dCheckboxBox:OnChange( bVal )
			tInfos[ sIndex ] = bVal 
		end 
	end 

	--[[--------------------------------------------
		Customcheck : Combobox
	--------------------------------------------]]--
	local dCustomcheck = vgui.Create( "KVS.ComboBox", dContainer )
	dCustomcheck:Dock( TOP )
	dCustomcheck:DockMargin( 20, 0, 20, 10 )
	dCustomcheck:SetTall( 30 )
	dCustomcheck:SetValue( tInfos.customCheck or "No customcheck" )
	dCustomcheck:AddChoice( "No customcheck" )
	for sName, tData in pairs( AdvCarDealer.CustomChecks or {} ) do
		dCustomcheck:AddChoice( sName )
	end
	dCustomcheck.OnSelect = function( self, index, value )
		tInfos.customCheck = value ~= "No customcheck" and value or nil
	end
	

	local dSave = vgui.Create( "KVS.Button", dContainer )
	dSave:Dock( TOP )
	dSave:DockMargin( 20, 5, 20, 5 )
	dSave:SetTall( 30 )
	dSave:SetText( "SAVE" )
	dSave:SetFont( font( "Montserrat Bold", 15 ) )
	function dSave:DoClick()
		dFrame:Remove()

		if sEditedClass ~= sClass then
			timer.Simple( 0, function()
				net.Start( "AdvCarDealer.EditConfig" )
					net.WriteUInt( 7, 8 )
					net.WriteString( sBrand )
					net.WriteString( sEditedClass )
				net.SendToServer()
			end )
		end

		net.Start( "AdvCarDealer.EditConfig" )
			net.WriteUInt( 9, 8 )
			net.WriteString( sBrand )
			net.WriteString( sClass )
			net.WriteTable( tInfos )
		net.SendToServer()

		AdvCarDealer.AdminVehiclesMenu()
	end
end

local function EditBrandName( sBrand )
	if not sBrand or not CFG().Vehicles or not CFG().Vehicles[ sBrand ] then return end

	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetDraggable( false )
	dFrame:SetSize( ScrW() * 0.4, 200 )
	dFrame:Center()
	dFrame:SetTitle( "Advanced Car Dealer" )
	dFrame:SetSubTitle( "Brand name" )
	dFrame:MakePopup()
	function dFrame:Paint(w, h)
		Derma_DrawBackgroundBlur( self, self.startTime )
		draw.RoundedBox(4, 0, 0, w, h, config("vgui.color.black_rhard") )
	end

	local dTitle = vgui.Create( "DLabel", dFrame )
	dTitle:Dock( TOP )
	dTitle:DockMargin( 15, 15, 15, 20 )
	dTitle:SetTall( 25 )
	dTitle:SetText( "CHANGE THE BRAND NAME OF " .. sBrand )
	dTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
	dTitle:SetFont( font( "Montserrat Bold", 20 ) )
	dTitle:SetContentAlignment( 5 )

	local dNewBrand = vgui.Create( "KVS.Input", dFrame )
	dNewBrand:Dock( TOP )
	dNewBrand:DockMargin( 20, 0, 20, 0 )
	dNewBrand:SetTall( 30 )
	dNewBrand:SetText( sBrand )

	local dSave = vgui.Create( "KVS.Button", dFrame )
	dSave:Dock( TOP )
	dSave:DockMargin( 20, 15, 20, 5 )
	dSave:SetTall( 30 )
	dSave:SetText( "CHANGE NAME" )
	dSave:SetFont( font( "Montserrat Bold", 15 ) )
	function dSave:DoClick()
		dFrame:Remove()

		if sBrand == dNewBrand:GetValue() then
			return
		end

		net.Start( "AdvCarDealer.EditConfig" )
			net.WriteUInt( 8, 8 )
			net.WriteString( dNewBrand:GetValue() )
			net.WriteString( sBrand )
		net.SendToServer()
	end
end

function AdvCarDealer.AdminVehiclesMenu()
	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetDraggable( false )
	dFrame:SetSize( ScrW() * 0.4, ScrH() * 0.9 )
	dFrame:Center()
	dFrame:SetTitle( "Advanced Car Dealer" )
	dFrame:SetSubTitle( "Vehicles management" )
	dFrame:MakePopup()

	AdvCarDealer.FrameAdminVehicle = dFrame

	local dContainer = vgui.Create( "KVS.ScrollPanel", dFrame )
	dContainer:Dock( FILL )

	local dTitle = vgui.Create( "DLabel", dContainer )
	dTitle:Dock( TOP )
	dTitle:DockMargin( 15, 15, 15, 15 )
	dTitle:SetTall( 25 )
	dTitle:SetText( "CREATE NEW BRANDS AND ADD VEHICLES" )
	dTitle:SetTextColor( AdvCarDealer.UIColors.text_grey )
	dTitle:SetFont( font( "Montserrat Bold", 20 ) )
	dTitle:SetContentAlignment( 5 )

	for sBrand, tVehicles in pairs( CFG().Vehicles or {} ) do
		local dCollapsibleBrands = vgui.Create( "DCollapsibleCategory", dContainer )
		dCollapsibleBrands:Dock( TOP )
		dCollapsibleBrands:DockMargin( 20, 5, 20, 0 )
		dCollapsibleBrands:SetExpanded( 1 )
		dCollapsibleBrands:SetLabel( sBrand )

		local dListVehicles = vgui.Create( "DListView", dCollapsibleBrands )
		dListVehicles:Dock( FILL )
		dListVehicles:SetMultiSelect( false )
		dListVehicles:AddColumn( "Name" )
		dListVehicles:AddColumn( "Class" )

		for sClass, tInfos in pairs( tVehicles ) do
			dListVehicles:AddLine( tInfos.name, sClass )
		end

		dCollapsibleBrands:SetContents( dListVehicles )

		function dListVehicles:OnRowRightClick( lineID, line )
			local menu = DermaMenu()
			menu:AddOption( "Remove", function() 
				local sClass = dListVehicles:GetLine( lineID ):GetColumnText( 2 )
				dListVehicles:RemoveLine( lineID )

				net.Start( "AdvCarDealer.EditConfig" )
					net.WriteUInt( 7, 8 )
					net.WriteString( sBrand )
					net.WriteString( sClass )
				net.SendToServer()
			end )
			menu:AddOption( "Edit", function() 
				local sClass = dListVehicles:GetLine( lineID ):GetColumnText( 2 )
				EditVehicle( sBrand, sClass )

				dFrame:Remove()
			end )
			menu:Open()
		end

		local dAddVehicle = vgui.Create( "KVS.Button", dContainer )
		dAddVehicle:Dock( TOP )
		dAddVehicle:DockMargin( 20, 0, 20, 0 )
		dAddVehicle:SetTall( 20 )
		dAddVehicle:SetText( "Add vehicle" )
		dAddVehicle:SetColor( config( "vgui.color.accept_green" ) )
		dAddVehicle:SetFont( font( "Montserrat Bold", 15 ) )
		dAddVehicle:SetBorder( false, false, false, false )
		function dAddVehicle:DoClick()
			dFrame:Remove()
			for sClass, tData  in pairs( list.Get( "Vehicles" ) ) do
				if not tData or not istable( tData ) or not tData.Model or not tData.Name or 
					not CFG().Vehicles or not CFG().Vehicles[ sBrand ] or CFG().Vehicles[ sBrand ][ sClass ] then continue end

				EditVehicle( sBrand, sClass, {
					name = tData.Name,
					model = tData.Model
				} )
				break
			end
		end

		local dChangeName = vgui.Create( "KVS.Button", dContainer )
		dChangeName:Dock( TOP )
		dChangeName:DockMargin( 20, 0, 20, 0 )
		dChangeName:SetTall( 20 )
		dChangeName:SetText( "Change brand name" )
		dChangeName:SetColor( config( "vgui.color.warning" ) )
		dChangeName:SetFont( font( "Montserrat Bold", 15 ) )
		dChangeName:SetBorder( false, false, false, false )
		function dChangeName:DoClick()
			EditBrandName( sBrand )
		end

		local dRemoveBrand = vgui.Create( "KVS.Button", dContainer )
		dRemoveBrand:Dock( TOP )
		dRemoveBrand:DockMargin( 20, 0, 20, 5 )
		dRemoveBrand:SetTall( 20 )
		dRemoveBrand:SetText( "Remove brand" )
		dRemoveBrand:SetColor( config( "vgui.color.refuse_red" ) )
		dRemoveBrand:SetFont( font( "Montserrat Bold", 15 ) )
		dRemoveBrand:SetBorder( false, false, true, true )
		function dRemoveBrand:DoClick()
			net.Start( "AdvCarDealer.EditConfig" )
				net.WriteUInt( 6, 8 )
				net.WriteString( sBrand )
			net.SendToServer()
		end
	end

	local dNewBrand = vgui.Create( "KVS.Button", dContainer )
	dNewBrand:Dock( TOP )
	dNewBrand:DockMargin( 20, 5, 20, 5 )
	dNewBrand:SetTall( 30 )
	dNewBrand:SetText( "Create new brand" )
	dNewBrand:SetFont( font( "Montserrat Bold", 15 ) )
	function dNewBrand:DoClick()
		net.Start( "AdvCarDealer.EditConfig" )
			net.WriteUInt( 8, 8 )
			net.WriteString( "Brand #" .. table.Count( CFG().Vehicles or {} ) + 1 )
		net.SendToServer()
	end
end