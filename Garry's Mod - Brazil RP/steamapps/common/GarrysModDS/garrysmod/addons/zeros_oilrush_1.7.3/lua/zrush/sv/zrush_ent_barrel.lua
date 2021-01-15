if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.Barrel_Initialize(Barrel)
	Barrel:SetModel("models/zerochain/props_oilrush/zor_barrel.mdl")
	Barrel:PhysicsInit(SOLID_VPHYSICS)
	Barrel:SetMoveType(MOVETYPE_VPHYSICS)
	Barrel:SetSolid(SOLID_VPHYSICS)
	Barrel:SetUseType(SIMPLE_USE)

	if (zrush.config.Machine_NoCollide) then
		Barrel:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	local phys = Barrel:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
		phys:SetMass(150)
	end

	Barrel:UseClientSideAnimation()
	//Barrel:SetUnFreezable(true)

	// This will be used to store the Pump/Refinery since the barrel cant be connected at both at the same time anyway
	Barrel.Machine = nil

	// A cooldown so it can only be attached/detached every 1 second
	Barrel.AttachCoolDown = false

	zrush.f.Barrel_UpdateVisual(Barrel)

	zrush.f.EntList_Add(Barrel)
end

// Called when a player presses e on the barrel
function zrush.f.Barrel_OnUse(Barrel,ply)


	if (Barrel:GetFuel() > 0 and not IsValid(Barrel.Machine)) then

		if zrush.config.FuelBuyer.SellMode == 2 then return end

		if not zrush.f.BarrelRank_PickUpCheck(ply, zrush.Fuel[Barrel:GetFuelTypeID()].ranks) then
			zrush.f.Notify(ply, zrush.language.VGUI["WrongUserGroup"], 1)

			return
		end

		net.Start("zrush_OpenFuelSplitUI_net")
		net.WriteEntity(Barrel)
		net.Send(ply)

		local phys = Barrel:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion(false)
		end
	end

	if IsValid(Barrel.Machine) then

		local class = Barrel.Machine:GetClass()
		if class == "zrush_pump" then
			zrush.f.Pump_DetachBarrel(Barrel.Machine)
		elseif class == "zrush_refinery" then

			if (Barrel:GetOil() > 0) then
				zrush.f.Refinery_DetachBarrel(Barrel.Machine,1, Barrel)

			elseif (Barrel:GetFuel() > 0 or (Barrel:GetFuel() <= 0 and Barrel:GetOil() <= 0)) then

				zrush.f.Refinery_DetachBarrel(Barrel.Machine,2, Barrel)
			end
		end
	end
end

// Called when the barrel gets removed
function zrush.f.Barrel_OnRemove(Barrel)

	if IsValid(Barrel.Machine) then
		local class = Barrel.Machine:GetClass()
		if class == "zrush_pump" then
			zrush.f.Pump_DetachBarrel(Barrel.Machine)
		elseif class == "zrush_refinery" then

			if Barrel:GetOil() > 0 then
				zrush.f.Refinery_DetachBarrel(Barrel.Machine,1, Barrel)
			elseif Barrel:GetFuel() > 0 then
				zrush.f.Refinery_DetachBarrel(Barrel.Machine,2, Barrel)
			end
		end
	end

	zrush.f.EntList_Remove(Barrel)
end

// Called when the barrel touches something
function zrush.f.Barrel_OnTouch(Barrel,other)
	if not IsValid(Barrel) then return end
	if not IsValid(other) then return end

	if (Barrel.AttachCoolDown) then return end

	if other:GetClass() == "zrush_pump" then

		if not IsValid(other:GetBarrel()) then
			zrush.f.Pump_AddBarrel(other,Barrel)
		end
	elseif other:GetClass() == "zrush_refinery" then

		if Barrel:GetOil() > 0 then

			if not IsValid(other:GetInputBarrel()) then
				zrush.f.Refinery_AttachBarrel(other,1, Barrel)
			end
		elseif Barrel:GetFuel() <= 0 and Barrel:GetOil() <= 0 then

			if not IsValid(other:GetOutputBarrel()) then
				zrush.f.Refinery_AttachBarrel(other,2, Barrel)
			end
		elseif Barrel:GetFuel() > 0 and Barrel:GetFuel() < zrush.config.Machine["Barrel"].Storage and Barrel:GetFuelTypeID() == other:GetFuelTypeID() then

			if not IsValid(other:GetOutputBarrel()) then
				zrush.f.Refinery_AttachBarrel(other,2, Barrel)
			end
		end
	end
end

// Called when the barrel gets damaged
function zrush.f.Barrel_OnTakeDamage(Barrel, dmg)
	if not Barrel.m_bApplyingDamage then
		Barrel.m_bApplyingDamage = true
		Barrel:TakePhysicsDamage(dmg)
		local damage = dmg:GetDamage()
		local entHealth = zrush.config.Machine["Barrel"].Health

		if (entHealth > 0) then
			Barrel.CurrentHealth = (Barrel.CurrentHealth or entHealth) - damage

			if (Barrel.CurrentHealth <= 0) then
				zrush.f.EntityExplosion(Barrel, "Barrel", true)
			end
		end

		Barrel.m_bApplyingDamage = false
	end
end


// Is the barrel full?
function zrush.f.Barrel_IsFull(Barrel)
	if (Barrel:GetOil() >= zrush.config.Machine["Barrel"].Storage or Barrel:GetFuel() >= zrush.config.Machine["Barrel"].Storage) then
		return true
	else
		return false
	end
end

