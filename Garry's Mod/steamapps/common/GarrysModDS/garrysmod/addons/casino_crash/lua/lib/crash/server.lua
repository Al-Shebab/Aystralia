util.AddNetworkString'Crash_AddLocation'
util.AddNetworkString'Casino_Crash.Receive'
util.AddNetworkString'Casino_Crash.BroadcastValue'
util.AddNetworkString'Casino_Crash.BroadcastPlayers'
util.AddNetworkString'Casino_Crash.Notify'
util.AddNetworkString'Casino_Crash.LocationTable'
Casino_Crash.BetTable = {}

function Casino_Crash.AddCash(_Player, _Amount)
	local __type = string.lower(Casino_Crash.Config.GiveCashType)
	local __amount = math.Round(tonumber(_Amount)) --just in case
	if not math.IsFinite(__amount) then return end

	if __type == "darkrp" then
		_Player:addMoney(__amount)

		return
	elseif __type == "pointshop" then
		_Player:PS_GivePoints(__amount)

		return
	elseif isfunction(Casino_Crash.Config.GiveCashType) then
		Casino_Crash.Config.GiveCashType(__amount)

		return
	else
		_Player:AddMoney(__amount)

		return
	end
end

Casino_Crash.CanBet = true

function Casino_Crash.StartNew()
	Casino_Crash.CanBet = true
end

local start = 0

function Casino_Crash.CreateHook()
	if Casino_Crash.Config.OnlyRunWithPlayers and table.Count(Casino_Crash.BetTable) <= 0 then return end
	start = 0
	local Delay = CurTime()
	Casino_Crash.CurVal = 0

	hook.Add("Think", "Casino_Crash.Think", function()
		if Delay > CurTime() then return end
		Delay = CurTime() + Casino_Crash.Config.Tick
		Casino_Crash.CanBet = false
		start = math.Round(math.Clamp(start + Casino_Crash.Config.Interval, Casino_Crash.Config.MinMultiplier, Casino_Crash.Config.MaxMultiplier), 2)

		for k, v in pairs(Casino_Crash.BetTable) do
			local ply = player.GetBySteamID(k)
			if not ply or not ply:IsValid() then continue end --they left or something??

			if v[2] <= start then
				local __amount = (v[1] * v[2]) or 0
				Casino_Crash.AddCash(ply, __amount)

				if v[2] == 1 then
					net.Start("Casino_Crash.Notify")
					net.WriteString("You broke even! $0 lost/earned")
					net.Send(ply)
				elseif (__amount) > 0 then
					net.Start("Casino_Crash.Notify")
					net.WriteString("You've won $" .. string.Comma(__amount) .. ". congrats!")
					net.Send(ply)
				end

				Casino_Crash.BetTable[ k ] = nil
			end
		end

		if math.random(1, Casino_Crash.Config.Probability) == Casino_Crash.Config.Probability or Casino_Crash.CurVal == Casino_Crash.Config.MaxMultiplier then
			Casino_Crash.CanBet = true

			timer.Create("Casino_Crash.StartGame", Casino_Crash.Config.WaitTimer, 1, function()
				Casino_Crash.CreateHook()
			end)

			net.Start("Casino_Crash.BroadcastValue")
			net.WriteString("CRASHED @ " .. start)
			net.WriteDouble(timer.TimeLeft("Casino_Crash.StartGame"))
			net.Broadcast()

			for k, v in pairs(player.GetAll()) do
				v:SetNWBool("Casino_Crash.IsBetting", false)
			end

			for k, v in pairs(Casino_Crash.BetTable) do
				local ply = player.GetBySteamID(k)
				if not ply or not ply:IsValid() then continue end --they left or something??

				if v[2] > start then
					net.Start("Casino_Crash.Notify")
					net.WriteString("Sorry, You've lost $" .. string.Comma(v[1]) .. ".")
					net.Send(player.GetBySteamID(k))
				end

				Casino_Crash.BetTable[ k ] = nil
			end

			Casino_Crash.BetTable = {}
			hook.Remove("Think", "Casino_Crash.Think")

			return
		end

		net.Start("Casino_Crash.BroadcastValue")
		net.WriteString(start) --I know I should be using WriteInt, but there is a chance this will pass the "CRASHED" string :/
		net.WriteDouble(timer.TimeLeft("Casino_Crash.StartGame") or 0)
		net.Broadcast()
		Casino_Crash.CurVal = start
	end)
end

