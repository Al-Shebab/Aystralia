if GSmartWatch.Cfg.HideIncompatibilities and not StormFox then
    return
end

if GSmartWatch.Cfg.DisabledApps[ "app_weather" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_weather"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Weather" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/weather.png", "smooth" )
GSWApp.ShowTime = true

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    if not StormFox then
        return GSmartWatch:PaintError( dBase.RunningApp, GSmartWatch.Lang[ "No weather data" ] )
    end

    local iTemperature = math.Round( StormFox.GetTemperature() ) 
    local sTemperature = iTemperature .. "°C"
    local sWeather = StormFox.GetWeather()
    local matWeather = StormFox.WeatherType:GetIcon( iTemperature )

    function dBase.RunningApp:Paint( iW, iH )
        GSmartWatch:SetStencil()
        draw.RoundedBox( 0, 0, 0, iW, iH, color_black )
        render.SetStencilEnable( false )

        draw.SimpleText( sTemperature, "GSmartWatch.96", ( iW * .5 ), ( iH * .35 ), color_white, 1, 1 )
        draw.SimpleText( sWeather, "GSmartWatch.64", ( iW * .5 ), ( iH * .6 ), color_white, 1, 1 )

        if matWeather then
            surface.SetDrawColor( color_white )
            surface.SetMaterial( matWeather )
            surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .75 ), ( iH * .1 ), ( iH * .1 ), 0 )
        end
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