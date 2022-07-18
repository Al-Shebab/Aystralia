function CH_SupplyCrate.StartRobbery( ply, crate )
	local CRATE_RequiredTeamsCount = 0
	local CRATE_PlayersCounted = 0
	
	-- Check if crate is on cooldown, empty or already being robbed as the very first.
	if CH_SupplyCrate.SupplyCrateCooldown then
		DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["The police supply crate is currently on a cooldown and cannot be robbed!"][CH_SupplyCrate.Config.Language] )
		return
	end
	if CH_SupplyCrate.Content.Money <= 0 then
		DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["The police supply crate is empty and cannot be robbed!"][CH_SupplyCrate.Config.Language] )
		return
	end
	if CH_SupplyCrate.IsBeingRobbed then
		if ply.IsRobbingCrate then
			DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["You are already robbing the police supply crate!"][CH_SupplyCrate.Config.Language] )
		else
			DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["Someone is already robbing the police supply crate!"][CH_SupplyCrate.Config.Language] )
		end
		return
	end
	
	-- Check required police teams and players required in general.
	for k, v in ipairs( player.GetAll() ) do
		CRATE_PlayersCounted = CRATE_PlayersCounted + 1
		
		if table.HasValue( CH_SupplyCrate.Config.RequiredTeams, team.GetName( v:Team() ) ) then
			CRATE_RequiredTeamsCount = CRATE_RequiredTeamsCount + 1
		end
		if CRATE_PlayersCounted == #player.GetAll() then
			if CRATE_RequiredTeamsCount < CH_SupplyCrate.Config.PoliceRequired then
				DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.PoliceRequired.." ".. CH_SupplyCrate.Config.Lang["police officers are required before you can rob the supply crate."][CH_SupplyCrate.Config.Language] )
				
				return
			end
		end
	end
	
	if #player.GetAll() < CH_SupplyCrate.Config.PlayerLimit then
		DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.PlayerLimit.." "..CH_SupplyCrate.Config.Lang["players are required before you can rob the police supply crate."][CH_SupplyCrate.Config.Language] )
		return
	end
	
	-- Rank/team restriction check
	if CH_SupplyCrate.Config.RobberyRankRestrictions then
		if not ply:CRATE_RankCanRob() then
			DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["You are not allowed to rob the police supply crate with your current rank!"][CH_SupplyCrate.Config.Language] )
			return
		end
	else
		if not table.HasValue( CH_SupplyCrate.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
			DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["You are not allowed to rob the police supply crate as a"][CH_SupplyCrate.Config.Language] .." ".. team.GetName( ply:Team() ).."!" )
			return
		end
	end
	
	--[[
		Initialize the robbery after all checks has been passed!
	--]]
	-- bLogs support
	hook.Run( "SUPPLY_CRATE_RobberyInitiated", ply )
	
	-- Notify police teams, player and set some vars
	for k, v in ipairs( player.GetAll() ) do
		if table.HasValue( CH_SupplyCrate.Config.GovernmentTeams, team.GetName( v:Team() ) ) then
			DarkRP.notify( v, 1, 7, CH_SupplyCrate.Config.Lang["The police supply crate is being robbed!"][CH_SupplyCrate.Config.Language] )
		end
	end
	
	CH_SupplyCrate.IsBeingRobbed = true
	ply.IsRobbingCrate = true
	
	DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["You have started a robbery on the police supply crate!"][CH_SupplyCrate.Config.Language] )
	DarkRP.notify( ply, 1, 10, CH_SupplyCrate.Config.Lang["You must stay alive for"][CH_SupplyCrate.Config.Language] .." ".. CH_SupplyCrate.Config.RobberyAliveTime .." ".. CH_SupplyCrate.Config.Lang["minutes to receive everything the crate has."][CH_SupplyCrate.Config.Language] )
	DarkRP.notify( ply, 1, 15, CH_SupplyCrate.Config.Lang["If you go too far away from the police supply crate, the robbery will also fail!"][CH_SupplyCrate.Config.Language] )
	
	-- Change crate bodygroup and play sequence of opening laptop
	crate:SetBodygroup( 3, 1 )
	crate:ResetSequence( "laptop_open" ) -- open laptop
	
	-- Play alarm if config is enabled
	if CH_SupplyCrate.Config.EmitSoundOnRob then
		local AlarmSound = CreateSound( crate, CH_SupplyCrate.Config.TheSound )
		AlarmSound:SetSoundLevel( CH_SupplyCrate.Config.SoundVolume )
		AlarmSound:Play()
		
		timer.Simple( CH_SupplyCrate.Config.SoundDuration, function()
			AlarmSound:Stop()
		end )
	end
	
	net.Start( "CRATE_RestartTimer" )
		net.WriteEntity( crate )
	net.Broadcast()
	
	timer.Simple( CH_SupplyCrate.Config.RobberyAliveTime * 60, function()
		if IsValid( ply ) then
			if ply.IsRobbingCrate then
				CH_SupplyCrate.RobberyFinished( true )		
				ply.IsRobbingCrate = false
				
				timer.Simple( 6, function()
					if IsValid( ply ) then
						DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["Congratulations! You have successfully robbed the supply crate."][CH_SupplyCrate.Config.Language] )
						DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["The entirety of the supply crates loot has dropped. Collect it before the cops get it!"][CH_SupplyCrate.Config.Language] )
						
						-- Reward Money
						if CH_SupplyCrate.Config.EnableMoneyLoot then
							CH_SupplyCrate.SpawnMoneyBag( ply )
						end
						
						-- Reward Ammo
						if CH_SupplyCrate.Config.EnableAmmoLoot then
							CH_SupplyCrate.SpawnAmmo()
						end
						
						-- Reward Shipments
						if CH_SupplyCrate.Config.EnableShipmentLoot then
							for i = 1, CH_SupplyCrate.Content.Shipments do
								CH_SupplyCrate.SpawnShipments( ply )
							end
						end
						
						-- bLogs support
						hook.Run( "SUPPLY_CRATE_RobberySuccessful", ply, CH_SupplyCrate.Content.Money, CH_SupplyCrate.Content.Shipments, CH_SupplyCrate.Content.Ammo )
						
						-- XP System Support
						CH_SupplyCrate.LevelSupport( ply, CH_SupplyCrate.Config.XPSuccessfulRobbery )
						
						-- Network armorys content (reset it after succesful robbery)
						CH_SupplyCrate.Content.Money = 0
						CH_SupplyCrate.Content.Shipments = 0
						CH_SupplyCrate.Content.Ammo = 0
						
						net.Start( "CRATE_UpdateContent" )
							net.WriteEntity( CH_SupplyCrate.CrateEntity )
							net.WriteDouble( CH_SupplyCrate.Content.Money )
							net.WriteDouble( CH_SupplyCrate.Content.Shipments )
							net.WriteDouble( CH_SupplyCrate.Content.Ammo )
						net.Broadcast()
					end
				end )
			end
		end
	end )
