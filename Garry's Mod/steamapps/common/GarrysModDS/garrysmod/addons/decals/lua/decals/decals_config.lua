-- Who is allowed to create and save decals
-- SteamIDs, SteamID64s and UserGroups supported
Decals.cfg.Allowed = {
    [ "superadmin" ] = true,
}

-- Color for chat notifications and halos
Decals.cfg.Color = Color( 0, 178, 238 )

-- Render distance (distance at which the decal will disappear)
Decals.cfg.RenderDistance = 5000

-- Command to save decals (do not add ! or /)
Decals.cfg.ChatCommand = "savegdecals"

-- Command to duplicate decals (do not add ! or /)
Decals.cfg.CopyCommand = "copygdecal"

-- Command to remove the current decal (do not add ! or /)
Decals.cfg.RemoveCommand = "removegdecal"

-- Command to clear all decals (do not add ! or /)
Decals.cfg.ClearCommand = "cleargdecals"

-- Default image (what the decal is by default)
Decals.cfg.DefaultImage = "https://cdn.discordapp.com/attachments/438737485560938496/793142174367481916/billboard.png"
