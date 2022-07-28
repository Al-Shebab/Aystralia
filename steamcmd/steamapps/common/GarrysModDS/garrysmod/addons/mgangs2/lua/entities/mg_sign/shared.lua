ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Category       		= "MGangs 2"
ENT.PrintName		   	= "MGangs 2 - Gang Sign"
ENT.Author			   	= "Zephruz & ZeroChain"
ENT.Contact			   	= "https://zephruz.net/"
ENT.Purpose			   	= "Sign for Gangs"
ENT.Instructions	 	= "Used to display a gangs information/stats."
ENT.Spawnable		    =  true
ENT.AdminSpawnable		=  false
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:SetupDataTables()
	-- Ints
	self:NetworkVar("Int", 0, "GangID")
end

function ENT:SetGangMaterial(mat)
	self.gIconMat = mat
end

function ENT:GetGangMaterial()
	local icon = self.gIconMat

	if (!icon || icon:IsError()) then
		local gang = self:GetGang()

		if (gang) then
			self:SetGangMaterial(Material("!" .. mg2.gang:GetIconMatName(gang:GetID())))
		else
			return
		end 
	end

	return icon
end

function ENT:SetGang(id)
	self:SetGangID(id)
end

function ENT:GetGang()
	local gangID = self:GetGangID()
	local gang = (mg2 && mg2.gang:Get(gangID))

	if !(gang) then return end

	return gang
end