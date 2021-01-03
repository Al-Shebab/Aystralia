-- INITIALIZE SCRIPT
if SERVER then
	for k, v in pairs( file.Find( "ch_armory_robbery/server/*.lua", "LUA" ) ) do
		include( "ch_armory_robbery/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_armory_robbery/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_armory_robbery/client/" .. v )
		--print("cs client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_armory_robbery/shared/*.lua", "LUA" ) ) do
		include( "ch_armory_robbery/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_armory_robbery/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_armory_robbery/shared/" .. v )
		--print("cs shared: ".. v)
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_armory_robbery/client/*.lua", "LUA" ) ) do
		include( "ch_armory_robbery/client/" .. v )
		--print("client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_armory_robbery/shared/*.lua", "LUA" ) ) do
		include( "ch_armory_robbery/shared/" .. v )
		--print("shared client: ".. v)
	end
end