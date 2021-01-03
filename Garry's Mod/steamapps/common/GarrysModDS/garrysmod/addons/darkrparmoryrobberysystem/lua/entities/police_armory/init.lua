AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function CH_ARMORY_SpawnPoliceArmory()	
	if not file.IsDir("craphead_scripts", "DATA") then
		file.CreateDir("craphead_scripts", "DATA")
	end
	 
	if not file.IsDir("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."", "DATA") then
		file.CreateDir("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."", "DATA")
	end
	
	if not file.Exists( "craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."/policearmory_location.txt", "DATA" ) then
		file.Write("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."/policearmory_location.txt", "0;-0;-0;0;0;0", "DATA")
	end
	
	local PositionFile = file.Read("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."/policearmory_location.txt", "DATA")
	 
	local ThePosition = string.Explode( ";", PositionFile )
		
	local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
	local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
		
	local PoliceArmory = ents.Create("police_armory")
	PoliceArmory:SetModel("models/props/cs_office/file_cabinet1_group.mdl")
	PoliceArmory:SetPos(TheVector)
	PoliceArmory:SetAngles(TheAngle)
	PoliceArmory:Spawn()
	PoliceArmory:PhysicsInit(0)
	PoliceArmory:SetMoveType(0)
	PoliceArmory:SetSolid(SOLID_VPHYSICS)
end
hook.Add( "Initialize", "CH_ARMORY_SpawnPoliceArmory", CH_ARMORY_SpawnPoliceArmory )

function CH_Armory_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."/policearmory_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( "New position for the police armory has been succesfully set." )
		ply:ChatPrint( "The police armory will respawn in 5 seconds. Move out the way." )
		
		-- Respawn the NPC
		for k, ent in ipairs( ents.FindByClass( "police_armory" ) ) do
			if IsValid( ent ) then
				ent:Remove()
			end
		end
		
		timer.Simple( 5, function()
			if IsValid( ply ) then
				CH_ARMORY_SpawnPoliceArmory()
				ply:ChatPrint( "The police armory has been respawned." )
			end
		end )
	else
		ply:ChatPrint( "Only administrators can perform this action." )
	end
end
concommand.Add( "policearmory_setpos", CH_Armory_Position )

function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and IsValid( caller ) then
		if ( self.lastUsed or CurTime() ) <= CurTime() then
			self.lastUsed = CurTime() + 2

			ARMORY_BeginRobbery( caller )
		end
	end
end