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

function bailNPC.timeLeft(arrestedClient)
    local bailEnd   = arrestedClient:GetNWFloat("bailEnd")
    local timeLeft  = math.Round(bailEnd - CurTime())

    return timeLeft
end

function bailNPC.calculatePrice(client, arrestedClient)
    if (not arrestedClient:isArrested()) then return nil end

    local bailPrice = bailNPC.priceCalculator(client, arrestedClient, bailNPC.timeLeft(arrestedClient))
    return (bailPrice or 0)
end

function bailNPC.canUseMenu(client, notifyClient)
    local arrestedCheck = (client:isArrested() and bailNPC.allowArrestedBail)
    local allowedCheck  = (bailNPC.allowedCheck and bailNPC.allowedCheck(client))
    local rangeCheck    = gCore.isInRange(client, "guurgle_bailnpc")

    if ((arrestedCheck == true or arrestedCheck == nil) and allowedCheck) then
        if (rangeCheck) then return true else return false end
        return true
    else 
        if (notifyClient == true) then if (SERVER) then DarkRP.notify(client, 1, 3, bailNPC.bailNotAllowedMessage) else notification.AddLegacy(bailNPC.bailNotAllowedMessage, 1, 3) end end
        return false
    end
end