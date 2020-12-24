ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Smoothie"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros FruitSlicer"
ENT.Model = "models/zerochain/fruitslicerjob/fs_fruitcup.mdl"
ENT.DisableDuplicator = false


function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ProductID")
	self:NetworkVar("Int", 1, "ToppingID")

    if SERVER then
        self:SetProductID(1)
        self:SetToppingID(1)
    end
end
