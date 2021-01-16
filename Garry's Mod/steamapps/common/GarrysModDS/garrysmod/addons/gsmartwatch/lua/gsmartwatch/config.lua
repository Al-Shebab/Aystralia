GSmartWatch.Cfg = {}

GSmartWatch.Cfg.Language = "en"                 -- Script language [ch, en, fr, ge, po, pt, ru, sp, tu]
GSmartWatch.Cfg.UseKey = KEY_G                  -- Default use key (full list here: https://wiki.facepunch.com/gmod/Enums/KEY)

GSmartWatch.Cfg.ViewModelLight = true           -- Set this to true if you want to apply light on the viewmodel
GSmartWatch.Cfg.ForceRealTime = false           -- Set this to true if you want to force real time usage (if StormFox is installed)

GSmartWatch.Cfg.CarFinderUpdateTime = 30        -- How many seconds before the car infos are updated (Car Finder app)
GSmartWatch.Cfg.CarKeyDistance = 1000           -- Max units between the player and the car to lock/unlock
GSmartWatch.Cfg.BootTime = 2                    -- Duration of startup animation (0 to disable)

GSmartWatch.Cfg.HideIncompatibilities = true   -- Set this to true to automatically disable apps that requires other script to be supported (will override GSmartWatch.Cfg.DisabledApps)
GSmartWatch.Cfg.DisabledApps = {                -- Set an app on true if you want to disable it
    [ "app_alarm" ] = false,
    [ "app_bank" ] = false,
    [ "app_calculator" ] = false,
    [ "app_carfinder" ] = false,
    [ "app_carkeys" ] = false,                  -- DarkRP needed - VCMod is only needed for lights (but is optionnal)
    [ "app_compass" ] = false,
    [ "app_fitness" ] = false,
    [ "app_health" ] = false,
    [ "app_maps" ] = true,
    [ "app_radio" ] = false,
    [ "app_services" ] = false,    
    [ "app_stockmarket" ] = false,              -- Required : Stock Market System
    [ "app_stopwatch" ] = true,
    [ "app_taxes" ] = false,                    -- Required : Slawer Mayor or DarkRP Mayor System
    [ "app_weather" ] = false,                  -- Required : StormFox
}

GSmartWatch.Cfg.BlacklistedTeams = {            -- List of teams to which you don't want to attach a smartwath (true to disable)
    [ "Hobo" ] = true,
}

GSmartWatch.Cfg.BlacklistedModels = {           -- List of playermodels to which you don't want to attach a smartwath (true to disable)
    [ "models/player/corpse1.mdl" ] = true,
    [ "models/zerochain/props_bloodlab/zbl_hazmat.mdl" ] = true,    
}

--[[ RADIOS ]]--

GSmartWatch.Cfg.RadioStations = {
    [ 1 ] = {
        name = "BBC Radio 1",                                                                       -- Station name
        url = "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1_mf_p",                           -- Audio stream URL
        image = "https://mytuner.global.ssl.fastly.net/media/tvos_radios/BFcU2vjUXh.png",           -- Station image URL
    },
    [ 2 ] = {
        name = "BBC Radio 2",
        url = "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio2_mf_p",
        image = "https://www.gretchenpeters.com/worldpetershellocruel/wp-content/uploads/2015/01/BBCR2-550x550.jpg",
    },
    [ 3 ] = {
        name = "BBC 1XTra",
        url = "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p",
        image = "https://www.internationalradiofestival.com/wp-content/uploads/2016/01/BBC-Radio-1Xtra.jpg"
    },
    [ 4 ] = {
        name = "Skyrock",
        url = "http://icecast.skyrock.net/s/natio_mp3_128k",
        image = "https://lh3.googleusercontent.com/dPiQ01OUKZVfRZUbbb-EVK5g9miS_K-xrxHgmBbynGG-GQ53yt3GzFKr0zUTnb-xswQ",
    },
    [ 5 ] = {
        name = "NRJ",
        url = "http://cdn.nrjaudio.fm/audio1/fr/30001/mp3_128.mp3?origine=fluxradios",
        image = "https://vignette.wikia.nocookie.net/logopedia/images/a/ae/NRJ_Hits_2017.svg.png/revision/latest?cb=20190621214935"
    },
    [ 6 ] = {
        name = "Fun Radio",
        url = "http://streaming.radio.funradio.fr/fun-1-44-128",
        image = "https://www.lalettre.pro/photo/art/grande/15883349-20947531.jpg"
    },
}

--[[ MINIMAP CONFIG ]]--
-- This is only specific to some maps, in most cases you should not have to add config for your map

GSmartWatch.Cfg.MapConfig = {
    [ "rp_southside" ] = {
        iZOffset = 300,
    },
    [ "rp_southside_day" ] = {
        iZOffset = 300,
    },
    [ "gm_construct" ] = {
        iZOffset = -5000,
        iZFar = 64000, 
    }
}

if SERVER then return end

-- Band colors
GSmartWatch.Cfg.Bands = {
    Color( 32, 32, 32 ),
    Color( 53, 59, 72 ),
    Color( 240, 240, 240 ),
    Color( 211, 84, 0 ),
    Color( 243, 156, 18 ),
    Color( 255, 255, 0 ),
    Color( 26, 188, 156 ),
    Color( 52, 152, 219 ),
    Color( 25, 42, 86 ),
    Color( 76, 209, 55 ),
    Color( 109, 33, 79 ),
    Color( 252, 66, 123 ),
    Color( 192, 57, 43 )
}

-- UI Colors
GSmartWatch.Cfg.Colors = {
    [ 0 ] = Color( 24, 25, 28 ),
    [ 1 ] = Color( 32, 34, 37 ),
    [ 2 ] = Color( 47, 49, 54 ),
    [ 3 ] = Color( 54, 57, 63 ),
    [ 4 ] = Color( 179, 183, 188 ),
    [ 5 ] = Color( 46, 204, 113 )
}