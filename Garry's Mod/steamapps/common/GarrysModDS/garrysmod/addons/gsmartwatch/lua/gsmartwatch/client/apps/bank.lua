if GSmartWatch.Cfg.DisabledApps[ "app_bank" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_bank"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Bank" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/banking.png", "smooth" )
GSWApp.ShowTime = true

local matBank = Material( "materials/gsmartwatch/bank.png", "smooth" )
local matGradient = Material( "vgui/gradient-d" )

--[[

    GSWApp:RunApp

]]--

if ARCBank then
    local sARCAccount = false
end

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    local fWallet = GSmartWatch:GetPlayerMoney()
    local fBank = GSmartWatch:GetPlayerMoney( true )

    local sWallet = ( fWallet and GSmartWatch:FormatMoney( fWallet ) or false )
    local sBank = ( fBank and GSmartWatch:FormatMoney( fBank ) or false )

    local tColors = {
        [ 1 ] = Color( 255, 0, 0 ),
        [ 2 ] = Color( 255, 0, 0 )
    }

    if fWallet and isnumber( fWallet ) and ( fWallet > 0 ) then
        tColors[ 1 ] = Color( 46, 204, 113 )
    end

    if fBank and isnumber( fBank ) and ( fBank > 0 ) then
        tColors[ 2 ] = Color( 46, 204, 113 )
    end

    -- ARCBank
    if ARCBank and ARCLib.IsVersion( "1.4.0", "ARCBank" ) then
        if not sARCAccount then
            ARCBank.GetAccessableAccounts( LocalPlayer(), function( iError, tAccounts )
                if ( tAccounts and tAccounts[ 1 ] ) then
                    sARCAccount = tostring( tAccounts[ 1 ] )
                end
            end )
        end

        if sARCAccount then
            ARCBank.GetBalance( LocalPlayer(), sARCAccount, function( iError, iMoney )
                if iMoney then
                    fBank = tonumber( iMoney )
                    sBank =  GSmartWatch:FormatMoney( fBank )

                    tColors[ 2 ] = ( fBank > 0 ) and Color( 46, 204, 113 ) or Color( 255, 0, 0 )
                end
            end )
        end
    end

    local fLerp = 0

    function dBase.RunningApp:Paint( iW, iH )
        fLerp = Lerp( RealFrameTime() * 6, fLerp, iH )

        GSmartWatch:SetStencil()

        draw.RoundedBox( 0, 0, 0, iW, iH, color_black )

        surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 0 ] )
        surface.SetMaterial( matBank )
        surface.DrawTexturedRectRotated( ( iW * .75 ), iH * .5, fLerp, fLerp, -12 )

        surface.SetDrawColor( color_black )
        surface.SetMaterial( matGradient )
        surface.DrawTexturedRect( 0, 0, iW, iH )

        draw.SimpleText( string.upper( GSmartWatch.Lang[ "Wallet" ] ), "GSmartWatch.48", ( iW * .5 ), ( iH * .3 ), color_white, 1, 1 )
        draw.SimpleText( ( sWallet and sWallet or "✗" ), "GSmartWatch.64", ( iW * .5 ), ( iH * .42 ), tColors[ 1 ], 1, 1 )

        draw.SimpleText( string.upper( GSmartWatch.Lang[ "Bank" ] ), "GSmartWatch.48", ( iW * .5 ), ( iH * .6 ), color_white, 1, 1 )
        draw.SimpleText( ( sBank and sBank or "✗" ), "GSmartWatch.64", ( iW * .5 ), ( iH * .72 ), tColors[ 2 ], 1, 1 )

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