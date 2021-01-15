if GSmartWatch.Cfg.DisabledApps[ "app_maps" ] then
    return
end

local tMap = GSmartWatch.Cfg.MapConfig[ game.GetMap() ] or {}

GSmartWatch.MyPOIs = GSmartWatch.MyPOIs or {}

local GSWApp = {}
 
GSWApp.ID = "app_maps"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Maps" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/maps.png", "smooth" )

local matArrow = Material( "materials/gsmartwatch/arrow.png", "smooth" )
local matWaypoint = Material( "materials/gsmartwatch/waypoint_direction.png", "smooth" )
local matVehicle = Material( "materials/gsmartwatch/vehicle.png", "smooth" )
local matClouds = Material( "materials/gsmartwatch/clouds_scroll.png", "smooth" )

local tColor = Color( 41, 128, 185 )
local tColor2 = Color( 192, 57, 43 )
local tBgColor = Color( 170, 218, 255 )

-- Player

local mPlayer = FindMetaTable( "Player" )

-- local tPoints = {
--     [ 0 ] = function( t )
--         return t
--     end,
    -- [ 1 ] = function( t )
    --     return ( t + Vector( 100, 0, 600 ) )
    -- end,
    -- [ 2 ] = function( t )
    --     return ( t + Vector( -100, 0, 600 ) )
    -- end,
    -- [ 3 ] = function( t )
    --     return ( t + Vector( 0, 100, 600 ) )
    -- end,
    -- [ 4 ] = function( t )
    --     return ( t + Vector( 0, -100, 600 ) )
    -- end
-- }

-- function mPlayer:IsCoveredByMap()
--     local tPos = LocalPlayer():GetPos()
--     local bCollide = false

--     for k, v in ipairs( tPoints ) do
--         local tEnd = v( tPos )

--         local tTr = util.TraceLine( {
-- 	        start = tPos,
--     	    endpos = tEnd,
-- 	        filter = function( eEnt )
--                 if ( eEnt:GetClass() == "prop_physics" ) then
--                     return true
--                 end
--             end
--         } )

--         if tTr.Entity and ( tTr.Entity:IsWorld() ) then
--             bCollide = true
--             break
--         end
--     end

--     return bCollide
-- end

-- Maps object

local Maps = {}

Maps.iMapSize = false
Maps.matCurMap = false

Maps.iZoom = 1
Maps.iPOIVisibility = 0

local tPOIColors = {
    Color( 238, 17, 17 ),
    Color( 211, 84, 0 ),
    Color( 227, 167, 26 ),
    Color( 43, 87, 151 ),
    Color( 45, 137, 239 ),
    Color( 0, 171, 169 ),
    Color( 239, 244, 255 ),
    Color( 96, 60, 186 ),
    Color( 159, 0, 167 ),
    Color( 30, 113, 69 ),
    Color( 0, 163, 0 ),
    Color( 53, 180, 51 )
}

local tPOIIcons = {
    "pin",
    "flag",
    "info",
    "fuel",
    "spanner",
    "house",
    "banking",
    "factory",
    "police",
    "hospital",
    "school",
    "church",
    "gun",
    "cart",
    "shirt",
    "fire",
    "diamond",
    "food",
    "drink",
    "syringe",
    "weed",
    "money",
    "paintspray",
    "paint",
    "fish",
    "music",
    "shield",
    "star",
    "user",
}

for k, v in ipairs( tPOIIcons ) do
    tPOIIcons[ k ] = Material( "materials/gsmartwatch/mapico/" .. v .. ".png", "smooth" )
end

--[[

    Maps:SetWaypoint

]]--

function Maps:SetWaypoint( tVector, sDestination, tPOIColor, iIcon )
    self.tWaypoint = tVector
    self.sDestination = sDestination
    self.tPOIColor = tPOIColor or tPOIColors[ 1 ]

    if iIcon and tPOIIcons[ iIcon ] and type( tPOIIcons[ iIcon ] == "IMaterial" ) then
        self.matPOIIcon = tPOIIcons[ iIcon ]
    else
        self.matPOIIcon = nil
    end
end

--[[

    GSmartWatch_OnMapPublicPOIUpdate

]]--

hook.Add( "GSmartWatch_OnMapPublicPOIUpdate", "GSmartWatch_OnMapPublicPOIUpdate:Maps", function( tPublicPOIs )
    if not Maps.sDestination then
        return
    end

    for k, v in pairs( tPublicPOIs ) do
        if ( k == Maps.sDestination ) then
            Maps:SetWaypoint( nil, nil, nil, nil )

            break
        end
    end
end )

