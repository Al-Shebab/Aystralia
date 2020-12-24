if not SERVER then return end
zrmine = zrmine or {}
zrmine.lvlsys = zrmine.lvlsys or {}

-- Admin
function zrmine.lvlsys.FindPlayerBySteamID(plyID)
    local pls = player.GetAll()
    local foundply = nil

    --Find by Partial Nick
    for k, v in pairs(pls) do
        if IsValid(v) and v:IsPlayer() and v:Alive() and v:SteamID() == plyID then
            foundply = v
            break
        end
    end

    return foundply
end


function zrmine.lvlsys.AdminReset(ply,plyID)

    if ply == nil or zrmine.f.IsAdmin(ply) then
        local foundply = zrmine.lvlsys.FindPlayerBySteamID(plyID)

        if (IsValid(foundply) and foundply:IsPlayer() and foundply:Alive()) then
            zrmine.lvlsys.PlayerReset(foundply)

            if IsValid(ply) then
                zrmine.f.Notify(ply, "You reseted " .. foundply:Name() .. " Level!", 0)
            end
        else
            if IsValid(ply) then
                zrmine.f.Notify(ply, "No Valid Player Found!", 1)
            end
        end
    else
        zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
    end
end

function zrmine.lvlsys.AdminGiveXP(ply, plyID, xp)
    if ply == nil or zrmine.f.IsAdmin(ply)  then
        local foundply = zrmine.lvlsys.FindPlayerBySteamID(plyID)

        if (xp == nil or xp <= 0) then
            zrmine.f.Notify(ply, "Not a valid number!", 1)

            return
        end

        if (not IsValid(foundply) or not foundply:IsPlayer() or not foundply:Alive()) then
            zrmine.f.Notify(ply, "No Valid Player Found!", 1)

            return
        end

        zrmine.lvlsys.AddXP(foundply, xp)

        if IsValid(ply) then
            zrmine.f.Notify(ply, "You gave " .. foundply:Nick() .. " " .. xp .. " XP!", 0)
        end
    else
        if IsValid(ply) then
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end
end

function zrmine.lvlsys.AdminGiveLvl(ply, plyID, lvl)
    if ply == nil or zrmine.f.IsAdmin(ply) then
        local foundply = zrmine.lvlsys.FindPlayerBySteamID(plyID)

        if (lvl == nil or lvl <= 0) then
            zrmine.f.Notify(ply, "Not a valid number!", 1)

            return
        end

        if (not IsValid(foundply) or not foundply:IsPlayer()) then
            zrmine.f.Notify(ply, "No Valid Player Found!", 1)

            return
        end

        zrmine.lvlsys.AddLvl(foundply, tonumber(lvl))

        if IsValid(ply) then
            zrmine.f.Notify(ply, "You gave " .. foundply:Nick() .. " " .. lvl .. " Level!", 0)
        end
    else
        if IsValid(ply) then
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end
end

-- Level Up
function zrmine.lvlsys.LevelUpCheck(ply)
    local PlyLvl = ply.zrms.lvl
    local PlyXP = ply.zrms.xp

    if (zrmine.config.Pickaxe_Lvl[PlyLvl + 1] and PlyXP >= zrmine.config.Pickaxe_Lvl[PlyLvl].NextXP) then
        zrmine.lvlsys.AddLvl(ply, 1)
        zrmine.lvlsys.SetXP(ply, zrmine.lvlsys.HasXP(ply) - zrmine.config.Pickaxe_Lvl[PlyLvl].NextXP)
        zrmine.f.Notify(ply, zrmine.language.LvlSys_LvlUp, 0)
    end

    zrmine.lvlsys.SwepUpdate(ply)
end

-- XP
function zrmine.lvlsys.AddXP(ply, amount)
    if (amount ~= nil) then
        ply.zrms.xp = ((ply.zrms.xp or 0) + amount)
    else
        ply.zrms.xp = ply.zrms.xp or 0
    end

    zrmine.data.DataChanged(ply)
    zrmine.lvlsys.LevelUpCheck(ply)
end

function zrmine.lvlsys.SetXP(ply, amount)
    if (amount ~= nil) then
        ply.zrms.xp = amount
    end

    zrmine.lvlsys.SwepUpdate(ply)
    zrmine.data.DataChanged(ply)
    zrmine.lvlsys.LevelUpCheck(ply)
end

function zrmine.lvlsys.HasXP(ply)
    local xp = 0

    if IsValid(ply) and ply.zrms and ply.zrms.xp then
        xp = ply.zrms.xp
    end

    return xp
end

-- Lvl
function zrmine.lvlsys.AddLvl(ply, amount)
    local setAmount = 0

    if IsValid(ply) and ply.zrms and ply.zrms.lvl then
        setAmount = ply.zrms.lvl + amount
    end

    if (setAmount > (table.Count(zrmine.config.Pickaxe_Lvl) - 1)) then
        setAmount = table.Count(zrmine.config.Pickaxe_Lvl) - 1
    end

    if (amount ~= nil) then
        ply.zrms.lvl = math.Clamp(setAmount, 0, table.Count(zrmine.config.Pickaxe_Lvl) - 1)
    else
        ply.zrms.lvl = amount
    end

    if (ply.zrms.lvl >= (table.Count(zrmine.config.Pickaxe_Lvl) - 1)) then
        zrmine.f.Notify(ply, zrmine.language.LvlSys_LvlMax, 0)
    end

    zrmine.lvlsys.SwepUpdate(ply)
    zrmine.data.DataChanged(ply)
end

function zrmine.lvlsys.SetLvl(ply, amount)

    if (amount ~= nil) then
        ply.zrms.lvl = math.Clamp(amount, 0, table.Count(zrmine.config.Pickaxe_Lvl) - 1)
    else
        ply.zrms.lvl = 0
    end

    zrmine.lvlsys.SwepUpdate(ply)
    zrmine.data.DataChanged(ply)
end

function zrmine.lvlsys.ReturnLvl(ply)
    local lvl = 0
    if IsValid(ply) and ply.zrms and ply.zrms.lvl then
        lvl = ply.zrms.lvl
    end

    return lvl
end

function zrmine.lvlsys.PlayerReset(ply)
    zrmine.lvlsys.SetXP(ply, 0)
    zrmine.lvlsys.SetLvl(ply, 0)
    zrmine.lvlsys.SwepUpdate(ply)
    zrmine.f.Notify(ply, zrmine.language.LvlSys_LvlReset, 1)
end

function zrmine.lvlsys.SwepUpdate(ply)
    if (ply:HasWeapon("zrms_pickaxe")) then
        zrmine.f.Pickaxe_UpdateLvlVar(ply:GetWeapon("zrms_pickaxe"),ply)
    end
end
