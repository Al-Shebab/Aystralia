AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(5,20,20)
ENT.PrintName		= "Gas can"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true
ENT.DoExplosion = 50
ENT.SHealth = 25

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/gas.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	 	self:SetModelScale(1.2,0.01)
    self:SetUseType(SIMPLE_USE)
    self:Activate()
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

local rope = Material("ggui/rope_lsd")

function ENT:Draw()

    if(isfunction(self.PostDraw)) then
         self:PostDraw()
    else
         self:DrawModel()
    end

	if(LocalPlayer():GetEyeTrace().Entity == self) then
          render.SetMaterial(rope)
          render.DrawBeam(self:GetPos()+self:GetUp()*self.Size.x + self:GetForward()*20 + self:GetRight()*32,self:GetPos()+ self:GetForward()*20 + self:GetRight()*32+Vector(0,0,self.Size.z)+LocalPlayer():GetRight()*self.Size.y*1.05,2,0,8,Color(255,255,255))

          if LocalPlayer():GetPos():Distance(self:GetPos()) > 256 then
               return
          end

          local eyeAng = EyeAngles()
          eyeAng.p = 0
          eyeAng.y = eyeAng.y - 90
          eyeAng.r = 90

          cam.Start3D2D(self:GetPos() + self:GetForward()*20 + self:GetRight()*32 + Vector(0,0,self.Size.z+1)+LocalPlayer():GetRight()*19, eyeAng, 0.1)
          cam.IgnoreZ(true)
               self:DoInfo(self:GetPos())
          cam.IgnoreZ(false)
          cam.End3D2D()
     end

end

function ENT:Use(act)
     self:Remove()
     act:Kill()
end
