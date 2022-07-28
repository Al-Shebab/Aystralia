--[[
    MGangs 2 - TERRITORIES - (SH) Config
    Developed by Zephruz
]]

MG2_TERRITORIES.config = (MG2_TERRITORIES.config or {})

--[[
    MG2_TERRITORIES.config.claim
]]
MG2_TERRITORIES.config.claim = {
    radius = 10000,   -- How close a player has to be to the flag to claim it
    time = 10,      -- How long it takes to claim a territory
}

--[[
    MG2_TERRITORIES.config.rewards 
    
    - Rewards a gang receives for claiming and holding a territory
]]
MG2_TERRITORIES.config.rewards = {
    claim = {
        EXP = 25,
        Balance = 200,
    },
    hold = {
        EXP = 5,
        Balance = 10,
    },
}

--[[
    MG2_TERRITORIES.config.rewardHoldFrequency

    - How frequently a gang is rewarded for keeping a territory claimed
    - Only will reward if a gangs player is online
]]
MG2_TERRITORIES.config.rewardHoldFrequency = 300

--[[
    MG2_TERRITORIES.config.unclaimNoPlayers
    
    - Automatically set a territory as unclaimed when a gang has no players online
]]
MG2_TERRITORIES.config.unclaimNoPlayers = false

--[[
    MG2_TERRITORIES.config.showHUD - Display the HUD when in a territory
]]
MG2_TERRITORIES.config.showHUD = true