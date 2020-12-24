include("shared.lua")

function ENT:Initialize()
	// The Belt material
	local params = {
		["$basetexture"] = "zerochain/props_mining/conveyorbelt/zrms_conveyorbelt_belt_diff",
		["$bumpMap"] = "zerochain/props_mining/conveyorbelt/zrms_conveyorbelt_belt_nrm",
		["$normalmapalphaenvmapmask"] = 1,
		["$surfaceprop"] = "metal",
		["$halflambert"] = 1,
		["$model"] = 1,
		["$envmap"] = "env_cubemap",
		["$envmaptint"] = Vector(0.01, 0.01, 0.01),
		["$envmapfresnel"] = 1,
		["$phong"] = 1,
		["$phongexponenttexture"] = "zerochain/props_mining/conveyorbelt/zrms_conveyorbelt_belt_phong",
		["$phongtint"] = Vector(1, 1, 1),
		["$phongboost"] = 25,
		["$phongfresnelranges"] = Vector(0.05, 0.5, 1),
		["$myspeed"] = 0,
		Proxies = {
			TextureScroll = {
				texturescrollvar = "$baseTexturetransform",
				texturescrollrate = "$myspeed",
				texturescrollangle = -90
			}
		}
	}
	self.ScrollMat = CreateMaterial("scrollmat" .. self:EntIndex(), "VertexLitGeneric", params)
	self:SetSubMaterial(2, "!scrollmat" .. self:EntIndex())
	self.ScrollMat:SetFloat("$myspeed", 0)

	// The Light Pixel handler
	self.PixVis = util.GetPixelVisibleHandle()

	// Sets up stuff for the client gravel animation
	zrmine.f.Gravel_Initialize(self)

	// Adds the client ent to the list
	zrmine.f.EntList_Add(self)

	self.LastState = -1
end

function ENT:ReturnStorage()
	return self:GetCoal() + self:GetIron() + self:GetBronze() + self:GetSilver() + self:GetGold()
end

function ENT:StateChanged()
	local CurrentState = self:GetCurrentState()

	if self.LastState ~= CurrentState then
		self.LastState = CurrentState
		return true
	else
		return false
	end
end

function ENT:EffectsHandler()

	if self.LastState == 0 then
		self:StopParticlesNamed("zrms_crusher_crush")

	elseif self.LastState == 1 then

		//Creates the Crush Effect
		local attach = self:GetAttachment(self:LookupAttachment("input"))

		if attach then
			zrmine.f.ParticleEffect("zrms_crusher_crush", attach.Pos,  attach.Ang, self)
		end

		zrmine.f.EmitSoundENT("zrmine_crush",self)

		timer.Simple(zrmine.config.Crusher_Time / 2, function()
			if IsValid(self) then

				// Creates the dust effect
				zrmine.f.ParticleEffect("zrms_refiner_refine", self:GetPos() + self:GetForward() * -30 + self:GetUp() * 15, self:GetAngles(), self)
			end
		end)
	end
end

function ENT:AnimationHandler()
	if self.LastState == 1 then

		if self:GetSequenceName(self:GetSequence()) ~= "crushing" then
			local animSpeed = 2 / zrmine.config.Crusher_Time
			animSpeed = math.Clamp(animSpeed,1,2)

			zrmine.f.Animation(self, "crushing", animSpeed)

			local Belt_speed = animSpeed * 2
			self.ScrollMat:SetFloat("$myspeed", Belt_speed)
		end
	else
		// If the current state is idle and we dont have anything in the storage then we play the idle animation
		if self:ReturnStorage() <= 0 and self:GetSequenceName(self:GetSequence()) ~= "idle" then
			zrmine.f.Animation(self, "idle", 1)

			self.ScrollMat:SetFloat("$myspeed", 0)
		end
	end
end

function ENT:CrushSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_refinery_loop")

	if (self.LastState == 1) then
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



