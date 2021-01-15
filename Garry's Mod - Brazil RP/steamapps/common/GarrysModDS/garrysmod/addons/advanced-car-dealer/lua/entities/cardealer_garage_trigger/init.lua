AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetSolid(  SOLID_BBOX )
	self:SetCollisionBoundsWS( self.PointA, self.PointB )
end

function ENT:StartTouch( entity )
	if type( entity ) ~= "Vehicle" then return end
	entity:SetNWBool( "canReturnInGarage", true )
end

function ENT:EndTouch( entity )
	if type( entity ) ~= "Vehicle" then return end
	entity:SetNWBool( "canReturnInGarage", false )
end