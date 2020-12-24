if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

////////////////////////////////

zfs.Shop_Interactions = {}


util.AddNetworkString("zfs_AnimEvent")
util.AddNetworkString("zfs_ItemPriceChange_cl")
util.AddNetworkString("zfs_ItemPriceChange_sv")
util.AddNetworkString("zfs_ItemSellWindowClose_sv")
util.AddNetworkString("zfs_shop_FX")
util.AddNetworkString("zfs_UpdateStorage")

// This Handels Price Change
net.Receive("zfs_ItemPriceChange_sv", function(len, ply)
	if zfs.f.NW_Player_Timeout(ply) then return end

	local ChangedPriceInfo = net.ReadTable()
	if ChangedPriceInfo == nil then return end

	local newPrice = ChangedPriceInfo.ChangedPrice
	local shop = ChangedPriceInfo.Shop

	if IsValid(ply) and ply:Alive() and IsValid(shop) and shop:GetClass() == "zfs_shop" and zfs.f.InDistance(ply:GetPos(), shop:GetPos(),  200) then
		if newPrice < zfs.config.Price.Minimum then
			zfs.f.Notify(ply, zfs.language.Shop.ChangePrice_PriceMinimum .. tostring(zfs.config.Price.Minimum) .. tostring(zfs.config.Currency), 1)

			return
		end

		if newPrice > zfs.config.Price.Maximum then
			zfs.f.Notify(ply, zfs.language.Shop.ChangePrice_PriceMaximum .. tostring(zfs.config.Price.Maximum) .. tostring(zfs.config.Currency), 1)

			return
		end

		// Function do change price
		zfs.f.Notify(ply, zfs.language.Shop.ChangePrice_PriceChanged .. tostring(newPrice) .. tostring(zfs.config.Currency) .. "!", 0)
		shop:SetPPrice(newPrice)
	end
end)

////////////////////////////////
local iconSize = 50
local margin = 3
local ScreenW, ScreenH = 390, 260
local productBoxX, productBoxY = -ScreenW * 0.61, -ScreenH * 0.36
////////////////////////////////



//////////////////////////////////////////////////////////////
/////////////////////// Initialize ///////////////////////////
//////////////////////////////////////////////////////////////

// Called when the Shop Initializes
function zfs.f.Shop_Initialize(Shop)
	zfs.f.EntList_Add(Shop)
	Shop:SetSkin(zfs.config.Theme)

	// This function tells the Clients too use the Animation Played on Client instead of the animation data that gets send from the ServerAnim
	Shop:UseClientSideAnimation()

	zfs.f.Shop_SpawnMixer(Shop)

	Shop.Sweeteners = {}
	Shop.Sweeteners["Milk"] = zfs.f.Shop_SpawnSweetener(Shop,"Milk", 0, 0, 10)
	Shop.Sweeteners["Coffe"] = zfs.f.Shop_SpawnSweetener(Shop,"Coffe", 1, 11, 0)
	Shop.Sweeteners["Chocolate"] = zfs.f.Shop_SpawnSweetener(Shop,"Chocolate", 2, 22, -10)

	//Thats the stuff we need do call with a little delay
	timer.Simple(1, function()
		if IsValid(Shop) then

			// Our Sell Table and Product Count
			Shop.ProductCount = 0
			zfs.f.Shop_SetupSellTable(Shop)

			// Resets all of our Vars
			zfs.f.Shop_action_Restart(Shop)
			zfs.f.Shop_ChangeState(Shop,0)
			zfs.f.CreateAnimTable(Shop,"idle_turnedoff", 1)

			zfs.f.Shop_StartStorage(Shop)
		end
	end)

	// The States i use, just here as a reminder
	//["DISABLED"] = 0
	//["MENU"] = 1
	//["STORAGE"] = 2
	//["ORDERING"] = 3
	//["CONFIRMING_PRODUCT"] = 4
	//["CUP_CHOOSETOPPING"] = 5
	//["CONFIRMING_TOPPING"] = 6
	//["WAIT_FOR_CUP"] = 7
	//["SLICE_FRUITS"] = 8
	//["WAIT_FOR_SWEETENER"] = 9
	//["FILLING_SWEETENER"] = 10
	//["WAIT_FOR_MIXERBUTTON"] = 11
	//["MIXING"] = 12
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
////////////////////////// Setup /////////////////////////////
//////////////////////////////////////////////////////////////
// This Spawns Our Sweeteners
function zfs.f.Shop_SpawnSweetener(Shop,sweettype, skin, right, AngleOffset)
	local ent = ents.Create("zfs_sweetener_base")
	local attach = Shop:GetAttachment(Shop:LookupAttachment("workplace"))

	if attach and IsValid(ent) then
		local ang = Shop:GetAngles()
		ang:RotateAroundAxis(Shop:GetUp(), -90 + AngleOffset)
		ent:SetAngles(ang)
		ent:SetPos(attach.Pos + Shop:GetUp() * 6 + Shop:GetForward() * -12 + Shop:GetForward() * right)

		ent:Spawn()
		ent:Activate()

		ent:SetParent(Shop)
		ent:SetSkin(skin)
		ent:SetNoDraw(true)
		ent.SweetenerType = sweettype
		Shop:DeleteOnRemove(ent)
		ent.PhysgunDisabled = true

		if zfs.config.SharedEquipment == false then
			zfs.f.SetOwnerID(ent, zfs.f.GetOwner(Shop))
		end
	end
	return ent
end

// This Spawns Mixer
function zfs.f.Shop_SpawnMixer(Shop)
	local ent = ents.Create("zfs_mixer")
	local attachInfo = Shop:GetAttachment(Shop:LookupAttachment("mixer_floor"))
	if attachInfo and IsValid(ent) then
		local ang = attachInfo.Ang
		ang:RotateAroundAxis(Shop:GetUp(), -90)
		ent:SetAngles(ang)
		ent:SetPos(attachInfo.Pos)

		ent:Spawn()
		ent:Activate()
		ent:PhysicsInit(SOLID_VPHYSICS)
		ent:SetSolid(SOLID_VPHYSICS)
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local phys = ent:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
		end

		ent:SetParent(Shop, Shop:LookupAttachment("mixer_floor"))
		Shop.Mixer = ent
		Shop:DeleteOnRemove(ent)
		ent.PhysgunDisabled = true
		if zfs.config.SharedEquipment == false then
			zfs.f.SetOwnerID(ent, zfs.f.GetOwner(Shop))
		end
	end
