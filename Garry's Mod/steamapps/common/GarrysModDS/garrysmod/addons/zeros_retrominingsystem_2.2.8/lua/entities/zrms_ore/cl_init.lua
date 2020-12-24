include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) and not zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 15) then
		self:DrawInfo()
	end

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then
		self:UpdateVisualsDraw()
	else
		self.LastAmount = -1
		self.LastType = -1
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	local Pos = self:GetPos() + Vector(0, 0, 60)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	local amount = math.Round(self.LastAmount, 1)
	local Text = amount .. zrmine.config.BuyerNPC_Mass

	if (amount <= 0) then
		Text = zrmine.language.Ore_Empty
	end

	local vType = self.LastType
	local rType = "nil"

	if (vType == "Coal") then
		rType = zrmine.language.Ore_Coal
	elseif (vType == "Iron") then
		rType = zrmine.language.Ore_Iron
	elseif (vType == "Bronze") then
		rType = zrmine.language.Ore_Bronze
	elseif (vType == "Silver") then
		rType = zrmine.language.Ore_Silver
	elseif (vType == "Gold") then
		rType = zrmine.language.Ore_Gold
	elseif (vType == "Random") then
		rType = zrmine.language.Ore_Random
	end

	cam.Start3D2D(Pos, Ang, 0.2)
		draw.DrawText(rType, "zrmine_mineentrance_font1", 0, -50, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
		draw.DrawText(Text, "zrmine_resource_font2", 0, 0, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:Initialize()
	self.InsertEffect = ParticleEmitter(self:GetPos())
	self.LastAmount = -1
	self.LastType = -1
end

function ENT:UpdateVisualsDraw()
	local rType = self:GetResourceType()
	local rAmount = self:GetResourceAmount()

	if self.LastAmount ~= rAmount or self.LastType ~= rType then
		self.LastAmount = rAmount
		self.LastType = rType
	end
end
