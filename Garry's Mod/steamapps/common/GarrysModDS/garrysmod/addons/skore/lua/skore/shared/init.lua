
sKore = {["config"] = {}}

local IGNORE_DIRECTORIES =  SERVER and {["language"] = true, ["client"] = true, ["vgui"] = true} or {["language"] = true, ["server"] = true}
local INCLUDE_EVERYTHING = SERVER and {} or {["vgui"] = true}
local DIRECTORY_PRIORITY = {"config", "shared", "server", "client", "vgui"}
local LAST_DIRECTORIES = {"modules"}
local INCLUDE_PREFIXES = SERVER and {"sh_", "sv_"} or {"sh_", "cl_"}
local FILE_PRIORITY = SERVER and {"sh_init.lua", "sv_init.lua"} or {"sh_init.lua", "cl_init.lua"}
local LAST_FILES = SERVER and {"sh_final.lua", "sv_final.lua"} or {"sh_final.lua", "cl_final.lua"}

function sKore.cleanDirectory(...)
	local dirtyPath = {...}
	for key, value in ipairs(dirtyPath) do
		if !isstring(value) then error("Argument #" .. key .. " is not a string!", 2) end
	end
	local directories = string.Explode("/", string.Replace(table.concat(dirtyPath, "/"), "\\", "/"))
	local cleanPath = {}
	for _, directory in ipairs(directories) do
		directory = string.Trim(directory)
		if directory != "" then table.insert(cleanPath, directory) end
	end
	return table.concat(cleanPath, "/")
end
sKore.cleanPath = sKore.cleanDirectory

function sKore.includeDirectory(path, recursively)
	if !isstring(path) then error("'path' argument is not a string!", 2) end
	path = sKore.cleanDirectory(path)
	recursively = recursively or false
	if !isbool(recursively) then error("'recursively' argument is not a boolean!", 2) end

	local files = file.Find(path .. "/*.lua", "LUA")
	if files == nil then error("'path' argument is an invalid path!", 2) end
	for _, fileName in ipairs(files) do include(path .. "/" .. fileName) end

	if !recursively then return end

	local _, subdirectories = file.Find(path .. "/*", "LUA")
	for _, subdirectory in ipairs(subdirectories) do
		if IGNORE_DIRECTORIES[subdirectory:lower()] then continue end
		sKore.includeDirectory(path .. "/" .. subdirectory, true)
	end
end

function sKore.loadDirectory(path)
	if !isstring(path) then error("'path' argument is not a string!", 2) end
	path = sKore.cleanDirectory(path)

	local files = file.Find(path .. "/*.lua", "LUA")
	if files == nil then error("'path' argument is an invalid path!", 2) end
	local filesLowered = table.Copy(files)
	for key, value in ipairs(filesLowered) do filesLowered[key] = value:lower() end

	for _, priorityFileName in ipairs(FILE_PRIORITY) do
		local key = table.RemoveByValue(filesLowered, priorityFileName)
		if key != false then
			include(path .. "/" .. files[key])
			table.remove(files, key)
		end
	end

	local includeLast = {}
	for _, lastFileName in ipairs(LAST_FILES) do
		local key = table.RemoveByValue(filesLowered, lastFileName)
		if key != false then
			table.insert(includeLast, files[key])
			table.remove(files, key)
		end
	end

	for _, fileName in ipairs(files) do
		local fileNameLower = string.lower(fileName)
		for _, prefix in ipairs(INCLUDE_PREFIXES) do
			if string.StartWith(fileNameLower, prefix) then
				include(path .. "/" .. fileName)
				break
			end
		end
	end

	for _, fileName in ipairs(includeLast) do include(path .. "/" .. fileName) end

	local _, subdirectories = file.Find(path .. "/*", "LUA")
	local subdirectoriesLowered = table.Copy(subdirectories)
	for key, value in ipairs(subdirectoriesLowered) do subdirectoriesLowered[key] = value:lower() end

	for _, prioritySubdirectory in ipairs(DIRECTORY_PRIORITY) do
		local key = table.RemoveByValue(subdirectoriesLowered, prioritySubdirectory)
		if key != false then
			if IGNORE_DIRECTORIES[prioritySubdirectory] then continue end
			if INCLUDE_EVERYTHING[prioritySubdirectory] then
				sKore.includeDirectory(path .. "/" .. subdirectories[key], true)
			else
				sKore.loadDirectory(path .. "/" .. subdirectories[key])
			end
			table.remove(subdirectories, key)
		end
	end

	local loadLast = {}
	for _, lastSubdirectory in ipairs(LAST_DIRECTORIES) do
		local key = table.RemoveByValue(subdirectoriesLowered, lastSubdirectory)
		if key != false then
			table.insert(loadLast, subdirectories[key])
			table.remove(subdirectories, key)
		end
	end

	for _, subdirectory in ipairs(subdirectories) do
		local loweredSubdirectory = subdirectory:lower()
		if IGNORE_DIRECTORIES[loweredSubdirectory] then continue end
		if INCLUDE_EVERYTHING[loweredSubdirectory] then
			sKore.includeDirectory(path .. "/" .. subdirectory, true)
		else
			sKore.loadDirectory(path .. "/" .. subdirectory)
		end
	end

	for _, subdirectory in ipairs(loadLast) do
		local loweredSubdirectory = subdirectory:lower()
		if IGNORE_DIRECTORIES[loweredSubdirectory] then continue end
		if INCLUDE_EVERYTHING[loweredSubdirectory] then
			sKore.includeDirectory(path .. "/" .. subdirectory, true)
		else
			sKore.loadDirectory(path .. "/" .. subdirectory)
		end
	end
end

if CLIENT then
	if file.Exists("skore", "DATA") then
		if !file.IsDir("skore", "DATA") then
			file.Delete("skore")
			file.CreateDir("skore")
		end
	else
		file.CreateDir("skore")
	end

	sKore.filePath = "skore/" .. string.gsub(game.GetIPAddress(), "[%.:]", {["."] = "_", [":"] = "__"}) .. ".txt"
	sKore.fileTable = util.JSONToTable(file.Read(sKore.filePath) or "") or {}
end

include("skore/shared/language.lua")
sKore.loadDirectory("skore")
