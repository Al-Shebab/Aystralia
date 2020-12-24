function scaleX(sw)
	return ScrW() * ((sw or 0) / 1920)
end

function scaleH(sh)
	return ScrH() * ((sh or 0) / 1080)
end

Casino_Crash.CurVal = 0

if Casino_Crash["DFrame"] then
	Casino_Crash["DFrame"]:Remove()
	Casino_Crash["DFrame"] = nil
end

function Casino_Crash.HasCrashed()
	if Casino_Crash.CurVal and string.find(Casino_Crash.CurVal, "CRASHED") then return true end

	return false
end

function Casino_Crash.DistanceCheck(_Vec)
	return LocalPlayer():GetPos():Distance(_Vec or Vector(0, 0, 0)) < Casino_Crash.Config.RenderDistance
end

net.Receive("Casino_Crash.BroadcastPlayers", function()
	local __table = net.ReadTable()

	--This pretty much relies on having a valid VGUI panel, this is for a "just-in-case" basis...
	if not Casino_Crash["DListView"] or not Casino_Crash["DListView"]:IsValid() then return end

	Casino_Crash["DListView"]:Clear( )
	
	for k, v in pairs(__table) do
		local ply = player.GetBySteamID(k)
		if ply == false then continue end
		
		if ply:IsValid() then
			Casino_Crash["DListView"]:AddLine(ply:Nick(), v[1], v[2] .. "x", "+$0")
		end
	end

	if #Casino_Crash["DListView"]:GetLines() <= 0 then
		timer.Create("Timers.Casino_Crash.Buffer", Casino_Crash.Config.WaitTimer, 1, function() end)
	end

	for k, v in pairs(Casino_Crash["DListView"]:GetLines()) do
		for i = 1, 4 do
			v.Columns[i]:SetFont("ManualButton")
			v.Columns[i]:SetColor(Color(255, 172, 38))

			v.Columns[i].Paint = function(self, w, h)
				local _Auto = tonumber(string.sub(v.Columns[3]:GetText(), 1, string.len(v.Columns[3]:GetText()) - 1)) or 0

				if not Casino_Crash.HasCrashed() and Casino_Crash.CurVal >= _Auto then
					v.Columns[3]:SetColor(Color(0, 220, 0, 255))
				end

				if Casino_Crash.CurVal and not Casino_Crash.HasCrashed() and Casino_Crash.CurVal ~= 0 and _Auto >= (Casino_Crash.CurVal or 0) then
					local _RawText = v.Columns[4]:GetText()
					local _Bet = v.Columns[2]:GetText()
					local _Profit = string.sub(_RawText, 3, string.len(_RawText))

					if tonumber(Casino_Crash.CurVal) then
						local _newVal = _Bet * Casino_Crash.CurVal

						if Casino_Crash.CurVal then
							if _Bet * Casino_Crash.CurVal >= tonumber(_Bet) then
								v.Columns[4]:SetColor(Color(0, 220, 0, 255))
								v.Columns[4]:SetText("+$" .. math.Round(math.abs(_Bet - _newVal)))
							else
								v.Columns[4]:SetColor(Color(220, 0, 0, 255))
								v.Columns[4]:SetText("-$" .. math.Round(math.abs(_Bet - _newVal)))
							end
						end
					end
				end

				draw.RoundedBox(0, 0, h - 0.6, w, 1, Color(100, 100, 100))
			end
		end
	end
end)

net.Receive("Casino_Crash.Notify", function()
	notification.AddLegacy(net.ReadString(), NOTIFY_HINT, 10)
end)

net.Receive("Casino_Crash.BroadcastValue", function()
	if not Casino_Crash or not Casino_Crash["BetButton"] or not Casino_Crash.CurVal then return end
	Casino_Crash["BetButton"].Disabled = true
	local _str = net.ReadString()

	if string.find(_str, "CRASHED") then
		Casino_Crash["DListView"]:Clear()
		Casino_Crash["BetButton"].Disabled = false
		local _TimeWaiting = net.ReadDouble()
		timer.Create("Timers.Casino_Crash.Buffer", _TimeWaiting, 1, function() end)
		Casino_Crash.CurVal = _str
	else
		Casino_Crash.CurVal = tonumber(_str) + Casino_Crash.Config.Interval
	end
end)

