function BANK2_COPSDLC_SpawnNPCs( ply )
	-- Spawning in the civil police
	timer.Create("NPCCOPS_SpawnNPCTimer", CH_BankVault.Config.NPCCOPS_TimerInterval, CH_BankVault.Config.NPCCOPS_TimerLoop, function()
		for k, v in pairs( file.Find( "craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/npc_spawnpos_*.txt", "DATA" ) ) do
			local PositionFile = file.Read("craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/".. v, "DATA")
			local ThePosition = string.Explode( ";", PositionFile )	
			local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
			local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])

			local npccop = ents.Create( "npc_combine_s" )
			npccop:SetPos( TheVector )
			npccop:SetAngles( TheAngle )
			--npccop:SetModel( "models/player/Group01/Male_01.mdl" )
			npccop:Spawn()
					
			timer.Simple( 5, function()
				npccop:Give( table.Random( CH_BankVault.Config.NPCCOPS_RandomWeapons ) )
				npccop:SetSaveValue( "m_vecLastPosition", ply:GetPos() )
				npccop:SetSchedule( SCHED_FORCED_GO )
				npccop:SetEnemy( ply )
				print( npccop:GetEnemy() )
			end )
					
			npccop:SetHealth( math.random( CH_BankVault.Config.NPCCOPS_MinHealth, CH_BankVault.Config.NPCCOPS_MaxHealth ) )
			npccop.IsRobberySecurity = true
		end
	end)
end

-- Console commands for police npc spawn locations
function BANK2_COPSDLC_CreateSpawnPos( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint("Please choose a UNIQUE name for the spawn position!") 
			return
		end
		
		if file.Exists( "craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/npc_spawnpos_".. FileName ..".txt", "DATA" ) then 
			ply:ChatPrint("This file name is already in use. Please choose another name for this.")
			return
		end
		
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/npc_spawnpos_".. FileName ..".txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint("New spawn position created!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("npccops_setspawnpos", BANK2_COPSDLC_CreateSpawnPos)

function BANK2_COPSDLC_DeleteSpawnPos( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint("Please enter a filename!") 
			return
		end
		
		if file.Exists( "craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/npc_spawnpos_".. FileName ..".txt", "DATA" ) then
			file.Delete( "craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/npc_spawnpos_".. FileName ..".txt" )
			ply:ChatPrint("The selected spawn position has been removed!")
		else
			ply:ChatPrint("The spawn position name does not exist!")
		end
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("npccops_deletespawnpos", BANK2_COPSDLC_DeleteSpawnPos)

function BANK2_COPSDLC_SpawnPosList( ply, cmd, args )
	if ply:IsAdmin() then
		print("NPC SPAWN POS LIST:")
		
		for k, v in pairs(file.Find("craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/npc_spawnpos_*.txt", "DATA")) do
			local PosFile = file.Read("craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower(game.GetMap()) .."/".. v, "DATA")
			local ThePos = string.Explode( ";", PosFile )
			local ThePrintPos = ThePos[1], ThePos[2], ThePos[3]
					
			print("File Name: ".. v .." - Position: "..ThePrintPos)
		end
		
		print("REMEMBER: YOU ONLY USE THE LAST OF THE FILE NAME. SO IF A FILE NAME IS CALLED 'NPC_SPAWNPOS_TRAIN', THEN YOU WOULD USE 'npccops_deletespawnpos train' TO REMOVE IT!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("npccops_spawnposlist", BANK2_COPSDLC_SpawnPosList)