end

-- When a robbery ends (succesfully or not)
function CH_SupplyCrate.RobberyFinished( success )
	local crate = CH_SupplyCrate.CrateEntity

	CH_SupplyCrate.SupplyCrateCooldown = true
	CH_SupplyCrate.IsBeingRobbed = false
	
	if not success then
		for k, v in ipairs( player.GetAll() ) do
			if table.HasValue( CH_SupplyCrate.Config.GovernmentTeams, team.GetName( v:Team() ) ) then
				DarkRP.notify( v, 1, 7, CH_SupplyCrate.Config.Lang["The supply crate robbery has failed!"][CH_SupplyCrate.Config.Language] )
			end
		end
	end
	
	net.Start( "CRATE_StopTimer" )
	net.Broadcast()
	
	-- Close laptop sequence and disable the bodygroup.
	crate:ResetSequence( "laptop_close" ) -- close laptop
	
	if success then
		crate:SetSkin( 1 ) -- set green skin on keypad
		crate:EmitSound( "buttons/button9.wav" )
	end
	
	--[[
	-- Create sparks on the laptop
	timer.Create( "crate_sparks", 0.3, 9, function()
		if IsValid( crate ) then
			local vPoint = crate:GetAttachment( 2 ).Pos
			local effectdata = EffectData()
			effectdata:SetStart( vPoint )
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 0.5 )
			util.Effect( "ManhackSparks", effectdata )
		end
	end )
	--]]
	
	timer.Simple( 0.65, function()
		if IsValid( crate ) then
			crate:SetBodygroup( 3, 0 ) -- wait before removing the laptop (let it close and show sprites)
		end
	end )
	
	if success then
		timer.Simple( 4, function()
			if IsValid( crate ) then
				crate:ResetSequence( "open" ) -- open crate sequence
				crate:EmitSound( "doors/door_screen_move1.wav" )
			end
		end )
		timer.Simple( 6, function()
			if IsValid( crate ) then
				crate:SetBodygroup( 2, 0 ) -- change bodygroup to remove crate inside cage (when we spawn the weapons)
			end
		end )
	end
	timer.Simple( 10, function() -- FINALLY WE RESET STUFF
		if IsValid( crate ) then
			if success then
				crate:ResetSequence( "close" ) -- close crate sequence
				crate:EmitSound( "doors/door_screen_move1.wav" )
				crate:SetSkin( 0 )
				timer.Simple( 0.8, function()
					crate:EmitSound( "doors/door_metal_thin_open1.wav" )
				end )
			end
			
			net.Start( "CRATE_RestartCooldown" )
			net.Broadcast()
			
			timer.Simple( CH_SupplyCrate.Config.RobberyCooldownTime * 60, function()
				if IsValid( crate ) then
					CH_SupplyCrate.SupplyCrateCooldown = false

					net.Start( "CRATE_StopCooldown" )
					net.Broadcast()
					
					if success then
						-- Spawn crate inside cage bodygroup
						crate:SetBodygroup( 2, 1 )
					end
				end
			end )
		end
	end )
