include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.HasEffect = false
	self.LastState = "nil"
end

function ENT:Think()

	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), GetConVar("zrush_cl_vfx_updatedistance"):GetFloat()) then

		// One time Effect Creation
		local cur_state = self:GetState()
		if self.LastState ~= cur_state then

			self.LastState = cur_state

			self:StopParticles()

			if (self.LastState == "NEED_BURNER") then
				zrush.f.ParticleEffectAttach("zrush_butangas", self, 0)
				self.HasEffect = true
			end
		end

		// The Sound of the gas
		zrush.f.LoopedSound(self, "zrush_sfx_butangas", cur_state == "NEED_BURNER",100)
	else
		if self.HasEffect == true then
			self.HasEffect = false
			self:StopParticles()
		end
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("zrush_sfx_butangas")
	self:StopParticles()
end
