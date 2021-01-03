function ARMORY_PlayerDeath( ply, inflictor, attacker )
	if ply.IsRobbingArmory then
		DarkRP.notify(ply, 1, 5,  "You have failed to rob the police armory!")
		attacker:addMoney( CH_ArmoryRobbery.Config.KillReward )
		
		for k, v in pairs(player.GetAll()) do
			if table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName(v:Team()) ) then
				DarkRP.notify(v, 1, 7,  "The police armory robbery has failed!")
			end
		end
		
		net.Start( "ARMORY_KillCountdown" )
		net.Broadcast()

		ARMORY_StartCooldown()

		ply.IsRobbingArmory = false
		CH_ArmoryRobbery.IsBeingRobbed = false
	end
end
hook.Add( "PlayerDeath", "ARMORY_PlayerDeath", ARMORY_PlayerDeath )

function ARMORY_RobberyFailCheck()
	for k, v in pairs(player.GetAll()) do
		if v.IsRobbingArmory then
			ArmoryRobber = v
			break
		end
	end
	
	if IsValid( ArmoryRobber ) then
		for k, ent in pairs(ents.FindByClass("police_armory")) do
			if IsValid( ent ) and ArmoryRobber:GetPos():DistToSqr(ent:GetPos()) >= CH_ArmoryRobbery.Config.RobberyDistance then
				if CH_ArmoryRobbery.IsBeingRobbed then
					DarkRP.notify(ArmoryRobber, 1, 5,  "You have moved to far away from the police armory, and the robbery has failed!")
					
					for k, v in pairs(player.GetAll()) do
						if table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName(v:Team()) ) then
							DarkRP.notify(v, 1, 7,  "The police armory robbery has failed!")
						end
					end
			
					net.Start( "ARMORY_KillCountdown" )
					net.Broadcast()
		
					ARMORY_StartCooldown()

					ArmoryRobber.IsRobbingArmory = false
					CH_ArmoryRobbery.IsBeingRobbed = false
					ArmoryRobber = nil
				end
			end
		end
	end
end
hook.Add("Tick", "ARMORY_RobberyFailCheck", ARMORY_RobberyFailCheck)

