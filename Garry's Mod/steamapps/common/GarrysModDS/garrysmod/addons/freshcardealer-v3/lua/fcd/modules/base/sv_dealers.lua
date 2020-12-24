fcd.platformsHidden = true

function fcd.setDealerID( ent, id )
	if not ent then return end
	if not id then return end
	
	ent:SetdealerID( tostring( id ) )
end

function fcd.setDealerName( ent, name )
	if not ent then return end
	if not name then return end
	
	ent:SetdealerName( tostring( name ) )
end

function fcd.saveDealers( hide )
	local save = {}

	for k, ent in pairs( ents.FindByClass( 'freshcardealer' ) ) do
		save[ fcd.getDealerID( ent ) ] = {
			mdl = ent:GetModel(),
			pos = ent:GetPos(),
			ang = ent:GetAngles(),
			plats = fcd.getDealerPlatforms( fcd.getDealerID( ent ) ) or {},
			name = fcd.getDealerName( ent ),
			id = fcd.getDealerID( ent ),
			specific = ent:GetisSpecific()
		}
	end

	fcd.hidePlatforms()	
	file.Write( fcd.dataStrings[ 'dealerSpawns' ], util.TableToJSON( save ) )

	if not hide then
		fcd.notifyServer( 'Saved a total of ' .. #save .. ' car dealers!' )
	end

	fcd.initDealers()
end

function fcd.initDealers()
	for k, ent in pairs( ents.FindByClass( 'freshcardealer' ) ) do
		ent:Remove()
	end

	for k, ent in pairs( ents.FindByClass( 'vehicleplatform' ) ) do
		ent:Remove()
	end

	local data = file.Read( fcd.dataStrings[ 'dealerSpawns' ], 'DATA' )
	if not data then return end
	if data == '' then return end
	if string.len( data ) <= 0 then return end
	
	data = util.JSONToTable( data )

	for k, v in pairs( data ) do
		local ent = ents.Create( 'freshcardealer' )
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		ent:Spawn()
		ent:SetModel( v.mdl )

		ent:SetisSpecific( v.specific )

		fcd.setDealerName( ent, v.name )
		fcd.setDealerID( ent, v.id )

		fcd.spawnDealerPlatforms( v )
	end

	fcd.hidePlatforms()
	fcd.notifyServer( 'Spawned a total of ' .. #data .. ' dealers!' )
end

hook.Add( 'InitPostEntity', 'fcd.initDealers', fcd.initDealers )

function fcd.spawnDealerPlatforms( data, id )
	if not data then return end

	for _, v in pairs( data.plats or {} ) do
		local plat = ents.Create( 'vehicleplatform' )
		plat:SetPos( v.pos )
		plat:SetAngles( v.ang )
		plat:Spawn()

		local phys = plat:GetPhysicsObject()
		
		if phys then
			phys:EnableMotion( false )
		end
		
		plat.dealerID = data.id
	end
end

function fcd.spawnPlatform( id )
	if not id then return end

	local dealer = fcd.getDealerByID( id )
	if not dealer then return end
	
	local pos = dealer:GetPos() + dealer:GetAngles():Up() * 100
	local ang = dealer:GetAngles()
	
	local ent = ents.Create( 'vehicleplatform' )
	ent:SetPos( pos )
	ent:SetAngles( ang )
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	ent.dealerID = id

	fcd.showPlatforms()
end

function fcd.hidePlatforms()
	for k, ent in pairs( ents.FindByClass( 'vehicleplatform' ) ) do
		ent:DrawShadow( false )
		ent:SetMaterial( 'Models/effects/vol_light001' )

		ent.draggable = false
	end

	fcd.platformsHidden = true
end

function fcd.showPlatforms()
	for k, ent in pairs( ents.FindByClass( 'vehicleplatform' ) ) do
		ent:DrawShadow( true )
		ent:SetMaterial( 'models/wireframe' )

		ent.draggable = true
	end

	fcd.platformsHidden = false
end

function fcd.togglePlatforms()
	if fcd.platformsHidden then
		fcd.showPlatforms()
	else
		fcd.hidePlatforms()
	end
end