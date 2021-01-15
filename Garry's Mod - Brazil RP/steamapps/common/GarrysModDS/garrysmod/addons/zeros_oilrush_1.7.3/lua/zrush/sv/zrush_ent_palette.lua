if (not SERVER) then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

util.AddNetworkString("zrush_Palette_AddBarrel_net")


function zrush.f.Palette_Initialize(Palette)
    zrush.f.Debug("zrush.f.Palette_Initialize")
    zrush.f.EntList_Add(Palette)

    Palette.BarrelCount = 0
    Palette.FuelList = {}
end

function zrush.f.Palette_StartTouch(Palette, other)
    if not IsValid(Palette) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zrush_barrel" then return end
    if zrush.f.CollisionCooldown(other) then return end
    zrush.f.Debug("zrush.f.Palette_StartTouch")

    zrush.f.Palette_AddBarrel(Palette, other)
end

function zrush.f.Palette_AddBarrel(Palette, barrel)
    if barrel:GetFuelTypeID() > 0 and barrel:GetFuel() > 0 and Palette.BarrelCount < zrush.config.Palette.Capacity then

        Palette.BarrelCount = Palette.BarrelCount + 1

        // Tell the palette which fuelid and how much got added
        Palette.FuelList[barrel:GetFuelTypeID()] = (Palette.FuelList[barrel:GetFuelTypeID()] or 0) + barrel:GetFuel()

        // Informas all clients that this palette entitiy just got a fuel barrel added
        net.Start("zrush_Palette_AddBarrel_net")
        net.WriteEntity(Palette)
        net.WriteInt(barrel:GetFuelTypeID(),6)
        net.Broadcast()

        SafeRemoveEntity(barrel)
    end
end
