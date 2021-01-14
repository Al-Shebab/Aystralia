if not SERVER then return end
zrmine = zrmine or {}
zrmine.data = zrmine.data or {}
zrmine.f = zrmine.f or {}

// Used to set data depending on config option
function zrmine.data.SetData(ply)
	if zrmine.config.Pickaxe_UseDB then
		ply:SetPData("zrmine/XP/database", util.TableToJSON(ply.zrms))
	else

		if not file.Exists("zrms", "DATA") then
			file.CreateDir("zrms")
		end

		if not file.Exists("zrms/playerdata", "DATA") then
			file.CreateDir("zrms/playerdata")
		end

		file.Write("zrms/playerdata/" ..  tostring(ply:SteamID64()) .. ".txt", util.TableToJSON(ply.zrms,true))
	end

	zrmine.f.Debug("Player data saved!")
end

// Used to get data depending on config option
function zrmine.data.GetData(ply)
	local plyData

	if zrmine.config.Pickaxe_UseDB then
		plyData = ply:GetPData("zrmine/XP/database", nil)

		plyData = zrmine.data.PlayerVar_Authenticater(plyData,ply) //03

	else
		if file.Exists("zrms/playerdata/" .. tostring(ply:SteamID64()) .. ".txt", "DATA") then
			plyData = file.Read("zrms/playerdata/" .. tostring(ply:SteamID64()) .. ".txt", "DATA")

			plyData = zrmine.data.PlayerVar_Authenticater(plyData,ply)
		else
			zrmine.f.Debug("No Pickaxe data found on file, Searching on internal Database ...")
			plyData = ply:GetPData("zrmine/XP/database", nil)

			if plyData then
				zrmine.f.Debug("Pickaxe Data found on internal Database!")
			end

			plyData = zrmine.data.PlayerVar_Authenticater(plyData,ply)

		end
	end

	return plyData
end

function zrmine.data.PlayerVar_Authenticater(data,ply)
	local rData

	if data == nil or isstring(data) == false then

		if ply.zrms == nil then
			rData = {
				xp = 0,
				lvl = 0
			}
		else
			rData = ply.zrms
		end
	else
		rData = util.JSONToTable(data) //04
	end

	return rData
end

// Checks if the player has the zrms level structure
function zrmine.data.PlayerVarCheck(ply)
	if IsValid(ply) and ply.zrms == nil then
		zrmine.data.SetupPlayerVar(ply)
	end
end

// Creates or Loads the zrms Level structure for the player
function zrmine.data.SetupPlayerVar(ply)
	if (IsValid(ply)) then

		local plyData = zrmine.data.GetData(ply) //02

		ply.zrms = {}

		if plyData then

			zrmine.f.Debug("Player Data found, Loading Vars")
			ply.zrms = plyData
		else

			zrmine.f.Debug("No Player data found, Creating Vars")
			ply.zrms = {
				xp = 0,
				lvl = 0
			}
		end

		zrmine.data.DataChanged(ply)
	end
end

function zrmine.data.DataChanged(ply)
	if not ply.zrms_DataChanged then
		ply.zrms_DataChanged = true
		zrmine.f.Debug("Player Data Changed.")
	end
end

function zrmine.data.SavePlayerData()
	zrmine.f.Timer_Remove("zrmine_XP_saver")
	zrmine.f.Timer_Create("zrmine_XP_saver", zrmine.config.Pickaxe_LvlSys_SaveTime, 0, function()
		zrmine.f.Debug("Player Data Autosave.")

		for k, v in pairs(zrmine.players) do
			if (IsValid(v) and v.zrms_DataChanged) then
				zrmine.data.SetData(v)
				v.zrms_DataChanged = false
			end
		end
	end)
end
hook.Add("InitPostEntity", "a_zrmine_SavePlayerData_id", zrmine.data.SavePlayerData)



function zrmine.data.PlayerDisconnect(ply)
	if (ply.zrms_DataChanged) then
		zrmine.f.Debug(ply:Nick() .. " disconnected , Pickaxe Data getting saved...")
		zrmine.data.SetData(ply)
	end
end
hook.Add("PlayerDisconnected", "a_zrmine_playerdisconnect_id", zrmine.data.PlayerDisconnect)



function zrmine.data.PlayerSpawn(ply)
	local timerID = "Steam_id_delay_zrms" .. ply:EntIndex()
	zrmine.f.Timer_Remove(timerID)

	zrmine.f.Timer_Create(timerID, zrmine.config.Pickaxe_LvlSys_Init_LoadTime, 1, function()
		zrmine.f.Debug("Player Data Autosave.")
		zrmine.f.Timer_Remove(timerID)
		zrmine.data.SetupPlayerVar(ply)
	end)
end




// The LevelSystem PlayerData
util.AddNetworkString("zrmine_LvlSysData_open_net")
util.AddNetworkString("zrmine_LvlSysData_request_net")
util.AddNetworkString("zrmine_LvlSysData_send_net")
util.AddNetworkString("zrmine_LvlSysData_update_net")

// This sends the level data to the admin
net.Receive("zrmine_LvlSysData_request_net", function(len, ply)
	if zrmine.f.Player_Timeout(ply) then return end

	local id = net.ReadString()
	local r_ply = player.GetBySteamID( id )
	if zrmine.f.IsAdmin(ply) and IsValid(r_ply) and r_ply:IsPlayer() then

		local newData = {}
		newData.id = id

		if r_ply.zrms and r_ply.zrms.xp and r_ply.zrms.lvl then
			newData.xp = r_ply.zrms.xp
			newData.lvl = r_ply.zrms.lvl

		else

			local _Data = zrmine.data.GetData(r_ply)

			if _Data and istable(_Data) then
				newData.xp = _Data.xp or 0
				newData.lvl = _Data.lvl or 0
			else
				newData.xp = 0
				newData.lvl = 0
			end
		end

		newData = util.TableToJSON(newData)
		local boardCompressed = util.Compress(newData)
		net.Start("zrmine_LvlSysData_send_net")
		net.WriteUInt(#boardCompressed, 16)
		net.WriteData(boardCompressed, #boardCompressed)
		net.Send(ply)
	end
end)

net.Receive("zrmine_LvlSysData_update_net", function(len, ply)
	if zrmine.f.Player_Timeout(ply) then return end

	local dataLength = net.ReadUInt(16)
	local boardDecompressed = util.Decompress(net.ReadData(dataLength))
	local adata = util.JSONToTable(boardDecompressed)

	if zrmine.f.IsAdmin(ply) then
		local _ply = player.GetBySteamID(adata.steamid)

		if IsValid(_ply) and _ply:IsPlayer() then
			_ply.zrms = {
				xp = adata.xp,
				lvl = math.Clamp(adata.lvl, 0, table.Count(zrmine.config.Pickaxe_Lvl) - 1)
			}

			zrmine.lvlsys.LevelUpCheck(ply)

			zrmine.data.SetData(_ply)


			zrmine.f.Notify(_ply, "Someone updated your Pickaxe Data!", 0)
			zrmine.f.Notify(ply, "You updated " .. _ply:Nick() .. " Pickaxe Data!", 0)
		end
	end
end)