end

// This is gonna setups our SellTable
function zfs.f.Shop_SetupSellTable(Shop)
	local tableCount = 16
	local moveSize = 8
	local x, y = 1, 1
	local currpos = 2

	local attach = Shop:GetAttachment(Shop:LookupAttachment("sellpoint"))

	if attach then
		for i = 0, tableCount - 1 do
			local pos = attach.Pos + (Shop:GetForward() * x) + (Shop:GetRight() * y)


			zfs.f.Debug_Sphere(pos,1,1,zfs.default_colors["red07"],true)

			if Shop.SellTable == nil then
				Shop.SellTable = {}
			end

			Shop.SellTable[i] = {}
			Shop.SellTable[i].Pos = Shop:WorldToLocal(pos)
			Shop.SellTable[i].IsEmpty = true
			Shop.SellTable[i].Entity = nil

			if (currpos > 8) then
				currpos = 1
				y = y + moveSize
				x = 1
			else
				x = x + moveSize
				currpos = currpos + 1
			end
		end
	end
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////





//////////////////////////////////////////////////////////////
////////////////////////// Touch /////////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.Shop_OnTouch(Shop, other)
	if not IsValid(Shop) or not IsValid(other) then return end
	if string.sub( other:GetClass(), 1, 13 ) ~= "zfs_fruitbox_"  then return end

	if zfs.f.CollisionCooldown(other) then return end

	zfs.f.Shop_FillStorage(Shop, other.FruitType, other.FruitAmount, true)
	SafeRemoveEntity(other)
end


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////





//////////////////////////////////////////////////////////////
//////////////////////// Storage /////////////////////////////
//////////////////////////////////////////////////////////////

// Fills our storage on Init
function zfs.f.Shop_StartStorage(Shop)
	for k, v in pairs(zfs.config.StartStorage) do
		zfs.f.Shop_FillStorage(Shop,k, v, false)
	end
end

