local matJob = Material("materials/slawer/mayor/businessman.png")

Slawer.Mayor.TaxesAverage = Slawer.Mayor.TaxesAverage or 0

function Slawer.Mayor:ShowTaxs(pnlContent)
	local scroll = vgui.Create("Slawer.Mayor:DScrollPanel", pnlContent)
	scroll:SetSize(pnlContent:GetWide() - 40 + 20, pnlContent:GetTall() - 100)
	scroll:SetPos(20, 20)
	if Slawer.Mayor.IsTooLowResolution then scroll:SetLowResValue(3.725) end

	local intY = 0
	local intX = 0

	local tblTaxs = table.Copy(Slawer.Mayor.JobTaxs)

	for intID, tblJob in pairs(RPExtraTeams) do
		if Slawer.Mayor.CFG.TaxesBlacklist[tblJob.name] then continue end

		local pnl = vgui.Create("DPanel", scroll)
		pnl:SetPos(intX, intY)
		pnl:SetSize((scroll:GetWide() - 20) / 2 - 10, Slawer.Mayor.IsTooLowResolution and 73 or 64)
		local intSalary = Slawer.Mayor:L("Salary"):format(DarkRP.formatMoney(tblJob.salary))
		function pnl:Paint(intW, intH)
			surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
			surface.DrawRect(0, 0, intW, intH)

			surface.SetMaterial(matJob)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(15, intH * 0.5 - 16, 32, 32)

			draw.SimpleText(tblJob.name, "Slawer.Mayor:R20", 62, intH * 0.5 - 10, color_white, 0, 1)
			draw.SimpleText(intSalary, "Slawer.Mayor:R20", 62, intH * 0.5 + 10, color_white, 0, 1)
			draw.SimpleText("%", "Slawer.Mayor:B30", intW - 20, intH * 0.5, color_white, 2, 1)
		end

		local txtTax = vgui.Create("Slawer.Mayor:DTextEntry", pnl)
		txtTax:SetSize(40, 30)
		txtTax:SetPos(pnl:GetWide() - txtTax:GetWide() - 40, pnl:GetTall() * 0.5 - 15)
		txtTax:SetValue(Slawer.Mayor.JobTaxs[intID] or 0)
		txtTax:SetFont("Slawer.Mayor:B30")
		function txtTax:OnValueChange(txt)
			tblTaxs[intID] = tonumber(txt)
			if tonumber(txt) && tonumber(txt) > Slawer.Mayor.CFG.MaxTax then
				self:SetText(Slawer.Mayor.CFG.MaxTax)
				if IsValid(Slawer.Mayor.FakeTextEntry) then
					Slawer.Mayor.FakeTextEntry:SetText(Slawer.Mayor.CFG.MaxTax)
				end
				tblTaxs[intID] = tonumber(txt)
				return
			end
		end
		function txtTax:OnEnter()
			self:SetValue(math.Clamp(tonumber(self:GetValue() or 0) or 0, 0, 100))
		end
		
		intX = intX == 0 && (scroll:GetWide() - 20) / 2 + 10 || 0
		if intX == 0 then
			intY = intY + pnl:GetTall() + 20
		end
	end

	local btnSave = vgui.Create("Slawer.Mayor:DButton", pnlContent)
	btnSave:SetSize(pnlContent:GetWide() - 40, 45)
	btnSave:SetPos(20, pnlContent:GetTall() - 20 - btnSave:GetTall())
	btnSave:SetText(Slawer.Mayor:L("Save"))
	function btnSave:DoClick()
		Slawer.Mayor:NetStart("UpdateTaxs", tblTaxs)
	end
end

Slawer.Mayor:NetReceive("SyncTaxs", function(tbl)
	Slawer.Mayor.JobTaxs = tbl
	local intSum = 0
	local iCount = 0
	for k, v in pairs(tbl) do
		if Slawer.Mayor.CFG.TaxesBlacklist[team.GetName(k)] then continue end
		
		iCount = iCount + 1
		intSum = intSum + v
	end
	
	Slawer.Mayor.TaxesAverage = math.Round(intSum / iCount)

	Slawer.Mayor:RefreshPanel("Taxs")
end)