AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local BankVault
function SpawnBankVault()	
	if not file.IsDir("craphead_scripts", "DATA") then
		file.CreateDir("craphead_scripts", "DATA")
	end
	
	if not file.IsDir("craphead_scripts/bank_robbery/".. string.lower(game.GetMap()) .."", "DATA") then
		file.CreateDir("craphead_scripts/bank_robbery/".. string.lower(game.GetMap()) .."", "DATA")
	end
	
	if not file.Exists( "craphead_scripts/bank_robbery/".. string.lower(game.GetMap()) .."/bankvault_location.txt", "DATA" ) then
		file.Write("craphead_scripts/bank_robbery/".. string.lower(game.GetMap()) .."/bankvault_location.txt", "0;-0;-0;0;0;0", "DATA")
	end
	
	local PositionFile = file.Read("craphead_scripts/bank_robbery/".. string.lower(game.GetMap()) .."/bankvault_location.txt", "DATA")
	 
	local ThePosition = string.Explode( ";", PositionFile )
		
	local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
	local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
		
	BankVault = ents.Create("bank_vault")
	BankVault:SetModel("models/props/cs_assault/moneypallet.mdl")
	BankVault:SetPos(TheVector)
	BankVault:SetAngles(TheAngle)

	BankVault:Spawn()
	BankVault:SetMoveType(MOVETYPE_NONE)
	BankVault:SetSolid( SOLID_BBOX )
	BankVault:SetCollisionGroup(COLLISION_GROUP_PLAYER)
end
timer.Simple(1, SpawnBankVault)

function CH_BankVault_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/bank_robbery/".. string.lower(game.GetMap()) .."/bankvault_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint("New position for the bank vault has been succesfully set. Please restart your server!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("bankvault_setpos", CH_BankVault_Position)

function ENT:AcceptInput(ply, caller)
	if caller:IsPlayer() && !caller.CantUse then
		caller.CantUse = true
		timer.Simple(3, function()  caller.CantUse = false end)

		if caller:IsValid() then
			BANK_BeginRobbery( caller )
		end
	end
end