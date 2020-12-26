
function sKore.isValidLanguageName(name)
	return isstring(name) and sKore.languages[name:lower()] != nil
end

function sKore.getLanguageTable(name)
	if !sKore.isValidLanguageName(name) then error("'name' argument is not a valid language name!", 2) end
	return sKore.languages[name:lower()]
end

function sKore.getDefaultLanguageName()
	return SERVER and sKore.config["serverLanguage"]:lower()
		   or sKore.config["defaultLanguage"]:lower()
end

function sKore.getActiveLanguageName()
	return CLIENT and sKore.config["allowLanguageSelection"]
		   and sKore.languageConvar:GetString():lower()
		   or sKore.getDefaultLanguageName()
end
sKore.getActiveLanguage = sKore.getActiveLanguageName

function sKore.getActiveLanguageTable()
	return sKore.getLanguageTable(sKore.getActiveLanguageName())
end

function sKore.getPhrase(phrase, ...)
	if isstring(phrase) and string.StartWith(phrase, "#") then
		local placeholder = string.sub(phrase, 2):lower()
		local fulltext = sKore.getActiveLanguageTable()[placeholder]
						 or sKore.getLanguageTable("english")[placeholder]
						 or phrase
		local formatParameters = {...}
		return #formatParameters == 0 and fulltext
			   or string.format(fulltext, unpack(formatParameters))
	end
	return phrase
end

function sKore.addPhrase(langname, placeholder, fulltext)
	if !isstring(langname) then error("'langname' argument is not a string!", 2) end
	if string.Trim(langname) == "" then error("'langname' argument is either an empty string or just whitespace!", 2) end
	if !isstring(placeholder) then error("'placeholder' argument is not a string!", 2) end
	if string.Trim(placeholder) == "" then error("'placeholder' argument is either an empty string or just whitespace!", 2) end
	if !isstring(fulltext) then error("'fulltext' argument is not a string!", 2) end

	langname = langname:lower()
	sKore.languages[langname] = sKore.languages[langname] or {}
	sKore.languages[langname][placeholder:lower()] = fulltext
end

function sKore.updateLanguageConvar()
	if SERVER then return end
	if sKore.languageConvar != nil then
		sKore.languageConvar:SetString(sKore.languageConvar:GetString())
		return
	end

	local languages = table.GetKeys(sKore.languages)
	local help = "sKore's language console variable. Available languages: '%s'."
	help = #languages > 1
		   and string.format(help, table.concat(languages, "', '", 1, #languages - 1) .. "' and '" .. languages[#languages])
		   or string.format(help, languages[#languages])

	sKore.languageConvar = CreateClientConVar(sKore.config["languageConvar"], sKore.getDefaultLanguageName(), false, false, help)
	cvars.RemoveChangeCallback(sKore.config["languageConvar"], "sKoreLanguageCallback")
	cvars.AddChangeCallback(sKore.config["languageConvar"], function(convar, oldValue, newValue)
		if !sKore.config["allowLanguageSelection"] then return end
		if !sKore.isValidLanguageName(newValue) then
			sKore.languageConvar:SetString(sKore.isValidLanguageName(oldValue) and oldValue or sKore.getDefaultLanguageName())
		else
			if newValue == oldValue then return end
			sKore.fileTable["language"] = newValue:lower()
			file.Write(sKore.filePath, util.TableToJSON(sKore.fileTable))
			hook.Run("sKoreLanguageUpdated")
		end
	end, "sKoreLanguageCallback")

	sKore.languageConvar:SetString(sKore.fileTable["language"] or sKore.getDefaultLanguageName())
end

function sKore.loadLanguageDirectories(path)
	if !isstring(path) then error("'path' argument is not a string!", 2) end
	path = sKore.cleanDirectory(path)

	local _, subdirectories = file.Find(path .. "/*", "LUA")
	if table.RemoveByValue(subdirectories, "language") != false then sKore.includeDirectory(path .. "/language", true) end
	for _, subdirectory in ipairs(subdirectories) do
		sKore.loadLanguageDirectories(path .. "/" .. subdirectory)
	end
end

function sKore.testLanguageConfig()
	local fileName = "skore/config/language.lua"
	if SERVER then
		sKore.config["allowLanguageSelection"] = nil
		sKore.config["languageSelectionMenuChat"] = nil
		sKore.config["languageSelectionMenuConsole"] = nil
		sKore.config["languageConvar"] = nil
		sKore.config["defaultLanguage"] = nil
		sKore.config["promptLanguageSelection"] = nil

		assert(sKore.isValidLanguageName(sKore.config["serverLanguage"]), Format("The '%s' setting on '%s' is not a valid language name!", "serverLanguage", fileName))
	else
		sKore.config["serverLanguage"] = nil
		assert(isbool(sKore.config["allowLanguageSelection"]), Format("The '%s' setting on '%s' is not a boolean!", "allowLanguageSelection", fileName))

		assert(istable(sKore.config["languageSelectionMenuChat"]), Format("The '%s' setting on '%s' is not a table!", "languageSelectionMenuChat", fileName))
		assert(table.IsSequential(sKore.config["languageSelectionMenuChat"]), Format("The '%s' setting on '%s' is not a sequential table!", "languageSelectionMenuChat", fileName))
		local optimizedTable = {}
		for key, value in pairs(sKore.config["languageSelectionMenuChat"]) do
			assert(isstring(value), Format("The key #%s of the '%s' setting on '%s' is not a string!", key, "languageSelectionMenuChat", fileName))
			assert(string.Trim(value) != "", Format("The key #%s of the '%s' setting on '%s' is either an empty string or just whitespace!", key, "languageSelectionMenuChat", fileName))
			optimizedTable[value:lower()] = true
		end
		sKore.config["languageSelectionMenuChat"] = optimizedTable

		assert(istable(sKore.config["languageSelectionMenuConsole"]), Format("The '%s' setting on '%s' is not a table!", "languageSelectionMenuConsole", fileName))
		assert(table.IsSequential(sKore.config["languageSelectionMenuConsole"]), Format("The '%s' setting on '%s' is not a sequential table!", "languageSelectionMenuConsole", fileName))
		for key, value in pairs(sKore.config["languageSelectionMenuConsole"]) do
			assert(isstring(value), Format("The key #%s of the '%s' setting on '%s' is not a string!", key, "languageSelectionMenuConsole", fileName))
			assert(string.Trim(value) != "", Format("The key #%s of the '%s' setting on '%s' is either an empty string or just whitespace!", key, "languageSelectionMenuConsole", fileName))
		end

		assert(isstring(sKore.config["languageConvar"]), Format("The '%s' setting on '%s' is not a string!", "languageConvar", fileName))
		assert(string.Trim(sKore.config["languageConvar"]) != "", Format("The '%s' setting on '%s' is either an empty string or just whitespace!", "languageConvar", fileName))

		assert(sKore.isValidLanguageName(sKore.config["defaultLanguage"]), Format("The '%s' setting on '%s' is not a valid language name!", "defaultLanguage", fileName))

		assert(isbool(sKore.config["promptLanguageSelection"]), Format("The '%s' setting on '%s' is not a boolean!", "promptLanguageSelection", fileName))
	end
end

function sKore.loadLanguage()
	if sKore.loadingLanguage then return end
	sKore.loadingLanguage = true
	sKore.languages = {["english"] = {}}
	include("skore/config/language.lua")
	sKore.loadLanguageDirectories("skore")
	sKore.updateLanguageConvar()
	sKore.testLanguageConfig()
	sKore.loadingLanguage = nil
end

function sKore.reloadLanguage()
	if sKore.loadingLanguage then return end
	sKore.loadLanguage()
	hook.Run("sKoreLanguageReloaded")
end

sKore.loadLanguage()
