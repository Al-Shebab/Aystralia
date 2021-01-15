if GSmartWatch.Cfg.DisabledApps[ "app_services" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_services"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Services" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/services.png", "smooth" )
GSWApp.ShowTime = true

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local tServices = {}

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    function dBase.RunningApp:Paint( iW, iH )
        GSmartWatch:SetStencil()

        draw.SimpleText( GSmartWatch.Lang[ "Press to call" ], "GSmartWatch.32", ( iW * .5 ), ( iH * .7 ), color_white, 1, 1 )

        render.SetStencilEnable( false )
    end

    -- Police mod
    if VS_PoliceMod and VS_PoliceMod.DisplayHelpCallMenu then
        table.insert( tServices, {
            name = GSmartWatch.Lang[ "Police" ],
            icon = Material( "materials/gsmartwatch/police_car.png", "smooth" ),
            func = function()
                local tMenu = {}
                for k, v in pairs( VS_PoliceMod.Config.CallsReason ) do
                    tMenu[ k ] = { name = v, func = function()
                        if dBase.RunningApp.dSubMenu and IsValid( dBase.RunningApp.dSubMenu ) then
                            dBase.RunningApp.dSubMenu:Remove()
                            dBase.RunningApp.dSubMenu = GSmartWatch:DrawTextEntry( dBase.RunningApp, 20, "Type request", color_black, function( sValue )
                                local tChoices = {
                                    { name = GSmartWatch.Lang[ "Yes" ], func = function()
                                        VS_PoliceMod:NetStart( "OnMissionSent", { cat = k, desc = tostring( sValue ) } )

                                        dBase.RunningApp.dSubMenu:Remove()
                                        dBase.RunningApp.dSubMenu = nil
                                    end },
                                    { name = GSmartWatch.Lang[ "No" ], func = function()
                                        dBase.RunningApp.dSubMenu:Remove()
                                        dBase.RunningApp.dSubMenu = nil
                                    end }
                                }

                                dBase.RunningApp.dSubMenu:Remove()
                                dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tChoices, 0, GSmartWatch.Lang[ "Confirm" ], color_black )
                            end )
                        end
                    end }
                end

                dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tMenu, 0, k, color_black )
            end
        })
    end

    if SlownLS then
        -- SlownLS Taxi
        if SlownLS.Taxi then
            table.insert( tServices, {
                name = GSmartWatch.Lang[ "Taxi" ],
                icon = Material( "materials/gsmartwatch/taxi.png", "smooth" ),
                func = function()
                    local tChoices = {
                        { name = GSmartWatch.Lang[ "Yes" ], func = function()
                            net.Start( "GSmartWatchNW" )
                                net.WriteUInt( 3, 3 )
                            net.SendToServer()

                            dBase.RunningApp.dSubMenu:Remove()
                            dBase.RunningApp.dSubMenu = nil
                        end },
                        { name = GSmartWatch.Lang[ "No" ], func = function()
                            dBase.RunningApp.dSubMenu:Remove()
                            dBase.RunningApp.dSubMenu = nil
                        end }
                    }

                    dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tChoices, 0, GSmartWatch.Lang[ "Confirm" ], color_black )
                end
            })
        end

        -- SlownLS Hitman
        -- if SlownLS.Hitman then
        --     table.insert( tServices, {
        --         name = "Hitman",
        --         icon = Material( "materials/gsmartwatch/hitman.png", "smooth" ),
        --         func = function()
        --             local tPlayers = {}
        --             local iMaxHitPrice = 10000

        --             for k, v in ipairs( player.GetAll() ) do
        --                 table.insert( tPlayers, { name = v:GetName(), data = v, func = function()
        --                     if dBase.RunningApp.dSubMenu and IsValid( dBase.RunningApp.dSubMenu ) then
        --                         dBase.RunningApp.dSubMenu:Remove()
        --                     end

        --                     dBase.RunningApp.dSubMenu = GSmartWatch:DrawNumWang( dBase.RunningApp, 0, 0, iMaxHitPrice, ( iMaxHitPrice / 20 ), "Hit price", color_black, function( iValue )
        --                         local iPrice = tonumber( iValue or 0 )
        --                         print( iPrice )

        --                         dBase.RunningApp.dSubMenu = GSmartWatch:DrawTextEntry( dBase.RunningApp, 20, "Hit reason", color_black, function( sDescription )
        --                             local tChoices = {
        --                                 { name = GSmartWatch.Lang[ "Yes" ], func = function()
        --                                     if SlownLS.Hitman.sendEvent then
        --                                         print( v, iPrice, sDescription )
        --                                         SlownLS.Hitman:sendEvent( "send_contract", {
        --                                             player = v,
        --                                             price = ( iPrice or 0 ),
        --                                             description = ( sDescription or "" ),
        --                                             ent = LocalPlayer(),
        --                                         })
        --                                     end

        --                                     if dBase.RunningApp.dSubMenu and IsValid( dBase.RunningApp.dSubMenu ) then
        --                                         dBase.RunningApp.dSubMenu:Remove()
        --                                     end

        --                                     dBase.RunningApp.dSubMenu = nil
        --                                 end },
        --                                 { name = GSmartWatch.Lang[ "No" ], func = function()
        --                                     if dBase.RunningApp.dSubMenu and IsValid( dBase.RunningApp.dSubMenu ) then
        --                                         dBase.RunningApp.dSubMenu:Remove()
        --                                     end
        --                                     dBase.RunningApp.dSubMenu = nil
        --                                 end }
        --                             }

        --                             dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tChoices, 0, GSmartWatch.Lang[ "Confirm" ], color_black )
        --                         end )
        --                     end )
        --                 end } )
        --             end

        --             dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tPlayers, 0, "Target", color_black )
        --         end
        --     })
        -- end
    end

    -- Mechanical System
    if MSystem and MSystem.NetStart then
        table.insert( tServices, {
            name = GSmartWatch.Lang[ "Mechanic" ],
            icon = Material( "materials/gsmartwatch/tow_truck.png", "smooth" ),
            func = function()
                local tChoices = {
                    { name = GSmartWatch.Lang[ "Yes" ], func = function()
                        MSystem:NetStart( "SendRequest" )

                        dBase.RunningApp.dSubMenu:Remove()
                        dBase.RunningApp.dSubMenu = nil
                    end },
                    { name = GSmartWatch.Lang[ "No" ], func = function()
                        dBase.RunningApp.dSubMenu:Remove()
                        dBase.RunningApp.dSubMenu = nil
                    end }
                }

                dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tChoices, 0, GSmartWatch.Lang[ "Confirm" ], color_black )
            end
        })
    end


        -- table.insert( tServices, {
        --     name = GSmartWatch.Lang[ "Ambulance" ],
        --     icon = Material( "materials/gsmartwatch/ambulance.png", "smooth" ),
        --     func = function()
        --     end
        -- })

    -- DServices
    if ( CONFIG_SERVICES and CONFIG_SERVICES.Settings ) then
        for k, v in pairs( CONFIG_SERVICES.Settings ) do
            table.insert( tServices, {
                name = k .. ( v.price and ( v.price > 0 ) and " | " .. GSmartWatch:FormatMoney( v.price ) or "" ),
                icon = Material( "materials/" .. v.icon, "smooth" ),
                func = function()
                    if dBase.RunningApp.dSubMenu and IsValid( dBase.RunningApp.dSubMenu ) then
                        dBase.RunningApp.dSubMenu:Remove()
                    end

                    dBase.RunningApp.dSubMenu = GSmartWatch:DrawTextEntry( dBase.RunningApp, 20, GSmartWatch.Lang[ "Type request" ], color_black, function( sValue )
                        local tChoices = {
                            { name = GSmartWatch.Lang[ "Yes" ] .. " (" .. GSmartWatch:FormatMoney( v.price ) .. ")", func = function()
    	                        net.Start( "services_request" )
	                                net.WriteVector( LocalPlayer():GetPos() )
	                                net.WriteString( k )
	                                net.WriteString( sValue )
                                	net.WriteString( v.icon )
                            	net.SendToServer()

                                dBase.RunningApp.dSubMenu:Remove()
                                dBase.RunningApp.dSubMenu = nil
                            end },
                            { name = GSmartWatch.Lang[ "No" ], func = function()
                                dBase.RunningApp.dSubMenu:Remove()
                                dBase.RunningApp.dSubMenu = nil
                            end }
                        }

                        dBase.RunningApp.dSubMenu:Remove()
                        dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tChoices, 0, GSmartWatch.Lang[ "Confirm" ], color_black )
                    end )
                end
            } )
        end
    end

    if ( #tServices == 0 ) then
        return GSmartWatch:PaintError( dBase.RunningApp, GSmartWatch.Lang[ "No service found" ] )
    end

    dBase.RunningApp.dCurService = vgui.Create( "DPanel", dBase.RunningApp )
    dBase.RunningApp.dCurService:SetSize( ( dBase:GetWide() * .4 ), ( dBase:GetTall() * .4 ) )
    dBase.RunningApp.dCurService:SetPos( ( dBase:GetWide() * .3 ), ( dBase:GetTall() * .25 ) )

    dBase.RunningApp.dCurService.tServices = tServices
    dBase.RunningApp.dCurService.fLerp = 0

    function dBase.RunningApp.dCurService:SetService( iIndex )
        if not tServices[ iIndex ] then
            return false
        end

        self.name = tServices[ iIndex ].name or false
        self.icon = tServices[ iIndex ].icon or false
        self.func = tServices[ iIndex ].func or false

        self.iSelected = iIndex
    end

    dBase.RunningApp.dCurService:SetService( 1 )

    function dBase.RunningApp.dCurService:Paint( iW, iH )
        self.fLerp = Lerp( RealFrameTime() * 10, self.fLerp, ( iH * .45 ) )

        if self.icon then
            surface.SetDrawColor( color_white )
            surface.SetMaterial( self.icon )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .4 ), self.fLerp, ( iH * .45 ), 0 )
        end

        draw.SimpleText( ( self.name or "" ), "GSmartWatch.48", ( iW * .5 ), iH * .9, color_white, 1, 1 )
    end
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
        if ( dParent and dParent.dCurService ) then
            if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
                dParent.dSubMenu:SelectNeighbour( true )
                return
            end

            local dPanel = dParent.dCurService
            if not dPanel.tServices or ( #dPanel.tServices < 1 ) then
                return
            end

            local iSelected = ( dPanel.iSelected + 1 )
            if ( iSelected > #dPanel.tServices ) then
                iSelected = 1
            end

            dPanel:SetService( iSelected )
            dPanel.fLerp = 0
        end

    elseif ( sBind == "invprev" ) then
        if ( dParent and dParent.dCurService ) then
            if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
                dParent.dSubMenu:SelectNeighbour()
                return
            end

            local dPanel = dParent.dCurService
            if not dPanel.tServices or ( #dPanel.tServices < 1 ) then
                return
            end

            local iSelected = ( dPanel.iSelected - 1 )
            if ( iSelected < 1 ) then
                iSelected = #dPanel.tServices
            end
            
            dPanel:SetService( iSelected )
            dPanel.fLerp = 0
        end

    elseif ( sBind == "+attack" ) then
        if dParent and dParent.dSubMenu then
            if dParent.dSubMenu.DoClick then
                dParent.dSubMenu:DoClick()
                return
            end

            if dParent.dSubMenu.tCachedChoice and dParent.dSubMenu.tCachedChoice.func() then
                dParent.dSubMenu.tCachedChoice.func()
            end

            return
        end

        if ( dParent and dParent.dCurService ) then
            local dPanel = dParent.dCurService
            if not dPanel.tServices or ( #dPanel.tServices < 1 ) then
                return
            end

            if dPanel.func then
                dPanel.func()
            end
        end

    elseif ( sBind == "+attack2" ) then
        if dParent.dSubMenu and IsValid( dParent.dSubMenu ) then
            dParent.dSubMenu:Remove()
            dParent.dSubMenu = nil

            return
        end

        GSmartWatch:RunApp( "app_myapps" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil