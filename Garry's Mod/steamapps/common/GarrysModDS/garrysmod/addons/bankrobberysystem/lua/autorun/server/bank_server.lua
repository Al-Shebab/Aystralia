function BANK_Initlize()
	BANK_AddMoneyTimer()
	SetGlobalInt( "BANK_VaultAmount", 0 )
	BankIsBeingRobbed = false
end
timer.Simple(1, function() 
	BANK_Initlize() 
end)

function BANK_PlayerDeath( ply, inflictor, attacker )
	if ply.IsRobbingBank then
		DarkRP.notify(ply, 1, 5,  "You have failed to rob the bank!")
		attacker:addMoney(BANK_Custom_KillReward)
		
		for k, v in pairs(player.GetAll()) do
			if table.HasValue( GovernmentTeams, team.GetName(v:Team()) ) then
				DarkRP.notify(v, 1, 7,  "The bank robbery has failed!")
			end
		end
		
		umsg.Start("BANK_KillTimer")
		umsg.End()
						
		BANK_StartCooldown()
						
		ply.IsRobbingBank = false
		BankIsBeingRobbed = false
	end
end
hook.Add("PlayerDeath", "BANK_PlayerDeath", BANK_PlayerDeath)

function BANK_RobberyFailCheck()
	for k, v in pairs(player.GetAll()) do
		if v.IsRobbingBank then
			BankRobber = v
			break
		end
	end
	
	if IsValid(BankRobber) then
		for _, ent in pairs(ents.FindByClass("bank_vault")) do
			if ent:IsValid() && BankRobber:GetPos():Distance(ent:GetPos()) >= BANK_Custom_RobberyDistance then
				if BankIsBeingRobbed then
					DarkRP.notify(BankRobber, 1, 5,  "You have moved to far away from the bank vault, and the robbery has failed!")
					
					for k, v in pairs(player.GetAll()) do
						if table.HasValue( GovernmentTeams, team.GetName(v:Team()) ) then
							DarkRP.notify(v, 1, 7,  "The bank robbery has failed!")
						end
					end
			
					umsg.Start("BANK_KillTimer")
					umsg.End()
									
					BANK_StartCooldown()
									
					BankRobber.IsRobbingBank = false
					BankIsBeingRobbed = false
					BankRobber = nil
				end
			end
		end
	end
end
hook.Add("Tick", "BANK_RobberyFailCheck", BANK_RobberyFailCheck)

