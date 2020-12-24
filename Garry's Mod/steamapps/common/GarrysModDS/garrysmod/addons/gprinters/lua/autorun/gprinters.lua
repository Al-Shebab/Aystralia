--[[
	gPrinters Release
	Version: 1.0.0
]]

gPrinters = {}
gPrinters.version = "V3.1"
gPrinters.adminModes = {}
gPrinters.printers = {}
gPrinters.plugins = {}
gPrinters.tabs = {}
gPrinters.lang = {}
gPrinters.cfg = {}

if SERVER then
	util.AddNetworkString( "gPrinters.sendID" )
	local files, directories = file.Find( "gprinters/*", "LUA" )
	for i, folder in pairs( directories ) do
		local files, directories = file.Find( "gprinters/" .. folder .. "/*", "LUA" )
		for i, f in pairs( files ) do
			if string.StartWith( f, "sh_" ) || string.StartWith( f, "cfg_" ) then
				include( "gprinters/" .. folder .. "/" .. f )
				AddCSLuaFile( "gprinters/" .. folder .. "/" .. f )
			elseif string.StartWith( f, "sv_" ) then
				include( "gprinters/" .. folder .. "/" .. f )
			elseif string.StartWith( f, "cl_" ) then
				AddCSLuaFile( "gprinters/" .. folder .. "/" .. f )
			end
		end
	end
	resource.AddWorkshop( "778221022" )
	resource.AddWorkshop( "1201714594" )
	resource.AddWorkshop( "1785499383" )
	resource.AddFile( "resource/fonts/bfhud.ttf" )

	//New gPrinters v3 Icons
	resource.AddFile( "materials/gprinters/circle_32.png" )
	resource.AddFile( "materials/gprinters/circle_256.png" )
	resource.AddFile( "materials/gprinters/multiserver_32.png" )
	resource.AddFile( "materials/gprinters/multiserver_256.png" )
	resource.AddFile( "materials/gprinters/server_32.png" )
	resource.AddFile( "materials/gprinters/server_256.png" )
	resource.AddFile( "materials/gprinters/star_32.png" )
	resource.AddFile( "materials/gprinters/star_256.png" )

	local attachments = {
		[1] = { model = "antenna", visible = 0 },
		[2] = { model = "armour", visible = 0 },
		[3] = { model = "block_fan", visible = 0 },
		[4] = { model = "block_moreprint", visible = 0 },
		[5] = { model = "block_silencer", visible = 0 },
		[6] = { model = "pipes", visible = 0 },
		[7] = { model = "scanner", visible = 0 }
	}

	for i = 1, #attachments do
		util.PrecacheModel( "models/gprinter/gprinter_" .. attachments[ i ].model .. ".mdl" )
	end

else
	local files, directories = file.Find( "gprinters/*", "LUA" )
	for i, folder in pairs( directories ) do
		local files, directories = file.Find( "gprinters/" .. folder .. "/*", "LUA" )
		for i, f in pairs( files ) do
			if string.StartWith( f, "sh_" ) || string.StartWith( f, "cfg_" ) then
				include( "gprinters/" .. folder .. "/" .. f )
			elseif string.StartWith( f, "cl_" ) then
				include( "gprinters/" .. folder .. "/" .. f )
			end
		end
	end

	steamworks.FileInfo( 778221022, function( result )
		steamworks.Download( result.fileid, true, function( name )
			game.MountGMA( name )
		end )
	end )

end

if SERVER then
	util.AddNetworkString( "gPrinters.chat" )

	function gPrinters.sendChat( ply, identifier, col, message )
		if !IsValid( ply ) then return end
		net.Start( "gPrinters.chat" )
			net.WriteString( identifier )
			net.WriteVector( Vector( col.r, col.g, col.b ) )
			net.WriteString( message )
		net.Send( ply )
	end
else
	net.Receive( "gPrinters.chat", function( len, ply )
		local identifier = net.ReadString()
		local vector = net.ReadVector()
		local color = Color( vector.x, vector.y, vector.z )
		local message = net.ReadString()

		chat.AddText( unpack( { color, identifier .. ": ", Color( 255, 255, 255 ), message } ) )
		chat.PlaySound()
	end )
end

local settingFile = "gprinters/printers/printers.txt"

function gPrinters.loadCustom()
	if !file.Exists( settingFile, "DATA" ) then
		print( "File not found" )
		return
	end

	local printers = file.Read( settingFile, "DATA" )
	printersData = util.JSONToTable( printers )
	if printersData then
		for k, v in pairs( printersData ) do
			local tblEnt = {}
			tblEnt.name = v.name
			tblEnt.ent = v.cmd
			tblEnt.model = v.model
			tblEnt.price = tonumber( v.f4price )
			tblEnt.max = tonumber( v.f4amount )
			tblEnt.cmd = v.cmd

			if ( #v.jobs > 0 ) then
				tblEnt.allowed = v.jobs
			end

			if v.customCheck then
				tblEnt.customCheck = function( ply )
					if v.rank >= 1 then
						gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].rankFunction( v.ranks, ply )
					else
						return ply
					end
				end

				tblEnt.CustomCheckFailMsg = function( ply )
					if v.rank >= 1 then
						return "You're not in the correct group!"
					else
						return ply
					end
				end
			end

			tblEnt.category = v.category
			tblEnt.sortOrder = tonumber( v.sortOrder )
			tblEnt.level = tonumber( v.plevel )
			tblEnt.donationrank = tonumber( v.donationrank ) || nil
			DarkRP.createEntity(v.name, tblEnt )
		end
	end
end

timer.Simple( 5, function()
	gPrinters.loadCustom()
end )