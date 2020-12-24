/*---------------------------------------------------------------------------
	Metatable
---------------------------------------------------------------------------*/
local embedMeta = {}
embedMeta.__index = embedMeta


/*---------------------------------------------------------------------------
	Setting the embed's title
---------------------------------------------------------------------------*/
function embedMeta.SetTitle(self, title)
	assert(isstring(title), "Embed titles must be strings.")
	assert(title:len() <= 256, "Embed titles cannot be longer than 256 characters.")

	self.title = title
end


/*---------------------------------------------------------------------------
	Setting the embed's description
---------------------------------------------------------------------------*/
function embedMeta.SetDescription(self, description)
	assert(isstring(description), "Embed descriptions must be strings.")
	assert(description:len() <= 2048, "Embed descriptions cannot be longer than 256 characters.")

	self.description = description
end


/*---------------------------------------------------------------------------
	Setting a clickable title URL
---------------------------------------------------------------------------*/
function embedMeta.SetURL(self, url)
	assert(isstring(url), "Embed URLs must be strings.")
	self.url = url
end

local function leftPad(s)
	s = tostring(s)
	return string.rep("0", 2 - #s)..s
end

//because os.date is gay
local function formatTimestamp(time)
	local tbl = os.date("!*t", time)
	return tbl.year.."-"..tbl.month.."-"..tbl.day.."T"..leftPad(tbl.hour)..":"..leftPad(tbl.min)..":"..leftPad(tbl.sec).."Z"
end

/*---------------------------------------------------------------------------
	Sets a timestamp on the embed, either the current time or from a table.
	Uses https://wiki.garrysmod.com/page/Structures/DateData
---------------------------------------------------------------------------*/
function embedMeta.SetTimestamp(self, time)
	if(time != nil) then assert(istable(time), "If provided, Embed timestamps must be a DateData structure.") end
	self.timestamp = istable(time) && formatTimestamp(os.time(time)) || formatTimestamp()
end


/*---------------------------------------------------------------------------
	Sets the embed's color. Takes a hex number or a Gmod color object
---------------------------------------------------------------------------*/
function embedMeta.SetColor(self, color)
	color = isstring(color) && (TDW.Config.RandomEmbedColors && ColorRand() || TDW.Config.EmbedColors[color]) || color

	if(IsColor(color)) then
		self.color = (bit.lshift(color.r, 16)) + (bit.lshift(color.g, 8)) + color.b
	else
		self.color = color
	end
end

function embedMeta.SetFooter(self, text, iconUrl)
	assert(isstring(text), "Embed footer text must be strings.")
	assert(text:len() <= 2048, "Embed footer text cannot be longer than 256 characters.")

	self.footer = {text = text, icon_url = iconUrl}
end

function embedMeta.SetImage(self, url)
	assert(isstring(url), "Embed Image URLs must be strings.")
	self.image = {url = url}
end

function embedMeta.SetThumbnail(self, url)
	assert(isstring(url), "Embed Thumbnail URLs must be strings.")
	self.thumbnail = {url = url}
end

function embedMeta.SetAuthor(self, name, iconUrl, url)
	assert(isstring(name), "Embed author names must be strings.")
	assert(name:len() <= 256, "Embed author names cannot have more than 256 characters")

	self.author = {name = name, icon_url = iconUrl, url = url}
end


/*---------------------------------------------------------------------------
	Function for adding a field
---------------------------------------------------------------------------*/
function embedMeta.AddField(self, name, value, inline)
	name = tostring(name)
	value = tostring(value)

	assert(#self.fields <= 25, "You cannot have more than 25 fields in a RichEmbed.")
	assert(isstring(name), "Embed field names must be strings.")
	assert(name:len() <= 256, "Embed field names cannot have more than 256 characters")
	assert(isstring(value), "Embed field values must be strings.")
	assert(value:len() <= 2048, "Embed field values cannot have more than 2048 characters.")

	table.insert(self.fields, {
		name = name,
		value = value,
		inline = inline
	})
end


/*---------------------------------------------------------------------------
	Constructor
---------------------------------------------------------------------------*/
function TDW.RichEmbed()
	return setmetatable({
		type = "rich",
		fields = {}
	}, embedMeta)
end