// Adds a specified fruit and amount in our storage
function zfs.f.Shop_FillStorage(Shop,fruittype, amount, PlaySound)
	if Shop.StoredIngrediens == nil then
		Shop.StoredIngrediens = {}
	end

	local inStoreFruits = Shop.StoredIngrediens[fruittype]

	if inStoreFruits == nil then
		inStoreFruits = 0
	end

	Shop.StoredIngrediens[fruittype] = inStoreFruits + amount
	zfs.f.Shop_UpdateNetStorage(Shop)

	if PlaySound then
		zfs.f.CreateEffectTable(nil, "zfs_sfx_FillStorage", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	end
end

// Removes a specified fruit and amount from our storage
function zfs.f.Shop_RemoveStorage(Shop,fruittype, amount)
	if Shop.StoredIngrediens == nil then
		Shop.StoredIngrediens = {}
	end

	local inStoreFruits = Shop.StoredIngrediens[fruittype]

	if inStoreFruits == nil then
		inStoreFruits = 0
	end

	Shop.StoredIngrediens[fruittype] = inStoreFruits - amount
	zfs.f.Shop_UpdateNetStorage(Shop)
end

// This sends our current Storage to the Client
function zfs.f.Shop_UpdateNetStorage(Shop)
	if (Shop.StoredIngrediens == nil or table.Count(Shop.StoredIngrediens) <= 0) then
		return
	end

	local a_String = util.TableToJSON(Shop.StoredIngrediens)
	local a_Compressed = util.Compress(a_String)

	net.Start("zfs_UpdateStorage")
	net.WriteEntity(Shop)
	net.WriteUInt(#a_Compressed, 16)
	net.WriteData(a_Compressed, #a_Compressed)
	net.SendPVS(Shop:GetPos())
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
////////////////////// Sell Table ////////////////////////////
//////////////////////////////////////////////////////////////
// This is gonna Search a empty positon on our table
function zfs.f.Shop_FindEmptyPosOnSellTable(Shop)
	local freePos

	for i = 0, table.Count(Shop.SellTable) - 1 do
		if Shop.SellTable[i].IsEmpty then
			freePos = i
			break
		end
	end

	if (freePos) then
		return freePos
	else
		zfs.f.Debug("Sell Place Full!")

		return false
	end
end

// This Adds a Product to our SellTable
function zfs.f.Shop_AddProductToSellTable(Shop,Product)
	Shop.ProductCount = Shop.ProductCount + 1

	local EMPTY_Pos = zfs.f.Shop_FindEmptyPosOnSellTable(Shop)
	if EMPTY_Pos then
		Product.SellTable_Index = EMPTY_Pos

		Shop.SellTable[EMPTY_Pos].Entity = Product
		Shop.SellTable[EMPTY_Pos].IsEmpty = false

		Product:SetPos(Shop.SellTable[EMPTY_Pos].Pos)

		local attach = Shop:GetAttachment(Shop:LookupAttachment("sellpoint"))
		if attach then
			Product:SetAngles(attach.Ang)
		end
	end
end

// This Removes a Product from our SellTable
function zfs.f.Shop_RemoveProductFromSellTable(Shop,Product, index)
	Shop.ProductCount = Shop.ProductCount - 1

	Shop.SellTable[index].Entity:Remove()
	Shop.SellTable[index].Entity = nil
	Shop.SellTable[index].IsEmpty = true
end

// Here we look if we have a free place on our table
function zfs.f.Shop_Has_SellTable_EmptySpot(Shop)
	local freePos

	for i = 0, table.Count(Shop.SellTable) - 1 do
		if (Shop.SellTable[i].IsEmpty) then
			freePos = i
			break
		end
	end

	if (freePos) then
		zfs.f.Debug("Free Place at position: " .. freePos)

		return true
	else
		zfs.f.Debug("Sell Place Full!")

		return false
	end
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
////////////////////// Interaction ////////////////////////////
//////////////////////////////////////////////////////////////


//This creates a Trace for determining if the Screen got hit
function zfs.f.Shop_Use(ply,Shop)
	if not zfs.f.IsOwner(ply, Shop) then
		zfs.f.Notify(ply, zfs.language.Shop.NotOwner, 1)

		return
	end

	if table.Count(zfs.config.Jobs) > 0 and zfs.config.Jobs[zfs.f.GetPlayerJob(ply)] == nil then
		zfs.f.Notify(ply, zfs.language.Shop.WrongJob, 1)

		return
	end

	local occ_ply = Shop:GetOccupiedPlayer()

	if IsValid(occ_ply) and ply ~= occ_ply then

		return
	end

	if Shop:GetIsBusy() then return end
	local localTrace
	localTrace = ply:GetEyeTrace()

	if localTrace and zfs.f.InDistance(ply:GetPos(), localTrace.HitPos, 300) and IsValid(localTrace.Entity) and localTrace.Entity == Shop then
		zfs.f.Shop_UseLogic(Shop,localTrace, ply)
	end
end

//Here do we check what Button the trace is hitting
function zfs.f.Shop_UseLogic(Shop,trace, ply)
	local lTrace = Shop:WorldToLocal(trace.HitPos)

	if (Shop:GetCurrentState() == 7 and lTrace.x < -26 and lTrace.x > -42 and lTrace.y < 25 and lTrace.y > 13 and lTrace.z < 51 and lTrace.z > 35) then
		zfs.f.Shop_action_PlaceCup(Shop)
	end

	zfs.f.Shop_GUILogic(Shop,trace, ply)
end

//Check if we are inside a 2D area relativ from the Root of the Entity
function zfs.f.Shop_CalcWorldElementPos(trace, xStart, xEnd, yStart, yEnd)
	if trace.x < xStart and trace.x > xEnd and trace.y < yStart and trace.y > yEnd then
		return true
	else
		return false
	end
end

// This return true if the values are inside the Local Vector relative too the Screen
function zfs.f.Shop_CalcLocalScreenPos(Shop, trace, xStart, xEnd, yStart, yEnd)
	local attach = Shop:GetAttachment(Shop:LookupAttachment("screen"))

	if attach then
		local AttaPos = attach.Pos
		local AttaAng = attach.Ang
		AttaAng:RotateAroundAxis(AttaAng:Up(), -90)
		AttaAng:RotateAroundAxis(AttaAng:Right(), 180)
		local lpos = WorldToLocal(trace.HitPos, Angle(0, 0, 0), AttaPos, AttaAng)

		if lpos.x < xStart and lpos.x > xEnd and lpos.y < yStart and lpos.y > yEnd then
			return true
		else
			return false
		end
	else
		return false
	end
end

// Our UI Logic
function zfs.f.Shop_GUILogic(Shop,trace, ply)
	local rootTrace = Shop:WorldToLocal(trace.HitPos)

	// Check if we hit the Screen
	if zfs.f.Shop_CalcLocalScreenPos(Shop,trace, 14, -14, 8.5, -8.5) then

		if Shop:GetCurrentState() == 0 then
			// Enables the Stand and goes to the menu
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -18.5, -30, 19.7, 17) then
				zfs.f.Shop_action_Enable(Shop)
			end
		elseif Shop:GetCurrentState() == 1 then
			// Disable
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -12, -20, 20, 18.2) then
				zfs.f.Shop_action_Disable(Shop)
			end

			//Make Product
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -21, -29, 20, 18.2) then
				zfs.f.Shop_Player_StartUse(Shop,ply)
				zfs.f.Shop_action_MakeProduct(Shop)
			end

			//Show Storage
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -29, -37, 20, 18.2) then
				zfs.f.Shop_Player_StartUse(Shop,ply)
				zfs.f.Shop_action_GoToStorage(Shop)
			end
		elseif (Shop:GetCurrentState() == 2) then
			// BackToTheMenu
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -33, -37.5, 21, 20.5) then
				zfs.f.Shop_action_GoToMenu(Shop)
			end
		elseif (Shop:GetCurrentState() == 3 and Shop:GetTSelectedItem() == -1) then
			// BackToTheMenu
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -33, -37.5, 21, 20.5) then
				zfs.f.Shop_action_GoToMenu(Shop)
			end

			if (Shop.ProductCount < 16) then
				zfs.f.Shop_UI_ProductSelection(Shop,trace)
			else
				zfs.f.Notify(ply, zfs.language.Shop.SellTableFull, 1)
			end
		elseif (Shop:GetCurrentState() == 4 and Shop:GetTSelectedItem() ~= -1) then

			// Change Price
			// Open vgui for custom price text entry
			if zfs.config.Price.Custom and zfs.f.Shop_CalcWorldElementPos(rootTrace, -34, -37, 20.25, 19.7) and Shop:GetTSelectedItem() then
				local PriceChangeInfo = {}
				PriceChangeInfo.Price = Shop:GetPPrice()
				PriceChangeInfo.selectedItem = Shop:GetTSelectedItem()
				PriceChangeInfo.Shop = Shop

				net.Start("zfs_ItemPriceChange_cl")
				net.WriteTable(PriceChangeInfo)
				net.Send(ply)
			end

			// Confirm
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -12, -23, 17.3, 16.6) and not zfs.f.Shop_MissingFruits(Shop,zfs.config.FruitCups[Shop:GetTSelectedItem()],ply) then
				zfs.f.Shop_action_ConfirmItem(Shop)
			end

			//Cancel
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -25, -36, 17.3, 16.6) then
				zfs.f.Shop_action_CancelItem(Shop)
				zfs.f.Shop_ChangeState(Shop,3)
			end
		elseif (Shop:GetCurrentState() == 5) then

			zfs.f.Shop_UI_ToppingSelection(Shop,trace)

			if (Shop:GetTSelectedTopping() ~= -1) then
				zfs.f.Shop_ChangeState(Shop,6)
			end

			// Cancel
			if zfs.f.Shop_CalcWorldElementPos(rootTrace, -33, -37.5, 21, 20.5) then
				zfs.f.Shop_action_CancelItem(Shop)
			end
		elseif (Shop:GetCurrentState() == 6 and Shop:GetTSelectedTopping() ~= -1) then
			if (Shop:GetTSelectedTopping() ~= -1) then
				// Confirm
				if zfs.f.Shop_CalcWorldElementPos(rootTrace, -12, -23, 17.5, 16.5) then
					zfs.f.Shop_action_ConfirmTopping(Shop,ply)
				end

				//Cancel
				if zfs.f.Shop_CalcWorldElementPos(rootTrace, -25, -36, 17.5, 16.5) then
					zfs.f.Shop_action_CancelTopping(Shop)
				end
			end
		end
	end
