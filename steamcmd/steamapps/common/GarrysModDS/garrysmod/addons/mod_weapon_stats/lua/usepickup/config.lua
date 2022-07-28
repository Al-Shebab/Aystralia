local c = {}

c.Enable        = true
c.LoadGM        = "auto" -- "auto", "terrortown", "darkrp", "fallback"
                     -- IF YOUR GAMEMODE IS JUST DARKRP BUT RENAMED, SET IT TO "darkrp" (if it doesn't detect DarkRP by itself)

c.Language      = "english" -- english, german, russian

c.Range         = 125 -- 125 => perfect in my opinion
c.Halos         = true
c.AutoPickup    = true

c.ChatCommands = {
    "!usepickup",
    "/usepickup",
    ".usepickup"
}

c.Colors = {
    ["Base"]    = Color( 220, 220, 220 ), -- normal text
    ["UseKey"]  = Color( 200, 50, 50 ), -- [E]
    ["Alt"]     = Color( 140, 140, 140 ), -- "Hold [ALT][..]" text
    ["Shadow"]  = Color( 50, 50, 50 ), -- shadow

    ["Row_BG"]  = Color( 30, 30, 30, 200 ), -- blurry background color of each row
    ["Row_Bar"] = Color( 150, 150, 150),
    ["Good"]    = Color( 0, 150, 0 ),
    ["Bad"]     = Color( 175, 0, 0 ),
    ["Avg"]     = Color( 255, 215, 0 ),

    ["SettingsBG"] = Color( 25, 25, 25, 220 ),
    ["SettingsCloseButton"] = Color( 200, 35, 35 )
}
c.NameOverride = { -- if for some reason the name doesnt fit or is just fucked up
    ["weapon_zm_revolver"] = "Desert Eagle",
}
c.ColorOverride = { -- generates the weapons color by its ammotype (non ttt gamemodes) but you can override that here
    ["ammotype"] = Color( 200, 30, 30 ),
}

c.StatsBaseBlacklist = {
    "weapon_base",
    "weapon_tttbasegrenade"
}

c.StatsClassBlacklist = { -- if it doesnt detect those weapons itself (mostly equipment like t-items with 0 delay etc)
    "weapon_crowbar"
}

if CLIENT then
    -- play around
    -- I will add better names for the font later

    surface.CreateFont( "USEPICKUP.Standard", {
        font = "Coolvetica",
        extended = false,
        size = 24,
        weight = 0,
        antialias = true,
        shadow = false
    } )

    surface.CreateFont( "USEPICKUP.Highlighted", {
        font = "Coolvetica",
        extended = false,
        size = 24,
        weight = 0,
        antialias = true,
        shadow = false
    } )

    surface.CreateFont( "USEPICKUP.HoldAlt", {
        font = "Trebuchet MS",
        size = 21,
        weight = 1000,
        shadow = false,
        antialias = true,
    } )

    surface.CreateFont( "USEPICKUP.Stats.Standard", {
        font = "Coolvetica",
        extended = false,
        size = 24,
        weight = 0,
        antialias = true,
        shadow = false
    } )

    surface.CreateFont( "USEPICKUP.Stats.Highlighted", {
        font = "Coolvetica",
        extended = false,
        size = 26,
        weight = 1000,
        antialias = true,
        shadow = false
    } )

    surface.CreateFont( "USEPICKUP.Stats.Standard.Alt", {
        font = "Trebuchet MS",
        extended = false,
        size = 19,
        weight = 0,
        antialias = true,
        shadow = false
    } )
end

--                                                                                                                                                                                                                                                                                                                                                                                                   76561207038545733

USEPICKUP.Config = c