if GSmartWatch.Cfg.DisabledApps[ "app_fitness" ] then
    return
end

local GSWApp = {}

GSWApp.ID = "app_fitness"
GSWApp.Name = GSmartWatch.Lang.Apps[ "Fitness" ]
GSWApp.Icon = Material( "materials/gsmartwatch/apps/step.png", "smooth" )
GSWApp.ShowTime = true

local matSteps = Material( "materials/gsmartwatch/steps.png", "smooth" )
local matKCal = Material( "materials/gsmartwatch/flame.png", "smooth" )
local matDistance = Material( "materials/gsmartwatch/gps.png", "smooth" )

--[[

    PlayerFootstep

]]--

GSmartWatch.Steps = ( GSmartWatch.Steps or 0 )

hook.Add( "PlayerFootstep", "GSmartWatch_PlayerFootstepda6fede5567959dc2050c45954ee018cd70bbc11550860513094dadd37573dc9", function( pPlayer, tPos, iFoot, sSound, iVolume, tFilters )
    if ( pPlayer == LocalPlayer() ) then
        GSmartWatch.Steps = ( ( GSmartWatch.Steps or 0 ) + 1 )
    end
end )

--[[

    GSWApp:RunApp

]]--

function GSWApp.Run( dBase )
    dBase.RunningApp = vgui.Create( "DPanel", dBase )
    dBase.RunningApp:SetSize( dBase:GetWide(), dBase:GetTall() )

    dBase.RunningApp.t = {
        {
            icon = { x = .5, y = .31, w = .16, h = .16 },
            text = { x = .5, y = .47, font = "GSmartWatch.64", font2 = "GSmartWatch.32" },
            lerp = 0,
        },
        {
            icon = { x = .65, y = .64, w = .12, h = .12 },
            text = { x = .65, y = .76, font = "GSmartWatch.48" },
            lerp = 0,
        },
        {
            icon = { x = .35, y = .64, w = .12, h = .12 },
            text = { x = .35, y = .76, font = "GSmartWatch.48" },
            lerp = 0,
        },
    }
    dBase.RunningApp.t2 = {
        { mat = matSteps, tColor = GSmartWatch.Cfg.Colors[ 5 ], sText = function()
            return string.Replace( string.Comma( GSmartWatch.Steps ), ",", "." ), "STEPS"
        end },
        { mat = matDistance, tColor = color_white, sText = function()
            return math.Round( GSmartWatch.Steps * .0008, 1 ), "KM"
        end },
        { mat = matKCal, tColor = color_white, sText = function()
            return math.floor( GSmartWatch.Steps * .04 ), "KCAL"
        end }
    }

    function dBase.RunningApp:Paint( iW, iH )
        GSmartWatch:SetStencil()

        for k, v in ipairs( self.t2 ) do
            self.t[ k ].lerp = Lerp( RealFrameTime() * 6, self.t[ k ].lerp, ( iH * self.t[ k ].icon.h ) )

            surface.SetDrawColor( v.tColor )
            surface.SetMaterial( v.mat )
            surface.DrawTexturedRectRotated( ( iW * self.t[ k ].icon.x ), ( iH * self.t[ k ].icon.y ), ( iW * self.t[ k ].icon.w ), self.t[ k ].lerp, 0 )

            local sTextA, sTextB = v.sText()
            if ( k == 1 ) and sTextB then
                draw.SimpleText( sTextA, self.t[ k ].text.font, ( iW * self.t[ k ].text.x ) - 2, ( iH * self.t[ k ].text.y ), color_white, 2, 1 )
                draw.SimpleText( sTextB, self.t[ k ].text.font2, ( iW * self.t[ k ].text.x ) + 2, ( iH * self.t[ k ].text.y ), GSmartWatch.Cfg.Colors[ 4 ], 0, 1 )
            else
                draw.SimpleText( sTextA, self.t[ k ].text.font, ( iW * self.t[ k ].text.x ), ( iH * self.t[ k ].text.y ), color_white, 1, 1 )
            end
        end

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

    if ( sBind == "invnext" ) or ( sBind == "+attack" ) then
        local tNew = {
            [ 1 ] = dBase.RunningApp.t2[ 3 ],
            [ 2 ] = dBase.RunningApp.t2[ 1 ],
            [ 3 ] = dBase.RunningApp.t2[ 2 ]
        }

        for k, v in pairs( dBase.RunningApp.t ) do
            v.lerp = 0
        end

        dBase.RunningApp.t2 = tNew

    elseif ( sBind == "invprev" )  then
        local tNew = {
            [ 1 ] = dBase.RunningApp.t2[ 2 ],
            [ 2 ] = dBase.RunningApp.t2[ 3 ],
            [ 3 ] = dBase.RunningApp.t2[ 1 ]
        }

        dBase.RunningApp.t2 = tNew

    elseif ( sBind == "+attack2" ) then
        GSmartWatch:RunApp( "app_myapps" )
    end
end

GSmartWatch:RegisterApp( GSWApp )
GSWApp = nil