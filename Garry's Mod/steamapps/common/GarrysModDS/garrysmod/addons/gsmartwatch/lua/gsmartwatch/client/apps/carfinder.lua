if GSmartWatch.Cfg.DisabledApps[ "app_carfinder" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_carfinder"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Car Finder" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/carfinder.png", "smooth" )
GSWApp.ShowTime = true

local matArrow = Material( "materials/gsmartwatch/arrow.png", "smooth" )
local matFlag = Material( "materials/gsmartwatch/flag.png", "smooth" )
local matUpdate = Material( "materials/gsmartwatch/update.png", "smooth" )

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    function dBase.RunningApp:ReturnError()
        self.Paint = nil
        GSmartWatch:PaintError( dBase.RunningApp, GSmartWatch.Lang[ "No vehicle linked" ] )
    end

    local tVehicle = ( GSmartWatch.VehicleData and table.Copy( GSmartWatch.VehicleData ) or false )

    if not tVehicle or table.IsEmpty( tVehicle ) then
        return dBase.RunningApp:ReturnError()
    end

    tVehicle.name = ( ( tVehicle.name and isstring( tVehicle.name ) ) and tVehicle.name or "Vehicle" )
    if ( string.len( tVehicle.name ) > 12 ) then
        tVehicle.name = string.sub( tVehicle.name, 0, 12 ) .. "..."
    end

    -- L² Plates
    if tVehicle.entity and IsValid( tVehicle.entity ) then
        local sPlate = tVehicle.entity:GetNWString( "ll_plate" )

        tVehicle.licenseplate = ( sPlate and ( sPlate ~= "" ) ) and string.upper( sPlate ) or false
    end

    local fLerp = 0

    function dBase.RunningApp:Paint( iW, iH )
        if not GSmartWatch.VehicleData then
            return self:ReturnError()
        end

        local iDist = math.floor( LocalPlayer():GetPos():Distance( GSmartWatch.VehicleData.pos ) / 60 )

        GSmartWatch:SetStencil()

        if ( iDist > 3 ) then
            local tAngles = ( GSmartWatch.VehicleData.pos - LocalPlayer():GetShootPos() ):Angle()
            local tAim = LocalPlayer():GetAimVector():Angle()

            fLerp = Lerp( RealFrameTime() * 4, fLerp, ( iH * .16 ) )

            surface.SetDrawColor( 52, 152, 219 )
            surface.SetMaterial( matArrow )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .52 ), fLerp, fLerp, ( tAngles.y - tAim.y ) )

            draw.SimpleText( tVehicle.name, "GSmartWatch.64", ( iW * .5 ), ( iH * .25 ), color_white, 1, 1 )

            if tVehicle.licenseplate then
                draw.SimpleText( tVehicle.licenseplate, "GSmartWatch.32", ( iW * .5 ), ( iH * .34 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
                draw.SimpleText( iDist  .. "m", "GSmartWatch.48", ( iW * .65 ), ( iH * .52 ), GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )
            else
                draw.SimpleText( iDist  .. "m", "GSmartWatch.48", ( iW * .5 ), ( iH * .34 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
            end

            surface.SetDrawColor( color_white )
            surface.SetMaterial( matUpdate )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .72 ), ( iH * .08 ), ( iH * .08 ), 0 )

            draw.SimpleText( string.format( GSmartWatch.Lang[ "%s s. ago" ], math.floor( CurTime() - GSmartWatch.VehicleData.lastUpdate ) ), "GSmartWatch.48", ( iW * .5 ), ( iH * .82 ), GSmartWatch.Cfg.Colors[ 3 ], 1, 1 )
        else
            fLerp = 0

            surface.SetDrawColor( color_white )
            surface.SetMaterial( matFlag )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .45 ), ( iH * .2 ), ( iH * .2 ), 0 )

            draw.SimpleText( GSmartWatch.Lang[ "You've arrived" ], "GSmartWatch.48", ( iW * .5 ), ( iH * .64 ), color_white, 1, 1 )
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