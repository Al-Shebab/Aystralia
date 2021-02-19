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

bailNPC = bailNPC or {}

bailNPC.bailMessageClient           = "You have bailed %s out of Prison!"               -- %s = Name of arrested Player
bailNPC.bailMessageArrestedClient   = "%s bailed you out of Prison!"                    -- %s = Name of Player who bailed the arrested Player out
bailNPC.cannotAffordMessage         = "You cannot afford this!"

bailNPC.menuTitle                   = "Bail NPC"
bailNPC.prisonEmptyText             = "Sorry, but the Prison is currently empty!"
bailNPC.arrestedText                = "Arrested by %s"                                  -- %s = Name of Police Officer

bailNPC.npcName                     = "Bail NPC"
bailNPC.npcNameColor                = Color(255, 255, 255, 255)


--#####################################################################################################################
-- You can easily spawn in a NPC Ingame and press WALK + USE (by default ALT + E) while looking at it to get the
-- position and angle of the NPC printed to console.

bailNPC.positionData = {
    {
        ["pos"]     = Vector(3890.968750, -926.875000, 72.031250),
        ["ang"]     = Angle(0, 180, 0),
        ["model"]   = "models/police.mdl",                              -- Optional - Default = "models/police.mdl"
        ["map"]     = "rp_bangclaw"                                     -- Optional - Default = All Maps
    },
}

--#####################################################################################################################

--
-- Allowed Check Function
-- client           = Client trying to bail someone out of Prison
-- You can perform anything here to check if a Client is allowed to use the Bail NPC.
--
bailNPC.allowedCheck = function(client)
    return true
end

bailNPC.allowArrestedBail            = true -- Allow Players to bail someone (or themself) out while they are in Prison

bailNPC.bailNotAllowedMessage       = "Sorry, but you are not allowed to bail people out of Prison!"

--#####################################################################################################################
--
-- Price Calculator Function
-- client           = Client that pays Bail
-- arrestedClient   = Client in Prison
-- prisonTime       = Time left in Prison
--

bailNPC.priceCalculator = function(client, arrestedClient, prisonTime)
    return (prisonTime * 25)
end

--#####################################################################################################################