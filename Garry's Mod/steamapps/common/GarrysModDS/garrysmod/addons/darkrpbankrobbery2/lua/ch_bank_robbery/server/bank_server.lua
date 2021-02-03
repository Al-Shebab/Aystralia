function CH_BankRobbery2_RobberyFailCheck()
	timer.Create( "BANK2_DistRobberyCheck", 3, 0, function()
		if not CH_BankVault.BankIsBeingRobbed then -- Better solution/optimized to not call the full code if the bank is not even being robbed.
			return
		end
		
		if not BANK_TransportDLC then
			for bank, v in pairs( CH_BankVault.Banks ) do
				if bank:GetClass() == "new_bank_vault" and IsValid( bank ) then
					TheVault = bank
				end
			end

			for k, v in pairs( player.GetAll() ) do
				if v.IsRobbingBank and IsValid( TheVault ) then
					if v:GetPos():DistToSqr( TheVault:GetPos() ) > tonumber( CH_BankVault.Config.RobberyDistance ) then
						if table.Count( CH_BankVault.CurrentRobbers ) == 1 then
							DarkRP.notify( v, 1, 5, "You have moved too far away from the bank vault and the robbery has failed!" )
					
							for k, govteams in pairs( player.GetAll() ) do
								if table.HasValue( CH_BankVault.Config.GovernmentTeams, team.GetName( govteams:Team() ) ) then
									DarkRP.notify( govteams, 1, 7, "The bank robbery has failed!" )
								end
							end
					
							CH_BankRobbery2_RestartRobbery()
						
							v.IsRobbingBank = false
							
							-- bLogs support
							hook.Run( "CH_BankRobbery2_bLogs_RobberyFailedEntirely", v )
						else
							v.IsRobbingBank = false
							DarkRP.notify( v, 1, 5, "You have moved too far away from the bank vault, and you have failed to rob the bank!" )
							DarkRP.notify( v, 1, 5, "Your companions are still alive and will continue to fight!" )
							
							table.RemoveByValue( CH_BankVault.CurrentRobbers, v )
							
							net.Start( "BANK2_RemoveCurrentRobbers")
								net.WriteString( v:Nick() )
							net.Broadcast()
							
							-- bLogs support
							hook.Run( "CH_BankRobbery2_bLogs_RobberyFailed", v )
						end
					end
				end
			end
		end
	end )
end

