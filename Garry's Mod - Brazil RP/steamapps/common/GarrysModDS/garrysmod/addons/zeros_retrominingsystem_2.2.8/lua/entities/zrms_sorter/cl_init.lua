include("shared.lua")

function ENT:Initialize()
	self.InsertEffect = ParticleEmitter(self:GetPos())
	zrmine.f.EntList_Add(self)
end

function ENT:SplittSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_conveyorbelt_move")

	if (self:GetCurrentState() == 1) then
		if self.SoundObj == nil then
			self.SoundObj = MoveSound
		end

		if self.SoundObj:IsPlaying() == false then
			self.SoundObj:Play()
			self.SoundObj:ChangeVolume(0, 0)
			self.SoundObj:ChangeVolume(GetConVar("zrms_cl_audiovolume"):GetFloat(), 1)
		end
	else
		if self.SoundObj == nil then
			self.SoundObj = MoveSound
		end

		if self.SoundObj:IsPlaying() == true then
			self.SoundObj:ChangeVolume(0, 1)
			if ((self.lastSoundStop or CurTime()) > CurTime()) then return end
			self.lastSoundStop = CurTime() + 5

			timer.Simple(2, function()
				if (IsValid(self)) then
					self.SoundObj:Stop()
				end
			end)
		end
	end
end

function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end
end

function ENT:Think()
	if zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		self:SplittSound()
	end
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 400) then
		self:DrawInfo()
	end

	if self.ShowInfo then
		self:DrawInfo02()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


// UI STUFF
function ENT:DrawInfo()
	local Pos = self:GetPos() + self:GetUp() * 18.9
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(self:GetForward(), 0)
	cam.Start3D2D(Pos, Ang, 0.1)
		draw.RoundedBox(0, -55, -55, 110, 110, zrmine.default_colors["grey05"])
		local col = zrmine.default_colors["Coal"]

		if (self.FilterType == 0) then
			col = zrmine.default_colors["Coal"]
		elseif (self.FilterType == 1) then
			col = zrmine.default_colors["Iron"]
		elseif (self.FilterType == 2) then
			col = zrmine.default_colors["Bronze"]
		elseif (self.FilterType == 3) then
			col = zrmine.default_colors["Silver"]
		elseif (self.FilterType == 4) then
			col = zrmine.default_colors["Gold"]
		end

		surface.SetDrawColor(col)
		surface.SetMaterial(zrmine.default_materials["Ore"])
		surface.DrawTexturedRect(-50, -50, 100, 100)
		draw.NoTexture()
	cam.End3D2D()
end

local offsetX, offsetY = 1, 10
function ENT:DrawResourceItem(Info, color, xpos, ypos, size)
	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)
	draw.NoTexture()
	draw.DrawText(Info .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font3", xpos + offsetX + 30, ypos + offsetY + size * 0.25, color, TEXT_ALIGN_LEFT)
end

function ENT:DrawInfo02()
	local Pos = self:GetPos() + self:GetUp() * 11 + self:GetRight() * 11.3
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(self:GetForward(), 90)

	local aCoal = ": " .. math.Round(self:GetCoal(), 2)
	local aIron = ": " .. math.Round(self:GetIron(), 2)
	local aBronze = ": " .. math.Round(self:GetBronze(), 2)
	local aSilver = ": " .. math.Round(self:GetSilver(), 2)
	local aGold = ": " .. math.Round(self:GetGold(), 2)

	cam.Start3D2D(Pos, Ang, 0.1)
		draw.RoundedBox(0, -105, -55, 210, 110, zrmine.default_colors["grey05"])
		draw.RoundedBox(0, -100, -50, 200, 100, zrmine.default_colors["grey02"])
		self:DrawResourceItem(aCoal, zrmine.default_colors["Coal"], -90, -60, 30)
		self:DrawResourceItem(aIron, zrmine.default_colors["Iron"], -90, -35, 30)
		self:DrawResourceItem(aBronze, zrmine.default_colors["Bronze"], -90, -10, 30)
		self:DrawResourceItem(aSilver, zrmine.default_colors["Silver"], -5, -60, 30)
		self:DrawResourceItem(aGold, zrmine.default_colors["Gold"], -5, -35, 30)
	cam.End3D2D()
end
