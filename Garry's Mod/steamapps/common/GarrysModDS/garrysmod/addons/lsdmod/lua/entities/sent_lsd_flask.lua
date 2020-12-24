AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(5,20,20)
ENT.PrintName		= "Flask"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true
ENT.DoAttach        = true

function ENT:SetupDataTables()
    self:NetworkVar("Int",0,"Stage")
    self:NetworkVar("Float",1,"Progress")
    self:NetworkVar("Bool",1,"Super")
end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/flask.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
          //self:SetLegacyTransform(false)
	 	self:SetModelScale(0.8,0.01)
          self:SetUseType(SIMPLE_USE)
          local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
    if(self:GetStage() == 0) then
      self:SetStage(1)
    end
    //self:SetSuper(false)
	end
end

function ENT:CollidedWith(ent)
     if(self:GetStage() == 1 && ent:GetClass() == "sent_lsd_powder") then
          self:SetStage(2)
          self:SetBodygroup(1,1)
          self:EmitSound("player/footsteps/grass1.wav")
          SafeRemoveEntityDelayed(ent,0)
     end
     if(self:GetStage() == 4 && ent:GetClass() == "sent_lsd_bottle") then
          self:SetStage(5)
          self:SetColor(Color(235,255,0))
          self:SetBodygroup(1,3)
          self:EmitSound("player/footsteps/wade6.wav")
          SafeRemoveEntityDelayed(ent,0)
     end
     if(self:GetStage() >= 7) then
          if(ent:GetClass() == "sent_lsd_paper") then
               local lsd = ents.Create("sent_lsd")
               lsd:SetPos(self:GetPos())
               lsd:Spawn()
               lsd:SetSuper(self:GetSuper())
               if(!self:GetSuper()) then
                 lsd:SetAmount(4)
               end
               timer.Simple(0,function()
                    lsd:Post()
               end)
               lsd:EmitSound("physics/cardboard/cardboard_box_impact_hard6.wav")
               self:Remove()
               ent:Remove()
          end
     end
end



function ENT:Use(act)
     if(self:GetStage() == 2 || self:GetStage() >= 4) then
          self:Remove()
          act:Kill()
     elseif(self:GetStage() == 3 && IsValid(self:GetParent())) then
          self:GetParent():Use(act)
     end
end

if SERVER then
  util.AddNetworkString("DoLSDSplash")
end

net.Receive("DoLSDSplash",function()
  local ent = net.ReadEntity()
  local eff = EffectData()
  eff:SetEntity(ent)
  util.Effect("eff_splashlsd",eff)
end)

function ENT:Think()
     if(SERVER && self:GetStage() == 5) then
          self:SetColor(Color(235,255,0))
          local vel = self:GetVelocity():Length()
          if(vel > 30*LSD.Cooking.ShakeStrenght && vel < 100*LSD.Cooking.ShakeStrenght) then
               self:SetProgress(self:GetProgress()-math.random(1,10)*LSD.Cooking.ShakeStrenght)
               if(self:GetProgress() <= 0) then
                    self:SetStage(6)
                    self:SetColor(Color(235,235,235))
               end
          elseif(vel > 1000*LSD.Cooking.ShakeStrenght) then
               for k,v in pairs(ents.FindInSphere(self:GetPos(),128)) do
                    if(v:IsPlayer()) then
                         v:TakeDamage(math.random(1,LSD.Cooking.MaxShakeDamage),self)
                    end
               end
               net.Start("DoLSDSplash")
               net.WriteEntity(self)
               net.SendPVS(self:GetPos())
               local eff = EffectData()
               eff:SetEntity(self)
               util.Effect("eff_splashlsd",eff)
          end
     elseif(self:GetSuper() && CLIENT) then
          local col = HSVToColor((RealTime() * 32) % 360, 1, 1)
          self:SetColor(Color(col.r,col.g,col.b))
     end
end

local w,h = 0,0

local rope = Material("ggui/rope_lsd")
local states = {"Insert Powder","I need heat","Turn on the burner","Insert liquid","Shake me gently","Cool me","Put me on a paper","Put me on a paper for super LSD"}

function ENT:DoInfo()
     if(states[self:GetStage()] && self:GetStage() < 7) then
          draw.SimpleTextOutlined(self.PrintName..":","LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          w,h = draw.SimpleTextOutlined(states[self:GetStage()]..(self:GetStage() == 5 && (" "..self:GetProgress().."%") || ""),"LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

          surface.SetMaterial(rope)
          surface.SetDrawColor(255,255,255,255)
          surface.DrawTexturedRectUV( 12, -32, 16, h+56, 0, 0, 1, 1 )
          surface.DrawTexturedRectUVRotated(12+w+40, 20, 16, h+56, 0, 0, 1, 1 ,180)
          surface.DrawTexturedRectUVRotated((w+40)/2+16, -32, 16, (w+40), 0, 0, 1, 2 ,90)
          surface.DrawTexturedRectUVRotated((w+40)/2+16, -32+h+56, 16, (w+40), 0, 0, 1, 2 ,90)
     else
          w,h = draw.SimpleTextOutlined("I'm ready! Put me on a paper","LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          if(!self:GetSuper()) then
               w,h = draw.SimpleTextOutlined("Or inside the burner for super LSD","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          else
               draw.SimpleTextOutlined("You got super LSD","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          end

          surface.SetMaterial(rope)
          surface.SetDrawColor(255,255,255,255)
          surface.DrawTexturedRectUV( 12, -32, 16, h+56, 0, 0, 1, 1 )
          surface.DrawTexturedRectUVRotated(12+w+40, 20, 16, h+56, 0, 0, 1, 1 ,180)
          surface.DrawTexturedRectUVRotated((w+40)/2+16, -32, 16, (w+40), 0, 0, 1, 2 ,90)
          surface.DrawTexturedRectUVRotated((w+40)/2+16, -32+h+56, 16, (w+40), 0, 0, 1, 2 ,90)
     end
end
