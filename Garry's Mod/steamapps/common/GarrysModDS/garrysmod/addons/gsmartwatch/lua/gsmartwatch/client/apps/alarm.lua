if GSmartWatch.Cfg.DisabledApps[ "app_alarm" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_alarm"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Alarm" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/alarm.png", "smooth" )
GSWApp.ShowTime = true

local matPlay = Material( "materials/gsmartwatch/play.png", "smooth" )
local matClear = Material( "materials/gsmartwatch/clear.png", "smooth" )

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )
    dBase.RunningApp.bAlarmIsRunning = ( timer.Exists( "GSmartWatch_AlarmTimer" ) and true or false )
    dBase.RunningApp.sName = GSmartWatch.Lang.Apps[ "Alarm" ]
    dBase.RunningApp.AlarmTime = 0
    dBase.RunningApp.fLerp = 0

    function dBase.RunningApp:Paint( iW, iH )
        self.fLerp = Lerp( RealFrameTime() * 6, self.fLerp, 0 )

        GSmartWatch:SetStencil()

        draw.SimpleText( self.sName,  "GSmartWatch.32", ( iW * .5 ), ( iH * .3 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
        surface.SetDrawColor( color_white )

        if self.bAlarmIsRunning then
            draw.SimpleText( os.date( "%M:%S", timer.TimeLeft( "GSmartWatch_AlarmTimer" ) ), "GSmartWatch.128", ( iW * .5 ), ( iH * .5 ), color_white, 1, 1 )
            surface.SetMaterial( matClear )
        else
            draw.SimpleText( os.date( "%M:%S", dBase.RunningApp.AlarmTime ), "GSmartWatch.128", ( iW * .5 ), ( iH * .5 ), color_white, 1, 1 )
            surface.SetMaterial( matPlay )
        end

        surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .75 ), ( iH * .17 ) + self.fLerp, ( iH * .17 ) + self.fLerp, 0 )

        render.SetStencilEnable( false )
    end
end

--[[

    GSWApp.OnUse

]]--

function GSWApp.OnUse( dBase, sBind )
    if not dBase or not IsValid( dBase ) or not dBase.RunningApp then
        return
    end

    if ( sBind == "invnext" ) then
        if dBase.RunningApp.bAlarmIsRunning or not dBase.RunningApp.AlarmTime then
            return
        end

        local iTime = ( dBase.RunningApp.AlarmTime - 10 )
        if ( iTime < 0 ) then
            iTime = 3590
        end

        dBase.RunningApp.AlarmTime = iTime

    elseif ( sBind == "invprev" ) then
        if dBase.RunningApp.bAlarmIsRunning or not dBase.RunningApp.AlarmTime then
            return
        end

        local iTime = ( dBase.RunningApp.AlarmTime + 10 )
        if ( iTime >= 3600 ) then
            iTime = 0
        end

        dBase.RunningApp.AlarmTime = iTime

    elseif ( sBind == "+attack" ) then
        if dBase.RunningApp.bAlarmIsRunning then
            timer.Remove( "GSmartWatch_AlarmTimer" )

            dBase.RunningApp.fLerp = 10
            dBase.RunningApp.AlarmTime = 0
            dBase.RunningApp.bAlarmIsRunning = nil

            GSmartWatch:Notify( GSmartWatch.Lang[ "Alarm stopped" ] )
        else
            if not dBase.RunningApp.AlarmTime or ( dBase.RunningApp.AlarmTime <= 0 ) then
                return GSmartWatch:Notify( GSmartWatch.Lang[ "Set a duration" ], 3 )
            end

            dBase.RunningApp.fLerp = 10
            dBase.RunningApp.bAlarmIsRunning = true
            dBase.RunningApp.AlarmTime = ( dBase.RunningApp.AlarmTime or 10 )
            if ( dBase.RunningApp.AlarmTime <= 0 ) then
                dBase.RunningApp.AlarmTime = 10
            end

            timer.Remove( "GSmartWatch_AlarmTimer" )
            timer.Create( "GSmartWatch_AlarmTimer", ( dBase.RunningApp.AlarmTime or 10 ), 1, function()
                if dBase and IsValid( dBase ) and dBase.RunningApp then
                    dBase.RunningApp.AlarmTime = 0
                    dBase.RunningApp.bAlarmIsRunning = nil
    
                    
                    GSmartWatch:Notify( GSmartWatch.Lang[ "Time elapsed" ], 4 )
                end

                GSmartWatch:Play2DSound( "gsmartwatch/ui/timer_alarm.mp3" )                
            end )

            GSmartWatch:Notify( GSmartWatch.Lang[ "Alarm triggered" ] )
        end

    elseif ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil