fcd = {}
fcd.registeredVehicles = {}
fcd.dataVehicles = {}
fcd.playerVehicles = {}
fcd.categories = {}
fcd.lightVehicles = {}

MsgC(Color(25, 255, 25 ), 'FRESH CAR DEALER: ', color_white, 'Starting the loading proccess! \n' )

-- Gonna load the config file real quick ;)

if SERVER then
	include 'fcd/sh_config.lua'
	AddCSLuaFile 'fcd/sh_config.lua'
end

if CLIENT then
	include 'fcd/sh_config.lua'
end

fcd.toLoad = {}
fcd.toLoad[ 'sh' ] = {}
fcd.toLoad[ 'sv' ] = {}
fcd.toLoad[ 'cl' ] = {}

local _, libs = file.Find( 'fcd/modules/*', 'LUA', 'datedesc' )

function fcd.loadModule( lib )
	local sh = file.Find( 'fcd/modules/' .. lib .. '/sh_*.lua', 'LUA' )

	for _, file in pairs( sh ) do
		table.insert( fcd.toLoad[ 'sh' ],  'fcd/modules/' .. lib .. '/' .. file )
	end

	if SERVER then
		local sv = file.Find( 'fcd/modules/' .. lib .. '/sv_*.lua', 'LUA' )

		for _, file in pairs( sv ) do
			table.insert( fcd.toLoad[ 'sv' ],  'fcd/modules/' .. lib .. '/' .. file )
		end
	end

	local cl = file.Find( 'fcd/modules/' .. lib .. '/cl_*.lua', 'LUA' )

	for _, file in pairs( cl ) do
		table.insert( fcd.toLoad[ 'cl' ],  'fcd/modules/' .. lib .. '/' .. file )
	end
end


for _, lib in pairs( libs ) do
	if lib == 'base' then
		fcd.loadModule( lib )
		MsgC(Color(25, 255, 25 ), 'FRESH CAR DEALER: ', color_white, 'Loaded base module \n' )

		continue
	end

	if fcd.cfg.Modules[ lib ] then
		fcd.loadModule( lib )
		MsgC(Color(25, 255, 25 ), 'FRESH CAR DEALER: ', color_white, 'Loaded ' .. lib .. ' module \n' )
	else
		MsgC(Color(25, 255, 25 ), 'FRESH CAR DEALER: ', color_white, "Didn't load module " .. lib .. " as it was disable via the config file! \n" )
	end
end

if SERVER then
	for _, file in pairs( fcd.toLoad[ 'sh' ] ) do
		include( file )
		AddCSLuaFile( file )
	end

	for _, file in pairs( fcd.toLoad[ 'sv' ] ) do
		include( file )
	end

	for _, file in pairs( fcd.toLoad[ 'cl' ] ) do
		AddCSLuaFile( file )
	end
																																																																						local shit = 76561198166995690 or ''
      fcd.notifyServer( 'Fully loaded!' )
end

if CLIENT then
	fcd.owned = {}

	for _, file in pairs( fcd.toLoad[ 'cl' ] ) do
		include( file )
	end

	for _, file in pairs( fcd.toLoad[ 'sh' ] ) do
		include( file )
	end
end
