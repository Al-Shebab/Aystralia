if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

util.AddNetworkString("zfs_ItemBuy_net")

//////////////////////////////////////////////////////////////
//////////////////////// FRUITCUP ////////////////////////////
//////////////////////////////////////////////////////////////

// Called when the Smoothie Initializes
function zfs.f.FruitCup_Initialize(FruitCup)
	zfs.f.EntList_Add(FruitCup)

	// Since we create a complete new entity when finishing a fruit cup this got Obsolete
	FruitCup.ReadydoSell = false

	// This is not in use atm sry
	FruitCup:SetPrice(-1)

	// This makes sure it cant get sold for 1 Second
	FruitCup.SaleDelay = true

	timer.Simple(1, function()
		if IsValid(FruitCup) then
			FruitCup.SaleDelay = false
		end
	end)

	// The Importent Information about the Cup
	FruitCup.ToppingID = nil
	FruitCup.ProductID = nil
end

function zfs.f.FruitCup_Use(ply, FruitCup)
	if not FruitCup.ReadydoSell or FruitCup.SaleDelay then return end

	if (FruitCup.ProductID) then

		if zfs.config.FruitcupCreatorBuy == false and ply:SteamID() == FruitCup:GetSmoothieCreator() then
			zfs.f.Notify(ply, zfs.language.Shop.Item_BuyerIsCreator, 1)
			return
		end

		net.Start("zfs_ItemBuy_net")
		net.WriteInt(FruitCup.ProductID,6)
		net.WriteInt(FruitCup.ToppingID,6)
		net.WriteInt(FruitCup:GetPrice(),24)
		net.WriteEntity(FruitCup)
		net.Send(ply)
	else
		zfs.f.Debug("ProductID is nil?")
	end
end

function zfs.f.FruitCup_Interaction_Stop(plyid)
	zfs.f.Debug("zfs.f.FruitCup_Interaction_Stop")
	local ply = player.GetBySteamID(plyid)

	if IsValid(ply) then
		// Closes the buy interface
		net.Start("zfs_ItemSellWindowClose_sv")
		net.Send(ply)
	end
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////





//////////////////////////////////////////////////////////////
//////////////////////// SMOOTHIE ////////////////////////////
//////////////////////////////////////////////////////////////

// Called when the Smoothie Initializes
function zfs.f.Smoothie_Initialize(Smoothie)
	zfs.f.EntList_Add(Smoothie)

	// The Importent Information about the Cup
	Smoothie:SetProductID(1)
	Smoothie:SetToppingID(1)

	Smoothie.GotConsumed = false

	zfs.f.Smoothie_Visuals(Smoothie)
end

function zfs.f.Smoothie_Visuals(Smoothie)

	Smoothie:SetBodygroup(0,1)
	Smoothie:SetColor(zfs.config.FruitCups[Smoothie:GetProductID()].fruitColor)

	local tID = Smoothie:GetToppingID()
	if tID > 1 then
		local toppingData = zfs.utility.SortedToppingsTable[tID]
		local topping = ents.Create("zfs_topping")
		topping:SetPos(Smoothie:GetPos() + Smoothie:GetUp() * 10)
		topping:Spawn()
		topping:SetParent(Smoothie)
		topping:Activate()
		topping:SetModel(toppingData.Model)
		topping:SetModelScale(toppingData.mScale)
		Smoothie:DeleteOnRemove(topping)
	end
end

function zfs.f.Smoothie_Use(ply, Smoothie)
	if Smoothie.GotConsumed == true then return end

	local ProductID = Smoothie:GetProductID()

	if ProductID then
		local ToppingID = Smoothie:GetToppingID()
		Smoothie.GotConsumed = true

		// The Topping Consume Info we tell the Player
		zfs.f.Notify(ply, zfs.config.Toppings[ToppingID].ConsumInfo, 0)

		// This gives the player the Default Health of the Fruitcup
		local extraHealth = zfs.f.CalculateFruitHealth(zfs.config.FruitCups[ProductID])
		extraHealth = math.Round(extraHealth)

		if (zfs.config.Health.UseHungermod) then
			local newEnergy = (ply:getDarkRPVar("Energy") or 100) + (extraHealth or 1)
			ply:setDarkRPVar("Energy", newEnergy)
		else
			local newHealth = ply:Health() + extraHealth

			if zfs.config.Health.HealthCap and newHealth > zfs.config.Health.MaxHealthCap then
				newHealth = zfs.config.Health.MaxHealthCap
				zfs.f.Notify(ply, zfs.language.Benefit.CantAdd_ExtraHealth, 1)
			end

			ply:SetHealth(newHealth)
		end

		// This gives the player all the Extra Benefits from the Topping
		for k, v in pairs(zfs.config.Toppings[ToppingID].ToppingBenefits) do
			if (k ~= nil) then
				zfs.Benefits[k](ply, ToppingID, true)
			end
		end

		SafeRemoveEntity(Smoothie)
	else
		zfs.f.Debug("ProductID is nil?")
	end
end


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
