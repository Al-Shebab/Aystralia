include("shared.lua")

function ENT:Initialize()
	self:Setup_Conveyorbelt_Material()
	self:Setup_PaintLack_Material()

	self.PixVis = util.GetPixelVisibleHandle()
	self.PixVisBasket = util.GetPixelVisibleHandle()
	self.InsertEffect = ParticleEmitter(self:GetPos())

	zrmine.f.EntList_Add(self)

	// Sets up stuff for the client gravel animation
	zrmine.f.Gravel_Initialize(self)

	// The refined gravel animation cycle
	self.rg_cycle = 0

	self.State = -1

	self.RefineStart = -1
end

// Animated Belt
function ENT:Setup_Conveyorbelt_Material()
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

	self.ScrollMat = CreateMaterial("Refiner_ScrollMat" .. self:EntIndex(), "VertexLitGeneric", params)
	self:SetSubMaterial(1, "!Refiner_ScrollMat" .. self:EntIndex())
end

// Color painted Lack
function ENT:Setup_PaintLack_Material()
	local resourceType = self.RefinerType
	local paintColor = Vector(1, 1, 1)

	if (resourceType == "Iron") then
		paintColor = Vector(0.407, 0.3, 0.35)
	elseif (resourceType == "Bronze") then
		paintColor = Vector(0.61, 0.28, 0.15)
	elseif (resourceType == "Silver") then
		paintColor = Vector(0.6, 0.6, 0.6)
	elseif (resourceType == "Gold") then
		paintColor = Vector(0.74, 0.56, 0.19)
	elseif (resourceType == "Coal") then
		paintColor = Vector(0.3, 0.3, 0.3)
	end

	local params = {
		["$basetexture"] = "zerochain/props_mining/refinery/zrms_refiner_diff",
		["$color2"] = paintColor,
		["$blendTintByBaseAlpha"] = 1,
		["$blendTintColorOverBase"] = 0,
		["$bumpMap"] = "zerochain/props_mining/refinery/zrms_refiner_nrm",
		["$normalmapalphaenvmapmask"] = 1,
		["$surfaceprop"] = "metal",
		["$halflambert"] = 1,
		["$model"] = 1,
		["$envmap"] = "env_cubemap",
		["$envmaptint"] = paintColor,
		["$envmapfresnel"] = 1,
		["$phong"] = 1,
		["$phongexponenttexture"] = "zerochain/props_mining/refinery/zrms_refiner_phong",
		["$phongtint"] = paintColor,
		["$phongboost"] = 15,
		["$phongfresnelranges"] = Vector(0.05, 0.5, 1)
	}

	self.PaintMat = CreateMaterial("RefinerPaint" .. self:EntIndex(), "VertexLitGeneric", params)
	self.PaintMat:SetVector("$color2", paintColor)
	self.PaintMat:SetFloat("$blendTintColorOverBase", 0.1)
	self:SetSubMaterial(5, "!RefinerPaint" .. self:EntIndex())
end


function ENT:UpdateState()
	local CurrentState = self:GetCurrentState()

	if self.State ~= CurrentState then
		self.State = CurrentState

		if CurrentState == 2 then

			self.ScrollMat:SetFloat("$myspeed", 2)

			self.RefineStart = CurTime()

			//Plays the crush sound
			zrmine.f.EmitSoundENT("zrmine_crush",self)

			//Plays the REFINING animation
			if self:GetSequenceName(self:GetSequence()) ~= "refine" then

				local animSpeed = 2 / self.RefiningTime
				animSpeed = math.Clamp(animSpeed,1,2)

				zrmine.f.Animation(self, "refine", animSpeed)
			end
		elseif CurrentState == 1 then

			self.ScrollMat:SetFloat("$myspeed", 2)

			zrmine.f.EmitSoundENT("zrmine_crush",self)
		else

			self.RefineStart = -1

			self.ScrollMat:SetFloat("$myspeed", 0)

			if self:GetSequenceName(self:GetSequence()) ~= "idle" then
				zrmine.f.Animation(self, "idle", 1)
			end
		end
	end
end

function ENT:RefineSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_refinery_loop")

	if self.State == 2 then
		if self.SoundObj == nil then
			self.SoundObj = MoveSound
		end

		if self.SoundObj:IsPlaying() == false then
			//self:EmitSound("zms_drill_start")
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
		self:UpdateState()

		self:RefineSound()

		// Handels the gravel animation
		zrmine.f.ClientGravelAnim(self)

		// Handels the refine gravel anim
		self:ClientRefinedGravelAnim()
	end
	self:SetNextClientThink(CurTime())
	return true
end





// 2D Light Sprites
function ENT:IndicatorLight_Refinery()
	local LightPos = self:GetPos() + self:GetUp() * 44 + self:GetForward() * -20

	local ViewNormal = self:GetPos() - EyePos()
	ViewNormal:Normalize()

	local Visibile = util.PixelVisible(LightPos, 3, self.PixVis)

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
function ENT:IndicatorLight_Basket()

	local LightPos = self:GetPos() + self:GetUp() * 28 + self:GetRight() * 15

	local ViewNormal = self:GetPos() - EyePos()
	ViewNormal:Normalize()

	local Visibile = util.PixelVisible(LightPos, 3, self.PixVisBasket)

	if (not Visibile or Visibile < 0.1) then return end

	local spriteColor = zrmine.default_colors["white02"]

	if IsValid(self:GetBasket()) then
		spriteColor = zrmine.default_colors["green02"]
	else
		spriteColor = zrmine.default_colors["red03"]
	end

	render.SetMaterial(zrmine.default_materials["light_ignorez"])
	render.DrawSprite(LightPos, 25, 25, spriteColor)
end

function ENT:Draw()
	self:DrawModel()

	zrmine.f.UpdateEntityVisuals(self)

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then

		if GetConVar("zrms_cl_lightsprites"):GetInt() == 1 then
			self:IndicatorLight_Refinery()
			self:IndicatorLight_Basket()
		end

		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


function ENT:UpdateVisuals()

	if (self:GetSubMaterial(1) ~= "!Refiner_ScrollMat" .. self:EntIndex()) then
		self:SetSubMaterial(1, "!Refiner_ScrollMat" .. self:EntIndex())
	end

	if (self:GetSubMaterial(5) ~= "!RefinerPaint" .. self:EntIndex()) then
		self:SetSubMaterial(5, "!RefinerPaint" .. self:EntIndex())
	end

	// This Sets the belt scroll speed of the mat
	if (self.State == 2 or self.State == 1) then
		self.ScrollMat:SetFloat("$myspeed", 2)
	else
		self.ScrollMat:SetFloat("$myspeed", 0)
	end
end


// UI Stuff
local offsetX, offsetY = 15, 10
function ENT:DrawResourceItem(Info, color, xpos, ypos, size)
	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)
	draw.NoTexture()
	draw.DrawText(Info, "zrmine_screen_font1", xpos + offsetX + 50, ypos + offsetY + size * 0.22, color, TEXT_ALIGN_LEFT)
end

function ENT:DrawInfo()

	local attach = self:GetAttachment(self:LookupAttachment("screen"))
	if attach then

		local Pos = attach.Pos + self:GetRight() * -1
		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(self:GetForward(), 90)

		local status

		local aCoal = ": " .. math.Round(self:GetCoal(), 2) .. "kg"
		local aIron = ": " .. math.Round(self:GetIron(), 2) .. "kg"
		local aBronze = ": " .. math.Round(self:GetBronze(), 2) .. "kg"
		local aSilver = ": " .. math.Round(self:GetSilver(), 2) .. "kg"
		local aGold = ": " .. math.Round(self:GetGold(), 2) .. "kg"

		if (self.State == 2) then
			status = zrmine.language.Refiner_Refining
		elseif (self.State == 0) then
			status = zrmine.language.Refiner_Waiting
		elseif (self.State == 1) then
			status = zrmine.language.Refiner_Moving
		end

		local aAng = self:GetAngles()
		aAng:RotateAroundAxis(self:GetForward(), -90)

		cam.Start3D2D(Pos, aAng, 0.1)
			draw.RoundedBox(0, -105, -65, 210, 130, zrmine.default_colors["grey02"])
			self:Draw_ResourceBar("Coal", 0)
			self:Draw_ResourceBar("Iron", 6)
			self:Draw_ResourceBar("Bronze", 12)
			self:Draw_ResourceBar("Silver", 18)
			self:Draw_ResourceBar("Gold", 24)
		cam.End3D2D()

		cam.Start3D2D(Pos, Ang, 0.1)

			if self.State == 2 then
				local refineTimeEnd = self.RefineStart +  self.RefiningTime
				local barSize = 130 / self.RefiningTime
				barSize = barSize * (refineTimeEnd - CurTime())
				barSize = math.Clamp(barSize,0,130)
				draw.RoundedBox(5, -50, -15, 130, 20, zrmine.default_colors["grey07"])
				draw.RoundedBox(5, -50, -15, barSize, 20, zrmine.default_colors["grey06"])
			end


			draw.DrawText(status, "zrmine_screen_font3", 15, -15, Color(229, 179, 72), TEXT_ALIGN_CENTER)

			local name = ""


			if (self.RefinerType == "Coal") then
				self:DrawResourceItem(aCoal, zrmine.default_colors["Coal"], -60, 0, 50)
				name = zrmine.language.Ore_Coal
			elseif (self.RefinerType == "Iron") then
				self:DrawResourceItem(aIron, zrmine.default_colors["Iron"], -60, 0, 50)
				name = zrmine.language.Ore_Iron
			elseif (self.RefinerType == "Bronze") then
				self:DrawResourceItem(aBronze, zrmine.default_colors["Bronze"], -60, 0, 50)
				name = zrmine.language.Ore_Bronze
			elseif (self.RefinerType == "Silver") then
				self:DrawResourceItem(aSilver, zrmine.default_colors["Silver"], -60, 0, 50)
				name = zrmine.language.Ore_Silver
			elseif (self.RefinerType == "Gold") then
				self:DrawResourceItem(aGold, zrmine.default_colors["Gold"], -60, 0, 50)
				name = zrmine.language.Ore_Gold
			end

			draw.DrawText(name, "zrmine_screen_font2", 15, -55, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)

			surface.SetDrawColor(zrmine.default_colors["white02"])
			surface.SetMaterial(zrmine.default_materials["Scale"])
			surface.DrawTexturedRect(-110, -53, 75, 105)
			draw.NoTexture()
		cam.End3D2D()
	end
