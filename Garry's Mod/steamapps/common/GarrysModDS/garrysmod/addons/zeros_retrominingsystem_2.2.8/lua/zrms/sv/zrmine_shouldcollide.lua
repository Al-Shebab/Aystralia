if not SERVER then return end


hook.Add("ShouldCollide", "a_zrmine_ShouldCollide", function(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) then
		local class01 = ent1:GetClass()
		local class02 = ent2:GetClass()

		if class01 == "zrms_mineentrance_base" and class02 == "zrms_ore" then return false end
		if class01 == "zrms_bar" and class02 == "zrms_bar" then return false end
		if class01 == "zrms_bar" and class02 == "Player" then return false end
	end
end)
