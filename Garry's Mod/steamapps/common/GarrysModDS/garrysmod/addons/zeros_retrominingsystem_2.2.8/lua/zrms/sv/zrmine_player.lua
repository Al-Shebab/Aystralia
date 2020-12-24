if not SERVER then return end

zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

zrmine.players = zrmine.players or {}

////////////////////////////////////////////
//////////////// NW Timeout ////////////////
////////////////////////////////////////////
// How often are clients allowed to send net messages to the server
ZRMS_NW_TIMEOUT = 0.1

function zrmine.f.Player_Timeout(ply)
    local Timeout = false

    if ply.zrms_NWTimeout and ply.zrms_NWTimeout > CurTime() then
        zrmine.f.Debug("Player_Timeout!")

        Timeout = true
    end

    ply.zrms_NWTimeout = CurTime() + ZRMS_NW_TIMEOUT

    return Timeout
end
////////////////////////////////////////////
////////////////////////////////////////////


function zrmine.f.Player_IsMiner(ply)
    if zrmine.config.Jobs and table.Count(zrmine.config.Jobs) > 0 then
        if zrmine.config.Jobs[zrmine.f.GetPlayerJob(ply)] == true then
            return true
        else
            return false
        end
    else
        return true
    end
end




////////////////////////////////////////////
/////////////// Player INIT ////////////////
////////////////////////////////////////////
util.AddNetworkString("zrmine_Player_Initialize")
net.Receive("zrmine_Player_Initialize", function(len, ply)

    if not IsValid(ply) then return end

    if ply.zrms_HasInitialized then
        return
    else
        ply.zrms_HasInitialized = true
    end

    zrmine.f.Debug("zrmine_Player_Initialize Netlen: " .. len)

    zrmine.f.Player_Add(ply)

    zrmine.data.PlayerSpawn(ply)
end)

function zrmine.f.Player_Add(ply)
    zrmine.players[zrmine.f.Player_GetID(ply)] = ply
end

function zrmine.f.Player_Remove(steamid)
    zrmine.players[steamid] = nil
end
////////////////////////////////////////////
////////////////////////////////////////////



////////////////////////////////////////////
/////////////// Player META ////////////////
////////////////////////////////////////////
// Meta Tables
local meta_ply = FindMetaTable("Player")

// This adds the specific Metal Bar Type and amount too our Sold metal bar table
function meta_ply:zrms_AddMetalBarsSold(mType, mAmount)
    self.zrms_SoldBars = self.zrms_SoldBars or {}
    self.zrms_SoldBars["Iron"] = self.zrms_SoldBars["Iron"] or 0
    self.zrms_SoldBars["Bronze"] = self.zrms_SoldBars["Bronze"] or 0
    self.zrms_SoldBars["Silver"] = self.zrms_SoldBars["Silver"] or 0
    self.zrms_SoldBars["Gold"] = self.zrms_SoldBars["Gold"] or 0
    self.zrms_SoldBars[mType] = self.zrms_SoldBars[mType] + mAmount
end

// This gives us a table of all the metal bars the player has sold
function meta_ply:zrms_GetMetalBarsSold()
    self.zrms_SoldBars = self.zrms_SoldBars or {}
    self.zrms_SoldBars["Iron"] = self.zrms_SoldBars["Iron"] or 0
    self.zrms_SoldBars["Bronze"] = self.zrms_SoldBars["Bronze"] or 0
    self.zrms_SoldBars["Silver"] = self.zrms_SoldBars["Silver"] or 0
    self.zrms_SoldBars["Gold"] = self.zrms_SoldBars["Gold"] or 0

    return self.zrms_SoldBars
end

// This gives us a table of all the stored MetalBars the player has
function meta_ply:zrms_GetMetalBars()
    self.zrms_Bars = self.zrms_Bars or {}
    self.zrms_Bars["Iron"] = self.zrms_Bars["Iron"] or 0
    self.zrms_Bars["Bronze"] = self.zrms_Bars["Bronze"] or 0
    self.zrms_Bars["Silver"] = self.zrms_Bars["Silver"] or 0
    self.zrms_Bars["Gold"] = self.zrms_Bars["Gold"] or 0

    return self.zrms_Bars
end

// This tells us if the player has metal bars
function meta_ply:zrms_HasMetalBars()
    local metalCount = 0
    for k, v in pairs(self:zrms_GetMetalBars()) do
        if v and v > 0 then
            metalCount = metalCount + v
        end
    end

    return metalCount > 0