end

function ENT:Draw_ResourceBar(rtype, xOffset)
	local ramount = 0

	if (rtype == "Coal") then
		ramount = self:GetCoal()
	elseif (rtype == "Iron") then
		ramount = self:GetIron()
	elseif (rtype == "Bronze") then
		ramount = self:GetBronze()
	elseif (rtype == "Silver") then
		ramount = self:GetSilver()
	elseif (rtype == "Gold") then
		ramount = self:GetGold()
	end

	local rpaintColor = Color(121, 111, 92)

	if (rtype == "Iron") then
		rpaintColor = zrmine.default_colors["Iron"]
	elseif (rtype == "Bronze") then
		rpaintColor = zrmine.default_colors["Bronze"]
	elseif (rtype == "Silver") then
		rpaintColor = zrmine.default_colors["Silver"]
	elseif (rtype == "Gold") then
		rpaintColor = zrmine.default_colors["Gold"]
	elseif (rtype == "Coal") then
		rpaintColor = zrmine.default_colors["Coal"]
	end

	local refCap = zrmine.config.Refiner_Capacity
	local r_Bar = (100 / refCap) * ramount

	if (r_Bar > 100) then
		r_Bar = 100
	end

	draw.RoundedBox(0, -87 + xOffset, -50, 5, r_Bar, rpaintColor)
end


// Refine Gravel Anim
function ENT:ClientRefinedGravelAnim()
	if self.ClientProps == nil then
		self.ClientProps = {}
	end

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then

		if IsValid(self.ClientProps["RefineGravel"]) then

			// The requested animation type aka skin
			local r_type = self:GetRefineAnim_Type()

			if r_type == -1 then
				self.ClientProps["RefineGravel"]:SetNoDraw(true)
				self.rg_cycle = 0
			else

				local speed = 1.5

				self.rg_cycle = math.Clamp(self.rg_cycle + (1 / speed) * FrameTime(), 0, 1)

				if self.rg_cycle >= 1 then

					self.ClientProps["RefineGravel"]:SetNoDraw(true)
				else
					self.ClientProps["RefineGravel"]:SetPos(self:LocalToWorld(Vector(0,5,0)))
					self.ClientProps["RefineGravel"]:SetSkin(r_type)
					self.ClientProps["RefineGravel"]:SetNoDraw(false)

					local sequence = self.ClientProps["RefineGravel"]:LookupSequence("refined")
					self.ClientProps["RefineGravel"]:SetSequence(sequence)
					self.ClientProps["RefineGravel"]:SetPlaybackRate(1)
					self.ClientProps["RefineGravel"]:SetCycle(self.rg_cycle)
				end
			end
		else
			self:CreateClientGravel()
		end
	else

		if IsValid(self.ClientProps["RefineGravel"]) then
			self.ClientProps["RefineGravel"]:Remove()
		end

		self.rg_cycle = 0
	end
end

function ENT:CreateClientGravel()
	local gravel = ents.CreateClientProp()

	gravel:SetPos(self:LocalToWorld(Vector(0,0,0)))
	gravel:SetModel("models/zerochain/props_mining/zrms_refinedgravel01.mdl")
	gravel:SetAngles(self:GetAngles())

	gravel:Spawn()
	gravel:Activate()

	gravel:SetRenderMode(RENDERMODE_NORMAL)
	gravel:SetParent(self)
	gravel:SetNoDraw(true)

	self.ClientProps["RefineGravel"] = gravel
end


function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end
end
