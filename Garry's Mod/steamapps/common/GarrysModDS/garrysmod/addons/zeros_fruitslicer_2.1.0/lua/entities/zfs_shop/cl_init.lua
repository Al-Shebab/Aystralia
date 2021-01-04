include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	zfs.f.Shop_Draw(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	zfs.f.Shop_Initialize(self)
end

// Animation
function ENT:Think()
	zfs.f.Shop_Think(self)

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	zfs.f.Shop_OnRemove(self)
end
