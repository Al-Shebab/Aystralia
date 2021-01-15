function Slawer.Mayor:ShowPolicemen(pnlContent)
	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 40)
	scroll:SetPos(20, 20)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(3.565) end

	local intY = 0

	for intID, p in pairs(player.GetAll()) do
		-- if p:isMayor() then continue end
		if not p:isCP() then continue end

		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetPos(0, intY)
		pnl:SetSize(scroll:GetWide() - 20, Slawer.Mayor.IsTooLowResolution and 69 or 64)
		function pnl:Paint(intW, intH)
			surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
			surface.DrawRect(0, 0, intW, intH)
		end

		local avatar = vgui.Create("SpawnIcon", pnl)
		avatar:SetSize(64, 64)
		avatar:InvalidateLayout(true)
		avatar:SetModel(p:GetModel())
		function avatar:OnMousePressed()end
		function avatar:PaintOver()end

		local lblName = vgui.Create("DLabel", pnl)
		lblName:SetSize(275, 25)
		lblName:SetPos(75, 10)
		lblName:SetText(p:Nick())
		lblName:SetFont("Slawer.Mayor:R30")

		local lblJob = vgui.Create("DLabel", pnl)
		lblJob:SetSize(275, 25)
		lblJob:SetPos(75, 33)
		lblJob:SetText(team.GetName(p:Team()))
		lblJob:SetFont("Slawer.Mayor:R22")
		lblJob:SetTextColor(Slawer.Mayor.Colors.LightGrey)

		local btnDemote
		if (p:isCP() && not p:isMayor()) && Slawer.Mayor.CFG.MayorCanKickCP then
			btnDemote = vgui.Create("Slawer.Mayor:DButton", pnl)
			btnDemote:SetSize(48, 48)
			btnDemote:SetPos(pnl:GetWide() - btnDemote:GetWide() - 10, pnl:GetTall() * 0.5 - btnDemote:GetTall() * 0.5)
			btnDemote:SetImageButton(Material("materials/slawer/mayor/logout.png"), color_white, 24)
			btnDemote:SetBackgroundColor(ColorAlpha(color_black, 100))
			function btnDemote:DoClick()
				Slawer.Mayor:NetStart("KickCP", {cp = p})
			end
		end

		local txtBonus

		local btnBonus = vgui.Create("Slawer.Mayor:DButton", pnl)
		btnBonus:SetSize(48, 48)
		local intOffsetX = pnl:GetWide() - (IsValid(btnDemote) && btnDemote:GetWide() or -10) - 8 - btnBonus:GetWide() - 8
		btnBonus:SetPos(intOffsetX, pnl:GetTall() * 0.5 - btnBonus:GetTall() * 0.5)
		btnBonus:SetImageButton(Material("materials/slawer/mayor/gift.png"), color_white, 24)
		btnBonus:SetBackgroundColor(ColorAlpha(color_black, 100))
		function btnBonus:DoClick()
			if txtBonus:GetWide() == 0 then
				txtBonus:MoveTo(intOffsetX - 125 - 8, pnl:GetTall() * 0.5 - txtBonus:GetTall() * 0.5, 0.25)
				txtBonus:SizeTo(125, 30, 0.25)
				txtBonus:OnMousePressed()
			else
				txtBonus:MoveTo(intOffsetX - 8, pnl:GetTall() * 0.5 - txtBonus:GetTall() * 0.5, 0.25)
				txtBonus:SizeTo(0, 30, 0.25)
				txtBonus:OnMousePressed()
			
				if string.Trim(txtBonus:GetText()) != "" then
					Slawer.Mayor:NetStart("MoneyGift", {receiver = p, amount = tonumber(txtBonus:GetText())})
				end
				txtBonus:SetText("")
			end
		end


		txtBonus = vgui.Create("Slawer.Mayor:DTextEntry", pnl)
		txtBonus:SetSize(0, 30)
		txtBonus:SetPos(intOffsetX - 8, pnl:GetTall() * 0.5 - txtBonus:GetTall() * 0.5)
		txtBonus:SetPlaceholder(Slawer.Mayor:L("Amount"))

		intY = intY + pnl:GetTall() + 20
	end
end

Slawer.Mayor:NetReceive("SyncPolicemen", function()
	Slawer.Mayor:RefreshPanel("Policemen")
end)