end

//Check if we clicked a Product
function zfs.f.Shop_UI_ProductSelection(Shop,trace)
	local attach = Shop:GetAttachment(Shop:LookupAttachment("screen"))

	if attach == nil then return end

	local AttaPos = attach.Pos
	local AttaAng = attach.Ang
	AttaAng:RotateAroundAxis(AttaAng:Up(), -90)
	AttaAng:RotateAroundAxis(AttaAng:Right(), 180)

	for i, k in pairs(zfs.config.FruitCups) do
		local x, y = zfs.f.Shop_CalcNextLine(i, iconSize, margin, productBoxX, productBoxY)
		local newVec = Vector(x, y, 1)
		local size = Vector(25, 25, -10)
		newVec:Add(size)
		newVec:Mul(0.07)
		local wpos = LocalToWorld(newVec, Angle(0, 0, 0), AttaPos, AttaAng)

		if zfs.f.InDistance(trace.HitPos, wpos, 1.8) then
			zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
			Shop:SetTSelectedItem(i)
			Shop:SetPPrice(zfs.config.FruitCups[Shop:GetTSelectedItem()].Price)
			zfs.f.Shop_ChangeState(Shop,4)
		end
	end
end

//Check if we have enough Fruits do make the Product
function zfs.f.Shop_MissingFruits(Shop,fruitcupdata,ply)
	local missingFruits = {}
	local hasMissingFruits = false

	for k, v in pairs(fruitcupdata.recipe) do
		local StoredFruitCount = Shop.StoredIngrediens[k]

		if (StoredFruitCount == nil) then
			StoredFruitCount = 0
		end

		if (StoredFruitCount < v) then
			missingFruits[k] = v - StoredFruitCount
		end
	end

	for k, v in pairs(missingFruits) do
		if (v > 0) then
			hasMissingFruits = true
			break
		end
	end

	if hasMissingFruits and IsValid(ply) then
		zfs.f.Notify(ply, zfs.language.Shop.MissingFruits, 1)
	end

	return hasMissingFruits
end

//Check if we clicked a Topping
function zfs.f.Shop_UI_ToppingSelection(Shop,trace)
	local attach = Shop:GetAttachment(Shop:LookupAttachment("screen"))

	if attach == nil then return end

	local AttaPos = attach.Pos
	local AttaAng = attach.Ang
	AttaAng:RotateAroundAxis(AttaAng:Up(), -90)
	AttaAng:RotateAroundAxis(AttaAng:Right(), 180)

	for i, k in pairs(zfs.utility.SortedToppingsTable) do
		local x, y = zfs.f.Shop_CalcNextLine(i, iconSize, margin, productBoxX, productBoxY)
		local newVec = Vector(x, y, 1)
		local size = Vector(25, 25, -10)
		newVec:Add(size)
		newVec:Mul(0.07)
		local wpos = LocalToWorld(newVec, Angle(0, 0, 0), AttaPos, AttaAng)

		if zfs.f.InDistance(trace.HitPos, wpos, 1.8) then
			Shop:SetTSelectedTopping(i)
			zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
		end
	end
end

// Calculate all of the Item Positions
function zfs.f.Shop_CalcNextLine(itemCount, aiconSize, amargin, aproductBoxX, aproductBoxY)
	local ypos = 0
	local xpos = 0
	local rowCount = 7

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





local ResetState = {}
ResetState[1] = true
ResetState[2] = true
ResetState[3] = true
ResetState[4] = true
ResetState[5] = true
ResetState[6] = true
ResetState[7] = false
ResetState[8] = false
ResetState[9] = false
ResetState[10] = false
ResetState[11] = false
ResetState[12] = false

// This function is used to Reset the entity if the player aborts his action/Moves too far away or dies
function zfs.f.Shop_ForceReset(Shop)
	zfs.f.Debug("zfs.f.Shop_ForceReset")
	local curState = Shop:GetCurrentState()

	if ResetState[curState] then

		zfs.f.Shop_Player_StopUse(Shop)

		zfs.f.CreateEffectTable(nil, "zfs_sfx_FillStorage", Shop, Shop:GetAngles(), Shop:GetPos(), nil)

		zfs.f.Shop_action_Restart(Shop)

		// Stops the distance check timer
		zfs.f.Timer_Remove("zfs_player_interaction_shop_check_ent_" .. Shop:EntIndex())
	end
end

function zfs.f.Shop_Player_StartUse(Shop,ply)
	zfs.f.Debug("zfs.f.Shop_Player_StartUse")
	Shop:SetOccupiedPlayer(ply)

	zfs.Shop_Interactions[ply:SteamID()] = Shop

	local timerid = "zfs_player_interaction_shop_check_ent_" .. Shop:EntIndex()
	zfs.f.Timer_Create(timerid,1,0,function()

		if IsValid(ply) and IsValid(zfs.Shop_Interactions[ply:SteamID()]) and zfs.f.InDistance(ply:GetPos(), zfs.Shop_Interactions[ply:SteamID()]:GetPos(), 200) == false then
			zfs.f.Shop_ForceReset(zfs.Shop_Interactions[ply:SteamID()])
		end
	end)
end

function zfs.f.Shop_Player_StopUse(Shop)
	zfs.f.Debug("zfs.f.Shop_Player_StartUse")
	local ply =  Shop:GetOccupiedPlayer()


	if IsValid(ply) then
		zfs.Shop_Interactions[ply:SteamID()] = nil
	end

	// Stops the distance check timer
	zfs.f.Timer_Remove("zfs_player_interaction_shop_check_ent_" .. Shop:EntIndex())

	Shop:SetOccupiedPlayer(NULL)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
