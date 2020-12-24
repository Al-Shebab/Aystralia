AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(25,20,40)
ENT.PrintName		= "Flank support"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true
ENT.DoAttach        = true

function ENT:SetupDataTables()
    self:NetworkVar("Int",0,"Stage")
    self:NetworkVar("Bool",1,"Power")
    self:NetworkVar("Float",2,"Gas")
    self:NetworkVar("Float",3,"Progress")
end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/flank_support.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	 	self:SetModelScale(0.8,0.01)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
    if(self:GetStage() == 0) then
      self:SetStage(1)
    else
      timer.Simple(0,function()
        self:SetModelScale(0.8,0.01)
        self:Activate()
      end)
    end
	end
end

function ENT:CollidedWith(ent)
     if(self:GetStage() == 1 && ent:GetClass() == "sent_lsd_pyro") then
          self:SetStage(2)
          self:SetBodygroup(1,1)
          self:EmitSound("physics/metal/metal_solid_impact_bullet1.wav")
          ent:Remove()
     end
     if(self:GetStage() == 2 && ent:GetClass() == "sent_lsd_gas") then
          self:SetStage(3)
          self:SetBodygroup(2,1)
          self:SetBodygroup(3,1)
          self:SetGas(100)
          self:EmitSound("physics/metal/metal_barrel_impact_soft1.wav")
          SafeRemoveEntityDelayed(ent,0)
     end
     if(self:GetStage() == 3 && ent:GetClass() == "sent_lsd_flask") then
          if(ent:GetStage()==2 || ent:GetStage()==7) then
              self:EmitSound("physics/glass/glass_impact_hard3.wav")
               ent:SetParent(self)
               self.Flask = ent
               ent:SetLocalPos(Vector(0,0,27))
               ent:SetLocalAngles(Angle(0,0,0))
               ent:SetSuper(ent:GetStage()==7)
               ent:SetStage(3)
               self:SetStage(4)
          end
     end
end

if SERVER then
  util.AddNetworkString("DoFlaskSteam")
end

net.Receive("DoFlaskSteam",function()
  local ent = net.ReadEntity()
  local ds = net.ReadBool()
  if(!ds) then
    local eff = EffectData()
    eff:SetEntity(ent)
    util.Effect("eff_steamlsd",eff)
  else
    ent.DispatchEffect = true
  end
end)

function ENT:Use(act)
     if(self:GetStage() == 4) then
          self:SetPower(!self:GetPower())
          self:SetBodygroup(4,self:GetPower() && 1 or 0)
          if(self:GetPower() && self:GetGas() > 0) then
            net.Start("DoFlaskSteam")
            net.WriteEntity(self.Flask)
            net.WriteBool(false)
            net.SendPVS(self:GetPos())
            local eff = EffectData()
            eff:SetEntity(self.Flask)
            util.Effect("eff_steamlsd",eff)
            self:EmitSound("ambient/fire/mtov_flame2.wav")
          end
     end
end

function ENT:Think()
     if(SERVER && self:GetStage() == 4 && !IsValid(self.Flask)) then
          self:SetStage(3)
          self:SetBodygroup(4,0)
     end
     if(self:GetPower() && SERVER) then
          if(self:GetGas() > 0) then
               self:SetGas(self:GetGas()-1*LSD.Cooking.GasDuration)
               self:SetProgress(self:GetProgress()+5*LSD.Cooking.GasConsuption)
               self.Flask:SetProgress(self:GetProgress())
               if(self:GetProgress() > 100) then
                    if(IsValid(self.Flask)) then
                         self.Flask:SetStage(4)
                         self.Flask:SetBodygroup(1,2)
                         self.Flask:SetParent(nil)
                         self.Flask:SetPos(self:GetPos()+Vector(0,0,32))
                         self.Flask:GetPhysicsObject():Sleep()
                         self.Flask = nil
                    end
                    self:SetPower(false)
                    self:SetProgress(0 )
                    self:SetBodygroup(4,0)
                    self:SetStage(3)
               end
          elseif(SERVER) then
               self:SetStage(2)
               self:SetBodygroup(2,0)
               self:SetBodygroup(3,0)
               self:SetBodygroup(4,0)
               self:SetPower(false)
               if(IsValid(self.Flask)) then
                    self.Flask:SetStage(2)
                    self.Flask:SetParent(nil)
                    self.Flask:SetPos(self:GetPos()+Vector(0,0,10))
                    self.Flask = nil
               end
          end
          self:NextThink(CurTime() + 0.5)
          return true
     end
end


local rope = Material("ggui/rope_lsd")
local w,h = 0,0
local dh = 32

local function getProgress(p)
     local a = string.rep("°",10-math.ceil(p/10))
     local b = string.rep("|",math.ceil(p/10))
     return b..a
end

function ENT:DoInfo()

     dh = 0
     if(self:GetStage() == 1) then
          draw.SimpleTextOutlined(self.PrintName,"LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          w,h = draw.SimpleTextOutlined("Insert a burner","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          dh = 64
     elseif(self:GetStage() == 2) then
          draw.SimpleTextOutlined(self.PrintName,"LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          w,h = draw.SimpleTextOutlined("Insert a gas cannister","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          dh = 64
     elseif(self:GetStage() == 3) then
          draw.SimpleTextOutlined(self.PrintName,"LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          w,h = draw.SimpleTextOutlined("Insert a flask","LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          dh = 64
     elseif(self:GetStage() == 4) then
          draw.SimpleTextOutlined(self.PrintName,"LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          w,h = draw.SimpleTextOutlined(!self:GetPower() && "Turn me on!" || "Gas remaining: %"..self:GetGas(),"LSDFont",32,42,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          draw.SimpleTextOutlined("Progress: %"..math.Round(self:GetProgress(),2),"LSDFont",32,82,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
          dh = 64+40
          w = 290
     end

     surface.SetMaterial(rope)
     surface.SetDrawColor(255,255,255,255)
     surface.DrawTexturedRectUV( 12, -32, 16, h+dh, 0, 0, 1, 1 )
     surface.DrawTexturedRectUV( 12+w+16+20, -32, 16, h+dh, 0, 0, 1, 1 )
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32, 16, (w+40), 0, 0, 1, 2 ,90)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32+h+40+dh-46, 16, (w+40), 0, 0, 1, 2 ,90)

end
