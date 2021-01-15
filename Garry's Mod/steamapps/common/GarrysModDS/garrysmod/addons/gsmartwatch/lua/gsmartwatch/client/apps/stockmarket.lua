if GSmartWatch.Cfg.HideIncompatibilities and not TBFY_STOCKS then
    return
end

if GSmartWatch.Cfg.DisabledApps[ "app_stockmarket" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_stockmarket"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Stocks" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/stocks.png", "smooth" )
GSWApp.ShowTime = true

local matStocks = Material( "materials/gsmartwatch/stocks_bg.png", "smooth" )
local tStocks = {}

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    if not TBFY_STOCKS then
        return GSmartWatch:PaintError( dBase.RunningApp, GSmartWatch.Lang[ "No stock data" ] )
    end

    local fLerp = 0
    dBase.RunningApp.iSelected = 1

    tStocks = {}

    for k, v in SortedPairs( TBFY_STOCKS ) do
        local tVStock = {
            Index = k,
            AmountChanged = v.AmountChanged,
            PercentChanged = v.PercentChanged,
            Value = GSmartWatch:FormatMoney( v.Value )
        }

        tVStock.tColor = ( ( tVStock.PercentChanged < 0 ) and Color( 255, 0, 0 ) or Color( 0, 255, 0 ) )

        for _, t in pairs( TBFY_STOCKMConfig.Stocks ) do
            if ( t.Stock == k )then
                tVStock.Name = t.Name
            end
        end

        table.insert( tStocks, tVStock )
    end

    function dBase.RunningApp:Paint( iW, iH )
        fLerp = Lerp( RealFrameTime() * 6, fLerp, ( iH * .4  ) )

        GSmartWatch:SetStencil()

        surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 0 ] )
        surface.SetMaterial( matStocks )
        surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .5 ), fLerp, fLerp, 0 )

        draw.SimpleText( tStocks[ self.iSelected ].Index, "GSmartWatch.48", ( iW * .5 ), ( iH * .3 ), color_white, 1, 1 )
        draw.SimpleText( tStocks[ self.iSelected ].Name, "GSmartWatch.96", ( iW * .5 ), ( iH * .46 ), color_white, 1, 1 )
        
        draw.SimpleText( tStocks[ self.iSelected ].PercentChanged .. "%", "GSmartWatch.64", ( iW * .5 ), ( iH * .6 ), tStocks[ self.iSelected ].tColor, 1, 1 )
        draw.SimpleText( ( ( tStocks[ self.iSelected ].PercentChanged < 0 ) and "▼" or "▲" ), "GSmartWatch.32", ( iW * .74 ), ( iH * .59 ), tStocks[ self.iSelected ].tColor, 1, 1 )

        draw.SimpleText( tStocks[ self.iSelected ].Value, "GSmartWatch.48", ( iW * .5 ), ( iH * .75 ), color_white, 1, 1 )

        render.SetStencilEnable( false )
    end
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if ( sBind == "invnext" ) or ( sBind == "+attack" ) then
        if ( #tStocks > 0 ) and dBase.RunningApp then
            dBase.RunningApp.iSelected = ( dBase.RunningApp.iSelected + 1 )

            if ( dBase.RunningApp.iSelected > #tStocks ) then
                dBase.RunningApp.iSelected = 1
            end
        end

    elseif ( sBind == "invprev" ) then
        if ( #tStocks > 0 ) and dBase.RunningApp then
            dBase.RunningApp.iSelected = ( dBase.RunningApp.iSelected - 1 )

            if ( dBase.RunningApp.iSelected < 1 ) then
                dBase.RunningApp.iSelected = #tStocks
            end
        end

    elseif ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil