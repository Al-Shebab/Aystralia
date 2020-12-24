AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(0,20,20)
ENT.PrintName		= "LSD"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Amount = 4

function ENT:SetupDataTables()
    self:NetworkVar("Bool",0,"Super")
    self:NetworkVar("Int",0,"Amount")
end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/lsd4.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_BBOX )         -- Toolbox
    self:PhysicsInitBox( Vector(-16,-16,-4),Vector(16,16,0) )
    self:SetModelScale(0.5,0.01)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
    if(self:GetAmount() == 0) then
      self:SetAmount(4)
    end
	end
end

function ENT:Post()
  if(self:GetSuper()) then
    self:SetAmount(1)
    self:SetModel( "models/gonzo/lsd/lsd.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_BBOX )
    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
    self:PhysicsInitBox( Vector(-16,-16,-4),Vector(16,16,0) )
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
  end
end

function ENT:Use(act)
  if(self:GetAmount() == 4) then
    for k=1,3 do
      local lsd = ents.Create("sent_lsd")
      lsd:SetPos(self:GetPos() + Vector(0,0,8*k))
      lsd:SetAngles(self:GetAngles())
      lsd:Spawn()
      lsd:SetModel("models/gonzo/lsd/lsd.mdl")
      lsd:SetAmount(1)
    end
  end
  act:SetLSD(act:GetLSD() + (self:GetSuper() && 250 || 100))
  act:EmitSound("lsd/serious/lcd_take.wav")
  act:SendLua("createUnderwater()")
  if(act:GetLSD() > (self:GetSuper() && 500 || 400)) then
    act:Kill()
  end
  self:Remove()
end

function ENT:TakeIt()
    if(IsValid(self.Grabber)) then
      local am = LSD.Config.Price/4 * self:GetAmount() * LSD.Config.Selling * (self:GetSuper() && LSD.Config.SellingSuper || 1)
      self.Grabber:addMoney(am)
      DarkRP.notify(self.Grabber,2,5,"You sold "..self:GetAmount().." LSDs at $"..am)
      self:Remove()
    end
end

local w,h = 0,0
local rope = Material("ggui/rope_lsd")

function ENT:DoInfo()

     w,h = draw.SimpleTextOutlined(self:GetSuper() && "Super LSD" || "LSD","LSDFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

     surface.SetMaterial(rope)
     surface.SetDrawColor(255,255,255,255)
     surface.DrawTexturedRectUV( 12, -32, 16, h+16, 0, 0, 1, 1 )
     surface.DrawTexturedRectUVRotated(12+w+40, 8, 16, h+16, 0, 0, 1, 1 ,180)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32, 16, (w+40), 0, 0, 1, 2 ,90)
     surface.DrawTexturedRectUVRotated((w+40)/2+16, -32+h+16, 16, (w+40), 0, 0, 1, 2 ,90)

end

hook.Add("GravGunOnPickedUp","SetLSDOwnership",function(ply,ent)
  if(ent:GetClass() == "sent_lsd") then
    ent.Grabber = ply
  end
end)

hook.Add("PhysgunPickup","SetLSDOwnership",function(ply,ent)
  if(ent:GetClass() == "sent_lsd") then
    ent.Grabber = ply
  end
end)
