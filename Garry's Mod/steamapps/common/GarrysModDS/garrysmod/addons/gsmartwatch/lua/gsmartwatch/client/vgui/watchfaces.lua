local tWatchface = {}

local matSMS = Material( "materials/gsmartwatch/sms.png", "smooth" )
local matSMS2 = Material( "materials/gsmartwatch/sms_flat.png", "smooth" )

--[[

    getUnreadSMS

]]--

local function getUnreadSMS()
    local iUnreadSMS = false

    if McPhone then
        iUnreadSMS = 0

        for k, v in pairs( McPhone.SMS ) do
            if v.New then
                iUnreadSMS = ( iUnreadSMS + 1 )
            end
        end
    end

    return iUnreadSMS
end

--[[

    tWatchface.Minimalism

]]--

function tWatchface:Minimalism( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local fLerpH, fLerpM, fLerpD = 0, dBase:GetWide(), dBase:GetTall()

    local iBattery = ( system.BatteryPower() or 100 )
    iBattery = ( ( iBattery > 100 ) and 100 or iBattery )

    local tBatteryColor = ( iBattery > 15 ) and color_white or Color( 255, 0, 0 )

    local function drawBattery( iW, iH )
        surface.SetDrawColor( tBatteryColor )
        surface.DrawRect( ( iW * .45 ), ( iH * .2 ), ( iBattery * ( iH * .1 ) / 100 ), ( iH * .032 ) )

        surface.SetDrawColor( color_white )
        surface.DrawOutlinedRect( ( iW * .45 ) - 6, ( iH * .2 ) - 6, ( iH * .1 ) + 12, ( iH * .032 ) + 12 )        
        surface.DrawRect( ( iW * .55 ) + 6, ( iH * .2 ), ( iH * .012 ), ( iH * .032 ) )
    end

    local iUnreadSMS = getUnreadSMS()
    local sDate = GSmartWatch:GetDate()

    function dBase.RunningApp:Paint( iW, iH )
        local sTime = GSmartWatch:GetTime()
        local tTimeSplit = string.Split( sTime, ":" )

        fLerpH = Lerp( RealFrameTime() * 6, fLerpH, ( iW * .5 ) )
        fLerpM = Lerp( RealFrameTime() * 6, fLerpM, ( iW * .5 ) )
        fLerpD = Lerp( RealFrameTime() * 6, fLerpD, ( iH * .58 ) )

        GSmartWatch:SetStencil()

        if iUnreadSMS and ( iUnreadSMS > 0 ) then
            surface.SetDrawColor( color_white )
            surface.SetMaterial( matSMS2 )
            surface.DrawTexturedRectRotated( ( iW * .5 ), fLerpD + ( iH * .2 ), ( iH * .08 ), ( iH * .08 ), 0 )

            draw.SimpleText( iUnreadSMS, "GSmartWatch.48", ( iW * .52 ) - 4, fLerpD + ( iH * .25 ) - 2, color_black, 0, 1 )
            draw.SimpleText( iUnreadSMS, "GSmartWatch.48", ( iW * .52 ), fLerpD + ( iH * .25 ), GSmartWatch.Cfg.Colors[ 5 ], 0, 1 )
        end

        draw.SimpleText( tTimeSplit[ 1 ], "GSmartWatch.200", fLerpH, ( iH * .5 ), GSmartWatch.Cfg.Colors[ 5 ], 2, 1 )
        draw.SimpleText( tTimeSplit[ 2 ], "GSmartWatch.200", fLerpM, ( iH * .5 ), color_white, 0, 1 )
        draw.SimpleText( sDate, "GSmartWatch.32", ( iW * .5 ), fLerpD, color_white, 2, 0 )

        drawBattery( iW, iH )

        render.SetStencilEnable( false )
    end

    return dBase.RunningApp
end

--[[

    Watch face : Minimalism

]]--

function tWatchface:Minimalism2( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local iBattery = ( system.BatteryPower() or 100 )
    iBattery = ( ( iBattery > 100 ) and 100 or iBattery )

    local tInfos = {
        {
            icon = Material( "materials/gsmartwatch/steps.png", "smooth" ),
            color = Color( 52, 152, 219 ),
            func = function()
                return ( GSmartWatch.Steps or 0 )
            end
        },
        {
            icon = Material( "materials/gsmartwatch/lightning.png", "smooth" ),
            color = Color( 243, 156, 18 ),
            func = function()
                return iBattery .. "%"
            end
        },
        {
            icon = Material( "materials/gsmartwatch/heart.png", "smooth" ),
            color = Color( 255, 0, 0 ),
            func = function()
                return ( ( LocalPlayer():Health() < 100 ) and LocalPlayer():Health() or 100 )
            end
        }, 
    }

    local fLerp = dBase.RunningApp:GetWide()
    local iOffset = ( dBase.RunningApp:GetWide() * .24 )

    local iUnreadSMS = getUnreadSMS()
    local sDate = GSmartWatch:GetDate()

    function dBase.RunningApp:Paint( iW, iH )
        fLerp = Lerp( RealFrameTime() * 6, fLerp, iOffset )

        GSmartWatch:SetStencil()

        if iUnreadSMS and ( iUnreadSMS > 0 ) then
            surface.SetDrawColor( ColorAlpha( color_white, 10 ) )
            surface.SetMaterial( matSMS2 )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .85 ), ( iH * .08 ), ( iH * .08 ), 0 )

            draw.SimpleText( iUnreadSMS, "GSmartWatch.48", ( iW * .52 ), ( iH * .88 ), color_white, 0, 1 )
        end

        for k, v in pairs( tInfos ) do
            local iX = ( iW * .5 ) - ( iOffset * 2 ) + ( fLerp * k )
    
            surface.SetDrawColor( v.color or color_white )
            surface.SetMaterial( v.icon )
            surface.DrawTexturedRectRotated( iX, ( iH * .25 ), ( iH * .08 ), ( iH * .08 ), 0 )

            draw.SimpleText( v.func(), "GSmartWatch.32", iX, ( iH * .35 ), color_white, 1, 1 )
        end

        draw.SimpleText( GSmartWatch:GetTime(), "GSmartWatch.200", ( iW * .5 ), ( iH * .55 ), color_white, 1, 1 )
        draw.SimpleText( sDate, "GSmartWatch.32", ( iW * .5 ), ( iH * .72 ), color_white, 1, 1 )

        render.SetStencilEnable( false )
    end

    return dBase.RunningApp
