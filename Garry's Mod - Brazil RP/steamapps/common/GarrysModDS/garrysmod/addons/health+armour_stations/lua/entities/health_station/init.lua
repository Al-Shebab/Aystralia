--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[
	Basic config
]]--

local Hp_fill_rate = 5 -- random number between 1 and 5
local Hp_plyfill_rate = 0.2

local Hp_printer_health = 100
local Hp_printer_storage = 100

local overheatchance = 1000





--ENT.SeizeReward = 950

local PrintMore
function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox03a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.sparking = false
	self.damage = Hp_printer_health
	self.IsMoneyPrinter = true
	timer.Simple(math.random(1, 5), function() PrintMore(self) end)
	self:SetNWInt("Health_amount",0)

	--self.sound:SetSoundLevel(52)
	--self.sound:PlayEx(1, 100)
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or Hp_printer_health) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self:Getowning_ent(), 1, 4, "Your Health Station has exploded!")
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Remove()
end

function ENT:BurstIntoFlames()
	DarkRP.notify(self:Getowning_ent(), 0, 4, "Your Health Station is overheating!")
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

PrintMore = function(ent)
	if not IsValid(ent) then return end
	
	timer.Simple(0.1, function()
		if not IsValid(ent) then return end
		ent:CreateMoneybag()
	end)

end

function ENT:CreateMoneybag()
	if not IsValid(self) or self:IsOnFire() then return end
	
	local MoneyPos = self:GetPos()

	
		--local overheatchance = 500
		if math.random(1, overheatchance) == 3 then self:BurstIntoFlames() end
	

	local amount = self:GetNWInt("Health_amount") + 2
	
	if amount >= Hp_printer_storage then
		amount = Hp_printer_storage
	end
	
	if amount == 0 then
		amount = Hp_printer_storage
	end

	self:SetNWInt("Health_amount", amount)
	--DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
	self.sparking = false
	timer.Simple(math.random( 1, Hp_fill_rate ), function() PrintMore(self) end)
	
	--end
end

function ENT:Think()

	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end

	if not self.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end

local hp_no_spam = 0

function ENT:Use( activator, caller )

		--self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	
		
		if self:GetNWInt("Health_amount") > 0 and caller:Health() < 100 then 
		self:EmitSound("hl1/fvox/boop.wav", 150, caller:Health() / caller:GetMaxHealth() * 100 + 10, 1, CHAN_AUTO) -- Stolen from darkrp gamemode :(
		if hp_no_spam == 0 then
			hp_no_spam = 1
			local to_take = self:GetNWInt("Health_amount") - 1
			local to_add = caller:Health() + 1
			self:SetNWInt("Health_amount", to_take )
			caller:SetHealth( to_add )
			
			timer.Simple( Hp_plyfill_rate, function()
			hp_no_spam = 0
			end)
			end
		end
end
