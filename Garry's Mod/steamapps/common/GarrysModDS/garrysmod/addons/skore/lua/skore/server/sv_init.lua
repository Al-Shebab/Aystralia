
local IGNORE_DIRECTORIES = {["server"] = true}
local IGNORE_PREFIXES = {"sv_"}

function sKore.AddCSLuaDirectory(path)
	if !isstring(path) then error("'path' argument is not a string!", 2) end
	path = sKore.cleanDirectory(path)

	local files = file.Find(path .. "/*.lua", "LUA")
	if files == nil then error("'path' argument is an invalid path!", 2) end
	for _, fileName in ipairs(files) do
		local ignore = false
		for _, prefix in ipairs(IGNORE_PREFIXES) do
			if string.StartWith(fileName, prefix) then
				ignore = true
				break
			end
		end
		if !ignore then AddCSLuaFile(path .. "/" .. fileName) end
	end

	local _, subdirectories = file.Find(path .. "/*", "LUA")
	for _, subdirectory in ipairs(subdirectories) do
		if IGNORE_DIRECTORIES[subdirectory:lower()] then continue end
		sKore.AddCSLuaDirectory(path .. "/" .. subdirectory)
	end
end

function sKore.resourceAddDirectory(path)
	if !isstring(path) then error("'path' argument is not a string!", 2) end
	path = sKore.cleanDirectory(path)

	local files, subdirectories = file.Find(path .. "/*", "GAME")
	for _, fileName in ipairs(files) do resource.AddSingleFile(path .. "/" .. fileName) end
	for _, subdirectory in ipairs(subdirectories) do sKore.resourceAddDirectory(path .. "/" .. subdirectory) end
end

local fileName = "skore/config/sv_config.lua"
assert(isbool(sKore.config["downloadFiles"]), Format("The '%s' setting on '%s' is not a boolean!", "downloadFiles", fileName))
assert(isbool(sKore.config["downloadWorkshop"]), Format("The '%s' setting on '%s' is not a boolean!", "downloadWorkshop", fileName))
assert(isstring(sKore.config["workshopID"]), Format("The '%s' setting on '%s' is not a string!", "workshopID", fileName))

if sKore.config["downloadWorkshop"] then
	resource.AddWorkshop(sKore.config["workshopID"])
elseif sKore.config["downloadFiles"] then
	sKore.resourceAddDirectory("skore")
end

sKore.AddCSLuaDirectory("skore")
