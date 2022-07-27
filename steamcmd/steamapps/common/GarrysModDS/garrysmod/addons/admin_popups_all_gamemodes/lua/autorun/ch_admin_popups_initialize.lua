-- INITIALIZE SCRIPT
if SERVER then
	for k, v in pairs( file.Find( "ch_admin_popups/shared/*.lua", "LUA" ) ) do
		include( "ch_admin_popups/shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_admin_popups/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_admin_popups/shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_admin_popups/server/*.lua", "LUA" ) ) do
		include( "ch_admin_popups/server/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_admin_popups/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_admin_popups/client/" .. v )
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_admin_popups/shared/*.lua", "LUA" ) ) do
		include( "ch_admin_popups/shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_admin_popups/client/*.lua", "LUA" ) ) do
		include( "ch_admin_popups/client/" .. v )
	end
end