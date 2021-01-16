--[[

    GSmartWatch:Play2DSound

]]--

local CSoundSource = false

function GSmartWatch:Play2DSound( sFileName )
    if CSoundSource then
        CSoundSource:Stop()
        CSoundSource = false
    end

    CSoundSource = CreateSound( LocalPlayer(), sFileName )
    CSoundSource:PlayEx( GSmartWatch.ClientSettings[ "UIVolume" ], 100 )
end

--[[

    GSmartWatch:GetPlayerMoney

]]--

function GSmartWatch:GetPlayerMoney( bBank )
    if bBank then
        -- SlownLS ATM
        if LocalPlayer().SlownLS_ATM_Balance then
            return ( LocalPlayer():SlownLS_ATM_Balance() or 0 )

        -- DarkRP Foundation
        elseif LocalPlayer().DRPF_BankingGet then
            return ( LocalPlayer():DRPF_BankingGet().AccountBalance or 0 )

        -- Glorified Banking
        elseif LocalPlayer().GetBankBalance then
            return ( LocalPlayer():GetBankBalance() or 0 )

        -- Blue's ATM
        elseif BATM then
            local tAccount = BATM.GetPersonalAccount()
            return ( tAccount and ( tAccount.balance or 0 ) or 0 )
        end

        return false
    end

    -- DarkRP
    if DarkRP then
        return ( LocalPlayer():getDarkRPVar( "money" ) or 0 )

    -- NutScript
    elseif nut then
        local pChar = LocalPlayer():getChar()
        return ( pChar:getMoney() or 0 )

    -- Helix
    elseif ( ix and ix.currency ) then
        local pChar = pPlayer:GetCharacter()
        return ( pChar:GetMoney() or 0 )
    end

    return false
end

--[[

    GSmartWatch:FormatMoney

]]--

function GSmartWatch:FormatMoney( fAmount )
    if DarkRP then
        return DarkRP.formatMoney( fAmount )
    end

    if ( nut and nut.currency ) then
        local sMoney = nut.currency.get( fAmount )
        local tSplit = string.Split( sMoney, " " )

        return tSplit[ 1 ] or sMoney
    end

    if ( ix and ix.currency ) then
        return ix.currency.Get( fAmount )
    end

    return ( "$" .. string.Comma( fAmount ) )
end

--[[

    GSmartWatch:GetTime

]]--

local bStormfox = ( StormFox and true or false )

function GSmartWatch:GetTime()
    local b24 = GSmartWatch.ClientSettings[ "Is24hCycle" ]

    if bStormfox and not GSmartWatch.Cfg.ForceRealTime then
        return os.date( ( b24 and "%H" or "%I" ) .. ":%M", ( StormFox.GetTime( true ) * 60 ) )
    end

    return os.date( ( b24 and "%H" or "%I" ) .. ":%M", os.time() )
end

--[[

    GSmartWatch:GetDate

]]--

function GSmartWatch:GetDate()
    if bStormfox and not GSmartWatch.Cfg.ForceRealTime then
        local iDay, iMonth = StormFox.GetDate()

        return ( ( iMonth > 9 ) and iMonth or ( "0" .. iMonth ) ) .. "/" ..  ( ( iDay > 9 ) and iDay or ( "0" .. iDay ) )
    end

    return os.date( "%x", os.time() )
end