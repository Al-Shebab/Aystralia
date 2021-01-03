--[[
    ZRewards - (SV) Config
    Developed by Zephruz
]]


--[[
    zrewards.config.mysqlInfo

    - Servers data info
    - If you're not using mysqloo set dbModule to "sqlite"
]]
zrewards.config.mysqlInfo = {
	dbModule = "sqlite", -- mysqloo or sqlite
    dbName = "garrysmod",
    dbHost = "localhost",
    dbUser = "root",
    dbPass = "",
}

--[[
    zrewards.config.steamApiKey

    - Your SteamAPI key from here: https://steamcommunity.com/dev/apikey
]]
zrewards.config.steamApiKey = "CB2CD369E7B7A8FD95DDD35D5ED94719"

--[[
    zrewards.config.methodsSettings

    - Settings for each method type
]]
zrewards.config.methodsSettings = {} -- DON'T EDIT THIS

--[[
    Daily Login

    [INSTRUCTIONS]
    -  No instructions
]]
zrewards.config.methodsSettings["dailylogin"] = {
    Enabled = true,
    VerifyOnSpawn = false,
}

--[[
    Name Tag

    [INSTRUCTIONS]
    - Set 'NameTag' to the tag you want a player to have in their name
        - You can optionally allow multiple nametags by making it a table
            * Example: NameTag = {"[ZS]", "(ZS)", "ZSERVER"},
    - IsPeriodic - Allows a player to claim a reward for this periodically when they have the tag in their name.
        - Interval - How frequent the player can claim this periodic reward (in seconds) (Default: 1 day / 86400 seconds)
]]
zrewards.config.methodsSettings["nametag"] = {
    Enabled = false,
    VerifyOnSpawn = false,
    IsPeriodic = false,
    Interval = 86400,
    NameTag = {"[SERVER]", "(SERVER)"},
    APIKey = zrewards.config.steamApiKey,
}

--[[
    Steam Group Method
    
    [INSTRUCTIONS]
    - Get your GroupID: https://steamcommunity.com/groups/YOUR_GROUP_NAME/edit 
        - Looks something like this: 33824579
        - Replace YOUR_GROUP_NAME with your groups URL handle

    - GroupLink: Just a link to your group the player can join at
        - Looks something like this: https://steamcommunity.com/groups/zephruz
]]
zrewards.config.methodsSettings["steamgroup"] = {
    Enabled = true,
    VerifyOnSpawn = false,
    APIKey = zrewards.config.steamApiKey,
    GroupID = "",
    GroupLink = "https://steamcommunity.com/groups/Aystralia",
}

--[[
    Discord Server Method

    [INSTRUCTIONS]
    Go here to learn how to get your GuildID: https://support.discordapp.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-
    Go here to make an application: https://discordapp.com/developers/applications/
    - Create an application, make it nice (name it, give it a picture, etc).
    - Copy your client ID & client secret - paste them below.
    - Bot Setup:
        * Click "Bot" on the left side of the screen & create your bot.
        * Set up your bot, make it nice too. Click the "Copy" button under the token section - paste it below.
    - OAuth2 Setup:
        * Click "OAuth2" on the left side of the screen
        * Click "Add Redirect" under the "Redirects" section
        * Enter this URL: https://zephruz.net/api/zrewards_discord
        * Make sure to save!
    - Invite your bot:
        * Use this link:
            * NOTE: Replace "CLIENTIDHERE" in the link with your bots client ID
            - https://discordapp.com/api/oauth2/authorize?client_id=CLIENTIDHERE&permissions=8&response_type=code&scope=bot
        * Navigate to the link and add the bot to your Discord server
    - You're done, have fun.
]]
zrewards.config.discordInfo = {
    GuildID = "775399964204990495",                               -- Your discord guild ID
    ClientID = "755792927891914812",                              -- Your discord application client ID
    ClientSecret = "5mfqZev_vkGlcIbtiB3koJz-VPvy5vXP",                          -- Your discord application client secret
    BotToken = "NzU1NzkyOTI3ODkxOTE0ODEy.X2IdAw.STHAvVoEejnCD7e-sxdXX9uScsA"                               -- Your discord bot token
}

zrewards.config.methodsSettings["discordserver"] = {
    Enabled = true,
    VerifyOnSpawn = false,
    
    -- Your discord invite link (given to players if they aren't in the guild)
    InviteLink = "https://discord.gg/hWN7zXtbQP",
}

zrewards.config.methodsSettings["discordboost"] = {
    Enabled = false,
    VerifyOnSpawn = false,

    -- Your discord boost role; MUST be a string (should be the role given to users who boost - to get a role ID: go to the edit roles page and right click the role -> "Copy ID")
    BoostRoleID = "",
}