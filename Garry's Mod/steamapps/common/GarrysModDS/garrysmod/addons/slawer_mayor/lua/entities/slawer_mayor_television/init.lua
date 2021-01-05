AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
    if Slawer.Mayor.CFG.DisabledModules["wanted"] then
        self:Remove()
        return
    end

	self:SetModel("models/props_phx/rt_screen.mdl")	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:PhysWake()

	self:SetUseType(SIMPLE_USE)
end

function ENT:SpawnFunction(pPlayer, tr, strClass)
    if ( !tr.Hit ) then return end

    local vecPos = tr.HitPos + tr.HitNormal * 25

    local ent = ents.Create( strClass )
    ent:SetPos(vecPos)
    ent:Spawn()
    ent:Activate()

    return ent
end