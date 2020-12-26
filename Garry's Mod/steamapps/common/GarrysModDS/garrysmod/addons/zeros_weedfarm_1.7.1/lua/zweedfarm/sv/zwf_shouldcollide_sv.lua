if not SERVER then return end
zwf = zwf or {}
zwf.hooks = zwf.hooks or {}

// This disables the collision betweent he smaller entities
local zwf_Ents = {"zwf_weedstick"}
hook.Add("ShouldCollide", "a_zwf.hooks.ShouldCollide", function(ent1, ent2)
	if (IsValid(ent1) and IsValid(ent2) and table.HasValue(zwf_Ents,ent1:GetClass()) and table.HasValue(zwf_Ents,ent2:GetClass())) then return false end
end)
