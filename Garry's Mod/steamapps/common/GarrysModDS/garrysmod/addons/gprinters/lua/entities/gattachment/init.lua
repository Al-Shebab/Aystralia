AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetCollisionGroup( COLLISION_GROUP_WORLD  )
	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:ResetSequence( "idle" )
		self.damage = 100
		self.notify = CurTime() + 1

		local phys = self:GetPhysicsObject()
		if ( phys:IsValid() ) then
			phys:Wake()
		end
	end
end

function ENT:OnTakeDamage( dmg )
	local attacker = dmg:GetAttacker()
	self.damage = self.damage - dmg:GetDamage()
	if self.damage <= 0 then
		self:GetParent():Setscanner( 0 )
		self:GetParent().isSecured = false
		self:Destroy()
		self:Remove()
	end
	
	if self:GetModel() == "models/gprinter/gprinter_scanner.mdl" then
		if self:GetParent():Getowning_ent():IsPlayer() then
			if self.notify > CurTime() then
				return
			else
				gPrinters.sendChat( activator, "gPrinter:", Color( 255, 163, 0 ), "Your scanner is being attacked" )
				self.notify = CurTime() + 3
			end
		end
	end
end

function ENT:Destroy()
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() )
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetScale( 0.1 )
	util.Effect( "Explosion", effectdata )
end

function ENT:Think()
	if ( SERVER ) then

		if !IsValid( self:GetParent() ) then
			self:Remove()
		end
		
		self:NextThink( CurTime() )
		return true

	end
end

function ENT:setModel( model )
	self:SetModel( model )
end

function ENT:setColor( color )
	self:SetColor( color )
end