// Adds liquid to the barrel
function zrush.f.Barrel_AddLiquid(Barrel,ltype, lamount)
	if (ltype == "Oil") then
		Barrel:SetOil(Barrel:GetOil() + lamount)
	else
		Barrel:SetFuelTypeID(ltype)
		Barrel:SetFuel(Barrel:GetFuel() + lamount)
	end

	zrush.f.Barrel_UpdateVisual(Barrel)
end

// Removes liquid from the barrel
function zrush.f.Barrel_RemoveLiquid(Barrel,ltype, lamount)
	if (ltype == "Oil") then
		Barrel:SetOil(Barrel:GetOil() - lamount)
	else
		Barrel:SetFuelTypeID(ltype)
		Barrel:SetFuel(Barrel:GetFuel() - lamount)
	end

	zrush.f.Barrel_UpdateVisual(Barrel)
end

// Emptys the Barrel
function zrush.f.Barrel_ResetLiquid(Barrel)
	Barrel:SetFuelTypeID(0)
	Barrel:SetOil(0)
	Barrel:SetFuel(0)
	zrush.f.Barrel_UpdateVisual(Barrel)
end

// Updates the Barrels color
function zrush.f.Barrel_UpdateVisual(Barrel)
	if Barrel:GetOil() > 0 then
		Barrel:SetColor(zrush.default_colors["grey02"])
	elseif Barrel:GetFuel() > 0 then
		Barrel:SetColor(zrush.Fuel[Barrel:GetFuelTypeID()].color)
	else
		Barrel:SetColor(zrush.default_colors["white01"])
	end
end

// Adds a cooldown so the barrel cant be detached again
function zrush.f.Barrel_GotDetached(Barrel)
	Barrel.AttachCoolDown = true

	timer.Simple(1, function()
		if (IsValid(Barrel)) then
			Barrel.AttachCoolDown = false
		end
	end)
end


util.AddNetworkString("zrush_OpenFuelSplitUI_net")
util.AddNetworkString("zrush_CloseFuelSplitUI_net")
util.AddNetworkString("zrush_FuelSplitUIGotClosed_net")
util.AddNetworkString("zrush_BarrelSplitFuel_net")
util.AddNetworkString("zrush_BarrelCollectFuel_net")

// This tells the Barrel that the client is no longer in its menu
net.Receive("zrush_FuelSplitUIGotClosed_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()

	if (IsValid(ent) and (ent:GetClass() == "zrush_barrel" or ent:GetClass() == "zrush_barrel_oil") and zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 300)) then

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
end)

// This Handles the Fuel Barrel Collect function
net.Receive("zrush_BarrelCollectFuel_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()

	if (IsValid(ent) and (ent:GetClass() == "zrush_barrel" or (ent:GetClass() == "zrush_barrel_oil" and ent:GetOil() <= 0 and ent:GetFuel() > 0 and ent:GetFuelTypeID() > 0)) and zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 200)) then

		if zrush.config.Barrel.Owner_PickUpCheck and not zrush.f.IsOwner(ply, ent) then
			zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)
			return
		end

		if ply:zrush_GetFuelBarrelCount() >= zrush.config.Player.FuelInvSize then
			zrush.f.Notify(ply, "Inventory Full! [" .. ply:zrush_GetFuelBarrelCount() .. "/" .. zrush.config.Player.FuelInvSize .. "]", 1)
		else
			local id, amount = ent:GetFuelTypeID(), math.Round(ent:GetFuel())

			if zrush.f.BarrelRank_PickUpCheck(ply, zrush.Fuel[id].ranks) then
				zrush.f.Notify(ply, "+" .. tostring(math.Round(ent:GetFuel())) .. " " .. zrush.Fuel[id].name, 0)
				ply:zrush_AddFuelBarrel(id, amount)
				SafeRemoveEntity(ent)
				zrush.f.Notify(ply, "[" .. ply:zrush_GetFuelBarrelCount() .. "/" .. zrush.config.Player.FuelInvSize .. "]", 0)
			end
		end
	end
end)

// This Handles the Fuel Barrel split function for VCMod
net.Receive("zrush_BarrelSplitFuel_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()

	if (IsValid(ent) and zrush.f.IsOwner(ply, ent) and ent:GetClass() == "zrush_barrel" and zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 200)) then
		if (ent:GetFuel() >= 20) then
			zrush.f.Barrel_SpawnVCModFuelCan(ent)
		else
			zrush.f.Notify(ply, zrush.language.VCMOD["NeedMoreFuel"], 1)
		end
	end
end)

// Extracts fuel and creates a VCMod FuelCan
function zrush.f.Barrel_SpawnVCModFuelCan(Barrel)
	if (not IsValid(Barrel.Machine) and Barrel:GetFuel() > 20 and Barrel:GetFuelTypeID() > 0) then
		local vc_fueltype = zrush.Fuel[Barrel:GetFuelTypeID()].vcmodfuel
		Barrel:SetFuel(Barrel:GetFuel() - 20)

		if (Barrel:GetFuel() <= 0) then
			Barrel:SetFuelTypeID(0)
			Barrel:SetFuel(0)
		end

		if (vc_fueltype == 0) then
			local ent = ents.Create("vc_pickup_fuel_petrol")
			ent:SetAngles(Angle(0, 0, 0))
			ent:SetPos(Barrel:GetPos() + Vector(0, 0, 100))
			ent:Spawn()
			ent:Activate()
		elseif (vc_fueltype == 1) then
			local ent = ents.Create("vc_pickup_fuel_diesel")
			ent:SetAngles(Angle(0, 0, 0))
			ent:SetPos(Barrel:GetPos() + Vector(0, 0, 100))
			ent:Spawn()
			ent:Activate()
		end
	end
end
