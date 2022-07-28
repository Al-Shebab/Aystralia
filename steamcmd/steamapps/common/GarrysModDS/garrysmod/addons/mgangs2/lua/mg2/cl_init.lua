--[[
    MGangs 2 - NOTIFICATIONS - (CL) Init
    Developed by Zephruz
]]

--[[
    mg2:Notification(...)

    - Posts a chat message to the LocalPlayer() chat and runs the zlib notification function
]]
function mg2:Notification(...)
    chat.AddText(Color(125,255,125), "[MGangs] ", Color(255,255,255), ...)

    zlib.notifs:Create(...)
end

--[[
    Hooks
]]
surface.CreateFont("mg2.GANGUSERHUD.LARGE", {
    font = "Abel",
    size = 26,
})

surface.CreateFont("mg2.GANGUSERHUD.MEDIUM", {
    font = "Abel",
    size = 24,
})

surface.CreateFont("mg2.GANGUSERHUD.SMALL", {
    font = "Abel",
    size = 20,
})

hook.Add("HUDPaint", "mg2.gang[HUDPaint]",
function()
    if (mg2.config.showGangHUD) then
        local tr = LocalPlayer():GetEyeTrace()
        local ply = tr.Entity

        if (IsValid(ply) && ply:IsPlayer()) then
            local gang, gangGroup = ply:GetGang(), ply:GetGangGroup()
            local inProx = (ply:GetPos():DistToSqr(LocalPlayer():GetPos()) < 30000)

            if (!inProx or !gang or !gangGroup) then return end

            local name, grpName, gColor = gang:GetName(), gangGroup:GetName(), (gang:GetColor() || Color(125,125,125))
            local values = {
				{
					value = name,
					x = ScrW()/2, y = ScrH() - 48,
					font = "mg2.GANGUSERHUD.LARGE"
				},
				{
					value = grpName,
					x = ScrW()/2, y = ScrH() - 30,
					font = "mg2.GANGUSERHUD.SMALL"
				},
			}

			local bW, bH = 0, 0

			-- Calculate box w/h
			for _,val in pairs(values) do
				local valW, valH = zlib.util:GetTextSize(val.value, val.font)

				if (valW > bW) then bW = valW end
				bH = bH + valH
			end

			bW = bW + 10

			local bX, bY = (ScrW()/2 - bW/2), (ScrH() - 75)

            draw.RoundedBoxEx(5, (bX - 2), (bY - 2), (bW + 4), (bH + 4), gColor, true, true, true, true)
			draw.RoundedBoxEx(5, bX, bY, bW, bH, Color(55,55,55,255), true, true, true, true)

            draw.SimpleText(mg2.lang:GetTranslation("ganginfo"), "mg2.GANGUSERHUD.SMALL", ScrW()/2, ScrH() - 80, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

            for _,val in pairs(values) do
				draw.SimpleText(val.value, val.font, val.x, val.y, (val.color or Color(255,255,255,255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
        end
    end
end)