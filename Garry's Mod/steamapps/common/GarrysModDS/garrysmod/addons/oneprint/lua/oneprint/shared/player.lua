local mPlayer = FindMetaTable( "Player" )

--[[

    mPlayer:OP_CanAfford

]]--

function mPlayer:OP_CanAfford( iPrice )
    if ( iPrice == 0 ) then
        return true
    end

    if DarkRP then
        return self:canAfford( iPrice )
    end
end

--[[

    mPlayer:OP_GetMoney

]]--

local tWallet = {
    [ "DarkRP" ] = function( pPlayer )
        return ( pPlayer:getDarkRPVar( "money" ) or 0 )
    end,
    [ "Nutscript" ] = function( pPlayer )
        return ( pPlayer:getChar():getMoney() or 0 )
    end,
    [ "Helix" ] = function( pPlayer )
        return ( pPlayer:GetCharacter():GetMoney() or 0 )
    end
}

function mPlayer:OP_GetMoney()
    if DarkRP then
        return tWallet[ "DarkRP" ]( self )
    elseif nut then
        return tWallet[ "Nutscript" ]( self )
    elseif ( ix and ix.currency ) then
        return tWallet[ "Helix" ]( self )
    end

    return 0
end

--[[

    mPlayer:OP_IsHaxor

]]--

function mPlayer:OP_IsHaxor()
    if not OnePrint.Cfg.HackingEnabled then
        return false
    end

    if not OnePrint.Cfg.HackingJobs or ( istable( OnePrint.Cfg.HackingJobs ) and table.IsEmpty( OnePrint.Cfg.HackingJobs ) ) then
        return true
    end

    return OnePrint.Cfg.HackingJobs[ team.GetName( self:Team() ) ]
end