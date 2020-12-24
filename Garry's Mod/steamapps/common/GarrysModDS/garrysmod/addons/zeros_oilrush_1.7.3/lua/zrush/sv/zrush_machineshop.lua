if not SERVER then return end
zrush = zrush or {}
zrush.f = zrush.f or {}
zrush.f.MachineShop = zrush.f.MachineShop or {}
util.AddNetworkString("zrush_MachineCrate_Open_net")
util.AddNetworkString("zrush_MachineCrate_Close_net")
util.AddNetworkString("zrush_MachineCrate_Buy_net")
util.AddNetworkString("zrush_MachineCrate_Sell_net")
util.AddNetworkString("zrush_MachineCrate_Update_net")

net.Receive("zrush_MachineCrate_Buy_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
    local ent = net.ReadEntity()
    local machineshopId = net.ReadInt(16)

    // Add checks for disdtance, is owner
    if (IsValid(ent) and ent:GetClass() == "zrush_machinecrate") then
        if zrush.f.InDistance(ent:GetPos(),ply:GetPos(),300) == false then
            zrush.f.Notify(ply, zrush.language.VGUI["TooFarAway"], 1)

            return
        end
        zrush.f.MachineShop.Buy(ent, machineshopId, ply)
    end
end)

function zrush.f.MachineShop.Buy(ent, machineshopId, ply)
    // Check if the player has enough money
    local cost = zrush.MachineShop[machineshopId].price

    if (not zrush.f.HasMoney(ply, cost)) then
        zrush.f.Notify(ply, zrush.language.VGUI["Youcannotafford"], 1)

        return
    end

    local str = zrush.language.VGUI["Youbougt"]
    str = string.Replace(str, "$Name", zrush.MachineShop[machineshopId].name)
    str = string.Replace(str, "$Price", tostring(cost))
    str = string.Replace(str, "$Currency", zrush.config.Currency)
    zrush.f.Notify(ply, str, 0)

    // Takes some money from the player
    zrush.f.TakeMoney(ply, cost)
	zrush.f.CreateNetEffect("npc_cash",ply)

    ent:SetMachineID(zrush.MachineShop[machineshopId].machineID)
end

util.AddNetworkString("zrush_MachineCrate_Sell_net")

// This gets called from then machine options box
net.Receive("zrush_MachineCrate_Sell_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
    local ent = net.ReadEntity()

    if (IsValid(ent) and ent:GetClass() == "zrush_machinecrate") then
        if zrush.f.InDistance(ent:GetPos(),ply:GetPos(),300) == false then
            zrush.f.Notify(ply, zrush.language.VGUI["TooFarAway"], 1)

            return
        end

        if zrush.f.IsOwner(ply, ent) then
            zrush.f.MachineShop.Sell(ent, ent:GetMachineID(), ply)
        else
            if zrush.config.Machine["MachineCrate"].AllowSell == true then
                zrush.f.MachineShop.Sell(ent, ent:GetMachineID(), ply)
            end
        end
    end
end)

function zrush.f.MachineShop.Sell(ent, MachineID, ply)

    // Here we sell all the modules
    if (ent.InstalledModules and table.Count(ent.InstalledModules) > 0) then
        for k, v in pairs(ent.InstalledModules) do

            local mData = zrush.AbilityModules[v]

            local earning = mData.price * zrush.config.SellValue
            local str = zrush.language.VGUI["YouSold"]
            str = string.Replace(str, "$Name", mData.Name)
            str = string.Replace(str, "$Price", tostring(earning))
            str = string.Replace(str, "$Currency", zrush.config.Currency)
            zrush.f.Notify(ply, str, 0)

            // Give the player the Cash
            zrush.f.GiveMoney(ply, earning)
        end
    end

    local machineData = zrush.f.FindMachineDataByID(MachineID)

    // Add money function for the machine
    local earning = machineData.price * zrush.config.SellValue
    local str = zrush.language.VGUI["YouSold"]
    str = string.Replace(str, "$Name", machineData.name)
    str = string.Replace(str, "$Price", tostring(earning))
    str = string.Replace(str, "$Currency", zrush.config.Currency)
    zrush.f.Notify(ply, str, 0)

    // Give the player the Cash
    zrush.f.GiveMoney(ply, earning)
	zrush.f.CreateNetEffect("npc_cash",ply)

    // Here we reset all the information
    ent:SetMachineID("nil")
    ent.InstalledModules = {}
	zrush.f.Machinecrate_AddModules(ent,ent.InstalledModules)
end