end

function CH_SupplyCrate.RobberyDistanceCheck()
	if not CH_SupplyCrate.IsBeingRobbed then
		return
	end
	
	for ent, v in pairs( CH_SupplyCrate.SupplyCrates ) do
		if ent:GetClass() == "police_supply_crate" and IsValid( ent ) then
			thecrate = ent
		end
	end
	
	for k, v in ipairs( player.GetAll() ) do
		if v.IsRobbingCrate and IsValid( thecrate ) then
			if v:GetPos():DistToSqr( thecrate:GetPos() ) > tonumber( CH_SupplyCrate.Config.RobberyDistance ) then
				DarkRP.notify( v, 1, 5, CH_SupplyCrate.Config.Lang["You have moved too far away from the supply crate, and the robbery has failed!"][CH_SupplyCrate.Config.Language] )
			
				CH_SupplyCrate.RobberyFinished( false )

				v.IsRobbingCrate = false
				
				-- bLogs support
				hook.Run( "SUPPLY_CRATE_RobberyFailed", ply )
			end
		end
	end
end

-- Update supply crate with money, ammo and shipments
function CH_SupplyCrate.UpdateLoot()
	-- Update the amount of money in the supply crate.
	timer.Create( "CRATE_MoneyTimer", CH_SupplyCrate.Config.MoneyTimer, 0, function()
		if CH_SupplyCrate.IsBeingRobbed then
			return
		end
		
		if CH_SupplyCrate.SupplyCrateCooldown then
			return
		end
		
		if CH_SupplyCrate.Config.MaxMoney > 0 then
			CH_SupplyCrate.Content.Money = math.Clamp( ( CH_SupplyCrate.Content.Money + CH_SupplyCrate.Config.MoneyOnTime ), 0, CH_SupplyCrate.Config.MaxMoney )
		else
			CH_SupplyCrate.Content.Money = ( CH_SupplyCrate.Content.Money + CH_SupplyCrate.Config.MoneyOnTime )
		end
		
		net.Start( "CRATE_UpdateContent" )
			net.WriteEntity( CH_SupplyCrate.CrateEntity )
			net.WriteDouble( CH_SupplyCrate.Content.Money )
			net.WriteDouble( CH_SupplyCrate.Content.Shipments )
			net.WriteDouble( CH_SupplyCrate.Content.Ammo )
		net.Broadcast()
		
		-- bLogs support
		hook.Run( "SUPPLY_CRATE_MoneyLootUpdated", CH_SupplyCrate.Config.MoneyOnTime, CH_SupplyCrate.Content.Money )
	end )
	
	-- Update the amount of ammo in the supply crate.
	timer.Create( "CRATE_AmmoTimer", CH_SupplyCrate.Config.AmmoTimer, 0, function()
		if CH_SupplyCrate.IsBeingRobbed then
			return
		end
		
		if CH_SupplyCrate.SupplyCrateCooldown then
			return
		end
		
		if CH_SupplyCrate.Config.MaxAmmo > 0 then
			CH_SupplyCrate.Content.Ammo = math.Clamp( ( CH_SupplyCrate.Content.Ammo + CH_SupplyCrate.Config.AmmoOnTime ), 0, CH_SupplyCrate.Config.MaxAmmo )
		else
			CH_SupplyCrate.Content.Ammo = ( CH_SupplyCrate.Content.Ammo + CH_SupplyCrate.Config.AmmoOnTime )
		end
		
		net.Start( "CRATE_UpdateContent" )
			net.WriteEntity( CH_SupplyCrate.CrateEntity )
			net.WriteDouble( CH_SupplyCrate.Content.Money )
			net.WriteDouble( CH_SupplyCrate.Content.Shipments )
			net.WriteDouble( CH_SupplyCrate.Content.Ammo )
		net.Broadcast()
		
		-- bLogs support
		hook.Run( "SUPPLY_CRATE_AmmoLootUpdated", CH_SupplyCrate.Config.AmmoOnTime, CH_SupplyCrate.Content.Ammo )
	end )
	
	-- Update the amount of shipments in the supply crate.
	timer.Create( "CRATE_ShipmentsTimer", CH_SupplyCrate.Config.ShipmentsTimer, 0, function()
		if CH_SupplyCrate.IsBeingRobbed then
			return
		end
		
		if CH_SupplyCrate.SupplyCrateCooldown then
			return
		end
		
		if CH_SupplyCrate.Config.MaxShipments > 0 then
			CH_SupplyCrate.Content.Shipments = math.Clamp( ( CH_SupplyCrate.Content.Shipments + CH_SupplyCrate.Config.ShipmentsOnTime ), 0, CH_SupplyCrate.Config.MaxShipments )
		else
			CH_SupplyCrate.Content.Shipments = ( CH_SupplyCrate.Content.Shipments + CH_SupplyCrate.Config.ShipmentsOnTime ) 
		end
		
		net.Start( "CRATE_UpdateContent" )
			net.WriteEntity( CH_SupplyCrate.CrateEntity )
			net.WriteDouble( CH_SupplyCrate.Content.Money )
			net.WriteDouble( CH_SupplyCrate.Content.Shipments )
			net.WriteDouble( CH_SupplyCrate.Content.Ammo )
		net.Broadcast()
		
		-- bLogs support
		hook.Run( "SUPPLY_CRATE_ShipmentsLootUpdated", CH_SupplyCrate.Config.ShipmentsOnTime, CH_SupplyCrate.Content.Shipments )
	end )
