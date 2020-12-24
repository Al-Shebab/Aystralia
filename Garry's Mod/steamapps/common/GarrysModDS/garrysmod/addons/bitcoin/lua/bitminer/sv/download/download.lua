if CLIENT then return end

if bitmine.EnableResourceAddfile then

	bitmine2 = bitmine2 || {}

	function bitmine2.AddDir( path )
        local files, folders = file.Find( path .. "/*", "GAME" )
        for k, v in pairs( files ) do
            resource.AddFile( path .. "/" .. v )
        end
        for k, v in pairs( folders ) do
            bitmine2.AddDir( path .. "/" .. v )
        end
	end

	bitmine2.AddDir("models/computer_updated")
	bitmine2.AddDir("materials/models/computer_updated")
	bitmine2.AddDir("materials/bit")
	bitmine2.AddDir("materials/customhq")
	bitmine2.AddDir("materials/models/customhq")
	
else

	resource.AddWorkshop( "906964622" )

end
	





