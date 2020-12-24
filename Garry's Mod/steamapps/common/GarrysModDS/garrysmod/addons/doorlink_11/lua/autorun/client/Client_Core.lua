hook.Add("HUDDrawDoorData","Door Linker ClientHUD",function(ent)
	local CPos = {x = ScrW()/2, y = ScrH() / 2}
	local DL = Door_HasLink(ent)
	if DL then
		if DL.ShowPrintNameInHUD then
			draw.SimpleText(DL.PrintName, "TargetID", CPos.x, CPos.y - 50, Color(0, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		draw.SimpleText("linked Door = total " .. table.Count(DL.Items), "TargetID", CPos.x, CPos.y - 30, Color(0, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
end)
