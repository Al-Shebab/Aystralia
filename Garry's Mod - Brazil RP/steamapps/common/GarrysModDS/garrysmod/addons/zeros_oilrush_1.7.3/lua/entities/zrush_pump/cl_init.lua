include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self:UpdatePitch()

	self.UpdateSound = false
end

function ENT:UpdatePitch()
	local basePitch = 100 / (zrush.config.Machine["Pump"].Speed / 4)
	self.SoundPitch = math.Clamp(basePitch + (140 * self:GetSpeedBoost()), 0, 140)
end

// This Updates some of the Sound Info
function ENT:UpdateSoundInfo()
	self:UpdatePitch()
	self.UpdateSound = true
end

function ENT:Think()
	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), GetConVar("zrush_cl_vfx_updatedistance"):GetFloat() or 1000) then

		// One time Effect Creation
		local cur_state = self:GetState()
		if self.LastState ~= cur_state then

			self.LastState = cur_state
		end

		// Playing looped sound
		zrush.f.LoopedSound(self, "zrush_sfx_jammed", self:GetJammed() == true and cur_state == "JAMMED",70)
		zrush.f.LoopedSound(self, "zrush_sfx_pump", self:GetJammed() == false and cur_state == "PUMPING",self.SoundPitch)
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("zrush_sfx_pump")
	self:StopSound("zrush_sfx_jammed")
	self:StopParticles()
end
