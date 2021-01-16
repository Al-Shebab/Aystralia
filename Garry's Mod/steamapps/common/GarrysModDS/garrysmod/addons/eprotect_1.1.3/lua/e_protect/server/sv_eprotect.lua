eProtect = eProtect or {}
eProtect.queneData = eProtect.queneData or {}
eProtect.saveQueue = eProtect.saveQueue or {}

eProtect.data = eProtect.data or {}
eProtect.data.disabled = eProtect.data.disabled or {}

local ignoreSaving = {
	["fakeNets"] = true,
	["netLogging"] = true,
	["exploitPatcher"] = true
}

util.AddNetworkString("eP:Handeler")

local function openMenu(ply)
	net.Start("eP:Handeler")
	net.WriteUInt(2, 3)
	net.Send(ply)
end

local function networkData(ply, data, specific)
	if !data then return end
	local data = util.TableToJSON(data)

	data = util.Compress(data)

	net.Start("eP:Handeler")
	net.WriteUInt(1, 3)
	net.WriteUInt(#data, 32)
	net.WriteData(data, #data)

	if specific then
		net.WriteString(specific)
	end

	net.Send(ply)
end

eProtect.hasPermission = function(ply, specific)
	return eProtect.config["permission"][ply:GetUserGroup()]
end

local punished = {}

eProtect.getData = function(specific)
	local data = file.Read("eprotect/data.json", "DATA")

	if !data then return end

	data = util.JSONToTable(data)

	if specific then
		data = data[specific]
	end

	for k,v in pairs(data) do
		eProtect.data[k] = v
	end

	return table.Copy(data)
end

eProtect.dataVerification = function()
	local data = eProtect.getData()
	data = data or {}

	data["general"] = data["general"] or {}

	for k,v in pairs(eProtect.BaseConfig) do
		if data["general"][k] then continue end
		data["general"][k] = v[1]
	end

	for k,v in pairs(eProtect.data) do
		if ignoreSaving[k] or k == "general" then continue end
		data[k] = v
	end

	file.CreateDir("eprotect")
	file.Write("eprotect/data.json", util.TableToJSON(data))

	eProtect.getData()
	eProtect.queueNetworking()
end

eProtect.saveData = function()
	file.CreateDir("eprotect")

	local data = table.Copy(eProtect.data)

	for k, v in pairs(data) do
		if ignoreSaving[k] then data[k] = nil end
	end

	file.Write("eprotect/data.json", util.TableToJSON(data))
end

eProtect.canNetwork = function(ply, netstring)
	if !IsValid(ply) or !ply:IsPlayer() then return end
	if (punished[ply:SteamID()] or eProtect.data.disabled[ply:SteamID()] or eProtect.data.general["disable-all-networking"]) and (netstring ~= "eP:Handeler") then return false end

	return true
end

eProtect.punish = function(ply, type, msg, duration)
	if eProtect.data.general["bypassgroup"][ply:GetUserGroup()] then return end
	msg = eProtect.config["prefix"]..msg

	punished[ply:SteamID()] = true

	slib.punish(ply, type, msg, duration)
end

eProtect.networkData = function(ply)
	if eProtect.queneData[ply:SteamID()] then
		for k,v in pairs(eProtect.queneData[ply:SteamID()]) do
			networkData(ply, eProtect.data[k], k)
			eProtect.queneData[ply:SteamID()][k] = nil
		end
	end
end

local function registerQuene(ply, specific)
	if specific then
		eProtect.queneData[ply:SteamID()] = eProtect.queneData[ply:SteamID()] and eProtect.queneData[ply:SteamID()] or {}
		eProtect.queneData[ply:SteamID()][specific] = true
	else
		for k,v in pairs(eProtect.data) do
			registerQuene(ply, k)
		end
	end
end

eProtect.queueNetworking = function(ply, specific)
	if ply then
		registerQuene(ply, specific)
	else
		for k,v in pairs(player.GetAll()) do
			if !IsValid(v) then continue end
			registerQuene(v, specific)
		end
	end
end

local screenshotRequested = {}
local idRequested = {}
local dataRequested = {}
local limitSC = {}

local function requestData(ply, target, type)
	local data
	
	if type == 1 then
		local sid = target:SteamID()
		if limitSC[sid] and CurTime() - limitSC[sid] < 10 then
			slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "sc-timeout", math.Round(10 - (CurTime() - limitSC[sid])), target:Nick()), ply)
		return end
		
		limitSC[sid] = CurTime()

		data = screenshotRequested
	elseif type == 2 then
		data = idRequested
	elseif type == 3 then
		data = dataRequested
	end

	if data[target] then return end

	data[target] = ply
	
	net.Start("eP:Handeler")
	net.WriteUInt(3, 3)
	net.WriteUInt(type, 2)
	net.WriteBool(false)
	net.Send(target)

	timer.Simple(10, function()
		if !target or !ply then return end
		if data[target] then
			data[target] = nil
			slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "sc-failed", target:Nick()), ply)
		end
	end)
end

local function correlateIPs(target, ply, returntbl)
	local correlated = {}
	local targetsid64 = target:SteamID64()

	local targetips = file.Read("eprotect/ips/"..targetsid64..".json", "DATA")
	targetips = util.JSONToTable(targetips)

	local files = file.Find("eprotect/ips/*", "DATA")
	for k,v in pairs(files) do
		local sid64 = string.gsub(v, ".json", "")
		
		if targetsid64 == sid64 then continue end

		local sid = util.SteamIDFrom64(sid64)

		local ips = file.Read("eprotect/ips/"..v, "DATA")
		ips = util.JSONToTable(ips)

		for ip, data in pairs(ips) do
			if targetips[ip] then
				correlated[sid] = ip
			end
		end
	end
	
	if ply and table.IsEmpty(correlated) then slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "no-correlation", target:Nick()), ply) return end
	
	if returntbl then return correlated end

	correlated = util.TableToJSON(correlated)
	correlated = util.Base64Encode(correlated)

	if ply then
		net.Start("eP:Handeler")
		net.WriteUInt(4,3)
		net.WriteUInt(target:EntIndex(), 14)
		net.WriteString(correlated)
		net.Send(ply)
	end
end

hook.Add("PlayerInitialSpawn", "eP:NetworkingQueuer", function(ply)
	eProtect.queueNetworking(ply)
	local sid = ply:SteamID()
	if punished[sid] then punished[sid] = nil end
end)

hook.Add("PlayerInitialSpawn", "eP:AutomaticIdentifier", function(ply)
	if eProtect.data.general["automatic-identifier"] then
		timer.Simple(3, function()
			if !IsValid(ply) or !ply:IsPlayer() then return end
			local correlatedIP = !table.IsEmpty(correlateIPs(ply, nil, true))
			local plysid64, ownerplysid64 = ply:SteamID64(), ply:OwnerSteamID64()
			local familyShare = ownerplysid64 ~= plysid64 and file.Find("eprotect/ips/"..ply:SteamID()..".json", "DATA")
			local detections = !familyShare and !correlatedIP

			if detections then
				detections = ""
				if correlatedIP then
					eProtect.logDetection(ply, "alt-detection", slib.getLang("eprotect", eProtect.config["language"], "correlated-ip"), 3)
					detections = slib.getLang("eprotect", eProtect.config["language"], "correlated-ip")
				end

				if familyShare then
					eProtect.logDetection(ply, "alt-detection", slib.getLang("eprotect", eProtect.config["language"], "family-share"), 3)
					detections = detections.." "..slib.getLang("eprotect", eProtect.config["language"], "and").." "..slib.getLang("eprotect", eProtect.config["language"], "family-share")
				end

				if detections ~= "" then
					for k, v in pairs(player.GetAll()) do
						if eProtect.data.general["notification-groups"][v:GetUserGroup()] then
							slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "auto-detected-alt", ply:Nick(), detections), ply)
						end
					end
				end
			end
		end)
	end
end)

hook.Add("PlayerSay", "eP:OpenMenu", function(ply, text, public)
	if (( string.lower( text ) == "!eprotect" )) then
		if !eProtect.hasPermission(ply) then
			return text
		end

		eProtect.networkData(ply)

		openMenu(ply)
		return ""
	end
end )

