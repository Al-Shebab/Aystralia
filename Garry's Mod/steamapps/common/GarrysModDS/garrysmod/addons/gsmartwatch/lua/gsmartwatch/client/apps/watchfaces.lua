local GSWApp = {}

GSWApp.ID = "app_watchfaces"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Watch faces" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/watchfaces.png", "smooth" )
-- GSWApp.ShowTime = true

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )
    dBase.RunningApp.Paint = nil
    dBase.RunningApp.iSelected = 1

    function dBase.RunningApp:PaintOver( iW, iH )
        GSmartWatch:SetStencil()
        draw.RoundedBox( 0, 0, 0, iW, iH, ColorAlpha( GSmartWatch.Cfg.Colors[ 0 ], 230 ) )

        draw.SimpleText( GSmartWatch.WatchFaces[ self.iSelected ].name, "GSmartWatch.64", ( iW * .52 ), ( iH * .37 ), color_black, 1, 1 )
        draw.SimpleText( GSmartWatch.WatchFaces[ self.iSelected ].name, "GSmartWatch.64", ( iW * .5 ), ( iH * .35 ), color_white, 1, 1 )
        
        render.SetStencilEnable( false )
    end

    dBase.RunningApp.Preview = GSmartWatch.WatchFaces[ dBase.RunningApp.iSelected ].func( dBase )
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if ( sBind == "invnext" ) then
        if ( dBase.RunningApp and dBase.RunningApp.iSelected ) then
            local dPanel = dBase.RunningApp

            dPanel.iSelected = ( dPanel.iSelected + 1 )
            if ( dPanel.iSelected > #GSmartWatch.WatchFaces ) then
                dPanel.iSelected = 1
            end

            if not dPanel.Preview then
                return
            end

            dPanel.Preview:Clear()
            dPanel.Preview = GSmartWatch.WatchFaces[ dPanel.iSelected ].func( dBase )
        end

    elseif ( sBind == "invprev" ) then
        if ( dBase.RunningApp and dBase.RunningApp.iSelected ) then
            local dPanel = dBase.RunningApp

            dPanel.iSelected = ( dPanel.iSelected - 1 )
            if ( dPanel.iSelected < 1 ) then
                dPanel.iSelected = #GSmartWatch.WatchFaces
            end
            
            if not dPanel.Preview then
                return 
            end

            dPanel.Preview:Clear()
            dPanel.Preview = GSmartWatch.WatchFaces[ dPanel.iSelected ].func( dBase )
        end

    elseif ( sBind == "+attack" ) then
        if ( dBase.RunningApp and dBase.RunningApp.iSelected ) then
            local dPanel = dBase.RunningApp

            if GSmartWatch.WatchFaces[ dPanel.iSelected ] then
                GSmartWatch:SaveClientSetting( "WatchFace", dPanel.iSelected )
                GSmartWatch:Notify( "Watch face applied" )
            end
        end

    elseif ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil