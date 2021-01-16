if GSmartWatch.Cfg.HideIncompatibilities then
    if not ( ( Slawer and Slawer.Mayor ) or ADVMayor ) then
        return
    end
end

if GSmartWatch.Cfg.DisabledApps[ "app_taxes" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_taxes"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Taxes" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/taxes.png", "smooth" )
GSWApp.ShowTime = true

local matTaxes = Material( "materials/gsmartwatch/taxes_bg.png", "smooth" )

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    local iJobTaxes, iAverageTax = false, false

    if ( Slawer and Slawer.Mayor ) then
        iJobTaxes = ( Slawer.Mayor.JobTaxs[ LocalPlayer():Team() ] or 0 )
        iAverageTax = ( Slawer.Mayor.TaxesAverage or 0 )

    elseif ADVMayor then
        iJobTaxes = ( GetGlobalInt( "MAYOR_EcoTax" ) or 0 )
        iAverageTax = ( GetGlobalInt( "MAYOR_EcoPoints" ) or 0 )
    end

    if not iJobTaxes or not iAverageTax then
        return GSmartWatch:PaintError( dBase.RunningApp, GSmartWatch.Lang[ "No tax data" ]  )
    end

    local fLerp = 0

    local tDraw = {
        [ 1 ] = {
            sInd = string.upper( team.GetName( LocalPlayer():Team() ) ),
            sTax = iJobTaxes .. "%",
            bHigher = ADVMayor and ( iJobTaxes >= 0 ) or ( iJobTaxes > math.floor( iAverageTax ) )
        },
        [ 2 ] = {
            sInd = string.upper( ADVMayor and GSmartWatch.Lang[ "City economy" ] or GSmartWatch.Lang[ "Average tax" ] ),
            sTax = math.floor( iAverageTax or 0 ) .. "%",
            bHigher = ADVMayor and ( iAverageTax >= 0 ) or ( iJobTaxes < math.floor( iAverageTax ) )
        }
    }

    local tRed = Color( 255, 0, 0 )
    local tGreen = Color( 0, 255, 0 )

    for i = 1, 2 do
        tDraw[ i ].tColor = ADVMayor and ( tDraw[ i ].bHigher and tGreen or tRed ) or ( tDraw[ i ].bHigher and tRed or tGreen )
        tDraw[ i ].sSymbol = ( tDraw[ i ].bHigher and "▲" or "▼" )
    end

    function dBase.RunningApp:Paint( iW, iH )
        fLerp = Lerp( RealFrameTime() * 6, fLerp, ( iH * .75  ) )

        GSmartWatch:SetStencil()
        
        surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 0 ] )
        surface.SetMaterial( matTaxes )
        surface.DrawTexturedRectRotated( fLerp, ( iH * .5 ), ( iH * .5 ), ( iH * .5 ), -12 )

        draw.SimpleText( GSmartWatch.Lang.Apps[ "Taxes" ], "GSmartWatch.64", ( iW * .5 ), ( iH * .28 ), color_white, 1, 1 )

        for k, v in pairs( tDraw ) do
            local iY = ( k - 1 ) * ( iH * .25 )
            
            draw.SimpleText( v.sInd, "GSmartWatch.32", ( iW * .5 ), ( iH * .45 ) + iY, GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
            draw.SimpleText( v.sTax, "GSmartWatch.64", ( iW * .5 ), ( iH * .55 ) + iY, color_white, 1, 1 )
            draw.SimpleText( v.sSymbol, "GSmartWatch.32", ( iW * .68 ), ( iH * .54 ) + iY, v.tColor, 1, 1 )
        end

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

    if ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil