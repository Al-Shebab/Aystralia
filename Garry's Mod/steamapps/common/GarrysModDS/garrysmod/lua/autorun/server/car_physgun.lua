local DenyGroups = 
{ 
	"user",
	"trusted",
	"sydney",
	"melbourne",
	"brisbane",
	"perth",
	"trial-moderator",
	"donator-trial-moderator",
	"senior-admin",
	"admin",
	"donator-admin",
	"senior-moderator",
	"donator-senior-moderator",
	"moderator",
	"donator-moderator",
}

-- ALLOWED GROUPS GO HERE
local AllowGroups = {
	"superadmin",
	"staff-manager",
}

local function VehPickup(ply, ent)
	if table.HasValue( DenyGroups, ply:GetNWString("usergroup") ) and (ent:GetClass():lower() == "prop_vehicle_jeep") then
		return false
	elseif table.HasValue( AllowGroups, ply:GetNWString("usergroup") ) then
		return true
	end
end
 
hook.Add("PhysgunPickup", "Physgun.VehPickup", VehPickup)