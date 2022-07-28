--[[
    MGangs 2 - (SH) Config
    Developed by Zephruz
]]

mg2.config = (mg2.config or {})

--[[
    mg2.config.currencyType - What currency system you're using

    - Set to false if not using
    - Current types:
        - darkrp
        - nutscript
]]
mg2.config.currencyType = "darkrp"

--[[
    mg2.config.gangCost - How much a gang costs
]]
mg2.config.gangCost = 100

--[[
    mg2.config.balanceSymbol

    - The money/balance symbol used
]]
mg2.config.balanceSymbol = "$"

--[[
    mg2.config.adminGroups - Administration groups
]]
mg2.config.adminGroups = {"founder", "superadmin", "admin"}

--[[
    mg2.config.defaultTheme - The default theme
]]
mg2.config.defaultTheme = "Midnight"

--[[
    mg2.config.defaultLanguage - The default language
]]
mg2.config.defaultLanguage = "en"

--[[
    mg2.config.maxGangNameSize - Maximum gang name length/size in charaacters
]]
mg2.config.maxGangNameSize = 20

--[[
    mg2.config.maxGangMOTDSize - Maximum gang MOTD length/size in characters
]]
mg2.config.maxGangMOTDSize = 100

--[[
    mg2.config.useProfanityFilterAPI
    
    - Use the profanity filter API which contains a list of profanity
    - You can use this if you want, but it is also recommended to add your own profanity filtered words below
]]
mg2.config.useProfanityFilterAPI = false

--[[
    mg2.config.profanityFilter 
    
    - Banned gang (and group) names
        * Will be used in places that a player can enter a (public) value
]]
mg2.config.profanityFilter = {
    "fagsdfbdbabvasva",
}

--[[
    mg2.config.showGangHUD - Display a users gang when looking at them
]]
mg2.config.showGangHUD = true

--[[
    mg2.config.disableMenuHints - Enables/disables hints on the menus
]]
mg2.config.disableMenuHints = false

--[[
    mg2.config.gangLeveling - Information regarding levels
]]
mg2.config.gangLeveling = {
    maxLevel = false, -- The max level a gang can reach (set to false for infinite)

    -- expCalculation: How much exp is required to level up
    expCalculation = function(level)
        return ((level*0.5) * 100)
    end,
}

--[[
    mg2.config.defaultGroups - The default gang groups

    - RECOMMENDED TO NOT EDIT
]]
mg2.config.defaultGroups = {
    ["Recruit"] = {
        IsRecruit = true,
        Priority = 1,
        Icon = "icon16/user.png",
        Color = Color(255,125,125),
    },
    ["Leader"] = {
        IsLeader = true,
        Priority = 100,
        Icon = "icon16/user_gray.png",
        Color = Color(125,255,125),
    },
}

--[[
    mg2.config.currencyTypes - Currency types for different gamemodes

    - RECOMMENDED TO NOT EDIT
]]
mg2.config.currencyTypes = {
    ["darkrp"] = {
        typeValid = function() return DarkRP end,
        canAfford = function(ply,val)
            return ply:canAfford(val)
        end,
        giveMoney = function(ply,val)
            return ply:addMoney(val)
        end,
        takeMoney = function(ply,val)
            return ply:addMoney(-val)
        end,
        getMoney = function(ply)
            return ply:getDarkRPVar("money")
        end,
    },
    ["nutscript"] = {
        typeValid = function() return nut end,
        canAfford = function(ply,val)
            local char = ply:getCharacter()

            return (char && char:hasMoney(val))
        end,
        giveMoney = function(ply,val)
            local char = ply:getCharacter()

            return (char && char:giveMoney(val))
        end,
        takeMoney = function(ply,val)
            local char = ply:getCharacter()

            return (char && char:takeMoney(val))
        end,
        getMoney = function(ply)
            local char = ply:getCharacter()

            return (char && char:getMoney())
        end,
    },
}