end

-- Spawning after succesful robbery
function CH_SupplyCrate.SpawnMoneyBag( ply )
	for ent, v in pairs( CH_SupplyCrate.SupplyCrates ) do
		if ent:GetClass() == "police_supply_crate" and IsValid( ent ) then
			local spawn_random = 3
			moneypos = ent:GetAttachment( spawn_random ).Pos + Vector( 0, 0, math.random( 10, 100 ) )
		end
	end
	
	local CRATE_MoneyBag = ents.Create( "police_money_bag" )
	CRATE_MoneyBag:SetModel( "models/craphead_scripts/supply_crate/money.mdl" )
	CRATE_MoneyBag.ShareGravgun = true
	CRATE_MoneyBag:SetPos( moneypos )
	CRATE_MoneyBag.nodupe = true
	CRATE_MoneyBag:Spawn()
	
	CRATE_MoneyBag:SetBagMoney( CH_SupplyCrate.Content.Money )
end

function CH_SupplyCrate.SpawnAmmo()
	local found = table.Random( GAMEMODE.AmmoTypes )
	 
	for ent, v in pairs( CH_SupplyCrate.SupplyCrates ) do
		if ent:GetClass() == "police_supply_crate" and IsValid( ent ) then
			local spawn_random = 4
			ammopos = ent:GetAttachment( spawn_random ).Pos + Vector( 0, 0, math.random( 10, 100 ) )
		end
	end
	
	local CRATE_DroppedAmmo = ents.Create( "spawned_weapon" )
	CRATE_DroppedAmmo:SetModel( found.model )
	CRATE_DroppedAmmo.ShareGravgun = true
	CRATE_DroppedAmmo:SetPos( ammopos )
	CRATE_DroppedAmmo.nodupe = true
	function CRATE_DroppedAmmo:PlayerUse( user, ... )
		user:GiveAmmo( CH_SupplyCrate.Content.Ammo, found.ammoType )
		self:Remove()
		return true
	end
	CRATE_DroppedAmmo:Spawn()
