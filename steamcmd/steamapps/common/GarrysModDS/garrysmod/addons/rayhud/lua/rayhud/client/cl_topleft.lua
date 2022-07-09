-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local ply = LocalPlayer()

--[[------------------------------
    Top Left Notifications
--------------------------------]]

local popupQueue = {}
local activePopup

local function ShowPopup( Clr, Title, Message, Important )

	if Clr then
		table.insert(popupQueue, {Clr = Clr, Title = Title, Message = Message, Important = Important})
	end

	if !IsValid(activePopup) then
		local curPopup = table.Copy(popupQueue[1])

		popupQueue[1] = nil
		popupQueue = table.ClearKeys(popupQueue)

		surface.SetFont("RayUI:Large2")
		local PanelWidth = select(1, surface.GetTextSize(curPopup.Message))
		PanelWidth = math.Clamp( PanelWidth, 0, ScrW() / 4 )

		local PopupPanel = vgui.Create("RayHUD:DPanel")
		PopupPanel:SetAlpha(0)
		PopupPanel:AlphaTo(255, 0.5)
		PopupPanel:SetSize(0, 0)
		PopupPanel:SetPos(RayHUD.OffsetX, RayHUD.OffsetY)
		PopupPanel.Paint = function (self, w, h)
			RayUI:DrawBlur(self)
			
			local Var = math.Clamp(  math.abs( math.sin( CurTime() * 6 ) ), 0.65, 1 )
			if !curPopup.Important then Var = 1 end
			local PopupCol = Color( Var * curPopup.Clr.r, Var * curPopup.Clr.g, Var * curPopup.Clr.b)

			RayUI:DrawMaterialBox(DarkRP.deLocalise(curPopup.Title), 0, 0, w, h, PopupCol)
		end

		activePopup = PopupPanel

		local PopupLabel = vgui.Create("DLabel", PopupPanel)
		PopupLabel:SetPos(12, 46 * RayUI.Scale)
		PopupLabel:SetFont("RayUI:Large2")
		PopupLabel:SetText(DarkRP.deLocalise(curPopup.Message))
		PopupLabel:SetWide(PanelWidth)
		PopupLabel:SetAutoStretchVertical( true )
		PopupLabel:SetWrap(true)

		timer.Simple(0.01, function()
			PopupPanel:SetTall(55 * RayUI.Scale + PopupLabel:GetTall())
			PopupPanel:SizeTo(PopupLabel:GetWide() + 24 * RayUI.Scale, -1, 0.5)
		end)

		timer.Simple(6, function()
			if !IsValid(PopupPanel) then return end

			PopupPanel:AlphaTo(0, 0.5)
			PopupPanel:SizeTo(0, -1, 0.5, 0, -1, function()
				if !IsValid(PopupPanel) then return end

				PopupPanel:Remove()

				if #popupQueue > 0 then
					ShowPopup()
				end
			end)
		end)
	end
end

net.Receive("RayHUD:SendHUDPopup",function(  )
	ShowPopup(net.ReadColor(), net.ReadString(), net.ReadString(), net.ReadBool())
end)

--[[------------------------------
    Battery Alert
--------------------------------]]

if RayUI.Configuration.GetConfig( "EnableBatteryAlert" ) then

	local LastBattery = system.BatteryPower()

	timer.Create("RayHUD:BatteryNotification", 1, 0, function(  )

		local Battery = system.BatteryPower()

		if LastBattery <= 100 and Battery == 255 then
			ShowPopup( RayUI.Colors.Green, RayUI.GetPhrase("hud", "charger_connected"), RayUI.GetPhrase("hud", "charging_started") )
		elseif LastBattery == 255 and Battery <= 100 then
			ShowPopup( RayUI.Colors.Red, RayUI.GetPhrase("hud", "charger_disconnected"), RayUI.GetPhrase("hud", "charging_aborted"), true )
		elseif (LastBattery > 20 and Battery <= 20) or (LastBattery > 5 and Battery <= 5) then
			ShowPopup( RayUI.Colors.Red, RayUI.GetPhrase("hud", "battery_status"), string.Replace(RayUI.GetPhrase("hud", "battery_info"), "%B", Battery), true )
		end

		LastBattery = Battery
	end)

	hook.Add("RayHUD:Reload", "RayHUD:UnloadBatteryNotification",function(  )
		timer.Remove("RayHUD:BatteryNotification")
	end)

end

--[[------------------------------
    DarkRP Vote & Question
--------------------------------]]

usermessage.Hook("DoVote", function(  )	end)

local voteQueue = {}
local curVote

