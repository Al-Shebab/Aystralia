zrush = zrush or {}
zrush.f = zrush.f or {}
zrush.utility = zrush.utility or {}

////////////////////////////////////////////
/////////////// DEFAULT ////////////////////
////////////////////////////////////////////
if SERVER then
	// Basic notify function
	function zrush.f.Notify(ply, msg, ntfType)
		if IsValid(ply) then
			if (ntfType == 1) then
				ply:EmitSound("zrush_sfx_error")
			end

			if DarkRP then
				DarkRP.notify(ply, ntfType, 8, msg)
			else
				ply:ChatPrint(msg)
			end
		end
	end

	//Used to fix the Duplication Glitch
	function zrush.f.CollisionCooldown(ent)
		if ent.zrush_CollisionCooldown == nil then
			ent.zrush_CollisionCooldown = true

			timer.Simple(0.1,function()
				if IsValid(ent) then
					ent.zrush_CollisionCooldown = false
				end
			end)

			return false
		else
			if ent.zrush_CollisionCooldown then
				return true
			else
				ent.zrush_CollisionCooldown = true

				timer.Simple(0.1,function()
					if IsValid(ent) then
						ent.zrush_CollisionCooldown = false
					end
				end)
				return false
			end
		end
	end

	// This updates the Machine UI
	util.AddNetworkString("zrush_UpdateMachineUI_net")
	function zrush.f.UpdateMachineUI(ent, UpdateShop)
		timer.Simple(0.1, function()
			if IsValid(ent) then
				zrush.f.Debug("zrush.f.UpdateMachineUI")

				net.Start("zrush_UpdateMachineUI_net")
				net.WriteEntity(ent)
				net.WriteTable(zrush.f.Machine_ReturnInstalledModules(ent))
				net.WriteBool(UpdateShop)
				net.Broadcast()
			end
		end)
	end

	// This Updates the Machine Sound
	util.AddNetworkString("zrush_UpdateMachineSound_net")
	function zrush.f.UpdateMachineSound(ent)
		timer.Simple(0.1, function()
			if (IsValid(ent)) then
				net.Start("zrush_UpdateMachineSound_net")
				net.WriteEntity(ent)
				net.SendPVS(ent:GetPos())
			end
		end)
	end

	// This gets called when we change the state of a entity
	function zrush.f.SetMachineState(state, ent)
		if (state ~= ent:GetState()) then
			zrush.f.Debug("(" .. ent:EntIndex() .. ") Machine(" .. ent:GetClass() .. ") State: " .. state)
			ent:SetState(state)
		end
	end

	// This creates a explosion for a entity
	function zrush.f.EntityExplosion(ent, EntityID, DoesDamage)
		local aEnt = ent

		if (string.sub(aEnt:GetClass(), 1, 12) == "zrush_barrel") then
			net.Start("zrush_CloseFuelSplitUI_net")
			net.WriteEntity(aEnt)
			net.Broadcast()
		else
			net.Start("zrush_CloseMachineUI_net")
			net.WriteEntity(aEnt)
			net.Broadcast()
			zrush.f.SetMachineState("EXPLODING", aEnt)
		end

		zrush.f.Timer_Remove("zrush_working_" .. aEnt:EntIndex())
		zrush.f.Timer_Remove("zrush_explosiontimer_" .. aEnt:EntIndex())

		local radius = zrush.config.Machine[EntityID].OverHeat_Radius or 100

		if (DoesDamage) then
			for k, v in pairs(zrush_PlayerList) do
				if (IsValid(v) and v:IsPlayer() and v:Alive() and zrush.f.InDistance(v:GetPos(), ent:GetPos(), radius)) then
					v:TakeDamage(zrush.config.Machine[EntityID].OverHeat_Damage or 10, aEnt, aEnt)
				end
			end
		end

		local vPoint = aEnt:GetPos()
		local effectdata = EffectData()
		local scale = (1 / 200) * radius
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(scale)
		util.Effect("Explosion", effectdata)

		timer.Simple(0.1, function()
			if (IsValid(aEnt)) then
				aEnt:Remove()
			end
		end)
	end

	// These are the attachment points IDs the machine have
	zrush.utility.MachineSockets = zrush.utility.MachineSockets or {}
	zrush.utility.MachineSockets["Drill"] = {1, 2, 3}
	zrush.utility.MachineSockets["Burner"] = {1, 2, 3}
	zrush.utility.MachineSockets["Pump"] = {1, 2, 3}
	zrush.utility.MachineSockets["Refinery"] = {1, 2, 3, 4}

	// A function for created module sockets
	function zrush.f.CreateSockets(ent)
		local count = math.Clamp(zrush.config.Machine[ent.MachineID].Module_Sockets, 1, table.Count(zrush.utility.MachineSockets[ent.MachineID]))
		ent.ModuleSocket = ent.ModuleSocket or {}

		for i = 1, count do
			local aPoint = zrush.utility.MachineSockets[ent.MachineID][i]
			local attach = ent:GetAttachment(aPoint)
			local socket = ents.Create("zrush_animbase")
			socket:SetModel("models/zerochain/props_oilrush/zor_module_socket.mdl")
			socket:SetPos(attach.Pos)
			local ang = attach.Ang
			ang:RotateAroundAxis(attach.Ang:Right(), -90)
			ang:RotateAroundAxis(attach.Ang:Up(), -180)
			socket:SetAngles(ang)
			socket:Spawn()
			socket:Activate()
			socket:SetParent(ent, aPoint)

			local atable = {
				ModuleID = -1,
				Module = nil,
				attachpoint = aPoint
			}

			table.insert(ent.ModuleSocket, atable)
		end
	end
else
	local wMod = ScrW() / 1920
	local hMod = ScrH() / 1080
	local zrush_fuelbuyer_notifictations = {}
	local zrush_interface_notifictations = {}

	// This creates a custom fuel buyer notification
	function zrush.f.FuelBuyerNotify(npc, msg, time)
		local npcName = npc:GetNPCName()
		local NotifyPanel
		// Notification panel
		NotifyPanel = vgui.Create("DNotify")
		NotifyPanel:SetPos(wMod * 355, hMod * 240)
		NotifyPanel:SetSize(200 * wMod, 330 * hMod)
		NotifyPanel:SetLife(time)
		NotifyPanel:SizeToContentsY(3)
		table.insert(zrush_fuelbuyer_notifictations, NotifyPanel)
		// Gray background panel
		local bg = vgui.Create("DPanel", NotifyPanel)
		bg:Dock(FILL)
		bg:SetBackgroundColor(Color(64, 64, 64))
		// Image ( parented to background panel )
		local img = vgui.Create("DImage", bg)
		img:SetPos(11 * wMod, 11 * hMod)
		img:SetSize(177 * wMod, 177 * hMod)
		img:SetImage(zrush.config.FuelBuyer.NotifyImage)
		// A label message ( parented to background panel )
		local lbl = vgui.Create("DLabel", bg)
		lbl:SetPos(11 * wMod, 190 * hMod)
		lbl:SetSize(128 * wMod, 50 * hMod)
		lbl:SetText(npcName .. ": ")
		lbl:SetTextColor(Color(125, 125, 255))
		lbl:SetFont("zrush_npc_font04")
		lbl:SetWrap(true)
		lbl:SetContentAlignment(7)
		// A label message ( parented to background panel )
		local lblmsg = vgui.Create("DLabel", bg)
		lblmsg:SetPos(11 * wMod, 215 * hMod)
		lblmsg:SetSize(190 * wMod, 300 * hMod)
		lblmsg:SetText(msg)
		lblmsg:SetTextColor(zrush.default_colors["white01"])
		lblmsg:SetFont("zrush_npc_font05")
		lblmsg:SetWrap(true)
		lblmsg:SetContentAlignment(7)
		// Add the background panel to the notification
		NotifyPanel:AddItem(bg)
	end

	// This destroys all active notifications
	function zrush.f.FuelBuyerNotify_RemoveAll()
		for k, v in pairs(zrush_fuelbuyer_notifictations) do
			if (IsValid(v)) then
				v:Remove()
			end
		end
		for k, v in pairs(zrush_interface_notifictations) do
			if (IsValid(v)) then
				v:Remove()
			end
		end
	end

	net.Receive("zrush_UpdateMachineSound_net", function(len)
		local ent = net.ReadEntity()

		if IsValid(ent) and zrush.f.FunctionValidater(ent.UpdateSoundInfo) then
			ent:UpdateSoundInfo()
		end
	end)

	// This adds a Custom Notify for the Machine Interface
	function zrush.f.InterfaceNotify(msg, time,type)

		local NotifyPanel

		NotifyPanel = vgui.Create("DNotify")
		NotifyPanel:SetPos(wMod * 360, hMod * 550)
		NotifyPanel:SetSize(1200 * wMod, 50 * hMod)
		NotifyPanel:SetLife(time)
		NotifyPanel:SizeToContentsX(3)
		NotifyPanel:SizeToContentsY(3)

		table.insert(zrush_interface_notifictations, NotifyPanel)

		local bg = vgui.Create("DPanel", NotifyPanel)
		bg:Dock(FILL)
		bg:SetBackgroundColor(Color(55, 55, 55))

		local lblmsg

		if (type == 0) then
			surface.PlaySound("common/warning.wav")

			local lbl = vgui.Create("DLabel", bg)
			lbl:SetPos(11 * wMod, 5 * hMod)
			lbl:SetSize(300 * wMod, 100 * hMod)
			lbl:SetText("Attention! ")
			lbl:SetTextColor(Color(255, 125, 125))
			lbl:SetFont("zrush_notify_font01")
			lbl:SetWrap(true)
			lbl:SetContentAlignment(7)
			// 164285642
			lblmsg = vgui.Create("DLabel", bg)
			lblmsg:SetPos(200 * wMod, 5 * hMod)
			lblmsg:SetSize(1500 * wMod, 300 * hMod)
			lblmsg:SetText(msg)
			lblmsg:SetTextColor(zrush.default_colors["white01"])
			lblmsg:SetFont("zrush_notify_font01")
			lblmsg:SetWrap(true)
			lblmsg:SetContentAlignment(7)
		elseif (type == 1) then
			surface.PlaySound("common/bugreporter_succeeded.wav")

			local lbl = vgui.Create("DLabel", bg)
			lbl:SetPos(11 * wMod, 5 * hMod)
			lbl:SetSize(300 * wMod, 100 * hMod)
			lbl:SetText("Info! ")
			lbl:SetTextColor(Color(255, 255, 125))
			lbl:SetFont("zrush_notify_font01")
			lbl:SetWrap(true)
			lbl:SetContentAlignment(7)

			lblmsg = vgui.Create("DLabel", bg)
			lblmsg:SetPos(100 * wMod, 5 * hMod)
			lblmsg:SetSize(1500 * wMod, 300 * hMod)
			lblmsg:SetText(msg)
			lblmsg:SetTextColor(zrush.default_colors["white01"])
			lblmsg:SetFont("zrush_notify_font01")
			lblmsg:SetWrap(true)
			lblmsg:SetContentAlignment(7)
		end

		NotifyPanel:AddItem(bg)
	end

	// This moves our notify
	hook.Add("Think", "a.zrush.NotificationsMover", function()
		for k, v in pairs(zrush_interface_notifictations) do
			if (IsValid(v) and v.y > 80) then
				v:SetPos(wMod * 360, hMod * (v.y - (0.25 * FrameTime() ) ) )
			end
		end
	end)

	function zrush.f.LoopedSound(ent, soundfile, shouldplay,pitch)
		if shouldplay and zrush.f.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 2000) then
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] == nil then
				ent.Sounds[soundfile] = CreateSound(ent, soundfile)
			end

			// If the sound is not playing or it should be updated then start/restart the sound
			if ent.Sounds[soundfile]:IsPlaying() == false or ent.UpdateSound then
				ent.Sounds[soundfile]:Play()
				ent.Sounds[soundfile]:ChangeVolume(1, 0)
				ent.Sounds[soundfile]:ChangePitch(pitch, 1)

				ent.UpdateSound = false
			end
		else
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] ~= nil and ent.Sounds[soundfile]:IsPlaying() == true then
				ent.Sounds[soundfile]:ChangeVolume(0, 0)
				ent.Sounds[soundfile]:Stop()
				ent.Sounds[soundfile] = nil
			end
		end
	end

	// Used for Color Lerp
	function zrush.f.LerpColor(t, c1, c2)
		local c3 = Color(0, 0, 0)
		c3.r = Lerp(t, c1.r, c2.r)
		c3.g = Lerp(t, c1.g, c2.g)
		c3.b = Lerp(t, c1.b, c2.b)
		c3.a = Lerp(t, c1.a, c2.a)

		return c3
	end
end

// Tells us if the function is valid
function zrush.f.FunctionValidater(func)
	if (type(func) == "function") then return true end
	// 164285642
	return false
end

// Does the player have the correct Rank?
function zrush.f.HasAllowedRank(ply, AllowedRanks)
	if IsValid(ply) and AllowedRanks then
		if table.Count(AllowedRanks) > 0 then
			if xAdmin then

				local HasRank = false
				for k, v in pairs(AllowedRanks) do
					if ply:IsUserGroup(k) then
						HasRank = true
						break
					end
				end
				return HasRank
			else
				if AllowedRanks[zrush.f.GetPlayerRank(ply)] then
					return true
				else
					return false
				end
			end
		else
			return true
		end
	else
		return false
	end
end

// Does the player have the correct Job?
function zrush.f.HasAllowedJob(ply, AllowedJobs)
	if IsValid(ply) and AllowedJobs then
		if table.Count(AllowedJobs) > 0 then
			return AllowedJobs[zrush.f.GetPlayerJobName(ply)]
		else
			return true
		end
	else
		return false
	end
end

// Checks if the distance between pos01 and pos02 is smaller then dist
function zrush.f.InDistance(pos01, pos02, dist)
	return pos01:DistToSqr(pos02) < (dist * dist)
end

// Used for Debug
function zrush.f.Debug(mgs)
	if (zrush.config.Debug) then
		if istable(mgs) then
			print("[    DEBUG    ] Table Start >")
			PrintTable(mgs)
			print("[    DEBUG    ] Table End <")
		else
			print("[    DEBUG    ] " .. mgs)
		end
	end
