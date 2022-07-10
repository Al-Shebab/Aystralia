elegant_printers.Upgrades = {
    sent_elegant_printer_ink = {
        Callback = function(self, ent)
            if self:GetInk() < self:GetMaxInk() then
                self:SetInk(self:GetInk() + self.InkRefill)
                return true
            end
        end
    },
    sent_elegant_printer_slot = {
        Callback = function(self, ent)
            local ply = self:Getowning_ent()
            local max = (IsValid(ply) and self.UpgradedMaxInkVIPs[ply:GetUserGroup()] or self.UpgradedMaxInk)
            if self:GetMaxInk() < max then
                self:SetMaxInk(self:GetMaxInk() + self.InkRefill)
                return true
            end
        end
    },
    sent_elegant_printer_repair = {
        Callback = function(self, ent)
            if self:GetDurability() < 100 then
                self:SetDurability(100)
                self:RemoveAllDecals() -- Clean bullet holes kek
                return true
            end
        end
    },
    sent_elegant_printer_cooling = {
        Callback = function(self, ent)
            if not self:GetHQCooling() then
                if self.Sound then
                    self.Sound:Stop()
                    self.Sound = nil
                end
                self:SetHQCooling(true)
                return true
            end
        end
    },
}
table.Inherit(elegant_printers.Upgrades.sent_elegant_printer_ink, elegant_printers.config.InkCartridge)
table.Inherit(elegant_printers.Upgrades.sent_elegant_printer_slot, elegant_printers.config.InkSlot)
table.Inherit(elegant_printers.Upgrades.sent_elegant_printer_repair, elegant_printers.config.RepairPart)
table.Inherit(elegant_printers.Upgrades.sent_elegant_printer_cooling, elegant_printers.config.HQCooling)

for class, data in next, elegant_printers.Upgrades do
    local ENT = {}
    ENT.ClassName = class
    ENT.Type = "anim"
    ENT.Base = "base_gmodentity"
    ENT.PrintName = data.PrintName
    ENT.Author = "Tenrys"
    ENT.Contact = "tenrys.iaido@gmail.com"
    ENT.DisableDuplicator = true
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
    ENT.Spawnable = true
    ENT.Category = "Elegant Printers"

    function ENT:Initialize()
        if not elegant_printers then error("Elegant Printers aren't loaded? Aborting.") self:Remove() end

        if SERVER then
            self:SetModel(data.model)
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetMoveType(MOVETYPE_VPHYSICS)
            self:SetSolid(SOLID_VPHYSICS)
            self:SetUseType(SIMPLE_USE)
        end

        local gpo = self:GetPhysicsObject()
        if IsValid(gpo) then
            if SERVER then
                gpo:Wake()
            end
            gpo:SetMass(50)
            gpo:SetMaterial("computer")
        end
    end

    scripted_ents.Register(ENT, class)

    if data.ItemStore and itemstore then
        itemstore.config.CustomItems[class] = {
            data.PrintName, "", true
        }
    end
end