function ARMORY_BeginRobbery( ply )
	local ARMORY_RequiredTeamsCount = 0
	local ARMORY_RequiredPlayersCounted = 0
	
	if table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName(ply:Team()) ) then
		if CH_ArmoryRobbery.Weapons.Enabled then
			if CH_ArmoryRobbery.Weapons.ArmorAmount > 0 then
				if ply:Armor() < 100 then
					ply:SetArmor( CH_ArmoryRobbery.Weapons.ArmorAmount )
					DarkRP.notify(ply, 1, 5,  "You have been given ".. CH_ArmoryRobbery.Weapons.ArmorAmount .." armor!")
				end
			end
			
			net.Start( "CH_Armory_WeaponMenu" )
			net.Send( ply )
			return
		else
			DarkRP.notify(ply, 1, 5,  "The police armory is currently disabled!")
			return
		end
	end
	
	for k, v in pairs(player.GetAll()) do
		ARMORY_RequiredPlayersCounted = ARMORY_RequiredPlayersCounted + 1
		
		if table.HasValue( CH_ArmoryRobbery.Config.RequiredTeams, team.GetName(v:Team()) ) then
			ARMORY_RequiredTeamsCount = ARMORY_RequiredTeamsCount + 1
		end
		
		if ARMORY_RequiredPlayersCounted == #player.GetAll() then
			if ARMORY_RequiredTeamsCount < CH_ArmoryRobbery.Config.PoliceRequired then
				DarkRP.notify(ply, 1, 5, "There has to be ".. CH_ArmoryRobbery.Config.PoliceRequired .." police officers before you can rob the police armory.")
				return
			end
		end
	end
	
	if CH_ArmoryRobbery.ArmoryCooldown then
		DarkRP.notify(ply, 1, 5,  "You cannot rob the police armory yet!")
		return
	end
	if GetGlobalInt( "ARMORY_MoneyAmount" ) <= 0 then
		DarkRP.notify(ply, 1, 5, "There is nothing in the police armory!")
		return
	end
	if CH_ArmoryRobbery.IsBeingRobbed then
		DarkRP.notify(ply, 1, 5, "The police armory is already being robbed!")
		return
	end
	if #player.GetAll() < CH_ArmoryRobbery.Config.PlayerLimit then
		DarkRP.notify(ply, 1, 5, "There must be ".. CH_ArmoryRobbery.Config.PlayerLimit .." players before you can rob the police armory.")
		return
	end
	if not table.HasValue( CH_ArmoryRobbery.Config.AllowedTeams, team.GetName(ply:Team()) ) then
		DarkRP.notify(ply, 1, 5, "You are not allowed to rob the police armory with your current team!")
		return
	end
	
	
	for k, v in pairs(player.GetAll()) do
		if table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName(v:Team()) ) then
			DarkRP.notify(v, 1, 7,  "The police armory is being robbed!")
		end
	end
	
	CH_ArmoryRobbery.IsBeingRobbed = true
	DarkRP.notify( ply, 1, 5, "You have began a robbery on the police armory!")
	DarkRP.notify( ply, 1, 10, "You must stay alive for ".. CH_ArmoryRobbery.Config.AliveTime .." minutes to receive everything the armory has.")
	DarkRP.notify( ply, 1, 13, "If you go to far away from the police armory vault, the robbery will also fail!")
	ply.IsRobbingArmory = true
	
	net.Start( "ARMORY_RestartCountdown" )
		net.WriteDouble( CH_ArmoryRobbery.Config.AliveTime * 60 )
	net.Broadcast()

	timer.Simple( CH_ArmoryRobbery.Config.AliveTime * 60, function()
		if ply.IsRobbingArmory then
			for k, v in pairs(player.GetAll()) do
				if table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName(v:Team()) ) then
					DarkRP.notify(v, 1, 7,  "The police armory robbery has succeeded and everything inside is now long gone!")
				end
			end

			net.Start( "ARMORY_KillCountdown" )
			net.Broadcast()

			ARMORY_StartCooldown()
			
			ply.IsRobbingArmory = false
			
			-- Reward Money
			DarkRP.notify( ply, 1, 5, "Congratulations! You have successfully robbed the police armory.")
			DarkRP.notify( ply, 1, 5, "You have been given ".. DarkRP.formatMoney( GetGlobalInt( "ARMORY_MoneyAmount" ) ).. " and a lot of gear has been dropped from the armory." )
			ply:addMoney( GetGlobalInt( "ARMORY_MoneyAmount" ) )
			SetGlobalInt( "ARMORY_MoneyAmount", 0 )
			
			-- Reward Ammo
			ARMORY_SpawnAmmo()
			SetGlobalInt( "ARMORY_AmmoAmount", 0 )
			
			-- Reward Shipments
			for i = 1, GetGlobalInt( "ARMORY_ShipmentsAmount" ) do
				ARMORY_SpawnShipments( ply )
			end
			SetGlobalInt( "ARMORY_ShipmentsAmount", 0 )
			
			CH_ArmoryRobbery.IsBeingRobbed = false
		end
	end)
end

function ARMORY_StartCooldown()
	CH_ArmoryRobbery.ArmoryCooldown = true

	net.Start( "ARMORY_RestartCooldown" )
		net.WriteDouble( CH_ArmoryRobbery.Config.CooldownTime * 60 )
	net.Broadcast()
	
	timer.Simple( CH_ArmoryRobbery.Config.CooldownTime * 60, function()
		CH_ArmoryRobbery.ArmoryCooldown = false

		net.Start( "ARMORY_KillCooldown" )
		net.Broadcast()
	end)
end

