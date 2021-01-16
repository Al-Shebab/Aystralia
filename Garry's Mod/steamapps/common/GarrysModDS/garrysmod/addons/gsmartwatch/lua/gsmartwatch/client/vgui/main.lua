local GSW_W, GSW_H = 454, 454
local matLoading = Material( "materials/gsmartwatch/loading.png", "smooth" )

--[[

	getSmartWatchBorders

]]--

local function getSmartWatchBorders( iX, iY, iRad, iSeg )
	local tPoly = {}

	table.insert( tPoly, { x = iX, y = iY, u = 0.5, v = 0.5 } )
	for i = 0, iSeg do
		local a = math.rad( ( i / iSeg ) * -360 )
		table.insert( tPoly, { x = iX + math.sin( a ) * iRad, y = iY + math.cos( a ) * iRad, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( tPoly, { x = iX + math.sin( a ) * iRad, y = iY + math.cos( a ) * iRad, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    return tPoly
end

local tBorders = getSmartWatchBorders( ( GSW_W * .5 ), ( GSW_H * .5 ), ( GSW_H * .5 ), 12 )

--[[

	GSmartWatch:SetStencil

]]--

function GSmartWatch:SetStencil()
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.ClearStencil()

	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilFailOperation( STENCIL_REPLACE )

    surface.SetDrawColor( color_black )
	draw.NoTexture()
    surface.DrawPoly( tBorders )

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
end

--[[

    GSmartWatch:DarkenColor

]]--

function GSmartWatch:DarkenColor( tC, i )
    return Color( tC.r * ( i * .01 ), tC.g * ( i * .01 ), tC.b * ( i * .01 ), ( tC.a or 255 ) )
end

--[[

    GSmartWatch:DrawMatShadow

]]--

local tShadowColor = ColorAlpha( color_black, 200 )

function GSmartWatch:DrawMatShadow( mat, iX, iY, iW, iH, tColor, iXOff, iYOff, iRot, tShadow )
    surface.SetMaterial( mat )

    surface.SetDrawColor( ( tShadow or tShadowColor ) )
    surface.DrawTexturedRectRotated( iX + ( iXOff or 0 ), iY + ( iYOff or 4 ), iW, iH, ( iRot or 0 ) )

    surface.SetDrawColor( tColor )
    surface.DrawTexturedRectRotated( iX, iY, iW, iH, ( iRot or 0 ) )
end

--[[

	GSmartWatch:DrawTextShadow

]]--

function GSmartWatch:DrawTextShadow( sText, sFont, iX, iY, tColor, iAlignX, iAlignY, iYOff, tShadow )
    draw.SimpleText( sText, sFont, iX + ( iXOff or 0 ), iY + ( iYOff or 4 ), ( tShadow or tShadowColor ), iAlignX, iAlignY )
    draw.SimpleText( sText, sFont, iX, iY, tColor, ( iAlignX or 1 ), ( iAlignY or 1 ) )
end

--[[

    GSmartWatch:DrawScreen

]]--

function GSmartWatch:DrawScreen( eSWEP )
    eSWEP.BaseUI = vgui.Create( "DPanel" )
    eSWEP.BaseUI:SetSize( GSW_W, GSW_H )
    eSWEP.BaseUI:SetPaintedManually( true )
	eSWEP.BaseUI:SetAlpha( 0 )
	eSWEP.BaseUI:AlphaTo( 255, .5, 0 )

	GSmartWatch:Play2DSound( "gsmartwatch/ui/unlock.mp3" )

	function eSWEP.BaseUI:OnRemove()
		GSmartWatch:Play2DSound( "gsmartwatch/ui/lock.mp3" )
	end

	eSWEP.BaseUI.Paint = nil
	GSmartWatch:RunApp( GSmartWatch.CurrentApp or "app_boot" )
end

--[[

	GSmartWatch:Notify()

]]--

function GSmartWatch:Notify( sNotifText, iDuration, sSoundPath )
	if not LocalPlayer():IsUsingSmartWatch() then
		return 
	end

	local eWeapon = LocalPlayer():GetActiveWeapon()
	if not eWeapon.BaseUI or not IsValid( eWeapon.BaseUI ) then
		return
	end

	if eWeapon.BaseUI.NotifPanel then
		eWeapon.BaseUI.NotifPanel:Remove()
		timer.Remove( "GSmartWatch_NotifTimer" )
	end

	local iDuration = ( iDuration or 2 )

	eWeapon.BaseUI.NotifPanel = vgui.Create( "DLabel", eWeapon.BaseUI )
	local dNotif = eWeapon.BaseUI.NotifPanel

	dNotif:SetFont( "GSmartWatch.32" )
	dNotif:SetText( sNotifText )
	dNotif:SetContentAlignment( 5 )
	dNotif:SetWide( eWeapon.BaseUI:GetWide() * .84 )
	dNotif:SetTextInset( 10, 0 )
	dNotif:SetWrap( true )
	dNotif:SizeToContents()
	dNotif:SetZPos( 100 )
	dNotif:SetAlpha( 0 )
	dNotif:AlphaTo( 255, .2, 0 )
	dNotif:SetPos( ( eWeapon.BaseUI:GetWide() * .5 ) - ( dNotif:GetWide() * .5 ), eWeapon.BaseUI:GetTall() - dNotif:GetTall() )
	dNotif:MoveTo( ( eWeapon.BaseUI:GetWide() * .5 ) - ( dNotif:GetWide() * .5 ), ( eWeapon.BaseUI:GetTall() * .55 ) - ( dNotif:GetTall() * .5 ), .5, 0, .5 )

	local iLoaded = 0
	local iDelay = .05
    local lastOccurance = CurTime()			

	function dNotif:Paint( iW, iH )
    	local timeElapsed = ( CurTime() - lastOccurance )

        if ( timeElapsed > iDelay ) then
        	iLoaded = ( iLoaded + iDelay )
            lastOccurance = CurTime()
        end

		local iWidth = ( iLoaded * ( iW + ( iH * .1 ) ) / iDuration  )
		iWidth = ( ( iWidth > iW ) and iW or iWidth )

		DisableClipping( true )
			draw.RoundedBox( 0, -( iH * .06 ) - 2, -( iH * .06 ) - 2, ( iW + ( iH * .1 ) ) + 4, ( iH + ( iH * .12 ) ) + 4, GSmartWatch.Cfg.Colors[ 3 ] )
			draw.RoundedBox( 0, -( iH * .06 ), -( iH * .06 ), ( iW + ( iH * .1 ) ), ( iH + ( iH * .12 ) ), GSmartWatch.Cfg.Colors[ 0 ] )
			draw.RoundedBox( 0, -( iH * .06 ), iH, iWidth, ( iH * .06 ), GSmartWatch.Cfg.Colors[ 5 ] )
		DisableClipping( false )		
	end

	timer.Create( "GSmartWatch_NotifTimer", iDuration, 1, function()
		if eWeapon and IsValid( eWeapon ) and eWeapon.BaseUI and eWeapon.BaseUI.NotifPanel and IsValid( eWeapon.BaseUI.NotifPanel ) then
			eWeapon.BaseUI.NotifPanel:AlphaTo( 0, .2, 0 )
			eWeapon.BaseUI.NotifPanel:MoveTo( ( eWeapon.BaseUI:GetWide() * .5 ) - ( dNotif:GetWide() * .5 ), eWeapon.BaseUI:GetTall() - dNotif:GetTall(), .25, 0, .5, function()
				if eWeapon.BaseUI.NotifPanel and IsValid( eWeapon.BaseUI.NotifPanel ) then
					eWeapon.BaseUI.NotifPanel:Remove()
					eWeapon.BaseUI.NotifPanel = nil
				end
			end )
		end		
	end )

	if ( sSoundPath == "" ) then
		return
	end

	GSmartWatch:Play2DSound( sSoundPath or "gsmartwatch/ui/notify.mp3" )
end

--[[

	GSmartWatch:PaintError

]]--

function GSmartWatch:PaintError( dPanel, sErrorMessage )
	if not dPanel or not IsValid( dPanel ) then
		return
	end

    function dPanel:Paint( iW, iH )
		surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 0 ] )
		surface.SetMaterial( matLoading )
		surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .5 ), ( iH * .4 ), ( iH * .4 ), ( CurTime() * 180 ) )

		if sErrorMessage then
	        draw.SimpleText( sErrorMessage, "GSmartWatch.48", ( iW * .5 ), ( iH * .5 ), color_white, 1, 1 )
		end
	end