function CH_BankRobbery2_StartRobbery( ply )
	local RequiredTeamsCount = 0
	local RequiredPlayersCounted = 0
	
	-- Default restrictions should show first
	if ply.IsRobbingBank then
		DarkRP.notify( ply, 1, 5, "You are already robbing the bank!" )
		return
	end
	if CH_BankVault.BankCooldown then
		DarkRP.notify( ply, 1, 5, "You cannot rob the bank yet!" )
		return
	end
	if CH_BankVault.Content.Money <= 0 then
		DarkRP.notify( ply, 1, 5, "There are no money in the bank!" )
		return
	end
	
	-- Team and model restrictions
	if not table.HasValue( CH_BankVault.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
		DarkRP.notify( ply, 1, 5, "You are not allowed to rob the bank with your current team!" )
		return
	end
	if CH_BankVault.Config.UseRequiredModels then
		if not table.HasValue( CH_BankVault.Config.RequiredModels, ply:GetModel() ) then
			DarkRP.notify( ply, 1, 5, "You are not allowed to rob the bank with your current model!" )
			return
		end
	end
	
	-- Required police officers before you can rob
	for k, v in pairs( player.GetAll() ) do
		RequiredPlayersCounted = RequiredPlayersCounted + 1
		
		if table.HasValue( CH_BankVault.Config.RequiredTeams, team.GetName( v:Team() ) ) then
			RequiredTeamsCount = RequiredTeamsCount + 1
		end
		
		if RequiredPlayersCounted == #player.GetAll() then
			if RequiredTeamsCount < CH_BankVault.Config.PoliceRequired then
				DarkRP.notify( ply, 1, 5, "There has to be ".. CH_BankVault.Config.PoliceRequired .." police officers before you can rob the bank." )
				return
			end
		end
	end
	
	-- Required players
	if #player.GetAll() < CH_BankVault.Config.PlayerLimit then
		DarkRP.notify( ply, 1, 5, "There must be ".. CH_BankVault.Config.PlayerLimit .." players before you can rob the bank." )
		return
	end
	
	-- If bank is being robbed, perhaps allow the player to join in on the robbery
	if CH_BankVault.BankIsBeingRobbed then
		if CH_BankVault.RobbersCanJoin then
			if table.Count( CH_BankVault.CurrentRobbers ) < 4 then
				DarkRP.notify( ply, 1, 5, "You have joined the current robbery on the bank!" )
				DarkRP.notify( ply, 1, 10, "You must stay alive with the rest of the team to receive the banks money." )
				DarkRP.notify( ply, 1, 15, "If you go to far away from the bank vault the bank robbery will fail." )
				
				ply.IsRobbingBank = true
				ply:wanted( ply, "Bank Robbery" )
				
				table.insert( CH_BankVault.CurrentRobbers, ply )
				
				net.Start( "BANK2_UpdateCurrentRobbers" )
					net.WriteString( ply:Nick() )
				net.Broadcast()
				
				-- set enemy for npc cops
				if CH_BankVault.Config.UseNPCCopsDLC then
					for k, v in ipairs( ents.FindByClass( "npc_metropolice" ) ) do
						v:SetEnemy( ply )
					end
				end
				
				-- bLogs support
				hook.Run( "CH_BankRobbery2_bLogs_JoinRobbery", ply )
				
				return
			else
				DarkRP.notify( ply, 1, 5, "There are already 3 people robbing the bank." )
				return
			end
		else
			DarkRP.notify( ply, 1, 5, "It is no longer possible to join the bank robbery!" )
			return
		end
	end
	
	-- Initialize new robbery if nobody is robbing it and all checks are passed!!
	-- Notify all officers of a new robbery IF initialized new robbery
	for k, v in pairs( player.GetAll() ) do
		if table.HasValue( CH_BankVault.Config.GovernmentTeams, team.GetName( v:Team() ) ) then
			DarkRP.notify( v, 1, 7, "The bank vault is under attack! You must stop the attack before the robbers get away with the money." )
		end
	end
	
	net.Start( "BANK2_RestartCountdown" )
		net.WriteDouble( CH_BankVault.Config.AliveTime )
	net.Broadcast()

	CH_BankVault.BankIsBeingRobbed = true
	CH_BankVault.RobbersCanJoin = true
	ply.IsRobbingBank = true
	ply:wanted( ply, "Bank Robbery" )
	
	table.Empty( CH_BankVault.CurrentRobbers )
	table.insert( CH_BankVault.CurrentRobbers, ply )
	
	net.Start( "BANK2_UpdateCurrentRobbers" )
		net.WriteString( ply:Nick() )
	net.Broadcast()

	for thevault, v in pairs( CH_BankVault.Banks ) do
		if thevault:GetClass() == "new_bank_vault" and IsValid( thevault ) then
			if CH_BankVault.Config.EmitSoundOnRob then

				local AlarmSound = CreateSound( thevault, CH_BankVault.Config.TheSound )
				AlarmSound:SetSoundLevel( CH_BankVault.Config.SoundVolume )
				AlarmSound:Play()
				
				timer.Simple( CH_BankVault.Config.SoundDuration, function()
					AlarmSound:Stop()
				end )
			end
		end
	end

	timer.Create( "BANK2_RobbersCanJoin", CH_BankVault.Config.RobbersCanJoin, 1, function()
		CH_BankVault.RobbersCanJoin = false
	end )
	
	-- bLogs support
	hook.Run( "CH_BankRobbery2_bLogs_RobberyInitiated", ply )
	
	if BANK_TransportDLC then
		BANK2_TRANSPORT_StartRobbery( ply )
	else
		DarkRP.notify( ply, 1, 5, "You have began a robbery on the bank!" )
		DarkRP.notify( ply, 1, 10, "You must stay alive for ".. string.ToMinutesSeconds( CH_BankVault.Config.AliveTime ) .." minutes to receive the banks money." )
		DarkRP.notify( ply, 1, 15, "If you go too far away from the bank vault, the robbery will fail." )
		
		if CH_BankVault.Config.UseNPCCopsDLC then
			BANK2_COPSDLC_SpawnNPCs( ply )
		end
		
		-- alive timer
		timer.Simple( CH_BankVault.Config.AliveTime, function()
			if table.ToString( CH_BankVault.CurrentRobbers ) != "{\"NONE\",}" then
				local FinalPot = CH_BankVault.Content.Money
				
				CH_BankVault.Content.Money = 0 -- Reset the money in the bank after succesful robbery.
				net.Start( "BANK2_UpdateBankMoney" )
					net.WriteEntity( CH_BankVault.BankEntity )
					net.WriteDouble( CH_BankVault.Content.Money )
				net.Broadcast()
			
				for k, robber in pairs( player.GetAll() ) do
					if robber.IsRobbingBank then
						for k, v in pairs( player.GetAll() ) do
							if table.HasValue( CH_BankVault.Config.GovernmentTeams, team.GetName( v:Team() ) ) then
								DarkRP.notify( v, 1, 10, "The bank robbery has succeeded and the money is now long gone!" )
							end
						end
						
						robber.IsRobbingBank = false
						robber:unWanted( robber )
				
						local MoneyToGet = FinalPot / table.Count( CH_BankVault.CurrentRobbers )

						if CH_BankVault.Config.DropMoneyOnSucces then
							for ent, v in pairs( CH_BankVault.Banks ) do
								if ent:GetClass() == "new_bank_vault" and IsValid( ent ) then
									for i = 1, table.Count( CH_BankVault.CurrentRobbers ) do
										DarkRP.createMoneyBag( ent:GetPos() + Vector(50, 0, 0), MoneyToGet )
									end
									
									DarkRP.notify( robber, 1, 10,  DarkRP.formatMoney( CH_BankVault.Content.Money ) .." has dropped from the bank from the successful robbery!")
								end
							end
						else
							robber:addMoney( MoneyToGet )
							DarkRP.notify( robber, 1, 10, "You have been given ".. DarkRP.formatMoney( MoneyToGet ) .." for successfully robbing the bank." )
							DarkRP.notify( robber, 1, 10, "The money was split between you and ".. table.Count( CH_BankVault.CurrentRobbers ) - 1 .." others." )
							
							-- Support for vrondakis level system
							if CH_BankVault.Config.VrondakisXPEnable then
								robber:addXP( CH_BankVault.Config.VrondakisXPAmount, true )
							end
						end		

						-- bLogs support
						hook.Run( "CH_BankRobbery2_bLogs_RobberySuccessful", robber, MoneyToGet )
					end
				end
				timer.Simple( 2, function()
					CH_BankRobbery2_RestartRobbery()
				end )
			end
		end )
	end
end

function CH_BankRobbery2_RestartRobbery()
	CH_BankVault.BankCooldown = true
	CH_BankVault.BankIsBeingRobbed = false

	table.Empty( CH_BankVault.CurrentRobbers )
	table.insert( CH_BankVault.CurrentRobbers, "NONE" )

	net.Start( "BANK2_RestartCooldown" )
		net.WriteDouble( CH_BankVault.Config.CooldownTime )
	net.Broadcast()

	net.Start( "BANK2_KillCountdown" )
	net.Broadcast()
	
	timer.Stop( "BANK2_RobbersCanJoin" )

	timer.Simple( CH_BankVault.Config.CooldownTime, function()
		CH_BankVault.BankCooldown = false
		
		net.Start( "BANK2_KillCooldown" )
		net.Broadcast()
	end )

	-- Transport DLC
	if BANK_TransportDLC then
		for k, v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
			if v.IsTransportingMoney then
				v:Remove()
			end
		end
		
		for k, v in pairs( ents.GetAll() ) do
			if v:GetClass() == "transport_moneypallet" then
				v:Remove()
			end
		end
		if timer.Exists( "BANK2Transport_Timeleft" ) then
			timer.Remove( "BANK2Transport_Timeleft" )
		end
	end
	
	-- Police NPC DLC
	if CH_BankVault.Config.UseNPCCopsDLC then
		for k, v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
			if v.IsRobberySecurity then
				v:Remove()
			end
		end
		if timer.Exists( "NPCCOPS_SpawnNPCTimer" ) then
			timer.Remove( "NPCCOPS_SpawnNPCTimer" )
		end
	end
end

function CH_BankRobbery2_AddMoneyTimer()
	timer.Create( "BANK_MoneyTimer", CH_BankVault.Config.MoneyTimer, 0, function()
		if not CH_BankVault.BankIsBeingRobbed then
			if CH_BankVault.Config.Max > 0 then
				CH_BankVault.Content.Money = math.Clamp( ( CH_BankVault.Content.Money + CH_BankVault.Config.MoneyOnTime ), 0, CH_BankVault.Config.Max )
			else
				CH_BankVault.Content.Money = ( CH_BankVault.Content.Money + CH_BankVault.Config.MoneyOnTime )
			end
			
			net.Start( "BANK2_UpdateBankMoney" )
				net.WriteEntity( CH_BankVault.BankEntity )
				net.WriteDouble( CH_BankVault.Content.Money )
			net.Broadcast()
		end
	end )
end

function CH_BankRobbery2_PlayerDeath( robber, inflictor, attacker )
	if robber.IsRobbingBank then
		if attacker then
			-- Unwanted the player and stop him robbing the bank.
			robber.IsRobbingBank = false
			robber:unWanted( robber )
			
			-- Reward money to the killer.
			if table.HasValue( CH_BankVault.Config.GovernmentTeams, team.GetName( attacker:Team() ) ) then
				attacker:addMoney( CH_BankVault.Config.KillReward )
				DarkRP.notify( attacker, 1, 7, "You have been rewarded ".. DarkRP.formatMoney( CH_BankVault.Config.KillReward ) .." for killing a bank robber!" )
			end
			
			-- Notify robber and police teams and remove from tables etc
			if table.Count( CH_BankVault.CurrentRobbers ) == 1 then
				DarkRP.notify( robber, 1, 5, "You have died and the bank robbery has failed!" )
				
				for k, v in pairs( player.GetAll() ) do
					if table.HasValue( CH_BankVault.Config.GovernmentTeams, team.GetName( v:Team() ) ) then
						DarkRP.notify( v, 1, 7, "All bank robbers have died and the bank robbery has failed." )
					end
				end
				
				CH_BankRobbery2_RestartRobbery()
				
				-- bLogs support
				hook.Run( "CH_BankRobbery2_bLogs_RobberyFailedEntirely", robber )
			else
				DarkRP.notify( robber, 1, 5, "You have failed to rob the bank, but your companions will continue to fight!" )
				
				table.RemoveByValue( CH_BankVault.CurrentRobbers, robber )
				net.Start( "BANK2_RemoveCurrentRobbers")
					net.WriteString( robber:Nick() )
				net.Broadcast()
				
				-- bLogs support
				hook.Run( "CH_BankRobbery2_bLogs_RobberyFailed", robber )
			end
		end
	end
end
hook.Add( "PlayerDeath", "CH_BankRobbery2_PlayerDeath", CH_BankRobbery2_PlayerDeath )

function CH_BankRobbery2_Disconnect( robber )
	if robber.IsRobbingBank then
		if table.Count( CH_BankVault.CurrentRobbers ) == 1 then			
			for k, v in pairs( player.GetAll() ) do
				if table.HasValue( CH_BankVault.Config.GovernmentTeams, team.GetName( v:Team() ) ) then
					DarkRP.notify( v, 1, 7, "The bank robbery has failed!" )
				end
			end
			
			CH_BankRobbery2_RestartRobbery()			
			robber.IsRobbingBank = false
			
			-- bLogs support
			hook.Run( "CH_BankRobbery2_bLogs_RobberyFailedEntirely", robber )
		else
			robber.IsRobbingBank = false
			table.RemoveByValue( CH_BankVault.CurrentRobbers, robber )
			
			net.Start( "BANK2_RemoveCurrentRobbers")
				net.WriteString( robber:Nick() )
			net.Broadcast()
			
			-- bLogs support
			hook.Run( "CH_BankRobbery2_bLogs_RobberyFailed", robber )
		end
	end
end
hook.Add( "PlayerDisconnected", "CH_BankRobbery2_Disconnect", CH_BankRobbery2_Disconnect )