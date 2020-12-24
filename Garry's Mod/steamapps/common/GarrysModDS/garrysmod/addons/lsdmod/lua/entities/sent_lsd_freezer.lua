AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(5,40,50)
ENT.PrintName		= "Freezer station"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true
ENT.DoAttach        = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.DoExplosion = 200

function ENT:SetupDataTables()
    self:NetworkVar("Int",0,"Stage")
    self:NetworkVar("Float",1,"Progress")
    self:NetworkVar("Entity",2,"Flask")
end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/freezer.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	 	self:SetModelScale(1.2,0.01)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
          self:SetStage(1)
	end
end

function ENT:CollidedWith(ent)
     if(ent:GetStage() == 6 && ent:GetClass() == "sent_lsd_flask") then
       timer.Simple(0,function()
          self:EmitSound("physics/glass/glass_impact_soft2.wav")
          self:SetProgress(0)
          self:SetStage(2)
          self:SetFlask(ent)
          ent:SetParent(self)
          ent:SetLocalPos(Vector(0,0,12))
          ent:SetLocalAngles(Angle(0,0,0))
        end)
     end
end

function ENT:Think()
     if(self:GetStage() == 2 && SERVER) then
          self:SetProgress(self:GetProgress()+5*LSD.Cooking.CoolTime)
          if(self:GetProgress() > 100) then
               if(self:GetProgress() > 500 && IsValid(self:GetFlask())) then
                    self:GetFlask():Remove()
               end
          end
          self:NextThink(CurTime() + 0.5)
          return true
     end
end

function ENT:Use(act)
     if(self:GetProgress() > 100) then
          self:SetStage(1)
          if(IsValid(self:GetFlask())) then
              self:EmitSound("physics/glass/glass_impact_soft2.wav")
               self:GetFlask():SetStage(self:GetFlask():GetSuper() && 8 || 7)
               self:SetProgress(0)
               self:GetFlask():SetBodygroup(1,4)
               self:GetFlask():SetParent(nil)
               self:GetFlask():SetPos(self:GetPos() - self:GetForward()*32)
               self:GetFlask():GetPhysicsObject():Sleep()
               net.Start("DoFlaskSteam")
               net.WriteEntity(self:GetFlask())
               net.WriteBool(true)
               net.Broadcast()
               self:SetFlask(nil)
          end
     end
end

function ENT:PostDraw()
     self:DrawModel()
     if(IsValid(self:GetFlask())) then
          self:GetFlask():DrawModel()
     end
end

local rope = Material("ggui/rope_lsd")
local w,h = 0,0

local function getProgress(p)
     local a = string.rep("°",10-math.ceil(p/10))
     local b = string.rep("|",math.ceil(p/10))
     return b..a
end

function ENT:DoInfo()

     if(self:GetStage() == 1) then
          draw.SimpleTextOutlined(self.PrintName,"LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          w,h = draw.SimpleTextOutlined("<Insert a flask>","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
     else
          w,h = draw.SimpleTextOutlined("We are cooling a flask","LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          if(self:GetProgress() < 100) then
               w,h = draw.SimpleTextOutlined("["..getProgress(self:GetProgress()).."] - %"..math.Round(self:GetProgress()),"LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          else
               w,h = draw.SimpleTextOutlined("I'm freezing! Take me out","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          end
     end

     surface.SetMaterial(rope)
     surface.SetDrawColor(255,255,255,255)
     surface.DrawTexturedRectUV( 12, -32, 16, h+56, 0, 0, 1, 1 )
     surface.DrawTexturedRectUVRotated(12+w+40, 20, 16, h+56, 0, 0, 1, 1 ,180)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32, 16, (w+40), 0, 0, 1, 2 ,90)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32+h+56, 16, (w+40), 0, 0, 1, 2 ,90)

end
