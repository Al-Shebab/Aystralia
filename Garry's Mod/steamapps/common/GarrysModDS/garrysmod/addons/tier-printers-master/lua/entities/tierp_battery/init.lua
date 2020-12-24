AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_tierprinters_config.lua")
include("shared.lua")
include("sh_tierprinters_config.lua")

util.AddNetworkString("opr_openui")
util.AddNetworkString("opr_withdraw")
util.AddNetworkString("opr_upgrade")
util.AddNetworkString("opr_recharge")
util.AddNetworkString("opr_notification")

-- Basic initiation stuff
function ENT:Initialize()
	self:SetModel("models/freeman/giant_battery.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.health = TierPrinters.Config.Health
end

-- Same health system as printer
function ENT:OnTakeDamage(dmg)
	self.health = (self.health or TierPrinters.Config.Health) - dmg:GetDamage()
	if self.health <= 0 then
		self:Destruct()
		self:Remove()
	end
end

-- Same destruction system as printer
function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

-- Same water chcek as printer
function ENT:Think()
	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end
end


-- Triggers the touch
function ENT:StartTouch( printer )
	-- Checks to make sure it's touching the printer
	if printer:GetClass() == "tierp_printer" then
		-- Checks printers battery life
		if printer:GetBattery() == 100 then return end
		-- "uses" the battery
		printer:BatteryRechargeEntity()
		self:Remove()
	end
end