function ARMORY_UpdateArmory()
	-- Update the amount of money in the armory.
	timer.Create("ARMORY_MoneyTimer", CH_ArmoryRobbery.Config.MoneyTimer, 0, function()
		if not CH_ArmoryRobbery.IsBeingRobbed then
			if CH_ArmoryRobbery.Config.MaxMoney > 0 then
				SetGlobalInt( "ARMORY_MoneyAmount", math.Clamp( (GetGlobalInt( "ARMORY_MoneyAmount" ) + CH_ArmoryRobbery.Config.MoneyOnTime), 0, CH_ArmoryRobbery.Config.MaxMoney) )
			else
				SetGlobalInt( "ARMORY_MoneyAmount", (GetGlobalInt( "ARMORY_MoneyAmount" ) + CH_ArmoryRobbery.Config.MoneyOnTime) )
			end
		end
	end)
	
	-- Update the amount of ammo in the armory.
	timer.Create("ARMORY_AmmoTimer", CH_ArmoryRobbery.Config.AmmoTimer, 0, function()
		if not CH_ArmoryRobbery.IsBeingRobbed then
			if CH_ArmoryRobbery.Config.MaxAmmo > 0 then
				SetGlobalInt( "ARMORY_AmmoAmount", math.Clamp( (GetGlobalInt( "ARMORY_AmmoAmount" ) + CH_ArmoryRobbery.Config.AmmoOnTime), 0, CH_ArmoryRobbery.Config.MaxAmmo) )
			else
				SetGlobalInt( "ARMORY_AmmoAmount", (GetGlobalInt( "ARMORY_AmmoAmount" ) + CH_ArmoryRobbery.Config.AmmoOnTime) )
			end
		end
	end)

	-- Update the amount of shipments in the armory.
	timer.Create("ARMORY_ShipmentsTimer", CH_ArmoryRobbery.Config.ShipmentsTimer, 0, function()
		if not CH_ArmoryRobbery.IsBeingRobbed then
			if CH_ArmoryRobbery.Config.MaxShipments > 0 then
				SetGlobalInt( "ARMORY_ShipmentsAmount", math.Clamp( (GetGlobalInt( "ARMORY_ShipmentsAmount" ) + CH_ArmoryRobbery.Config.ShipmentsOnTime), 0, CH_ArmoryRobbery.Config.MaxShipments) )
			else
				SetGlobalInt( "ARMORY_ShipmentsAmount", (GetGlobalInt( "ARMORY_ShipmentsAmount" ) + CH_ArmoryRobbery.Config.ShipmentsOnTime) )
			end
		end
	end)
end

function ARMORY_Disconnect( ply )
	if ply.IsRobbingArmory then
		
		for k, v in pairs( player.GetAll() ) do
			if table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName(v:Team()) ) then
				DarkRP.notify(v, 1, 7,  "The police armory robbery has failed!")
			end
		end
		
		net.Start( "ARMORY_KillCountdown" )
		net.Broadcast()

		ARMORY_StartCooldown()

		ply.IsRobbingArmory = false
		CH_ArmoryRobbery.IsBeingRobbed = false
	end
end
hook.Add( "PlayerDisconnected", "ARMORY_Disconnect", ARMORY_Disconnect )

function ARMORY_SpawnAmmo()

	local found = table.Random(GAMEMODE.AmmoTypes)
	 
	for _, ent in pairs(ents.FindByClass("police_armory")) do
		ammopos = ent:GetPos() + Vector(70,0,math.random(20,150))
	end
	
	local ARMORY_DroppedAmmo = ents.Create("spawned_weapon")
	ARMORY_DroppedAmmo:SetModel(found.model)
	ARMORY_DroppedAmmo.ShareGravgun = true
	ARMORY_DroppedAmmo:SetPos(ammopos)
	ARMORY_DroppedAmmo.nodupe = true
	function ARMORY_DroppedAmmo:PlayerUse(user, ...)
		user:GiveAmmo(GetGlobalInt( "ARMORY_AmmoAmount" ), found.ammoType)
		self:Remove()
		return true
	end
	ARMORY_DroppedAmmo:Spawn()
end

function ARMORY_SpawnShipments( ply )
	
	local foundKey
	for k,v in pairs(CustomShipments) do
		foundKey = math.random(table.Count(CustomShipments))
	end
	
	for _, ent in pairs(ents.FindByClass("police_armory")) do
		shipmentpos = ent:GetPos() + Vector(70,0,math.random(20,150))
	end
	
	local ARMORY_DroppedShipment = ents.Create("spawned_shipment")
	ARMORY_DroppedShipment.SID = ply.SID
	ARMORY_DroppedShipment:Setowning_ent(ply)
	ARMORY_DroppedShipment:SetContents(foundKey, CH_ArmoryRobbery.Config.ShipmentsAmount)

	ARMORY_DroppedShipment:SetPos(shipmentpos)
	ARMORY_DroppedShipment.nodupe = true
	ARMORY_DroppedShipment:Spawn()
	ARMORY_DroppedShipment:SetPlayer(ply)
	ARMORY_DroppedShipment:SetModel("models/Items/item_item_crate.mdl")
	ARMORY_DroppedShipment:PhysicsInit(SOLID_VPHYSICS)
	ARMORY_DroppedShipment:SetMoveType(MOVETYPE_VPHYSICS)
	ARMORY_DroppedShipment:SetSolid(SOLID_VPHYSICS)

	local phys = ARMORY_DroppedShipment:GetPhysicsObject()
	phys:Wake()

	if CustomShipments[foundKey].onBought then
		CustomShipments[foundKey].onBought(ply, CustomShipments[foundKey], weapon)
	end
	hook.Call("playerBoughtShipment", nil, ply, CustomShipments[foundKey], weapon)
end

util.AddNetworkString( "ARMORY_RetrieveWeapon" )
net.Receive( "ARMORY_RetrieveWeapon", function(length, ply)
	local TheWeapon = net.ReadString()
	
	if ply.WeaponArmoryDelay then
		DarkRP.notify(ply, 1, 5,  "Please wait before retrieving another weapon from the armory.")
		return
	end
	
	for _, ent in ipairs( ents.FindByClass( "police_armory" ) ) do
		if IsValid( ent ) and ply:GetPos():DistToSqr( ent:GetPos() ) > 10000 then
			DarkRP.notify( ply, 1, 5,  "You are not close enough to the armory to retrieve a weapon!")
			return
		end
	end
	
	if not table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName( ply:Team() ) ) then
		DarkRP.notify(ply, 1, 5, "You are not allowed to retrieve weapons with your current team!")
		return
	end
	
	if TheWeapon == "weapon1" then
		ply:Give(CH_ArmoryRobbery.Weapons.Weapon1WepName)
		ply:GiveAmmo(CH_ArmoryRobbery.Weapons.Weapon1AmmoAmount, CH_ArmoryRobbery.Weapons.Weapon1AmmoType)
		DarkRP.notify(ply, 1, 5,  "You have retrieved an ".. CH_ArmoryRobbery.Weapons.Weapon1Name .." with ".. CH_ArmoryRobbery.Weapons.Weapon1AmmoAmount .." bullets.")
	elseif TheWeapon == "weapon2" then
		ply:Give(CH_ArmoryRobbery.Weapons.Weapon2WepName)
		ply:GiveAmmo(CH_ArmoryRobbery.Weapons.Weapon2AmmoAmount, CH_ArmoryRobbery.Weapons.Weapon2AmmoType)
		DarkRP.notify(ply, 1, 5,  "You have retrieved an ".. CH_ArmoryRobbery.Weapons.Weapon2Name .." with ".. CH_ArmoryRobbery.Weapons.Weapon2AmmoAmount .." bullets.")
	elseif TheWeapon == "weapon3" then
		ply:Give(CH_ArmoryRobbery.Weapons.Weapon3WepName)
		ply:GiveAmmo(CH_ArmoryRobbery.Weapons.Weapon3AmmoAmount, CH_ArmoryRobbery.Weapons.Weapon3AmmoType)
		DarkRP.notify(ply, 1, 5,  "You have retrieved an ".. CH_ArmoryRobbery.Weapons.Weapon3Name .." with ".. CH_ArmoryRobbery.Weapons.Weapon3AmmoAmount .." bullets.")
	end
	
	ply.WeaponArmoryDelay = true
	timer.Simple( CH_ArmoryRobbery.Weapons.Cooldown * 60, function()
		if IsValid( ply ) then
			ply.WeaponArmoryDelay = false
		end
	end )
end )

util.AddNetworkString( "ARMORY_StripWeapon" )
net.Receive( "ARMORY_StripWeapon", function(length, ply)
	local TheWeapon = net.ReadString()
	
	for _, ent in ipairs( ents.FindByClass( "police_armory" ) ) do
		if IsValid( ent ) and ply:GetPos():DistToSqr( ent:GetPos() ) > 10000 then
			DarkRP.notify(ply, 1, 5,  "You are not close enough to the armory to deposit a weapon!")
			return
		end
	end
	
	if not table.HasValue( CH_ArmoryRobbery.Config.GovernmentTeams, team.GetName( ply:Team() ) ) then
		DarkRP.notify(ply, 1, 5, "You are not allowed to deposit weapons with your current team!")
		return
	end
	
	if TheWeapon == "weapon1" then
		ply:StripWeapon(CH_ArmoryRobbery.Weapons.Weapon1WepName)
		DarkRP.notify(ply, 1, 5,  "You have deposited your ".. CH_ArmoryRobbery.Weapons.Weapon1Name ..".")
	elseif TheWeapon == "weapon2" then
		ply:StripWeapon(CH_ArmoryRobbery.Weapons.Weapon2WepName)
		DarkRP.notify(ply, 1, 5,  "You have deposited your ".. CH_ArmoryRobbery.Weapons.Weapon2Name ..".")
	elseif TheWeapon == "weapon3" then
		ply:StripWeapon(CH_ArmoryRobbery.Weapons.Weapon3WepName)
		DarkRP.notify(ply, 1, 5,  "You have deposited your ".. CH_ArmoryRobbery.Weapons.Weapon3Name ..".")
	end

end )