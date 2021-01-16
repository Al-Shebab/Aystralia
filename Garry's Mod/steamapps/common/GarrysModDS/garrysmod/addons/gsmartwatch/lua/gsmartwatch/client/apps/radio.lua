if GSmartWatch.Cfg.DisabledApps[ "app_radio" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_radio"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Radio" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/radio.png", "smooth" )

local matLoading = Material( "materials/gsmartwatch/loading.png", "smooth" )
local matMusic = Material( "materials/gsmartwatch/mapico/music.png", "smooth" )
local matGradient = Material( "vgui/gradient-d" )

local matStation = false
local fScrollX = false

local Radio = {}

Radio.iVolume = .5
Radio.iVolumeMax = 1

--[[

    Radio:SetVolume

]]--

function Radio:SetVolume( iVolume )
    local iVolume = ( iVolume or 1 )

    if ( iVolume > Radio.iVolumeMax ) then
        iVolume = Radio.iVolumeMax
    elseif ( iVolume < 0 ) then
        iVolume = 0
    end

    self.iVolume = iVolume

    if self.iAudioChannel and ( type( self.iAudioChannel ) == "IGModAudioChannel" ) then
        self.iAudioChannel:SetVolume( iVolume )
    end
end

--[[

    Radio:GetVolume

]]--

function Radio:GetVolume()
    return self.iVolume
end

--[[

    GSmartWatch:GetRadioStation

]]--

function GSmartWatch:GetRadioStation()
    return ( Radio.iStation or 1 )
end

--[[

    GSmartWatch:IsRadioPlaying

]]--

function GSmartWatch:IsRadioPlaying()
    return ( Radio.bPlaying and not Radio.bSearchingStation )
end

--[[

    Radio:Stop

]]--

function Radio:Stop()
    if self.iAudioChannel and type( self.iAudioChannel == "IGModAudioChannel" ) then
        self.iAudioChannel:Stop()
    end

    self.iAudioChannel = nil
    self.bPlaying = nil
    self.bSearchingStation = nil
end

--[[

    Radio:Play

]]--

function Radio:Play( dBase )
    if not self.iStation or not GSmartWatch.Cfg.RadioStations[ self.iStation ] then
        return
    end

    Radio:Stop()

    self.bSearchingStation = true

    sound.PlayURL( GSmartWatch.Cfg.RadioStations[ self.iStation ].url, "", function( iSoundChannel )
    	if iSoundChannel and IsValid( iSoundChannel ) then
            Radio:Stop()
    
	    	iSoundChannel:SetPos( LocalPlayer():GetPos() )
    		iSoundChannel:Play()
            iSoundChannel:SetVolume( Radio.iVolume )

            Radio.iAudioChannel = iSoundChannel
            Radio.bPlaying = true
            Radio.bSearchingStation = nil
        else
            Radio:Play( dBase )
    	end
    end )
end

--[[

    Radio:SetStation

]]--

function Radio:SetStation( iStation, dBase )
    local iStation = ( iStation or 1 )

    if not iStation or not GSmartWatch.Cfg.RadioStations[ iStation ] then
        iStation = 1
    end

    self.iStation = iStation

    if not dBase or not IsValid( dBase ) then
        return
    end

    Radio:Play( dBase )

    if not dBase.dStationImage or not IsValid( dBase.dStationImage ) then
        dBase.dStationImage = vgui.Create( "DHTML", dBase )
        dBase.dStationImage:Dock( FILL )
        dBase.dStationImage:SetMouseInputEnabled( false )
    end

    dBase.dStationImage:SetHTML( "<style> body, html { height: 454; margin: 0; } .icon { background-image: url(" .. GSmartWatch.Cfg.RadioStations[ iStation ].image .. "); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; overflow: hidden;} </style> <body> <div class=\"icon\"></div> </body>" )

    function dBase.dStationImage:Think()
        if not dBase.bImageLoaded then
            if not self:IsLoading() then
                dBase.bImageLoaded = true

                matStation = self:GetHTMLMaterial()
            end
        end
    end

    dBase.dStationImage:SetAlpha( 0 )
end

--[[

    Radio:BuildMenu

]]--

