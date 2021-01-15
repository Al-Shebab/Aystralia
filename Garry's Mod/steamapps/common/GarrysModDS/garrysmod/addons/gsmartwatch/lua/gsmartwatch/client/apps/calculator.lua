if GSmartWatch.Cfg.DisabledApps[ "app_calculator" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_calculator"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Calculator" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/calculator.png", "smooth" )

local matGradient = Material( "vgui/gradient-d" )
local matGradient2 = Material( "vgui/gradient-u" )

local Calculator = {}

Calculator.iColumns = 4
Calculator.iRows = 5

Calculator.tButtons = {
    [ 1 ] = { sName = "AC", tTextColor = Color( 211, 84, 0 ) },
    [ 2 ] = { sName = "C", tTextColor = Color( 211, 84, 0 ) },
    [ 3 ] = { sName = "%", tTextColor = Color( 211, 84, 0 ) },
    [ 4 ] = { sName = "÷", tTextColor = Color( 211, 84, 0 ) },
    [ 5 ] = { sName = "7" },
    [ 6 ] = { sName = "8" },
    [ 7 ] = { sName = "9" },
    [ 8 ] = { sName = "x", tTextColor = Color( 211, 84, 0 ) },
    [ 9 ] = { sName = "4" },
    [ 10 ] = { sName = "5" },
    [ 11 ] = { sName = "6" },
    [ 12 ] = { sName = "-", tTextColor = Color( 211, 84, 0 ) },
    [ 13 ] = { sName = "1" },
    [ 14 ] = { sName = "2" },
    [ 15 ] = { sName = "3" },
    [ 16 ] = { sName = "+", tTextColor = Color( 211, 84, 0 ) },
    [ 17 ] = { sName = "0" },
    [ 18 ] = { sName = "." },
    [ 19 ] = { sName = "=", tTextColor = color_white, bDouble = true },
}

for k, v in ipairs( Calculator.tButtons ) do
    v.fLerpColor = 0
end

local tNumOrder = {
    [ "0" ] = 17,
    [ "1" ] = 13,
    [ "2" ] = 14,
    [ "3" ] = 15,
    [ "4" ] = 9,
    [ "5" ] = 10,
    [ "6" ] = 11,
    [ "7" ] = 5,
    [ "8" ] = 6,
    [ "9" ] = 7,
    [ "." ] = 18
}

Calculator.tOperators = {
    [ "KP_MINUS" ] = { func = function( dText, iValue )
		Calculator.sOperator = "-"
        if Calculator.iFirstVal then
            if iValue then
                Calculator.iFirstVal = Calculator:Compute( Calculator.sOperator, ( iValue or 0 ) )
            else
                iValue = Calculator.iFirstVal
            end
        else
            Calculator.iFirstVal = ( iValue or 0 )
        end

        dText:SetText( "" )
        Calculator.sValue = nil

        Calculator.tButtons[ 12 ].fLerpColor = 16
    end },
    [ "KP_PLUS" ] = { func = function( dText, iValue )
		Calculator.sOperator = "+"
        if Calculator.iFirstVal then
            if iValue then
                Calculator.iFirstVal = Calculator:Compute( Calculator.sOperator, ( iValue or 0 ) )
            else
                iValue = Calculator.iFirstVal
            end
        else
            Calculator.iFirstVal = ( iValue or 0 )
        end

        dText:SetText( "" )
        Calculator.sValue = nil

        Calculator.tButtons[ 16 ].fLerpColor = 16
    end },
    [ "KP_SLASH" ] = { func = function( dText, iValue )
		Calculator.sOperator = "/"
        if Calculator.iFirstVal then
            if iValue then
                Calculator.iFirstVal = Calculator:Compute( Calculator.sOperator, ( iValue or 0 ) )
            else
                iValue = Calculator.iFirstVal
            end
        else
            Calculator.iFirstVal = ( iValue or 0 )
        end

        dText:SetText( "" )
        Calculator.sValue = nil

        Calculator.tButtons[ 4 ].fLerpColor = 16
    end },
    [ "KP_MULTIPLY" ] = { func = function( dText, iValue )
		Calculator.sOperator = "*"
        if Calculator.iFirstVal then
            if iValue then
                Calculator.iFirstVal = Calculator:Compute( Calculator.sOperator, ( iValue or 0 ) )
            else
                iValue = Calculator.iFirstVal
            end
        else
            Calculator.iFirstVal = ( iValue or 0 )
        end

        dText:SetText( "" )
        Calculator.sValue = nil

        Calculator.tButtons[ 8 ].fLerpColor = 16
    end },
    [ "ENTER" ] = { func = function( dText, iValue )
        if iValue and Calculator.sOperator then
            Calculator.iFirstVal = Calculator:Compute( Calculator.sOperator, ( iValue or 0 ) )

            dText:SetText( "" )

            Calculator.sOperator = nil
            Calculator.sValue = nil
        end

        Calculator.tButtons[ 19 ].fLerpColor = 16
    end },
    [ "DEL" ] = { func = function( dText, iValue )
        dText:SetText( "" )

        Calculator.sOperator = nil
		Calculator.iFirstVal = nil
        Calculator.sValue = nil

        Calculator.tButtons[ 2 ].fLerpColor = 16
    end },
    [ "ESCAPE" ] = { func = function( dText, iValue )
        GSmartWatch:RunApp( "app_myapps" )
    end },
    [ "BACKSPACE" ] = { func = function( dText, iValue )
        Calculator.tButtons[ 1 ].fLerpColor = 16
    end }
}