end

--[[

    tWatchface:Classic

]]--

function tWatchface:Classic( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local tMats = {
        clock = Material( "materials/gsmartwatch/watchfaces/watchface3_01.png", "smooth" ),
        minutes = Material( "materials/gsmartwatch/watchfaces/watchface3_02.png", "smooth" ),
        hours = Material( "materials/gsmartwatch/watchfaces/watchface3_03.png", "smooth" )
    }

    local fLerp = 0
    local fLerpH = -180
    local fLerpM = -180

    local iUnreadSMS = getUnreadSMS()

    function dBase.RunningApp:Paint( iW, iH )
        fLerp = Lerp( RealFrameTime() * 6, fLerp, ( iH * .95 ) )

        local sTime = GSmartWatch:GetTime()
        local tTimeSplit = string.Split( sTime, ":" )

        fLerpH = Lerp( RealFrameTime() * 2, fLerpH, ( tTimeSplit[ 1 ] * 360 / 12 ) )
        fLerpM = Lerp( RealFrameTime() * 2, fLerpM, ( tTimeSplit[ 2 ] * 360 / 60 ) )

        GSmartWatch:SetStencil()

        if iUnreadSMS and ( iUnreadSMS > 0 ) then
            surface.SetDrawColor( ColorAlpha( color_white, 10 ) )
            surface.SetMaterial( matSMS2 )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .7 ), ( fLerp * .08 ), ( fLerp * .08 ), 0 )

            draw.SimpleText( iUnreadSMS, "GSmartWatch.48", ( iW * .52 ), ( iH * .75 ), color_white, 0, 1 )
        end

        for sLayer, v in pairs( tMats ) do
            local iR = 0
            if ( sLayer == "hours" ) then
                iR = fLerpH
            elseif ( sLayer == "minutes" ) then
                iR = fLerpM
            end

            surface.SetDrawColor( color_white )
            surface.SetMaterial( v )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .5 ), fLerp, fLerp, - iR )
        end

        render.SetStencilEnable( false )
    end

    return dBase.RunningApp
end

--[[

    tWatchface:Futuristic

]]--

function tWatchface:Futuristic( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local fLerp = 0
    local tCol = Color( 157, 186, 255 )

    function dBase.RunningApp:FormatTime( iCur, iMax )
        if ( iCur > ( iMax - 1 ) ) then
            iCur = ( iCur - iMax )
        elseif ( iCur < 0 ) then
            iCur = ( iMax + iCur )
        end

        if ( string.len( iCur ) == 1 ) then
            iCur = "0" .. iCur
        end

        return iCur
    end

    local iUnreadSMS = getUnreadSMS()
    local sDate = GSmartWatch:GetDate()

    local fLerpScale = 0
    local fLerpScale2 = 0

    function dBase.RunningApp:Paint( iW, iH )
        local sTime = GSmartWatch:GetTime()
        local tTimeSplit = string.Split( sTime, ":" )

        fLerp = Lerp( RealFrameTime() * 6, fLerp, ( iH * .06 ) )

        GSmartWatch:SetStencil()        

        for i = - 3, 3 do
            local sFont = ( ( i == 0 ) and "GSmartWatch.128" or "GSmartWatch.48" )
            local sColor = ColorAlpha( tCol, 255 - ( 81 * math.abs( i ) ) )

            if ( i < -1 ) or ( i > 1 ) then
                sFont = "GSmartWatch.32" 
            end

            local iOffset = ( ( i < 0 ) and - fLerp ) or ( ( i > 0 ) and fLerp ) or 0

            local iHour = self:FormatTime( tTimeSplit[ 1 ] + i, 24 )
            local iMin = self:FormatTime( tTimeSplit[ 2 ] + i, 60 )

            draw.SimpleText( iHour, sFont, ( iW * .5 ) + ( ( fLerp * 2 ) * i ) + iOffset, ( i == 0 ) and ( iH * .43 ) or ( iH * .45 ), sColor, 1, 1 )
            draw.SimpleText( iMin, sFont, ( iW * .5 ) + ( ( fLerp * 2 ) * i ) + iOffset, ( i == 0 ) and ( iH * .58 ) or ( iH * .55 ), sColor, 1, 1 )
        end

        if iUnreadSMS and ( iUnreadSMS > 0 ) then
            surface.SetDrawColor( color_white )
            surface.SetMaterial( matSMS )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .2 ), ( iH * .1 ), ( iH * .1 ), 0 )

            draw.SimpleText( iUnreadSMS, "GSmartWatch.48", ( iW * .52 ) - 4, ( iH * .25 ) - 2, color_black, 0, 1 )
            draw.SimpleText( iUnreadSMS, "GSmartWatch.48", ( iW * .52 ), ( iH * .25 ), tCol, 0, 1 )
        end

        draw.SimpleText( sDate, "GSmartWatch.48", ( iW * .5 ), ( iH * .75 ), tCol, 1, 1 )

        render.SetStencilEnable( false )
    end

    return dBase.RunningApp
end

--[[

    tWatchface:Ubuntu

]]--

function tWatchface:Ubuntu( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local tBGColor = Color( 44, 0, 30 )
    local tBlue = Color( 34, 183, 235 )
    local tGreen = Color( 98, 173, 23 )

    surface.CreateFont( "GSmartWatch.Ubuntu32", { font = "Tahoma", size = 42, weight = 500, antialias = true } )

    local iBattery = ( system.BatteryPower() or 100 )
    iBattery = ( ( iBattery > 100 ) and 100 or iBattery )

    local sDate = GSmartWatch:GetDate()

    dBase.RunningApp.tt_tText = {}
    dBase.RunningApp.tt_tMax = {}
    dBase.RunningApp.tt_tFuncs = {}
    dBase.RunningApp.tt_tLerp = {}

    function dBase.RunningApp:TypeText( sText, iOrder, iX, iY, tColor, iAlignX, iAlignY, fCallBack )
        self.tt_tText[ iOrder ] = ( self.tt_tText[ iOrder ] or sText )
        self.tt_tMax[ iOrder ] = ( self.tt_tMax[ iOrder ] or string.len( self.tt_tText[ iOrder ] ) )
        
        self.tt_tFuncs[ iOrder ] = ( self.tt_tFuncs[ iOrder ] or ( fCallBack or nil ) )
        self.tt_tLerp[ iOrder ] = Lerp( RealFrameTime() * 4, ( self.tt_tLerp[ iOrder ] or 0 ), self.tt_tMax[ iOrder ] )

        if ( math.Round( self.tt_tLerp[ iOrder ] ) == self.tt_tMax[ iOrder ] ) then
            if self.tt_tFuncs[ iOrder ] then
                self.tt_tFuncs[ iOrder ]()
            end
        end

        local sText = string.sub( self.tt_tText[ iOrder ], 0, math.Round( self.tt_tLerp[ iOrder ] ) )

        draw.SimpleText( sText, "GSmartWatch.Ubuntu32", iX, iY, ( tColor or color_white ), ( iAlignX or 0 ), ( iAlignY or 0 ) )
    end

    function dBase.RunningApp:Paint( iW, iH )
        local iTextX = ( iW * .15 )

        GSmartWatch:SetStencil()

        draw.RoundedBox( 0, 0, 0, iW, iH, tBGColor )

        self:TypeText( "usr@ubuntu", 1, iTextX, ( iH * .25 ), tGreen, 0, 1, function()
        self:TypeText( ":~$ info", 2, ( iW * .58 ), ( iH * .25 ), tBlue, 0, 1, function()

        self:TypeText( "[TIME] " .. GSmartWatch:GetTime(), 3, iTextX, ( iH * .35 ), color_white, 0, 1, function()
        self:TypeText( "[DATE] " .. sDate, 4, iTextX, ( iH * .45 ), color_white, 0, 1, function()
        self:TypeText( "[BATT] " .. iBattery .. "%", 5, iTextX, ( iH * .55 ), color_white, 0, 1, function()
        self:TypeText( "[HEAL] " .. LocalPlayer():Health() .. "BPM", 6, iTextX, ( iH * .65 ), color_white, 0, 1, function()

        self:TypeText( "usr@ubuntu", 7, iTextX, ( iH * .75 ), tGreen, 0, 1, function()
        self:TypeText( ":~$", 8, ( iW * .58 ), ( iH * .75 ), tBlue, 0, 1 ) end) end) end) end) end) end) end)

        render.SetStencilEnable( false )
    end

    return dBase.RunningApp
end

--[[

    GSmartWatch.WatchFaces

]]--

GSmartWatch.WatchFaces = {
    [ 1 ] = { name = "Futuristic", func = function( dBase )
        return tWatchface:Futuristic( dBase )
    end },
    [ 2 ] = { name = "Minimalism", func = function( dBase )
        return tWatchface:Minimalism( dBase )
    end },
    [ 3 ] = { name = "Minimalism 2", func = function( dBase )
        return tWatchface:Minimalism2( dBase )
    end },
    [ 4 ] = { name = "Classic", func = function( dBase )
        return tWatchface:Classic( dBase )
    end },
    [ 5 ] = { name = "Ubuntu", func = function( dBase )
        return tWatchface:Ubuntu( dBase )
    end }
}