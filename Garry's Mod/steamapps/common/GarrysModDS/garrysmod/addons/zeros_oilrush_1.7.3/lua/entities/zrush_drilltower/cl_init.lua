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

	self.LastPipeCount = -1
	self.ClientPipesRebuild = false
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

function ENT:Remove_ClientPipes()
	if (self.Pipes) then
		for i = 1, table.Count(self.Pipes) do
			local pipe = self.Pipes[i]

			if IsValid(pipe) then
				pipe:Remove()
			end
		end
	end
end

local s_ang = Angle(-90, 0, 0)

// This spawns the visual pipes in the tower
function ENT:Rebuild_ClientPipes()
	local PipesInMachine = zrush.f.ReturnBoostValue(self.MachineID, "pipes", self)

	// If the pipecount change then we rebuild the pipes
	self:Remove_ClientPipes()

	self.Pipes = {}
	for i = 0, PipesInMachine - 1 do
		local pipe = ents.CreateClientProp()
		local attach = self:LookupAttachment("pipe")
		if (IsValid(pipe) and attach) then
			pipe:SetPos(self:LocalToWorld(Vector(0, 0, 50 + 85 * i)))
			pipe:SetModel("models/zerochain/props_oilrush/zor_drillpipe.mdl")
			pipe:SetAngles(self:LocalToWorldAngles(s_ang))
			pipe:Spawn()
			pipe:Activate()
			pipe:SetParent(self, attach)
			pipe:SetRenderMode(RENDERMODE_NORMAL)
			pipe:SetNoDraw(true)
			table.insert(self.Pipes, pipe)
		end
	end

	// Here we set the Pipes visibility
	for i = 1, table.Count(self.Pipes) do
		local pipe = self.Pipes[i]

		if IsValid(pipe) then
			if (i <= self:GetPipes()) then
				pipe:SetNoDraw(false)
			else
				pipe:SetNoDraw(true)
			end
		end
	end
	self.ClientPipesRebuild = true
end

function ENT:Think()

	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), GetConVar("zrush_cl_vfx_updatedistance"):GetFloat() or 1000) then

		if (self.LastPipeCount ~= self:GetPipes()) or self.ClientPipesRebuild == false  then
			self:Rebuild_ClientPipes()
			self.LastPipeCount = self:GetPipes()
		end


		// One time Effect Creation
		local cur_state = self:GetState()
		if self.LastState ~= cur_state then

			self.LastState = cur_state
		end

		// Playing looped sound
		zrush.f.LoopedSound(self, "zrush_sfx_jammed", self:GetJammed() == true and cur_state == "JAMMED",70)
		zrush.f.LoopedSound(self, "zrush_sfx_drill", self:GetJammed() == false and cur_state == "IS_WORKING",self.SoundPitch)

	else

		self:Remove_ClientPipes()
		self.ClientPipesRebuild = false
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("zrush_sfx_drill")
	self:StopSound("zrush_sfx_jammed")
	self:StopParticles()
	self:Remove_ClientPipes()
end
