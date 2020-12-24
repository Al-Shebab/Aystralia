zfs = zfs || {}
zfs.f = zfs.f || {}

local IgnoreFileTable = {}
local function NicePrint(txt)
	if SERVER then
		MsgC(Color(236, 73, 211), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

function zfs.f.PreLoadFile(fdir,afile,info)
	IgnoreFileTable[afile] = true
	zfs.f.LoadFile(fdir,afile,info)
end

function zfs.f.LoadFile(fdir,afile,info)

	if info then
		local nfo = "// [ Initialize ]: " .. afile .. string.rep( " ", 25 - afile:len() ) .. "//"
		NicePrint(nfo)
	end

	if SERVER then
		AddCSLuaFile(fdir .. afile)
	end

	include(fdir .. afile)
end

function zfs.f.LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") and not IgnoreFileTable[afile] then
			zfs.f.LoadFile(fdir,afile,true)
		end
	end

	for _, dir in ipairs(dirs) do
		zfs.f.LoadAllFiles(fdir .. dir .. "/")
	end
end

// Initializes the Script
function zfs.f.Initialize()
	NicePrint(" ")
	NicePrint("//////////////////////////////////////////////")
	NicePrint("//////////// Zeros Fruitslicer ///////////////")
	NicePrint("//////////////////////////////////////////////")

	zfs.f.PreLoadFile("","zfs_config_main.lua",true)
	zfs.f.PreLoadFile("","zfs_config_smoothies.lua",true)
	zfs.f.PreLoadFile("","zfs_config_toppings.lua",true)

	zfs.f.LoadAllFiles("zfs_languages/")

	zfs.f.LoadAllFiles("zfruitslicer/sh/")
	if SERVER then
		zfs.f.LoadAllFiles("zfruitslicer/sv/")
	end
	zfs.f.LoadAllFiles("zfruitslicer/cl/")



	NicePrint("//////////////////////////////////////////////")
	NicePrint("//////////////////////////////////////////////")
end

if SERVER then
	hook.Add("PostGamemodeLoaded", "a_zfs_Initialize_sv", function()
		zfs.f.Initialize()
	end)
else

	hook.Add("InitPostEntity", "a_zfs_Initialize_cl", function()
		zfs.f.Initialize()
	end)
end


if GAMEMODE then
	zfs.f.Initialize()
end