end

--[[

	GSmartWatch:DrawColorScroller

]]--

function GSmartWatch:DrawColorScroller( dBase, tColors, iValue, tBgColor, fCallBack )
    if not dBase or not IsValid( dBase ) then
        return
    end

	if not tColors or not istable( tColors ) then
		return
	end

	local tColors = tColors

    local iSelected = ( iValue or 0 )

    local dPanel = vgui.Create( "DPanel", dBase )
    dPanel:SetSize( dBase:GetWide(), dBase:GetTall() )

	function dPanel:DoClick()
		if fCallBack and self.tCachedColor then
			fCallBack( self.tCachedColor )
		end
	end

	if tBgColor and IsColor( tBgColor ) then
		function dPanel:Paint( iW, iH )
			GSmartWatch:SetStencil()
				draw.RoundedBox( 0, 0, 0, iW, iH, tBgColor )
			render.SetStencilEnable( false )
		end
	else
		dPanel.Paint = nil
	end

	dPanel.tButtons = {}
	dPanel.tCachedColor = false

	function dPanel:SelectNeighbour( bNext )
        iSelected = bNext and ( iSelected + 1 ) or ( iSelected - 1 )

		if not self.tButtons[ iSelected ] then
            iSelected = bNext and 0 or #self.tButtons
        end

        self.dScroll:ScrollToChild( self.tButtons[ iSelected ] )

        if self.tButtons[ iSelected ].tBtnColor then
            self.tCachedColor = self.tButtons[ iSelected ].tBtnColor
        end
	end

    dPanel.dScroll = vgui.Create( "DScrollPanel", dPanel )
    dPanel.dScroll:SetSize( ( dBase:GetWide() * .64 ), ( dBase:GetTall() * .65 ) )
    dPanel.dScroll:SetPos( ( dBase:GetWide() * .18 ), ( dBase:GetTall() * .225 ) )

    local dBar = dPanel.dScroll:GetVBar()
    dBar:SetWidth( 0 )
    dBar:SetVisible( false )

    local iID = -1
    for k, v in SortedPairs( tColors ) do
        iID = ( iID + 1 )

        iSelected = ( iSelected or iID )

        local dButton = dPanel.dScroll:Add( "DButton" )
        dButton:SetSize( dPanel.dScroll:GetWide(), ( dPanel.dScroll:GetTall() * .16 ) )
        dButton:SetText( "" )
        dButton:SetFont( "GSmartWatch.32" )
        dButton:SetTextColor( color_white )
        dButton:SetContentAlignment( 4 )
        dButton:SetTextInset( ( dButton:GetTall() * 1.2 ), 0 )
        dButton:Dock( TOP )
	    dButton:DockMargin( 0, 0, 0, 26 )
        dButton.sKey = k
        dButton.iIndex = iID
        dButton.tBtnColor = v

		if not dPanel.tCachedColor then
		 	dPanel.tCachedColor = v
		end

        dPanel.tButtons[ iID ] = dButton

		local fLerpBoxW = 0
		local fLerpBoxH = 0

        function dButton:Paint( iW, iH )
			local i = self.iIndex

			local bHovered = ( i == iSelected )
			local bNeighbourHovered = ( i == ( iSelected - 1 ) ) or ( i == ( iSelected + 1 ) )

			local iOffset = 0
			local iBoxX = 0
			local iBoxY = iH

			local iBoxW = iH
			local iBoxH = ( iH * .5 )

			if bHovered then
				iBoxW = ( iW * .5 )
				iBoxH = bHovered and iH or ( iH * .5 )
			elseif bNeighbourHovered then
				iBoxW = ( iH * 1.7 )
				iBoxH = ( iH * .6 )
			else
				iBoxW = iH
				iBoxH = ( iH * .5 )
			end

			fLerpBoxW = Lerp( RealFrameTime() * 6, fLerpBoxW, iBoxW )
			fLerpBoxH = Lerp( RealFrameTime() * 6, fLerpBoxH, iBoxH )

			iBoxX = ( iW * .5 ) - ( fLerpBoxW * .5 )
			iBoxY = -( fLerpBoxH * .5 )

            if bHovered then
                draw.RoundedBox( ( iH * .2 ), iBoxX, iBoxY + 0, fLerpBoxW, fLerpBoxH, color_white )
            end

			draw.RoundedBox( ( iH * .2 ) - 3, iBoxX + 3, iBoxY + 3, fLerpBoxW - 6, fLerpBoxH - 6, bHovered and v or GSmartWatch:DarkenColor( v, 50 ) )

			self:SetTextInset( ( dButton:GetTall() * 1.2 ) + ( iOffset * 1.5 ), 0 )	
            self:SetTextColor( bHovered and color_white or GSmartWatch.Cfg.Colors[ 3 ] )
        end
    end

    return dPanel
