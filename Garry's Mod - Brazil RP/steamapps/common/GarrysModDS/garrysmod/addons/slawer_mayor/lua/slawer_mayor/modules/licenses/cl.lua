function Slawer.Mayor:ShowLicenses(pnlContent)
	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 80)
	scroll:SetPos(20, 60)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(1.6) end

	local intY = 0
	for k, v in pairs(player.GetAll()) do
		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetSize(scroll:GetWide() - 20, 37)
		pnl:SetPos(0, intY)
		pnl.back = intY % 80 == 0 and Slawer.Mayor.Colors.Grey or Slawer.Mayor.Colors.DarkGrey
		function pnl:Paint(intW, intH)
			if not IsValid(v) then
				self:Remove()
				return
			end

			surface.SetDrawColor(self.back)
			surface.DrawRect(0, 0, intW, intH)

			draw.SimpleText(v:EntIndex(), "Slawer.Mayor:R20", 30, intH * 0.5, color_white, 1, 1)
			draw.SimpleText(v:Nick(), "Slawer.Mayor:R20", 245, intH * 0.5, color_white, 1, 1)
			draw.SimpleText(v:getDarkRPVar("HasGunlicense") and Slawer.Mayor:L("Yes") or Slawer.Mayor:L("No"), "Slawer.Mayor:R20", 500, intH * 0.5, color_white, 1, 1)
			-- draw.SimpleText("Grant/Revoke License", "Slawer.Mayor:R20", 725, intH * 0.5, color_white, 1, 1)
		end

		local btnGrantRevoke = vgui.Create("DImageButton", pnl)
		btnGrantRevoke:SetSize(20, 20)
		btnGrantRevoke:SetPos(725 - btnGrantRevoke:GetWide() * 0.5, 10)
		btnGrantRevoke:SetImage("materials/slawer/mayor/licenses.png")
		function btnGrantRevoke:Think()
			if IsValid(v) then
				btnGrantRevoke:SetColor(v:getDarkRPVar("HasGunlicense") && Slawer.Mayor.Colors.LightGrey || color_white)
			end
		end
		function btnGrantRevoke:DoClick()
			Slawer.Mayor:NetStart("ToggleGunLicense", {p = v})
		end

		intY = intY + 40
	end
	
	local header = vgui.Create("DPanel", pnlContent)
	header:SetSize(pnlContent:GetWide() - 40, 40)
	header:SetPos(20, 20)
	function header:Paint(intW, intH)
		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(0, 0, intW, intH)

		surface.SetDrawColor(Slawer.Mayor.Colors.LightGrey)
		surface.DrawLine(0, intH - 1, intW, intH - 1)

		draw.SimpleText("#", "Slawer.Mayor:R20", 30, intH * 0.5, color_white, 1, 1)
		draw.SimpleText(Slawer.Mayor:L("Citizen"), "Slawer.Mayor:R20", 245, intH * 0.5, color_white, 1, 1)
		draw.SimpleText(Slawer.Mayor:L("HasGunLicense"), "Slawer.Mayor:R20", 500, intH * 0.5, color_white, 1, 1)
		draw.SimpleText(Slawer.Mayor:L("GrantRevokeLicense"), "Slawer.Mayor:R20", 725, intH * 0.5, color_white, 1, 1)
	end
end