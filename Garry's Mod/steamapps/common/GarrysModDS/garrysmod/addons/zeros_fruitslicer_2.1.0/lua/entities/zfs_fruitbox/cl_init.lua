include("shared.lua")

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zfs.f.Fruitbox_Draw(self)
end
