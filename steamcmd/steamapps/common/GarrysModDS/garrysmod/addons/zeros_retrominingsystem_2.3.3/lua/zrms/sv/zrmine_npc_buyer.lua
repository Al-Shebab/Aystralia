if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.BuyerNPC_Initialize(BuyerNPC)

	timer.Simple(1, function()
		if (IsValid(BuyerNPC)) then
			zrmine.f.BuyerNPC_RefreshBuyRate(BuyerNPC)
		end
	end)

	zrmine.f.EntList_Add(BuyerNPC)
end

function zrmine.f.BuyerNPC_RefreshBuyRate(BuyerNPC)
	BuyerNPC:SetBuyRate(math.random(zrmine.config.MetalBuyer.MinRate, zrmine.config.MetalBuyer.MaxRate))
end


hook.Add( "EntityTakeDamage", "zrmine_EntityDamage_NPCFix", function( target, dmginfo )
	if IsValid(target) and target:GetClass() == "zrms_buyer" then
		return true
	end
end )

function zrmine.f.BuyerNPC_USE(BuyerNPC,ply,key)

	if (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and BuyerNPC:GetCurrentState() == 0 then

		// Is the Player a customer of the BuyerNPC
		if (zrmine.f.Player_IsMiner(ply)) then

			// Does the Player have metal do sell
			if ply:zrms_HasMetalBars() then

				zrmine.f.BuyerNPC_ChangeState(BuyerNPC,1)

				// Here we sell the bars
				zrmine.f.BuyerNPC_SellBars(ply, BuyerNPC)

			else
				zrmine.f.BuyerNPC_ChangeState(BuyerNPC,2)

				zrmine.f.Notify(ply, zrmine.language.NPC_NoProduct, 1)
			end
		else

			zrmine.f.BuyerNPC_ChangeState(BuyerNPC,2)
			zrmine.f.Notify(ply, zrmine.language.NPC_GoAway, 1)
		end
	end
end

function zrmine.f.BuyerNPC_ChangeState(npc,state)
	npc:SetCurrentState(state)

	timer.Simple(2,function()
		if IsValid(npc) then
			npc:SetCurrentState(0)
		end
	end)
end

// This function is used do sell Metal Bars
function zrmine.f.BuyerNPC_SellBars(ply, buyer)

	// Calculate the Earnings
	local ply_MetalBars = ply:zrms_GetMetalBars()
	local Earning = 0
	local sellProfit = buyer:GetBuyRate() / 100
	local SoldBars = {}

	for k, v in pairs(ply_MetalBars) do
		if (v > 0) then
			Earning = Earning + (v * zrmine.config.BarValue[k]) * sellProfit
			ply:zrms_AddMetalBarsSold(k, v)
			table.insert(SoldBars, zrmine.f.GetOreTranslation(k) .. ": " .. v .. ", ")
		end
	end

	// Custom Hook
	hook.Run("zrmine_OnSelling", ply, BuyerNPC, sellProfit, ply_MetalBars,Earning)

	// Give the player the Cash
	zrmine.f.GiveMoney(ply, Earning)

	zrmine.f.Notify(ply, zrmine.language.Sold .. ": " .. string.Implode(" ", SoldBars), 0)

	timer.Simple(0.6,function()
		if IsValid(ply) then
			zrmine.f.Notify(ply, "+ " .. math.Round(Earning) .. zrmine.config.Currency, 0)
		end
	end)

	// Resets Players bar  amount
	ply:zrms_ResetMetalBars()
end


//Saving
function zrmine.f.BuyerNPC_Save(ply)
	local data = {}

	for u, j in pairs(ents.FindByClass("zrms_buyer")) do
		table.insert(data, {
			class = j:GetClass(),
			pos = j:GetPos(),
			ang = j:GetAngles()
		})
	end

	if not file.Exists("zrms", "DATA") then
		file.CreateDir("zrms")
	end

	file.Write("zrms/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", util.TableToJSON(data))
	zrmine.f.Notify(ply, "BuyerNPC´s have been saved for the map " .. string.lower(game.GetMap()) .. "!", 0)
end

function zrmine.f.BuyerNPC_Remove(ply)
	for u, j in pairs(ents.FindByClass("zrms_buyer")) do
		if IsValid(j) then
			SafeRemoveEntity(j)
		end
	end

	if  file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA") then
		file.Delete("zrms/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt")
	end

	zrmine.f.Notify(ply, "BuyerNPC´s have been removed for the map " .. string.lower(game.GetMap()) .. "!", 0)
end


function zrmine.f.BuyerNPC_Load()
	if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA") then
		local data = file.Read("zrms/" .. string.lower(game.GetMap()) .. "_BuyerNPCs" .. ".txt", "DATA")
		data = util.JSONToTable(data)

		for k, v in pairs(data) do
			local oreSpawner = ents.Create("zrms_buyer")
			oreSpawner:SetPos(v.pos)
			oreSpawner:SetAngles(v.ang)
			oreSpawner:Spawn()
		end

		print("[Zeros Retro MiningSystem] Finished loading Buyer NPCs.")
	else
		print("[Zeros Retro MiningSystem] No map data found for BuyerNPCs entities. Please place some and do !savezrms to create the data.")
	end
end
timer.Simple(1,function()
    zrmine.f.BuyerNPC_Load()
end)
hook.Add("PostCleanupMap", "a_zrmine_SpawnBuyerNPCPostCleanUp", zrmine.f.BuyerNPC_Load)
