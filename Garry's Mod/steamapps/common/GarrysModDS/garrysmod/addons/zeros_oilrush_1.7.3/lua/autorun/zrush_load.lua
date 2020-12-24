zrush = zrush or {}
zrush.f = zrush.f or {}

local function NicePrint(txt)
	if SERVER then
		MsgC(Color(237, 82, 65), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local IgnoreFileTable = {}
function zrush.f.PreLoadFile(fdir,afile,info)
	IgnoreFileTable[afile] = true
	zrush.f.LoadFile(fdir,afile,info)
end

function zrush.f.LoadFile(fdir,afile,info)

	if info then
		local nfo = "// [ Initialize ]: " .. afile .. string.rep( " ", 30 - afile:len() ) .. "//"
		NicePrint(nfo)
	end

	if SERVER then
		AddCSLuaFile(fdir .. afile)
	end

	include(fdir .. afile)
end

function zrush.f.LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") and not IgnoreFileTable[afile] then
			zrush.f.LoadFile(fdir,afile,true)
		end
	end

	for _, dir in ipairs(dirs) do
		zrush.f.LoadAllFiles(fdir .. dir .. "/")
	end
end

// Initializes the Script
function zrush.f.Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////// Zeros OilRush ///////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")
	NicePrint("//------------------ SHARED ---------------------//")
	NicePrint("//                                               //")
	zrush.f.PreLoadFile("zrush/sh/","zrush_materials.lua",true)
	zrush.f.PreLoadFile("","zrush_config_main.lua",true)
	zrush.f.PreLoadFile("","zrush_config_fuel.lua",true)
	zrush.f.PreLoadFile("","zrush_config_modules.lua",true)
	zrush.f.PreLoadFile("","zrush_config_machines.lua",true)
	zrush.f.PreLoadFile("","zrush_config_oilspot.lua",true)

	// Needs to be loaded again now that the fuel list got created
	zrush.f.PreLoadFile("zrush/sh/","zrush_materials.lua",false)
	zrush.f.LoadAllFiles("zrush_languages/")
	zrush.f.LoadAllFiles("zrush/sh/")
	if SERVER then
		NicePrint("//                                               //")
		NicePrint("//------------------ SERVER ---------------------//")
		NicePrint("//                                               //")
	zrush.f.LoadAllFiles("zrush/sv/")
	end
	NicePrint("//                                               //")
	NicePrint("//------------------ CLIENT ---------------------//")
	NicePrint("//                                               //")
	zrush.f.LoadAllFiles("zrush/cl/")
	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")
end

if SERVER then

	timer.Simple(0,function()
		zrush.f.Initialize()
	end)
else


	// This needs to be called instantly on client since client settings wont work otherwhise
	zrush.f.PreLoadFile("zrush/sh/","zrush_materials.lua",false)
	zrush.f.PreLoadFile("zrush/cl/","zrush_fonts.lua",false)
	zrush.f.PreLoadFile("zrush/cl/","zrush_settings_menu.lua",false)

	timer.Simple(0,function()
		zrush.f.Initialize()
	end)
end


if GAMEMODE then
	zrush.f.Initialize()
end
