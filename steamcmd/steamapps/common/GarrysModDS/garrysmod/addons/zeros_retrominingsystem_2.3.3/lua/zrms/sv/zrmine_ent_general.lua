if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Returns the current ressource storage of the general zrms entity
function zrmine.f.General_ReturnStorage(ent)
	local StoredAmount = 0

	for k, v in pairs(ent.StoredResource) do
		if (v > 0) then
			StoredAmount = StoredAmount + v
		end
	end

	return StoredAmount
end

// Here we receive resources from our Parent
function zrmine.f.General_ReceiveResources(ent,rTable)

	zrmine.f.CreateNetEffect("crusher_addressource",ent)

	for k, v in pairs(rTable) do
		ent.StoredResource[k] = math.Clamp(ent.StoredResource[k] + v,0,9999999999)
	end

	zrmine.f.General_UpdateNETResource(ent)
end

// Updates the NW Vars
function zrmine.f.General_UpdateNETResource(ent)
	ent:SetCoal(ent.StoredResource["Coal"] or 0)
	ent:SetIron(ent.StoredResource["Iron"] or 0)
	ent:SetBronze(ent.StoredResource["Bronze"] or 0)
	ent:SetSilver(ent.StoredResource["Silver"] or 0)
	ent:SetGold(ent.StoredResource["Gold"] or 0)
end

// Clear the Ressource Vars
function zrmine.f.General_ClearResource(ent)
	zrmine.f.CreateNetEffect("crusher_addressource",ent)

	ent:SetCoal(0)
	ent:SetIron(0)
	ent:SetBronze(0)
	ent:SetSilver(0)
	ent:SetGold(0)
end
