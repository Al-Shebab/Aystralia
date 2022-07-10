--[[

    OnePrint:L

]]--

function OnePrint:L( sLangString )
    return OnePrint.Lang[ sLangString ]
end

--[[

    OnePrint:C

]]--

function OnePrint:C( iColorIndex )
    return OnePrint.Cfg.Colors[ iColorIndex ]
end

--[[

    OnePrint:FormatMoney

]]--

local tMoneyFormatting = {
    [ "DarkRP" ] = function( iMoney )
        return DarkRP.formatMoney( iMoney )
    end,
    [ "Nutscript" ] = function( iMoney )
        local sMoney = nut.currency.get( iMoney )
        local tSplit = string.Split( sMoney, " " )

        return tSplit[ 1 ] or sMoney
    end,
    [ "Helix" ] = function( iMoney )
        return ix.currency.Get( iMoney )
    end
}

function OnePrint:FormatMoney( iMoney )
    if DarkRP then
        return tMoneyFormatting[ "DarkRP" ]( iMoney )
    end

    if ( nut and nut.currency ) then
        return tMoneyFormatting[ "Nutscript" ]( iMoney )
    end

    if ( ix and ix.currency ) then
        return tMoneyFormatting[ "Helix" ]( iMoney )
    end

    return ( "$" .. string.Comma( iMoney ) )
end
