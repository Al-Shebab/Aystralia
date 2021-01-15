GSmartWatch.LastUse = 0
local fUseDelay = .15

--[[

    PlayerBindPress

]]--

local tValidBinds = {
    [ "invprev" ] = true,
    [ "invnext" ] = true,
    [ "+attack" ] = true,
    [ "+attack2" ] = true,
}

hook.Add( "PlayerBindPress", "GSmartWatch_PlayerBindPress", function( pPlayer, sBind, bPressed )
    if not tValidBinds[ sBind ] or not pPlayer:IsUsingSmartWatch() then
        return
    end

	if not GSmartWatch.CurrentApp then
		return true
	end

    if ( CurTime() > ( GSmartWatch.LastUse + fUseDelay ) ) then
    	local tApp = ( GSmartWatch.Apps[ GSmartWatch.CurrentApp ] or false )
	    if not tApp then
			return true
		end

	    if tApp.OnUse then
            GSmartWatch:Play2DSound( "gsmartwatch/ui/" .. ( ( ( sBind == "+attack" ) or ( sBind == "+attack2" ) ) and "keypress_standard.mp3" or "tick.mp3" ) )
    		tApp.OnUse( pPlayer:GetActiveWeapon().BaseUI, sBind )
		end

        local fDelay = ( tApp.KeyPressCooldown and tApp.KeyPressCooldown or .25 )

        GSmartWatch.LastUse = CurTime() + ( ( ( sBind == "+attack" ) or ( sBind == "+attack2" ) ) and fDelay or 0 )
    end

    return true
end )

--[[

    manageWatchInput

]]--

local function manageWatchInput( iButton )
    local xAppID = GSmartWatch:GetActiveApp()
    if not xAppID or ( xAppID == "app_boot" ) or ( xAppID == "app_watch" ) then
        return
    end

    if ( iButton == MOUSE_MIDDLE ) or ( iButton == KEY_BACKSPACE ) then
        GSmartWatch.LastUse = ( GSmartWatch.LastUse or 0 )
        if ( CurTime() < ( GSmartWatch.LastUse + fUseDelay ) ) then
            return
        end

    	GSmartWatch:Play2DSound( "gsmartwatch/ui/keypress_standard.mp3" )
        GSmartWatch.LastUse = CurTime()

        if ( xAppID == "app_myapps" ) then
            return GSmartWatch:RunApp( "app_watch" )
        end

        GSmartWatch:RunApp( "app_myapps" )

    elseif ( iButton == KEY_DOWN ) or ( iButton == KEY_UP ) then
        GSmartWatch.LastUse = ( GSmartWatch.LastUse or 0 )
        if ( CurTime() < ( GSmartWatch.LastUse + fUseDelay ) ) then
            return
        end

        if GSmartWatch.Apps[ xAppID ] and GSmartWatch.Apps[ xAppID ].OnUse then
            GSmartWatch:Play2DSound( "gsmartwatch/ui/tick.mp3" )
            GSmartWatch.Apps[ GSmartWatch.CurrentApp ].OnUse( LocalPlayer():GetActiveWeapon().BaseUI, ( ( iButton == KEY_DOWN ) and "invnext" or "invprev" ) ) 
        end

        GSmartWatch.LastUse = CurTime()

    elseif ( iButton == KEY_LEFT ) or ( iButton == KEY_RIGHT ) then
        GSmartWatch.LastUse = ( GSmartWatch.LastUse or 0 )
        if ( CurTime() < ( GSmartWatch.LastUse + fUseDelay ) ) then
            return
        end

        if GSmartWatch.Apps[ xAppID ] and GSmartWatch.Apps[ xAppID ].OnUse then
            GSmartWatch:Play2DSound( "gsmartwatch/ui/keypress_standard.mp3" )
            GSmartWatch.Apps[ xAppID ].OnUse( LocalPlayer():GetActiveWeapon().BaseUI, ( ( iButton == KEY_RIGHT ) and "+attack" or "+attack2" ) )
        end
   
        GSmartWatch.LastUse = CurTime()
    end
end

--[[

    PlayerButtonDown

]]--

hook.Add( "PlayerButtonDown", "GSmartWatch_PlayerButtonDown", function( pPlayer, iButton )
    if ( pPlayer ~= LocalPlayer() ) then
        return
    end

    if ( iButton == GSmartWatch.Cfg.UseKey ) then
        if GSmartWatch.Cfg.BlacklistedModels[ LocalPlayer():GetModel() ] then
            return
        end

        if GSmartWatch.Cfg.BlacklistedTeams[ team.GetName( LocalPlayer():Team() ) ] then
            return
        end

        if pPlayer:IsUsingSmartWatch() then
            if GSmartWatch.ClientSettings[ "IsToggle" ] then
                net.Start( "GSmartWatchNW" )
                    net.WriteUInt( 1, 2 )
                net.SendToServer()
            end
        else
            LocalPlayer().GSW_OldWeapon = LocalPlayer():GetActiveWeapon()

            net.Start( "GSmartWatchNW" )
                net.WriteUInt( 0, 2 )
            net.SendToServer()
        end

        return
    end

    if pPlayer:IsUsingSmartWatch() then
        manageWatchInput( iButton )
    end
end )

--[[

    PlayerButtonDown

]]--

hook.Add( "PlayerButtonUp", "GSmartWatch_PlayerButtonUp", function( pPlayer, iButton )
    if ( pPlayer ~= LocalPlayer() ) or ( iButton ~= GSmartWatch.Cfg.UseKey ) or GSmartWatch.ClientSettings[ "IsToggle" ] then
        return
    end

    net.Start( "GSmartWatchNW" )
        net.WriteUInt( 1, 2 )
    net.SendToServer()
end )

--[[

    PlayerSwitchWeapon

]]--

hook.Add( "PlayerSwitchWeapon", "GSmartWatch_PlayerSwitchWeapon", function( pPlayer, eOldWeapon, eNewWeapon )
    if IsValid( eOldWeapon ) and ( eOldWeapon:GetClass() == "gsmartwatch" ) then
        if eOldWeapon.BaseUI and IsValid( eOldWeapon.BaseUI ) then
            eOldWeapon.BaseUI:Remove()

            hook.Remove( "Think", "GSmartWatch_SWEPLightEmitter" )
        end

        timer.Simple( .6, function()
            LocalPlayer():GetViewModel():SetSubMaterial( 1 )
        end )
    end
end )