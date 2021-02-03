-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

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

		surface.SetFont("FlatHUD.Main:Medium")
		local PanelWidth = select(1, surface.GetTextSize(curPopup.Message))
		PanelWidth = math.Clamp( PanelWidth, 0, ScrW() / 4 )

		local PopupPanel = vgui.Create("FlatHUD:DPanel")
		PopupPanel:SetAlpha(0)
		PopupPanel:AlphaTo(255, 0.5)
		PopupPanel:SetSize(0, 0)
		PopupPanel:SetPos(12, 12)
		PopupPanel.Paint = function (self, w, h)
			local Var = math.Clamp(  math.abs( math.sin( CurTime() * 6 ) ), 0.65, 1 )
			if !curPopup.Important then Var = 1 end
			local PopupCol = Color( Var * curPopup.Clr.r, Var * curPopup.Clr.g, Var * curPopup.Clr.b)

			FlatUI.DrawMaterialBox(DarkRP.deLocalise(curPopup.Title), 0, 0, w, h, PopupCol)
		end

		activePopup = PopupPanel

		local PopupLabel = vgui.Create("DLabel", PopupPanel)
		PopupLabel:SetPos(12, 48 * FlatHUD.Scale)
		PopupLabel:SetFont("FlatHUD.Main:Medium")
		PopupLabel:SetText(DarkRP.deLocalise(curPopup.Message))
		PopupLabel:SetWide(PanelWidth)
		PopupLabel:SetAutoStretchVertical( true )
		PopupLabel:SetWrap(true)

		timer.Simple(0.01, function()
			PopupPanel:SetTall(55 * FlatHUD.Scale + PopupLabel:GetTall())
			PopupPanel:SizeTo(PopupLabel:GetWide() + 24 * FlatHUD.Scale, -1, 0.5)
		end)

		timer.Simple(6,function(  )
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

net.Receive("FlatHUD:SendHUDPopup",function(  )
	ShowPopup(net.ReadColor(), net.ReadString(), net.ReadString(), net.ReadBool())
end)

--[[------------------------------
    DarkRP Vote & Question.
--------------------------------]]

usermessage.Hook("DoVote", function(  )	end)

local voteQueue = {}
local curVote

local function startVote( id, question, time, isVote )
	local queue

	local QueuePanel = vgui.Create("FlatHUD:DPanel")
	QueuePanel:SetSize(290 * FlatHUD.Scale, 180 * FlatHUD.Scale)
	QueuePanel:SetPos(12 * FlatHUD.Scale, ScrH() / 2 - (180 * FlatHUD.Scale) / 2 - 180 * FlatHUD.Scale)
	QueuePanel.Paint = function (self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, FlatUI.Colors.DarkGray3)

		local text123 = "There are " .. #voteQueue .. " votes in queue"
		surface.SetFont("FlatHUD.Main:Small")
		local textw, texth = select(1, surface.GetTextSize( text123 ))

	draw.SimpleText(text123, "FlatHUD.Main:Small",  w / 2 - textw / 2, h - (80 * FlatHUD.Scale / 2 - texth / 2), color_white)
	end
	QueuePanel.Think = function (self, w, h)
		if #voteQueue > 0 and !queue then
			self:SetSize(290 * FlatHUD.Scale, 220 * FlatHUD.Scale)
			queue = true
		end
	end

	local Window = vgui.Create("FlatHUD:DPanel", QueuePanel)
	Window:SetSize(290 * FlatHUD.Scale, 180 * FlatHUD.Scale)
	Window:SetPos(0, 0)
	Window.Paint = function (self, w, h)
		FlatUI.DrawMaterialBox("Job Voting", 0, 0, w, h, FlatUI.Icons.Vote)
	end

	local VoteText = vgui.Create("DLabel", Window)
	VoteText:SetFont("FlatHUD:TopRight")
	VoteText:SetText(string.Replace( DarkRP.deLocalise(question), "\n", " " ))
	VoteText:SetPos(10 * FlatHUD.Scale, 47 * FlatHUD.Scale)
	VoteText:SetWide(280 * FlatHUD.Scale)
	VoteText:SetAutoStretchVertical( true )
	VoteText:SetWrap(true)

	for i = 1, 2 do
		local Button = FlatUI.CreateFlatButton(Window, i == 1 and "Yes" or "No", FlatUI.Colors.Gray2, i == 1 and FlatUI.Colors.Green or FlatUI.Colors.HP, function()
			Main:Remove()
		end)
		Button:SetSize(120 * FlatHUD.Scale, 30 * FlatHUD.Scale)
		Button:SetPos(i == 1 and 12 * FlatHUD.Scale or (290 - 120 - 12) * FlatHUD.Scale, Window:GetTall() - 12 - 30 * FlatHUD.Scale)
		Button:SetFont("FlatHUD.Main:Small")
		Button.DoClick = function()
			QueuePanel:Remove()

			if i == 1 then
				ply:ConCommand("vote " .. id .. " yea\n")
			else
				ply:ConCommand("vote " .. id .. " nay\n")
			end
		end
	end

	local voteStarted = CurTime()

	local TimerText = vgui.Create("DLabel", Window)
	TimerText:SetFont("FlatHUD.Main:Small")
	TimerText:SizeToContents()
	TimerText:SetPos(Window:GetWide() / 2 - TimerText:GetWide() / 2, Window:GetTall() - 66 * FlatHUD.Scale)
	TimerText.Think = function()
		if !time then return end

		local calcTime = math.max(math.floor(time - (CurTime() - voteStarted)), 0)

		if TimerText:GetValue() != tostring(calcTime) then
			TimerText:SetText("Vote expires in " .. calcTime .. " seconds")
			TimerText:SizeToContents()
			TimerText:SetPos(Window:GetWide() / 2 - TimerText:GetWide() / 2, Window:GetTall() - 66 * FlatHUD.Scale)
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
net.Receive("FlatHUD:DarkRP_Vote",function()
	if visibility == false then
		notification.AddLegacy(FlatHUD.GetPhrase("VOTE_PENDING"),NOTIFY_HINT,5)
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