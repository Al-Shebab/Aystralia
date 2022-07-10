ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Elegant Money Printer"
ENT.Author = "Tenrys"
ENT.Contact = "tenrys.iaido@gmail.com"
ENT.DisableDuplicator = true
ENT.IsMoneyPrinter = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Spawnable = true
ENT.Category = "Elegant Printers"

function ENT:CapitalizeString(str) -- Make sure first letter is uppercase
    return str:sub(1, 1):upper() .. str:sub(2)
end

local noInherit = { -- Waste of space
    HQCooling = true,
    InkCartridge = true,
    InkSlot = true,
    RepairPart = true,
    Tiers = true,
}
function ENT:UpdateTier(tierName)
    for k, v in next, elegant_printers.config do
        if not noInherit[k] then
            self[k] = v -- Load base tier and config
        end
    end

    tierName = tierName or self:GetTier()

    if elegant_printers.config.Tiers and tierName then
        for name, tier in next, elegant_printers.config.Tiers do
            if name:lower() == tierName:lower() then
                self.PrintName = nil
                for k, v in next, tier do
                    self[k] = v
                end
                if not self.PrintName then
                    self.PrintName = self:CapitalizeString(tierName) .. " Money Printer"
                end
                break
            end
        end
    end
    self.MaxRenderDistance = (self.MaxRenderDistance or 256 ^ 2)

    if SERVER then
        if self:GetNextPrint() == 0 then
            self:SetMoney(0)
            self:SetMaxInk(self.MaxInk)
            self:SetInk(self.InkRefill)
            self:SetDurability(100)
        end

        self:SetColor(self.PrinterColor)

        self:NextPrint()

        net.Start("elegant_printers_updatetier")
            net.WriteEntity(self)
            net.WriteString(tierName)
        net.Broadcast()
    end
end

function ENT:SetupDataTables()
    if not elegant_printers then return end

    self:NetworkVar("Int", 0, "Money", {
        KeyName = "dosh",
        Edit = {
            title = "Money",
            type = "Number",
            order = 0,
        }
    })
    self:NetworkVar("Int", 1, "Ink", {
        KeyName = "ink",
        Edit = {
            title = "Ink",
            type = "Number",
            order = 1,
        }
    })
    self:NetworkVar("Int", 3, "MaxInk", {
        KeyName = "maxink",
        Edit = {
            title = "Max Ink",
            type = "Number",
            order = 2,
        }
    })
    self:NetworkVar("Int", 2, "Durability", {
        KeyName = "durability",
        Edit = {
            title = "Durability",
            type = "Int",
            min = 0,
            max = 100,
            order = 3,
        }
    })
    self:NetworkVar("String", 0, "Tier", {
        KeyName = "tier",
        Edit = {
            title = "Tier",
            type = "Generic",
            order = 4,
        }
    })

    self:NetworkVar("Float", 0, "NextPrint")
    self:NetworkVar("Float", 1, "NextHeatup")
    self:NetworkVar("Bool", 0, "Exploding")
    self:NetworkVar("Bool", 1, "HQCooling")
    self:NetworkVar("Entity", 0, "owning_ent") -- DarkRP compatibility

    if SERVER then
        -- lots of hacking
        timer.Simple(0, function()
            local _SetMoney = self.SetMoney
            function self:SetMoney(int)
                _SetMoney(self, math.Clamp(int, 0, self.MaxMoney))
            end
            local _SetMaxInk = self.SetMaxInk
            function self:SetMaxInk(int)
                local ply = self:Getowning_ent()
                local max = IsValid(ply) and self.UpgradedMaxInkVIPs[ply:GetUserGroup()] or self.UpgradedMaxInk
                _SetMaxInk(self, math.Clamp(int, 0, max))
            end
            local _SetInk = self.SetInk
            function self:SetInk(int)
                if self:GetInk() <= 0 and int > 0 then
                    self:NextPrint()
                end
                if self.InkSystem == false then
                    int = math.max(1, self:GetMaxInk())
                end
                _SetInk(self, math.Clamp(int, 0, self:GetMaxInk()))
            end
        end)
        local _SetTier = self.SetTier
        function self:SetTier(tier)
            _SetTier(self, tier)
            self:UpdateTier(tier)
        end
        local _EditValue = self.EditValue
        function self:EditValue(k, v)
            _EditValue(self, k, v)
            if k:lower() == "tier" then
                self:UpdateTier(v)
            end
        end
    end
end

function ENT:Initialize()
    if not elegant_printers then error("Elegant Printers aren't loaded? Aborting.") self:Remove() return end

    if SERVER then
        self:SetModel("models/freeman/compact_printer.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetTrigger(true)

        timer.Simple(0, function()
            if not self:GetHQCooling() then
                self.Sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
                self.Sound:SetSoundLevel(45)
            end
        end)
    end

    self:UpdateTier()

    local gpo = self:GetPhysicsObject()
    if IsValid(gpo) then
        if SERVER then
            gpo:Wake()
        end
        gpo:SetMass(50)
        gpo:SetMaterial("computer")
    end
end

function ENT:IsInactive()
    return self:GetInk() <= 0 or self:GetMoney() >= self.MaxMoney
end

function ENT:CanTool(ply, trace, tool)
    if tool == "colour" then return true end
    if tool == "remover" and self:Getowning_ent() == ply then return true end
    return false
end