local function startVote( id, question, time, isVote )
	local queue

	local QueuePanel = vgui.Create("RayHUD:DPanel")
	QueuePanel:SetSize(290 * RayUI.Scale, 180 * RayUI.Scale)
	QueuePanel:SetPos(RayHUD.OffsetX, ScrH() / 2 - (180 * RayUI.Scale) / 2 - 180 * RayUI.Scale)
	QueuePanel.Paint = function (self, w, h)
		RayUI:DrawBlur(self)
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 40))

		local QueueText = "There are " .. #voteQueue .. " votes in queue"
		surface.SetFont("RayUI:Medium2")
		local textw, texth = select(1, surface.GetTextSize( QueueText ))

	draw.SimpleText(QueueText, "RayUI:Medium2",  w / 2 - textw / 2, h - (80 * RayUI.Scale / 2 - texth / 2), color_white)
	end
	QueuePanel.Think = function (self, w, h)
		if #voteQueue > 0 and !queue then
			self:SetSize(290 * RayUI.Scale, 220 * RayUI.Scale)
			queue = true
		end
	end

	local Window = vgui.Create("RayHUD:DPanel", QueuePanel)
	Window:SetSize(290 * RayUI.Scale, 180 * RayUI.Scale)
	Window:SetPos(0, 0)
	Window.Paint = function (self, w, h)
		RayUI:DrawBlur(self)
		RayUI:DrawMaterialBox("Job Voting", 0, 0, w, h, RayUI.Icons.Vote)
	end

	local VoteText = vgui.Create("DLabel", Window)
	VoteText:SetFont("RayUI:Small2")
	VoteText:SetText(string.Replace( DarkRP.deLocalise(question), "\n", " " ))
	VoteText:SetPos(10 * RayUI.Scale, 47 * RayUI.Scale)
	VoteText:SetWide(280 * RayUI.Scale)
	VoteText:SetAutoStretchVertical( true )
	VoteText:SetWrap(true)

	for i = 1, 2 do
		local Button = vgui.Create("DButton", Window)
		Button:SetSize(120 * RayUI.Scale, 30 * RayUI.Scale)
		Button:SetPos(i == 1 and 12 * RayUI.Scale or (290 - 120 - 12) * RayUI.Scale, Window:GetTall() - 12 - 30 * RayUI.Scale)
		Button:SetFont("RayUI:Medium2")
		Button.DoClick = function()
			QueuePanel:Remove()

			if i == 1 then
				ply:ConCommand("vote " .. id .. " yea\n")
			else
				ply:ConCommand("vote " .. id .. " nay\n")
			end

		--	Main:Remove()
		end
		Button:FormatRayButton(i == 1 and "Yes" or "No", RayUI.Colors.Gray2, i == 1 and RayUI.Colors.Green or RayUI.Colors.HP)
	end

	local voteStarted = CurTime()

	local TimerText = vgui.Create("DLabel", Window)
	TimerText:SetFont("RayUI:Medium2")
	TimerText:SizeToContents()
	TimerText:SetPos(Window:GetWide() / 2 - TimerText:GetWide() / 2, Window:GetTall() - 66 * RayUI.Scale)
	TimerText.Think = function()
		if !time then return end

		local calcTime = math.max(math.floor(time - (CurTime() - voteStarted)), 0)

		if TimerText:GetValue() != tostring(calcTime) then
			TimerText:SetText("Vote expires in " .. calcTime .. " seconds")
			TimerText:SizeToContents()
			TimerText:SetPos(Window:GetWide() / 2 - TimerText:GetWide() / 2, Window:GetTall() - 66 * RayUI.Scale)
		end
	end

	curVote = QueuePanel

	if time < 0 then QueuePanel:Remove() return end

	timer.Simple(time, function()
		if IsValid(QueuePanel) then
			QueuePanel:Remove()
		end
	end)

	QueuePanel.OnRemove = function()
		curVote = nil

		if #voteQueue == 0 then return end

		local newVote = voteQueue[1]
		startVote(newVote.id, newVote.question, newVote.ending - CurTime(),newVote.isVote)

		voteQueue[1] = nil
		voteQueue = table.ClearKeys(voteQueue)

		queue = nil
	end
end
-- 76561198166995699
net.Receive("RayHUD:DarkRP_Vote",function()
	if visibility == false then
		notification.AddLegacy(RayUI.GetPhrase("hud", "VOTE_PENDING"),NOTIFY_HINT,5)
	end

	local id = net.ReadUInt(10)
	local question = net.ReadString()
	local time = net.ReadUInt(8)

	surface.PlaySound("plats/elevbell1.wav")

	if IsValid(curVote) then
		table.insert(voteQueue, {id = id, question = question, ending = CurTime() + time, isVote = true})
	else
		startVote(id, question, time, true)
	end
end)