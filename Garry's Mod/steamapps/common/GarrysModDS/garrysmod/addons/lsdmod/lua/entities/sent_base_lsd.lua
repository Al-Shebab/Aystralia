
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Drug"
ENT.Author		= "Gonzo"
ENT.Category		= "Drugs"

ENT.Spawnable 		= false
ENT.AdminOnly 		= false
ENT.DoAttach        = false

ENT.Size = Vector(0,30,30)
ENT.LSDItem = true

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true;

function ENT:SetupDataTables()
    self:NetworkVar("Int",0,"Stage")
end

function ENT:SpawnFunction( ply, tr, ClassName )

        if ( !tr.Hit ) then return end

        local SpawnPos = tr.HitPos

        local ent = ents.Create( ClassName )
        ent:SetPos( SpawnPos + tr.HitNormal * 4 )
        ent:Spawn()
        ent:Activate()

        return ent
end

function ENT:OnRemove()
  if(IsValid(self.LSD_Owner) && self.LSD_Owner.LSDObjects) then
    self.LSD_Owner.LSDObjects[self:GetClass()] =  math.max(0,(self.LSD_Owner.LSDObjects[self:GetClass()] or 0)-1)
  end
end

function ENT:OnTakeDamage(dmg)
    if(LSD.Config.Health > 0 && dmg:IsExplosionDamage() || dmg:IsBulletDamage()) then
        self.SHealth = (self.SHealth or LSD.Config.Health) - dmg:GetDamage()
        if(self.SHealth <= 0) then
          if(self.DoExplosion) then
            local exp = ents.Create("env_explosion")
            exp:SetPos(self:GetPos())
            exp:Spawn()
            exp:SetKeyValue("iMagnitude",self.DoExplosion)
            exp:Fire("Explode",0,0)
          end
            self:Remove()
        end
    end
end

function ENT:PhysicsCollide(data,col)
     if(self.DoAttach && data.HitEntity != game.GetWorld() && !data.HitEntity:IsPlayer()) then
          if(string.StartWith(data.HitEntity:GetClass(),"sent_lsd_")) then
               self:CollidedWith(data.HitEntity)
          end
     end
end

function ENT:CollidedWith(ent)
end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/bottle.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
          self:SetUseType(SIMPLE_USE)
          local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		self:SetTrigger(true)
	end
end

function ENT:Use( activator, caller )
    return
end

local rope = Material("ggui/rope_lsd")

function ENT:Draw()

    if(isfunction(self.PostDraw)) then
         self:PostDraw()
    else
         self:DrawModel()
    end

	if(LocalPlayer():GetEyeTrace().Entity == self && halo.RenderedEntity() != self) then
          render.SetMaterial(rope)
          render.DrawBeam(self:GetPos()+self:GetUp()*self.Size.x,self:GetPos()+Vector(0,0,self.Size.z)+LocalPlayer():GetRight()*self.Size.y*1.05,2,0,8,Color(255,255,255))

          if LocalPlayer():GetPos():Distance(self:GetPos()) > 256 then
               return
          end

          local eyeAng = EyeAngles()
          eyeAng.p = 0
          eyeAng.y = eyeAng.y - 90
          eyeAng.r = 90

          //eyeAng:RotateAroundAxis(eyeAng:Forward(),EyeAngles().p-90)

          cam.Start3D2D(self:GetPos() + Vector(0,0,self.Size.z)+LocalPlayer():GetRight()*self.Size.y, eyeAng, 0.1)
          cam.IgnoreZ(true)
               self:DoInfo(self:GetPos())
          cam.IgnoreZ(false)
          cam.End3D2D()
     end

end

local w,h = 0,0

function ENT:DoInfo()

     w,h = draw.SimpleTextOutlined(self.PrintName,"LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

     surface.SetMaterial(rope)
     surface.SetDrawColor(255,255,255,255)
     surface.DrawTexturedRectUV( 12, -32, 16, h+16, 0, 0, 1, 1 )
     surface.DrawTexturedRectUVRotated(12+w+40, 8, 16, h+16, 0, 0, 1, 1 ,180)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32, 16, (w+40), 0, 0, 1, 2 ,90)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32+h+16, 16, (w+40), 0, 0, 1, 2 ,90)

end

if CLIENT then

  local triangle = {}
  local a,b,c,d,ang

  function surface.DrawTexturedRectUVRotated(px,py,pw,ph,pu,pv,eu,ev,rot)

  	ang = Angle(0,rot,0)
  	a = Vector(-pw/2,-ph/2,0)
  	a:Rotate(ang)
  	b = Vector(pw/2,-ph/2,0)
  	b:Rotate(ang)
  	c = Vector(pw/2,ph/2,0)
  	c:Rotate(ang)
  	d = Vector(-pw/2,ph/2,0)
  	d:Rotate(ang)

  	triangle[1] = {x=px+a.x,y=py+a.y,u=pu,v=pv}
  	triangle[2] = {x=px+b.x,y=py+b.y,u=eu,v=pv}
  	triangle[3] = {x=px+c.x,y=py+c.y,u=eu,v=ev}
  	triangle[4] = {x=px+d.x,y=py+d.y,u=pu,v=ev}

  	surface.DrawPoly(triangle)

  end

end
