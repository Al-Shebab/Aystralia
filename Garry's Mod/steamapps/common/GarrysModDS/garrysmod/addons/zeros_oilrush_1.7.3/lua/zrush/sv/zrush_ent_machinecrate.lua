if not SERVER then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.Machinecrate_Initialize(Machinecrate)
	Machinecrate:SetModel("models/zerochain/props_oilrush/zor_machinecrate.mdl")
	Machinecrate:PhysicsInit(SOLID_VPHYSICS)
	Machinecrate:SetMoveType(MOVETYPE_VPHYSICS)
	Machinecrate:SetSolid(SOLID_VPHYSICS)
	Machinecrate:SetUseType(SIMPLE_USE)

	if (zrush.config.Machine_NoCollide) then
		Machinecrate:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	local phys = Machinecrate:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
		phys:SetMass(150)
	end

	Machinecrate.Wait = true

	timer.Simple(1, function()
		if (IsValid(Machinecrate)) then
			Machinecrate.Wait = false
		end
	end)
	zrush.f.EntList_Add(Machinecrate)
end

// Called when a player presses e on the Machinecrate
function zrush.f.Machinecrate_OnUse(Machinecrate,ply)
	if (Machinecrate.Wait) then return end

	if (IsValid(ply) and ply:IsPlayer() and ply:Alive()) then


		//Do we have a machine selected?
		if (Machinecrate:GetMachineID() == "nil") then
			if (not zrush.f.IsOwner(ply, Machinecrate)) then
				zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)

				return
			end

			net.Start("zrush_MachineCrate_Open_net")
			net.WriteEntity(Machinecrate)
			net.Send(ply)
		else
			if (not zrush.f.IsOwner(ply, Machinecrate) and zrush.config.Machine["MachineCrate"].AllowSell == false) then
				zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)

				return
			end

			zrush.f.Machinecrate_SetCrateOccupied(Machinecrate,ply)

			Machinecrate.InstalledModules = Machinecrate.InstalledModules or {}
			net.Start("zrush_MachineCrateOB_Open_net")
			net.WriteEntity(Machinecrate)
			net.WriteTable(Machinecrate.InstalledModules)
			net.Send(ply)
		end
	end
end






util.AddNetworkString("zrush_MachineCrateOB_Open_net")
util.AddNetworkString("zrush_MachineCrateOB_Close_net")


util.AddNetworkString("zrush_MachineCrate_AddModules_net")

function zrush.f.Machinecrate_AddModules(Machinecrate,mTable)
	if mTable and istable(mTable) then
		Machinecrate.InstalledModules = {}
		table.CopyFromTo(mTable, Machinecrate.InstalledModules)

		timer.Simple(0.1, function()
			if (IsValid(Machinecrate)) then
				net.Start("zrush_MachineCrate_AddModules_net")
				net.WriteEntity(Machinecrate)
				net.WriteTable(mTable)
				net.SendPVS(Machinecrate:GetPos())
			end
		end)
	end
end

function zrush.f.Machinecrate_SetCrateOccupied(Machinecrate,player)
	local phys = Machinecrate:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

function zrush.f.Machinecrate_SetCrateFree(Machinecrate)
	local phys = Machinecrate:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end
end

util.AddNetworkString("zrush_MachineCrate_Close_net")
util.AddNetworkString("zrush_MachineCrate_Close_cl")

// This tells the Machinecrate that the client is no longer in its menu
net.Receive("zrush_MachineCrate_Close_cl", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()
	if IsValid(ent) and ent:GetClass() == "zrush_machinecrate" then
		zrush.f.Machinecrate_SetCrateFree(ent)
	end
end)
