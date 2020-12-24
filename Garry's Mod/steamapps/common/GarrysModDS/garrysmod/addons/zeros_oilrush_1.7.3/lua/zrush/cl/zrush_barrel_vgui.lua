if not CLIENT then return end

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

local zrush_BarrelMenu = {}
local zrush_BarrelMain = {}

zrush = zrush or {}
zrush.VGUI = zrush.VGUI or {}
zrush.VGUI.Barrel = zrush.VGUI.Barrel or {}

/////////// General
local function zrush_OpenUI()
	if IsValid(zrush_BarrelMenu_panel) then
		zrush_BarrelMenu_panel:SetVisible(true)
		zrush.VGUI.Barrel.UpdateUI()
	else
		zrush_BarrelMenu_panel = vgui.Create("zrush_vgui_BarrelMenu")
	end
end

local function zrush_CloseUI()
	if IsValid(zrush_BarrelMenu_panel) then
		if (zrush.config.Debug) then
			zrush_BarrelMenu_panel:Remove()
		else
			zrush_BarrelMenu_panel:SetVisible(false)
		end
	end

	local barrel = LocalPlayer().zrush_Barrel

	if IsValid(barrel) then
		timer.Simple(0.3, function()
			if IsValid(barrel) then
				net.Start("zrush_FuelSplitUIGotClosed_net")
				net.WriteEntity(barrel)
				net.SendToServer()
			end
		end)
	end
end

///////////
/////////// Init

function zrush.VGUI.Barrel.UpdateUI()
	local barrel = LocalPlayer().zrush_Barrel
	local fuelData = zrush.Fuel[barrel:GetFuelTypeID()]

	if IsValid(zrush_BarrelMain.FuelAmount) and IsValid(zrush_BarrelMain.Title) then
		zrush_BarrelMain.FuelAmount:SetText(zrush.language.VGUI.Barrel["FuelAmount"] .. math.Round(barrel:GetFuel()))
		zrush_BarrelMain.Title:SetText(fuelData.name)
		zrush_BarrelMain.Title:SetColor(fuelData.color)
	end

	if IsValid(zrush_BarrelMain.SplitButton) and zrush.f.VCMod_Installed() then
		local vcmodfuel = "nil"

		if (fuelData.vcmodfuel == 0) then
			vcmodfuel = "Petrol"
		else
			vcmodfuel = "Diesel"
		end

		local str = zrush.language.VGUI.Barrel["SpawnVCModFuelCan"]
		str = string.Replace(str, "$fueltype", vcmodfuel)
		zrush_BarrelMain.SplitButton:SetText(str)
	end
end

