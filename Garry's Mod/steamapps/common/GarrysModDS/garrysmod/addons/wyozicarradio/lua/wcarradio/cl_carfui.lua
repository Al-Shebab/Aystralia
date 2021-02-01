-- return local pos/ang

local angleOverrides = {
	["models/buggy.mdl"] = -90,
	["models/airboat.mdl"] = -90,
}

local function GetAngPos(ply, seat, veh)
	local Pos, Ang

	if veh.IsScar and veh:IsScar() then
		-- ahoy, prepare the hacky workarounds
		if veh.SeatPos and #veh.SeatPos >= 2 then
			local pos0, pos1 = unpack(veh.SeatPos)

			local pos, fwd = (pos0 + pos1) / 2 + Vector(0, 0, 28), (pos1 - pos0):Cross(veh:GetUp()):GetNormalized()
			pos = pos + fwd * 20

			return pos, fwd:Angle()
		end
	end

	local posang = veh:GetAttachment(veh:LookupAttachment("vehicle_driver_eyes"))
	if posang then
		Pos = posang.Pos
		Ang = posang.Ang
	end

	if not Pos or not Ang then return end

	local driver_eyes_local = veh:WorldToLocal(Pos)
	local mid_local = veh:WorldToLocal(veh:WorldSpaceCenter())

	local pos = mid_local
	pos.x = pos.x - 4 -- To center the FUI we use an Arbitrarily Chosen But Correct number
	pos.y = driver_eyes_local.y + 22
	pos.z = driver_eyes_local.z - 1.5

	local ang = veh:WorldToLocalAngles(Ang)
	ang.p = 0

	local ao = angleOverrides[veh:GetModel()]
	if ao then
		ang:RotateAroundAxis(ang:Up(), ao)
	end

	return pos, ang
end

local tdui = wyozicr.tdui

tdui.RegisterSkin("WyoziCarRadio", {
	rect = {
		color = Color(44, 62, 80, 170)
	},
	button = {
		bgColor = Color(44, 62, 80, 200),
		bgHoverColor = Color(192, 57, 43),
		fgColor = Color(255, 255, 255)
	}
})

local icon_cfg = Material("icon16/cog.png")
local uni_left = utf8.char(0x25c0)
local uni_right = utf8.char(0x25b6)

surface.CreateFont("WCRConfig", {
	font = "Roboto",
	size = 16
})

