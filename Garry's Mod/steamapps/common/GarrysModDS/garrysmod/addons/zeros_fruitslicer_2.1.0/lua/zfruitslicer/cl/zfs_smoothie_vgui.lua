if not CLIENT then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

local zfs_SellMenu = {}
local zfs_SellMenu_Main = {}
local zfs_SellMenu_Benefits = {}

local function zfs_OpenUI()
	if IsValid(zfs_SellMenu_panel) then
		zfs_SellMenu_panel:Remove()
	end

	zfs_SellMenu_panel = vgui.Create("zfs_SellMenu_VGUI")
end

local function zfs_CloseUI()
	if IsValid(zfs_SellMenu_panel) then
		zfs_SellMenu_panel:Remove()
	end
end

net.Receive("zfs_ItemBuy_net", function(len)
	LocalPlayer().zfs_SelectedItem = net.ReadInt(6)
	LocalPlayer().zfs_SelectedTopping = net.ReadInt(6)
	LocalPlayer().zfs_Price = net.ReadInt(24)
	LocalPlayer().zfs_ItemEnt = net.ReadEntity()

	zfs_OpenUI()
end)

net.Receive("zfs_ItemSellWindowClose_sv", function(len)
	zfs_CloseUI()
end)


local function zfs_Purchase_Cancel()
	zfs_CloseUI()
end

local function zfs_Purchase_Accept()
	zfs_CloseUI()
	// This Sends the purchase request to the Server
	net.Start("zfs_ItemBuy_cl")
	net.WriteEntity(LocalPlayer().zfs_ItemEnt)
	net.SendToServer()
end

