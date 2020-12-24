if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Initializes the Entity
function zrmine.f.Splitter_Initialize(Splitter)
	Splitter.StoredResource = {}
	Splitter.StoredResource["Coal"] = 0
	Splitter.StoredResource["Iron"] = 0
	Splitter.StoredResource["Bronze"] = 0
	Splitter.StoredResource["Silver"] = 0
	Splitter.StoredResource["Gold"] = 0

	zrmine.f.EntList_Add(Splitter)
end

/*
	StateInfo:
	0 = WAITING_FOR_ORDER
	1 = SPLITTING
*/


// Sends the specified ressource type to the connected module
function zrmine.f.Splitter_SendResources(Splitter,rtype)

	local sendTable = {}
	local sendAmount = zrmine.f.Calculate_AmountCap(Splitter.StoredResource[rtype], Splitter.WorkAmount)

	Splitter.StoredResource[rtype] = Splitter.StoredResource[rtype] - sendAmount

	local sendA = 0
	local sendB = 0

	if (sendAmount <= 1) then
		sendA = sendAmount
		sendB = 0
	else
		sendA = sendAmount / 2
		sendB = sendAmount / 2
	end

	local cm01 = Splitter:GetModuleChild01()
	local cm02 = Splitter:GetModuleChild02()


	if (IsValid(cm01) and sendA > 0) then
		sendTable[rtype] = sendA
		zrmine.f.General_ReceiveResources(cm01,sendTable)
		zrmine.f.CreateInsertEffect(cm01, rtype)
	end

	if (IsValid(cm02) and sendB > 0) then

		sendTable = {}

		sendTable[rtype] = sendB

		zrmine.f.General_ReceiveResources(cm02,sendTable)
		zrmine.f.CreateInsertEffect(cm02, rtype)
	end

	zrmine.f.General_UpdateNETResource(Splitter)
end

// This returns the id of a valid resource we can splitt and send to the connected module
function zrmine.f.Splitter_FindValidResource(Splitter)
	local validResource = nil

	for k, v in pairs(Splitter.StoredResource) do
		local sendAmount = zrmine.f.Calculate_AmountCap(v, Splitter.WorkAmount)

		if (sendAmount > 0) then
			validResource = k
			break
		end
	end

	return validResource
end



// Main Logic
function zrmine.f.Splitter_ModuleUpdate(Splitter)
	if Splitter:GetCurrentState() == 0 and zrmine.f.General_ReturnStorage(Splitter) > 0 then
		local cm01 = Splitter:GetModuleChild01()
		local cm02 = Splitter:GetModuleChild02()

		if IsValid(cm01) and IsValid(cm02) and zrmine.f.General_ReturnStorage(cm01) < cm01.HoldAmount and zrmine.f.General_ReturnStorage(cm02) < cm02.HoldAmount then
			zrmine.f.Splitter_Transport(Splitter)
		end
	end
end

function zrmine.f.Splitter_Transport(Splitter)

	// Sets the current state to busy
	Splitter:SetCurrentState(1)

	// Here we find a valid resource do splitt
	local SendResource = zrmine.f.Splitter_FindValidResource(Splitter)

	// Plays the wheel animation
	local wheel_animtime = (1 / Splitter.SplitingSpeed) * 2
	zrmine.f.CreateAnimTable(Splitter, "wheel", wheel_animtime)

	// Sends the gravel to the connected module
	timer.Simple(Splitter.SplitingSpeed, function()

		if IsValid(Splitter) then

			// Here we send the resources or show the discard gravel effect for module01
			zrmine.f.Splitter_SendResources(Splitter,SendResource)

			timer.Simple(0.1, function()

				if (IsValid(Splitter)) then

					zrmine.f.CreateAnimTable(Splitter, "idle", 1)
					Splitter:SetCurrentState(0)
				end
			end)
		end
	end)
end


// Damage Stuff
function zrmine.f.Splitter_OnTakeDamage(Splitter,dmg)
	Splitter:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zrmine.config.Damageable["Splitter"].EntityHealth

	if (entHealth > 0) then
		Splitter.CurrentHealth = (Splitter.CurrentHealth or entHealth) - damage

		if (Splitter.CurrentHealth <= 0) then
			zrmine.f.GenericEffect("Explosion",Splitter:GetPos())
			Splitter:Remove()
		end
	end
end
