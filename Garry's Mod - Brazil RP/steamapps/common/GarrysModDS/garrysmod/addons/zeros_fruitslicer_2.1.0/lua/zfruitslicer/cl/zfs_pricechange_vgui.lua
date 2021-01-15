if not CLIENT then return end
local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

local zfs_PriceChanger = {}
local zfs_PriceChanger_Main = {}

local function zfs_OpenUI()
	if IsValid(zfs_PriceChanger_panel) then
		zfs_PriceChanger_panel:Remove()
	end

	zfs_PriceChanger_panel = vgui.Create("zfs_PriceChanger_VGUI")
end

local function zfs_CloseUI()

	if IsValid(zfs_PriceChanger_panel) then
		zfs_PriceChanger_panel:Remove()
	end
end

local function zfs_ChangePrice(inputval)

	local PriceChangeInfo = {}
	PriceChangeInfo.ChangedPrice = tonumber(inputval)
	PriceChangeInfo.Shop = LocalPlayer().zfs_Shop

	net.Start("zfs_ItemPriceChange_sv")
	net.WriteTable(PriceChangeInfo)
	net.SendToServer()

	zfs_CloseUI()
end



net.Receive("zfs_ItemPriceChange_cl", function(len)
	local customPriceInfo = net.ReadTable()
	LocalPlayer().zfs_Price = customPriceInfo.Price
	LocalPlayer().zfs_SelectedItem = customPriceInfo.selectedItem
	LocalPlayer().zfs_Shop = customPriceInfo.Shop

	zfs_OpenUI()
end)



function zfs_PriceChanger:Init()
	self:SetSize(600 * wMod, 200 * hMod)
	self:Center()
	self:MakePopup()

	zfs_PriceChanger_Main.close = vgui.Create("DButton", self)
	zfs_PriceChanger_Main.close:SetText("")
	zfs_PriceChanger_Main.close:SetPos(503.5 * wMod, 0.8 * hMod)
	zfs_PriceChanger_Main.close:SetSize(100 * wMod, 26.8 * hMod)
	zfs_PriceChanger_Main.close.DoClick = function()
		zfs_CloseUI()
	end
	zfs_PriceChanger_Main.close.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["white02"])
		else
			surface.SetDrawColor(zfs.default_colors["black01"])
		end
		surface.DrawRect(0, 0, w, h)

		draw.DrawText(zfs.language.Shop.ChangePrice_Cancel, "zfs_ChangePriceButtonFont01", 48 * wMod, 2 * hMod, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
	end

	zfs_PriceChanger_Main.PriceField = vgui.Create("DTextEntry", self)
	zfs_PriceChanger_Main.PriceField:SetPos(142 * wMod, 88 * hMod)
	zfs_PriceChanger_Main.PriceField:SetSize(320 * wMod, 50 * hMod)
	zfs_PriceChanger_Main.PriceField:SetNumeric(true)
	zfs_PriceChanger_Main.PriceField:SetFont("zfs_TextFieldFont01")
	zfs_PriceChanger_Main.PriceField:SetTextColor(zfs.default_colors["green01"])

	zfs_PriceChanger_Main.PriceField:SetValue(LocalPlayer().zfs_Price)

	zfs_PriceChanger_Main.symbol01 = vgui.Create("DLabel", self)
	zfs_PriceChanger_Main.symbol01:SetPos(30 * wMod, 40 * hMod)
	zfs_PriceChanger_Main.symbol01:SetSize(100 * wMod, 200 * hMod)
	zfs_PriceChanger_Main.symbol01:SetFont("zfs_SymboldFont01")
	zfs_PriceChanger_Main.symbol01:SetColor(zfs.default_colors["yellow01"])
	zfs_PriceChanger_Main.symbol01:SetText(zfs.config.Currency)
	zfs_PriceChanger_Main.symbol01:SetAutoStretchVertical(true)

	zfs_PriceChanger_Main.symbol02 = vgui.Create("DLabel", self)
	zfs_PriceChanger_Main.symbol02:SetPos(495 * wMod, 40 * hMod)
	zfs_PriceChanger_Main.symbol02:SetSize(100 * wMod, 200 * hMod)
	zfs_PriceChanger_Main.symbol02:SetFont("zfs_SymboldFont01")
	zfs_PriceChanger_Main.symbol02:SetColor(zfs.default_colors["yellow01"])
	zfs_PriceChanger_Main.symbol02:SetText(zfs.config.Currency)
	zfs_PriceChanger_Main.symbol02:SetAutoStretchVertical(true)

	zfs_PriceChanger_Main.ChangePrice = vgui.Create("DButton", self)
	zfs_PriceChanger_Main.ChangePrice:SetText("")
	zfs_PriceChanger_Main.ChangePrice:SetPos(0 * wMod, 0 * hMod)
	zfs_PriceChanger_Main.ChangePrice:SetSize(107 * wMod, 27 * hMod)
	zfs_PriceChanger_Main.ChangePrice.DoClick = function()
		if zfs_PriceChanger_Main and IsValid(zfs_PriceChanger_Main.PriceField) then
			local inputval = zfs_PriceChanger_Main.PriceField:GetValue()
			if inputval then
				zfs_ChangePrice(inputval)
			end
		end
	end
	zfs_PriceChanger_Main.ChangePrice.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["white02"])
		else
			surface.SetDrawColor(zfs.default_colors["black01"])
		end
		surface.DrawRect(0, 0, w, h)

		draw.DrawText(zfs.language.Shop.ChangePrice_Confirm, "zfs_ChangePriceButtonFont01", 52 * wMod, 2 * hMod, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
	end
end

function zfs_PriceChanger:Paint(w, h)
	surface.SetDrawColor(zfs.default_colors["white01"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_changeprice"])
	surface.DrawTexturedRect(0, 0, w, h)
end

/*
function zfs_PriceChanger:UpdateInfo()
	local product_ConfigID = zfs.config.FruitCups[LocalPlayer().zfs_SelectedItem]
	local CustomPrice = LocalPlayer().zfs_Price
	local visualPrice

	if (CustomPrice < zfs.config.PriceMinimum or CustomPrice > zfs.config.PriceMaximum) then
		visualPrice = product_ConfigID.Price
	else
		visualPrice = LocalPlayer().zfs_Price
	end

	return visualPrice
end
*/

vgui.Register("zfs_PriceChanger_VGUI", zfs_PriceChanger, "EditablePanel")
