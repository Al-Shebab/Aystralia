if not SERVER then return end
zrush = zrush or {}
zrush.f = zrush.f or {}
zrush.f.FuelBuyers = zrush.f.FuelBuyers or {}


function zrush.f.FuelBuyer_Initialize(FuelBuyer)
	FuelBuyer:SetModel(zrush.config.FuelBuyer.Model)
	FuelBuyer:SetSolid(SOLID_BBOX)
	FuelBuyer:SetHullSizeNormal()

	FuelBuyer:SetNPCState(NPC_STATE_SCRIPT)
	FuelBuyer:SetHullType(HULL_HUMAN)
	FuelBuyer:SetUseType(SIMPLE_USE)

	FuelBuyer:CapabilitiesAdd(CAP_ANIMATEDFACE)
	FuelBuyer:CapabilitiesAdd(CAP_TURN_HEAD)


	zrush.f.FuelBuyer_RefreshBuyRate(FuelBuyer)

	table.insert(zrush.f.FuelBuyers,FuelBuyer)
end

// Called when a player presses e on the fuelbuyer
function zrush.f.FuelBuyer_OnUse(FuelBuyer,ply)

	// Does the player have the correct job?
	if zrush.config.Jobs and table.Count(zrush.config.Jobs) > 0 and zrush.config.Jobs[zrush.f.GetPlayerJob(ply)] == nil then
		zrush.f.Notify(ply, zrush.language.VGUI["WrongJob"], 1)

		return
	end

	if zrush.config.FuelBuyer.SellMode == 1 then
		// Open Sell UI
		net.Start("zrush_OpenSellFuelUI_net")
		net.WriteEntity(FuelBuyer)
		net.WriteTable(ply:zrush_GetFuelBarrels())
		net.Send(ply)
	else
		// 	Direct Sell
		zrush.f.FuelBuyer_DirectSell(FuelBuyer, ply)
	end
end



// Used to Play a Animation after another
function zrush.f.FuelBuyer_AnimSequence(FuelBuyer,anim1, anim2, speed)
	zrush.f.PlayAnimation(FuelBuyer, anim1, speed)

	timer.Simple(FuelBuyer:SequenceDuration(FuelBuyer:GetSequence()), function()
		if not IsValid(FuelBuyer) then return end
		zrush.f.PlayAnimation(FuelBuyer, anim2, speed)
	end)
end

function zrush.f.FuelBuyer_RefreshBuyRate(FuelBuyer)
	FuelBuyer:SetPrice_Mul(math.random(zrush.config.FuelBuyer.MinBuyRate, zrush.config.FuelBuyer.MaxBuyRate))
end



function zrush.f.FuelBuyer_ChangeFuelMarkt()
	for k, v in pairs(zrush.f.FuelBuyers) do
		if IsValid(v) then
			zrush.f.FuelBuyer_RefreshBuyRate(v)
		end
	end
end

function zrush.f.FuelBuyer_FuelBuyerMarkt_TimerExist()

	local timerid = "zrush_fuelbuyermarkt_id"
	zrush.f.Timer_Remove(timerid)
	zrush.f.Timer_Create(timerid, zrush.config.FuelBuyer.RefreshRate, 0,zrush.f.FuelBuyer_ChangeFuelMarkt)
end
//hook.Add("InitPostEntity", "a.zrush.InitPostEntity.Fuelbuyermarkt_OnMapLoad", zrush.f.FuelBuyer_FuelBuyerMarkt_TimerExist)
zrush.f.FuelBuyer_FuelBuyerMarkt_TimerExist()

util.AddNetworkString("zrush_OpenSellFuelUI_net")
util.AddNetworkString("zrush_CloseSellFuelUI_net")
util.AddNetworkString("zrush_SellFuel_net")
util.AddNetworkString("zrush_UpdateSellFuelUI_net")

net.Receive("zrush_SellFuel_net", function(len, ply)
	if zrush.f.NW_Player_Timeout(ply) then return end
	local ent = net.ReadEntity()
	local soldFuelIndex = net.ReadInt(16)
	local sellAll = net.ReadBool()

	if (IsValid(ent) and ent:GetClass() == "zrush_fuelbuyer_npc" and zrush.f.InDistance(ent:GetPos(),ply:GetPos(),200)) then
		zrush.f.FuelBuyer_SellFuel(ent, ply, soldFuelIndex, sellAll)
	end
end)

