function fcd.openDealerAdmin( ply, id )
	if not ply then return end
	if not id then return end
	
	net.Start( 'fcd.dealerAdminOpen' )
		net.WriteString( id )
	net.Send( ply )
end

function fcd.adminPlayerSay( ply, txt )
	txt = string.Explode( ' ', txt )

	if table.HasValue( fcd.cfg.adminCommands, txt[ 1 ] ) then
		if not fcd.adminAccess( ply ) then
			fcd.notifyPlayer( ply, fcd.cfg.adminTranslate[ 'adminOnly' ] )
			return ''
		end
	end

	if txt[ 1 ] == fcd.cfg.adminCommands[ 'saveDealers' ] then
		fcd.saveDealers()
		fcd.notifyPlayer( ply, fcd.cfg.adminTranslate[ 'dealersSaved' ] )

		return ''
	end

	if txt[ 1 ] == fcd.cfg.adminCommands[ 'initDealers' ] then
		fcd.initDealers()
		fcd.notifyPlayer( ply, fcd.cfg.adminTranslate[ 'dealersReset' ] )

		return ''
	end

	if txt[ 1 ] == fcd.cfg.adminCommands[ 'togglePlatforms' ] then
		fcd.togglePlatforms()

		return ''
	end

	if txt[ 1 ] == fcd.cfg.adminCommands[ 'dealerAdmin' ] then
		if ply:GetEyeTrace().Entity:GetClass() == 'freshcardealer' then
			fcd.openDealerAdmin( ply, fcd.getDealerID( ply:GetEyeTrace().Entity ) )
		else
			fcd.notifyPlayer( ply, fcd.cfg.adminTranslate[ 'notLookingAtDealer' ] )
		end

		return ''
	end

	if txt[ 1 ] == fcd.cfg.adminCommands[ 'adminMenu' ] then
		net.Start( 'fcd.openAdmin' )
			net.WriteTable( fcd.playerVehicles )
		net.Send( ply )

		return ''
	end

	if txt[ 1 ] == fcd.cfg.chopShop[ 'saveNPCsCommand' ] then
		fcd.saveChopShopNPCs()
		fcd.notifyPlayer( ply, 'You have saved all chop shop NPCs!' )
		return ''
	end
end

hook.Add( 'PlayerSay', 'fcd.adminPlayerSay', fcd.adminPlayerSay )