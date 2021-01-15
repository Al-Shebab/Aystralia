ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "OilSpot Generator"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "SpawnRadius")

    if (SERVER) then
        self:SetSpawnRadius(1000)
    end
end
