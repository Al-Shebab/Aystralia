--[[
	Función de registro
]]

function gPrinters.addPrinter( pname, params, ent_cmd )
	params = params or {}
	ent_cmd = ent_cmd

	local ENT = {}
	ENT.Type = "anim"
	ENT.Base = "gbase"
	ENT.PrintName = pname
	ENT.Spawnable = false
	ENT.AdminSpawnable = false
	ENT.data = params
	scripted_ents.Register( ENT, ent_cmd )
	return ent_cmd
end

hook.Add( "PlayerSay", "gPrinters.adminCommand", function( ply, text )
	if ( text == "!" .. gPrinters.plugins[ "General" ].adminCommand ) or ( text == "/" .. gPrinters.plugins[ "General" ].adminCommand ) then
		ply:ConCommand( "gPrinters.openMenu" )
		return ""
	end
end )

hook.Add( "PlayerInitialSpawn", "gPrinters.notification", function( ply )
	if IsValid( ply ) and ply:IsSuperAdmin() and ( gPrinters.plugins[ "General" ].adminNotify == true ) then
		timer.Simple( 5, function()
			gPrinters.sendChat( ply, "[gPrinter]", Color( 255, 163, 0 ), "In order to modify gPrinters, please type !" .. gPrinters.plugins[ "General" ].adminCommand .. " in chat" )
			gPrinters.sendChat( ply, "[gPrinter]", Color( 255, 163, 0 ), "If you haven't added any, use it to add them." )
		end )
	end
end )