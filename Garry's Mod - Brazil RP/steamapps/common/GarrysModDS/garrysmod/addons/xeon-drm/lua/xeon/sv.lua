-- Copyright © 2019 William Venner
-- Tampering will result in immediate automatic license revokation

XEON:print("Running/updating XEON...")

file.CreateDir("xeon")

if (file.Exists("xeon/xeon.dat", "DATA")) then
	RunString(file.Read("xeon/xeon.dat", "DATA"), "XEON DRM")
end
local function LoadCached()
	if (file.Exists("xeon/xeon.dat", "DATA")) then
		XEON:print("Using cached DRM payload! Check status page: " .. XEON.URL, XEON.PRINT_WARNING)
		RunString(file.Read("xeon/xeon.dat", "DATA"), "XEON DRM")
		return true
	else
		XEON:print("XEON was unable to get the DRM payload, please check your server's connection to the internet. Check status page: " .. XEON.URL, XEON.PRINT_ERROR)
	end
end
timer.Simple(0, function()
	http.Post(XEON.URL .. "/api/xeon", {}, function(body, size, headers, httpCode)
		if (httpCode == 200 and size > 0) then
			local line1 = {string.find(body,string.char(10))}
			local line1_start = line1[1] local line1_end = line1[2]
			if (body:sub(1, line1_start - 1) == "success") then
				body = body:sub(line1_end + 1)
				local payload, err = CompileString(body, "XEON DRM", false)
				if (type(payload) == "function") then
					if (not file.Exists("xeon/xeon.dat", "DATA")) then
						payload()
					end
					file.Write("xeon/xeon.dat", body)
				else
					if (not LoadCached()) then
						local err
						if (type(payload) == "string") then err = payload end
						if (err) then
							XEON:print("Lua error with DRM payload!", XEON.PRINT_ERROR)
							ErrorNoHalt(err .. string.char(10))
						else
							XEON:print("Unknown error with DRM payload!", XEON.PRINT_ERROR)
						end
					end
				end
			else
				file.Write("xeon/invalid_response_" .. os.time() .. ".txt", body)
				XEON:print("Invalid response from XEON. Body written to data/xeon/invalid_response_" .. os.time() .. ".txt", XEON.PRINT_ERROR)
				LoadCached()
			end
		else
			XEON:print("httpCode = " .. httpCode .. ", size = " .. size, XEON.PRINT_ERROR)
			LoadCached()
		end
	end, function(err)
		XEON:print("http.Fetch error: " .. err, XEON.PRINT_ERROR)
		LoadCached()
	end)
end)
