if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Sorter_Initialize(Sorter)
	Sorter.StoredResource = {}
	Sorter.StoredResource["Coal"] = 0
	Sorter.StoredResource["Iron"] = 0
	Sorter.StoredResource["Bronze"] = 0
	Sorter.StoredResource["Silver"] = 0
	Sorter.StoredResource["Gold"] = 0

	zrmine.f.EntList_Add(Sorter)
end

/*
	StateInfo:
	0 = WAITING_FOR_ORDER
	1 = FILTERING
*/


// Here we send resources to our Children
function zrmine.f.Sorter_SendResources(Sorter)

	local sendTable = {}

	local filterType
	if (Sorter.FilterType == 0) then
		filterType = "Coal"
	elseif (Sorter.FilterType == 1) then
		filterType = "Iron"
	elseif (Sorter.FilterType == 2) then
		filterType = "Bronze"
	elseif (Sorter.FilterType == 3) then
		filterType = "Silver"
	elseif (Sorter.FilterType == 4) then
		filterType = "Gold"
	end

	local sendFilter = zrmine.f.Calculate_AmountCap(Sorter.StoredResource[filterType], Sorter.WorkAmount)

	// Do we have a module for the Filter load?
	local cm01 = Sorter:GetModuleChild01()
	if (IsValid(cm01) and sendFilter > 0) then
		Sorter.StoredResource[filterType] = Sorter.StoredResource[filterType] - sendFilter

		sendTable[filterType] = sendFilter

		zrmine.f.General_ReceiveResources(cm01,sendTable)
		zrmine.f.CreateInsertEffect(cm01, filterType)
	end


	local rtype = zrmine.f.Sorter_FindValidResource(Sorter)
	local sendother = 0

	if (rtype) then
		sendother = zrmine.f.Calculate_AmountCap(Sorter.StoredResource[rtype], Sorter.WorkAmount)
	end

	// Do we have a module for the other load?
	local cm02 = Sorter:GetModuleChild02()
	if (rtype and IsValid(cm02) and sendother > 0) then

		Sorter.StoredResource[rtype] = Sorter.StoredResource[rtype] - sendother

		sendTable[rtype] = sendother

		zrmine.f.General_ReceiveResources(cm02,sendTable)
		zrmine.f.CreateInsertEffect(cm02, rtype)
	end

	zrmine.f.General_UpdateNETResource(Sorter)
end

// Removes all stored Resources
function zrmine.f.Sorter_ClearResources(Sorter)

	zrmine.f.CreateNetEffect("crusher_addressource",Sorter)

	Sorter.StoredResource = Sorter.StoredResource or {}
	Sorter.StoredResource["Coal"] = 0
	Sorter.StoredResource["Iron"] = 0
	Sorter.StoredResource["Bronze"] = 0
	Sorter.StoredResource["Silver"] = 0
	Sorter.StoredResource["Gold"] = 0

	zrmine.f.General_UpdateNETResource(Sorter)
end

// This returns the id of a valid resource
function zrmine.f.Sorter_FindValidResource(Sorter)
	local validResource = nil

	local filterType
	if (Sorter.FilterType == 0) then
		filterType = "Coal"
	elseif (Sorter.FilterType == 1) then
		filterType = "Iron"
	elseif (Sorter.FilterType == 2) then
		filterType = "Bronze"
	elseif (Sorter.FilterType == 3) then
		filterType = "Silver"
	elseif (Sorter.FilterType == 4) then
		filterType = "Gold"
	end


	for k, v in pairs(Sorter.StoredResource) do
		local sendAmount = zrmine.f.Calculate_AmountCap(v, Sorter.WorkAmount)

		if (sendAmount > 0 and k ~= filterType) then
			validResource = k
			break
		end
	end

	return validResource
end


// Main Logic
function zrmine.f.Sorter_ModuleUpdate(Sorter)
	if Sorter:GetCurrentState() == 0 and zrmine.f.General_ReturnStorage(Sorter) > 0 then
		local cm01 = Sorter:GetModuleChild01()
		local cm02 = Sorter:GetModuleChild02()

		if IsValid(cm01) and IsValid(cm02) and zrmine.f.General_ReturnStorage(cm01) < cm01.HoldAmount and zrmine.f.General_ReturnStorage(cm02) < cm02.HoldAmount then
			zrmine.f.Sorter_Transport(Sorter)
		end
	end
end

function zrmine.f.Sorter_Transport(Sorter)

	// Sets the current state to busy
	Sorter:SetCurrentState(1)

	// Plays the wheel animation
	local wheel_animtime = (1 / Sorter.SorterSpeed) * 2
	zrmine.f.CreateAnimTable(Sorter, "wheel", wheel_animtime)

	// Sends the gravel to the connected module
	timer.Simple(Sorter.SorterSpeed, function()
		if (IsValid(Sorter)) then

			// Here we send the resources
			zrmine.f.Sorter_SendResources(Sorter)

			timer.Simple(0.1, function()
				if (IsValid(Sorter)) then
					zrmine.f.CreateAnimTable(Sorter, "idle", 1)
					Sorter:SetCurrentState(0)
				end
			end)
		end
	end)
end






// Damage Stuff
function zrmine.f.Sorter_OnTakeDamage(Sorter,dmg)
	Sorter:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["Sorter"].EntityHealth

	if (entHealth > 0) then
		Sorter.CurrentHealth = (Sorter.CurrentHealth or entHealth) - damage

		if (Sorter.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Sorter:GetPos())
			Sorter:Remove()
		end
	end
end