function BANK_BeginRobbery( ply )
	local RequiredTeamsCount = 0
	local RequiredPlayersCounted = 0
	
	for k, v in pairs(player.GetAll()) do
		RequiredPlayersCounted = RequiredPlayersCounted + 1
		
		if table.HasValue( RequiredTeams, team.GetName(v:Team()) ) then
			RequiredTeamsCount = RequiredTeamsCount + 1
		end
		
		if RequiredPlayersCounted == #player.GetAll() then
			if RequiredTeamsCount < BANK_Custom_PoliceRequired then
				DarkRP.notify(ply, 1, 5, "There has to be "..BANK_Custom_PoliceRequired.." police officers before you can rob the bank.")
				return
			end
		end
	end
	
	if BankCooldown then
		DarkRP.notify(ply, 1, 5,  "You cannot rob the bank yet!")
		return
	end
	if GetGlobalInt( "BANK_VaultAmount" ) <= 0 then
		DarkRP.notify(ply, 1, 5, "There are no money in the bank!")
		return
	end
	if BankIsBeingRobbed then
		DarkRP.notify(ply, 1, 5, "The bank is already being robbed!")
		return
	end
	if #player.GetAll() < BANK_Custom_PlayerLimit then
		DarkRP.notify(ply, 1, 5, "There must be "..BANK_Custom_PlayerLimit.." players before you can rob the bank.")
		return
	end
	if not table.HasValue( AllowedTeams, team.GetName(ply:Team()) ) then
		DarkRP.notify(ply, 1, 5, "You are not allowed to rob the bank with your current team!")
		return
	end
	
	
	for k, v in pairs(player.GetAll()) do
		if table.HasValue( GovernmentTeams, team.GetName(v:Team()) ) then
			DarkRP.notify(v, 1, 7,  "The bank is being robbed!")
		end
	end
	
	BankIsBeingRobbed = true
	DarkRP.notify(ply, 1, 5, "You have began a robbery on the bank!")
	DarkRP.notify(ply, 1, 10, "You must stay alive for ".. BANK_Custom_AliveTime .." minutes to receive the banks money.")
	DarkRP.notify(ply, 1, 13, "If you go to far away from the bank vault, the robbery will also fail!")
	ply.IsRobbingBank = true
				
	umsg.Start("BANK_RestartTimer")
		umsg.Long(BANK_Custom_AliveTime * 60)
	umsg.End()
				
	timer.Simple( BANK_Custom_AliveTime * 60, function()
		if ply.IsRobbingBank then
			DarkRP.notify(ply, 1, 5,  "You have succesfully robbed the bank!")
			for k, v in pairs(player.GetAll()) do
				if table.HasValue( GovernmentTeams, team.GetName(v:Team()) ) then
					DarkRP.notify(v, 1, 7,  "The bank robbery has succeseded and the money is now long gone!")
				end
			end
						
			umsg.Start("BANK_KillTimer")
			umsg.End()
						
			BANK_StartCooldown()
						
			ply.IsRobbingBank = false
			
			if BANK_Custom_DropMoneyOnSucces then
				for _, ent in pairs(ents.FindByClass("bank_vault")) do
					DarkRP.createMoneyBag( ent:GetPos() + Vector(50, 0, 0), GetGlobalInt( "BANK_VaultAmount" ) )
					DarkRP.notify(ply, 1, 5,  ""..DarkRP.formatMoney(GetGlobalInt( "BANK_VaultAmount" )).." has dropped from the bank!")
				end
			else
				ply:addMoney( GetGlobalInt( "BANK_VaultAmount" ) )
				DarkRP.notify(ply, 1, 5,  "You have been given "..DarkRP.formatMoney(GetGlobalInt( "BANK_VaultAmount" )).." for succesfully robbing the bank.")
			end
						
			SetGlobalInt( "BANK_VaultAmount", 0 )
			BankIsBeingRobbed = false
		end
	end)
end

function BANK_StartCooldown()
	BankCooldown = true
	umsg.Start("BANK_RestartCooldown")
		umsg.Long(BANK_Custom_CooldownTime * 60)
	umsg.End()
	
	timer.Simple( BANK_Custom_CooldownTime * 60, function()
		BankCooldown = false
		umsg.Start("BANK_KillCooldown")
		umsg.End()
	end)
end

function BANK_AddMoneyTimer()
	timer.Create("BANK_MoneyTimer", BANK_CUSTOM_MoneyTimer, 0, function()
		if not BankIsBeingRobbed then
			if BANK_Custom_Max > 0 then
				SetGlobalInt( "BANK_VaultAmount", math.Clamp( (GetGlobalInt( "BANK_VaultAmount" ) + BANK_CUSTOM_MoneyOnTime), 0, BANK_Custom_Max) )
			else
				SetGlobalInt( "BANK_VaultAmount", (GetGlobalInt( "BANK_VaultAmount" ) + BANK_CUSTOM_MoneyOnTime) )
			end
		end
	end)
end

function BANK_Disconnect( ply )
	if ply.IsRobbingBank then
			
		for k, v in pairs(player.GetAll()) do
			if table.HasValue( GovernmentTeams, team.GetName(v:Team()) ) then
				DarkRP.notify(v, 1, 7,  "The bank robbery has failed!")
			end
		end
			
		umsg.Start("BANK_KillTimer")
		umsg.End()
							
		BANK_StartCooldown()
							
		ply.IsRobbingBank = false
		BankIsBeingRobbed = false
	end
end
hook.Add( "PlayerDisconnected", "BANK_Disconnect", BANK_Disconnect )