local ui
hook.Add("PostDrawTranslucentRenderables", "WCR_FUIRenderer", function(bDrawingSkybox, bDrawingDepth)
    if bDrawingDepth then return end

	local ply = LocalPlayer()

	local seat = ply:GetVehicle()
	local veh = seat:WCR_GetCarEntity()

	if not IsValid(veh) then return end

	local lpos, lang = GetAngPos(ply, seat, veh)
	if not lpos or not lang then return end

	local pos, ang = veh:LocalToWorld(lpos), veh:LocalToWorldAngles(lang)

	local eyelocal = veh:WorldToLocal(ply:EyePos())
	if math.abs(eyelocal.x) > 5 then
		ang:RotateAroundAxis(ang:Up(), eyelocal.x > 0 and 10 or -10)
	end

	ui = ui or tdui.Create()
	ui:SetSkin("WyoziCarRadio")

	ui:_UpdatePAS(pos, ang, 0.02)
	ui:BeginRender()

	if not veh:WCR_IsCarHealthy() then
		ui:DrawRect(0, 0, 500, 230, Color(30, 30, 30))

		ui:DrawText("Car is broken", "!Roboto@35", 250, 50)
		ui:DrawText("Repair the car to continue listening", "!Roboto@30", 250, 100)
	else
		ui:DrawRect(0, 0, 500, 230)

		local cur_station = veh:WCR_GetChannel()
		local cs_name, cs_url

		local stereochan, prevschan, nextschan = "-", "", ""
		local isOn = true
		do
			stereochan = cs_name or cs_url or ""
			if stereochan == "" then
				local station = wyozicr.AllStations[cur_station]
				if station then
					stereochan = station.Name
					local prevchan, nextchan = (cur_station-1), (cur_station+1)
					if prevchan < 1 then prevchan = #wyozicr.AllStations end
					if nextchan > #wyozicr.AllStations then nextchan = 1 end

					prevschan = wyozicr.AllStations[prevchan] and wyozicr.AllStations[prevchan].Name or ""
					nextschan = wyozicr.AllStations[nextchan] and wyozicr.AllStations[nextchan].Name or ""
				else
					stereochan = ""
					isOn = false
				end
			end
		end

		ui:DrawText("Radio station selector", "!Roboto@35", 250, 7)
		ui:DrawLine(0, 47, 500, 47, tdui.COLOR_WHITE_TRANSLUCENT)
		ui:DrawText(stereochan, "!Roboto@30", 250, 60)

		if ui:DrawButton("", "!Roboto@20", 440, 10, 45, 45) then

			local fr = vgui.Create("DFrame")
			fr:SetSize(180, 105)
			fr:Center()

			fr:SetTitle("")
			fr.btnMinim:SetVisible(false); fr.btnMaxim:SetVisible(false)
			fr.Paint = function(_,w,h)
				surface.SetDrawColor(44, 62, 80, 250)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(255, 255, 255)
				surface.DrawRect(0, 0, w, 25)

				draw.SimpleText("Car Radio settings", "WCRConfig", 6, 4, Color(44, 62, 80))

				surface.SetDrawColor(255, 255, 255)
				surface.DrawOutlinedRect(0, 0, w, h)

				draw.SimpleText("Volume", "WCRConfig", 6, 32)
				surface.DrawLine(0, 55, w, 55)

				draw.SimpleText("Muffle sounds", "WCRConfig", 25, 61)

				draw.SimpleText("Disable 3D Volume", "WCRConfig", 25, 81)
			end

			local s = fr:Add("DNumSlider")
			s.Label:SetVisible(false)
			s.TextArea:SetTextColor(Color(255, 255, 255))
			s:SetPos(55, 30)
			s:SetSize(140, 20)
			s:SetMinMax(0, 100)
			s:SetDecimals(0)
			s:SetConVar("wyozicr_stereovolume")
			s.Slider:SetSlideX(GetConVar("wyozicr_stereovolume"):GetFloat() / 100)

			local s = fr:Add("DCheckBox")
			s:SetPos(5, 62)
			s:SetConVar("wyozicr_mufflesounds")

			local s = fr:Add("DCheckBox")
			s:SetPos(5, 82)
			s:SetConVar("wyozicr_disable3d")

			fr:MakePopup()
		end
		ui:DrawMat(icon_cfg, 450, 20, 24, 24)

		ui:EnableRectStencil(0, 50, 110, 100)
		ui:DrawText(prevschan, "!Roboto@25", 10, 75, Color(180, 180, 180), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		ui:DisableStencil()

		ui:EnableRectStencil(390, 50, 110, 100)
		ui:DrawText(nextschan, "!Roboto@25", 490, 75, Color(180, 180, 180), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		ui:DisableStencil()

		if ui:DrawButton(uni_left, "!Roboto@200", 20, 110, 100, 100) then
			net.Start("wyozicr_cradio")
				net.WriteInt(-1, 8)
			net.SendToServer()
		end

		if ui:DrawButton(uni_right, "!Roboto@200", 380, 110, 100, 100) then
			net.Start("wyozicr_cradio")
				net.WriteInt(1, 8)
			net.SendToServer()
		end

		if ui:DrawButton(isOn and "Turn OFF" or "Turn ON", "!Roboto@60", 130, 110, 240, 100, isOn and tdui.COLOR_RED or tdui.COLOR_GREEN) then
			net.Start("wyozicr_cradio")
				net.WriteInt(0, 8)
			net.SendToServer()
		end
	end

	ui:DrawCursor()
	ui:EndRender()

	ui:BlockUseBind()
end)