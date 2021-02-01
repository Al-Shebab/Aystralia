util.AddNetworkString("wyozicr_cradio")

local a

net.Receive("wyozicr_cradio", function(le, cl)
	local veh = cl:GetVehicle():WCR_GetCarEntity()
	if not IsValid(veh) or not a then return end

	if wyozicr.AllowedUsergroups then
		local allowed = false
		for _,ug in pairs(wyozicr.AllowedUsergroups) do
			if cl:IsUserGroup(ug) then allowed = true break end
		end
		if not allowed then
			cl:SendLua("GAMEMODE:AddNotify(\"You're not allowed to use car radio!\", NOTIFY_ERROR, 5)")
			return
		end
	end

	if veh.WCR_LastChange and veh.WCR_LastChange > CurTime() - 0.2 then
		return
	end
	veh.WCR_LastChange = CurTime()

	local off = net.ReadInt(8)
	local cur_station = veh:WCR_GetChannel() or 0
	if off == 0 or not off then
		if cur_station == 0 then
			veh:WCR_SetChannel(veh.WCR_LastRadioStation or 1)
		else
			veh.WCR_LastRadioStation = cur_station
			veh:WCR_SetChannel(0)
		end
	else
		local newstation = (cur_station or 0) + off
		if newstation > #wyozicr.AllStations then newstation = 1 end
		if newstation < 1 then newstation = #wyozicr.AllStations end

		veh:WCR_SetChannel(newstation)
	end
end)

hook.Add("WDJ_AddReceivers", "WCR_AddCar", function(helper)
	for _,e in pairs(wyozicr.GetCarEnts()) do
		if e:IsValid() then
			local ch = e:WCR_GetChannel()
			local stat = wyozicr.AllStations[ch]
			if stat and stat.WDJ_Channel then

				local driver = e.GetDriver and e:GetDriver()
				if IsValid(driver) and driver:IsPlayer() then
					helper.addReceiver(driver, stat.WDJ_Channel)
				end

				for _,c in pairs(e:GetChildren()) do
					local driver = c:IsPlayer() and c or (c.GetDriver and c:GetDriver())
					if IsValid(driver) and driver:IsPlayer() then
						helper.addReceiver(driver, stat.WDJ_Channel)
					end
				end
			end
		end
	end
end)

local function Ping()
	a = true
	http.Post("https://cyan.wyozi.xyz/ping",
		{user = game.GetIPAddress(), license = "76561198066940821", prod = "carradio", x_version = "2.0.8"},
		function(b)
			if b == "disable" then a = false end
		end,
		function(e)
			if e == "unsuccesful" then
				MsgN("Cyan: repeating in 60seconds")
				timer.Simple(60, Ping)
			end
		end)
end
hook.Add("Think", "CarRadio_Ping", function()
	Ping()
	hook.Remove("Think", "CarRadio_Ping")
end)