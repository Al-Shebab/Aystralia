if GSmartWatch.Cfg.DisabledApps[ "app_stopwatch" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_stopwatch"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Stopwatch" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/stopwatch.png", "smooth" )
GSWApp.ShowTime = true

local matPlay = Material( "materials/gsmartwatch/play.png", "smooth" )
local matPause = Material( "materials/gsmartwatch/pause.png", "smooth" )
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
    dBase.RunningApp.sName = GSmartWatch.Lang.Apps[ "Stopwatch" ]

    dBase.RunningApp.fLerpPlay, dBase.RunningApp.fLerpPlay2 = 80, 0
    dBase.RunningApp.fLerpReset, dBase.RunningApp.fLerpReset2 = 80, 0

    GSmartWatch.StopWatchTime = ( GSmartWatch.StopWatchTime or 0 )

    function dBase.RunningApp:Paint( iW, iH )
        self.fLerpPlay = GSmartWatch.IsStopwatchActive and 255 or Lerp( RealFrameTime() * 6, self.fLerpPlay, 80 )
        self.fLerpPlay2 = Lerp( RealFrameTime() * 6, self.fLerpPlay2, 0 )

        self.fLerpReset = Lerp( RealFrameTime() * 6, self.fLerpReset, 80 )
        self.fLerpReset2 = Lerp( RealFrameTime() * 6, self.fLerpReset2, 0 )

        GSmartWatch:SetStencil()

        draw.SimpleText( self.sName,  "GSmartWatch.32", ( iW * .5 ), ( iH * .3 ), GSmartWatch.Cfg.Colors[ 4 ], 1, 1 )
        draw.SimpleText( os.date( "%M:%S", GSmartWatch.StopWatchTime ),  "GSmartWatch.128", ( iW * .5 ), ( iH * .5 ), color_white, 1, 1 )

        surface.SetDrawColor( Color( 255, 255, 255, self.fLerpPlay ) )
        surface.SetMaterial( GSmartWatch.IsStopwatchActive and matPause or matPlay )
        surface.DrawTexturedRectRotated( ( iW * .35 ), ( iH * .75 ), ( iH * .16 ) + self.fLerpPlay2, ( iH * .16 ) + self.fLerpPlay2, 0 )

        surface.SetDrawColor( Color( 255, 255, 255, self.fLerpReset ) )
        surface.SetMaterial( matClear )
        surface.DrawTexturedRectRotated( ( iW * .65 ), ( iH * .75 ), ( iH * .16 ) + self.fLerpReset2, ( iH * .16 ) + self.fLerpReset2, 0 )

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

    if ( sBind == "+attack" ) then
        dBase.RunningApp.fLerpPlay, dBase.RunningApp.fLerpPlay2 = 255, 10

        if GSmartWatch.IsStopwatchActive then            
            GSmartWatch.IsStopwatchActive = nil
        else
            GSmartWatch.IsStopwatchActive = true

            local delay = 1
            local lastOccurance = -delay

            hook.Add( "Think", "GSmartWatch_StopWatchThink", function()
                if not GSmartWatch.IsStopwatchActive then
                    hook.Remove( "Think", "GSmartWatch_StopWatchThink" )
                end

                local timeElapsed = ( CurTime() - lastOccurance )

                if ( timeElapsed > delay ) then
                    GSmartWatch.StopWatchTime = ( ( GSmartWatch.StopWatchTime or 0 ) + 1 )
                    lastOccurance = CurTime()
                end
            end )
        end

    elseif ( sBind == "+attack2" ) then
        dBase.RunningApp.fLerpReset, dBase.RunningApp.fLerpReset2 = 255, 10
        GSmartWatch.StopWatchTime = 0

        hook.Remove( "Think", "GSmartWatch_StopWatchThink" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil