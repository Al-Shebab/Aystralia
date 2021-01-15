ITEM.Name = "Machinecrate"
ITEM.Description = "Holds machines for Oil drilling."
ITEM.Model = "models/zerochain/props_oilrush/zor_machinecrate.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:SaveData(ent)
	self:SetData("MachineID", ent:GetMachineID())
	self:SetData("ZRushOwner", zrush.f.GetOwnerID(ent))
	self:SetData("Content", ent.InstalledModules)
end

function ITEM:LoadData(ent)
	ent:SetMachineID(self:GetData("MachineID"))

	if SERVER then
		local tbl = self:GetData("Content")

		zrush.f.Machinecrate_AddModules(ent,tbl)
		zrush.f.SetOwnerID(ent, self:GetData("ZRushOwner"))
	end
end
