ITEM.Name = itemstore.Translate("moneyprinter_name")
ITEM.Description = itemstore.Translate("moneyprinter_desc")
ITEM.Model = "models/freeman/compact_printer.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false

function ITEM:SaveData(ent)
	self:SetData("Price", ent.price)
	self:SetData("Owner", ent:Getowning_ent())

    self:SetData("Tier", ent:GetTier())
    self:SetData("Money", ent:GetMoney())
    self:SetData("Ink", ent:GetInk())
    self:SetData("MaxInk", ent:GetMaxInk())
    self:SetData("Durability", ent:GetDurability())
end

function ITEM:LoadData(ent)
	ent:Setowning_ent(self:GetData("Owner"))

    ent:SetTier(self:GetData("Tier"))
    timer.Simple(0, function()
        ent:SetMoney(self:GetData("Money"))
        ent:SetInk(self:GetData("Ink"))
        ent:SetMaxInk(self:GetData("MaxInk"))
        ent:SetDurability(self:GetData("Durability"))
    end)
end

function ITEM:GetName()
    local name = self.Name

    return self:GetData("Tier") .. " " .. name
end

function ITEM:CanPickup(ply, ent)
    if ent:GetExploding() then return false end

    return ent.ItemStore
end
