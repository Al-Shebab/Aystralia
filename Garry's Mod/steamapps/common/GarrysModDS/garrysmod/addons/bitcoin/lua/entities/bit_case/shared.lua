ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Desktop Case"
ENT.Author = "Mikael"
ENT.Category = "bitmine"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Point" )
	self:NetworkVar( "Int", 1, "PowerSupply" )
	self:NetworkVar( "Int", 2, "ReqPowerSupply" )
	self:NetworkVar( "Int", 3, "Graphiccard" )	
	self:NetworkVar( "Int", 4, "Harddisk" )		
	self:NetworkVar( "Int", 5, "Ram" )		
	self:NetworkVar( "Int", 6, "BitCoin" )	
	self:NetworkVar( "Int", 7, "GBused" )
	self:NetworkVar( "Int", 8, "Load" )	
	self:NetworkVar( "Bool", 0, "Motherboard" )	
	self:NetworkVar( "Bool", 1, "CPU" )	
	self:NetworkVar( "Bool", 2, "Cornet" )	
	self:NetworkVar( "Bool", 3, "Window" )	
end
