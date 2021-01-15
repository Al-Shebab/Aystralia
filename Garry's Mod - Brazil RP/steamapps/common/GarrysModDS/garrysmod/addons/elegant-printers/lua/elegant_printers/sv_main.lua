resource.AddWorkshop("1472719548")

hook.Add("playerBoughtCustomEntity", "elegant_printers", function(ply, itemData, ent, price)
    if ent:GetClass() == "sent_elegant_printer" and itemData.tier then
        ent:SetTier(itemData.tier)
    end
end)

hook.Add("canBuyCustomEntity", "elegant_printers", function(ply, itemData)
    if itemData.ent ~= "sent_elegant_printer" then return end

    local owned = 0
    for _, ent in next, ents.FindByClass("sent_elegant_printer") do
        if ent:Getowning_ent() == ply then
            owned = owned + 1
        end
    end
    if owned >= (elegant_printers.config.GlobalMaxVIPs[ply:GetUserGroup()] or elegant_printers.config.GlobalMax) then return false, false, "You can't buy any more printers!" end

    local tierData = itemData.tier and elegant_printers.config.Tiers[itemData.tier] or nil
    local allowedVIPs = (tierData and tierData.AllowedVIPs) and tierData.AllowedVIPs or elegant_printers.config.AllowedVIPs
    if allowedVIPs and table.Count(allowedVIPs) > 0 then
        local allowed = false
        for _, group in next, allowedVIPs do
            if ply:IsUserGroup(group) then
                allowed = true
                break
            end
        end
        if not allowed then return false, false, "You are not allowed to buy this printer!" end
    end
end)

hook.Add("canPocket", "elegant_printers", function(ply, ent)
    if ent:GetClass() == "sent_elegant_printer" and ent:GetExploding() then return false, "This shit's exploding!!" end
end)

hook.Add("CanEditVariable", "elegant_printers", function(ent, ply, k, v)
    if ent:GetClass() == "sent_elegant_printer" and IsValid(ent:Getowning_ent()) and not ply:IsSuperAdmin() then return false end
end)

-- Why do I have to do this?!!
gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "elegant_printers", function(data)
    local steamId, bot, ply = data.networkid, data.bot, Player(data.userid)

    if bot == 0 and IsValid(ply) then
        for _, ent in pairs(ents.FindByClass("sent_elegant_printer")) do
            if ent:Getowning_ent() == ply then
                ent.owning_ent_disconnected_steamId = steamId
            end
        end
        for _, ent in pairs(player.GetAll()) do
            if ent.darkRPPocket then
                for _, item in pairs(ent.darkRPPocket) do
                    if item.ClassName == "sent_elegant_printer" and item.DT.owning_ent == ply then
                        item.owning_ent_disconnected_steamId = steamId
                    end
                end
            end
        end
    end
end)
hook.Add("PlayerAuthed", "elegant_printers", function(ply, steamId)
    for _, ent in pairs(ents.FindByClass("sent_elegant_printer")) do
        if ent.owning_ent_disconnected_steamId == steamId then
            ent:Setowning_ent(ply)
            ent.owning_ent_disconnected_steamId = nil
        end
    end
    for _, ent in pairs(player.GetAll()) do
        if ent.darkRPPocket then
            for _, item in pairs(ent.darkRPPocket) do
                if item.ClassName == "sent_elegant_printer" and item.owning_ent_disconnected_steamId == steamId then
                    item.DT.owning_ent = ply
                    item.owning_ent_disconnected_steamId = nil
                end
            end
        end
    end
end)

elegant_printers.EventDuration = nil

function elegant_printers.IsEventActive()
    if not elegant_printers.EventDuration then
        elegant_printers.EventDuration = tonumber(file.Read("elegant_printers_event.txt", "DATA") or 0)
    end
    return os.time() < elegant_printers.EventDuration
end

function elegant_printers.TriggerEvent(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    elegant_printers.EventDuration = os.time() + elegant_printers.config.EventDuration
    file.Write("elegant_printers_event.txt", elegant_printers.EventDuration)

    net.Start("elegant_printers_event_announce")
        net.WriteFloat(elegant_printers.config.EventPrintMultiplier)
        net.WriteFloat(elegant_printers.config.EventDuration)
    net.Broadcast()
    elegant_printers.Print("Event mode turned on for the next " .. string.NiceTime(elegant_printers.config.EventDuration))
end

concommand.Add("elegant_printers_triggerevent", elegant_printers.TriggerEvent)

util.AddNetworkString("elegant_printers_event_announce")

elegant_printers.Print("Loaded server")
