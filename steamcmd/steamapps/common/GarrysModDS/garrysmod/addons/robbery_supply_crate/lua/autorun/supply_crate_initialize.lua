-- INITIALIZE SCRIPT
if SERVER then
	for k, v in ipairs( file.Find( "crate_robbery/shared/*.lua", "LUA" ) ) do
		include( "crate_robbery/shared/" .. v )
	end
	
	for k, v in ipairs( file.Find( "crate_robbery/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "crate_robbery/shared/" .. v )
	end
	
	for k, v in ipairs( file.Find( "crate_robbery/server/*.lua", "LUA" ) ) do
		include( "crate_robbery/server/" .. v )
	end
	
	for k, v in ipairs( file.Find( "crate_robbery/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "crate_robbery/client/" .. v )
	end
end

if CLIENT then
	for k, v in ipairs( file.Find( "crate_robbery/shared/*.lua", "LUA" ) ) do
		include( "crate_robbery/shared/" .. v )
	end
	
	for k, v in ipairs( file.Find( "crate_robbery/client/*.lua", "LUA" ) ) do
		include( "crate_robbery/client/" .. v )
	end
end