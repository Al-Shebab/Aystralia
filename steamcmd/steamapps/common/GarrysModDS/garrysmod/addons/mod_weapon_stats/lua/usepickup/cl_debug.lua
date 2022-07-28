concommand.Add( "usepickup_debug", function() USEPICKUP.Debugmode:FullDebug() end )

USEPICKUP.Debugmode = {}

USEPICKUP.Debugmode.Enable = false

USEPICKUP.Debugmode.Permission = {
    "STEAM_0:0:72931887", -- My SteamID (CupCakeR) - https://steamid.io/lookup/76561198106129502
    "Your SteamID", -- https://steamid.io/
}

--
function USEPICKUP.Debugmode:Print( s )
    MsgC( Color(255,0,0), "<USEPICKUP.Debug> ", Color(255,255,255), s, "\n" )
end

function USEPICKUP.Debugmode:HasPermission()
    return table.HasValue( self.Permission, LocalPlayer():SteamID() )
end

function USEPICKUP.Debugmode:FullDebug()
    if !self:HasPermission() then
        self:Print( "You don't have permission to debug." )
        return
    end

    self:Print( "Starting" )

    local lp = LocalPlayer()
    local weapon = USEPICKUP.FUNCS:GetLookAtWeapon( lp, true )

    if !weapon then
        self:Print( "No weapon (GetLookAtWeapon)" )
        PrintTable( p:GetEyeTrace(MASK_SHOT) )
        return
    end
    
    self:Print( "GetLookAtWeapon: " .. tostring(weapon) )

    self:Print( "Base: " .. USEPICKUP.STATS:GetWeaponBase( weapon ) )

    self:Print( "ValidateUse: " .. tostring(USEPICKUP.FUNCS:ValidateUse( lp, weapon )) )

    local stats_table = USEPICKUP.STATS:GetWeaponStats( weapon )
    if !stats_table or stats_table == {} then
        self:Print( "Weapon stats table: NONE" )
    else
        self:Print( "Weapon stats table:" )
        PrintTable( USEPICKUP.STATS:GetWeaponStats( weapon ) )
    end

    self:Print( "Global 'AverageStats' table" )
    PrintTable( USEPICKUP.STATS.AverageStats )

    self:Print( "Global 'GlobalMax' table" )
    PrintTable( USEPICKUP.STATS.GlobalMax )

    self:Print( "Finished\n" )
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         --76561310346441921