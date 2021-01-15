include( "shared.lua" )

Slawer.Mayor.WantedList = Slawer.Mayor.WantedList or {}

local intW, intH = 560, 329
local matExclamation = Material("materials/slawer/mayor/exclamation.png")
local matLoading = Material("materials/slawer/mayor/loading.png")

function ENT:TogglePerson()
	if Slawer.Mayor.WantedNumber == 0 then
		self.blnOff = true
	else
		if self.blnOff then self.blnOff = false end

		for k, v in pairs(Slawer.Mayor.WantedList) do
			if not IsValid(v.p) then table.remove(Slawer.Mayor.WantedList, k) end
		end

		Slawer.Mayor.WantedNumber = table.Count(Slawer.Mayor.WantedList)

		if Slawer.Mayor.WantedNumber == 0 then
			self.blnOff = true
			return
		end

		self.intActual = self.intActual + 1

		if not Slawer.Mayor.WantedList[self.intActual] then self.intActual = 1 end

		self:SetWantedPlayer(Slawer.Mayor.WantedList[self.intActual].p)
	end
end

function ENT:Initialize()
	self.intActual = 1
	self.blnOff = true
	self:TogglePerson()		

	self.strTimer = "smayor_tv" .. self:EntIndex()

	timer.Create(self.strTimer, 5, 0, function()
		if not IsValid(self) then return end
		self:TogglePerson()
	end)
end

function ENT:SetWantedPlayer(p)
	if not IsValid(self.Panel) then self:CreatePanel() end

	if not IsValid(p) then return end

	self.Panel.icon:SetModel(p:GetModel() or Slawer.Mayor:L("None"), p:GetSkin(), p:GetBodyGroups())
	self.Panel.label:SetText(p:Nick() or Slawer.Mayor:L("None"))
	self.Panel.reason:SetText(Slawer.Mayor:L("Reason") .. ": " .. (p:getDarkRPVar("wantedReason") or Slawer.Mayor:L("None")))
end

function ENT:CreatePanel()
	if IsValid(self.Panel) then return end

	self.blnOff = true

	self.Panel = vgui.Create("DPanel")
	self.Panel:SetSize(intW, intH - 50)
	self.Panel:SetPos(0, 50)
	self.Panel:ParentToHUD()
	self.Panel:SetPaintedManually(true)
	function self.Panel:Paint(intW, intH)
		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(10, 10, 170, intH - 20)
		surface.DrawRect(190, 10, intW - 200, intH - 20)
	end

	self.Panel.icon = vgui.Create("SpawnIcon", self.Panel)
	self.Panel.icon:SetSize(170, intH - 70)
	self.Panel.icon:SetPos(10, 10)

	self.Panel.label = vgui.Create("DLabel", self.Panel)
	self.Panel.label:SetSize(intW - 200 - 20, 55)
	self.Panel.label:SetPos(190 + 10, 10)
	self.Panel.label:SetFont("Slawer.Mayor:B30")
	self.Panel.label:SetContentAlignment(5)
	self.Panel.label:SetWrap(false)

	self.Panel.reason = vgui.Create("DLabel", self.Panel)
	self.Panel.reason:SetSize(intW - 200 - 20, intH - 70)
	self.Panel.reason:SetContentAlignment(7)
	self.Panel.reason:SetPos(190 + 10, 60)
	self.Panel.reason:SetFont("Slawer.Mayor:R30")
	self.Panel.reason:SetWrap(true)
end

function ENT:OnRemove()
	if IsValid(self.Panel) then self.Panel:Remove() end
end

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 250000 then
		if IsValid(self.Panel) then self.Panel:Remove() end
		return
	end

	if not IsValid(self.Panel) then
		self:CreatePanel()
	end

	local Pos = self:GetPos()

	Pos = Pos + self:GetUp() * 35.4 + self:GetForward() * 6.1 + self:GetRight() * 27.9

	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)

	local colVal = 255 - math.abs(math.sin(CurTime() * 2) * 200)
	local colRed = Color(255, colVal, colVal)

	cam.Start3D2D(Pos, Ang, 0.1)
		surface.SetDrawColor(Slawer.Mayor.Colors.Grey)
		surface.DrawRect(0, 0, intW, intH)

		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(0, 0, intW, 50)

		if Slawer.Mayor.WantedNumber > 1 && self.strTimer && timer.Exists(self.strTimer) then
			surface.SetDrawColor(Slawer.Mayor.Colors.LightGrey)
			surface.DrawRect(0, 50, intW / 5 * timer.TimeLeft(self.strTimer), 1)
		end

		local strMessage = GetGlobalString("SMayor:News")

		if (Slawer.Mayor.WantedNumber or 0) != 0 || strMessage != "" then
			surface.SetMaterial(matExclamation)
			surface.SetDrawColor(colRed)
			surface.DrawTexturedRect(10, 12, 24, 24)
			surface.DrawTexturedRect(intW - 24 - 10, 12, 24, 24)
		end
		
		if strMessage != "" then
			draw.SimpleText(Slawer.Mayor:L("MayorMessage"), "Slawer.Mayor:B30", intW * 0.5, 25, colRed, 1, 1)

			local tblLines = string.Explode("\n", DarkRP.textWrap(strMessage, "Slawer.Mayor:R30", intW - 70))

			for k, v in pairs(tblLines) do
				draw.SimpleText(v, "Slawer.Mayor:R30", intW * 0.5, ((intH - 70) * 0.5 + 70 - #tblLines / 2 * 40) + (k - 1) * 40, color_white, 1, 1)
			end
		
		else
			draw.SimpleText(Slawer.Mayor:L("WantedNotice") .. " (" .. (Slawer.Mayor.WantedNumber or 0) .. ")", "Slawer.Mayor:B30", intW * 0.5, 25, color_white, 1, 1)
			
			if self.blnOff || Slawer.Mayor.WantedNumber == 0 then
				if Slawer.Mayor.WantedNumber == 0 then
					draw.SimpleText(Slawer.Mayor:L("NoWantedNotice"), "Slawer.Mayor:B30", intW * 0.5, (intH - 50) * 0.5 + 50, color_white, 1, 1)
				else
					surface.SetMaterial(matLoading)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRectRotated(intW * 0.5, (intH - 50) * 0.5 + 50, 64, 64, -(CurTime() * 300) % 360)
				end
			else
				self.Panel:PaintManual()
			end
		end
	cam.End3D2D()
end