function zfs_SellMenu:Init()
	self:SetSize(1400 * wMod, 800 * hMod)
	self:Center()
	self:MakePopup()

	local product = zfs.config.FruitCups[LocalPlayer().zfs_SelectedItem]
	local topping = zfs.config.Toppings[LocalPlayer().zfs_SelectedTopping]

	local indicatorColor = Color(product.fruitColor.r, product.fruitColor.g, product.fruitColor.b, 255)
	local hue = ColorToHSV(indicatorColor)
	indicatorColor = HSVToColor(hue, 0.7, 0.9)

	zfs_SellMenu_Main.indicator = vgui.Create("DImage", self)
	zfs_SellMenu_Main.indicator:SetSize(1400 * wMod, 800 * hMod)
	zfs_SellMenu_Main.indicator:SetPos(0 * wMod, 0 * hMod)
	zfs_SellMenu_Main.indicator:SetMaterial(zfs.default_materials["zfs_ui_sellbox_indicator"])
	zfs_SellMenu_Main.indicator:SetImageColor(indicatorColor)

	zfs_SellMenu_Main.cap = vgui.Create("DImage", self)
	zfs_SellMenu_Main.cap:SetSize(1400 * wMod, 800 * hMod)
	zfs_SellMenu_Main.cap:SetPos(0 * wMod, 0 * hMod)
	zfs_SellMenu_Main.cap:SetImage("materials/zfruitslicer/ui/zfs_ui_sellbox_cap.png")

	zfs_SellMenu_Main.close = vgui.Create("DButton", self)
	zfs_SellMenu_Main.close:SetText("")
	zfs_SellMenu_Main.close:SetPos(910 * wMod, 230 * hMod)
	zfs_SellMenu_Main.close:SetSize(50 * wMod, 50 * hMod)
	zfs_SellMenu_Main.close.DoClick = function()
		zfs_Purchase_Cancel()
	end
	zfs_SellMenu_Main.close.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["red08"])
		else
			surface.SetDrawColor(zfs.default_colors["red09"])
		end

		surface.SetMaterial(zfs.default_materials["zfs_ui_sellbox_close"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zfs_SellMenu_Main.purchase = vgui.Create("DButton", self)
	zfs_SellMenu_Main.purchase:SetText(zfs.language.Shop.Item_PurchaseButton)
	zfs_SellMenu_Main.purchase:SetTextColor(zfs.default_colors["white01"])
	zfs_SellMenu_Main.purchase:SetFont("zfs_VGUIButtonfont01")
	zfs_SellMenu_Main.purchase:SetPos(501 * wMod, 600 * hMod)
	zfs_SellMenu_Main.purchase:SetSize(175 * wMod, 50 * hMod)
	zfs_SellMenu_Main.purchase.DoClick = function()
		zfs_Purchase_Accept()
	end
	zfs_SellMenu_Main.purchase.Paint = function(s, w, h)
		if zfs_SellMenu_Main.purchase:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["green05"])
		else
			surface.SetDrawColor(zfs.default_colors["green06"])
		end

		surface.SetMaterial(zfs.default_materials["zfs_ui_sellbox_button"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zfs_SellMenu_Main.icon = vgui.Create("Panel", self)
	zfs_SellMenu_Main.icon:SetSize(130 * wMod, 130 * hMod)
	zfs_SellMenu_Main.icon:SetPos(515 * wMod, 107 * hMod)
	zfs_SellMenu_Main.icon.Paint = function(s, w, h)
		surface.SetDrawColor(zfs.default_colors["white01"])
		surface.SetMaterial(product.Icon)
		surface.DrawTexturedRect(0, 0, w, h)
	end


	zfs_SellMenu_Main.itemName = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.itemName:SetPos(460 * wMod, 225 * hMod)
	zfs_SellMenu_Main.itemName:SetSize(400 * wMod, 100 * hMod)
	zfs_SellMenu_Main.itemName:SetFont("zfs_VGUIfont03")
	zfs_SellMenu_Main.itemName:SetText(product.Name)
	zfs_SellMenu_Main.itemName:SetTextColor(indicatorColor)

	zfs_SellMenu_Main.priceValue = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.priceValue:SetPos(470 * wMod, 263 * hMod)
	zfs_SellMenu_Main.priceValue:SetSize(200 * wMod, 100 * hMod)
	zfs_SellMenu_Main.priceValue:SetFont("zfs_VGUIfont01")
	zfs_SellMenu_Main.priceValue:SetText(tostring(LocalPlayer().zfs_Price) .. zfs.config.Currency)
	zfs_SellMenu_Main.priceValue:SetTextColor(zfs.default_colors["green07"])

	zfs_SellMenu_Main.healthBar = vgui.Create("DImage", self)
	zfs_SellMenu_Main.healthBar:SetPos(470 * wMod, 345 * hMod)
	zfs_SellMenu_Main.healthBar:SetSize(225 * wMod, 30 * hMod)
	zfs_SellMenu_Main.healthBar.Paint = function(s, w, h)
		surface.SetDrawColor(zfs.default_colors["black10"])
		surface.SetMaterial(zfs.default_materials["fs_ui_bar"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zfs_SellMenu_Main.healthText = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.healthText:SetPos(480 * wMod, 311 * hMod)
	zfs_SellMenu_Main.healthText:SetSize(200 * wMod, 100 * hMod)
	zfs_SellMenu_Main.healthText:SetFont("zfs_VGUIfont01")
	zfs_SellMenu_Main.healthText:SetText(zfs.language.VGUI.HealthBoni)
	zfs_SellMenu_Main.healthText:SetTextColor(zfs.default_colors["white01"])

	// This gives the player the Default Health of the Fruitcup
	local extraHealth = zfs.f.CalculateFruitHealth(zfs.config.FruitCups[LocalPlayer().zfs_SelectedItem])
	//extraHealth = math.Clamp(extraHealth, 0, zfs.config.Health.MaxReward)
	extraHealth = math.Round(extraHealth)

	zfs_SellMenu_Main.healthValue = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.healthValue:SetPos(645 * wMod, 311 * hMod)
	zfs_SellMenu_Main.healthValue:SetSize(200 * wMod, 100 * hMod)
	zfs_SellMenu_Main.healthValue:SetFont("zfs_VGUIfont01")
	zfs_SellMenu_Main.healthValue:SetText("+" .. tostring(extraHealth))
	zfs_SellMenu_Main.healthValue:SetTextColor(zfs.default_colors["white01"])

	local descriptionColor = Color(product.fruitColor.r, product.fruitColor.g, product.fruitColor.b, 255)
	local ih = ColorToHSV(descriptionColor)
	descriptionColor = HSVToColor(ih, 0, 0.2)
	zfs_SellMenu_Main.description = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.description:SetPos(480 * wMod, 465 * hMod)
	zfs_SellMenu_Main.description:SetSize(225 * wMod, 400 * hMod)
	zfs_SellMenu_Main.description:SetFont("zfs_VGUIfont02")
	zfs_SellMenu_Main.description:SetColor(descriptionColor)
	zfs_SellMenu_Main.description:SetText(product.Info)
	zfs_SellMenu_Main.description:SetWrap(true)
	zfs_SellMenu_Main.description:SetAutoStretchVertical(true)

	zfs_SellMenu_Main.Topping_Name = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.Topping_Name:SetPos(825 * wMod, 340 * hMod)
	zfs_SellMenu_Main.Topping_Name:SetSize(200 * wMod, 100 * hMod)
	zfs_SellMenu_Main.Topping_Name:SetFont("zfs_VGUIfont01")
	zfs_SellMenu_Main.Topping_Name:SetText(tostring(topping.Name))
	zfs_SellMenu_Main.Topping_Name:SetTextColor(zfs.default_colors["blue03"])

	local toppingInfo = string.Replace(tostring(topping.Info), "\n", "  ")
	zfs_SellMenu_Main.Topping_Desc = vgui.Create("DLabel", self)
	zfs_SellMenu_Main.Topping_Desc:SetPos(825 * wMod, 370 * hMod)
	zfs_SellMenu_Main.Topping_Desc:SetSize(130 * wMod, 100 * hMod)
	zfs_SellMenu_Main.Topping_Desc:SetFont("zfs_VGUI_Desc")
	zfs_SellMenu_Main.Topping_Desc:SetText(toppingInfo)
	zfs_SellMenu_Main.Topping_Desc:SetTextColor(zfs.default_colors["black04"])
	zfs_SellMenu_Main.Topping_Desc:SetWrap(true)

	// Only create the Topping Model snapshot and Benefits List if the Selected topping item from the table is not 1 aka No Topping
	if (LocalPlayer().zfs_SelectedTopping ~= 1) then
		zfs_SellMenu_Main.Topping_Icon = vgui.Create("SpawnIcon", self)
		zfs_SellMenu_Main.Topping_Icon:SetSize(70 * wMod, 70 * hMod)
		zfs_SellMenu_Main.Topping_Icon:SetPos(755 * wMod, 374 * hMod)
		zfs_SellMenu_Main.Topping_Icon:SetModel(topping.Model)

		zfs_SellMenu_Main.Benefitspanel = vgui.Create("Panel", self)
		zfs_SellMenu_Main.Benefitspanel:SetPos(754 * wMod, 439 * hMod)
		zfs_SellMenu_Main.Benefitspanel:SetSize(210 * wMod, 180 * hMod)
		zfs_SellMenu_Main.Benefitspanel.Paint = function(s, w, h)
			surface.SetDrawColor(zfs.default_colors["black01"])
			surface.DrawRect(0, 0, w, h)
		end

		zfs_SellMenu.Benefits(zfs_SellMenu_Main.Benefitspanel, topping)
	else
		zfs_SellMenu_Main.Topping_Icon = vgui.Create("DImage", self)
		zfs_SellMenu_Main.Topping_Icon:SetSize(60 * wMod, 60 * hMod)
		zfs_SellMenu_Main.Topping_Icon:SetPos(770 * wMod, 378 * hMod)
		zfs_SellMenu_Main.Topping_Icon:SetImage("materials/zfruitslicer/ui/zfs_ui_nothing.png")
		zfs_SellMenu_Main.Topping_Icon:SetImageColor(zfs.default_colors["red10"])
	end
end

function zfs_SellMenu.Benefits(parent, topping)

	zfs_SellMenu_Benefits.panel = vgui.Create("DScrollPanel", parent)
	zfs_SellMenu_Benefits.panel:SetSize(210 * wMod, 180 * hMod)
	zfs_SellMenu_Benefits.panel:DockMargin(10 * wMod, 4 * hMod, 10 * wMod, 10 * hMod)
	zfs_SellMenu_Benefits.panel:Dock(FILL)
	zfs_SellMenu_Benefits.panel.Paint = function(self, w, h)
		surface.SetDrawColor(zfs.default_colors["black01"])
		surface.DrawRect(0, 0, w, h)
	end

	zfs_SellMenu_Benefits.panel:GetVBar().Paint = function() return true end
	zfs_SellMenu_Benefits.panel:GetVBar().btnUp.Paint = function() return true end
	zfs_SellMenu_Benefits.panel:GetVBar().btnDown.Paint = function() return true end
	zfs_SellMenu_Benefits.panel:GetVBar().btnGrip.Paint = function() return true end

	zfs_SellMenu_Benefits.list = vgui.Create("DIconLayout", zfs_SellMenu_Benefits.panel)
	zfs_SellMenu_Benefits.list:SetSize(210 * wMod, 180 * hMod)
	zfs_SellMenu_Benefits.list:SetPos(0 * wMod, 0 * hMod)
	zfs_SellMenu_Benefits.list:SetSpaceY(3 * hMod)
	local itemPaddingX = 15 * wMod

	if topping.ToppingBenefits ~= nil then
		for k, v in pairs(topping.ToppingBenefits) do

			zfs_SellMenu_Benefits[k] = zfs_SellMenu_Benefits.list:Add("DPanel")
			zfs_SellMenu_Benefits[k]:SetSize(zfs_SellMenu_Benefits.list:GetWide(), 30 * hMod)
			zfs_SellMenu_Benefits[k].Paint = function(self, w, h)
				surface.SetDrawColor(zfs.default_colors["black01"])
				surface.DrawRect(0, 0, w, h)
			end

			zfs_SellMenu_Benefits[k].iconBG = vgui.Create("DImage", zfs_SellMenu_Benefits[k])
			zfs_SellMenu_Benefits[k].iconBG:SetSize(32 * wMod, 32 * hMod)
			zfs_SellMenu_Benefits[k].iconBG:SetPos((itemPaddingX - 1) * wMod, -1 * hMod)
			zfs_SellMenu_Benefits[k].iconBG:SetImage("materials/zfruitslicer/ui/zfs_ui_toppingbg.png")
			zfs_SellMenu_Benefits[k].iconBG:SetImageColor(zfs.default_colors["white06"])

			zfs_SellMenu_Benefits[k].icon = vgui.Create("DPanel", zfs_SellMenu_Benefits[k])
			zfs_SellMenu_Benefits[k].icon:SetSize(29 * wMod, 29 * hMod)
			zfs_SellMenu_Benefits[k].icon:SetPos((itemPaddingX + 0.1) * wMod, 1 * hMod)
			zfs_SellMenu_Benefits[k].icon.Paint = function(s, w, h)
				surface.SetDrawColor(zfs.default_colors["white01"])
				surface.SetMaterial(zfs.utility.BenefitsIcons[k])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zfs_SellMenu_Benefits[k].BName = vgui.Create("DLabel", zfs_SellMenu_Benefits[k])
			zfs_SellMenu_Benefits[k].BName:SetSize(140 * wMod, 35 * hMod)
			zfs_SellMenu_Benefits[k].BName:SetPos((itemPaddingX + 35) * wMod, -8 * hMod)
			zfs_SellMenu_Benefits[k].BName:SetFont("zfs_VGUIBenefitFont01")
			zfs_SellMenu_Benefits[k].BName:SetText(tostring(k))
			zfs_SellMenu_Benefits[k].BName:SetTextColor(zfs.default_colors["black02"])
			local bInfo

			if (k == "Health") then
				bInfo = "+" .. tostring(v)
			elseif (k == "ParticleEffect") then
				bInfo = tostring(v)
			elseif (k == "SpeedBoost") then
				bInfo = "+" .. tostring(v)
			elseif (k == "AntiGravity") then
				bInfo = "+" .. tostring(v)
			elseif (k == "Ghost") then
				bInfo = "(" .. tostring(v) .. "/255)"
			elseif (k == "Drugs") then
				bInfo = tostring(v)
			end

			zfs_SellMenu_Benefits[k].BValue = vgui.Create("DLabel", zfs_SellMenu_Benefits[k])
			zfs_SellMenu_Benefits[k].BValue:SetSize(140 * wMod, 35 * hMod)
			zfs_SellMenu_Benefits[k].BValue:SetPos((itemPaddingX + 35) * wMod, 7 * hMod)
			zfs_SellMenu_Benefits[k].BValue:SetFont("zfs_VGUIBenefitFont02")
			zfs_SellMenu_Benefits[k].BValue:SetText(tostring(bInfo))
			zfs_SellMenu_Benefits[k].BValue:SetTextColor(zfs.default_colors["green08"])
		end
	end
end

function zfs_SellMenu:Paint(w, h)
	surface.SetDrawColor(zfs.default_colors["white01"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_sellbox_main"])
	surface.DrawTexturedRect(0 * wMod, 0 * hMod, w, h)
end

vgui.Register("zfs_SellMenu_VGUI", zfs_SellMenu, "Panel")
