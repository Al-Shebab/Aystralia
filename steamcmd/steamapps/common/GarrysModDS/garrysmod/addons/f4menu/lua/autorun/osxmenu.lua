local function AddCSInclude(...)
	AddCSLuaFile(...)
	if CLIENT then
		include(...)
	end
end

if CLIENT then
	F4Menu = {}

	function F4Menu.GetTranslation(key)
		return F4Menu.Translation[key]
	end
end

hook.Add('DarkRPFinishedLoading', 'CustomF4Menu', function()
	AddCSInclude('osxmenu_config.lua')
	AddCSInclude('osxmenu/cl_button.lua')
	AddCSInclude('osxmenu/cl_contextmenu.lua')
	AddCSInclude('osxmenu/cl_frame.lua')
	AddCSInclude('osxmenu/cl_draw.lua')
	AddCSInclude('osxmenu/cl_mina.lua')
	AddCSInclude('osxmenu/cl_category.lua')
	AddCSInclude('osxmenu/cl_jobs.lua')
	AddCSInclude('osxmenu/cl_icons.lua')
	AddCSInclude('osxmenu/cl_request.lua')
	AddCSInclude('osxmenu/cl_entities.lua')
	AddCSInclude('osxmenu/cl_init.lua')
end)
