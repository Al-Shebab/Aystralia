/*---------------------------------------------------------------------------
	Metatable
---------------------------------------------------------------------------*/
local attachmentMeta = {}
attachmentMeta.__index = attachmentMeta


/*---------------------------------------------------------------------------
	Sets the attachment's URL
---------------------------------------------------------------------------*/
function attachmentMeta.SetURL(self, url)
	assert(isstring(url), "Attachment URLs must be strings.")
	self.url = url
end

function attachmentMeta.SetFilename(self, filename)
	assert(isstring(filename), "Attachment filenames must be strings.")
	self.filename = filename
end


/*---------------------------------------------------------------------------
	Constructor
---------------------------------------------------------------------------*/
function TDW.Attachment(url, filename)
	return setmetatable({
		url = url,
		filename = filename
	}, attachmentMeta)
end