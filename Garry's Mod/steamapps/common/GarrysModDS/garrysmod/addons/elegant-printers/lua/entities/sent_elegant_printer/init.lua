if not DarkRP then return end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Editable = true

function ENT:NextPrint()
    self:SetNextPrint(CurTime() + self.PrintTime)
end

function ENT:Think()
    if self.Sound and not self.Sound:IsPlaying() then
        self.Sound:PlayEx(1, 100)
    end

    if not self:IsInactive() then
        if self:GetNextPrint() < CurTime() then
            local owner = self:Getowning_ent()
            local amtMult
            if IsValid(owner) then
                if owner.GetSecondaryUserGroup then
                    amtMult = self.PrintMultiplierVIPs[owner:GetSecondaryUserGroup()]
                end
                -- ??
                if owner.GetRank then
                    amtMult = self.PrintMultiplierVIPs[owner:GetRank()]
                end
                if not amtMult then
                    amtMult = self.PrintMultiplierVIPs[owner:GetUserGroup()]
                end
            end
            amtMult = amtMult or 1
            local evtMult = elegant_printers.IsEventActive() and self.EventPrintMultiplier or 1
            local amt = self.PrintAmount * amtMult * evtMult

            local ok, newAmt = hook.Run("moneyPrinterPrintMoney", self, amt)
            if ok ~= true then
                self:SetMoney(self:GetMoney() + (newAmt or amt))
                self:SetInk(math.max(0, self:GetInk() - 1))

                hook.Run("moneyPrinterPrinted", self, self) -- ??
            end

            self:NextPrint()
        end
        if self.CoolingSystem ~= false and not self:GetHQCooling() and self:GetNextHeatup() < CurTime() then
            if self:GetNextHeatup() > 0 then -- Don't do anything the first tick
                self:SetDurability(self:GetDurability() - 1)
                if self:GetDurability() <= 0 then
                    self:Explode()
                end
            end
            self:SetNextHeatup(CurTime() + self.HeatupTime)
        end
    end
    if (self:IsInactive() or self:GetDurability() <= 50) and (not self.NextSpark or self.NextSpark < CurTime()) then
        local eff = EffectData()
        eff:SetOrigin(self:GetPos())
        eff:SetMagnitude(1)
        eff:SetScale(1)
        eff:SetRadius(2)
        util.Effect("Sparks", eff)
        local speed = math.max(self:GetDurability() / 50, 0.05) * 0.5
        self.NextSpark = CurTime() + 5 * speed
    end

    self:SetBodygroup(1, self:GetInk() > 0 and 1 or 0)
    self:SetSkin(self:IsInactive() and 1 or 0)
end

function ENT:Use(ply)
    if IsValid(ply) and self:GetMoney() > 0 then
        if self:GetMoney() >= self.MaxMoney then
            self:NextPrint()
        end
        ply:addMoney(self:GetMoney())
        if ply.addXP and self.VrondakisLevelSystem then
            ply:addXP(self:GetMoney() * self.VrondakisLevelSystem_Multiplier)
        end
        net.Start("elegant_printers_receivemoney")
            net.WriteEntity(self)
            net.WriteInt(self:GetMoney(), 32)
        net.Send(ply)
        self:SetMoney(0)
    end
end

function ENT:OnRemove()
    if self.Sound then
        self.Sound:Stop()
    end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end
    if ent.Consuming then return end

    local upgrade = elegant_printers.Upgrades[ent:GetClass()]
    if upgrade then
        ent.Consuming = true
        timer.Simple(0, function()
            timer.Simple(0, function()
                if not IsValid(self) then return end
                ent.Consuming = false -- Reset just in case something goes wrong
            end) -- Collision callback errors stuff?
            local dispose = upgrade.Callback(self, ent)
            if dispose then
                ent:Remove()
                self:EmitSound("weapons/stunstick/alyx_stunner" .. math.random(1, 2) .. ".wav")
            end
        end)
    end
end

function ENT:Explode()
    if self:GetExploding() then return end

    local ok = hook.Run("moneyPrinterCatchFire", self)
    if ok == true then return end

    self:SetExploding(true)

    local pos, gpo = self:GetPos(), self:GetPhysicsObject()
    if IsValid(gpo) then
        if self.Sound then self.Sound:Stop() end
        self:EmitSound("weapons/mortar/mortar_shell_incomming1.wav")
        if not gpo:IsMotionEnabled() then
            gpo:EnableMotion(true)
        end
        gpo:AddVelocity(Vector(0, 0, 300))
        gpo:AddAngleVelocity(VectorRand())
    end
    timer.Simple(0.75, function()
        if not IsValid(self) then return end
        local eff = EffectData()
        eff:SetOrigin(pos)
        eff:SetStart(pos)
        eff:SetScale(1)
        util.Effect("Explosion", eff)
        util.BlastDamage(self, self, pos, 160, 30)
        DarkRP.notify(self:Getowning_ent(), NOTIFY_ERROR, 7, "Your " .. self.PrintName .. " exploded!")
        self:Remove()
    end)
end

local damageTypes = {
    [DMG_GENERIC] = true,
    [DMG_BUCKSHOT] = true,
    [DMG_BULLET] = true,
    [DMG_BLAST] = true,
    [DMG_ACID] = true,
    [DMG_CLUB] = true,
    [DMG_SHOCK] = true,
    [DMG_DISSOLVE] = true
}
function ENT:OnTakeDamage(dmgInfo)
    if self:GetExploding() then return end

    local isDmgType = false
    for typ, _ in next, damageTypes do
        if dmgInfo:IsDamageType(typ) or (dmgInfo:GetDamageType() == 0 and typ == 0) then
            isDmgType = true
            break
        end
    end

    if isDmgType then
        self:SetDurability(math.max(0, self:GetDurability() - dmgInfo:GetDamage()))
        if self:GetDurability() <= 0 then
            self:Explode()
        end
    end
end

util.AddNetworkString("elegant_printers_receivemoney")
util.AddNetworkString("elegant_printers_updatetier")