end

// This Resets the Players MetalBars
function meta_ply:zrms_ResetMetalBars()
    self.zrms_Bars = self.zrms_Bars or {}
    self.zrms_Bars["Iron"] = 0
    self.zrms_Bars["Bronze"] = 0
    self.zrms_Bars["Silver"] = 0
    self.zrms_Bars["Gold"] = 0
end

// This Adds the specific metal bar too the player
function meta_ply:zrms_AddMetalBar(mType, mAmount)
    self.zrms_Bars = self.zrms_Bars or {}
    self.zrms_Bars[mType] = (self.zrms_Bars[mType] or 0) + mAmount
end
////////////////////////////////////////////
////////////////////////////////////////////



local zrms_DeleteEnts = {"zrms_basket", "zrms_conveyorbelt", "zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right",
"zrms_crusher", "zrms_gravelcrate", "zrms_melter", "zrms_mineentrance_base", "zrms_inserter", "zrms_refiner_iron", "zrms_refiner_coal", "zrms_refiner_bronze",
"zrms_refiner_silver", "zrms_refiner_gold", "zrms_splitter", "zrms_storagecrate", "zrms_sorter_bronze", "zrms_sorter_coal", "zrms_sorter_gold", "zrms_sorter_iron",
"zrms_sorter_silver"}

hook.Add("OnPlayerChangedTeam", "a_zrmine_OnPlayerChangedTeam", function(ply, before, after)
    if IsValid(ply) then
        if zrmine.config.Jobs[before] then
            ply:zrms_ResetMetalBars()
        end

        for k, v in pairs(zrmine.EntList) do
            if IsValid(v) and table.HasValue(zrms_DeleteEnts, v:GetClass()) and zrmine.f.GetOwnerID(v) == ply:SteamID() then
                v:Remove()
            end
        end
    end
end)






function zrmine.f.PlayerDeath(victim, inflictor, attacker)
    if IsValid(victim) and victim.zrms_Bars ~= nil then

        local bars = victim:zrms_GetMetalBars()


        local barCount = bars.Iron + bars.Bronze + bars.Silver + bars.Gold

        if barCount > 0 then
            local ent = ents.Create("zrms_storagecrate")
            ent:SetAngles(Angle(0, 0, 0))
            ent:SetPos(victim:GetPos())
            ent:Spawn()
            ent:Activate()

            // This adds the entity to the DroppedChests Table so it can be removed if left alone too long
            zrmine.f.AddDroppedChest(ent)

            ent:SetbIron(bars.Iron)
        	ent:SetbBronze(bars.Bronze)
        	ent:SetbSilver(bars.Silver)
        	ent:SetbGold(bars.Gold)

            ent:SpawnFromInventory()

            victim:zrms_ResetMetalBars()
        end
    end
end

hook.Add("PlayerDeath", "a_zrmine_PlayerDeath", function(victim, inflictor, attacker)
    if zrmine.config.MetalBar_DropOnDeath then
        zrmine.f.PlayerDeath(victim, inflictor, attacker)
    end
end)





local function AdminSay(cmd, txt, ply)
    if string.sub(string.lower(txt), 1, string.len(cmd)) == cmd then
        if zrmine.f.IsAdmin(ply) then
            return true
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)

            return false
        end
    else
        return false
    end
end
hook.Add("PlayerSay", "a_zrmine_HandleConCanCommands", function(ply, text)

    if AdminSay("!savezrms",text,ply) then
        zrmine.f.OreSpawn_Save(ply)

        zrmine.f.BuyerNPC_Save(ply)

        zrmine.f.PublicEnts_Save(ply)

    elseif AdminSay("!zrms_lvlsys_reset",text,ply) then
        local strings = string.Split(text, " ")
        zrmine.lvlsys.AdminReset(ply, strings[2])
    elseif AdminSay("!zrms_lvlsys_xp",text,ply) then
        local strings = string.Split(text, " ")
        zrmine.lvlsys.AdminGiveXP(ply, strings[2], tonumber(strings[3], 10))
    elseif AdminSay("!zrms_lvlsys_lvl",text,ply) then
        local strings = string.Split(text, " ")
        zrmine.lvlsys.AdminGiveLvl(ply, strings[2], tonumber(strings[3], 10))
    elseif AdminSay("!zrms_savepipeline",text,ply) then
        zrmine.f.PipeLine_Save(ply)
    end
end)
