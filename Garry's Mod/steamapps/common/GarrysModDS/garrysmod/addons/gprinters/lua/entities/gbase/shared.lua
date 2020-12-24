ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "gPrinter Base"
ENT.Author = "Zoey"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "owning_ent" )

	self:NetworkVar( "Int", 0, "moreprint" )
	self:NetworkVar( "Int", 1, "silencer" )
	self:NetworkVar( "Int", 2, "antenna" )
	self:NetworkVar( "Int", 3, "scanner" )
	self:NetworkVar( "Int", 4, "armour" )
	self:NetworkVar( "Int", 5, "pipes" )
	self:NetworkVar( "Int", 6, "fan" )
	self:NetworkVar( "Int", 7, "storedmoney" )

	self:NetworkVar( "Int", 8, "armor" )
	self:NetworkVar( "Int", 9, "health" )

	if SERVER then
		self:Sethealth( self.data.health)
		self:Setarmour( tonumber( gPrinters.plugins[ "General" ].armorUpgrade ) )
		self:Setstoredmoney( 0 )
		self:Setmoreprint( 0 )
		self:Setsilencer( 0 )
		self:Setantenna( 0 )
		self:Setscanner( 0 )
		self:Setarmour( 0 )
		self:Setpipes( 0 )
		self:Setfan( 0 )
	end
end