hook.Add( "GSmartWatch_OnWaypointArrival", "GSmartWatch_OnWaypointArrival:Maps", function( sDest, tWP )
    GSmartWatch:Play2DSound( "gsmartwatch/ui/notify.mp3" )
end )

--[[

    Maps:SetPOIVisibility

]]--

function Maps:SetPOIVisibility( iVis )
    if not iVis or ( iVis < 0 ) or ( iVis > 3 ) then
        self.iPOIVisibility = 0

        return 
    end

    self.iPOIVisibility = iVis
end

--[[

    Maps:Zoom

]]--

function Maps:Zoom( dBase, bUnzoom )
    if not dBase or not IsValid( dBase ) or not dBase.iImgH or not dBase.iImgMaxH then
        return
    end

    local iMax = dBase.iImgMaxH

    local iZoomStages = 6

    local iMinZ = ( iMax * .5 )
    local iMaxZ = ( iMinZ * iZoomStages )

    if bUnzoom then
        Maps.iZoom = ( Maps.iZoom - 1 )
        if ( Maps.iZoom < 1 ) then
            Maps.iZoom = 1
        end

        local iUnzoom = ( dBase.iImgH - iMinZ )
        dBase.iImgH = ( iUnzoom > iMinZ ) and iUnzoom or iMinZ
    else
        Maps.iZoom = ( Maps.iZoom + 1 )
        if ( Maps.iZoom > iZoomStages ) then
            Maps.iZoom = iZoomStages
        end

        local iZoom = ( dBase.iImgH + iMinZ )
        dBase.iImgH = ( iZoom < iMaxZ ) and iZoom or iMaxZ
    end

    Maps.fZBarX = 100

    if timer.Exists( "GSmartWatch_MapZoom" ) then
        timer.Adjust( "GSmartWatch_MapZoom", 1.5, 1, function()
            Maps.fZBarX = 0
        end )

        return
    end

    timer.Create( "GSmartWatch_MapZoom", 1.5, 1, function()
        Maps.fZBarX = 0
    end )    
end

--[[

    Maps:CreateMat

]]--

function Maps:CreateMat( iH )
    local iH = ( iH or 2048 )
    local tMin, tMax = game.GetWorld():GetModelBounds()

    local tRT = GetRenderTarget( "GSmartWatch_MinimapRT", iH, iH )

    for k, v in pairs( ents.GetAll() ) do
        if v:IsWorld() then
            continue
        end

        v:SetNoDraw( true )
    end

    render.PushRenderTarget( tRT )
    	render.RenderView( {
    	    origin = Vector( ( tMax.x + tMin.x ) * .5, ( tMax.y + tMin.y ) * .5, tMax[ 3 ] + ( tMap.iZOffset or 0  ) ),
	        angles = Angle( 90, 90, 0 ),
            x = 0,
            y = 0,
            w = iH,
            h = iH,
    		bloomtone = false,
            drawmonitors = false,
            drawviewmodel = false,
            ortho = true,
		    ortholeft = tMin.x,
		    orthoright = tMax.x,
		    orthotop = tMin.y + ( tMap.iZOffset or 0 ),
		    orthobottom = tMax.y + ( tMap.iZOffset or 0 ),
	    	znear = 0,
        	zfar = ( tMap.iZFar or 64000 ),
        } )
    render.PopRenderTarget()

    local tMaterial = CreateMaterial( "GSmartWatch_MinimapRTMaterial", "UnlitGeneric", {
	    [ "$basetexture" ] = tRT:GetName(),
    } )

    for k, v in pairs( ents.GetAll() ) do
        if v:IsWorld() then
            continue
        end

        v:SetNoDraw( false )
    end

    render.SetShadowsDisabled( false )

    Maps.matCurMap, Maps.iMapSize = tMaterial, ( tMax.x - tMin.x )

    return tMaterial, ( tMax.x - tMin.x )
end

--[[

    Maps:CreateCustomPOI

]]--

function Maps:CreateCustomPOI( sName, tPos, tPOIColor, iPOIIcon )
    if not sName or not tPos or not isvector( tPos ) then
        return false
    end

    if not file.Exists( "gsmartwatch", "DATA" ) then
        file.CreateDir( "gsmartwatch" )
    end

    if not file.Exists( "gsmartwatch/mypois", "DATA" ) then
        file.CreateDir( "gsmartwatch/mypois" )
    end

    local tSavedPOIs = {}

    if file.Exists( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", "DATA" ) then
        local sSavedPOIs = file.Read( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", "DATA" )
        tSavedPOIs = util.JSONToTable( sSavedPOIs )
    end

    if tSavedPOIs[ sName ] then
        return false
    end

    tSavedPOIs[ sName ] = {
        [ 1 ] = Vector( math.Round( tPos.x, 1 ), math.Round( tPos.y, 1 ), math.Round( tPos.z, 1 ) ),
        [ 2 ] = ( tPOIColor or tPOIColors[ 1 ] ),
        [ 3 ] = ( iPOIIcon or 1 )
    }

    GSmartWatch.MyPOIs = tSavedPOIs

    file.Write( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", util.TableToJSON( tSavedPOIs, true ) )

    return true
end

--[[

    Maps:RemoveCustomPOI

]]--

function Maps:RemoveCustomPOI( sName )
    if file.Exists( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", "DATA" ) then
        local sSavedPOIs = file.Read( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", "DATA" )
        local tSavedPOIs = util.JSONToTable( sSavedPOIs )

        if tSavedPOIs[ sName ] then
            tSavedPOIs[ sName ] = nil
            GSmartWatch.MyPOIs = tSavedPOIs
            
            file.Write( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", util.TableToJSON( tSavedPOIs, true ) )

            if ( Maps.sDestination == sName ) then
                Maps:SetWaypoint( nil, nil, nil, nil )
            end

            return true
        end

        return false
    end

    return false
end

--[[

    Maps:TranslateVector

]]--

function Maps:TranslateVector( iTargetX, iTargetY, fZoom, iCenterX, iCenterY )
    local iX = ( ( iTargetX / Maps.iMapSize ) * -fZoom ) + iCenterX
    local iY = ( ( iTargetY / Maps.iMapSize ) * fZoom ) - iCenterY

    return iX, iY
end

--[[

    Maps:IsPointOutOfCircle

]]--

function Maps:IsPointOutOfCircle( iRad, iX, iY ) 
    if ( ( iX * iX ) + ( iY * iY ) > ( iRad ^ 2 ) ) then
        return true
    end

    return false
end

--[[

    Maps:DrawPOIArray

]]--

function Maps:DrawPOIArray( tPOIs, fLerpSize, iX, iY, iW, iH )
    for k, v in pairs( tPOIs ) do
        if Maps.sDestination and ( k == Maps.sDestination ) then
            continue
        end

        local tPos = LocalPlayer():GetPos()
        local iPoiX, iPoiY = Maps:TranslateVector( v[ 1 ].x, v[ 1 ].y, fLerpSize, iX, iY )

        if not Maps:IsPointOutOfCircle( ( iH * .55 ), iPoiX, iPoiY ) then
            GSmartWatch:DrawMatShadow( tPOIIcons[ v[ 3 ] ] or tPOIIcons[ 1 ], ( iW * .5 ) - iPoiX, ( iH * .5 ) - iPoiY, ( iH * .12 ), ( iH * .12 ), GSmartWatch:DarkenColor( v[ 2 ], 75 ) )
        end
    end
end

--[[

    Maps:DrawPOIs

]]--

function Maps:DrawPOIs( iVis, fLerpSize, iX, iY, iW, iH )
    if not iVis or ( iVis == 0 ) then
        return
    end

    if ( iVis == 1 ) and GSmartWatch.MyPOIs then
        return Maps:DrawPOIArray( GSmartWatch.MyPOIs, fLerpSize, iX, iY, iW, iH )
    end

    if ( iVis == 2 ) and GSmartWatch.PublicPOIs then
        return Maps:DrawPOIArray( GSmartWatch.PublicPOIs, fLerpSize, iX, iY, iW, iH )
    end

    if ( iVis == 3 ) then
        if GSmartWatch.PublicPOIs then
            Maps:DrawPOIArray( GSmartWatch.PublicPOIs, fLerpSize, iX, iY, iW, iH )
        end

        if GSmartWatch.MyPOIs then
            Maps:DrawPOIArray( GSmartWatch.MyPOIs, fLerpSize, iX, iY, iW, iH )
        end
    end
end

--[[

    Maps:DrawVehicle

]]--

function Maps:DrawVehicle( iX, iY, iW, iH, fLerpSize )
    local tPos = GSmartWatch.VehicleData.pos
    local iVehicleX, iVehicleY = Maps:TranslateVector( tPos.x, tPos.y, fLerpSize, iX, iY )

    if not Maps:IsPointOutOfCircle( ( iH * .55 ), iVehicleX, iVehicleY ) then
        GSmartWatch:DrawMatShadow( matVehicle, ( iW * .5 ) - iVehicleX, ( iH * .5 ) - iVehicleY, ( iH * .17 ), ( iH * .17 ), ColorAlpha( color_white, 140 ) )
    end
end

--[[

    Maps:DrawZoomBar

]]--

function Maps:DrawZoomBar( iW, iH, fLerpZoom, fLerpZoomX )
    local iBarH = ( iH * .35 )

    local iZoomOffset = ( iBarH / 6 * - fLerpZoom )
    local iZoomX = ( ( iW * .18 ) * - ( fLerpZoomX * .01 ) )

    draw.RoundedBox( 10, ( iW - 8 ) + iZoomX, ( iH * .3 ) - 2, 16, ( iBarH + 12 ) + 2, GSmartWatch.Cfg.Colors[ 0 ] )
    draw.RoundedBox( 0, ( iW - 2 ) + iZoomX, ( iH * .3 ) + iBarH + iZoomOffset + 6, 4, - iZoomOffset, GSmartWatch.Cfg.Colors[ 4 ] )
end

--[[

    Maps:DrawClouds

]]--

local iCloudX = 454
local iCloudW = 908

function Maps:DrawClouds( iW, iH, fCloudAlpha )
    iCloudX = ( iCloudX - .1 )

    if ( iCloudX < - ( iCloudW * .9 ) ) then
        iCloudX = iW
    end

    if ( fCloudAlpha > 2 ) then
        surface.SetDrawColor( ColorAlpha( color_white, fCloudAlpha ) )
        surface.SetMaterial( matClouds )
        surface.DrawTexturedRect( iCloudX, ( iH * .5 ) - ( iCloudW * .125 ), iCloudW, ( iCloudW * .25 ) )
    end
end


--[[

    Maps:BuildMenu

]]--

function Maps:BuildMenu( dBase, iSubMenu )
    if not dBase or not IsValid( dBase ) or not dBase.RunningApp then
        return
    end

    local tMenu = {}

    table.insert( tMenu, { name = GSmartWatch.Lang[ "Stop GPS" ], func = function()
        if not Maps.tWaypoint then
            return GSmartWatch:Notify( GSmartWatch.Lang[  "GPS navigation not activated" ] )
        end

        local tChoices = {
            { name = GSmartWatch.Lang[ "Yes" ], func = function()
                Maps:SetWaypoint( nil, nil, nil, nil )
                Maps:DestroyMenu( dBase )

                GSmartWatch:Notify( GSmartWatch.Lang[ "Navigation stopped" ] )
            end },
            { name = GSmartWatch.Lang[ "No" ], func = function()
                Maps:DestroyMenu( dBase, true )
            end }
        }
    
        dBase.RunningApp.dSubMenu:Remove()
        dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tChoices, 0, GSmartWatch.Lang[ "Stop GPS" ], color_black )

        Maps.iSubMenu = 1
    end } )

    local iPOICount, iPublicPOICount = table.Count( GSmartWatch.MyPOIs or {} ), table.Count( GSmartWatch.PublicPOIs or {} )

    table.insert( tMenu, { name = GSmartWatch.Lang[ "POIs" ], descr = ( iPOICount + iPublicPOICount ) .. " " .. GSmartWatch.Lang[ "POIs" ], func = function()
        local tPOIMenus = {}

        -- My POIs
        tPOIMenus[ 1 ] = { name = GSmartWatch.Lang[ "My POIs" ], descr = iPOICount .. " " .. GSmartWatch.Lang[ "POIs" ], func = function()
            if not GSmartWatch.MyPOIs or table.IsEmpty( GSmartWatch.MyPOIs ) then
                return GSmartWatch:Notify( GSmartWatch.Lang[ "No saved POI found on this map" ] )
            end

            local tPOIs = {}
            for k, v in SortedPairs( GSmartWatch.MyPOIs ) do
                tPOIs[ k ] = { name = k,descr = math.floor( LocalPlayer():GetPos():Distance( v[ 1 ] ) / 60 ) .. "m", func = function()
                    local tSubMenu = {
                        { name = GSmartWatch.Lang[ "Navigate" ], descr = math.floor( LocalPlayer():GetPos():Distance( v[ 1 ] ) / 60 ) .. "m", func = function()
                            Maps:DestroyMenu( dBase )
                            Maps:SetWaypoint( v[ 1 ], k, v[ 2 ], v[ 3 ] )

                            GSmartWatch:Notify( GSmartWatch.Lang[ "Navigation started" ] )
                        end },
                        { name = GSmartWatch.Lang[ "Remove" ], func = function()
                            local bRemoved = Maps:RemoveCustomPOI( k )

                            if bRemoved then
                                GSmartWatch:Notify( GSmartWatch.Lang[ "POI removed" ] )
                            end

                            Maps:DestroyMenu( dBase, true )
                        end }
                    }

                    dBase.RunningApp.dSubMenu:Remove()
                    dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tSubMenu, 0, k, color_black )
                end }
            end

            if GSmartWatch.VehicleData and GSmartWatch.VehicleData.pos then
                local tVehicleEntry = { name = GSmartWatch.Lang[ "Vehicle" ], func = function()
                    local tSubMenu = {
                        { name = GSmartWatch.Lang[ "Navigate" ], descr = math.floor( LocalPlayer():GetPos():Distance( v[ 1 ] ) / 60 ) .. "m", func = function()
                            Maps:DestroyMenu( dBase )
                            Maps:SetWaypoint( GSmartWatch.VehicleData.pos, GSmartWatch.Lang[ "Vehicle" ], Color( 180, 200, 255 ), nil )

                            GSmartWatch:Notify( GSmartWatch.Lang[ "Navigation started" ] )
                        end },
                    }

                    dBase.RunningApp.dSubMenu:Remove()
                    dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tSubMenu, 0, k, color_black )
                end }

                tPOIs[ GSmartWatch.Lang[ "Vehicle" ] ] = tVehicleEntry
            end

            Maps:SetWaypoint( tVector, sDestination, tPOIColor, iIcon )
        

            dBase.RunningApp.dSubMenu:Remove()
            dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tPOIs, 0, GSmartWatch.Lang[ "My POIs" ], color_black )
        end }

        -- Public POIs
        tPOIMenus[ 2 ] = { name = GSmartWatch.Lang[ "Public POIs" ], descr = iPublicPOICount .. " " .. GSmartWatch.Lang[ "POIs" ], func = function()
            if not GSmartWatch.PublicPOIs or table.IsEmpty( GSmartWatch.PublicPOIs ) then
                return GSmartWatch:Notify( GSmartWatch.Lang[ "No public POI found on this map" ] )
            end

            local tPOIs = {}
            for k, v in SortedPairs( GSmartWatch.PublicPOIs ) do
                tPOIs[ k ] = { name = k, descr = math.floor( LocalPlayer():GetPos():Distance( v[ 1 ] ) / 60 ) .. "m", func = function()
                    local tSubMenu = {
                        { name = GSmartWatch.Lang[ "Navigate" ], descr = math.floor( LocalPlayer():GetPos():Distance( v[ 1 ] ) / 60 ) .. "m", func = function()
                            Maps:SetWaypoint( v[ 1 ], k, v[ 2 ], v[ 3 ] )
                            GSmartWatch:Notify( GSmartWatch.Lang[ "Navigation started" ] )

                            Maps:DestroyMenu( dBase )
                        end },
                    }

                    if LocalPlayer():IsSuperAdmin() then
                        tSubMenu[ 2 ] = { name = GSmartWatch.Lang[ "Remove" ], func = function()
                            net.Start( "GSmartWatchNW" )
                                net.WriteUInt( 5, 3 )
                                net.WriteString( k )
                            net.SendToServer()

                            Maps:DestroyMenu( dBase )
                        end }
                    end

                    dBase.RunningApp.dSubMenu:Remove()
                    dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tSubMenu, 0, k, color_black )
                end }
            end

            dBase.RunningApp.dSubMenu:Remove()
            dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tPOIs, 0, GSmartWatch.Lang[ "Public POIs" ], color_black )
        end }

        dBase.RunningApp.dSubMenu:Remove()
        dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tPOIMenus, 0, GSmartWatch.Lang[ "POIs" ], color_black )

        Maps.iSubMenu = 2
    end } )

    local tVisibilityTitle = {
        [ 1 ] = GSmartWatch.Lang[ "My POIs" ],
        [ 2 ] = GSmartWatch.Lang[ "Public POIs" ],
        [ 3 ] = GSmartWatch.Lang[ "Show all" ],
        [ 4 ] = GSmartWatch.Lang[ "Hide all" ]
    }

    table.insert( tMenu, { name = GSmartWatch.Lang[ "POI Visibility" ], descr = tVisibilityTitle[ Maps.iPOIVisibility ] or tVisibilityTitle[ 4 ], func = function()    
        dBase.RunningApp.dSubMenu:Remove()
        dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, {
            { name = tVisibilityTitle[ 1 ], func = function()
                Maps:SetPOIVisibility( 1 )
                GSmartWatch:Notify( GSmartWatch.Lang[ "POI Visibility" ] .. ":\n" .. tVisibilityTitle[ 1 ] )
            end },
            { name = tVisibilityTitle[ 2 ], func = function()
                Maps:SetPOIVisibility( 2 )
                GSmartWatch:Notify( GSmartWatch.Lang[ "POI Visibility" ] .. ":\n" .. tVisibilityTitle[ 2 ] )
            end },
            { name = tVisibilityTitle[ 3 ], func = function()
                Maps:SetPOIVisibility( 3 )
                GSmartWatch:Notify( GSmartWatch.Lang[ "POI Visibility" ] .. ":\n" .. tVisibilityTitle[ 3 ] )
            end },
            { name = tVisibilityTitle[ 0 ], func = function()
                Maps:SetPOIVisibility( 0 )
                GSmartWatch:Notify( GSmartWatch.Lang[ "POI Visibility" ] .. ":\n" .. tVisibilityTitle[ 4 ] )
            end }
        }, 0, GSmartWatch.Lang[ "POI Visibility" ], color_black )

        Maps.iSubMenu = 3
    end } )

    table.insert( tMenu, { name = GSmartWatch.Lang[ "Add POI" ], func = function()
        dBase.RunningApp.dSubMenu:Remove()
        dBase.RunningApp.dSubMenu = GSmartWatch:DrawTextEntry( dBase.RunningApp, 18, GSmartWatch.Lang[ "Type POI name" ], color_black, function( sValue )
            if ( sValue == "" ) or not dBase.RunningApp.dSubMenu or not IsValid( dBase.RunningApp.dSubMenu ) then
                return
            end

            dBase.RunningApp.dSubMenu:Remove()
            dBase.RunningApp.dSubMenu = GSmartWatch:DrawColorScroller( dBase.RunningApp, tPOIColors, 0, color_black, function( tColor )
                local tIcons = {}

                for k, v in ipairs( tPOIIcons ) do
                    if ( type( v ) ~= "IMaterial" ) then
                        continue
                    end

                    tIcons[ k ] = { icon = v, iconColor = tColor, func = function()
                        local tSubMenu = {
                            [ 1 ] = { name = string.format( GSmartWatch.Lang[ "Save %s?" ], sValue ), func = function()
                                local bPOIAdded = Maps:CreateCustomPOI( sValue, LocalPlayer():GetPos(), tColor, k )

                                Maps:DestroyMenu( dBase )
                                GSmartWatch:Notify( bPOIAdded and GSmartWatch.Lang[ "New POI saved" ] or GSmartWatch.Lang[ "Canceled. POI already exists" ] )
                            end },
                            [ 2 ] = { name = GSmartWatch.Lang[ "Cancel" ], func = function()
                                Maps:DestroyMenu( dBase )
                                GSmartWatch:Notify( GSmartWatch.Lang[ "Action canceled" ] )
                            end }
                        }

                        dBase.RunningApp.dSubMenu:Remove()
                        dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tSubMenu, 0, GSmartWatch.Lang[ "Add POI" ], color_black )
                    end }
                end

                dBase.RunningApp.dSubMenu:Remove()
                dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tIcons, 0, GSmartWatch.Lang[ "Choose icon" ], color_black, ( dBase:GetTall() * .16 ) )

            end )
        end )

        Maps.iSubMenu = 4
    end } )

    if LocalPlayer():IsSuperAdmin() then
        table.insert( tMenu, { name = GSmartWatch.Lang[ "Add public POI" ], func = function()
            dBase.RunningApp.dSubMenu:Remove()
            dBase.RunningApp.dSubMenu = GSmartWatch:DrawTextEntry( dBase.RunningApp, 18, GSmartWatch.Lang[ "Type POI name" ], color_black, function( sValue )
                if ( sValue == "" ) or not dBase.RunningApp.dSubMenu or not IsValid( dBase.RunningApp.dSubMenu ) then
                    return
                end

                dBase.RunningApp.dSubMenu:Remove()

                dBase.RunningApp.dSubMenu = GSmartWatch:DrawColorScroller( dBase.RunningApp, tPOIColors, 0, color_black, function( tColor )
                    local tIcons = {}

                    for k, v in ipairs( tPOIIcons ) do
                        if ( type( v ) ~= "IMaterial" ) then
                            continue
                        end

                        tIcons[ k ] = { icon = v, iconColor = tColor, func = function()
                            local tSubMenu = {
                                [ 1 ] = { name = string.format( GSmartWatch.Lang[ "Save %s?" ], sValue ), func = function()
                                    local tColor = ( tColor and IsColor( tColor ) ) and tColor or tPOIColors[ 1 ]
                                    local sColor = table.ToString( tColor )

                                    net.Start( "GSmartWatchNW" )
                                        net.WriteUInt( 4, 3 )
                                        net.WriteString( sValue )
                                        net.WriteColor( tColor )
                                        net.WriteUInt( k, 8 )
                                    net.SendToServer()

                                    Maps:DestroyMenu( dBase )
                                end },
                                [ 2 ] = { name = GSmartWatch.Lang[ "Cancel" ], func = function()
                                    Maps:DestroyMenu( dBase )
                                    GSmartWatch:Notify( GSmartWatch.Lang[ "Action canceled" ] )
                                end }
                            }

                            dBase.RunningApp.dSubMenu:Remove()
                            dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tSubMenu, 0, GSmartWatch.Lang[ "Add POI" ], color_black )
                        end }
                    end

                    dBase.RunningApp.dSubMenu:Remove()
                    dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tIcons, 0, GSmartWatch.Lang[ "Choose icon" ], color_black, ( dBase:GetTall() * .16 ) )
                end )
            end )

            Maps.iSubMenu = 5
        end } )
    end

    if dBase.RunningApp then
        dBase.RunningApp.dSubMenu = GSmartWatch:DrawScroller( dBase.RunningApp, tMenu, ( Maps.iSubMenu or 1 ) - 1, GSmartWatch.Lang.Apps[ "Maps" ], color_black )
        dBase.RunningApp.dSubMenu.bFirstLayer = true
    end
end

--[[

    Maps:DestroyMenu

]]--

function Maps:DestroyMenu( dBase, bRebuild )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if dBase.RunningApp and dBase.RunningApp.dSubMenu and IsValid( dBase.RunningApp.dSubMenu ) then
        dBase.RunningApp.dSubMenu:Remove()
        dBase.RunningApp.dSubMenu = nil
    end

    if bRebuild then
        Maps:BuildMenu( dBase )
    end
end

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local iMaxImgH = 2048

    local matCurMap = ( Maps.matCurMap or false )
    local iMapSize = ( Maps.iMapSize or false )

    if not Maps.matCurMap or not Maps.iMapSize then
        matCurMap, iMapSize = Maps:CreateMat( iMaxImgH )
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )
    dBase.RunningApp.iImgH = ( Maps.iZoom * iMaxImgH )
    dBase.RunningApp.iImgMaxH = iMaxImgH

    local fLerpSize = dBase.RunningApp.iImgMaxH
    local fLerpZoom = ( Maps.iZoom or 0 )
    local fLerpZoomX = 0
    local fLerpWaypointH = 0
    local fLerpCloudAlpha = 0

    local iRad = ( dBase.RunningApp:GetTall() * .5 )

    Maps.fZBarX = 0
    Maps.iSubMenu = nil

    --[[

        dBase.RunningApp:Paint

    ]]--

    function dBase.RunningApp:Paint( iW, iH )
        if not matCurMap then
            return 
        end

        local tPos = LocalPlayer():GetPos()
        local tAng = LocalPlayer():GetAngles()

        local tWP = Maps.tWaypoint
        local sDest = Maps.sDestination

        local iR = ( tAng[ 2 ] - 90 )
        local iTX, iTY = iRad, ( iH * .73 )
        local iX = ( ( tPos.x / iMapSize ) * fLerpSize )
        local iY = ( ( tPos.y / iMapSize ) * fLerpSize )

        fLerpSize = Lerp( RealFrameTime() * 2, fLerpSize, self.iImgH )
        fLerpZoomX = Lerp( RealFrameTime() * 6, fLerpZoomX, ( Maps.fZBarX or 0 ) )

        GSmartWatch:SetStencil()

        -- Map draw
        draw.RoundedBox( 0, 0, 0, iW, iH, tBgColor )

    	surface.SetDrawColor( color_white )
	    surface.SetMaterial( matCurMap )
	    surface.DrawTexturedRectRotated( ( iRad - iX ), ( iRad + iY ), fLerpSize, fLerpSize, 0 )

        -- POI Visibility
        Maps:DrawPOIs( Maps.iPOIVisibility, fLerpSize, iX, iY, iW, iH )

        -- Vehicle
        if GSmartWatch.VehicleData and GSmartWatch.VehicleData.pos then
            Maps:DrawVehicle( iX, iY, iW, iH, fLerpSize )
        end

        -- Waypoint
        if tWP then
            local sDist = GSmartWatch.Lang[ "You've arrived" ]

            local fDist = tWP:Distance( tPos )
            local tAngles = ( tWP - tPos ):Angle()

            local iDistX, iDistY = iRad, ( iTY + 52 )
            local iWayPointX, iWayPointY = Maps:TranslateVector( tWP.x, tWP.y, fLerpSize, iX, iY )

            if ( fDist > 400 ) then
                sDist = math.floor( fDist / 60 )  .. "m"
                self.bArrived = nil
            else
                if not self.bArrived then
                    hook.Run( "GSmartWatch_OnWaypointArrival", sDest, tWP )
                end

                self.bArrived = true
            end

            if Maps:IsPointOutOfCircle( ( iRad * 1.1 ), iWayPointX, iWayPointY ) then
                fLerpWaypointH = Lerp( RealFrameTime() * 4, fLerpWaypointH, ( iH * .97 ) )

                self.bInCircle = nil                    
            else
                iDistX, iDistY = iRad - iWayPointX, iRad - iWayPointY + ( iH * .15 )
                iTX, iTY = iRad - iWayPointX, iRad - iWayPointY - ( iH * .16 )

                fLerpWaypointH = Lerp( RealFrameTime() * 4, fLerpWaypointH, 0 )

                if not self.bInCircle then
                    GSmartWatch:Play2DSound( "gsmartwatch/ui/keypress_standard.mp3" )
                end

                self.bInCircle = true
            end

            if ( fLerpWaypointH > 1 ) then
                GSmartWatch:DrawMatShadow( matWaypoint, iRad, iRad, fLerpWaypointH, fLerpWaypointH, Maps.tPOIColor, 0, 6, ( tAngles[ 2 ] - 90 ) )
            end

            GSmartWatch:DrawTextShadow( sDist, "GSmartWatch.48", iDistX, iDistY, GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )

            if Maps.matPOIIcon then
                GSmartWatch:DrawMatShadow( Maps.matPOIIcon, iRad - iWayPointX, iRad - iWayPointY, ( iH * .16 ), ( iH * .16 ), Maps.tPOIColor, 0, 6 )
            end
        end

        -- Waypoint name
        if sDest and not self.bArrived then
            surface.SetFont( "GSmartWatch.32" )
            local iDestW, iDestH = surface.GetTextSize( sDest )

            if Maps.tPOIColor then
                draw.RoundedBox( ( iDestH * .5 ), iTX - ( iDestW * .5 ) - 15 - 2, iTY - ( iDestH * .5 ) - 2, ( iDestW + 30 ) + 4, iDestH + 4, Maps.tPOIColor )
            end

            draw.RoundedBox( ( iDestH * .5 ), iTX - ( iDestW * .5 ) - 15, iTY - ( iDestH * .5 ), ( iDestW + 30 ), iDestH, ColorAlpha( color_black, 250 ) )
            draw.SimpleText( sDest, "GSmartWatch.32", iTX, iTY, color_white, 1, 1 )
        end

        -- Player
        GSmartWatch:DrawMatShadow( matArrow, iRad, iRad, ( iH * .16 ), ( iH * .16 ), tColor, 0, 6, iR )

        -- Clouds
        local bShowClouds = ( fLerpSize < 1200 ) -- and not LocalPlayer():IsCoveredByMap()

        fLerpCloudAlpha = Lerp( RealFrameTime() * ( bShowClouds and 1 or 12 ), fLerpCloudAlpha, ( bShowClouds and 100 or 0 ) )

        Maps:DrawClouds( iW, iH, fLerpCloudAlpha )

        -- Zoom bar
        if ( fLerpZoomX > 5 ) then
            fLerpZoom = Lerp( RealFrameTime() * 6, fLerpZoom, Maps.iZoom )

            Maps:DrawZoomBar( iW, iH, fLerpZoom, fLerpZoomX )
        end

        render.SetStencilEnable( false )
    end

    if not matCurMap then
        GSmartWatch:PaintError( dBase.RunningApp, "" )
    end

    if not GSmartWatch.MyPOIs or table.IsEmpty( GSmartWatch.MyPOIs ) then
        if file.Exists( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", "DATA" ) then
            local sSavedPOIs = file.Read( "gsmartwatch/mypois/" .. game.GetMap() .. ".txt", "DATA" )
            GSmartWatch.MyPOIs = util.JSONToTable( sSavedPOIs )
            
            return
        end

        GSmartWatch.MyPOIs = {}
    end
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    if not dBase or not IsValid( dBase ) or not dBase.RunningApp or not IsValid( dBase.RunningApp ) then
        return
    end

    local dParent = dBase.RunningApp

    if ( sBind == "invnext" ) then
        if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
            dParent.dSubMenu:SelectNeighbour( true )
        else
            if dParent.iImgH then
                Maps:Zoom( dParent, true )
            end
        end

    elseif ( sBind == "invprev" ) then
        if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
            dParent.dSubMenu:SelectNeighbour()
        else
            if dParent.iImgH then
                Maps:Zoom( dParent )
            end
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
        else
            Maps:BuildMenu( dBase )
        end
    
    elseif ( sBind == "+attack2" ) then
        if dParent.dSubMenu and IsValid( dParent.dSubMenu ) then
            if dParent.dSubMenu.bFirstLayer then
                dParent.dSubMenu:Remove()
                dParent.dSubMenu = nil
            else
                dParent.dSubMenu:Remove()
                Maps:BuildMenu( dBase, Maps.iSubMenu )
            end
        else
            GSmartWatch:RunApp( "app_myapps" )
        end
    end
end

--[[

    GSWApp.OnShutdown

]]--

function GSWApp.OnShutdown()
    if timer.Exists( "GSmartWatch_MapZoom" ) then
        timer.Remove( "GSmartWatch_MapZoom" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil