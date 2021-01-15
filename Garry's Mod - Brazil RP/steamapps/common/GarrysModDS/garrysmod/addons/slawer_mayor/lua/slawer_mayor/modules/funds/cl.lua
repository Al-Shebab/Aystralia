function Slawer.Mayor:ShowFunds(pnlContent)
	local pnlCards = vgui.Create("DPanel", pnlContent)
	pnlCards:SetSize(pnlContent:GetWide() - 40, 120)
	pnlCards:SetPos(20, 20)

	local intPlayers = 0
	local intCops = 0

	for _, p in pairs(player.GetAll()) do
		intPlayers = intPlayers + 1
		if p:isCP() then intCops = intCops + 1 end
	end

	function pnlCards:Paint(intW, intH)
		Slawer.Mayor:DrawCard(0, 0, intW / 3 - 10, 100, DarkRP.formatMoney(Slawer.Mayor:GetFunds()), Slawer.Mayor:L("CityFunds") .. " / " .. DarkRP.formatMoney(Slawer.Mayor:GetMaxFunds()))
		Slawer.Mayor:DrawCard(intW / 3 + 5, 0, intW / 3 - 10, 100, intPlayers, Slawer.Mayor:L("CitizensInTheCity"))
		Slawer.Mayor:DrawCard(intW / 3 * 2 + 10, 0, intW / 3 - 10, 100, intCops, Slawer.Mayor:L("GovernmentAgents"))
	end

	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 160)
	scroll:SetPos(20, 140)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(8.225) end

	local intY = 0
	local intX = 0

	for intID, tbl in pairs(Slawer.Mayor.CFG.Upgrades) do
		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetPos(intX, intY)
		pnl:SetSize((scroll:GetWide() - 20) / 2 - 10, Slawer.Mayor.IsTooLowResolution and 185 or 143)
		local intMoney = Slawer.Mayor:L("Max")
		if Slawer.Mayor:GetUpgradeLevel(intID) < Slawer.Mayor:GetUpgradeMaxLevel(intID) then
			intMoney = DarkRP.formatMoney(tbl.Levels[Slawer.Mayor:GetUpgradeLevel(intID) + 1].Price)
		end
		local strName = tbl.Name .. " (" .. Slawer.Mayor:GetUpgradeLevel(intID) .. "/" .. #tbl.Levels .. ")"
		function pnl:Paint(intW, intH)
			surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
			surface.DrawRect(0, 0, intW, intH)

			draw.SimpleText(strName, "Slawer.Mayor:R22", 15, 15, color_white)
			draw.SimpleText(intMoney, "Slawer.Mayor:R22", intW - 15, 15, color_white, 2)
		end

		local tblLines = Slawer.Mayor:WrapText(tbl.Description, "Slawer.Mayor:R20", pnl:GetWide() - 30)

		local strLabel = (tblLines[1] or "") .. "\n" .. (tblLines[2] or "")
		strLabel = #tblLines > 2 && string.sub(strLabel, 0, -3) .. "..." || strLabel

		local lbl = vgui.Create("DLabel", pnl)
		lbl:SetSize(pnl:GetWide() - 15, Slawer.Mayor.IsTooLowResolution and 80 or 40)
		lbl:SetPos(15, 45)
		lbl:SetText(strLabel)
		lbl:SetContentAlignment(7)
		lbl:SetFont("Slawer.Mayor:R20")
		
		local btnBuy = vgui.Create("Slawer.Mayor:DButton", pnl)
		btnBuy:SetSize(pnl:GetWide() - 30, 30)
		btnBuy:SetPos(15, pnl:GetTall() - btnBuy:GetTall() - 15)
		btnBuy:SetText(Slawer.Mayor:L("Upgrade"))
		function btnBuy:DoClick()
			Slawer.Mayor:NetStart("Upgrade", {id = intID})
		end
		if intMoney == Slawer.Mayor:L("Max") then
			btnBuy:SetText(intMoney)
			btnBuy:SetBackgroundColor(Slawer.Mayor.Colors.Grey)
			function btnBuy:DoClick() end
		end

		intX = intX == 0 && (scroll:GetWide() - 20) / 2 + 10 || 0
		if intX == 0 then
			intY = intY + pnl:GetTall() + 20
		end
	end
end


Slawer.Mayor:NetReceive("SyncUpgrades", function(tbl)
	Slawer.Mayor.Upgrades = tbl

	Slawer.Mayor:RefreshPanel("Funds")
end)