function Radio:BuildMenu( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    local tMenu = {}

    local sRadio = false
    local iStation = GSmartWatch:GetRadioStation()

    if iStation and GSmartWatch.Cfg.RadioStations[ iStation ] then
        sRadio = GSmartWatch.Cfg.RadioStations[ iStation ].name 
    end

    table.insert( tMenu, { name = GSmartWatch.Lang[ "Stations" ], descr =  sRadio, func = function()
        local tStations = {}

        for k, v in ipairs( GSmartWatch.Cfg.RadioStations ) do
            tStations[ k ] = { name = v.name, func = function()
                Radio:SetStation( k, dBase )
                GSmartWatch:Notify( GSmartWatch.Lang[ "Now playing" ] .. ":\n" .. v.name, 1 )
            end }
        end

        dBase.dSubMenu:Remove()
        dBase.dSubMenu = GSmartWatch:DrawScroller( dBase, tStations, ( iStation or 1 ) - 1, GSmartWatch.Lang[ "Stations" ], color_black )

        Radio.iSubMenu = 1
    end } )


    table.insert( tMenu, { name = GSmartWatch.Lang[ "Turn off" ], func = function()
        if not Radio.bPlaying then
            GSmartWatch:Notify( GSmartWatch.Lang[ "Radio is already off" ] )
            return
        end

        local tChoices = {
            [ 1 ] = { name = GSmartWatch.Lang[ "Yes" ], func = function()
                Radio:Stop()

                dBase.dSubMenu:Remove()
                dBase.dSubMenu = nil

                Radio:BuildMenu( dBase )

                GSmartWatch:Notify( GSmartWatch.Lang[ "Radio stoped" ] )
            end },
            [ 2 ] = { name = GSmartWatch.Lang[ "No" ], func = function()
                dBase.dSubMenu:Remove()
                dBase.dSubMenu = nil

                Radio:BuildMenu( dBase )
            end },
        }

        dBase.dSubMenu:Remove()
        dBase.dSubMenu = GSmartWatch:DrawScroller( dBase, tChoices, 0, GSmartWatch.Lang[ "Turn off" ], color_black )

        Radio.iSubMenu = 2
    end } )

    dBase.dSubMenu = GSmartWatch:DrawScroller( dBase, tMenu, ( Radio.iSubMenu or 1 ) - 1, GSmartWatch.Lang.Apps[ "Radio" ], color_black )
    dBase.dSubMenu.bFirstLayer = true
end

--[[

    Radio:DrawSpectrum

]]--

function Radio:DrawSpectrum( iW, iH, tLerpFFT, tCol1, tCol2 )
    if Radio.iAudioChannel then
        local iFFTCount = #tLerpFFT
        local iAmp = 5000

        local tFFT = {} 
        Radio.iAudioChannel:FFT( tFFT, FFT_256 )

        for i = 1, iFFTCount do
            if not tLerpFFT[ i ] or not tFFT[ i ] then
                continue
            end

            tLerpFFT[ i ] = Lerp( RealFrameTime() * 4, tLerpFFT[ i ], tFFT[ i * math.floor( 128 / iFFTCount ) ] * iAmp )

            if tLerpFFT[ i ] > ( iH * .25 ) then
                tLerpFFT[ i ] = ( iH * .25 )
            end

            if tLerpFFT[ i - 1 ] then
                local iX, iY = ( iW / iFFTCount ) * ( i - 1 ), ( iH * .72 ) - tLerpFFT[ i ]
                local iX2, iY2 = ( iW / iFFTCount ) * ( i - 2 ), ( iH * .72 ) - tLerpFFT[ i - 1 ]

                surface.SetDrawColor( tCol1 )
                surface.DrawLine( iX, iY, iX2, iY2 )

                surface.SetDrawColor( tCol2 )
                surface.DrawLine( iX, ( iH * .72 ) + tLerpFFT[ i ] + 5, iX2, ( iH * .72 ) + tLerpFFT[ i - 1 ] + 5 )

                local tPoly = {
                    { x = iX, y = iY },
                    { x = iX2, y = iY2 },
                    { x = iX2, y = ( iH * .72 ) },
                    { x = iX, y = ( iH * .72 ) },
                }

                surface.SetDrawColor( ColorAlpha( Color( 255, 0, 0 ), 50 ) )
                draw.NoTexture()
                surface.DrawPoly( tPoly )
            end
        end
    end
end

--[[

    Radio:DrawSpectrum

]]--

function Radio:DrawSpectrum( iW, iH, tLerpFFT, tCol1, tCol2, iLerpSpeed, iAmp )
    if Radio.iAudioChannel then
        local iFFTCount = #tLerpFFT
        local iAmp = ( iAmp or 5000 )

        local tFFT = {} 
        Radio.iAudioChannel:FFT( tFFT, FFT_512 )

        for i = 1, iFFTCount do
            if not tLerpFFT[ i ] or not tFFT[ i ] then
                continue
            end

            tLerpFFT[ i ] = Lerp( RealFrameTime() * ( iLerpSpeed or 4 ), tLerpFFT[ i ], tFFT[ i * math.floor( 140 / iFFTCount ) ] * iAmp )

            if ( tLerpFFT[ i ] > ( iH * .25 ) ) then
                tLerpFFT[ i ] = ( iH * .25 )
            end

            if tLerpFFT[ i - 1 ] then
                local x, y = ( iW / ( iFFTCount - 1 ) ) * ( i - 1 ), ( iH * .72 ) - tLerpFFT[ i ] - 5
                local x2, y2 = ( iW / ( iFFTCount - 1 ) ) * ( i - 2 ), ( iH * .72 ) - tLerpFFT[ i - 1 ] - 5

                surface.SetDrawColor( tCol1 )
                surface.DrawLine( x, y, x2, y2 )

                if tCol2 then
                    surface.SetDrawColor( tCol2 )
                    surface.DrawLine( x, ( iH * .72 ) + tLerpFFT[ i ] + 5, x2, ( iH * .72 ) + tLerpFFT[ i - 1 ] + 5 )
                end
            end
        end
    end
end

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    local tLerpFFT = {}

    for i = 1, 24 do
        tLerpFFT[ i ] = 0
    end

    local tCol1, tCol2 = color_white, GSmartWatch:DarkenColor( color_white, 25 )
    local fLerpIconY = dBase:GetTall()
    local sRadio = false

    fScrollX = ( fScrollX or dBase:GetWide() )

    function dBase.RunningApp:Paint( iW, iH )
        fScrollX = ( fScrollX - .4 )
        if ( fScrollX < -( iW ) ) then
            fScrollX = iW
        end

        if Radio.iStation and GSmartWatch.Cfg.RadioStations[ Radio.iStation ] then
            sRadio = GSmartWatch.Cfg.RadioStations[ Radio.iStation ].name
        end

        GSmartWatch:SetStencil()
            if matStation and Radio.bPlaying then
                fLerpIconY = Lerp( RealFrameTime() * 6, fLerpIconY, 0 )

                draw.RoundedBox( 0, 0, 0, iW, ( iH * .7 ), ColorAlpha( tCol2, 60 ) )

                surface.SetDrawColor( tCol1 )
                surface.SetMaterial( matStation )
                surface.DrawTexturedRectRotated( ( iW * .53 ), ( iH * .52 ) - fLerpIconY, ( iW * .5 ), ( iH * .5 ), 0 )

                surface.SetDrawColor( tCol2 )
                surface.SetMaterial( matStation )
                surface.DrawTexturedRectRotated( ( iW * .53 ), ( iH * .98 ) + fLerpIconY, ( iW * .5 ), ( iH * .5 ), 0 )
            else
                fLerpIconY = iH
            end

            draw.RoundedBox( 0, 0, ( iH * .72 ), iW, ( iH * .28 ), ColorAlpha( color_black, 250 ) )

            surface.SetDrawColor( ColorAlpha( color_black, 250 ) )
            surface.SetMaterial( matGradient )
            surface.DrawTexturedRect( 0, ( iH * .32 ), iW, ( iH * .4 ) )

            Radio:DrawSpectrum( iW, iH, tLerpFFT, tCol1, tCol2 )

            if Radio.bPlaying then
                surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 4 ] )
                surface.SetMaterial( matMusic )
                surface.DrawTexturedRectRotated( fScrollX, ( iH * .85 ), ( iH * .08 ), ( iH * .08 ), 0 )

                draw.SimpleText( sRadio, "GSmartWatch.48", fScrollX + ( iH * .06 ) + 10, ( iH * .85 ), GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )
            else
                fLerpIconY = 0

		        surface.SetDrawColor( GSmartWatch.Cfg.Colors[ 5 ] )
	    	    surface.SetMaterial( matLoading )
    		    surface.DrawTexturedRectRotated( ( iW * .5 ), ( iH * .75 ), ( iH * .12 ), ( iH * .12 ), ( CurTime() * 180 ) )

                draw.RoundedBox( 0, 0, ( iH * .5 ) - 30, iW, 60, GSmartWatch.Cfg.Colors[ 0 ] )

                if Radio.bSearchingStation then
                    draw.SimpleText( string.format( GSmartWatch.Lang[ "Stream loading (%s)..." ], sRadio ), "GSmartWatch.32", fScrollX, ( iH * .5 ), GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )
                else
                    draw.SimpleText( GSmartWatch.Lang[ "Select a station" ], "GSmartWatch.32", fScrollX, ( iH * .5 ), GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )
                end
            end
        render.SetStencilEnable( false )
    end
