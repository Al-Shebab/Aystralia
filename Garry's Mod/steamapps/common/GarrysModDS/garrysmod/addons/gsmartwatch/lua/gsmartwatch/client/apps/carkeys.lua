if GSmartWatch.Cfg.DisabledApps[ "app_carkeys" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_carkeys"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Car Keys" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/carkeys.png", "smooth" )
GSWApp.ShowTime = true

local matLock = Material( "materials/gsmartwatch/lock.png", "smooth" )
local matUnlock = Material( "materials/gsmartwatch/unlock.png", "smooth" )

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
        return GSmartWatch:PaintError( dBase.RunningApp, GSmartWatch.Lang[ "No vehicle linked" ] )
    end

    dBase.RunningApp.fLerpBtnL, dBase.RunningApp.fLerpBtnR = 80, 0
    dBase.RunningApp.fLerpBtnL2, dBase.RunningApp.fLerpBtnR2 = 80, 0

    tVehicle.name = ( tVehicle.name or GSmartWatch.Lang[ "Vehicle" ] )
    if ( string.len( tVehicle.name ) > 12 ) then
        tVehicle.name = string.sub( tVehicle.name, 0, 12 ) .. "..."
    end

    -- L² Plates
    if tVehicle.entity and IsValid( tVehicle.entity ) then
        local sPlate = tVehicle.entity:GetNWString( "ll_plate" )

        tVehicle.licenseplate = ( sPlate and ( sPlate ~= "" ) ) and string.upper( sPlate ) or false
    end

    function dBase.RunningApp:Paint( iW, iH )
        if not GSmartWatch.VehicleData then
            return self:ReturnError()
        end

        local iDist = LocalPlayer():GetPos():Distance( GSmartWatch.VehicleData.pos )
        local bInRange = ( iDist < GSmartWatch.Cfg.CarKeyDistance )
        local sText = ( bInRange and GSmartWatch.Lang[ "Within range" ] or GSmartWatch.Lang[ "Too far" ] )

        GSmartWatch:SetStencil()
    
        self.fLerpBtnL, self.fLerpBtnL2 = Lerp( RealFrameTime() * 6, self.fLerpBtnL, 80 ), Lerp( RealFrameTime() * 6, self.fLerpBtnL2, 0 )
        self.fLerpBtnR, self.fLerpBtnR2 = Lerp( RealFrameTime() * 6, self.fLerpBtnR, 80 ), Lerp( RealFrameTime() * 6, self.fLerpBtnR2, 0 )

        if tVehicle.licenseplate then
            draw.SimpleText( tVehicle.name, "GSmartWatch.64", ( iW * .5 ), ( iH * .32 ), color_white, 1, 1 )
            draw.SimpleText( tVehicle.licenseplate, "GSmartWatch.32", ( iW * .5 ), ( iH * .42 ), color_white, 1, 1 )
        else
            draw.SimpleText( tVehicle.name, "GSmartWatch.64", ( iW * .5 ), ( iH * .42 ), color_white, 1, 1 )
        end

        draw.SimpleText( "[" .. sText .. "]", "GSmartWatch.48", ( iW * .5 ), ( iH * .54 ), ( bInRange and color_white or GSmartWatch.Cfg.Colors[ 3 ] ), 1, 1 )

        surface.SetDrawColor( ColorAlpha( bInRange and color_white or GSmartWatch.Cfg.Colors[ 3 ], self.fLerpBtnL ) )
        surface.SetMaterial( matLock )
        surface.DrawTexturedRectRotated( ( iW * .35 ), ( iH * .75 ), ( iH * .16 ) + self.fLerpBtnL2, ( iH * .16 ) + self.fLerpBtnL2, 0 )

        surface.SetDrawColor( ColorAlpha( bInRange and color_white or GSmartWatch.Cfg.Colors[ 3 ], self.fLerpBtnR ) )
        surface.SetMaterial( matUnlock )
        surface.DrawTexturedRectRotated( ( iW * .65 ), ( iH * .75 ), ( iH * .16 ) + self.fLerpBtnR2, ( iH * .16 ) + self.fLerpBtnR2, 0 )

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

    if not ( ( sBind == "+attack" ) or ( sBind == "+attack2" ) ) then
        return
    end

    local bInRange = false
    if GSmartWatch.VehicleData and GSmartWatch.VehicleData.pos then
        local iDist = LocalPlayer():GetPos():Distance( GSmartWatch.VehicleData.pos )
        bInRange = ( iDist < GSmartWatch.Cfg.CarKeyDistance )
    end

    if ( sBind == "+attack" ) then
        dBase.RunningApp.fLerpBtnL, dBase.RunningApp.fLerpBtnL2 = 255, 10

    elseif ( sBind == "+attack2" ) then
        if not GSmartWatch.VehicleData or not GSmartWatch.VehicleData.pos then
            return GSmartWatch:RunApp( "app_myapps" )
        end

        dBase.RunningApp.fLerpBtnR, dBase.RunningApp.fLerpBtnR2 = 255, 10
    end

    if bInRange then
        net.Start( "GSmartWatchNW" )
            net.WriteUInt( 2, 3 )
            net.WriteUInt( ( sBind == "+attack" ) and 0 or 1, 2 )
        net.SendToServer()
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil