concommand.Add("doorlinker",function(ply,cmd,args)

	local AllowGroup = {}
	AllowGroup["superadmin"] = true
	AllowGroup["admin"] = true

	for k,v in pairs(AllowGroup) do
		if ply:GetNWString("usergroup") == k then
			ply:Give("door_linker")
			ply:SelectWeapon("door_linker")
			return
		end
	end
end)


local function BoughtDoor(ply,entity,cost)
	local DoorLink = Door_HasLink(entity)
	if DoorLink then
		local NeedMoney = table.Count(DoorLink.Items)
		NeedMoney = NeedMoney - 1
		NeedMoney = NeedMoney*cost
		
		if ply:getDarkRPVar("money") < NeedMoney then
			GAMEMODE:Notify(ply,4,4,"You need $ " .. NeedMoney .. " to buy rest of linked door!")
				entity:UnOwn(ply)
				ply:GetTable().OwnedNumz = math.abs(ply:GetTable().OwnedNumz - 1)
				ply:GetTable().Ownedz[entity:EntIndex()] = nil
			
				if DoorLink_Config.GamemodeCode == 1 then
					ply:AddMoney(cost)
				end
				if DoorLink_Config.GamemodeCode == 2 then
					ply:addMoney(cost)
				end
			return
		end
		
		local Count = 0
		for k,v in pairs(DoorLink.Items) do
			local Ent = ents.GetByIndex(v)
			if Ent and Ent:IsValid() and Ent != entity then
				Count = Count + 1
				if DoorLink_Config.GamemodeCode == 1 then
					ply:AddMoney(-cost)
					Ent:Own(ply)
				end
				if DoorLink_Config.GamemodeCode == 2 then
					ply:addMoney(-cost)
					Ent:keysOwn(ply)
				end
				
				ply:GetTable().OwnedNumz = ply:GetTable().OwnedNumz + 1
				ply:GetTable().Ownedz[Ent:EntIndex()] = Ent
			
			end
		end
		if DoorLink_Config.GamemodeCode == 1 then
			GAMEMODE:Notify(ply,3,4,Count .. " Linked Door bought. ( - $" .. Count*cost .. " )")
		end
		if DoorLink_Config.GamemodeCode == 2 then
			DarkRP.notify(ply,3,4,Count .. " Linked Door bought. ( - $" .. Count*cost .. " )")
		end
		
	end
end


if DoorLink_Config.GamemodeCode == 1 then
	hook.Add("PlayerBoughtDoor","Linked Door Buy",function(ply,entity,cost)
		BoughtDoor(ply,entity,cost)
	end)
end
if DoorLink_Config.GamemodeCode == 2 then
	hook.Add("playerBoughtDoor","Linked Door Buy",function(ply,entity,cost)
		BoughtDoor(ply,entity,cost)
	end)
end


local function SoldDoor(ply,entity,refund)
	local DoorLink = Door_HasLink(entity)
	if DoorLink then
		local Count = 0
		for k,v in pairs(DoorLink.Items) do
			local Ent = ents.GetByIndex(v)
			if Ent and Ent:IsValid() and Ent != entity then
				Count = Count + 1
				if DoorLink_Config.GamemodeCode == 1 then
					Ent:UnOwn(ply)
				end
				if DoorLink_Config.GamemodeCode == 2 then
					Ent:keysUnOwn(ply)
				end
				
				ply:GetTable().OwnedNumz = math.abs(ply:GetTable().OwnedNumz - 1)
				ply:GetTable().Ownedz[Ent:EntIndex()] = nil
			
				if DoorLink_Config.GamemodeCode == 1 then
					ply:AddMoney(refund)
				end
				if DoorLink_Config.GamemodeCode == 2 then
					ply:addMoney(refund)
				end
			end
		end
		if DoorLink_Config.GamemodeCode == 1 then
			GAMEMODE:Notify(ply,2,4,Count .. " Linked Door sold. ( + $" .. Count*refund .. " )")
		end
		if DoorLink_Config.GamemodeCode == 2 then
			DarkRP.notify(ply,2,4,Count .. " Linked Door sold. ( + $" .. Count*refund .. " )")
		end
	end
end





if DoorLink_Config.GamemodeCode == 1 then
	hook.Add("PlayerSoldDoor","Linked Door Sell",function(ply,entity,refund)
		SoldDoor(ply,entity,refund)
	end)
end
if DoorLink_Config.GamemodeCode == 2 then
	hook.Add("playerKeysSold","Linked Door Sell",function(ply,entity,refund)
		SoldDoor(ply,entity,refund)
	end)
end



local function AddOwnership(entity,target)
	local DoorLink = Door_HasLink(entity)
	if DoorLink then
		local Count = 0
		for k,v in pairs(DoorLink.Items) do
			local Ent = ents.GetByIndex(v)
			if Ent and Ent:IsValid() and Ent != entity then
				Count = Count + 1
				
				if Ent.addKeysAllowedToOwn then
					Ent:addKeysAllowedToOwn(target)
				end
			end
		end
		if DoorLink_Config.GamemodeCode == 1 then
			GAMEMODE:Notify(ply,2,4,"Also Granted access to " .. Count .. " Linked Door")
		end
		if DoorLink_Config.GamemodeCode == 2 then
			DarkRP.notify(ply,2,4,"Also Granted access to " .. Count .. " Linked Door")
		end
	end
end

local function RemoveOwnership(entity,target)
	local DoorLink = Door_HasLink(entity)
	if DoorLink then
		local Count = 0
		for k,v in pairs(DoorLink.Items) do
			local Ent = ents.GetByIndex(v)
			if Ent and Ent:IsValid() and Ent != entity then
				Count = Count + 1
				
				if entity:isKeysAllowedToOwn(target) then
					entity:removeKeysAllowedToOwn(target)
				end

				if entity:isKeysOwnedBy(target) then
					entity:removeKeysDoorOwner(target)
				end
			end
		end
		if DoorLink_Config.GamemodeCode == 1 then
			GAMEMODE:Notify(ply,2,4,"Also Removed access from " .. Count .. " Linked Door")
		end
		if DoorLink_Config.GamemodeCode == 2 then
			DarkRP.notify(ply,2,4,"Also Removed access from " .. Count .. " Linked Door")
		end
	end
end

hook.Add("onAllowedToOwnAdded","DoorLinker : onAllowedToOwnAdded",function(ply,entity,target)
	AddOwnership(entity,target)
end)

hook.Add("onAllowedToOwnRemoved","DoorLinker : onAllowedToOwnAdded",function(ply,entity,target)
	RemoveOwnership(entity,target)
end)