Calculator.tOperators[ "+" ] = Calculator.tOperators[ "KP_PLUS" ]
Calculator.tOperators[ "=" ] = Calculator.tOperators[ "ENTER" ]
Calculator.tOperators[ "/" ] = Calculator.tOperators[ "KP_SLASH" ]

--[[

    Calculator:Compute

]]--

function Calculator:Compute( xOperator, iValue )
    if ( xOperator == "+" ) then
        return ( Calculator.iFirstVal + iValue )
    elseif ( xOperator == "-" ) then
        return ( Calculator.iFirstVal - iValue )
    elseif ( xOperator == "*" ) then
        return ( Calculator.iFirstVal * iValue )
    elseif ( xOperator == "/" ) then
        return ( Calculator.iFirstVal / iValue )
    end
end

--[[

    Calculator:TextInput

]]--

function Calculator:TextInput( dPanel, iMaxCharacters, fOnClick, fOnChange )
    if not dPanel or not IsValid( dPanel ) then
        return
    end

	local iMaxChar = ( iMaxCharacters or 12 )

	dPanel.dFakeEntry = vgui.Create( "DTextEntry", dPanel )
	dPanel.dFakeEntry:SetSize( ScrW(), ScrH() )
	dPanel.dFakeEntry:SetDrawLanguageID( false )
    dPanel.dFakeEntry:SetNumeric( true )
	dPanel.dFakeEntry:MakePopup()

	function dPanel.dFakeEntry:OnChange()
        local sValue = self:GetValue()
        local iLen = string.len( sValue )

        if ( iLen > iMaxChar ) then
            self:SetText( self.sValidText )
            self:SetValue( self.sValidText )
            self:SetCaretPos( iMaxChar )
        else
            self.sValidText = sValue
        end

        local sLastChar = string.sub( self:GetValue(), string.len( self:GetValue() ) )
        if sLastChar and tNumOrder[ sLastChar ] then
            Calculator.tButtons[ tNumOrder[ sLastChar ] ].fLerpColor = 16
        end
        
        if ( sLastChar == "-" ) then
            self:SetText( string.sub( self:GetValue(), 1, ( iLen - 1 ) ) )
            self:SetValue( string.sub( self:GetValue(), 1, ( iLen - 1 ) ) )
        end

        if fOnChange then
            fOnChange( self:GetText() )
        end
	end

	function dPanel.dFakeEntry:OnFocusChanged( bGained )
		if not bGained then
			self:RequestFocus()
		end
	end

	dPanel.dFakeEntry.Paint = nil

	function dPanel.dFakeEntry:OnMousePressed( iMouse )
		if ( iMouse == MOUSE_LEFT ) then
            if fOnClick and ( self:GetValue() ~= "" ) then
    			fOnClick( self:GetValue() )
            end

            self:Remove()

            GSmartWatch:Play2DSound( "gsmartwatch/ui/keypress_standard.mp3" )
            GSmartWatch:RunApp( "app_myapps" )

			return
		end

		if ( iMouse == MOUSE_RIGHT ) then
            self:Remove()

            GSmartWatch:Play2DSound( "gsmartwatch/ui/keypress_standard.mp3" )
            GSmartWatch:RunApp( "app_myapps" )
		end
	end

    function dPanel.dFakeEntry:OnKeyCode( iKey )
        if ( iKey == GSmartWatch.Cfg.UseKey ) then
            self:Remove()
            return
        end

        if ( iKey == KEY_LEFT ) then
            GSmartWatch.LastUse = CurTime()

            GSmartWatch:Play2DSound( "gsmartwatch/ui/keypress_standard.mp3" )
            GSmartWatch:RunApp( "app_myapps" )
        end

        local tOperator = Calculator.tOperators[ input.GetKeyName( iKey ) ]
        if tOperator then
            if tOperator.func then
                tOperator.func( self, tonumber( self:GetValue() or 0 ) )
            end
        end
    end

	function dPanel.dFakeEntry:OnEnter()
		if fOnClick and ( self:GetValue() ~= "" ) then
			fOnClick( self:GetValue() )
		end

        Calculator.tOperators[ "=" ].func( self, tonumber( self:GetValue() or 0 ) )
	end

	dPanel.dFakeEntry:RequestFocus()

    return dPanel.dFakeEntry
