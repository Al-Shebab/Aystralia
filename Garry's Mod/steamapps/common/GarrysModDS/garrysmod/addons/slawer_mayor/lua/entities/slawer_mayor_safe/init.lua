AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

Slawer.Mayor.SafeList = Slawer.Mayor.SafeList or {}

function ENT:Initialize()
    if Slawer.Mayor.CFG.DisabledModules["funds"] then
        self:Remove()
        return
    end

	self:SetModel("models/anthon/safebox.mdl")
    self:SetModelScale(Slawer.Mayor.CFG.SafeSize)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    self:UseClientSideAnimation()

	self:PhysWake()

	self:SetUseType(SIMPLE_USE)

    self.IsOpen = false

    self.intNext = 0

    self:UpdateMoneyLevel()

    Slawer.Mayor.SafeList[self] = true
end

function ENT:OnRemove()
    Slawer.Mayor.SafeList[self] = nil
end

function ENT:UpdateMoneyLevel()
    self:SetBodygroup(1, Slawer.Mayor:GetMoneyBG())
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

sound.Add( {
	name = "slawer_mayor_safe_lockpicked",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "ambient/alarms/alarm1.wav"
} )

function ENT:OnToggle(b, bLockpicked)
    self.IsOpen = b

    Slawer.Mayor:NetStart("ToggleSafeAnim", {open = b, ent = self})

    timer.Simple(2.5, function()
        if IsValid(self) then
            self:ResetSequence(b && "idleopen" || "idle")
        end
    end)

    if bLockpicked then
        self:EmitSound("slawer_mayor_safe_lockpicked")
        timer.Simple(Slawer.Mayor.CFG.AlarmDuration, function()
            if IsValid(self) then
                self:StopSound("slawer_mayor_safe_lockpicked")
            end
        end)
    end

    timer.Simple(b && 0.95 || 0, function()
        self:EmitSound("doors/heavy_metal_move1.wav")
    end)
end

function ENT:Use(p)
    if self.intNext > CurTime() then return end

    if self.IsOpen then
        Slawer.Mayor:NetStart("OpenSafeMenu", {ent = self}, p)
    else
	    if not Slawer.Mayor:HasAccess(p) then return end
        self:OnToggle(!self.IsOpen)

        self.intNext = CurTime() + 2.5
    end
end

function ENT:StartTouch(ent)
    if not self.IsOpen then return end
    if ent:GetClass() != "spawned_money" then return end
    if ent:Getamount() + Slawer.Mayor:GetFunds() > Slawer.Mayor:GetMaxFunds() then return end
    if ent.usedd then return end

    ent.usedd = true

    Slawer.Mayor:AddFunds(ent:Getamount())
    
    ent:Remove()
end