end

--[[

	GSmartWatch:DrawScroller

]]--

function GSmartWatch:DrawScroller( dBase, tChoices, iValue, sTitle, tColor, iHeight, fCallBack )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local iSelected = ( iValue or 0 )
	local iChoices = table.Count( tChoices )

    local dPanel = vgui.Create( "DPanel", dBase )
    dPanel:SetSize( dBase:GetWide(), dBase:GetTall() )

	if fCallBack and isfunction( fCallBack ) then
		function dPanel:DoClick()
			fCallBack( iSelected )
		end
	end

	local dLineW = ( dPanel:GetWide() * .6 )
	local dBarW = ( dLineW / iChoices )
	local fBarLerpX = 0

	function dPanel:Paint( iW, iH )
		GSmartWatch:SetStencil()

		if tColor then
			draw.RoundedBox( 0, 0, 0, iW, iH, tColor )
		end

		local dBarX = ( iSelected * dLineW / iChoices )
		fBarLerpX = Lerp( RealFrameTime() * 6, fBarLerpX, dBarX )

		if sTitle then
			draw.SimpleText( sTitle, "GSmartWatch.32", ( iW * .5 ), ( iH * .25 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
		end

		draw.RoundedBox( 0, ( iW * .5 ) - ( dLineW * .5 ), ( iH * .62 ), dLineW, 6, GSmartWatch.Cfg.Colors[ 2 ] )
		draw.RoundedBox( 0, ( iW * .5 ) - ( dLineW * .5 ) + fBarLerpX, ( iH * .62 ), dBarW, 6, GSmartWatch.Cfg.Colors[ 5 ] )

		draw.SimpleText( ( iSelected + 1 ) .. "/" .. iChoices, "GSmartWatch.32", ( iW * .5 ), ( iH * .75 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )

		render.SetStencilEnable( false )
	end

	dPanel.tButtons = {}
	dPanel.tCachedChoice = false

	function dPanel:SelectNeighbour( bNext, iNeighbour )
		if iNeighbour then
			iSelected = iNeighbour
		else
			iSelected = bNext and ( iSelected + 1 ) or ( iSelected - 1 )
		end        

		if not self.tButtons[ iSelected ] then
            iSelected = bNext and 0 or #self.tButtons
        end

		if self.tButtons[ iSelected ] and IsValid( self.tButtons[ iSelected ] ) then
	        self.dScroll:ScrollToChild( self.tButtons[ iSelected ] )
		end

        if self.tButtons[ iSelected ] and self.tButtons[ iSelected ].tChoice then
            self.tCachedChoice = self.tButtons[ iSelected ].tChoice
        end
	end

    dPanel.dScroll = vgui.Create( "DScrollPanel", dPanel )
    dPanel.dScroll:SetSize( ( dBase:GetWide() * .64 ), ( dBase:GetTall() * .65 ) )
    dPanel.dScroll:SetPos( ( dBase:GetWide() * .18 ), ( dBase:GetTall() * .175 ) )

    local dBar = dPanel.dScroll:GetVBar()
    dBar:SetWidth( 0 )
    dBar:SetVisible( false )

	local tChoicesNumeric = {}
	local xFirstKey = type( table.GetKeys( tChoices )[ 1 ] or 1 )

	if ( xFirstKey == "string" ) then
		for k, v in SortedPairs( tChoices ) do
			table.insert( tChoicesNumeric, { key = k, value = v } )
		end

	elseif ( xFirstKey == "number" ) then
		for k, v in ipairs( tChoices ) do
			table.insert( tChoicesNumeric, { key = k, value = v } )
		end

	else
		for k, v in pairs( tChoices ) do
			table.insert( tChoicesNumeric, { key = k, value = v } )
		end
	end

    local iID = -1
    for k, v in ipairs( tChoicesNumeric ) do
        iID = ( iID + 1 )

        local dButton = dPanel.dScroll:Add( "DButton" )
        dButton:SetSize( dPanel.dScroll:GetWide(), ( dPanel.dScroll:GetTall() * .16 ) )
        dButton:SetText( v.value.name or "" )
        dButton:SetFont( "GSmartWatch.32" )
        dButton:SetTextColor( color_white )
        dButton:SetContentAlignment( 5 )
        dButton:Dock( TOP )
        dButton.sKey = v.key
        dButton.iIndex = iID
		dButton.tChoice = v.value
		dButton.sDescription = ( v.value and ( v.value.descr or "" ) or "" )
		dButton.fLerpAlpha = 0

		if v.value.data then
			dButton.xData = v.value.data
		end

		if v.value.icon then
			dButton.matBtn = v.value.icon
		end

		if v.value.iconColor then
			dButton.tIconColor = v.value.iconColor
		end

		if not dPanel.tCachedChoice then
		 	dPanel.tCachedChoice = v.value
		end

        dPanel.tButtons[ iID ] = dButton

        function dButton:Paint( iW, iH )
			local bHovered = ( self.iIndex == iSelected )

			self:SetFont( bHovered and "GSmartWatch.48" or "GSmartWatch.32" )
            self:SetTextColor( bHovered and color_white or GSmartWatch.Cfg.Colors[ 0 ] )

			if self.matBtn then
				self.fLerpAlpha = Lerp( RealFrameTime() * 12, self.fLerpAlpha, bHovered and 255 or 0 )

				surface.SetDrawColor( ColorAlpha( ( self.tIconColor or color_white ), self.fLerpAlpha ) )
				surface.SetMaterial( self.matBtn )
				surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .5 ) + ( ( iHeight or 0 ) * .25 ), ( iHeight or iH ), ( iHeight or iH ), 0 )
			end

			if bHovered and self.sDescription then
				draw.SimpleText( self.sDescription, "GSmartWatch.32", ( iW * .5 ), iH + 28, GSmartWatch.Cfg.Colors[ 3 ], 1, 1 )
			end
        end
    end

	dPanel.dScroll:SizeToChildren( false, true )
	dPanel.dScroll:SetPos( ( dBase:GetWide() * .5 ) - ( dPanel.dScroll:GetWide() * .5 ), ( dBase:GetTall() * .4 ) - ( dPanel.dScroll:GetTall() * .5 ) )

	timer.Simple(.1, function()
		if dPanel and dPanel.SelectNeighbour and iSelected then
			dPanel:SelectNeighbour( nil, iSelected )
		end
	end )

    return dPanel
end

--[[

	GSmartWatch:DrawTextEntry

]]--

function GSmartWatch:DrawTextEntry( dBase, iMaxChar, sTitle, tBgColor, fCallBack, fCallBackRMB )
    if not dBase or not IsValid( dBase ) then
        return
    end

	local iMaxChar = ( iMaxChar or 18 )

	if ( iMaxChar > 18 ) then
		iMaxChar = 18
	end

    local dPanel = vgui.Create( "DPanel", dBase )
    dPanel:SetSize( dBase:GetWide(), dBase:GetTall() )
	dPanel.sValue = ""

	local fLerpPlaceholder = 0
	local fLerpW = 0

	function dPanel:Paint( iW, iH )
		local iChars = #self.sValue
		local bFill = ( iChars > 0 )

		GSmartWatch:SetStencil()
	
		if tBgColor then
			draw.RoundedBox( 0, 0, 0, iW, iH, tBgColor )
		end

		if sTitle then
			fLerpPlaceholder = Lerp( RealFrameTime() * 6, fLerpPlaceholder, bFill and ( iH * .12 ) or 0 )

			draw.SimpleText( sTitle, "GSmartWatch.32", ( iW * .1 ), ( iH * .5 ) - fLerpPlaceholder, GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )
		end

		draw.SimpleText( iChars .. "/" .. iMaxChar, "GSmartWatch.32", ( iW * .1 ), ( iH - ( fLerpPlaceholder * 3 ) ), GSmartWatch.Cfg.Colors[ 3 ], 0, 1 )

		if bFill then
			fLerpW = Lerp( RealFrameTime() * 10, fLerpW, ( iW * .8 ) )

			draw.SimpleText( self.sValue, "GSmartWatch.48", ( iW * .1 ), ( iH * .5 ), color_white, 0, 1 )
			draw.RoundedBox( 0, ( iW * .1 ), ( iH * .57 ), fLerpW, 4, GSmartWatch.Cfg.Colors[ 5 ] )
		else
			fLerpW = Lerp( RealFrameTime() * 2, fLerpW, ( iW * .8 ) )

			draw.RoundedBox( 0, ( iW * .1 ), ( iH * .57 ), fLerpW, 4, GSmartWatch:DarkenColor( GSmartWatch.Cfg.Colors[ 5 ], 50 ) )
		end

		render.SetStencilEnable( false )
	end

	dPanel.dFakeEntry = vgui.Create( "DTextEntry", dPanel )
	dPanel.dFakeEntry:SetSize( ScrW(), ScrH() )
	dPanel.dFakeEntry:SetDrawLanguageID( false )
	dPanel.dFakeEntry:MakePopup()

	function dPanel.dFakeEntry:AllowInput( sValue )
		if self.bDisallowInput then
			return true
		end
	end

	function dPanel.dFakeEntry:OnTextChanged( bNoRemoval )
		if ( string.len( self:GetText() ) >= iMaxChar ) then
			self.bDisallowInput = true
			dPanel.sValue = string.sub( self:GetText(), 0, iMaxChar )		
		else
			self.bDisallowInput = nil
			dPanel.sValue = self:GetText()
		end
	end

	function dPanel.dFakeEntry:OnFocusChanged( bGained )
		if not bGained then
			self:RequestFocus()
		end
	end

	dPanel.dFakeEntry.Paint = nil

	function dPanel.dFakeEntry:OnMousePressed( iMouse )
		if ( iMouse == MOUSE_LEFT ) and fCallBack and ( self:GetValue() ~= "" ) then
			fCallBack( dPanel.sValue )
			self:Remove()

			return
		end

		if ( iMouse == MOUSE_RIGHT ) then
			if dPanel and IsValid( dPanel ) then
				if dPanel:GetParent() then
					dPanel:GetParent().dSubMenu = nil
				end

				dPanel:Remove()
			end

			self:Remove()
		end
	end

	function dPanel.dFakeEntry:OnEnter()
		if fCallBack and ( self:GetValue() ~= "" ) then
			self:Remove()
			fCallBack( dPanel.sValue )
		end
	end

	dPanel.dFakeEntry:RequestFocus()

	return dPanel
end

--[[

	GSmartWatch:DrawCheckBox

]]--

function GSmartWatch:DrawCheckBox( dBase, bDefault, sTitle, tColor, fCallBack )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local dPanel = vgui.Create( "DPanel", dBase )
    dPanel:SetSize( dBase:GetWide(), dBase:GetTall() )

	if tColor then
		function dPanel:Paint( iW, iH )
			GSmartWatch:SetStencil()
			draw.RoundedBox( 0, 0, 0, iW, iH, tColor )
			render.SetStencilEnable( false )
		end
	else
		dPanel.Paint = nil
	end

	dPanel.bToggled = ( bDefault or false )

	function dPanel:DoClick()
		self.bToggled = not self.bToggled
		self.dCheck:SetValue( self.bToggled )

		if fCallBack and isfunction( fCallBack ) then
			fCallBack( self.bToggled )
		end
	end

	if sTitle then
		local dTitle = vgui.Create( "DLabel", dPanel )
		dTitle:SetSize( dBase:GetWide(), dBase:GetTall() * .23 )
		dTitle:SetPos( 0, dBase:GetTall() * .3 )
		dTitle:SetText( sTitle )
		dTitle:SetFont( "GSmartWatch.48" )
		dTitle:SetContentAlignment( 5 )
		dTitle:SetTextColor( color_white )
	end

	dPanel.dCheck = vgui.Create( "DCheckBox", dPanel )
	dPanel.dCheck:SetSize( ( dPanel:GetWide() * .24 ), ( dPanel:GetTall() * .08 ) )
	dPanel.dCheck:SetPos( ( dPanel:GetWide() * .5 ) - ( dPanel.dCheck:GetWide() * .5 ), ( dPanel:GetTall() * .6 ) )
	dPanel.dCheck:SetValue( dPanel.bToggled )

	local fLerpX = ( dPanel.dCheck:GetChecked() and ( dPanel.dCheck:GetWide() - dPanel.dCheck:GetTall() ) or 0 )

	function dPanel.dCheck:Paint( iW, iH )
		local bChecked = self:GetChecked()

		fLerpX = Lerp( RealFrameTime() * 10, fLerpX, ( bChecked and ( iW - iH ) or 0 ) )

		draw.RoundedBox( ( iH * .5 ) + 5, - 5, - 5, ( iW + 10 ), ( iH + 10 ), GSmartWatch.Cfg.Colors[ 0 ] )
		draw.RoundedBox( ( iH * .5 ), fLerpX, 0, iH, iH, bChecked and GSmartWatch.Cfg.Colors[ 5 ] or GSmartWatch.Cfg.Colors[ 2 ] )
	end

	return dPanel
end

--[[

	GSmartWatch:DrawNumWang

]]--

function GSmartWatch:DrawNumWang( dBase, iDefault, iMin, iMax, iIncrement, sTitle, tColor, fCallBack, fOnNeighbourSelect )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local dPanel = vgui.Create( "DPanel", dBase )
    dPanel:SetSize( dBase:GetWide(), dBase:GetTall() )

	if tColor then
		function dPanel:Paint( iW, iH )
			GSmartWatch:SetStencil()
			draw.RoundedBox( 0, 0, 0, iW, iH, tColor )
			render.SetStencilEnable( false )
		end
	else
		dPanel.Paint = nil
	end

	function dPanel:DoClick()
		if fCallBack and isfunction( fCallBack ) then
			fCallBack( self.dNum:GetValue() )
		end
	end

	function dPanel:SelectNeighbour( bNext )
		if bNext then
			self.dNum:SetValue( self.dNum:GetValue() - ( iIncrement or 1 ) )
		else
			self.dNum:SetValue( self.dNum:GetValue() + ( iIncrement or 1 ) )
		end

		if fOnNeighbourSelect then
			fOnNeighbourSelect( self.dNum:GetValue(), bNext )
		end
	end

	if sTitle then
		local dTitle = vgui.Create( "DLabel", dPanel )
		dTitle:SetSize( dBase:GetWide(), dBase:GetTall() * .23 )
		dTitle:SetPos( 0, dBase:GetTall() * .3 )
		dTitle:SetText( sTitle )
		dTitle:SetTextColor( color_white )
		dTitle:SetFont( "GSmartWatch.48" )
		dTitle:SetContentAlignment( 5 )
	end

	dPanel.dNum = vgui.Create( "DNumberWang", dPanel )
	dPanel.dNum:SetSize( ( dPanel:GetWide() * .6 ), ( dPanel:GetTall() * .06 ) )
	dPanel.dNum:SetPos( ( dPanel:GetWide() * .5 ) - ( dPanel.dNum:GetWide() * .5 ), ( dPanel:GetTall() * .61 ) )
	dPanel.dNum:SetMinMax( ( iMin or 0 ), ( iMax or 0 ) )
	dPanel.dNum:SetValue( iDefault or false )
	dPanel.dNum:HideWang()

	local fLerp = dPanel.dNum:GetValue()
	dPanel.dNum.sMax = string.Comma( dPanel.dNum:GetMax() )

	function dPanel.dNum:Paint( iW, iH )
		fLerp = Lerp( RealFrameTime() * 6, fLerp, self:GetValue() )

		local iX = ( fLerp * iW / self:GetMax() )
		local iX2 = ( fLerp * ( iW - iH ) / self:GetMax() )

		draw.RoundedBox( 2, 0, 3, iW, 6, GSmartWatch.Cfg.Colors[ 0 ] )
		draw.RoundedBox( 2, 0, 3, iX, 6, GSmartWatch.Cfg.Colors[ 5 ] )
		
		draw.RoundedBox( ( iH * .5 ), iX2, - ( iH * .25 ), iH, iH, color_white )
		draw.SimpleText( string.Comma( math.Round( fLerp ) ) .. "/" .. self.sMax, "GSmartWatch.32", ( iW * .5 ), ( iH * 2.2 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
	end

	return dPanel
end