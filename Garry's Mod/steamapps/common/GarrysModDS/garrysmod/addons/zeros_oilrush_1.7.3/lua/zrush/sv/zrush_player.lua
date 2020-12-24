if CLIENT then return end

zrush = zrush or {}
zrush.f = zrush.f or {}

////////////////////////////////////////////
//////////////// Player NW /////////////////
////////////////////////////////////////////
// How often are clients allowed to send net messages to the server
ZRUSH_NW_TIMEOUT = 0.25

// Prevents the player to spam the server with net.msg
function zrush.f.NW_Player_Timeout(ply)
    local Timeout = false

    if ply.zrush_NWTimeout and ply.zrush_NWTimeout > CurTime() then
        Timeout = true
    end

    ply.zrush_NWTimeout = CurTime() + ZRUSH_NW_TIMEOUT

    return Timeout
end
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
////////////// Player INIT /////////////////
////////////////////////////////////////////
if zrush_PlayerList == nil then
    zrush_PlayerList = {}
end

function zrush.f.Add_Player(ply)
    zrush_PlayerList[ply:SteamID()] = ply
end

util.AddNetworkString("zrush_Player_Initialize")
net.Receive("zrush_Player_Initialize", function(len, ply)

    if ply.zrush_HasInitialized then
        return
    else
        ply.zrush_HasInitialized = true
    end

    if zrush.f.NW_Player_Timeout(ply) then return end
    zrush.f.Debug("zrush_Player_Initialize Netlen: " .. len)

    if IsValid(ply) then
        zrush.f.Add_Player(ply)
    end
end)
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
///////////// Player Other /////////////////
////////////////////////////////////////////
gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "a.zrush.player.disconnect", function(data)
    local steamid = data.networkid

    zrush_PlayerList[steamid] = nil

    zrush.f.PlayerCleanup(steamid)
end)

local DeleteClass = {
    ["zrush_barrel"] = true,
    ["zrush_drillpipe_holder"] = true,
    ["zrush_machinecrate"] = true,
    ["zrush_drilltower"] = true,
    ["zrush_burner"] = true,
    ["zrush_pump"] = true,
    ["zrush_refinery"] = true,
    ["zrush_drillhole"] = true,
    ["zrush_palette"] = true,
}

function zrush.f.PlayerCleanup(steamid)
    for k, v in pairs(zrush.EntList) do
        if IsValid(v) and DeleteClass[v:GetClass()] and steamid == zrush.f.GetOwnerID(v) then
            if (v:GetClass() == "zrush_drillhole" and IsValid(v.OilSpot)) then
                v.OilSpot:Remove()
            end

            SafeRemoveEntity(v)
        end
    end
end

hook.Add("OnPlayerChangedTeam", "a.zrush.OnPlayerChangedTeam.CleanupEnts", function(ply, before, after)
    zrush.f.PlayerCleanup(ply:SteamID())
end)
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
////////// Player Functions ////////////////
////////////////////////////////////////////
// Meta Tables
local meta_ply = FindMetaTable("Player")

// This adds the drillhole id too the player
function meta_ply:zrush_CreatedDrillHole(drillhole_entindex)
    self.zrush_ActiveDrillholes = self.zrush_ActiveDrillholes or {}
    table.insert(self.zrush_ActiveDrillholes, drillhole_entindex)
end

// Return active drillhole count
function meta_ply:zrush_ReturnActiveDrillHoleCount()
    local activedrillholes = 0

    for k, v in pairs(ents.FindByClass("zrush_drillhole")) do
        if (IsValid(v) and zrush.f.GetOwnerID(v) == self:SteamID() and v.Closed == false) then
            activedrillholes = activedrillholes + 1
        end
    end

    return activedrillholes
end

// This adds the specific fuel do our inv
function meta_ply:zrush_AddFuelBarrel(fID, fAmount)
    self.zrush_INV_FuelBarrels = self.zrush_INV_FuelBarrels or {}
    self.zrush_INV_FuelBarrels[fID] = self.zrush_INV_FuelBarrels[fID] or 0
    self.zrush_INV_FuelBarrels[fID] = self.zrush_INV_FuelBarrels[fID] + fAmount
