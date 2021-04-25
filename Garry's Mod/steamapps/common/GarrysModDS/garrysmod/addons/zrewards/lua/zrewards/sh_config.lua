--[[
    ZRewards - (SH) Config
    Developed by Zephruz
]]

zrewards.config = (zrewards.config or {})
zrewards.config.rewards = {} -- DON'T EDIT THIS

--[[
    zrewards.config.defaultTheme - The default VGUI theme
]]
zrewards.config.defaultTheme = "Default"

--[[
    zrewards.config.defaultLanguage - The default language
]]
zrewards.config.defaultLanguage = "en"

--[[
    zrewards.config.disableReferrals - Disable referrals
]]
zrewards.config.disableReferrals = false

--[[
    zrewards.config.disablePopupMenu

    - Enables the popup menu on spawn
]]
zrewards.config.disablePopupMenu = false

--[[
    zrewards.config.disablePopupOnComplete

    - Disables the popup menu after a user has completed all methods
]]
zrewards.config.disablePopupOnComplete = true

--[[
    zrewards.config.communityName - Your community name
]]
zrewards.config.communityName = "Aystralia Network"

--[[
    zrewards.config.showCommunityName

    - Display your community name on the in-game menus/VGUI
]]
zrewards.config.showCommunityName = true

--[[
    zrewards.config.adminGroups

    - Admin groups allowed to use the admin menu
]]
zrewards.config.adminGroups = {"superadmin"}

--[[
    zrewards.config.hiscoresPlayerLimit
    
    - Maximum amount of players that will show on the (referral) hiscores menu
]]
zrewards.config.hiscoresPlayerLimit = 10

--[[
    zrewards.config.spawnRewardWaitTime

    - Amount of time rewards are attempted be rewarded when a player initialy spawns
        * It's not recommended to modify this
]]
zrewards.config.spawnRewardWaitTime = 15

--[[
    zrewards.config.notifications

    - Notification settings
]]
zrewards.config.notifications = {
    showGlobal = false,              -- Display the global reward message
    showDisclaimer = false,         -- Display a disclaimer when claiming methods; only used for discord
}

--[[
    zrewards.config.disabledMethods

    - Methods that are disabled
        * Set to true to disable
]]
zrewards.config.disabledMethods = {
    ["dailylogin"] = false,
    ["nametag"] = true,
    ["steamgroup"] = false,
    ["discordserver"] = false,
    ["discordboost"] = false,
}

--[[
    zrewards.config.rewards

    - Rewards for specific actions

    [INFORMATION/TUTORIAL]
    Template:
        zrewards.config.rewards["REWARD.TYPE.NAME"] = {
            Enabled = true,             -- Not required, but can set to false to disable
            Icon = "icon16/ruby.png",   -- The icon for this reward. Not required, set to false to disable.
            RewardFor = {
                ["discordserver"] = REWARD AMOUNT/VALUE, -- (can be false if you don't want this rewarded)
                ["discordboost"] = REWARD AMOUNT/VALUE,
                ["steamgroup"] = REWARD AMOUNT/VALUE,
                ["referral"] = REWARD AMOUNT/VALUE,
            },
        }

    Reward available types:
        - DarkRP:
            - DarkRP.Cash
        - Nutscript:
            - Nutscript.Money
        - PS1:
            - PS1.Points
        - PS2:
            - PS2.Points
            - PS2.PremiumPoints
        - gLevel:
            - gLevel.EXP
            - gLevel.Level
            - gLevel.Rank
            - gLevel.Points
            - gLevel.Keys
        - SH Pointshop:
            - SHPointshop.StandardPoints
            - SHPointshop.PremiumPoints
        - Underdone:
            - Underdone.Item
            - Underdone.XP
            - Underdone.Money
        - Bricks CreditStore
            - BricksCreditStore.Credits
        - Admin Mods:
            - Admin.Rank
        - General:
            - General.Weapon
        - ...More in the  zrewards/lua/zrewards/rewards/types/  folder

    RewardFor available types:
        - discordserver - for joining the discord server
        - discordboost - for boosting the discord server
        - steamgroup - for joining the steam group
        - referral - for a referral
        - dailylogin - for daily logins
        - nametag - for name tags
]]
zrewards.config.rewards["DarkRP.Cash"] = {
    Icon = "icon16/money.png",
    RewardFor = {
        ["discordserver"] = 10000,
        ["discordboost"] = 200000,
        ["steamgroup"] = 50000,
        ["referral"] = 10000,
        ["dailylogin"] = 25000,
        ["nametag"] = 1,
    },
}