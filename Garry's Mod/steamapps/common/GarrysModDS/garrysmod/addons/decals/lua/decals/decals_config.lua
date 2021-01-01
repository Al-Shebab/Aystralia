-- Who is allowed to create and save decals
-- SteamIDs, SteamID64s and UserGroups supported
Decals.cfg.Allowed = {
    [ "STEAM_0:0:2316327" ] = true,
    [ "superadmin" ] = true,
}

-- Color for chat notifications and halos
Decals.cfg.Color = Color( 0, 178, 238 )

-- Render distance (distance at which the decal will disappear)
Decals.cfg.RenderDistance = 5000

-- Command to save decals (do not add ! or /)
Decals.cfg.ChatCommand = "savedecals"

-- Command to duplicate decals (do not add ! or /)
Decals.cfg.CopyCommand = "copydecal"

-- Command to remove the current decal (do not add ! or /)
Decals.cfg.RemoveCommand = "removedecal"

-- Command to clear all decals (do not add ! or /)
Decals.cfg.ClearCommand = "cleardecals"

-- Default image (what the decal is by default)
Decals.cfg.DefaultImage = "https://vignette.wikia.nocookie.net/tf2freakshow/images/3/36/GMod_Logo.png"