end

function CH_SupplyCrate.SpawnShipments( ply )
    local foundKey
    local Count_WhiteList = table.Count( CH_SupplyCrate.ShipWhiteList )
    local Count_CustomShipments = table.Count( CustomShipments )

    if Count_WhiteList == 0 then
        for k, v in pairs( CustomShipments ) do
            foundKey = math.random( Count_CustomShipments )
        end
    elseif Count_WhiteList > 0 then
        for k, v in pairs( CH_SupplyCrate.ShipWhiteList ) do
            foundKey = math.random( Count_WhiteList )
        end
    end
	
	for ent, v in pairs( CH_SupplyCrate.SupplyCrates ) do
		if ent:GetClass() == "police_supply_crate" and IsValid( ent ) then
			local spawn_random = math.random( 5, 8 )
			shipmentpos = ent:GetAttachment( spawn_random ).Pos  + Vector( 0, 0, math.random( 10, 100 ) )
		end
	end
	
	local CRATE_SpawnedShipment = ents.Create( "spawned_shipment" )
	CRATE_SpawnedShipment.SID = ply.SID
	CRATE_SpawnedShipment:Setowning_ent( ply )
	CRATE_SpawnedShipment:SetContents( foundKey, CH_SupplyCrate.Config.ShipmentsWepAmount )
	CRATE_SpawnedShipment:SetPos( shipmentpos )
	CRATE_SpawnedShipment.nodupe = true
	CRATE_SpawnedShipment:Spawn()
	CRATE_SpawnedShipment:SetPlayer( ply )
	CRATE_SpawnedShipment:SetModel( "models/craphead_scripts/supply_crate/mil_crate.mdl" )
	CRATE_SpawnedShipment:PhysicsInit( SOLID_VPHYSICS )
	CRATE_SpawnedShipment:SetMoveType( MOVETYPE_VPHYSICS )
	CRATE_SpawnedShipment:SetSolid( SOLID_VPHYSICS )

	CRATE_SpawnedShipment:PhysWake()
	
	if CH_SupplyCrate.Config.ShipmentAutoRemove > 0 then
		timer.Simple( CH_SupplyCrate.Config.ShipmentAutoRemove, function()
			if IsValid( CRATE_SpawnedShipment ) then
				CRATE_SpawnedShipment:Remove()
			end
		end )
	end
end