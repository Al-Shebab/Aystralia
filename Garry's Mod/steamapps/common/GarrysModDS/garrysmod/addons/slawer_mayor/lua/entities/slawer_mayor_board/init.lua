AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props/cs_office/offcorkboarda.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetModelScale(7, 0)
	self:SetColor(Color(30, 30, 30))
	
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