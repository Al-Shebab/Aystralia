local GSWApp = {}

GSWApp.ID = "app_settings"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Settings" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/settings.png", "smooth" )

--[[

    GSWApp:RunApp

]]--

local tSettingsButtons = {}

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    tSettingsButtons = {}

    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )
    dBase.RunningApp.Paint = nil

    local tMenu = {}
    local iID = 0
    local dParent = dBase.RunningApp

    for sKey, _ in pairs( GSmartWatch.ClientSettings ) do
        iID = ( iID + 1 )

        tMenu[ iID ] = { name = GSmartWatch.Lang.Settings[ sKey ], func = function()
            if ( sKey == "WatchFace" ) then
                GSmartWatch:RunApp( "app_watchfaces" )
                return
            end

            if ( sKey == "BandColor" ) then
                dParent.dSubMenu = GSmartWatch:DrawColorScroller( dParent, GSmartWatch.Cfg.Bands, 0, color_black, function( tColor )
                    if tColor and IsColor( tColor ) then
                        LocalPlayer():GetActiveWeapon():SetBandColor( tColor )

                        GSmartWatch:SaveClientSetting( "BandColor", tColor )
                        GSmartWatch:Notify( GSmartWatch.Lang[ "Updated watchband" ], 2 )
                    end
                end )

            elseif ( sKey == "Is24hCycle" ) then
                dParent.dSubMenu = GSmartWatch:DrawCheckBox( dParent, GSmartWatch.ClientSettings[ "Is24hCycle" ], GSmartWatch.Lang[ "Time system" ], color_black, function( bChecked )
                    GSmartWatch:SaveClientSetting( "Is24hCycle", bChecked )
                    GSmartWatch:Notify( ( bChecked and GSmartWatch.Lang[ "24h clock" ] or GSmartWatch.Lang[ "12h clock" ] ), 2 )
                end )

            elseif ( sKey == "IsToggle" ) then
                dParent.dSubMenu = GSmartWatch:DrawCheckBox( dParent, GSmartWatch.ClientSettings[ "IsToggle" ], GSmartWatch.Lang[ "Set key toggle" ], color_black, function( bChecked )
                    GSmartWatch:SaveClientSetting( "IsToggle", bChecked )
                    GSmartWatch:Notify( ( bChecked and GSmartWatch.Lang[ "Key : Toggle" ] or GSmartWatch.Lang[ "Key : Hold" ] ), 2 )
                end)

            -- elseif ( sKey == "LeftHanded" ) then
            --     dParent = GSmartWatch:DrawCheckBox( dBase, GSmartWatch.ClientSettings[ "LeftHanded" ], "Left-handed?", function( bChecked )
            --         GSmartWatch:SaveClientSetting( "LeftHanded", bChecked )
            --         GSmartWatch:Notify( ( bChecked and "Left-handed" or "Right-handed" ), 2 )
            --     end )

            elseif ( sKey == "UIVolume" ) then
                dParent.dSubMenu = GSmartWatch:DrawNumWang( dParent, ( GSmartWatch.ClientSettings[ "UIVolume" ] * 100 ), 0, 100, 10, GSmartWatch.Lang[ "Adjust UI volume" ], color_black, function( iValue )
                    GSmartWatch:SaveClientSetting( "UIVolume", ( iValue * .01 ) )
                    GSmartWatch:Notify( "Volume set to " .. iValue, 2 )
                end )
            end
        end }
    end

    tMenu[ table.Count( tMenu ) + 1 ] = { name = "Factory settings", func = function()
        local tChoices = {
            { name = GSmartWatch.Lang[ "Confirm" ], func = function()
                dBase.RunningApp.dSubMenu:Remove()
                dBase.RunningApp.dSubMenu = nil

                if file.Exists( "gsmartwatch/client_settings.txt", "DATA" ) then
                    file.Delete( "gsmartwatch/client_settings.txt", "DATA" )
                end

                GSmartWatch:InitClientSettings()
                GSmartWatch:RunApp( "app_boot" )

                if LocalPlayer():IsUsingSmartWatch() then
                    LocalPlayer():GetActiveWeapon():SetBandColor( GSmartWatch.Cfg.Bands[ 1 ] )
                end
            end },
            { name = GSmartWatch.Lang[ "No" ], func = function()
                dBase.RunningApp.dSubMenu:Remove()
                dBase.RunningApp.dSubMenu = nil

                GSmartWatch:RunApp( "app_settings" )
            end }
        }
    
        dParent.dSubMenu:Remove()
        dParent.dSubMenu = GSmartWatch:DrawScroller( dParent, tChoices, 0, "Factory settings", color_black )
    end }

    dParent.dSubMenu = GSmartWatch:DrawScroller( dParent, tMenu, 0, GSmartWatch.Lang.Apps[ "Settings" ], ColorAlpha( color_black, 255 ) )
    dParent.dSubMenu.bFirstLayer = true
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
        if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
            dParent.dSubMenu:SelectNeighbour( true )
            return
        end

    elseif ( sBind == "invprev" ) then
        if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
            dParent.dSubMenu:SelectNeighbour()
            return
        end

    elseif ( sBind == "+attack" ) then
        if dParent.dSubMenu then
            if dParent.dSubMenu.DoClick then
                dParent.dSubMenu:DoClick()
                return
            end

            if dParent.dSubMenu.tCachedChoice and dParent.dSubMenu.tCachedChoice.func() then
                dParent.dSubMenu.tCachedChoice.func()
            end
        end

    elseif ( sBind == "+attack2" ) then
        if dParent.dSubMenu and IsValid( dParent.dSubMenu ) then
            if dParent.dSubMenu.bFirstLayer then
                return GSmartWatch:RunApp( "app_myapps" )
            end

            dParent.dSubMenu:Remove()
            GSmartWatch:RunApp( "app_settings" )
        end
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil