if GSmartWatch.Cfg.DisabledApps[ "app_health" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_health"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Health" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/health.png", "smooth" )
GSWApp.ShowTime = true

local matHeart = Material( "materials/gsmartwatch/heart.png", "smooth" )

--[[

    GSmartWatch_HealthTracking

]]--

local iMaxTracking = 20
local iTrackingDelay = 30

local tHealthTracking = {}

timer.Create( "GSmartWatch_HealthTracking", iTrackingDelay, 0, function()
    if LocalPlayer() and IsValid( LocalPlayer() ) and LocalPlayer():Alive() then
        local iHealth = ( LocalPlayer():Health() > 100 ) and 100 or LocalPlayer():Health()

        if ( #tHealthTracking >= iMaxTracking ) then        
            for k, v in ipairs( tHealthTracking ) do
                tHealthTracking[ k - 1 ] = v
            end

            tHealthTracking[ 0 ] = nil
            tHealthTracking[ iMaxTracking ] = iHealth

            return
        end

        table.insert( tHealthTracking, iHealth )
    end
end )

--[[

    drawHealthTracker

]]--

local function drawHealthTracker( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp.fHeartScale = ( dBase:GetTall() * .1 )

    function dBase.RunningApp:Paint( iW, iH )
        self.fHeartScale = Lerp( RealFrameTime() * 10, self.fHeartScale, ( iH * .1 ) )

        surface.SetDrawColor( Color( 255, 0, 0 ) )
        surface.SetMaterial( matHeart )
        surface.DrawTexturedRectRotated( ( iW * .4 ), ( iH * .24 ), self.fHeartScale, self.fHeartScale, 0 )

        draw.SimpleText( LocalPlayer():Health(), "GSmartWatch.64", ( iW * .5 ), ( iH * .25 ), color_white, 0, 1 )

        if ( #tHealthTracking > 0 ) then
            draw.SimpleText( "▼ " .. math.min( unpack( tHealthTracking ) ) .. " ▲ " .. math.max( unpack( tHealthTracking ) ), "GSmartWatch.32", iW * .5, ( iH * .8 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
        end
    end

    local iGraphW, iGraphH = ( dBase.RunningApp:GetWide() * .7 ), ( dBase.RunningApp:GetTall() * .35 )
    local iGraphX, iGraphY = ( dBase.RunningApp:GetWide() * .5 ) - ( iGraphW * .5 ), ( dBase.RunningApp:GetTall() * .52 ) - ( iGraphH * .5 )

    dBase.RunningApp.Graph = vgui.Create( "DPanel", dBase.RunningApp )
    dBase.RunningApp.Graph:SetSize( iGraphW, iGraphH )
    dBase.RunningApp.Graph:SetPos( iGraphX, iGraphY )

    local tGraphPoly = {}
    local tRed = Color( 255, 0, 0 )

    function dBase.RunningApp.Graph:Paint( iW, iH )
        surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 2 ] )
        surface.DrawLine( 0, 2, iW, 2 )

        for i = 1, 4 do
            surface.DrawLine( 0, ( iH * .25 ) * i, iW, ( iH * .25 ) * i )
            draw.SimpleText( 125 - ( 25 * i ), "GSmartWatch.32", iW, ( iH * .25 ) * i + 5, GSmartWatch.Cfg.Colors[ 4 ], 2, 4 )
        end

        for k, v in ipairs( tHealthTracking ) do
            local iOldX, iOldY = ( iW * ( ( k - 1 ) or 0 ) / iMaxTracking ), iH - ( iH * ( tHealthTracking[ k - 1 ] or v ) / 100 )
            local iX, iY = ( iW * k / iMaxTracking ), iH - ( iH * v / 100 )

            surface.SetDrawColor( tRed )
            surface.DrawLine( iOldX,  iOldY, iX, iY )

            local tGraphPoly = {
                { x = iOldX, y = iH },
                { x = iOldX, y = iOldY },
                { x = iX, y = iY },
                { x = iX, y = iH },
            }

        	surface.SetDrawColor( ColorAlpha( tRed, ( k * ( 255 / iMaxTracking ) / ( 255 / iMaxTracking ) ) ) )
	        draw.NoTexture()
    	    surface.DrawPoly( tGraphPoly )
        end        
    end
end

--[[

    drawHealthHUD

]]--

local function drawHealthHUD( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if dBase.RunningApp.Graph then
        dBase.RunningApp.Graph:Remove()
    end

    dBase.RunningApp.fHeartScale = ( dBase:GetTall() * .1 )

    local tInfos = {
        {
            [ 1 ] = GSmartWatch.Lang[ "ARMOR" ],
            [ 2 ] = function()
                return math.floor( LocalPlayer():Armor() or 100 )
            end
        },
    }

    if DarkRP then
        -- Hungermod
        if LocalPlayer():getDarkRPVar( "Energy" ) then
            table.insert( tInfos, {
                [ 1 ] = GSmartWatch.Lang[ "ENERGY" ],
                [ 2 ] = function()
                    return math.floor( LocalPlayer():getDarkRPVar( "Energy" ) or 100 )
                end
            })
        end

        -- Cooking Mod
        if LocalPlayer():getDarkRPVar( "Thirst" ) then
            table.insert( tInfos, {
                [ 1 ] = GSmartWatch.Lang[ "THIRST" ],
                [ 2 ] = function()
                    return math.floor( LocalPlayer():getDarkRPVar( "Thirst" ) or 100 )
                end
            })
        end
    end

    -- Simple Stamina
    if SS and LocalPlayer().GetStamina then
        table.insert( tInfos, {
            [ 1 ] = GSmartWatch.Lang[ "STAMINA" ],
            [ 2 ] = function()
                return math.floor( LocalPlayer():GetStamina() or 100 )
            end
        })
    end
    
    local fLerpLeft, fLerpRight = 0, dBase:GetWide()

    local iInfos = #tInfos
    local iOffset = ( ( iInfos or 0 ) - 1 ) * ( dBase:GetTall() * .05 )

    function dBase.RunningApp:Paint( iW, iH )
        self.fHeartScale = Lerp( RealFrameTime() * 10, self.fHeartScale, ( iH * .1 ) )

        fLerpLeft = Lerp( RealFrameTime() * 6, fLerpLeft, ( iW * .5 ) )
        fLerpRight = Lerp( RealFrameTime() * 6, fLerpRight, ( iW * .5 ) )

        GSmartWatch:SetStencil()

        surface.SetDrawColor( Color( 255, 0, 0 ) )
        surface.SetMaterial( matHeart )
        surface.DrawTexturedRectRotated( ( iW * .25 ), ( iH * .34 ) - iOffset, self.fHeartScale, self.fHeartScale, 0 )

        draw.SimpleText( math.floor( LocalPlayer():Health() ), "GSmartWatch.128", fLerpLeft - 2, ( iH * .5 ) - iOffset, color_white, 2, 1 )
        draw.SimpleText( string.upper( GSmartWatch.Lang[ "HEALTH" ] ), "GSmartWatch.48", fLerpRight + 2, ( iH * .5 ) + 12 - iOffset, Color( 255, 0, 0 ), 0, 4 )

        for k, v in pairs( tInfos ) do
            draw.SimpleText( v[ 2 ](), "GSmartWatch.64", fLerpLeft - 2, ( iH * .55 ) + ( ( iH * .1 ) * k ) - iOffset, GSmartWatch.Cfg.Colors[ 4 ], 2, 1 )
            draw.SimpleText( v[ 1 ], "GSmartWatch.32", fLerpRight + 2, ( iH * .55 ) + ( ( iH * .1 ) * k ) + 14 - iOffset, GSmartWatch.Cfg.Colors[ 4 ], 0, 4 )
        end     

        render.SetStencilEnable( false )
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
    dBase.RunningApp.iSubMenu = 1
    drawHealthHUD( dBase )

    if timer.Exists( "GSmartWatch_HeartBeat" ) then
        timer.Remove( "GSmartWatch_HeartBeat" )
    end

    timer.Create( "GSmartWatch_HeartBeat", math.floor( 120 / LocalPlayer():Health() ), 0, function()
        if dBase and IsValid( dBase ) then
            dBase.RunningApp.fHeartScale = ( dBase:GetTall() * .12 )
        end
    end )    
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if ( sBind == "invnext" ) or ( sBind == "+attack" ) then
        if dBase.RunningApp then
            if ( dBase.RunningApp.iSubMenu or 1 ) == 1 then
                dBase.RunningApp.iSubMenu = 2
                drawHealthTracker( dBase )
            else
                dBase.RunningApp.iSubMenu = 1
                drawHealthHUD( dBase )
            end
        end

    elseif ( sBind == "invprev" ) then
        if dBase.RunningApp then
            if ( dBase.RunningApp.iSubMenu or 1 ) == 1 then
                dBase.RunningApp.iSubMenu = 2
                drawHealthTracker( dBase )
            else
                dBase.RunningApp.iSubMenu = 1
                drawHealthHUD( dBase )
            end
        end

    elseif ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end
end

--[[

    GSWApp.OnShutdown

]]--

function GSWApp.OnShutdown()
    if timer.Exists( "GSmartWatch_HeartBeat" ) then
        timer.Remove( "GSmartWatch_HeartBeat" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil