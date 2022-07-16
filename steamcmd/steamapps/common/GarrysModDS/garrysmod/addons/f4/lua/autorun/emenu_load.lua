-- Nothing should be changed here!!!
-- Nothing should be changed here!!! 
-- Nothing should be changed here!!! 

-- All configuration files are located in the folder:
-- emenu/lua/emenu/config
-- CONTENT: https://steamcommunity.com/sharedfiles/filedetails/?id=2580871422

--WORKSHOP CONTENT
if ( SERVER ) then
	resource.AddWorkshop( "2580871422" )
end


emenu = emenu or {}
emenu.loader = {}


-----------------
/// MATERIALS ///
-----------------
emenu.Materials = {
    ["person"]      = Material("materials/emenu/tabs/person.png","smooth"),
    ["shop"]        = Material("materials/emenu/tabs/shop.png","smooth"),
    ["unknown"]     = Material("materials/emenu/tabs/question.png","smooth"),
    ["discord"]		= Material("materials/emenu/tabs/discord.png","smooth"),
    ["steam"]		= Material("materials/emenu/tabs/steam.png","smooth"),

    ["like"]        = Material("materials/emenu/buttons/like.png","smooth"),
    ["like_filled"] = Material("materials/emenu/buttons/likefilled.png","smooth"),
    ["next"]        = Material("materials/emenu/buttons/next.png","smooth"),
    ["close"]       = Material("materials/emenu/buttons/close.png","smooth"),
    ["show"]        = Material("materials/emenu/buttons/show.png","smooth"),
    ["hide"]        = Material("materials/emenu/buttons/hide.png","smooth"),
    ["pin"]         = Material("materials/emenu/buttons/pin.png","smooth"),

    ["gradient"]    = Material("materials/emenu/gradient.png","smooth"),
    ["circle"]      = Material("materials/emenu/circle.png","smooth"),
    ["tr_texture"]  = Material("materials/emenu/tr_texture.png","smooth"),
}



------------------------
/// LOADER FUNCTIONS ///
------------------------
local epath = "emenu/" 

if (SERVER) then
print([[
 ______ __  __ ______ _   _ _    _ 
|  ____|  \/  |  ____| \ | | |  | |
| |__  | \  / | |__  |  \| | |  | |
|  __| | |\/| |  __| | . ` | |  | |
| |____| |  | | |____| |\  | |__| |
|______|_|  |_|______|_| \_|\____/ ]])
print("_____________________________________\n")
end

function emenu.loader:IncludeClient(path)
	if (CLIENT) then
		include(epath .. path)
	end

	if (SERVER) then
		AddCSLuaFile(epath .. path)
		print("• ".. epath .. path)
	end
end

function emenu.loader:IncludeServer(path)
	if (SERVER) then
		include(epath .. path)
		print("• ".. epath .. path)
	end
end

function emenu.loader:IncludeShared(path)
	self:IncludeServer(path)
	self:IncludeClient(path)
	if (SERVER) then print("• ".. epath .. path ) end
end

function emenu.loader:ResourceAddFile(path)
	if (SERVER) then
		resource.AddFile(path)
		print("• Resource added: ".. path)
	end
end

function emenu.loader:ResourceAddFolder(name, recurse)
    local files, folders = file.Find(name .."/*", "GAME")

    for _, fname in ipairs(files) do
        self:ResourceAddFile(name .."/".. fname)
    end

    if recurse then
        for _, fname in ipairs(folders) do
            emenu.loader:ResourceAddFolder(name .."/".. fname, recurse)
        end
    end
end

function emenu.loader:MaterialAddFolder(name, recurse)
    local files, folders = file.Find(name .."/*", "GAME")

    for _, fname in ipairs(files) do
        self:ResourceAddFile(name .."/".. fname)
        emenu.Materials[fname] = name .."/".. fname
    end

    if recurse then
        for _, fname in ipairs(folders) do
            emenu.loader:MaterialAddFolder(name .."/".. fname, recurse)
        end
    end
end

function emenu.loader:ClAddFolder(name,recurse)
	local files, folders = file.Find(epath .. name .. "/*", "LUA")
	for k, fname in ipairs(files) do
		local path = name.."/"..fname
		self:IncludeClient(path)
	end
	if recurse then
		for _, fname in ipairs(folders) do
            self:ClAddFolder(name .."/".. fname, recurse)
        end
    end
end

function emenu.loader:SvAddFolder(name,recurse)
	local files, folders = file.Find(epath .. name .. "/*", "LUA")
	for k, fname in ipairs(files) do
		local path = name.."/"..fname
		self:IncludeServer(path)
	end
	if recurse then
		for _, fname in ipairs(folders) do
            self:SvAddFolder(name .."/".. fname, recurse)
        end
    end
end

function emenu.loader:ShAddFolder(name,recurse)
	local files, folders = file.Find(epath .. name .. "/*", "LUA")
	for k, fname in ipairs(files) do
		local path = name.."/"..fname
		self:IncludeShared(path)
	end
	if recurse then
		for _, fname in ipairs(folders) do
            self:ShAddFolder(name .."/".. fname, recurse)
        end
    end
end



-----------------
/// MAIN LOAD ///
-----------------
-- Adds all fonts to server load
emenu.loader:ResourceAddFile("resource/fonts/amsterdam.ttf")

-- emenu.loader:MaterialAddFolder("materials/emenu",true) -- if you want use standart icons download

-- CREATE CONFIGS
if (CLIENT) then
	if not file.Exists("emenu", "DATA") then
		file.CreateDir("emenu")
	end
end

-- MAIN LOAD FUNCTION
function emenu.loader:Load()
	emenu.loader.finished = false

	self:IncludeClient("config/econfig.lua")
	self:IncludeClient("config/elangs.lua")
	self:IncludeClient("core/eutils.lua")
	self:IncludeClient("core/efonts.lua")

	self:IncludeServer("core/eserver.lua")
	
	--All vgui elements
	self:ClAddFolder("vgui",true)

	--Main files
	self:IncludeClient("core/ewinmanager.lua")
	self:IncludeClient("core/emenu.lua")

	--Windows
	self:ClAddFolder("core/tabs",true)

	if (SERVER) then
		print("\nLOADING FINISHED")
		print("_____________________________________")
	end

	emenu.loader.finished = true
end

emenu.loader:Load()