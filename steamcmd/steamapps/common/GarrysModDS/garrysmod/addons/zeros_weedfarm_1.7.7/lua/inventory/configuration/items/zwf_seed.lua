local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_weedfarm/zwf_weedseed.mdl")
ITEM:SetDescription(function(self, tbl)
	local data = tbl.data
	local Perf_Time = data.Perf_Time
	local Perf_Amount = data.Perf_Amount
	local Perf_THC = data.Perf_THC
	local seedData = zwf.config.Plants[data.SeedID]

	Perf_Time = 100 - (Perf_Time - 100)
	Perf_Time = Perf_Time * 0.01
	Perf_Time = seedData.Grow.Duration * Perf_Time
	Perf_Time = math.Round(Perf_Time) .. "s"

	Perf_Amount = Perf_Amount * 0.01
	Perf_Amount = seedData.Grow.MaxYieldAmount * Perf_Amount
	Perf_Amount = math.Round(Perf_Amount) .. zwf.config.UoW

	Perf_THC = Perf_THC * 0.01
	Perf_THC = seedData.thc_level * Perf_THC
	Perf_THC = math.Round(Perf_THC) .. "%"

	return {
		zwf.language.VGUI["Duration"] .. ": " .. tostring(Perf_Time),
		zwf.language.VGUI["HarvestAmount"] .. ": " .. tostring(Perf_Amount),
		zwf.language.General["THC"] .. ": " .. tostring(Perf_THC)
	}
end)

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	ent:SetSeedID(data.SeedID)
	ent:SetSeedName(data.SeedName)
	ent:SetPerf_Time(data.Perf_Time)
	ent:SetPerf_Amount(data.Perf_Amount)
	ent:SetPerf_THC(data.Perf_THC)
	ent:SetSeedCount(data.SeedCount)
	ent:SetSkin(zwf.config.Plants[data.SeedID].skin)

	zwf.f.SetOwnerByID(ent, data.ZWFOwner)
end)

function ITEM:GetData(ent)
	return {
		SeedID = ent:GetSeedID(),
		SeedName = ent:GetSeedName(),
		SeedCount = ent:GetSeedCount(),
		Perf_Time = ent:GetPerf_Time(),
		Perf_Amount = ent:GetPerf_Amount(),
		Perf_THC = ent:GetPerf_THC(),
		ZWFOwner = zwf.f.GetOwnerID(ent)
	}
end

-- Only called in inventory
function ITEM:GetSkin(tbl)
	return zwf.config.Plants[tbl.data.SeedID].skin
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -30,
		Z = 25,
		Angles = Angle(0, -60, -90),
		Pos = Vector(0, 0, -1.5)
	}
end

function ITEM:GetVisualAmount(item)
	return item.data.SeedCount
end

-- Display name is only called in the HUD part for when you're looking at an item
-- This means item will always be an entity
function ITEM:GetDisplayName(item)
	return self:GetName(item) .. " seeds"
end

function ITEM:GetName(item)
	-- It's an entity if it's on ground, otherwise it's in the inventory.
	return isentity(item) and item:GetSeedName() or item.data.SeedName
end

ITEM:Register("zwf_seed")
