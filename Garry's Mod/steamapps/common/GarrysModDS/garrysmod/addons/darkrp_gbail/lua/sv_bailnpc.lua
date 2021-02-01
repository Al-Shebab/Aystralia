--        ____        _ _
--       |  _ \      (_) |   Package Information
--   __ _| |_) | __ _ _| |   @package      gBail
--  / _` |  _ < / _` | | |   @author       Guurgle
-- | (_| | |_) | (_| | | |   @build        1.0.2
--  \__, |____/ \__,_|_|_|   @release      06/26/2016
--   __/ |    _              _____                       _
--  |___/    | |            / ____|                     | |
--           | |__  _   _  | |  __ _   _ _   _ _ __ __ _| | ___
--           | '_ \| | | | | | |_ | | | | | | | '__/ _` | |/ _ \
--           | |_) | |_| | | |__| | |_| | |_| | | | (_| | |  __/
--           |_.__/ \__, |  \_____|\__,_|\__,_|_|  \__, |_|\___|
--                   __/ |                          __/ |
--                  |___/                          |___/ 

hook.Add("playerArrested", "bailArrested", function(client, time, arrester)
    if (IsValid(client)) then client:SetNWFloat("bailEnd", CurTime() + time) end
    if (IsValid(arrester)) then client:SetNWString("bailArrester", arrester:GetName()) end
end)

hook.Add("playerUnArrested", "bailUnArrested", function(client, unarrester)
    if (IsValid(client)) then
        client:SetNWString("bailArrester", "")
        client:SetNWFloat("bailEnd", nil)
    end
end)

netstream.Hook("bailMenu", function(client, arrestedClient)
    if (not IsValid(client) or not IsValid(arrestedClient)) then return end
    if (bailNPC.canUseMenu(client, true) == false or not arrestedClient:isArrested()) then return end

    local bailPrice = bailNPC.calculatePrice(client, arrestedClient)

    if (client:canAfford(bailPrice)) then
        client:addMoney(-bailPrice)
        arrestedClient:unArrest()

        DarkRP.notify(client, 0, 3, string.format(bailNPC.bailMessageClient, arrestedClient:Nick()))
        DarkRP.notify(arrestedClient, 0, 3, string.format(bailNPC.bailMessageArrestedClient, client:Nick()))

        DarkRP.log(client:Nick() .. " (" .. client:SteamID() .. ") bailed " .. arrestedClient:Nick() .. " (" .. arrestedClient:SteamID() .. ") out of Prison. (" .. DarkRP.formatMoney(bailPrice) .. ")", Color(0, 255, 255))
    else DarkRP.notify(client, 1, 3, bailNPC.cannotAffordMessage) end
end)

function bailNPC.deployNPCs()
    if (bailNPC.positionData) then
        for k, v in pairs(bailNPC.positionData) do
            if (type(v["pos"]) != "Vector" or type(v["ang"]) != "Angle") then continue end
            if (v["map"] and v["map"] != game.GetMap()) then continue end

            local npcEntity = ents.Create("guurgle_bailnpc")
            npcEntity:SetPos(v["pos"])
            npcEntity:SetAngles(v["ang"])
            npcEntity:Spawn()
            npcEntity:SetModel(v["model"] or "models/police.mdl")
        end
    end
end
hook.Add("InitPostEntity", "bailNPC", bailNPC.deployNPCs)
hook.Add("PostCleanupMap", "bailNPC", bailNPC.deployNPCs)