hook.Add("eP:PreNetworking", "eP:Restrictions", function(ply, netstring, len)
	if !eProtect.canNetwork(ply, netstring) then return false end
	if len >= 512000 then eProtect.logDetection(ply, "net-overflow", netstring, 1) eProtect.punish(ply, 1, slib.getLang("eprotect", eProtect.config["language"], "kick-net-overflow")) return false end	
end)

hook.Add("eP:PreHTTP", "eP:PreventBlockedHTTP", function(url)
	if eProtect.data.general["httpfocusedurls"] then
		return eProtect.data.general["httpfocusedurlsisblacklist"] == !tobool(eProtect.data.general["httpfocusedurls"][url])
	end
end)

timer.Create("eP:SaveCache", eProtect.config["process-save-queue"], 0, function()
	if !eProtect.saveQueue then return end
	eProtect.saveData()

	eProtect.saveQueue = nil
end)

net.Receive("eP:Handeler", function(len, ply)
	local gateway = net.ReadBit()
	local action = net.ReadUInt(2)

	if tobool(gateway) then

		if !eProtect.hasPermission(ply) then return end

		if action == 1 then
			local specific = net.ReadUInt(3)
			local strings = {}
	
			for i=1,specific do
				strings[i] = net.ReadString()
			end
	
			local statement = net.ReadUInt(2)
			local data
	
			if statement == 1 then
				data = net.ReadBool()
			elseif statement == 2 then
				data = net.ReadInt(32)
			elseif statement == 3 then
				local chunk = net.ReadUInt(32)
				data = net.ReadData(chunk)
				
				data = util.Decompress(data)
				data = util.JSONToTable(data)
			end
			
			local finaldestination = eProtect.data
			for k,v in ipairs(strings) do
				finaldestination = finaldestination[v]
				if k >= (#strings - 1) then break end
			end
	
			finaldestination[strings[#strings]] = data
	
			eProtect.saveQueue = true
			eProtect.queueNetworking(nil, strings[1])
		elseif action == 2 then
			local subaction = net.ReadUInt(3)
			local target = net.ReadUInt(14)
	
			target = Entity(target)
	
			if !IsValid(target) or !target:IsPlayer() then slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "invalid-player"), ply) return end
			
			local sid = target:SteamID()
	
			if subaction == 1 then
				eProtect.data.disabled[sid] = net.ReadBool()
				eProtect.queueNetworking(nil, "disabled")
			elseif subaction == 2 then
				requestData(ply, target, net.ReadUInt(2))
			elseif subaction == 3 then
				correlateIPs(target, ply)
			elseif subaction == 4 then
				local sid64 = target:SteamID64()
				local ownersid64 = target:OwnerSteamID64()

				if sid64 == ownersid64 then
					slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "no-family-share", target:Nick()), ply)
				else
					slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "has-family-share", target:Nick(), ownersid64), ply)
				end
			end
		end
	else
		if action == 1 then
			local subaction = net.ReadUInt(2)

			local data

			if subaction == 1 then
				data = screenshotRequested
			elseif subaction == 2 then
				data = idRequested
			elseif subaction == 3 then
				data = dataRequested
			end

			if !data[ply] then eProtect.punish(ply, 1, slib.getLang("eprotect", eProtect.config["language"], "kick-malicious-intent")) return end
			local target = data[ply]
			data[ply] = nil

			local id = net.ReadString()

			if !id then
				eProtect.punish(ply, 1, slib.getLang("eprotect", eProtect.config["language"], "kick-malicious-intent"))
			return end

			net.Start("eP:Handeler")
			net.WriteUInt(3, 3)
			net.WriteUInt(subaction, 2)
			net.WriteUInt(ply:EntIndex(), 14)
			net.WriteBool(true)
			net.WriteString(id)

			net.Send(target)
		elseif action == 2 then
			local menu = net.ReadUInt(2)
			local menus = {
				[1] = "Loki",
				[2] = "Exploit City"
			}

			eProtect.logDetection(ply, "exploit-menu", menus[menu], 2)
			eProtect.punish(ply, 2, slib.getLang("eprotect", eProtect.config["language"], "banned-exploit-menu"))
		end
	end
end)

eProtect.dataVerification()