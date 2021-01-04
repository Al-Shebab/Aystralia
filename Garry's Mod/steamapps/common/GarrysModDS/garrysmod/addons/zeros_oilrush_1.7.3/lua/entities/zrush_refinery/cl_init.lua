include("shared.lua")


function ENT:Initialize()
	self:UpdatePitch()

	self.UpdateSound = false

	self.LastState = "nil"

	zrush.f.EntList_Add(self)
end

function ENT:Draw()
	self:DrawModel()

	if zrush.f.DrawUI() and zrush.f.InDistance(LocalPlayer():GetPos(),self:GetPos(),500) then
		self:Draw_MainInfo()
	end
end


local time = 0
local progress = 0
local l_pos = Vector(0,-24.3,69.5)
local l_ang = Angle(0,0,90)

function ENT:Draw_MainInfo(col)
	local lColor = zrush.Fuel[self:GetFuelTypeID()].color

	cam.Start3D2D(self:LocalToWorld(l_pos), self:LocalToWorldAngles(l_ang), 0.1)
		draw.RoundedBox(0, -53, -50, 108, 108, zrush.trans_fuelcolors[self:GetFuelTypeID()])

		if self.LastState == "REFINING" then

			if (time > 100) then
				time = 0
			else
				local boostBoni = zrush.f.ReturnBoostValue(self.MachineID, "speed", self)
				time = time + (70 * FrameTime() - (20 * FrameTime() * boostBoni))
				progress = (1 / 100) * time
			end

			surface.SetDrawColor(lColor)
			surface.SetMaterial(zrush.default_materials["circle_refining"])
			surface.DrawTexturedRectRotated(0, 0, 100, 100, Lerp(progress, 360, 0))
		end
	cam.End3D2D()
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

			if (self.LastState == "REFINING") then
				zrush.f.ParticleEffectAttach("zrush_burner", self, 7)

			elseif (self.LastState == "OVERHEAT") then
				zrush.f.ParticleEffectAttach("zrush_refinery_overheat", self, 7)

			end
		end

		// Playing looped sound
		zrush.f.LoopedSound(self, "zrush_sfx_overheat_loop", self:GetOverHeat() == true and cur_state == "OVERHEAT",70)
		zrush.f.LoopedSound(self, "zrush_sfx_refine", self:GetOverHeat() == false and cur_state == "REFINING",self.SoundPitch)
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
end
