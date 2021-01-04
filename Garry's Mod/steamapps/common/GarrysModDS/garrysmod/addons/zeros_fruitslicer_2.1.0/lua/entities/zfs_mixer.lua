//////////////////////////////////////////////////////////////
////// Model & Design by: Zerochain | Coding by : Zerochain //
//////////////////////////////////////////////////////////////
AddCSLuaFile()
DEFINE_BASECLASS("zfs_anim")
ENT.Spawnable = false
ENT.Base = "zfs_anim"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.PrintName = "Mixer"
ENT.Category = "Zeros FruitSlicer"
ENT.Model = "models/zerochain/fruitslicerjob/fs_mixer.mdl"

function ENT:Use(activator, caller)
    local shop = self:GetParent()

    if not IsValid(shop) then return end

    if shop:GetClass() ~= "zfs_shop" then return end

    if not zfs.f.IsOwner(activator, shop) then
        zfs.f.Notify(activator, zfs.language.Shop.NotOwner, 1)

        return
    end

    if (shop:GetIsBusy()) then return end

    if (shop:GetCurrentState() == 11) then
        zfs.f.Shop_action_StartMixer(shop)
    end
end
