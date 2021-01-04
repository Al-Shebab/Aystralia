if (not CLIENT) then return end
zfs = zfs or {}
zfs.f = zfs.f or {}


local ScreenW, ScreenH = 390, 260
local iconSize = 50
local productBoxX, productBoxY = -ScreenW * 0.61, -ScreenH * 0.36
local margin = 3

//////////////////////////////////////////////////////////////
/////////////////////// Initialize ///////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.Shop_Initialize(Shop)
	zfs.f.EntList_Add(Shop)

	Shop.CurrentState = 0
	Shop.initialdiff = 100000000000000000000
	Shop.lastHitItem = nil
	Shop.nearestItem = nil
	Shop.IsHovering = false

	zfs.f.Shop_CreateToppingModelSnapshots(Shop)
	zfs.f.Shop_SetupDerma2D3D(Shop)
end

// Creats other needed Derma stuff for 2D3D
function zfs.f.Shop_SetupDerma2D3D(Shop)
	// Creats our product info label
	Shop.PDescription = vgui.Create("DLabel", Shop.Mframe)
	Shop.PDescription:SetPos(245, 25)
	Shop.PDescription:SetSize(130, 50)
	Shop.PDescription:SetFont("zfs_ProductInfo")
	Shop.PDescription:SetColor(zfs.default_colors["white01"])
	Shop.PDescription:SetText("lorem upsum ddf du bist so ganz und so sun")
	Shop.PDescription:SetWrap(true)
	Shop.PDescription:SetPaintedManually(true)
	Shop.PDescription:SetVisible(false)
	Shop.PDescription:SetAutoStretchVertical(true)
end

// This Creates all the UI Model Snapshots for the Topping selection Base on Initialize
function zfs.f.Shop_CreateToppingModelSnapshots(Shop)
	Shop.MSpawnIcons = {}
	Shop.Mframe = vgui.Create("DFrame")
	Shop.Mframe:SetSize(ScreenW, ScreenH)
	Shop.Mframe:SetPos(0, 0)
	Shop.Mframe:SetPaintedManually(true)

	for i, k in pairs(zfs.utility.SortedToppingsTable) do
		local x, y = zfs.f.Shop_CalcNextLine(7, i, iconSize, margin, -46, 5)
		Shop.MSpawnIcons[i] = vgui.Create("SpawnIcon", Shop.Mframe) // SpawnIcon
		Shop.MSpawnIcons[i]:SetPos(x, y)
		Shop.MSpawnIcons[i]:SetSize(40, 40)
		Shop.MSpawnIcons[i]:SetModel(k.Model) // Model we want for this spawn icon

		// Dont Paint the no topping 
		if (i == 1) then
			Shop.MSpawnIcons[i]:SetPaintedManually(false)
		else
			Shop.MSpawnIcons[i]:SetPaintedManually(true)
		end

	end
end

// This Creates a UI Model Snapshot for our Topping Confirmation
function zfs.f.Shop_CreateSelectedToppingModel(Shop,i, x, y)
	Shop.selectedToppingModel = vgui.Create("SpawnIcon", Shop.Mframe)
	Shop.selectedToppingModel:SetPos(x, y)
	Shop.selectedToppingModel:SetSize(60, 60)
	Shop.selectedToppingModel:SetModel(zfs.utility.SortedToppingsTable[i].Model)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////
/////////////////////////// MAIN  ///////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.Shop_Think(Shop)

	//Here we create or remove the client models
	if zfs.f.InDistance(LocalPlayer():GetPos(), Shop:GetPos(), 1000) then

		zfs.f.Shop_Lights(Shop)
		zfs.f.Shop_FrozzeEffect(Shop)
		zfs.f.Shop_SweetenerFillSound(Shop)

		Shop.CurrentState = Shop:GetCurrentState()

		if Shop.ClientProps then

			if not IsValid(Shop.ClientProps["r_wheel"]) then
				zfs.f.Shop_SpawnWheel(Shop,"r_wheel")
			end

			if not IsValid(Shop.ClientProps["l_wheel"]) then
				zfs.f.Shop_SpawnWheel(Shop,"l_wheel")
			end

			if not IsValid(Shop.ClientProps["Glass"]) then
				zfs.f.Shop_SpawnWindows(Shop)
			end

			if not IsValid(Shop.ClientProps["FruitPile"]) then
				zfs.f.Shop_SpawnFruitPile(Shop)
			end
		else
			Shop.ClientProps = {}
		end
	else
		zfs.f.Shop_RemoveClientModels(Shop)
		Shop.ClientProps = {}

		if Shop.SoundObj and Shop.SoundObj:IsPlaying() then
			Shop.SoundObj:Stop()
		end
	end
end

function zfs.f.Shop_OnRemove(Shop)
	zfs.f.Shop_RemoveClientModels(Shop)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////
////////////////////////// DRAW //////////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.Shop_Draw(Shop)
	if zfs.f.InDistance(Shop:GetPos(), LocalPlayer():GetPos(), 200) then
		zfs.f.Shop_DrawInterface(Shop)

		if zfs.config.SharedEquipment then
			zfs.f.Shop_DrawOccupiedInfo(Shop)
		end
	end
end