function zrush.f.FuelBuyer_SellFuel(fuelnpc, ply, id, sellAll)
	local playerFuelTable = {}
	table.CopyFromTo(ply:zrush_GetFuelBarrels(), playerFuelTable)

	local fuelAmount = playerFuelTable[id]
	local sellAmount = 0

	if (fuelAmount >= zrush.config.FuelBuyer.SellAmount) then
		if (sellAll) then
			sellAmount = fuelAmount
		else
			sellAmount = zrush.config.FuelBuyer.SellAmount
		end
	else
		sellAmount = fuelAmount
	end

	if sellAmount <= 0 then return end

	ply:zrush_SoldFuelBarrel(id, sellAmount)
	ply:zrush_RemoveFuelBarrel(id, sellAmount)
	local sellProfit = fuelnpc:GetPrice_Mul() / 100
	local Earning = (zrush.Fuel[id].price * sellAmount) * sellProfit

	// Give the player the Cash
	zrush.f.GiveMoney(ply, Earning)
	local str = zrush.language.NPC["YouSold"]
	str = string.Replace(str, "$Amount", tostring(math.Round(sellAmount)))
	str = string.Replace(str, "$UoM", zrush.config.UoM)
	str = string.Replace(str, "$Fuelname", zrush.Fuel[id].name)
	str = string.Replace(str, "$Earning", tostring(math.Round(Earning)))
	str = string.Replace(str, "$Currency", zrush.config.Currency)
	zrush.f.Notify(ply, str, 0)
	zrush.f.CreateNetEffect("npc_cash",ply)


	// Custom Hook
	hook.Run("zrush_OnFuelSold", ply,sellAmount,id,Earning,fuelnpc)

	// Play the Sell Animation
	zrush.f.FuelBuyer_AnimSequence(fuelnpc,zrush.config.FuelBuyer.anim_sell[math.random(#zrush.config.FuelBuyer.anim_sell)], zrush.config.FuelBuyer.anim_idle[math.random(#zrush.config.FuelBuyer.anim_idle)], 1)

	net.Start("zrush_UpdateSellFuelUI_net")
	net.WriteEntity(fuelnpc)
	net.WriteTable(ply:zrush_GetFuelBarrels())
	net.Send(ply)
end

function zrush.f.FuelBuyer_DirectSell(fuelnpc, ply)



	local FuelInDistance = {}
	for k, v in pairs(zrush.EntList) do
		if IsValid(v) and zrush.f.InDistance(ply:GetPos(), v:GetPos(), 250) then
			if v:GetClass() == "zrush_palette" and v.BarrelCount > 0 then

				for f_id,f_amount in pairs(v.FuelList) do
					FuelInDistance[f_id] = (FuelInDistance[f_id] or 0) + f_amount
				end

				SafeRemoveEntity(v)

			elseif v:GetClass() == "zrush_barrel" and v:GetFuelTypeID() > 0 and v:GetFuel() > 0 then

				FuelInDistance[v:GetFuelTypeID()] = (FuelInDistance[v:GetFuelTypeID()] or 0) + v:GetFuel()

				SafeRemoveEntity(v)
			end
		end
	end

	if table.Count(FuelInDistance) <= 0 then

		zrush.f.Notify(ply, zrush.language.NPC["NoFuel"], 1)
		return
	end

	local sellProfit = fuelnpc:GetPrice_Mul() / 100

	for k, v in pairs(FuelInDistance) do
		if k and v then
			local fuel_id = k
			local fuelAmount = v

			if zrush.Fuel[fuel_id] == nil then continue end

			ply:zrush_SoldFuelBarrel(fuel_id, fuelAmount)

			local Earning = (zrush.Fuel[fuel_id].price * fuelAmount) * sellProfit

			// Give the player the Cash
			zrush.f.GiveMoney(ply, Earning)
			local str = zrush.language.NPC["YouSold"]
			str = string.Replace(str, "$Amount", tostring(math.Round(fuelAmount)))
			str = string.Replace(str, "$UoM", zrush.config.UoM)
			str = string.Replace(str, "$Fuelname", zrush.Fuel[fuel_id].name)
			str = string.Replace(str, "$Earning", tostring(math.Round(Earning)))
			str = string.Replace(str, "$Currency", zrush.config.Currency)
			zrush.f.Notify(ply, str, 0)

			// Custom Hook
			hook.Run("zrush_OnFuelSold", ply,fuelAmount,fuel_id,Earning,fuelnpc)
		end
	end

	zrush.f.CreateNetEffect("npc_cash",ply)

	// Play the Sell Animation
	zrush.f.FuelBuyer_AnimSequence(fuelnpc,zrush.config.FuelBuyer.anim_sell[math.random(#zrush.config.FuelBuyer.anim_sell)], zrush.config.FuelBuyer.anim_idle[math.random(#zrush.config.FuelBuyer.anim_idle)], 1)
end
