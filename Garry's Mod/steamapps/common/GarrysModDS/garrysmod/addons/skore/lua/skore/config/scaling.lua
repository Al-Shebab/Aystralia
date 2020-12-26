
/*###############################################
	Scaling Configuration File
###############################################*/

-- Should players be able to ajust their UI size?
--
-- If this setting is set to 'true', players might rescale their UI through the
-- rescaling menu.
sKore.config["allowScaleAjustment"] = true

-- How should the scaling console variable be named?
--
-- This setting defines the name of the scaling console variable. This has no
-- direct impact on the addon's behavior. You shouldn't need to change this
-- unless you have a special reason to.
--
-- WARNING: This setting cannot be a name of an already existing console command
-- or console variable. The addon will break silently if it is.
sKore.config["scaleConvar"] = "skore_scale"

-- What chat command(s) should open the rescaling menu?
--
-- This setting defines the chat command(s) that open the rescalling menu.
-- Obviously, this setting has no effect if scale ajustment is not enabled.
-- If you wish to disable the chat command(s) for this menu, leave the table
-- empty.
sKore.config["scaleAjustmentMenuChat"] = {
	"/scale", "!scale", "/scaling", "!scaling"
}

-- What console command(s) should open the rescaling menu?
--
-- This setting defines the console command(s) that open the rescaling menu.
-- Obviously, this setting has no effect if scale ajustment is not enabled.
-- If you wish to disable the console command(s) for this menu, leave the table
-- empty.
sKore.config["scaleAjustmentMenuConsole"] = {}

-- What should be the minimum rescale value?
--
-- This setting sets a hard bottom limit on the rescaling that the player is
-- allowed to do. You shouldn't change this unless you have a special reason to.
-- I strongly suggest not setting this lower than 0.5 (50%).
sKore.config["minimumScale"] = 0.66

-- What should be the maximum rescale value?
--
-- This setting sets a hard top limit on the rescaling that the player is
-- allowed to do. You shouldn't change this unless you have a special reason to.
-- NOTE: A value of 2 means that the player is allowed to rescale the UI to 200%
-- of it's original size.
sKore.config["maximumScale"] = 2



sKore.reloadScaling() -- Ignore this line.
