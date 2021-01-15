local GSWApp = {}

GSWApp.ID = "app_myapps"
GSWApp.Name = GSmartWatch.Lang.Apps[ "My Apps" ]
GSWApp.IsInvisible = true

--[[

    GSWApp:RunApp

]]--

local tAppButtons = {}
GSmartWatch.LastSelectedApp = false


function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    tAppButtons = {}

    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )
    dBase.RunningApp.Paint = nil

    dBase.RunningApp.dScroll = vgui.Create( "DScrollPanel", dBase.RunningApp )
    dBase.RunningApp.dScroll:SetSize( ( dBase:GetWide() * .64 ), ( dBase:GetTall() * .68 ) )
    dBase.RunningApp.dScroll:SetPos( ( dBase:GetWide() * .18 ), ( dBase:GetTall() * .16 ) )

    local dBar = dBase.RunningApp.dScroll:GetVBar()
    dBar:SetWidth( 0 )
    dBar:SetVisible( false )

    local iID = -1

    for k, v in SortedPairs( GSmartWatch:GetApps() ) do
        if v.IsInvisible or GSmartWatch.Cfg.DisabledApps[ k ] then
            continue
        end

        iID = ( iID + 1 )
        if not GSmartWatch.LastSelectedApp then
            GSmartWatch.LastSelectedApp = iID
        end

        local dButton = dBase.RunningApp.dScroll:Add( "DButton" )
        dButton:SetSize( dBase.RunningApp.dScroll:GetWide(), ( dBase.RunningApp.dScroll:GetTall() * .2 ) )
	    dButton:SetText( v.Name or "" )
        dButton:SetFont( "GSmartWatch.32" )
        dButton:SetTextColor( color_white )
        dButton:SetContentAlignment( 4 )
        dButton:SetTextInset( ( dButton:GetTall() * 1.2 ), 0 )
        dButton:Dock( TOP )
        dButton:SetWrap( true )
	    dButton:DockMargin( 0, 0, 0, 20 )

        dButton.iIndex = iID
        dButton.iAppID = v.ID
        -- dButton.fLerp = 0
        -- dButton.fLerpAlpha = 0

        tAppButtons[ iID ] = dButton

        function dButton:Paint( iW, iH )
            local bHoverd = ( self.iIndex == GSmartWatch.LastSelectedApp )

            self:SetTextColor( bHoverd and color_white or GSmartWatch.Cfg.Colors[ 3 ] )
            self:SetTextInset( ( bHoverd and ( iH * 1.35 ) or ( iH * 1.2 ) ), 0 )

            if v.Icon then
                surface.SetDrawColor( bHoverd and color_white or GSmartWatch:DarkenColor( color_white, 50 ) )
                surface.SetMaterial( v.Icon )
                surface.DrawTexturedRectRotated( ( iH * .5 ), ( iH * .5 ), ( bHoverd and ( iH * 1.2 ) or iH ), ( bHoverd and ( iH * 1.2 ) or iH ), 0 )
            end
        end
    end

    timer.Simple( .01, function()
        if dBase and IsValid( dBase ) and GSmartWatch.LastSelectedApp and tAppButtons[ GSmartWatch.LastSelectedApp ] then
            if dBase.RunningApp and dBase.RunningApp.dScroll then
                dBase.RunningApp.dScroll:ScrollToChild( tAppButtons[ GSmartWatch.LastSelectedApp ] )
            end
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

    if ( sBind == "invnext" ) then
        if GSmartWatch.LastSelectedApp then
            GSmartWatch.LastSelectedApp = tAppButtons[ GSmartWatch.LastSelectedApp + 1 ] and ( GSmartWatch.LastSelectedApp + 1 ) or 0
            dBase.RunningApp.dScroll:ScrollToChild( tAppButtons[ GSmartWatch.LastSelectedApp ] )
        end

    elseif ( sBind == "invprev" ) then
        if GSmartWatch.LastSelectedApp then
            GSmartWatch.LastSelectedApp = tAppButtons[ GSmartWatch.LastSelectedApp - 1 ] and ( GSmartWatch.LastSelectedApp - 1 ) or #tAppButtons
            dBase.RunningApp.dScroll:ScrollToChild( tAppButtons[ GSmartWatch.LastSelectedApp ] )
        end

    elseif ( sBind == "+attack" ) then
        GSmartWatch:RunApp( tAppButtons[ GSmartWatch.LastSelectedApp ].iAppID )

    elseif ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_watch" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil