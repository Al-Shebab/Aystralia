AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_tierprinters_config.lua")
include("shared.lua")
include("sh_tierprinters_config.lua")

-- Creating the net message stuff
util.AddNetworkString("opr_openui")
util.AddNetworkString("opr_withdraw")
util.AddNetworkString("opr_upgrade")
util.AddNetworkString("opr_recharge")
util.AddNetworkString("opr_notification")

if TierPrinters.Config.PickUpAble then
	hook.Add("PhysgunPickup", "Printer_pickup", function(ply, ent)
		if ent:GetClass() == "tierp_printer" then
			return true
		end
	end)
end

-- Setting up the entity when created
function ENT:Initialize()
	-- Using the custom model
	self:SetModel("models/freeman/money_printer.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	if TierPrinters.Config.PickUpAbleGrav then
		phys:SetMass(30)
	end

	self:CPPISetOwner(self:Getowning_ent())

	-- Setting the default tier (tier 1)
	if self:GetTier() == 0 then
		self:SetTier(1)
	end
	print(self:GetFirstSpawn())
	-- Setting the battery life (100%)
	if !self:GetFirstSpawn() then
		self:SetBattery(100)
		self:SetFirstSpawn(true)
		-- Setting the default entity health
		self:SetCHealth(TierPrinters.Config.Health)
	end

	-- Triggers the starting of both the printing and battery usage.
	timer.Simple(TierPrinters.Config.PrintTime, function() if not IsValid(self) then return end self:Print() end)
	-- Checks to see if battery system is enabled
	if TierPrinters.Config.BatterySystem then
		timer.Simple(TierPrinters.Config.BatteryTime, function() if not IsValid(self) then return end self:Battery() end)
	end

	if TierPrinters.Config.SoundSystem then
		self.sound = CreateSound(self, Sound(TierPrinters.Config.SoundDir))
		self.sound:SetSoundLevel(52)
		self.sound:PlayEx(1, 100)
	end

end

-- Basic health system, deduct damage from heath, if health is <= 0 then run destroy function and remove the entity.
function ENT:OnTakeDamage(dmg)
	local InputHealth = (self:GetCHealth() or TierPrinters.Config.Health) - dmg:GetDamage()
	self:SetCHealth(InputHealth)
	if self:GetCHealth() <= 0 then
		self:Destruct()
		self:Remove()
	end
end

-- Destroy function, just some fanc effects.
function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)

	-- Notify printer owner the printer has been destroyed 
	net.Start("opr_notification")
		net.WriteString(TierPrinters.Config.Language.Destroyed)
	net.Send(self:Getowning_ent())
	if TierPrinters.blogs then
		TierPrinters.blogs:Log(bLogs:FormatPlayer(self:Getowning_ent()) .. "'s printer was destroyed.")
	end
end

-- Print money
function ENT:Print()
	if not IsValid(self) then return end
	-- Used to trigger the next print
	timer.Simple(TierPrinters.Config.PrintTime, function()
		if not IsValid(self) then return end
		self:Print()
	end)
	-- Checks to see if the battery is >0 before printing
	if self:GetBattery() == 0 then return end
	-- Prints (adds) the money
	local amount = TierPrinters.Config.Tiers[self:GetTier()].amount
	local limit = TierPrinters.Config.Tiers[self:GetTier()].limit

	if limit then
		if self:GetMoney() >= limit then return end
		self:SetMoney(math.Clamp(self:GetMoney() + amount, 0, limit))
	else
		self:SetMoney(self:GetMoney() + amount)
	end
	
	hook.Call("TierPrintersPrint", nil, self:Getowning_ent(), self, amount)
end

-- The batter system
-- Checks to see if the battery is enabled
if TierPrinters.Config.BatterySystem then
	-- Basic battery life system
	function ENT:Battery()
		if not IsValid(self) then return end
		-- Used to trigger the next battery decrease
		timer.Simple(TierPrinters.Config.BatteryTime, function()
			if not IsValid(self) then return end
			self:Battery()
		end)
	
		-- Decreases battery if it is >0
		if self:GetBattery() == 0 then return end
		self:SetBattery(self:GetBattery()-1)
	end
	
	-- Used for the recharge button within the UI
	function ENT:BatteryRecharge(ply)
		if self:GetBattery() == 100 then return end
		-- Basic check for enough money
		if ply:getDarkRPVar("money") >= TierPrinters.Config.BatteryPrice then
			-- Sets battery life and takes money
			self:SetBattery(100)
			ply:addMoney(-TierPrinters.Config.BatteryPrice)
			-- notify player of success
			net.Start("opr_notification")
				net.WriteString(string.format(TierPrinters.Config.Language.ConfRecharge, TierPrinters.Config.BatteryPrice))
			net.Send(ply)
			if TierPrinters.blogs then
				TierPrinters.blogs:Log(bLogs:FormatPlayer(self:Getowning_ent()) .. "'s printer was recharged.")
			end
		end
	end

	-- Simple function to easily control the battery enttiys events for possible future use 
	function ENT:BatteryRechargeEntity(ply)
		if self:GetBattery() == 100 then return end
		self:SetBattery(100)
	end
end

-- Just destroys the printer if it's under water 
function ENT:Think()
	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end

	if TierPrinters.Config.SoundSystem then
		if self:GetBattery() == 0 then
			self.sound:Stop()
		else
			self.sound:Play()
		end
	end
end

-- Trigger player interactions
function ENT:Use( ply )
	-- Basic checks
	local tr = ply:GetEyeTrace().HitPos
	local pos = self:WorldToLocal(tr)
	-- Used for interactive 3D2D panel
	if !(pos.x < 30.662 and pos.x > 30.6031 and pos.y < 15.58 and pos.y > -0.63 and pos.z < 44.26 and pos.z > 41.03) then return end

	-- Open UI
	net.Start("opr_openui")
		net.WriteEntity(self)
	net.Send(ply)
end


-- Receive from pressing the withdraw button
net.Receive("opr_withdraw", function(_, ply)
	local printer = net.ReadEntity()
	if not IsEntity(printer) then return end
	if not (printer:GetClass() == "tierp_printer") then return end
	if ply:GetPos():Distance(printer:GetPos()) > 150 then return end	
	-- Calls the take money function
	printer:TakeMoney(ply)
end)

-- Receive from attempting to upgrade a tier
net.Receive("opr_upgrade", function(_, ply)

	-- Calls the upgrade function
	local tier = net.ReadInt(32)
	local printer = net.ReadEntity()
	if not IsEntity(printer) then return end
	if not (printer:GetClass() == "tierp_printer") then return end
	if ply:GetPos():Distance(printer:GetPos()) > 150 then return end	

	-- This checks for the config option on allowing anyone to upgrade tiers. To prevent players bypassing the tier restrictions
	if !(TierPrinters.Config.AnyoneUpgrade) then
		-- Chceks to make sure the player is the printer owner
		if !(ply == printer:Getowning_ent()) then
			-- notify the player of failure
			net.Start("opr_notification")
				net.WriteString(TierPrinters.Config.Language.ErrorOtherUpgrade)
			net.Send(ply)
			return
		end 
	end

	if TierPrinters.Config.ForceNextTier then
		if !(tier == printer:GetTier() + 1) then
			net.Start("opr_notification")
				net.WriteString(TierPrinters.Config.Language.ErrorStageUpgrade)
			net.Send(ply)
			return
		end
	end

	printer:Upgrade(tier, ply)
end)

-- Receive from UI recharge button
net.Receive("opr_recharge", function(_, ply)
	local printer = net.ReadEntity()
	if not IsEntity(printer) then return end
	if not (printer:GetClass() == "tierp_printer") then return end
	if ply:GetPos():Distance(printer:GetPos()) > 150 then return end	

	-- Checks to make sure player aren't trying to bypass
	if TierPrinters.Config.BatteryUI then
		-- Calls ther battery recharge function
		printer:BatteryRecharge(ply)
	end
end)


-- The upgrade function
function ENT:Upgrade(tier, ply)
	-- Basic checks
	if self:GetTier() >= tier then return end
	if tier > #TierPrinters.Config.Tiers then return end
	for k, v in ipairs(TierPrinters.Config.Tiers) do
		if k == tier then
			if v.customCheck ~= nil then
				if !(v.customCheck(ply)) then
					net.Start("opr_notification")
						net.WriteString(TierPrinters.Config.Language.ErrorNoRequrirements)
					net.Send(ply)
					return
				end
			end
		end
	end

	-- Same sytem as client side to ensure that all the tiers get paid for when jumping to higher tiers
	local charge = 0
	for k, v in ipairs(TierPrinters.Config.Tiers) do
		if self:GetTier() >= k then
		elseif k > tier then
		else
			charge = charge + v.price
		end
	end

	-- Basic money check
	if ply:getDarkRPVar("money") >= charge then
		-- Sets the tier
		self:SetTier(tier)
		ply:addMoney(-charge)
		-- Notify player of success
		net.Start("opr_notification")
			net.WriteString(string.format(TierPrinters.Config.Language.SuccessfulUpgrade, tier, charge))
		net.Send(ply)
		if TierPrinters.blogs then
			TierPrinters.blogs:Log(bLogs:FormatPlayer(self:Getowning_ent()).."'s printer was upgraded to tier "..tier.." by "..bLogs:FormatPlayer(ply))
		end
	else
		-- Notify player of unsuccess
		net.Start("opr_notification")
			net.WriteString(TierPrinters.Config.Language.FailureUpgrade)
		net.Send(ply)
	end
end

-- The take money function
function ENT:TakeMoney(ply)
	-- Cehcks to see if there actually is money to take
	if self:GetMoney() == 0 then return end
	-- notifys the player that the money has been taken
	net.Start("opr_notification")
		net.WriteString(string.format(TierPrinters.Config.Language.TakingMoney, self:GetMoney()))
	net.Send(ply)
	-- Takes the money and resets the printer
	ply:addMoney(self:GetMoney())
	hook.Call("TierPrintersWithdraw", nil, ply, self, self:GetMoney())
	if TierPrinters.blogs then
		TierPrinters.blogs:Log(bLogs:FormatPlayer(self:Getowning_ent()).."'s printer had a withdrawal of "..self:GetMoney().." by "..bLogs:FormatPlayer(ply)..".")
	end
	self:SetMoney(0)
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end
-- Notes are primarily for myself, secondary for other. Helps me keep stuff neat, and allows others to follow along. Spelling/typo errors may be present within the notes 