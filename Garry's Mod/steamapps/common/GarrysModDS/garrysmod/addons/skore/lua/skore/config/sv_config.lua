
/*###############################################
	Server Configuration File
###############################################*/

-- NOTE: All of the settings below require a server restart to take effect.

-- Whether resources (such as icons) should be downloaded through the server,
-- through the workshop or through FastDL.
--
-- If you're using FastDL in your server you should set both of the settings
-- below to false.
--
-- DEVELOPER TIP: You should avoid using FastDL and download stuff directly from
-- workshop whenever possible. Players with slower hard drives (a significant
-- amount) will load WAY FASTER if your server content is downloaded through the
-- workshop than if it is through FastDL.
sKore.config["downloadFiles"] = false -- Download directly through the server?
sKore.config["downloadWorkshop"] = true -- Download from the workshop?

-- The workshop id for the materials (and other resources).
-- Do not change this unless you know what you're doing!
sKore.config["workshopID"] = "1547209598"
