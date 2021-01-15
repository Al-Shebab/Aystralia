include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()

	if self.FuelList == nil then
		self.FuelList = {}
	end

	self.Count_Y = 0
	self.Count_X = 0
	self.Count_Z = 0

	self.LastBarrelCount = 0
end

function ENT:CrateChangeUpdater()
	local barrelCount = table.Count(self.FuelList)

	if self.LastBarrelCount ~= barrelCount then
		self.LastBarrelCount = barrelCount

		self:UpdateClientProps()
	end
end


function ENT:Think()
	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then
		self:CrateChangeUpdater()
	else
		self:RemoveClientModels()
		self.ClientProps = {}
		self.LastBarrelCount = -1
	end
end

function ENT:UpdateClientProps()
	self:RemoveClientModels()

	self.ClientProps = {}

	if self.LastBarrelCount > 0 then

		for k,v in pairs(self.FuelList) do
			self:CreateClientBarrel(v)
		end
	end
end

function ENT:OnRemove()
	self:RemoveClientModels()
end

function ENT:CreateClientBarrel(fuel_id)

	if zrush.Fuel[fuel_id] == nil then return end

	local offset_x = 18
	local offset_y = 52

	local step_x = 35
	local step_y = 35
	local step_z = 50.5

	local m_scale = 1

	local count_w = 2

	if zrush.config.Palette.Capacity > 8 then
		offset_x = 22
		offset_y = 42

		step_x = 21
		step_y = 21
		step_z = 30.5

		m_scale = 0.60

		count_w = 3
	end

	local pos = self:GetPos() - self:GetRight() * offset_x - self:GetForward() * offset_y + self:GetUp() * 3
	local ang = self:GetAngles()

	if self.Count_X >= count_w then
		self.Count_X = 1
		self.Count_Y = self.Count_Y + 1
	else
		self.Count_X = self.Count_X + 1
	end

	if self.Count_Y >= count_w then
		self.Count_Y = 0
		self.Count_Z = self.Count_Z + 1
	end

	pos = pos + self:GetForward() * step_x * self.Count_X
	pos = pos + self:GetRight() * step_y * self.Count_Y
	pos = pos + self:GetUp() * step_z * self.Count_Z



	local Barrel = ents.CreateClientProp()
	Barrel:SetModel("models/zerochain/props_oilrush/zor_barrel.mdl")
	Barrel:SetAngles(ang)
	Barrel:SetPos(pos)

	Barrel:SetModelScale(m_scale)

	Barrel:Spawn()
	Barrel:Activate()

	Barrel:SetRenderMode(RENDERMODE_NORMAL)
	Barrel:SetParent(self)

	Barrel:SetColor(zrush.Fuel[fuel_id].color)

	table.insert(self.ClientProps, Barrel)
end

function ENT:RemoveClientModels()
	self.Count_Y = 0
	self.Count_X = 0
	self.Count_Z = 0

	if self.ClientProps and table.Count(self.ClientProps) > 0 then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
