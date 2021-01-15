include("shared.lua")


// UI STUFF
function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 600) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	local Pos = self:GetPos() + self:GetUp() * 55 + self:GetForward() * 53
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(self:GetRight(), -90)
	Ang:RotateAroundAxis(self:GetForward(), 90)
	local title = "nil"

	if (zrmine.config.Mine_CustomName) then
		title = zrmine.config.Mine_CustomName
	else
		local owner = zrmine.f.GetOwner(self)
		if (IsValid(owner)) then
			title = owner:Nick()
		end
	end

	local info
	local cState = self:GetCurrentState()

	if (cState == 4) then
		info = zrmine.language.Mine_Mining
	elseif (cState == 1) then
		info = zrmine.language.Mine_Ready
	else
		info = zrmine.language.Mine_Wait
	end

	local rColor = zrmine.default_colors["white02"]
	local rtype = self:GetMineResourceType()

	if (rtype == "Random") then
		rColor = zrmine.default_colors["Random"]
	elseif (rtype == "Coal") then
		rColor = zrmine.default_colors["Coal"]
	elseif (rtype == "Iron") then
		rColor = zrmine.default_colors["Iron"]
	elseif (rtype == "Bronze") then
		rColor = zrmine.default_colors["Bronze"]
	elseif (rtype == "Silver") then
		rColor = zrmine.default_colors["Silver"]
	elseif (rtype == "Gold") then
		rColor = zrmine.default_colors["Gold"]
	end

	local Pos01 = self:GetPos() + self:GetUp() * 56 + self:GetForward() * 50
	cam.Start3D2D(Pos01, Ang, 0.07)
		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["MineBgIcon"])
		surface.DrawTexturedRect(-425, -51, 850, 160)
		draw.NoTexture()

		draw.RoundedBox(5, -425, -51, 850, 160, zrmine.default_colors["black03"])
		draw.RoundedBox(0, -250, 65, 550, 12, zrmine.default_colors["black04"])

		if (cState == 0) then
			draw.DrawText(zrmine.language.Mine_SearchOre, "zrmine_mineentrance_font2", 0, 10, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
		else
			draw.DrawText(info, "zrmine_mineentrance_font2", 0, -15, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
			local startMineTime = self:GetStartMinningTime()
			local mineTime = self:GetMinningTime() + 5
			local moveStep
			startMineTime = (startMineTime + mineTime) - CurTime()
			local cartIcon = zrmine.default_materials["Minecart"]

			if (startMineTime > mineTime / 2) then
				moveStep = -750 + (1000 / mineTime) * startMineTime
				cartIcon = zrmine.default_materials["Minecart"]
			elseif (startMineTime > 0) then
				moveStep = 250 + (-1000 / mineTime) * startMineTime
				cartIcon = zrmine.default_materials["MinecartFull"]
			else
				moveStep = 250
			end

			draw.RoundedBox(0, -250, 75, 550, 5, zrmine.default_colors["grey03"])
			surface.SetDrawColor(zrmine.default_colors["white02"])
			surface.SetMaterial(zrmine.default_materials["MineIcon"])
			surface.DrawTexturedRect(250, -21, 110, 110)
			draw.NoTexture()

			if (mineTime - 5 > 0) then
				surface.SetDrawColor(zrmine.default_colors["white02"])
				surface.SetMaterial(cartIcon)
				surface.DrawTexturedRect(moveStep, 32, 50, 50)
				draw.NoTexture()
			end
		end

		if (rtype ~= "Nothing") then
			surface.SetDrawColor(rColor)
			surface.SetMaterial(zrmine.default_materials["Ore"])
			surface.DrawTexturedRect(-400, -70, 200, 200)
			draw.NoTexture()

			if (rtype == "Random") then
				draw.DrawText("?", "zrmine_mineentrance_font3", -300, -15, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
			end
		end

	cam.End3D2D()

	cam.Start3D2D(Pos, Ang, 0.08)
		draw.RoundedBox(0, -340, -190, 680, 120, self.mainColor)
		surface.SetDrawColor(zrmine.default_colors["grey04"])
		surface.SetMaterial(zrmine.default_materials["MineSignIcon"])
		surface.DrawTexturedRect(-360, -205, 720, 160)
		draw.NoTexture()
		draw.DrawText(title .. "´s Mine", "zrmine_mineentrance_font1", 0, -150, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
	cam.End3D2D()
end



// Stencil stuff
ZRMS_SHAFTS = ZRMS_SHAFTS or {}

function ENT:CreateClientSideModel()
	self.csModel = ClientsideModel("models/zerochain/props_mining/mining_tunnel.mdl")

	if (IsValid(self.csModel) and IsValid(self)) then
		self.csModel:SetPos(self:GetPos())
		self.csModel:SetAngles(self:GetAngles())
		self.csModel:SetParent(self)
		self.csModel:SetNoDraw(true)
	end
end

function ENT:CreateCart()
	self.csCartModel = ClientsideModel("models/Zerochain/props_mining/me_cart.mdl")

	if (IsValid(self) and IsValid(self.csCartModel) ) then
		local attachID = self:LookupAttachment("cart")

		if (attachID == 1) then
			self.csCartModel:SetPos(self:GetAttachment(attachID).Pos)
			local ang = self:GetAttachment(attachID).Ang
			ang:RotateAroundAxis(self:GetAttachment(attachID).Ang:Up(), 90)
			self.csCartModel:SetAngles(ang)
			self.csCartModel:SetParent(self, attachID)
			self.csCartModel:SetNoDraw(true)
		end
	end
end

function ENT:Initialize()
	self.mainColor = HSVToColor(math.random(0, 360), 0.5, 0.5)
	ZRMS_SHAFTS[self:EntIndex()] = self
end

hook.Add("PreDrawTranslucentRenderables", "a_zrmine_RenderShafts", function(depth, skybox)
	if skybox then return end
	if depth then return end

	if GetConVar("zrms_cl_stencil"):GetInt() == 1 then
		for k, s in pairs(ZRMS_SHAFTS) do
			if not IsValid(s) then continue end
			if (s:GetIsClosed() or not zrmine.f.InDistance(LocalPlayer():GetPos(), s:GetPos(), 700)) then continue end
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(57)

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)


			local angle = s:GetAngles()
			cam.Start3D2D(s:GetPos(), angle, 1)
				surface.SetDrawColor(0, 200, 255, 200)
				draw.NoTexture()
				draw.RoundedBox(0, -93, -30, 140, 60, Color(255, 255, 255, 1))
			cam.End3D2D()


			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			//render.SuppressEngineLighting(true)
			render.SetLightingOrigin(s:GetPos() + s:GetUp() * 10)
			render.DepthRange(0, 0.8)

			if (IsValid(s.csModel)) then
				s.csModel:DrawModel()
			end

			if (IsValid(s.csCartModel) and not s:GetHideCart()) then
				s.csCartModel:DrawModel()
			end

			//render.SuppressEngineLighting(false)
			render.SetStencilEnable(false)
			render.DepthRange(0, 1)
		end
	end
end)

function ENT:Think()
	if zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		if (IsValid(self.csModel)) then
			self.csModel:SetPos(self:GetPos())
			self.csModel:SetAngles(self:GetAngles())
		else
			self:CreateClientSideModel()
		end


		if (IsValid(self.csCartModel)) then
			local attachID = self:LookupAttachment("cart")

			if (attachID == 1) then
				self.csCartModel:SetPos(self:GetAttachment(attachID).Pos)
				local ang = self:GetAttachment(attachID).Ang
				ang:RotateAroundAxis(self:GetAttachment(attachID).Ang:Up(), 90)
				self.csCartModel:SetAngles(ang)
			end
		else
			self:CreateCart()
		end
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	if IsValid(self.csModel) then
		self.csModel:Remove()
	end

	if IsValid(self.csCartModel) then
		self.csCartModel:Remove()
	end
end
