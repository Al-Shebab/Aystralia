local GSWApp = {}

GSWApp.ID = "app_boot"
GSWApp.IsInvisible = true

local matLogo = Material( "materials/gsmartwatch/gsmartwatch_logo.png", "smooth" )

--[[

    bootWatch

]]--

local function bootWatch( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    local iW, iH = dBase:GetWide(), dBase:GetTall()
    local iRad = ( dBase.RunningApp:GetTall() * .5 )

    local fLerpAlpha = 0
    local fLerpScale = 0
    local fLerpAnimScale = 0
    local fLerpAnimX = iW
    local fLerpBarY = iW

    local tApps = {}
    local iApp = 0

    for k, v in pairs( GSmartWatch:GetApps() ) do
        if v.IsInvisible or not v.Icon or GSmartWatch.Cfg.DisabledApps[ k ] then
            continue
        end

        iApp = ( iApp + 1 )

        tApps[ iApp ] = {
            matIcon = v.Icon,
            tSpline = {}
        }

        for i = 1, 12 do
            tApps[ iApp ].tSpline[ i ] = Vector( math.random( ( iW * .2 ), iW ), math.random( 0, iH ), 0 )
        end
    end

    -- GSmartWatch_Boot
    local iBootTime = ( GSmartWatch.Cfg.BootTime > 30 ) and 30 or GSmartWatch.Cfg.BootTime

    if not timer.Exists( "GSmartWatch_Boot" ) then
        timer.Create( "GSmartWatch_Boot", GSmartWatch.Cfg.BootTime, 1, function()
            if not dBase or not IsValid( dBase ) or not dBase.RunningApp then
                return
            end

            if ( GSmartWatch:GetActiveApp() ~= "app_boot" ) then
                return
            end

            dBase.RunningApp.bEndAnim = true
        end )
    end

    function dBase.RunningApp:Paint( iW, iH )
        local iTime = timer.TimeLeft( "GSmartWatch_Boot" )

        if self.bEndAnim or not iTime then
            fLerpAlpha = Lerp( RealFrameTime() * 6, fLerpAlpha, 0 )
            fLerpScale = Lerp( RealFrameTime() * 6, fLerpScale, 0 )
            fLerpAnimX = Lerp( RealFrameTime() * 2, fLerpAnimX, -( iRad * 1.6 ) )

            if ( fLerpScale < 1 ) then
                GSmartWatch:Play2DSound( "gsmartwatch/ui/unlock.mp3" )
                GSmartWatch:RunApp( "app_watch" )

                return
            end
        else
            fLerpAlpha = Lerp( RealFrameTime() * 2, fLerpAlpha, 255 )
            fLerpScale = Lerp( RealFrameTime() * 4, fLerpScale, ( iH * .9 ) )
            fLerpAnimX = Lerp( RealFrameTime() * 4, fLerpAnimX, ( iTime * iRad ) / iBootTime )
        end

        if ( fLerpScale > ( iH * .7 ) ) then
            self.bBack = true
            fLerpAnimScale = Lerp( RealFrameTime() * 2, fLerpAnimScale, 1.7 )
        end

        GSmartWatch:SetStencil()

        for k, v in ipairs( tApps ) do
            local tPos = math.BSplinePoint( math.sin( CurTime() ) / 32, v.tSpline, .5 )
            local fDist = Vector( iRad, iRad, 0 ):Distance( tPos ) * .3

            surface.SetDrawColor( GSmartWatch:DarkenColor( color_white, 20 ) )
            surface.SetMaterial( v.matIcon )
            surface.DrawTexturedRectRotated( tPos[ 1 ] - fLerpAnimX, tPos[ 2 ], ( iH * .16 ) - fDist, ( iH * .16 ) - fDist, 0 )
        end

        GSmartWatch:DrawMatShadow( matLogo, iRad + 5, iRad - 10, fLerpScale, fLerpScale, ColorAlpha( color_white, fLerpAlpha ), 0, 6 )

        if iTime then
            local iProgress = ( iBootTime - iTime ) * ( iW * .5 ) / iBootTime
            local iLoadBarW = ( iProgress < 0 ) and 0 or iProgress

            fLerpBarY = Lerp( RealFrameTime() * 6, fLerpBarY, ( iH * .62 ) )

	    	draw.RoundedBox( 3, ( iW * .25 ), fLerpBarY, ( iW * .5 ), 6, GSmartWatch.Cfg.Colors[ 1 ] )
    		draw.RoundedBox( 3, ( iW * .25 ), fLerpBarY, iLoadBarW, 6, GSmartWatch.Cfg.Colors[ 5 ] )
        end

        render.SetStencilEnable( false )
    end
end

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if timer.Exists( "GSmartWatch_Boot" ) then
        bootWatch( dBase )
        return
    end

    if not GSmartWatch.Cfg.BootTime or ( GSmartWatch.Cfg.BootTime <= 0 ) then
        GSmartWatch:RunApp( "app_watch" )
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    GSmartWatch:PaintError( dBase.RunningApp )

    timer.Simple( 1, function()
        if dBase and IsValid( dBase ) then
            if dBase.RunningApp and IsValid( dBase.RunningApp ) then
                dBase.RunningApp:Remove()
            end

            bootWatch( dBase )
        end
    end )
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil