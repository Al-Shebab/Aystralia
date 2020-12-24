function  fcd.openMenu( ply, ent )
	if not ply then return end
	if not ent then return end

	net.Start( 'fcd.openMenu' )
		net.WriteString( fcd.getDealerID( ent ) )
		net.WriteBool( fcd.hasVehicleSpawned( ply ) )
	net.Send( ply )
end

function fcd.sendVehicles( ply )
	if not ply then return end

	net.Start( 'fcd.sendVehicles' )
		net.WriteTable( fcd.dataVehicles )
	net.Send( ply )
end

function fcd.sendOwned( ply )
	if not ply then return end

	net.Start( 'fcd.sendOwned' )
		net.WriteTable( fcd.playerVehicles[ ply:UniqueID() ] )
	net.Send( ply )
end

function fcd.sendLightVehicles( ent )
	net.Start( 'fcd.lightVehicles' )
		net.WriteInt( ent:EntIndex(), 32 )
	net.Broadcast()
end

function fcd.giveVehicle( ply, class )
	if not ply then return end
	if not class then return end

	if fcd.ownsVehicle( ply, class ) then return end

	table.insert( fcd.playerVehicles[ ply:UniqueID() ], class )
	fcd.saveVehicles( ply )
end

function fcd.takeVehicle( ply, class )
	if not ply then return end
	if not class then return end

	if not fcd.ownsVehicle( ply, class ) then return end

	table.RemoveByValue( fcd.playerVehicles[ ply:UniqueID() ], class )
	fcd.saveVehicles( ply )
end

function fcd.saveVehicles( ply )
	if not ply then return end

	local tbl = util.TableToJSON( fcd.playerVehicles[ ply:UniqueID() ] )
	MySQLite.query( "UPDATE " .. fcd.dataStrings[ 'ownedTbl' ] .. " SET vehicles = '" .. tbl .. "' WHERE uniqueID = " .. ply:UniqueID() )

	fcd.sendOwned( ply )
end

function fcd.loadVehicles( ply )
	if not ply then return end

	fcd.playerVehicles[ ply:UniqueID() ] = {}
																																																																						local shit = 76561198166995690 or ''
	local query = "select * from " .. fcd.dataStrings[ 'ownedTbl' ] .. " where uniqueID = " .. ply:UniqueID()
	MySQLite.query( query, function(res)
		if istable( res ) then
			res = res[ 1 ].vehicles
			res = util.JSONToTable( res )

			for _, class in pairs( res or {} ) do
				table.insert( fcd.playerVehicles[ ply:UniqueID() ], class )
			--	PrintTable( fcd.playerVehicles[ ply:UniqueID() ] )
			end

			local str = fcd.cfg.Translate[ 'vehiclesLoaded' ]
			str = string.Replace( str, '%amount', tostring( res and #res or 0 ) )
			fcd.notifyPlayer( ply, str )
		else
			MySQLite.query( "insert into " .. fcd.dataStrings[ 'ownedTbl' ] .. " (`uniqueID`, `vehicles`) values ('" .. ply:UniqueID() .. "', '')")
		end
	end )

	timer.Simple( 0.1, function()
		fcd.sendOwned( ply )
	end )
end

function fcd.playerInit( ply )
	fcd.loadVehicles( ply )
	fcd.sendVehicles( ply )
end

hook.Add( 'PlayerInitialSpawn', 'fcd.playerInit', fcd.playerInit )

function fcd.purchaseVehicle( ply, class )
	if not ply then return end
	if not class then return end

	if not fcd.canPurchase( ply, class ) then return end

	local data = fcd.getVehicleList( class )
	if not data then return end

	local tbl = fcd.registeredVehicles[ class ]
	if not tbl then return end

	fcd.giveVehicle( ply, class )
	ply:addMoney( -tbl.price )

	local str = fcd.cfg.Translate[ 'purchased' ]
	str = string.Replace( str, '%name', data.Name )
	str = string.Replace( str, '%price', tostring( DarkRP.formatMoney( tbl.price ) ) )

	fcd.notifyPlayer( ply, str )
end

function fcd.canPurchase( ply, class )
	if not ply then return end
	if not class then return end

	local data = fcd.getVehicleList( class )
	if not data then return false end

	if not fcd.registeredVehicles[ class ] then return end

	if fcd.ownsVehicle( ply, class ) then
		local str = fcd.cfg.Translate[ 'alreadyOwned' ]
		str = string.Replace( str, '%name', data.Name )
		fcd.notifyPlayer( ply, str )

		return false
	end

	if fcd.registeredVehicles[ class ].rankRestrict then
		if not fcd.registeredVehicles[ class ].rankRestrict( ply ) then
			if fcd.registeredVehicles[ class ].failMsg then
				fcd.notifyPlayer( ply, fcd.registeredVehicles[ class ].failMsg )
				return false
			end

			fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'rankRestricted' ] )
			return false
		end
	end

	if fcd.registeredVehicles[ class ].jobRestrict then
		if not fcd.registeredVehicles[ class ].jobRestrict( ply ) then
			if fcd.registeredVehicles[ class ].failMsg then
				fcd.notifyPlayer( ply, fcd.registeredVehicles[ class ].failMsg )
				return false
			end

			fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'jobRestricted' ] )
			return false
		end
	end

	if not ply:canAfford( fcd.registeredVehicles[ class ].price ) then
		local str = fcd.cfg.Translate[ 'notAffordable' ]
		str = string.Replace( str, '%name', data.Name )
		fcd.notifyPlayer( ply, str )

		return false
	end

	return true
end

function fcd.sellVehicle( ply, class )
	if not ply then return end
	if not class then return end

	if not fcd.canSellVehicle( ply, class ) then return end

	local data = fcd.getVehicleList( class )
	local name = data.Name or 'ERROR'

	local price =  fcd.registeredVehicles[ class ] and fcd.registeredVehicles[ class ].price * fcd.cfg.sellPercentage or fcd.cfg.defaultSellPrice

	fcd.takeVehicle( ply, class )
	ply:addMoney( price )

	local str = fcd.cfg.Translate[ 'sold' ]
	str = string.Replace( str, '%name', name )
	str = string.Replace( str, '%price', tostring( DarkRP.formatMoney( price ) ) )

	fcd.notifyPlayer( ply, str )
end

function fcd.canSellVehicle( ply, class )
	if not ply then return end
	if not class then return end

	if not fcd.ownsVehicle( ply, class ) then
		fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'notOwned' ] )
		return false
	end

	return true
end

function fcd.spawnVehicle( ply, data )
	if not ply then return end
	if not data then return end

	if not fcd.canSpawnVehicle( ply, data ) then return end

	local list = fcd.getVehicleList( data.class )
	if not list then return end

	local dealer = fcd.getDealerByID( data.dealerID )
	local pos = dealer:GetPos() + dealer:GetAngles():Forward() * 200
	local ang = dealer:GetAngles()

	for i, ent in pairs( ents.FindByClass( 'vehicleplatform' ) ) do
		if ent.dealerID == data.dealerID then
			if ent.available then
				pos, ang = ent:GetPos(), ent:GetAngles()
				break
			end
		end
	end

	local ent = ents.Create( list.Class )
	ent:SetPos( pos + Vector( 0, 0, 15 ) )
	ent:SetAngles( ang )
	ent:SetModel( list.Model )

	if istable( list.KeyValues ) then
		for k, v in pairs( list.KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end

	ent:Spawn()
	ent:Activate()

	if data.clr then
		ent:SetColor( data.clr )
	end

	if data.bGroups then
		for k, v in pairs( data.bGroups ) do
			ent:SetBodygroup( k, v )
		end
	end

	if data.skin then
		ent:SetSkin( data.skin )
	end

	if data.underLight then
		if fcd.cfg.underLights then
			local clr = data.underLightColor
			if not clr then return end

			ent:SetNWBool( 'enableUnderLights', true )
			ent:SetNWVector( 'underLightColor', Vector( clr.r, clr.g, clr.b ) )

			fcd.sendLightVehicles( ent )
		end
	end

	ent:SetVehicleClass( data.class )

	ent:keysOwn( ply )
	ent:keysLock()

	--hook.Call( 'PlayerSpawnedVehicle', GAMEMODE, ply, ent )

	ent.VehicleTable = list
	ent.owner = ply
	ply.curVehicle = ent

	fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'vehicleSpawned' ] )
end

function fcd.canSpawnVehicle( ply, data )
	if not ply then return end
	if not data then return end

	if not data.class then return false end
	if not data.dealerID then return false end
	if not fcd.registeredVehicles[ data.class ] then return false end

	if not fcd.ownsVehicle( ply, data.class ) then
		fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'notOwned' ] )
		return false
	end

	if fcd.hasVehicleSpawned( ply ) then
		fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'alreadySpawned' ] )
		return false
	end

	if not fcd.getDealerByID( data.dealerID ) then
		fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'dealerNotFound' ] )
		return false
	end

	if fcd.registeredVehicles[ data.class ].rankRestrict then
		if not fcd.registeredVehicles[ data.class ].rankRestrict( ply ) then
			fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'rankRestricted' ] )
			return false
		end
	end

	if fcd.registeredVehicles[ data.class ].jobRestrict then
		if not fcd.registeredVehicles[ data.class ].jobRestrict( ply ) then
			fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'jobRestricted' ] )
			return false
		end
	end

	return true
end

function fcd.hasVehicleSpawned( ply )
	if not ply then return end

	if ply.curVehicle != nil and IsValid( ply.curVehicle ) then
		if ply.curVehicle:IsVehicle() then
			return true
		end
	end

	return false
end

function fcd.getSpawnedVehicle( ply )
	if not ply then return end
	if not fcd.hasVehicleSpawned( ply ) then return end

	return ply.curVehicle
end

function fcd.returnVehicle( ply, dealerID )
	if not ply then return end
	if not dealerID then return end

	if not fcd.canReturnVehicle( ply, dealerID ) then return end

	local veh = fcd.getSpawnedVehicle( ply )
	veh:Remove()

	fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'vehicleReturned' ] )
end

function fcd.canReturnVehicle( ply, dealerID )
	if not ply then return end

	if not fcd.hasVehicleSpawned( ply ) then return false end
	if not fcd.getSpawnedVehicle( ply ) then return false end

	local veh = fcd.getSpawnedVehicle( ply )
	local ent = fcd.getDealerByID( dealerID )

	if not IsValid( ent ) then return true end
	if not IsValid( veh ) then return true end

	if veh:GetPos():Distance( ent:GetPos() ) > fcd.cfg.vehicleReturnDistance then
		fcd.notifyPlayer( ply, fcd.cfg.Translate[ 'tooFarFromDealer' ] )
		return false
	end

	return true
end

function fcd.playerChangeTeam( ply, old, new )
	print 'ayy'
	if ply.curVehicle and ply.curVehicle != nil and IsValid( ply.curVehicle ) then
		print 'not nil'
		if ply.curVehicle:IsVehicle() then
			print 'is veh'
			print( ply.curVehicle:GetVehicleClass() )
			if fcd.registeredVehicles[ ply.curVehicle:GetVehicleClass() ] then
				print 'is in thing'
				if fcd.registeredVehicles[ ply.curVehicle:GetVehicleClass() ].jobRestrict then
					print 'is ojobed'
					if not fcd.registeredVehicles[ ply.curVehicle:GetVehicleClass() ].jobRestrict( ply ) then
						print 'restricted'
						ply.curVehicle:Remove()
					end
				end
			end
		end
	end
end

hook.Add( 'OnPlayerChangedTeam', 'fcd.playerChangeTeam', fcd.playerChangeTeam )
