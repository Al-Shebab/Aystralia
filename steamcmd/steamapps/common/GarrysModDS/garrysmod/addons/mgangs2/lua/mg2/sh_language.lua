--[[
    MGangs 2 - (SH) Language
    Developed by Zephruz
]]

mg2.lang = (mg2.lang or {})
mg2.lang._current = (mg2.lang._current or {})

--[[
	mg2.lang:Register(name [string])

	- Registers a language
]]
function mg2.lang:Register(name)
	local lang = {}

	zlib.object:SetMetatable("mg2.Language", lang)

	lang:SetName(name)

	local cache = zlib.cache:Get("mg2.Languages")

	if (cache) then
		cache:addEntry(lang, name)

		return cache:getEntry(name)
	end

	return lang
end

--[[
	mg2.lang:Get(name [string])

	- Returns a language
]]
function mg2.lang:Get(name)
	local cache = zlib.cache:Get("mg2.Languages")

	if !(cache) then return end

	return cache:getEntry(name)
end

--[[
	mg2.lang:SetCurrent(name [string])

	- Sets the currently used language
]]
function mg2.lang:SetCurrent(name)
	self._current = (self:Get(name) or self:Get("en"))
end

--[[
	mg2.lang:GetCurrent()

	- Gets the currently used language
]]
function mg2.lang:GetCurrent()
	return self._current
end

--[[
	mg2.lang:GetAll()

	- Returns all languages
]]
function mg2.lang:GetAll()
	local cache = zlib.cache:Get("mg2.Languages")

	if !(cache) then return end

	return cache:GetEntries()
end

--[[
	mg2.lang:GetTranslation(name [string], ...)

	- Pass the translation name as the first argument, as the rest you can use replacement values
	- Returns the translation with the current language
]]
function mg2.lang:GetTranslation(name, ...)
	local cur = self:GetCurrent()

	return (cur && cur:getTranslation(name, ...) || name)
end

--[[
	Language cache
]]
zlib.cache:Register("mg2.Languages")

--[[
	Language metastructure
]]

local langMtbl = zlib.object:Create("mg2.Language")

langMtbl:setData("Name", "LANG.NAME", {shouldSave = false})
langMtbl:setData("Translations", {}, {
	shouldSave = false,
	onSet = function(s,tname,oVal,tval)
		if (!tname or !tval) then return val end

		local oVal = (oVal or {})
		
		oVal[tname] = tval

		return oVal
	end,
	onGet = function(s,val,tname,...)
		if !(tname) then return val end

		local trans = (val[tname] or tname)

		return string.format(trans, ...)
	end
})

function langMtbl:addTranslation(name,val)
	self:SetTranslations(name, val)
end

function langMtbl:getTranslation(name, ...)
	return self:GetTranslations(name, ...)
end

--[[
	Load Languages
]]
-- Languages
local files, dirs = file.Find("mg2/languages/mg2_language_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "languages/")
end

-- Set current language
mg2.lang:SetCurrent(mg2.config.defaultLanguage or "en")