function zrush_BarrelMenu:Init()
	self:SetSize(300 * wMod, 400 * hMod)
	self:Center()
	self:MakePopup()
	local barrel = LocalPlayer().zrush_Barrel
	local fuelData = zrush.Fuel[barrel:GetFuelTypeID()]
	zrush_BarrelMain.ImageBG = vgui.Create("DImage", self)
	zrush_BarrelMain.ImageBG:SetPos(-50 * wMod, -2 * hMod)
	zrush_BarrelMain.ImageBG:SetSize(400 * wMod, 400 * hMod)
	zrush_BarrelMain.ImageBG:SetAutoDelete(true)

	zrush_BarrelMain.ImageBG.Paint = function(s,w, h)
		surface.SetDrawColor(zrush.default_colors["grey04"])
		surface.SetMaterial(zrush.default_materials["barrel_icon"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_BarrelMain.Title = vgui.Create("DLabel", self)
	zrush_BarrelMain.Title:SetPos(45 * wMod, 25 * hMod)
	zrush_BarrelMain.Title:SetSize(200 * wMod, 125 * hMod)
	zrush_BarrelMain.Title:SetFont("zrush_vgui_font03")
	zrush_BarrelMain.Title:SetText(fuelData.name)
	zrush_BarrelMain.Title:SetColor(fuelData.color)
	zrush_BarrelMain.Title:SetWrap(true)

	zrush_BarrelMain.close = vgui.Create("DButton", self)
	zrush_BarrelMain.close:SetText("")
	zrush_BarrelMain.close:SetPos(236 * wMod, 0 * hMod)
	zrush_BarrelMain.close:SetSize(50 * wMod, 50 * hMod)

	zrush_BarrelMain.close.DoClick = function()
		zrush_CloseUI()
	end

	zrush_BarrelMain.close.Paint = function(s,w, h)
		if zrush_BarrelMain.close:IsHovered() then
			surface.SetDrawColor(zrush.default_colors["red02_highlight"])
		else
			surface.SetDrawColor(zrush.default_colors["red02"])
		end

		surface.SetMaterial(zrush.default_materials["button02"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText("X", "zrush_vgui_font03", 25 * wMod, 25 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if zrush.f.VCMod_Installed() then
		local vcmodfuel = "nil"

		if (fuelData.vcmodfuel == 0) then
			vcmodfuel = "Petrol"
		else
			vcmodfuel = "Diesel"
		end

		zrush_BarrelMain.SplitButton = vgui.Create("DButton", self)
		local str = zrush.language.VGUI.Barrel["SpawnVCModFuelCan"]
		str = string.Replace(str, "$fueltype", vcmodfuel)

		zrush_BarrelMain.SplitButton:SetText(str)
		zrush_BarrelMain.SplitButton:SetFont("zrush_vgui_font10")
		zrush_BarrelMain.SplitButton:SetTextColor(zrush.default_colors["white01"])
		zrush_BarrelMain.SplitButton:SetContentAlignment(5)
		zrush_BarrelMain.SplitButton:SetPos(50 * wMod, 280 * hMod)
		zrush_BarrelMain.SplitButton:SetSize(200 * wMod, 50 * hMod)
		zrush_BarrelMain.SplitButton.DoClick = function()
			local abarrel = LocalPlayer().zrush_Barrel

			if IsValid(abarrel) then
				net.Start("zrush_BarrelSplitFuel_net")
				net.WriteEntity(abarrel)
				net.SendToServer()
			end

			zrush_CloseUI()
		end
		zrush_BarrelMain.SplitButton.Paint = function(s,w, h)
			if not zrush_BarrelMain.SplitButton:IsHovered() then
				surface.SetDrawColor(11, 179, 215, 255)
			else
				surface.SetDrawColor(13, 212, 255, 255)
			end

			surface.SetMaterial(zrush.default_materials["button"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_BarrelMain.Info = vgui.Create("DLabel", self)
		zrush_BarrelMain.Info:SetPos(50 * wMod, 325 * hMod)
		zrush_BarrelMain.Info:SetSize(225 * wMod, 70 * hMod)
		zrush_BarrelMain.Info:SetFont("zrush_vgui_font04")
		zrush_BarrelMain.Info:SetText(zrush.language.VGUI.Barrel["BarrelMenuInfo"])
		zrush_BarrelMain.Info:SetColor(zrush.default_colors["white01"])
		zrush_BarrelMain.Info:SetContentAlignment(5)
		zrush_BarrelMain.Info:SetWrap(true)
	end

	zrush_BarrelMain.FuelAmount = vgui.Create("DLabel", self)
	zrush_BarrelMain.FuelAmount:SetPos(50 * wMod, 115 * hMod)
	zrush_BarrelMain.FuelAmount:SetSize(600 * wMod, 125 * hMod)
	zrush_BarrelMain.FuelAmount:SetFont("zrush_vgui_font02")
	zrush_BarrelMain.FuelAmount:SetText(zrush.language.VGUI.Barrel["FuelAmount"] .. math.Round(barrel:GetFuel()))
	zrush_BarrelMain.FuelAmount:SetColor(zrush.default_colors["white01"])

	zrush_BarrelMain.AbsorbButton = vgui.Create("DButton", self)
	zrush_BarrelMain.AbsorbButton:SetText(zrush.language.VGUI.Barrel["Collect"])
	zrush_BarrelMain.AbsorbButton:SetFont("zrush_vgui_font09")
	zrush_BarrelMain.AbsorbButton:SetTextColor(zrush.default_colors["white01"])
	zrush_BarrelMain.AbsorbButton:SetContentAlignment(5)
	zrush_BarrelMain.AbsorbButton:SetPos(50 * wMod, 205 * hMod)
	zrush_BarrelMain.AbsorbButton:SetSize(200 * wMod, 50 * hMod)

	zrush_BarrelMain.AbsorbButton.DoClick = function()
		local bbarrel = LocalPlayer().zrush_Barrel

		if IsValid(bbarrel) then
			net.Start("zrush_BarrelCollectFuel_net")
			net.WriteEntity(bbarrel)
			net.SendToServer()
			zrush_CloseUI()
		end
	end

	zrush_BarrelMain.AbsorbButton.Paint = function(s,w, h)
		if not zrush_BarrelMain.AbsorbButton:IsHovered() then
			surface.SetDrawColor(2, 189, 158, 255)
		else
			surface.SetDrawColor(3, 255, 213, 255)
		end

		surface.SetMaterial(zrush.default_materials["button"])
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

function zrush_BarrelMenu:Paint(w, h)
	surface.SetDrawColor(70, 70, 70, 0)
	surface.SetMaterial(zrush.default_materials["square"])
	surface.DrawTexturedRect(0, 0, w, h)
end

///////////
vgui.Register("zrush_vgui_BarrelMenu", zrush_BarrelMenu, "Panel")

// This opens the machine ui for a user
net.Receive("zrush_OpenFuelSplitUI_net", function(len)
	LocalPlayer().zrush_Barrel = net.ReadEntity()
	zrush_OpenUI()
end)

// This close the ui
net.Receive("zrush_CloseFuelSplitUI_net", function(len)
	zrush_CloseUI()
end)