function ENT:Think()

	if zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		// Returns true after the state changed
		if self:StateChanged() then

			// Handels the effects
			self:EffectsHandler()
		end

		// Handles the animation of the model
		self:AnimationHandler()

		// Handels the Crushing shound
		self:CrushSound()

		// Handels the gravel animation
		zrmine.f.ClientGravelAnim(self)
	end
	self:SetNextClientThink(CurTime())
	return true
end

// Handles the light sprite
function ENT:IndicatorLight()

	local LightPos = self:GetPos() + self:GetUp() * 42 + self:GetForward() * -19

	local ViewNormal = self:GetPos() - EyePos()
	ViewNormal:Normalize()

	local Visibile = util.PixelVisible(LightPos, 4, self.PixVis)
	if (not Visibile or Visibile < 0.1) then return end

	local spriteColor = zrmine.default_colors["white02"]

	if IsValid(self:GetModuleChild()) then
		spriteColor = zrmine.default_colors["green02"]
	else
		spriteColor = zrmine.default_colors["red03"]
	end
	render.SetMaterial(zrmine.default_materials["light_ignorez"])
	render.DrawSprite(LightPos, 25, 25, spriteColor)
end

// The Info screen
local offsetX, offsetY = 55, 18
function ENT:DrawResourceItem(Info, color, xpos, ypos, size)
	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)
	draw.NoTexture()
	draw.DrawText(": " .. Info .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font3", xpos + offsetX + 30, ypos + offsetY + size * 0.25, color, TEXT_ALIGN_LEFT)
end

function ENT:DrawInfo()

	local attach = self:GetAttachment(self:LookupAttachment("screen"))

	if attach then

		local Pos = attach.Pos + self:GetForward() * -0.3
		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(self:GetForward(), 90)
		Ang:RotateAroundAxis(self:GetUp(), 90)

		if (self.LastState == 1) then
			status = zrmine.language.Crusher_Crushing
		elseif (self.LastState == 0) then
			status = zrmine.language.Crusher_Waiting
		end

		local aCoal = math.Round(self:GetCoal(), 2)
		local aIron = math.Round(self:GetIron(), 2)
		local aBronze = math.Round(self:GetBronze(), 2)
		local aSilver = math.Round(self:GetSilver(), 2)
		local aGold = math.Round(self:GetGold(), 2)

		local aAng = self:GetAngles()
		aAng:RotateAroundAxis(self:GetForward(), -90)
		aAng:RotateAroundAxis(self:GetUp(), 90)

		local amount = aCoal + aIron + aBronze + aSilver + aGold

		cam.Start3D2D(Pos, aAng, 0.1)
			draw.RoundedBox(0, -105, -65, 210, 130, zrmine.default_colors["grey02"])
			local aBar = (100 / zrmine.config.Crusher_Capacity) * amount

			if (aBar > 100) then
				aBar = 100
			end

			draw.RoundedBox(0, -87, -50, 30, aBar, zrmine.default_colors["brown01"])
		cam.End3D2D()

		cam.Start3D2D(Pos, Ang, 0.1)
			self:DrawResourceItem(aCoal, zrmine.default_colors["Coal"], -105, -75, 30)
			self:DrawResourceItem(aIron, zrmine.default_colors["Iron"], -105, -55, 30)
			self:DrawResourceItem(aBronze, zrmine.default_colors["Bronze"], -105, -35, 30)
			self:DrawResourceItem(aSilver, zrmine.default_colors["Silver"], -105, -15, 30)
			self:DrawResourceItem(aGold, zrmine.default_colors["Gold"], -105, 5, 30)
			surface.SetDrawColor(zrmine.default_colors["white02"])
			surface.SetMaterial(zrmine.default_materials["Scale"])
			surface.DrawTexturedRect(-110, -53, 75, 105)
			draw.NoTexture()
		cam.End3D2D()
	end
end



function ENT:Draw()
	self:DrawModel()

	if (zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300)) then

		self:DrawInfo()

		if GetConVar("zrms_cl_lightsprites"):GetInt() == 1 then
			self:IndicatorLight()
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end

	zrmine.f.RemoveClientGravel(self)
end