////////////////// Actions - Main ////////////////////////////
//////////////////////////////////////////////////////////////

// Go Back to the Main Menu
function zfs.f.Shop_action_Disable(Shop)
	if Shop.PublicEntity then return end

	zfs.f.Shop_Player_StopUse(Shop)

	zfs.f.Shop_SetBusy(Shop,2)

	local phys = Shop:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_ToogleMachine", Shop, Shop:GetAngles(), Shop:GetPos(), nil)

	zfs.f.Debug("You disabled the stand")

	Shop:SetSkin(1)

	zfs.f.Shop_AnimSequence(Shop.Mixer,"close", "idle", 1)

	zfs.f.Shop_AnimSequence(Shop,"dessamble", "idle_turnedoff", 1)

	zfs.f.Shop_ChangeState(Shop,0)
end

// Enable The Machine
function zfs.f.Shop_action_Enable(Shop)
	zfs.f.Shop_SetBusy(Shop,2)
	Shop:SetPos(Shop:GetPos() + Shop:GetUp() * 0.5)
	local phys = Shop:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_ToogleMachine", Shop, Shop:GetAngles(), Shop:GetPos(), nil)

	zfs.f.Debug("You enabled the stand")
	zfs.f.Debug("Its frozen now")


	Shop:SetSkin(0)

	zfs.f.Shop_AnimSequence(Shop.Mixer,"open", "idle_open", 1)

	zfs.f.Shop_AnimSequence(Shop,"assemble", "idle_turnedon", 1)
	zfs.f.Shop_action_GoToMenu(Shop)
end

// Goes to the Menu
function zfs.f.Shop_action_GoToMenu(Shop)
	zfs.f.Shop_Player_StopUse(Shop)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.Shop_ChangeState(Shop,1)
end

// Goes to the Storage
function zfs.f.Shop_action_GoToStorage(Shop)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.Shop_ChangeState(Shop,2)
	zfs.f.Shop_UpdateNetStorage(Shop)
end

// Starts a Order
function zfs.f.Shop_action_MakeProduct(Shop)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.Shop_ChangeState(Shop,3)
end

// Confirms the selected Product
function zfs.f.Shop_action_ConfirmItem(Shop)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)

	local function AddNeedFruits(fruit, amount)
		for i = 1, amount do
			table.insert(Shop.NeededFruits, fruit)
		end

		zfs.f.Debug("Added " .. amount .. " " .. fruit .. " to the NeedCutBowl.")
	end

	local product = zfs.config.FruitCups[Shop:GetTSelectedItem()]
	AddNeedFruits("zfs_melon", product.recipe["zfs_melon"])
	AddNeedFruits("zfs_banana", product.recipe["zfs_banana"])
	AddNeedFruits("zfs_coconut", product.recipe["zfs_coconut"])
	AddNeedFruits("zfs_pomegranate", product.recipe["zfs_pomegranate"])
	AddNeedFruits("zfs_strawberry", product.recipe["zfs_strawberry"])
	AddNeedFruits("zfs_kiwi", product.recipe["zfs_kiwi"])
	AddNeedFruits("zfs_lemon", product.recipe["zfs_lemon"])
	AddNeedFruits("zfs_orange", product.recipe["zfs_orange"])
	AddNeedFruits("zfs_apple", product.recipe["zfs_apple"])

	zfs.f.Debug("You need to cut")
	zfs.f.Debug(Shop.NeededFruits)


	zfs.f.Shop_ChangeState(Shop,5)
end

// Confirms the Topping
function zfs.f.Shop_action_ConfirmTopping(Shop,ply)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	local selectedTopping = zfs.config.Toppings[Shop:GetTSelectedTopping()]

	// Does the Owner have the right Ulx Group to choose this topping?
	local Ranks_create = selectedTopping.Ranks_create
	if table.Count(Ranks_create) > 0 and zfs.f.PlayerRankCheck(ply,Ranks_create) == false then

		local allowedGroups = table.ToString(zfs.f.CreateAllowList(selectedTopping.Ranks_create), nil, false)
		zfs.f.Notify(ply, tostring(zfs.language.Shop.SelectTopping_WrongUlx01 .. allowedGroups), 3)
		zfs.f.Notify(ply, zfs.language.Shop.SelectTopping_WrongUlx02, 1)

		return
	end

	local topping = zfs.config.Toppings[Shop:GetTSelectedTopping()]

	zfs.f.Debug("Selected Topping: " .. topping.Name)

	Shop.SmoothieCreator = ply

	zfs.f.Shop_ChangeState(Shop,7)
end

// Called when we press the Cancel Product Button
function zfs.f.Shop_action_CancelItem(Shop)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.Shop_action_Restart(Shop)
end

// Called when we press the Cancel Topping Button
function zfs.f.Shop_action_CancelTopping(Shop)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_item_select", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.Shop_ChangeState(Shop,5)
	Shop:SetTSelectedTopping(-1)
end

// Restarts the whole Progress
function zfs.f.Shop_action_Restart(Shop)
	// Here we reset our Fruit Bowl that has all our cutted fruit
	Shop.FruitsInMixer = {}
	table.Empty(Shop.FruitsInMixer)

	// Here we reset our needed Fruits
	Shop.NeededFruits = {}
	table.Empty(Shop.NeededFruits)

	// Product Fruits Count
	Shop.FruitsToSlice = nil

	// Resets our MixerStuff
	Shop.Mixer:SetBodygroup(0, 0)
	Shop.Mixer:SetSkin(0)
	Shop.Mixer:SetColor(zfs.default_colors["white01"])

	//Network Var Setup
	Shop:SetPPrice(-1)
	Shop:SetTSelectedItem(-1)
	Shop:SetTSelectedTopping(-1)

	//Start State
	Shop.mixerStack = 0
	zfs.f.Shop_ChangeState(Shop,1)

	Shop.SmoothieCreator = nil

	zfs.f.Shop_Player_StopUse(Shop)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
/////////////// Actions - Cooking ////////////////////////////
//////////////////////////////////////////////////////////////
// This Places our Cup
function zfs.f.Shop_action_PlaceCup(Shop)
	if (Shop.Cup_InWork == nil) then
		local ent = ents.Create("zfs_fruitcup_base")
		ent:SetAngles(Shop:GetAngles())
		ent:SetPos(Shop:GetAttachment(Shop:LookupAttachment("cupwait")).Pos)
		ent:Spawn()
		ent:SetParent(Shop, Shop:LookupAttachment("cupwait"))
		ent:Activate()
		ent:PhysicsInitSphere(0.1, "default")
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local ang = Shop:GetAngles()
		ang:RotateAroundAxis(Shop:GetUp(), -115)
		ent:SetAngles(ang)
		Shop.Cup_InWork = ent
		Shop:DeleteOnRemove(ent)
	else
		Shop.Cup_InWork:SetNoDraw(false)
	end

	// Gives us the Count how many fruits we have for later use
	Shop.FruitsToSlice = table.Count(Shop.NeededFruits)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_cup_placed", Shop, Shop:GetAngles(), Shop:GetPos(), nil)

	zfs.f.Debug("Cup got placed")
	zfs.f.Shop_action_GetFruit(Shop)
end

// Checks if there still is a Fruit for us to cut
function zfs.f.Shop_action_GetFruit(Shop)
	local toCut = nil

	for k, v in ipairs(Shop.NeededFruits) do
		if (v ~= nil) then
			toCut = v
			break
		end
	end

	if (toCut ~= nil) then
		zfs.f.Shop_action_PlaceFruit(Shop,toCut)
		zfs.f.Debug("You got " .. table.Count(Shop.NeededFruits) .. " left to cut.")
		zfs.f.Debug(Shop.NeededFruits)

	else

		zfs.f.Debug("Fruits are done, Now mix")

		zfs.f.Shop_ChangeState(Shop,9)
		zfs.f.Shop_action_ShowSweetener(Shop)
	end
end

// Places a Fruit we need do cut
function zfs.f.Shop_action_PlaceFruit(Shop,fruit)

	zfs.f.Debug("Place fruit " .. fruit)

	local ent = ents.Create(fruit)
	local ang = Shop:GetAngles()
	ang:RotateAroundAxis(Shop:GetUp(), ent.AngleOffset)
	ent:SetAngles(ang)
	ent:SetPos(Shop:GetAttachment(Shop:LookupAttachment("workplace")).Pos + Shop:GetUp() * 1)
	ent:Spawn()
	ent:SetParent(Shop, Shop:LookupAttachment("workplace"))
	ent:Activate()
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	zfs.f.EntList_Add(ent)

	zfs.f.SetOwnerID(ent, zfs.f.GetOwner(Shop))
	ent.WorkStation = Shop

	zfs.f.Debug("Fruit got placed")


	zfs.f.Shop_ChangeState(Shop,8)
end

// Places the sliced fruit in to the Mixer
function zfs.f.Shop_action_FillMixer(Shop,fruit)
	// This Spawn the sliced fruit prop in too the mixer
	local FruitEnt = ents.Create("prop_dynamic")
	FruitEnt:SetModel("models/zerochain/fruitslicerjob/fs_slicedfruits.mdl")

	FruitEnt:Spawn()
	FruitEnt:Activate()

	Shop:DeleteOnRemove(FruitEnt)

	local fruitPos = Shop.Mixer:LocalToWorld(Shop.Mixer:GetUp() * 5 + Shop.Mixer:GetUp() * Shop.mixerStack)
	FruitEnt:SetPos(fruitPos)

	local ang = Shop:GetAngles()
	ang:RotateAroundAxis(Shop.Mixer:GetUp(), math.random(0, 360))
	FruitEnt:SetAngles(ang)

	FruitEnt:SetParent(Shop)

	// This Sets the bodygroup of the sliced fruits for the mixer
	local curFruit = fruit:GetClass()

	if (curFruit == "zfs_melon") then
		FruitEnt:SetBodygroup(0, 0)
	elseif (curFruit == "zfs_pomegranate") then
		FruitEnt:SetBodygroup(0, 1)
	elseif (curFruit == "zfs_coconut") then
		FruitEnt:SetBodygroup(0, 2)
	elseif (curFruit == "zfs_banana") then
		FruitEnt:SetBodygroup(0, 3)
	elseif (curFruit == "zfs_lemon") then
		FruitEnt:SetBodygroup(0, 4)
	elseif (curFruit == "zfs_kiwi") then
		FruitEnt:SetBodygroup(0, 5)
	elseif (curFruit == "zfs_orange") then
		FruitEnt:SetBodygroup(0, 6)
	elseif (curFruit == "zfs_strawberry") then
		FruitEnt:SetBodygroup(0, 7)
	elseif (curFruit == "zfs_apple") then
		FruitEnt:SetBodygroup(0, 8)
	end

	// This Offsets the next sliced fruit
	if (Shop.FruitsToSlice > 6) then
		Shop.mixerStack = Shop.mixerStack + (10 / Shop.FruitsToSlice)
	else
		Shop.mixerStack = Shop.mixerStack + 1
	end

	//Adds the sliced fruit in to our Mixer
	table.insert(Shop.FruitsInMixer, FruitEnt)

	// Removes the sliced fruit from our todo slice list
	table.RemoveByValue(Shop.NeededFruits, fruit:GetClass())
	zfs.f.Debug("Removed " .. tostring(fruit) .. " from the NeedCutBowl.")

	// This removes the Fruit prop
	fruit:Remove()

	zfs.f.Shop_action_GetFruit(Shop)
end

// Show Sweeteners
function zfs.f.Shop_action_ShowSweetener(Shop)
	// Show all the Sweeteners
	for i, k in pairs(Shop.Sweeteners) do
		if (IsValid(Shop.Sweeteners[i])) then
			Shop.Sweeteners[i]:SetNoDraw(false)
		end
	end

	Shop.Sweeteners["Coffe"]:SetPos(Shop:GetAttachment(Shop:LookupAttachment("workplace")).Pos + Shop:GetUp() * 3 + Shop:GetForward() * -12 + Shop:GetForward() * 0)
	Shop.Sweeteners["Milk"]:SetPos(Shop:GetAttachment(Shop:LookupAttachment("workplace")).Pos + Shop:GetUp() * 3 + Shop:GetForward() * -12 + Shop:GetForward() * 11)
	Shop.Sweeteners["Chocolate"]:SetPos(Shop:GetAttachment(Shop:LookupAttachment("workplace")).Pos + Shop:GetUp() * 3 + Shop:GetForward() * -12 + Shop:GetForward() * 22)
