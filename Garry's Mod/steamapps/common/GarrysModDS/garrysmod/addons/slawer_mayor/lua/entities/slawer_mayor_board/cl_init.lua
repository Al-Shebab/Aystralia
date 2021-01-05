include( "shared.lua" )

Slawer.Mayor.CityBoards = Slawer.Mayor.CityBoards or {}

local intW, intH = 2019, 1093

local intWHalf = intW * 0.5

local intHeaderH = intH * 0.14

local intMargins = 20
local intCards = 3

local intCardW = (intW - intMargins * 2) / intCards - intCards * 5
local intCardH = intH * 0.25
local intCardY = intHeaderH + intMargins

local intTitleY = intHeaderH * 0.5

local intXCardOne = intMargins + (intCardW + intMargins) * 0
local intXCardTwo = intMargins + (intCardW + intMargins) * 1
local intXCardThree = intMargins + (intCardW + intMargins) * 2

intMargins = nil
intCards = nil

function ENT:Initialize()
	table.insert(Slawer.Mayor.CityBoards, self)
end

function ENT:CreatePanel()
	if IsValid(self.Panel) then return end

	if not Slawer.Mayor.MayorName then
		for k, v in pairs(player.GetAll()) do
			if not IsValid(v) or not v.isMayor then continue end
				if v:isMayor() then
					Slawer.Mayor.MayorName = v
					break
				end
		end
	end

	local tblLaws = table.Copy(DarkRP.getLaws())
	local tblInfo = {}

	Slawer.Mayor.DidLawsChanged = false

	for k, v in pairs(tblLaws) do
		tblInfo[k] = Slawer.Mayor:WrapText(k .. ". " .. string.Replace(v, "\n", " "), "Slawer.Mayor:B65", intW - 80)
	end

	local intScroll = 30
	local intCurrent = 1
	local intLaws = table.Count(tblLaws)
	local dir = 1

	local tblScroll = {}

	self.Panel = vgui.Create("DPanel")
	self.Panel:SetSize(intW, 600)
	self.Panel:SetPos(0, intH - self.Panel:GetTall())
	self.Panel:SetPaintedManually(true)
	self.Panel:ParentToHUD()
	self.Panel.intScroll = intScroll
	function self.Panel:Paint(intW, intH)
		self.intScroll = Lerp(RealFrameTime() * 4, self.intScroll, intScroll)

		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()

		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )

		draw.RoundedBox(0, 0, 0, intW, intH, color_white)

		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )
		
		local intY = 0

		for k, v in pairs(tblInfo) do
			for Lk, Lv in pairs(v) do
				draw.SimpleText(Lv, "Slawer.Mayor:B65", intW * 0.5, self.intScroll + intY, intCurrent == k && color_white || Slawer.Mayor.Colors.LightGrey, 1, 1)
				intY = intY + 70
			end
			tblScroll[k] = intY - 60 - #v * 7
			intY = intY + 40
		end

		render.SetStencilEnable( false )
	end

	self.strTimer = "smayor" .. self:EntIndex()

	if timer.Exists(self.strTimer) then
		timer.Destroy(self.strTimer)
	end

	local tblMinScroll

	timer.Create(self.strTimer, Slawer.Mayor.CFG.LawsScrollingDelay, 0, function()
		if Slawer.Mayor.DidLawsChanged then
			timer.Remove(self.strTimer or "smayor" .. self:EntIndex())
			if IsValid(self.Panel) then self.Panel:Remove() end
		end

		if not IsValid(self.Panel) then
			return
		end

		if table.Count(tblScroll) != 0 then
			if intCurrent >= intLaws then
				dir = -1
			elseif intCurrent <= 1 then
				dir = 1
			end

			intCurrent = intCurrent + dir

			tblMinScroll = tblMinScroll or (-(table.GetLastValue(tblScroll) or 0)+self.Panel:GetTall() - 50)

			intScroll = math.Clamp(self.Panel:GetTall() * 0.5 -(tblScroll[intCurrent] or 0), tblMinScroll or 0, 30)
			-- intScroll = self.Panel:GetTall() * 0.5 -tblScroll[intCurrent]
		end
	end)
end

function ENT:OnRemove()
	if self.strTimer then
		if timer.Exists(self.strTimer) then timer.Destroy(self.strTimer) end
	end
	if IsValid(self.Panel) then
		self.Panel:Remove()
	end
end

function ENT:Draw()
	self:DrawModel()
	
	if Slawer.Mayor.LookingTo && IsValid(Slawer.Mayor.LookingTo) then
		if IsValid(self.Panel) then self.Panel:Remove() end
		return
	end

	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 2250000 then
		if IsValid(self.Panel) then self.Panel:Remove() end
		return
	end

	if (Slawer.Mayor.MayorName && not IsValid(Slawer.Mayor.MayorName)) || (Slawer.Mayor.MayorName && not Slawer.Mayor.MayorName:isMayor()) then
		Slawer.Mayor.MayorName = nil
	end

	if not IsValid(self.Panel) then
		self:CreatePanel()
	end

	local Pos = self:GetPos()
	Pos = Pos + self:GetForward() * 140.2 + self:GetUp() * 76.5 + self:GetRight() * -4
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Up(), 180)
	Ang:RotateAroundAxis(Ang:Forward(), 90)

	cam.Start3D2D(Pos, Ang, 0.14)
		surface.SetDrawColor(Slawer.Mayor.Colors.Grey)
		surface.DrawRect(0, 0, intW, intH)

		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(0, 0, intW, intHeaderH)

		draw.SimpleText(Slawer.Mayor:L("CityBoard") .. " - " .. (IsValid(Slawer.Mayor.MayorName) && Slawer.Mayor.MayorName:Nick() or Slawer.Mayor:L("None")), "Slawer.Mayor:B65", intWHalf, intTitleY, color_white, 1, 1)

		Slawer.Mayor:DrawBigCard(intXCardOne, intCardY, intCardW, intCardH, DarkRP.formatMoney(Slawer.Mayor.GetFunds and Slawer.Mayor:GetFunds() or 0), Slawer.Mayor:L("CityFunds"))
		Slawer.Mayor:DrawBigCard(intXCardTwo, intCardY, intCardW, intCardH, Slawer.Mayor.WantedNumber or 0, Slawer.Mayor:L("WantedNotice"))
		Slawer.Mayor:DrawBigCard(intXCardThree, intCardY, intCardW, intCardH, (Slawer.Mayor.TaxesAverage or 0) .. "%", Slawer.Mayor:L("AverageTax"))
	cam.End3D2D()

end

-- used that hook because in the ENT:Draw I was having issues with the stencil.
hook.Add( "PostDrawOpaqueRenderables", "Slawer.Mayor:PostDrawOpaqueRenderables", function()
	for _, ent in ipairs(Slawer.Mayor.CityBoards) do
		if not IsValid(ent) then
			table.remove(Slawer.Mayor.CityBoards, _)
			continue
		end
		if not IsValid(ent.Panel) then continue end

		local Pos = ent:GetPos()
		Pos = Pos + ent:GetForward() * 140.2 + ent:GetUp() * 76.5 + ent:GetRight() * -4
		local Ang = ent:GetAngles()
		Ang:RotateAroundAxis(Ang:Up(), 180)
		Ang:RotateAroundAxis(Ang:Forward(), 90)

		cam.Start3D2D(Pos, Ang, 0.14)
			ent.Panel:PaintManual()
		cam.End3D2D()
	end
end)
