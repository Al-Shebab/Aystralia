local GSWApp = {}

GSWApp.ID = "app_watch"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Watch" ]
GSWApp.IsInvisible = true

local matMusic = Material( "materials/gsmartwatch/mapico/music.png", "smooth" )

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    GSmartWatch.WatchFaces[ ( GSmartWatch.ClientSettings.WatchFace or 1 ) ].func( dBase )

    local bRadioPlaying = GSmartWatch:IsRadioPlaying()
    if bRadioPlaying then
        local iStation = GSmartWatch:GetRadioStation()
        local sRadio = GSmartWatch.Cfg.RadioStations[ iStation ].name 
        local fScrollX = dBase.RunningApp:GetWide()

        surface.SetFont( "GSmartWatch.32" )
        local iTextW, iTextH = surface.GetTextSize( sRadio )

        function dBase.RunningApp:PaintOver( iW, iH )
            GSmartWatch:SetStencil()

            fScrollX = ( fScrollX - .2 )
            if ( fScrollX < -( iTextW + 20 ) ) then
                fScrollX = iW
            end

            draw.RoundedBox( 0, fScrollX - 15, ( iH * .88 ) - ( iTextH * .5 ), iTextW + 70, iTextH, ColorAlpha( GSmartWatch.Cfg.Colors[ 0 ], 240 ) )

            surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 4 ] )
            surface.SetMaterial( matMusic )
            surface.DrawTexturedRect( fScrollX, ( iH * .88 ) - ( iH * .03 ), ( iH * .06 ), ( iH * .06 ) )

            draw.SimpleText( sRadio, "GSmartWatch.32", fScrollX + ( iH * .06 ) + 10, ( iH * .88 ), GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )

            render.SetStencilEnable( false )
        end
    end
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    GSmartWatch.LastUse = ( GSmartWatch.LastUse or 0 )
    if ( CurTime() < ( GSmartWatch.LastUse - .5 ) ) then
        return
    end

    if ( sBind == "+attack" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end

    GSmartWatch.LastUse = CurTime() + .2
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil