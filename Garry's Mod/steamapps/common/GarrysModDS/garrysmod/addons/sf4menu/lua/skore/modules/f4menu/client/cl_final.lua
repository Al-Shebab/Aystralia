
hook.Add("loadCustomDarkRPItems", "sF4MenuReload", function()
    timer.Simple(0, function() -- 76561198166995690
	    if IsValid(sF4Menu.f4Menu) then sF4Menu.f4Menu:Remove() end
        local panel = DarkRP.getF4MenuPanel()
        if IsValid(panel) then panel:Remove() end

        include("skore/modules/f4menu/client/cl_init.lua")
    end)
end)