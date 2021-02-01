-- List of car models in which carradio is disabled
wyozicr.DisabledModels = {
	"path/to/carmodel.mdl"
}

-- Whether we should override stations below with Wyozi Home Kit: Media Pack stations, if they exist
wyozicr.UseHomeKitStations = true

-- List of stations. See below for instructions
wyozicr.Stations = {
	{
		Name = "Future House",
		Link = "http://uk2.internet-radio.com:8024/listen.pls&t=.pls"
	},
	{
		Name = "Psytrance",
		Link = "http://radio.psymusic.co.uk:8040/radio1_64k_aac.mp3.m3u&t=.pls"
	},
	{
		Name = "Hardstyle",
		Link = "http://uk5.internet-radio.com:8270/listen.pls&t=.pls"
	},
	{
		Name = "Rap",
		Link = "http://us3.internet-radio.com:8313/listen.pls&t=.pls"
	},
	{
		Name = "Classical",
		Link = "http://us3.internet-radio.com:8313/listen.pls&t=.pls"
	},
	{
		Name = "Top 40",
		Link = "http://uk2.internet-radio.com:8024/listen.pls&t=.pls"
	},
}

-- You can use following resources for more stations:

-- https://www.internet-radio.com/
-- To get a link that works for carradio rightclick the "PLS" button and copy the link location.
-- The link you have should look something like this "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us1.internet-radio.com:8180/listen.pls&t=.pls"
-- Now, remove everything before ?u= and after &t= so that the link looks like this: "http://us1.internet-radio.com:8180/listen.pls"
-- This is a link you can use with carradio

-- If you have your own .pls or .m3u links, they should also work directly with carradio.