//This Draws the Occupied Interface
function zfs.f.Shop_DrawOccupiedInfo(Shop)
	local player = Shop:GetOccupiedPlayer()
	if IsValid(player) then

		cam.Start3D2D(Shop:LocalToWorld(Vector(0,0,150 + (1 * math.abs(math.sin(CurTime()) * 15)) )), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
			draw.RoundedBox(25, -120, 15, 700, 150, zfs.default_colors["black03"])

			surface.SetDrawColor(zfs.default_colors["white01"])
			surface.SetMaterial(zfs.default_materials["zfs_ui_makeproduct"])
			surface.DrawTexturedRect(-400, -100, 390, 260)

			draw.DrawText(player:Nick(), "zfs_OccupiedFont01", -90, 25, zfs.default_colors["red03"], TEXT_ALIGN_LEFT)
			//draw.DrawText("Occupied by " .. player:Nick(), "zfs_OccupiedFont01", 0, 0, zfs.default_colors["red03"], TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

//This Draw the Main interface
function zfs.f.Shop_DrawInterface(Shop)

	cam.Start3D2D(Shop:LocalToWorld(Vector(-24.3, 18.3, 65)), Shop:LocalToWorldAngles(Angle(0, 180, 105)), 0.07)

		if Shop:GetIsBusy() then
			zfs.f.Shop_ui_IsBusy()
		elseif (Shop.CurrentState == 0) then
			zfs.f.Shop_ui_EnableStand(Shop)
		elseif (Shop.CurrentState == 1) then
			zfs.f.Shop_DrawBaseScreen("ZerosFruitSlicer OS v1.0")
			zfs.f.Shop_ui_ShowStorage(Shop)
			zfs.f.Shop_ui_MakeProduct(Shop)

			if (Shop:GetPublicEntity() == false) then
				zfs.f.Shop_ui_Disable(Shop)
			end
		elseif (Shop.CurrentState == 2) then
			zfs.f.Shop_DrawBaseScreen(zfs.language.Shop.StorageTitle)
			zfs.f.Shop_ui_Cancel(Shop, zfs.language.Shop.StorageBackButton)
			zfs.f.Shop_ui_Storage(Shop)
		elseif (Shop.CurrentState == 3 and Shop:GetTSelectedItem() == -1) then
			zfs.f.Shop_DrawBaseScreen(zfs.language.Shop.Screen_Product_Select)
			zfs.f.Shop_ui_Cancel(Shop, zfs.language.Shop.Screen_Cancel)
			zfs.f.Shop_ui_ProductSelection(Shop)
		elseif (Shop.CurrentState == 4) then
			zfs.f.Shop_ui_ProductConfirmation(Shop)
		elseif (Shop.CurrentState == 5) then
			zfs.f.Shop_DrawBaseScreen(zfs.language.Shop.Screen_Topping_Select)
			zfs.f.Shop_ui_Cancel(Shop, zfs.language.Shop.Screen_Cancel)
			zfs.f.Shop_ui_ToppingSelection(Shop)
		elseif (Shop.CurrentState == 6) then
			zfs.f.Shop_DrawBaseScreen(zfs.language.Shop.Screen_Confirm_Topping)
			zfs.f.Shop_ui_ToppingConfirmation(Shop)
		elseif (Shop.CurrentState == 7) then
			zfs.f.Shop_DrawBaseScreen("")
			zfs.f.Shop_ui_InfoBox(zfs.language.Shop.Screen_Info01, "TakeCup")
		elseif (Shop.CurrentState == 8) then
			zfs.f.Shop_DrawBaseScreen("")
			zfs.f.Shop_ui_InfoBox(zfs.language.Shop.Screen_Info02, "SliceFruits")
		elseif (Shop.CurrentState == 9) then
			zfs.f.Shop_DrawBaseScreen("")
			zfs.f.Shop_ui_InfoBox(zfs.language.Shop.Screen_Info04, "ChooseSweetener")
		elseif (Shop.CurrentState == 11) then
			zfs.f.Shop_DrawBaseScreen("")
			zfs.f.Shop_ui_InfoBox(zfs.language.Shop.Screen_Info03, "StartTheBlender")
		end
	cam.End3D2D()

	cam.Start3D2D(Shop:LocalToWorld(Vector(-11.2, 20, 71.4)), Shop:LocalToWorldAngles(Angle(0, 180, 105)), 0.07)

		if (Shop.CurrentState == 4) then
			Shop.PDescription:PaintManual()
		elseif (Shop.CurrentState == 5) then
			// This Rebuilds makes sure our model snapshot gets rebuild
			if (Shop.selectedToppingModel) then
				Shop.selectedToppingModel = nil
			end

			// This Renders all our Topping Model Snapshots
			for i, k in pairs(Shop.MSpawnIcons) do
				if (i ~= 1) then
					Shop.MSpawnIcons[i]:PaintManual()
				end
			end
		elseif (Shop.CurrentState == 6) then
			// This Renders the Model Snapshot if its not number 1 aka the Cancel Icon
			if (Shop:GetTSelectedTopping() ~= 1) then
				local selectedTopping = Shop:GetTSelectedTopping()

				if (Shop.selectedToppingModel) then
					Shop.selectedToppingModel:PaintManual()
				else

					zfs.f.Shop_CreateSelectedToppingModel(Shop,selectedTopping, 18, 11)
				end
			end
		end
	cam.End3D2D()
end

// This creates the Main Screen Frame
function zfs.f.Shop_DrawBaseScreen(toptitle)
	draw.RoundedBox(2, -ScreenW * 0.5, -130, ScreenW, ScreenH, zfs.default_colors["black04"])
	draw.RoundedBox(0, -ScreenW * 0.48, -ScreenH * 0.363, ScreenW * 0.96, ScreenH * 0.834, zfs.default_colors["black05"])
	draw.RoundedBox(0, -ScreenW * 0.5, -ScreenH * 0.39, ScreenW, 2, zfs.default_colors["white04"])
	draw.DrawText(toptitle, "zfs_MainBoxTitle", -ScreenW * 0.475, -ScreenW * 0.315, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
////////////////////////// UI //////////////////////////////
//////////////////////////////////////////////////////////////

// This adds the Cancel button to the menu
function zfs.f.Shop_ui_Cancel(Shop,text)
	local ButtonBackToMainColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-33, -37.5, 21, 20.5) then
		ButtonBackToMainColor = zfs.default_colors["red04"]
	else
		local h, s, v = ColorToHSV(zfs.default_colors["red04"])
		ButtonBackToMainColor = HSVToColor(h, s, v - 0.3)
	end

	//Buttons
	draw.RoundedBox(3, ScreenW * 0.32, -ScreenH * 0.465, ScreenW * 0.16, ScreenH * 0.058, ButtonBackToMainColor)
	draw.DrawText(text, "zfs_BaseCancel", ScreenW * 0.4, -ScreenH * 0.468, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
end

// This tells the Player do wait
function zfs.f.Shop_ui_IsBusy()
	zfs.f.Shop_DrawBaseScreen("ZerosFruitSlicer OS v1.0")

	draw.DrawText(zfs.language.Shop.Screen_Wait, "zfs_buttonfont01", 0, -ScreenH * 0.07, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
end

// This asks us if we want do enable the stand
function zfs.f.Shop_ui_EnableStand(Shop)
	zfs.f.Shop_DrawBaseScreen("ZerosFruitSlicer OS v1.0")

	local buttonAssemblesColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-18.5, -30, 19.7, 17) then
		buttonAssemblesColor = zfs.default_colors["white05"]
	else
		buttonAssemblesColor = zfs.default_colors["black06"]
	end

	local xSize, ySize = ScreenW * 0.4, ScreenH * 0.55
	local xPos, yPos = -ScreenW * 0.22, -ScreenH * 0.23

	surface.SetDrawColor(buttonAssemblesColor)
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(zfs.default_colors["white01"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_assmble"])
	surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
	draw.NoTexture()

	if zfs.f.Shop_CalcWorldElementPos(Shop,-18.5, -30, 19.7, 17) then
		surface.SetDrawColor(zfs.default_colors["green04"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_product_hover"])
		surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
		draw.NoTexture()
	end
end

// This adds the disable button to the menu
function zfs.f.Shop_ui_Disable(Shop)
	local xSize, ySize = ScreenW * 0.3, ScreenH * 0.4
	local xPos, yPos = -ScreenW * 0.47, -ScreenH * 0.345
	// Disable Button
	local buttonDessambleColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-12, -20, 20, 18.2) then
		buttonDessambleColor = zfs.default_colors["black01"]
	else
		buttonDessambleColor = zfs.default_colors["black07"]
	end

	surface.SetDrawColor(zfs.default_colors["white05"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(buttonDessambleColor)
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(zfs.default_colors["white06"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_desamble"])
	surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
	draw.NoTexture()

	if zfs.f.Shop_CalcWorldElementPos(Shop,-12, -20, 20, 18.2) then
		surface.SetDrawColor(zfs.default_colors["green04"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_product_hover"])
		surface.DrawTexturedRect(xPos, yPos, xSize, ySize)
		draw.NoTexture()
	end
end

// This adds the MakeProduct button to the menu
function zfs.f.Shop_ui_MakeProduct(Shop)
	local xSize, ySize = ScreenW * 0.3, ScreenH * 0.4
	local xPos, yPos = -ScreenW * 0.47, -ScreenH * 0.345
	local buttonMakeProduct

	if zfs.f.Shop_CalcWorldElementPos(Shop,-21, -29, 20, 18.2) then
		buttonMakeProduct = zfs.default_colors["black01"]
	else
		buttonMakeProduct = zfs.default_colors["black07"]
	end

	surface.SetDrawColor(zfs.default_colors["white05"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos + 125, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(buttonMakeProduct)
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos + 125, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(zfs.default_colors["white06"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_makeproduct"])
	surface.DrawTexturedRect(xPos + 104, yPos, xSize * 1.4, ySize)
	draw.NoTexture()

	if zfs.f.Shop_CalcWorldElementPos(Shop,-21, -29, 20, 18.2) then
		surface.SetDrawColor(zfs.default_colors["green04"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_product_hover"])
		surface.DrawTexturedRect(xPos + 125, yPos, xSize, ySize)
		draw.NoTexture()
	end
end

// This adds the ShowStorage button to the menu
function zfs.f.Shop_ui_ShowStorage(Shop)
	local xSize, ySize = ScreenW * 0.3, ScreenH * 0.4
	local xPos, yPos = -ScreenW * 0.47, -ScreenH * 0.345
	local buttonMakeProduct

	if zfs.f.Shop_CalcWorldElementPos(Shop,-29, -37, 20, 18.2) then
		buttonMakeProduct = zfs.default_colors["black01"]
	else
		buttonMakeProduct = zfs.default_colors["black07"]
	end

	surface.SetDrawColor(zfs.default_colors["white05"])
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos + 250, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(buttonMakeProduct)
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(xPos + 250, yPos, xSize, ySize)
	draw.NoTexture()

	surface.SetDrawColor(zfs.default_colors["white06"])
	surface.SetMaterial(zfs.default_materials["fs_ui_storage"])
	surface.DrawTexturedRect(xPos + 262, yPos + 12, xSize / 1.3, ySize / 1.3)
	draw.NoTexture()

	if zfs.f.Shop_CalcWorldElementPos(Shop,-29, -37, 20, 18.2) then
		surface.SetDrawColor(zfs.default_colors["green04"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_product_hover"])
		surface.DrawTexturedRect(xPos + 250, yPos, xSize, ySize)
		draw.NoTexture()
	end
end

// The Storage UI
function zfs.f.Shop_ui_Storage(Shop)
	local xSize, ySize = ScreenW * 0.15, ScreenH * 0.2
	local xPos, yPos = -ScreenW * 0.46, -ScreenH * 0.345
	zfs.f.Shop_ui_FruitStorageItems(Shop.StoredFruits, xPos, yPos, xSize, ySize)
end

// This adds a Fruit Storage UI Element if we have the fruit in our storage
function zfs.f.Shop_ui_FruitStorageItems(fruits, x, y, sizeX, sizeY)
	if (fruits == nil or table.Count(fruits) <= 0) then
		print("FruitArray is nil!")

		return
	end

	local rowCount = 5
	local itemCount = 0
	local nextX = 0
	local nextY = 0

	for k, v in pairs(fruits) do
		if fruits[k] > 0 then
			if (itemCount > rowCount) then
				nextY = 54
				nextX = 60 * (itemCount - rowCount * 1.21)
				itemCount = itemCount + 1
			else
				itemCount = itemCount + 1
				nextX = 60 * (itemCount - rowCount * 0.21)
			end

			surface.SetDrawColor(zfs.config.Item_BG)
			surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
			surface.DrawTexturedRect(x + nextX, y + nextY, sizeX, sizeY)
			draw.NoTexture()

			surface.SetDrawColor(zfs.default_colors["white06"])
			surface.SetMaterial(zfs.default_materials[k])
			surface.DrawTexturedRect(x + nextX, y + nextY, sizeX, sizeY)
			draw.NoTexture()

			surface.SetDrawColor(zfs.default_colors["black08"])
			surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
			surface.DrawTexturedRect(x + nextX, y + nextY, sizeX, sizeY)
			draw.NoTexture()

			draw.DrawText(tostring(v), "zfs_ProductTitle", x + nextX + 30, y + nextY + 15, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
		end
	end
end

// This asKs us if we are happy with ous selection
function zfs.f.Shop_ui_InfoBox(info, status)
	draw.DrawText(info, "zfs_InfoBoxTextfont01", ScreenW * -0.45, ScreenH * -0.35, zfs.default_colors["red05"], TEXT_ALIGN_LEFT)

	if (status == "TakeCup") then
		surface.SetDrawColor(zfs.default_colors["white06"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_takeacup"])
		surface.DrawTexturedRect(-ScreenW * 0.481, -ScreenH * 0.54, ScreenW * 0.85, ScreenH)
		draw.NoTexture()
	elseif (status == "SliceFruits") then
		surface.SetDrawColor(zfs.default_colors["white06"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_slicefruit"])
		surface.DrawTexturedRect(-ScreenW * 0.4, -ScreenH * 0.365, ScreenW * 0.85, ScreenH * 0.8)
		draw.NoTexture()
	elseif (status == "ChooseSweetener") then
		surface.SetDrawColor(zfs.default_colors["white06"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_chooseswetener"])
		surface.DrawTexturedRect(-ScreenW * 0.48, -ScreenH * 0.31, ScreenW * 0.96, ScreenH * 0.78)
		draw.NoTexture()
	elseif (status == "StartTheBlender") then
		surface.SetDrawColor(zfs.default_colors["white06"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_starttheblender"])
		surface.DrawTexturedRect(-ScreenW * 0.48, -ScreenH * 0.31, ScreenW * 0.96, ScreenH * 0.9)
		draw.NoTexture()
	end
end

// This displays the ProductSelection
function zfs.f.Shop_ui_ProductSelection(Shop)
	// This disables our Product Info again
	if (Shop.PDescription:IsValid() and Shop.PDescription:IsVisible()) then
		Shop.PDescription:SetVisible(false)
	end

	for i, k in pairs(zfs.config.FruitCups) do
		local x, y = zfs.f.Shop_CalcNextLine(7, i, iconSize, margin, productBoxX, productBoxY)

		// This changes its background color
		local iconBG_Color = zfs.config.Item_BG
		surface.SetDrawColor(iconBG_Color)
		surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
		surface.DrawTexturedRect(x, y, iconSize, iconSize)
		draw.NoTexture()

		surface.SetDrawColor(zfs.default_colors["white01"])
		surface.SetMaterial(k.Icon)
		surface.DrawTexturedRect(x, y, iconSize, iconSize)
		draw.NoTexture()

		// This enables the hover element
		if zfs.f.Shop_HoverOverButton(zfs.f.Shop_CalcElementPos(Shop,x, y, Vector(25, 25, -10))) then
			surface.SetDrawColor(zfs.default_colors["green04"])
			surface.SetMaterial(zfs.default_materials["zfs_ui_product_hover"])
			surface.DrawTexturedRect(x, y, iconSize, iconSize)
			draw.NoTexture()
		end
	end
end

// This ask´s us if we are happy with our product selection
function zfs.f.Shop_ui_ProductConfirmation(Shop)
	local selectedItem = zfs.config.FruitCups[Shop:GetTSelectedItem()]
	local iconBG_Color = zfs.config.Item_BG
	local buttonYesColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-12, -23, 17.3, 16.6) then
		buttonYesColor = zfs.default_colors["green02"]
	else
		local h, s, v = ColorToHSV(zfs.default_colors["green02"])
		buttonYesColor = HSVToColor(h, s, v - 0.3)
	end

	local buttonNoColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-25, -36, 17.3, 16.6) then
		buttonNoColor = zfs.default_colors["red01"]
	else
		local h, s, v = ColorToHSV(zfs.default_colors["red01"])
		buttonNoColor = HSVToColor(h, s, v - 0.3)
	end

	zfs.f.Shop_DrawBaseScreen(zfs.language.Shop.Screen_Confirm_Product)

	//Buttons
	draw.RoundedBox(7, -ScreenW * 0.45, ScreenH * 0.28, ScreenW * 0.4, ScreenH * 0.15, buttonYesColor)
	draw.DrawText(zfs.language.Shop.Screen_Confirm_Yes, "zfs_buttonfont01", -ScreenW * 0.25, ScreenH * 0.28, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
	draw.RoundedBox(7, ScreenW * 0.05, ScreenH * 0.28, ScreenW * 0.4, ScreenH * 0.15, buttonNoColor)
	draw.DrawText(zfs.language.Shop.Screen_Confirm_No, "zfs_buttonfont01", ScreenW * 0.25, ScreenH * 0.28, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
	local x = -ScreenW * 0.455
	local y = -ScreenH * 0.35
	local tIconSize = iconSize * 1.5
	draw.RoundedBox(0, -ScreenW * 0.48, -ScreenH * 0.358, ScreenW * 0.96, ScreenH * 0.31, zfs.default_colors["white05"])
	draw.DrawText(tostring(selectedItem.Name), "zfs_ProductTitle", -ScreenW * 0.25, -ScreenH * 0.36, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)

	// Sets and enables our Derma Product Info Label
	if (Shop.PDescription:IsValid() and not Shop.PDescription:IsVisible()) then
		Shop.PDescription:SetText(tostring(selectedItem.Info))
		Shop.PDescription:SetVisible(true)

		if zfs.config.Price.Custom then
			Shop.PDescription:SetPos(88, 45)
			Shop.PDescription:SetSize(250, 50)
		else
			Shop.PDescription:SetPos(245, 5)
			Shop.PDescription:SetSize(130, 50)
		end
	end

	local prize

	if zfs.config.Price.Custom then
		local buttonEditColor

		if zfs.f.Shop_CalcWorldElementPos(Shop,-34, -37, 20.20, 19.7) then
			buttonEditColor = zfs.default_colors["red02"]
		else
			buttonEditColor = zfs.default_colors["blue01"]
		end

		draw.RoundedBox(3, ScreenW * 0.355, -ScreenH * 0.33, ScreenW * 0.1, ScreenH * 0.08, buttonEditColor)
		draw.DrawText("...", "zfs_EditButton", ScreenW * 0.405, -ScreenH * 0.345, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
		prize = Shop:GetPPrice()
		draw.DrawText(zfs.language.Shop.Screen_Product_Price, "zfs_Infofont03", -ScreenW * 0.25, -ScreenH * 0.26, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
		draw.DrawText(tostring(prize) .. zfs.config.Currency, "zfs_Infofont03", -ScreenW * 0.11, -ScreenH * 0.26, zfs.default_colors["green03"], TEXT_ALIGN_LEFT)
	else
		draw.RoundedBox(0, ScreenW * 0.145, -ScreenH * 0.34, ScreenW * 0.325, ScreenH * 0.27, zfs.default_colors["black09"])
		draw.RoundedBox(0, -ScreenW * 0.248, -ScreenH * 0.13, ScreenW * 0.38, ScreenH * 0.005, zfs.default_colors["white03"])

		// Here we calculate what the Fruit varation boni is
		PriceBoni = zfs.f.CalculateFruitVarationBoni(selectedItem) * zfs.config.Price.FruitMultiplicator
		ExtraFruitPrice = math.Round(selectedItem.Price * PriceBoni)

		draw.DrawText(zfs.language.Shop.Screen_Product_BasePrice, "zfs_Infofont03", -ScreenW * 0.25, -ScreenH * 0.27, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
		draw.DrawText(zfs.language.Shop.Screen_Product_FruitBoni, "zfs_Infofont03", -ScreenW * 0.25, -ScreenH * 0.2, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)

		// The Base Price
		draw.DrawText(tostring(selectedItem.Price) .. zfs.config.Currency, "zfs_Infofont03", ScreenW * 0.135, -ScreenH * 0.27, zfs.default_colors["cyan01"], TEXT_ALIGN_RIGHT)

		// The FruitVariation Extra Cost
		draw.DrawText("+" .. tostring(ExtraFruitPrice) .. zfs.config.Currency, "zfs_Infofont03", ScreenW * 0.135, -ScreenH * 0.2, zfs.default_colors["cyan01"], TEXT_ALIGN_RIGHT)

		// The Final Price
		draw.DrawText("+" .. tostring(selectedItem.Price + ExtraFruitPrice) .. zfs.config.Currency, "zfs_Infofont03", ScreenW * 0.135, -ScreenH * 0.125, zfs.default_colors["green03"], TEXT_ALIGN_RIGHT)
	end

	surface.SetDrawColor(iconBG_Color)
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(x, y, tIconSize, tIconSize)
	draw.NoTexture()

	surface.SetDrawColor(zfs.default_colors["white01"])
	surface.SetMaterial(selectedItem.Icon)
	surface.DrawTexturedRect(x, y, tIconSize, tIconSize)
	draw.NoTexture()




	Shop.cl_NeededFruits = {}

	// Here we are gonna show what ingrediens are needed
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_melon", selectedItem.recipe["zfs_melon"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_banana", selectedItem.recipe["zfs_banana"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_coconut", selectedItem.recipe["zfs_coconut"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_pomegranate", selectedItem.recipe["zfs_pomegranate"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_strawberry", selectedItem.recipe["zfs_strawberry"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_kiwi", selectedItem.recipe["zfs_kiwi"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_lemon", selectedItem.recipe["zfs_lemon"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_orange", selectedItem.recipe["zfs_orange"])
	zfs.f.Shop_util_Add_NeedFruits(Shop,"zfs_apple", selectedItem.recipe["zfs_apple"])

	draw.DrawText(zfs.language.Shop.Screen_Product_Ingrediens, "zfs_ProductInfo", -ScreenW * 0.45, -ScreenH * 0.04, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)

	local ingrediensBoxX, ingrediensBoxY = -ScreenW * 0.53, ScreenH * 0.02
	local ingrediensSize = 30

	local needFruitsCount = {}
	needFruitsCount["zfs_melon"] = 0
	needFruitsCount["zfs_banana"] = 0
	needFruitsCount["zfs_coconut"] = 0
	needFruitsCount["zfs_pomegranate"] = 0
	needFruitsCount["zfs_strawberry"] = 0
	needFruitsCount["zfs_kiwi"] = 0
	needFruitsCount["zfs_lemon"] = 0
	needFruitsCount["zfs_orange"] = 0
	needFruitsCount["zfs_apple"] = 0

	if (Shop.StoredFruits ~= nil) then
		for i, k in pairs(Shop.cl_NeededFruits) do
			needFruitsCount[k] = needFruitsCount[k] + 1
			local ax, ay = zfs.f.Shop_CalcNextLine(11, i, ingrediensSize, 2, ingrediensBoxX, ingrediensBoxY)
			local iconBG_Color01

			if (Shop.StoredFruits[k] == nil) then
				iconBG_Color01 = zfs.default_colors["red06"]
			elseif (needFruitsCount[k] > Shop.StoredFruits[k]) then
				iconBG_Color01 = zfs.default_colors["red06"]
			else
				iconBG_Color01 = zfs.config.Item_BG
			end

			surface.SetDrawColor(iconBG_Color01)
			surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
			surface.DrawTexturedRect(ax, ay, ingrediensSize, ingrediensSize)
			draw.NoTexture()

			surface.SetDrawColor(zfs.default_colors["white01"])
			surface.SetMaterial(zfs.default_materials[k])
			surface.DrawTexturedRect(ax, ay, ingrediensSize, ingrediensSize)
			draw.NoTexture()
		end
	end
end

// This displays the ToppingSelection
function zfs.f.Shop_ui_ToppingSelection(Shop)
	for i, k in pairs(zfs.utility.SortedToppingsTable) do
		local x, y = zfs.f.Shop_CalcNextLine(7, i, iconSize, margin, productBoxX, productBoxY)

		// This Sets the BG Color of the bg icon
		local iconBG_Color

		if (table.Count(k.Ranks_create) > 0) then
			iconBG_Color = zfs.config.Restricted_Topping_BG
		else
			iconBG_Color = zfs.config.Item_BG
		end

		local h, s, v = ColorToHSV(Color(iconBG_Color.r, iconBG_Color.g, iconBG_Color.b))

		// This changes the item Color if we hover
		if zfs.f.Shop_HoverOverButton(zfs.f.Shop_CalcElementPos(Shop,x, y, Vector(25, 25, -10))) then
			iconBG_Color = HSVToColor(h, s, v + 0.15)
		else
			iconBG_Color = HSVToColor(h, s, v - 0.15)
		end

		surface.SetDrawColor(iconBG_Color)
		surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
		surface.DrawTexturedRect(x, y, iconSize, iconSize)
		draw.NoTexture()

		if (i == 1) then
			surface.SetDrawColor(zfs.default_colors["red07"])
			surface.SetMaterial(k.Icon)
			surface.DrawTexturedRect(x, y, iconSize, iconSize)
			draw.NoTexture()
		else
			if (k.Icon ~= nil) then
				surface.SetDrawColor(zfs.default_colors["white01"])
				surface.SetMaterial(k.Icon)
				surface.DrawTexturedRect(x, y, iconSize, iconSize)
				draw.NoTexture()
			end
		end

		// This enables the hover element
		if zfs.f.Shop_HoverOverButton(zfs.f.Shop_CalcElementPos(Shop,x, y, Vector(25, 25, -10))) then
			surface.SetDrawColor(zfs.default_colors["green04"])
			surface.SetMaterial(zfs.default_materials["zfs_ui_product_hover"])
			surface.DrawTexturedRect(x, y, iconSize, iconSize)
			draw.NoTexture()
		end
	end
end

// This ask´s us if we are happy with our topping selection
function zfs.f.Shop_ui_ToppingConfirmation(Shop)
	local selectedTopping = zfs.utility.SortedToppingsTable[Shop:GetTSelectedTopping()]

	if selectedTopping == nil then return end

	local iconBG_Color

	if (table.Count(selectedTopping.Ranks_create) > 0) then
		iconBG_Color = zfs.config.Restricted_Topping_BG
	else
		iconBG_Color = zfs.config.Item_BG
	end

	local buttonYesColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-12, -23, 17.5, 16.5) then
		buttonYesColor = zfs.default_colors["green02"]
	else
		local h, s, v = ColorToHSV(zfs.default_colors["green02"])
		buttonYesColor = HSVToColor(h, s, v - 0.3)
	end

	local buttonNoColor

	if zfs.f.Shop_CalcWorldElementPos(Shop,-25, -36, 17.5, 16.5) then
		local h, s, v = ColorToHSV(zfs.default_colors["red01"])
		buttonNoColor = HSVToColor(h, s, v)
	else
		local h, s, v = ColorToHSV(zfs.default_colors["red01"])
		buttonNoColor = HSVToColor(h, s, v - 0.3)
	end

	//Buttons
	draw.RoundedBox(7, -ScreenW * 0.45, ScreenH * 0.25, ScreenW * 0.4, ScreenH * 0.2, buttonYesColor)
	draw.DrawText(zfs.language.Shop.Screen_Confirm_Yes, "zfs_buttonfont01", -ScreenW * 0.25, ScreenH * 0.28, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
	draw.RoundedBox(7, ScreenW * 0.05, ScreenH * 0.25, ScreenW * 0.4, ScreenH * 0.2, buttonNoColor)
	draw.DrawText(zfs.language.Shop.Screen_Confirm_No, "zfs_buttonfont01", ScreenW * 0.25, ScreenH * 0.28, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
	local x = -ScreenW * 0.45
	local y = -ScreenH * 0.346
	local tIconSize = iconSize * 1.5
	local bIconSize = iconSize * 0.46
	// Benefits
	draw.RoundedBox(0, ScreenW * 0.267, -ScreenH * 0.345, ScreenW * 0.2, ScreenH * 0.567, zfs.default_colors["black06"])

	// Adds all benefit items to our list
	if (table.Count(selectedTopping.ToppingBenefits) > 0) then
		local pos = 0
		local yPos = -ScreenH * 0.33
		local itemMargin = 5

		for k, v in pairs(selectedTopping.ToppingBenefits) do
			draw.RoundedBox(0, ScreenW * 0.279, yPos + pos, ScreenW * 0.18, ScreenH * 0.09, zfs.default_colors["white05"])
			local bInfo
			local bInfo_color = zfs.default_colors["white01"]
			local bInfo_align = TEXT_ALIGN_CENTER
			local bInfo_posX = ScreenW * 0.4
			local bInfo_posy = yPos + pos

			if (k == "Health") then
				bInfo = "+" .. tostring(v)

				draw.Text({
					text = bInfo,
					pos = {bInfo_posX, bInfo_posy + 13},
					font = "zfs_BenefitsInfofont01",
					xalign = bInfo_align,
					yalign = bInfo_align,
					color = bInfo_color
				})
			elseif (k == "ParticleEffect") then
				bInfo = "Effect"
				draw.DrawText(bInfo, "zfs_BenefitsInfofont01", bInfo_posX, bInfo_posy + 5, bInfo_color, bInfo_align)
			elseif (k == "SpeedBoost") then
				bInfo = "+" .. tostring(v)

				draw.Text({
					text = bInfo,
					pos = {bInfo_posX, bInfo_posy + 13},
					font = "zfs_BenefitsInfofont01",
					xalign = bInfo_align,
					yalign = bInfo_align,
					color = bInfo_color
				})
			elseif (k == "AntiGravity") then
				bInfo = "+" .. tostring(v)

				draw.Text({
					text = bInfo,
					pos = {bInfo_posX, bInfo_posy + 13},
					font = "zfs_BenefitsInfofont01",
					xalign = bInfo_align,
					yalign = bInfo_align,
					color = bInfo_color
				})
			elseif (k == "Ghost") then
				bInfo = "(" .. tostring(v) .. "/255)"

				draw.Text({
					text = bInfo,
					pos = {bInfo_posX, bInfo_posy + 13},
					font = "zfs_BenefitsInfofont01",
					xalign = bInfo_align,
					yalign = bInfo_align,
					color = bInfo_color
				})
			elseif (k == "Drugs") then
				bInfo = tostring(v)

				draw.Text({
					text = bInfo,
					pos = {bInfo_posX, bInfo_posy + 13},
					font = "zfs_BenefitsInfofont01",
					xalign = bInfo_align,
					yalign = bInfo_align,
					color = bInfo_color
				})
			end

			surface.SetMaterial(zfs.utility.BenefitsIcons[k])
			surface.SetDrawColor(zfs.default_colors["white01"])
			surface.DrawTexturedRect(x + ScreenW * 0.73, yPos + pos, bIconSize, bIconSize)
			draw.NoTexture()
			pos = pos + bIconSize + itemMargin
		end
	end

	if (selectedTopping.ToppingBenefit_Duration > 0) then
		local duration = tostring(selectedTopping.ToppingBenefit_Duration) .. "s"
		draw.DrawText(duration, "zfs_ProductDuration", ScreenW * 0.25, -ScreenH * 0.34, zfs.default_colors["blue02"], TEXT_ALIGN_RIGHT)
	end

	draw.DrawText(tostring(selectedTopping.Name), "zfs_ProductTitle", -ScreenW * 0.25, -ScreenH * 0.35, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
	draw.DrawText(tostring(selectedTopping.Info), "zfs_ToppingInfo", -ScreenW * 0.25, -ScreenH * 0.175, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)

	draw.RoundedBox(0, -ScreenW * 0.247, -ScreenH * 0.19, ScreenW * 0.495, 1, zfs.default_colors["white03"])
	draw.RoundedBox(0, -ScreenW * 0.247, -ScreenH * 0.06, ScreenW * 0.495, 1, zfs.default_colors["white03"])
	draw.DrawText(zfs.language.Shop.Screen_Topping_Price, "zfs_ProductPrice", -ScreenW * 0.25, -ScreenH * 0.25, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
	draw.DrawText("+" .. tostring(selectedTopping.ExtraPrice) .. zfs.config.Currency, "zfs_ProductPrice", ScreenW * 0.25, -ScreenH * 0.25, zfs.default_colors["green03"], TEXT_ALIGN_RIGHT)

	surface.SetDrawColor(iconBG_Color)
	surface.SetMaterial(zfs.default_materials["zfs_ui_productbg"])
	surface.DrawTexturedRect(x, y, tIconSize, tIconSize)
	draw.NoTexture()

	// This renders our Cancel Icon
	if Shop:GetTSelectedTopping() == 1 then
		surface.SetDrawColor(zfs.default_colors["red07"])
		surface.SetMaterial(selectedTopping.Icon)
		surface.DrawTexturedRect(x, y, tIconSize, tIconSize)
		draw.NoTexture()
	end

	//Acces Information
	draw.RoundedBox(0, -ScreenW * 0.45, -ScreenH * 0.03, ScreenW * 0.7, ScreenH * 0.25, zfs.default_colors["black06"])
	local allowedGroups

	// Checks the selected Topping is creation exlusive for a ulx Group
	if table.Count(selectedTopping.Ranks_create) > 0 then
		allowedGroups = zfs.f.CreateAllowList(selectedTopping.Ranks_create)
		allowedGroups = table.concat( allowedGroups, ",", 1, #allowedGroups )
	else
		allowedGroups = zfs.language.Shop.Screen_Topping_NoRestricted
	end

	draw.DrawText(zfs.language.Shop.Screen_Topping_Add_Restricted, "zfs_AcessInfofont01", -ScreenW * 0.44, -ScreenH * 0.02, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
	draw.DrawText(allowedGroups, "zfs_AcessInfofont02", -ScreenW * 0.44, ScreenH * 0.03, zfs.config.Restricted_Topping_BG, TEXT_ALIGN_LEFT)


	local allowedGroupsConsume
	local allowedJobsConsume

	// Checks the selected Topping is consumbtion exlusive for a ulx Group or job
	if table.Count(selectedTopping.Ranks_consume) > 0 then
		allowedGroupsConsume = zfs.f.CreateAllowList(selectedTopping.Ranks_consume)
		allowedGroupsConsume = table.concat( allowedGroupsConsume, ",", 1, #allowedGroupsConsume )
	else
		allowedGroupsConsume = zfs.language.Shop.Screen_Topping_NoRestricted

	end

	if table.Count(selectedTopping.Job_consume) > 0 then
		allowedJobsConsume = zfs.f.CreateAllowList(selectedTopping.Job_consume)
		allowedJobsConsume = table.concat( allowedJobsConsume, ",", 1, #allowedJobsConsume )
	else
		allowedJobsConsume = " "
	end

	draw.DrawText(zfs.language.Shop.Screen_Topping_Consum_Restricted, "zfs_AcessInfofont01", -ScreenW * 0.44, ScreenH * 0.1, zfs.default_colors["white01"], TEXT_ALIGN_LEFT)
	draw.DrawText(allowedGroupsConsume .. "," .. allowedJobsConsume, "zfs_AcessInfofont02", -ScreenW * 0.44, ScreenH * 0.15, zfs.config.Restricted_Topping_BG, TEXT_ALIGN_LEFT)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////





//////////////////////////////////////////////////////////////
////////////////////////// MISC //////////////////////////////
//////////////////////////////////////////////////////////////

// Adds the amount of fruits in our Needed Fruits Table
function zfs.f.Shop_util_Add_NeedFruits(Shop,fruit, amount)
	for i = 1, amount do
		table.insert(Shop.cl_NeededFruits, fruit)
	end
end

// This gives us the World position of the UI element relativ too the root bone
function zfs.f.Shop_CalcWorldElementPos(Shop,xStart, xEnd, yStart, yEnd)
	local trace = LocalPlayer():GetEyeTrace().HitPos
	local tracePos = Shop:WorldToLocal(trace)

	if tracePos.x < xStart and tracePos.x > xEnd and tracePos.y < yStart and tracePos.y > yEnd then
		return true
	else
		return false
	end
end

// This gives us the World position of the UI element relativ too the Screen
function zfs.f.Shop_CalcElementPos(Shop, x, y, size)
	local wpos = Vector(0, 0, 0)
	local attach = Shop:GetAttachment(Shop:LookupAttachment("screen"))

	if attach then
		local AttaPos = attach.Pos
		local AttaAng = attach.Ang

		AttaAng:RotateAroundAxis(AttaAng:Up(), -90)
		AttaAng:RotateAroundAxis(AttaAng:Right(), 180)

		local newVec = Vector(x, y, 1)
		newVec:Add(size)
		newVec:Mul(0.07)
		wpos = LocalToWorld(newVec, Angle(0, 0, 0), AttaPos, AttaAng)
	end

	return wpos
end

//This finds the nearerst item
function zfs.f.Shop_CalcNearestItem(Shop,wpos, key)
	local trace = LocalPlayer():GetEyeTrace()
	local currentdiff = wpos:Distance(trace.HitPos)

	if (currentdiff < Shop.initialdiff) then
		Shop.initialdiff = currentdiff
		Shop.nearestItem = key
	end
	// selectedkey now holds key for closest match
	// values[selectedkey] gives you the (first) closest value
end

// This Calculates if we Hover over a Item
function zfs.f.Shop_HoverOverButton(wpos)
	local trace = LocalPlayer():GetEyeTrace()

	if zfs.f.InDistance(trace.HitPos, wpos,  1.8) then
		return true
	else
		return false
	end
end

// This Calculates the position for each item in the fruitcups config list
function zfs.f.Shop_CalcNextLine(rowCount, itemCount, aiconSize, amargin, aproductBoxX, aproductBoxY)
	local ypos = 0
	local xpos = 0

	if (itemCount > rowCount * 3) then
		ypos = aproductBoxY + (aiconSize * 3 + amargin * 4)
		xpos = aproductBoxX + (aiconSize + amargin) * (itemCount - (rowCount * 3))
	elseif (itemCount > rowCount * 2) then
		ypos = aproductBoxY + (aiconSize * 2 + amargin * 3)
		xpos = aproductBoxX + (aiconSize + amargin) * (itemCount - (rowCount * 2))
	elseif (itemCount > rowCount) then
		ypos = aproductBoxY + (aiconSize + amargin * 2)
		xpos = aproductBoxX + (aiconSize + amargin) * (itemCount - rowCount)
	else
		ypos = aproductBoxY + amargin
		xpos = aproductBoxX + (aiconSize + amargin) * itemCount
	end

	return xpos, ypos
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////
/////////////////////// Storage //////////////////////////////
//////////////////////////////////////////////////////////////

net.Receive("zfs_UpdateStorage", function(len, ply)
	//print("Recieved StoredIngrediens Length: " .. len)
	local shop = net.ReadEntity()

	local dataLength = net.ReadUInt(16)
	local d_Decompressed = util.Decompress(net.ReadData(dataLength))
	local svStorage = util.JSONToTable(d_Decompressed)

	if IsValid(shop) and svStorage ~= nil and istable( svStorage ) then
		zfs.f.Shop_UpdateStorage(shop,svStorage)
	else
		print("Something is nil, Contact FruitslicerScript Creator")
	end
end)

// Here we fill our Table with the current Storage of fruits we have on the Server
function zfs.f.Shop_UpdateStorage(Shop , svFruitStorage)
	if Shop.StoredFruits == nil then
		Shop.StoredFruits = {}
	end

	Shop.StoredFruits = svFruitStorage
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////








//////////////////////////////////////////////////////////////
/////////////////////// Visuals //////////////////////////////
//////////////////////////////////////////////////////////////
// This creates the DynamicLight
function zfs.f.Shop_Lights(Shop)
	if (Shop.CurrentState ~= 0) then
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		local attach = Shop:GetAttachment(Shop:LookupAttachment("workplace"))
		if (attach and dlight) then
			dlight.pos = attach.Pos + Shop:GetUp() * 30
			dlight.r = 255
			dlight.g = 8
			dlight.b = 60
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 256
			dlight.DieTime = CurTime() + 1
		end
	end
end

// This creates the frezzing effect
function zfs.f.Shop_FrozzeEffect(Shop)
	if ((Shop.lastFrozze or CurTime()) > CurTime()) then return end
	Shop.lastFrozze = CurTime() + 2

	if IsValid(Shop) and Shop.CurrentState ~= 0 then
		local attach = Shop:GetAttachment(9)

		if (attach) then
			local attachPos = attach.Pos

			if (attachPos) then
				local ang = Shop:GetAngles()
				local pos = attachPos + Shop:GetUp() * 36
				ParticleEffect("zfs_frozen_effect", pos, ang, Shop)
			end
		end
	end
end

function zfs.f.Shop_SweetenerFillSound(Shop)
	if Shop.CurrentState == 10 then
		local SweetenerFillSound = CreateSound(Shop, "zfs_sfx_sweetener")

		if Shop.SoundObj == nil then
			Shop.SoundObj = SweetenerFillSound
		end

		if Shop.SoundObj:IsPlaying() == false then
			Shop.SoundObj:Play()
			Shop.SoundObj:ChangeVolume(0, 0)
			Shop.SoundObj:ChangeVolume(0.5, 1)

			timer.Simple(4.1, function()
				if IsValid(Shop) and Shop.SoundObj then
					Shop.SoundObj:Stop()
				end
			end)
		end
	end
end




// Here we start our CLIENT Models
// For Render reason we spawn the windows as a seperate model
function zfs.f.Shop_SpawnWheel(Shop,attach)
	local ent = ents.CreateClientProp()
	local attachInfo = Shop:GetAttachment(Shop:LookupAttachment(attach))
	if attachInfo and IsValid(ent) then
		local ang = attachInfo.Ang
		ent:SetModel("models/zerochain/fruitslicerjob/fs_wheel.mdl")
		ent:SetAngles(ang)
		ent:SetPos(attachInfo.Pos)
		ent:Spawn()
		ent:Activate()
		ent:SetRenderMode(RENDERMODE_NORMAL)

		ent:SetParent(Shop, Shop:LookupAttachment(attach))
		ent:SetLocalPos(attachInfo.Ang:Forward() * 0.01)
		ent:SetLocalAngles(Angle(0, 0, -90))
		Shop.ClientProps[attach] = ent
	end
end

function zfs.f.Shop_SpawnWindows(Shop)
	local ent = ents.CreateClientProp()
	ent:SetModel("models/zerochain/fruitslicerjob/fs_shop_glass.mdl")
	ent:SetAngles(Shop:GetAngles())
	ent:SetPos(Shop:GetPos())
	ent:Spawn()
	ent:Activate()
	ent:SetRenderMode(RENDERMODE_NORMAL)
	ent:SetParent(Shop)
	Shop.ClientProps["Glass"] = ent
end

function zfs.f.Shop_SpawnFruitPile(Shop)
	local ent = ents.CreateClientProp()
	ent:SetModel("models/zerochain/fruitslicerjob/fs_fruitpile.mdl")
	local ang = Shop:GetAngles()
	ang:RotateAroundAxis(Shop:GetForward(),90)
	ang:RotateAroundAxis(Shop:GetUp(),90)
	ent:SetAngles(ang)
	ent:SetPos(Shop:GetPos() + Shop:GetForward() * -5)
	ent:Spawn()
	ent:Activate()
	ent:SetRenderMode(RENDERMODE_NORMAL)
	ent:SetModelScale(0.9)
	ent:SetParent(Shop, Shop:LookupAttachment("fruitlift"))
	Shop.ClientProps["FruitPile"] = ent
end

function zfs.f.Shop_RemoveClientModels(Shop)
	if (Shop.ClientProps and table.Count(Shop.ClientProps) > 0) then
		for k, v in pairs(Shop.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