end

// This removes the specific fuel from our inv
function meta_ply:zrush_RemoveFuelBarrel(fID, fAmount)
    self.zrush_INV_FuelBarrels = self.zrush_INV_FuelBarrels or {}
    self.zrush_INV_FuelBarrels[fID] = self.zrush_INV_FuelBarrels[fID] or 0
    self.zrush_INV_FuelBarrels[fID] = self.zrush_INV_FuelBarrels[fID] - fAmount
end

// This gives us a table of all the fuel barrels the player has in his inv
function meta_ply:zrush_GetFuelBarrels()
    self.zrush_INV_FuelBarrels = self.zrush_INV_FuelBarrels or {}

    return self.zrush_INV_FuelBarrels
end

// This returns true if we have fuel in our inv
function meta_ply:zrush_HasFuelBarrels()
    self.zrush_INV_FuelBarrels = self.zrush_INV_FuelBarrels or {}
    local hasBarrels = false

    for k, v in pairs(self.zrush_INV_FuelBarrels) do
        if (v > 0) then
            hasBarrels = true
            break
        end
    end

    return hasBarrels
end

// This returns the amount of barrels in our inventory
function meta_ply:zrush_GetFuelBarrelCount()
    local b_Count = 0
    if self.zrush_INV_FuelBarrels and table.Count(self.zrush_INV_FuelBarrels) > 0 then
        for k, v in pairs(self.zrush_INV_FuelBarrels) do
            if (v > 0) then
                b_Count = b_Count + math.Round(v / zrush.config.Machine["Barrel"].Storage, 0)
            end
        end
    end
    return b_Count
end

function meta_ply:zrush_SoldFuelBarrel(fID, fAmount)
    self.zrush_SOLD_FuelBarrels = self.zrush_SOLD_FuelBarrels or {}
    self.zrush_SOLD_FuelBarrels[fID] = self.zrush_SOLD_FuelBarrels[fID] or 0
    self.zrush_SOLD_FuelBarrels[fID] = self.zrush_SOLD_FuelBarrels[fID] + fAmount
end

// This gives us a table of all the fuel barrels the player sold
function meta_ply:zrush_GetFuelBarrelsSold()
    self.zrush_SOLD_FuelBarrels = self.zrush_SOLD_FuelBarrels or {}

    return self.zrush_SOLD_FuelBarrels
end

concommand.Add("zrush_debug_GetFuelBarrelCount", function(ply, cmd, args)
    if zrush.f.IsAdmin(ply) then
        print("Barrels in Inventory: " .. ply:zrush_GetFuelBarrelCount())
    end
end)

concommand.Add("zrush_debug_GetFuelBarrels", function(ply, cmd, args)
    if zrush.f.IsAdmin(ply) then
        PrintTable(ply:zrush_GetFuelBarrels())
    end
end)

concommand.Add("zrush_debug_GetFuelBarrelsSold", function(ply, cmd, args)
    if zrush.f.IsAdmin(ply) then
        PrintTable(ply:zrush_GetFuelBarrelsSold())
    end
end)
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
////////////// Player Death ////////////////
////////////////////////////////////////////
// Closes all ui stuff
local function zrush_CloseAllUI(ply)
    // This closes the machine UI
    net.Start("zrush_ForceCloseMachineUI_net")
    net.Send(ply)

    // This closes the npc buyer UI
    net.Start("zrush_CloseSellFuelUI_net")
    net.Send(ply)

    // This closes the barrel UI
    net.Start("zrush_CloseFuelSplitUI_net")
    net.Send(ply)

    // This closes the MachineCrate OptionBox UI
    net.Start("zrush_MachineCrateOB_Close_net")
    net.Send(ply)

    // This closes the MachineShop UI
    net.Start("zrush_MachineCrate_Close_net")
    net.Send(ply)
end

function zrush.f.PlayerDeath(victim, inflictor, attacker)
    zrush.f.PlayerDropFuel(victim)
end

hook.Add("PostPlayerDeath", "a.zrush.PostPlayerDeath", function(ply, text)
    zrush_CloseAllUI(ply)
end)

