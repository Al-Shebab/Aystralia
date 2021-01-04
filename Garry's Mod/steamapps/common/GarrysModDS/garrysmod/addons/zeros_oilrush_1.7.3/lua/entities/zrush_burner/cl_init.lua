include("shared.lua")


function ENT:Initialize()
	self:UpdatePitch()

	self.UpdateSound = false

	self.LastState = "nil"

	zrush.f.EntList_Add(self)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:UpdatePitch()
	local maxSpeed = zrush.config.Machine[self.MachineID].Speed * 2
	local current_Speed = zrush.config.Machine[self.MachineID].Speed * (1 + self:GetSpeedBoost())
	self.SoundPitch = math.Clamp((140 / maxSpeed) * current_Speed, 0, 140) // Maybe replace 140 with 200 idk
end

// This Updates some of the Sound Info
function ENT:UpdateSoundInfo()
	self:UpdatePitch()
	self.UpdateSound = true
end

function ENT:Think()
	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), GetConVar("zrush_cl_vfx_updatedistance"):GetFloat()) then

		// One time Effect Creation
		local cur_state = self:GetState()
		if self.LastState ~= cur_state then

			self.LastState = cur_state

			self:StopParticles()

			if (self.LastState == "BURNING_GAS") then
				zrush.f.ParticleEffectAttach("zrush_burner", self, 4)

			elseif (self.LastState == "OVERHEAT") then
				zrush.f.ParticleEffectAttach("zrush_burner_overheat", self, 4)

			end
		end

		// Playing looped sound
		zrush.f.LoopedSound(self, "zrush_sfx_overheat_loop", self:GetOverHeat() == true and cur_state == "OVERHEAT",70)
		zrush.f.LoopedSound(self, "zrush_sfx_refine", self:GetOverHeat() == false and cur_state == "BURNING_GAS",self.SoundPitch)
	else
		if self.LastState ~= nil then
			self.LastState = nil
			self:StopParticles()
		end
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("zrush_sfx_overheat_loop")
	self:StopSound("zrush_sfx_refine")

	self:StopParticles()

	zrush.f.EntList_Remove(self)
end
