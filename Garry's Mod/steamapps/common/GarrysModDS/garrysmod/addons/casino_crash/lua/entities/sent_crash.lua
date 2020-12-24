AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Casino Crash"
ENT.Author = "KappaJ"
ENT.Category = "Fun + Games"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()
	if (CLIENT) then return end
	self:SetModel("models/hunter/plates/plate3x5.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

    local phys = self:GetPhysicsObject()

    if phys and phys:IsValid() then
    	phys:EnableMotion( false )
        phys:Wake()
    end
end

if (SERVER) then return end

function ENT:Draw()
	--self:DrawModel()
	if not Casino_Crash then return end --Location table doesn't exixt?

	if not self.Panel or not self.Panel:IsValid() then
		self.Panel = Casino_Crash.CreatePanel(self:GetPos())
	end

	if not Casino_Crash.DistanceCheck(self:GetPos()) then return end

	local __scale = self:GetModelScale()

	vgui.Start3D2D( self:LocalToWorld( Vector( scaleX( -75 ), scaleH( -129 ), 1 ) * __scale ), self:LocalToWorldAngles( Angle( 0, 90, 0 ) ), 0.2 * self:GetModelScale() )
	vgui.MaxRange3D2D(Casino_Crash.Config.RenderDistance)
	self.Panel:Paint3D2D(true)
	vgui.End3D2D()
end