local HSV_Change = HSVToColor((0 * 50) % 360, 1, 1)

local Slope = {
	{
		x = scaleX(10),
		y = scaleH(320)
	},
	{
		x = scaleX(635),
		y = scaleH(20)
	},
	{
		x = scaleX(635),
		y = scaleH(320)
	}
}

local HelpLerp = 0

function Casino_Crash.CreatePanel(_Vector)
	local _SelectedLang = Casino_Crash.Config.Translations[Casino_Crash.Config.Language]
	if Casino_Crash["DFrame"] and Casino_Crash["DFrame"]:IsValid() then return Casino_Crash["DFrame"] end
	Casino_Crash["DFrame"] = vgui.Create("DFrame")
	Casino_Crash["DFrame"]:SetSize(scaleX(1300), scaleH(730))
	Casino_Crash["DFrame"]:ShowCloseButton(false)
	Casino_Crash["DFrame"]:SetTitle("")
	Casino_Crash["DFrame"]:SetVisible(false)
	--Casino_Crash["DFrame"]:MakePopup()
	--Casino_Crash["DFrame"]:Center()
	Casino_Crash["DFrame"]:SetDraggable(false)

	if not Casino_Crash.HasCrashed() then
		HSV_Change = HSVToColor((Casino_Crash.CurVal or 0 * 50) % 360, 1, 1)
	end

	Casino_Crash["DFrame"].Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(22, 30, 40, 255))
		surface.SetDrawColor(255, 172, 39)
		surface.DrawOutlinedRect(scaleX(10), scaleH(350), scaleX(625), scaleH(370))
		--Downscale rendering so the graph + it's text render in a smaller window.
		w = scaleX(625)
		h = scaleH(300)

		if tonumber(Casino_Crash.CurVal) and Casino_Crash.CurVal ~= 0 then
			HSV_Change = util.LerpColor(0.03, 0.03, 0.03, HSV_Change, HSVToColor((Casino_Crash.CurVal * 50) % 360, 1, 1))
			surface.SetDrawColor(HSV_Change)
			draw.NoTexture()
			surface.DrawPoly(Slope)
		end

		if Casino_Crash.CurVal ~= 0 then
			local __str = Casino_Crash.CurVal

			if tonumber(__str) then
				__str = math.Round(Casino_Crash.CurVal, 2)
			end

			draw.SimpleText(__str .. "x", "MainText", w / 2, h / 2 + 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if Casino_Crash.HasCrashed() then
				if timer.Exists("Timers.Casino_Crash.Buffer") then
					draw.SimpleText(_SelectedLang["vgui.casinocrash.roundstartsin"] .. math.Round(timer.TimeLeft("Timers.Casino_Crash.Buffer")) .. _SelectedLang["vgui.casinocrash.seconds"], "MainText2", w / 2, h / 2 + scaleH(100), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) --[[Color( 22, 30, 40 )]]
				elseif Casino_Crash.Config.OnlyRunWithPlayers then
					draw.SimpleText("#vgui.casinocrash.waitingforplayers", "MainText2", w / 2, h / 2 + scaleX(100), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end

		draw.RoundedBox(0, math.Clamp(gui.MouseX() - 3, 0, 1300), math.Clamp(gui.MouseY() - 3, 0, 760), 6, 6, Color(220, 220, 220, 255))
	end

	local Frame = Casino_Crash["DFrame"]
	Frame:ParentToHUD()
	Casino_Crash["HelpPanel"] = vgui.Create("DPanel", Frame)
	Casino_Crash["HelpPanel"]:SetPos(scaleX(5), scaleH(5))
	Casino_Crash["HelpPanel"]:SetSize(scaleX(32), scaleH(32))
	Casino_Crash["HelpPanel"].Hovering = false

	Casino_Crash["HelpPanel"].Paint = function(self, w, h)
		surface.SetDrawColor(255, 172, 39, 150)
		surface.DrawOutlinedRect(0, 0, w, h)

		if HelpLerp > .95 then
			draw.SimpleText("#vgui.casinocrash.howtoplay", "ManualButton", 40, 5, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#vgui.casinocrash.rule1", "ManualButton", 10, 32, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#vgui.casinocrash.rule2", "ManualButton", 10, 54, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#vgui.casinocrash.rule3", "ManualButton", 10, 74, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#vgui.casinocrash.rule4", "ManualButton", 10, 94, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#vgui.casinocrash.rule5", "ManualButton", 10, 114, Color(220, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

	Casino_Crash["HelpButton"] = vgui.Create("DButton", Frame)
	Casino_Crash["HelpButton"]:SetPos(scaleX(5), scaleH(5))
	Casino_Crash["HelpButton"]:SetSize(scaleX(32), scaleH(32))
	Casino_Crash["HelpButton"]:SetText("")

	Casino_Crash["HelpButton"].Paint = function(self, w, h)
		surface.SetDrawColor(255, 172, 39, 150)
		--surface.DrawOutlinedRect(0, 0, w, h)
		draw.SimpleText("?", "ManualButton", w / 2, h / 2, Color(255, 172, 39), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if Casino_Crash["HelpPanel"].Hovering then
			HelpLerp = Lerp(FrameTime() * 5, HelpLerp, 1)
		else
			HelpLerp = Lerp(FrameTime() * 10, HelpLerp, 0)
		end

		Casino_Crash["HelpPanel"]:SetSize(scaleX(490 * HelpLerp), scaleH(140 * HelpLerp))
	end

	Casino_Crash["HelpButton"].OnCursorEntered = function(self, w, h)
		Casino_Crash["HelpPanel"].Hovering = true
	end

	Casino_Crash["HelpButton"].OnCursorExited = function(self, w, h)
		Casino_Crash["HelpPanel"].Hovering = false
	end

	Casino_Crash["BetButton"] = vgui.Create("DButton", Frame)
	Casino_Crash["BetButton"]:SetPos(scaleX(20), scaleH(360))
	Casino_Crash["BetButton"]:SetSize(scaleX(605), scaleH(40))
	Casino_Crash["BetButton"]:SetText("")
	Casino_Crash["BetButton"].Text = string.upper(_SelectedLang["vgui.casinocrash.placebet"])
	Casino_Crash["BetButton"].Color = Color(255, 172, 32)

	Casino_Crash["BetButton"].Paint = function(self, w, h)
		if not self:IsValid() then return end

		if self.Disabled then
			Casino_Crash["BetButton"].Text = "#vgui.casinocrash.roundwaiting"

			local waiting_col = Color(76,175,80)

			if not Casino_Crash.Config.AllowManualCashout then
				waiting_col = Color(99, 99, 99)
				Casino_Crash["BetButton"].Text = "#vgui.casinocrash.roundendwait"
			end

			self.Color = util.LerpColor(0.03, 0.03, 0.03, self.Color, waiting_col)
		elseif (not self.Disabled and LocalPlayer():GetNWBool("Casino_Crash.IsBetting")) then
			self.Color = util.LerpColor(0.03, 0.03, 0.03, self.Color, Color(99, 99, 99))
			Casino_Crash["BetButton"].Text = "#vgui.casinocrash.startwaiting"
		else
			Casino_Crash["BetButton"].Text = string.upper(_SelectedLang["vgui.casinocrash.placebet"])
			self.Color = util.LerpColor(0.03, 0.03, 0.03, self.Color, Color(255, 172, 32))
		end

		draw.RoundedBox(0, 0, 0, w, h, self.Color)
		draw.SimpleText(self.Text, "ButtonText", w / 2, h / 2, Color(22, 30, 40), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	Casino_Crash["BetButton"].DoClick = function()
		local _Value = Frame.Wang:GetValue()
		if _Value < Casino_Crash.Config.MinCash or _Value > Casino_Crash.Config.MaxCash then return end

		net.Start("Casino_Crash.Receive")
		net.WriteInt(_Value, 32)
		net.WriteDouble(Casino_Crash["CashoutWang"].Value)
		net.SendToServer()
	end

	local manual = vgui.Create("DButton", Frame)
	manual:SetPos(scaleX(20), scaleH(405))
	manual:SetSize(scaleX(100), scaleH(30))
	manual:SetText("")

	manual.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, h - 2, w, 2, Color(255, 172, 39))
		draw.SimpleText("MANUAL", "ManualButton", w / 2, h / 2, Color(255, 174, 39), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	manual.OnCursorEntered = function(self) end
	manual.OnCursorExited = function(self) end
	local Clear = vgui.Create("DButton", Frame)
	Clear:SetPos(scaleX(20), scaleH(450))
	Clear:SetSize(scaleX(80), scaleH(30))
	Clear:SetText("")

	Clear.Paint = function(self, w, h)
		surface.DrawOutlinedRect(0, 0, w, h)
		draw.SimpleText(_SelectedLang["vgui.casinocrash.default"], "ManualButton", w / 2, h / 2, Color(255, 174, 39), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	Clear.DoClick = function(self)
		Frame.Wang:SetValue(0)
		Frame.Wang.Value = 10
	end

	Frame.Wang = vgui.Create("DNumberWang", Frame)
	Frame.Wang:SetPos(scaleX(18), scaleH(512))
	Frame.Wang:SetSize(scaleX(256), scaleH(40))
	Frame.Wang:SetDecimals(0)
	Frame.Wang:SetFont("ManualButton")

	Frame.Wang.Paint = function(self, w, h)
		surface.SetDrawColor(255, 174, 39)
		surface.DrawOutlinedRect(0, 0, w, h)
		self:DrawTextEntryText(Color(220, 220, 220), Color(30, 130, 255), Color(220, 220, 220))
	end

	Frame.Wang.GetValue = function(self) return self.Value end

	Frame.Wang.OnValueChanged = function(self, value)
		Frame.Wang:SetText(_SelectedLang["vgui.casinocrash.currency"] .. string.Comma(value))
	end

	Frame.Wang.Value = 10
	Frame.Wang:SetValue(10)
	local Buttons = {}
	Buttons.Amounts = {10, 100, 1000, 5000, 10000, 25000}

	for k, v in pairs(Buttons.Amounts) do
		Buttons[v] = vgui.Create("DButton", Frame)
		Buttons[v]:SetPos(scaleX(110 + 80 * (k - 1)), scaleH(450))
		Buttons[v]:SetSize(scaleX(70), scaleH(30))
		Buttons[v]:SetText("")
		Buttons[v].Fade = 0
		Buttons[v].TextCol = Color(255, 174, 39)

		Buttons[v].Paint = function(self, w, h)
			if self.Entered then
				self.Fade = Lerp(FrameTime() * 8, self.Fade, 255)
				self.TextCol = Color(22, 30, 40)
			else
				self.Fade = Lerp(FrameTime() * 8, self.Fade, 0)
				self.TextCol = Color(255, 174, 39)
			end

			draw.RoundedBox(0, 0, 0, w, h, Color(255, 174, 39, self.Fade))
			local str = ""

			if isnumber(v) then
				str = "+" .. string.Comma(v)
			else
				str = v
			end

			draw.SimpleText(str, "ManualButton", w / 2, h / 2, self.TextCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 174, 39)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		Buttons[v].DoClick = function(self)
			local _NewVal = math.Clamp(Frame.Wang.Value + v, Casino_Crash.Config.MinCash, Casino_Crash.Config.MaxCash)
			Frame.Wang.Value = _NewVal
			Frame.Wang:SetValue(_NewVal)
		end

		Buttons[v].OnCursorEntered = function(self, w, h)
			self.Entered = true
		end

		Buttons[v].OnCursorExited = function(self, w, h)
			self.Entered = false
		end
	end

	Casino_Crash["BetLabel"] = vgui.Create("DLabel", Frame)
	Casino_Crash["BetLabel"]:SetText("BET:")
	Casino_Crash["BetLabel"]:SetColor(Color(255, 174, 39))
	Casino_Crash["BetLabel"]:SetFont("ManualButton")
	Casino_Crash["BetLabel"]:SetPos(scaleX(20), scaleH(490))
	Casino_Crash["BetLabel"]:SizeToContents()
	Frame.Wang:SetMax(Casino_Crash.Config.MaxCash)
	Frame.Wang:SetMin(Casino_Crash.Config.MinCash)
	Casino_Crash["Currency"] = vgui.Create("DButton", Frame)
	Casino_Crash["Currency"]:SetPos(scaleX(270), scaleH(512))
	Casino_Crash["Currency"]:SetSize(scaleX(100), scaleH(40))
	Casino_Crash["Currency"]:SetText("")
	Casino_Crash["Currency"].Text = _SelectedLang["vgui.casinocrash.currency"]

	Casino_Crash["Currency"].Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 172, 39))
		draw.SimpleText(self.Text, "ButtonText2", w / 2, h / 2, Color(22, 30, 40), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	Casino_Crash["DListView"] = vgui.Create("DListView", Frame)
	Casino_Crash["DListView"]:SetSize(scaleX(635), scaleH(710))
	Casino_Crash["DListView"]:SetPos(scaleX(655), scaleH(10))
	Casino_Crash["DListView"]:SetMultiSelect(false)
	Casino_Crash["DListView"]:SetDataHeight(20)
	Casino_Crash.Columns = {}
	Casino_Crash.Columns[1] = Casino_Crash["DListView"]:AddColumn("#vgui.casinocrash.player")
	Casino_Crash.Columns[2] = Casino_Crash["DListView"]:AddColumn("#vgui.casinocrash.bet")
	Casino_Crash.Columns[3] = Casino_Crash["DListView"]:AddColumn("#vgui.casinocrash.auto")
	Casino_Crash.Columns[4] = Casino_Crash["DListView"]:AddColumn("#vgui.casinocrash.profit")
	Casino_Crash["DListView"]:SetHeaderHeight(30)
	Casino_Crash["DListView"]:SetDataHeight(25)

	for k, v in pairs(Casino_Crash.Columns) do
		if k > 1 then
			v:SetFixedWidth(110)
		end

		local _Text = v.Header:GetText()
		v.Header:SetText("")
		v:SetHeight(100)

		v.Header.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(36, 48, 66))
			draw.RoundedBox(0, 0, h - 3, w, 3, Color(42, 128, 92))
			draw.SimpleText(_Text, "ManualButton", 5, h / 2 - 2, Color(100, 118, 140), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	Casino_Crash["DListView"].Paint = function(self, w, h)
		self:SortByColumn(2, true)
		draw.RoundedBox(0, 0, 0, w, h, Color(33, 43, 57))
	end

	Casino_Crash["CashoutLabel"] = vgui.Create("DLabel", Frame)
	Casino_Crash["CashoutLabel"]:SetText(_SelectedLang["vgui.casinocrash.autocashout"])
	Casino_Crash["CashoutLabel"]:SetColor(Color(255, 174, 39))
	Casino_Crash["CashoutLabel"]:SetFont("ManualButton")
	Casino_Crash["CashoutLabel"]:SetPos(scaleX(20), scaleH(635))
	Casino_Crash["CashoutLabel"]:SizeToContents()
	local Clear2 = vgui.Create("DButton", Frame)
	Clear2:SetPos(scaleX(20), scaleH(595))
	Clear2:SetSize(scaleX(80), scaleH(30))
	Clear2:SetText("")

	Clear2.Paint = function(self, w, h)
		surface.SetDrawColor(255, 174, 39)
		surface.DrawOutlinedRect(0, 0, w, h)
		draw.SimpleText(_SelectedLang["vgui.casinocrash.default"], "ManualButton", w / 2, h / 2, Color(255, 174, 39), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	Clear2.DoClick = function(self)
		Casino_Crash["CashoutWang"]:SetValue(1)
		Casino_Crash["CashoutWang"].Value = 1
	end

	Casino_Crash["CashoutWang"] = vgui.Create("DNumberWang", Frame)
	local CO_WANG = Casino_Crash["CashoutWang"]
	CO_WANG:SetPos(scaleX(18), scaleH(657))
	CO_WANG:SetSize(scaleX(256), scaleH(40))
	CO_WANG:SetDecimals(2)
	CO_WANG:SetFont("ManualButton")

	Casino_Crash["CashoutWang"].Up.DoClick = function()
		local val = math.Clamp(CO_WANG:GetValue() + Casino_Crash.Config.Interval, Casino_Crash.Config.MinMultiplier, Casino_Crash.Config.MaxMultiplier)
		CO_WANG:SetValue(val)
		CO_WANG.Value = val
	end

	Casino_Crash["CashoutWang"].Down.DoClick = function()
		CO_WANG:SetValue(math.Clamp(CO_WANG:GetValue() - Casino_Crash.Config.Interval, Casino_Crash.Config.MinMultiplier, Casino_Crash.Config.MaxMultiplier))
	end

	Casino_Crash["CashoutWang"].OnValueChanged = function(self, value)
		CO_WANG:SetText(value .. "x")
	end

	Casino_Crash["CashoutWang"].Value = 1.00
	Casino_Crash["CashoutWang"]:SetValue(1.00)

	Casino_Crash["CashoutWang"].Paint = function(self, w, h)
		surface.SetDrawColor(255, 174, 39)
		surface.DrawOutlinedRect(0, 0, w, h)
		self:DrawTextEntryText(Color(220, 220, 220), Color(30, 130, 255), Color(220, 220, 220))
	end

	local AutoIntervals = {}
	AutoIntervals.Intervals = {0.1, 0.5, 0.7, 1, 1.5, 2}

	for k, v in pairs(AutoIntervals.Intervals) do
		AutoIntervals[v] = vgui.Create("DButton", Frame)
		AutoIntervals[v]:SetPos(scaleX(110 + 80 * (k - 1)), scaleH(595))
		AutoIntervals[v]:SetSize(scaleX(70), scaleH(30))
		AutoIntervals[v]:SetText("")
		AutoIntervals[v].Fade = 0
		AutoIntervals[v].TextCol = Color(255, 174, 39)

		AutoIntervals[v].Paint = function(self, w, h)
			if self.Entered then
				self.Fade = Lerp(FrameTime() * 8, self.Fade, 255)
				self.TextCol = Color(22, 30, 40)
			else
				self.Fade = Lerp(FrameTime() * 8, self.Fade, 0)
				self.TextCol = Color(255, 174, 39)
			end

			draw.RoundedBox(0, 0, 0, w, h, Color(255, 174, 39, self.Fade))
			local str = ""

			if isnumber(v) then
				str = "+" .. string.Comma(v)
			else
				str = v
			end

			draw.SimpleText(str, "ManualButton", w / 2, h / 2, self.TextCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 174, 39)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local CashoutWang = Casino_Crash["CashoutWang"]

		AutoIntervals[v].DoClick = function(self)
			local _NewVal = CashoutWang.Value + v
			CashoutWang.Value = _NewVal
			CashoutWang:SetValue(_NewVal)
		end

		AutoIntervals[v].OnCursorEntered = function(self, w, h)
			self.Entered = true
		end

		AutoIntervals[v].OnCursorExited = function(self, w, h)
			self.Entered = false
		end
	end

	Casino_Crash["AutoCashout"] = vgui.Create("DButton", Frame)
	Casino_Crash["AutoCashout"]:SetPos(scaleX(270), scaleH(657))
	Casino_Crash["AutoCashout"]:SetSize(scaleX(100), scaleH(40))
	Casino_Crash["AutoCashout"]:SetText("")
	Casino_Crash["AutoCashout"].Text = _SelectedLang["vgui.casinocrash.multiplier"]

	Casino_Crash["AutoCashout"].Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 172, 39))
		draw.SimpleText(self.Text, "ButtonText2", w / 2, h / 2, Color(22, 30, 40), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	return Casino_Crash["DFrame"]
end

net.Receive("Casino_Crash.LocationTable", function()
	Casino_Crash.LocationTable = net.ReadTable()
end)