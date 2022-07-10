--[[

	OnePrint:Notify

]]--

local tNotify = {
    [ "DarkRP" ] = function( pPlayer, sNotify, iType, iTime )
       	DarkRP.notify( pPlayer, ( iType or 0 ), ( iTime or 1 ), sNotify )
    end,
    [ "Nutscript" ] = function( pPlayer, sNotify, iType, iTime )
		nut.util.notify( sNotify, pPlayer )
    end,
    [ "Helix" ] = function( pPlayer, sNotify, iType, iTime )
		pPlayer:Notify( sNotify )
    end
}

function OnePrint:Notify( pPlayer, sNotify, iType, iTime )
	if DarkRP then
        return tNotify[ "DarkRP" ]( pPlayer, sNotify, iType, iTime )
    elseif nut then
        return tAddMoney[ "Nutscript" ]( pPlayer, sNotify, iType, iTime )
    elseif ( ix and ix.currency ) then
        return tAddMoney[ "Helix" ]( pPlayer, sNotify, iType, iTime )
	end

	pPlayer:ChatPrint( sNotify )
end


--[[

	OnePrint:AddMoney

]]--

local tAddMoney = {
    [ "DarkRP" ] = function( pPlayer, iMoney )
       	pPlayer:addMoney( iMoney )
    end,
    [ "Nutscript" ] = function( pPlayer, iMoney )
        pPlayer:getChar():giveMoney( iMoney )
    end,
    [ "Helix" ] = function( pPlayer, iMoney )
        local iWallet = ( pPlayer:GetCharacter():GetMoney() or 0 )
		pPlayer:GetCharacter():SetMoney( iWallet + iMoney )
    end
}

function OnePrint:AddMoney( pPlayer, iMoney )
	if DarkRP then
        return tAddMoney[ "DarkRP" ]( pPlayer, iMoney )
    elseif nut then
        return tAddMoney[ "Nutscript" ]( pPlayer, iMoney )
    elseif ( ix and ix.currency ) then
        return tAddMoney[ "Helix" ]( pPlayer, iMoney )
	end
end