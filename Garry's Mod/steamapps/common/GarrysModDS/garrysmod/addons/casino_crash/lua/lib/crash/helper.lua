function util.LerpColor(tr, tg, tb, from, to)
	tg = tg or tr
	tb = tb or tr

	return Color(Lerp(tr, from.r, to.r), Lerp(tg, from.g, to.g), Lerp(tb, from.b, to.b))
end

function math.IsFinite(num)
    return not (num ~= num or num == math.huge or num == -math.huge)
end

function Casino_Crash.CanAfford(_Player, _Amount)
	if not _Player or not _Amount then return false end

    local __type = string.lower(Casino_Crash.Config.CashType)

    if __type == "darkrp" then
        return _Player:canAfford( _Amount )
    elseif __type == "pointshop" then
        return ( _Player:PS_GetPoints() >= _Amount )
    elseif isfunction(Casino_Crash.Config.CashType) then
        return Casino_Crash.Config.CashType( _Amount )
    else
    	return _Player:CanAfford( _Amount ) --fallback
    end
end

function Casino_Crash.SetTranslate( )
	if not CLIENT then return end

	for k, v in pairs( Casino_Crash.Config.Translations ) do
		if k != Casino_Crash.Config.Language then continue end
		
		for _key, _val in pairs( v ) do
			language.Add( _key, _val )
		end
	end
end

Casino_Crash.SetTranslate( )