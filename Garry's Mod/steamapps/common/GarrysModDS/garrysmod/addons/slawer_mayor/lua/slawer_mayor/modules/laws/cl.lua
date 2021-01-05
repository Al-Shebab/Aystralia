function Slawer.Mayor:ShowLaws(pnlContent)
	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 100)
	scroll:SetPos(20, 20)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(2.68) end

	local intY = 0

	for intID, strLaw in pairs(DarkRP.getLaws()) do
		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetPos(0, intY)
		pnl:SetWide(scroll:GetWide() - 20)
		function pnl:Paint(intW, intH)
			draw.RoundedBox(0, 0, 0, intW, intH, Slawer.Mayor.Colors.DarkGrey)
		end

		local intLabelW = pnl:GetWide() - 20 - 15 - 40

		local tblLines = Slawer.Mayor:WrapText(intID .. " - " .. string.Replace(strLaw, "\n", " "), "Slawer.Mayor:R22", intLabelW - 50)

		pnl:SetTall(#tblLines * 27 + 20)

		local lbl = vgui.Create("DLabel", pnl)
		lbl:SetSize(intLabelW, pnl:GetTall())
		lbl:SetPos(20, 0)
		lbl:SetText(string.Implode("\n", tblLines))
		lbl:SetContentAlignment(4)
		lbl:SetFont("Slawer.Mayor:R22")

		if not GAMEMODE || GAMEMODE.Config == nil || GAMEMODE.Config.DefaultLaws == nil || GAMEMODE.Config.DefaultLaws[intID] != strLaw then
			local btnRemove = vgui.Create("Slawer.Mayor:DButton", pnl)
			btnRemove:SetPos(pnl:GetWide() - 55, 0)
			btnRemove:SetSize(55, pnl:GetTall())
			btnRemove:SetText("✕")
			btnRemove:SetBackgroundColor(ColorAlpha(color_black, 100))
			function btnRemove:DoClick()
				LocalPlayer():ConCommand("darkrp removelaw " .. intID)
			end
		end


		intY = intY + pnl:GetTall() + 20
	end

	local txtLaw = vgui.Create("Slawer.Mayor:DTextEntry", pnlContent)
	txtLaw:SetSize(pnlContent:GetWide() - 40, 45)
	txtLaw:SetPos(20, pnlContent:GetTall() - 20 - txtLaw:GetTall() - 20 - txtLaw:GetTall())
	txtLaw:SetVisible(false)
	txtLaw:SetAlpha(0)

	local btnAdd = vgui.Create("Slawer.Mayor:DButton", pnlContent)
	btnAdd:SetSize(pnlContent:GetWide() - 40, 45)
	btnAdd:SetPos(20, pnlContent:GetTall() - 20 - btnAdd:GetTall())
	btnAdd:SetText(Slawer.Mayor:L("AddALaw"))
	function btnAdd:DoClick()
		if txtLaw:IsVisible() then
			RunConsoleCommand("darkrp", "addlaw", txtLaw:GetText())
		else
			scroll:SizeTo(scroll:GetWide(), pnlContent:GetTall() - 175, 0.25)
			txtLaw:SetVisible(true)
			txtLaw:AlphaTo(255, 0.25)
			txtLaw:OnMousePressed()
		end
	end
end

local function onLawsUpdated()
	Slawer.Mayor:RefreshPanel("Laws")
	Slawer.Mayor.DidLawsChanged = true
end

hook.Add("addLaw", "Slawer.Mayor:addLaw", onLawsUpdated)
hook.Add("removeLaw", "Slawer.Mayor:removeLaw", onLawsUpdated)
hook.Add("resetLaws", "Slawer.Mayor:resetLaws", onLawsUpdated)