end

// Add Sweetener
function zfs.f.Shop_action_AddSweetener(Shop,sweettype)
	zfs.f.Shop_ChangeState(Shop,10)
	zfs.f.Shop_SetBusy(Shop,4)

	// This hides all the other Sweetener
	for i, k in pairs(Shop.Sweeteners) do
		if (IsValid(Shop.Sweeteners[i]) and i ~= sweettype) then
			Shop.Sweeteners[i]:SetNoDraw(true)
			Shop.Sweeteners[i]:SetPos(Shop:GetAttachment(Shop:LookupAttachment("fruitlift")).Pos + Shop:GetUp() * 15)
		end
	end

	Shop.Sweeteners[sweettype]:SetPos(Shop:GetAttachment(Shop:LookupAttachment("mixer_floor")).Pos + Shop:GetUp() * 15)
end

// Starts the Mixer
function zfs.f.Shop_action_StartMixer(Shop)
	// This clears all the props in the mixer
	for i, k in pairs(Shop.FruitsInMixer) do
		if (IsValid(Shop.FruitsInMixer[i])) then
			Shop.FruitsInMixer[i]:Remove()
		end
	end

	// This creats all of the SFX & VFX of the Mixer
	zfs.f.CreateAnimTable(Shop.Mixer, "mix", 2)

	zfs.f.CreateEffectTable(nil, "zfs_sfx_startmixer", Shop, Shop:GetAngles(), Shop:GetPos(), nil)
	zfs.f.CreateEffectTable(nil, "zfs_sfx_mix", Shop, Shop:GetAngles(), Shop:GetPos(), nil)

	Shop.Mixer:SetBodygroup(0, 1)
	Shop.Mixer:SetColor(zfs.config.FruitCups[Shop:GetTSelectedItem()].fruitColor)
	zfs.f.Shop_ChangeState(Shop,12)
	zfs.f.Shop_SetBusy(Shop,8)

	timer.Simple(8, function()
		if IsValid(Shop) then
			zfs.f.CreateAnimTable(Shop.Mixer, "open", 1)

			Shop.Mixer:SetBodygroup(0, 0)

			Shop.Mixer:SetColor(zfs.default_colors["white01"])
			zfs.f.Shop_action_FinishCup(Shop)
		end
	end)
end

// Creats our Finished Product
function zfs.f.Shop_action_FinishCup(Shop)
	// This removes our work in progress Cup
	Shop.Cup_InWork:SetNoDraw(true)

	// This Creates our product
	local productData = zfs.config.FruitCups[Shop:GetTSelectedItem()]
	local product = ents.Create("zfs_fruitcup_base")
	product:Spawn()
	product:Activate()
	product:SetParent(Shop)
	product:SetColor(productData.fruitColor)
	product:SetModelScale(1)
	product:SetBodygroup(0, 1)

	product:SetSmoothieCreator(Shop.SmoothieCreator:SteamID())

	// 164285642

	// This Creates our Topping
	if (Shop:GetTSelectedTopping() ~= 1) then
		local toppingData = zfs.utility.SortedToppingsTable[Shop:GetTSelectedTopping()]
		local topping = ents.Create("zfs_topping")
		local ang = Shop:GetAngles()
		ang:RotateAroundAxis(Shop:GetUp(), 90)
		topping:SetAngles(ang)
		topping:SetPos(product:GetPos() + product:GetUp() * 10)
		topping:Spawn()
		topping:SetParent(product)
		topping:Activate()
		topping:SetModel(toppingData.Model)
		topping:SetModelScale(toppingData.mScale)
		product:DeleteOnRemove(topping)
	end

	// Everyone can buy it but its stell a entity from the shop owner
	zfs.f.SetOwnerID(product, zfs.f.GetOwner(Shop))

	// Add our fruit cup to a free spot on our World/Lua Table
	zfs.f.Shop_AddProductToSellTable(Shop,product)

	// This Allows the Item do get sold
	product.ReadydoSell = true

	// Here we tell our Cup what item he is from the config
	product.ProductID = Shop:GetTSelectedItem()

	// Here we tell our Cup what his topping is
	product.ToppingID = Shop:GetTSelectedTopping()

	// This Sets the Price of our Cup
	if zfs.config.Price.Custom then
		product:SetPrice(Shop:GetPPrice() + zfs.config.Toppings[Shop:GetTSelectedTopping()].ExtraPrice)
	else
		// Here we calculate what the Fruit varation boni is
		local PriceBoni = zfs.f.CalculateFruitVarationBoni(productData) * zfs.config.Price.FruitMultiplicator

		local FruitVariationCharge = math.Round(productData.Price * PriceBoni)

		local finalprice = Shop:GetPPrice() + FruitVariationCharge + zfs.config.Toppings[Shop:GetTSelectedTopping()].ExtraPrice

		product:SetPrice(finalprice)
	end

	// Custom Hook
	hook.Run("zfs_OnSmoothieMade" ,Shop.SmoothieCreator, product, product.ProductID)


	// Here we remove the used fruits from our storage
	for k, v in pairs(productData.recipe) do
		if v > 0 then
			zfs.f.Shop_RemoveStorage(Shop,k, v)
		end
	end

	zfs.f.Shop_action_Restart(Shop)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////






//////////////////////////////////////////////////////////////
/////////////// Actions - Selling ////////////////////////////
//////////////////////////////////////////////////////////////
util.AddNetworkString("zfs_ItemBuy_cl")

