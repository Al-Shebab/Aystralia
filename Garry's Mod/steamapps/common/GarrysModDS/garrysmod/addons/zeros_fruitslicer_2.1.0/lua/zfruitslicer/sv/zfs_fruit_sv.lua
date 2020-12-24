if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}


//////////////////////////////////////////////////////////////
/////////////////////// Initialize ///////////////////////////
//////////////////////////////////////////////////////////////

// Called when the Fruit Initializes
function zfs.f.Fruit_Initialize(Fruit)
	zfs.f.EntList_Add(Fruit)
	// State Stuff
	Fruit.currentState = "UNPEELED"

	Fruit.fStates = {
		["PEELED"] = function()
			zfs.f.Fruit_state_PEELED(Fruit)
		end,
		["SLICED"] = function()
			zfs.f.Fruit_state_SLICED(Fruit)
		end
	}

	Fruit.fHealth = Fruit.PrepareAmount
	Fruit.WorkStation = nil
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


function zfs.f.Fruit_Interact(ply,Fruit)
	if (IsValid(ply) and ply:IsPlayer() and ply:Alive() and zfs.f.IsOwner(ply, Fruit) and zfs.f.IsOwner(ply, Fruit.WorkStation)) then
		zfs.f.Fruit_PrepareFruit(Fruit)
	end
end








function zfs.f.Fruit_PrepareFruit(Fruit)
	if Fruit.fHealth > 0 then
		Fruit.fHealth = Fruit.fHealth - 1
		zfs.f.Fruit_UpdateVisuals(Fruit)
		zfs.f.Fruit_CheckState(Fruit)
		Fruit:Interact_VFX_SFX()
	else
		zfs.f.Shop_action_FillMixer(Fruit.WorkStation,Fruit)
		Fruit:Finish_VFX_SFX()
	end
end


// States
function zfs.f.Fruit_CheckState(Fruit)
	if Fruit.fHealth <= 0 then

		zfs.f.Fruit_ChangeState(Fruit,"SLICED")
	elseif Fruit.fHealth <= Fruit.PrepareAmount * 0.7 then

		zfs.f.Fruit_ChangeState(Fruit,"PEELED")
	end
end

function zfs.f.Fruit_ChangeState(Fruit,state)
	if Fruit.currentState == state then return end
	Fruit.fStates[state]()
	Fruit.currentState = state
end

function zfs.f.Fruit_state_PEELED(Fruit)

	Fruit:SetSkin(Fruit:SkinCount() - 1)
end

function zfs.f.Fruit_state_SLICED(Fruit)
	Fruit:SetBodygroup(0, Fruit:GetBodygroupCount(0))
end

//Actions
function zfs.f.Fruit_action_PEEL(Fruit)
	local SkinStep = (Fruit.PrepareAmount * 0.3) / (Fruit:SkinCount() - 1)
	local nextStep = math.Round(Fruit.PrepareAmount - (SkinStep * (Fruit:GetSkin() + 1)))

	if Fruit.fHealth == nextStep then
		Fruit:SetSkin(Fruit:GetSkin() + 1)
	end
end

function zfs.f.Fruit_action_SLICE(Fruit)
	local BodygroupStep = (Fruit.PrepareAmount * 0.7) / (Fruit:GetBodygroupCount(0) - 2)
	local nextStep = Fruit.PrepareAmount - (BodygroupStep * (Fruit:GetBodygroup(0) + 1))
	nextStep = math.Round(nextStep)
	nextStep = math.Clamp(nextStep, 0, 100)

	if Fruit.fHealth <= nextStep then
		Fruit:SetBodygroup(0, Fruit:GetBodygroup(0) + 1)
	end

	// Here we can change the Color when we reached a certain Bodygroup
	if (Fruit.LastBodygroup_Color and Fruit:GetBodygroup(0) >= Fruit.ChangeColorAtBodygroup) then
		Fruit:SetColor(zfs.default_colors["white01"])
	end
end

function zfs.f.Fruit_UpdateVisuals(Fruit)

	if (Fruit.fHealth < Fruit.PrepareAmount * 0.7) then
		zfs.f.Fruit_action_SLICE(Fruit)
	elseif (Fruit.fHealth > Fruit.PrepareAmount * 0.7) then
		zfs.f.Fruit_action_PEEL(Fruit)
	end
end
