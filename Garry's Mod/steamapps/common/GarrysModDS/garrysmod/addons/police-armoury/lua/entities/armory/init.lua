AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:Initialize()
	if _PArmory then
		if _PArmory.ENTInitialize then
			return _PArmory.ENTInitialize(self)
		end
	end
end

function ENT:Use(activator, ply)
	if _PArmory then
		if _PArmory.ENTUse then
			return _PArmory.ENTUse(self, activator, ply)
		end
	end
end

function ENT:Think()
	if _PArmory then
		if _PArmory.ENTThink then
			return _PArmory.ENTThink(self)
		end
	end
end

function ENT:OnRemove()
	if _PArmory then
		if _PArmory.ENTOnRemove then
			return _PArmory.ENTOnRemove(self)
		end
	end
end