net.Receive("Casino_Crash.Receive", function(_Length, _Player)
	local _Amount = net.ReadInt(32)
	local _Auto = net.ReadDouble()

	if Casino_Crash.Config.AllowManualCashout and not Casino_Crash.CanBet and start > 0 and Casino_Crash.BetTable[_Player:SteamID()] then
		--Early cashout
		_Player:SetNWBool("Casino_Crash.IsBetting", false)
		local _Original = Casino_Crash.BetTable[_Player:SteamID()][1]
		local _Amount = math.Round(start * _Original)

		if _Amount > 0 then
			Casino_Crash.BetTable[_Player:SteamID()] = nil
			Casino_Crash.AddCash(_Player, _Amount)
			net.Start("Casino_Crash.Notify")
			net.WriteString("You cashed out early and received $" .. string.Comma(_Amount) .. " ($" .. string.Comma(_Amount - _Original) .. " profit)")
			net.Send(_Player)
			net.Start("Casino_Crash.BroadcastPlayers")
			net.WriteTable(Casino_Crash.BetTable)
			net.Broadcast()

			return
		end
	end

	if Casino_Crash.BetTable[_Player:SteamID()] and #Casino_Crash.BetTable[_Player:SteamID()] > 0 then
		net.Start("Casino_Crash.Notify")
		net.WriteString("You have already placed a bet!")
		net.Send(_Player)

		return
	end

	if not math.IsFinite(_Amount) then return end
	--User tried to bet a number that isn't finite!
	if not Casino_Crash.CanBet then return end

	if not Casino_Crash.CanAfford(_Player, _Amount) then
		net.Start("Casino_Crash.Notify")
		net.WriteString("You cannot afford this!")
		net.Send( _Player )

		return
	end

	Casino_Crash.AddCash(_Player, -_Amount)
	local _Bet = 0

	if Casino_Crash.BetTable[_Player:SteamID()] then
		_Bet = Casino_Crash.BetTable[_Player:SteamID()][1]
	end

	Casino_Crash.BetTable[_Player:SteamID()] = {math.Clamp(_Amount, Casino_Crash.Config.MinCash, Casino_Crash.Config.MaxCash), _Auto}
	_Player:SetNWBool("Casino_Crash.IsBetting", true)

	if not timer.Exists("Casino_Crash.StartGame") then
		Casino_Crash.StartNew()

		timer.Create("Casino_Crash.StartGame", Casino_Crash.Config.WaitTimer, 1, function()
			Casino_Crash.CreateHook()
		end)
	end

	net.Start("Casino_Crash.BroadcastPlayers")
	net.WriteTable(Casino_Crash.BetTable)
	net.Broadcast()
end)

function Casino_Crash.RemoveScreen(_Vector, _NoFetch)
	if not isvector(_Vector) or _Vector == nil then return end
	local __locations = file.Read("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", "DATA")
	local __table = util.JSONToTable(__locations)

	for k, v in pairs(__table) do
		if v.vector == _Vector then
			__table[k] = nil
		end
	end

	file.Write("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(__table))

	if not _NoFetch then
		Casino_Crash.FetchRenderingTable()
	end
end

function Casino_Crash.FetchRenderingTable(_Player)
	local __table = util.JSONToTable(file.Read("crash_casino/" .. string.lower(game.GetMap()) .. ".txt") or "[]")

	if Casino_Crash.Entities then
		for k, v in pairs(Casino_Crash.Entities) do
			if v:IsValid() then
				v:Remove()
			end

			v = nil
		end
	end

	Casino_Crash.Entities = {}
	local __entities = Casino_Crash.Entities

	for k, v in pairs(__table) do
		__entities[k] = ents.Create("sent_crash")
		__entities[k]:SetPos(v.vector)
		__entities[k]:SetAngles(v.angle + Angle(90, 0, 0))
		__entities[k]:Spawn()
		__entities[k]:Activate()
		__entities[k]:SetModelScale(v.scale)
		__entities[k].Key = k

		if _Player and _Player:IsValid() then
			undo.Create("prop")
			undo.AddEntity(__entities[k])

			undo.AddFunction(function(tab, arg2)
				if not tab.Entities[1] or not tab.Entities[1]:IsValid() then return end
				Casino_Crash.RemoveScreen(tab.Entities[1]:GetPos(), true)
			end, 556)

			undo.SetPlayer(_Player)
			undo.Finish()
		end
	end
end

hook.Add("OnPhysgunFreeze", "Casino_Crash.OnPhysgunFreeze.SavePanels", function(_Weapon, _Phys, _Entity, _Player)
	if _Player:IsSuperAdmin() and _Entity.Key and _Entity:IsValid() and _Entity:GetClass() == "sent_crash" then
		local __table = util.JSONToTable(file.Read("crash_casino/" .. string.lower(game.GetMap()) .. ".txt") or "[]")

		if __table[_Entity.Key] then
			__table[_Entity.Key] = {
				["vector"] = _Entity:GetPos(),
				["angle"] = _Entity:GetAngles() - Angle(90, 0, 0),
				["scale"] = _Entity:GetModelScale()
			}

			net.Start('Casino_Crash.Notify')
			net.WriteString('Panel update saved!')
			net.Send(_Player)
		end

		file.Write("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(__table or "[]"))
		Casino_Crash.FetchRenderingTable()

		return true
	end
end)

hook.Add("InitPostEntity", "Casino_Crash.InitPostEntity.SetupEntities", function()
	Casino_Crash.FetchRenderingTable()
end)