hook.Add("PlayerSilentDeath", "a.zrush.PlayerSilentDeath", function(ply, text)
    zrush_CloseAllUI(ply)
end)

hook.Add("PlayerDeath", "a.zrush.PlayerDeath", function(victim, inflictor, attacker)
    if (zrush.config.Player.DropFuelOnDeath) then
        zrush.f.PlayerDeath(victim, inflictor, attacker)
    end
end)
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
//////////// Fuel Inventory ////////////////
////////////////////////////////////////////
local function spawn_FuelBarrel(pos, fuelId, amount, ply)
    local ent = ents.Create("zrush_barrel")
    ent:SetAngles(Angle(0, 0, 0))
    ent:SetPos(pos)
    ent:Spawn()
    ent:Activate()
    ent:SetFuelTypeID(fuelId)
    ent:SetFuel(amount)

    zrush.f.Barrel_UpdateVisual(ent)

    zrush.f.SetOwner(ent, ply)

    return ent
end

function zrush.f.PlayerDropFuel(ply)
    if (IsValid(ply)) then
        local fuelBarrels = ply:zrush_GetFuelBarrels()

        for k, v in pairs(fuelBarrels) do
            // Do we have fuel in this id?
            if (v > 0) then
                // Do we have more fuel of this type in the inv as the max capacity of a barrel can hold?
                if (v > zrush.config.Machine["Barrel"].Storage) then
                    local totalFuel = v
                    local barrelCount = totalFuel / zrush.config.Machine["Barrel"].Storage
                    local fullBarrelCount = math.floor(barrelCount)

                    // This spawns the full barrels
                    for i = 1, fullBarrelCount do
                        spawn_FuelBarrel(ply:GetPos() + ply:GetForward() * 50 + ply:GetUp() * 25 * i, k, zrush.config.Machine["Barrel"].Storage, ply)
                        ply:zrush_RemoveFuelBarrel(k, zrush.config.Machine["Barrel"].Storage)
                    end

                    local restamount = totalFuel - (fullBarrelCount * zrush.config.Machine["Barrel"].Storage)

                    if (restamount > 0) then
                        // This spawns the rest amount in a barrel
                        spawn_FuelBarrel(ply:GetPos() + ply:GetForward() * 50 + ply:GetUp() * 25, k, restamount, ply)
                        ply:zrush_RemoveFuelBarrel(k, restamount)
                    end
                else
                    spawn_FuelBarrel(ply:GetPos() + ply:GetForward() * 50 + ply:GetUp() * 25, k, v, ply)
                    ply:zrush_RemoveFuelBarrel(k, v)
                end
            end
        end
    end
end

hook.Add("PlayerSay", "a.zrush.PlayerSay.DropFuel", function(ply, text)
    if string.sub(string.lower(text), 1, 9) == "!dropfuel" then
        if (ply:zrush_HasFuelBarrels()) then
            zrush.f.PlayerDropFuel(ply)
        else
            zrush.f.Notify(ply, zrush.language.Inv["InvEmpty"], 1)
        end
    end
end)

// Tells the player its fuel inventory
hook.Add("PlayerSay", "a.zrush.PlayerSay.FuelInv", function(ply, text)
    if string.sub(string.lower(text), 1, 8) == "!fuelinv" then
        if (ply:zrush_HasFuelBarrels()) then
            local fueltabl = ply:zrush_GetFuelBarrels()
            local sortedTable = {}

            for k, v in pairs(fueltabl) do
                if (v > 0) then
                    local info = "| " .. zrush.Fuel[k].name .. ": " .. math.Round(v) .. " |"
                    table.insert(sortedTable, info)
                end
            end

            sortedTable = table.concat(sortedTable, " ")
            zrush.f.Notify(ply, sortedTable, 0)
            zrush.f.Notify(ply, zrush.language.Inv["FuelInv"], 3)
        else
            zrush.f.Notify(ply, zrush.language.Inv["InvEmpty"], 1)
        end
    end
end)
////////////////////////////////////////////
////////////////////////////////////////////
