local cvar_enable = CreateConVar("wyozicr_stereoenabled", "1", FCVAR_ARCHIVE)
local cvar_outside_enable = CreateConVar("wyozicr_outsidecar", "1", FCVAR_ARCHIVE)
local cvar_outside_dist = CreateConVar("wyozicr_outsidecar_distance", "500", FCVAR_ARCHIVE)
local cvar_volume = CreateConVar("wyozicr_stereovolume", "100", FCVAR_ARCHIVE)
local cvar_non3dvolmul = CreateConVar("wyozicr_non3dvolumemult", "0.5", FCVAR_ARCHIVE)
local cvar_htmlvolmul = CreateConVar("wyozicr_htmlvolumemult", "0.5", FCVAR_ARCHIVE)
local cvar_no3dswitchreload = CreateConVar("wyozicr_no3dswitchreload", "0", FCVAR_ARCHIVE)
local cvar_disable3d = CreateConVar("wyozicr_disable3d", "0", FCVAR_ARCHIVE)

local function GetDriver(car)
	if not IsValid(car) then return end

	local plys = player.GetAll()
	for i=1,#plys do
		if plys[i]:GetVehicle() == car then
			return plys[i]
		end
	end
end

local function Media_Stop(media)
	if media.Stop then
		media:Stop()
	else
		media:stop()
	end
end
local function Media_SetVolume(media, vol)
	if media.SetVolume then
		media:SetVolume(vol)
	else
		media:setVolume(vol * cvar_htmlvolmul:GetFloat())
	end
end

local Entity = FindMetaTable("Entity")

-- Potential Car Set
-- Set of cars that can play music and can potentially be heard by localplayer
local PCS = wyozicr._PCS or {}
wyozicr._PCS = PCS

function Entity:WCR_RadioStop()
	if not self.WCR_Player then return end

	--assert(self:WCR_IsCarEntity())

	Media_Stop(self.WCR_Player)
	self.WCR_Player = nil
	self.WCR_PlayerCreated = nil
end

local cvar_debugpcs = CreateConVar("wyozicr_debugpcs", "0")
cvars.AddChangeCallback("wyozicr_debugpcs", function(a, b, c)
	if c == "1" then
		hook.Add("HUDPaint", "WCR_PCSDebugPaint", function()
			local i = 0
			for car,_ in pairs(PCS) do
				draw.SimpleText(tostring(car) .. ": " .. tostring(car.WCR_Player), "DermaDefaultBold", 10, 150 + i * 20, Color(255, 255, 255))
				i = i + 1
			end
		end)
	else
		hook.Remove("HUDPaint", "WCR_PCSDebugPaint")
	end
end, "debugpaint")

function Entity:WCR_RadioThink(isLocalCar, isThirdperson)
	local car = self

	if not IsValid(car) or car:IsDormant() then
		PCS[car] = nil
		car:WCR_RadioStop()

		if cvar_debugpcs:GetBool() then
			print(car, " removed/dormant; PCS removed")
		end
		return
	end

	local isPlaying = IsValid(car.WCR_Player)
	local shouldPlay = cvar_enable:GetBool() and car:WCR_HasRadioCapability()

	local station = car:WCR_GetChannel()
	local stat = wyozicr.AllStations and wyozicr.AllStations[station]
	local isWDJ = stat and stat.WDJ_Channel ~= nil

	local url = stat and stat.Link

	-- Make sure we're not trying to play nil
	if (not url or url == "") and (not stat or not stat.WDJ_Channel) then
		shouldPlay = false

		PCS[car] = nil

		if cvar_debugpcs:GetBool() then
			print(car, " nil url; PCS removed")
		end
	end

	-- If we're not sitting inside the car, need to do some additional checks to
	-- check if we really should play radio
	if not isLocalCar and shouldPlay then
		local carpos = car:GetPos()
		local req_dist = cvar_outside_dist:GetFloat()

		-- if wasn't playing, we require player to be a bit closer to prevent spawm
		-- from going back and forth
		if not isPlaying then req_dist = req_dist - 100 end

		local play_outside = not isWDJ and cvar_outside_enable:GetBool() and carpos:Distance(LocalPlayer():EyePos()) < req_dist
		if not play_outside then
			shouldPlay = false
		end
	end

	-- shouldPlay cannot change after this point
	-- if it's false, terminate early
	if not shouldPlay then
		if isPlaying then car:WCR_RadioStop() end
		return
	end

	-- Check if URL has changed. WDJ media needs some extra magic code to work
	local hasUrlChanged = car.WCR_Url ~= url
	if isWDJ then
		local master = wdj.GetMaster(stat.WDJ_Channel)
		hasUrlChanged = IsValid(master) and (not IsValid(car.WCR_Player) or type(car.WCR_Player) ~= "table" or car.WCR_Player:getUrl() ~= master:GetCurMedia())
	end

	local should3D = not isLocalCar or (isThirdperson and not cvar_disable3d:GetBool())
	local has3DChanged = not isWDJ and IsValid(car.WCR_Player) and not cvar_no3dswitchreload:GetBool() and car.WCR_Player:Is3D() ~= should3D

	if isPlaying and not shouldPlay then
		MsgN("[WyoziCR] Stopping #" .. station .. " (car: " .. tostring(car) .. " - url: " .. tostring(stereourl) .. ")")

		car:WCR_RadioStop()
	elseif shouldPlay and (hasUrlChanged or has3DChanged or not isPlaying) and not car.WCR_StartingStereo then
		local only3DChanged = has3DChanged and not hasUrlChanged and isPlaying

		if IsValid(car.WCR_Player) and not only3DChanged then
			car:WCR_RadioStop()
		end

		if isWDJ then
			local master = wdj.GetMaster(stat.WDJ_Channel)

			if IsValid(master) then
				local link = master:GetCurMedia()

				if link ~= "" and link ~= "--loading" then
					MsgN(string.format("[WyoziCR] Loading WDJ station #%d (car: %s - url: %s)",
						station,
						tostring(car),
						tostring(url)))

					local elapsed = CurTime() - (master:GetCurMediaStarted() or CurTime())

					local service = wdj.medialib.load("media").guessService(link)
					local mediaclip = service:load(link)

					mediaclip:seek(elapsed)
					mediaclip:play()
					car.WCR_Player = mediaclip
					car.WCR_PlayerCreated = CurTime()
					car.WCR_Url = nil
				end
			end
		else
			if hasUrlChanged then
				car.WCR_PlayAttempts = 0
			end

			if car.WCR_PlayAttempts >= 2 then
				return
			end

			MsgN(string.format("[WyoziCR] Loading station #%d (car: %s - url: %s)",
				station,
				tostring(car),
				tostring(url)))

			car.WCR_StartingStereo = true
			car.WCR_Url = url

			local opts = should3D and "3d" or ""
			sound.PlayURL(url, opts, function(chan, err, errstr)
				if IsValid(car.WCR_Player) and only3DChanged then
					car:WCR_RadioStop()
				end

				if not IsValid(chan) then
					MsgN(string.format("[WyoziCR] Loading stream failed: %s", errstr))

					car.WCR_PlayAttempts = (car.WCR_PlayAttempts or 0) + 1
					car.WCR_StartingStereo = false
					return
				end
				if not IsValid(car) then
					MsgN("[WyoziCR] Associated car removed during stream load")

					chan:Stop()
					return
				end

				car.WCR_StartingStereo = false
				car.WCR_Player = chan
				car.WCR_PlayerCreated = CurTime()
				car.WCR_PlayAttempts = 0
			end)
		end
	end

	if IsValid(car.WCR_Player) then
		local volumemul = 1

		-- if BASS, we need to set position
		if not isWDJ then
			if car.WCR_Player:Is3D() then
				if isLocalCar then
					car.WCR_Player:SetPos(LocalPlayer():EyePos())
					car.WCR_Player:Set3DFadeDistance(200, 1000000000)
				else
					car.WCR_Player:SetPos(car:GetPos())
					car.WCR_Player:Set3DFadeDistance(150, cvar_outside_dist:GetFloat())
				end
			else
				volumemul = volumemul * cvar_non3dvolmul:GetFloat()
			end
		end

		-- fadein
		if not isLocalCar and car.WCR_PlayerCreated then
			local fadein = math.min((CurTime() - car.WCR_PlayerCreated)*2, 1)
			volumemul = volumemul * fadein
		end

		local vol = cvar_volume:GetFloat() or 50
		vol = vol / 100
		vol = vol * volumemul
		vol = math.min(vol, 1)

		Media_SetVolume(car.WCR_Player, vol)
	end
end

hook.Add("EntityNetworkedVarChanged", "WCR_RadioChangeListener", function(ent, name, oldval, newval)
	if name == "wcr_chan" then

		PCS[ent] = true

		if cvar_debugpcs:GetBool() then
			print(ent, " chanchange; PCS updated")
		end
	end
end)

hook.Add("NetworkEntityCreated", "WCR_PCSAdd", function(ent)
	if ent:WCR_IsCarEntity() then
		-- add entity to car think
		PCS[ent] = true

		if cvar_debugpcs:GetBool() then
			print(ent, " netentcreate; PCS updated")
		end
	end
end)
hook.Add("NotifyShouldTransmit", "WCR_PCSUpdater", function(ent, shouldTransmit)
	if ent:WCR_IsCarEntity() and shouldTransmit then
		PCS[ent] = true

		if cvar_debugpcs:GetBool() then
			print(ent, " NST; PCS updated")
		end
	end
end)

hook.Add("Think", "WCR_ActiveRadioUpdater", function()
	local localVeh = LocalPlayer():GetVehicle()
	localVeh = IsValid(localVeh) and localVeh:WCR_GetCarEntity()

	local isThirdperson = IsValid(localVeh) and (not localVeh.GetThirdPersonMode or localVeh:GetThirdPersonMode())

	for car,_ in pairs(PCS) do
		local isLocalCar = localVeh == car

		car:WCR_RadioThink(isLocalCar, isThirdperson)
	end
end)

hook.Add("EntityRemoved", "WCR_RadioCleanup", function(ent)
	if IsValid(ent.WCR_Player) then
		Media_Stop(ent.WCR_Player)
	end
end)