end

// Used to concat the keys of a table
function zrush.f.KeyTableConcat(_tbl, concator)
	local str = ""

	local count = 1
	for k, v in pairs(_tbl) do
		str = str .. tostring(k)
		if count < table.Count(_tbl) then
			str = str .. concator
		end
		count = count + 1
	end

	return str
end
////////////////////////////////////////////
////////////////////////////////////////////





////////////////////////////////////////////
///////////////// OWNER ////////////////////
////////////////////////////////////////////
if SERVER then
	// This saves the owners SteamID
	function zrush.f.SetOwner(ent, ply)
		if IsValid(ply) then

			zrush.f.SetOwnerID(ent, ply:SteamID())

			if CPPI then
				ent:CPPISetOwner(ply)
			end
		else
			zrush.f.SetOwnerID(ent, "world")
		end
	end
	// 164285642
	function zrush.f.SetOwnerID(ent, id)
		if IsValid(ent) then
			ent:SetNWString("zrush_Owner", id)
		end
	end
end

	// This checks if the player is a admin
	function zrush.f.IsAdmin(ply)
		if IsValid(ply) then
			if xAdmin then
				//xAdmin Support
				return ply:IsAdmin()
			elseif sam then
				return ply:IsAdmin()
			else
				if zrush.config.AdminRanks[zrush.f.GetPlayerRank(ply)] then
					return true
				else
					return false
				end
			end
		else
			return false
		end
	end

	// This returns the entites owner SteamID
	function zrush.f.GetOwnerID(ent)
		return ent:GetNWString("zrush_Owner", "nil")
	end

	// This returns the owner
	function zrush.f.GetOwner(ent)
		if IsValid(ent) then
			local id = ent:GetNWString("zrush_Owner", "nil")
			local ply = player.GetBySteamID(id)

			if IsValid(ply) then
				return ply
			else
				return false
			end
		else
			return false
		end
	end

	// This returns true if the input is the owner
	function zrush.f.IsOwner(ply, ent)
		if IsValid(ent) and IsValid(ply) then
			if zrush.config.EquipmentSharing then
				return true
			else
				local id = ent:GetNWString("zrush_Owner", "nil")
				local ply_id = ply:SteamID()

				if (id == ply_id or id == "world") then
					return true
				else
					return false
				end
			end
		else
			return false
		end
	end
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
///////////////// Timer ////////////////////
////////////////////////////////////////////
concommand.Add("zrush_debug_Timer_PrintAll", function(ply, cmd, args)
	if zrush.f.IsAdmin(ply) then
		zrush.f.Timer_PrintAll()
	end
end)

if zrush_TimerList == nil then
	zrush_TimerList = {}
end

function zrush.f.Timer_PrintAll()
	PrintTable(zrush_TimerList)
end

function zrush.f.Timer_Create(timerid, time, rep, func)
	if zrush.f.FunctionValidater(func) then
		timer.Create(timerid, time, rep, func)
		table.insert(zrush_TimerList, timerid)
	end
end

function zrush.f.Timer_Remove(timerid)
	if timer.Exists(timerid) then
		timer.Remove(timerid)
		table.RemoveByValue(zrush_TimerList, timerid)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
////////////// Rank / Job //////////////////
////////////////////////////////////////////
// Returns the player rank / usergroup
function zrush.f.GetPlayerRank(ply)
	if SG then
		return ply:GetSecondaryUserGroup() or ply:GetUserGroup()
	else
		return ply:GetUserGroup()
	end
end

// Returns the players job
function zrush.f.GetPlayerJob(ply)
	return ply:Team()
end

// Returns the players job
function zrush.f.GetPlayerJobName(ply)
	return team.GetName( zrush.f.GetPlayerJob(ply) )
end
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
//////////////// CUSTOM ////////////////////
////////////////////////////////////////////
function zrush.f.VCMod_Installed()
	return VC ~= nil
end

function zrush.f.CatchMachinesByModuleType(m_type)
	local machines = {}

	if (m_type == "speed") then
		machines = {
			["Drill"] = true,
			["Burner"] = true,
			["Pump"] = true,
			["Refinery"] = true,
		}
	elseif (m_type == "production") then
		machines = {
			["Burner"] = true,
			["Pump"] = true,
			["Refinery"] = true,
		}
	elseif (m_type == "antijam") then
		machines = {
			["Drill"] = true,
			["Pump"] = true,
		}
	elseif (m_type == "cooling") then
		machines = {
			["Burner"] = true,
			["Refinery"] = true,
		}
	elseif (m_type == "refining") then
		machines = {
			["Refinery"] = true,
		}
	elseif (m_type == "pipes") then
		machines = {
			["Drill"] = true,
		}
	end

	return machines
end

// This returns the module with the specified ID
function zrush.f.FindModuleDataByType(atype)
	local tModule

	for k, v in pairs(zrush.AbilityModules) do
		if (v.type == atype) then
			tModule = v
			break
		end
	end

	return tModule
end

// This returns the machine with the specified MachineID
function zrush.f.FindMachineDataByID(MachineID)
	local tMachine

	for k, v in pairs(zrush.MachineShop) do
		if (v.machineID == MachineID) then
			tMachine = v
			break
		end
	end

	return tMachine
end

// This returns the total sell value of the machine
function zrush.f.ReturnMachineCrateValue(machinecrate, InstalledModules)
	local totalValue = 0

	if (InstalledModules and table.Count(InstalledModules) > 0) then
		for k, v in pairs(InstalledModules) do
			local mData = zrush.AbilityModules[v]
			local earning = mData.price * zrush.config.SellValue
			totalValue = totalValue + earning
		end
	end

	local machineData = zrush.f.FindMachineDataByID(machinecrate:GetMachineID())
	totalValue = totalValue + machineData.price * zrush.config.SellValue

	return totalValue
end

// This returns the Final Boost Value
function zrush.f.ReturnBoostValue(machineID, BoostType, machine)
	if not IsValid(machine) then return end
	local boostValue = 0

	if BoostType == "speed" and zrush.f.FunctionValidater(machine.GetSpeedBoost) then
		boostValue = math.Clamp(zrush.config.Machine[machineID].Speed * (1 - machine:GetSpeedBoost()), 0.1, 99)
	elseif BoostType == "production" and zrush.f.FunctionValidater(machine.GetProductionBoost) then
		boostValue = zrush.config.Machine[machineID].Amount * (1 + machine:GetProductionBoost())
	elseif BoostType == "antijam" and zrush.f.FunctionValidater(machine.GetAntiJamBoost) then
		if IsValid(machine) then
			local hole = machine:GetHole()

			if IsValid(hole) and zrush.f.FunctionValidater(hole.GetChaosEventBoost) then
				boostValue = math.Clamp((zrush.config.Machine[machineID].JamChance + hole:GetChaosEventBoost()) * (1 - machine:GetAntiJamBoost()), 0, 99999)
			end
		end
	elseif BoostType == "cooling" and zrush.f.FunctionValidater(machine.GetCoolingBoost) then
		local chaoeseventBoost = 0

		if (machine:GetClass() == "zrush_burner") then
			local hole = machine:GetHole()

			if IsValid(hole) and zrush.f.FunctionValidater(hole.GetChaosEventBoost) then
				chaoeseventBoost = hole:GetChaosEventBoost()
			end
		end

		boostValue = math.Clamp((zrush.config.Machine[machineID].OverHeat_Chance + chaoeseventBoost) * (1 - machine:GetCoolingBoost()), 0, 99999)
	elseif BoostType == "pipes" and zrush.f.FunctionValidater(machine.GetExtraPipes) then
		boostValue = zrush.config.Machine[machineID].MaxHoldPipes + machine:GetExtraPipes()
	elseif BoostType == "refining" and zrush.f.FunctionValidater(machine.GetRefineBoost) and zrush.f.FunctionValidater(machine.GetFuelTypeID) then
		boostValue = math.Clamp(zrush.Fuel[machine:GetFuelTypeID()].refineoutput * (1 + machine:GetRefineBoost()), 0.01, 1)
	end

	boostValue = math.Round(boostValue, 2)

	return boostValue
end

function zrush.f.BarrelRank_PickUpCheck(ply, AllowedRanks)
	if zrush.config.Barrel.Rank_PickUpCheck then
		if zrush.f.HasAllowedRank(ply, AllowedRanks) then
			return true
		else
			return false
		end
	else
		return true
	end
end
////////////////////////////////////////////
////////////////////////////////////////////