net.Receive("zfs_ItemBuy_cl", function(len, ply)
	if zfs.f.NW_Player_Timeout(ply) then return end

	local w_item = net.ReadEntity()

	if IsValid(w_item) and w_item:GetClass() == "zfs_fruitcup_base" and zfs.f.InDistance(ply:GetPos(), w_item:GetPos(), 200) and ply:Alive() then

		local price = w_item:GetPrice()

		// If we are on DarkRp then check if the Player has enough money
		if not zfs.f.HasMoney(ply, price) then
			zfs.f.Notify(ply, zfs.language.Shop.Item_NoMoney, 1)

			return
		end

		// Does the player have the right Ulx Group to Consume the topping of this Item?
		local Ranks_consume = zfs.config.Toppings[w_item.ToppingID].Ranks_consume
		if table.Count(Ranks_consume) > 0 then
			local permission = zfs.f.PlayerRankCheck(ply,Ranks_consume)

			if permission == false then

				local allowedGroups = zfs.f.CreateAllowList(Ranks_consume)
				allowedGroups = table.concat( allowedGroups, ",", 1, #allowedGroups )
				zfs.f.Notify(ply, zfs.language.Shop.Item_WrongUlx01 .. allowedGroups, 3)
				zfs.f.Notify(ply, zfs.language.Shop.Item_WrongUlx02, 1)
				return
			end
		end

		// Does the player have the right Job to Consume the topping of this Item?
		local Job_consume = zfs.config.Toppings[w_item.ToppingID].Job_consume
		if table.Count(Job_consume) > 0 then
			local JobPermission = Job_consume[zfs.f.GetPlayerJob(ply)]

			if (JobPermission == false or JobPermission == nil) then

				local allowedJobs = zfs.f.CreateAllowList(Job_consume)
				allowedJobs = table.concat( allowedJobs, ",", 1, #allowedJobs )

				zfs.f.Notify(ply, zfs.language.Shop.Item_WrongJob01 .. allowedJobs, 3)
				zfs.f.Notify(ply, zfs.language.Shop.Item_WrongJob02, 1)

				return
			end
		end

		zfs.f.Debug("Received Benefits by " .. ply:Nick())
		zfs.f.Debug(zfs.config.Toppings[w_item.ToppingID].ToppingBenefits)

		// This Handles the sell action of the cup from the Shop
		zfs.f.Shop_action_SellCup(w_item:GetParent(),w_item, ply, price)
	end
end)

// This Function gets called from the cup when someone buys it
function zfs.f.Shop_action_SellCup(Shop,cup, ply, price)

	zfs.f.Debug("Buyer: " .. ply:Nick())
	zfs.f.Debug("Sold Cup EntIndex: " .. cup:EntIndex())
	zfs.f.Debug(cup.PrintName .. " Sold!")

	zfs.f.CreateEffectTable("zfs_sell_effect", "zfs_cup_sold", Shop, cup:GetAngles(), cup:GetPos(), nil)
	local cupData = zfs.config.FruitCups[cup.ProductID]

	// The Indicators for the Purchase
	local PurchaseInfo = string.Replace(zfs.language.Shop.ItemBought, "$itemName", tostring(cupData.Name))
	PurchaseInfo = string.Replace(PurchaseInfo, "$itemPrice", tostring(price))
	PurchaseInfo = string.Replace(PurchaseInfo, "$currency", zfs.config.Currency)
	zfs.f.Notify(ply, PurchaseInfo, 0)

	// This makes the Money Transaction and informs the creator of the cup
	local smoothie_creator = player.GetBySteamID( cup:GetSmoothieCreator() )
	if IsValid(smoothie_creator) then
		zfs.f.GiveMoney(smoothie_creator, price)
		local SellInfo = ply:Nick() .. " [" .. tostring(cupData.Name) .. "] +" .. zfs.config.Currency .. tostring(price)
		zfs.f.Notify(smoothie_creator, SellInfo, 0)
	end
	zfs.f.TakeMoney(ply, price)

	// Custom Hook
	hook.Run("zfs_OnSmoothieSold" ,ply, price, cup,cup.ProductID)

	zfs.f.Shop_action_DropCup(Shop,cup.ProductID,cup.ToppingID, ply)

	// This Removes the Cup from Table and World
	zfs.f.Shop_RemoveProductFromSellTable(Shop,cup, cup.SellTable_Index)
end

// Drops the bought fruitcup entity on the floor
function zfs.f.Shop_action_DropCup(Shop,product_id,topping_id, ply)
	local ent = ents.Create("zfs_smoothie")
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(Shop:LocalToWorld(Vector(10,-25,50)))
	ent:Spawn()
	ent:Activate()
	ent:SetProductID(product_id)
	ent:SetToppingID(topping_id)
	zfs.f.Smoothie_Visuals(ent)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////







//////////////////////////////////////////////////////////////
////////////////////////// Misc ////////////////////////////
//////////////////////////////////////////////////////////////

// Gets called when we change the State
function zfs.f.Shop_ChangeState(Shop,state)
	if Shop:GetCurrentState() == state then

		zfs.f.Debug("Cant change to " .. state .. " since its allready in that state")
		return
	end

	zfs.f.Debug("State Changed too " .. state)

	Shop:SetCurrentState(state)
end

// Is used for locking the controlls and telling the Player to wait
function zfs.f.Shop_SetBusy(Shop,time)
	Shop:SetIsBusy(true)

	timer.Simple(time, function()
		if IsValid(Shop) then
			Shop:SetIsBusy(false)
		end
	end)
end

function zfs.f.Shop_AnimSequence(Shop,anim1, anim2, speed)

	zfs.f.CreateAnimTable(Shop, anim1, speed)
	timer.Simple(Shop:SequenceDuration(Shop:GetSequence()), function()
		if not IsValid(Shop) then return end
		zfs.f.CreateAnimTable(Shop, anim2, speed)
	end)
end
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////
////////////////////////// Pickup ////////////////////////////
//////////////////////////////////////////////////////////////
// Here we make sure the players cant pick up the shop when its running
local function ShopPickup(ply, ent)
	if ent:GetClass() == "zfs_shop" then
		if ent:GetCurrentState() == 0 and ply == zfs.f.GetOwner(ent) then
			return true
		else
			return false
		end
	end
end

hook.Add("PhysgunPickup", "zfs_AllowShopPickUp", ShopPickup)
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
