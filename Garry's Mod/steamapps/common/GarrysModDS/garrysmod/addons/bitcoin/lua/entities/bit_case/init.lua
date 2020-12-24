AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/computer_updated/computer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:SetPoint(bitmine.Health)
	self:SetColor(bitmine.BitMinerColor)
	self.Sound = CreateSound(self,"ambient/machines/machine3.wav")
end

function ENT:OnTakeDamage( dmg )
    if ( self.burningup ) then return end
	self:SetPoint( ( self:GetPoint() or 100 ) - dmg:GetDamage() )       
    if ( self:GetPoint() <= 0 ) then      
        self:Remove() 
		self:Destruct()
    end    
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata) 
end

local bit_vec_list = {
	[1] = Vector(1, -17.4, -11),
	[2] = Vector(10, -17.4, -11),
	[3] = Vector(1, -17.4, -11),
	[4] = Vector(2, -17.4, -11),
	[5] = Vector(1, -17.4, -11),
	[6] = Vector(1, -17.4, -13),
	[7] = Vector(0, -17.4, -11),
	[8] = Vector(0, -17.4, -13),
	[9] = Vector(0, -17.4, -15),
	[10] = Vector(0, -17.4, -17),
	[11] = Vector(0, -17.4, -19),
	[12] = Vector(1, -17.4, -11),	
	[13] = Vector(1, -17.4, -11)
}

local bit_model_list = {
	[1] = "models/props/cs_office/computer_caseb_p8a.mdl",
	[2] = "models/props/cs_office/computer_caseb_p8a.mdl",
	[3] = "models/props/cs_office/computer_caseb_p5b.mdl",
	[4] = "models/props/cs_office/computer_caseb_p5b.mdl",
	[5] = "models/props/cs_office/computer_caseb_p2a.mdl",
	[6] = "models/props/cs_office/computer_caseb_p2a.mdl",
	[7] = "models/props/cs_office/computer_caseb_p6b.mdl",
	[8] = "models/props/cs_office/computer_caseb_p6b.mdl",
	[9] = "models/props/cs_office/computer_caseb_p6b.mdl",
	[10] = "models/props/cs_office/computer_caseb_p6b.mdl",
	[11] = "models/props/cs_office/computer_caseb_p6b.mdl",
	[12] = "models/props/cs_office/computer_caseb_p7a.mdl",	
	[13] = "models/props/cs_office/computer_caseb_p4a.mdl"
}

function ENT:CreateModel( variable, model, vector )
	variable = ents.Create( "prop_dynamic" )
	if ( !IsValid( variable ) ) then return end
	variable:SetModel( model )
	variable:PhysicsInit( SOLID_VPHYSICS )
	variable:SetParent( self )
	variable:SetPos( vector )
	variable:SetAngles( self:GetAngles() )
	variable:Spawn()
end

function ENT:Use( ply )
	if ( ( self.lastUsed or CurTime() ) <= CurTime() ) then	
		self.lastUsed = CurTime() + 0.25
		if (self:GetPowerSupply() >= self:GetReqPowerSupply()) 
		and (self:GetGraphiccard() >= 1) 
		and (self:GetHarddisk() >= 500) 
		and (self:GetRam() >= 4) 
		and ((self:GetCPU()))
		and (self:GetMotherboard()) 
		and !(self:GetLoad() == 5) then
			self:SetLoad(1)
			timer.Create( "bitminetimer"..self:EntIndex(), 10 / self:GetRam(), 0, function() 
				if !(self:GetLoad() == 5) then return end
					self.Sound:SetSoundLevel( 55 )
					self.Sound:PlayEx(1, 100)
					self.Sound:Play()
				if !(self:GetGBused() >= self:GetHarddisk()) then
					self:SetBitCoin(self:GetBitCoin() + 1 * self:GetGraphiccard() )
					self:SetGBused(self:GetGBused() + bitmine.GbRamUsed)
				end	
			end)	
			timer.Create( "bitloadtimer"..self:EntIndex(), 6, 4, function() 		
				self:SetLoad(self:GetLoad() + 1)
			end)
		end
	end
end

function ENT:StartTouch( ent )
	if (ent:GetClass() == "bit_powersupply") then 
		if (self:GetPowerSupply() == 0) then
			self:SetPowerSupply(self:GetPowerSupply() + 500)
			self:CreateModel( self.powersupply, bit_model_list[1], bit_vec_list[1] )
			ent:Remove()	
		elseif (self:GetPowerSupply() == 500) then
			self:SetPowerSupply(self:GetPowerSupply() + 500)
			self:CreateModel( self.powersupply2, bit_model_list[2], bit_vec_list[2] )
			ent:Remove()			
		end		
	elseif (ent:GetClass() == "bit_ram") then 
	
		if (self:GetRam() == 0) then
			self:SetRam(self:GetRam() + 4)
			self:CreateModel( self.ram, bit_model_list[3], bit_vec_list[3] )			
			ent:Remove()
		elseif (self:GetRam() == 4) then
			self:SetRam(self:GetRam() + 4)		
			self:CreateModel( self.ram2, bit_model_list[4], bit_vec_list[4] )				
			ent:Remove()
		end		
	elseif (ent:GetClass() == "bit_graphiccard") then 	
		if (self:GetGraphiccard() == 0) then
			self:SetGraphiccard(self:GetGraphiccard() + 1)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 150)	
			self:CreateModel( self.graphiccard, bit_model_list[5], bit_vec_list[5] )	
			ent:Remove()			
		elseif (self:GetGraphiccard() == 1) then	
			self:SetGraphiccard(self:GetGraphiccard() + 1)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 150)	
			self:CreateModel( self.graphiccard2, bit_model_list[6], bit_vec_list[6] )	
			ent:Remove()			
		end	
	elseif (ent:GetClass() == "bit_harddisk") then 		
		if (self:GetHarddisk() == 0) then
			self:SetHarddisk(self:GetHarddisk() + 500)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 25)	
			self:CreateModel( self.harddisk, bit_model_list[7], bit_vec_list[7] )				
			ent:Remove()
		elseif (self:GetHarddisk() == 500) then
			self:SetHarddisk(self:GetHarddisk() + 500)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 25)	
			self:CreateModel( self.harddisk2, bit_model_list[8], bit_vec_list[8] )	
			ent:Remove()	
		elseif (self:GetHarddisk() == 1000) then
			self:SetHarddisk(self:GetHarddisk() + 500)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 25)
			self:CreateModel( self.harddisk3, bit_model_list[9], bit_vec_list[9] )	
			ent:Remove()	
		elseif (self:GetHarddisk() == 1500) then
			self:SetHarddisk(self:GetHarddisk() + 500)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 25)	
			self:CreateModel( self.harddisk4, bit_model_list[10], bit_vec_list[10] )	
			ent:Remove()	
		elseif (self:GetHarddisk() == 2000) then
			self:SetHarddisk(self:GetHarddisk() + 500)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 25)	
			self:CreateModel( self.harddisk5, bit_model_list[11], bit_vec_list[11] )	
			ent:Remove()				
		end	
	elseif (ent:GetClass() == "bit_motherboard") then 	
		if !(self:GetMotherboard()) then
			self:SetMotherboard(true)
			self:SetReqPowerSupply(self:GetReqPowerSupply() + 145)	
			self:CreateModel( self.motherboard, bit_model_list[12], bit_vec_list[12] )			
			ent:Remove()
		end		
	elseif (ent:GetClass() == "bit_cpu") then 
	
		if !(self:GetCPU()) then
			self:SetCPU(true)
			self:CreateModel( self.motherboard, bit_model_list[13], bit_vec_list[13] )
			ent:Remove()
		end		
	elseif (ent:GetClass() == "bit_windows") then 
	
		if !(self:GetWindow()) and !(self:GetCornet()) then
			self:SetWindow(true)
			ent:Remove()
		end		
	elseif (ent:GetClass() == "bit_cornet") then 	
		if !(self:GetWindow()) and !(self:GetCornet()) then
			self:SetCornet(true)
			ent:Remove()
		end			
	end
end

function ENT:OnRemove()
	local ei = self:EntIndex()
	if self.Sound then self.Sound:Stop() end
	timer.Remove( "bitminetimer"..ei )
	timer.Remove( "bitloadtimer"..ei )
end

