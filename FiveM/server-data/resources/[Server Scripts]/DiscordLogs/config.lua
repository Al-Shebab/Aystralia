Config = {}

Config.AllLogs = true											-- Enable/Disable All Logs Channel
Config.postal = true  											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "Aystralia Network" 							-- Bot Username
Config.communtiyName = "Aystralia Network ➞ Server Logs"					-- Icon top of the Embed


Config.weaponLog = true  			-- set to false to disable the shooting weapon logs
Config.weaponLogDelay = 500		-- delay to wait after someone fired a weapon to check again in ms (put to 0 to disable) Best to keep this at atleast 1000

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs


-- Change color of the default embeds here
-- It used Decimal color codes witch you can get and convert here: https://jokedevil.com/colorPicker
Config.joinColor = "3863105" 		-- Player Connecting
Config.leaveColor = "15874618"		-- Player Disconnected
Config.chatColor = "10592673"		-- Chat Message
Config.shootingColor = "10373"		-- Shooting a weapon
Config.deathColor = "000000"		-- Player Died
Config.resourceColor = "15461951"	-- Resource Stopped/Started



Config.webhooks = {
	all = "", 
	chat = "https://discordapp.com/api/webhooks/793098328819761192/MHQFVcUb9WHUywteUX_WVtpS7sjkpeno-ckh3A7Rf3YiKwqE5SAALGGs8KPQL7GjsSwV", 
	joins = "https://discordapp.com/api/webhooks/793098489261326357/ie9TeDRWPG5AEtZQUeqHQYE3vHM5xqCWKnKYEkDmtBu7S_-xbMIikhVgFLB8BUVDmn8p", 
	leaving = "https://discordapp.com/api/webhooks/793098489261326357/ie9TeDRWPG5AEtZQUeqHQYE3vHM5xqCWKnKYEkDmtBu7S_-xbMIikhVgFLB8BUVDmn8p", 
	deaths = "https://discordapp.com/api/webhooks/793098671155576832/tI29yrHxAsjG84P3Gl4LJRseQepYE5IyV2swv5_rIiz5sBPLhIwpdXbem7dNvifU9nF3",
	shooting = "https://discordapp.com/api/webhooks/793098671155576832/tI29yrHxAsjG84P3Gl4LJRseQepYE5IyV2swv5_rIiz5sBPLhIwpdXbem7dNvifU9nF3", 
	resources = "https://discordapp.com/api/webhooks/793098771503775775/qB4_IzU-lITyRmCR5PWatZsIp9dxfJuCilEBW7f2aaGXwS_BOIEttf_JbzVIGR4Aud5C",

  -- How you add more logs is explained on https://docs.jokedevil.com/JD_logs
  }


 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.1.0"