end

--[[

    Calculator:Draw

]]--

function Calculator:Draw( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local iYBorder = ( dBase:GetTall() * .14 )
    local iMargin = 6

    local iValueW = 0
    local iOperatorX = 0

    local dScreen = vgui.Create( "DPanel", dBase )
    dScreen:SetSize( ( dBase:GetWide() * .72 ), ( dBase:GetTall() * .2 ) )
    dScreen:SetPos( ( dBase:GetWide() * .5 ) - ( dScreen:GetWide() * .5 ), iYBorder )
    dScreen.fLerpTextY = - ( dScreen:GetTall() * .9 )

    dBase.iScreenTall = ( dScreen:GetTall() + iYBorder )    

    function dScreen:Paint( iW, iH )
        self.fLerpTextY = Lerp( RealFrameTime() * 6, self.fLerpTextY, 0 )

        if Calculator.sOperator then
            draw.SimpleText( Calculator.sOperator, "GSmartWatch.32", ( iW - 32 ) - iValueW, ( iH + self.fLerpTextY ), GSmartWatch.Cfg.Colors[ 4 ], 2, 4 )
        end

        if Calculator.sValue then
            local sText = string.Comma( Calculator.sValue )
            surface.SetFont( "GSmartWatch.48" )
            iValueW = surface.GetTextSize( sText )

            draw.SimpleText( sText, "GSmartWatch.48", ( iW - 32 ), ( iH + self.fLerpTextY ), color_white, 2, 4 )
        else
            iValueW = 0
        end

        if Calculator.iFirstVal then
            local sText = string.Comma( math.Round( Calculator.iFirstVal, 4 ) )
            if ( string.len( sText ) > 13 ) then
                sText = string.sub( sText, 1, 13 ) .. "..."
            end
            draw.SimpleText( sText, "GSmartWatch.32", ( iW - 32 ), self.fLerpTextY, GSmartWatch.Cfg.Colors[ 4 ], 2, 3 )
        end
    end

    local dButtons = vgui.Create( "DPanel", dBase )
    dButtons:SetSize( ( dScreen:GetWide() * .9 ), ( dBase:GetTall() - dScreen:GetTall() - ( iYBorder * 2 ) ) )
    dButtons:SetPos( ( dBase:GetWide() * .5 ) - ( dButtons:GetWide() * .5 ), iYBorder + dScreen:GetTall() + iMargin )
    dButtons.Paint = nil

    local dLayout = vgui.Create( "DIconLayout", dButtons )
    dLayout:SetSize( dButtons:GetWide(), dButtons:GetTall() )
    dLayout:SetSpaceY( iMargin )
    dLayout:SetSpaceX( dLayout:GetSpaceY() )
    
    dLayout:SetPos( ( dLayout:GetSpaceY() * .5 ), ( dLayout:GetSpaceY() * .5 ) )

    local iRow = 1
    local iColumn = 1

    for k, v in ipairs( Calculator.tButtons ) do
        iColumn = ( iColumn + 1 )
        if iColumn > 4 then
            iColumn = 1
            iRow = ( iRow + 1 )
        end
    
        local dBtn = dLayout:Add( "DButton" )
        dBtn:SetSize( ( ( dButtons:GetWide() * ( v.bDouble and 2 or 1 ) ) / Calculator.iColumns ) - dLayout:GetSpaceX(), ( dButtons:GetTall() / Calculator.iRows )- dLayout:GetSpaceY() )
        dBtn:SetAlpha( 0 )
        dBtn:AlphaTo( 255, .5, ( .1 * iRow ) )
        dBtn:SetText( v.sName )
        dBtn:SetFont( "GSmartWatch.48" )

        dBtn.tColor = ( v.tTextColor or GSmartWatch.Cfg.Colors[ 4 ] )
        dBtn.tPressColor = color_white

        dBtn:SetTextColor( dBtn.tColor )

        function dBtn:Paint( iW, iH )
            v.fLerpColor = Lerp( RealFrameTime() * 4, v.fLerpColor, 0 )

            if v.fLerpColor > 10 then
                self:SetTextColor( self.tPressColor )

                surface.SetDrawColor( ColorAlpha( GSmartWatch.Cfg.Colors[ 4 ], v.fLerpColor ) )
                surface.SetMaterial( matGradient2 )
                surface.DrawTexturedRect( 0, 0, iW, v.fLerpColor * 2 )
            else
                self:SetTextColor( self.tColor )
            end
        end
    end
end

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )
    dBase.RunningApp.iScreenTall = 0

    local fLerpW = 0
    local fLerpH = 0

    function dBase.RunningApp:Paint( iW, iH )
        fLerpW = Lerp( RealFrameTime() * 6, fLerpW, iW )
        GSmartWatch:SetStencil()

        if ( fLerpW > ( iW * .96 ) ) then
            fLerpH = Lerp( RealFrameTime() * 6, fLerpH, self.iScreenTall )
        end

        surface.SetDrawColor( ColorAlpha( GSmartWatch.Cfg.Colors[ 0 ], 200 ) )
        surface.SetMaterial( matGradient )
        surface.DrawTexturedRect( 0, self.iScreenTall - fLerpH, iW, fLerpH )

        draw.RoundedBox( 0, 0, self.iScreenTall - 4, fLerpW, 4, GSmartWatch.Cfg.Colors[ 3 ] )

        render.SetStencilEnable( false )
    end

    Calculator:TextInput( dBase.RunningApp, 9, function( sValue ) end, function( sValue )
        Calculator.sValue = sValue
    end )

    Calculator:Draw( dBase.RunningApp )
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local dParent = dBase.RunningApp

    if ( sBind == "invnext" ) then
    elseif ( sBind == "invprev" ) then
    elseif ( sBind == "+attack" ) then
    elseif ( sBind == "+attack2" ) then
        if dBase.RunningApp and IsValid( dBase.RunningApp ) then
            GSmartWatch:RunApp( "app_myapps" )
        end
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil