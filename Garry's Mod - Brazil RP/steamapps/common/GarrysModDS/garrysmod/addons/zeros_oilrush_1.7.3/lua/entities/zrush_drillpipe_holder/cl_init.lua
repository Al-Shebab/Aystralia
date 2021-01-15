include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.ClientPipesRebuild = false
	zrush.f.EntList_Add(self)
end

function ENT:Think()
	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), GetConVar("zrush_cl_vfx_updatedistance"):GetFloat() or 1000) == false then
		self:Remove_ClientPipes()
		self.ClientPipesRebuild = false
	else
		if ((self.LastPipeCount or 0) ~= self:GetPipeCount()) or self.ClientPipesRebuild == false then
			self:Rebuild_ClientPipes()
			self.LastPipeCount = self:GetPipeCount()
		end
	end
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

// This spawns the visual pipes in the holder
function ENT:Rebuild_ClientPipes()
	self:Remove_ClientPipes()
	self.Pipes = {}

	for i = 1, self:GetPipeCount() do
		local attach = self:GetAttachment(i)

		if (attach) then
			local pipe = ents.CreateClientProp()

			if (IsValid(pipe)) then
				pipe:SetPos(attach.Pos)
				pipe:SetModel("models/zerochain/props_oilrush/zor_drillpipe.mdl")
				local ang = attach.Ang
				ang:RotateAroundAxis(self:GetForward(), 90)
				ang:RotateAroundAxis(self:GetRight(), 90)
				pipe:SetAngles(ang)
				pipe:Spawn()
				pipe:Activate()
				pipe:SetRenderMode(RENDERMODE_NORMAL)
				pipe:SetParent(self)
				table.insert(self.Pipes, pipe)
			end
		end
	end

	self.ClientPipesRebuild = true
end

function ENT:OnRemove()
	self:Remove_ClientPipes()
end