end

function Radio:BuildVolumeUI( dBase )
    if not dBase or not IsValid( dBase ) then
        return
    end

    if dBase.dSubMenu and IsValid( dBase.dSubMenu ) and not dBase.dSubMenu.bVolumeGUI then
        dBase.dSubMenu:Remove()
    end

    dBase.dSubMenu = GSmartWatch:DrawNumWang( dBase, math.Round( Radio.iVolume * ( 100 / Radio.iVolumeMax ) / 1 ), 0, 100, 5, GSmartWatch.Lang[ "Volume" ], ColorAlpha( color_black, 250 ), function( iValue )
        if dBase and dBase.dSubMenu and IsValid( dBase.dSubMenu ) then
            dBase.dSubMenu:Remove()
            dBase.dSubMenu = nil
        end
    end, function( iValue, bNext )
        local iNewVolume = ( ( iValue * Radio.iVolumeMax ) * .01 )
        Radio:SetVolume( iNewVolume )

        if timer.Exists( "GSmartWatch_RadioVolume" ) then
            timer.Adjust( "GSmartWatch_RadioVolume", 1, 1, function()
                if dBase and dBase.dSubMenu and IsValid( dBase.dSubMenu ) and dBase.dSubMenu.bVolumeGUI then
                    dBase.dSubMenu:Remove()
                    dBase.dSubMenu = nil
                end
            end )
        else
            timer.Create( "GSmartWatch_RadioVolume", 1, 1, function()
                if dBase and dBase.dSubMenu and IsValid( dBase.dSubMenu ) and dBase.dSubMenu.bVolumeGUI then
                    dBase.dSubMenu:Remove()
                    dBase.dSubMenu = nil
                end
            end )
        end
    end )

    dBase.dSubMenu.bVolumeGUI = true
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
        else
            Radio:BuildVolumeUI( dParent )
        end

    elseif ( sBind == "invprev" ) then
        if dParent.dSubMenu and dParent.dSubMenu.SelectNeighbour then
            dParent.dSubMenu:SelectNeighbour()
        else
            Radio:BuildVolumeUI( dParent )
        end

    elseif ( sBind == "+attack" ) then
        if dParent.dSubMenu and IsValid( dParent.dSubMenu ) then
            if dParent.dSubMenu.DoClick then
                dParent.dSubMenu:DoClick()
                return
            end

            if dParent.dSubMenu.tCachedChoice and dParent.dSubMenu.tCachedChoice.func() then
                dParent.dSubMenu.tCachedChoice.func()
            end
        else
            Radio.iSubMenu = nil
            Radio:BuildMenu( dParent )
        end

    elseif ( sBind == "+attack2" ) then
        if dParent.dSubMenu and IsValid( dParent.dSubMenu ) then
            if dParent.dSubMenu.bFirstLayer or dParent.dSubMenu.bVolumeGUI then
                dParent.dSubMenu:Remove()
                dParent.dSubMenu = nil

                if timer.Exists( "GSmartWatch_RadioVolume" ) then
                    timer.Remove( "GSmartWatch_RadioVolume" )
                end
            else
                dParent.dSubMenu:Remove()
                Radio:BuildMenu( dParent )
            end
        else
            GSmartWatch:RunApp( "app_myapps" )
        end
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil