if GSmartWatch.Cfg.DisabledApps[ "app_compass" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_compass"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Compass" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/compass.png", "smooth" )

local matCompass = Material( "materials/gsmartwatch/compass_bg.png", "smooth" )

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    local fLerp = 0

    function dBase.RunningApp:Paint( iW, iH )
        local iRX = math.ceil( 180 - LocalPlayer():GetAngles().y )
        local tPos = LocalPlayer():GetPos()

        fLerp = Lerp( RealFrameTime() * 8, fLerp, ( iH * .9 ) )

        GSmartWatch:SetStencil()
    
        surface.SetDrawColor( color_white )
        surface.SetMaterial( matCompass )
        surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .5 ), fLerp, fLerp, iRX )

        render.SetStencilEnable( false )

        draw.SimpleText( iRX .. "°", "GSmartWatch.48", ( iW * .5 ), ( iH * .5 ) - 90, GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
        draw.SimpleText( math.floor( tPos.x / 500 ) .. " S", "GSmartWatch.64", ( iW * .5 ), ( iH * .5 ) - 20, color_white, 1, 1 )
        draw.SimpleText( - math.floor( tPos.y / 500 ) .. " W", "GSmartWatch.64", ( iW * .5 ), ( iH * .5 ) + 20, color_white, 1, 1 )
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