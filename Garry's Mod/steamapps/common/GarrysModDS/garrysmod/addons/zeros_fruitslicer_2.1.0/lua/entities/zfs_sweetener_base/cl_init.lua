include("shared.lua")

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end
