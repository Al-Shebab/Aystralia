local matWanted = Material("materials/slawer/mayor/exclamation.png")

function Slawer.Mayor:ShowWanted(pnlContent)
	local btnNew = vgui.Create("Slawer.Mayor:DButton", pnlContent)
	btnNew:SetSize(pnlContent:GetWide() - 40, 40)
	btnNew:SetPos(pnlContent:GetWide() * 0.5 - btnNew:GetWide() * 0.5, pnlContent:GetTall() - btnNew:GetTall() - 20)
	btnNew:SetText(Slawer.Mayor:L("StartAWantedNotice"))
	-- btnNew:SetFont("Slawer.Mayor:R30")
	-- btnNew:SetBackgroundColor(Slawer.Mayor.Colors.DarkGrey)
	function btnNew:DoClick()
		Slawer.Mayor:ShowNewWanted(pnlContent)
	end

	
	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 100)
	scroll:SetPos(20, 20)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(3.12) end

	local intY = 0
	for k, p in pairs(player.GetAll()) do
		if not p:getDarkRPVar("wanted") then continue end

		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetSize(scroll:GetWide() - 20, 60)
		pnl:SetPos(0, intY)
		function pnl:Paint(intW, intH)
			if not p || not IsValid(p) then
				self:Remove()
				return
			end

			surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
			surface.DrawRect(0, 0, intW, intH)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(matWanted)
			surface.DrawTexturedRect(20, intH * 0.5 - 16, 32, 32)

			draw.SimpleText(p:Nick(), "Slawer.Mayor:R22", 73, intH * 0.5, color_white, 0, 1)
			-- draw.SimpleText(strDate, "Slawer.Mayor:R22", intW - 240, intH * 0.5, color_white, 2, 1)
		end

		local btnEnd = vgui.Create("Slawer.Mayor:DButton", pnl)
		btnEnd:SetSize(200, 32)
		btnEnd:SetPos(pnl:GetWide() - btnEnd:GetWide() - 20, pnl:GetTall() * 0.5 - btnEnd:GetTall() * 0.5)
		btnEnd:SetText(Slawer.Mayor:L("Cancel"))
		btnEnd:SetBackgroundColor(Slawer.Mayor.Colors.Red)
		function btnEnd:DoClick()
			RunConsoleCommand("darkrp", "unwanted", p:UserID())
		end

		intY = intY + pnl:GetTall() + 18
	end
end

function Slawer.Mayor:ShowNewWanted(pnlContent)
	pnlContent:Clear()

	local btnBack = vgui.Create("Slawer.Mayor:DButton", pnlContent)
	btnBack:SetSize(100, 32)
	btnBack:SetPos(20, 20)
	btnBack:SetText(Slawer.Mayor:L("Back"))
	btnBack:SetBackgroundColor(Slawer.Mayor.Colors.DarkGrey)
	function btnBack:DoClick()
		pnlContent:Clear()
		Slawer.Mayor:ShowWanted(pnlContent)
	end

	local txtReason = vgui.Create("Slawer.Mayor:DTextEntry", pnlContent)
	txtReason:SetSize(pnlContent:GetWide() - 160, 32)
	txtReason:SetPos(140, 20)
	txtReason:SetText(Slawer.Mayor:L("Reason"))

	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 132)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(1.68) end
	scroll:SetPos(20, 112)

	local intY = 0
	for k, v in pairs(player.GetAll()) do
		if v:getDarkRPVar("wanted") then continue end

		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetSize(scroll:GetWide() - 20, 42)
		pnl:SetPos(0, intY)
		pnl.back = intY % 84 == 0 and Slawer.Mayor.Colors.Grey or Slawer.Mayor.Colors.DarkGrey
		function pnl:Paint(intW, intH)
			if not IsValid(v) then
				self:Remove()
				return
			end

			surface.SetDrawColor(self.back)
			surface.DrawRect(0, 0, intW, intH)

			draw.SimpleText(v:EntIndex(), "Slawer.Mayor:R20", 30, intH * 0.5, color_white, 1, 1)
			draw.SimpleText(v:Nick(), "Slawer.Mayor:R20", 280, intH * 0.5, color_white, 1, 1)
		end

		local btnStart = vgui.Create("DImageButton", pnl)
		btnStart:SetSize(20, 20)
		btnStart:SetPos(650 - btnStart:GetWide() * 0.5, 10)
		btnStart:SetImage("materials/slawer/mayor/warrants.png")
		btnStart:SetColor(color_white)
		function btnStart:Think()
		end
		function btnStart:DoClick()
			RunConsoleCommand("darkrp", "wanted", v:UserID(), txtReason:GetText())
		end

		intY = intY + pnl:GetTall()
	end
	
	local header = vgui.Create("DPanel", pnlContent)
	header:SetSize(pnlContent:GetWide() - 40, 40)
	header:SetPos(20, 72)
	function header:Paint(intW, intH)
		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(0, 0, intW, intH)

		surface.SetDrawColor(Slawer.Mayor.Colors.LightGrey)
		surface.DrawLine(0, intH - 1, intW, intH - 1)

		draw.SimpleText("#", "Slawer.Mayor:R20", 30, intH * 0.5, color_white, 1, 1)
		draw.SimpleText(Slawer.Mayor:L("Citizen"), "Slawer.Mayor:R20", 280, intH * 0.5, color_white, 1, 1)
		draw.SimpleText(Slawer.Mayor:L("StartAWantedNotice"), "Slawer.Mayor:R20", 650, intH * 0.5, color_white, 1, 1)
	end
end

hook.Add("DarkRPVarChanged", "Slawer.Mayor:Wanted:DarkRPVarChanged", function(p, var, old, new)
	if var == "wanted" and old == true then
		Slawer.Mayor.WantedNumber = Slawer.Mayor.WantedNumber or 0
		Slawer.Mayor.WantedList = Slawer.Mayor.WantedList or {}

		Slawer.Mayor:RefreshPanel("Wanted")

		Slawer.Mayor.WantedNumber = math.Clamp(Slawer.Mayor.WantedNumber - 1, 0, math.huge)
		for k, v in pairs(Slawer.Mayor.WantedList) do
			if v.p == p then
				table.remove(Slawer.Mayor.WantedList, k)
				break
			end
		end

		print("-1 ici")
	elseif var == "wantedReason" then
		if not IsValid(p) or not p:IsPlayer() then return end

		Slawer.Mayor.WantedNumber = Slawer.Mayor.WantedNumber or 0
		Slawer.Mayor.WantedList = Slawer.Mayor.WantedList or {}

		Slawer.Mayor:RefreshPanel("Wanted")
		
		if new != nil then
			Slawer.Mayor.WantedNumber = Slawer.Mayor.WantedNumber + 1
			table.insert(Slawer.Mayor.WantedList, {p = p, sid = (p:SteamID() or 0), reason = new, uid = p:UserID()})
		else
			for k, v in pairs(Slawer.Mayor.WantedList) do
				if v.p == p then
					Slawer.Mayor.WantedNumber = math.Clamp(Slawer.Mayor.WantedNumber - 1, 0, math.huge)
					table.remove(Slawer.Mayor.WantedList, k)
					break
				end
			end
		end
	end
end)

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "Slawer:Mayor:player_disconnect", function( data )
	local steamid = data.networkid
	local uid = data.userid
	
	for k, v in pairs(Slawer.Mayor.WantedList) do
		if v.sid == steamid or v.uid == uid then
			Slawer.Mayor.WantedNumber = Slawer.Mayor.WantedNumber - 1
			table.remove(Slawer.Mayor.WantedList, k)
			break
		end
	end
end )